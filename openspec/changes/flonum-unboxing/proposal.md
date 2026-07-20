## Why

`inexact-numbers` ships correct flonums with the simplest representation: a
flonum is a heap box `{HDR_FLONUM, double}`, and **every arithmetic result
allocates one**. That is fine for `(display (* 2.0 pi))` but ruinous for the
thing flonums are for — tight numeric loops. The `demos/mandelbrot.scm` inner
loop produces ≈9 flonums per iteration, of which ≈7 are intermediates that never
outlive the expression that made them; at 100 max-iters over an 80×32 grid that
is on the order of millions of heap allocations for one 2560-character picture.

This change keeps intermediate flonums in native `f64` machine registers and
boxes only where a flonum escapes — the "80% of the win for 20% of the work"
first rung from `openspec/explorations/flonum-unboxing.md` (Rung 1, Option A).
It is a codegen optimization only: the boxed flonum stays the canonical `val`,
and the language surface is untouched.

## What Changes

- Add a **flonum inline fast path** to the emitter's arithmetic lowering
  (`emit-inline-arith` / `inline-arith-table` in `src/emit.ss`), mirroring the
  existing fixnum path: for `+ - * = <` (and `> >= <=`, which reduce to `< =`),
  emit native `fadd`/`fmul`/`fsub`/`fcmp` on unboxed `f64` operands, guarded so
  non-flonum operands still flow to the `rt_*` runtime primitives.
- Introduce a second machine type into emitted IR — `double` — alongside the
  monotyped `i64` `val`, with exactly two conversions: **unbox** (`flo_val`, a
  load) and **box** (`rt_make_flonum`, an alloc).
- **Intra-expression producer→consumer fusion**: within one expression tree, a
  flonum-op result that feeds another flonum op stays in an `f64` register; the
  emitter boxes only where the tree's value escapes (stored into a
  pair/vector/record/box, returned into a `val` slot, passed to a `val`-typed
  call **including the loop back-edge**, or consumed by a `val`-only runtime op
  such as `display`/`eqv?`/`cons`). Every `box ∘ unbox` pair that meets is
  cancelled.
- Prove flonum-ness cheaply via **literal + arithmetic-result propagation** (no
  general type-inference pass): literal flonums, flonum-fast-path results, and
  `exact->inexact` results are known-flonum sources; where a type cannot be
  proven, fall back wholesale to the boxed path.
- **Scope is Rung 1 only.** Loop-carried unboxing across the tailcc back-edge
  (Rung 2 — "the wall") and unboxed flonum arrays (Rung 3) are explicit
  non-goals of this change; the back-edge remains an escape point that boxes.
- **Task 0 is a measurement spike**: hand-write unboxed IR for the mandelbrot
  loop and read the `-O2` output to (a) confirm LLVM will *not* fold the naive
  `box`/`unbox` round-trip on its own (GC_MALLOC is a side effect it must
  preserve) and (b) set the ceiling — alloc count, frame time, GC pressure —
  before any pass is written.

## Capabilities

### New Capabilities

_None._ This is a codegen optimization within an existing capability; it adds no
new language surface.

### Modified Capabilities

- `aot-codegen`: The requirement "Fixnum numeric primitives lower to an inline
  fast path" currently states the emitter **SHALL NOT** gain a flonum inline
  path and that flonum/mixed operands take the runtime path "with no flonum
  inline path in the emitted IR." This change **modifies** that requirement to
  permit a flonum inline fast path with intra-expression unboxing, while
  preserving the invariant that the `rt_*` runtime primitives remain the single
  definition of numeric semantics and that observable results are unchanged.

## Impact

- **Code**: `src/emit.ss` (the arithmetic lowering and a new "this node emitted
  an `f64`, not a `val`" annotation + box/unbox seam handling). No
  calling-convention change — Rung 1 stays within `emit.ss`, per Option A.
- **Representation**: unchanged. The boxed `{HDR_FLONUM, double}` remains
  canonical; `rt_make_flonum` / `flo_val` are the only bridges.
- **Runtime semantics**: unchanged — every result must remain bit-identical to
  the current boxed lowering for both fixnum and flonum operands.
- **Dev→ship fidelity**: the unboxing decisions live in the shared emitter, so
  JIT and AOT stay byte-identical; the `byte-identical-backends` demo check MUST
  continue to pass and this change asserts it explicitly (as
  `multiple-values` and `inline-fixnum-arith` did).
- **Supersedes**: `inexact-numbers` design D2's "no flonum inline path" clause
  (recorded there as an exploration follow-on).
- **Verification workload**: `demos/mandelbrot.scm` (allocation-count and
  frame-time before/after), plus the existing numeric demos for result parity.
