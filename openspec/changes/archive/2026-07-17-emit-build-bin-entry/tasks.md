## 1. Manifest parsers ignore program entries (module-system)

- [x] 1.1 In `src/repl-core.ss`, guard `repl-manifest-paths` (mode 5) and `repl-manifest-user-paths` (mode 9) to process only entries whose head keyword is `library`, so a `(program …)` entry is never mis-read as a library.
- [x] 1.2 In `src/compile.ss`, guard `read-manifest` the same way (the Chez driver's reference parser also ignores program entries), keeping the two parsers consistent.
- [x] 1.3 Verify library resolution is unchanged when a manifest mixes library and program entries (existing `test/modules-*` suites still green; a mixed manifest resolves `(import (mylib))` exactly as before).

## 2. Chez-free program-entry resolver (embedded compiler + host)

- [x] 2.1 In `src/repl-core.ss`, add `repl-manifest-program`: input is the program NAME on the first line followed by the manifest text; find the `(program NAME (source S) [(output O)])` entry and return `source` and `output` (newline-joined; empty output line when no `(output O)`). Handle NAME omitted (select the sole program entry, else an error naming available entries) and unknown NAME (error naming the missing program).
- [x] 2.2 Wire a new dispatch mode (next free integer, 10) in `repl-dispatch` → `repl-manifest-program`, and document it in the mode-list comment.
- [x] 2.3 In `src/run.cpp`, add a `--resolve-program NAME` flag: read the manifest (`--manifest` > `EMIT_MANIFEST` > `emit-libs.scm`), set mode 10 with `"NAME\n" + manifest-text`, call `scheme_entry()`, print `scm_str(...)` to stdout, and return without JIT/run. Surface resolver errors on stderr with a non-zero exit.
- [x] 2.4 `make regen` (Chez-free) to rebuild the committed embedded IR from the changed `repl-core.ss`, then relink; confirm the fixed point is byte-stable (`git diff bootstrap/` empty after a second regen).

## 3. `emit build` wrapper

- [x] 3.1 Add `bin/emit` (bash, mirroring `bin/scheme-compile`: source `tools/llvm-env.sh`, ensure `scheme-run` exists). Dispatch the first token; any verb other than `build` prints a usage error listing only `build`.
- [x] 3.2 Implement `emit build [NAME] [--manifest FILE]`: resolve via `scheme-run --resolve-program`; default the output from `NAME` (under `build/`) when the resolver returns none; then `EMIT_MANIFEST="$MAN" bin/scheme-compile "$source" -o "$output"`.
- [x] 3.3 Add narration per `docs/OUTPUT.md`: announce program name, resolved source, delivered exe path + size on stderr, honoring `EMIT_VERBOSITY`.
- [x] 3.4 Confirm nothing is renamed/removed — `bin/scheme-compile`, `scheme-run`, `repl-host` behave exactly as before.

## 4. Manifest examples

- [x] 4.1 Add a `(program …)` example entry to `test/modules/emit-libs.scm` pointing at an existing runnable program under `test/modules/` (e.g. `prog-mylib.scm`).

## 5. Tests

- [x] 5.1 Test that `scheme-run --resolve-program NAME` prints the resolved source/output for a program entry (and errors for unknown/ambiguous NAME) — the Chez-free resolver.
- [x] 5.2 Test that `emit build NAME` produces a standalone executable from a program entry importing a user library, and running it yields the expected value.
- [x] 5.3 Parity test: `emit build NAME` and `bin/scheme-compile` on the same resolved source + manifest produce executables that run to the identical value.
- [x] 5.4 Test the omission/error cases: unknown NAME; omitted NAME with zero and with multiple program entries; a mixed manifest still resolves library imports.
- [x] 5.5 Default-output test: a program entry with no `(output O)` builds to the `NAME`-derived default path.
- [x] 5.6 Run the existing module suites green (`test/modules-tests.sh`, `test/modules-run-tests.sh`, `test/modules-repl-tests.sh`) plus the regen trust-check.

## 6. Docs

- [x] 6.1 Document the `(program …)` manifest entry, `scheme-run --resolve-program`, and `emit build` in `docs/MODULES.md`.
- [x] 6.2 Update `openspec/explorations/packaging-and-emit-cli.md`: record slice #2's status — `emit build` introduced additively (build verb only), Chez-free door (no tree-shaking yet), with CLI-naming/back-compat and Chez-free tree-shaking still deferred.
