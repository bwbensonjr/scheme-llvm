## Context

Grounded in the emitted IR of the Ackermann probe (`docs/PERFORMANCE.md` P5) and the emitter
source:

- **Arithmetic is out-of-line.** `+ - * = <` map through `prim-table` (`src/emit.ss:142`) and
  `emit-primcall` (`src/emit.ss:313`) to `call @rt_add`/`@rt_sub`/`@rt_mul`/`@rt_num_eq`/`@rt_lt`.
  By the time a form reaches `emit-primcall` it is **binary**: `expand.ss` (`expand-arith`,
  `expand-compare`/`compare-chain`, `src/passes/expand.ss:307`) reduces n-ary arithmetic to
  nested binary forms and chained comparisons to pairwise `<`/`=`. So a single hook at
  `emit-primcall` covers all arities and `> >= <=`.
- **The runtime is fixnum-only, unchecked.** `rt_add(a,b) = FIX(UNFIX(a)+UNFIX(b))`
  (`src/runtime/runtime.c:120`), likewise `rt_sub`/`rt_mul`/`rt_num_eq`/`rt_lt` — no overflow
  check, no operand type check, one number type (`core-language` spec lines 1023, 236). Fixnums
  are tag `000`, payload `value<<3`. Because the tag is zero, `(+ a b)` on fixnums is exactly
  `add i64 a, b` (no shifts), `(= a b)` is `icmp eq i64 a, b`, `(< a b)` is `icmp slt i64 a, b`;
  `(* a b)` is `ashr a,3; mul` (one operand must be un-shifted). These equal what `rt_*`
  computes today, bit for bit.
- **Self-calls are indirect but stable.** The recursive call loads the callee from `self`'s
  capture slot (`and self,-8; getelementptr …; load; load code; call %reg` — `finish-call`
  `src/emit.ss:393-402`, code-pointer load `src/emit.ss:384`). The self-reference is captured at
  closure creation, so it is fixed for the activation's lifetime.
- **Tail calls already work** — the two tail self-calls emit `musttail`; stack is bounded.

## Goals / Non-Goals

**Goals:**
- Inline the fixnum case of `+ - * = <` (and thus `> >= <=`) behind a fixnum-tag guard, keeping
  `rt_*` as the slow path and the single source of numeric semantics.
- Lower a function's self-call to a direct `call fastcc @code_N`, eliding the redundant per-call
  arity check, with observably identical behavior.
- Preserve exact current behavior (values, errors, wrap semantics) and dev→ship fidelity — one
  shared emitter, identical IR on REPL and AOT.
- Move the Ackermann benchmark measurably.

**Non-Goals:**
- **B-general** (direct calls to *other* known top-level functions) — deferred; needs the
  P1-style AOT-only carve-out for REPL redefinition.
- Changing the runtime, the calling convention, or adding overflow/bignum semantics.
- Inlining `quotient`/`remainder`/division or non-numeric primitives.

## Decisions

**Decision: A2 (tag-checked seam), not A1 (unconditional inline).** The inline path is guarded
by a fixnum-tag test and falls back to `rt_*` for non-fixnum operands. Today the fast and slow
paths are behaviorally identical (the runtime does no checks), so A2 costs a small guard for no
present behavior difference — but it keeps numeric semantics single-sourced in the runtime.
Bignums/flonums are explicitly *deferred, not rejected* (`core-language` line 236); when they
arrive, `rt_*` learns promotion and the emitter already routes non-fixnums there without a second
edit. *Alternative A1* (emit `add`/`icmp` unconditionally) is simpler and identical in speed for
Ackermann, but bakes fixnum-wrap into codegen and would force a future emitter change; rejected
to preserve the seam. Chosen by the user in exploration.

**Decision: fixnum guard is `(a | b) & 7 == 0`.** Both operands are fixnums iff neither carries
a non-zero tag; OR-ing the tagged words and testing the low 3 bits does this in one `or` + one
`and` + one `icmp`. When an operand is a literal fixnum (e.g. `(+ n 1)` → `b = 8`) or otherwise
statically known to be a fixnum, LLVM folds the guard away, so hot loops often keep just the
native op.

**Decision: hook the inline seam at `emit-primcall` (binary).** Because expansion already made
every arithmetic/comparison op binary, `emit-primcall` (`src/emit.ss:313`) is the one place to
branch: for the five inline-eligible ops emit guard + fast op + slow call (an LLVM `select` or a
small diamond of blocks yielding a phi); for everything else, the current `call @rt_*`. A
`prim-table` entry can gain an "inline template" field or a parallel table keyed by op.

**Decision: identify a self-call structurally, at emission.** The emitter knows the function it
is currently emitting and that function's self-binding (the name bound by the enclosing
`letrec`/closure whose body is being emitted). A call whose operator resolves to exactly that
self-binding is a self-call. This is a local check at the call site against the current
function's identity — no new whole-program analysis. When it matches, emit `call fastcc @code_N`
(the label of the function being emitted) directly; otherwise keep the closure-load + indirect
call. This deliberately covers **only** the self case; references to other top-level names stay
indirect (B-general).

**Decision: elide the arity check on the direct self-call path by construction, keep it at
entry.** The direct self-call is emitted by us with the function's exact arity, so we simply do
not emit an `argc` guard for that call, and — since the callee's own entry still runs its arity
check — closure-entry (external) callers remain checked. Making the call direct with a constant
`argc` additionally lets LLVM fold the entry `icmp argc,K` and inline the leaf, so the check
tends to vanish even where it remains. We rely on emission to skip the redundant work on the
self path rather than adding a second (check-skipping) entry label, keeping the prototype
uniform and `musttail` legal.

**Decision: regenerate committed IR via `make regen`.** `src/emit.ss` is the compiler; the
committed `bootstrap/*.ll` must be regenerated and re-converge to the byte-identical fixed point
(trust-check enforces it).

## Risks / Trade-offs

- **Inline fixnum path must exactly match `rt_*`** → For `+ - =` the equivalence is trivial
  (tag 000). `*` needs exactly one operand un-shifted (`ashr a,3` then `mul`), and `<` uses
  signed `slt` to match `UNFIX`'s arithmetic (signed) shift. Guard against sign/shift mistakes
  with value-equivalence tests over the existing `naryarith`/`narycmp` demos plus edge cases
  (negatives, zero).
- **Emission-order determinism** → `aot-codegen` requires identical temp numbering independent
  of host eval order; the new diamond/`select` must allocate temps deterministically. Covered by
  the existing "emission order" tests and the self-emission fixed-point suite.
- **Self-call detection false-positive** → If a name shadows the self-binding (an inner `let`
  rebinding the function's name), the call is NOT a self-call. Detection must compare against the
  self-binding actually in scope, not just the symbol; err toward the indirect path when unsure
  (always correct, just slower).
- **Interaction with `musttail`** → Tail self-calls must stay `musttail`; a direct
  `musttail call fastcc @code_N` is legal under the uniform prototype. Verify the countdown /
  tail-loop suites and a tail self-recursive case remain bounded-stack.
- **Forgetting `make regen`** → invisible in binaries until regenerated; mitigated by the
  trust-check and an explicit task step.

## Migration Plan

No user migration. Deploy: edit `src/emit.ss`, add tests, `make regen`, run suites, record
Ackermann timings. Rollback: revert the commit + `make regen`.

## Open Questions

- **Should `*` be in the first cut?** It needs the shift and is rarer on hot paths than `+ - =`;
  including it is cheap but adds one more equivalence to verify. (Leaning: include all five for
  completeness, since the guard/machinery is shared.)
- **Fast-path shape: `select` vs. branch+phi?** A `select` keeps both ops always evaluated (fine
  for pure arithmetic, no traps) and is simplest; a branch avoids the slow `rt_*` call on the
  fast path. Since the slow path is a *call*, a branch (only calling `rt_*` when needed) is
  preferable. Confirm during implementation.
