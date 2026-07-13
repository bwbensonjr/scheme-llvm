## Context

A string is a tag-7 extended heap object `{HDR_STRING, byte-length, char *bytes}` storing
UTF-8; length and indexing are by **codepoint** (`string-char-operations` settled this).
Because UTF-8 is variable width, the byte length of a string is not a fixed function of its
codepoint length, and the byte offset of codepoint `i` requires a scan. Strings have been
immutable so far, so this never mattered. `string-set!` forces the question: replacing
codepoint `i` with a character whose UTF-8 encoding differs in length from the old one changes
the total byte length. Runtime primitives are C functions on tagged `i64` wired through the
`primcall` path; string objects are allocated with `GC_MALLOC` and their words are ordinary
mutable memory.

## Goals / Non-Goals

**Goals:**
- `string-set!`: replace the character at a codepoint index, in place, for **any** character
  (including ones whose byte length differs from the old character's).
- Preserve object identity: aliases of the same string observe the mutation.
- `string-copy`: a fresh, independently-mutable duplicate.

**Non-Goals:**
- Changing the immutable UTF-8 representation to a fixed-width codepoint array — considered
  and rejected for now (D1 Alternatives); the splice approach keeps one representation.
- `string-fill!`, `string-copy!` (range copy), growable strings — add when needed.
- Enforced immutability of string *literals* (R7RS leaves mutating a literal undefined) —
  see D3.
- Bounds/domain error signaling — out-of-range index remains undefined for this subset.

## Decisions

### D1 — `string-set!` splices the UTF-8 buffer and updates the object in place

`rt_string_set(s, i, ch)`:

1. Scan the UTF-8 bytes to find the byte range `[b0, b1)` of codepoint `i`.
2. Encode the replacement character `ch` to its UTF-8 bytes `e` (length `le`).
3. Allocate a new byte buffer of size `byte-length - (b1 - b0) + le`, copy `[0, b0)`, then
   `e`, then `[b1, byte-length)`.
4. Overwrite the string object's word[1] (byte-length) and word[2] (bytes pointer) with the
   new length and buffer. The object's tagged pointer is unchanged, so every alias sees the
   update.

This is **O(n)** per mutation (scan + rebuild) but correct for any character and preserves
identity. It keeps a single string representation across mutable and immutable use.

**Alternative considered — fixed-width mutable representation.** Store mutable strings as an
array of 32-bit codepoints (or tagged words), giving O(1) `string-set!` and no rebuild. Rejected
for now: it introduces a *second* string representation (or converts all strings to it),
forcing every string operation to handle both, and complicates `string=?`/`string-append`/
literals. The splice approach can be swapped for a fixed-width buffer later **behind the same
`string-set!` interface** if profiling demands it — noted, not done here.

### D2 — All strings are mutable; `make-string` yields a mutable target

Under D1 every string object has a `GC_MALLOC`'d byte buffer whose length/pointer words can be
rewritten, so no separate "mutable string" type is needed. `make-string` (from
`string-char-library`) therefore already returns a mutable string; the `make-string` +
`string-set!` idiom works without changing `make-string`.

### D3 — `string-copy` for safe mutation; mutating literals is undefined

String literals evaluate to fresh heap string objects (the emitter copies the constant bytes
via `rt_make_string` per use), so mutating a literal corrupts only that instance, not a shared
constant. Still, R7RS leaves mutation of literals undefined, so the recommended idiom is to
mutate a `string-copy` or a `make-string`. `rt_string_copy(s)` allocates a fresh object over a
fresh copy of the bytes. This change documents that mutating a literal is undefined and
provides `string-copy` as the safe path.

### D4 — Frontend unchanged beyond the prim list

`string-set!` and `string-copy` are ordinary primcalls (arity 3 and 1, tagged-`i64`), so the
only frontend change is adding them to `*prims*` and `prim-table` + `declare`s. `string-set!`
returns an unspecified value (the store's result); demos read the mutated string back rather
than relying on the return value.

## Risks / Trade-offs

- **O(n) `string-set!`** — documented (D1); acceptable now, optimizable later behind the
  interface via a fixed-width representation without a semantic change.
- **Identity/aliasing correctness** — the in-place word update is what makes aliases see the
  change; covered by an aliasing demo (two bindings to the same string; set via one, read via
  the other).
- **Byte-length change** — the splice explicitly handles ASCII↔multibyte replacement; covered
  by a demo that replaces an ASCII char with a multibyte one and re-checks `string-length`
  (codepoints) and `string-ref`.
- **Literal mutation** — documented as undefined (D3); `string-copy` is the safe path.
- **GC safety** — the new buffer is `GC_MALLOC`'d and reachable from the (still-live) string
  object before the old pointer is dropped; no raw pointers escape across an allocation.
