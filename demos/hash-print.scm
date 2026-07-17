; Hash tables print opaquely as #<hash-table N> (N = element count); not readable.
;   => #<hash-table 2>
(let ((h (make-hash-table)))
  (hash-table-set! h "x" 1)
  (hash-table-set! h "y" 2)
  h)
