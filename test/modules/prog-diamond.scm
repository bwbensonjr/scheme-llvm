;;; prog-diamond.scm -- import both arms of a diamond over (dia-c). => 35
(import (dia-a))
(import (dia-b))
(+ (a-val) (b-val))    ; 14 + 21 = 35
