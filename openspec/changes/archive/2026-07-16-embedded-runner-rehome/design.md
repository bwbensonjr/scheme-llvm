## Context

Modules v0 Stage 3 (`module-prelude-scheme-base`) re-homed the prelude as the R7RS library
`(scheme base)`, auto-imported into every prelude-enabled compile. That re-homing landed on two
of the three compile doors:

- **Chez batch driver** (`src/compile.ss`): reads `emit-libs.scm`, compiles `lib/scheme/base.sld`
  to `scheme.base.ll` (cached under `build/lib`), auto-imports it, and threads the import table
  into the shared-core `compile-program-with-imports`; `--no-prelude` skips it.
- **REPL** (`src/repl-core.ss` + `src/repl/host.cpp`): preloads `(scheme base)`, auto-imports it
  (host "mode 6"), merges the derived-form macros into the session.

The **third door — the Chez-free embedded runner** — was explicitly deferred. Today
`build/scheme-run` (`src/run.cpp` + `bootstrap/embed.ll`) and `bin/scheme-compile --emit` drive
the embedded entry `src/entry-embed.scm`, which is a single line:

```scheme
(compile-source-with-prelude *prelude-source* (read-all-stdin))
```

`compile-source-with-prelude` calls `with-prelude`, which **prepends the ~89 prelude definitions
as source forms** (dropping any the user shadows). So after Stage 3 the two AOT paths diverge in
emitted IR: the Chez driver emits a program that imports `scheme.base` externals plus a linked
`scheme.base.ll`, while `scheme-run`/`scheme-compile` inline the prelude. Values still match, but
the `compiler-embedding` spec's "runner output matches AOT output" and "no separate compilation
path for the runner" guarantees are now only satisfied at the value level, not structurally — and
the module-system spec carries an explicit placeholder saying the runner "provides the same
prelude by prepend pending its follow-on re-home."

**Constraints that shape the design:**
- The embedded entry must have **no filesystem access** (spec: "bake in the standard prelude so
  the embedded compiler performs prelude-correct compilation with no filesystem access"). The
  baked-in `*prelude-source*` string is already present in the assembled core.
- The embedded compiler emits **host-agnostic IR** (no target header); the Chez-driver-built
  `scheme.base.ll` embeds a host triple, so the runner cannot simply reuse that artifact.
- `src/run.cpp` handles exactly one IR module string; `bin/scheme-compile` links exactly one `.ll`.
- The compiler's **own bootstrap keeps prepending the prelude** — this change does not link
  `(scheme base)` into the compiler binaries for their own execution.

## Goals / Non-Goals

**Goals:**
- Re-home the Chez-free embedded batch runner to `(scheme base)`: auto-import + derived-form macro
  merge, driven entirely from the baked-in prelude source, so the runner exercises the real module
  system.
- Restore the `compiler-embedding` guarantees structurally: `scheme-run --emit` and the Chez driver
  emit **byte-identical program IR** for the same prelude-using program.
- Keep all re-homing logic in the Scheme core; leave `src/run.cpp` and `bin/scheme-compile`'s
  single-module IR handling unchanged.
- Add `--no-prelude` parity to the runner.

**Non-Goals:**
- Re-homing the compiler's own bootstrap (`T-* = prelude ++ compiler`); the self-hosting fixed
  point stays prepend-based.
- Macro phase-separation / macros traveling in `.exports` (a v0 non-goal); the derived-form macros
  continue to be carried and merged compile-time.
- The stateful incremental REPL entry (`entry-embed-repl` / `embed-repl.ll`) — already re-homed in
  Stage 3; untouched here except for shared-core effects.
- Reading `lib/scheme/base.sld` or any manifest from disk at runtime.

## Decisions

### D1 — Assemble `(scheme base)` inside the embedded entry, from baked-in prelude source

The embedded entry gains the logic to construct the `(scheme base)` `define-library` form from
`*prelude-source*` — the same split `tools/gen-scheme-base.ss` performs (procedures → exported
`define-library` body; the 9 derived-form macros → body, not exported, so the library
self-compiles), but in the portable core rather than in a Chez script. It then compiles that
library as a unit to obtain its IR + export table, compiles the user program through
`compile-program-with-imports` with `(scheme base)` in the import set, and merges the derived-form
macros into the program's `macro-env`.

**Why:** This reuses Stage 2's `compile-program-with-imports` — the *same* path the Chez driver
takes — so "one compiler core" holds and byte-identity with the driver's program IR falls out. The
prelude source is already baked in, so no filesystem access is needed.

**Alternatives considered:**
- *Read `lib/scheme/base.sld` / `scheme.base.ll` from disk at runtime.* Rejected: breaks the
  no-filesystem, host-agnostic embedding contract and needs a prebuilt, host-specific artifact.
- *Keep prepending but relabel.* Rejected: does not restore structural IR parity and leaves the
  runner outside the module system — the whole point of the follow-on.

### D2 — Return two modules, sentinel-delimited: `(scheme base)` IR then program IR

The entry returns a single string holding **two** emitted modules separated by a fixed boundary
marker (a line that cannot appear in emitted core IR, e.g. `\n; ==EMIT-UNIT-BOUNDARY==\n`): the
`(scheme base)` library IR, the marker, then the program IR. `src/run.cpp` splits on the marker
and adds **both** modules to the JIT (`(scheme base)` first, then the program, whose `external`
references to `scheme.base:*` resolve against it); `bin/scheme-compile` splits into two `.ll`
files and `clang`-links both with the runtime. This mirrors the Chez driver's separate-unit
linking exactly, so the emitted **program** module is byte-identical to the driver's `prog.ll`.

**Why (revised after reading `emit.ss`):** the two modules cannot be raw-text-concatenated into
one LLVM module. `emit-library-batch` and `emit-program-with-imports` each emit, from a reset
counter, a `define internal i64 @__apply0(...)` (a fixed name hardcoded in `rt_run_guarded`;
`(scheme base)` emits it because it uses `guard`/error procedures) and string globals
`@.str.sym.0`/`@.str.lit.0`… — so one merged module would have duplicate `@__apply0` definitions
and colliding string globals. The Chez driver avoids this precisely by keeping them separate
modules and letting `clang` link them (internal symbols stay module-private). The sentinel
mechanism keeps them separate for the runner too, all compilation logic stays in the Scheme core,
and the program IR stays byte-identical to the driver's.

**Alternatives considered:**
- *Raw single-module concatenation (the original propose-phase choice).* Rejected on reading
  `emit.ss`: it produces invalid IR (duplicate `@__apply0`, colliding `@.str.*` globals).
- *Valid single module via a new combined-emit path.* Would keep the hosts unchanged, but the
  program IR is no longer byte-identical to the driver (globals renumbered across the two halves),
  dropping fidelity to value-parity, and it adds nontrivial `emit.ss` code that risks the
  self-hosting fixed point. Rejected: more compiler surface for weaker fidelity.

**Cost:** `src/run.cpp` and `bin/scheme-compile` gain a small split step (~10 lines each) rather
than staying literally unchanged — the module *handling* grows from one module to two, but the
compilation logic still lives entirely in the core.

### D3 — `--no-prelude` forwarded via an environment variable read by the entry

`scheme_entry` takes `void` and reads the program from stdin. `run.cpp`/`scheme-compile` already
parse argv (`--emit`); they gain `--no-prelude` and communicate it to the entry by setting an
environment variable (e.g. `EMIT_NO_PRELUDE`) that the entry checks through a small runtime
primitive (a `getenv` shim in `src/runtime/runtime.c` exported for the compiled core). With the
flag set, the entry skips D1/D2 entirely and emits only the program IR.

**Why:** Smallest viable channel; leaves stdin as pure program source and the single-module IR
handling untouched. This is the one place `run.cpp`/`scheme-compile` change, and only to forward a
flag — not to touch module handling (reconciles the "hosts unchanged" intent with `--no-prelude`
parity).

**Alternatives considered:**
- *Prepend a directive line to stdin.* Rejected: pollutes the source channel and complicates
  `--emit`.
- *Add an argv-carrying entry variant.* Rejected: larger surface than an env-var check; the entry
  is deliberately `void`-signatured for the string-FFI shim.

### D4 — Regenerate `bootstrap/embed.ll`; leave `schemec.ll` and `embed-repl.ll` semantics alone

`entry-embed.scm` is assembled into `T-embed.scm` → `embed.ll`, so changing the entry regenerates
`embed.ll` via `make regen` (Chez-free, idempotent). `schemec.ll` (prelude-free filter) is
unaffected; `embed-repl.ll` (REPL, already re-homed) changes only if shared core changes. The
module-scaffold byte-identity baseline governs the *compiler's own* committed IR, whose bootstrap
still prepends — unaffected; the embedded runner's emitted IR for *user* prelude-using programs
changes intentionally, and is validated by the new runner↔driver IR-parity test rather than the
baseline.

## Risks / Trade-offs

- **[Concatenated library IR drifts from the driver's `scheme.base.ll`]** → The library IR is emitted
  by the same embedded compiler core that the driver drives; the new test asserts byte-identical
  *program* IR against the driver and identical demo values, catching any drift in CI.
- **[Duplicate `scheme.base:*` symbols if `(scheme base)` were emitted more than once]** → The entry
  emits it exactly once ahead of the program; enforced by the module-system "links or loads exactly
  once" requirement and a test asserting a single occurrence in the emitted module.
- **[Re-homing perturbs the self-hosting fixed point]** → Out of scope by construction: the compiler's
  own bootstrap still prepends; only the embedded *entry's* runtime behavior changes. `make regen`
  must still reach a byte-identical fixed point for `embed.ll`; verified by the existing regen
  idempotence check.
- **[`getenv` in the compiled core adds a runtime dependency]** → A single, well-scoped
  `RT_NO_MAIN`-safe shim; only consulted by the entry at startup, no effect on emitted user IR.
- **[Prelude-source split logic now duplicated in Chez (`gen-scheme-base.ss`) and the core]** → Both
  derive from the single `src/prelude.scm`; the existing `test/scheme-base-gen-check.sh` guard plus
  the new IR-parity test keep them consistent. A future cleanup could share one splitter.

## Migration Plan

1. Implement D1–D3 in the core / entry / runtime / hosts.
2. `make regen` to rebuild `bootstrap/embed.ll` (Chez-free) to a byte-identical fixed point;
   relink `scheme-run` and `scheme-compile`.
3. Add runner↔driver IR/value parity and `--no-prelude` tests to `run-all-tests.sh` /
   `run-dev-tests.sh`; confirm demo values unchanged.
4. Update `README.md` / `docs` references that describe the runner as prepending the prelude.

**Rollback:** revert the entry/host/runtime commits and `git checkout` the prior `bootstrap/embed.ll`;
the prepend path is fully self-contained and returns the runner to Stage-3 behavior.

## Open Questions

- Exact env-var name and whether to reuse an existing runtime hook vs. add a dedicated `getenv`
  shim — settle during apply.
- Whether the `(scheme base)` splitter logic should be factored into one core routine shared with
  `gen-scheme-base.ss` now, or left as a noted follow-on cleanup.
