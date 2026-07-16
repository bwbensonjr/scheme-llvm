## Why

Stage 3 (`module-prelude-scheme-base`) re-homed the prelude as the library `(scheme base)`
— auto-imported and linked/loaded as a real module — but **only for the Chez driver
(`src/compile.ss`) and the REPL**. Its commit explicitly deferred the **Chez-free embedded
runner** (`build/scheme-run` and `bin/scheme-compile --emit`, driven by `src/entry-embed.scm`
→ `compile-source-with-prelude`) as a clean follow-on: that path still **prepends the prelude
source text** to every program via `with-prelude`. As a result the two AOT paths now diverge —
the Chez driver emits IR in which prelude procedures are imported externals plus a linked
`scheme.base.ll`, while the embedded runner inlines the prelude's ~89 definitions. This
contradicts the `compiler-embedding` spec's standing guarantees that "runner output matches
AOT output" and that "there SHALL NOT be a separate compilation path for the runner," and it
leaves the largest, most-depended-on unit unexercised by the module system on the Chez-free
door. Re-homing the embedded runner closes the last gap in Modules v0's dev→ship fidelity.

## What Changes

- **The embedded batch entry auto-imports `(scheme base)` instead of prepending the prelude.**
  `src/entry-embed.scm` (and the supporting core) compiles `(scheme base)` from the compiler's
  **baked-in prelude source** — no filesystem access — into a library artifact + export table,
  then compiles the user program *importing* `(scheme base)` via the existing
  `compile-program-with-imports` machinery, and merges the derived-form macros
  (`and`/`or`/`when`/`unless`/`let*`/`cond`/`case`/`guard`/`%guard-clauses`) into the program's
  `macro-env` at expand time. This is the same compiler-core logic the Chez driver already uses
  — now reached on the Chez-free door — so the runner exercises the real module system.
- **The entry returns two modules, sentinel-delimited: `(scheme base)` IR then program IR.** They
  cannot be merged into one LLVM module (both emit a fixed `@__apply0` and reset string globals, so
  they would collide), so the entry separates them with a boundary marker. `src/run.cpp` splits on
  the marker and adds both modules to the JIT (`(scheme base)` first, then the program, whose
  `external` refs to `scheme.base:*` resolve against it); `bin/scheme-compile` splits and
  `clang`-links both `.ll` with the runtime. This mirrors the Chez driver's separate-unit linking,
  so the emitted **program** module is byte-identical to the driver's. All compilation logic lives
  in the Scheme core; the hosts gain only a small split step.
- **`--no-prelude` parity on the runner.** `scheme-run`/`scheme-compile` gain `--no-prelude`,
  forwarded through the smallest viable channel to the entry (an env var checked by the entry
  via a runtime primitive), which then skips both halves — no auto-import, no macro merge,
  prelude names left unbound — matching `src/compile.ss`. The single-module IR handling in the
  host is otherwise untouched.
- **Regenerate the committed embedded IR.** Changing the embedded entry changes `bootstrap/embed.ll`
  (the assembled batch compiler); `make regen` rebuilds it Chez-free. `schemec.ll` (prelude-free
  filter) and `embed-repl.ll` (REPL, already re-homed in Stage 3) are unaffected except for any
  shared-core changes. The compiler's own bootstrap keeps prepending the prelude — this change does
  **not** link `(scheme base)` into the compiler binaries for their own execution.
- **Tests**: a prelude-using program produces byte-identical IR and identical values from
  `scheme-run --emit` and the Chez driver; `scheme-run` and `scheme-compile` outputs match the AOT
  path; `--no-prelude` leaves prelude names unbound on the runner; `(scheme base)` appears exactly
  once in the emitted module; demo values unchanged.

## Capabilities

### New Capabilities
<!-- None; this completes an existing capability rather than introducing a new one. -->

### Modified Capabilities
- `compiler-embedding`: The embedded batch entry and runner re-home the prelude to `(scheme base)`
  (auto-import + derived-form macro merge, built from baked-in prelude source with no filesystem
  access), emitting the library IR concatenated ahead of the program IR; the runner gains
  `--no-prelude` parity. This restores the spec's "runner output matches AOT output" and
  "one compilation path for the runner" guarantees against the Chez driver *after* Stage 3's
  re-homing, and supersedes the description of the entry as prepending the prelude.
- `module-system`: The implicit `(scheme base)` auto-import (with `--no-prelude` opt-out) and its
  manifest entry, established for the Chez door in Stage 3, now also hold on the Chez-free embedded
  door — the same requirement satisfied by a second, portable implementation.

## Impact

- **Code**: `src/entry-embed.scm` (auto-import + macro merge + concatenated emit); shared core in
  `src/core.ss`/`src/compile.ss`-equivalents as needed to make `(scheme base)` assembly reachable
  from the embedded entry (reusing `compile-program-with-imports`); `src/runtime/runtime.c` (a small
  env-var/getenv hook so the entry can see `--no-prelude`); `src/run.cpp` + `bin/scheme-compile`
  (parse and forward `--no-prelude`; single-module handling unchanged).
- **Committed artifacts**: `bootstrap/embed.ll` regenerated via `make regen` (Chez-free, idempotent
  fixed point).
- **Tests / CI**: additions to `run-all-tests.sh` / `run-dev-tests.sh` for runner↔driver IR/value
  parity and `--no-prelude`; the module-scaffold byte-identity baseline is unaffected for the
  compiler's own IR (its bootstrap still prepends) but the embedded runner's emitted IR for
  prelude-using programs changes intentionally.
- **Docs**: update `README.md` / `docs` references that describe `scheme-run`/`scheme-compile` as
  prepending the prelude.
- **No breaking change** to user-observable values; a deliberate IR change for prelude-using
  programs compiled via the embedded runner.
