; Character/string library (openspec string-char-library): char comparisons
; (n-ary, prelude over char->integer), string content equality, and the string
; constructors (C primitives: string-append, symbol->string, list->string,
; make-string).  One list result pins down every case:
;   => (#t #f #t #f "foobar" "xxx" (#\a #\b) "héllo")
(list
 (char<? #\a #\b #\c)                              ; chained char<     -> #t
 (char<? #\a #\c #\b)                              ; out of order      -> #f
 (string=? (substring "xhello" 1 6) "hello")       ; content equality  -> #t
 (string=? "abc" "abd")                            ; unequal content   -> #f
 (string-append "foo" (symbol->string (quote bar))); append + sym->str -> "foobar"
 (make-string 3 #\x)                               ; filled string     -> "xxx"
 (string->list "ab")                               ; string -> chars   -> (#\a #\b)
 (list->string (string->list "héllo")))            ; round-trip, UTF-8 -> "héllo"
