## Why

The prelude (`src/prelude.scm`) is prepended, as source text, to every program the compiler
compiles — the one piece of "library zero" that is not yet a module. Stages 1–2 built a real
separate-compilation system (`define-library`, export/rename, transitive imports, both
doors); Stage 3 of the Modules v0 design
(`docs/superpowers/specs/2026-07-15-modules-v0-design.md`, D6) finishes v0 by re-homing the
prelude as the library **`(scheme base)`**: its procedures become a real linked/loaded
library artifact, its derived-form macros become a compile-time set auto-merged into every
scope, and both are auto-imported so existing programs keep working with no source change.
This makes "the prelude is library zero" literally true for user code and exercises the
module system on the largest, most-depended-on unit in the tree.

Per the chosen scope, **the compiler's own bootstrap keeps prepending the prelude** (the
`T-* = prelude ++ compiler` assembly and the self-hosting fixed-point *logic* are unchanged;
`(scheme base)` is not linked into the compiler binaries for their own execution). Only the
**user-program and REPL** compile paths re-home. This contains the self-referential risk the
full re-home would concentrate here, and leaves that as a clean follow-on.

## What Changes

- **Split the prelude into two halves** driven from the single `src/prelude.scm` source:
  - **Runtime half → the `(scheme base)` library**: the prelude's ~89 procedure definitions,
    wrapped as `(define-library (scheme base) …)` exporting all of them, compiled once to
    `scheme.base.ll` + `scheme.base.exports` and linked (AOT) / loaded (REPL) like any Stage-2
    library. Its body is compiled with the derived-form macros in scope (prelude procedures
    use `cond`/`case`/`when`/… internally).
  - **Compile-time half → the derived-form macros** (`and`, `or`, `when`, `unless`, `let*`,
    `cond`, `case`, `guard`, `%guard-clauses`): carried by the compiler and auto-merged into
    every user program's / REPL session's `macro-env` at expand time (until macro
    phase-separation lets them travel in `.exports`, a v0 non-goal).
- **Auto-import `(scheme base)`**: a prelude-enabled user program (and REPL session) behaves
  as if it began with `(import (scheme base))` — its procedures resolve as imported external
  globals and `scheme.base.ll` is linked/loaded — and the derived-form macro set is merged in.
  User-wins shadowing falls out of the Stage 0 resolution order (own defines beat imports).
- **`--no-prelude` skips both halves** (no auto-import, no macro merge), exactly as it skips
  the prepended prelude today.
- **Add `(scheme base)` to the default manifest** with a source under `lib/scheme/base.sld`,
  so both doors resolve it through the Stage-2 manifest/graph machinery.
- **Regenerate the Stage-0 byte-identity baseline**: re-homing intentionally changes the
  emitted IR of prelude-using programs (prelude procedures become imported externals + a
  linked `scheme.base.ll`), so `test/module-scaffold-baseline.sha256` is regenerated; the
  demos' **values** must stay identical (behavior preserved).
- **Tests**: a program that uses only prelude procedures builds/runs via `(scheme base)` on
  both doors; the derived-form macros work without a prepended prelude; `--no-prelude` leaves
  prelude names unbound; `(scheme base)` links exactly once; demo values unchanged.

## Capabilities

### New Capabilities
<!-- None; Stage 3 extends the existing module-system capability from Stages 0–2. -->

### Modified Capabilities
- `module-system`: Adds requirements for the `(scheme base)` runtime/macro split, implicit
  auto-import of `(scheme base)` (with `--no-prelude` opt-out), and the manifest entry for it.
  No Stage 0–2 requirement is weakened for library-free programs that also pass
  `--no-prelude`; the Stage-0 "scaffolding preserves emitted IR" invariant is explicitly
  superseded for prelude-using programs (their IR now reflects the imported library), with
  behavior (demo values) preserved.

## Impact

- **Prelude source (`src/prelude.scm`) + a generated `lib/scheme/base.sld`:** the single
  prelude source is split (build-time or checked-in) into the procedure library and the
  macro set; drift between the two is prevented by generating one from the other or by a
  guard.
- **User compile paths:** the Chez batch driver (`src/compile.ss`), the embedded runner
  (`src/run.cpp` + `src/entry-embed.scm`), the AOT wrapper (`bin/scheme-compile`), and the
  REPL (`src/repl/host.cpp` + `src/repl-core.ss`) switch a prelude-enabled compile from
  "prepend full prelude" to "auto-import `(scheme base)` + merge derived-form macros",
  reusing Stage 2's `compile-program-with-imports` (which already accepts prelude/macro forms)
  and manifest/graph/link machinery.
- **Committed IR (`bootstrap/*.ll`):** regenerated — the embedded entry and `repl-core`
  change, so `embed.ll`/`embed-repl.ll` change; `regen.sh`'s prepend *structure* is unchanged
  and the compiler does not link `(scheme base)` for itself, so the self-hosting fixed point
  re-establishes cleanly. The anti-stale **trust-check is the gate** (`make regen` reproduces
  the new committed IR byte-for-byte).
- **Tests:** the Stage-0 baseline reference is regenerated; new `test/modules-*` cases on both
  doors; the demo-values and self-hosting/trust-check suites must stay green.
- **Dependencies:** builds on the archived `module-generalize` (Stage 2).
- **Out of scope / v0 non-goals:** the compiler's OWN re-home onto `(scheme base)` (deferred
  follow-on); macro phase-separation / macros travelling in `.exports`; `only`/`except`/
  `prefix`; splitting `(scheme base)` into finer R7RS libraries (`(scheme write)` etc.).
