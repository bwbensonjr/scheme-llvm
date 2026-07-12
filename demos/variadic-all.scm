; all-arguments variadic: a bare symbol parameter binds every argument as a list.
(define (list* . xs) xs)
(list* 1 2 3)                          ; => (1 2 3)
