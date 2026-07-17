## 1. Runtime: hash primitive

- [x] 1.1 `rt_hash(x)`: fixnum→self, immediates→raw word, symbol→FNV-1a over name, string/bytevector→FNV-1a over bytes, pair/vector→bounded shallow fold; return non-negative tagged fixnum (masked to 60 bits)
- [x] 1.2 Assert (in a comment + demo) that `equal?` values hash equally

## 2. Runtime: hash-table object and printer

- [x] 2.1 Add `HDR_HASHTABLE` (header code 4); payload = one slot to a spine vector `#(count buckets _)`
- [x] 2.2 `rt_make_hash_table(spine)` / `rt_hash_table_spine(ht)` accessor / `rt_hash_table_p(ht)` predicate
- [x] 2.3 Add a `TAG_EXT`/`HDR_HASHTABLE` printer arm rendering `#<hash-table N>` (N = count)

## 3. Frontend + codegen: wire the primitives

- [x] 3.1 `parse.ss`: add `%hash %make-hash-table %hash-table? %hash-table-spine` to `*prims*`
- [x] 3.2 `emit.ss`: add each to `prim-table` (→ `rt_*`) and emit its `declare` (all arity 1)
- [x] 3.3 Confirm the fixed-arity `primcall` path emits them unchanged (arity from the call site + declares)

## 4. Prelude: hash-table structure and operations

- [x] 4.1 `make-hash-table`: allocate spine (8 buckets, count 0) via `%make-hash-table`
- [x] 4.2 `hash-table?` (over `%hash-table?`) and internal spine/count/buckets accessors
- [x] 4.3 Bucket index helper: `(remainder (%hash key) nbuckets)` (== modulo; `%hash` is non-negative)
- [x] 4.4 `hash-table-set!`: scan bucket for `equal?` key (rebuild alist to replace, since pairs are immutable / prepend), bump count, grow past load factor
- [x] 4.5 Grow/rehash: allocate ~2x bucket vector and reinsert all entries onto the spine in place
- [x] 4.6 `hash-table-ref/default`, `hash-table-contains?`, `hash-table-delete!` (bucket scans)
- [x] 4.7 `hash-table-ref` (= ref/default with `error` on absence)
- [x] 4.8 `hash-table-size`, `hash-table-keys`, `hash-table-values`, `hash-table->alist` (walk buckets)
- [x] 4.9 Regenerate `lib/scheme/base.sld` from `src/prelude.scm` — note the bootstrap ordering: the seed compiler must know the new prims before `base.sld` references them, so regen the compiler with the old `base.sld` first, then regen `base.sld` + bootstrap again (see design "Migration")

## 5. Demos and tests

- [x] 5.1 Demo: set + `hash-table-ref/default` retrieval
- [x] 5.2 Demo: missing key returns default; overwrite an `equal?` key
- [x] 5.3 Demo: delete then `hash-table-contains?` => `#f`
- [x] 5.4 Demo: insert 100 distinct keys, assert size = 100 and all retrievable (exercises growth)
- [x] 5.5 Demo: `hash-table?` on a table and a non-table (vector); opaque print `#<hash-table N>` (hash-print demo)
- [x] 5.6 Demo: `(= (%hash "abc") (%hash (string-append "ab" "c")))` => `#t`
- [x] 5.7 Add the demos to `demos/run-tests.sh` (and `demos/run-backends.sh`) with expected values

## 6. Verify

- [x] 6.1 Build and run the demos; confirm set/ref/delete/contains/size/keys/growth/printing (scheme-run + REPL)
- [x] 6.2 `demos/run-backends.sh`: the new demos agree across AOT/JIT/bitcode (GC: tables survive rehash) — 46/46
- [x] 6.3 Confirm existing demos unaffected (run-all-tests.sh 6/6; refreshed the byte-identity baseline for the ABI growth)

## 7. Docs and spec sync

- [x] 7.1 Add the `HDR_HASHTABLE` row to `LLVM.md` and `src/README.md`; update root `README.md` status
- [x] 7.2 Sync the `core-language` (modified) delta into `openspec/specs/` (done at archive time via `openspec archive`)
