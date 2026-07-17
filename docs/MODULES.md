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

A manifest may also carry **program entries** — the deliverables `emit build` produces (change:
`emit-build-bin-entry`):

```scheme
;; a program entry: (program NAME (source PATH) [(output EXE-PATH)])
((library (scheme base) (source "lib/scheme/base.sld"))
 (library (mylib)       (source "test/modules/mylib.sld"))
 (program mylib-app     (source "test/modules/prog-mylib.scm") (output "build/mylib-app")))
```

- `NAME` is a bare symbol (distinct from a library name, which is a list), `source` is the
  program's top-level source file, and the optional `output` is the delivered executable's path
  (default `build/<NAME>`).
- A program entry is **not** a library: it is never a target of `import`, and library import
  resolution ignores it. See [`emit build`](#emit-build--deliver-a-program) below.

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

### Chez-free embedded runner — the run door (user libraries)

`build/scheme-run` compiles and runs a whole program with **no Chez**, and resolves user-library
`import`s through the manifest — the *run door*, at parity with the AOT and REPL doors (change:
`run-door-user-libraries`). `(scheme base)` is baked in, so a plain program needs no manifest at
all; user libraries are read from the manifest (default `emit-libs.scm`, override `--manifest FILE`
or `EMIT_MANIFEST`):

```sh
echo '(map (lambda (x) (* x x)) (list 1 2 3))' | build/scheme-run   # => (1 4 9)   no manifest needed
build/scheme-run --manifest test/modules/emit-libs.scm < test/modules/prog-mylib.scm   # => 142
```

The run door reuses the REPL door's Chez-free machinery: the host reads the manifest and each
library source and hands the text to the embedded compiler through a small mode protocol, then the
program's `@scheme_entry` initializes the imported units in topological order before running — so
the emitted program module is **byte-identical** to the AOT door's for the same manifest (dev→ship
fidelity). `bin/scheme-compile` uses the same `--emit` path for the native build.

### `emit build` — deliver a program

`bin/emit` is the project front-end. Today it exposes one verb, `build`, which turns a manifest
**program entry** into a standalone native executable — Chez-free end to end (change:
`emit-build-bin-entry`):

```bash
# resolve (program mylib-app) and deliver its executable via the Chez-free AOT door
bin/emit build mylib-app --manifest test/modules/emit-libs.scm
./build/mylib-app                       # => 142

# with exactly one program entry, the NAME may be omitted
bin/emit build --manifest my-project.scm
```

- **Resolution is Chez-free.** `emit build` resolves the `(program NAME …)` entry through the
  embedded compiler, exposed as `scheme-run --resolve-program NAME` (manifest resolution order:
  `--manifest` > `EMIT_MANIFEST` > default `emit-libs.scm`). It prints the resolved source and
  output and runs nothing:

  ```bash
  build/scheme-run --resolve-program mylib-app --manifest test/modules/emit-libs.scm
  # test/modules/prog-mylib.scm
  # build/mylib-app
  ```

- **Delivery** is `bin/scheme-compile` (the Chez-free AOT door), so the executable is byte-for-
  behavior identical to building the resolved source directly. This slice links full library units
  (no tree-shaking); the output path comes from the entry's `output`, an `-o` override, or the
  default `build/<NAME>`.
- `emit build` **renames nothing** — `scheme-run`, `repl-host`, and `bin/scheme-compile` are
  unchanged. Unifying the four doors under a single `emit` binary (`emit lib`/`run`/`repl`) is
  future work; see `openspec/explorations/packaging-and-emit-cli.md`.

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
  `<name>.exports` table (`(NAME ((external . "mangled") …))`) and a `<name>.stamp` sidecar
  recording the compiler that produced them. Artifacts are reused only when fresh — the source
  is no newer than the artifact **and** the recorded compiler-identity stamp matches the current
  compiler — and rebuilt otherwise. The stamp is a version marker plus a content hash over the
  compiler sources that determine emitted IR (the `compile.ss` `(include …)` set plus the host
  target header), so a compiler/emitter change invalidates cached units even when their source
  is untouched — the toolchain is part of the cache key, as in Rust (`.rlib` SVH), GHC (`.hi`
  version), Go, and Bazel (change: `artifact-compiler-stamp`).

## Scope & limits

This is Modules v0:

- **Exports are procedures (values), not macros.** A library may use `define-syntax` internally, but
  exporting macros through `.exports` is not yet supported; derived-form macros reach programs via
  the `(scheme base)` merge, not per-library export.
- **No tree-shaking on the Chez-free door.** `bin/scheme-compile` (and thus `emit build`) links
  full library units; the closed-world reachability strip is only on the Chez driver's AOT ship
  path (change: `aot-release-profile`). Porting it to the Chez-free door is future work.
- Import specifiers are whole-library only — no `only`/`except`/`prefix` import sets yet.

For the authoritative requirements and scenarios, see `openspec/specs/module-system/spec.md`; for
the design rationale, `docs/superpowers/specs/2026-07-15-modules-v0-design.md`.
