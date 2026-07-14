## 1. Whole-program reader

- [x] 1.1 Add `read-all-from-string` to `src/prelude.scm`: loop `rd-datum`/`rd-skip-ws` over the source, accumulating top-level forms in order until end of input.

## 2. Verification

- [x] 2.1 Tests: multi-form source (defines + trailing expr), comments/whitespace between and after forms, empty/whitespace-only input.
- [x] 2.2 Cross-check the form list against Chez `read` over a small sample source file.
- [x] 2.3 Run `./run-all-tests.sh`; all suites pass.
