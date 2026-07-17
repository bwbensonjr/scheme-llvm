; write: render ANY datum in *write* style -- strings WITH quotes, chars WITH the
; #\ prefix, compounds recursing in write style.  The write-style companion to
; `display`; returns the unspecified value so it composes inside `begin`.  The
; final bare `(quote done)` is the program's value (change: io-output-primitives).
(begin
  (write "hi")(display " ")
  (write #\a)(display " ")
  (write (list "a" #\b 3))(display " ")
  (quote done))
