## 1. Compiler-identity stamp (src/compile.ss)

- [x] 1.1 Define the list of compiler-source files that determine emitted IR, derived from the
      `compile.ss` `(include ...)` block (`match.scm`, `util.scm`, `parse.ss`,
      `passes/{expand,recognize-let,convert-assignments,convert-closures,lower}.ss`, `emit.ss`,
      `core.ss`) plus `compile.ss` itself; add a comment tying the list to that include block.
- [x] 1.2 Add a dependency-free content-hash helper (D2; default FNV-1a/djb2 over bytes, unless
      a Chez digest is cleanly importable) and a `compiler-stamp` that returns the stamp
      S-expression `(emit-artifact-stamp <version> <hex-digest>)` — version a hand-bumpable
      integer, digest over the fixed-order concatenation of the file list (optionally the host
      target header, per the open question). Resolved the open question: the host target header
      IS folded into the digest (it is prepended to every `.ll`, so it affects emitted IR).
- [x] 1.3 Compute the current stamp once per build (not per unit) and thread it into the unit
      loop in `build-modular-artifacts`.

## 2. Record and check the stamp (src/compile.ss)

- [x] 2.1 In `build-modular-artifacts` (`:439-461`), after writing `<base>.ll` and
      `<base>.exports`, write `<base>.stamp` containing the current stamp (write it LAST so a
      torn write fails safe toward rebuild — D3). Used `write` (not `display`) so the hex-digest
      string round-trips as a string, not a symbol.
- [x] 2.2 Extend `artifacts-fresh?` (`:395`) to also require that `<base>.stamp` exists and its
      recorded stamp equals the current stamp; a missing or mismatched stamp ⇒ not fresh.
      Thread the current stamp in as a parameter.
- [x] 2.3 Update the reuse/compile narration (`:449/:460`) to distinguish `[fresh]` reuse from a
      rebuild triggered by a stamp mismatch vs. a source change (`docs/OUTPUT.md`). Rebuild note
      now reads `[N bytes, recompile: missing|source changed|compiler changed]`.

## 3. Remediate and verify

- [x] 3.1 Remove the stale `build/lib/*` artifacts (or confirm the missing-stamp path
      auto-rebuilds them) so the next build regenerates them with the current emitter. Confirmed
      the missing-stamp path auto-rebuilds: first build after the change reported
      `recompile: compiler changed` and regenerated `scheme.base.ll` with `#t`=`i64 257` (×8,
      matching `bootstrap/`); `(char<? #\a #\b)` now returns `#t`, not `#\nul`.
- [x] 3.2 Confirm the previously-failing Chez suites now pass: `RUNNER=aot demos/run-tests.sh`
      (53/0), `demos/run-backends.sh` (aot==jit==bitcode, no `#\nul`-for-`#t`), the module
      vertical-slice AOT suite, and `demos/run-embedded.sh`. Verified: AOT demos 53/0 (was 51/2),
      backends 43/0 (aot=jit=bitcode), embedded 53/0, module vertical-slice (AOT) PASS.
- [x] 3.3 Verify no regression: `./run-all-tests.sh` and the rest of `./run-dev-tests.sh`
      (self-emission, self-hosting fixed point, REPL-vs-batch, anti-stale trust-check) pass.
      Verified: run-all-tests 6/6 suites, run-dev-tests 17/17 suites, all green.
- [x] 3.4 Verify the invalidation itself: with a clean build, touch/edit a compiler source
      (e.g. add a comment to `src/emit.ss`) and confirm the next build recompiles the
      `build/lib` units (stamp mismatch), whereas a no-op re-run reuses them (`[fresh]`).
      Verified: appending a comment to `src/emit.ss` → `recompile: compiler changed`; no-op rerun
      → `[fresh]`; reverting `emit.ss` returned the digest to the identical original
      (`30291CE53F493D04`), confirming the stamp is deterministic and content-based.

## 4. Docs and close-out

- [x] 4.1 Note the compiler-identity dimension of artifact freshness where artifact reuse is
      documented (`docs/MODULES.md` if applicable) and add/adjust the `docs/PERFORMANCE.md` P3
      note if the stamp interacts with the precompiled-prelude item. Updated the MODULES.md
      "Artifacts" bullet (stamp + toolchain-as-cache-key) and the PERFORMANCE.md P3 note (future
      precompiled units must key on the same stamp).
- [x] 4.2 Record in the change that the root cause was cache invalidation (not an emitter/`#t`
      encoding bug); the emitter was already correct. Recorded in design.md "Outcome (verified)".
