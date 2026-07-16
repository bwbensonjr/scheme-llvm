## 1. Compiler-identity stamp (src/compile.ss)

- [ ] 1.1 Define the list of compiler-source files that determine emitted IR, derived from the
      `compile.ss` `(include ...)` block (`match.scm`, `util.scm`, `parse.ss`,
      `passes/{expand,recognize-let,convert-assignments,convert-closures,lower}.ss`, `emit.ss`,
      `core.ss`) plus `compile.ss` itself; add a comment tying the list to that include block.
- [ ] 1.2 Add a dependency-free content-hash helper (D2; default FNV-1a/djb2 over bytes, unless
      a Chez digest is cleanly importable) and a `compiler-stamp` that returns the stamp
      S-expression `(emit-artifact-stamp <version> <hex-digest>)` — version a hand-bumpable
      integer, digest over the fixed-order concatenation of the file list (optionally the host
      target header, per the open question).
- [ ] 1.3 Compute the current stamp once per build (not per unit) and thread it into the unit
      loop in `build-modular-artifacts`.

## 2. Record and check the stamp (src/compile.ss)

- [ ] 2.1 In `build-modular-artifacts` (`:439-461`), after writing `<base>.ll` and
      `<base>.exports`, write `<base>.stamp` containing the current stamp (write it LAST so a
      torn write fails safe toward rebuild — D3).
- [ ] 2.2 Extend `artifacts-fresh?` (`:395`) to also require that `<base>.stamp` exists and its
      recorded stamp equals the current stamp; a missing or mismatched stamp ⇒ not fresh.
      Thread the current stamp in as a parameter.
- [ ] 2.3 Update the reuse/compile narration (`:449/:460`) to distinguish `[fresh]` reuse from a
      rebuild triggered by a stamp mismatch vs. a source change (`docs/OUTPUT.md`).

## 3. Remediate and verify

- [ ] 3.1 Remove the stale `build/lib/*` artifacts (or confirm the missing-stamp path
      auto-rebuilds them) so the next build regenerates them with the current emitter.
- [ ] 3.2 Confirm the previously-failing Chez suites now pass: `RUNNER=aot demos/run-tests.sh`
      (53/0), `demos/run-backends.sh` (aot==jit==bitcode, no `#\nul`-for-`#t`), the module
      vertical-slice AOT suite, and `demos/run-embedded.sh`.
- [ ] 3.3 Verify no regression: `./run-all-tests.sh` and the rest of `./run-dev-tests.sh`
      (self-emission, self-hosting fixed point, REPL-vs-batch, anti-stale trust-check) pass.
- [ ] 3.4 Verify the invalidation itself: with a clean build, touch/edit a compiler source
      (e.g. add a comment to `src/emit.ss`) and confirm the next build recompiles the
      `build/lib` units (stamp mismatch), whereas a no-op re-run reuses them (`[fresh]`).

## 4. Docs and close-out

- [ ] 4.1 Note the compiler-identity dimension of artifact freshness where artifact reuse is
      documented (`docs/MODULES.md` if applicable) and add/adjust the `docs/PERFORMANCE.md` P3
      note if the stamp interacts with the precompiled-prelude item.
- [ ] 4.2 Record in the change that the root cause was cache invalidation (not an emitter/`#t`
      encoding bug); the emitter was already correct.
