## 1. Frontend: parse + lower variadic lambdas

- [x] 1.1 `parse`: accept dotted rest `(lambda (a b . rest) …)` and all-args `(lambda args …)`, lowering to a lambda IL that records fixed params + the rest name
- [x] 1.2 `rename`/`free-vars`: treat the rest parameter as an ordinary bound variable
- [x] 1.3 `lower`: record `(fixed-count, rest-name|#f)` on each `code` def; keep fixed-arity lambdas identical to today

## 2. Codegen: variadic callee + arity check

- [x] 2.1 `emit-code-def`: for a variadic code def, emit a prologue binding `rest` to a list built from the positional excess (`a{f}..`, real per `argc`) plus `overflow`
- [x] 2.2 `emit-code-def`: for a fixed-arity code def, emit an `argc` arity check (`argc == f`, else arity error); variadic checks `argc >= f`
- [x] 2.3 Keep the fixed-arity hot path allocation-free (rest-building only in variadic callees)

## 3. Codegen + runtime: apply

- [x] 3.1 Recognize `(apply f a1 … aN lst)` in the frontend and lower it to an apply call site
- [x] 3.2 `emit`: fill positional slots with `a1..` up to `K`, spill the remaining fixed args + `lst` elements into an `overflow` vector, set `argc = N + length(lst)`
- [x] 3.3 Runtime: `rt_build_rest` (positional excess + overflow → list), `rt_spread`/list→overflow for apply, and `rt_arity_error` (message + abort)

## 4. Demos and tests

- [x] 4.1 Demos: dotted rest, all-args variadic, `apply` over a list longer than `K`, and an arity-error case
- [x] 4.2 Add them to `demos/run-tests.sh` (arity-error demo checks non-zero exit)

## 5. Verify

- [x] 5.1 Build and run the demos; confirm correct values and the arity-error abort
- [x] 5.2 Run `demos/run-backends.sh`: all demos (incl. variadic/apply/arity-error) agree across AOT/JIT/bitcode
- [x] 5.3 Confirm `countdown`/`namedloop` still bounded-stack (musttail) and hot path allocation-free
- [x] 5.4 Inspect IR: overflow populated for variadic/apply calls, `ptr null` for fixed-arity

## 6. Docs and spec sync

- [x] 6.1 Update `LLVM.md` Calling convention (argc/overflow now consumed; rest + apply lowering)
- [x] 6.2 Sync `core-language` (added) and `aot-codegen` (modified) deltas into `openspec/specs/`
