; a read symbol is interned: eq? to the same-named literal.
(eq? (read-from-string "foo") (quote foo))   ; => #t
