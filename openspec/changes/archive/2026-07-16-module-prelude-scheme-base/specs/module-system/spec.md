## MODIFIED Requirements

### Requirement: Scaffolding preserves emitted IR

Introducing the typed-scope resolver and the unit-parameterized naming SHALL NOT change the
LLVM IR emitted for any program that imports no library **and** is compiled `--no-prelude`.
The compiler's own regenerated IR (`bootstrap/*.ll`) SHALL remain a stable self-hosting fixed
point after any change. Re-homing the prelude as `(scheme base)` intentionally changes the
emitted IR of a prelude-enabled program (its prelude procedures become imported externals and
`scheme.base.ll` is linked/loaded); such a program's observable **behavior** (its printed
value) SHALL be unchanged.

#### Scenario: Library-free, prelude-free programs emit byte-identical IR

- **WHEN** a program that imports no library is compiled `--no-prelude` before and after this
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

## ADDED Requirements

### Requirement: Prelude split into (scheme base) runtime and macro halves

The compiler SHALL treat the standard prelude as the library `(scheme base)`, split into two
halves driven from one prelude source: a **runtime half** — the prelude's procedure
definitions, compiled as a `(define-library (scheme base) …)` unit that exports all of them
and is linked (AOT) / loaded (REPL) like any Stage-2 library — and a **compile-time half** —
the prelude's derived-form macros (`and`, `or`, `when`, `unless`, `let*`, `cond`, `case`,
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

Unless `--no-prelude` is given, the compiler SHALL compile a user program (and initialize a
REPL session) as though it began with `(import (scheme base))`: the prelude procedures resolve
as imported bindings referencing `scheme.base` external globals, `scheme.base.ll` is
linked/loaded, and the derived-form macro set is merged into the compile's `macro-env`. A name
the program defines itself SHALL take precedence over the auto-imported one (user-wins
shadowing, per the Stage 0 resolution order). A program that adds no `import` SHALL still
compile and run with the prelude available.

#### Scenario: A program uses prelude procedures with no explicit import

- **WHEN** a program that references only prelude procedures (e.g. `(map (lambda (x) (+ x 1))
  '(1 2 3))`) is compiled without `--no-prelude` and without any `import`
- **THEN** it builds and runs, the prelude procedures resolve to `(scheme base)` exports, and
  `scheme.base.ll` is linked/loaded into the result

#### Scenario: A derived-form macro works without a prepended prelude

- **WHEN** a program uses `cond`/`case`/`when` without `--no-prelude`
- **THEN** the derived-form macro expands correctly (its expansion's procedure calls resolve
  to `(scheme base)` exports) and the program produces the expected value

#### Scenario: A user definition shadows an auto-imported prelude name

- **WHEN** a program defines its own top-level `map` while the prelude is enabled
- **THEN** references to `map` resolve to the program's own definition, not the `(scheme base)`
  export

#### Scenario: --no-prelude skips both halves

- **WHEN** a program is compiled `--no-prelude`
- **THEN** `(scheme base)` is not auto-imported, the derived-form macros are not merged, and a
  reference to a prelude name (procedure or macro) is an unbound/undefined error

### Requirement: (scheme base) links or loads exactly once

The compiler SHALL link `(scheme base)` into an executable exactly once and initialize it
exactly once even when it is auto-imported alongside explicit imports (including libraries
that themselves depend on it, once the compiler participates), guaranteed by the
transitive-closure dedup and the one-shot `@"scheme.base:__inited"` guard.

#### Scenario: Auto-import plus explicit import links (scheme base) once

- **WHEN** a program is compiled with the prelude enabled and also explicitly imports another
  library
- **THEN** `scheme.base.ll` appears exactly once in the link and its `__init` runs once
