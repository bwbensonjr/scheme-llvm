## 1. Decide the path (D1)

- [x] 1.1 Confirm avoid vs grow (design recommends AVOID). Record the decision in design.md. The tasks below branch on it.

## 2a. Avoid path (recommended)

- [x] 2a.1 Inventory the ~21 `let-values`/`values` sites (`compile.ss`, `emit.ss`, `parse.ss`).
- [x] 2a.2 Convert each `values`-returning helper to return a list/pair; update callers to destructure (plain `car`/`cadr` or the `,x` matcher).
- [x] 2a.3 Confirm no `let-values`/`values` references remain in the compiler; delete the core-language spec delta (no capability change on this path).

## 2b. Grow path (alternative)

<!-- N/A: AVOID path chosen (D1, 2026-07-13). -->
- [ ] 2b.1 Add a values representation + `call-with-values` support in the runtime.
- [ ] 2b.2 Add `let-values` desugar (→ `call-with-values` + lambda) in the expander; register keywords.
- [ ] 2b.3 Wire `values`/`call-with-values` into prim/emit; keep the single-value degenerate case.

## 3. Verification

- [x] 3.1 Run `./run-all-tests.sh`; confirm all suites pass (behavior-preserving either way).
