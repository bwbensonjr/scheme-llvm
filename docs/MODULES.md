# Modules

Emit implements a subset of the R7RS-small module surface — `define-library`, `import`, and
`export` — where **a library is the shared unit of compilation**: a `.sld` source compiles once to
an artifact (`.ll` IR + a compile-time `.exports` table) that is consumed identically whether it is
linked into a batch build or loaded into the REPL. The prelude itself is "library zero," re-homed as
`(scheme base)` and auto-imported into every program (see [`(scheme base)`](#scheme-base) below).

This is a v0 slice — see [Scope & limits](#scope--limits). The runnable examples under
`test/modules/` are the source of truth for syntax; every snippet below is drawn from them.

## Writing a library

A library source is one `(define-library …)` form, conventionally in a `.sld` file:

```scheme
;; test/modules/mylib.sld
(define-library (mylib)
  (export greet)
  (begin
    (define (helper x) (+ x 100))          ; internal (not exported)
    (define (make-adder n) (lambda (x) (+ x n)))
    (define (greet) (helper ((make-adder 5) 37)))))   ; => 142
```

- **`(export spec …)`** — each `spec` is a bare name, or `(rename internal external)` to publish an
  internal binding under a different name. Importers see only exported names.

  ```scheme
  ;; test/modules/rename-lib.sld
  (define-library (rename-lib)
    (export (rename %fast-map fmap))       ; importers see `fmap`; `%fast-map` stays private
    (begin (define (%fast-map) 77)))
  ```

- **`(import (lib) …)`** — a library may import other libraries and use their exports; the build
  resolves the transitive closure (see [Semantics](#semantics)).

  ```scheme
  ;; test/modules/chain-a.sld
  (define-library (chain-a)
    (import (chain-b))                      ; chain-a uses chain-b's export
    (export a-plus)
    (begin (define (a-plus) (+ (base-val) 5))))   ; base-val comes from chain-b => 15
  ```

- **`(begin form …)`** — the library body: a mutually-recursive group of top-level `define`s (and
  `define-syntax` used internally). Bare forms outside a `begin` are also accepted.

## Importing in a program

A program imports a library with a top-level `import` and then uses its exports:

```scheme
;; test/modules/prog-mylib.scm  => 142
(import (mylib))
(greet)
```

A name the program defines itself shadows an imported one of the same spelling (**user-wins
shadowing**).

## The manifest

Library *names* are mapped to *source files* by a manifest — an s-expression file (default
`emit-libs.scm`, overridable with `--manifest FILE` or the `EMIT_MANIFEST` env var):

```scheme
;; each entry: (library NAME (source PATH) [(artifacts DIR)])
((library (scheme base) (source "lib/scheme/base.sld"))
 (library (mylib)       (source "test/modules/mylib.sld"))
 (library (chain-a)     (source "test/modules/chain-a.sld"))
 (library (chain-b)     (source "test/modules/chain-b.sld")))
```

- `source` is the `.sld` path. `artifacts` is where the compiled `.ll`/`.exports` land (default
  `build/lib`). **Entry order is irrelevant** — the build computes the topological order itself.
- The default `emit-libs.scm` at the repo root lists only `(scheme base)`; point `--manifest` at
  your own for additional libraries (as the test suites do with `test/modules/emit-libs.scm`).

## Building and running

There are three doors. All share one compiler core, so a library's compiled bytes are identical
across them (dev→ship fidelity).

### Batch / AOT (and JIT, bitcode) — the Chez driver

`src/compile.ss` resolves imports through the manifest, compiles each library to a unit, and links
runtime + units + program. All three `--backend`s (`aot` default, `jit`, `bitcode`) resolve imports
and the `(scheme base)` auto-import identically:

```sh
chez --libdirs src --script src/compile.ss test/modules/prog-mylib.scm \
     --manifest test/modules/emit-libs.scm -o /tmp/prog
/tmp/prog                     # => 142

# same program, in-process JIT via lli, or a bitcode artifact:
chez --libdirs src --script src/compile.ss test/modules/prog-mylib.scm \
     --manifest test/modules/emit-libs.scm --backend jit
```

### REPL — interactive import

The shipped `build/repl-host` (build it with `make repl-host`) preloads the manifest's libraries and
honors interactive `import`; pass the manifest via `EMIT_MANIFEST`:

```sh
EMIT_MANIFEST=test/modules/emit-libs.scm build/repl-host
> (import (mylib))
> (greet)
142
```

### Chez-free embedded runner — `(scheme base)` only

`build/scheme-run` and `bin/scheme-compile` compile and run a whole program with **no Chez** — but
they auto-import only `(scheme base)` (baked in) and have **no manifest**, so they cannot resolve
arbitrary user-library `import`s:

```sh
echo '(map (lambda (x) (* x x)) (list 1 2 3))' | build/scheme-run   # => (1 4 9)   (scheme base) works
echo '(import (mylib)) (greet)'                | build/scheme-run   # error: unbound variable greet
```

For user libraries on a Chez-free path, use the Chez driver above. (Extending the embedded runner
with a manifest is future work.)

## `(scheme base)`

The prelude — `map`, `filter`, `append`, `fold-left`, the character comparisons, the reader, the
derived-form macros (`cond`/`case`/`when`/…), etc. — is the library `(scheme base)`, generated from
`src/prelude.scm` into `lib/scheme/base.sld`. It is **auto-imported into every program and REPL
session** (and into the compiler's own build), as if the source began with `(import (scheme base))`.

- Its procedures resolve as `scheme.base:*` external globals against a linked/loaded
  `scheme.base.ll`; its derived-form macros are merged at expand time.
- **`--no-prelude`** skips the auto-import and the macro merge, leaving prelude names and derived
  forms unbound — for a program that wants only primitives and its own definitions.
- Do not edit `lib/scheme/base.sld` by hand; it is generated (`tools/gen-scheme-base.ss`, guarded by
  `test/scheme-base-gen-check.sh`). Edit `src/prelude.scm` and regenerate.

## Semantics

- **Transitive imports** — a program (or library) pulls in the full transitive closure of its
  imports, ordered dependencies-first. See `test/modules/chain-*.sld`.
- **Diamond-safe initialization** — if two libraries both import a third, it is linked once and its
  `__init` runs once (guarded by a `@"lib:__inited"` flag). See `test/modules/dia-*.sld`.
- **Import cycles are rejected** at build time with a diagnostic. See `test/modules/cyc-*.sld`.
- **User-wins shadowing** — a program's own top-level `define` beats an imported binding.
- **Symbol naming** — an export is emitted as `@"libname:export"` (e.g. `@"mylib:greet"`,
  `@"scheme.base:map"`); a `rename` is pure table indirection, so the emitted symbol tracks the
  *internal* name (`@"rename.lib:%fast-map"` for the `fmap` export). Importers reference these as
  external globals.
- **Artifacts** — each library compiles to `<artifacts>/<name>.ll` plus a readable
  `<name>.exports` table (`(NAME ((external . "mangled") …))`). Artifacts are reused when fresh
  (source no newer than artifact) and rebuilt otherwise.

## Scope & limits

This is Modules v0:

- **Exports are procedures (values), not macros.** A library may use `define-syntax` internally, but
  exporting macros through `.exports` is not yet supported; derived-form macros reach programs via
  the `(scheme base)` merge, not per-library export.
- **The Chez-free embedded runner** (`scheme-run`/`scheme-compile`) resolves only `(scheme base)`,
  not manifest user libraries (see above).
- Import specifiers are whole-library only — no `only`/`except`/`prefix` import sets yet.

For the authoritative requirements and scenarios, see `openspec/specs/module-system/spec.md`; for
the design rationale, `docs/superpowers/specs/2026-07-15-modules-v0-design.md`.
