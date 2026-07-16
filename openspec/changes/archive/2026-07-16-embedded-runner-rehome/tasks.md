## 1. Assemble (scheme base) in the embedded core (D1)

- [x] 1.1 Add a core routine that builds the `(scheme base)` `define-library` form from the baked-in `*prelude-source*` — splitting the ~89 procedure defines (exported) from the 9 derived-form macros (`and`/`or`/`when`/`unless`/`let*`/`cond`/`case`/`guard`/`%guard-clauses`, body-only, not exported), mirroring `tools/gen-scheme-base.ss` but in the portable core with no filesystem access.
- [x] 1.2 Compile that library form as a unit to obtain its IR + export table, reusing the existing `compile-unit`/`compile-library` machinery (host-agnostic IR, no target header).
- [x] 1.3 Extract the derived-form macro set from the baked-in prelude source (filter `define-syntax`) so it can be merged into a program's `macro-env`.

## 2. Re-home the embedded batch entry (D1/D2)

- [x] 2.1 Add a core function (`compile-source-rehomed`) that compiles the stdin program through `compile-program-with-imports` with `(scheme base)` auto-imported (its table from 1.2) and the derived-form macros merged into its `macro-env`; keep the lone-`define-library` unit path as-is.
- [x] 2.2 Return the two emitted modules separated by a fixed boundary marker: `(scheme base)` IR, marker, then program IR. Ensure the program references `scheme.base:*` as externals (byte-identical to the Chez driver's `prog.ll`) and user-wins shadowing holds (own defines beat imports).
- [x] 2.3 Rewrite `src/entry-embed.scm` to call `compile-source-rehomed` (prelude on) or `compile-source-string` (`--no-prelude`); keep the whole path filesystem-free and header-free.

## 3. Host split + --no-prelude parity (D2/D3)

- [x] 3.1 Add a nullary runtime primitive (`%no-prelude?` -> `rt_no_prelude_p`) in `src/runtime/runtime.c` reading `EMIT_NO_PRELUDE`; register it in `src/parse.ss` `*prims*`, `src/emit.ss` `prim-table`, and the `emit.ss` declares block.
- [x] 3.2 In `src/entry-embed.scm`, branch on `(%no-prelude?)`: when set, emit only the program IR (no `(scheme base)`, no marker, prelude names unbound); otherwise re-home.
- [x] 3.3 In `src/run.cpp`: parse `--no-prelude` and `setenv("EMIT_NO_PRELUDE", ...)` before calling `scheme_entry`; split the returned IR on the boundary marker and add each module to the JIT (`(scheme base)` first, then the program). `--emit` writes the whole returned string unchanged.
- [x] 3.4 In `bin/scheme-compile`: parse `--no-prelude` and forward it to `scheme-run --emit`; split the emitted IR on the marker into separate `.ll` files and `clang`-link all of them with the runtime.

## 4. Regenerate committed IR (D4)

- [x] 4.1 Run `make regen` to rebuild `bootstrap/embed.ll` from the updated core, Chez-free, to a byte-identical fixed point; relink `build/scheme-run` and rebuild via `bin/scheme-compile`.
- [x] 4.2 Confirm `bootstrap/schemec.ll` (prelude-free filter) and `bootstrap/embed-repl.ll` (REPL) are unchanged except for any shared-core effects, and that regen is idempotent.

## 5. Tests

- [x] 5.1 Add a test asserting `scheme-run --emit` and the Chez driver produce byte-identical program IR for a prelude-using program (structural runner↔driver parity).
- [x] 5.2 Add a test asserting `scheme-run` and `bin/scheme-compile` outputs match the AOT path values for prelude-using programs (value parity), and that `(scheme base)` appears exactly once in the emitted module.
- [x] 5.3 Add a `--no-prelude` runner test: a prelude-name reference is an unbound-variable error, matching the Chez driver's `--no-prelude`.
- [x] 5.4 Re-run the demo suite and confirm all demo values (hashes) are unchanged; wire the new tests into `run-all-tests.sh` / `run-dev-tests.sh`.

## 6. Docs

- [x] 6.1 Update `README.md` and any `docs` references that describe `scheme-run` / `scheme-compile` as prepending the prelude, to reflect the `(scheme base)` re-home.
- [x] 6.2 Update the `module-system` spec placeholder text (via the delta) so it no longer says the embedded runner "provides the same prelude by prepend pending its follow-on re-home".
