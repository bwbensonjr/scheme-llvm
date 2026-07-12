## Why

The arithmetic primitives `+ - *` are binary-only — they compile to binary C calls
(`rt_add(a,b)` …). Writing `(+ a b c)` silently passes extra args to a 2-arg function
(the bug the `derived-forms` demo hit, forcing nested `(+ x (+ y …))`). Real Scheme code —
and the compiler's own source — uses n-ary arithmetic constantly. This is a cheap,
frontend-only fold with no runtime or ABI change.

## What Changes

- Extend the existing `expand` pass to fold n-ary `+`, `-`, `*` into nested **binary**
  primcalls, with the standard identities/edge cases:
  - `(+)` → `0`, `(+ a)` → `a`, `(+ a b c …)` → `(+ (+ a b) c) …)` (left fold)
  - `(*)` → `1`, `(* a)` → `a`, `(* a b c …)` → left fold
  - `(- a)` → `(- 0 a)` (unary negation), `(- a b c …)` → left fold; `(-)` is an error
- **No runtime, ABI, or backend change** — the folded output is the same binary
  `primcall`s the compiler already emits.
- **Deferred (noted):** n-ary comparisons `(= a b c)` / `(< a b c)` as chained
  comparisons — they need single-evaluation temps (like `or`) and are a separate small
  follow-on.

## Capabilities

### New Capabilities
<!-- None: n-ary arithmetic folds into the existing binary primitives. -->

### Modified Capabilities
- `core-language`: add a requirement that the arithmetic operators `+ - *` accept any
  number of arguments (with the standard identities and unary `-` as negation),
  evaluating to the same result as the left-folded binary form.

## Impact

- **Code (frontend only):** `src/passes/expand.ss` — add n-ary arithmetic folding
  alongside the derived-form rewrites; `demos/` + `demos/run-tests.sh`.
- **Unaffected:** runtime, emitter, calling convention, and all other passes.
- **Relationship to variadic:** independent. This is a compile-time fold to binary prims,
  not first-class variadic `+`; if `+` ever needs to be a first-class variadic *value*,
  that builds on the separate variadic/`apply` work.
