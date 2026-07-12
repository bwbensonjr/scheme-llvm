;;; repl-frontend.ss -- unit tests for the REPL persistent-globals front end.
;;; Run from the repo root:  chez --libdirs src --script test/repl-frontend.ss
;;;
;;; Exercises the front-end model (parse.ss REPL section + the pass threading)
;;; at the IL level: a form sees earlier definitions, redefinition wins for
;;; later forms, forward references are rejected, lambda defines self-recurse,
;;; and value defines see the previous binding.  Execution-level behavior is
;;; covered separately by the end-to-end backend tests.

(import (chezscheme) (match) (util))

(include "src/parse.ss")
(include "src/passes/recognize-let.ss")
(include "src/passes/convert-assignments.ss")
(include "src/passes/convert-closures.ss")
(include "src/passes/lower.ss")

(define pass 0)
(define fail 0)
(define (check name got want)
  (if (equal? got want)
      (begin (set! pass (+ pass 1)) (printf "  [OK  ] ~a\n" name))
      (begin (set! fail (+ fail 1))
             (printf "  [FAIL] ~a\n         got:  ~s\n         want: ~s\n" name got want))))
(define (check-pred name got pred)
  (if (pred got)
      (begin (set! pass (+ pass 1)) (printf "  [OK  ] ~a\n" name))
      (begin (set! fail (+ fail 1))
             (printf "  [FAIL] ~a\n         got:  ~s\n" name got))))
(define (check-raises name thunk)
  (let ([raised (guard (e (#t 'raised)) (thunk) 'no-error)])
    (check name raised 'raised)))

;; does symbol `s` appear anywhere in tree `t`?
(define (mentions? s t)
  (cond [(eq? s t) #t]
        [(pair? t) (or (mentions? s (car t)) (mentions? s (cdr t)))]
        [else #f]))

(printf "REPL front-end unit tests\n")

;; 1. A later form sees an earlier definition.
(let ([env (make-repl-env)])
  (reset-counter!)
  (check "define x binds x.g0"
         (repl-lower-form env '(define x 41))
         '(global-set! x.g0 (const 41)))
  (check "reference resolves to x.g0"
         (repl-lower-form env '(+ x 1))
         '(primcall + (global-ref x.g0) (const 1))))

;; 2. Redefinition: a later form uses the newest generation.
(let ([env (make-repl-env)])
  (reset-counter!)
  (repl-lower-form env '(define y 1))
  (repl-lower-form env '(define y 2))
  (check "y resolves to latest generation y.g1"
         (repl-env-lookup env 'y) 'y.g1)
  (check "sum uses the latest y.g1"
         (repl-lower-form env '(+ y y))
         '(primcall + (global-ref y.g1) (global-ref y.g1))))

;; 3. Forward reference is rejected.
(let ([env (make-repl-env)])
  (reset-counter!)
  (check-raises "undefined name errors"
                (lambda () (repl-lower-form env '(+ z 1)))))

;; 4. A lambda definition registers before its init, so it self-recurses into
;;    the new binding.
(let ([env (make-repl-env)])
  (reset-counter!)
  (let ([il (repl-lower-form env '(define (f n) (f n)))])
    (check-pred "recursive call targets f.g0"
                il (lambda (t) (and (eq? (car t) 'global-set!)
                                    (eq? (cadr t) 'f.g0)
                                    (mentions? 'f.g0 (caddr t)))))))

;; 5. A value definition registers after its init, so the init sees the previous
;;    binding: (define w 10) then (define w (+ w 1)) reads the old w.g0.
(let ([env (make-repl-env)])
  (reset-counter!)
  (repl-lower-form env '(define w 10))
  (check "value redefinition reads previous generation"
         (repl-lower-form env '(define w (+ w 1)))
         '(global-set! w.g1 (primcall + (global-ref w.g0) (const 1)))))

;; 6. The whole front-end pipeline lowers a form to L-code carrying the global
;;    nodes (no unbound-variable crash from `lower`).
(let ([env (make-repl-env)])
  (reset-counter!)
  (repl-lower-form env '(define g 7))
  (let* ([il (repl-lower-form env '(+ g g))]
         [lc (lower-program
               (convert-closures
                 (convert-assignments
                   (recognize-let il))))])
    (check-pred "lowers to a program with global-ref"
                lc (lambda (t) (and (eq? (car t) 'program) (mentions? 'g.g0 t))))))

(printf "\n~a passed, ~a failed\n" pass fail)
(exit (if (zero? fail) 0 1))
