## Context

The project targets a pinned **LLVM 22** plus Boehm **libgc**, but every consumer currently hardcodes
the macOS Homebrew layout:

- `Makefile:18-23` — `LLVM := /opt/homebrew/opt/llvm@22`, `GC_INC`/`GC_LIB := /opt/homebrew/...`
- `src/compile.ss:19-20,79` — `gc-inc`/`gc-lib` and `llvm-bin "/opt/homebrew/opt/llvm@22/bin/"`
- `test/repl.ss:25-26` — `gc-inc`/`gc-lib`
- `test/repl-batch-tests.sh:21` — `clang -I/opt/homebrew/include -L/opt/homebrew/lib`

`src/compile.ss` drives the LLVM 22 tools by **absolute path** on purpose (the keg is deliberately
kept off `PATH`) and already fails with a message if the keg is missing. On Ubuntu, LLVM 22 installs
as `/usr/lib/llvm-22` with `llvm-config-22` on `PATH`, and libgc (`libgc-dev`) lands in standard
system include/lib dirs — none of which the hardcoded constants find.

The AOT backend uses the *system* clang and only needs libgc paths; the JIT/bitcode/REPL paths need
the full LLVM 22 install (tools + `llvm-config` flags for the host).

## Goals / Non-Goals

**Goals:**
- Build and run all backends on Ubuntu (apt `llvm-22` + `libgc-dev`) with zero configuration when the
  tools are discoverable.
- Keep existing Homebrew setups working unchanged.
- One resolution mechanism shared by all four consumers; a single override governs everything.
- Clear diagnostic naming the override and the install command for both platforms.

**Non-Goals:**
- Changing the LLVM major pin (stays 22) or supporting a range of versions.
- Windows support; non-LLVM backends.
- Auto-installing anything.

## Decisions

### D1: Resolution order — explicit override → `PATH` discovery → known prefixes
Prefer an explicit env override, then `llvm-config`-based discovery, then a fixed list of known
prefixes (Homebrew keg, `/usr/lib/llvm-22`, `/usr`). Env vars:
- `LLVM_CONFIG` (full path to a `llvm-config`) or `LLVM_PREFIX` (dir whose `bin/` has the tools).
- `GC_PREFIX` (dir with `include/` + `lib/`), with optional finer `GC_INC`/`GC_LIB` already used by
  the Makefile.

*Rationale:* `llvm-config` is the canonical, version-aware way to find LLVM and derive flags; the
keg-off-`PATH` design is preserved because an explicit prefix/`llvm-config` still points there. Known
prefixes cover the two supported platforms without discovery when `PATH` is bare.

*Alternative considered:* require the keg on `PATH` — rejected; contradicts the current deliberate
off-`PATH` design and still wouldn't help Linux.

### D2: `llvm-config` is the single source of the LLVM bin dir and flags
Derive the tool directory from `llvm-config --bindir` and host flags from
`--cxxflags/--ldflags/--libs/--system-libs`, instead of assembling paths from a prefix string. The
Makefile already does this for flags; extend the same idea to locating `lli`/`llvm-as`/`llvm-link`/
`clang` in `compile.ss` (via `--bindir`) rather than the literal `llvm-bin` constant.

### D3: A small shared resolver, not four copies
Add one Scheme helper (in `compile.ss` or a tiny shared module it and `test/repl.ss` load) that
returns resolved `(llvm-bindir, gc-inc, gc-lib)` by reading env then probing. The `Makefile` and
`repl-batch-tests.sh` get an equivalent shell/make snippet (or call a `tools/` helper) so make and
Scheme agree. Keep it minimal — env lookups plus `file-exists?`/`which`-style probes; no config file.

*Alternative considered:* a generated config file committed per-host — rejected as extra state and a
footgun across machines.

### D4: AOT compiler is resolved too — system `clang` if present, else the LLVM 22 `clang`
AOT (and the host-triple probe in `host-target-header`) used a bare `clang` on the assumption a
system compiler is always on `PATH`. That holds on macOS (Apple clang) but **not** on Ubuntu: this
machine has no unversioned `clang` on `PATH`, and the apt `clang` metapackage would pull clang **18**,
not 22. So the resolver also supplies the AOT C compiler: prefer an unversioned `clang` on `PATH`
(Apple clang / a distro default), else fall back to `<llvm-bindir>/clang` (the resolved LLVM 22
clang). This keeps macOS AOT behavior identical while making Linux work, and never silently uses a
mismatched clang. Only JIT/bitcode/REPL still require the *full* LLVM 22 install; AOT needs the
resolved compiler + libgc paths.

*Rationale for the fallback order:* macOS AOT-without-the-keg (Apple clang) must keep working, so a
`PATH` clang wins; where there is none, the LLVM 22 clang is the correct (version-matched) choice.

## Risks / Trade-offs

- **`llvm-config` present but wrong major version** → Probe `llvm-config --version` and reject a
  non-22 major with the same actionable diagnostic (ties into the missing-toolchain requirement).
- **Discovery picks an unexpected `llvm-config` on a multi-LLVM host** → Explicit `LLVM_CONFIG`/
  `LLVM_PREFIX` override always wins (D1); document it.
- **Make/Scheme resolvers drift** → Resolved by making `tools/toolchain.sh` the *single* source of
  truth: the Makefile, the shell test harnesses, and the Scheme resolver (`src/toolchain.ss`) all
  shell out to it, so there is exactly one implementation.
- **Bare `clang` absent / wrong-version on Linux** → Resolve the AOT compiler (D4) instead of
  assuming `clang` on `PATH`; never fall through to a non-22 system clang for the LLVM-tool paths.
- **libgc dylib/so name differs (`libgc.dylib` vs `libgc.so`)** → The JIT `-load` currently names
  `libgc.dylib`; resolve the platform-correct filename from the resolved lib dir.

## Migration Plan

1. Land the resolver + update the four consumers; Homebrew hosts keep working (keg is a known prefix).
2. Update `src/TOOLCHAIN.md`, `README.md`, `run-all-tests.sh` header with the Linux path and override
   vars.
3. Verify on this Ubuntu machine (all backends + REPL + test suite) and re-verify on macOS/Homebrew.
   Rollback is a straightforward revert; no persisted state is introduced.

## Open Questions

- Exact env-var names — `LLVM_PREFIX`/`LLVM_CONFIG`/`GC_PREFIX` proposed; confirm before wiring.
- Whether the shell consumers call a shared `tools/` script or duplicate a few lines of discovery.
