# Toolchain (core-lambda-slice)

| tool | pinned (LLVM.md) | note |
|------|------------------|------|
| Chez Scheme | host | invoked as `chez` |
| C compiler (AOT + host-triple probe) | 22.x preferred | resolved `cc`: a system `clang` if present, else the LLVM 22 `clang` |
| LLVM 22 tools (JIT/bitcode/REPL) | 22.x | `lli`, `llvm-as`, `llvm-link`, `clang`, `llvm-config` |
| libgc (Boehm) | any | headers `gc/gc.h`; shared `libgc.so`/`.dylib` |
| C++ stdlib (REPL host) | — | libc++ on macOS; `libstdc++-dev` on Linux |
| llc | — | not needed; `clang foo.ll` compiles IR directly |

## Locating the toolchain (host-agnostic)

Nothing is hardcoded to a Homebrew keg. `tools/toolchain.sh` is the single source of
truth that discovers LLVM 22 and libgc on the host; the Makefile, the Scheme driver
(via `src/toolchain.ss`), and the shell test harnesses all defer to it, so one
override/discovery result governs every backend.

Resolution order — **environment override → `PATH` → known prefixes**:

| concern | env override | discovery |
|---------|--------------|-----------|
| LLVM 22 | `LLVM_CONFIG` (path to `llvm-config`) or `LLVM_PREFIX` (its `bin/` holds the tools) | `llvm-config-22`/`llvm-config` on `PATH`; then Homebrew keg `/opt/homebrew/opt/llvm@22`, `/usr/lib/llvm-22`, `/usr` |
| libgc | `GC_PREFIX` (has `include/`+`lib/`), or `GC_INC`/`GC_LIB` | Homebrew `/opt/homebrew`; then the Linux system paths (header on the default include path, shared object via `ldconfig`) |

`tools/toolchain.sh check` prints exactly what resolved. A discovered `llvm-config` must
report major version 22, and its `--bindir` supplies the tool directory (the unversioned
tool names `lli`/`llvm-as`/`llvm-link`/`clang` live there on both platforms). The JIT
loads libgc into `lli` via `-load=<resolved libgc shared object>`. If LLVM 22 or libgc
cannot be found, the tools fail with a message naming the override variable and the
install command for both platforms (`brew install llvm@22 bdw-gc` /
`apt-get install llvm-22 llvm-22-dev clang-22 libgc-dev`).

### AOT compiler

AOT and the host-triple probe use the resolved `cc`: an unversioned `clang` on `PATH`
(Apple clang on macOS, a distro default on Linux) when present, else `<llvm-bindir>/clang`
(the version-matched LLVM 22 clang). This is why AOT works on a Linux host that has no
unversioned `clang` on `PATH` — and never silently falls back to a mismatched system clang.

## Build / run a program (three backends)

    # AOT (default): native executable
    chez --libdirs src --script src/compile.ss <program>.scm -o <out>

    # Bitcode: writes <out>.bc (inspectable/opt-able) + a native exe from it
    chez --libdirs src --script src/compile.ss <program>.scm -o <out> --backend bitcode

    # JIT: llvm-link the runtime in, run in-process via lli (prints the value)
    chez --libdirs src --script src/compile.ss <program>.scm -o <out> --backend jit

Under the hood the AOT link is (paths from the resolver):

    <cc> -I<gc-inc> -L<gc-lib> src/runtime/runtime.c <program>.ll -lgc -o <program>

The 3-way equivalence harness (`demos/run-backends.sh`) runs every demo through all
three backends and asserts identical results.

## Interactive REPL: the persistent ORC/LLJIT host

The interactive REPL (change `interactive-repl`) executes entered forms in a long-lived
process built on **LLVM 22 ORC v2 / LLJIT** (`src/repl/host.cpp`). It requires the
LLVM 22 **development** install (headers + `llvm-config`, e.g. `llvm-22-dev` on Ubuntu or
the `llvm@22` keg on macOS) plus a C++ standard library — libc++ on macOS, `libstdc++-dev`
on Linux (matching the clang's default GCC install; on Ubuntu 24.04 that is
`libstdc++-14-dev`):

    make build/repl-host              # dependency-driven; rebuilds when sources change

The Makefile derives `clang++`, `llvm-config`, and the libgc paths from `tools/toolchain.sh`.

The top-level `Makefile` owns the recipe (per-object rules for `runtime-host.o` and
`host.o`, each also depending on the `Makefile`), so the host is rebuilt whenever
`src/runtime/runtime.c`, `src/repl/host.cpp`, or the recipe changes — a stale host would
otherwise silently lack any `rt_*` added since it was last built, breaking the prelude.
`src/repl/build-host.sh` remains as a thin wrapper over `make build/repl-host`. Staleness
is by mtime, so a `git checkout`/`clone` that sets source mtimes behind an existing binary
may not trigger a rebuild; recover with `touch` on the source or `make clean`.

The build:

- compiles the C runtime (`src/runtime/runtime.c`) with `-DRT_NO_MAIN` so its standalone
  `main` is omitted (the host supplies its own);
- compiles `host.cpp` against `$(llvm-config --cxxflags)`;
- links with `$(llvm-config --ldflags --libs orcjit native --system-libs)` plus `-lgc`,
  and **`-rdynamic`** so the JIT resolves `rt_*` / GC symbols from the host process via
  `DynamicLibrarySearchGenerator::GetForCurrentProcess`.

The host reads a simple wire protocol on stdin — `"<entry-symbol> <byte-count>\n"` then
that many bytes of IR — adds each form's module to the running JIT, looks up its
`@__repl_N` thunk, calls it, and prints the value with `rt_write` (or `!<error>` on a
compile/JIT failure or a runtime trap). Runtime traps (e.g. arity errors) `longjmp` back
to the host loop via the `rt_trap` hook in `runtime.c`, so the session survives; when
`rt_trap` is null (the standalone executables) a trap still `exit(1)`s as before.

Drive it with the batch frame generator (a stand-in for the Group 5 interactive driver):

    chez --libdirs src --script test/repl-frames.ss <session>.scm | build/repl-host

End-to-end host tests: `test/repl-host-tests.sh`.
