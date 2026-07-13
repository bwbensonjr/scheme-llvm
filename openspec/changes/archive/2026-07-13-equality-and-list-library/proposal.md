## Why

The language has identity equality (`eq?` / `eqv?`) but no *structural* equality, so there
is no way to compare two lists, two strings, or nested structure by value. That gap blocks
the list-search procedures that everyone reaches for — `member` and `assoc` are just
`memq`/`assq` with `equal?` instead of `eq?` — and it blocks writing tests and data-driven
code over compound values. This change adds `equal?` and the small list library that builds
on it (`member`, `assoc`) plus the two general list combinators the prelude is missing
(`filter`, `fold-left`/`fold-right`).

## What Changes

- **Runtime** — add `rt_equal`: a structural equality primitive that recurses over pairs and
  compares strings by codepoint content, falling back to `eqv?` identity for the immediate
  and interned types (fixnum, boolean, nil, symbol, character). Wired as the reserved
  primitive `equal?`.
- **Prelude** — add pure-Scheme library procedures built on the primitives:
  `member` / `assoc` (structural analogues of the existing `memq` / `assq`), `filter`, and
  the fold combinators `fold-left` and `fold-right`.
- **Naming decision** — the fold combinators are named `fold-left` / `fold-right` (R6RS,
  matching the Chez host), not SRFI-1 `fold` (see design D3).

## Capabilities

### New Capabilities
<!-- None: extends the existing equality/list facilities with new procedures. -->

### Modified Capabilities
- `core-language`: add structural equality `equal?` and the list-library procedures
  `member`, `assoc`, `filter`, `fold-left`, `fold-right`.

## Impact

- **Code:**
  - `src/runtime/runtime.c` — `rt_equal` (structural recursion; string byte/codepoint compare).
  - `src/parse.ss` — add `equal?` to `*prims*`.
  - `src/emit.ss` — add `equal?` to `prim-table` and emit its `declare` (arity 2).
  - `src/prelude.scm` — `member`, `assoc`, `filter`, `fold-left`, `fold-right`.
  - `demos/` — a demo covering `equal?` on nested/string structure and the list procedures.
- **Verification:** `demos/run-tests.sh` and `demos/run-backends.sh` (3-way) with the new
  demo; existing demos unaffected.
- **Unaffected:** value representation and the calling convention are unchanged (one new
  primitive + prelude procedures), so `aot-codegen` is untouched — this is a `core-language`
  addition.
- **Depends on:** nothing (Wave A; independent).
- **Enables:** any consumer needing value comparison or list search; recommended first of
  the near-term additive changes.
