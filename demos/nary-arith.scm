; n-ary arithmetic: variadic + - *, unary negation, identities, and nested
; arithmetic inside another form.  Folds to nested binary prims in `expand`.
(+ (+ 1 2 3 4)          ; n-ary sum          -> 10
   (* 2 3 4)            ; n-ary product      -> 24
   (- 10 1 2)           ; left-assoc subtract -> 7
   (- 5)                ; unary negation     -> -5
   (+)                  ; additive identity  ->  0
   (*)                  ; multiplicative id  ->  1
   (if (< 0 1)          ; nested arithmetic inside `if`
       (* 1 2 3)        ;                    ->  6
       0))              ; total              -> 43
