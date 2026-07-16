## Why

Stage 1 (`module-artifacts-vertical-slice`) proved both doors on the smallest possible case:
one flat library, one bare-name export, one program importing it. Real libraries are not
flat — they build on other libraries, they rename their exports, and a program can reach the
same dependency by two paths. Stage 2 of the Modules v0 design
(`docs/superpowers/specs/2026-07-15-modules-v0-design.md`) **generalizes** the Stage 1 slice
into a usable separate-compilation system: libraries that import libraries, exports that
rename, a build that orders and rebuilds units correctly, and a diamond that initializes
each unit exactly once. This is the last stage before the prelude can be re-homed as
`(scheme base)` (Stage 3).

## What Changes

- **Export-rename** — accept `(export (rename <internal> <external>))` alongside bare
  `(export <name>)`. The export table's *key* becomes the external name while the mangled
  symbol stays based on the **internal** name (`(export (rename %fast-map map))` →
  `map → @"L:%fast-map"`). Pure table indirection; no new emission logic. `only`/`except`/
  `prefix` import-set transforms remain out of scope (v0 non-goal).
- **Transitive imports (lib→lib)** — a `define-library` may itself `(import (<other-lib>))`.
  The resolver populates a library unit's import environment from its dependencies' export
  tables exactly as it already does for a program, so a library can reference another
  library's exports as `imported` bindings.
- **Dependency ordering** — the build driver builds a dependency graph from the manifest and
  the units' `import` forms, detects cycles as a compile-time error, and links units in
  **topological order** with each `@scheme_entry`/`__init` calling its direct dependencies'
  `__init`s first, so every imported global is populated before use across the whole graph.
- **Diamond-safe initialization** — when two paths reach one library, its `@"L:__init"` is
  invoked from more than one dependent, but the Stage 1 one-shot `@"L:__inited"` guard runs
  its body exactly once. This stage adds the multi-dependent wiring and the test that proves
  it (the guard mechanism itself already exists).
- **Stale-rebuild** — the build driver rebuilds a library's `.ll`/`.exports` when its source
  is newer than its artifacts (or artifacts are missing), and reuses fresh artifacts
  otherwise, so multi-unit builds don't recompile the world every time.
- **Manifest polish** — generalize the two-entry Stage 1 manifest into a real resolver: many
  libraries, a default artifact directory convention (under `build/`), and a clear error when
  an imported library is absent from the manifest.
- **Tests** — extend `test/modules-*` with: a lib→lib transitive chain that builds/runs and
  loads in the REPL; export-rename (importer sees the external name, the internal name stays
  invisible); a diamond whose shared unit initializes once; a cycle reported as an error; and
  stale-rebuild vs. reuse.

## Capabilities

### New Capabilities
<!-- None; Stage 2 extends the existing module-system capability from Stages 0 and 1. -->

### Modified Capabilities
- `module-system`: Adds requirements for export-rename, transitive (lib→lib) import
  resolution, topological dependency ordering with diamond-safe one-time init, stale-rebuild,
  and a generalized manifest resolver. No Stage 0/1 requirement is weakened: library-free
  programs still emit byte-identical IR, a unit's `.ll` stays byte-identical across doors, and
  the single-library slice keeps working.

## Impact

- **Surface / parsing (`src/passes/expand.ss` or the library-front step):** accept
  `(export (rename i e))` in the export parser; accept `(import …)` inside `define-library`.
- **Compiler core (`src/core.ss`, `src/parse.ss`):** build a library unit's import
  environment from its dependencies' export tables (the same path a program already uses);
  export-table keys become external names mapped to internal-name-based mangled symbols.
- **Drivers / hosts (`src/compile.ss`, `bin/scheme-compile`, `src/run.cpp`,
  `src/repl/host.cpp`, `src/repl-core.ss`):** dependency-graph construction, cycle detection,
  topological build+link order, per-dependency `__init` wiring, stale-artifact detection, and
  the generalized manifest resolver.
- **Tooling / observability:** the build driver narrates the resolved build order and
  per-unit compile/reuse decisions per `docs/OUTPUT.md`, honoring `EMIT_VERBOSITY`.
- **Tests:** new `test/modules-*` cases (transitive chain both doors, export-rename, diamond
  init-once, cycle error, stale-rebuild) wired into `run-all-tests.sh` and `run-dev-tests.sh`.
- **Committed IR:** if any `CORE_FLAT` file changes, `make regen` regenerates `bootstrap/*.ll`
  and the anti-stale trust-check must stay green.
- **Dependencies:** builds on the archived `module-artifacts-vertical-slice` (Stage 1).
- **Out of scope (later stages / v0 non-goals):** prelude as `(scheme base)` / auto-import
  (Stage 3); macro export / phase separation; `only`/`except`/`prefix`; `cond-expand`/
  `include`; first-class/dynamic libraries.
