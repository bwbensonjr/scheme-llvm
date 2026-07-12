## MODIFIED Requirements

### Requirement: One emitted IR drives AOT, JIT, and bitcode exits

The compiler SHALL take a single emitted LLVM IR module to three interchangeable
whole-program exits — a native executable (AOT), in-process batch JIT execution via
`lli`, and a bitcode artifact — without changes to the emitted IR or the C runtime
between exits. AOT SHALL remain the default exit. In addition, the compiler SHALL support
an interactive exit in which per-form IR modules are added incrementally to a single
long-lived LLVM ORC/LLJIT host process (see the `interactive-repl` capability); this
interactive exit is distinct from the batch `lli` exit, which runs one whole-program
module and terminates. A REPL session and a batch build SHALL produce the same value for
the same sequence of forms.

#### Scenario: JIT execution via lli

- **WHEN** a demo program is built with the batch JIT backend selected
- **THEN** the compiler links the runtime into the program IR at the IR level and runs it
  via `lli` (resolving `libgc`), and the run reports the program's value — the same value
  the AOT executable reports

#### Scenario: Bitcode emission

- **WHEN** a demo program is built with the bitcode backend selected
- **THEN** the compiler writes a `.bc` bitcode artifact from the same emitted `.ll`,
  suitable for inspection and `opt`

#### Scenario: AOT remains the default

- **WHEN** a program is compiled with no backend explicitly selected
- **THEN** the compiler produces a native executable exactly as before this change

#### Scenario: Interactive exit matches batch value

- **WHEN** a sequence of top-level forms is evaluated form-by-form in the interactive
  ORC/LLJIT REPL, and the same sequence is compiled and run as a single whole-program
  batch build
- **THEN** the value reported for the final form is identical between the two exits
