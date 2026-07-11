## Why

The core subset is verbose: multi-way branching means nested `if`, there is no
short-circuit `and`/`or`, no `when`/`unless`, no sequential `let*`, and no named-`let`
loop. Every non-trivial program (including the compiler's own source, the self-hosting
target) leans on these forms. Adding them now is cheap — they all desugar to existing
core forms — and it doubles as a deliberate rehearsal of the source→source rewriting the
future macro expander will generalize.

## What Changes

- Add a new **`expand`** frontend stage: a source→source pass that rewrites derived forms
  into the existing core (`if`, `let`, `letrec`, `begin`, application). It runs after
  `collect-toplevel` and before `parse`, and is observable under `--dump`.
- Support these derived forms:
  - `(cond [test body ...] ... [else body ...])` → nested `if`
  - `(and e ...)` / `(or e ...)` → short-circuit `if` chains (`or` binds a fresh temp so
    each operand is evaluated once)
  - `(when test body ...)` / `(unless test body ...)` → `if` + `begin`
  - `(let* ([x e] ...) body ...)` → nested `let`
  - named `let`: `(let name ([x e] ...) body ...)` → `(letrec ([name (lambda (x ...) body ...)]) (name e ...))`
- **BREAKING (minor):** the new form keywords (`cond and or when unless let*`) become
  reserved, like the existing primitive names — they can no longer be used as ordinary
  variable names.
- **Frontend-only.** No changes to the runtime, the value representation, the emitter, or
  the existing core passes.

## Capabilities

### New Capabilities
<!-- None: derived forms desugar into the existing core language. -->

### Modified Capabilities
- `core-language`: add a requirement that the compiler accepts the derived syntactic
  forms above and compiles them with the same semantics as their core expansions.
- `aot-codegen`: the "Each pipeline stage is independently observable" requirement's
  stage list gains the new `expand` stage in `--dump`, after `collect-toplevel`.

## Impact

- **Code (frontend only):**
  - New `src/passes/expand.ss` (or a section of `src/parse.ss`) implementing the `expand`
    pass; `or` and any temp-introducing desugaring draw fresh names from the existing
    rename counter.
  - `src/compile.ss` — insert `expand` between `collect-toplevel` and `parse`; add its
    `--dump` line.
  - `demos/` — a demo exercising the new forms; `demos/run-tests.sh` covers it.
- **Unaffected:** `src/runtime/runtime.c`, `src/emit.ss`, `src/passes/{recognize-let,
  convert-assignments,convert-closures,lower}.ss`.
- **Deferred (noted, not built):** `case`, `cond` with `=>` and bare-test clauses,
  `quasiquote`, `do`, `delay`/`force` — these arrive with the macro system.
