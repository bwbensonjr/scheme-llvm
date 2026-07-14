## Why

The batch compiler reached a byte-identical self-hosting fixed point, but every way of
*running* Scheme still shells out: AOT/JIT/bitcode invoke `clang`/`lli`, and the REPL runs
a Chez front end that frames IR to the executor. Path A (in-process embedding) is the end
state — the compiled compiler is called as a library and its IR is JIT-run in the same
process — but doing it for the interactive REPL requires porting the REPL's *stateful,
incremental* orchestration (persistent env, per-form modules, compile-error rollback) into
compiled Scheme, which is large and partly gated on the unfinished `error`/`guard`
downgrade.

This change proves the **embedding mechanism** on the simpler **batch** path first: a
single in-process compile-and-run of a whole program — no Chez, no `clang`, no subprocess.
It establishes the C-ABI shim, the linked-in compiler, and the JIT-the-returned-IR loop
that the follow-on incremental REPL change (`repl-embedded-incremental`) then reuses.

## What Changes

- Add an **`--embed-entry`** mode to `tools/assemble-core.ss` that assembles the core into
  a program whose C-callable `scheme_entry` reads source text and **returns the emitted IR
  as a Scheme string** (rather than the `--filter-main` stdin→stdout `display`), with the
  prelude baked in so compilation is prelude-correct and fully in-language.
- Add a core entry `compile-source-string/prelude` (prelude text + user text →
  IR text via the existing `with-prelude`), so the embedded compiler reproduces the batch
  driver's user-wins shadowing without any file I/O.
- Add exported runtime accessors `rt_string_bytes` / `rt_string_len` so a C/C++ host can
  read the bytes of the IR string the embedded compiler returns.
- Add an in-process runner `build/scheme-run` (`src/run.cpp`): a single binary that links
  the embedded compiler (`embed.ll`) + the runtime + a C++ ORC/LLJIT host. It calls the
  embedded compiler to get IR text, `parseIR` → `addIRModule`, looks up the program's
  `scheme_entry`, calls it, and prints the value — **no Chez, no `clang`, no subprocess**.
- Build integration: a Makefile rule produces `embed.ll` from the core (via Chez today),
  links `build/scheme-run`, and rebuilds it when the runtime/host/compiler sources change.
- **Check in the stage-0 `embed.ll`** at a tracked path (`bootstrap/embed.ll`): the core
  emits host-agnostic IR (no target header), so the committed artifact is cross-platform
  and a Chez-free checkout can build `scheme-run` from it.
- Keep the **text-IR seam**: the embedded compiler returns IR *text* the host parses.
- Batch/AOT/JIT/bitcode and the existing `--repl` are unchanged.

## Capabilities

### New Capabilities
- `compiler-embedding`: the compiler core assembled as an in-process, C-callable unit that
  returns emitted IR text, embedded in a runner that JIT-runs a whole program in one
  process with no Chez and no `clang`/subprocess, with dev→ship fidelity (the embedded and
  batch paths share one compiler core and agree on emitted IR).

### Modified Capabilities
- _(none — the interactive `--repl` is untouched here; the incremental REPL port is the
  follow-on `repl-embedded-incremental` change.)_

## Impact

- **Code:** `tools/assemble-core.ss` (new `--embed-entry` mode), `src/core.ss`
  (`compile-source-string/prelude`), `src/runtime/runtime.c` (exported string accessors),
  new `src/run.cpp` (the runner), `Makefile` (`embed.ll` + `scheme-run` rules and staleness
  graph), new tracked `bootstrap/embed.ll`.
- **New artifact:** `build/scheme-run` — runs a Scheme program in-process
  (`build/scheme-run < demos/fact.scm` ⇒ `120`).
- **Dependencies:** removes Chez and `clang`/`lli` from this run path; Chez is still needed
  at build time to (re)generate `embed.ll`.
- **Tests:** a new harness runs the demos through `scheme-run` and compares to expected
  values / the AOT output; wired into `run-all-tests.sh`. Existing harnesses unaffected.
- **Follow-on:** `repl-embedded-incremental` ports the stateful REPL loop (persistent env +
  compile-error rollback) into the embedded compiler, retiring Chez from `--repl`.
