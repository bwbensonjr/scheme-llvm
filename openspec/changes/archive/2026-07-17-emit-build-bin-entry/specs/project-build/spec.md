## ADDED Requirements

### Requirement: emit build resolves a manifest program entry

The `emit` binary SHALL provide a `build` verb that builds a standalone executable
from a program named in the manifest. Invoked as `emit build [NAME]`, it SHALL
resolve the manifest's `(program NAME …)` entry to its source file, build that
source through the shipped Chez-free AOT door (`bin/scheme-compile`: `scheme-run
--emit` + clang), and deliver the resulting native executable to the entry's
configured output path. The resolution of the program entry SHALL itself be
Chez-free. This slice does not tree-shake: full library units are linked, as the
Chez-free AOT door does today.

When the manifest contains exactly one program entry, `NAME` MAY be omitted and that
entry SHALL be selected. When `NAME` is omitted and the manifest has zero or more
than one program entry, `emit build` SHALL report an error naming the available
program entries.

The manifest SHALL be located the same way the other doors locate it: the
`EMIT_MANIFEST` environment variable if set, otherwise `--manifest FILE` if given,
otherwise the default `emit-libs.scm`.

#### Scenario: Build the sole program entry by name

- **WHEN** the manifest contains `(program my-app (source "app.scm") (output "build/app"))`
  and the user runs `emit build my-app`
- **THEN** `app.scm` is resolved through the manifest, built through the release ship
  path, and a standalone executable is delivered at `build/app`

#### Scenario: Build the sole program entry with the name omitted

- **WHEN** the manifest has exactly one program entry and the user runs `emit build`
- **THEN** that program entry is selected and built as if its name had been given

#### Scenario: Ambiguous or missing program name is an error

- **WHEN** the user runs `emit build` and the manifest has zero, or more than one,
  program entries
- **THEN** `emit build` reports an error naming the available program entries and
  builds nothing

#### Scenario: Unknown program name is an error

- **WHEN** the user runs `emit build nope` and the manifest has no `(program nope …)`
  entry
- **THEN** `emit build` reports a compile-time error naming the missing program and
  builds nothing

### Requirement: Delivered executable defaults its output path from the program name

A `(program NAME …)` entry MAY omit the `(output O)` clause. When omitted, `emit
build` SHALL derive the delivered executable's path from `NAME` (a stable default
under the build directory), so that a minimal program entry naming only a source is
buildable.

#### Scenario: Output path defaults from the program name

- **WHEN** the manifest contains `(program my-app (source "app.scm"))` with no
  `output` clause and the user runs `emit build my-app`
- **THEN** the executable is delivered to a default path derived from `my-app`

### Requirement: emit build matches the AOT door

A program built through `emit build` SHALL produce a standalone executable whose
observable behavior is identical to building that same source directly through
`bin/scheme-compile` with the same manifest. `emit build` is packaging over the
proven ship path — it resolves the program entry and then invokes
`bin/scheme-compile`; it introduces no second compilation path.

#### Scenario: emit build and the AOT door agree

- **WHEN** a program with library imports is built once via `emit build NAME` and
  once via `bin/scheme-compile` on the same resolved source with the same manifest
- **THEN** both executables run and produce the identical value

### Requirement: The manifest program resolver is Chez-free

Resolving a `(program NAME …)` entry to its source and output SHALL be performed by
the embedded compiler with no dependency on Chez, reusing the same manifest
machinery the run door uses. `scheme-run` SHALL expose this via a
`--resolve-program NAME` mode that reads the manifest (`--manifest` > `EMIT_MANIFEST`
> default `emit-libs.scm`) and prints the resolved source and output, without
JIT-compiling or running any program.

#### Scenario: The resolver prints a program entry's source and output

- **WHEN** the manifest contains `(program my-app (source "app.scm") (output "build/app"))`
  and the user runs `scheme-run --resolve-program my-app`
- **THEN** it prints the resolved source (`app.scm`) and output (`build/app`) and
  runs nothing

#### Scenario: The resolver reports an unknown program

- **WHEN** the user runs `scheme-run --resolve-program nope` and the manifest has no
  `(program nope …)` entry
- **THEN** it reports an error naming the missing program and builds/runs nothing

### Requirement: emit build narrates its actions

`emit build` SHALL follow the project output convention (`docs/OUTPUT.md`): it SHALL
announce what it is building, name its resolved inputs (program name, source) and
outputs (delivered executable path), and report the relevant metrics (e.g. final
binary size), with narration on stderr and controllable via `EMIT_VERBOSITY`.

#### Scenario: A build reports its resolved inputs and outputs

- **WHEN** the user runs `emit build my-app` at the default verbosity
- **THEN** the tool announces the program name, the resolved source, and the delivered
  executable path with its size on stderr

### Requirement: emit is additive and renames nothing

Introducing the `emit` binary SHALL NOT rename or remove any existing tool.
`bin/scheme-compile` (the AOT door), `scheme-run` (the run door), and `repl-host`
(the REPL door) SHALL continue to work exactly as before. The `emit` binary SHALL
expose only the `build` verb in this change; the other verbs and any deprecation of
the existing names remain future work.

#### Scenario: Existing tools are unaffected

- **WHEN** the `emit` binary is present and a user invokes `bin/scheme-compile`,
  `scheme-run`, or `repl-host` as before
- **THEN** each behaves exactly as it did prior to this change
