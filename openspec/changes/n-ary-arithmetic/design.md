## Context

`+ - *` are binary C runtime functions (`rt_add`/`rt_sub`/`rt_mul`, each `i64 (i64,i64)`);
`emit-primcall` passes however many operands it is given, so `(+ a b c)` emits a 3-arg
call to a 2-arg function → wrong result. The frontend already has an `expand` pass
(source→source, from `derived-forms`) that is the natural home for a fold to binary form.

## Goals / Non-Goals

**Goals:**
- Accept `(+ …)`, `(- …)`, `(* …)` with any arity and compile them correctly by folding to
  nested binary `primcall`s in `expand`.
- No runtime/ABI/backend change.

**Non-Goals:**
- N-ary comparisons `(= a b …)` / `(< a b …)` (chained; need single-eval temps) — deferred.
- Division / other numeric ops (not in the subset).
- First-class variadic `+` as a value (that is the variadic/`apply` work).

## Decisions

### D1 — Fold in the `expand` pass

Add the fold to `src/passes/expand.ss` so it composes with the other source→source
rewrites and appears under the existing `expand` `--dump` stage (no new stage). Operands
are expanded first (so nested derived forms / nested arithmetic fold correctly), then
left-folded.

### D2 — Fold rules

| form | expansion |
|------|-----------|
| `(+)` | `0` |
| `(+ a)` | `a` (expanded) |
| `(+ a b c …)` | `(+ … (+ (+ a b) c) …)` left-associative binary `primcall`s |
| `(*)` | `1` |
| `(* a)` | `a` |
| `(* a b …)` | left fold |
| `(- a)` | `(- 0 a)` — unary negation |
| `(- a b)` | `(- a b)` |
| `(- a b c …)` | left fold `(- (- a b) c) …` |
| `(-)` | error (arity) |

The operator stays a reserved primitive name (as today); the fold only reshapes arity.
Two-operand calls are emitted unchanged, so existing programs are byte-for-byte identical.

### D3 — Left-associativity and evaluation order

Fold left so operands evaluate left-to-right and `-` subtracts in the correct order
(`(- 10 1 2)` = `7`). Each operand appears exactly once (no temps needed — unlike `or`,
the values flow straight into the binary calls).

## Risks / Trade-offs

- **`(-)` with zero args** → explicit arity error in `expand`, not a silent miscompile.
- **Interaction with the reserved-keyword set** → `+ - *` are already reserved primitive
  names; nothing new is reserved.
- **Must recurse operands** → the fold expands each operand via `expand` so nested forms
  (arithmetic inside `cond`, etc.) still work; covered by a demo.
