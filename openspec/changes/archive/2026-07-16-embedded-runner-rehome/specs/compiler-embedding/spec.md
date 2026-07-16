## MODIFIED Requirements

### Requirement: Compiler core assembles into a callable in-process entry

The project SHALL provide a way to assemble the compiler core into a program whose
C-callable entry compiles Scheme source text to LLVM IR text in-process and returns that
IR as a value, using the same compiler core as the batch compiler. Instead of prepending the
prelude as source text, the assembled entry SHALL re-home the prelude as the library
`(scheme base)`: from the compiler's **baked-in prelude source** — with no filesystem access —
it SHALL compile `(scheme base)` into a library artifact and export table, compile the user
program as if it began with `(import (scheme base))` via the same `compile-program-with-imports`
machinery the batch driver uses, and merge the derived-form macros into the program's
`macro-env` at expand time. The entry SHALL return two emitted modules separated by a fixed
boundary marker (a line that cannot occur in emitted core IR): the `(scheme base)` library IR,
the marker, then the program IR, with no target header on either. The host SHALL split on the
marker and treat the two as separate LLVM modules (they cannot be merged into one — each emits a
fixed `@__apply0` and reset string globals that would collide). Unless `--no-prelude` is in
effect, this re-homed behavior applies; `--no-prelude` SHALL skip both halves and emit only the
program (no marker).

#### Scenario: The assembled entry returns emitted IR

- **WHEN** the core is assembled in embedded-entry mode, linked, and its entry is called
  with a Scheme program supplied as source text
- **THEN** the entry returns a string containing the emitted `(scheme base)` library IR, a
  boundary marker, then the program's core IR (the program referencing `scheme.base` external
  globals for prelude procedures), and no target header is included on either module

#### Scenario: The embedded entry shares the batch compiler core

- **WHEN** the embedded entry and the batch Chez driver are each given the same prelude-using
  program
- **THEN** they produce the same core IR for the program, because both compile it through the
  same `compile-program-with-imports` path with `(scheme base)` auto-imported — the embedded
  entry differs only in assembling `(scheme base)` from baked-in source rather than reading it
  from disk

#### Scenario: Prelude shadowing matches the batch driver

- **WHEN** a program redefines a name also defined by the prelude and is compiled by the
  embedded entry
- **THEN** the user's definition wins (user-wins shadowing), identically to the batch driver,
  because the program's own top-level define takes precedence over the auto-imported
  `(scheme base)` binding in the Stage 0 resolution order

### Requirement: The embedded runner agrees with the batch path (dev→ship fidelity)

The in-process runner and the batch AOT path SHALL produce the same observable result for
the same program, because they share one compiler core and one prelude re-homing. There
SHALL NOT be a separate compilation path for the runner: a prelude-using program SHALL resolve
its prelude procedures through `(scheme base)` on the embedded runner exactly as on the Chez
batch driver, not through a prepended prelude.

#### Scenario: Runner output matches AOT output

- **WHEN** the same program is run through the in-process runner and compiled-and-run
  through the batch AOT path
- **THEN** both print the same value

#### Scenario: Runner emitted IR matches the Chez driver

- **WHEN** the same prelude-using program is compiled by `scheme-run --emit` (Chez-free) and by
  the Chez batch driver
- **THEN** the program's emitted core IR is byte-identical between the two paths — the runner no
  longer inlines the prelude's definitions but references `(scheme base)` exports as the Chez
  driver does

## ADDED Requirements

### Requirement: The runner supports --no-prelude parity

The runner (`scheme-run` and `bin/scheme-compile`) SHALL accept `--no-prelude` and forward it to
the embedded entry through the smallest viable channel (an environment variable the entry reads
via a runtime primitive). With `--no-prelude`, the entry SHALL skip the `(scheme base)`
auto-import and the derived-form macro merge, emit only the program IR, and leave prelude names
unbound — matching the Chez batch driver's `--no-prelude`. The runner's single-module IR handling
(JIT for `scheme-run`, clang link for `scheme-compile`) SHALL be otherwise unchanged.

#### Scenario: --no-prelude skips the (scheme base) auto-import on the runner

- **WHEN** a program that references a prelude procedure is run through `scheme-run --no-prelude`
- **THEN** the embedded entry emits no `(scheme base)` IR and the reference is an unbound-variable
  error, exactly as under the Chez driver's `--no-prelude`

#### Scenario: --no-prelude on the runner matches the driver's --no-prelude

- **WHEN** the same program is compiled with `bin/scheme-compile --no-prelude` and with the Chez
  driver's `--no-prelude`
- **THEN** both emit only the program IR (no `(scheme base)`) and agree on the observable result
