; GC-root check: intern a symbol, allocate a large list to force Boehm
; collections, then re-intern the same name.  If the intern table survives GC,
; the two references are eq?.
(define (build n acc)
  (if (= n 0) acc (build (- n 1) (cons n acc))))
(define s1 (quote persistent))         ; intern
(define junk (build 1000000 (quote ())))  ; ~16MB of pairs -> triggers GC
(define s2 (quote persistent))         ; re-intern after GC
(eq? s1 s2)                            ; => #t
