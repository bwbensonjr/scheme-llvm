## Why

The compiler's own source uses `cadr`/`caddr`/`cddr`/… ~78 times and `case` in the passes,
but scheme-llvm provides neither (only `car`/`cdr` primitives; `cond`/`when`/`unless`/`let*`
are the only derived forms in the prelude). These are the cheapest self-hosting wins
(roadmap step 1): pure `syntax-rules`/prelude additions, no runtime changes, no risk.

## What Changes

- Add the common **c…r combinators** to `src/prelude.scm` as procedures over `car`/`cdr`:
  `caar cadr cdar cddr caaar … cddddr` (at least the depth-2 and depth-3 forms the compiler
  uses).
- Add **`case`** as a `syntax-rules` derived form (expanding to `cond` + `memv`/`eqv?`
  chains), alongside the existing derived forms.

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `core-language`: Extend the standard prelude with the cxr combinators, and add `case` to
  the supported derived syntactic forms.

## Impact

- **Code**: `src/prelude.scm` (cxr defs; `case` macro). No runtime or emit changes.
- **Enables**: shrinks the compiler's dependency on Chez built-ins (self-hosting). Also
  immediately usable by any program.
- **Independent** of the other self-hosting steps; can land anytime.
