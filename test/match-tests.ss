;;; match-tests.ss -- unit tests for the `match` macro (src/match.scm).
;;; Run from the repo root:  chez --script test/match-tests.ss
;;;
;;; Characterizes the matcher surface the compiler passes rely on: the `,x`
;;; (nanopass) convention -- bare symbols are literals matched with eq?, ,id
;;; binds; pairs, dotted-rest, nil, guards, else, and the no-match error.
;;; (Ellipsis is intentionally out of scope here -- see change
;;; port-match-to-syntax-rules; it is a follow-up.)

(import (chezscheme))
(include "src/match.scm")           ; flat source (change: self-hosting-completion)

(define pass 0)
(define fail 0)
(define (check name got want)
  (if (equal? got want)
      (begin (set! pass (+ pass 1)) (printf "  [OK  ] ~a\n" name))
      (begin (set! fail (+ fail 1))
             (printf "  [FAIL] ~a\n         got:  ~s\n         want: ~s\n" name got want))))
(define (check-raises name thunk)
  (let ([r (guard (e (#t 'raised)) (thunk) 'no-error)])
    (check name r 'raised)))

(printf "match macro unit tests\n")

(check "binder"        (match 5 [,x x]) 5)
(check "literal head + binders"
       (match '(seq 1 2) [(seq ,a ,b) (list a b)]) '(1 2))
(check "dotted-rest"
       (match '(primcall + 1 2) [(primcall ,op . ,args) (list op args)])
       '(+ (1 2)))
(check "literal dispatch picks right clause"
       (match '(if a b c) [(seq ,x) 'seq] [(if ,a ,b ,c) (list a b c)])
       '(a b c))
(check "guard passes"
       (match 'foo [,x (guard (symbol? x)) 'sym] [,x 'other]) 'sym)
(check "guard falls through"
       (match 5 [,x (guard (symbol? x)) 'sym] [,x 'other]) 'other)
(check "else"
       (match 99 [(a ,x) 'pair] [else 'fell]) 'fell)
(check "nested pattern"
       (match '(a (b c)) [(,x (,y ,z)) (list x y z)]) '(a b c))
(check "nil pattern"
       (match '() [() 'empty] [,x 'nonempty]) 'empty)
(check "multi-expression body"
       (match 3 [,x (set! x (+ x 1)) x]) 4)
(check-raises "no matching clause raises"
       (lambda () (match 5 [(a ,x) 'pair])))

(printf "\n  ~a passed, ~a failed\n" pass fail)
(exit (if (= fail 0) 0 1))
