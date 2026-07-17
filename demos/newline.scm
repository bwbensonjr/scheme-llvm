; newline: write a single line feed (U+000A) to stdout, returning the unspecified
; value so it composes inside `begin`.  Here it separates two `display`s onto their
; own lines; the final bare `(quote done)` is the program's value (change:
; io-output-primitives).
(begin
  (display "a")
  (newline)
  (display "b")
  (newline)
  (quote done))
