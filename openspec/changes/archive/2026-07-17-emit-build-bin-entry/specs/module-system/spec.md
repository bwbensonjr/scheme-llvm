## MODIFIED Requirements

### Requirement: Library manifest

Library discovery SHALL be driven by a readable s-expression manifest (default
`./emit-libs.scm`, overridable) mapping each library name to its source file and an optional
artifact directory; compiled artifacts SHALL default under a build directory rather than the
source tree. The manifest MAY list any number of libraries. Resolving an imported library
that has no manifest entry SHALL be a compile-time error naming the missing library. The
standard library `(scheme base)` SHALL be resolvable through the manifest like any other
library, so both doors build/load it through the same machinery.

The manifest MAY additionally contain **program entries** of the form
`(program NAME (source S) [(output O)])`, where `NAME` is a bare symbol naming a
deliverable program, `source` names its top-level source file, and the optional
`output` names the delivered executable path. A program entry names a build target,
not a library: it is never a target of `import`, and reading the manifest to resolve
library imports SHALL ignore program entries (library resolution is unchanged by
their presence). Manifest reading SHALL accept a manifest that mixes library and
program entries in any order.

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

#### Scenario: A program entry is parsed and does not affect library resolution

- **WHEN** the manifest mixes `(library (mylib) (source …))` and
  `(program my-app (source "app.scm"))` entries and a build resolves `(import (mylib))`
- **THEN** `(mylib)` resolves through the manifest exactly as before and the program
  entry is ignored during library resolution

#### Scenario: A program entry is resolvable by name

- **WHEN** the manifest contains `(program my-app (source "app.scm") (output "build/app"))`
  and the program `my-app` is looked up
- **THEN** the manifest yields its source (`app.scm`) and output (`build/app`)
