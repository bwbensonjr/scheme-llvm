## Why

The M1 compiler accepts exactly one top-level expression (`compile.ss` reads a single
form; `parse-program` is just `parse-expr`), with no `define` in the grammar. A real
Scheme program — and the compiler's own source, the self-hosting north star — is a file
of top-level `define`s followed by expressions. Until a program can be more than one
form, every richer feature (more primitives, symbols, derived forms) has no natural way
to be written or tested. This is the cheapest next increment that unblocks all of them.

## What Changes

- The compiler accepts a **program = a sequence of top-level forms** (definitions and
  expressions) read from the source file, instead of a single expression.
- Add top-level `define` in both forms:
  - `(define x e)` — value binding
  - `(define (f arg ...) body ...)` — lambda shorthand, desugaring to `(define f (lambda (arg ...) body ...))`
- A program's **value is its last top-level expression** (the value reported by the
  executable), matching the existing single-expression behavior as the one-form case.
- Add **one new observable frontend stage** that collects the top-level forms and
  desugars them into a single `(letrec ([x e] ...) <last-expr>)`, which the existing
  `convert-assignments → convert-closures → lambda-lift → emit` chain already compiles.
- `--dump` shows the new stage alongside the existing ones.
- **Frontend-only.** No changes to the value representation, the C runtime, or the LLVM
  emitter. `letrec` is already supported end to end.
- Scope guard (non-breaking, additive): `define` is accepted at top level (and, if
  trivially in reach, internal-body position); no `letrec*` reordering semantics beyond
  what the existing `letrec` lowering provides.

## Capabilities

### New Capabilities
<!-- None: this reshapes existing behavior rather than introducing a new capability area. -->

### Modified Capabilities
- `core-language`: the "Compile and run the M1 core-lambda subset" requirement changes
  from accepting *a single top-level expression* to accepting *a sequence of top-level
  forms including `define`*, with the program's value defined as its last top-level
  expression.
- `aot-codegen`: the "Each pipeline stage is independently observable" requirement's
  stage list gains the new top-level-collection/`define`-desugaring stage in the
  `--dump` output.

## Impact

- **Code (frontend only):**
  - `src/compile.ss` — `read-program` reads *all* forms from the file (loop on `read`)
    rather than one; pipeline gains the new stage; `--dump` wiring.
  - `src/parse.ss` — new top-level entry that parses a list of forms and desugars
    `define` (both shapes) into a `letrec` over the trailing expression.
  - `demos/` — add a multi-`define` demo; `demos/run-tests.sh` covers it.
- **Unaffected:** `src/runtime/runtime.c`, `src/emit.ss`, `src/passes/*` (they already
  handle `letrec`, closures, boxing, lambda-lift), and all M1 IR conventions.
- **Compatibility:** M1's single-expression programs remain valid (the one-form case),
  so existing demos keep passing.
