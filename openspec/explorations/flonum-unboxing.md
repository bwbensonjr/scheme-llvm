# Exploration: flonum unboxing (keeping doubles in registers)

Status: exploration / performance follow-on to `inexact-numbers` (individual rungs become their own changes)
Related: `openspec/changes/inexact-numbers` (ships the boxed `{HDR_FLONUM, double}` rep; design D2 and the `aot-codegen` "no flonum inline path" clause are the two things this REVISES); `src/emit.ss` (the inline fixnum fast path, `inline-arith-table` / `emit-inline-arith`, lines 321-382 — the pattern a flonum path mirrors); `src/passes/lower.ss` + the `tailcc` calling convention (README "Values are tagged 64-bit words"); `docs/PIPELINE.md` (the deliberate **no-CPS / no-ANF direct-style** pass ladder — the source of the central tension below); `LLVM.md`.
Captured: 2026-07-19

## The framing

`inexact-numbers` gives us *correct* flonums with the simplest possible
representation: a flonum is a heap box `{HDR_FLONUM, double}`, and **every
arithmetic result allocates one**. That is fine for `(display (* 2.0 pi))`. It is
ruinous for the thing flonums are *for* — tight numeric loops.

The chosen fix is not a representation change. It is a **codegen optimization**:
keep intermediate flonums in native `f64` machine registers, emit native
`fadd`/`fmul`/`fcmp`, and call `rt_make_flonum` *only where a flonum escapes* into
the boxed world. The value representation is untouched; the boxed flonum is still
the canonical `val`. We are just declining to build the box when nobody needs it.

```
   BOXED EVERYWHERE (inexact-numbers)      UNBOXED IN REGISTERS (this)
   ─────────────────────────────────      ───────────────────────────
   d = fmul zx, zx                         d = fmul zx, zx
   b = rt_make_flonum(d)   ← alloc         (stays an f64 register)
   ...                                     ...
   d2 = flo_val(b)         ← load          d2 = d                (no round-trip)
   e = fmul zy, zy                         e = fmul zy, zy
   b2 = rt_make_flonum(e)  ← alloc         (stays an f64 register)
   ...                                     ...
                                           box ONLY at escape points
```

Because `inexact-numbers` deliberately isolated all numeric *semantics* in the
`rt_*` functions (design D2), the representation underneath is swappable — and
this optimization needs no change to the language surface, only to how the
emitter lowers numeric code.

## The cost, counted box-by-box (the mandelbrot inner loop)

`demos/mandelbrot.scm` is the motivating workload. Its `escape-count` loop, per
non-escaping iteration:

```
(let loop ((zx …) (zy …) (i 0))
  (cond
    ((= i max-iter) i)
    ((> (+ (* zx zx) (* zy zy)) 4.0) i)          ; guard: 2 muls + 1 add + 1 cmp
    (else
     (loop (+ (- (* zx zx) (* zy zy)) cx)        ; new zx: 2 muls + 1 sub + 1 add
           (+ (* 2.0 zx zy) cy)                   ; new zy: 2 muls + 1 add
           (+ i 1)))))                            ; i is a FIXNUM — already immediate
```

Counting flonum-producing operations (no CSE pass exists, so the guard's
`zx*zx`/`zy*zy` are recomputed, not shared):

```
   flonum results / iteration  ≈ 9
   loop-carried (escape via back-edge): 2   (new zx, new zy)
   pure intermediates:                  7   (every mul, and the interior +/-)
```

At `100` max-iters over an `80×32` grid, that is on the order of **millions of
heap allocations for one 2560-character picture** — and all but 2-per-iteration
are intermediates that never outlive the expression that made them. That 7-of-9
is the prize.

## The one seam: an `f64` shadow of the value model

Today the emitter is monotyped: **every SSA value it emits is `i64`** (a tagged
`val`). Unboxing introduces a *second* machine type into the IR — `double` — and
two conversions between the worlds:

```
        val (i64)  ────  flo_val(v)  ───▶  double        (UNBOX: a load)
        double     ──  rt_make_flonum ──▶  val (i64)      (BOX:  an alloc)
```

The entire pass is one idea: **push boxes outward toward escape points and pull
unboxes inward toward producers, then cancel every `box ∘ unbox` pair that meets.**
What is left boxed is exactly what truly escapes.

## Escape points — where an `f64` MUST become a `val` again

```
ESCAPE (must box)                              STAYS UNBOXED (f64 register)
──────────────────────────────────────────    ──────────────────────────────
stored into a pair / vector / record / box     operand of another flonum op
returned into a val slot (function result)     bound to a flonum-stable local
passed to a call with a val-typed param        a literal flonum feeding an op
  (INCLUDING the loop back-edge, today)         exact->inexact result feeding an op
consumed by a val-only runtime op
  (display, write, eqv?, equal?, cons, …)
assigned to a type-unstable variable
  (a var that also holds non-flonums)
```

The third row is the whole story of how *far* unboxing reaches — see the wall
below.

## The staircase — how far the boxes retreat

```
 Rung 1  INTRA-EXPRESSION unboxing
 ───────────────────────────────────────────────────────────────────
   within one expression tree, a flonum op result that feeds another
   flonum op stays in an f64 register.  box only where the tree's value
   escapes.
     mandelbrot: kills 7 of 9 boxes/iter (all the intermediates)
     touches:  src/emit.ss only  ·  NO calling-convention change
     risk:     low-moderate
 ═══════════════════════════ THE WALL ═══════════════════════════════
   the uniform tailcc convention passes every arg as i64.  a loop-
   carried flonum crosses the back-edge as a call argument → it must
   be a val → it must be boxed.  getting past the wall means changing
   how a function receives its args.
 ─────────────────────────────────────────────────────────────────
 Rung 2  LOOP-CARRIED unboxing
   specialize a self-recursive function so its flonum-typed parameters
   are passed UNBOXED (f64) around the back-edge.
     mandelbrot: kills the last 2 boxes/iter → 0 allocs in the loop
     touches:  lower.ss + the calling convention (per-function
               specialized signature, or an "unboxed local across the
               back-edge" representation)
     risk:     high (convention divergence vs. the uniform prototype;
               dev→ship byte-identity must still hold)
 ─────────────────────────────────────────────────────────────────
 Rung 3  FLONUM DATA (orthogonal)
   an unboxed array-of-double type (f64vector / flonum-vector), so a
   vector of N floats is one allocation, not N boxes + a vector.
     touches:  runtime (a new HDR_*), parse/emit, prelude
     risk:     moderate; independent of rungs 1-2
     biggest win for numeric-array code (matrices, signal processing)
```

Rung 1 is the "80% of the win for 20% of the work" rung and is almost certainly
the first change. Rung 2 is where it gets genuinely hard — and it is optional:
even 2 boxes/iteration is a ~78% allocation cut from rung 1 alone.

## The type question: proven vs. guarded

To emit `fmul` instead of `rt_mul`, the emitter must believe both operands are
flonums. Two ways to earn that belief:

```
             GUARDED (dynamic)                 PROVEN (static)
             ─────────────────                 ───────────────
 shape       if both-flonum: f64 path          emit pure f64, no guard
             else: rt_* slow path              (fall back to boxed when
             (mirrors today's fixnum inline)    a type can't be proven)
 needs       nothing — pure runtime test       a flonum type/representation
                                                analysis over the region
 cost        a branch per op; and box∘unbox     none at runtime; analysis at
             around each op UNLESS fused         compile time
 fusion      producer→consumer fusion is what   naturally unboxed across the
             actually removes the boxes          proven region
```

Cheap, certain type sources that need no analysis at all: **literal flonums**
(`0.0`, `2.0`, `4.0`), the result of any flonum-fast-path arithmetic op, and
`exact->inexact`. In the mandelbrot loop, `zx`/`zy` trace back to `0.0` and to
flonum arithmetic — a modest forward propagation may prove them flonum without a
full inference pass. Worth checking whether **literal + arith propagation** alone
covers the common loop, deferring general inference.

A plausible hybrid: **proven where cheap, guarded at the region boundary.** Prove
flonum-ness by propagation inside a loop body; guard once on entry (or fall back
wholesale to the boxed path) when a value can't be proven.

## The central tension: unboxing wants ANF; this pipeline refuses it

`docs/PIPELINE.md` is emphatic that the pass ladder is **direct-style, no CPS, no
ANF** — a deliberate simplicity choice. But representation-selection optimizations
(this is one) classically want a *normalized* IR where every intermediate is
named and its type/lifetime is a property of a binding, not a position in a tree.
That is exactly what ANF gives and what we chose not to have.

```
   OPTION A  peephole on the expression tree (in emit.ss)
     recognize flonum-op-feeding-flonum-op locally as the tree is
     emitted; keep a "this node emitted an f64, not a val" annotation
     and cancel box/unbox at the seams.
       + no new intermediate language; smallest surface
       + stays true to the no-ANF stance
       − reasoning is local; loop-carried (rung 2) is out of reach;
         type propagation across lets/branches is awkward

   OPTION B  a narrow normalized numeric region + a flonum-repr pass
     let-normalize (ANF-lite) ONLY numeric subexpressions, run a small
     representation/type pass that annotates flonum temporaries, box at
     escapes.
       + clean home for rung 2 and for proven unboxing
       − introduces the very normalization the pipeline avoided;
         needs a new (small) IL delta and a --dump stage
```

This is the decision that most shapes the work. Option A likely suffices for rung
1; rung 2 probably forces something B-shaped. A reasonable path: **do rung 1 as
Option A, measure, and only pay for Option B if rung 2's numbers justify it.**

## Can we just let LLVM do it? (Almost certainly not — but spike it)

Tempting: emit `rt_make_flonum(d)` and an immediate `flo_val(box)` and hope
`-O2` folds the round-trip. It won't: `rt_make_flonum` calls `GC_MALLOC`, a
side-effecting allocation LLVM must conservatively preserve — so the alloc
survives even when the box is dead. Unless `rt_make_flonum` is inlined *and* the
allocator is annotated so LLVM can prove the box non-escaping (a much bigger ask),
the box/unbox cancellation has to be **our** explicit pass. One cheap spike would
confirm this before committing: emit the naive box+unbox and read the optimized
IR.

## What this revises back in `inexact-numbers`

- **Design D2** stated "the inline path is untouched … no flonum inline path."
  This work *is* that path; the follow-on change updates D2 to record the
  supersession.
- The **`aot-codegen`** requirement clause "The emitter SHALL NOT gain a flonum
  inline path" is MODIFIED by rung 1.
- The **dev→ship byte-identity** invariant (JIT and AOT share one emitter) and
  the **byte-identical-backends** demo check must both still hold — the unboxing
  decisions are made in the shared emitter, so they will, but every rung's
  verification must assert it explicitly (as `multiple-values` and
  `inline-fixnum-arith` did).

## Open questions

- **Rung 1 only, or commit to the wall?** Is 0-alloc loops (rung 2) a goal, or is
  a ~78% cut (rung 1) enough to make flonums "fast enough" for now?
- **Measure first.** What does rung 1 alone buy on mandelbrot (frame time,
  alloc count, GC pressure)? A spike with hand-written unboxed IR for the loop
  would set the ceiling before any pass is written.
- **Peephole (A) vs. normalized region (B)** — decide per the rung-1 measurement
  and the rung-2 appetite.
- **Proven vs. guarded vs. hybrid** — does literal+arith propagation prove enough
  in real loops to skip general inference?
- **Type-stable variable analysis** — how do we detect a variable that is flonum
  on every assignment (safe to keep unboxed) vs. one that is polymorphic (must
  stay boxed)? Named-let loop vars are the important case.
- **Sequencing vs. a future NaN-boxing rep.** If NaN-boxing ever lands (the
  `inexact-numbers` non-goal), scalar unboxing becomes largely moot — but rung 3
  (flonum arrays) still matters. Does that change whether rung 2 is worth building
  now?
- **`f32` / single-precision** — irrelevant to correctness, but an unboxed `f32`
  path fits an immediate word; not a goal here, noted only as a boundary.

## First rung (when it becomes a change)

Rung 1, Option A: a flonum fast path in `emit-inline-arith` mirroring the fixnum
one, plus producer→consumer fusion that keeps a flonum result unboxed when it
feeds another flonum op, boxing at escapes. Scope it to prove out the seam and the
byte-identity guarantee on `demos/mandelbrot.scm`, with the measurement spike as
its task 0.
