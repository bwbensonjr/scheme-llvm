; apply over a runtime list longer than the max fixed arity (K = 1 here, from
; sum-list).  `sum` is variadic, so apply spreads 10, 20, and the 5 list
; elements through the overflow vector: xs = (10 20 1 2 3 4 5), sum = 45.
(define (sum-list xs)
  (if (null? xs) 0 (+ (car xs) (sum-list (cdr xs)))))
(define (sum . xs) (sum-list xs))
(define nums (cons 1 (cons 2 (cons 3 (cons 4 (cons 5 (quote ())))))))
(apply sum 10 20 nums)                 ; => 45
