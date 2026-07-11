; multiple top-level forms: a value `define`, the `(define (f ...) ...)` procedure
; shorthand, mutual reference (even?/odd? call each other; even? forward-refers to
; odd?), and a trailing expression whose value is the program's value.
(define bump 1)
(define (even? n) (if (= n 0) #t (odd? (- n 1))))
(define (odd? n) (if (= n 0) #f (even? (- n 1))))
(define (double n) (* n 2))
(+ (if (even? 10) (double bump) 0)
   (if (odd? 7) 100 0))
