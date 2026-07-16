## Context

Strings are heap objects laid out as `{ HDR_STRING, byte-length, char *bytes }` — a 3-word
block — storing UTF-8 bytes with an explicit byte length (`src/runtime/runtime.c:228-236`).
The public API is **codepoint-indexed** (design **D1**): `string-length` counts codepoints,
`string-ref`/`substring` take codepoint indices. Reaching codepoint _i_ is done by
`utf8_offset`, which walks from byte 0 counting UTF-8 sequences until it has skipped _i_
codepoints (`src/runtime/runtime.c:296-300`). Therefore:

- `rt_string_length` is O(bytes) — it rescans the whole string every call (`:307`).
- `rt_string_ref` is O(_i_) (`:313`); a loop over all indices is O(n²).
- `rt_substring` is O(end) (`:318`).

The 64-bit tagged value representation is shared between the runtime and the emitter, but the
string *object layout* is not: the emitter lowers a string literal to a single opaque call
`call i64 @rt_make_string(ptr <bytes>, i64 <len>)` (`src/emit.ss:127-131`,
`declare i64 @rt_make_string(ptr, i64)` at `:489`) and the runtime alone decides the header
shape. This is the key lever — the header can grow without touching the emitter or the
committed bootstrap IR.

Two facts shape the design:
- **The common string is all-ASCII.** For an ASCII string, byte length equals codepoint
  count and codepoint index equals byte offset, so all the `utf8_offset` walking is pure
  overhead. The compiler's own reader/source is ASCII.
- **The pathology is narrow but genuinely quadratic.** Only a multi-byte string that is
  randomly indexed in a loop is O(n²). Sequential forward iteration is already O(1) per step.

This change is backlog item **P4** in `docs/PERFORMANCE.md`. The chosen direction (from the
proposal's decision point) is **ASCII fast-path + lazy breadcrumb index**, keeping UTF-8
storage rather than switching to a fixed-width representation.

## Goals / Non-Goals

**Goals:**
- `string-length` O(1) for every string; `string-ref`/`substring` O(1) for ASCII strings.
- A full indexed traversal of a multi-byte string amortized to O(n) instead of O(n²).
- Preserve every observable result and the codepoint-indexed contract: `string-length`,
  `string-ref`, `substring`, `string->symbol`, `string=?`, `string-append`, `list->string`,
  `string->list`, `make-string`, in-place mutation, non-ASCII round-tripping, and
  `eq?`/`equal?`/print identity.
- Keep the emitter IR and the committed bootstrap IR unchanged (change confined to the C
  runtime), preserving the runtime/emitter contract and the self-hosting fixed point.

**Non-Goals:**
- Switching to a fixed-width string representation (rejected alternative — see D1).
- Changing the codepoint-indexed API to a byte-indexed or cursor-based one.
- O(1) *worst-case* random access on multi-byte strings (the breadcrumb gives amortized-O(n)
  per traversal / sublinear-per-access, not O(1) per isolated access).
- Touching character, fixnum, pair, symbol, vector, or closure representations.
- Dead-code elimination / prelude precompilation (backlog **P1**/**P3**).

## Decisions

### D1 — Keep UTF-8 storage; add an ASCII fast path + lazy breadcrumb index

Grow the string header from 3 to 5 words:

```
   { HDR_STRING, byte_len, cp_len, char *bytes, cpidx *index }
        [0]         [1]      [2]        [3]           [4]
```

- `cp_len` — codepoint count, computed once in `rt_make_string` (one O(byte_len) scan, same
  order as the `memcpy` already performed) and stored. Makes `rt_string_length` O(1).
- `index` — nullable pointer to a lazily-built breadcrumb table; `NULL` at construction and
  for ASCII strings (which never need it).

**ASCII fast path.** `byte_len == cp_len` ⇔ the string is all-ASCII ⇔ codepoint index == byte
offset. `rt_string_ref`/`rt_substring` test this first and index the byte array directly —
O(1), no scan, no index allocation.

**Breadcrumb index (multi-byte only).** On the first random codepoint access to a string with
`byte_len != cp_len`, build a table sampling the byte offset every `K` codepoints
(`index[j]` = byte offset of codepoint `j*K`). An access to codepoint _i_ then starts at
`index[i/K]` and scans forward at most `K` codepoints. Build cost is O(byte_len), paid once;
each subsequent access is O(K). A full 0…n−1 traversal is O(n) build + O(n·K) access = O(n)
for constant K.

Refactor `utf8_offset(s, blen, cp)` → `utf8_offset_from(s, blen, start_byte, start_cp, cp)`
so both the plain walk and the breadcrumb-seeded walk share one implementation.

**Rationale.** This keeps the single most valuable property of UTF-8 storage — that
`string=?`/`equal?` are byte `memcmp` (`:330-334`), `substring`/`string-append` are byte
slices/concatenation, and `string->symbol` interns the bytes directly — while removing both
the ASCII overhead (the common case) and the quadratic blow-up (the rare case). The emitter
never sees the header, so the IR and bootstrap are untouched.

**Alternatives considered:**
- **Fixed-width representation** (Latin-1/UCS-2/UCS-4 hybrid, à la CPython/Racket): true
  O(1) random access for all strings, but rewrites `string=?`/`equal?`, `substring`,
  `string-append`, `string->symbol`, `make-string`, mutation, and the literal-encoding path,
  and enlarges the runtime — against the "small, clean, self-contained binary" goal for a
  case that is rare in practice. Rejected.
- **ASCII fast path only** (no breadcrumb): simplest, fixes the common case, but leaves the
  multi-byte O(n²) worst case in place. Rejected as it does not actually close P4's stated
  symptom.
- **Document & punt** (formalize the O(1) forward-iteration idiom, close P4 as by-design):
  cheapest, matches the "present value is low" note, but leaves the pathology. Rejected in
  favor of a real fix now that one is scoped.

### D2 — Sampling stride K is a fixed compile-time constant

Use a fixed `K` (e.g. 16 or 32) rather than a per-string adaptive stride. The index costs
`cp_len / K` words; at K = 32 that is ~3% of the codepoint count, allocated only for
multi-byte strings that are actually randomly indexed. A fixed constant keeps the lookup a
plain `i / K` divide and the code trivial. Revisit only if profiling on a real workload shows
the constant matters.

### D3 — Build the index lazily, on first random access, never for ASCII

`rt_make_string` does **not** build the index — it only computes `cp_len`. The index is built
on the first `rt_string_ref`/`rt_substring` call that (a) hits a multi-byte string and (b)
cannot answer from an already-built index. This keeps construction cheap, allocates nothing
for the overwhelmingly common ASCII and never-randomly-indexed cases, and means a program
that only iterates sequentially (which should use forward iteration anyway) pays nothing.

The index is a plain `GC_MALLOC_ATOMIC` array of byte offsets (no interior pointers), so it is
GC-safe and collected with the string. Because strings are logically immutable at the byte
level except through the mutation primitives (D4), a built index is valid for the string's
lifetime unless mutation invalidates it.

### D4 — In-place mutation invalidates `cp_len` and the index

`string-set!` and any in-place mutation (`src/runtime/runtime.c`, "In-place string mutation"
requirement) can change a codepoint's byte width, so after mutation both `cp_len` and any
built `index` may be stale. On each mutation the runtime SHALL recompute/repair `cp_len` and
drop the cached `index` (set it back to `NULL`, to be rebuilt lazily if needed again).
Correctness first; mutation is not on the hot path this change optimizes.

### D5 — Confine the change to the C runtime; emitter and bootstrap IR unchanged

Because the emitter lowers literals through the opaque `rt_make_string(ptr, i64)` call and
never reads the header, the header can grow with **no** emitter edit and **no** regeneration
of the committed stage-0 IR (`bootstrap/*.ll`). The self-hosting fixed point is re-verified as
a guard, but no IR change is expected. All exported accessors (`rt_string_len`,
`rt_string_bytes`) keep their signatures; their internal field offsets shift ([bytes] moves
from word 2 to word 3) but callers are recompiled against the same C API.

## Risks / Trade-offs

- **Field-offset drift across the runtime** (every `str_len`/`str_bytes`/`rt_make_string`
  caller must agree on the new 5-word layout) → route all field access through the
  `str_len`/`str_bytes`/`str_cplen` accessors and the single `rt_make_string` constructor;
  grep every `as_ptr(v)[1|2]` and `GC_MALLOC(3 * sizeof(val))` string site and update
  together. Verified by the full demo suite.
- **Stale `cp_len`/index after mutation** → D4 recomputes `cp_len` and nulls the index on
  every mutation; a scenario exercises index-then-mutate-then-index.
- **Per-string memory for the index** → built only for multi-byte, randomly-indexed strings,
  at ~`cp_len/K` words; ASCII and sequentially-iterated strings allocate nothing (D3).
- **Construction now scans for `cp_len`** → same O(byte_len) order as the existing `memcpy`,
  paid once; buys O(1) `string-length` forever. Acceptable.
- **Self-hosting fixed point depends on byte-identical IR** → the change touches only the
  runtime, not emitted IR, so the fixed point is expected to hold unchanged; it is
  re-verified regardless as a guard, not merely assumed.
- **Index correctness for astral (4-byte) codepoints** → the breadcrumb stores byte offsets
  of codepoint boundaries, width-agnostic; the forward scan uses `utf8_seq_len`, already
  correct for 1–4 byte sequences. Covered by a non-ASCII/astral traversal scenario.

## Migration Plan

Single-commit runtime change (`src/runtime/runtime.c`), no schema/data migration:
1. Grow the header and constructor; add `str_cplen` and index build/lookup helpers.
2. Rewire `rt_string_length`/`rt_string_ref`/`rt_substring` and every other `rt_make_string`
   caller to the new layout.
3. Handle mutation invalidation (D4).
4. Run the demo suite + AOT/JIT/bitcode 3-way and REPL-vs-batch equivalence harnesses; verify
   the self-hosting fixed point.
5. Tick **P4** in `docs/PERFORMANCE.md` and update any layout prose in README/`LLVM.md`.

Rollback is a straight revert of the runtime commit — no persisted artifact or IR depends on
the new layout.

## Open Questions

- The concrete sampling stride `K` (D2) — pick a default (16 or 32) at implementation time;
  low risk, internal, tunable later.
- Whether to also grant `substring` the breadcrumb seed for both `start` and `end` (it
  computes two offsets); trivial once the helper exists, decide during implementation.
