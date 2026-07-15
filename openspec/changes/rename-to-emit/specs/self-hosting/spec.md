## MODIFIED Requirements

### Requirement: The core is assembled into a single self-hostable program

There SHALL be a repeatable step that assembles the compiler core into one program in the
language Emit accepts — containing no `library`/`import`/`include` forms, with the source
reader provided by the in-language `read-all-from-string` — so the core can be fed to
Emit as a single compilation unit. This assembly step SHALL NOT require Chez: the core
sources SHALL already be in a flat, concatenation-ready form (top-level `define-syntax`/`define`s
with no `library` wrappers, no `include`s, and no top-level name collisions), so that assembling
the program is ordered concatenation of the source files with a chosen entry, performable with
LLVM-era tooling alone. The Chez assembler (`tools/assemble-core.ss`) MAY be retained as
historical/reproduction tooling but SHALL NOT be on the default build path.

#### Scenario: Assembled core is a single subset program

- **WHEN** the assembly step runs over the core sources
- **THEN** it produces one file containing no `library`/`import`/`include` forms, and that file
  behaves like the core when run under the embedded compiler

#### Scenario: Assembly requires no Chez

- **WHEN** the compiler is assembled on a machine with only LLVM and libgc installed (no Chez)
- **THEN** the flat program is produced by concatenating the checked-in flat source files with
  the chosen entry, and no Chez process is invoked

### Requirement: Remaining self-hosting gaps are fully enumerated

Compiling the assembled core with Emit SHALL yield a complete inventory of the
constructs the language does not yet accept, each classified (missing primitive, missing
prelude procedure, unsupported special form, or reader gap) and assigned a fix path, recorded
as the self-hosting gap backlog.

#### Scenario: Gap inventory is complete and sized

- **WHEN** the sweep has compiled the assembled core as far as it can
- **THEN** every remaining unsupported construct is recorded in the self-hosting gap list with
  a location and a fix path, so no further gap is discovered ad hoc during the stage-1 build

### Requirement: The compiler core compiles its own source

The compiler core SHALL be expressible in the language Emit accepts, such that the
core's own source can be compiled by Emit to produce a working compiler. Building the
core with the host-hosted compiler SHALL yield a native `schemec` that maps source text to
LLVM IR without Chez at compile time.

#### Scenario: Core builds to a native compiler

- **WHEN** the core source is compiled by the (Chez-hosted) compiler
- **THEN** a native `schemec` is produced that, given a program's source text, emits the same
  IR the Chez-hosted compiler emits for that program

### Requirement: Self-compilation reaches a stable fixed point

Compiling the compiler source with self-built `schemec` binaries SHALL reproduce the compiler:
the IR emitted for the source by stage-1 `schemec` (call it stage-2), linked into `schemec2`
and used to recompile the source (stage-3), SHALL yield stage-2 byte-identical to stage-3 (the
triple test). This fixed point across self-compiled binaries is the acceptance criterion for
self-hosting.

The stage-1 IR emitted by the *Chez-hosted* compiler is NOT required to match stage-2: Chez and
Emit are different host runtimes and intern the constant pool in different orders, so
stage-1 legitimately differs. The compiler converges after one recompile off Chez, not zero.

#### Scenario: Stage-2 and stage-3 IR are identical

- **WHEN** the compiler source is compiled by stage-1 `schemec` (yielding stage-2), and stage-2
  is linked into `schemec2` and used to recompile the same source (yielding stage-3)
- **THEN** the stage-2 and stage-3 IR outputs are byte-identical
