## Why

The build hardcodes macOS Homebrew paths (`/opt/homebrew/opt/llvm@22`, `/opt/homebrew/include`,
`/opt/homebrew/lib`) in the `Makefile`, `src/compile.ss`, and the test scripts. On any host where
LLVM 22 and libgc live elsewhere — notably Ubuntu/Debian with the `llvm-22`/`libgc-dev` apt
packages — the JIT, bitcode, and REPL backends fail to build or run. The compiler should locate its
LLVM 22 + libgc toolchain on the host it is invoked on, not assume Homebrew.

## What Changes

- Introduce a single, documented way to point the build at an LLVM 22 install and a libgc install,
  replacing the hardcoded Homebrew constants. Resolution order: explicit environment variables
  (e.g. `LLVM_PREFIX` / `LLVM_CONFIG`, `GC_PREFIX`), then auto-discovery (`llvm-config-22` /
  `llvm-config` on `PATH`, common package prefixes), with the Homebrew keg remaining a supported
  location — no longer the *only* one.
- Update the four consumers to use the resolved paths:
  - `Makefile` (REPL host `LLVM`, `GC_INC`, `GC_LIB`),
  - `src/compile.ss` (`gc-inc`, `gc-lib`, `llvm-bin` for `lli`/`llvm-as`/`llvm-link`/`clang`),
  - `test/repl.ss` (`gc-inc`, `gc-lib`),
  - `test/repl-batch-tests.sh` (clang include/lib flags).
- Fail with a clear, actionable message when LLVM 22 or libgc cannot be found, naming both the
  env-var override and the expected package (`brew install llvm@22` **or**
  `apt-get install llvm-22 libgc-dev`).
- Update docs (`src/TOOLCHAIN.md`, `README.md`, `run-all-tests.sh` header) to describe host-agnostic
  discovery and the Linux path, dropping the Homebrew-only assumption.

Non-goals: changing the pinned LLVM major version (still 22), supporting non-LLVM backends, or
Windows support.

## Capabilities

### New Capabilities
- `toolchain-configuration`: How the build and compiler locate their external LLVM 22 and libgc
  toolchain across hosts — override via environment, auto-discovery, the set of supported install
  layouts (Homebrew keg, Linux distro packages, custom prefix), and the required diagnostic when the
  toolchain is missing.

### Modified Capabilities
<!-- none: no existing spec's requirements change; consumers are updated to read resolved paths -->

## Impact

- **Code**: `Makefile`, `src/compile.ss`, `test/repl.ss`, `test/repl-batch-tests.sh`. Likely a small
  shared discovery helper (e.g. a Scheme procedure in `compile.ss`/a shared module and a make/shell
  snippet) so the four consumers agree.
- **Docs**: `src/TOOLCHAIN.md`, `README.md`, `run-all-tests.sh`.
- **Dependencies**: still LLVM 22 + libgc; adds Linux (apt) as a first-class supported install.
- **Compatibility**: existing Homebrew setups keep working with no configuration.
