;;; flonum-arith.scm -- inexact reals: literals, mixed arithmetic (contagion),
;;; real division, and numeric comparison across the fixnum/flonum tower.
;;; The final list is auto-printed by the runner (change: inexact-numbers).
(list (+ 1 2.0)      ; mixed -> flonum
      (* 2.0 0.5)    ; flonum -> flonum
      (- 5.0 1)      ; mixed -> flonum
      (/ 7 2)        ; exact/exact not divisible -> flonum
      (/ 6 3)        ; exact/exact divisible -> exact
      (/ 5.0 2)      ; inexact division
      (< 1 2.5)      ; mixed comparison
      (> 3.0 2)
      (= 2 2.0))     ; numeric equality across types
