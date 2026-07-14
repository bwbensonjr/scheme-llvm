## Why

Building stage-1 `schemec` ([[self-hosting-bootstrap]] task 2.1) surfaced a self-application
miscompilation, distinct from the already-fixed [[fix-high-arity-call-convention]] `tailcc`
bug. The native `schemec` (compiler compiled by scheme-llvm, `fastcc`) compiles **closure-free**
programs byte-identically to the Chez-hosted compiler (`(+ 1 2)`, `42`, `(if …)`, `(quote …)`),
but fails on **any program that produces a closure**:

- `lambda`, `let`, `letrec`, and define-of-procedure programs abort with
  `arity error: expected 2 argument(s), got 3` — raised inside `schemec`'s **own** execution
  while it compiles the input (a 2-parameter function in `schemec`'s closure-handling path is
  called with 3 arguments).
- a recursive `letrec` (e.g. `demos/fact.scm`) **segfaults**.

**Root cause (found by bisection — not a codegen miscompilation, a prelude-arity gap):** the
prelude's `map`, `for-each`, and `append` were **fixed-arity** (`map`/`for-each` single-list;
`append` two-list), but the compiler core uses the **variadic** forms pervasively — `rename`
(`parse.ss`) does `(map cons names new)`, `(map list new es)`; `emit.ss` does
`(map (lambda (b op) …) binds ops)`, `(for-each … slots (iota k))`, and `emit-code-def` builds
its argument list with a **three-argument `append`**. Chez's `map`/`for-each`/`append` are
variadic, so the source runs Chez-hosted; under self-compilation these resolve to the
fixed-arity prelude versions, so a two-list `(map cons names new)` (or a 3-arg `append`) enters
a 2-parameter function with 3 arguments → `arity error: expected 2, got 3`. Closure-free
programs never reach a multi-list `map`, which is why they worked. The gap-sweep only verified
`schemec` *produces parseable IR*, never that it *runs*, so this was latent.

**Fix:** make the prelude `map`, `for-each`, and `append` variadic (R7RS), expressible in the
subset (rest args + `apply` + single-list/two-list helpers), like the earlier G8/G10 prelude
work. This lets `schemec` compile closure/`let`/`letrec`/recursion programs — a prerequisite
for the stage-1 build and the triple test.

**Note — the recursive-`letrec` segfault is a *separate* bug.** After the variadic fix,
`(letrec ((f (lambda (n) (if (= n 0) 1 (* n (f (- n 1))))))) (f 5))` compiles cleanly; the
`demos/fact.scm` segfault was traced to `[...]` **bracket** syntax (`rd-datum` in the prelude
reader has no case for `[`), which the assembled core uses ~529 times. That reader gap is
scoped as its own follow-up (see design D3), not fixed here.

## What Changes

- **Root-cause by bisection**: reduce the failure to a minimal program (closure form + whatever
  additional context is needed) that, compiled by scheme-llvm and run, reproduces
  `expected 2, got 3` (mirroring how [[fix-high-arity-call-convention]] was bisected). Identify
  the exact miscompiled construct / pass.
- **Fix the miscompilation** at its root in the relevant pass or emitter, keeping the existing
  behavior for the (already-correct) demo programs.
- **Determine whether the recursive-`letrec` segfault is the same root cause**; if it is, it is
  fixed here, otherwise it is scoped as a follow-up.
- **Regression test**: a demo/harness case that compiles a closure/recursion program *with the
  self-built `schemec`* (or an equivalent construct that reproduces the bug through the
  Chez-hosted compiler) and checks the result, so the class stays covered.

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `core-language`: The standard prelude `map`, `for-each`, and `append` are variadic (multi-list
  / multi-argument), matching Chez, so the compiler compiling itself yields correct code for
  `lambda`/`let`/`letrec`/recursion — not only the small closure programs the demo suite
  exercises.

## Impact

- **Code**: `src/prelude.scm` (variadic `map`/`for-each`/`append`); a regression demo
  (`demos/map-multi-list.scm`).
- **Unblocks**: closure/`let`/`letrec`/recursion under self-compilation — a prerequisite for
  [[self-hosting-bootstrap]] task 2.1 (though the bracket-reader gap below must also close before
  the core fully self-compiles).
- **Follow-up**: the `[...]` bracket-reader gap (`rd-datum`) — a distinct self-hosting blocker
  scoped separately (design D3).
- **Risk**: a prelude change validated against the full suite (demos × 3 backends + REPL) plus
  the new multi-list demo, and confirmed to let `schemec` compile closure programs.
