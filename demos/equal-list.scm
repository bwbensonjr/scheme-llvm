; Structural equality (equal?) and the equal?-based list library
; (member/assoc/filter/fold-left/fold-right) from openspec
; equality-and-list-library.  equal? is the rt_equal primitive; the rest are
; prelude Scheme.  The result is a single list pinning down every case:
;   => (1 1 0 ((2) (3)) ("b" . 2) (2 3 4) -6 (1 2 3))
(list
 (if (equal? (list 1 (list 2 3)) (quote (1 (2 3)))) 1 0)  ; nested structure   -> 1
 (if (equal? (substring "xhello" 1 6) "hello") 1 0)       ; string by content  -> 1
 (if (equal? (quote (1 2)) (quote (1 2 3))) 1 0)          ; unequal structure  -> 0
 (member (list 2) (quote ((1) (2) (3))))                  ; member by value    -> ((2) (3))
 (assoc "b" (quote (("a" . 1) ("b" . 2))))                ; assoc by value     -> ("b" . 2)
 (filter (lambda (n) (< 1 n)) (quote (1 2 3 0 4)))        ; filter             -> (2 3 4)
 (fold-left (lambda (a b) (- a b)) 0 (quote (1 2 3)))     ; ((0-1)-2)-3        -> -6
 (fold-right (lambda (x acc) (cons x acc))               ; rebuild list       -> (1 2 3)
             (quote ()) (quote (1 2 3))))
