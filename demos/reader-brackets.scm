; The in-language reader accepts [...] brackets as equivalent to (...)
; (fix-bracket-reader).  The prelude reader's rd-datum had no case for `[`, so
; bracket syntax mis-read and the self-compiled schemec segfaulted on the
; bracket-laden core.  This reads a bracketed datum at runtime via the compiled
; prelude reader.  Expected value: ((a (b c) (d 5)))
(read-all-from-string "(a [b c] [d 5])")
