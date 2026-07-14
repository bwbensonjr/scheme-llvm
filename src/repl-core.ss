;;; repl-core.ss -- the interactive REPL orchestration, in the compiled core.
;;;
;;; Change: repl-embedded-incremental.  This is the incremental, stateful half of
;;; the compiler that used to live in the Chez driver (`run-repl`, compile.ss).
;;; Ported here it compiles under scheme-llvm itself, so the interactive `--repl`
;;; runs its compilation in-process (no Chez, no per-form subprocess) -- the same
;;; embedding Path A that `scheme-run` uses for batch.
;;;
;;; It is assembled ONLY into the REPL embedded compiler (tools/assemble-core.ss
;;; --repl-entry), after the pure core (parse/expand/passes/emit/core.ss) whose
;;; functions it drives: make-repl-env, expand, normalize-define, define-form?,
;;; define-syntax-form?, define-name, parse-define-syntax, repl-lower-form(*),
;;; repl-register-define!, repl-lcode, emit-repl-module, emit-repl-batch, union*,
;;; *core-keywords*/*prims*/*extra-op-keywords*, and read-all-from-string.
;;;
;;; SESSION STATE lives as top-level mutable globals: being A-linked in one host
;;; process, they persist across the host's repeated `scheme_entry` calls -- which
;;; is exactly the incremental-compilation state `run-repl` threaded by hand.
;;; The form/gensym counter (*repl-n*) is initialized once by init-session and
;;; only ever incremented, never reset per form (run-repl's @__repl_N discipline).

(define *repl-env* (make-repl-env))          ; #(name->mangled-sym alist, generation)
(define *repl-macro-env* (quote ()))         ; ((name . transformer) ...)
(define *repl-known* (quote ()))             ; hygiene "known bindings" set
(define *repl-n* 0)                          ; per-form thunk counter (@__repl_N)

;; register a define-syntax in the session (mirrors run-repl's note-syntax!)
(define (repl-note-syntax! form)
  (set! *repl-macro-env* (cons (parse-define-syntax form) *repl-macro-env*))
  (set! *repl-known* (cons (cadr form) *repl-known*)))

;; expand a define's INIT (not its raw signature -- expanding the raw form would
;; treat a dotted param list like `(f . xs)` as an application), then rebuild a
;; simple (define name expanded-init); expand any other form whole.  (run-repl's
;; expand-form.)
(define (repl-expand-form form)
  (if (define-form? form)
      (let ([nd (normalize-define form)])
        (list (quote define) (car nd) (expand (cadr nd) *repl-macro-env* *repl-known*)))
      (expand form *repl-macro-env* *repl-known*)))

;; --- error rendering (for the host to report a compile error on stderr) -----
;; A raised object is normally an R7RS error object ("who: message" + irritants);
;; render it to a plain string.  This text is diagnostic only (the harnesses read
;; it off stderr and discard it), so a best-effort irritant rendering is fine.
(define (repl-irritant->string x)
  (cond
    [(symbol? x) (symbol->string x)]
    [(string? x) x]
    [else "?"]))
(define (repl-irritants->string xs)
  (if (null? xs)
      ""
      (string-append " "
        (string-append (repl-irritant->string (car xs))
                       (repl-irritants->string (cdr xs))))))
(define (repl-error->string e)
  (if (error-object? e)
      (string-append (error-object-message e)
                     (repl-irritants->string (error-object-irritants e)))
      "error"))

;; --- compile one entered form (run-repl's `feed`, minus the host framing) ---
;; Snapshot all session state, compile the form under an in-language `guard`, and
;; on a raised error restore the snapshot so a bad form never corrupts the session
;; (design D3).  Returns a (status . payload) pair the host destructures:
;;   (ok     . (ir-text . entry-name))   host JITs + looks up entry-name
;;   (error  . message-string)           host reports on stderr; session continues
;;   (syntax . registered-name)          a define-syntax was registered
(define (compile-one-form form)
  (let ([s0 (vector-ref *repl-env* 0)]
        [s1 (vector-ref *repl-env* 1)]
        [sme *repl-macro-env*]
        [sk *repl-known*]
        [sn *repl-n*])
    (guard (e (#t (vector-set! *repl-env* 0 s0)
                  (vector-set! *repl-env* 1 s1)
                  (set! *repl-macro-env* sme)
                  (set! *repl-known* sk)
                  (set! *repl-n* sn)
                  (cons (quote error) (repl-error->string e))))
      (cond
        [(define-syntax-form? form)
         (repl-note-syntax! form)
         (cons (quote syntax) (symbol->string (cadr form)))]
        [else
         (let ([dn (define-name form)])
           (when dn (set! *repl-known* (cons dn *repl-known*)))
           (let ([lc (repl-lcode (repl-lower-form *repl-env* (repl-expand-form form)))])
             (let ([m (emit-repl-module lc (+ *repl-n* 1))])
               (set! *repl-n* (+ *repl-n* 1))
               (cons (quote ok) (cons (car m) (cadr m))))))]))))

;; text -> (status . payload).  Read exactly one form from the host-supplied text
;; (the host already sliced it to one complete form via form-complete?), then
;; compile it.  Wrapped in the same guard so a reader error also degrades to an
;; error status rather than aborting the session.
(define (compile-one-form-text text)
  (guard (e (#t (cons (quote error) (repl-error->string e))))
    (let ([forms (read-all-from-string text)])
      (if (null? forms)
          (cons (quote error) "empty form")
          (compile-one-form (car forms))))))

;; --- prelude as one startup batch (run-repl's load-prelude!) ----------------
;; Load the standard library as ONE mutually-recursive group: collect its macros,
;; pre-register every define name (so forward/mutual references resolve), lower
;; each body reusing those symbols, and emit a single combined module whose
;; globals later interactive forms resolve against.  The interactive thunk counter
;; starts ABOVE the batch's @__repl_1..N range so names never collide in the JIT.
;; Returns the batch IR text (its entry is @scheme_entry -- the host looks it up
;; and calls it once to initialize the prelude's global slots).
(define (repl-load-prelude! forms)
  (for-each
    (lambda (f)
      (cond [(define-syntax-form? f) (repl-note-syntax! f)]
            [(define-form? f)
             (set! *repl-known* (cons (define-name f) *repl-known*))
             (repl-register-define! *repl-env* f)]
            [else (if #f #f)]))
    forms)
  (let ([progs (fold-left
                 (lambda (acc f)
                   (if (define-form? f)
                       (cons (repl-lcode (repl-lower-form* *repl-env* (repl-expand-form f) #f)) acc)
                       acc))
                 (quote ()) forms)])
    (set! *repl-n* (length progs))
    ;; A DISTINCT entry name (not scheme_entry): the host links the compiler's own
    ;; @scheme_entry, so the prelude batch's entry must be uniquely named for the
    ;; host's JIT->lookup to find THIS module.  Kept in sync with host.cpp.
    (emit-repl-batch-named (reverse progs) "__repl_prelude")))

;; Initialize a fresh session and return the prelude batch IR (or "" when
;; PRELUDE-SRC is empty, i.e. --no-prelude).  Seeds the base known-names set
;; exactly as run-repl did.  Called once by the host at startup.
(define (init-session prelude-src)
  (reset-counter!)                             ; monotonic gensym for @code_N labels
  (set! *repl-env* (make-repl-env))
  (set! *repl-macro-env* (quote ()))
  (set! *repl-known* (union* (list *core-keywords* *prims* *extra-op-keywords*)))
  (set! *repl-n* 0)
  (let ([forms (read-all-from-string prelude-src)])
    (if (null? forms)
        ""
        (repl-load-prelude! forms))))

;; --- the input-completeness probe (design D4(b); spike/form-complete) --------
;; Does the host's accumulated buffer start with a complete datum yet?  An
;; EOF-aware scanner mirroring the reader's structure -- it reuses the reader's
;; own lexeme helpers (rd-ws?/rd-delim?/rd-skip-ws/rd-token-end) so the two can't
;; drift.  The internal fc-* helpers return a byte index just past the datum, or a
;; negative sentinel (fc-incomplete/fc-malformed); form-complete-code exposes that
;; integer to the host directly (see its doc).
(define fc-incomplete -1)
(define fc-malformed -2)
(define (fc-bad? r) (< r 0))

(define (fc-string s n i)                     ; scan "..." past the opening quote
  (if (< i n)
      (let ([k (char->integer (string-ref s i))])
        (cond
          [(= k 34) (+ i 1)]                                  ; closing "
          [(= k 92) (if (< (+ i 1) n) (fc-string s n (+ i 2)) fc-incomplete)]
          [else (fc-string s n (+ i 1))]))
      fc-incomplete))

(define (fc-char s n i)                        ; scan #\<char|name>; force 1 char in
  (if (< i n) (rd-token-end s n (+ i 1)) fc-incomplete))

(define (fc-hash s n i)                         ; scan after '#'
  (if (< i n)
      (let ([k (char->integer (string-ref s i))])
        (cond
          [(= k 40) (fc-list s n (+ i 1))]                    ; #( vector
          [(= k 92) (fc-char s n (+ i 1))]                    ; #\ char literal
          [else (rd-token-end s n i)]))                       ; #t #f #xNN ...
      fc-incomplete))

(define (fc-prefix s n i)                       ; scan after ' or ` : a datum follows
  (let ([j (rd-skip-ws s n i)])
    (if (< j n) (fc-datum s n j) fc-incomplete)))

(define (fc-unquote s n i)                       ; scan after , or ,@ : a datum follows
  (let ([i2 (if (and (< i n) (= (char->integer (string-ref s i)) 64)) (+ i 1) i)])
    (let ([j (rd-skip-ws s n i2)])
      (if (< j n) (fc-datum s n j) fc-incomplete))))

(define (fc-list s n i)                          ; scan (...) past the open paren
  (let ([j (rd-skip-ws s n i)])
    (if (< j n)
        (let ([k (char->integer (string-ref s j))])
          (cond
            [(or (= k 41) (= k 93)) (+ j 1)]                  ; ) or ] closes
            [else (let ([r (fc-datum s n j)])
                    (if (fc-bad? r) r (fc-list s n r)))]))
        fc-incomplete)))

(define (fc-datum s n i)                         ; scan one datum at i (i < n, past ws)
  (let ([k (char->integer (string-ref s i))])
    (cond
      [(or (= k 40) (= k 91)) (fc-list s n (+ i 1))]          ; ( or [
      [(or (= k 41) (= k 93)) fc-malformed]                   ; unbalanced ) or ]
      [(= k 34) (fc-string s n (+ i 1))]                      ; "
      [(or (= k 39) (= k 96)) (fc-prefix s n (+ i 1))]        ; ' or `
      [(= k 44) (fc-unquote s n (+ i 1))]                     ; ,
      [(= k 35) (fc-hash s n (+ i 1))]                        ; #
      [else (rd-token-end s n i)])))                          ; atom -> to delimiter

;; Host-facing result is a plain integer the host decodes via rt_fixnum_value:
;;   >= 0  complete -- that many leading bytes are the first datum
;;   -1    incomplete (need more input)   -2  malformed
;; (an integer, not the spike's (complete . n)|symbol shape, so the C++ host
;; branches on one fixnum's sign with no pair/symbol destructuring.)
(define (form-complete-code s)
  (let ([n (string-length s)])
    (let ([i (rd-skip-ws s n 0)])
      (if (< i n) (fc-datum s n i) fc-incomplete))))

;; --- cross-call state persistence -------------------------------------------
;; The assembled program is one @scheme_entry, so *repl-env* etc. are locals
;; re-created on every host call.  Bundle them into a vector held in the runtime
;; (repl-state-ref / repl-state-set!), restoring into the working globals at entry
;; and saving them back before returning, so the session persists across calls.
;; `counter` (util.ss's gensym counter) MUST persist too: @code_N labels are
;; module-global, so the counter has to stay monotonic across forms or two forms'
;; code labels collide in the JIT.  (repl-state-ref) is #f before the first save.
(define (repl-restore-state!)
  (let ([s (repl-state-ref)])
    (when (vector? s)
      (set! *repl-env* (vector-ref s 0))
      (set! *repl-macro-env* (vector-ref s 1))
      (set! *repl-known* (vector-ref s 2))
      (set! *repl-n* (vector-ref s 3))
      (set! counter (vector-ref s 4)))))
(define (repl-save-state!)
  (repl-state-set! (vector *repl-env* *repl-macro-env* *repl-known* *repl-n* counter)))

;; --- the dispatched embedded entry (design D2) -------------------------------
;; The host sets (repl-mode)/(repl-input) via rt_repl_set, then calls this ccc
;; `scheme_entry` (the assembled program's trailing expression).  One entry, four
;; operations, so the existing single-scheme_entry emission is reused unchanged:
;;   0 init-session no prelude   1 init-session with the baked-in *prelude-source*
;;   2 form-complete?            3 compile-one-form
;; State is restored before and saved after each op (init modes seed it fresh).
(define (repl-dispatch)
  (repl-restore-state!)
  (let ([mode (repl-mode)])
    (let ([result
           (cond
             [(= mode 0) (init-session "")]
             [(= mode 1) (init-session *prelude-source*)]
             [(= mode 2) (form-complete-code (repl-input))]
             [else       (compile-one-form-text (repl-input))])])
      (repl-save-state!)
      result)))
