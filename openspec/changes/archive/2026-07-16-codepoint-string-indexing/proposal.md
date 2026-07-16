## Why

Strings are stored as UTF-8 bytes with a codepoint-indexed API (design **D1**). Reaching
codepoint _i_ walks from byte 0 counting codepoints (`utf8_offset`, `src/runtime/runtime.c:296`),
so `string-ref` is O(_i_) and any loop that indexes a string by position is O(n²). This is
backlog item **P4** in [`docs/PERFORMANCE.md`](../../../docs/PERFORMANCE.md).

The pathology only bites strings that (a) contain multi-byte codepoints **and** (b) are
randomly indexed in a loop — but when it bites, it is quadratic. The overwhelmingly common
case is all-ASCII text (the compiler's own reader/source included), where byte offset already
equals codepoint offset and the walk is pure waste. This change removes the waste for the
common case and removes the asymptotic blow-up for the rare one, without abandoning UTF-8
storage.

## What Changes

- **ASCII fast path (the primary win).** Cache each string's codepoint length alongside its
  byte length at construction. When they are equal the string is pure ASCII, so codepoint
  index == byte offset: `string-ref`, `substring`, and `string-length` become O(1) with no
  scan. `string-length` itself becomes O(1) for **every** string (the count is now stored,
  not recomputed).
- **Amortized breadcrumb index (the asymptotic fix for multi-byte strings).** On the first
  random codepoint access to a genuinely multi-byte string, lazily build a sampled
  codepoint→byte breadcrumb table (one entry every K codepoints). Subsequent accesses jump to
  the nearest breadcrumb and scan at most K bytes forward, turning an indexed loop from O(n²)
  into O(n) build + O(n·K) access. The index is built at most once per string and never for
  ASCII strings.
- **String header grows** from `{ HDR_STRING, byte_len, bytes }` to
  `{ HDR_STRING, byte_len, cp_len, bytes, index }`, where `index` is a nullable pointer to a
  lazily-allocated breadcrumb table (`NULL` until first multi-byte random access).
- Preserve all observable string behavior and the codepoint-indexed contract: `string-length`,
  `string-ref`, `substring`, `string->symbol`, `string=?`, `string-append`, `list->string`,
  `string->list`, `make-string`, in-place mutation, and faithful UTF-8 round-tripping of
  non-ASCII text. `equal?`/`string=?` stay byte comparisons (UTF-8 byte equality is codepoint
  equality); `substring`/`string-append`/`string->symbol` are unaffected by the index.
- On landing, tick **P4** ☐→☑ in `docs/PERFORMANCE.md` and record this change's name there.

No user-visible language behavior changes — this is a storage/representation change behind a
preserved contract, so it is not marked BREAKING. Complexity guarantees improve; results do
not change.

## Capabilities

### New Capabilities
<!-- none; this change modifies existing capabilities only -->

### Modified Capabilities
- `core-language`: the "String and character operations" requirement gains an explicit
  **complexity guarantee** — `string-length` is O(1); `string-ref`/`substring` are O(1) on
  ASCII strings and amortized sublinear-per-access (O(n) per full indexed traversal) on
  multi-byte strings — while every existing observable result (codepoint indexing, non-ASCII
  round-tripping) is preserved unchanged.
- `aot-codegen`: the runtime string value-representation requirement changes — the string heap
  object grows a stored codepoint-length word and a nullable breadcrumb-index pointer; a string
  literal still lowers to a single `rt_make_string` call on a private byte-array constant (the
  emitter interface is unchanged).

## Impact

- **Code**: `src/runtime/runtime.c` — string header layout and `rt_make_string`
  (`:228-236`); `str_len`/`str_bytes` accessors and a new `str_cplen` accessor (`:238-246`);
  `rt_string_length` (`:307`), `rt_string_ref` (`:313`), `rt_substring` (`:318`) to use the
  ASCII fast path and breadcrumb index; `utf8_offset` (`:296`) refactored to accept a
  breadcrumb start; new breadcrumb build/lookup helpers; every other `rt_make_string`/
  `str_len` caller (`string-append`, `list->string`, `make-string`, `symbol->string`,
  mutation) updated for the new arity/field set.
- **Contract**: the string layout is produced by the runtime's `rt_make_string`, which the
  emitter already calls opaquely for literals — the emitter's IR does not change, so the
  runtime/emitter contract is preserved by keeping `rt_make_string`'s signature. Verified by
  the existing demos and the AOT/JIT/bitcode and REPL-vs-batch equivalence harnesses.
- **Docs**: `docs/PERFORMANCE.md` (P4 check-off), and any README/`LLVM.md`/`docs/PIPELINE.md`
  text describing the string object layout.
- **Bootstrap**: the string literal IR shape is unchanged (still one `rt_make_string` call), so
  no committed stage-0 IR needs regeneration for the representation; the self-hosting fixed
  point is re-verified regardless.
- **No new dependencies.**
