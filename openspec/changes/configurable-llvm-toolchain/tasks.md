## 1. Toolchain resolver

- [x] 1.1 Decide/confirm env-var names (`LLVM_PREFIX`/`LLVM_CONFIG`, `GC_PREFIX`, keep `GC_INC`/`GC_LIB`) and record them in `src/TOOLCHAIN.md`.
- [x] 1.2 Add a shared Scheme resolver (in `src/compile.ss` or a small module it loads) that returns `(llvm-bindir gc-inc gc-lib gc-libfile)`: read env override → probe `llvm-config-22`/`llvm-config` on `PATH` → known prefixes (Homebrew keg, `/usr/lib/llvm-22`, `/usr`).
- [x] 1.3 Derive the LLVM bin dir from `llvm-config --bindir` and verify `llvm-config --version` is major 22; reject otherwise.
- [x] 1.4 Resolve libgc include/lib from `GC_PREFIX`/system paths/Homebrew, and pick the platform library filename (`libgc.so` vs `libgc.dylib`) for the JIT `-load`.
- [x] 1.5 Emit an actionable error (names the missing tool, the override var, and both install commands) when LLVM 22 or libgc is not found.

## 2. Wire consumers to the resolver

- [x] 2.1 `src/compile.ss`: replace hardcoded `gc-inc`/`gc-lib` (lines 19-20) and `llvm-bin` (line 79) with resolver results; keep AOT on system clang using resolved libgc paths.
- [x] 2.2 `test/repl.ss`: replace hardcoded `gc-inc`/`gc-lib` (lines 25-26) with the resolver.
- [x] 2.3 `Makefile`: replace `LLVM`/`GC_INC`/`GC_LIB` (lines 18-23) with values from env override or `llvm-config`-based discovery (a make/shell snippet or a `tools/` helper), keeping `--cxxflags/--ldflags/--libs` driven by the resolved `llvm-config`.
- [x] 2.4 `test/repl-batch-tests.sh`: replace the hardcoded `-I/opt/homebrew/include -L/opt/homebrew/lib` (line 21) with resolved libgc flags.
- [x] 2.5 Ensure make/shell and Scheme resolvers agree (share a `tools/` script or keep the logic identical and minimal).

## 3. Docs

- [x] 3.1 Update `src/TOOLCHAIN.md`: host-agnostic discovery, override vars, and the Linux (`apt-get install llvm-22 libgc-dev`) path alongside Homebrew.
- [x] 3.2 Update `README.md` requirements section (currently `brew`-only) with the Linux install and override note.
- [x] 3.3 Update the `run-all-tests.sh` header comment (drops the `/opt/homebrew/opt/llvm@22` assumption).

## 4. Verification

- [x] 4.1 On this Ubuntu host (apt `llvm-22` + `libgc-dev`, no env overrides): build the REPL host, compile a demo through AOT, JIT, and bitcode, and run `test/repl-batch-tests.sh` — all succeed.
- [x] 4.2 Run the backend equivalence harness (`demos/run-backends.sh`) and `run-all-tests.sh` on Ubuntu; confirm identical cross-backend results.
- [x] 4.3 Confirm an explicit `LLVM_CONFIG`/`LLVM_PREFIX` + `GC_PREFIX` override is honored over discovery.
- [x] 4.4 Confirm the missing-LLVM diagnostic fires (e.g. temporarily hide `llvm-config`) with the expected message.
- [ ] 4.5 Re-verify no regression on a macOS/Homebrew host (keg discovered, unconfigured) — or document that it needs checking there if unavailable.
  - Not verifiable in this Linux dev environment. The resolver preserves macOS behavior by design: the Homebrew keg (`/opt/homebrew/opt/llvm@22`) is a known prefix, `/opt/homebrew/{include,lib}` is the first libgc probe, `libgc.dylib` is selected over `.so`, and AOT prefers the system (Apple) `clang` on `PATH`. **Still needs a real run of `tools/toolchain.sh check` + `./run-all-tests.sh` on a Homebrew Mac before this box is checked.**
