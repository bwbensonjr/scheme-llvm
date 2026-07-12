; dotted rest parameter: arguments beyond the two fixed params are collected
; into `rest` as a proper list.
((lambda (a b . rest) rest) 1 2 3 4)   ; => (3 4)
