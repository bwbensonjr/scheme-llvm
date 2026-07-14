## Context

`read-from-string s` = `(car (rd-datum s n (rd-skip-ws s n 0)))` — it reads one datum and
discards the next index. The reader already threads position functionally as `(datum .
next-index)` and skips whitespace/`;` comments. Reading all forms is just looping that until
the position reaches the end.

## Goals / Non-Goals

**Goals:** a whole-program reader in-language: source string → list of top-level forms.

**Non-Goals:** streaming/incremental reads from a live port, datum labels, block comments
`#| |#` unless a source file needs them, non-UTF-8 handling.

## Decisions

### D1: Loop the existing datum reader

`read-all-from-string s`: let `n = (string-length s)`; loop from index `(rd-skip-ws s n 0)`:
if at end, return the accumulated forms (in order); else `rd-datum` at the position, cons the
datum, continue from `(rd-skip-ws s n next)`. Reuses all existing `rd-*` helpers unchanged —
no new lexing.

### D2: Driver supplies the string; core stays pure

Per [[decompose-core-driver]], the driver reads stdin/file into a string and hands it to the
core; the core calls `read-all-from-string` to get the forms it already compiles. The core
does no port I/O.

## Risks / Trace-offs

- **Comment/whitespace at EOF** → `rd-skip-ws` already handles trailing whitespace/comments;
  test a source ending in a comment.
- **Large sources** → the reader is O(n) per datum scan; fine for compiler-sized inputs.

## Migration Plan

1. Add `read-all-from-string` to `src/prelude.scm`.
2. Test: multi-form strings (defines + trailing expression), comments between forms, trailing
   whitespace/comment, empty input.
3. Confirm it produces the same form list as Chez `read` over the same source for a sample
   (e.g. a small demo file).

## Open Questions

- Does any source we must read use block comments `#| |#` or datum comments `#;`? If so, add
  them to the reader (small extensions to `rd-*`).
