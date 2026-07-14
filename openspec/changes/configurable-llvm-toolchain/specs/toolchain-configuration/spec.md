## ADDED Requirements

### Requirement: LLVM 22 toolchain location is host-agnostic

The build and compiler SHALL locate the LLVM 22 tools (`clang`/`clang++`, `llvm-config`,
`lli`, `llvm-as`, `llvm-link`) without assuming any single install layout. Resolution SHALL
follow this order:

1. an explicit override, when set: a `LLVM_CONFIG` path, or an `LLVM_PREFIX` directory whose
   `bin/` holds the tools;
2. auto-discovery on `PATH`, trying versioned names first (`llvm-config-22`) then `llvm-config`;
3. known package prefixes, including the Homebrew keg (`/opt/homebrew/opt/llvm@22`) and the
   Linux distro layout (e.g. `/usr/lib/llvm-22`, `/usr/bin`).

A discovered `llvm-config` SHALL be the source of the compiler/linker flags (`--cxxflags`,
`--ldflags`, `--libs`, `--system-libs`) rather than hardcoded paths. The Homebrew keg SHALL
remain a supported location but SHALL NOT be the only one.

#### Scenario: Homebrew keg (macOS) still works unconfigured

- **WHEN** the build runs on a macOS host with `llvm@22` installed via Homebrew and no toolchain
  environment variables set
- **THEN** the LLVM 22 tools are resolved from the Homebrew keg and the JIT, bitcode, and REPL
  backends build and run exactly as before this change

#### Scenario: Linux apt packages are discovered

- **WHEN** the build runs on an Ubuntu/Debian host with the `llvm-22` package installed and no
  toolchain environment variables set
- **THEN** `llvm-config-22` (or the distro `llvm-config`) is discovered on `PATH`/known prefixes
  and used to locate the tools and derive build flags, and the backends build and run

#### Scenario: Explicit override wins

- **WHEN** `LLVM_CONFIG` (or `LLVM_PREFIX`) is set to a specific LLVM 22 install
- **THEN** that install is used in preference to any auto-discovered one

### Requirement: libgc location is host-agnostic

The build and compiler SHALL locate the Boehm libgc headers (`gc/gc.h`) and library (`libgc`)
without assuming `/opt/homebrew`. Resolution SHALL honor an explicit override (a `GC_PREFIX`
directory, or separate include/lib overrides) and otherwise fall back to standard system
locations plus the Homebrew prefix. The resolved include and lib directories SHALL be used
consistently by every consumer that references libgc (the AOT link, the JIT `-load`, the REPL
host link, and the batch REPL tests).

#### Scenario: System libgc on Linux

- **WHEN** the build runs on a host where `libgc-dev` is installed in standard system paths and
  no libgc environment variables are set
- **THEN** the compiler compiles and links against libgc from the system paths without any
  `/opt/homebrew` flags

#### Scenario: Custom libgc prefix

- **WHEN** `GC_PREFIX` is set to a non-standard libgc install
- **THEN** that prefix's `include` and `lib` directories are used by all libgc consumers

### Requirement: All toolchain consumers share one resolution

The `Makefile` (REPL host), `src/compile.ss` (AOT/JIT/bitcode driver), `test/repl.ss`, and
`test/repl-batch-tests.sh` SHALL obtain their LLVM and libgc locations from the same resolution
logic, so that a single override or discovery result governs every backend. No consumer SHALL
retain a hardcoded `/opt/homebrew/...` path as its only source.

#### Scenario: One override governs every backend

- **WHEN** a user sets the toolchain override environment variables once and then builds the REPL
  host, compiles a program through each of the AOT/JIT/bitcode backends, and runs the REPL tests
- **THEN** every one of those consumers uses the overridden LLVM 22 and libgc locations

### Requirement: Missing toolchain fails with an actionable diagnostic

When LLVM 22 or libgc cannot be resolved, the build/compiler SHALL fail with a clear message that
names what was not found, the environment-variable override that would fix it, and the expected
install command for both supported platforms (`brew install llvm@22` / `brew install bdw-gc` and
`apt-get install llvm-22 libgc-dev`).

#### Scenario: LLVM 22 not found

- **WHEN** a JIT/bitcode/REPL build is attempted on a host with no discoverable LLVM 22
- **THEN** the process exits with a message stating LLVM 22 was not found, how to point at it via
  the override variable, and the install command for macOS and Linux — rather than a raw
  file-not-found or linker error
