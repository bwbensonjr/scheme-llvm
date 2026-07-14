# Exploration: the namespace model (shared by modules + the embedded REPL)

Status: exploration / design shared by two workstreams
Related: `openspec/explorations/modules-and-embedding.md` (the triangle; step 1b/2),
`openspec/changes/repl-embedded-incremental` (the Chez-free REPL port),
future `modules-*` changes. Captured: 2026-07-14

## Why this doc

The incremental REPL port and the module system are independent in *mechanism* but share
one decision: **how a free identifier resolves to a binding, and how that binding names a
symbol in the emitted IR.** Settling that once means the REPL port can be built on the final
model instead of a flat one we'd unpick later. This doc is that decision; either workstream
can then proceed in either order.

## Where we are: one flat namespace

Today there is a single global namespace. Resolution (`resolve-globals`, `src/parse.ss:224`)
maps a free identifier to `(global-ref sym)` via a flat `name→sym` alist, or errors
"unbound". Two mangling schemes already exist:

```
  BATCH        every top-level define -> its own symbol; one letrec; whole program.
  REPL         make-repl-env = #(name->sym alist, generation)
               each define -> a GENERATION-mangled symbol  x.g0, x.g1, ...
               redefinition allocates a fresh generation; earlier-compiled forms keep
               the symbol they captured, later forms resolve to the newest (parse.ss:210).
               per-form modules: defined globals get slots; referenced-but-not-defined
               globals are emitted as `external global` and resolve across the JITDylib.
```

Hygiene / visibility is tracked by the `known` set (core keywords + primitives + macro
names + top-level define names) and `macro-env` (the parsed `define-syntax` forms). All of
it is **flat**: every top-level name is visible everywhere; nothing is scoped or imported.

## The unifying idea: a scope is a set of bindings; a module and a REPL session are both scopes

```
                         ┌──────────────── a SCOPE ────────────────┐
   free identifier  ─►   │  resolve against, in order:              │
                         │   1. lexical locals (lambda/let/letrec)  │  (unchanged)
                         │   2. this scope's own top-level defines   │  -> owned symbol
                         │   3. imported bindings                    │  -> other unit's symbol
                         │   4. primitives / keywords                │  -> intrinsic
                         │   else: unbound-variable error            │
                         └───────────────────────────────────────────┘

   a MODULE          = a CLOSED scope: exports a chosen subset of (2); may import (3)
   a REPL SESSION    = an OPEN   scope: (2) accumulates as you type, redefinable; may import (3)
```

A binding has a **kind** and a **symbol**:

| Binding kind | Resolves to | Symbol in IR |
|---|---|---|
| local (this scope defined it) | `(global-ref own-sym)` | this unit **defines** the global |
| imported (another unit exports it) | `(global-ref exported-sym)` | this unit **declares** it `external`; the JIT/linker binds it to the exporter |
| primitive / keyword | intrinsic emit | — |

This is exactly today's per-form REPL mechanism (defined-vs-external globals in one JITDylib)
— generalized so "external" can come from an imported *library*, not only an earlier *form*.

## The one decision that actually differs: symbol mangling

Resolution is uniform; the mangling scheme is where modules and the REPL genuinely diverge,
because a symbol name is the **cross-unit ABI**.

```
  REPL session names   ── GENERATION-mangled (x.g0, x.g1)
                          ephemeral, session-local, supports redefinition.
                          Fine because nothing OUTSIDE a session imports from it.

  Module export names   ── DETERMINISTIC, module-qualified (e.g.  lib:name  or  hash)
                          STABLE across separate compilations: a library compiled once and
                          imported by many must expose the SAME symbol every time, or its
                          .ll/.o and its importers won't link. Generation counters (session
                          state) are NOT stable, so modules need their own scheme.

  Module-internal names ── module-qualified too (collision-free in a shared JITDylib/link),
                          but NOT part of the export ABI.
```

**Design rule:** the exported symbol of `name` in library `L` is a pure function of
`(L, name)` — no counters, no compile-order dependence — so it round-trips across separate
compilation. The REPL session is the degenerate case where the "export scheme" is the
generation counter (and its exports are consumed only by later forms in the same process).

## Imports are a compile-time name-set transform

`(import <import-set> …)` resolves at compile time:

1. Read the imported unit's **export table**: `name → exported-symbol` (+ for macros, the
   syntax — deferred, see phase separation).
2. Apply the import-set transforms — `only` / `except` / `prefix` / `rename` — as pure
   name-set operations over that table.
3. Inject the results into the importer's scope as **imported bindings** (kind = imported).
   In IR, each referenced import becomes an `external global` (JIT/linker binds it).

The export table is the `.exports` artifact from `modules-and-embedding.md`. For AOT the
driver reads `.exports` files; for the REPL, `import` resolves against modules already loaded
into the session (their export tables held in the embedded compiler's state) and
`addIRModule`s the library so its symbols materialize — the same move `load-prelude!` already
makes for the prelude batch.

## The prelude is library zero

Today the prelude is text-prepended and its names are flat top-level defines. Under this
model it becomes an implicitly-imported library (eventually partitioned into
`(scheme base)` / `(scheme write)` / `(scheme char)` / …). Transitional: keep it
auto-imported so existing programs are unaffected; the `import` machinery just formalizes
what prepending does now.

## Macros across the boundary (noted, deferred)

Exported macros don't survive into IR, so an importing unit needs the exporter's
`syntax-rules` definitions at expand time — the `.exports` compile-time half. In this model
that means the export table carries macro entries that get merged into the importer's
`macro-env` (and their introduced names into `known`) during import resolution. v0 exports
procedures only; this is where macro export slots in later without reshaping the model.

## What the REPL port must honor (the single carried constraint)

`repl-embedded-incremental` can stay flat for v1 (no `import` yet) **iff** it is built on the
scope abstraction above rather than assuming "every visible name is session-defined":

- Model the session env as a **scope with a typed lookup** that already distinguishes
  *local* (generation-mangled) from *imported* (external) from *intrinsic* — even if v1 only
  ever populates *local* + the implicit prelude.
- Keep the "referenced-but-not-defined ⇒ `external global`" emission (it already exists);
  that is precisely the hook imports will reuse.
- Do **not** fold the prelude in as if its names were session-local; treat it as the first
  (implicit) import, so real `import` is additive.

With that, adding modules-in-REPL later is: populate *imported* bindings + `addIRModule` the
library. No rework of resolution or emission.

## Open questions

- **Export mangling scheme**: readable `lib:name` (debuggable IR) vs. a hash (robust to odd
  characters / long library names)? Must be LLVM-symbol-legal and collision-free.
- **Library identity**: how `(import (foo bar))` maps to an on-disk `.exports`/`.ll` (search
  path) vs. a session-loaded module.
- **Redefinition vs. imports in the REPL**: can a session `define` shadow an imported name?
  (Flat REPL already lets a later define win; imports should follow the same last-wins-in-
  session rule, leaving the library's own binding intact.)
- **Prelude partitioning timing**: keep the monolithic implicit prelude for v0 and split into
  `(scheme *)` libraries later, or split up front?
- **Macro export representation** in `.exports`: serialized `syntax-rules` source (matches the
  text-IR ethos) vs. a pre-parsed form.

## Not in scope here

This is the shared resolution/mangling model, not an implementation. The `.exports` format,
separate-compilation build wiring, and the R7RS import-set surface are the modules changes;
the stateful per-form orchestration is `repl-embedded-incremental`. Both cite this doc for
how names resolve and how symbols are mangled.
