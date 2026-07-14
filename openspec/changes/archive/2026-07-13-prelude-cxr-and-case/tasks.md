## 1. cxr combinators

- [x] 1.1 Add `caar cadr cdar cddr` and the depth-3 forms (`caaar` … `cdddr`) to `src/prelude.scm` as compositions of `car`/`cdr`.
- [x] 1.2 Add `memv` to the prelude (eqv? analogue of `memq`) if not present.

## 2. case macro

- [x] 2.1 Add `case` as a `syntax-rules` derived form (bind key once; `cond` over `(memv key '(d ...))`; `else` last).

## 3. Verification

- [x] 3.1 Add a demo exercising `case` and a few cxr forms (`demos/`), wired into the demo suite.
- [x] 3.2 Run `./run-all-tests.sh`; confirm all suites pass.
