## Why

The compiler uses `let-values`/`values` ~21 times (e.g. `emit-repl-module` returns
`(values text name defd)`, `repl-scan-globals` returns `(values defd refd)`). scheme-llvm
has no multiple-values, so these sites block self-hosting (roadmap step 3). We either grow
real multiple values or avoid them by returning pairs.

## What Changes

Pick one path (see design), then apply it:

- **Grow:** add `values`, `call-with-values`, and the `let-values` derived form to the
  language (runtime + expander), with the standard single-value degenerate case; OR
- **Avoid:** refactor the ~21 `let-values` sites in the compiler to return and destructure
  ordinary pairs/lists, and drop the dependency entirely.

The design recommends a path; this proposal covers whichever is chosen.

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `core-language`: (grow path) Add multiple return values — `values`, `call-with-values`, and
  `let-values` — including the single-value degenerate case. (avoid path touches no spec —
  it's an internal refactor of the compiler and needs no capability change.)

## Impact

- **Grow path**: `src/runtime` (a values representation + `call-with-values` support),
  `src/passes/expand.ss` (`let-values` desugar), prim/keyword tables, `src/emit.ss`. Larger,
  but keeps the compiler source idiomatic.
- **Avoid path**: only the ~21 call sites in `compile.ss`/`emit.ss`/`parse.ss`; no
  language/runtime change. Smaller, but makes those sites less idiomatic.
- **Depends on**: nothing hard, but best after [[decompose-core-driver]] so the affected core
  sites are clearly delimited.
