## Context

Stage 1 of Modules v0 (`docs/superpowers/specs/2026-07-15-modules-v0-design.md`), building
directly on the archived Stage 0 (`module-resolution-scaffold`). Stage 0 already delivered
the two pieces this stage stands on: a typed-scope resolver in `resolve-globals`
(`src/parse.ss`) that classifies bindings `local | imported | primitive` (with `imported`
structured but never produced), and `mangle` (`src/util.scm`) plus the unit threading in
`lower.ss`/`emit.ss` that names a unit's own globals and lifted code labels `@"L:x"` for a
library and unchanged for the program (empty-prefix) unit.

Today the whole pipeline emits exactly one module with one `@scheme_entry`
(`src/emit.ss` `emit-program`/`emit-entry`), links program+runtime via `clang`
(`src/compile.ss`), and the REPL emits per-form modules whose referenced-but-undefined
globals become `external global i64` (`src/emit.ss` `emit-repl-module`). The task is to
produce a **library artifact** and consume it through **both doors** (AOT link, REPL
`addIRModule`) off one compiler core — the smallest slice that exercises the full path:
one `(mylib)` exporting one procedure, imported by a program that both links into an exe and
loads in the REPL.

The dominating constraints: the pure core (`src/core.ss`) must stay free of
filesystem/subprocess I/O (self-hosting invariant); a unit's `.ll` must be byte-identical
across both doors (dev→ship fidelity, guarded by self-emission-equivalence); and
library-free programs must keep emitting byte-identical IR (Stage 0's guarantee is not
weakened).

## Goals / Non-Goals

**Goals:**
- `define-library` / `(export <name> …)` / whole-module `(import (<lib>))` surface, parsed
  into a unit's declarations (imports, exports, body forms).
- A `compile-unit` core entry: `(forms, library-name, import-env) → (ir-text, export-table)`,
  emitting the library artifact shape (per-export externals, guarded `@"L:__init"`, no
  `@scheme_entry`, mangled internals) and a readable `<unit>.exports`.
- The resolver **produces** `imported` bindings from the import environment → `external
  global i64`.
- Both doors from the same entry: AOT `build-program` (manifest → compile lib+program →
  link, with `@scheme_entry` calling imported `__init`s first) and REPL `import`
  (`addIRModule` + `__init` once + merge exports into session scope).
- A minimal readable manifest (`./emit-libs.scm`).
- A `test/modules-*` suite covering both doors, cross-door byte-identity, and the
  no-collision blocker.

**Non-Goals:**
- Export-rename `(export (rename i e))` and transitive lib→lib imports + dependency ordering
  (Stage 2). Stage 1 has a single library with a single program importing it.
- Prelude as `(scheme base)` / auto-import (Stage 3).
- Macro export / phase separation; `only`/`except`/`prefix`; `cond-expand`/`include`;
  first-class/dynamic libraries (v0 non-goals).
- Dead-code elimination beyond "an unlinked library isn't included".

## Decisions

### D1 — `compile-unit` in the embedded compiler core; drivers do I/O

Add a core entry beside `compile-source-with-prelude` (`src/core.ss`) that takes the unit's
forms, its library name (a list of symbol parts for `mangle`), and an **in-memory import
environment** (external-name → mangled-symbol, aggregated from the imported libraries'
export tables), and returns `(values ir-text export-table)`. The export table is a plain
s-expression the driver serializes to `<unit>.exports`. Reading `.exports`/manifest files,
ordering, and writing artifacts stay in the drivers (`src/compile.ss`, `bin/scheme-compile`)
and hosts (`src/run.cpp`, `src/repl/host.cpp`), never in the core.

*Alternative rejected:* teach the `schemec` text filter a library protocol on stdin.
Rejected per the master design D1 — it grows a second module path parallel to the embedded
one, against "one compiler core".

### D2 — Library artifact shape

`compile-unit` for library `L` emits, via a library-mode sibling of `emit-program`:
- one `@"L:x" = global i64 0` **definition** per exported internal name `x` (external
  linkage so other modules resolve it by name), reusing `global-operand` with `*emit-unit*`
  bound to `L`;
- `define i64 @"L:__init"()` that runs the library's top-level defines to populate those
  globals (the same letrec/thunk lowering `emit-program` already does), wrapped in a one-shot
  guard: load `@"L:__inited"`, return early if set, else set it and run — making `__init`
  idempotent for the Stage-2 diamond case at no extra Stage-1 cost;
- **no `@scheme_entry`**;
- module-qualified internal top-levels and lifted code labels via Stage 0's `*unit*`/`mangle`
  (already in place — binding `*unit*`/`*emit-unit*` to `L` is the whole change).

The program unit is emitted as today but its `@scheme_entry` is generalized to call each
imported library's `@"L:__init"` (declared `external`) before the program body — a direct
extension of how `emit-repl-batch` already runs ordered thunks (`src/emit.ss`).

*Alternative rejected:* a constructor-attribute auto-init. Rejected — explicit `__init`
calls from `@scheme_entry` keep ordering visible and portable across both doors.

### D3 — Resolution: populate `imported` from the import environment

`resolve-globals`/`scope-resolve` (`src/parse.ss`) gain the import environment as a lookup
source between "own top-level" and "primitive" (the order Stage 0 documented). An imported
hit yields `(make-binding 'imported @"L:x")`; the existing `imported`→`(global-ref sym)`
arm already routes it to the `external global i64` hook. A unit is a **closed** scope
(exports a chosen subset of its own defines); a REPL session stays **open**. The resolution
logic is identical across doors — only who populates the import environment differs (D4).

### D4 — Two doors, one export environment

- **AOT (`build-program`, generalizing `bin/scheme-compile`/`src/compile.ss`):** read the
  program's `(import (L))`, resolve `L` via the manifest to its source, `compile-unit` the
  library (writing `L.ll` + `L.exports` under `build/lib/`), build the import env from
  `L.exports`, compile the program against it, then
  `clang runtime.c L.ll prog.ll -lgc -o exe`. Stage 1 is one non-transitive library, so no
  topological ordering yet.
- **REPL (`src/repl/host.cpp` + `src/repl-core.ss`):** on `(import (L))`, resolve `L`,
  `addIRModule` `L.ll` into the shared JITDylib, look up and call `@"L:__init"` once, and
  merge `L.exports` into the session scope as imported bindings so later forms emit
  `external global` references resolved across the dylib.

Both call the same `compile-unit`, so `L.ll` is identical across doors — verified by
extending self-emission-equivalence to the unit.

### D5 — Manifest

A readable s-expression, default `./emit-libs.scm` (override `--manifest`):
`((library (mylib) (source "…/mylib.sld") (artifacts "build/lib")) …)`. The driver maps a
library name → source (+ optional artifact dir; defaults under `build/`). Kept to the two
entries the slice needs; richer search/defaults are Stage 2.

### D6 — Surface parsing

`define-library` groups `(export …)`, `(import …)`, and `(begin …)`/body declarations. Stage
1 parses the subset into `(imports exports body-forms)` and feeds the body through the
existing pipeline with the library naming context set. Recognizing these forms lives at the
front of the pipeline (a small step before/within expansion) so the rest of the passes are
unchanged.

## Risks / Trade-offs

- **[Library emission accidentally changes library-free program IR]** → library mode is a
  distinct emit path keyed off a non-empty unit; the program unit stays empty-prefix.
  Mitigation: keep Stage 0's demo byte-identity check green (`test/module-scaffold-baseline.sh`).
- **[A unit's `.ll` differs between the AOT and REPL doors]** → both doors call one
  `compile-unit`. Mitigation: a cross-door byte-identity test (self-emission-equivalence
  extended to the unit) is a Stage-1 gate.
- **[`__init` ordering / double-run]** → the one-shot `@"L:__inited"` guard makes `__init`
  idempotent now; Stage 1's single import needs no ordering, and the guard is ready for
  Stage 2's diamonds.
- **[Core acquires I/O to read `.exports`/manifest]** → forbidden; the import env crosses
  into the core as data, and all file/subprocess work stays in drivers/hosts. Mitigation:
  keep `compile-unit` a pure `forms+name+env → text+table` function.
- **[`CORE_FLAT` edits leave committed IR stale]** → run `make regen`; the anti-stale
  trust-check in `run-dev-tests.sh` fails loudly otherwise.
- **[Scope creep from rename/transitive imports]** → explicitly deferred to Stage 2; Stage 1
  is one library, one export, one importer.

## Migration Plan

1. Add `define-library`/`export`/`import` surface parsing → `(imports exports body)`.
2. Add `compile-unit` to the core; add library-mode emission (per-export externals, guarded
   `__init`, no `@scheme_entry`) reusing Stage 0's unit naming.
3. Populate `imported` in the resolver from the import environment.
4. Generalize the program's `@scheme_entry` to call imported `__init`s.
5. AOT `build-program` (manifest read, unit compile, multi-`.ll` link) + REPL `import`
   (`addIRModule` + `__init` + export merge).
6. Manifest reader; `build/lib/` artifact layout; observability narration.
7. `test/modules-*` suite (both doors, cross-door byte-identity, no-collision blocker);
   `make regen` if `CORE_FLAT` changed; both suites green.

Rollback is a single revert per step; the change is additive (new surface, a new emit mode
behind the unit key, new driver/manifest) with no change to library-free program behavior.

## Open Questions

- Does the import environment cross the compile-unit FFI as serialized `.exports` text or as
  an in-process Scheme structure held by the embedded compiler? (Master design open question;
  Stage 1 can start with in-process state since one process drives both compile and link.)
- `.sld` vs plain-`.scm` for the library source file extension in the manifest — pick the
  R7RS-conventional `.sld` unless it complicates the reader.
- Printable-safe library-name normalization for punctuation/integer parts is settled by
  Stage 0's `mangle`; confirm nothing in `__init`/export-symbol emission re-introduces an
  LLVM-illegal unquoted form.
