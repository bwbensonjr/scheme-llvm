## MODIFIED Requirements

### Requirement: One emitted IR drives AOT, JIT, and bitcode exits

The compiler SHALL take the same emitted modular artifact set — the program module plus its linked
libraries (the transitive import closure, including the auto-imported `(scheme base)` when the
prelude is enabled) — to three interchangeable whole-program exits: a native executable (AOT),
in-process batch JIT execution via `lli`, and a bitcode artifact, without changes to the emitted IR
or the C runtime between exits. All three exits SHALL resolve the prelude through `(scheme base)`
and program imports through the manifest identically — there is one compilation path, not a
per-backend one; JIT and bitcode SHALL NOT prepend the prelude or fail on `import` forms. A
library-free program compiled `--no-prelude` legitimately reduces to a single self-contained module
on every exit. AOT SHALL remain the default exit. In addition, the compiler SHALL support an
interactive exit in which per-form IR modules are added incrementally to a single long-lived LLVM
ORC/LLJIT host process (see the `interactive-repl` capability); this interactive exit is distinct
from the batch `lli` exit, which runs one whole-program module set and terminates. A REPL session
and a batch build SHALL produce the same value for the same sequence of forms.

#### Scenario: JIT execution via lli

- **WHEN** a demo program is built with the batch JIT backend selected
- **THEN** the compiler links the runtime and every unit of the modular set (the program plus its
  libraries, including `(scheme base)`) at the IR level and runs it via `lli` (resolving `libgc`),
  and the run reports the program's value — the same value the AOT executable reports

#### Scenario: Bitcode emission

- **WHEN** a demo program is built with the bitcode backend selected
- **THEN** the compiler writes a `.bc` bitcode artifact from the same emitted modular set,
  suitable for inspection and `opt`

#### Scenario: AOT remains the default

- **WHEN** a program is compiled with no backend explicitly selected
- **THEN** the compiler produces a native executable exactly as before this change

#### Scenario: JIT and bitcode re-home the prelude and resolve imports

- **WHEN** a prelude-using program, and a program with a top-level `(import …)`, are each built with
  `--backend jit` and with `--backend bitcode`
- **THEN** each build resolves the prelude through the auto-imported `(scheme base)` and the import
  through the manifest — linking the library units alongside the program — rather than prepending
  the prelude or failing on the `import` form, and produces the same value the AOT backend produces

#### Scenario: Interactive exit matches batch value

- **WHEN** a sequence of top-level forms is evaluated form-by-form in the interactive
  ORC/LLJIT REPL, and the same sequence is compiled and run as a single whole-program
  batch build
- **THEN** the value reported for the final form is identical between the two exits
