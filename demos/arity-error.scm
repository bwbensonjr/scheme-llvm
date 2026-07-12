; fixed-arity procedure called with the wrong number of arguments: the runtime
; reports an arity error and aborts (non-zero exit) rather than miscomputing.
(define (f a b) (+ a b))
(f 1 2 3)                              ; 3 args to a 2-arg procedure => arity error
