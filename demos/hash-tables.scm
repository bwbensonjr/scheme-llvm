; Hash-table data type (openspec hash-tables): SRFI-69 subset, equal?-keyed,
; built in the prelude on vectors + the %hash primitive.  A table is an opaque
; HDR_HASHTABLE wrapper around a mutable spine #(count buckets _); it grows past
; a load factor.  One list result pins down every case:
;   => (1 42 2 #f 100 #t #t #t #f #t)
(let ((h (make-hash-table))
      (big (make-hash-table)))
  ; populate `big` with 100 distinct integer keys -> exercises grow/rehash
  (let loop ((i 0)) (if (< i 100) (begin (hash-table-set! big i (* i i)) (loop (+ i 1))) #f))
  (list
   (begin (hash-table-set! h "a" 1) (hash-table-ref/default h "a" 0))  ; set + ref     -> 1
   (hash-table-ref/default h "missing" 42)                             ; default       -> 42
   (begin (hash-table-set! h "k" 1) (hash-table-set! h "k" 2)
          (hash-table-ref/default h "k" 0))                            ; overwrite key -> 2
   (begin (hash-table-set! h (quote g) 9) (hash-table-delete! h (quote g))
          (hash-table-contains? h (quote g)))                         ; delete        -> #f
   (hash-table-size big)                                              ; grew to size  -> 100
   (let bloop ((i 0) (ok #t))                                         ; all retrievable
     (if (< i 100)
         (bloop (+ i 1) (if (= (hash-table-ref/default big i -1) (* i i)) ok #f))
         ok))                                                          ; every key ok  -> #t
   (hash-table? h)                                                    ; predicate yes -> #t
   (hash-table? (make-hash-table))                                    ; predicate yes -> #t
   (hash-table? (vector 1 2 3))                                       ; predicate no  -> #f
   (= (%hash "abc") (%hash (string-append "ab" "c")))))               ; equal? hashes -> #t
