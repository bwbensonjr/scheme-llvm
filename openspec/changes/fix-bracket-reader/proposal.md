## Why

The self-hosting stage-1 build ([[self-hosting-bootstrap]] task 2.1) is blocked by a reader
gap, found while closing [[fix-closure-self-compilation]]: the native `schemec` **segfaults on
any program using `[...]` bracket list syntax**. Minimal repro: `(let ([x 5]) x)` crashes, while
`(let ((x 5)) x)` compiles.

Root cause: the prelude's in-language reader dispatch `rd-datum` (`src/prelude.scm`) has **no
case for `[`** (char 91) — it handles `(`, `'`, `` ` ``, `,`, `"`, `#`, else → `rd-atom`. So a
`[` is read as the start of an atom token, the list structure is never built, and the malformed
forms crash `schemec` downstream. (Under Chez the source is read by Chez's own `read`, which
accepts brackets, so this only bites the self-hosted reader.)

This blocks self-hosting concretely: the assembled core `build/schemec.scm` is produced by Chez
`pretty-print`, which emits `[...]` for binding forms — **~529 brackets** — so `schemec` cannot
read its own source for the stage-1 build or the byte-identical triple test.

## What Changes

- **Grow the reader to accept `[...]` as list syntax**, equivalent to `(...)` (R6RS/R7RS treat
  them interchangeably). Three small edits in `src/prelude.scm`:
  - `rd-datum`: dispatch `[` (91) to `rd-list` (like `(`).
  - `rd-list`: accept `]` (93) as a list terminator in addition to `)` (41).
  - `rd-delim?`: treat `[` (91) and `]` (93) as token delimiters, so an atom abutting a bracket
    (e.g. `5]`) ends correctly.
- Brackets and parentheses are accepted interchangeably (lenient matching — a `[` may be closed
  by `)` and vice-versa), matching the well-formed input the compiler consumes; strict
  bracket/paren matching is out of scope.
- **Regression test**: reader and end-to-end demos that use `[...]` (e.g. `(let ([x 5]) (+ x 1))`
  and a bracketed `letrec`) read and evaluate correctly.

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `core-language`: the in-language reader (`read-from-string` / `read-all-from-string`) accepts
  `[...]`-bracketed lists as equivalent to `(...)`.

## Impact

- **Code**: `src/prelude.scm` (`rd-datum`, `rd-list`, `rd-delim?`); a reader/demo regression case.
- **Unblocks**: [[self-hosting-bootstrap]] task 2.1 — with this and the variadic-prelude fix in,
  `schemec` should read and compile the bracket-bearing assembled core.
- **Risk**: low — a localized reader extension; the full suite (incl. the `read-all` reader unit
  tests) guards it, plus a new bracket case.
