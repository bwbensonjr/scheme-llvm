; Ackermann: near-pure probe of non-tail recursion + small-integer arithmetic
; with almost no allocation. Isolates codegen quality for calls and fixnum ops
; (see docs/PERFORMANCE.md, P5). (ack 3 10) => 8189.
(define (ack m n)
  (cond
   ((= m 0) (+ n 1))
   ((= n 0) (ack (- m 1) 1))
   (else (ack (- m 1) (ack m (- n 1))))))
(ack 3 10)
