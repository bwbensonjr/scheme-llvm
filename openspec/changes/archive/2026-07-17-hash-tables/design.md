## Context

Vectors (mutable, fixed-length, O(1)-indexed) and `equal?` (structural comparison) already
exist. A hash table is expressible almost entirely in Scheme on top of those two: a bucket
vector of association lists, plus a count, plus a hash function to pick a bucket. The only
capability the runtime cannot already provide is a fast, stable **hash code** for a value — so
the runtime contribution is one primitive, `%hash`, and everything else lives in the prelude,
consistent with the project's "as simple and transparent as possible" goal.

R7RS-small does not define hash tables, so there is no canonical surface to conform to. SRFI-69
("Basic Hash Tables") is the most widely-implemented minimal API and is adopted here. The
value representation is the tagged-word scheme with tag 7 (`TAG_EXT`) for heap objects; header
codes `HDR_STRING` (0), `HDR_VECTOR` (2), `HDR_ERROR` (3) are in use, code 1 is free.

## Goals / Non-Goals

**Goals:**
- A mutable `equal?`-keyed hash table with amortized-O(1) set/ref, built in the prelude on
  vectors + `equal?` + a runtime `%hash`.
- The SRFI-69 core: `make-hash-table`, `hash-table?`, `hash-table-set!`, `hash-table-ref`,
  `hash-table-ref/default`, `hash-table-delete!`, `hash-table-contains?`, `hash-table-size`,
  `hash-table-keys`, `hash-table-values`, `hash-table->alist`.
- Automatic grow/rehash on load factor.
- A recognizable opaque printed form and a working `hash-table?` predicate.

**Non-Goals:**
- Custom equality/hash functions per table (`make-hash-table eq? hash`) — `equal?`-keyed only
  for now; the structure leaves room to add them.
- `hash-table-update!`, `hash-table-update!/default`, `hash-table-walk`, `hash-table-fold`,
  `hash-table-copy`, `hash-table-merge!` — add when a consumer needs them.
- Weak keys/values, thread safety, ordered iteration.
- A readable literal syntax — hash tables print opaquely and are not read.

## Decisions

### D1 — Representation: header-tagged object wrapping a mutable spine

A hash table is a `TAG_EXT` object with a new header code `HDR_HASHTABLE` (the next free code)
whose payload is a single slot pointing at a **mutable spine** — a 3-element vector
`#(count buckets _)` where `count` is the element count and `buckets` is a vector of
association lists. Growth replaces the `buckets` slot (and resets `count`) in place, so the
table's identity (the outer `TAG_EXT` object) is stable across rehash.

The header code exists for exactly two reasons the prelude cannot satisfy on its own: a correct
`hash-table?` predicate (a bare vector-of-vectors would be indistinguishable from a user
vector) and a distinct printed form. Two representations were considered:

- **(chosen) `HDR_HASHTABLE` extended object** — costs one header code and a tiny runtime
  constructor/accessor/predicate, but gives a true disjoint type and clean printing.
- **Tagged plain vector** (`#('%hash-table count buckets)`, predicate = "vector whose 0th
  element is the `%hash-table` sentinel symbol") — zero runtime change, but `hash-table?` would
  report `#t` for a user vector that happens to start with that symbol, and it would print as a
  vector. Rejected: a data type should be disjoint.

`%make-hash-table`, `%hash-table?`, `%hash-table-spine` (accessor) are the minimal runtime
primitives for the chosen representation; all `hash-table-*` operations are prelude Scheme over
the spine vector.

### D2 — `%hash`: a fixnum hash code respecting `equal?`

`rt_hash(x)` returns a tagged fixnum. It MUST satisfy: `equal?` values hash equally. It is
computed by value class:
- fixnum → the value itself (masked to non-negative);
- boolean / nil / char → the raw tagged word (immediates are canonical, so `equal?` ⇒ `eq?`);
- symbol → the interned symbol's identity/address folded to a fixnum (interned ⇒ `eq?`);
- string → an FNV-1a byte hash over the UTF-8 storage (content hash, so two `equal?` strings
  with distinct storage still collide into the same bucket);
- pair / vector → a shallow structural fold (combine element hashes) bounded to a small depth
  to stay O(1)-ish; collisions are fine because the bucket list falls back to `equal?`.

Only `%hash` is a new primitive here; correctness of lookup rests on `equal?` in the bucket
scan, so `%hash` need only be *consistent with* `equal?`, never a perfect hash.

### D3 — Buckets, load factor, and growth (prelude)

`make-hash-table` allocates a spine with an initial bucket vector (e.g. 8 buckets) and
`count = 0`. `hash-table-set!` computes `(modulo (%hash key) nbuckets)`, scans that bucket's
alist for an `equal?` key (replace if found, else prepend and bump `count`), then, when
`count / nbuckets` exceeds a load factor (e.g. 3), allocates a bucket vector of roughly double
the size and reinserts every entry. `hash-table-ref/default` / `hash-table-contains?` /
`hash-table-delete!` scan the target bucket. `hash-table-ref` is
`hash-table-ref/default` with a "key not found" `error` on absence. `hash-table-keys` /
`-values` / `->alist` walk all buckets. All of this is straightforward Scheme over vectors and
`assoc`-style traversal already in the prelude.

### D4 — Printer renders `#<hash-table N>`

The tag-walking printer gains a `TAG_EXT`/`HDR_HASHTABLE` arm printing `#<hash-table ` + the
count + `>`. Opaque forms with `#<…>` are the conventional non-readable print; this matches how
other implementations render tables and signals "not a literal."

## Risks / Trade-offs

- **`%hash` must track `equal?`** → if `%hash` ever disagrees with `equal?` (equal values,
  different codes), entries become unfindable. Mitigation: derive `%hash` strictly by value
  class from the same notion of equality; cover with a demo asserting `equal?` strings share a
  bucket, and rely on the bucket-list `equal?` scan as the source of truth.
- **Header-code collision with sibling data-type changes** → `bytevectors` and `records` also
  claim header codes; the number is assigned at implementation time and the others shift up.
  Recorded so the changes compose in any order.
- **Structural hashing cost** → hashing large pair/vector keys could be expensive; bounded-depth
  shallow hashing keeps it cheap at the cost of more collisions, which correctness tolerates.
- **Mutation under GC** → the spine and bucket vectors hold tagged words the collector scans;
  in-place growth replaces slots with freshly-allocated vectors, all GC-safe.
- **No custom eq/hash yet** → `equal?`-only keying is a real limitation for identity-keyed maps;
  the spine leaves room to carry eq/hash closures later without changing the outer type.

## Migration Plan

Adding a data type that the **prelude itself uses** (unlike a pure runtime/reader addition) hits
a bootstrap ordering constraint: the seed compiler that `tools/regen.sh` links from the committed
`bootstrap/embed.ll` compiles `lib/scheme/base.sld` on the *first* fixed-point iteration, before
the new compiler exists. If `base.sld` already references the new `%hash*` primitives but the seed
compiler doesn't know them, iteration 1 fails with "unbound variable %make-hash-table". So the
regen sequence is two-step:

1. With `base.sld` still at its previous (pre-hash) state, run `make regen`. `build/embed.scm`
   bakes the new `parse.ss` `*prims*` + `emit.ss` prim-table, so the fixed point produces a
   **new compiler** (`bootstrap/embed.ll`) that knows the hash primitives — while the library it
   compiles has no hash references yet, so iteration 1 succeeds.
2. Regenerate `base.sld` from `src/prelude.scm` (`chez --script tools/gen-scheme-base.ss`), then
   run `make regen` again. The seed is now the new compiler, so it compiles the hash-referencing
   `base.sld` cleanly and the committed `bootstrap/scheme.base.ll` gains the hash procedures.

The `test/scheme-base-gen-check.sh` guard enforces that the *final* committed `base.sld` matches
`prelude.scm`; the pre-hash intermediate is only a bootstrap stepping-stone. (Rollback is `git
checkout` of the source + `bootstrap/` + `lib/scheme/base.sld` followed by `make regen`.)

## Open Questions

- Initial bucket count and load-factor threshold — pick pragmatic defaults (8 buckets, load
  factor 3, double-on-grow); tune later if a demo shows pathology.
- Whether `hash-table-ref` (no default) should take an optional thunk (SRFI-69's third arg) —
  ship the `error`-on-absence form first; add the thunk overload if needed.
