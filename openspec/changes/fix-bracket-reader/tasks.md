## 1. Failing regression (TDD)

- [ ] 1.1 Add a demo using `[...]` bracket syntax — e.g. `demos/brackets.scm`:
      `(let ([x 5] [y 6]) (+ x y))` (expected `11`) and/or a bracketed `letrec`. Register it in
      `demos/run-tests.sh`. Confirm it FAILS/segfaults before the fix (via `build/schemec`, and/or
      that the in-language reader mis-reads it).

## 2. Fix the reader

- [ ] 2.1 `src/prelude.scm` `rd-datum`: dispatch `[` (char 91) to `rd-list` (like `(`).
- [ ] 2.2 `src/prelude.scm` `rd-list`: accept `]` (char 93) as a list terminator in addition to
      `)` (char 41).
- [ ] 2.3 `src/prelude.scm` `rd-delim?`: add `[` (91) and `]` (93) as token delimiters so an atom
      adjacent to a bracket (e.g. `5]`) terminates correctly.

## 3. Verification

- [ ] 3.1 The in-language reader reads `(let ([x 5]) x)` to the same structure as the paren form;
      the bracket demo returns its expected value across all three backends.
- [ ] 3.2 `build/schemec` compiles a bracketed program (`demos/fact.scm`) without segfaulting,
      emitting IR byte-identical to the Chez-hosted compiler.
- [ ] 3.3 Run `./run-all-tests.sh` (incl. the `read-all` reader units); all suites pass.

## 4. Hand off

- [ ] 4.1 Hand back to [[self-hosting-bootstrap]] task 2.1: with variadic prelude procs and
      bracket reading in, `build/schemec` should read and compile the bracket-bearing assembled
      core — resume the stage-1 build (2.1), driver verification (2.2/2.3), and the triple test.
