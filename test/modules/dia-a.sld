;;; dia-a.sld -- diamond left arm (change: module-generalize).
(define-library (dia-a)
  (import (dia-c))
  (export a-val)
  (begin
    (define (a-val) (* (c-val) 2))))    ; 7 * 2 = 14
