## 1. Convention and shared helpers

- [x] 1.1 Write `docs/OUTPUT.md`: the message format (`<verb> <input> -> <output>  [metrics]`), the stderr/stdout stream discipline, and the three verbosity levels (`quiet`/`default`/`verbose`) with the `EMIT_VERBOSITY` control
- [x] 1.2 Add `tools/log.sh` with `say`, `vsay`, and `bytes` helpers that emit to stderr and honor `EMIT_VERBOSITY`; source it from the scripts that need it
- [x] 1.3 Link `docs/OUTPUT.md` from `CLAUDE.md` and `README.md`

## 2. Retrofit build and regen tooling

- [x] 2.1 `Makefile`: replace bare `built $@` with action + `input -> output` messages for `all`, `scheme-run`, `repl-host`, `schemec`; report each linked binary's byte size
- [x] 2.2 `Makefile` `regen` target: announce the phase and report total elapsed time
- [x] 2.3 `tools/regen.sh`: keep numbered step banners; add per-step timing and the fixed-point iteration count to convergence (byte sizes already reported — route them through `bytes`)
- [x] 2.4 `bin/scheme-compile`: narrate the emit and link steps to stderr; report emitted-IR size and final executable size; confirm stdout/data path is untouched

## 3. Retrofit test runners

- [x] 3.1 `run-all-tests.sh`: add per-suite timing and a total elapsed time to the existing PASS/FAIL summary
- [x] 3.2 `run-dev-tests.sh`: same per-suite timing and total; keep the Chez-skip message

## 4. Compiler driver verbosity

- [x] 4.1 Thread `EMIT_VERBOSITY` into the driver (`src/compile.ss`); gate stage announcements on it and add conventional `-q`/`-v` front-end flags where argv is parsed. `src/core.ss` needs no change — it already threads stage names through the injected `dump` side-channel, keeping the pure core port-free
- [x] 4.2 Make each frontend pass announce its stage name (`collect-toplevel`, `expand`, `parse+rename`, `recognize-let`, `convert-assignments`, `convert-closures`, `lower`) at `verbose` via `announce-stage`; keep `default` concise
- [x] 4.3 Align the embedded runner's status text (`src/run.cpp`) with the convention (prefixed `scheme-run:`) and confirm it routes to stderr

## 5. Verify stream discipline and acceptance

- [x] 5.1 Confirm all narration is on stderr: `scheme-run --emit` and `schemec` stdout is byte-identical with `EMIT_VERBOSITY` set to each level (verified: 1 distinct hash across unset/quiet/default/verbose for both)
- [x] 5.2 Run `run-all-tests.sh` (Chez-free) — all suites pass with the new output (2 suites, 0 failed, 29s)
- [x] 5.3 Run `run-dev-tests.sh` (Chez-gated) — self-emission-equivalence and the anti-stale trust-check pass, proving committed IR is byte-for-byte unchanged (13 suites, 0 failed, 289s)
- [x] 5.4 Spot-check each tool at `quiet`/`default`/`verbose` and confirm output matches `docs/OUTPUT.md`
