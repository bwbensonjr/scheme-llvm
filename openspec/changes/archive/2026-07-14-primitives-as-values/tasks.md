## 1. Compiler support

- [x] 1.1 In `src/parse.ss`, add `*prim-eta-arity*` (`car`/`cdr`/`cons`) and eta-expand a
  primitive in value position: `parse-expr`'s symbol case rewrites a prim to
  `(lambda (p …) (op p …))` (fixed arity) or `(lambda gs (%str-concat gs))` (`string-append`).
- [x] 1.2 In `src/passes/expand.ss`, fold direct N-ary `string-append` to nested binary primcalls
  (`expand-string-append`, reusing `fold-arith`); `()` → `""`, one arg → that arg.
- [x] 1.3 In `src/prelude.scm`, add the common-subset helper `%str-concat` (folds 2-arg
  `string-append` over a list), used by the value-position eta.

## 2. Verification

- [x] 2.1 `(map car …)`, `(fold-right cons …)`, `(apply string-append …)`, and direct
  `(string-append a b c d)` compile and run correctly (`()` → `""`).
- [x] 2.2 Direct `(car x)`/`(cons a b)`/2-arg `(string-append a b)` are byte-identical IR
  (`--no-prelude` diff).
- [x] 2.3 The prelude still loads and runs under the bootstrap host (the `read-all` reader suite,
  which `(load)`s `src/prelude.scm`, passes).
- [x] 2.4 Run `./run-all-tests.sh`; all suites pass.
- [x] 2.5 Hand off to [[self-hosting-bootstrap]]: with G8 closed (subsuming G4), the assembled
  core compiles clean end-to-end with scheme-llvm (no shims). Note the separate 2-list `map`
  runtime gap for the backlog.
