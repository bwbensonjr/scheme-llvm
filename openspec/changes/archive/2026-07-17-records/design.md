## Context

The value representation is one 64-bit tagged word; tag 7 (`TAG_EXT`) is an extended heap
object whose first word is a header code (`HDR_STRING` 0, `HDR_VECTOR` 2, `HDR_ERROR` 3; code 1
free). New heap types add a header code "without needing a new primary tag." The compiler has a
fixpoint `expand` stage that is hygienic for macro-introduced identifiers and already hosts a
**built-in expander transformer** for `quasiquote` (a form lowered by the expander itself
rather than by a user `syntax-rules` rule). `define-record-type` cannot be a plain
`syntax-rules` macro: each expansion must mint a *fresh, disjoint type* at run time and bind a
variable number of accessors/mutators, so it is lowered the same way `quasiquote` is — a
built-in transformer emitting core forms over runtime record primitives.

Error objects (`HDR_ERROR`) are the existing precedent for a fixed-shape heap record; a record
instance generalizes that to a per-type descriptor plus N fields.

## Goals / Non-Goals

**Goals:**
- The R7RS-small `define-record-type` form: constructor, type predicate, field
  accessors, optional field mutators.
- Disjoint types: each type's predicate is true only for its own instances.
- A record instance as a tag-7 object `{HDR_RECORD, type-descriptor, field…}`.
- Opaque printing `#<record TYPE>`; identity equality (`eqv?`/`equal?` by object).

**Non-Goals:**
- R7RS-large / SRFI-99 procedural or inspection layer (`record-type-descriptor`,
  `record-accessor`, field introspection) — the declarative `define-record-type` only.
- Single-inheritance / subtyping, sealed/opaque attributes, mutable type redefinition.
- Structural `equal?` over record fields — records are identity types (matches common practice
  and avoids cycles-through-records questions).
- Non-full constructors that initialize a subset of fields with a custom argument order beyond
  what the `(constructor field …)` clause lists (R7RS allows the constructor to name a subset;
  ship the full-field-list common case first, note the subset case in Open Questions).

## Decisions

### D1 — Record instance: tag-7 object with `HDR_RECORD` and a type descriptor

A record is `TAG_EXT` with first word `HDR_RECORD` (the next free header code). The second word
is a **type descriptor**: a runtime token unique per `define-record-type` occurrence, against
which the predicate compares. Remaining words are the field slots (tagged `i64`, like vector
elements):

```
{ HDR_RECORD, type-descriptor, field0, field1, …, field{n-1} }
```

The type descriptor is itself a small heap object minted by `%make-record-type` (carrying at
least the type's name, for printing, and serving as an identity token). Two records are the
same type iff their descriptors are `eq?`. This makes disjointness automatic and cheap.

### D2 — Runtime primitives (fixed arity, tagged in/out)

- `%make-record-type(name)` → a fresh type-descriptor token (a `TAG_EXT` object holding the
  name string; identity distinguishes types).
- `%make-record(td, field-list)` → allocate `{HDR_RECORD, td, field…}` from a list of field
  values. (Arity is fixed; the constructor closure built by the lowering gathers its fixed
  arguments into the field list — or a small family `%make-record{1,2,3,…}` is emitted; see D3.)
- `%record-ref(r, i)` → field `i` (0-based; `UNFIX` the index).
- `%record-set!(r, i, x)` → store field `i` in place; return unspecified.
- `%record-of-type?(r, td)` → `#t` iff `r` is `HDR_RECORD` and its descriptor is `eq?` to `td`.
- `%record?(r)` → `#t` iff `r` is any record (`TAG_EXT`/`HDR_RECORD`).

All are guarded behind the `TAG_EXT` check before dereferencing the header, as `vector?` does.

### D3 — `define-record-type` lowering (frontend, at `collect-toplevel`)

**Revised during implementation.** The proposal framed this as a built-in *expander*
transformer, modeled on `quasiquote`. But in this compiler the pipeline is
`collect-define-syntax → collect-toplevel → expand → parse` (see `core.ss`): `collect-toplevel`
runs **before** `expand` and folds the whole program's top-level `define`s into a single
`letrec`/`let` body. A form that *introduces bindings* (constructor, predicate, accessors — not
one expression like `quasiquote`) must therefore be recognized where top-level defines are
understood — `collect-toplevel` — not in the syntax-rules expander, which by then sees only the
folded body. So `define-record-type` is lowered in `parse.ss` (`record-type-bindings`, wired
into `collect-toplevel` and the internal-define `build-body`), producing a list of `(name init)`
binding pairs:

```scheme
(<rtd>  (%make-record-type "name"))                 ; fresh descriptor binding, once
(ctor   (lambda (f …) (%make-record <rtd> (list <field0|'()> …))))  ; field list in body order
(pred   (lambda (o) (%record-of-type? o <rtd>)))    ; type predicate
(acc    (lambda (o) (%record-ref o <i>)))           ; per field, <i> = body field index
(mut    (lambda (o v) (%record-set! o <i> v)))      ; per field with a mutator clause
```

Field indices follow the body field-tag order; the constructor builds its field list in that
order, placing each listed constructor field and leaving any unlisted field unspecified (`'()`),
which covers R7RS's subset-constructor case. `<rtd>` is a `fresh-name` symbol shared by the
generated bindings. Because the output is ordinary `(name init)` pairs over primcalls/lambdas,
`expand` and all later passes and all three backends handle records with no further change (one
compilation path). The **REPL** cannot fold a whole program, so `repl-lower-form*` handles
`define-record-type` in parallel: it registers the record's names as one mutually-visible
persistent-global group and emits a core-IL `seq` chain of `global-set!` stores.

The observable behavior (every `core-language` scenario) is identical to the proposal; only the
*stage* that performs the lowering changed. See the `macro-system` delta and the Migration note.

Fixed-arity `%make-record`: the runtime primitive is fixed-arity, so the lowering passes fields
as a *list* (`(list a …)`) to a single `%make-record(td, list)` primitive, which walks the list
into the allocated slots. This avoids emitting a `%make-record-N` family per arity.

### D4 — Printer renders `#<record TYPE>`

The tag-walking printer gains a `TAG_EXT`/`HDR_RECORD` arm: print `#<record `, then the type
descriptor's name string, then `>`. Opaque `#<…>` matches the non-readable convention (as
hash tables also use).

### D5 — Identity equality

`rt_equal` (and `eqv?`) treat records as identity types: equal iff the same object (pointer).
**No `rt_equal` arm is needed** — the existing `a == b` fast path already returns `#t` for the
same object, and a distinct record matches none of the `HDR_STRING`/`HDR_VECTOR`/`HDR_BYTEVECTOR`
arms, so it falls through to `#f`. `eqv?` behaves the same. Rationale: R7RS does not require
structural record equality, fields can form cycles, and identity is the least-surprising default;
a user can define their own field-wise comparison.

## Risks / Trade-offs

- **Header codes** → resolved: `bytevectors`=1, `hash-tables`=4 landed first, so records take
  `HDR_RECORD`=5 and `HDR_RECORD_TYPE`=6. Header codes are a full word (not limited to 8 like
  primary tags), so this is unconstrained.
- **Constructor field-subset case** → R7RS allows the constructor clause to name a subset of
  fields in any order. The lowering handles this: the constructor builds its field list in body
  order, emitting the matching constructor parameter for a listed field and `'()` (unspecified)
  for an unlisted one.
- **Lowering location vs the proposal** → the proposal said "expander transformer"; because
  `collect-toplevel` runs before `expand`, the lowering had to move there (D3). Two lowering
  sites result (batch `collect-toplevel`/`build-body` and the REPL's `repl-lower-form*`), a mild
  duplication justified by the REPL's per-form persistent-global model; both share
  `record-type-bindings`, so the binding shapes cannot drift.
- **Type descriptor lifetime under GC** → the descriptor is referenced by every instance's
  second word and by the generated `<rtd>` binding; both are live roots the collector scans, so
  descriptors survive as long as any instance does.
- **No introspection** → without a procedural layer, generic printers/serializers can't walk
  record fields; acceptable for the declarative subset, revisited if a consumer needs it.

## Migration Plan

Unlike `hash-tables`, the record primitives are **not used by the prelude/(scheme base)** — only
by lowered user programs — so `lib/scheme/base.sld` does not reference them and a single
`make regen` suffices (no two-step compiler bootstrap). Steps: edit source (runtime + parse.ss +
emit.ss), `make regen`, refresh the `test/module-scaffold-baseline.sha256` byte-identity baseline
(the new `declare`s emit into every module), verify with `run-all-tests.sh` then
`run-dev-tests.sh` (the anti-stale trust-check asserts committed `bootstrap/` == a clean regen).
Rollback is `git checkout` of the source + `bootstrap/` followed by `make regen`.

## Open Questions

- Should the type descriptor also carry the field count / field names (for a richer future
  printer or introspection)? Carry the name now; add fields lazily when introspection lands.
- Subset/reordered constructor field lists — ship all-fields-in-order first; confirm whether any
  early consumer needs the general form.
