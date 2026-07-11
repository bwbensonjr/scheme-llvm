;;; tests.ss -- shared test inputs (plain s-expressions). The SAME datum is
;;; fed to both the nanopass side (via parse-Lx) and the hand-rolled side, so
;;; the comparison holds the input constant (design D3).
;;;
;;; One set per pass, because each pass has a different input-language surface:
;;;   rl-tests : L1  (lambdas as exprs, set! present)
;;;   ca-tests : L3  (has set!; includes a captured-mutable-boxing case)
;;;   cc-tests : L5  (no set!; includes a non-trivial closure case)
;;;
;;; Convention: core lambda/let/letrec bodies are a single Expr; multi-step
;;; bodies use explicit (seq ...).

(library (tests)
  (export rl-tests ca-tests cc-tests)
  (import (chezscheme))

  (define rl-tests
    '(;; direct application of a lambda -> let
      (call (lambda (a b) (call plus a b)) (quote 1) (quote 2))
      ;; nested; inner call-of-lambda also recognized
      (call (lambda (x) (call (lambda (y) (call plus x y)) (quote 5))) (quote 3))
      ;; arity mismatch: NOT recognized, stays a call
      (call (lambda (a b) a) (quote 1))
      ;; a real call (operator not a lambda) is left alone
      (letrec ([f (lambda (n) (call f n))]) (call f (quote 0)))))

  (define ca-tests
    '(;; captured-mutable boxing: counter is set! inside the lambda body
      (lambda (counter)
        (seq (set! counter (call plus counter (quote 1)))
             counter))
      ;; a let-bound assigned variable
      (let ([acc (quote 0)])
        (seq (set! acc (call plus acc (quote 10))) acc))
      ;; mix: x assigned, y not -> only x is boxed/renamed
      (lambda (x y)
        (seq (set! x y) (call plus x y)))
      ;; no assignments at all -> program unchanged
      (let ([z (quote 7)]) (call plus z z))))

  (define cc-tests
    '(;; non-trivial closure: mutually recursive f/g, plus an outer free var
      (letrec ([f (lambda (n) (call g n))]
               [g (lambda (m) (call f (call plus m free)))])
        (call f (quote 10)))
      ;; single closure capturing an outer let binding
      (let ([k (quote 100)])
        (letrec ([add-k (lambda (n) (call plus n k))])
          (call add-k (quote 1))))
      ;; closed lambda (no free vars) -> empty free-var list
      (letrec ([id (lambda (x) x)]) (call id (quote 9)))
      ;; boxes flow through closure conversion unchanged
      (letrec ([bump (lambda (b) (set-box! b (unbox b)))]) (call bump c)))))
