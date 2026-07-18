## 1. Primitive floor (D0) — compiler-intrinsic (DECIDED: intrinsic floor, no linked artifact)

- [x] 1.1 Decided the mechanism: compiler-intrinsic floor (recorded in design.md D0). Plain names are an intrinsic integrable set; direct calls inline to `%op`, value uses eta-synthesize; universal by construction (no import, no `primitive-layer.ll`).
- [x] 1.2 Introduce the intrinsic integrable set (`*integrable*`, name→`%`-op+arity) in `compute-known`; `cons` removed from `*prims*`, `%cons` added. (Batch A: cons only so far.)
- [~] 1.3 Chez host shim — NOT NEEDED under the intrinsic floor: `%`-ops appear only in compiler-generated IL, never in prelude source, so `read-all-tests` (loads prelude under Chez) passes unchanged (6/6). Marked moot; revisit only if a future primitive puts a `%`-op in source loaded under Chez.
- [x] 1.4 Regression guards verified (Chez driver): a library using `cons` without importing `(scheme base)` → `(5 . 6)`; a `--no-prelude` program using `cons` → works. Both were spike failures. (Add to the automated suite in a later task.)

## 2. Shadow-aware inliner (D1)

- [~] 2.1 Integrable table (`*integrable*`) covers all shipped fixed-arity prims (`cons` + the 30-prim Batch A); variadic fold/identity (for `+ - * = <`, `string-append`) pending Batch B
- [x] 2.2 `inline-primitives` pass added and wired into all three paths (compile-forms, compile-program-with-imports, repl-lower-form). Shadow-awareness is free: rename makes any shadow unique, so an unshadowed integrable survives as its bare symbol — no `bound`/`find-assigned` threading needed
- [x] 2.3 Document the new stage in `docs/PIPELINE.md` with its input/output IL shape (added to the pipeline diagram, a prose paragraph on shadow-awareness / dev-ship fidelity, and a stage-table row)
- [x] 2.4 Verified (cons): a direct unshadowed `(cons a b)` emits bare `@rt_cons`, zero wrapper refs — matches baseline codegen

## 3. Staged bootstrap rollout (D3) — repeat per batch

- [x] 3.1 Batch A (fixed-arity) **shipped** in two direct-regen slices (both converged; the staged 2-regen was unnecessary for this shape — see the D3 lesson in design.md):
  - slice 1 (commit 0a18580): `cons`.
  - slice 2 (commit 4303bf0): the 30 single-signature fixed-arity prims — `quotient remainder car cdr null? pair? equal? not char->integer integer->char string-length string-ref string->symbol symbol->string list->string string-set! vector-ref vector-set! vector-length vector? bytevector-u8-ref bytevector-u8-set! bytevector-length bytevector? symbol? string? char? boolean? integer? exact?`.
  - `eqv?` (from the original task list) is **deferred to Batch B**: it is expander-folded (`expand-compare`) alongside `= < > <= >= eq?`, so it moves with that family. The R7RS optional-arity ops (`make-*`, `substring`, `string-copy`, `string=?`) are also deferred. `scheme.base.ll` byte-identical both slices; fixed point + Chez re-derivation green.
- [ ] 3.2 Batch B (variadic: `+ - * = <`, `string-append`): same 2-regen; keep the expander fold (D2) emitting binary raw primcalls for literal calls
- [ ] 3.3 Remaining primitives in further batches until all are layer-exposed
- [ ] 3.4 Commit regenerated `bootstrap/*.ll` at each stable stage; trust-check clean

## 4. Cleanup and reconcile

- [~] 4.1 Retire the eta special-case: `*prim-eta-arity*` + `nsyms` deleted, `prim-as-value` reduced to the sole variadic `string-append` case (commit 4303bf0). Full retirement of `prim-as-value` waits on Batch B making `string-append` (and the other variadic ops) integrable.
- [ ] 4.2 Reconcile remaining "reserved primitive" wording in `core-language` specs/comments with the new model
- [ ] 4.3 (Optional, later) Unify the expander n-ary fold into the table-driven inliner (D2 follow-up), deleting `fold-arith`/`expand-string-append`

## 5. Verification

- [ ] 5.1 Full `./run-dev-tests.sh` green (all suites, including the new library / `--no-prelude` guards)
- [ ] 5.2 First-class + shadow behavior confirmed for a representative primitive of each kind (fixed, variadic, predicate)
- [ ] 5.3 Binary-size and self-host regen-time within noise of baseline (inliner recovers the un-inlined cost the spike measured)
- [ ] 5.4 `make catalogue` refreshed
