## ADDED Requirements

### Requirement: The AOT build optimizes the linked module (release profile)

The AOT backend SHALL produce an optimized native executable: the linked module set (runtime +
library units + program) SHALL be compiled with an optimizing pipeline (e.g. `-O2` / `opt`)
rather than at the default `-O0`. This optimization SHALL preserve observable behavior — the
executable SHALL produce the same values and errors as the unoptimized build for every program —
and SHALL NOT change the emitter's textual IR output or the committed bootstrap IR (only the
link/codegen step optimizes). The interactive/JIT door is unaffected.

#### Scenario: AOT executable is optimized

- **WHEN** a program is built through the AOT backend
- **THEN** the linked module is compiled with an optimizing pipeline, and the resulting
  executable produces the same result as an unoptimized build (e.g. `(ack 3 12)` ⇒ `32765`)

#### Scenario: Emitted IR and bootstrap IR are unchanged

- **WHEN** the AOT release optimization is enabled
- **THEN** the emitter's per-form textual IR and the committed `bootstrap/*.ll` are byte-identical
  to before (the optimization is a link/codegen-time step, not an emission change), so IR
  byte-identity and self-hosting fixed-point checks still hold

### Requirement: The AOT build tree-shakes unreachable library bindings

Under the closed-world assumption of an AOT build (a sealed program with no further definitions or
redefinitions, and no `eval`/dynamic name lookup), the AOT backend SHALL omit library and prelude
bindings that are not transitively reachable from an explicit **root set**. Reachability SHALL be
computed from the root set over the general unit/export graph (the prelude is treated as one unit
among others, not special-cased). The AOT build SHALL generate initialization that constructs only
the reachable bindings, so that unreachable code becomes genuinely unreferenced and is removed from
the executable.

The root set SHALL be a parameter of the reachability computation (for an executable, the program's
entry and top-level references), so the same mechanism can later serve other roots (e.g. a
delivered library's exported interface) without change.

This transform SHALL apply ONLY to the AOT/build door. The interactive/REPL door SHALL continue to
provide the full library units (open world — any binding may be referenced by a later form), and
both doors SHALL share one compiler core. Tree-shaking SHALL preserve observable behavior: a
program's result SHALL be identical to a non-shaken build.

#### Scenario: Unused library bindings are dropped from the executable

- **WHEN** a program that references only a small subset of `(scheme base)` (e.g. only `car`) is
  built for AOT
- **THEN** library bindings not transitively reachable from the program are absent from the linked
  executable, and the binary is smaller than one linking the full library

#### Scenario: Reachable bindings and behavior are preserved

- **WHEN** a program that transitively uses a library binding (directly or through another reachable
  binding) is built for AOT
- **THEN** that binding is retained and the program produces the same result as a non-shaken build

#### Scenario: The REPL door keeps the full library

- **WHEN** the same library is loaded through the interactive/REPL door
- **THEN** every binding remains available regardless of what any single form references (open
  world), and behavior matches the AOT build for programs that use the same bindings

#### Scenario: Reachability is root-set-driven

- **WHEN** the reachability computation is invoked with an explicit root set
- **THEN** exactly the bindings transitively reachable from that root set are retained, so a
  different root set (e.g. a library's exports rather than a program entry) selects a different
  retained set through the same mechanism
