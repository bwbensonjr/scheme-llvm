## 1. Fix the quasiquote expander

- [x] 1.1 In `src/passes/expand.ss` `qq`, add `(pair? (cdr d))` to the `unquote`,
  `unquote-splicing`, and `quasiquote` head-check cond arms so a bare `(kw)` list-datum falls
  through to general-pair rebuilding. (Also guarded the leading-splice arm with
  `(pair? (cdr (car d)))`, which had the same latent `(cadr (car d))` crash.)

## 2. Verification

- [x] 2.1 Regression: `` `(list (quote unquote) ,(+ 1 2)) `` and `` `(a unquote b) `` compile
  and produce the correct literal structure (compare to Chez).
- [x] 2.2 Confirm existing quasiquote output is byte-identical (no drift for well-formed input).
- [x] 2.3 Run `./run-all-tests.sh`; all suites pass.
- [x] 2.4 Hand off to [[self-hosting-bootstrap]]: with G6 closed, the assembled core clears the
  first compile blocker.
