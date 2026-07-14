## ADDED Requirements

### Requirement: Pass pattern-matching depends only on syntax-rules

The pattern-matching facility used to express the compiler's passes SHALL be implementable
with `syntax-rules` alone and SHALL NOT depend on `syntax-case` or any other procedural-macro
facility. This keeps the compiler's own source within reach of scheme-llvm's expander (a
self-hosting enabler). The hand-rolled pass-framework decision is unchanged; only the
matcher's macro-level requirements are constrained.

#### Scenario: The matcher carries no syntax-case dependency

- **WHEN** the compiler source is inspected after this change
- **THEN** no pass or matcher module imports or uses `syntax-case`, `with-syntax`,
  `generate-temporaries`, `datum`, or quasisyntax, and the previous `syntax-case`-based
  `match` module is removed

#### Scenario: Passes behave identically under the new matcher

- **WHEN** the full test suite (`./run-all-tests.sh`) is run after the passes are rewritten
  to the `syntax-rules` matcher
- **THEN** all suites pass, and emitted IR / program results are unchanged from before the
  change (the port is behavior-preserving)

#### Scenario: A single matcher serves host and self-hosted builds

- **WHEN** the matcher is chosen and integrated
- **THEN** the same matcher module is used by the host (Chez) build and is expressible by
  scheme-llvm's own expander, so there is no separate host-only matcher to diverge
