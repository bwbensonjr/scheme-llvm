# Exploration: modules + in-process embedding (Path A)

Status: exploration / living roadmap (individual steps become their own changes)
Related: `openspec/explorations/chez-free-repl.md` (the three paths A/B/C; this
continues from A); archived `2026-07-14-self-hosting-bootstrap` (Path C fixed point,
done for **batch**); archived `2026-07-14-self-host-io-strategy` (Path C vs A, D1);
archived `2026-07-12-interactive-repl` (the ORC/LLJIT host)
Captured: 2026-07-14

## The framing

Three product desires converge on one architectural artifact:

1. **Standalone executables as the niche.** Producing small, clean, self-contained
   native binaries from Scheme is a defining differentiator. Keep AOT first-class;
   binary size/cleanliness is a design concern.
2. **The REPL is the primary dev loop, with dev→ship fidelity.** Develop, test, and
   debug interactively, *then* compile to an executable with identical behavior. The
   REPL and the batch compiler must be the **same** compiler core.
3. **Libraries usable in both contexts.** Develop a library, compile it once, and use
   that same artifact interactively (loaded into the REPL) *and* in a static build
   (linked into an executable).

All three are consumers of the same thing: a **separately-compiled module** with a
declared export interface.

```
                 STANDALONE EXE  (the niche)
                        ▲
                       ╱ ╲
             links ───╱   ╲─── links
                     ╱     ╲
                    ╱ ┌───────────┐ ╲
                   ╱  │ COMPILED  │  ╲
                  ╱   │  MODULE   │   ╲
                 ╱    │ (IR/.o +  │    ╲
                ╱     │  exports) │     ╲
               ╱      └───────────┘      ╲
    REPL DEV ◀──────── addIRModule ────────▶ LIBRARIES
   (interactive)                             (shared unit)
```

The codebase is already ~80% shaped for this: the REPL host resolves cross-module
symbols in a shared JITDylib (`src/repl/host.cpp`), and AOT already links multiple
`.ll` files. **A library is "a module you `addIRModule` before the user types" in the
REPL, and "a `.o` you pass to clang" in the static build — the same bytes, two doors.**
The quiet enabler is the **uniform calling convention**: every Scheme function shares
one `tailcc` prototype `(self, argc, a0…a{K-1}, overflow)`, so separately-compiled
modules link at the IR level with no glue.

## Where we actually are (2026-07-14)

The byte-identical fixed point (`stage-2 == stage-3`) was reached for the **batch**
path only. The **REPL front end is still Chez**:

```
BATCH today — a Chez-free compile step exists:
  schemec  ──IR text──▶  clang + runtime + libgc  ──▶  a.out
  (compiled Scheme; Path C, self-hosting-bootstrap)

REPL today — TWO processes, compiler STILL Chez:
  ┌─ chez compile.ss --repl ─┐  frames         ┌─ build/repl-host (C++) ─┐
  │  read → expand → passes  │  "name N\n"+IR  │  parseIR → addIRModule  │
  │  → emit   (run by CHEZ)  │────────────────▶│  → lookup → call → print│
  └──────────────────────────┘   per form      └─────────────────────────┘
       ^^^ Chez lives here                           ^^^ already Chez-free
```

So **Path A is what makes the REPL Chez-free at all** — not an optimization of an
already-Chez-free REPL. And per desire (2), embedding the *same* core the batch path
uses is what *guarantees* dev→ship fidelity; a subprocess REPL (a REPL-flavored
Path C) would risk a second compilation path drifting from batch.

## Part 1 — In-process embedding (Path A)

Fold the compiled compiler into the ORC/LLJIT host so there is no Chez and no
per-form subprocess. The compiler stops being a program that *runs* and becomes a
library the host *calls*.

```
PATH A — one process, no Chez, no per-form fork:
  ┌──────────── build/repl-host (C++ ORC/LLJIT) ────────────┐
  │  entered text ─▶ rt_compile(src) ──┐                     │
  │                                    │ (the COMPILED       │
  │                 ◀── IR text ───────┘  compiler, in-proc) │
  │  parseIR ─▶ addIRModule ─▶ lookup ─▶ call ─▶ rt_write     │
  └──────────────────────────────────────────────────────────┘
```

**Keep the text-IR seam.** The compiled compiler still returns IR *text*; the host
`parseIR`s it. Embedding is process topology, not abandoning the inspectable boundary
that gives `--dump` and the byte-identical fixed point. Hold this line.

### The FFI boundary is tiny — its sibling already exists

`tools/assemble-core.ss --filter-main` already wraps the assembled core as
`(display (compile-source-string (read-all-stdin)))` — a stdin→stdout `main`. Path A
wants the *same assembled core* wrapped in a **callable C-ABI shim** instead:

```
  --filter-main   →  (display (compile-source-string (read-all-stdin)))   [a main()]
  --repl-entry    →  char* rt_compile(char* src)                          [a call]
                       { return bytes-of (compile-source-string src) }
```

The shim's whole job is the value-representation crossing: build a Scheme string from
`src` (runtime already has string constructors), call `compile-source-string`, return
the result string's byte pointer. **One function** — a close cousin of
`RT_FILTER_MAIN`.

### Fork 1 — how to embed (the cheap axis)

| | **A-link** (static) | **A-jit** (load into the JIT) |
|---|---|---|
| Mechanism | `clang compiler.ll runtime.c host.cpp -o repl-host` | host `parseIR`s `compiler.ll` into LLJIT at startup |
| Call site | plain C function pointer | `JIT->lookup("rt_compile")` |
| Startup cost | none (already native) | materialize the whole compiler once |
| Liveness | compiler frozen at host-build time | compiler is just another module |

Start **A-link**. The host is *already* rebuilt whenever the runtime changes (the
Makefile staleness graph); "…and whenever the compiler changes" costs nothing
conceptually. A-jit only earns its keep if the *user* should redefine the compiler
live (a real Lisp move — a much bigger fish, deferred).

### Fork 2 — one world or many? — resolved by Part 2

The naive embed shares one GC heap / symbol table / JITDylib between compiler and user
code (elegant but dangerous: a user redefining `car` could collide with a compiler
global). The naive alternative is two isolated worlds (safe but throws away the point).
**Modules dissolve this binary into controlled worlds**: the compiler is a module, the
session is a module, each library is a module; sharing is by explicit export/import.
So do not hardcode "one flat world" in the embed — leave room for named scopes (Part 2).

### The sleeper argument for A over C in the REPL

The REPL compiles *forms incrementally* with earlier definitions in scope
(`emit-repl-module` / `repl-lcode`, `src/compile.ss`). That needs the compiler's own
mutable state — gensym counter, rename env, interned symbols — to **persist across
forms**. A per-form subprocess starts fresh every time (you'd serialize/replay
compiler state on every form — awkward-to-hopeless). An **embedded** compiler gets
persistent state for free, exactly like user globals already persist in the JITDylib.

## Part 2 — Modules (target: R7RS-small)

The module surface targets **R7RS-small**: `define-library`, `import`, `export`.

### The compiled-module artifact

```
  A library exports procedures AND macros.
  Procedures → survive into IR  → ship as .ll/.o        ✅ runtime artifact
  Macros     → compile-time only → vanish before IR      ⚠️ compile-time artifact
```

A `syntax-rules` macro is consumed by the `expand` pass and gone — it does not exist
at runtime. So a compiled library that exports macros **cannot be pure IR**. Two
artifacts per library (think `.hi`/`.mli`):

```
  libfoo.ll / libfoo.o     ← runtime: the compiled procedures
  libfoo.exports           ← compile-time: export list + exported syntax-rules defs
```

The embedded/batch compiler reads `.exports` to resolve imports at expand time; the
linker (AOT) or JIT (REPL) consumes the IR. **v0 can dodge phase separation entirely:
export procedures only, keep macros source-level (re-expanded on import).** The
`.exports` sidecar is the named follow-on for macro-exporting libraries.

### R7RS-small mapping onto this backend

| R7RS-small feature | How it lands here |
|---|---|
| `(define-library (name …) decls…)` | unit of separate compilation → one `.ll/.o` (+ `.exports`) |
| `(export id …)`, `(export (rename int ext))` | the module's public interface; drives what `.exports` lists and what stays internal |
| `(import <import-set> …)` | compile-time: load each imported module's `.exports`; link/`addIRModule` its IR |
| `(begin def …)` | inline library body → compiled into the module |
| `(include "f") / (include-ci …)` | source splicing before compile (driver concern, reader already exists) |
| `(include-library-declarations …)` | splice declarations; low priority |
| `(cond-expand …)` | feature-based selection; needs a feature list; low priority |
| import sets `only / except / prefix / rename` | pure compile-time name-set transforms over an imported `.exports` |
| standard libs `(scheme base)`, `(scheme write)`, `(scheme char)`, `(scheme cxr)`, … | our prelude, re-partitioned — **the prelude becomes `(scheme base)` + friends** |

Two clarifying observations:

- **R7RS libraries are not first-class.** `import`/`define-library` are static,
  top-level forms — no runtime library values. That matches the AOT model perfectly:
  imports resolve at compile/link time, nothing dynamic to represent at runtime.
- **The prelude is library zero.** Re-partitioning today's flat prelude into
  `(scheme base)` / `(scheme write)` / `(scheme char)` / `(scheme cxr)` / … turns the
  "prepend everything" model into "import what you use" — which is exactly the
  separate-compilation lever that shrinks standalone binaries (the niche). Dead-code
  elimination falls out at the linker level: unused library objects simply aren't
  linked.

### The two genuinely new hard problems

> The namespace/name-resolution model modules share with the embedded REPL is worked out in
> `openspec/explorations/namespace-model.md` (a scope = a set of bindings; a module and a
> REPL session are both scopes; the one real divergence is symbol mangling — stable/module-
> qualified for exports vs. ephemeral/generation for a session).

1. **Namespaces / import resolution (tractable design work).** Today everything is one
   flat global namespace. Modules need exported-vs-private, and the four import-set
   transforms (`only`/`except`/`prefix`/`rename`). All are compile-time name-set
   operations over a module's `.exports`. Internal names likely need mangling by module
   so separately-compiled units don't collide in the JITDylib / at link time.
2. **Macro phase separation (the thorny one).** Exported macros must travel in the
   compile-time `.exports` artifact, not the IR. Deferred past v0 on purpose.

## Roadmap / suggested ordering

```
  ✅ Path C batch fixed point            (self-hosting-bootstrap — done)
  ────── remaining ──────
  1a. Path A embedding — mechanism  (path-a-embedding)
       A-link the compiled core into an in-process runner (build/scheme-run);
       the embedded compiler returns IR text, the runner JIT-runs a whole
       program. No Chez, no clang/lli, no subprocess. Batch path only.
       ← establishes the embedding primitives (C-callable compiler entry,
         exported string accessors, parse→add→lookup→call loop).

  1b. Path A embedding — incremental REPL  (repl-embedded-incremental)
       Port run-repl's stateful orchestration (persistent env, per-form
       modules, compile-error rollback) into the embedded compiler; retire
       Chez from --repl. Gated on r7rs-exceptions-subset (in-language guard) for rollback.
       ← reuses 1a's primitives; adds the per-form entry-name handshake.
         Do NOT hardcode one flat world.

  2. Modules v0 — procedures only  (R7RS-small subset)
       define-library / export / import with only/except/prefix/rename;
       a library compiles to .ll/.o; AOT links it; REPL addIRModule's it.
       Prelude re-partitioned as (scheme base) & friends = "library zero."
       ← where the standalone-exe payoff (DCE, small binaries) starts to land.

  3. Macro-exporting modules — the .exports sidecar
       phase-separated compile-time interface for exported syntax-rules.
       Deferred until v0 proves the artifact model.

  4. Fill out R7RS-small library set + include / cond-expand
       as demand warrants.
```

Embedding first: small, bounded, kills the last Chez dependency, and builds the exact
module-loading muscle (callable compiled code in the host; cross-module resolution)
that step 2 generalizes.

## Open questions

- **Bootstrap artifact policy (still open from self-hosting-bootstrap D3).** A-link
  needs a `compiler.ll` at host-build time: regenerate via `schemec` each build (clean,
  slower) or commit a stage-0 `.ll` (fast, but a checked-in generated artifact)?
- **Internal-name mangling scheme** for separately-compiled modules sharing one
  JITDylib / link — per-module prefix? what guarantees no collision with user globals?
- **Where the REPL loop lives** after embedding — compiled Scheme calling back into the
  host to JIT, or the host driving compiled `compile-form`? (interactive-repl D4 leans
  to the former.)
- **Macro artifact format** for `.exports` — serialized syntax-rules source, or a
  compiled/expanded form? Serialized source is simplest and matches the text-IR ethos.
- **`cond-expand` feature list** — what features do we advertise?
- **GC/re-entrancy** — the embedded compiler now allocates in the same heap it compiles
  into; Boehm is conservative and `GC_INIT()` runs once, but heap-pressure profile
  changes mid-session.

## Not in scope here

This is the roadmap; each numbered step becomes its own OpenSpec change. Full R6RS-style
phase towers, first-class/dynamic libraries, and `eval`/`(scheme eval)` are out of scope
for R7RS-small compatibility. Path B (front end in C++) remains rejected — it abandons
the "compiler in Scheme" identity.
