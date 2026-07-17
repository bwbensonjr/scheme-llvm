; Record data type (openspec records): R7RS define-record-type, lowered in the
; frontend (collect-toplevel) to a fresh type descriptor + constructor + predicate
; + accessors/mutators over the record runtime primitives.  Records are disjoint
; per type and compare by identity.  One list result pins down every case:
;   => (3 4 #t #f #f #t 9 #t #f)
(define-record-type point
  (make-point x y)
  point?
  (x point-x set-point-x!)
  (y point-y))
(define-record-type pear
  (make-pear a b)
  pear?
  (a pear-a)
  (b pear-b))
; Sequence the pre-mutation read, the mutation, and the post-mutation read with
; let*/begin so the result does not depend on argument evaluation order (which
; R7RS leaves unspecified, and which differs between the JIT and AOT paths).
(let* ((p         (make-point 3 4))
       (x-before  (point-x p))                  ; accessor            -> 3
       (y         (point-y p))                  ; accessor            -> 4
       (is-point  (point? p))                   ; predicate (yes)     -> #t
       (not-point (point? 5))                   ; predicate (non-rec) -> #f
       (disjoint  (point? (make-pear 1 2)))     ; disjoint types      -> #f
       (is-pear   (pear? (make-pear 1 2))))     ; other predicate     -> #t
  (set-point-x! p 9)                            ; mutate x in place
  (list x-before y is-point not-point disjoint is-pear
        (point-x p)                             ; after mutation      -> 9
        (equal? p p)                            ; identity equal?     -> #t
        (equal? (make-point 1 2) (make-point 1 2))))  ; distinct objects -> #f
