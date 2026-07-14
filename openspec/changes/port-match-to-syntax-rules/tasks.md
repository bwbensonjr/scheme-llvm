## 1. Consume the matcher decision

- [ ] 1.1 Read the recorded decision from [[select-syntax-rules-matcher]]: the chosen matcher, its pattern convention, and (if Wright-style) the literal→`'quote`, `,x`→binder, `(guard …)`→`?`-pattern mapping to apply during the rewrite.
- [ ] 1.2 Read the recorded required expander work (e.g. add the ellipsis escape `(... ...)`) that the rewrite depends on.

## 2. Implement the required expander support

- [ ] 2.1 Implement in `src/passes/expand.ss` the `syntax-rules` construct(s) the decision identified as required (e.g. the ellipsis escape `(... ...)`); skip if the decision recorded that none is needed.
- [ ] 2.2 Add expander unit tests for the required construct(s) (e.g. ellipsis escape yields a literal `...`; ellipsis-with-tail depth handling) alongside the existing macro-system tests.

## 3. Adopt the matcher and rewrite the passes

- [ ] 3.1 Add the chosen matcher module and make it usable from the passes; retire `src/match.sls` and its `(chezscheme)`/`syntax-case` imports.
- [ ] 3.2 Rewrite `match` forms in `src/parse.ss` to the adopted syntax; run the full suite.
- [ ] 3.3 Rewrite `match` forms in `src/passes/recognize-let.ss`, `convert-assignments.ss`, `convert-closures.ss`, `lower.ss` (one file at a time; suite green after each).
- [ ] 3.4 Rewrite `match` forms in `src/emit.ss` (the largest, ~12 forms); run the full suite.
- [ ] 3.5 Grep-confirm no `match.sls`, `syntax-case`, `with-syntax`, `generate-temporaries`, `datum`, or quasisyntax references remain in the compiler source.

## 4. Verification

- [ ] 4.1 Run `./run-all-tests.sh`; confirm all suites pass and results/IR are unchanged (behavior-preserving port).
- [ ] 4.2 Add a focused matcher test file exercising each used pattern shape and each guard, so the matcher is covered independently of the passes.
- [ ] 4.3 Confirm the host (Chez) build uses the same matcher module that scheme-llvm's expander can expand (single-matcher property).
