; char interning: equal-codepoint characters are the same object across every
; construction path (literal, integer->char, string-ref), distinct chars differ,
; and interned chars survive GC -- like interned symbols (see symbol-gc).  Each
; true test lights a distinct decimal digit so the total pins down which fired.
(define (build n acc) (if (= n 0) acc (build (- n 1) (cons n acc))))
(define c1 #\Z)                        ; latin1-tier intern (cp 90)
(define c3 #\λ)                        ; astral-tier intern (cp 955)
(define junk (build 1000000 (quote ())))  ; ~16MB of pairs -> forces Boehm GC
(+ (if (eqv? #\a #\a) 1 0)             ; literal eqv?              ->       1
   (if (eq? #\a #\a) 10 0)            ; literal eq?               ->      10
   (if (eq? #\A (integer->char 65)) 100 0)     ; cross-construction ->    100
   (if (eq? (string-ref "A" 0) #\A) 1000 0)    ; string-ref identity ->  1000
   (if (eqv? #\a #\b) 10000 0)        ; distinct chars -> #f       ->       0
   (if (eq? c1 (integer->char 90)) 100000 0)   ; latin1 survives GC ->  100000
   (if (eq? c3 (integer->char 955)) 1000000 0));astral survives GC  -> 1000000
                                      ; total                      -> 1101111
