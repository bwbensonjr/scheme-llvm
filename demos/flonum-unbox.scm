;;; flonum-unbox.scm -- exercises the flonum f64-region fast path (change:
;;; flonum-unboxing).  Covers: a flonum accumulator loop (the loop-var fixpoint
;;; proves `acc` flonum-stable, so its body computes in native fadd/fmul and boxes
;;; only at the back-edge escape), nested flonum arithmetic fused in one region,
;;; escape points (storing flonums into a vector), a flonum comparison region, and
;;; a mixed fixnum/flonum operand that must fall back to the boxed runtime path.
;;; The final list is auto-printed by the runner.

(define (scaled-sum n)                  ; acc is flonum-stable (fixpoint); i is not
  (let loop ((i 0) (acc 0.0))
    (if (= i n)
        acc
        (loop (+ i 1) (+ acc (* 0.5 (exact->inexact i)))))))   ; 0.5*(0+1+..+n-1)

(define (poly x)                        ; one fused region: fmul/fmul/fadd/fadd
  (+ (* x x x) (* 3.0 x) 1.0))

(let ((v (make-vector 3 0.0)))
  (vector-set! v 0 (scaled-sum 5))      ; 0.5*(0+1+2+3+4)    -> 5.0
  (vector-set! v 1 (poly 2.0))          ; 8.0 + 6.0 + 1.0    -> 15.0
  (vector-set! v 2 (+ 1 2.0))           ; mixed: guard fails -> boxed rt_add -> 3.0
  (list (vector-ref v 0)
        (vector-ref v 1)
        (vector-ref v 2)
        (< (poly 1.0) 6.0)))            ; 1.0+3.0+1.0 = 5.0 < 6.0 -> #t
