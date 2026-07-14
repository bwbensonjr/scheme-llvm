; 4-byte UTF-8 codepoint (U+1F600 😀 -> F0 9F 98 80) in a string literal and a
; symbol, exercising the in-language UTF-8 encoder's 4-byte path and the \XX
; escaping in emit's c"..." literals (change: emit-cstring-in-language).  The
; value round-trips through the runtime's own UTF-8 decode, confirming the
; escaping agrees with it.  (2- and 3-byte paths are covered by unicode.scm /
; string-unicode.scm; control chars by reader-lexical.scm.)
(list "a😀b" (string->symbol "grin😀"))
