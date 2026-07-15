;;; expander-tests.ss -- unit tests for the syntax-rules expander (expand.ss).
;;; Run from the repo root:  chez --libdirs src --script test/expander-tests.ss
;;;
;;; Exercises the expander directly at the source->source level, independent of
;;; the rest of the pipeline.  Added by change: port-match-to-syntax-rules to
;;; cover the ellipsis-escape (... ...) needed to host a syntax-rules matcher.

(import (chezscheme))
(include "src/util.scm")            ; flat source (change: self-hosting-completion)
(include "src/passes/expand.ss")

(define pass 0)
(define fail 0)
(define (check name got want)
  (if (equal? got want)
      (begin (set! pass (+ pass 1)) (printf "  [OK  ] ~a\n" name))
      (begin (set! fail (+ fail 1))
             (printf "  [FAIL] ~a\n         got:  ~s\n         want: ~s\n" name got want))))

(define base-known
  (append *core-keywords* *extra-op-keywords*
          '(list cons car cdr null? pair? eq? equal? not append)))

;; expand FORM in an environment built from the given define-syntax forms.
(define (expand-with dsx form)
  (expand form (map parse-define-syntax dsx) base-known))

(printf "expander unit tests\n")

;; ---- ellipsis escape (... ...) ----
;; R7RS: (... <tmpl>) yields <tmpl> with ellipses inside treated literally.
(check "ellipsis escape yields a literal ..."
       (expand-with
         (list '(define-syntax gen (syntax-rules () ((_ a) (list a (... ...))))))
         '(gen foo))
       '(list foo ...))

;; inside an escape, pattern variables still substitute but `...` stays literal
(check "escape substitutes pvars, keeps ... literal"
       (expand-with
         (list '(define-syntax gen2 (syntax-rules () ((_ a) (... (a ...))))))
         '(gen2 foo))
       '(foo ...))

;; regression: ordinary ellipsis repetition still expands
(check "ordinary ellipsis still repeats"
       (expand-with
         (list '(define-syntax lst (syntax-rules () ((_ x ...) (list x ...)))))
         '(lst 1 2 3))
       '(list 1 2 3))

(printf "\n  ~a passed, ~a failed\n" pass fail)
(exit (if (= fail 0) 0 1))
