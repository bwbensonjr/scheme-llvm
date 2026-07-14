; High-arity calling-convention regression (fix-high-arity-call-convention).
; `big` forces the whole-program max fixed arity to K=6, so every call passes
; K+3=9 arguments and the 9th is stack-passed on arm64.  `f` makes a NON-tail
; closure call `(helper a)` and then uses its own argument `b` afterward -- the
; caller's `b` must survive the call.  Under the old `tailcc` convention a
; non-tail call with a stack-passed argument corrupted `b` (garbage/hang); under
; `fastcc` it is preserved.  Expected value: 130.
(define (big a1 a2 a3 a4 a5 a6) (+ a1 a2))   ; only purpose: raise K to 6
(define (helper x) (+ x 100))
(define (f a b) (+ (helper a) b))            ; non-tail call to helper; b live across it
(f 10 20)                                    ; (+ (helper 10) 20) = 110 + 20 = 130
