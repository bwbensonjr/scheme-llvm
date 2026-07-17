## 1. Runtime: record data type and primitives

- [x] 1.1 Add `HDR_RECORD` (header code 5) + `HDR_RECORD_TYPE` (6); layout `{HDR_RECORD, type-descriptor, field…}`
- [x] 1.2 `rt_make_record_type(name)`: allocate a fresh `{HDR_RECORD_TYPE, name-string}` descriptor token (identity distinguishes types)
- [x] 1.3 `rt_make_record(td, field-list)`: allocate `{HDR_RECORD, td, field…}`, walking the list into the slots
- [x] 1.4 `rt_record_ref(r, i)`: return field `i` (UNFIX index)
- [x] 1.5 `rt_record_set(r, i, x)`: store field `i` in place; return unspecified
- [x] 1.6 `rt_record_of_type_p(r, td)`: `#t` iff `HDR_RECORD` and descriptor `eq?` to `td`
- [x] 1.7 `rt_record_p(r)`: `#t` iff any `TAG_EXT`/`HDR_RECORD` (guard the header deref behind the `TAG_EXT` check)

## 2. Runtime: printer and equality

- [x] 2.1 Add `TAG_EXT`/`HDR_RECORD` (→ `#<record TYPE>`) and `HDR_RECORD_TYPE` (→ `#<record-type TYPE>`) printer arms (name from the descriptor)
- [x] 2.2 Identity equality: no `rt_equal` arm needed — the `a == b` fast path gives identity, and distinct records fall through to `#f` (no ext arm matches `HDR_RECORD`); `eqv?` likewise

## 3. Frontend + codegen: wire the primitives

- [x] 3.1 `parse.ss`: add `%make-record-type %make-record %record-ref %record-set! %record-of-type? %record?` to `*prims*`
- [x] 3.2 `emit.ss`: add each to `prim-table` (→ `rt_*`) and emit its `declare` (arities 1,2,2,3,2,1)
- [x] 3.3 Confirm the fixed-arity `primcall` path emits them unchanged

## 4. Frontend: define-record-type lowering

- [x] 4.1 Lower `define-record-type` in `collect-toplevel` / `build-body` (parse.ss) — NOT the syntax-rules expander: `collect-toplevel` runs before `expand`, so a definition-introducing form must be lowered where top-level defines are understood (design revised; see design D3 + Migration)
- [x] 4.2 Parse the form: type name, `(constructor field …)`, predicate, `(field accessor [mutator]) …`
- [x] 4.3 Assign field indices by body field-tag order; constructor builds the field list in body order (unlisted field → unspecified)
- [x] 4.4 Emit: fresh `<rtd>` binding via `%make-record-type` (a `fresh-name` descriptor, referenced by the other bindings)
- [x] 4.5 Emit constructor `(lambda (a …) (%make-record <rtd> (list …)))`
- [x] 4.6 Emit predicate `(lambda (o) (%record-of-type? o <rtd>))`
- [x] 4.7 Emit each accessor `(%record-ref o i)` and each mutator `(%record-set! o i v)`
- [x] 4.8 Confirm collect-toplevel/build-body leave no residual `define-record-type` (any-define? updated so a misplaced record def errors like a misplaced define)
- [x] 4.9 REPL support: `repl-lower-form*` registers the record's names as a mutually-visible persistent-global group and emits a core-IL `seq` chain of `global-set!` stores (dev→ship fidelity)

## 5. Demos and tests

- [x] 5.1 Demo: `define-record-type point`; constructor + `point-x`/`point-y` accessors
- [x] 5.2 Demo: predicate `point?` true on a point, false on a non-record and on another record type
- [x] 5.3 Demo: mutator `set-point-x!` then read back
- [x] 5.4 Demo: two distinct record types are disjoint
- [x] 5.5 Demo: opaque print `#<record point>` (record-print demo); identity equality (`equal?` same object vs two fresh)
- [x] 5.6 Add the demos to `demos/run-tests.sh` (and `demos/run-backends.sh`) with expected values

## 6. Verify

- [x] 6.1 Build and run the demos; confirm construction, predicate, access, mutation, disjointness, printing (scheme-run + REPL)
- [x] 6.2 `demos/run-backends.sh`: the new demos agree across AOT/JIT/bitcode (GC: records + descriptors survive) — 48/48
- [x] 6.3 Confirm existing demos unaffected; the expander/collect-toplevel change leaves non-record programs unchanged (byte-identity baseline refreshed for the ABI growth). Note: the records demo was made evaluation-order-independent (JIT and AOT differ on `list` argument order, which R7RS leaves unspecified)

## 7. Docs and spec sync

- [x] 7.1 Add the `HDR_RECORD` / `HDR_RECORD_TYPE` rows to `LLVM.md` and `src/README.md`; update root `README.md` status
- [x] 7.2 Sync the `core-language` and `macro-system` (modified) deltas into `openspec/specs/` (done at archive time via `openspec archive`)
