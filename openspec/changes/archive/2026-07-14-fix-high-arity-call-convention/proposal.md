## Why

The self-hosting stage-1 build ([[self-hosting-bootstrap]] task 2.1) produced a native
`schemec` that builds cleanly (2 MB IR, links) but **hangs or crashes at runtime** on trivial
input. Root cause (systematic-debugging, 2026-07-14): a **calling-convention bug** at high
arity.

Every emitted function uses the prototype `tailcc i64 (self, argc, a0..a{K-1}, overflow)` —
`K+3` arguments, where `K` is the whole-program max fixed arity. On arm64 the first 8 integer
arguments are register-passed; the rest spill to the stack. When **`K ≥ 6`** a call passes
`≥ 9` arguments, so at least one is stack-passed, and a **non-tail `call tailcc` with a
stack-passed argument does not preserve the caller's live arguments** — the caller reads
garbage after the call returns. `K ≤ 5` (≤ 8 args, all in registers) is correct.

The compiler core has arity-7 functions (`ev-if`/`et-if`), and its passes/reader are full of
non-tail calls with live arguments, so self-compilation trips this pervasively. **Every demo
and test is `K ≤ 5`**, which is why the suite never caught it. The defect is independent of
`-O0`/`-O2`.

## What Changes

- **Emit `fastcc` instead of `tailcc`** for the uniform function prototype and all call sites.
  `fastcc` preserves the caller's live arguments across non-tail calls with stack-passed
  arguments; `tailcc` does not. Every emitted tail call is already `musttail` (the code
  generator always emits `musttail` in tail position — the `tc?` flag is always true), and
  `fastcc` **guarantees `musttail`**, so guaranteed tail calls (the allocation-free hot path
  and deep tail loops) are preserved. Verified: the 10M-iteration `countdown` loop still runs
  in bounded stack under `fastcc`.
- **Add a high-arity regression test**: a program whose max arity `K ≥ 6` that makes a non-tail
  closure call with a live argument must return the correct value (the minimal repro:
  `(define (big a1..a6) …) (define (helper x) …) (define (f a b) (+ (helper a) b)) (f 10 20)`
  ⇒ `130`).

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `aot-codegen`: The "argc + overflow calling convention" requirement is corrected to use
  `fastcc` so that argument passing is correct at **all** arities (not only `K ≤ 5`), while
  still guaranteeing `musttail` tail calls and the allocation-free fixed-arity hot path.

## Impact

- **Code**: `src/emit.ss` (the `tailcc` → `fastcc` occurrences in the prototype and calls); a
  new high-arity demo/test.
- **Unblocks**: [[self-hosting-bootstrap]] task 2.1 (a working native `schemec`).
- **Risk**: low-to-moderate — a calling-convention change validated against the full suite
  (all demos across three backends, the persistent REPL host, and interactive REPL), plus the
  new high-arity test. The REPL host / JIT / bitcode paths consume the same emitted IR, so the
  change applies uniformly.
