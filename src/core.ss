;;; core.ss -- the pure compiler core: source forms (or text) -> LLVM IR text.
;;;
;;; This is the self-hosting target: text in -> IR text out.  It performs NO
;;; file, subprocess, or external-port I/O.  Everything effectful -- reading the
;;; source file, reading the prelude, supplying the host target-triple header,
;;; writing the .ll, and invoking the C toolchain / JIT -- lives in the driver
;;; (compile.ss).  Keeping that surface out of the core means self-hosting never
;;; has to bring the filesystem or subprocess API into the language.
;;;
;;; FLAT SOURCE (change: self-hosting-completion): this file is concatenation-
;;; ready.  The passes are NOT `(include ...)`d here -- they are separate flat
;;; files concatenated ahead of this one by the ordered-`cat` assembly (see the
;;; Makefile `regen` recipe / `src/README.md`).  The reader is the in-language
;;; `read-all-from-string` (defined in the prelude), so the core needs no ports.
;;; The Chez-hosted driver/tests include the same flat files (no separate library
;;; tree), so there is one live source.

;; --- reader (self-hostable; no ports) ------------------------------------
;; `read-all-from-string` is provided by the prelude (which is prepended to every
;; program the compiler compiles, including the compiler's own source).
(define (read-forms-from-string str) (read-all-from-string str))

;; --- prelude assembly (pure list ops over already-read forms) ------------

;; name defined by a top-level (define ...) form, or #f for a non-define form
(define (define-name f)
  (and (pair? f) (eq? (car f) 'define)
       (let ([sig (cadr f)]) (if (pair? sig) (car sig) sig))))

;; prepend prelude forms to the user's, dropping any prelude define whose name
;; the user also defines (user-wins shadowing, so the prelude never clobbers).
(define (with-prelude prelude-forms user-forms)
  (let ([user-names (filter (lambda (x) x) (map define-name user-forms))])
    (append
      (filter (lambda (f)
                (let ([n (define-name f)])
                  (not (and n (memq n user-names)))))
              prelude-forms)
      user-forms)))

;; names bound at the top level (prelude + program), used both as the hygiene
;; "known bindings" set and, with the fixed keyword/primitive sets, to decide
;; which template identifiers a macro is allowed to introduce.
(define (compute-known macro-env runtime-forms)
  (union* (list *core-keywords* *prims* *extra-op-keywords*
                (map car macro-env)
                (filter (lambda (x) x) (map define-name runtime-forms)))))

;; --- the pipeline: forms -> IR text (no target header) -------------------
;; `dump` is an injected side-channel: the driver passes an effectful stderr
;; dumper under --dump; every other caller passes `no-dump` so the core stays
;; pure.  The core never touches a port itself.
(define (no-dump stage form) (if #f #f))

(define (compile-forms forms dump)
  (reset-counter!)
  (let* ([me+rf (collect-define-syntax forms)]
         [macro-env (car me+rf)] [runtime-forms (cadr me+rf)])
    (let* ([known (compute-known macro-env runtime-forms)]
           [top   (collect-toplevel runtime-forms)]
           [expd  (expand top macro-env known)]
           [core  (rename-program (parse-program expd))]
           [a     (recognize-let core)]
           [b     (convert-assignments a)]
           [c     (convert-closures b)]
           [d     (lower-program c program-unit)])
      (dump "collect-toplevel" top) (dump "expand" expd)
      (dump "parse+rename" core) (dump "recognize-let" a)
      (dump "convert-assignments" b) (dump "convert-closures" c) (dump "lower" d)
      (emit-program d))))

;; convenience: source text -> IR text (no prelude, no header).  This is the
;; core's self-hosting-facing contract; the driver adds prelude/header/toolchain.
(define (compile-source-string str)
  (compile-forms (read-forms-from-string str) no-dump))

;; source text + prelude text -> IR text (no header).  The prelude-aware sibling
;; of compile-source-string: it applies the same user-wins shadowing the batch
;; driver does (with-prelude), but takes the prelude as *text* rather than
;; reading a file, so it stays free of filesystem/subprocess I/O.  Used by the
;; embedded compiler (change: path-a-embedding), whose entry bakes the prelude
;; source in as a string constant and passes the user program on stdin.
(define (compile-source-with-prelude prelude-str user-str)
  (compile-forms
    (with-prelude (read-forms-from-string prelude-str)
                  (read-forms-from-string user-str))
    no-dump))

;; shared back half of the pipeline for one core-IL expression.  The REPL feeds
;; forms through this incrementally (against a persistent env); batch compilation
;; runs the same passes over a whole program in `compile-forms`.
(define (repl-lcode il)
  (lower-program (convert-closures (convert-assignments (recognize-let il))) program-unit))
