# compiler-embedding Specification

## Purpose

Defines how the compiler core is embedded as a callable, in-process compiler: assembling the
core into a program whose C-callable entry compiles Scheme source text to LLVM IR text
in-process (with the standard prelude baked in), and a runner that JIT-compiles and executes
a whole program in a single process without spawning Chez Scheme, `clang`, or `lli`. It also
fixes the fidelity, textual-IR, and host-agnostic artifact guarantees that make the embedded
path a faithful, portable stand-in for the batch path.

## Requirements

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

### Requirement: A runner compiles and runs a whole program in one process

The project SHALL provide a runner that embeds the compiled compiler and executes a whole
Scheme program in a single process: it SHALL obtain the program's IR from the embedded
compiler in-process, JIT-compile and run that IR, and print the program's value — with no
Chez Scheme process, no `clang`/`lli`, and no per-run subprocess.

#### Scenario: A program is compiled and run in-process

- **WHEN** a Scheme program is supplied to the runner as source
- **THEN** the runner prints the program's value, having compiled it via the embedded
  compiler and JIT-executed the emitted IR without spawning Chez, `clang`, `lli`, or any
  other subprocess

#### Scenario: The runner reads IR bytes from the embedded compiler

- **WHEN** the embedded compiler returns the emitted IR as a string value
- **THEN** the runner reads that string's bytes through the runtime's exported string
  accessors and parses them into an LLVM module for JIT execution

#### Scenario: A runtime trap is reported without aborting abruptly

- **WHEN** the running program triggers a runtime trap (for example an arity error)
- **THEN** the runner reports the trap message rather than crashing the process silently

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

### Requirement: The embedded compiler still emits textual IR

The embedded compiler SHALL return LLVM IR as text, and the runner SHALL parse that text
into a module. Embedding SHALL NOT replace the textual-IR boundary with direct in-memory IR
construction.

#### Scenario: Emitted IR remains inspectable text

- **WHEN** the embedded compiler compiles a program
- **THEN** its output is LLVM IR text — the same form of IR the batch path emits and
  `--dump` exposes — which the runner parses with the IR text parser

### Requirement: The embedded compiler artifact is host-agnostic and committed

The generated embedded-compiler IR artifact SHALL contain no host target header, so it is
cross-platform, and it SHALL be committed to the repository at a tracked path so a checkout
without Chez can build the runner from it. The build SHALL regenerate the artifact when the
compiler core sources change.

#### Scenario: A Chez-free checkout builds the runner

- **WHEN** the repository is checked out on a supported platform without Chez available and
  the runner is built
- **THEN** the build links the committed embedded-compiler IR and produces a working runner,
  because the committed IR carries no platform-specific target header

#### Scenario: A compiler-source change regenerates the artifact

- **WHEN** a compiler core source is changed and the runner is rebuilt
- **THEN** the embedded-compiler IR artifact is regenerated from the updated sources before
  the runner is linked

### Requirement: Stateful incremental per-form compilation entry

The embedded compiler SHALL expose an entry that compiles one entered form at a time,
maintaining its compilation state (REPL environment, macro environment, known-names set, and
form counter) across successive calls within one process, so that a form can reference
bindings and macros established by earlier forms. The entry SHALL return, for a successfully
compiled form, both the emitted IR and the name of that form's entry thunk (the entry-name
handshake), so the host looks up exactly the symbol the compiler chose rather than predicting
it.

#### Scenario: A later form sees an earlier definition, compiled in-process

- **WHEN** `(define x 41)` is compiled by the entry and then `(+ x 1)` is compiled as a
  separate call
- **THEN** the second call succeeds with `x` resolved to the earlier binding, and returns the
  IR together with the entry-thunk name for the host to run

#### Scenario: The compiler reports the entry-thunk name

- **WHEN** the entry compiles a form
- **THEN** it returns the form's entry-thunk symbol name alongside the IR, and the host
  resolves that exact name

### Requirement: Compile-error recovery preserves the session

When compiling one form raises an error, the embedded compiler SHALL restore the compilation
state it held before that form and report the error, so that a subsequent form compiles as if
the failed form had never been entered. This recovery SHALL be expressed with the in-language
exception facility (`guard`), not by aborting the process.

#### Scenario: A bad form does not corrupt the session

- **WHEN** a form that fails to compile (for example, one referencing an unbound variable) is
  entered, followed by a valid form
- **THEN** the failed form is reported, the compiler's state is unchanged by it, and the valid
  form compiles and runs normally

#### Scenario: Recovery uses in-language guard

- **WHEN** the embedded compiler compiles a form that raises during expansion or lowering
- **THEN** the raise is caught in-language and the pre-form state is restored, rather than the
  raise reaching the outermost trap and ending compilation

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
