## MODIFIED Requirements

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
- **THEN** the library compiles without error and `greet` is available to importers under the
  external name `greet`

#### Scenario: A library exports a procedure under a renamed external name

- **WHEN** a `define-library (mylib)` defines a top-level procedure `%fast-map` and declares
  `(export (rename %fast-map map))`
- **THEN** the library compiles without error, importers see the binding under the external
  name `map`, and the internal name `%fast-map` is not visible to importers

#### Scenario: Exporting an undefined name is an error

- **WHEN** a `define-library` declares `(export missing)` (or `(export (rename missing m))`)
  but defines no top-level `missing`
- **THEN** compilation reports a compile-time error naming the undefined export

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
- **THEN** its export table records that external name `greet` maps to symbol `mylib:greet`

#### Scenario: A renamed export keys on the external name but mangles the internal name

- **WHEN** `(mylib)` declares `(export (rename %fast-map map))`
- **THEN** its export table records that external name `map` maps to symbol
  `mylib:%fast-map`

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

### Requirement: Library manifest

Library discovery SHALL be driven by a readable s-expression manifest (default
`./emit-libs.scm`, overridable) mapping each library name to its source file and an optional
artifact directory; compiled artifacts SHALL default under a build directory rather than the
source tree. The manifest MAY list any number of libraries. Resolving an imported library
that has no manifest entry SHALL be a compile-time error naming the missing library.

#### Scenario: Manifest resolves a library name to its source

- **WHEN** the manifest contains an entry mapping `(mylib)` to a source file and the build
  path resolves `(import (mylib))`
- **THEN** the library's source is located via the manifest and its artifacts are written
  under the configured (default `build/`) directory

#### Scenario: An unresolved import is reported

- **WHEN** a program (or library) imports `(nope)` and the manifest has no entry for `(nope)`
- **THEN** the build path reports a compile-time error naming the missing library

## ADDED Requirements

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
missing or older than the library's source, and SHALL reuse existing artifacts that are
newer than the source, so a multi-unit build does not recompile units whose source is
unchanged.

#### Scenario: A changed source triggers a rebuild

- **WHEN** a library's source is newer than its committed `.ll`/`.exports` artifacts (or the
  artifacts are absent) and a build resolves an import of that library
- **THEN** the driver recompiles the library, writing fresh `.ll` and `.exports`

#### Scenario: Fresh artifacts are reused

- **WHEN** a library's artifacts are newer than its source and a build resolves an import of
  that library
- **THEN** the driver reuses the existing artifacts without recompiling the library
