## Why

The compiler is batch- and closed-world only: `collect-toplevel` folds an entire
program — every top-level `define` plus the trailing expression — into one monolithic
`letrec`, emitted as a single module with one `@scheme_entry`, and every backend
(including the `lli` JIT) runs that module once in a fresh process and exits. There is
no way to enter a form, see its value, define a binding, and use it in the next form.
An interactive read-eval-print loop is the natural next capability and a prerequisite
for a comfortable self-hosting workflow.

## What Changes

- Add a **REPL-mode top-level model** in the front end: instead of one monolithic
  `letrec`, each entered form compiles independently, and top-level `define`s become
  **persistent global bindings** rather than alpha-renamed letrec-locals. Redefinition
  is supported by mangling each definition with a generation counter (e.g. `@x.3`) plus
  a compiler-side `name → current-symbol` map, so a reference resolves to the latest
  definition. Batch/whole-program compilation is unchanged.
- Add **incremental per-form IR emission**: each entered form emits its own small
  module that declares previously-defined globals and every `rt_*` as `external`,
  defines any new global slots, and exposes one entry thunk (`@__repl_N`) returning the
  value to print.
- Add a **persistent execution host** built on LLVM ORC v2 / LLJIT: `GC_INIT` runs
  once, the GC heap / symbol-intern table / `rt_*` runtime stay alive for the whole
  session, and each form's module is added to the running JIT and its entry thunk looked
  up and called. This replaces per-form `lli` (which cannot share heap state across
  forms).
- Add a **REPL driver** that reads a form, drives the existing reader/expander/codegen
  to produce IR text, hands it to the persistent JIT host, and prints the result.
- Reuse the existing conservative `rt_write` printer for interactive output.

## Capabilities

### New Capabilities
- `interactive-repl`: the read-eval-print loop — persistent top-level environment with
  redefinition, incremental per-form compilation to independent IR modules, execution in
  a long-lived LLVM ORC/LLJIT process with a shared GC heap and runtime, and interactive
  printing of results.

### Modified Capabilities
- `backends`: the "one emitted IR drives interchangeable exits" thesis gains a fourth,
  interactive exit — a persistent ORC/LLJIT host that adds per-form modules to a running
  JIT — distinct from the existing batch `lli` JIT that runs one whole-program module and
  exits. A REPL session and a batch build of the same forms must produce the same values.

## Impact

- **Front end**: `src/parse.ss` (`collect-toplevel` gains a REPL/global-definition mode);
  `src/emit.ss` (per-form module emission, external declarations for prior globals,
  `@__repl_N` entry thunks, global slot definitions).
- **Driver**: `src/compile.ss` (a new interactive entry path alongside `main`), plus a
  new REPL driver module.
- **Runtime / host**: a new persistent C++ ORC/LLJIT host linked against `runtime.c` and
  libgc; `src/runtime/runtime.c` may expose additional symbols to the JIT. `TOOLCHAIN.md`
  updated for the LLVM 22 ORC dependency.
- **No change** to AOT, bitcode, batch-JIT exits, or to whole-program compilation
  semantics. Conservative libgc means JIT'd code needs no special GC rooting.
