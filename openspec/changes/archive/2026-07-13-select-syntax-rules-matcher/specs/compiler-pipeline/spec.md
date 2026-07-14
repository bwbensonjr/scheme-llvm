## ADDED Requirements

### Requirement: syntax-rules matcher selection is evidence-backed and recorded

The project SHALL record a decision on which `syntax-rules`-based pattern matcher replaces
the compiler's `syntax-case` `match`, supported by an empirical comparison rather than paper
analysis. Candidate matchers SHALL be filtered by hard gates (`syntax-rules`-only; coverage
of the pattern subset the passes use, including ellipsis-with-tail `(p ... plast)`; use of
no feature scheme-llvm lacks), the survivors SHALL be compared empirically, and the chosen
matcher SHALL be recorded together with the rationale and the exact expander work the
follow-on rewrite requires.

#### Scenario: Candidates are gated and scored

- **WHEN** the matcher selection is made
- **THEN** the candidate matchers considered are recorded with a pass/fail against the hard
  gates and a weighted score for the survivors (pass churn, expander work, test-suite reuse,
  size, maturity)

#### Scenario: Candidate constructs are validated against the real expander

- **WHEN** the top candidates are compared
- **THEN** representative matcher constructs (at minimum a flat pattern, an ellipsis pattern,
  and an ellipsis-with-tail pattern) are expanded against the actual expander and the results
  are recorded, including any construct the expander does not yet support
- **AND** if that spike is insufficient to decide, representative passes are ported and their
  emitted IR is checked byte-identical to the current baseline

#### Scenario: Decision is recorded with required expander work

- **WHEN** the comparison is complete
- **THEN** the change's design doc records the chosen matcher, the scores, the bake-off
  evidence, and the specific `syntax-rules` construct(s) (if any, e.g. the ellipsis escape
  `(... ...)`) that the expander must gain before the rewrite
