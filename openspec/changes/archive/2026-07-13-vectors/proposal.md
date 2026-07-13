## Why

Vectors are the first fixed-size, O(1)-indexed, *mutable* aggregate — the natural container
for array-shaped data, and the value the reader's `#(...)` syntax denotes. The README lists
`#(...)` under "reader extensions," but that syntax cannot exist without the vector data type
itself, which the README also lists (separately) under "Data." This change adds the type and
its operations, and — because the type now exists — the `#(...)` reader syntax with it. The
value representation already anticipates this: new heap types live under the extended-object
tag (tag 7) with a new header code, "without needing a new primary tag."

## What Changes

- **Runtime — new data type** — a vector as a tag-7 extended heap object with header code
  `HDR_VECTOR`: layout `{HDR_VECTOR, length, elem0, …, elem{n-1}}`, each element a tagged
  `i64`. Add the operations `make-vector` (length + fill), `vector-ref`, `vector-set!`
  (mutation), `vector-length`, and the `vector?` predicate, wired as reserved primitives.
- **Runtime — printer** — extend the tag-walking value printer to render a vector as
  `#(e0 e1 …)`.
- **Prelude** — `vector` (variadic constructor) and `list->vector`, built on `make-vector` +
  `vector-set!`.
- **Reader** — extend `rd-hash` so `#(...)` reads its elements and builds a vector
  (via `list->vector`).
- **Equality (follow-on)** — if `equal?` exists (`equality-and-list-library`), extend
  `rt_equal` to recurse element-wise into vectors; otherwise this arm lands when `equal?` does.

## Capabilities

### New Capabilities
<!-- The vector type is modeled as a core-language addition; see Modified Capabilities. -->

### Modified Capabilities
- `core-language`: add the vector data type and its operations (`vector`, `make-vector`,
  `vector-ref`, `vector-set!`, `vector-length`, `vector?`, `list->vector`) and the `#(...)`
  reader syntax.

## Impact

- **Code:**
  - `src/runtime/runtime.c` — `HDR_VECTOR`; `rt_make_vector`, `rt_vector_ref`,
    `rt_vector_set`, `rt_vector_length`, `rt_vector_p`; printer arm for vectors; (optional)
    a vector arm in `rt_equal`.
  - `src/parse.ss` — add `make-vector vector-ref vector-set! vector-length vector?` to `*prims*`.
  - `src/emit.ss` — add each to `prim-table` and emit its `declare` (arities 2,2,3,1,1).
  - `src/prelude.scm` — `vector`, `list->vector`, and the `#(...)` branch of `rd-hash`.
  - `demos/` — vector construction/ref/set!/length demos and a `#(...)` reader demo.
- **Verification:** `demos/run-tests.sh` and `demos/run-backends.sh` (3-way) with the new
  demos; existing demos unaffected.
- **Representation:** adds a header code under the existing tag-7 extended-object mechanism;
  the 8-tag scheme and the calling convention are unchanged, so `aot-codegen` is untouched.
  `LLVM.md` and `src/README.md` gain the `HDR_VECTOR` row.
- **Depends on:** nothing required (Wave A / foundational). Soft dependency:
  `equality-and-list-library` for the `rt_equal` vector arm (sequence after it if that arm is
  included).
- **Enables:** array-shaped data; `#(...)` reader literals; vector quasiquote later.
