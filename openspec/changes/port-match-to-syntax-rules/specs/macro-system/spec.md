## ADDED Requirements

### Requirement: syntax-rules can host a runtime pattern matcher

The `syntax-rules` expander SHALL be powerful enough to host a pattern matcher defined as
`syntax-rules` macros — one that expands to runtime destructuring code over lists. In
particular the expander SHALL support the constructs that such a matcher requires: recursive
macro expansion to bounded depth, ellipsis patterns with a fixed tail (`(p ... tail)`), and
the ellipsis escape `(... ...)` (which yields a literal `...` in expansion output so a
matcher macro can generate templates that themselves contain ellipsis).

#### Scenario: Ellipsis escape yields a literal ellipsis

- **WHEN** a transformer template contains `(... ...)` (the ellipsis escape)
- **THEN** the expansion produces a literal `...` at that position rather than treating it
  as a repetition marker

#### Scenario: A syntax-rules matcher expands and runs

- **WHEN** the adopted `syntax-rules` matcher is loaded and used to expand a flat pattern
  `(match x [(a b) …])`, an ellipsis pattern `(match x [(a b ...) …])`, and an
  ellipsis-with-tail pattern `(match x [(a ... z) …])`
- **THEN** each expands without error and, when run, binds the pattern variables correctly
  and selects the intended clause

#### Scenario: Ellipsis-with-tail destructures a runtime list

- **WHEN** the matcher matches `(p ... plast)` against a runtime list of length n ≥ 1
- **THEN** `p` captures the first n−1 elements in order and `plast` captures the final
  element
