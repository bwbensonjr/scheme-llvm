## Why

The gap sweep ([[self-host-gap-sweep]]) found gap **G6**: scheme-llvm's quasiquote expander
`qq` crashes (`cadr` on a bare `(unquote)`) when a quasiquote *template* contains the literal
symbols `unquote`/`unquote-splicing`/`quasiquote` as list **data** — e.g.
`` `(list (quote unquote) ,x) ``. `qq` matches on `(car d)` being `unquote` without first
checking the datum is a well-formed `(unquote X)`, so descending into `(quote unquote)` reaches
the tail `(unquote)` and dies. This is precisely the shape the expander's *own* nested-quasiquote
handling emits (`expand.ss` lines ~284/288/290), so **the expander cannot compile itself** — the
first hard blocker when compiling the assembled core with scheme-llvm.

## What Changes

- Guard each head check in `qq` so it only treats a datum as unquote/unquote-splicing/quasiquote
  when it is a proper `(kw X)` form: add `(pair? (cdr d))` to the three cond arms. A bare
  `(unquote)` / `(unquote-splicing)` / `(quasiquote)` list-datum then falls through to the
  general-pair arm and is rebuilt structurally (correct: `` `(unquote) `` → `(unquote)`).
- No behavior change for well-formed quasiquotes; this only stops the crash on the literal-symbol
  edge case (which R7RS quasiquote must handle).

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `macro-system`: the quasiquote rewrite handles the literal symbols `unquote`,
  `unquote-splicing`, and `quasiquote` appearing as ordinary list data inside a quasiquote,
  rather than misparsing them as (malformed) unquote forms.

## Impact

- **Code**: `src/passes/expand.ss` (`qq`, three one-token guards).
- **Depends on**: nothing; unblocks [[self-hosting-bootstrap]] (G6 is the first compile blocker
  for the assembled core) and complements the rest of the [[self-host-gap-sweep]] backlog.
- **Risk**: minimal — a strictly narrowing guard on an existing match; verified against the
  crashing shape and ordinary quasiquotes.
