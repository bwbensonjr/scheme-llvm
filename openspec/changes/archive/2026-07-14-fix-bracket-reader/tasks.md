## 1. Failing regression (TDD)

- [x] 1.1 Add a demo exercising `[...]` via the in-language reader — `demos/reader-brackets.scm`:
      `(read-all-from-string "(a [b c] [d 5])")` (expected `((a (b c) (d 5)))`), registered in
      `demos/run-tests.sh`. RED before the fix: brackets read as atoms → `((a [b c] [d 5]))`.
      (A bracket *source* demo would not test the gap — `run-tests.sh` compiles via Chez `read`,
      which already accepts brackets; the gap is in the prelude reader, seen by `schemec`.)

## 2. Fix the reader

- [x] 2.1 `src/prelude.scm` `rd-datum`: dispatch `[` (char 91) to `rd-list` (like `(`).
- [x] 2.2 `src/prelude.scm` `rd-list`: accept `]` (char 93) as a list terminator in addition to
      `)` (char 41).
- [x] 2.3 `src/prelude.scm` `rd-delim?`: add `[` (91) and `]` (93) as token delimiters so an atom
      adjacent to a bracket (e.g. `5]`) terminates correctly.

## 3. Verification

- [x] 3.1 The in-language reader reads brackets to the paren structure (`reader-brackets` demo
      → `((a (b c) (d 5)))`); `schemec` compiles `(let ([x 5] [y 6]) (+ x y))` (was SEGV → rc=0).
- [x] 3.2 `build/schemec` compiles a bracketed program (`demos/fact.scm`) **without segfaulting**
      and the emitted IR is **correct** — it links and runs to `120`. **Not byte-identical to the
      Chez-hosted compiler**, but the difference is *only* temp ordering from an evaluation-order
      divergence (Chez evaluates call arguments right-to-left, scheme-llvm left-to-right, so
      `(emit-app (ev f …) (map … args) …)` sequences `fresh-temp` differently). That is a
      SEPARATE self-hosting blocker (the byte-identical fixed point), scoped as a follow-up
      ([[fix-emit-eval-order]]); the bracket reader itself is correct.
- [x] 3.3 Run `./run-all-tests.sh` (incl. the `read-all` reader units + new `reader-brackets`
      demo); all suites pass.

## 4. Hand off

- [x] 4.1 Hand back to [[self-hosting-bootstrap]] task 2.1: the bracket reader is in; `schemec`
      now reads/compiles bracket-bearing programs. Full byte-identical self-compilation of the
      core additionally requires the evaluation-order follow-up. Recorded in
      self-hosting-bootstrap §2.
