# compiler-pipeline Specification

## Purpose

Defines how the compiler's pass pipeline is structured and justified: the choice of
framework for expressing passes (nanopass versus stylized hand-rolled Scheme), and the
documented boundary between the frontend passes the compiler owns and the work delegated
to LLVM.

## Requirements

### Requirement: Pass-pipeline framework decision is evidence-backed and recorded

The project SHALL record a decision on how the compiler's pass pipeline is expressed —
the nanopass framework versus stylized hand-rolled Scheme — supported by a direct
comparison of representative passes translated both ways, together with the rationale
and the scoring that produced it.

#### Scenario: Representative passes are translated both ways

- **WHEN** the framework decision is made
- **THEN** at least three representative Chez passes (a trivial-traversal pass, an
  assignment-conversion pass, and a closure-conversion pass) have been translated into
  both nanopass and stylized hand-rolled Scheme
- **AND** each pair produces equivalent output on the same shared test inputs

#### Scenario: Decision is recorded with rationale

- **WHEN** the comparison is complete
- **THEN** the frontend/pass-ladder design doc records the chosen framework, the
  scoring (line count, boilerplate share, readability, safety lost), and the rationale
- **AND** `LLVM.md`'s framing of the pass pipeline is consistent with the recorded
  decision

### Requirement: Frontend pass-ladder and LLVM boundary are documented

The project SHALL document the transferable frontend pass spine
(`read → expand → core → assignment-conv → closure-conv → lambda-lift → emit .ll`) and
the boundary below which LLVM subsumes the work (ANF, calling conventions, basic-block
layout, instruction selection, register allocation, code generation).

#### Scenario: Pipeline doc distinguishes owned passes from LLVM-subsumed work

- **WHEN** the frontend/pass-ladder design doc exists
- **THEN** it identifies which passes the compiler owns and which are delegated to LLVM
- **AND** it notes that the minimal subset requires neither CPS nor ANF, with CPS tied
  to future `call/cc` support

### Requirement: Standard prelude prepended to programs

The compiler SHALL support a standard **prelude** — a file of Scheme definitions — whose
top-level forms are prepended to every compiled program's forms before the program is
assembled, so prelude definitions are in scope for every program. If a user program defines
a name the prelude also defines, the user's definition SHALL win (the prelude's definition
for that name is dropped), so the prelude never collides with or clobbers user code. The
compiler SHALL provide a way to compile a program without the prelude.

#### Scenario: Prelude procedures are available to a program

- **WHEN** a program that defines none of the prelude names calls a prelude procedure (e.g.
  `(map f (list 1 2 3))`)
- **THEN** it compiles and runs using the prelude's definition, producing the correct result

#### Scenario: User definitions shadow the prelude

- **WHEN** a program defines a name that the prelude also defines
- **THEN** the program's definition is used and the prelude's definition of that name is
  dropped (no duplicate-binding error), and the program produces the result of its own
  definition

#### Scenario: Prelude can be disabled

- **WHEN** a program is compiled with the prelude disabled
- **THEN** it is compiled from its own forms alone, and a program that does not reference any
  prelude procedure produces the same result as with the prelude enabled

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
