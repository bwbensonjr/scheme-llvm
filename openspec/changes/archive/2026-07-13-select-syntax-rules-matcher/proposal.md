## Why

Removing the compiler's `syntax-case`-based `match` (`src/match.sls`) is a prerequisite for
self-hosting, but *which* `syntax-rules` matcher to adopt is an open, consequential
decision — and research shows no off-the-shelf matcher has all three properties we want at
once (the nanopass `,x` convention → zero pass churn; `syntax-rules`-only; ellipsis
including `(p ... plast)`):

- **SRFI-241** — `,x` convention ✅, ellipsis ✅, but reference impl needs `syntax-case` ❌.
- **`pmatch`** — `,x` convention ✅, `syntax-rules` ✅, but no ellipsis ❌.
- **SRFI-204 / Shinn `match.scm`** — `syntax-rules` ✅, ellipsis ✅, but Wright convention
  (rewrite all pass patterns) ❌.

So the real choice is **buy** (adopt Shinn/SRFI-204, pay in a pattern rewrite) vs **build**
(author a `,x` + `syntax-rules` + ellipsis matcher, pay in matcher authorship). Both likely
require our expander to gain the ellipsis-escape `(... ...)`. This decision should be made
on evidence, not on paper — so this change is the *first step*: choose the matcher and prove
feasibility, before the follow-on change ([[port-match-to-syntax-rules]]) does the rewrite.

## What Changes

- Enumerate and gate candidate `syntax-rules` matchers against hard filters
  (`syntax-rules`-only; covers the used pattern subset incl. `(p ... plast)`; uses no
  feature scheme-llvm lacks).
- Score the survivors on weighted criteria (pass churn, expander work, test-suite reuse,
  size/auditability, maturity, license).
- Run an empirical **bake-off**: for the top buy and top build candidate, spike the
  expander (expand flat / ellipsis / ellipsis-with-tail probes) and port two representative
  passes (`convert-assignments.ss` and `emit.ss`), diffing emitted IR against baseline
  (must be byte-identical).
- **Record the decision** in `design.md`: the chosen matcher, the scores, the bake-off
  evidence, and exactly what expander work (if any) the rewrite will require.
- No production rewrite and no committed compiler behavior change — this change produces a
  decision and de-risking evidence only (throwaway/spike code is not integrated).

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `compiler-pipeline`: Add a requirement that the `syntax-rules` matcher selection is
  evidence-backed and recorded — mirroring the existing "Pass-pipeline framework decision
  is evidence-backed and recorded" requirement (representative passes tried, output
  equivalence checked, decision + rationale recorded).

## Impact

- **Deliverable**: a recorded decision (chosen matcher + required expander work) that
  becomes the input to [[port-match-to-syntax-rules]]. That follow-on change's task group 1
  ("select the matcher") and its expander spike are subsumed here and should be trimmed to
  "consume this decision" when this change lands.
- **Code**: only throwaway spike/bake-off artifacts (kept under the change or a scratch
  location), not integrated into `src/`. No change to runtime, emit output, `match.sls`, or
  the passes yet.
- **Research inputs**: SRFI-241, SRFI-204, SRFI-200 (survey), Alex Shinn's `match.scm`,
  `pmatch` — surface syntax and `syntax-rules` requirements verified against source.
