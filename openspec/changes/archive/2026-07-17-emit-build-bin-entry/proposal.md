## Why

Today the manifest (`emit-libs.scm`) maps only *library* names to sources; building
a deliverable program means passing a source path to `bin/scheme-compile` by hand.
The `aot-release-profile` change landed the compile-and-strip machinery on the
Chez-hosted driver; `run-door-user-libraries` then completed the Chez-free doors so
that `scheme-run`/`bin/scheme-compile` resolve user libraries through the manifest.
What is missing is the *project* half: a way for the manifest to name the program to
build and where to deliver it, and a single command that turns "the project" into a
standalone executable. This is slice #2 of
`openspec/explorations/packaging-and-emit-cli.md`, now unblocked because slice #3
proved the module surface packaging sits on.

## What Changes

- Add a **program entry** to the manifest schema: `(program NAME (source S)
  [(output O)])` alongside the existing `(library …)` entries. `NAME` is a bare
  symbol; `source` names the program's top-level source file; optional `output`
  names the delivered executable path (default derived from `NAME`).
- Introduce a new, **additive** `emit` binary with a single verb: `emit build
  [NAME]` (a `bin/emit` wrapper). It resolves the named program entry through the
  manifest **Chez-free** and delivers a standalone executable via the shipped
  Chez-free AOT door (`bin/scheme-compile`: `scheme-run --emit` + clang `-O2`).
  With one program entry, `NAME` may be omitted.
- Add a **Chez-free manifest program-entry resolver** to the embedded compiler: a
  new dispatch mode in `src/repl-core.ss` (manifest text + program name → source +
  output) exposed by a `scheme-run --resolve-program NAME` host flag in
  `src/run.cpp`, reusing the same manifest machinery the run door already uses. The
  committed embedded IR is regenerated (`make regen`, Chez-free).
- Make both manifest readers **ignore program entries during library resolution**
  (`read-manifest` in `src/compile.ss`; `repl-manifest-paths` /
  `repl-manifest-user-paths` in `src/repl-core.ss`), so a program entry is never
  mistaken for an importable library.
- The `emit` binary **renames and removes nothing**: `scheme-compile`,
  `scheme-run`, `repl-host`, and `bin/scheme-compile` keep working unchanged. The
  CLI-naming / deprecation / verb-unification decisions stay deferred to slice #1.
- Scope is **local paths only**, and this slice does **not** add tree-shaking to the
  Chez-free door (full library units are linked, as `bin/scheme-compile` does
  today). No registry, version constraints, or lockfile — the dependency-model and
  Chez-free-tree-shaking questions stay explicitly deferred.

## Capabilities

### New Capabilities
- `project-build`: The `emit build` command — resolve a manifest program entry to
  its source and delivery path, build a standalone executable via the shipped
  Chez-free AOT door (`bin/scheme-compile`), and report the result. The seed of the
  packaging tool.

### Modified Capabilities
- `module-system`: The "Library manifest" requirement extends to admit a
  `(program NAME (source S) [(output O)])` entry kind. Manifest reading must parse
  program entries and continue to resolve library imports unchanged (a program
  entry is not a library and is never a target of `import`).

## Impact

- **Code**:
  - `src/repl-core.ss` — new dispatch mode resolving a manifest program entry
    (name + manifest text → source + output); `repl-manifest-paths` /
    `repl-manifest-user-paths` gain a `library`-keyword guard.
  - `src/run.cpp` — a `--resolve-program NAME` host flag that reads the manifest and
    prints the resolved source/output (no JIT/run).
  - `src/compile.ss` — `read-manifest` gains the same `library`-keyword guard (the
    Chez driver's reference parser also ignores program entries).
  - `bin/emit` — new bash wrapper: `emit build [NAME]` → resolve → `bin/scheme-compile`.
  - `Makefile` — an `emit` wrapper install/target as needed; committed IR
    (`bootstrap/embed-repl.ll` et al.) regenerated via `make regen`.
- **Manifests**: `test/modules/emit-libs.scm` (and optionally the root
  `emit-libs.scm`) gain example program entries; existing library-only manifests
  remain valid.
- **Docs**: `docs/MODULES.md` (manifest grammar + `emit build`) and a note in
  `openspec/explorations/packaging-and-emit-cli.md` marking slice #2's status.
- **No breaking changes**: purely additive command and manifest surface.
