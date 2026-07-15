## MODIFIED Requirements

### Requirement: The core is assembled into a single self-hostable program

There SHALL be a repeatable step that assembles the compiler core into one program in the
language scheme-llvm accepts — containing no `library`/`import`/`include` forms, with the source
reader provided by the in-language `read-all-from-string` — so the core can be fed to
scheme-llvm as a single compilation unit. This assembly step SHALL NOT require Chez: the core
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

### Requirement: Compiled compiler replaces Chez at compile time (path C)

Compiling a program SHALL require no Chez. The compiled `schemec` (source text → LLVM IR) and
the in-process runner `scheme-run` (source text → run) SHALL be buildable from committed IR with
only LLVM, and SHALL be the standard way to compile and run programs. A Chez-free path SHALL
exist to produce a standalone native executable from a program's source (for example
`scheme-run --emit` piped to `clang`), honoring standalone executables as a first-class
deliverable. The REPL host's removal of Chez is delivered separately by path A (in-process
embedding).

#### Scenario: A program is compiled and run without Chez

- **WHEN** a program is compiled and run through `scheme-run` (or `schemec` + `clang`) on a
  machine without Chez
- **THEN** compilation and execution complete with no Chez process, and the result matches the
  result the Chez-hosted driver produces for that program

#### Scenario: A standalone executable is produced without Chez

- **WHEN** a program's source is compiled to a native executable using only the committed
  compiler IR and LLVM (no Chez)
- **THEN** a standalone binary is produced whose output matches the AOT build's output

## ADDED Requirements

### Requirement: Committed self-compiled compiler artifacts are the authoritative form

The compiler's own emitted IR — for the batch compiler (`schemec`), the in-process runner
(`embed`), and the interactive REPL (`embed-repl`) — SHALL be checked into the repository as
host-agnostic stage-0 artifacts and SHALL be the favored, authoritative form from which the
binaries are built. These artifacts SHALL be produced by the compiled compiler itself (the
self-hosting fixed point), not only by the Chez-hosted compiler, so that they can be regenerated
without Chez.

#### Scenario: Binaries build from committed IR without Chez

- **WHEN** the repository is checked out on a machine with only LLVM and libgc, and the default
  build is run
- **THEN** the compiler, runner, and REPL binaries are produced by linking the committed IR with
  the runtime, and no Chez process is invoked and no regeneration is attempted

#### Scenario: Committed IR is self-produced

- **WHEN** the committed compiler IR is regenerated
- **THEN** it is emitted by the compiled compiler (`schemec` / `scheme-run`) over the assembled
  source, reaching the same byte-identical fixed point the triple test asserts

### Requirement: The compiler is regenerable from source without Chez

A developer SHALL be able to change the compiler source (for example add a primitive, a pass, or
module support) and rebuild the committed compiler IR and all binaries using only LLVM and libgc
— no Chez. This regeneration SHALL be an explicit, opt-in step (distinct from the default build,
which only links committed IR), and after it the rebuilt compiler SHALL compile programs with the
changed behavior.

#### Scenario: A compiler-source change is rebuilt Chez-free

- **WHEN** a developer edits a compiler source file and runs the regeneration step on a machine
  without Chez
- **THEN** the assembled program is reconcatenated, the compiled compiler re-emits the committed
  IR, the binaries relink, and a program exercising the change compiles with the new behavior —
  all with no Chez process

### Requirement: A Chez-gated check guarantees the committed IR is not stale

Because the default build links committed IR and does not auto-regenerate on source change, there
SHALL be a check — permitted to require Chez, and intended for CI — that regenerates the compiler
IR from the current source in a clean tree and asserts it is byte-identical to the committed IR.
This check SHALL fail if a compiler-source change was not accompanied by regeneration, and SHALL
serve as an independent (second-host) re-derivation of the self-hosting fixed point.

#### Scenario: Un-regenerated compiler change is caught

- **WHEN** the compiler source is changed but the committed IR is not regenerated, and the
  trust-check runs
- **THEN** the check regenerates the IR and reports a mismatch against the committed IR, failing

#### Scenario: An independent host reproduces the fixed point

- **WHEN** the trust-check rebuilds the compiler from the frozen genesis source under Chez
- **THEN** it reaches the same committed byte-identical fixed point, confirming the committed IR
  is faithfully derived from source
