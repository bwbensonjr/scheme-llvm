# module-system Specification

## Purpose

Defines the compiler's separate-compilation foundation: how free identifiers are resolved
into typed bindings (local, imported, or primitive), how a compilation unit's own emitted
symbols are named through a deterministic, unit-parameterized function so that separately
compiled units do not collide at link time, and the byte-identity guarantee that this
scaffolding introduces no behavior change for programs that import no library. This is the
Stage 0 groundwork for the Modules v0 design (separate compilation of `define-library`
units into artifacts linkable into an AOT executable and loadable into the REPL).

## Requirements

### Requirement: Typed binding resolution

Free-identifier resolution SHALL classify every resolved binding by a kind — `local` (the
current unit's own top-level definition), `imported` (another unit's export), or `primitive`
(a built-in operator/keyword) — resolving lexical locals first, then the unit's own
top-level definitions, then imported bindings, then primitives, and otherwise reporting an
unbound-variable error. In this change no imported bindings exist yet; the resolution
results for any program that imports no library SHALL be identical to the prior flat model.

#### Scenario: A program's own top-level define resolves as local

- **WHEN** a program references a name it defines at top level
- **THEN** resolution classifies the binding as `local`
- **AND** the emitted reference targets the same global the flat model produced

#### Scenario: A primitive resolves as primitive

- **WHEN** a program references a built-in operator or keyword (e.g. `car`, `if`)
- **THEN** resolution classifies it as `primitive` and emits the same intrinsic as before

#### Scenario: An unbound identifier still errors

- **WHEN** a program references a name that is neither local, imported, nor primitive
- **THEN** resolution reports an unbound-variable error, as it did before

### Requirement: Deterministic module-qualified symbol naming

The compiler SHALL name a compilation unit's own emitted symbols — top-level globals and
lifted code-block labels — through a deterministic, unit-parameterized function. For a
library named `(p₁ p₂ … pₙ)` and an internal name `x`, the function SHALL produce the symbol
`p₁.p₂.….pₙ:x`, a pure function of the library name and the internal name with no dependence
on compile order or counters. The **program** (non-library) unit SHALL use the empty prefix,
so its emitted symbol names are unchanged from today.

#### Scenario: Library name maps to a canonical symbol

- **WHEN** the naming function is applied to library `(scheme base)` and internal name `map`
- **THEN** it returns the symbol string `scheme.base:map`

#### Scenario: The same input always yields the same symbol

- **WHEN** the naming function is applied twice to the same `(library, name)` pair, in
  separate compilations
- **THEN** it returns the identical symbol both times (no counter or order dependence)

#### Scenario: Program-unit symbols are unprefixed

- **WHEN** a lifted code block or top-level global is emitted for the program unit (no
  enclosing library)
- **THEN** its symbol name is exactly what the pre-change compiler emitted (empty prefix)

### Requirement: Scaffolding preserves emitted IR

Introducing the typed-scope resolver and the unit-parameterized naming SHALL NOT change the
LLVM IR emitted for any program that imports no library. The compiler's own regenerated IR
(`bootstrap/*.ll`) SHALL remain a stable self-hosting fixed point after the change.

#### Scenario: Library-free programs emit byte-identical IR

- **WHEN** any existing demo/program (which imports no library) is compiled before and after
  this change
- **THEN** the emitted `.ll` is byte-for-byte identical

#### Scenario: Existing suites and the trust-check pass

- **WHEN** `run-all-tests.sh` and `run-dev-tests.sh` are run after `make regen`
- **THEN** all suites pass, including self-emission-equivalence and the anti-stale
  trust-check (regenerated committed IR is reproduced byte-for-byte from source)

### Requirement: Library definition and export surface

The compiler SHALL accept a `define-library` form naming a library `(p₁ … pₙ)` and
containing `(export <name> …)` declarations and body definitions. Exported names MUST be
names the library defines at its top level; exporting a name the library does not define
SHALL be a compile-time error. In this stage exports are procedures and `export` lists bare
names only (rename and import-set transforms are out of scope).

#### Scenario: A library exports a procedure it defines

- **WHEN** a `define-library (mylib)` defines a top-level procedure `greet` and declares
  `(export greet)`
- **THEN** the library compiles without error and `greet` is available to importers under
  the external name `greet`

#### Scenario: Exporting an undefined name is an error

- **WHEN** a `define-library` declares `(export missing)` but defines no top-level `missing`
- **THEN** compilation reports a compile-time error naming the undefined export

### Requirement: Whole-module import surface

The compiler SHALL accept a whole-module `(import (<lib>))` form that makes every export of
`<lib>` visible in the importing unit under its external name, resolved as an `imported`
binding. Import-set transforms (`only` / `except` / `prefix`) are out of scope for this
stage.

#### Scenario: An imported name becomes referenceable

- **WHEN** a program contains `(import (mylib))` and `mylib` exports `greet`
- **THEN** a reference to `greet` in the program resolves to the imported binding rather than
  reporting an unbound-variable error

### Requirement: Library artifact emission

Compiling a `define-library` SHALL emit an LLVM module (the library unit) that:
contains one external-linkage global per exported binding, named by the Stage 0 symbol namer
(`@"p₁.….pₙ:x"`); contains an initialization function `@"L:__init"` that runs the library's
top-level definitions to populate those globals and is guarded by a one-shot flag
(`@"L:__inited"`) so repeated calls run the body at most once; names the library's internal
top-levels and lifted code blocks through the same unit-qualified namer; and defines **no**
`@scheme_entry`. Library-free programs SHALL remain byte-identical to Stage 0 (only library
units carry the qualified names).

#### Scenario: The library unit exposes exports and an init, not an entry

- **WHEN** `(mylib)` exporting `greet` is compiled to its unit module
- **THEN** the module declares `@"mylib:greet"` with external linkage, defines `@"mylib:__init"`,
  and defines no `@scheme_entry`

#### Scenario: Init runs the body at most once

- **WHEN** `@"mylib:__init"` is called more than once
- **THEN** the library's top-level definitions execute on the first call only (the
  `@"mylib:__inited"` guard suppresses re-execution)

#### Scenario: A library-free program is unchanged

- **WHEN** a program that imports no library is compiled after this change
- **THEN** its emitted IR is byte-for-byte identical to the Stage 0 output

### Requirement: Library export table

Alongside the library unit the compiler SHALL produce a readable export table mapping each
export's external name to its mangled symbol (procedures only; a macro slot is reserved but
unused). A driver reading the table together with the unit module SHALL have everything
needed to resolve references into the library with no access to the library's source.

#### Scenario: Export table maps external name to mangled symbol

- **WHEN** `(mylib)` exporting `greet` is compiled
- **THEN** its export table records that external name `greet` maps to symbol
  `mylib:greet`

### Requirement: Imported binding resolution

Free-identifier resolution SHALL resolve an imported name against an in-memory import
environment (built from the imported libraries' export tables), classifying it as an
`imported` binding whose symbol is the exporter's mangled symbol, and SHALL emit a reference
to it as an `external global` resolved by name at link/load time. The importing unit SHALL
NOT define that global. A name the importing unit defines itself SHALL take precedence over
an imported name of the same spelling.

#### Scenario: Imported reference emits an external global

- **WHEN** a program importing `(mylib)` references the exported `greet`
- **THEN** resolution classifies `greet` as `imported` with symbol `mylib:greet` and the
  program module references it as an external global it does not define

#### Scenario: A local definition shadows an import

- **WHEN** a program imports `(mylib)` (which exports `greet`) but also defines its own
  top-level `greet`
- **THEN** references to `greet` resolve to the program's own definition, not the import

### Requirement: Program initialization ordering

A program that imports libraries SHALL, in its `@scheme_entry`, call each imported library's
`@"L:__init"` before executing the program body, so every imported global is populated
before first use.

#### Scenario: Imported library is initialized before the program body

- **WHEN** a program imports `(mylib)` and calls `greet` in its body
- **THEN** `@scheme_entry` calls `@"mylib:__init"` before the body runs, and the call to
  `greet` observes the populated global

### Requirement: AOT door — build and link an importing program

An import-aware build path SHALL resolve a program's `(import (<lib>))` through a manifest to
the library's source, compile the library to its unit module and export table, compile the
program against the resulting import environment, and link the library unit, the program
module, and the runtime into a single working executable. An imported library that a program
does not import SHALL NOT be linked.

#### Scenario: A program importing a library builds and runs

- **WHEN** the build path is run on a program that imports `(mylib)` and prints the result of
  `greet`
- **THEN** it produces an executable that, when run, prints the value `greet` returns

### Requirement: REPL door — import a library interactively

The interactive REPL SHALL, on evaluating `(import (<lib>))`, resolve the library through the
manifest, load its unit module into the running session, invoke its `@"L:__init"` exactly
once, and merge its export table into the session scope so subsequent forms may reference the
imported names.

#### Scenario: Imported procedure is callable in the REPL

- **WHEN** the user evaluates `(import (mylib))` and then calls `greet` in a later form
- **THEN** the REPL loads `mylib`, initializes it once, and the later form returns the value
  `greet` produces

### Requirement: Dev→ship fidelity for library units

A library unit's emitted module SHALL be byte-for-byte identical whether it is produced for
the AOT door or the REPL door, because both doors drive the same compile-unit core entry.

#### Scenario: A unit's module bytes match across doors

- **WHEN** `(mylib)` is compiled for the AOT link and for REPL loading
- **THEN** the two unit modules are byte-for-byte identical

### Requirement: Separately compiled units link without symbol collision

Two libraries compiled independently, each with an internal helper and lifted code blocks of
the same spelling, SHALL link together into one program with no duplicate-symbol conflict,
because every unit-owned symbol is qualified by the unit's library name.

#### Scenario: Two units with same-named internals coexist

- **WHEN** libraries `(liba)` and `(libb)` each define an internal `helper` and each lift
  code blocks, and a program imports both
- **THEN** the units link into one executable with no symbol collision and both libraries'
  exports work

### Requirement: Library manifest

Library discovery SHALL be driven by a readable s-expression manifest (default
`./emit-libs.scm`, overridable) mapping each library name to its source file and an optional
artifact directory; compiled artifacts SHALL default under a build directory rather than the
source tree.

#### Scenario: Manifest resolves a library name to its source

- **WHEN** the manifest contains an entry mapping `(mylib)` to a source file and the build
  path resolves `(import (mylib))`
- **THEN** the library's source is located via the manifest and its artifacts are written
  under the configured (default `build/`) directory
