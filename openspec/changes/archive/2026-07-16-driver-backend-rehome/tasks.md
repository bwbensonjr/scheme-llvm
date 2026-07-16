## 1. Refactor the modular build into an artifact-set builder (D1)

- [x] 1.1 In `src/compile.ss`, split `build-modular-program` into `build-modular-artifacts` that resolves the transitive import closure (incl. `(scheme base)` when prelude-enabled), builds/reuses each unit `.ll`, compiles the program `.ll`, and returns the ordered list of unit `.ll`s + the program `.ll` (writing them; no linking).
- [x] 1.2 Re-express the AOT path as a consumer of that set (`clang` links runtime + units + program → exe), verifying its behavior is byte-identical to the current `build-modular-program`.

## 2. Re-home the jit and bitcode backends (D1)

- [x] 2.1 Generalize `run-jit` to `llvm-as` every unit + the program to `.bc`, `clang -emit-llvm` the runtime, `llvm-link` all into one combined `.bc`, and run via `lli` (load `libgc`).
- [x] 2.2 Generalize the bitcode path (`emit-bitcode`/`build-bitcode-exe`) to assemble/`llvm-link` the unit + program `.ll`s into the program `.bc`, then link `.bc` + runtime → exe.

## 3. Make the dispatch backend-independent (D2)

- [x] 3.1 In `main`, replace the aot-only modular guard with `(or prelude? (pair? (program-imports src)))` selecting the modular path for ALL backends; keep the `compile-file` single-module arm only for `--no-prelude` + no-imports (all backends).
- [x] 3.2 Confirm `--emit-ir`/`emit-ir-filter` is untouched (documented single-module raw-filter exception).

## 4. Verify (behavior preserved)

- [x] 4.1 `demos/run-backends.sh` (3-way aot/jit/bitcode equivalence) stays green across the demo suite.
- [x] 4.2 Add jit + bitcode checks: a prelude-using program and an importing program (via `test/modules/emit-libs.scm`) build and run under both backends and match the aot value.
- [x] 4.3 Full suites green: `run-all-tests.sh` (Chez-free) and `run-dev-tests.sh` (Chez-gated, incl. backend equivalence, module AOT/REPL, self-host fixed point, trust-check). Confirm `bootstrap/*.ll` unchanged (Chez-driver-only change; no regen).

## 5. Docs

- [x] 5.1 Update `README.md` / `docs/PIPELINE.md` backend notes to say all three backends re-home on `(scheme base)` and resolve imports; note `--emit-ir` as the documented single-module raw-filter exception.
