;;; flonum-predicates.scm -- the refined numeric predicates and exact/inexact
;;; conversions distinguish the two number types (change: inexact-numbers).
(list (exact? 7) (inexact? 7)            ; fixnum: exact
      (exact? 2.5) (inexact? 2.5)        ; flonum: inexact
      (integer? 3.0) (integer? 2.5)      ; integral vs non-integral flonum
      (number? 2.5) (flonum? 2.5) (real? 7)
      (exact->inexact 3) (inexact->exact 3.0)
      (eqv? 2.5 2.5) (eqv? 2 2.0))       ; flonum by value; exact/inexact never eqv?
