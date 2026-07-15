# Design: Modules v0 — separate compilation, procedures-only (R7RS-small subset)

Status: design / approved for planning
Date: 2026-07-15
Related: `openspec/explorations/modules-and-embedding.md` (the triangle; roadmap step 2),
`openspec/explorations/namespace-model.md` (scope + mangling model),
`CLAUDE.md` design goals (one compiler core; standalone executables; module = shared
unit of compilation; R7RS-small surface).

## Context

The compiler is whole-program today: a program's forms *plus the entire prelude* compile
into a single LLVM module with one `@scheme_entry`, linked with the C runtime into an
executable. There is no separate compilation — you cannot compile unit A → `a.ll`, unit B →
`b.ll`, and link them into one executable with A and B referencing each other. Three
concrete blockers:

- Lifted code blocks are named `@code1, @code2…` from a per-compilation counter
  (`src/passes/lower.ss:48`, `src/emit.ss:637`), so two units collide on link.
- Every emitted module defines its own `@scheme_entry` — linking two is a duplicate symbol.
- There is no module boundary: the whole-program compile sees all forms at once to build
  the macro environment, the hygiene rename set, and the global-name set.

Separate compilation is a stated goal (`CLAUDE.md`: "A module is the shared unit of
compilation… compiles once to an artifact (IR/object + compile-time export interface)…
Target R7RS-small"). The embedding roadmap's step 2 is exactly this. Two building blocks
already exist: `llvm-link` is used to merge program+runtime (`src/compile.ss:164-171`), and
the REPL already does symbol-level incremental compilation — top-level globals are emitted
as stably-named `@"name"` (`src/emit.ss:590`) and referenced-but-undefined globals become
`external global i64` (`src/emit.ss:706-710`), resolved by name in a shared JITDylib.

This design was reached by brainstorming from those two exploration docs; it fixes the v0
slice and the concrete mechanisms.

## Goals / Non-Goals

**Goals:**
- A `define-library` compiles once to a reusable artifact usable through **both doors**:
  linked into an AOT executable, and `addIRModule`'d into the interactive REPL — the same
  bytes, verified byte-identical.
- Support the R7RS-small surface subset: `define-library`, `export` (including
  `(export (rename internal external))`), and whole-module `(import (name))`.
- Deterministic, readable, module-qualified export symbols that are stable across separate
  compilations (the cross-unit ABI).
- Library discovery via an explicit manifest/registry.
- Re-home the prelude as one implicit library `(scheme base)`, auto-imported, so existing
  programs are unaffected.
- One compiler core drives both doors (no second compilation path); the pure core stays
  free of filesystem/subprocess I/O.

**Non-Goals (deferred, explicit):**
- Macro export / phase separation (the `.exports` compile-time macro half). v0 exports
  **procedures only**; the prelude's derived-form macros stay compile-time.
- Import-set transforms `only` / `except` / `prefix` (rename *is* in v0, on `export`).
- Fine-grained prelude partitioning into `(scheme write)` / `(scheme char)` / `(scheme cxr)`.
- Dead-code elimination beyond "an unused library unit simply isn't linked".
- `cond-expand`, `include` / `include-library-declarations`.
- First-class / dynamic libraries; `eval` / `(scheme eval)`.
- Renaming the shipped tools to `emit` (kept as a deferred, now-well-informed follow-on).

## Decisions

### D1 — Module compilation lives in the embedded compiler, not the `schemec` filter

Module-aware compilation needs richer input than a text filter's stdin→stdout seam: a unit
must know *which library it is* and *its imports' export tables*. The REPL door already
requires the in-process embedded compiler (Path A). So the embedded compiler gains a
**compile-unit** capability, and the AOT path drives that *same* embedded compiler to emit
each unit before linking. `schemec` (the pure whole-program text→IR filter) is unchanged.
This upholds "one compiler core" and reuses the embedding's C-ABI/string FFI.

*Alternative rejected:* extend `schemec`'s stdin protocol to carry library name + import
tables. Rejected — it grows a second, filter-shaped module path parallel to the embedded
one, risking drift the "one core" goal forbids.

### D2 — The compilation unit and its two artifacts

A `define-library` compiles to two files (the `.hi`/`.mli` split):

- **`<unit>.ll`** — an LLVM module with:
  - one `external`-linkage global per **exported** binding holding its closure
    (`@"scheme.base:map" = global i64 0`);
  - **no `@scheme_entry`**; instead an init function `@"L:__init"()` that runs the
    library's top-level defines to populate its globals, guarded by a one-shot
    `@"L:__inited"` flag (diamond-import safe);
  - module-qualified names for internal top-levels *and lifted code blocks*
    (`@"L:%helper"`, `@"L:code1"`) — the fix for the code-label collision blocker.
- **`<unit>.exports`** — a small readable table: the library name plus
  `external-name → mangled-symbol` for each export (procedures only in v0; a macro slot is
  reserved but unused).

The final program keeps its single `@scheme_entry`, which first calls each imported
library's `__init` in dependency order (`(scheme base)` first), then runs the program body
— generalizing what `@scheme_entry` already does running top-level thunks in order
(`src/emit.ss:642-663`). The pure core turns *forms + an in-memory import environment* into
IR text; reading `.exports`/manifest files, ordering deps, and writing artifacts are
driver/host effects (preserving the core's no-I/O invariant).

### D3 — Resolution model (the scope abstraction)

Generalize the flat `resolve-globals` (`src/parse.ss:224`) into a typed scope. A free
identifier resolves in order:

1. lexical locals (lambda/let/letrec) — unchanged
2. this unit's own top-level defines → the unit **defines** that global
3. imported bindings → the unit **declares** the exporter's global `external`
4. primitives / keywords → intrinsic
5. else → unbound-variable error

A binding carries a *kind* (`local` / `imported` / `primitive`) and a *symbol*. `imported`
emits `external global i64` bound by name across the JITDylib/linker — the existing
"referenced-but-not-defined ⇒ external global" mechanism, generalized so "external" may come
from a library, not only an earlier REPL form. A module is a **closed** scope (exports a
chosen subset of (2), may import (3)); a REPL session is an **open** scope ((2) accumulates
and is redefinable). Resolution logic is identical across both.

### D4 — Mangling (the cross-unit ABI)

For library `L = (p₁ p₂ … pₙ)` and internal name `x`, the symbol is `@"p₁.p₂.….pₙ:x"` —
e.g. `@"scheme.base:map"`, `@"srfi.1:fold"`. It is a pure function of `(L, x)` — no
counters, no compile-order dependence — so it round-trips across separate compilations. It
is readable in `--dump` and LLVM-legal (globals are already quoted, `src/emit.ss:590`).

- **Library** own names (exported and internal alike) → `@"L:x"`; lifted code → `@"L:code1"`.
- **Program** (the non-library `main`) → keeps today's unprefixed names; only one program
  module exists and libraries are all `L`-prefixed, so no collisions.
- **REPL session** → generation-mangled `x.g0`, `x.g1` (today's scheme, unchanged); imports
  resolve to `@"L:x"` externals.

**Export + rename semantics:** the symbol is always based on the **internal** name; the
export table's *key* is the external name. `(export map)` → `map → @"L:map"`;
`(export (rename %fast-map map))` → `map → @"L:%fast-map"`. Rename is pure table indirection
— no new emission logic — which is why v0 affords it while deferring `only`/`except`/`prefix`.

### D5 — The two doors, one in-memory export environment

The compiler resolves imports against an **in-memory export environment**; only who
populates it differs by door.

- **AOT (build-program):** a build driver reads the program's `import` forms, resolves each
  `(import (L))` through the manifest to its `.ll` + `.exports` (transitively, topologically
  ordered, rebuilding stale units via compile-unit), populates the export environment from
  the `.exports` files, compiles every unit + the program, and links
  `clang runtime.c scheme.base.ll L.ll … prog.ll -lgc -o exe`. Unused libraries are not
  linked. This generalizes `bin/scheme-compile` past its single-`.ll` assumption.
- **REPL:** on `(import (L))`, the host resolves `L` via the manifest, `addIRModule`s `L.ll`
  (+ transitive deps) into the shared JITDylib, calls `@"L:__init"` once, and merges
  `L.exports` into the session scope as imported bindings. The export environment comes from
  the compiler's own session state (already-loaded modules). Later forms referencing imported
  names emit `external global` refs resolved across the JITDylib.

Both doors call the *same* compile-unit entry, so a unit's `.ll` bytes are identical across
them — dev→ship fidelity extends to libraries, guarded by self-emission-equivalence.

### D6 — Prelude as `(scheme base)`, split procedure/macro

The prelude contains both procedures and derived-form **macros** (`cond`, `and`, `or`,
`when`, `unless`, `let*` are prelude `define-syntax`, per `docs/PIPELINE.md`). v0 is
procedures-only for the runtime artifact, so `(scheme base)` splits under one
implicit-import umbrella:

- **Runtime half** → `scheme.base.ll` + `scheme.base.exports`: the prelude's procedure
  defines, compiled and linked/loaded like any library.
- **Compile-time half** → the derived-form macros, auto-merged into every scope's
  `macro-env` at expand time (carried by the compiler / re-expanded), until macro phase
  separation lets them travel in `.exports`.

"Auto-import `(scheme base)`" therefore merges both its export table (imported external
globals) and its built-in macro set (compile-time) into each program/session scope.
User-wins shadowing falls out of D3's resolution order (own defines at step 2 beat imports
at step 3). Programs with no `import` still get `(scheme base)` auto-imported and compile
unchanged; `--no-prelude` skips both halves.

### D7 — Interface surface: extend current tools; defer the `emit` rename

v0 needs four capabilities: **compile-unit** (embedded-compiler entry: source + name +
import env → `.ll` + `.exports`), **build-program** (import-aware, generalizes
`bin/scheme-compile`), **run-program** (`scheme-run`, now `addIRModule`-ing deps), and
**repl** (`repl-host`, now honoring `import`). v0 adds these on the *existing* binaries and
wrapper, renaming nothing — respecting the decision to settle modules before packaging. The
four map 1:1 onto a future `emit lib` / `emit build` / `emit run` / `emit repl`
(+ `repl-host`→`emit-repl`), so that unification is later pure packaging over a proven
surface.

**Manifest format** — a readable s-expression (default `./emit-libs.scm`, override
`--manifest`):

```scheme
;; emit-libs.scm
((library (scheme base) (source "lib/scheme/base.sld") (artifacts "build/lib"))
 (library (foo bar)      (source "examples/foo/bar.sld")))
```

A library entry maps the name → its source and (optional) artifact directory; artifacts
default under `build/` so compiled units stay out of the source tree.

## Risks / Trade-offs

- **[Prelude re-homing breaks the self-hosting fixed point]** → Sequence it last (Stage 3),
  against a proven mechanism; the existing anti-stale trust-check (`make regen` reproduces
  byte-identical committed IR) is the automated gate.
- **[Code-label / global namespacing changes emitted IR for existing programs]** → Program
  (non-library) names stay unprefixed; Stage 0's acceptance is byte-identical IR for
  no-library programs. Only library units get the new `@"L:…"` names.
- **[Init ordering / diamond imports run a library twice]** → the one-shot `@"L:__inited"`
  guard makes `__init` idempotent; AOT orders inits at compile time, the REPL runs each on
  first import.
- **["Both doors" in v0 is a larger first bite]** → Approach A stages it: Stage 0 (no
  artifacts) → Stage 1 (trivial user library, both doors) → Stage 2 (generalize) → Stage 3
  (prelude). Both-doors acceptance concentrates in Stage 1 on the smallest possible unit.
- **[Manifest adds a config layer]** → v0 keeps it a two-entry file for the slice; format is
  a plain s-expression consistent with the project's text ethos.
- **[Embedded compile-unit entry grows the FFI surface]** → it is a parameterized sibling of
  the existing `RT_FILTER_MAIN` / `scheme_entry` string-FFI shim the embedding already uses;
  inputs cross via the runtime's existing string constructors.

## Migration Plan (staging)

- **Stage 0 — Resolution scaffolding, no artifacts.** Typed scope + module-qualified
  mangling for library-owned names and lifted code labels. Acceptance: no-library programs
  emit byte-identical IR. **Tracked as its own OpenSpec change**
  (`openspec/changes/module-resolution-scaffold`), landed and verified before the
  module-artifact stages — it is self-contained and byte-identity-testable.
- **Stage 1 — Vertical slice (both-doors milestone).** One trivial `(mylib)` exporting one
  procedure → `mylib.ll` + `mylib.exports`; a program `(import (mylib))` that links into a
  working exe *and* loads into the REPL. Minimal two-entry manifest. v0's core gate.
- **Stage 2 — Generalize.** Export-rename; transitive imports (lib→lib); dependency ordering
  + `__init` guard; stale-rebuild; manifest polish.
- **Stage 3 — Prelude as `(scheme base)`.** Split into procedure-library + compile-time
  macros; auto-import; `--no-prelude` skips it. Gated on the trust-check.

Each stage keeps `run-all-tests.sh` and `run-dev-tests.sh` green. Rollback is per-stage: the
changes are additive (new emission names behind the scope layer, new driver/manifest, a
re-homed prelude) and each stage is independently revertible.

## Testing / Acceptance

- **Regression / byte-identity:** existing suites stay green throughout; Stage 0 asserts
  no-library byte-identity; Stage 3's trust-check proves committed IR unchanged after
  re-homing.
- **New `test/modules-*` suite:**
  - AOT: build a program importing a library → run → assert value.
  - REPL: import a library interactively → assert value.
  - Imported-name shadowing / redefinition (own define beats import).
  - Diamond import: `__init` runs exactly once.
  - Export-rename: importer sees the external name; the internal name is not visible.
  - `--no-prelude`: prelude names are unbound.
- **The original blocker, as a test:** two independently compiled units (each with an
  internal `helper` + lifted code blocks) link together with no symbol collision.
- **Dev→ship fidelity:** a unit's `.ll` loaded in the REPL is byte-identical to the one
  linked into the exe (self-emission-equivalence extended to units).

**Observability:** the build driver narrates unit compiles/links per the shipped
`tooling-observability` convention (`compile (foo bar) -> build/lib/foo.bar.ll [N bytes]`,
`link … -> exe`), honoring `EMIT_VERBOSITY`.

## Open Questions (to resolve during planning/implementation)

- Exact library-name → symbol normalization for edge cases (integer parts like `(srfi 1)`,
  characters LLVM dislikes even when quoted). Proposal: dot-join parts, `:` before the name;
  confirm the printable-safe rule.
- Whether `compile-unit` inputs cross the FFI as serialized text (matches the text-IR ethos)
  or as a Scheme data structure held in the embedded compiler's state.
- Manifest search/default-artifact-dir conventions once more than a couple of libraries
  exist (kept trivial for the Stage 1 slice).

**Resolved:** Stage 0 is landed as its own OpenSpec change
(`module-resolution-scaffold`) before the module-artifact stages.
