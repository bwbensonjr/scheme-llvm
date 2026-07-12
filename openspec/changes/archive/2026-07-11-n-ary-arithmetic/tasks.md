## 1. Fold in the expand pass

- [x] 1.1 In `src/passes/expand.ss`, detect `(+ …)`, `(- …)`, `(* …)` and fold to nested binary `primcall`s (expand operands first)
- [x] 1.2 Identities: `(+)` → `0`, `(*)` → `1`; single-arg `(+ a)`/`(* a)`/`(- a)` handled (`(- a)` → `(- 0 a)`)
- [x] 1.3 Left-associative fold for ≥2 args, preserving left-to-right operand order
- [x] 1.4 `(-)` with no args → clear compile-time error
- [x] 1.5 Confirm binary calls (exactly 2 operands) are emitted unchanged

## 2. Demos and tests

- [x] 2.1 Add a demo exercising n-ary `+`/`*`/`-`, unary negation, identities, and nested arithmetic inside another form
- [x] 2.2 Add it to `demos/run-tests.sh` with the expected value

## 3. Verify

- [x] 3.1 Build and run the demo; confirm correct values
- [x] 3.2 Run `demos/run-backends.sh`: all demos agree across AOT/JIT/bitcode
- [x] 3.3 Confirm all existing demos still pass unchanged (binary calls unaffected)
- [x] 3.4 Confirm no changes to `src/emit.ss`, `src/runtime/runtime.c`, or the other passes

## 4. Spec sync

- [x] 4.1 Sync the `core-language` added requirement into `openspec/specs/`
