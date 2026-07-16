## Why

Separate compilation — a `define-library` compiled once into a reusable artifact that is
both linked into an AOT executable and loaded into the REPL — is the core Modules v0 goal,
and Stage 0 (`module-resolution-scaffold`) already landed the typed-scope resolver and the
module-qualified symbol ABI that make it safe. What's still missing is the artifact itself:
there is no library surface syntax, nothing emits a linkable/loadable unit, and the
`imported` binding kind is structured but never produced. This change is **Stage 1** of the
design (`docs/superpowers/specs/2026-07-15-modules-v0-design.md`) — the smallest end-to-end
vertical slice that proves both doors on one trivial library.

## What Changes

- Add a **library surface**: `define-library` with `(export <name> …)` and whole-module
  `(import (<lib>))`, restricted to the R7RS-small subset needed for the slice (procedures
  only; `export`-rename, `only`/`except`/`prefix`, and transitive lib→lib imports are
  deferred to Stage 2; macro export to a later v0 stage).
- Add a **compile-unit** capability to the embedded compiler (design D1): source + library
  name + an in-memory import environment → a library `.ll` plus a readable `.exports` table.
  The pure core stays free of filesystem/subprocess I/O; reading `.exports`/manifest and
  writing artifacts are driver/host effects.
- Emit the **library artifact shape** (design D2): one `external`-linkage global per export
  holding its closure, a one-shot-guarded init function `@"L:__init"` (with `@"L:__inited"`)
  that populates those globals, **no `@scheme_entry`**, and module-qualified names for
  internal top-levels and lifted code blocks (reusing Stage 0's `mangle`). Plus a
  `<unit>.exports` s-expression table mapping each external name → its mangled symbol.
- **Populate the `imported` binding kind** (design D3): resolve an imported free identifier
  against the in-memory export environment to a `(global-ref @"L:x")`, emitted as
  `external global i64` — the referenced-but-not-defined hook Stage 0 wired but left
  unexercised.
- Drive **both doors** off the same compile-unit entry (design D5): the AOT
  **build-program** path resolves `(import (L))` through a minimal manifest, compiles the
  library and the program, and links `clang runtime.c L.ll prog.ll -lgc -o exe`; the program's
  single `@scheme_entry` calls each imported library's `__init` before the program body. The
  **REPL** path `addIRModule`s `L.ll`, calls `@"L:__init"` once, and merges `L.exports` into
  the session scope as imported bindings.
- Add a minimal **manifest** (design D7): a readable s-expression (`./emit-libs.scm`,
  override `--manifest`) mapping a library name → its source (and optional artifact dir);
  two entries suffice for the slice.
- Add a **`test/modules-*` suite**: AOT build+run of a program importing a library; the same
  library imported interactively in the REPL; a unit's `.ll` byte-identical across both doors
  (dev→ship fidelity); and the original blocker as a test — two independently compiled units
  each with an internal `helper` + lifted code blocks link with no symbol collision.

## Capabilities

### New Capabilities
<!-- None; Stage 1 extends the existing module-system capability introduced in Stage 0. -->

### Modified Capabilities
- `module-system`: Adds the library-surface, artifact-emission, import-resolution, and
  both-doors requirements — the first stage that produces and consumes a module artifact,
  building on Stage 0's typed-scope and symbol-naming foundation. No Stage 0 requirement is
  weakened: library-free programs still emit byte-identical IR (only library units carry the
  `@"L:…"` names).

## Impact

- **Embedded compiler (`src/core.ss`, `src/emit.ss`, `src/parse.ss`):** a `compile-unit`
  entry (library name + import env → IR + export table); library-mode emission (per-export
  globals, guarded `__init`, no `@scheme_entry`); resolver produces `imported` bindings from
  the import environment.
- **Surface / expansion (`src/passes/expand.ss` or a new front step):** recognize
  `define-library` / `export` / `import` forms and split a unit's declarations.
- **Drivers/hosts (`src/compile.ss`, `bin/scheme-compile`, `src/run.cpp`,
  `src/repl/host.cpp`, `src/repl-core.ss`):** manifest reading, artifact writing, AOT
  multi-`.ll` linking with `__init` ordering, and REPL `addIRModule` + `__init` + export merge.
- **Tooling / observability:** the build driver narrates unit compiles/links per
  `docs/OUTPUT.md` (`compile (foo bar) -> build/lib/foo.bar.ll [N bytes]`, `link … -> exe`).
- **Tests:** new `test/modules-*` suite wired into `run-all-tests.sh` (AOT/REPL doors,
  byte-identity across doors) and `run-dev-tests.sh` where Chez is needed.
- **Committed IR:** if any `CORE_FLAT` file changes, `make regen` regenerates
  `bootstrap/*.ll`; the anti-stale trust-check must stay green.
- **Dependencies:** builds on the archived `module-resolution-scaffold` (Stage 0).
- **Out of scope (later stages):** export-rename & transitive imports (Stage 2); prelude as
  `(scheme base)` (Stage 3); macro export / phase separation, `only`/`except`/`prefix`,
  `cond-expand`/`include` (v0 non-goals).
