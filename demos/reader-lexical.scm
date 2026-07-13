; Reader lexical extensions (openspec reader-lexical-extensions): string
; escapes (\n \t \xHH;), named characters (#\space #\newline), and dotted /
; improper lists.  Strings and chars are reduced to codepoints so the result
; prints unambiguously:
;   => (3 9 65 32 10 (a . b) (x y . z))
(list
 (string-length (read-from-string "\"a\\nb\""))                 ; \n escape     -> 3
 (char->integer (string-ref (read-from-string "\"x\\ty\"") 1))  ; \t escape     -> 9
 (char->integer (string-ref (read-from-string "\"\\x41;\"") 0)) ; \xHH; escape  -> 65 (#\A)
 (char->integer (read-from-string "#\\space"))                  ; named space   -> 32
 (char->integer (read-from-string "#\\newline"))                ; named newline -> 10
 (read-from-string "(a . b)")                                   ; dotted pair   -> (a . b)
 (read-from-string "(x y . z)"))                                ; improper list -> (x y . z)
