## 1. Baseline and measurement harness

- [x] 1.1 Record the before state: `(ack 3 10)`/`(3 11)`/`(3 12)` wall times under `build/scheme-run` and the current `ack` IR (`scheme-run --emit`) showing `rt_add`/`rt_sub`/`rt_num_eq` calls and the closure-loaded indirect self-call.
- [x] 1.2 Confirm the emission hook points: n-ary/chained forms are already binary at `emit-primcall` (`expand.ss` `expand-arith`/`compare-chain`), and the self-reference is the enclosing function's self-binding captured at closure creation.

## 2. A — inline fixnum fast path for numeric primitives

- [x] 2.1 Add an inline-eligible mapping for `+ - * = <` (fast op + slow `rt_*`) alongside `prim-table` in `src/emit.ss`.
- [x] 2.2 In `emit-primcall` (`src/emit.ss:313`), for an inline-eligible binary op emit the fixnum guard `(a|b)&7==0`, the native fast op on the true edge, and the existing `rt_*` call on the false edge, joined to one result (branch + phi so `rt_*` is only called when needed).
- [x] 2.3 Use the exact tag-0 sequences: `+`→`add`, `-`→`sub`, `=`→`icmp eq`, `<`→`icmp slt`, `*`→`ashr a,3; mul` (one operand un-shifted); comparisons produce the boolean the runtime returns.
- [x] 2.4 Keep temp numbering deterministic (independent of host eval order) so the emission-order and self-emission fixed-point invariants hold.

## 3. B-self — direct self-call + arity-check elision

- [x] 3.1 At the call site, detect when the operator resolves to the enclosing function's self-binding actually in scope (fall back to the indirect path on shadowing or any uncertainty).
- [x] 3.2 For a self-call, emit a direct `call fastcc @code_N` (the function's own label) instead of the closure-load + indirect call, and do not emit the redundant `argc` guard on that path.
- [x] 3.3 Preserve `musttail` for tail-position self-calls; keep the callee entry's arity check for closure-entry (external) callers.

## 4. Tests

- [x] 4.1 Value-equivalence: every existing demo (esp. `naryarith`, `narycmp`, `eq-not`, `fact`, `countdown`, `named-let-loop`) produces identical results; add fixnum edge cases (negatives, zero, `*`).
- [x] 4.2 IR-shape assertions: `(+ a b)`/`(< a b)` emit a native `add`/`icmp` under a fixnum guard with an `rt_*` slow path; a self-recursive function emits direct `call fastcc @code_N` without the per-call arity guard.
- [x] 4.3 Confirm a tail self-recursive loop stays `musttail`/bounded-stack (countdown / named-let suites) and an external wrong-arity closure call still errors.
- [x] 4.4 Record after Ackermann timings; note the before/after delta.

## 5. Regenerate committed IR and verify

- [x] 5.1 `make regen`; confirm `git diff bootstrap/` is coherent and re-converges to the byte-identical fixed point (iter reached).
- [x] 5.2 Run the Chez-free suite (`run-all-tests.sh`) and the Chez-gated suite (`run-dev-tests.sh`) incl. backend-equivalence, self-hosting fixed point, and the anti-stale trust-check (post-commit).

## 6. Documentation

- [x] 6.1 Update `docs/PERFORMANCE.md` P5: record the A2 seam decision, the A + B-self scope of this change, the deferred B-general, fill the OpenSpec-change line, and add the before/after Ackermann numbers.
