; derived forms: cond (inside a define body), and, or, when, unless, let*, named let.
; Note: M1 arithmetic primitives are binary, so sums are nested (+ x (+ y ...)).
(define (classify n)
  (cond [(< n 0) -1]
        [(= n 0) 0]
        [else 1]))

(define (sum-to n)                          ; named-let loop, tail-recursive
  (let loop ([i n] [acc 0])
    (if (= i 0) acc (loop (- i 1) (+ acc i)))))

(let* ([a 3] [b (* a a)])                   ; let* sequential: a=3, b=9
  (+ (classify -5)                          ; -1
     (+ (classify 0)                        ;  0
        (+ (classify 7)                     ;  1
           (+ (if (and (< a b) (< 0 a)) 10 0)   ; and (both true)      -> 10
              (+ (if (or (< b a) (= b 9)) 20 0) ; or  (short-circuits) -> 20
                 (+ (when (< a b) 100)          ; when (taken)         -> 100
                    (+ (unless (< b a) 5)       ; unless (taken)       ->  5
                       (sum-to b)))))))))       ; sum 1..9             -> 45
