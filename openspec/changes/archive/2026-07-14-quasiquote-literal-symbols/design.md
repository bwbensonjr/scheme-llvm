## Context

`qq` (`src/passes/expand.ss`) rewrites a quasiquoted datum into `cons`/`append`/`list`/`quote`
core forms. Its first three cond arms special-case a datum whose `car` is `unquote`,
`unquote-splicing`, or `quasiquote`, then take `(cadr d)`. When the quasiquote contains one of
those symbols *as data* (not as a head of a real unquote), the recursion still reaches a datum
like `(unquote)` — the two-element list `(quote unquote)` has cdr `(unquote)` — and `(cadr d)`
fails with `cadr: incorrect list structure`. The compiler's own expander emits exactly this
shape when it rewrites nested quasiquotes (`` `(list (quote unquote) ,x) ``), so it cannot be
compiled by scheme-llvm.

## Goals / Non-Goals

**Goals:** make `qq` total on quasiquotes that contain the literal symbols `unquote`,
`unquote-splicing`, `quasiquote` as data; keep all well-formed quasiquote output byte-identical.

**Non-Goals:** any broader quasiquote feature (vector quasiquote, deeper nesting semantics
beyond what R7RS-over-lists already gives); the sweep confirmed the core needs nothing more.

## Decisions

### D1: Narrow the head checks with `(pair? (cdr d))`

Change the three arms from `(and (pair? d) (eq? (car d) 'KW) ...)` to
`(and (pair? d) (eq? (car d) 'KW) (pair? (cdr d)) ...)`. A datum is treated as `(KW X)` only
when it actually has an operand. A bare `(unquote)` / `(unquote-splicing)` / `(quasiquote)`
then falls through to the general-pair arm `` `(cons ,(qq (car d) level) ,(qq (cdr d) level)) ``
and is rebuilt as the literal list it is. This is the minimal, obviously-correct fix and matches
how a robust quasiquote expander must treat these symbols.

## Risks / Trade-offs

- **Masking a genuinely malformed unquote** → a lone `(unquote)` with no operand is not valid
  unquote syntax anyway; treating it as data is the correct R7RS reading, and the previous
  behavior was a crash, not a diagnostic. No regression in intent.
- **Output drift** → none for well-formed input: the guard only changes the previously-crashing
  path. Confirmed against the assembled-core compile and existing quasiquote tests.
