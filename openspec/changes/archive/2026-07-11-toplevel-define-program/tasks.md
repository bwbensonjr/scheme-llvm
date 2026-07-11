## 1. Read all top-level forms

- [x] 1.1 Change `read-program` in `src/compile.ss` to loop `read` until EOF and return the ordered list of forms (instead of a single form)
- [x] 1.2 Error clearly if the file is empty

## 2. Top-level collection + define desugaring pass

- [x] 2.1 Add a `collect-toplevel` pass (new entry in `src/parse.ss`, or a small `src/passes/collect-toplevel.ss`) that takes the list of source forms and produces one core `(letrec ([x e] ...) <last-expr>)`
- [x] 2.2 Normalize `(define (f arg ...) body ...)` to `(define f (lambda (arg ...) body ...))` before building bindings
- [x] 2.3 Handle `(define x e)`: contribute binding `[x (parse-expr e)]`
- [x] 2.4 Use the trailing top-level expression as the `letrec` body (the program's value)
- [x] 2.5 Error with a clear message if the program has no trailing expression (definitions only)
- [x] 2.6 Restrict `define` handling to top-level position (do not accept internal `define` as a new feature)

## 3. Pipeline wiring and observability

- [x] 3.1 Insert the new pass as the first stage in `compile-file`, feeding its `letrec` into `rename-program`/`parse` → `recognize-let` → existing chain
- [x] 3.2 Add the new stage to `--dump` output, before `recognize-let`
- [x] 3.3 Confirm single-expression programs still flow through unchanged (one-form case yields the same IL as M1)

## 4. Demos and tests

- [x] 4.1 Add a multi-`define` demo under `demos/` exercising `(define x e)`, the `(define (f ...) ...)` shorthand, and mutual reference between definitions, with a trailing expression
- [x] 4.2 Add the new demo to `demos/run-tests.sh` with its expected value
- [x] 4.3 Confirm all existing M1 demos still pass unchanged

## 5. Verify end to end

- [x] 5.1 Build and run the new demo; confirm the executable reports the last expression's value
- [x] 5.2 Run `--dump` on the new demo and confirm each stage (including the new one) prints in order
- [x] 5.3 Confirm `grep`/inspection shows no changes to `src/runtime/runtime.c`, `src/emit.ss`, or `src/passes/{convert-assignments,convert-closures,lower,recognize-let}.ss`

## 6. Spec sync

- [x] 6.1 After implementation, sync the `core-language` and `aot-codegen` delta specs into `openspec/specs/` (via the sync/archive workflow)
