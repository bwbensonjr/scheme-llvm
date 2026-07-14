## ADDED Requirements

### Requirement: Compiler core assembles into a callable in-process entry

The project SHALL provide a way to assemble the compiler core into a unit exposing a
C-ABI-callable entry that compiles Scheme source text to LLVM IR text in-process — a
sibling of the existing stdin→stdout filter entry — so the compiler can be invoked as a
function rather than run as a program. The entry SHALL accept the source text of one or
more forms and SHALL return the emitted core IR text, using the same compiler core as the
stdin→stdout filter and the batch compiler.

#### Scenario: Assembling the core with the callable entry

- **WHEN** the assembly step runs over the core sources in callable-entry mode
- **THEN** it produces a unit whose entry, given the bytes of a Scheme form, returns the
  same core IR text the batch compiler emits for that form (modulo the target header and
  prelude, which remain the driver's responsibility)

#### Scenario: The callable entry shares the batch compiler core

- **WHEN** the callable entry and the batch compiler are each given the same source
- **THEN** both produce byte-identical core IR, because they are the same assembled core
  with different entry points

### Requirement: The persistent JIT host embeds the compiler and compiles in-process

The persistent JIT host SHALL embed the compiled compiler and SHALL compile each entered
form by calling the compiler in-process, with no Chez Scheme process and no per-form
subprocess. For each entered form the host SHALL obtain the emitted IR from the embedded
compiler and then add and execute it through the host's existing add-module / lookup /
call path.

#### Scenario: A form is compiled and evaluated without Chez

- **WHEN** a form is entered in `--repl` and no Chez Scheme process is running
- **THEN** the host compiles the form via the embedded compiler, executes the resulting
  IR, and prints the form's value

#### Scenario: No per-form subprocess is spawned

- **WHEN** a sequence of forms is entered in one REPL session
- **THEN** each form is compiled by a function call within the host process, with no
  process fork/exec per form

### Requirement: Embedded compiler state persists across forms

The embedded compiler's mutable compilation state — including its name-generation counter
and interned symbols — SHALL persist across successive compile calls within one REPL
session, so that incremental per-form compilation composes without reinitializing the
compiler between forms.

#### Scenario: Generated names do not collide across forms

- **WHEN** two forms that each cause the compiler to generate fresh internal names are
  entered in the same session
- **THEN** the names generated for the second form do not collide with those generated for
  the first, because the compiler's name counter advanced rather than resetting

### Requirement: REPL and batch compilation share one compiler core (dev→ship fidelity)

Interactive (`--repl`) and batch compilation SHALL use the same compiler core, so that
code developed and tested interactively compiles to a standalone executable with the same
core IR. There SHALL NOT be a separate REPL-only compilation path.

#### Scenario: Interactive and batch agree on emitted IR

- **WHEN** the same top-level definition is compiled once via the embedded REPL compiler
  and once via the batch compiler
- **THEN** the emitted core IR for that definition is identical (modulo the target header
  and prelude supplied by the driver)

### Requirement: The compiler still emits textual IR consumed by the host

The embedded compiler SHALL return LLVM IR as text, and the host SHALL parse that text
into a module. Embedding SHALL NOT replace the textual-IR boundary with direct in-memory
IR construction.

#### Scenario: Emitted IR remains inspectable text

- **WHEN** the embedded compiler compiles a form
- **THEN** its output is LLVM IR text that the host parses with the IR text parser, the
  same form of IR the batch path emits and `--dump` exposes
