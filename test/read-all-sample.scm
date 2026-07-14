; sample source for the read-all cross-check (stdin-source-reader): a mix of
; top-level forms staying within the subset both readers share (integers,
; symbols, strings, chars, booleans, vectors, quote sugar, dotted pairs,
; nesting, comments) so read-all-from-string and Chez `read` agree exactly.
(define (square n) (* n n))      ; a define with a body
(define greeting "hello world")  ; string literal
(define flags (list #t #f))      ; booleans
(define chars '(#\a #\space))    ; quoted list of characters
(define v #(1 2 3))              ; vector literal
(define pair '(x . y))           ; dotted pair
(define nested '(a (b c) (d (e)))) ; nested structure
(square -4)                      ; trailing expression, negative arg
