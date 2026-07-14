## Context

The AOT/JIT calling convention (spec `aot-codegen` "Emit the argc + overflow calling
convention") gives every Scheme function one uniform prototype
`tailcc i64 (i64 self, i64 argc, i64 a0 … i64 a{K-1}, ptr overflow)`, where `K` is the
whole-program max fixed arity. Calls pass `K+3` arguments. This was chosen so a single
prototype makes `musttail` legal everywhere and the fixed-arity path is allocation-free.

## The bug

On arm64 the AAPCS integer argument registers are `x0..x7` (8). A call with `K+3 > 8`
arguments — i.e. **`K ≥ 6`** — passes at least one argument on the stack. Empirically, a
**non-tail `call tailcc` with a stack-passed argument corrupts the caller's live arguments**:
after the call returns, values the caller still needs read as garbage.

Reproduction (minimal, 5 lines):

```scheme
(define (big a1 a2 a3 a4 a5 a6) (+ a1 a2))   ; forces K = 6
(define (helper x) (+ x 100))
(define (f a b) (+ (helper a) b))            ; non-tail call; b must survive it
(f 10 20)                                     ; K≤5 ⇒ 130 (correct); K≥6 ⇒ garbage
```

Evidence: correct at `K = 4,5`; garbage at `K = 6,7`. A plain tail loop (`down`) and a 6-arg
call (`sum6`) are correct at high `K` — only **non-tail closure calls with live args** break,
because those are what must preserve caller state across the call. The failure is independent
of `-O0`/`-O2` (so it is an ABI/CC issue, not an optimizer artifact). The self-compiled core
hangs/crashes because its passes and the in-language reader are saturated with such calls and
its max arity is 7.

## Goals / Non-Goals

**Goals:** correct argument passing at all arities; keep guaranteed `musttail` tail calls; keep
the fixed-arity hot path allocation-free; no change to the value representation or the
overflow/variadic mechanism.

**Non-Goals:** redesigning the calling convention (e.g. passing all args through a spilled
`argv`); changing `K`; performance tuning beyond preserving today's behavior.

## Decisions

### D1: Emit `fastcc`, not `tailcc`

Change the emitted calling convention from `tailcc` to `fastcc` for the function prototype and
every call. Rationale:

- `fastcc` preserves the caller's live arguments across a non-tail call with stack-passed
  arguments; `tailcc` (as LLVM lowers a *non-tail* `call tailcc` with stack args) does not.
  Verified: the minimal repro returns `130` under `fastcc`.
- **Guaranteed tail calls are unaffected.** The code generator always emits tail calls as
  `musttail` (`finish-call` uses `(if tc? "musttail " "")` and `tc?` is hard-wired to `#t` in
  `emit-code-def`; it is never threaded as `#f`). `musttail` is verifier-enforced and honored
  under `fastcc`. Verified: the 10M-iteration `countdown` loop completes in bounded stack under
  `fastcc`.
- Minimal blast radius: the uniform-prototype architecture, the `argc`+`overflow` mechanism,
  the arity check, and the allocation-free hot path are all unchanged. Only the CC token
  changes (the four `tailcc` occurrences in `src/emit.ss`: the prototype in `emit-code-def`
  and the two calls in `finish-call`, plus the convention comment).

### D2: Why not restructure the convention

Alternatives considered and rejected as heavier for no added correctness:

- **Cap positional slots at 5** (route fixed args `≥ 5` through `overflow` so calls never
  exceed 8 args): keeps `tailcc` but complicates the callee prologue, arity check, and rest
  building; larger and riskier than a CC swap.
- **Uniform `argv` pointer** (`fastcc i64 (self, argc, ptr args)`): simplest signature but
  allocates an argument array on **every** call, violating the allocation-free hot-path
  requirement and regressing the common low-arity case.

`fastcc` fixes the bug with the least change and preserves every existing guarantee.

## Risks / Trade-offs

- **`fastcc` musttail guarantee** → enforced by the IR verifier and confirmed at runtime (10M
  bounded-stack loop); if a future emitted tail call were ever *not* `musttail`, `fastcc` would
  not auto-TCO it (unlike `tailcc`). Guard: keep every tail call `musttail` (already invariant),
  and the `countdown`/`named-let-loop` demos regression-test it.
- **All backends share the IR** → the persistent REPL host (ORC/LLJIT), `lli` JIT, and bitcode
  paths consume the same emitted convention, so the change is uniform; the full suite
  (`run-all-tests.sh`) exercises all of them.

## Verification

1. New high-arity test: the minimal repro (and a read-a-list-at-`K≥6` variant) returns the
   correct value.
2. `./run-all-tests.sh` — all suites pass (demos × 3 backends, REPL host, interactive REPL,
   equivalence/batch), confirming no regression, especially the deep-tail-loop demos.
3. Hand back to [[self-hosting-bootstrap]] 2.1: rebuild `build/schemec` and confirm it emits
   IR (no hang/crash) for a trivial program.
