## Context

Stage 2 of Modules v0 (`docs/superpowers/specs/2026-07-15-modules-v0-design.md`), building on
the archived Stage 1 (`module-artifacts-vertical-slice`) and Stage 0
(`module-resolution-scaffold`). Stage 1 delivered the artifact machinery for the smallest
case: a `compile-unit` core entry `(forms, library-name, import-env) → (ir-text,
export-table)` (`src/core.ss`); library-mode emission with per-export externals, a
guarded `@"L:__init"`, and no `@scheme_entry` (`src/emit.ss`); the resolver producing
`imported` bindings from an in-memory import environment (`src/parse.ss`); a two-entry
manifest (`emit-libs.scm`); and both doors — AOT `build-program` (`src/compile.ss`,
`bin/scheme-compile`) and REPL `import` (`src/repl/host.cpp`, `src/repl-core.ss`) — driven
off the one `compile-unit`.

Every generalization Stage 2 needs already has a Stage-1 seam:
- The import environment is **already** built from a library's export table and threaded into
  resolution — Stage 1 only ever populated it from the *program's* direct imports, but the
  same code populates a *library's* import environment for transitive imports.
- `@"L:__init"` is **already** one-shot-guarded by `@"L:__inited"` — Stage 1 documented this
  as "ready for Stage 2's diamonds"; Stage 2 only adds the multi-dependent call wiring and the
  test.
- The program's `@scheme_entry` **already** calls its imported libraries' `__init`s before the
  body — Stage 2 generalizes the *set* and *order* of those calls to the transitive closure.
- The export table **already** maps external name → mangled symbol — export-rename only
  changes how that pair is computed (external key from `<external>`, symbol from `<internal>`).

The dominating constraints from Stages 0/1 hold unchanged: the pure core (`src/core.ss`) stays
free of filesystem/subprocess I/O; a unit's `.ll` is byte-identical across both doors
(dev→ship fidelity); and library-free programs keep emitting byte-identical IR.

## Goals / Non-Goals

**Goals:**
- Export-rename `(export (rename <internal> <external>))`: external-name key, internal-based
  symbol; pure table indirection, no new emission logic.
- Transitive lib→lib imports: a library's import environment built from its dependencies'
  export tables, resolved identically to a program's.
- A dependency graph built from the manifest + units' `import` forms; cycle detection as a
  compile-time error; topological build/link/`__init` ordering.
- Diamond-safe init: shared units run their body once (guard already present); add the
  multi-dependent wiring and the init-once test.
- Stale-rebuild: recompile a unit when its source is newer than (or its artifacts absent),
  reuse otherwise.
- A generalized manifest resolver (many libraries, default artifact dir, missing-library
  error).
- `test/modules-*` extended: transitive chain (both doors), rename, diamond init-once, cycle
  error, stale-rebuild.

**Non-Goals:**
- Prelude as `(scheme base)` / auto-import (Stage 3).
- Macro export / phase separation; `only`/`except`/`prefix`; `cond-expand`/`include`;
  first-class/dynamic libraries (v0 non-goals).
- Dead-code elimination beyond "an unimported library isn't linked".
- Content-hash / fingerprint rebuild invalidation — Stage 2 uses mtime; hashing is a later
  refinement.
- Parallel unit compilation — units build sequentially in topological order.

## Decisions

### D1 — Export-rename is a parse + export-table change only

Extend the export parser (Stage 1's `(export <name> …)` step) to accept
`(rename <internal> <external>)` entries. Internally an export becomes a pair
`(external . internal)`; a bare `<name>` is `(name . name)`. Validation checks that
`<internal>` is a top-level define of the library (unchanged rule, applied to the internal
side). The export table Stage 1 already emits as `external-name → mangled-symbol` now computes
the key from `<external>` and the symbol from `mangle(L, <internal>)`. Emission is untouched:
the internal name is what gets a `@"L:x"` global regardless of the external spelling.

*Alternative rejected:* emit an alias global under the external name pointing at the internal
one. Rejected — it adds a symbol and emission logic for what is purely a lookup-table key
rename, contradicting the design's "pure table indirection".

### D2 — A library's import environment is built the same way a program's is

Stage 1's `compile-unit` already takes an `import-env` and threads it through resolution; the
program driver already builds that env from the imported libraries' `.exports`. For a library
that itself imports libraries, the driver builds *that library's* `import-env` from *its*
dependencies' `.exports` and passes it to the same `compile-unit`. No core change beyond
recognizing `import` forms inside `define-library` (a parser tweak) — resolution, the
`imported` binding kind, and the external-global emission are all reused verbatim. A library
remains a **closed** scope (own defines win over imports — D3 order from Stage 0).

*Alternative rejected:* a distinct "library import" resolution path. Rejected — the whole
point of Stage 0's typed scope is that program and library resolution are the same function
over a different environment.

### D3 — Dependency graph, cycle detection, topological order in the driver

The build driver constructs a directed graph: nodes are library names (+ the program), edges
are `X imports Y`. It resolves each node's `import` forms through the manifest to discover
dependencies, transitively, until closed. It runs a topological sort (DFS with a
visiting/visited marking); a back-edge is a cycle → compile-time error naming the cycle. The
sorted order drives three things in lockstep: the order units are compiled (a dependency's
`.exports` must exist before its dependent compiles), the order `.ll` files are passed to
`clang`, and the order of `__init` calls emitted into `@scheme_entry` (dependencies first).
This all lives in the driver/host — the core never sees the graph.

*Alternative rejected:* compile lazily/recursively on first reference without an explicit
graph. Rejected — an explicit graph makes cycle detection, ordering, and "don't link
unimported libraries" straightforward and narratable, and keeps the topological order a single
source of truth for compile/link/init.

### D4 — `__init` ordering under transitivity and diamonds

Each unit's `@scheme_entry` (program) — and, for correctness under transitivity, the wiring
that precedes a unit's use — calls the `__init`s of its **direct** dependencies first. Because
`@"L:__inited"` makes every `__init` idempotent (Stage 1), the simplest correct scheme is: the
program's `@scheme_entry` calls `__init` for **every** library in the transitive closure, in
topological order, before the body. Each callee's guard ensures its body runs once even though
a diamond's shared unit is named by multiple dependents. This keeps ordering visible in one
place (the entry) and needs no per-library "call my dependencies" prologue.

*Alternative rejected:* each library's `__init` calls its own dependencies' `__init`s (a
recursive init tree). Correct and also diamond-safe via the guard, but it spreads ordering
across every unit and complicates the REPL door (which loads incrementally). Deferring to a
flat topological sequence in the entry / load order is simpler for v0; the guard makes both
equivalent in effect. (If a later stage needs libraries initialized without a program entry,
the recursive scheme can be revisited.)

### D5 — REPL loads the transitive closure in order

On `(import (L))`, the host resolves `L`'s transitive dependency closure via the manifest,
`addIRModule`s each unit `.ll` in topological order into the shared JITDylib, calls each
unit's `@"L:__init"` once (tracking already-initialized units in session state so a later
`import` of an overlapping graph doesn't re-run), and merges `L`'s export table into the
session scope. Diamond safety is doubly ensured: session-state tracking avoids a redundant
call, and the `@"L:__inited"` guard makes even a redundant call a no-op. Both doors still call
the same `compile-unit`, so unit `.ll` bytes stay identical across doors.

### D6 — Stale-rebuild by mtime in the driver

Before compiling a unit, the driver compares the source file's mtime to the artifacts'
(`.ll` + `.exports`) mtimes. Missing or older artifacts → recompile via `compile-unit` and
rewrite both artifacts; newer artifacts → reuse (read the existing `.exports` for the import
env, reuse the existing `.ll` for linking/loading). This is a driver/host effect (filesystem);
the core stays pure. mtime is chosen over content-hashing for v0 simplicity; the check is
narrated per `docs/OUTPUT.md` so a reuse-vs-rebuild decision is visible.

*Alternative rejected:* always recompile. Rejected — multi-unit graphs would recompile the
world on every build, and the design explicitly calls for "rebuilding stale units".

### D7 — Manifest polish

Generalize the Stage 1 reader from "two entries" to an arbitrary list, keyed by library name
(the s-expression `(library (p …) (source "…") (artifacts "…"))` shape is unchanged). A
default artifact directory (`build/lib`) applies when an entry omits `artifacts`. Resolving an
imported library with no manifest entry raises a compile-time error naming the missing library
(previously undefined behavior with one hard-coded pair). Richer search paths / globbing stay
out of scope.

## Risks / Trade-offs

- **[Export-rename accidentally changes the emitted symbol]** → the mangled symbol must stay
  based on the *internal* name; only the export-table key changes. Mitigation: a test asserts
  `(rename %fast-map map)` emits `@"L:%fast-map"` and the table keys `map`; Stage 1's
  bare-export tests stay green.
- **[Cycle in the import graph loops or links garbage]** → explicit DFS cycle detection raises
  a compile-time error before any compile/link. Mitigation: a cycle-error test is a Stage-2
  gate.
- **[Diamond runs a shared unit's body twice]** → the `@"L:__inited"` guard (Stage 1) plus
  REPL session-state tracking. Mitigation: a diamond init-once test with an observable
  one-time effect.
- **[Init ordering wrong under transitivity]** → single source of truth: the topological sort
  drives compile, link, and `__init` order together. Mitigation: a transitive-chain test whose
  correctness depends on `(b)` initializing before `(a)`.
- **[Stale-rebuild reuses an out-of-date unit]** → mtime comparison against source; missing
  artifacts always rebuild. Trade-off: mtime can be fooled by clock skew / touch; acceptable
  for v0, revisitable with hashing. Mitigation: narrate the decision; a stale-rebuild test
  edits a source and asserts a recompile.
- **[Core acquires I/O for transitive `.exports`/graph]** → forbidden; the graph, mtime
  checks, and `.exports` reads all stay in the driver/host, crossing into `compile-unit` as
  in-memory data. Mitigation: keep `compile-unit` a pure `forms+name+env → text+table`.
- **[`CORE_FLAT` edits leave committed IR stale]** → the rename/transitive parser tweaks may
  touch `CORE_FLAT`. Mitigation: `make regen`; the anti-stale trust-check fails loudly
  otherwise.
- **[Library-free / single-library behavior regresses]** → Stage 2 is additive over Stage 1's
  paths. Mitigation: Stage 0's demo byte-identity guard and all Stage 1 `test/modules-*` cases
  stay green.

## Migration Plan

1. Export-rename: extend the export parser to accept `(rename i e)`; represent exports as
   `(external . internal)`; compute the export-table key from `external`, the symbol from
   `mangle(L, internal)`.
2. Transitive imports: recognize `import` inside `define-library`; have the driver build a
   library's import env from its dependencies' `.exports` and feed the same `compile-unit`.
3. Dependency graph in the driver: resolve the transitive closure via the manifest, detect
   cycles (error), topologically sort.
4. Ordering: compile units in topo order; link `.ll`s in topo order; emit `__init` calls for
   the whole closure in topo order into `@scheme_entry`.
5. Diamond wiring + init-once (guard already present); REPL session-state tracking of
   initialized units.
6. REPL door: load the transitive closure in order, init each once, merge the imported
   library's exports.
7. Stale-rebuild: mtime check per unit (reuse vs recompile) with narration.
8. Manifest polish: arbitrary entries, default artifact dir, missing-library error.
9. `test/modules-*`: transitive chain (both doors), rename, diamond init-once, cycle error,
   stale-rebuild; wire into `run-all-tests.sh` / `run-dev-tests.sh`.
10. `make regen` if any `CORE_FLAT` file changed; both suites green including the trust-check.

Rollback is per-step; the change is additive (new export syntax, transitive env population,
a driver-side graph/ordering/rebuild layer, manifest generalization) with no change to
library-free or single-library behavior.

## Open Questions

- Where exactly the `import`-inside-`define-library` recognition lives relative to Stage 1's
  library-front step — likely the same step already splitting `(imports exports body)`, now
  applied to library units too rather than only the program.
- Whether the flat "entry inits the whole closure" scheme (D4) suffices for the REPL's
  incremental loading in all diamond shapes, or whether session-state tracking must also
  reconcile a later `import` that introduces a new path to an already-initialized unit
  (expected: the guard + tracking cover it; confirm with the diamond test under the REPL door).
- mtime granularity / clock-skew edge cases for stale-rebuild — acceptable for v0, but confirm
  the check treats "equal mtime" and "artifact absent" conservatively (rebuild on doubt).
