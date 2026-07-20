## Context

`inexact-numbers` isolated all numeric *semantics* in the `rt_*` runtime
functions (its design D2), choosing the simplest correct flonum representation: a
heap box `{HDR_FLONUM, double}` where **every arithmetic result allocates one**.
That makes the representation swappable and keeps the language surface clean, but
it means a tight numeric loop allocates on every operation. `demos/mandelbrot.scm`
is the motivating workload: its `escape-count` inner loop produces ≈9 flonums per
iteration, of which ≈7 are pure intermediates that never outlive the expression
that made them.

Today the emitter (`src/emit.ss`) is **monotyped**: every SSA value it emits is
an `i64` tagged `val`. The fixnum inline fast path (`inline-arith-table` /
`emit-inline-arith`, ~`src/emit.ss:321-382`) is the pattern this work mirrors —
it guards on a fixnum tag and emits native `add`/`sub`/`icmp`, falling back to
`rt_*` otherwise. The pipeline is deliberately **direct-style, no CPS, no ANF**
(`docs/PIPELINE.md`), a simplicity choice that shapes the central decision below.

This change implements **Rung 1, Option A** from
`openspec/explorations/flonum-unboxing.md`: intra-expression flonum unboxing done
as a peephole on the expression tree, entirely within `src/emit.ss`, with no
calling-convention change.

## Goals / Non-Goals

**Goals:**
- Keep intra-expression intermediate flonums in native `f64` registers; box only
  at escape points. On mandelbrot this kills ≈7 of 9 boxes/iteration.
- Emit native `fadd`/`fmul`/`fsub`/`fcmp` for proven/guarded flonum operands.
- Preserve the invariant that `rt_*` is the single definition of numeric
  semantics — results bit-identical to the boxed lowering for all inputs.
- Preserve dev→ship byte-identity (shared emitter → JIT and AOT emit the same
  code; `byte-identical-backends` check holds).
- Stay within `src/emit.ss`; no new intermediate language, honoring the no-ANF
  stance.

**Non-Goals:**
- **Rung 2 (loop-carried unboxing across the `tailcc` back-edge)** — "the wall."
  The back-edge remains an escape point that boxes.
- **Rung 3 (unboxed flonum arrays / f64vector)** — orthogonal, separate change.
- A general flonum **type-inference** pass — only cheap literal + arith-result
  propagation is in scope.
- **NaN-boxing** or any change to the value representation.
- **`f32` / single precision.**

## Decisions

### D1: Option A (peephole in `emit.ss`) over Option B (normalized numeric region)

Unboxing classically wants a normalized IR (ANF) where every intermediate is
named and its type/lifetime is a property of a binding. The pipeline deliberately
refuses ANF. Option A recognizes flonum-op-feeding-flonum-op locally as the tree
is emitted, carrying a "this node emitted an `f64`, not a `val`" annotation and
cancelling `box`/`unbox` at the seams.

- **Chosen: Option A.** Smallest surface, no new IL, honors no-ANF, and is
  sufficient for Rung 1 (intra-expression). Its known limit — local reasoning
  can't reach loop-carried values — is exactly Rung 2, which is out of scope.
- **Rejected for now: Option B** (let-normalize *only* numeric subexpressions +
  a small flonum-representation pass). It is the clean home for Rung 2 and for
  proven unboxing across lets/branches, but it introduces the very normalization
  the pipeline avoided and needs a new IL delta and `--dump` stage. Path:
  do Rung 1 as A, measure, and only pay for B if Rung 2's numbers justify it.

### D2: Proven-where-cheap type source (literal + arith propagation), not inference

To emit `fmul` instead of `rt_mul`, the emitter must believe both operands are
flonums. The cheap, certain sources need no analysis: **literal flonums**
(`0.0`, `2.0`, `4.0`), the result of any flonum-fast-path op, and
`exact->inexact`. In the mandelbrot loop `zx`/`zy` trace back to `0.0` and to
flonum arithmetic, so a modest forward propagation likely proves them flonum.

- **Chosen:** literal + arith-result forward propagation, with **wholesale
  fall-back to the boxed `rt_*` path** wherever flonum-ness cannot be proven.
  Optionally a **hybrid**: prove inside a region, guard once at its boundary.
- **Rejected for now:** a full flonum type/representation analysis over the
  region — more power than Rung 1 needs; revisit with Option B.

### D3: Our own explicit box/unbox cancellation — do not rely on LLVM `-O2`

Emitting `rt_make_flonum(d)` followed by an immediate `flo_val(box)` and hoping
`-O2` folds the round-trip will not work: `rt_make_flonum` calls `GC_MALLOC`, a
side-effecting allocation LLVM must conservatively preserve, so the alloc
survives even when the box is dead. The cancellation must be **our** explicit
peephole. Task 0 spikes this (emit the naive box+unbox, read the optimized IR) to
confirm before committing.

### D4: The `tailcc` back-edge stays an escape point (defer the wall)

The uniform calling convention passes every argument as `i64`. A loop-carried
flonum crosses the back-edge as a call argument, so it must be a `val` → it must
be boxed. Getting past this needs a per-function specialized signature (or an
"unboxed across the back-edge" representation) in `lower.ss` + the convention —
high risk to dev→ship byte-identity and convention uniformity. This change
**boxes at the back-edge** and leaves that for Rung 2.

## Risks / Trade-offs

- **Type-stable variable detection for named-let loop vars** → With D4 the
  back-edge boxes regardless, so a mis-analysis of whether a loop var is
  always-flonum only forgoes an optimization; it can never produce a wrong
  result. Correctness does not depend on the analysis being precise.
- **Box/unbox seam bugs producing wrong values** → Gated by two checks that must
  both pass: result parity across all numeric demos + mandelbrot, and the
  `byte-identical-backends` demo check. Every rung asserts these explicitly (as
  `multiple-values` and `inline-fixnum-arith` did).
- **Option A cannot reach Rung 2** → Accepted by scope. Even Rung 1 alone is a
  ~78% allocation cut on the mandelbrot loop (7 of 9 boxes/iter); Rung 2 is
  measured-then-decided, not assumed.
- **A future NaN-boxing rep could make scalar unboxing largely moot** → Noted;
  it would not affect Rung 3 (flonum arrays). Sequencing question carried to Open
  Questions rather than resolved here.

## Spike Findings (task 0)

The measurement spike is complete. It validated the premises and surfaced two
things that reshape the emitter work.

**Emitted IR confirmed (0.1).** In `escape-count` (`code_56` in `emit run --emit
demos/mandelbrot.scm`), every flonum `+`/`-`/`*` lowers to the *fixnum*-guarded
fast path whose slow arm is `rt_mul`/`rt_add`/`rt_sub`. For flonum operands the
fixnum guard `((a|b)&7)==0` always fails, so **every such op takes the slow arm
and allocates a box in the runtime** — ≈10 allocating arith ops per iteration.

**New cost the exploration missed.** The flonum literals `4.0` and `2.0` compile
to `rt_flonum_lit(@.flo.lit.N)` *inside the loop body* (`%t34`, `%t73`); each call
runs `strtod` **and** `rt_make_flonum`, i.e. 2 extra allocations + 2 `strtod`
calls per iteration. Unboxing to immediate `f64` literals removes these for free —
a bonus win of Option A the count-of-9 did not include.

**D3 confirmed (0.2).** `opt -O2` on hand-written IR (`scratchpad/d3test.ll`):
Case 1 (external `rt_make_flonum` + reload) preserves the entire round-trip; Case
2 (inlined box body + reload) forwards store→load (the `fadd` uses the original
`double`) **but the `GC_malloc` call and its stores survive** — the dead
allocation is not eliminated. Box/unbox cancellation must be our explicit pass.

**Baseline (0.3), heavy render `(render -2.5 1.0 -1.25 1.25 300 120 400)`:**
native binary **0.24 s** steady-state (best of 5), **≈2064 GC collections**
(`GC_PRINT_STATS`); JIT (`emit run`) **0.50 s** incl. prelude compile. These are
the numbers task 5.3 must beat.

**The byte-identity constraint sharpens the approach.** The emitter MUST keep
non-flonum code byte-identical (existing demos' IR unchanged; the `make regen`
git-diff trust-check enforces it). So the `f64` path cannot be a blanket change to
arithmetic lowering — that would alter every fixnum `(+ i 1)`, force a full
bootstrap regen, and add flonum-guard overhead to integer code. **The flonum path
must activate only on static flonum evidence.**

Consequence for D2: literal-in-tree evidence covers mandelbrot's guard region
(`… > 4.0`) and the `(+ (* 2.0 zx zy) cy)` region, but **not** the
`new-zx = (+ (- (* zx zx) (* zy zy)) cx)` region — it contains no flonum literal;
its flonum-ness derives solely from the loop vars `zx`/`zy`. Proving that needs a
**named-let loop-variable type fixpoint** (`zx` init `0.0`, update is flonum-arith
of `zx`/`zy` ⇒ flonum-stable), which the exploration deferred as an open question.
So D2 as written ("literal + arith propagation within one expression") does **not**
prove the whole loop; without the loop fixpoint, the new-zx intermediates stay
boxed (a *partial* Rung 1). This is the open decision below.

## Achieved (implementation)

Full Rung 1 landed as guarded flonum regions in `src/emit.ss` (the loop-var
fixpoint `compute-flonum-params`, `flo-src?`/`region-*` detection, and
`emit-flonum-region`), gated so flonum-free code is untouched. Measured on the
heavy render `(render -2.5 1.0 -1.25 1.25 300 120 400)`:

| metric              | baseline | after | change |
|---------------------|----------|-------|--------|
| GC collections      | ~2064    | ~695  | **−66%** |
| native run (best/5) | 0.24 s   | 0.10 s| **~2.4× faster** |

Per iteration the ~12 flonum allocations (10 arith boxes + `4.0`/`2.0` literal
boxes) drop to ~4 (the guard-region sum box + its `4.0` literal, plus the two
loop-carried back-edge boxes for new-`zx`/new-`zy`). The full 83% ideal is not
reached because `expand-compare` binds every comparison operand to a `let`-temp
(single-evaluation safety), so the guard's `(> sum 4.0)` splits the sum into its
own boxed region rather than fusing into the `<` — the documented Option-A
boundary ("propagation across lets is awkward"). Verification: `demos/run-tests.sh`
70/70 (incl. `flonumunbox`, byte-identical `mandelbrot`), `demos/run-backends.sh`
49/49 (aot=jit=bitcode), and `make regen` idempotent (bootstrap IR unchanged →
dev→ship byte-identity holds).

## Migration Plan

None required — this is an internal codegen optimization with no language-surface
or representation change. Rollback is to disable the flonum fast path and fall
back to the existing boxed `rt_*` lowering; because the boxed path is retained as
the fallback throughout, the two can coexist behind the type-proof check.

## Open Questions

- **Rung 1 only, or commit to the wall?** Is a ~78% cut (Rung 1) enough to make
  flonums "fast enough," or is 0-alloc loops (Rung 2) a goal? Decide on the
  task-0 / task-5 measurements.
- **Does literal + arith propagation prove enough in real loops** to skip general
  inference, or is a small analysis needed sooner than expected?
- **Peephole (A) vs. normalized region (B)** for the next rung — decided by the
  Rung-1 measurement and the Rung-2 appetite.
- **Sequencing vs. a future NaN-boxing representation** — does its possibility
  change whether Rung 2 is worth building?
