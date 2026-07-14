## Why

The batch compiler reached a byte-identical self-hosting fixed point, but the
interactive REPL's front end is **still Chez**: `chez compile.ss --repl` compiles each
entered form and frames the IR to the C++ ORC/LLJIT host. This is the last place Chez is
required at runtime, and — because the REPL is the primary development loop — it means
interactively-tested code and AOT-compiled code do not provably go through the same
compiler. Path A (in-process embedding) removes the last Chez dependency and makes the
REPL and batch paths share one compiler core, guaranteeing dev→ship fidelity.

## What Changes

- Add a **callable C-ABI entry** to the assembled compiler core: a `--repl-entry`
  variant of `tools/assemble-core.ss` that emits `rt_compile(src) → ir` (a sibling of
  the existing `--filter-main` stdin→stdout entry), so the compiler can be invoked as an
  in-process function rather than a program.
- **Embed the compiled compiler in the REPL host** (`src/repl/host.cpp`) via static
  linking (A-link): `clang compiler.ll runtime.c host.cpp → build/repl-host`. The host
  calls `rt_compile` in-process to turn each entered form's text into IR, then `parseIR`
  → `addIRModule` → `lookup` → call as it does today.
- **Retire Chez from `--repl`.** The `--repl` driver in `src/compile.ss` stops shelling
  out to a Chez-hosted compile step and its stdin frame protocol; the host reads source
  text and drives the embedded compiler itself. Batch/AOT/JIT/bitcode paths are
  unchanged.
- The embedded compiler's mutable state (gensym counter, rename environment, interned
  symbols) **persists across forms** for free, which is what incremental REPL
  compilation needs.
- Extend the build so the host is rebuilt when the **compiler** source changes, not just
  the runtime/host sources (the compiler is now linked into the host).
- Keep the **text-IR seam**: the embedded compiler still returns IR *text* that the host
  parses. Embedding changes process topology, not the inspectable boundary.
- Do **not** hardcode a single flat namespace between compiler and user globals — leave
  room for the module-scoped namespaces of the follow-on modules work.

## Capabilities

### New Capabilities
- `compiler-embedding`: The compiler core assembled as an in-process, C-ABI-callable
  unit (`rt_compile`) embedded in the persistent JIT host, driving per-form compilation
  in one process with no Chez and no per-form subprocess, with persistent compiler state
  across forms and dev→ship fidelity (the REPL and batch paths share one compiler core).

### Modified Capabilities
- `interactive-repl`: the "persistent JIT host stays in sync with its sources"
  requirement extends to cover the now-embedded compiler — the host SHALL be rebuilt when
  the compiler source changes, not only when the runtime/host sources change. All
  observable REPL behavior (persistent environment, redefinition, incremental per-form
  modules, trap isolation, interactive printing) is preserved.

## Impact

- **Code:** `tools/assemble-core.ss` (new `--repl-entry` variant), `src/repl/host.cpp`
  (embedded compiler call path, source-text input instead of IR frames), `src/compile.ss`
  (`--repl` driver: drop the Chez compile step and frame protocol), `Makefile` (link the
  compiler into `build/repl-host`; extend staleness graph to the compiler sources).
- **Dependencies:** removes the Chez runtime dependency for `--repl`; still requires Chez
  (or `schemec`) at host-build time to produce `compiler.ll`. Reopens the stage-0
  artifact policy question (regenerate vs. commit `compiler.ll`).
- **Tests:** REPL end-to-end and REPL-vs-batch equivalence harnesses must pass unchanged
  against the embedded host; a Chez-free `--repl` becomes the verification target.
- **Runtime:** the embedded compiler allocates in the same Boehm-GC heap it compiles
  into; single `GC_INIT()` unchanged, heap-pressure profile shifts within the session.
