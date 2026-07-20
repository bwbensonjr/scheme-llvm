;;; write-char.scm -- write-char emits a character's UTF-8 bytes to stdout,
;;; including a non-ASCII codepoint (change: inexact-numbers).  The side-effect
;;; output is "hi λ\n"; the final symbol `done` is auto-printed by the runner.
(for-each write-char (string->list "hi "))
(write-char (integer->char 955))   ; λ (2-byte UTF-8)
(write-char #\newline)
'done
