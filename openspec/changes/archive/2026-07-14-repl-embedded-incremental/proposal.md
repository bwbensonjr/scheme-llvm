## Why

`path-a-embedding` proves in-process embedding on the batch path (a whole program compiled
and JIT-run in one process, no Chez/`clang`). The interactive `--repl` is still Chez: its
stateful, incremental orchestration — persistent `env`/`macro-env`/`known`/`n`, per-form
modules, and compile-error rollback — lives in the Chez driver (`run-repl`,
`src/compile.ss`), not in the compiler core. This change ports that orchestration into the
embedded compiler so `--repl` runs Chez-free, completing Path A for the REPL and delivering
dev→ship fidelity for the primary development loop.

## What Changes

- Port the `run-repl` incremental loop into compiled Scheme: persistent compiler state
  across forms, `expand-form` against the growing macro env, `repl-lower-form` /
  `emit-repl-module` per form, and the prelude-as-one-batch load.
- Add a **parameterized, stateful C-ABI entry** the host calls per form (source text → IR +
  entry-thunk name), reusing the entry-name handshake (the compiler returns the per-form
  thunk symbol it chose).
- Confront **compile-error rollback**: preserve "a bad form is reported and the session
  survives" for compile-time errors, which depends on in-language `guard` — delivered by the
  `r7rs-exceptions-subset` change (the R7RS-small §6.11 subset: `guard`/`raise`/`error`
  objects). Land that first, then the rollback is expressible in compiled Scheme.
- Update `src/repl/host.cpp` to drive the embedded compiler in-process (source text in, no
  IR frame protocol) and `src/compile.ss --repl` to stop shelling out to Chez.
- Extend the host staleness graph to the embedded compiler; keep the text-IR seam.

## Capabilities

### New Capabilities
- _(none — extends existing capabilities.)_

### Modified Capabilities
- `interactive-repl`: `--repl` compiles each form via the embedded compiler in-process with
  no Chez and no per-form subprocess, preserving all observable behavior (persistent
  environment, redefinition, incremental per-form modules, trap isolation, interactive
  printing); the host-sync requirement extends to the embedded compiler.
- `compiler-embedding`: add persistent, incremental per-form compilation state and the
  parameterized per-form entry with the entry-name handshake.

## Impact

- **Depends on:** `path-a-embedding` (embedding primitives) and, for graceful compile-error
  recovery, `r7rs-exceptions-subset` (in-language `guard`/`raise`/error objects).
- **Code:** the core (ported `run-repl` orchestration + stateful entry), `src/repl/host.cpp`,
  `src/compile.ss` (`--repl` driver), `Makefile`.
- **Tests:** the REPL end-to-end, interactive, equivalence, and batch harnesses must pass
  with Chez removed from the `--repl` compile path.
- **Note:** design and detailed tasks to be written when this change is picked up; its
  rollback approach is gated on the `error`/`guard` decision.
