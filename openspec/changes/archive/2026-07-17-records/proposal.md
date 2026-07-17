## Why

The README lists **records** under "Not yet done → Data" (with "(vectors done)"). Records are
R7RS-small's user-defined product type — `define-record-type` — giving named, disjoint
structures with a constructor, a type predicate, and field accessors/mutators. They are the
last missing data type and the standard way to model structured data without overloading
vectors or pairs; they also give the compiler a principled way to represent its own IR nodes
down the line.

## What Changes

- **Runtime — new data type** — a record instance as a tag-7 extended heap object with a new
  header code `HDR_RECORD`: layout `{HDR_RECORD, type-descriptor, field0, …, field{n-1}}`,
  where the type-descriptor is a per-type runtime token used by the predicate to make records
  of distinct types disjoint. Add primitives `%make-record-type`, `%make-record`,
  `%record-ref`, `%record-set!`, `%record-of-type?`, and `%record?`.
- **Frontend — `define-record-type`** — a built-in definition form lowered by the frontend (in
  `collect-toplevel`, where top-level defines are understood — see design D3; the proposal
  originally said "expander", but `collect-toplevel` runs before `expand`, so a binding-
  introducing form must be handled there) that lowers an R7RS `(define-record-type name
  (constructor field …) predicate (field accessor [mutator]) …)` form into: one fresh type
  descriptor, a constructor, a predicate, and the per-field accessors/mutators, all defined over
  the record primitives. The REPL lowers it equivalently into a persistent-global group.
- **Runtime — printer** — a record instance prints opaquely as `#<record TYPE>` using the
  type's name; records are not readable.
- **Equality** — records use identity: two record instances are `equal?` (and `eqv?`) iff they
  are the same object. `equal?` does not recurse into record fields.

## Capabilities

### New Capabilities
<!-- The record type is modeled as a core-language addition; see Modified Capabilities. -->

### Modified Capabilities
- `core-language`: add the record data type, the `define-record-type` form, and the record
  runtime primitives that back it.
- `macro-system`: recognize `define-record-type` as a built-in definition form lowered by the
  frontend before `expand` (in `collect-toplevel`), leaving no residual form for later stages.

## Impact

- **Code:**
  - `src/runtime/runtime.c` — `HDR_RECORD`; `rt_make_record_type`, `rt_make_record`,
    `rt_record_ref`, `rt_record_set`, `rt_record_of_type_p`, `rt_record_p`; a printer arm; an
    identity arm in `rt_equal` (records compare by object identity).
  - `src/parse.ss` — add the record primitives to `*prims*`.
  - `src/emit.ss` — add each to `prim-table` and emit its `declare`.
  - `src/parse.ss` — lower `define-record-type` in `collect-toplevel` / `build-body`
    (`record-type-bindings`) and in the REPL's `repl-lower-form*`.
  - `src/prelude.scm` — any helper glue for the lowering, if needed.
  - `demos/` — a `define-record-type` demo (constructor, predicate, accessors, mutator),
    a two-types-are-disjoint demo, and a printing demo.
- **Verification:** `demos/run-tests.sh` and `demos/run-backends.sh` (3-way) with the new demos.
- **Representation:** adds a header code under the existing tag-7 extended-object mechanism; the
  8-tag scheme and calling convention are unchanged, so `aot-codegen` is untouched. `LLVM.md`
  and `src/README.md` gain the `HDR_RECORD` row.
- **Depends on:** the macro/expander stage (present) and the extended-object mechanism (present).
- **Enables:** user-defined structured data; a principled representation for compiler IR nodes;
  a foundation for a future condition-type hierarchy in the exception system.
