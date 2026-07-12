## Context

Characters are `TAG_EXT` heap objects `{ HDR_CHAR, codepoint }` built by
`rt_make_char(intptr_t codepoint)` — the single factory called by (a) char-literal emission
(`@rt_make_char` in `emit.ss`), (b) `rt_integer_to_char`, and (c) `rt_string_ref`. Nothing
canonicalizes them, so each call allocates a fresh object and identity `==` fails on equal
chars. Symbols solve the same problem with `rt_intern`: a linear-scan, growable,
`GC_MALLOC_UNCOLLECTABLE` (scanned, rooted) `intern_table` that returns the existing object
for an equal key. `rt_eq_p`/`rt_eqv_p` are both `truthy(a == b)`, so once equal chars share
one object, both predicates are automatically correct on characters — no frontend or
predicate change is needed.

## Goals / Non-Goals

**Goals:**
- Equal-codepoint characters are the same object; `(eqv? #\a #\a)` and `(eq? #\a #\a)` are
  `#t`, across every construction path (literal, `integer->char`, `string-ref`).
- Runtime-only, single choke point (`rt_make_char`); no frontend/ABI change.
- Survive GC under both AOT and the lli JIT (same rooting discipline as symbols).

**Non-Goals:**
- `equal?` / structural equality (separate change).
- Making characters *immediate* (tagged) values — all 8 primary tags are already used, so
  that is a tagging-scheme rework; interning achieves the semantics without it.
- Value comparison for non-immediate numbers (flonums/bignums) — the other half of the
  `eqv?` seam, still deferred.

## Decisions

### D1 — Intern inside `rt_make_char`

Route the one factory through a char intern table so all three construction paths share
canonical objects:

```c
val rt_make_char(intptr_t cp) {
  val c = char_lookup(cp);          /* existing interned char, or 0 */
  if (c) return c;
  val *p = GC_MALLOC(2 * sizeof(val));
  p[0] = HDR_CHAR; p[1] = cp;
  val ch = tag_ptr(p, TAG_EXT);
  char_intern_add(ch);
  return ch;
}
```

### D2 — Table structure: Latin-1 direct array + growable scanned table for the rest

Keying is by integer codepoint (cheaper than symbols' `strcmp`), but the codepoint space
is large (0…0x10FFFF), so a full direct array is too big to preallocate. Use two tiers:

- **Latin-1 fast path (0…255):** a fixed `val latin1[256]` cache, `GC_MALLOC_UNCOLLECTABLE`
  and scanned. O(1) for the overwhelmingly common ASCII/Latin-1 case (so `string-ref` loops
  over ASCII text stay cheap).
- **Astral/BMP overflow (≥256):** a growable, `GC_MALLOC_UNCOLLECTABLE`, scanned array with
  linear scan by codepoint — identical discipline to `intern_table`. Rare codepoints, small
  table, linear scan is fine and keeps the code simple and consistent with symbols.

**Alternative rejected:** a single linear-scan table for all chars (like symbols verbatim) —
simpler but makes ASCII `string-ref` loops O(n) in the number of distinct chars seen; the
256-entry fast path removes that cost for one small array. **Alternative rejected:** a hash
table — faster asymptotically but more machinery than this subset needs.

### D3 — Rooting: uncollectable + scanned (mirror symbols)

Both tiers are allocated with `GC_MALLOC_UNCOLLECTABLE` and hold tagged char words, so Boehm
scans them and keeps the interned chars alive as roots. This is exactly why the symbol table
is uncollectable-and-scanned rather than a plain static pointer: under lli's JIT the module
data segment is not a registered Boehm root, so a heap-pointer-in-static would be collected
mid-run. The `symbol-gc` demo already validates this discipline; a char-GC check extends it.

### D4 — No predicate or frontend change

`rt_eq_p`/`rt_eqv_p` remain `truthy(a == b)`. The `n-ary-equality-and-not` comment on
`rt_eqv_p` (that `==` doesn't cover chars) is updated: chars are now interned, so `==`
covers them; the remaining seam is value comparison for non-immediate numbers.

## Risks / Trade-offs

- **Char creation cost** → mitigated by the Latin-1 O(1) fast path (D2); only rare
  ≥256 codepoints hit the linear scan.
- **GC collecting interned chars under lli** → mitigated by `GC_MALLOC_UNCOLLECTABLE` +
  scanned tables (D3), the proven symbol pattern; covered by a char-survives-GC test.
- **Hidden identity assumptions** → chars are immutable in Scheme, so sharing is
  semantically invisible; existing string/char/unicode demos must still pass unchanged
  (regression check).
- **Memory** for the 256-entry Latin-1 array is a fixed ~2 KB, allocated lazily on first
  char — negligible.
