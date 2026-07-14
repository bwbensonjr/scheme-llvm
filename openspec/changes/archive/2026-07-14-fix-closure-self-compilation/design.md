## Context

`schemec` is the compiler core assembled into one program and compiled to native by the
Chez-hosted scheme-llvm (see [[self-hosting-bootstrap]] 2.1, `make build/schemec`). After
[[fix-high-arity-call-convention]] it is `fastcc` and compiles closure-free programs
byte-identically to the Chez compiler. It still fails on closure-bearing input.

## Observed behavior (evidence gathered 2026-07-14)

Feeding source text to `build/schemec` on stdin (`printf '…' | build/schemec`):

| Input | Result |
|-------|--------|
| `(+ 1 2)`, `42`, `(if #t 1 2)`, `1 2`, `(car (quote (1 2)))`, `(quote (1 2 3))` | ✅ correct IR |
| `((lambda (x) x) 5)` | ❌ `arity error: expected 2 argument(s), got 3` |
| `(let ((x 5)) x)`, `(let ((x 5)) (+ x 1))` | ❌ same arity error |
| `(define x 5) x`, `(define (f n) n) (f 5)` | ❌ same arity error |
| `(letrec ((f (lambda (n) n))) (f 3))` | ❌ same arity error |
| `(letrec ((f (lambda (n) (if (= n 0) 1 (f (- n 1)))))) (f 3))` | ❌ arity error |
| `demos/fact.scm` (recursive `letrec`) | 💥 segfault |
| the whole prelude (defines, no trailing expr) | ✅ clean `collect-toplevel` error — so reading/`collect-toplevel` handle ~79 defines fine |

The trigger is **producing a closure** (any `lambda`, or `let`/`letrec`/define that lowers to
one). The error is raised by `schemec`'s *own* runtime (`rt_arity_error`) *while compiling* — a
fixed-arity-2 function in its pipeline is entered with `argc = 3`. The Chez-hosted compiler
compiles all of these correctly, and scheme-llvm's demo suite (which includes closures,
`let`, named-`let` loops, multi-define programs) passes on all three backends — so the defect
is specific to scheme-llvm compiling **the compiler's own closure-handling code**.

## Root cause (found 2026-07-14 — task 1 complete)

**It is not a codegen miscompilation. It is a missing prelude capability.** The prelude's `map`
and `for-each` are **single-list only**:

```scheme
(define (map f xs)      (if (null? xs) '() (cons (f (car xs)) (map f (cdr xs)))))
(define (for-each f xs) (if (null? xs) (if #f #f) (begin (f (car xs)) (for-each f (cdr xs)))))
```

But the compiler core uses the **multi-list** (R7RS-variadic) forms pervasively — `parse.ss`'s
`rename` has `(map cons names new)`, `(map cons xs new)`, `(map list new es)`; `emit.ss` has
`(map (lambda (b op) …) binds ops)`, `(map … slots (iota k))`, `(map … fixed (iota f))`,
`(for-each (lambda (s i) …) slots (iota k))`; etc. Chez's built-in `map`/`for-each` are
variadic, so the source runs fine Chez-hosted; under self-compilation `map`/`for-each` resolve
to the 2-arg prelude versions, and a 2-list call `(map cons names new)` enters a 2-parameter
function with 3 arguments → `arity error: expected 2, got 3`.

Bisection: `read` ✓ → `collect-define-syntax` ✓ → `compute-known` ✓ → `collect-toplevel` ✓ →
`expand` ✓ → `parse-program` ✓ → **`rename-program` ✗** (its `(lambda …)` case is the first
multi-list `map` the pipeline reaches). Minimal mechanism confirmed:
`(map cons (quote (1 2)) (quote (3 4)))` compiled by scheme-llvm errors `expected 2, got 3`.

**Fix: make the prelude `map` and `for-each` variadic (accept ≥ 1 lists).** Expressible in the
subset (rest args + `apply` + a single-list helper), like the G8/G10 prelude work. This is why
closure-free programs worked (they reach no multi-list `map`) while any `lambda`/`let`/`letrec`/
`define`-of-procedure program hit `rename`'s multi-list `map` immediately.

## Goals / Non-Goals

**Goals:** make the prelude `map`/`for-each` variadic so the self-compiled compiler runs its own
closure path; keep all currently passing programs correct; add a regression test that exercises
a multi-list `map` compiled by scheme-llvm.

**Non-Goals:** the full stage-1 build / triple test (that resumes in
[[self-hosting-bootstrap]]); performance; the `tailcc→fastcc` work (done). The recursive
`letrec` segfault is investigated here but may be split out if it is a separate root cause.

## Approach

### D1: Bisect to a minimal repro (root cause before fix)

Follow the method that localized [[fix-high-arity-call-convention]]:

1. Reduce to the smallest failing program (already close: `((lambda (x) x) 5)`).
2. Bisect the pipeline stage that misbehaves. Because the arity error is raised *by `schemec`
   at compile time*, the miscompiled code is in whichever of `schemec`'s pipeline functions
   handles closures — likely `convert-closures` (free-variable capture, `self` threading) or
   closure emission (`emit-make-closure` / `emit-closure-block` / the closure-body call shape).
   Build small variants of the assembled core whose entry calls one stage on a closure input
   and see which stage aborts (the same `build/…scm` + `--emit-ir` + link technique used for
   the tailcc bisection).
3. Once the stage is known, find the specific construct scheme-llvm miscompiles by shrinking
   that stage's code path — the "expected 2, got 3" says a 2-arg function is called with 3
   args, so look for where an arg count is computed or a call is shaped in the closure path
   (candidate mechanisms: a variadic/`apply` call whose `argc` is computed wrong, an
   `emit-spill`/overflow index, or a `map`/fold over closure fields that passes an extra
   element).

### D2: Fix at the root, not the symptom

Fix the identified construct in the pass/emitter. Re-derive the minimal repro as a failing
test first (TDD), then confirm the fix turns it green without changing the IR for the
already-correct demos.

### D3: Recursive-`letrec` segfault

After the arity fix, re-test `demos/fact.scm` through `schemec`. If the segfault is gone, it
shared the root cause. If it persists, record it and scope a follow-up change (it may be a
distinct miscompilation — e.g. self-referential closure capture or tail-recursion under
self-compilation).

## Risks / Trade-offs

- **Root cause not yet known** → task 1 is the bisection; no fix is attempted before it, per
  systematic-debugging. The minimal repro is already small, so localization should be quick.
- **Fix could regress working programs** → guard with the full `run-all-tests.sh` (demos × 3
  backends + REPL) plus the new self-compiled closure case.
- **Multiple independent closure bugs** → possible; each becomes its own minimal repro and, if
  not fixable together, its own change (the segfault is the first candidate).

## Verification

1. Failing minimal repro (closure program) reproduces `expected 2, got 3` before the fix.
2. After the fix: `build/schemec` compiles `((lambda (x) x) 5)`, `(let …)`, `(define …)`, and a
   `letrec` program without error, emitting IR that matches the Chez-hosted compiler; the
   recursive `letrec` either works or is scoped out (D3).
3. `./run-all-tests.sh` — all suites still pass.
4. Hand back to [[self-hosting-bootstrap]] 2.1.
