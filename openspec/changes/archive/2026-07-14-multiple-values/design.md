## Context

The ~21 uses are almost all the shape `(let-values ([(a b) (f …)]) …)` where `f` returns a
small fixed number of values — no variadic `values`, no `call-with-values` across module
boundaries. That narrowness matters: it makes "avoid" cheap and "grow" only needs the fixed
case.

## Goals / Non-Goals

**Goals:** remove the multiple-values dependency from the self-hosting critical path, one way
or the other.

**Non-Goals:** full continuation-based multiple-values generality, variadic `values` receivers
beyond what the compiler uses.

## Decisions

### D1: Choose avoid vs grow (DECIDED: AVOID, 2026-07-13)

**Decision: AVOID.** Refactor the ~21 sites to return pairs/lists and destructure them; add
no language/runtime surface. This keeps the self-hosting gap flat, as recommended below.

**Recommendation: avoid.** Refactor the ~21 sites to return a pair/list and destructure it
(`(let ([r (f …)]) (let ([a (car r)] [b (cadr r)]) …))`, or a small `match`). Rationale:
- The uses are all fixed-arity and internal — no external contract needs true `values`.
- It adds **zero** language/runtime surface to self-host (multiple values otherwise need a
  values representation + `call-with-values` protocol in the runtime).
- The `,x` matcher already makes destructuring ergonomic.

**Grow** stays the alternative if we decide multiple values are worth having as a language
feature in their own right (not just to satisfy the compiler). If chosen: represent values as
a distinguished tuple the callee returns and `call-with-values` unpacks; `let-values`
desugars to `call-with-values` + a lambda; single value is the identity case.

Resolve D1 before implementing; the tasks below branch on it.

## Risks / Trade-offs

- **Avoid** → 21 mechanical edits; risk of a wrong `car`/`cadr` — guarded by the full suite.
- **Grow** → new runtime protocol; more to self-host later (works against the "keep the gap
  flat" principle).

## Migration Plan (avoid path)

1. Convert each `values`-returning helper to return a list; update its `let-values` callers to
   destructure.
2. Remove any `let-values`/`values` references from the compiler.
3. Full suite green.

## Open Questions

- ~~Final call on D1.~~ Resolved 2026-07-13: AVOID. Multiple values are pursued only to
  unblock self-hosting, not as a standalone language feature.
