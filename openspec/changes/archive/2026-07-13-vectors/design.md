## Context

The value representation is one 64-bit tagged word; the low 3 bits are the tag. Tags 0–6 are
assigned (fixnum, boolean, nil, pair, closure, box, symbol) and tag 7 (`TAG_EXT`) is an
*extended heap object* whose first word is a header code discriminating its type — currently
`HDR_STRING` (0) and `HDR_CHAR` (1). The runtime comment states the design intent directly:
"Further heap types (vectors, …) add header codes without needing a new primary tag." This
change realizes exactly that for vectors. Runtime primitives are C functions wired through
the fixed-arity `primcall` path; heap allocation is `rt_alloc_words` / `GC_MALLOC` under
Boehm GC. The tag-walking printer in `runtime.c` renders values; it already handles pairs,
strings, characters, etc.

## Goals / Non-Goals

**Goals:**
- A mutable, fixed-length vector type: `{HDR_VECTOR, length, elem…}`.
- Operations: `make-vector`, `vector-ref`, `vector-set!`, `vector-length`, `vector?`;
  the `vector` constructor and `list->vector` (prelude).
- Printing as `#(…)` and reading `#(…)`.

**Non-Goals:**
- Growable vectors, `vector-fill!`, `vector->list`, `vector-map`/`vector-for-each`,
  `vector-copy`, `subvector` — add when a consumer needs them (the constructor + ref/set!/
  length are the core).
- Bytevectors, records, hash tables — separate data types, later.
- Vector quasiquote (`` `#(…) ``) — after both this change and `quasiquote`.

## Decisions

### D1 — Vectors are tag-7 extended objects with `HDR_VECTOR`

A vector is `TAG_EXT` with first word `HDR_VECTOR` (the next header code, 2), second word the
codepoint... no — the second word is the element **count** (a raw `intptr_t`, not a tagged
fixnum, matching how `HDR_STRING` stores its byte length), followed by `length` tagged-`i64`
element slots:

```
{ HDR_VECTOR, length, elem0, elem1, ..., elem{length-1} }
```

This reuses the extended-object mechanism with no change to the primary tag scheme, so the
calling convention and `aot-codegen` are untouched. `rt_make_vector(k, fill)` allocates
`length + 2` words, writes the header and count, and fills the element slots with `fill`.

### D2 — Operations are runtime primitives; constructor and `list->vector` are prelude

The indexed/allocating operations are C primitives (fixed arity, tagged-`i64` in/out):
`rt_make_vector(k, fill)`, `rt_vector_ref(v, i)`, `rt_vector_set(v, i, x)` (returns an
unspecified value; mutates in place), `rt_vector_length(v)` (returns a tagged fixnum), and
`rt_vector_p(v)` (`TAG_EXT` with `HDR_VECTOR`). Index arguments are `UNFIX`ed; bounds are
undefined if out of range for this subset (matching `string-ref`), documented in the runtime.

The variadic constructor and list conversion are prelude Scheme, since they are expressible
over the primitives:

```scheme
(define (list->vector xs)
  (let ([v (make-vector (length xs) 0)])
    (let loop ([xs xs] [i 0])
      (if (null? xs) v (begin (vector-set! v i (car xs)) (loop (cdr xs) (+ i 1)))))))
(define (vector . xs) (list->vector xs))
```

### D3 — Printer renders `#(e0 e1 …)`

The tag-walking printer gains a `TAG_EXT`/`HDR_VECTOR` arm: print `#(`, then each element
separated by spaces (recursively, reusing the element printer), then `)`. This mirrors the
existing pair/string arms and is the inverse of the reader syntax.

### D4 — Reader `#(...)` builds a vector via `list->vector`

`rd-hash` gains a branch for `(` immediately after `#`: read the parenthesized elements with
the existing `rd-list` machinery to get a list, then convert with `list->vector`. This keeps
the reader change tiny and reuses list reading. (Reader lives in `prelude.scm`, so
`list->vector` from this same change is available.)

### D5 — `equal?` over vectors is a follow-on arm

`equality-and-list-library` notes that `rt_equal` will gain a vector arm when vectors exist.
That arm — two vectors are `equal?` iff same length and element-wise `equal?` — is included
here as a task **iff** `equal?` already exists; otherwise it is added by whichever change
lands second. Recorded so the two changes compose regardless of order.

## Risks / Trade-offs

- **Mutability is straightforward (unlike strings)** — vector slots are fixed-width tagged
  words, so `vector-set!` is a plain store with no representation question (contrast
  `string-mutation`). Mutation under Boehm GC is safe (slots hold tagged words the collector
  scans).
- **Out-of-range indices undefined** — consistent with `string-ref`; a checked-error variant
  comes with the broader error story. Noted in the runtime.
- **Count stored raw (not a fixnum)** — matches `HDR_STRING`'s length convention;
  `vector-length` tags it on the way out.
- **Ordering vs `equal?`** — the `rt_equal` vector arm depends on `equal?` existing (D5);
  handled by making it conditional and recording it in both changes.
- **Scope discipline** — only the core five operations plus constructor/`list->vector`;
  the broader vector library is deferred to when consumers need it.
