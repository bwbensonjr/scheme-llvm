# module-system Specification

## Purpose

Defines the compiler's separate-compilation foundation: how free identifiers are resolved
into typed bindings (local, imported, or primitive), how a compilation unit's own emitted
symbols are named through a deterministic, unit-parameterized function so that separately
compiled units do not collide at link time, and the byte-identity guarantee that this
scaffolding introduces no behavior change for programs that import no library. It covers the
Modules v0 design's separate compilation of `define-library` units into artifacts that are
both linked into an AOT executable and loaded into the REPL: the library/export/import
surface (including export-rename), transitive lib→lib imports with topological dependency
ordering and diamond-safe one-time initialization, and stale-artifact rebuild driven by a
readable manifest.

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
LLVM IR emitted for any program that imports no library **and** is compiled `--no-prelude`.
The compiler's own regenerated IR (`bootstrap/*.ll`) SHALL remain a stable self-hosting fixed
point after any change. Re-homing the prelude as `(scheme base)` intentionally changes the
emitted IR of a prelude-enabled program (its prelude procedures become imported externals and
`scheme.base.ll` is linked/loaded); such a program's observable **behavior** (its printed
value) SHALL be unchanged.

#### Scenario: Library-free, prelude-free programs emit byte-identical IR

- **WHEN** a program that imports no library is compiled `--no-prelude` before and after a
  change
- **THEN** the emitted `.ll` is byte-for-byte identical

#### Scenario: A prelude-using program's behavior is preserved across the re-home

- **WHEN** a demo that relies on prelude procedures is compiled and run before and after
  re-homing the prelude as `(scheme base)`
- **THEN** it prints the same value both times, even though its emitted IR changed

#### Scenario: Existing suites and the trust-check pass

- **WHEN** `run-all-tests.sh` and `run-dev-tests.sh` are run after `make regen`
- **THEN** all suites pass, including self-emission-equivalence and the anti-stale
  trust-check (regenerated committed IR is reproduced byte-for-byte from source)

### Requirement: Library definition and export surface

The compiler SHALL accept a `define-library` form naming a library `(p₁ … pₙ)` and
containing `(export …)` declarations and body definitions. Each `export` declaration lists
either a bare name `<name>` or a rename pair `(rename <internal> <external>)`. The
**internal** name (the bare name, or `<internal>` in a rename) MUST be a name the library
defines at its top level; exporting a name the library does not define SHALL be a
compile-time error. The **external** name (the bare name, or `<external>` in a rename) is the
spelling under which importers see the binding. In this stage exports are procedures; `only`/
`except`/`prefix` import-set transforms remain out of scope.

#### Scenario: A library exports a procedure it defines

- **WHEN** a `define-library (mylib)` defines a top-level procedure `greet` and declares
  `(export greet)`
- **THEN** the library compiles without error and `greet` is available to importers under
  the external name `greet`

#### Scenario: A library exports a procedure under a renamed external name

- **WHEN** a `define-library (mylib)` defines a top-level procedure `%fast-map` and declares
  `(export (rename %fast-map map))`
- **THEN** the library compiles without error, importers see the binding under the external
  name `map`, and the internal name `%fast-map` is not visible to importers

#### Scenario: Exporting an undefined name is an error

- **WHEN** a `define-library` declares `(export missing)` (or `(export (rename missing m))`)
  but defines no top-level `missing`
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
export's **external** name to the **internal-name-based** mangled symbol (procedures only; a
macro slot is reserved but unused). For a bare export the external name equals the internal
name; for `(rename <internal> <external>)` the table key is `<external>` while the mangled
symbol is derived from `<internal>`. A driver reading the table together with the unit module
SHALL have everything needed to resolve references into the library with no access to the
library's source.

#### Scenario: Export table maps external name to mangled symbol

- **WHEN** `(mylib)` exporting `greet` is compiled
- **THEN** its export table records that external name `greet` maps to symbol
  `mylib:greet`

#### Scenario: A renamed export keys on the external name but mangles the internal name

- **WHEN** `(mylib)` declares `(export (rename %fast-map map))`
- **THEN** its export table records that external name `map` maps to symbol
  `mylib:%fast-map`

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

A program that imports libraries SHALL, in its `@scheme_entry`, call the imported libraries'
`@"L:__init"` functions in an order consistent with the dependency graph — every library's
`__init` runs after the `__init`s of the libraries it depends on and before the program body
— so every imported global (direct or transitive) is populated before first use.

#### Scenario: A transitive dependency is initialized before its dependents

- **WHEN** a program imports `(a)`, `(a)` imports `(b)`, and the program body uses an export
  of `(a)` that internally calls an export of `(b)`
- **THEN** `@scheme_entry` calls `@"b:__init"` before `@"a:__init"` and both before the
  program body, and the call observes both globals populated

#### Scenario: Imported library is initialized before the program body

- **WHEN** a program imports `(mylib)` and calls `greet` in its body
- **THEN** `@scheme_entry` calls `@"mylib:__init"` before the body runs, and the call to
  `greet` observes the populated global

### Requirement: AOT door — build and link an importing program

An import-aware build path SHALL resolve a program's imports (and each library's imports)
through the manifest to their sources, build the transitive dependency graph, reject import
cycles with a compile-time error, compile each unit against the import environment built from
its dependencies' export tables, and link the program module, every unit in the transitive
closure, and the runtime into a single working executable in dependency order. A library that
is not in the program's transitive import closure SHALL NOT be linked.

#### Scenario: A program importing a library builds and runs

- **WHEN** the build path is run on a program that imports `(mylib)` and prints the result of
  `greet`
- **THEN** it produces an executable that, when run, prints the value `greet` returns

#### Scenario: A transitive import chain builds and runs

- **WHEN** the build path is run on a program that imports `(a)` where `(a)` imports `(b)`
- **THEN** it compiles `(b)`, `(a)`, and the program, links all three plus the runtime, and
  the resulting executable runs correctly

#### Scenario: An import cycle is reported

- **WHEN** the build path resolves a graph in which `(a)` imports `(b)` and `(b)` imports `(a)`
- **THEN** it reports a compile-time error naming the cycle rather than looping or linking

### Requirement: REPL door — import a library interactively

The interactive REPL SHALL, on evaluating `(import (<lib>))`, resolve the library and its
transitive dependencies through the manifest, load each unit module into the running session
in dependency order, invoke each unit's `@"L:__init"` exactly once, and merge the imported
library's export table into the session scope so subsequent forms may reference the imported
names.

#### Scenario: Imported procedure is callable in the REPL

- **WHEN** the user evaluates `(import (mylib))` and then calls `greet` in a later form
- **THEN** the REPL loads `mylib`, initializes it once, and the later form returns the value
  `greet` produces

#### Scenario: A transitive dependency is loaded and initialized in the REPL

- **WHEN** the user evaluates `(import (a))` where `(a)` imports `(b)`
- **THEN** the REPL loads both `b` and `a` in dependency order, initializes each once, and a
  later form calling an export of `(a)` that relies on `(b)` returns the expected value

### Requirement: Dev→ship fidelity for library units

A library unit's emitted module SHALL be byte-for-byte identical whether it is produced for
the AOT door or the REPL door, because both doors drive the same compile-unit core entry.

#### Scenario: A unit's module bytes match across doors

- **WHEN** `(mylib)` is compiled for the AOT link and for REPL loading
- **THEN** the two unit modules are byte-for-byte identical

### Requirement: Separately compiled units link without symbol collision

Two libraries compiled independently, each with an internal helper and lifted code blocks of the same spelling, SHALL link together into one program with no duplicate-symbol conflict, because every unit-owned symbol is qualified by the unit's library name.

#### Scenario: Two units with same-named internals coexist

- **WHEN** libraries `(liba)` and `(libb)` each define an internal `helper` and each lift
  code blocks, and a program imports both
- **THEN** the units link into one executable with no symbol collision and both libraries'
  exports work

### Requirement: Library manifest

Library discovery SHALL be driven by a readable s-expression manifest (default
`./emit-libs.scm`, overridable) mapping each library name to its source file and an optional
artifact directory; compiled artifacts SHALL default under a build directory rather than the
source tree. The manifest MAY list any number of libraries. Resolving an imported library
that has no manifest entry SHALL be a compile-time error naming the missing library. The
standard library `(scheme base)` SHALL be resolvable through the manifest like any other
library, so both doors build/load it through the same machinery.

#### Scenario: Manifest resolves a library name to its source

- **WHEN** the manifest contains an entry mapping `(mylib)` to a source file and the build
  path resolves `(import (mylib))`
- **THEN** the library's source is located via the manifest and its artifacts are written
  under the configured (default `build/`) directory

#### Scenario: An unresolved import is reported

- **WHEN** a program (or library) imports `(nope)` and the manifest has no entry for `(nope)`
- **THEN** the build path reports a compile-time error naming the missing library

#### Scenario: (scheme base) resolves through the manifest

- **WHEN** the auto-import of `(scheme base)` (or an explicit `(import (scheme base))`) is
  resolved
- **THEN** `(scheme base)` is located through the manifest and compiled/loaded like any other
  library unit

### Requirement: Transitive library imports

A `define-library` SHALL be permitted to contain `(import (<other-lib>))` declarations. When
compiling such a library, the compiler SHALL build its import environment from the export
tables of the libraries it imports and resolve its free identifiers against that environment
exactly as it does for a program — a name exported by an imported library resolves to an
`imported` binding referencing the exporter's mangled symbol as an external global the
importing library does not define, with the library's own top-level definitions taking
precedence over an imported name of the same spelling.

#### Scenario: A library references another library's export

- **WHEN** `(a)` imports `(b)`, `(b)` exports `add1`, and `(a)`'s body calls `add1`
- **THEN** the reference to `add1` in `(a)` resolves to the `imported` binding `b:add1` and
  `(a)`'s emitted unit references it as an external global it does not define

#### Scenario: A library's own definition shadows a transitive import

- **WHEN** `(a)` imports `(b)` (which exports `helper`) but `(a)` also defines its own
  top-level `helper`
- **THEN** references to `helper` inside `(a)` resolve to `(a)`'s own definition, not `(b)`'s
  export

### Requirement: Diamond-safe one-time initialization

The compiler SHALL ensure a library reachable by more than one path in the transitive import
graph (a diamond) executes its top-level body exactly once across the whole program run, even
though its `@"L:__init"` may be invoked from more than one dependent — guaranteed by the
one-shot `@"L:__inited"` guard.

#### Scenario: A shared dependency initializes once in a diamond

- **WHEN** a program imports `(a)` and `(b)`, both of which import `(c)`, and `(c)`'s body has
  an observable one-time effect
- **THEN** running the program executes `(c)`'s body exactly once even though both `(a)` and
  `(b)` cause `@"c:__init"` to be invoked

### Requirement: Stale-artifact rebuild

The build driver SHALL rebuild a library's `.ll` and `.exports` artifacts when they are
missing, older than the library's source, **or produced by a different compiler**, and SHALL
reuse existing artifacts only when they are newer than the source **and** were produced by the
current compiler, so a multi-unit build does not recompile units whose source is unchanged yet
never reuses a unit compiled by a different (e.g. older) compiler.

Compiler identity SHALL be captured as a **compiler-identity stamp** — a version marker
combined with a content hash over the compiler sources that determine the emitted IR — and
SHALL be recorded alongside each unit's artifacts when they are written. An artifact whose
recorded stamp differs from the current compiler's stamp SHALL be treated as stale and
recompiled, even when its source is unchanged.

#### Scenario: A changed source triggers a rebuild

- **WHEN** a library's source is newer than its committed `.ll`/`.exports` artifacts (or the
  artifacts are absent) and a build resolves an import of that library
- **THEN** the driver recompiles the library, writing fresh `.ll` and `.exports`

#### Scenario: Fresh artifacts are reused

- **WHEN** a library's artifacts are newer than its source and carry the current compiler's
  identity stamp, and a build resolves an import of that library
- **THEN** the driver reuses the existing artifacts without recompiling the library

#### Scenario: A compiler change invalidates unchanged-source artifacts

- **WHEN** the compiler that determines emitted IR has changed (its identity stamp differs
  from the stamp recorded with a unit's artifacts) but the library's source is unchanged, and
  a build resolves an import of that library
- **THEN** the driver recompiles the library instead of reusing the stale artifact, so the
  emitted IR reflects the current compiler (e.g. a boolean literal re-encoding is not served
  from a unit compiled by the old emitter)

### Requirement: Prelude split into (scheme base) runtime and macro halves

The compiler SHALL treat the standard prelude as the library `(scheme base)`, split into two
halves driven from one prelude source: a **runtime half** — the prelude's procedure
definitions, compiled as a `(define-library (scheme base) …)` unit that exports all of them
and is linked (AOT) / loaded (REPL) like any library — and a **compile-time half** — the
prelude's derived-form macros (`and`, `or`, `when`, `unless`, `let*`, `cond`, `case`,
`guard`, and their helpers), carried by the compiler as a macro set rather than emitted into
the artifact. The runtime half SHALL be compiled with the derived-form macros in scope,
because prelude procedures use them internally. The two halves SHALL stay consistent with the
single prelude source (no divergent hand-maintained copies).

#### Scenario: The runtime half is a linkable/loadable library exporting the prelude procedures

- **WHEN** `(scheme base)` is compiled
- **THEN** it produces `scheme.base.ll` + `scheme.base.exports` exporting the prelude's
  procedures (e.g. `map`, `assq`, `append`), with a guarded `@"scheme.base:__init"` and no
  `@scheme_entry`

#### Scenario: The runtime half compiles using the derived-form macros

- **WHEN** a prelude procedure whose body uses `cond`/`case` (e.g. `case` expands to `memv`)
  is compiled into the `(scheme base)` unit
- **THEN** the derived-form macros are in scope for that compilation and the unit compiles
  without an unbound-macro error

### Requirement: Implicit import of (scheme base)

Unless `--no-prelude` is given, the compiler SHALL make the prelude available to a user
program (and REPL session) without an explicit import, as though it began with `(import
(scheme base))`: the prelude procedures resolve to `(scheme base)` and the derived-form macro
set is merged into the compile's `macro-env`. This SHALL hold identically on all three doors —
the Chez batch driver, the REPL, and the Chez-free embedded runner (`scheme-run` /
`scheme-compile`): on each, the procedures resolve as imported bindings referencing `scheme.base`
external globals and `scheme.base.ll` is linked/loaded/concatenated into the result. On the
Chez-free embedded runner, `(scheme base)` is compiled from the compiler's baked-in prelude
source with no filesystem access, so the runner re-homes rather than prepends. A name the
program defines itself SHALL take precedence over the auto-imported one (user-wins shadowing, per
the Stage 0 resolution order).

#### Scenario: A program uses prelude procedures with no explicit import

- **WHEN** a program that references only prelude procedures (e.g. `(map (lambda (x) (+ x 1))
  '(1 2 3))`) is compiled without `--no-prelude` and without any `import`
- **THEN** it builds and runs; on every door the prelude procedures resolve to
  `(scheme base)` exports and `scheme.base.ll` is linked/loaded/concatenated into the result

#### Scenario: A derived-form macro works without a prepended prelude

- **WHEN** a program uses `cond`/`case`/`when` without `--no-prelude` on any door
- **THEN** the derived-form macro expands correctly (its expansion's procedure calls resolve
  to `(scheme base)` exports) and the program produces the expected value

#### Scenario: A user definition shadows an auto-imported prelude name

- **WHEN** a program defines its own top-level `map` while the prelude is enabled
- **THEN** references to `map` resolve to the program's own definition, not the `(scheme base)`
  export

#### Scenario: --no-prelude skips both halves

- **WHEN** a program is compiled `--no-prelude` (on any door, including the embedded runner)
- **THEN** `(scheme base)` is not auto-imported, the derived-form macros are not merged, and a
  reference to a prelude name (procedure or macro) is an unbound/undefined error

#### Scenario: The embedded runner re-homes the prelude like the Chez driver

- **WHEN** a prelude-using program is compiled by the Chez-free embedded runner
  (`scheme-run --emit`) and by the Chez batch driver, both with the prelude enabled
- **THEN** both resolve prelude procedures through `(scheme base)` and emit byte-identical
  program IR — the embedded runner assembles `(scheme base)` from baked-in prelude source
  instead of reading `lib/scheme/base.sld` from disk

### Requirement: (scheme base) links or loads exactly once

The compiler SHALL link `(scheme base)` into an executable exactly once and initialize it
exactly once even when it is auto-imported alongside explicit imports, guaranteed by the
transitive-closure dedup and the one-shot `@"scheme.base:__inited"` guard.

#### Scenario: Auto-import plus explicit import links (scheme base) once

- **WHEN** a program is compiled with the prelude enabled and also explicitly imports another
  library
- **THEN** `scheme.base.ll` appears exactly once in the link and its `__init` runs once

### Requirement: (scheme base) is library zero for the compiler's own build

The compiler binaries themselves — `schemec`, `embed` (the `scheme-run` runner), and `embed-repl`
(the REPL host) — SHALL consume `(scheme base)` as a linked library rather than carrying a
prepended copy of the prelude's procedures. Their source SHALL be compiled with `(scheme base)`
auto-imported (procedures resolving to `scheme.base:*` external globals, derived-form macros merged
compile-time), and each binary SHALL link the single committed `scheme.base.ll`, initializing it
once via its `@"scheme.base:__init"` guard. This makes `(scheme base)` library zero for the
compiler, the largest consumer of the module system, exactly as it is for user programs.

#### Scenario: A compiler binary references the prelude through (scheme base)

- **WHEN** a compiler binary's committed IR is inspected
- **THEN** the prelude procedures it uses appear as `scheme.base:*` external globals resolved
  against the linked `scheme.base.ll`, not as the binary's own inlined top-level definitions

#### Scenario: The compiler links (scheme base) exactly once

- **WHEN** any of the compiler binaries is built from committed IR
- **THEN** it links exactly one `scheme.base.ll` and runs its `__init` once, and the binary behaves
  identically to the prelude-prepended build it replaces
