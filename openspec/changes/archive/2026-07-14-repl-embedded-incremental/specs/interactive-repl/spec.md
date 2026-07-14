## MODIFIED Requirements

### Requirement: Incremental per-form compilation to independent modules

REPL mode SHALL compile each entered form into its own LLVM IR module that declares every
previously-defined global binding and every required `rt_*` runtime function as
`external`, defines global slots for any bindings the form introduces, and exposes exactly
one entry thunk that evaluates the form, initializes any new slots, and returns the value
to be printed. A form SHALL be able to reference globals defined by earlier forms and
SHALL NOT be able to reference globals defined by later forms. This compilation SHALL be
performed by the embedded compiler **in-process** — with no Chez Scheme process and no
per-form subprocess — with the compiler's per-form compilation state (the REPL environment,
macro environment, known-names set, and form counter) persisting across forms in the one
host process.

#### Scenario: Prior globals are referenced as external

- **WHEN** a form that uses an earlier-defined binding is compiled
- **THEN** its emitted module declares that binding's global symbol and the `rt_*`
  functions it uses as `external`, and defines only the globals the form itself introduces

#### Scenario: Forward references are rejected

- **WHEN** a form references a name that has not yet been defined by any earlier form
- **THEN** compilation of that form reports an unbound-variable error rather than
  succeeding

#### Scenario: Forms are compiled without Chez

- **WHEN** a sequence of forms is entered in a `--repl` session
- **THEN** each form is compiled by the embedded compiler within the host process (no Chez
  process, no per-form subprocess), and definitions entered earlier remain visible to later
  forms because the compiler's state persists in-process

### Requirement: Persistent JIT host stays in sync with the runtime source

Before the persistent JIT host is used — whether launched by the interactive REPL driver
or by a REPL test harness — the project SHALL ensure the host binary is up to date with
respect to the runtime, host, and embedded-compiler sources it links. The host SHALL be
(re)built whenever `src/runtime/runtime.c`, `src/repl/host.cpp`, the assembled/compiled
compiler it embeds (and the core sources behind it), or the host build recipe is newer than
the existing binary, so that every `rt_*` runtime function and the embedded compiler entry
the host relies on are present and resolvable. It SHALL NOT be sufficient for the host
binary to merely exist; an out-of-date binary SHALL be rebuilt before use.

#### Scenario: A newly added runtime function is available to the prelude

- **WHEN** a new `rt_*` function is added to `src/runtime/runtime.c` and the REPL is then
  started (via the driver or a test harness) with a host binary that predates the change
- **THEN** the host is rebuilt before the first form is evaluated, and a prelude
  procedure that uses the new runtime function resolves and evaluates successfully instead
  of failing with `Failed to materialize symbols`

#### Scenario: A compiler-source change rebuilds the host

- **WHEN** a compiler core source (a pass, `emit`, or the assembly step) is changed and the
  REPL is then started with a host binary that predates the change
- **THEN** the host is rebuilt before the first form is evaluated, so `--repl` compiles
  forms with the updated compiler rather than a stale embedded copy

#### Scenario: An up-to-date host is not rebuilt

- **WHEN** the REPL is started and `build/repl-host` is newer than `runtime.c`,
  `host.cpp`, the embedded compiler, and the build recipe
- **THEN** the freshness check performs no compilation and the session starts without
  rebuilding the host
