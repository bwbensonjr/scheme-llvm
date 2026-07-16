## Context

Stage 3 of Modules v0 (`docs/superpowers/specs/2026-07-15-modules-v0-design.md`, D6),
building on the archived Stages 0–2. The prelude (`src/prelude.scm`) is the last piece of
"library zero" still delivered by textual **prepend**: ~89 procedure definitions plus 9
derived-form macros (`and`, `or`, `when`, `unless`, `let*`, `cond`, `case`, `guard`,
`%guard-clauses`). Prelude procedures use the macros internally (e.g. `case` expands over
`memv`), so the two halves are coupled at compile time.

The prelude is prepended in several places today: the Chez batch driver
(`src/compile.ss` `with-prelude`, `program-forms`); the embedded runner
(`src/entry-embed.scm` → `compile-source-with-prelude *prelude-source*`, driven by
`src/run.cpp`); and the REPL (`src/repl-core.ss` `repl-load-prelude!` / `init-session`, driven
by `src/repl/host.cpp`). The compiler **compiles itself** by prepending the prelude to its own
source (`tools/regen.sh` assembles `T-* = prelude ++ compiler`, compiled by `schemec`).

Stage 2 already gives us everything the re-home needs: a manifest → transitive-closure →
topological build/link/init pipeline (`build-modular-program`), a `compile-program-with-imports`
core entry that **already takes `prelude-forms` and merges them for macro collection** while
resolving imports as external globals, a REPL that preloads manifest libraries and honors
`(import (L))`, and a one-shot `@"L:__inited"` guard. Stage 3 is largely *re-wiring* those
parts, not new compiler machinery.

**Chosen scope (user + REPL only):** user-program and REPL compiles re-home onto `(scheme
base)`; the compiler's own bootstrap keeps prepending the prelude. Concretely, `regen.sh`'s
`T-* = prelude ++ compiler` structure and the self-hosting fixed-point *logic* are unchanged,
and `(scheme base)` is **not** linked into `schemec`/`scheme-run`/`repl-host` for their own
execution. `bootstrap/*.ll` is still regenerated (the embedded entry and `repl-core` change),
but to a new, cleanly reproducible fixed point — the anti-stale trust-check is the gate.

## Goals / Non-Goals

**Goals:**
- `(scheme base)` as a real library: runtime half → `scheme.base.ll` + `scheme.base.exports`;
  compile-time half → the derived-form macro set carried by the compiler.
- Auto-import `(scheme base)` for user programs and the REPL (procedures as imported
  externals + linked/loaded `scheme.base.ll`; macros merged into `macro-env`); `--no-prelude`
  skips both halves; user defines shadow imports.
- One prelude source of truth (`src/prelude.scm`); the two halves are derived from it.
- Both doors reuse the Stage-2 manifest/graph/link/preload machinery; `(scheme base)` links
  and initializes exactly once.
- Behavior preserved: demo **values** unchanged; suites + self-hosting + trust-check green
  after `make regen`.

**Non-Goals:**
- The compiler's OWN re-home onto `(scheme base)` (deferred follow-on; keeps regen.sh/Makefile
  structure and the fixed-point logic unchanged this stage).
- Macro phase-separation / macros travelling in `.exports` (v0 non-goal — macros stay
  compiler-carried).
- `only`/`except`/`prefix`; splitting `(scheme base)` into finer R7RS libraries.
- Byte-identity of prelude-using programs vs pre-Stage-3 (re-home changes their IR by design;
  behavior is the invariant, guarded by demo values).

## Decisions

### D1 — Split the prelude, single source of truth

Keep `src/prelude.scm` as the authoritative source. Derive the two halves mechanically so they
cannot drift:
- **Runtime half:** wrap the prelude's non-`define-syntax` forms in `(define-library (scheme
  base) (export …all procedure names…) (begin …procedures…))`, materialized at
  `lib/scheme/base.sld`. Generation reuses the compiler's own `collect-define-syntax`, which
  already partitions a form list into `(macro-env, runtime-forms)`; the export list is the
  `define-name`s of the runtime forms.
- **Compile-time half:** the `define-syntax` forms, baked into the compiler as a
  `*prelude-macros-source*` constant (the macro-only analogue of today's `*prelude-source*`),
  merged into every prelude-enabled compile's `macro-env`.

*Alternative rejected:* hand-maintain `lib/scheme/base.sld` and a separate macro file.
Rejected — two copies of the prelude drift; deriving both from one source (build-time
generation or a checked-in-plus-guard) keeps them honest.

**Resolved (materialization):** `src/prelude.scm` stays the **single source of truth** — the
compiler still prepends it for its own bootstrap, so `(scheme base)` and the compiler's prelude
can never diverge. `lib/scheme/base.sld` and the derived-form macro constant are **checked in**
(so a reader can see the standard library as ordinary source and a clean build needs no
generation step), guarded by a **regenerate-and-diff** test: a small generator produces both
from `src/prelude.scm`, and the guard fails if the checked-in copies are stale. Evolving the
standard library is therefore one motion — edit `src/prelude.scm`, run the generator, commit
the regenerated `base.sld` + macro constant (and artifacts, D4) — with the guard catching a
forgotten regenerate.

### D2 — Auto-import reuses `compile-program-with-imports` with a macro-only prelude

The core needs **no change** for the Chez batch door. `compile-program-with-imports` already
takes `prelude-forms` (merged for macro collection) and `import-tables`/`init-libs` (resolved
as external globals + ordered inits). Stage 3 wires the driver to call it with:
- `prelude-forms` = the derived-form **macros only** (not the procedures);
- the program's imports **plus an implicit `(scheme base)`** (unless `--no-prelude`).

So the procedures arrive as imported externals from `scheme.base.exports`, the macros arrive
compile-time via `prelude-forms`, and user-wins shadowing is the existing resolution order.

*Alternative rejected:* invent a new "auto-import" core entry. Rejected — the existing entry
already separates the macro-carry channel (`prelude-forms`) from the runtime-import channel
(`import-tables`); Stage 3 only chooses what flows through each.

### D3 — The embedded/REPL doors switch prepend → import+macros (this is what moves bootstrap)

The batch Chez driver can re-home with no bootstrap change (D2), but the shipped **user-facing**
binaries embed the compiler, so re-homing them edits embedded source and regenerates
`bootstrap/*.ll`:
- **`scheme-run` / `scheme-compile` (AOT):** `src/entry-embed.scm` gains a mode that, unless
  `--no-prelude`, compiles the user program via the import+macro path against `(scheme base)`;
  `src/run.cpp` preloads `scheme.base.ll` into its JIT (and, for `--emit`, the driver links it)
  — mirroring how `repl-host` already preloads libraries. `bin/scheme-compile` links
  `scheme.base.ll` (resolved via the manifest) alongside the program.
- **REPL:** `src/repl-core.ss` `init-session` stops prepending the full prelude batch; instead
  it (a) merges the derived-form macros into `*repl-macro-env*`/`*repl-known*`, and (b)
  auto-imports `(scheme base)` — which the host **already preloads** as a manifest library —
  by merging its exports into the session scope. `--no-prelude` still yields an empty session.

Because `entry-embed.scm` and `repl-core.ss` are inside `embed.ll`/`embed-repl.ll`, these
files changing regenerates those two artifacts. `schemec.ll` need not change (the batch/filter
core is untouched). This is the honest cost of "user + REPL": bootstrap is regenerated, but the
compiler's self-compilation still runs on the prepend path and `(scheme base)` is not linked
into the compiler for its own use.

*Alternative rejected:* keep the embedded binaries prepending and re-home only the Chez batch
door. Rejected — the REPL is explicitly in scope, and `scheme-run`/`scheme-compile` are the
primary standalone-executable path; leaving them on prepend would ship two visibly different
prelude behaviors.

### D4 — `(scheme base)` in the default manifest; artifacts committed and kept fresh

Add `(library (scheme base) (source "lib/scheme/base.sld"))` to the default `emit-libs.scm`.
Both doors resolve and build it through Stage 2's manifest/graph/stale-rebuild path. The
REPL preloads it (already its behavior for manifest libraries).

**Resolved (artifacts) — revised during apply:** build `scheme.base.{ll,exports}` **on
demand**, cached by Stage-2 stale-rebuild in `build/lib`, rather than committing the compiled
artifacts. The compiled `.ll` embeds a host-specific `target datalayout`/`triple` header, so a
committed copy would not be portable across dev machines; both re-homed doors already build the
unit once (~1s) and reuse it, and the byte-identity baseline is untouched. The **source**
`lib/scheme/base.sld` is committed and kept in sync with `src/prelude.scm` by the
regenerate-and-diff guard (D1), so "edit `src/prelude.scm` → regenerate → commit" is still one
motion. (The original plan to also commit the compiled artifacts is deferred to the embedded
follow-on, where a Chez-free clean build would actually benefit from skipping the first
compile.)

### D5 — Supersede the Stage-0 byte-identity baseline for prelude-using programs

`test/module-scaffold-baseline.sh` records a sha256 of each demo's emitted IR and fails on
drift. Re-homing legitimately changes that IR (procedures become imported externals + a linked
`scheme.base.ll`). Stage 3 therefore **regenerates** the baseline reference and narrows the
Stage-0 invariant to `--no-prelude` library-free programs (see the modified "Scaffolding
preserves emitted IR"). The behavioral guard moves to the demo-**values** suite, which must
stay green.

*Alternative rejected:* keep the old baseline and exempt prelude demos. Rejected — the
baseline's value is a clean recorded reference; regenerating it (with values as the real
invariant) is clearer than a growing exemption list.

## Risks / Trade-offs

- **[Re-homing breaks the self-hosting fixed point]** → contained by scope: the compiler still
  self-compiles via prepend; `regen.sh` structure and fixed-point logic are unchanged.
  Mitigation: the anti-stale trust-check (`make regen` reproduces committed IR byte-for-byte)
  is the hard gate; run it before landing.
- **[`(scheme base)` body fails to compile without its own macros]** → the runtime half's
  procedures use `cond`/`case`/… Mitigation: compile the `(scheme base)` unit with the
  derived-form macro set in scope (the compiler carries it); a task compiles `scheme.base.sld`
  first, in isolation, and asserts success.
- **[Double-provided prelude: prepended AND imported]** → if any door still prepends while also
  importing, procedures would be multiply-defined. Mitigation: each re-homed door switches
  fully from prepend to import+macros; a test asserts `scheme.base.ll` links exactly once.
- **[Macro expansions reference procedures not yet resolvable]** → a derived-form macro expands
  to calls (`memv`, etc.) that must resolve to `(scheme base)` exports. Mitigation: auto-import
  makes them imported bindings; a test uses `cond`/`case` in a prelude-only program on both
  doors.
- **[Prelude split drifts from source]** → two hand-maintained halves. Mitigation: derive both
  from `src/prelude.scm` (D1) with a regenerate-and-diff guard.
- **[Baseline/demos churn hides a real regression]** → regenerating the byte-identity baseline
  could mask a behavior change. Mitigation: keep demo **values** as the invariant; regenerate
  the IR baseline only after values are confirmed unchanged.
- **[REPL startup cost / ordering]** → the REPL now loads `scheme.base` as a unit at startup
  instead of a prepended batch. Mitigation: it already preloads manifest libraries; auto-import
  is a scope-merge on top.

## Migration Plan

1. Split the prelude (D1): derive `lib/scheme/base.sld` (procedure library + export list) and
   the derived-form macro constant from `src/prelude.scm`; add a regenerate-and-diff guard.
2. Add `(scheme base)` to the default `emit-libs.scm`; compile it in isolation with the macro
   set in scope and confirm `scheme.base.{ll,exports}` are well-formed (guarded init, exports
   all procedures, no `@scheme_entry`).
3. Chez batch door (D2): route a prelude-enabled compile through
   `compile-program-with-imports` with macro-only `prelude-forms` + implicit `(scheme base)`
   import; `--no-prelude` bypasses both.
4. AOT embedded door (D3): `entry-embed.scm` import+macro mode; `run.cpp` preloads
   `scheme.base.ll`; `bin/scheme-compile` links it.
5. REPL door (D3): `init-session` merges derived-form macros and auto-imports the preloaded
   `(scheme base)`; `--no-prelude` yields an empty session.
6. `make regen` (embed/embed-repl change); confirm the new fixed point and the trust-check.
7. Regenerate the Stage-0 byte-identity baseline (D5); confirm demo **values** unchanged.
8. Tests: prelude-only program on both doors; derived-form macros without prepend;
   `--no-prelude` leaves prelude names unbound; `(scheme base)` links once; user-shadow.
   Wire into `run-all-tests.sh` / `run-dev-tests.sh`.

Rollback is per-step; each door is independently revertible to prepend, and the change is
additive (new library artifact + a compile-mode switch behind the prelude flag).

## Open Questions

- **Resolved:** materialization is check-in-plus-guard with `src/prelude.scm` as the single
  source (D1); `scheme.base.{ll,exports}` are committed in a tracked dir and kept fresh by the
  same guard rather than always built on demand (D4).
- Does any prelude procedure rely on a *primitive* the module resolver treats differently once
  the body is a library unit rather than a prepended top-level? (Expected no — Stage 2 library
  bodies already use primitives — confirm when compiling `scheme.base.sld`.)
- Minor: the R7RS `(scheme base)` name has an integer-free two-symbol form; confirm `mangle`
  produces the expected `scheme.base:x` (Stage 0 covered multi-part names; `(scheme base)` is
  the first two-part library actually built).
