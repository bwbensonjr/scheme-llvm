## Context

Grounded in experiments run during exploration (see `docs/PERFORMANCE.md` P1/P5):

- **AOT ships at -O0.** `link-modular-aot` (`src/compile.ss:566`) is `clang runtime.c *.ll -lgc -o
  exe`; clang defaults to `-O0` on `.ll`. `(ack 3 12)`: -O0 = 4.47s/125 KB, -O2 = 3.29s/108 KB,
  JIT = 3.20s. Dev currently beats ship.
- **`internalize + globaldce` removes 0 of 249 functions.** The prelude `__init` eagerly builds
  every binding and passes each closure through `rt_root` (an opaque GC-root call — 114 of them),
  so every function escapes LLVM's view and appears live. Linkage alone is not the blocker; the
  eager-init + escape model is.
- **`-O2` does not devirtualize heap closures.** After `internalize` + full `-O2` over a sealed
  module, all 191 indirect closure calls remained indirect, 0 became direct. (This is why
  B-general needs an emitter change and is parked, not part of this change.)
- **Tree-shaking is sound here.** No `eval`, `symbol->value`, or runtime environment lookup exists
  in the compiled surface, so a sealed program cannot reach a binding by a dynamically-computed
  name.

The two doors already exist (one compiler core → REPL door + AOT door). This change makes the AOT
door a **release profile**: closed-world, optimized, tree-shaken. It is framed as the first slice
of a future `emit build` (the "compile the project and deliver it" half of a `cargo`/`uv`-style
tool), so its factoring must generalize.

## Goals / Non-Goals

**Goals:**
- Optimize the AOT link (opt/-O2) so ship binaries are faster and typically smaller; fix the
  dev-beats-ship inversion. Behavior-preserving; emitted/committed IR unchanged.
- Tree-shake unreachable library bindings from AOT builds via a **root-set-driven, unit-general**
  reachability pass, so a `car`-only program does not ship all 196 `scheme.base` functions.
- Keep the dev/REPL door identical (full units, one compiler core, dev→ship fidelity).
- Factor the work so a future manifest can supply richer roots (bin entry, or a delivered
  library's exports) with no change to the pass.

**Non-Goals:**
- The packaging layer: manifest format, dependency resolution, lockfile, workspaces, `emit
  build`/`emit run` CLI verbs. This change is the compile substrate they will drive.
- **B-general** (direct calls to other top-level functions) — needs an emitter change +
  binding-immutability analysis; parked.
- Delivering a *library* artifact (root = exports) end-to-end — only making the root set pluggable.
- Changing the runtime, the emitter's per-form IR, the calling convention, or the REPL path.

## Decisions

**Decision: optimize at link with an opt pipeline gated to the AOT door.** Run `-O2`/`opt` over the
AOT module set (the JIT already optimizes; the bitcode path should be consistent). This is a
link/codegen-time step: the emitted `.ll` and committed `bootstrap/*.ll` are unchanged, so IR
byte-identity and self-hosting fixed-point checks are unaffected. *Alternative* (bump only clang's
`-O`): equivalent for a single-file link; prefer an explicit `opt` step so it composes with the
tree-shaking pass over the merged module.

**Decision: tree-shake via reachability-pruned `__init` + `globaldce`, not pure LLVM DCE.** Pure
`globaldce` fails (eager init + `rt_root` escape). Instead: (1) from the root set, walk the units'
export/reference graph to the transitively-reachable binding set; (2) generate a program-specific
`__init` that `make-closure`s only those bindings; (3) the unreachable `code_N` are then genuinely
unreferenced, so `globaldce`/`-O2` strips them. Reachability *tells* LLVM what is dead by not
referencing it. *Alternative* (fight LLVM: internal linkage + lazy init + avoid `rt_root` escape):
fragile and indirect; rejected in favor of the Scheme-level reachability the project can reason
about.

**Decision: the reachability pass is root-set-driven and unit-general.** It takes an explicit root
set (today: the program entry + its top-level references) rather than assuming "the whole program
is live," and treats the prelude as one unit among others. This matches `cargo`/`uv` (separate
compilation for dev; whole-program strip at final link) and lets a future manifest supply a bin
entry or a library's exports as roots without reworking the pass. This is a *factoring* decision:
it does not add near-term scope, it constrains where the seams go.

**Decision: dev keeps cached full units; AOT builds a pruned init per program.** The cached full
unit `.ll` (P3) stays for the REPL/JIT door (open world — everything must be available). The AOT
ship path builds a program-specific pruned `__init`, trading per-program unit reuse for a smaller
binary. That is the correct trade for a ship step and mirrors `cargo`'s separate-compile +
final-link strip. To record as the P3 interaction.

**Decision: regenerate committed IR only if the emitter changes.** This change is expected to live
in `src/compile.ss` (link/backend + reachability), not the emitter, so `bootstrap/*.ll` should be
unchanged. If any emitted-IR change proves necessary, `make regen` + the trust-check apply as
usual.

## Risks / Trade-offs

- **Tree-shaking soundness** → depends on no dynamic name lookup; verified (no `eval`). Guard with
  value-equivalence tests across all demos and a "reachable binding retained" test. Any future
  `eval`-like feature must disable shaking (or seed roots from it).
- **Pruned-init correctness / init order** → the reachable set must be closed under the units'
  internal references and initialized in dependency order (the existing `__init` order). A missing
  transitive dep would be a link error or a wrong result; covered by demo value-equivalence.
- **-O2 and determinism** → optimization runs after emission, so the byte-identity/fixed-point
  invariants (which check emitted `.ll`) are untouched; the AOT *binary* is not part of those
  checks. Confirm the backend-equivalence suite (AOT|JIT|bitcode same values) still holds.
- **Binary size could grow from inlining** → `-O2` may inline; net effect measured as smaller on
  ack (−14%), and tree-shaking removes far more. Track binary size in tests so a regression is
  visible.
- **P3 interaction** → giving up per-program unit reuse on the AOT path slightly increases build
  time; acceptable for a ship step. Note explicitly.

## Migration Plan

No user migration. Deploy: add the opt step + reachability-pruned link in `src/compile.ss`; add
tests; measure Ackermann + binary size. Rollback: revert the commit. If the emitter is untouched,
no `make regen` is needed; otherwise regen + trust-check.

## Resolved during apply

- **`-O2` mechanism** — a centralized `ship-opt = "-O2"` added to the AOT and bitcode ship-path
  clang invocations (`src/compile.ss`). Per-module clang `-O2` (no `llvm-link`/LTO) already yields
  the measured win (ack 4.52s→3.02s, 125KB→108KB), and keeps the AOT path clang-only. The JIT/REPL
  door is untouched.
- **Pruned unit mechanism → recompile the unit with a keep-set (Approach 1).** Rather than IR-level
  `__init` surgery + `globaldce` (which would require `llvm-link`/`opt` on the AOT path), the AOT
  build recompiles each unit emitting ONLY the reachable bindings and a `__init` over just those.
  Reachability is computed at the Scheme level (post-expansion, so macro-introduced references are
  visible) as the transitive closure, over each unit's define→define reference graph, of the root
  set. This keeps AOT clang-only, is fully Scheme-level/transparent, and trades the cached full
  unit for a program-specific pruned unit on the ship path (dev/REPL keeps the cached full unit).

## Open Questions

- **Cross-unit DAG reachability** — the first cut computes roots from the program's references and
  propagates keep-sets backward through the import DAG; confirm the ordering (program refs known
  before units are pruned) is handled by a pre-pass. The common case (program → `(scheme base)`) is
  the primary test.
- **Is the reachable set cacheable by import-set?** Per-program is simplest; a cache keyed by the
  (root-set → reachable-set) mapping is a later optimization if AOT build time matters.
- **Granularity of pruning** — per top-level binding (closure/global) is the natural unit; confirm
  nothing (e.g. a macro-expander dependency or a runtime-reflected binding) needs coarser retention.
