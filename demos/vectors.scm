; Vector data type (openspec vectors): tag-7 HDR_VECTOR heap object with
; make-vector/vector-ref/vector-set!/vector-length/vector?, the prelude vector
; constructor + list->vector, printing as #(...), structural equal?, and the
; #(...) reader syntax.  One list result pins down every case:
;   => (20 4 99 #t #f #(1 2 3) #t #f 9)
(list
 (vector-ref (vector 10 20 30) 1)                          ; construct + index -> 20
 (vector-length (make-vector 4 0))                         ; length            -> 4
 (let ((v (make-vector 2 0))) (vector-set! v 0 99) (vector-ref v 0))  ; mutate  -> 99
 (vector? (vector 1))                                      ; predicate (yes)   -> #t
 (vector? (quote (1)))                                     ; predicate (no)    -> #f
 (vector 1 2 3)                                            ; prints #(1 2 3)   -> #(1 2 3)
 (equal? (vector 1 2) (vector 1 2))                        ; structural equal? -> #t
 (equal? (vector 1 2) (vector 1 3))                        ; unequal           -> #f
 (vector-ref (read-from-string "#(7 8 9)") 2))             ; reader #(...)     -> 9
