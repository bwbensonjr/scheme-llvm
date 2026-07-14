; read-all-from-string: read every top-level form from a source string
; (stdin-source-reader).  Exercises a multi-form source (defines + a trailing
; expression), comments/whitespace between and after forms, and comment-only
; input.  The program's value is the list of the three read results.
(define forms
  (read-all-from-string "(define x 1) (define y 2) (+ x y)"))
(define commented
  (read-all-from-string "; lead\n(define a 1) ; mid\n\n(b c)\n; trailing comment\n"))
(define empty
  (read-all-from-string "   ; only a comment\n   "))
(list forms commented empty)
