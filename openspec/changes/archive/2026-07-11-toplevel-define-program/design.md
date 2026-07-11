## Context

The M1 `core-lambda-slice` compiler reads exactly one top-level form
(`compile.ss` `read-program` calls `read` once) and `parse-program` is an alias for
`parse-expr`. There is no `define` in the grammar. The downstream pipeline
(`convert-assignments → convert-closures → lambda-lift → emit`) and the whole runtime/IR
convention layer are complete and proven end to end, including full `letrec` support
(mutual recursion, closures, boxing, `musttail`).

The self-hosting north star is a compiler whose own source is a file of top-level
`define`s. Nothing in the language today can express a program of more than one form, so
this is the first rung of the language ladder and a precondition for testing every later
feature (symbols, derived forms, more primitives).

## Goals / Non-Goals

**Goals:**
- Accept a program as a sequence of top-level forms (definitions and expressions).
- Support top-level `define` in both shapes: `(define x e)` and
  `(define (f arg ...) body ...)`.
- Define a program's value as its last top-level expression.
- Do it as a **single new frontend pass** feeding the existing `letrec`, with a
  `--dump`-observable stage, and **no changes** to the runtime, IR conventions, emitter,
  or the existing passes.

**Non-Goals:**
- `letrec*` sequential-evaluation semantics beyond what the existing `letrec` lowering
  gives (see Risks). No separate `define`-ordering analysis.
- Internal `define` inside lambda/let bodies as a distinct feature — handled only if it
  falls out of the same desugaring for free; otherwise deferred.
- Module system, multiple files, separate compilation, top-level redefinition/REPL.
- Any new data types, primitives, derived forms, or macros — those are later milestones.

## Decisions

### D1 — Desugar top-level forms into one `letrec`, reuse the whole pipeline

A program `d1 d2 ... dk e_last` (where the `d`s are `define`s and there may be
interleaved expressions) desugars to a single core expression:

```
(letrec ([x1 e1] ... [xn en]) <body>)
```

where each `(define x e)` / `(define (f a...) body...)` contributes a binding
(`f`'s value is `(lambda (a...) body...)`), and `<body>` is the trailing top-level
expression (the program's value). This is chosen because `letrec` already compiles
correctly through the existing passes — mutual reference among definitions, closures,
boxing, and tail calls all work unchanged. The new work is purely *shape reconstruction*
at the top, not new lowering.

**Refinement (found during implementation):** the backend's `letrec` is
letrec-*of-lambdas* — `convert-closures` turns every binding into a closure, so a
non-lambda RHS (e.g. `(define bump 1)`) breaks `lower`. So the desugaring splits by case:
- **all-lambda defines** → `(letrec (...) body)` as designed (efficient, unchanged path).
- **value or mixed defines** → the classic `letrec*`→`let`+`set!` transform:
  `(let ([x '()] …) (set! x init) … body)`. Downstream `convert-assignments` boxes the
  mutated bindings, so mutual reference and forward reference still work and the change
  stays **frontend-only** (uses only `let`/`set!`/`quote`, all already supported). The
  trade-off is that top-level *value* bindings get boxed; top-level *procedure*-only
  programs keep the efficient `letrec` path.

**Alternatives considered:**
- *A real top-level environment / global slots.* More faithful to Scheme's actual
  top-level semantics (supports redefinition, forward references across expressions), but
  requires new runtime machinery (global cells) and a new lowering path. Rejected as
  premature — `letrec`/`let`+`set!` cover the M2 programs we need and add zero backend
  surface.
- *Extend the backend to compile non-lambda `letrec` bindings directly.* Would avoid the
  boxing, but violates the frontend-only constraint and duplicates work
  assignment-conversion already does. Rejected for M2.
- *Nest each `define` as a one-binding `let`/`letrec` around the rest.* Equivalent
  result but produces deeper, less legible IL in `--dump`; a single flat `letrec` reads
  better and matches how the pipeline already displays bindings.

### D2 — New pass lives in the frontend, before `recognize-let`

Add a `collect-toplevel` (working name) step as the first pass, producing the core IL
`letrec`. It runs before `recognize-let` so the rest of the chain is untouched. The
`(define (f a...) ...)` shorthand is normalized to `(define f (lambda ...))` inside this
pass, so only one `define` shape reaches the binding builder.

**Alternative:** fold it into `parse.ss`'s existing `parse-body` (which already collapses
a body sequence). Rejected for observability — a distinct named stage is the project's
transparency discipline (`--dump`), and top-level handling is conceptually separate from
expression parsing.

### D3 — Reader reads all forms; trailing expression required

`read-program` loops `read` until EOF, yielding the ordered list of forms. A program
MUST end in an expression (the value); a program that is only `define`s with no trailing
expression is a compile error with a clear message. This keeps "the program has a value"
total and matches the executable's contract (stdout = the value).

## Risks / Trade-offs

- **`letrec` vs `letrec*` ordering** → M1 `letrec` binds mutually but does not guarantee
  left-to-right evaluation of initializers with visibility of earlier values at *init
  time*. For `define`s that are `lambda`s (the overwhelmingly common case) this is
  irrelevant — bodies run at call time. For `define`s whose initializer *uses* an earlier
  `define`'s value immediately, behavior follows the existing `letrec` lowering. Mitigation:
  document this; demos use the lambda-heavy pattern; revisit `letrec*` only if a real
  program needs strict init ordering.
- **Trailing-expression requirement may surprise** users expecting a definitions-only
  file to compile → Mitigation: explicit, tested error message rather than silent
  undefined value.
- **Internal define scope creep** → keep it out of scope unless free; a naive top-level
  desugar must not accidentally accept internal `define` in a way that later needs
  breaking changes. Mitigation: restrict the new pass to top-level position.
