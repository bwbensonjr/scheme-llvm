;;; core.ss -- the pure compiler core: source forms (or text) -> LLVM IR text.
;;;
;;; This is the self-hosting target: text in -> IR text out.  It performs NO
;;; file, subprocess, or external-port I/O.  Everything effectful -- reading the
;;; source file, reading the prelude, supplying the host target-triple header,
;;; writing the .ll, and invoking the C toolchain / JIT -- lives in the driver
;;; (compile.ss).  Keeping that surface out of the core means self-hosting never
;;; has to bring the filesystem or subprocess API into the language.
;;;
;;; The one in-memory reader helper (`read-forms-from-string`) uses a string
;;; port, which touches nothing outside the process; it is pure in effect.

(include "src/parse.ss")
(include "src/passes/expand.ss")
(include "src/passes/recognize-let.ss")
(include "src/passes/convert-assignments.ss")
(include "src/passes/convert-closures.ss")
(include "src/passes/lower.ss")
(include "src/emit.ss")

;; --- reader (works on any input port; no file access of its own) ---------
(define (read-forms port)   ; -> ordered list of all top-level forms in PORT
  (let loop ([forms '()])
    (let ([e (read port)])
      (if (eof-object? e)
          (reverse forms)
          (loop (cons e forms))))))

(define (read-forms-from-string str)   ; in-memory; no file/subprocess I/O
  (read-forms (open-input-string str)))

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
           [d     (lower-program c)])
      (dump "collect-toplevel" top) (dump "expand" expd)
      (dump "parse+rename" core) (dump "recognize-let" a)
      (dump "convert-assignments" b) (dump "convert-closures" c) (dump "lower" d)
      (emit-program d))))

;; convenience: source text -> IR text (no prelude, no header).  This is the
;; core's self-hosting-facing contract; the driver adds prelude/header/toolchain.
(define (compile-source-string str)
  (compile-forms (read-forms-from-string str) no-dump))

;; shared back half of the pipeline for one core-IL expression.  The REPL feeds
;; forms through this incrementally (against a persistent env); batch compilation
;; runs the same passes over a whole program in `compile-forms`.
(define (repl-lcode il)
  (lower-program (convert-closures (convert-assignments (recognize-let il)))))
