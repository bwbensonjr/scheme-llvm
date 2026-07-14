## 1. Gate the candidates (Stage A)

- [x] 1.1 For each candidate — SRFI-204/Shinn `match.scm`, `pmatch`, SRFI-241 — verify against source/SRFI text: implementation macro style (`syntax-rules` vs `syntax-case`), pattern convention (`,x` vs Wright), ellipsis + `(p ... plast)` support, and license. — Verified via SRFI texts + source; recorded in design "Decision".
- [x] 1.2 Apply the hard gates (G1 syntax-rules-only; G2 covers the used subset incl. `(p ... plast)`; G3 no feature scheme-llvm lacks; license). Record each candidate's pass/fail with a one-line reason.
- [x] 1.3 Confirm the surviving set is {Shinn/SRFI-204 (buy)} and {a `,x` matcher: pmatch+ellipsis or SRFI-241-ported (build)}; note any candidate eliminated and why.

## 2. Score the survivors (Stage B)

- [x] 2.1 Score each survivor on the weighted criteria (pass churn ×3, expander work ×2, test-suite reuse ×2, size/auditability ×2, maturity ×1); record the table.

## 3. Bake-off (Stage C)

- [x] 3.1 Expander spike: expand the three probes in the current `src/passes/expand.ss`; record pass/fail and any missing construct. — DONE empirically (probes A/B/C): escape unsupported; `,x` non-ellipsis matcher works with no extension; ellipsis needs the escape.
- [x] 3.2 Port `src/passes/convert-assignments.ss` ... — SKIPPED per accepted decision: the expander spike (3.1) was decisive; the full dual-port bake-off is not needed to select the matcher. Effort quantification deferred into the port change.
- [x] 3.3 Port `src/passes/emit.ss` ... — SKIPPED per accepted decision (same rationale).
- [x] 3.4 Build the ported passes and diff emitted IR ... — SKIPPED per accepted decision (same rationale).

## 4. Record the decision (Stage D)

- [x] 4.1 Update this change's `design.md` with the chosen matcher, the gate results, the weighted scores, and the bake-off (spike) evidence.
- [x] 4.2 State the exact expander work the rewrite requires (add `(... ...)` escape) so it can be scoped in the follow-on change.
- [x] 4.3 Update [[port-match-to-syntax-rules]]: trim its selection/spike tasks to "consume the recorded decision". — Done in the prior session.
