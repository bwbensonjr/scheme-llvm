; `case` (matching clause + else fall-through) and the cxr combinators
; (caar/cadr/caddr/cadar plus a cdar), summed to one deterministic result.
(define (classify n)
  (case n
    ((0) 100)
    ((1 2 3) 200)
    ((4 5) 300)
    (else 999)))

(define data '((1 2) 3 4 5))

(+ (classify 2)                     ; 200  matches (1 2 3)
   (classify 5)                     ; 300  matches (4 5)
   (classify 42)                    ; 999  else
   (caar data)                      ; 1    (car (car data))
   (cadr data)                      ; 3    (car (cdr data))
   (caddr data)                     ; 4    (car (cddr data))
   (car (cdar data))                ; 2    (cdar data = (2))
   (cadar data))                    ; 2    (car (cdr (car data)))
