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
