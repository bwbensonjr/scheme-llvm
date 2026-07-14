; Variadic (multi-list) map (fix-closure-self-compilation).
; The compiler core's `rename` (parse.ss) and `emit.ss` use 2-list `map`/
; `for-each` -- e.g. (map cons names new), (map (lambda (b op) ...) binds ops),
; (for-each (lambda (s i) ...) slots (iota k)).  Chez's map/for-each are
; variadic, so the source runs Chez-hosted; the prelude's were single-list, so
; the self-compiled `schemec` hit `arity error: expected 2, got 3`.  This demo
; exercises the 2-list map form; the variadic for-each is exercised by schemec
; itself compiling closures.  Expected value: (11 22 33).
(map (lambda (a b) (+ a b)) (quote (10 20 30)) (quote (1 2 3)))
