;;; modulo.scm -- flooring modulo (result takes the divisor's sign), contrasted
;;; with the existing truncating remainder (change: inexact-numbers).
(list (modulo 17 5)    ; 2
      (modulo 5 5)     ; 0
      (modulo -7 3)    ; 2  (sign of divisor)
      (modulo 7 -3)    ; -2 (sign of divisor)
      (remainder -7 3)) ; -1 (sign of dividend, for contrast)
