;;; cyc-a.sld -- cycle fixture A (change: module-generalize).  (cyc-a) <-> (cyc-b).
(define-library (cyc-a)
  (import (cyc-b))
  (export a)
  (begin
    (define (a) (b))))
