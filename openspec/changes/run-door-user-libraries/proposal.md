## Why

The Chez-free in-process runner `build/scheme-run` is the "run-program" door of the
module system, but it is the only door that cannot load **user** libraries. It bakes in
`(scheme base)` and auto-imports only that; it has no manifest and no filesystem access, so
`(import (mylib))` fails with an unbound variable. `docs/MODULES.md` (lines 117, 126) flags
this explicitly as "future work." This is the last module-door gap: the **AOT door**
(`build and link an importing program`) and the **REPL door** (`import a library
interactively`) both already resolve user libraries, the latter Chez-free. Closing it
reaches door parity and finishes "the proven surface" that later packaging work
(`openspec/explorations/packaging-and-emit-cli.md`, slice #3) is gated on.

The REPL door already solved exactly this problem Chez-free, and its machinery is reusable:
the C++ host does the manifest/file I/O and feeds source text to the in-process compiler
through a small mode protocol (`src/repl-core.ss`: mode 5 "manifest text → source paths",
mode 4 "load-library source text → unit IR + `__init`", mode 6 auto-import `(scheme base)`).
This change makes the run-program host reuse that same protocol rather than growing a second
resolution path.

## What Changes

- **`scheme-run` resolves and loads user libraries via a manifest.** Given a program with
  `(import (foo bar))`, the run host reads the manifest, transitively loads the imported
  libraries as compiled units (JIT-ing each unit + its `__init`), then compiles and runs the
  user program importing them — mirroring how `repl-host` preloads a session's libraries.
- **Manifest source: default `emit-libs.scm`, overridable by `--manifest FILE` and the
  `EMIT_MANIFEST` env var** — the same resolution the Chez driver and REPL already honor.
  When no manifest is present and the program imports only `(scheme base)` (or nothing),
  behavior is unchanged (no regression for today's programs).
- **Reuse the existing compiler-side mode protocol** (`repl-load-library-text`,
  `repl-manifest-paths`, auto-import), driven from the run host (`src/run.cpp`) — no new
  library-resolution logic in the compiler core. The host gains the manifest/file I/O and
  the topological preload loop; the Scheme side is reused as-is where possible.
- **Dev→ship fidelity is a hard acceptance criterion.** A program built+run through
  `scheme-run` with a given manifest MUST behave identically to the same program through the
  AOT door with the same manifest.

Non-goals (deferred): manifest schema extensions such as a bin/project entry (that is
packaging slice #2); any dependency/registry/version/lockfile model; renaming binaries under
a unified `emit` CLI (packaging slice #1). This change only brings the *run* door to parity
with the *AOT* and *REPL* doors on the **existing** manifest format.

## Capabilities

### New Capabilities
<!-- None — this extends the existing module-system surface. -->

### Modified Capabilities
- `module-system`: add a requirement for the run-program (in-process, Chez-free) door to
  resolve user libraries via the manifest, complementing the existing "AOT door — build and
  link an importing program" and "REPL door — import a library interactively" requirements.

## Impact

- **Code**: `src/run.cpp` (manifest/file I/O + topological library preload before running the
  program, mirroring `repl-host`/`src/host.cpp`); `src/entry-embed.scm` and possibly small
  shared factoring with `src/repl-core.ss` so the run host reuses the mode protocol; argument
  parsing for `--manifest` on the run path. No expected change to the emitter, so committed
  `bootstrap/*.ll` should be unaffected — but if the embedded entry's emitted IR changes,
  `make regen` + the trust-check apply.
- **Doors/fidelity**: run-program output must match the AOT door for the same manifest;
  covered by value-equivalence tests across the module test suites (`test/modules/`).
- **Tests**: extend `test/modules/` (or the demo harness) to run importing programs through
  `scheme-run` and assert parity with the AOT/JIT backends.
- **Docs**: update `docs/MODULES.md` to remove the "future work" caveat for the embedded
  runner and document `scheme-run --manifest`.
- **Compatibility**: additive. Programs importing only `(scheme base)` or nothing are
  unaffected; the manifest is consulted only when the program imports a non-baked-in library.
