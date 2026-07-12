## 1. Runtime: symbol type + interning

- [x] 1.1 Add `TAG_SYMBOL` (6) and a symbol heap layout holding the name
- [x] 1.2 Add an intern table reachable by `libgc` (GC root) and `rt_intern(const char*)` returning the canonical symbol
- [x] 1.3 `rt_write`: print a symbol by name; confirm `eq?` (existing) now distinguishes symbols by identity
- [x] 1.4 Confirm interning: same name ⇒ same word; different name ⇒ different word

## 2. Codegen: symbol and quoted-structure constants

- [x] 2.1 Emit private string-constant globals for symbol names (correct length + trailing `\00`, escaping)
- [x] 2.2 `encode-const`/emit: a symbol constant → `call i64 @rt_intern(ptr @.str.sym.N)`
- [x] 2.3 A pair constant → emitted `rt_cons(<encode car>, <encode cdr>)`, recursing for nested lists/atoms
- [x] 2.4 Immediates inside quoted structure still encode inline (fixnum/bool/`()`)
- [x] 2.5 Add `declare i64 @rt_intern(ptr)` (and confirm `rt_cons` already declared)

## 3. Demos and tests

- [x] 3.1 Demos: quoted symbol value (prints name), `eq?` on same/different symbols, quoted nested list traversal + print
- [x] 3.2 A demo that interns, drops the reference, allocates heavily, then compares `eq?` (GC-root check)
- [x] 3.3 Add them to `demos/run-tests.sh` with expected values

## 4. Verify

- [x] 4.1 Build and run the demos; confirm symbol printing, `eq?`, and list structure
- [x] 4.2 Run `demos/run-backends.sh`: quote/symbol demos agree across AOT/JIT/bitcode
- [x] 4.3 Confirm existing demos unaffected; frontend/passes untouched (only runtime + emit changed)

## 5. Docs and spec sync

- [x] 5.1 Update `LLVM.md` value-representation section (tag 6 symbols, intern table, quoted-structure materialization, remaining tag budget)
- [x] 5.2 Sync `core-language` (added) and `aot-codegen` (modified) deltas into `openspec/specs/`
