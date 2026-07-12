## Context

The compiler is closed-world and batch-only. `collect-toplevel` (`src/parse.ss:116`)
folds every top-level form into a single `letrec`; `alpha-rename` makes those bindings
fresh letrec-locals with no persistent identity. `emit-program` (`src/emit.ss:422`) emits
one module — rt-declarations + symbol globals + all code + a single
`@scheme_entry() -> i64`. The runtime `main` (`src/runtime/runtime.c:359`) calls
`GC_INIT()`, runs `scheme_entry` once, prints, and exits. The JIT exit (`run-jit`,
`src/compile.ss:142`) is a *batch* JIT: `lli` on one whole-program module that runs and
exits. Per-form `lli` cannot be a REPL, because each invocation is a fresh process with a
fresh heap — a pair/closure/symbol from one form is meaningless in the next.

The runtime uses the Boehm conservative GC (libgc). This is a key enabler: JIT'd code
needs no cooperative stack maps or root registration; one `GC_INIT` in a persistent host
plus ordinary calls into JIT'd code are scanned conservatively.

## Goals / Non-Goals

**Goals:**
- A persistent top-level environment where `define`s survive across entered forms and can
  be redefined.
- Incremental compilation: each form → its own small IR module referencing prior globals
  as `external`.
- A long-lived execution host (LLVM ORC v2 / LLJIT) that keeps one GC heap, symbol table,
  and `rt_*` runtime alive for the session, with values flowing across forms.
- Reuse of the existing reader, expander, lowering passes, and `rt_write` printer.
- Batch/AOT/bitcode/`lli` exits and whole-program semantics unchanged.

**Non-Goals:**
- Editor integration, multi-line editing, readline/history, tab completion.
- Error recovery beyond reporting and continuing at the prompt (no debugger, no restarts).
- Concurrency / multiple sessions in one host.
- Removing or replacing the batch `lli` JIT exit.
- Precise/moving GC or relocation of JIT'd code.

## Decisions

### D1: Top-level defines become persistent globals with generation-mangled names

Add a REPL-mode top-level lowering distinct from `collect-toplevel`'s monolithic
`letrec`. Each `(define x e)` allocates a module-level global slot and stores the
evaluated init into it. Redefinition is handled by mangling each definition with a
generation counter (`@x.3`) plus a compiler-side `name → current-symbol` map; a reference
to `x` resolves to the latest `@x.N`.

- **Why:** Globals persist in the JIT symbol table and are resolvable by later modules;
  mangling makes redefinition a fresh symbol rather than an illegal duplicate definition,
  and gives correct "later forms see the new binding, already-compiled forms keep the old"
  semantics for free.
- **Alternatives considered:** (a) A single persistent environment array indexed at
  runtime — adds an indirection layer and a hand-rolled symbol table the JIT already
  provides. (b) Recompiling the whole growing session each entry — O(n²) and re-runs side
  effects. (c) Disallowing redefinition — hostile for a REPL.

### D2: One IR module per form with an `@__repl_N` entry thunk

Each form emits a module that (1) `external`-declares every prior global it references and
every `rt_*` it uses, (2) defines global slots for names it introduces, and (3) defines
one `@__repl_N() -> i64` thunk that evaluates the form, initializes new slots, and returns
the value to print.

- **Why:** Matches ORC's add-module/lookup-symbol model directly and keeps each form's IR
  small and inspectable, consistent with the project's transparency goal.
- **Alternatives considered:** Mutating one growing module in place — ORC modules are
  effectively immutable once added; re-adding a superset conflicts with existing symbols.

### D3: Persistent host on LLVM ORC v2 / LLJIT, runtime resolved from the host process

A small long-lived C++ host initializes libgc once, links `runtime.c` + libgc, and exposes
process symbols to the JIT via `DynamicLibrarySearchGenerator::GetForCurrentProcess()` so
`rt_*` resolve without re-adding the runtime per form. The host parses each form's IR text
(`parseIR`), `addIRModule`s it, looks up `__repl_N`, casts to `val(*)()`, and calls it.

- **Why:** LLJIT is the supported, stable ORC v2 façade and is exactly the
  KaleidoscopeJIT pattern; resolving the runtime from the host process avoids duplicate
  `rt_*` definitions and keeps one heap/symbol-table instance.
- **Alternatives considered:** MCJIT (legacy, deprecated); a bespoke interpreter of the
  lowered IL in Chez (a *different* engine → semantic drift, fails the "REPL with the LLVM
  backend" goal).

### D4: Keep the loop logic in Chez; make the C++ host a thin server

The read/compile logic (reader, expander, codegen) stays in Chez. The C++ ORC piece is a
minimal long-lived server: Chez emits IR text and sends it over a pipe; the server
JIT-adds and runs it and returns the printed value.

- **Why:** Concentrates the interesting, fast-changing logic in Scheme (aligned with the
  self-hosting goal) and confines LLVM/C++ to a small, rarely-changing shim.
- **Alternatives considered:** Writing the whole REPL in C++ (duplicates reader/expander,
  diverges from the Scheme-first design); embedding LLVM in Chez via FFI (heavier, less
  portable).

### D6: Pin a session-wide closure arity K in REPL mode

The shared closure calling convention is `tailcc i64 (self, argc, a0..a{K-1}, overflow)`
where `K` is the max fixed arity. Today `max-arity`/`*arity*` compute `K` per whole
program (`src/emit.ss:334`). In a persistent session, closures built by one form's module
are called from later forms' modules, so `K` MUST be identical across every per-form
module or the prototypes mismatch (undefined behavior). REPL mode SHALL pin `K` to a fixed
constant (initially 8) for the whole session; a definition whose fixed arity exceeds the
pinned `K` SHALL be rejected with a clear error.

- **Why:** Already-emitted modules cannot be retrofitted with a larger `K`, so a
  session-wide constant is the only stable choice; overflow handling already spills
  arguments beyond `K`, so a modest constant costs little.
- **Alternatives considered:** Recompiling/re-adding earlier modules when `K` grows
  (defeats incrementality); a per-closure arity tag with a dispatch shim (adds runtime
  cost and complexity for a rare case). *(Discovered during Group 1 implementation.)*

### D5: Sequence the work — front end first, validated on the existing batch JIT

Land D1/D2 first and validate by emitting several `@__repl_1..N` thunks into one module and
calling them in sequence from a temporary driver, proving the global-slot and redefinition
model with **no ORC code**. Only then build the ORC host (D3/D4) to make it incremental.

- **Why:** De-risks the backend-agnostic front-end change independently of the C++/ORC
  work; each half is separately verifiable.

## Risks / Trade-offs

- **ORC v2 API churn across LLVM versions** → Pin to the project's LLVM 22 (already pinned
  in `src/compile.ss`); wrap ORC usage behind a thin host interface so an API bump touches
  one file.
- **`datalayout`/triple mismatch between per-form modules and the JIT** → Reuse the
  existing host-target-header logic so every emitted module carries the host triple; the
  JIT's data layout is authoritative and modules must match.
- **Conservative GC false retention / scanning JIT'd frames** → libgc already scans the
  C stack conservatively; document that the host must call into JIT'd code on a scanned
  thread and avoid hiding live pointers in unscanned memory.
- **Redefinition symbol growth** (a hot redefine loop leaks `@x.N` symbols) → Acceptable
  for an interactive session; note it and revisit only if it bites.
- **Symbol clashes / duplicate definitions on re-add** → Generation mangling (D1) plus
  one-module-per-form (D2) ensure every defined symbol is unique across the session.
- **Scope creep into readline/editing** → Explicitly a non-goal; first cut reads plain
  forms from a port.

## Migration Plan

Purely additive. New REPL entry path in `src/compile.ss` plus a new driver module and a
new C++ host; AOT/bitcode/`lli`/batch semantics and existing demos are untouched. Rollback
is removing the REPL entry point and host — no change to existing artifacts. Land D5 stage
1 (front-end globals on batch JIT) behind the new mode before adding the ORC host.

## Open Questions

- Transport between Chez and the C++ host: line-delimited IR text over a pipe vs. a temp
  `.ll` path per form vs. a socket. (Leaning: pipe with a length-prefixed framing.)
- How results are marshaled back for printing: let the host call `rt_write` directly
  (simplest) vs. return a tagged value to Chez for formatting.
- Whether `set!` on an undefined top-level name should implicitly define it at the REPL, or
  error as in batch mode.
- Error-handling contract when a form traps at runtime (arity error, etc.): keep the
  session alive and resume at the prompt — confirm the host can isolate a trap without
  tearing down the process.
