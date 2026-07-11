## 1. The expand pass

- [x] 1.1 Add `expand` (new `src/passes/expand.ss`, or a section of `src/parse.ss`) as a source→source pass recursing over the whole program expression
- [x] 1.2 Expand `cond` (with `else`; require a body per clause) to nested `if`/`begin`
- [x] 1.3 Expand `and` to short-circuit `if` chains (no temp needed)
- [x] 1.4 Expand `or` to `(let ([t e]) (if t t <rest>))` using a fresh name for `t`
- [x] 1.5 Expand `when` / `unless` to `if` + `begin`
- [x] 1.6 Expand `let*` to nested `let` (empty bindings → `begin`)
- [x] 1.7 Expand named `let` to `letrec` + immediate call, preserving tail position
- [x] 1.8 Recurse into all subforms (bodies of `lambda`/`let`/`letrec`/`define`, arms of `if`, args of calls) so derived forms nest freely
- [x] 1.9 Draw fresh names from the existing rename counter (reset per program)

## 2. Pipeline wiring and observability

- [x] 2.1 Insert `expand` in `compile-file` between `collect-toplevel` and `parse`
- [x] 2.2 Add the `expand` stage to `--dump`, after `collect-toplevel`
- [x] 2.3 Confirm programs with no derived forms pass through `expand` unchanged

## 3. Demos and tests

- [x] 3.1 Add a demo exercising `cond`, `and`/`or`, `when`/`unless`, `let*`, and a named-`let` loop, including a derived form inside a top-level `define` body
- [x] 3.2 Add a tail-recursive named-`let` (or `cond`-in-tail) demo to confirm bounded stack
- [x] 3.3 Add the demos to `demos/run-tests.sh` with expected values

## 4. Verify end to end

- [x] 4.1 Build and run the demos; confirm correct values and short-circuit semantics
- [x] 4.2 Run `--dump` and confirm `expand` prints after `collect-toplevel` and rewrites the derived forms to core
- [x] 4.3 Confirm all existing M1/M2 demos still pass unchanged
- [x] 4.4 Confirm no changes to `src/runtime/runtime.c`, `src/emit.ss`, or `src/passes/{recognize-let,convert-assignments,convert-closures,lower}.ss`

## 5. Spec sync

- [x] 5.1 Sync the `core-language` (added requirement) and `aot-codegen` (modified stage-dump) deltas into `openspec/specs/`
