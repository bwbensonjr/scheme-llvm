## ADDED Requirements

### Requirement: Compiler core assembles into a callable in-process entry

The project SHALL provide a way to assemble the compiler core into a program whose
C-callable entry compiles Scheme source text to LLVM IR text in-process and returns that
IR as a value, using the same compiler core as the batch compiler. The assembly SHALL bake
in the standard prelude so the embedded compiler performs prelude-correct compilation with
no filesystem access.

#### Scenario: The assembled entry returns emitted IR

- **WHEN** the core is assembled in embedded-entry mode, linked, and its entry is called
  with a Scheme program supplied as source text
- **THEN** the entry returns a string whose contents are the emitted core IR for that
  program (with the prelude applied), and no target header is included

#### Scenario: The embedded entry shares the batch compiler core

- **WHEN** the embedded entry and the batch compiler are each given the same program
- **THEN** they produce the same core IR, because they are the same assembled core with
  different entry points

#### Scenario: Prelude shadowing matches the batch driver

- **WHEN** a program redefines a name also defined by the prelude and is compiled by the
  embedded entry
- **THEN** the user's definition wins (user-wins shadowing), identically to the batch
  driver's `with-prelude` behavior

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
the same program, because they share one compiler core. There SHALL NOT be a separate
compilation path for the runner.

#### Scenario: Runner output matches AOT output

- **WHEN** the same program is run through the in-process runner and compiled-and-run
  through the batch AOT path
- **THEN** both print the same value

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
