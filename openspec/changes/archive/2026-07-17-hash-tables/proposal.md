## Why

The README lists **hash tables** under "Not yet done → Data." Hash tables are the mutable,
amortized-O(1) key→value map — the workhorse aggregate the compiler itself wants (symbol
tables, intern maps, dedup sets) and the last of the three missing data types. R7RS-small does
not standardize hash tables, so this change adopts the widely-implemented SRFI-69 surface
(`make-hash-table`, `hash-table-set!`, `hash-table-ref`, …) as a pragmatic, minimal API.

## What Changes

- **Runtime — hash primitive** — a `%hash` primitive mapping any value to a fixnum hash code
  (identity for symbols/fixnums/chars/booleans; content hash for strings), so the table can
  bucket keys. This is the only new runtime code; the table structure itself is built in Scheme.
- **Prelude — hash-table type built on vectors** — a hash table represented as a mutable
  aggregate holding a bucket vector (each bucket an association list) and an element count,
  with `equal?`-keyed lookup and automatic rehash/grow on load factor. Operations:
  `make-hash-table`, `hash-table?`, `hash-table-set!`, `hash-table-ref`,
  `hash-table-ref/default`, `hash-table-delete!`, `hash-table-contains?`, `hash-table-size`,
  `hash-table-keys`, `hash-table-values`, `hash-table->alist`.
- **Runtime — printer (minimal)** — hash tables print as an opaque `#<hash-table N>` (element
  count `N`); they are not readable.

## Capabilities

### New Capabilities
<!-- The hash-table type is modeled as a core-language addition; see Modified Capabilities. -->

### Modified Capabilities
- `core-language`: add the hash-table data type and its SRFI-69-style operations, plus the
  `%hash` primitive that backs it.

## Impact

- **Code:**
  - `src/runtime/runtime.c` — `rt_hash(x)` primitive (fixnum/symbol/char/boolean by identity,
    string by content); optionally a `HDR_HASHTABLE` tag purely so the printer/predicate can
    recognize a table opaquely (see design D1 for the tagged-vector-vs-header trade-off).
  - `src/parse.ss` — add `%hash` (and, if header-backed, `%make-hash-table`/`%hash-table?`) to `*prims*`.
  - `src/emit.ss` — add the new primitive(s) to `prim-table` and emit their `declare`s.
  - `src/prelude.scm` — the hash-table structure and all `hash-table-*` operations, built on
    vectors + `%hash` + `equal?`; automatic grow/rehash.
  - `demos/` — set/ref/default/delete/contains?/size/keys demos, a grow-past-load-factor demo,
    and a printing demo.
- **Verification:** `demos/run-tests.sh` and `demos/run-backends.sh` (3-way) with the new demos.
- **Representation:** at most one header code under the existing tag-7 mechanism (or none, if
  the tagged-vector representation is chosen); the 8-tag scheme and calling convention are
  unchanged, so `aot-codegen` is untouched.
- **Depends on:** `vectors` (the bucket store) and `equal?` (key comparison) — both present.
- **Enables:** compiler-internal maps/sets; a future move of the symbol intern table into
  Scheme; SRFI-69 growth (`hash-table-update!`, `hash-table-walk`, custom eq/hash).
