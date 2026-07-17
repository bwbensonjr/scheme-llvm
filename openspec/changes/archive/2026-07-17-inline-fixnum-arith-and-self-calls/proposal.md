## Why

Emit compiles integer arithmetic and self-recursion into far more work than they need. The
Ackermann probe `(ack 3 12)` — a near-pure test of calls + fixnum arithmetic with almost no
allocation — runs in ~5.8s under `scheme-run` (see `docs/PERFORMANCE.md` P5). Reading the
emitted IR of `ack` shows why: every `= + -` is an **opaque out-of-line runtime call**
(`rt_num_eq`/`rt_add`/`rt_sub`), and every recursive call is an **indirect call through the
closure** (untag `self`, load a capture slot, load the code pointer, call the register), each
entry re-runs a redundant `argc` arity guard. None of this is visible to LLVM, so nothing
folds, hoists, or inlines.

Two facts make this cheap to fix and low-risk. First, the runtime is **fixnum-only** with no
overflow or input-type checks (`src/runtime/runtime.c:120` — `rt_add(a,b)=FIX(UNFIX(a)+UNFIX(b))`;
spec `core-language` line 1023 "current fixnum-only"), and fixnums are tag `000` (`value<<3`),
so `(+ a b)` on two fixnums is literally one native `add` and `(= a b)` is one `icmp` —
byte-for-byte what `rt_*` already computes. Second, a function's self-reference is bound at
closure creation (loaded from `self`'s capture slot), so a **direct self-call is semantically
identical** to today's indirect call — pure indirection removal, no redefinition question.

## What Changes

- **A — inline fixnum fast path for hot numeric primitives** (`+ - * = <`; `> >= <=` reduce to
  these via `expand.ss`). At the single binary primcall site (`emit-primcall`, `src/emit.ss:313`),
  emit a fixnum-tag guard `(a|b)&7==0`; on the fast path emit the native op
  (`add`/`sub`/`mul-with-shift`/`icmp`); on the slow path call the existing `rt_*`. The runtime
  remains the **single definition of numeric semantics** — the inline path is a transparent
  accelerator of `rt_*`, never a divergent definition — so a future flonum/bignum change
  (deferred per `core-language` line 236, not rejected) lands in `rt_*` and the emitter already
  routes non-fixnums there.
- **B-self — direct self-calls + arity-check elision.** Recognize when a call's operator is the
  enclosing function's own self-binding and emit a direct `call fastcc @code_N` instead of the
  closure-load + indirect call, eliding the redundant `argc` guard for that call. Observably
  identical (the self-reference is already stable); it removes an indirection and, by making the
  call direct with a constant `argc`, lets LLVM inline and optimize across activations.
- **Regression + benchmark coverage.** Existing demos must produce identical values (only
  faster); add IR-shape assertions (inline `add`/`icmp` under a fixnum guard; direct self-call)
  and record before/after Ackermann timings.

Explicitly **out of scope** (deferred to a later change): **B-general** — making calls to
*other* known top-level functions direct. That breaks REPL redefinition of the callee and needs
an AOT-ship-time-only carve-out with the same dev→ship reasoning as P1's dead-code elimination;
it may ride with P1's link rework rather than stand alone.

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `aot-codegen`: add two codegen requirements — (1) fixnum numeric primitives lower to an inline
  fast path guarded by a fixnum-tag test, delegating to the runtime for non-fixnum operands; (2)
  a function's self-call lowers to a direct call with the redundant arity check elided. Both
  preserve observable semantics.

## Impact

- **Code**: `src/emit.ss` — `emit-primcall` (inline seam for the numeric prims) and the
  call-emission path (`finish-call` / closure-load, `src/emit.ss:384-402`) plus a way to
  identify a self-call. No runtime change (`rt_*` stays the slow path unchanged).
- **Committed IR**: `src/emit.ss` is part of the compiler, so `bootstrap/*.ll` must be
  regenerated (`make regen`); the Chez-gated trust-check enforces the fixed point.
- **Tests**: value-equivalence across all demos (unchanged results), new IR-shape assertions,
  Ackermann timing note. `docs/PERFORMANCE.md` P5 updated (A2 seam chosen; A + B-self scoped
  here, B-general deferred).
- **No observable semantic change**: same values, same errors, same overflow/wrap behavior as
  the current runtime; the win is generated-code quality.
