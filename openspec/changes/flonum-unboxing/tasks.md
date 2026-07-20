## 0. Measurement spike (set the ceiling before writing any pass)

- [x] 0.1 Hand-write unboxed `f64` LLVM IR for the `demos/mandelbrot.scm` `escape-count` inner loop (native `fadd`/`fmul`/`fsub`/`fcmp`, no `rt_make_flonum` on intermediates) — inspected the actual emitted IR (`code_56`); confirmed every flonum op takes the fixnum-guard slow arm (`rt_mul`/`rt_add`/`rt_sub`) and allocates, plus per-iteration `rt_flonum_lit` for `4.0`/`2.0`
- [x] 0.2 Emit the *naive* boxed version (each op does `rt_make_flonum` then `flo_val`) and read the `-O2` output; confirm LLVM does NOT fold the box/unbox round-trip (GC_MALLOC side effect is preserved) — validates decision D3 — `scratchpad/d3test.ll`: GC_malloc + stores survive even with store→load forwarded
- [x] 0.3 Record the baseline for the boxed lowering: allocation count, frame time, and GC pressure for a representative render; record the hand-unboxed loop's numbers as the achievable ceiling — heavy render 300×120@400: native 0.24s / ≈2064 GC collections; JIT 0.50s
- [x] 0.4 Write the spike findings into `design.md` Open Questions (Rung-1 expected win) so task 5 has a target to compare against — added "Spike Findings (task 0)" section to `design.md`

## 1. Flonum inline fast path in the emitter

- [x] 1.1 Study the existing fixnum path in `src/emit.ss` (`inline-arith-table` / `emit-inline-arith`, ~lines 321-382) as the mirror pattern
- [x] 1.2 Add flonum lowering for `+ - * = <` (and `> >= <=` via their existing reduction) that emits native `fadd`/`fsub`/`fmul`/`fcmp` on unboxed `f64` values — `emit-flonum-region`/`region->f64`
- [x] 1.3 Guard the flonum path (flonum-tag test or proven-flonum) and delegate any non-fixnum/non-flonum or unspecialized-mixed operand to the existing `rt_*` primitive — `rt_flonum_p` leaf guards + `region->i64-slow` fallback
- [x] 1.4 Confirm `/` and `modulo` remain out-of-line `rt_div`/`rt_modulo` calls (unchanged, no inline path) — not in `inline-arith-table`, so never region-eligible

## 2. The f64 seam (second machine type in the IR)

- [x] 2.1 Introduce a "this node emitted an `f64`, not a `val`" annotation on emitted expression nodes — realized as `region->f64` returning a native `double` operand (the f64 shadow is the return type of the region walk, not a per-node flag)
- [x] 2.2 Implement the two conversions: unbox (`flo_val`, a load: `val i64` → `double`) and box (`rt_make_flonum`, an alloc: `double` → `val i64`); declare externs as needed — `unbox-flonum` (inline mask+load), `rt_make_flonum` boxing; `declare i64 @rt_make_flonum(double)` added
- [x] 2.3 Ensure the boxed `{HDR_FLONUM, double}` representation is untouched — the box remains the canonical `val` — unchanged; runtime and `encode-const` flonum literal path intact

## 3. Intra-expression fusion and escape boxing (Rung 1, Option A)

- [x] 3.1 Keep a flonum result unboxed in an `f64` register when it feeds another flonum op within one expression tree (producer→consumer fusion) — region-internal arith nodes recurse in `region->f64` with no intermediate box
- [x] 3.2 Cancel every `box ∘ unbox` pair (`rt_make_flonum` immediately followed by `flo_val`) — structurally avoided: intermediates never box, so no pair is ever created to cancel; box happens once at the region root
- [x] 3.3 Box (`rt_make_flonum`) at every escape point: store into pair/vector/record/box, return into a `val` slot, pass to a `val`-typed call (INCLUDING the `tailcc` loop back-edge — Rung 2 is out of scope), consume by a `val`-only op (`display`/`write`/`eqv?`/`equal?`/`cons`), or assign to a type-unstable variable — the region root boxes; everything outside a region stays on the existing `val` path, so all escapes see a boxed `val`

## 4. Flonum-ness propagation (proven-where-cheap)

- [x] 4.1 Mark cheap certain flonum sources as known-flonum: literal flonums, any flonum-fast-path result, and `exact->inexact` results — `flo-src?` (inexact `const`, `%exact->inexact`, arith contagion, `*fset*` vars)
- [x] 4.2 Forward-propagate flonum-ness within the expression; where it cannot be proven, fall back wholesale to the boxed `rt_*` path — contagion in `flo-src?`; unproven leaves guarded, whole region falls to the slow arm at runtime
- [x] 4.3 Verify literal + arith propagation proves `zx`/`zy` flonum in the mandelbrot loop without a general inference pass; note in `design.md` if it does not — the per-code-block `compute-flonum-params` fixpoint proves `zx`/`zy` (excludes counter `i`); literal-only propagation was insufficient for the new-`zx` region, as recorded in design.md

## 5. Verification

- [x] 5.1 Result parity: compile and run all numeric demos + `demos/mandelbrot.scm`; every result MUST be bit-identical to the previous boxed lowering — `demos/run-tests.sh` 70/70, `mandelbrot` byte-identical to `mandelbrot.expected`
- [x] 5.2 Assert dev→ship byte-identity: the shared emitter makes JIT and AOT emit byte-identical code; the `byte-identical-backends` demo check MUST pass — `demos/run-backends.sh` 49/49 aot=jit=bitcode (incl. `flonumunbox`); `make regen` idempotent (bootstrap IR unchanged)
- [x] 5.3 Re-measure allocation count / frame time / GC pressure on mandelbrot and compare against the task-0 baseline and ceiling; confirm the intra-expression boxes (≈7 of 9/iter) are eliminated — heavy render: GC collections ~2064→~695 (−66%), native run 0.24s→0.10s (~2.4×); ~12→~4 allocs/iter (table in design.md)
- [x] 5.4 Add/adjust demos or checks that exercise the flonum fast path and each escape point — `demos/flonum-unbox.scm` (accumulator loop, fused arith, vector escape, comparison region, mixed-operand guard fallback), registered in run-tests.sh + run-backends.sh

## 6. Docs and close-out

- [x] 6.1 Update `inexact-numbers` cross-refs for the D2 "no flonum inline path" supersession (recorded as an exploration follow-on) — noted in `openspec/explorations/flonum-unboxing.md`; the `aot-codegen` delta MODIFIES the requirement that carried the D2 clause
- [x] 6.2 Run `openspec validate --change flonum-unboxing --strict` and fix any issues — `openspec validate flonum-unboxing --strict` → valid
- [x] 6.3 Update `docs/PIPELINE.md` / `LLVM.md` if the emitter's f64 seam warrants a note — added a "Flonum f64 regions" paragraph to `docs/PIPELINE.md`
