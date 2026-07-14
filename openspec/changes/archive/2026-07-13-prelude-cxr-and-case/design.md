## Context

Trivial, low-risk additions that remove Chez built-in dependencies from the compiler source.
`cadr` and friends are just compositions of `car`/`cdr`; `case` is a standard `syntax-rules`
sugar over `cond` + `eqv?`.

## Goals / Non-Goals

**Goals:** add the cxr combinators the compiler uses and a `case` macro; keep them pure
prelude/`syntax-rules`.

**Non-Goals:** full R7RS cxr set breadth beyond what's useful; `case` with `=>` clauses
unless the compiler needs it (it does not).

## Decisions

### D1: cxr as prelude procedures

Define `(define (cadr x) (car (cdr x)))` etc. Cover at least all depth-2 and depth-3 forms;
including the full depth-4 set is cheap and harmless. Names must not collide with primitives
(only `car`/`cdr` are primitive).

### D2: `case` as syntax-rules over cond + memv

`(case k ((d ...) body ...) ... (else e ...))` → bind `k` once, then a `cond` whose tests are
`(memv k '(d ...))`, with `else` last. Requires `memv` (add to prelude if absent; it mirrors
`memq` with `eqv?`). Hygienic temp for `k` (the expander already renames introduced ids).

## Risks / Trade-offs

- **`memv` availability** → add it to the prelude if not present (analogue of `memq`).
- **Name shadowing** → user-wins prelude shadowing already handles redefinition; cxr names
  are ordinary defines.

## Migration Plan

1. Add cxr combinators + `memv` to `src/prelude.scm`.
2. Add the `case` macro.
3. Tests: a demo exercising `case` and a few cxr forms; full suite green.

## Open Questions

- How deep to go on cxr (depth-3 suffices for the compiler; depth-4 is cheap completeness).
