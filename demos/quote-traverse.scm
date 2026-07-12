; traverse quoted structure with car/cdr; the second element is itself a list.
(car (cdr (quote (a (b c) 1))))        ; => (b c)
