## 1. Root-cause (bisection, before any fix)

- [x] 1.1 Reduce to a minimal failing program (`((lambda (x) x) 5)`) and confirm it reproduces
      `arity error: expected 2, got 3` through `build/schemec`. — confirmed.
- [x] 1.2 Bisect which pipeline stage in `schemec` mishandles the closure. — `rename-program`
      (`parse.ss`) for the lambda case; `emit-code-def` (`emit.ss`) for the define case.
- [x] 1.3 Find the specific construct scheme-llvm "miscompiles". — **Not a miscompilation: a
      prelude-arity gap.** `rename` uses two-list `map` (`(map cons names new)`) and
      `emit-code-def` uses three-argument `append`; the prelude `map`/`for-each`/`append` were
      fixed-arity, so a multi-list call entered a 2-param function with 3 args. Recorded in
      design.md (Root cause).

## 2. Fix

- [x] 2.1 Failing regression demo (TDD red): `demos/map-multi-list.scm` (multi-list `map`) —
      returned `arity error: expected 2, got 3` before the fix; registered in `demos/run-tests.sh`.
- [x] 2.2 Fix at the root in `src/prelude.scm`: make `map`, `for-each`, and `append` variadic
      (R7RS) via rest args + `apply` + single-list/two-list helpers (`%map1`, `%mapn`,
      `%any-null?`, `%for-each1`, `%for-eachn`, `%append2`). Single-list/2-arg stays the fast path.

## 3. Verification

- [x] 3.1 Green: `build/schemec` now compiles `((lambda (x) x) 5)`, `(let …)`,
      `(define (f n) n) (f 5)`, and `(letrec … recursion …)` (parens) without error.
- [x] 3.2 Re-test the recursive `letrec` segfault (`demos/fact.scm`). — **Root-caused to a
      SEPARATE bug:** the `[...]` bracket syntax. The prelude reader's `rd-datum` has no case for
      `[` (char 91); the assembled core uses ~529 brackets. Scoped as a follow-up
      (design D3), NOT this change.
- [x] 3.3 `./run-all-tests.sh` — all suites pass (incl. the new `map-multi-list` demo); no
      regression.

## 4. Hand off

- [x] 4.1 Hand back to [[self-hosting-bootstrap]] task 2.1: the closure-arity class is fixed;
      full self-compilation of the core additionally requires the bracket-reader follow-up. Note
      recorded in self-hosting-bootstrap §2.
