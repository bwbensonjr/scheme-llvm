## 1. Runtime: expose string bytes to a C/C++ host

- [x] 1.1 Add exported `rt_string_bytes(val) → const char*` and `rt_string_len(val) →
  intptr_t` to `src/runtime/runtime.c` (non-static wrappers over `str_bytes`/`str_len`).
- [x] 1.2 Confirm `RT_NO_MAIN` still omits `main`/`scheme_entry` expectations so the runner
  can supply its own `main`.

## 2. Core: prelude-correct in-language compile entry

- [x] 2.1 Add `compile-source-string/prelude` to `src/core.ss`:
  `(compile-forms (with-prelude (read-forms-from-string prelude) (read-forms-from-string user)) no-dump)`.
- [x] 2.2 Verify it reproduces the batch driver's user-wins shadowing on a demo that
  redefines a prelude name.

## 3. Assembly: `--embed-entry` mode

- [x] 3.1 Add `--embed-entry` to `tools/assemble-core.ss` → `build/embed.scm`: the same
  assembled core, ending in `(compile-source-string/prelude *prelude-source* (read-all-stdin))`.
- [x] 3.2 Bake `*prelude-source*` from `src/prelude.scm` as a correctly-escaped string
  literal (`\`, `"`, newlines) that Chez reads back at build time.
- [x] 3.3 Sanity: assemble with `--embed-entry` and confirm `build/embed.scm` is a complete
  program that ends in the value-returning entry expression.

## 4. Build integration

- [x] 4.1 Makefile rule: `build/embed.scm` → `bootstrap/embed.ll` (assemble, then
  `chez … compile.ss --emit-ir` with prelude, as `schemec.ll` is built).
- [x] 4.2 Makefile rule: link `build/scheme-run` from `bootstrap/embed.ll` +
  `runtime.c` (`RT_NO_MAIN`) + `src/run.cpp`, with `-rdynamic` and libgc and the LLVM
  ORC/native flags (as `repl-host`).
- [x] 4.3 Extend the staleness graph: `bootstrap/embed.ll`, the core sources behind it,
  `runtime.c`, and `run.cpp` are prerequisites of `build/scheme-run`.

## 5. Runner: in-process compile + JIT run

- [x] 5.1 Write `src/run.cpp`: `GC_INIT`, init native target, create `LLJIT`, add the
  process-symbol generator (resolve `rt_*` from the linked runtime).
- [x] 5.2 Call the linked-in `scheme_entry()` (embedded compiler; reads stdin) → IR string;
  copy its bytes via `rt_string_bytes`/`rt_string_len` into a `MemoryBuffer`.
- [x] 5.3 `parseIR` → `setDataLayout` → `addIRModule`; `JIT->lookup("scheme_entry")`; call
  it; `rt_write` the result + newline (match the AOT `main`).
- [x] 5.4 Wrap the call in `setjmp`/`rt_trap` isolation so a runtime trap is reported.

## 6. Stage-0 artifact

- [x] 6.1 Generate and commit `bootstrap/embed.ll` (D6); confirm it carries no
  `target datalayout`/`triple` line.

## 7. Verification

- [x] 7.1 `build/scheme-run < demos/fact.scm` prints `120`, with no Chez/`clang`/`lli`/
  subprocess involved (verify via process inspection).
- [x] 7.2 Diff embedded-vs-batch IR on a prelude-using demo (dev→ship fidelity at the IR
  level).
- [x] 7.3 New harness (e.g. `demos/run-embedded.sh`) runs every demo through `scheme-run`
  and compares to the expected values, matching `demos/run-tests.sh`.
- [x] 7.4 Confirm runner output equals AOT output across the demos.
- [x] 7.5 Verify the staleness graph: touch a core source, run `scheme-run`, confirm
  `bootstrap/embed.ll` regenerates and the runner relinks before use.
- [x] 7.6 Wire the new harness into `run-all-tests.sh`; full roll-up is green (existing
  demos/backends/REPL harnesses unaffected).

## 8. Documentation

- [x] 8.1 Update `README.md`: describe `build/scheme-run` (in-process compile-and-run, no
  Chez/`clang`), the `--embed-entry`/`bootstrap/embed.ll` build, and the new harness.
- [x] 8.2 Update the README pipeline/"Backends & process" text to include the in-process
  embedded run path, and note the incremental REPL remains Chez pending
  `repl-embedded-incremental`.
