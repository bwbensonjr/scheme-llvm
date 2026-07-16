;; entry-embed.scm -- the embedded batch compiler's entry (change:
;; embedded-runner-rehome).  Reads the program from stdin and returns emitted IR.
;; With the prelude enabled (the default) it re-homes the prelude as the auto-
;; imported library (scheme base), returning the (scheme base) module + a boundary
;; marker + the program module (the host splits and links/JITs both).  With
;; --no-prelude (forwarded by the host via EMIT_NO_PRELUDE, read by %no-prelude?)
;; it emits only the program, leaving prelude names unbound -- matching the Chez
;; driver's --no-prelude.
(if (%no-prelude?)
    (compile-source-string (read-all-stdin))
    (compile-source-rehomed *prelude-source* (read-all-stdin)))
