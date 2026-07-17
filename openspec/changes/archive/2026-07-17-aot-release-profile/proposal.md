## Why

The shipped AOT executable is both **slower and larger than it should be**, and — surprisingly
— slower than the REPL. The AOT link (`link-modular-aot`, `src/compile.ss:566`) is literally
`clang runtime.c *.ll -lgc -o exe`, which compiles the IR at clang's default **-O0**. Measured
on Ackermann `(ack 3 12)`: AOT -O0 = 4.47s / 125 KB, the same IR at -O2 = 3.29s / 108 KB, and
the JIT/REPL runs it in 3.20s. So today **dev beats ship** — the exact inverse of what a release
build should deliver — and every binary ships unoptimized (P5).

On size, every AOT binary also links the *entire* `(scheme base)` unit — all 196 functions — even
a program that calls only `car` (P1). An experiment confirms plain `internalize + globaldce`
removes **0 of 249** functions: the prelude's `__init` eagerly constructs every binding and passes
each closure through `rt_root` (GC-root), so every function escapes LLVM's view and looks live.
Nothing is pruned because nothing *looks* dead.

Both problems are safe to fix only under the **closed-world** assumption that AOT already has: a
sealed, complete program with no future `define`/redefinition (unlike the open-world REPL). A
compiled program has no `eval` or dynamic name lookup (verified), so static reachability is sound.
This change turns the AOT door into a proper **release profile**: optimize at link, and emit/init
only the library bindings the sealed program actually reaches. It is deliberately framed and
factored as the first slice of a future `emit build` (the "compile the project and deliver it"
half of a `cargo`/`uv`-style project tool), so it grows into that vision rather than being a
prelude-specific hack.

## What Changes

- **Optimize at the AOT link (release profile).** Run `-O2`/`opt` over the AOT module set so the
  shipped binary is optimized (faster, and typically smaller). Behavior-preserving; the emitted
  `.ll` and committed bootstrap IR are unchanged (only the link/codegen step optimizes), so IR
  byte-identity tests are unaffected. This also lets the already-landed B-self direct self-calls
  actually inline.
- **Reachability tree-shaking of library bindings (closed-world, AOT-only).** At `build` time,
  compute the set of library/prelude bindings transitively reachable from an explicit **root
  set**, generate a program-specific pruned `__init` that constructs only those bindings, and let
  `globaldce`/`-O2` then strip the now-genuinely-unreferenced code. Reachability is what makes
  LLVM's DCE finally bite (it removes the `make-closure`/`rt_root` references that kept dead code
  alive).
- **Root-set-driven and unit-general by design.** The reachability pass takes an explicit root set
  (today: the program's entry + top-level references) rather than assuming "the whole program is
  live," and walks the general unit/export graph (the prelude is just "unit zero"). This is the
  same shape `cargo`/`uv` use — separate compilation for dev, whole-program strip at final link —
  so a future manifest can supply richer roots (a bin entry, or a delivered library's exports)
  without reworking the pass.
- **Dev door untouched.** The REPL / JIT / `emit run` path keeps the full library units and the
  one shared compiler core; dev→ship fidelity (identical observable behavior) is preserved. The
  new work is a ship-time-only transform, gated to the AOT/`build` door.

Explicitly **out of scope** (future work, noted so the substrate stays clean for the layer above):
the packaging layer itself — a project manifest, dependency resolution, a lockfile, workspaces,
and the `emit build`/`emit run` CLI verbs. Also out of scope: **B-general** (direct calls to other
top-level functions), which needs an emitter change + binding-immutability analysis and is parked
in `docs/PERFORMANCE.md`; and delivering a *library* artifact (root = exports) beyond making the
root set pluggable.

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `aot-codegen`: add release-profile requirements — (1) the AOT link optimizes the module (opt/-O2);
  (2) the AOT build tree-shakes unreachable library bindings via a root-set-driven, unit-general
  reachability pass, preserving observable behavior; the dev/REPL door is unaffected.

## Impact

- **Code**: `src/compile.ss` — the AOT link/backend path gains an optimization step and a
  reachability-pruned `__init` for the linked unit set; a reachability walk over units' export
  graphs from a root set. No change to the emitter's per-form IR, the REPL path, or the runtime.
- **Interaction with P3 (cached units)**: dev keeps the cached full unit `.ll`; the AOT ship path
  builds a program-specific pruned init (it trades per-program reuse for a smaller binary — fine
  for a ship step). To record in design.

- **Tests**: value-equivalence across all demos (identical results); size/opt-level assertions
  (a `car`-only program drops most of `scheme.base`; AOT binary is optimized); Ackermann and
  binary-size before/after. `docs/PERFORMANCE.md` P1/P5 updated; P3 note cross-referenced.
- **No observable semantic change**: same values and errors; faster, smaller, optimized ship
  binaries; dev loop unchanged.
