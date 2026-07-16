## Why

Every Scheme character is currently a heap-allocated object. `string-ref`, the reader, and
`integer->char` each allocate (or intern-lookup) a two-word block, and two permanent
`GC_MALLOC_UNCOLLECTABLE` intern tables stay resident for the whole process solely to make
`eq?`/`eqv?` hold by identity. Characters are small, ubiquitous values that never need to
live on the heap — encoding them immediately in the tagged word removes the allocation, the
GC pressure, and ~40 lines of intern machinery at once. This is backlog item **P2** in
[`docs/PERFORMANCE.md`](../../../docs/PERFORMANCE.md).

## What Changes

- Represent characters as **immediate tagged words** (codepoint encoded directly in the
  word); a character is never heap-allocated.
- Introduce a **secondary immediate encoding** carved from the boolean/nil tag space (the
  primary 3-bit tag space is fully assigned). Characters and the existing booleans/`()`
  become distinct subtypes of one immediate tag, with headroom reserved for future
  singletons (`eof-object`, the unspecified value).
- **Remove** the character intern machinery: the `char_latin1[256]` array, the growable
  linear-scan astral table, `char_lookup`/`char_intern_add`, and the `HDR_CHAR` extended
  heap layout (`src/runtime/runtime.c`).
- Update the three places that share the value representation so they agree: the C runtime
  (`runtime.c`), the LLVM IR emitter (`src/emit.ss`: inline tag checks + character-literal
  emission), and the shared value printer (`display`/`write` of characters).
- Preserve all observable character behavior: `char?`, `char->integer`, `integer->char`,
  `eq?`/`eqv?` on characters, the n-ary character comparisons (`char=? char<? char>?
  char<=? char>=?`), `#\` literals including named characters (`#\newline`, `#\space`,
  `#\tab`, …), and the characters returned by `string-ref`.
- On landing, tick **P2** in `docs/PERFORMANCE.md` and record this change's name there.

No user-visible language behavior changes — this is a representation change behind a
preserved contract. (The internal value encoding is not a user-facing API, so this is not
marked BREAKING.)

## Capabilities

### New Capabilities
<!-- none; this change modifies existing capabilities only -->

### Modified Capabilities
- `core-language`: the "Character interning" requirement is reframed — characters are no
  longer heap objects interned by codepoint; character identity (`eq?`/`eqv?` holding for
  equal codepoints) is instead an intrinsic property of the immediate encoding. The `eqv?`
  requirement's characterization of characters as "interned" is updated to "immediate".
- `aot-codegen`: the runtime value-representation requirement changes — characters move off
  the header-word extended-object scheme onto an immediate encoding, and a character literal
  no longer lowers to a `rt_make_char` heap call.

## Impact

- **Code**: `src/runtime/runtime.c` (tag/subtype macros, `char?`, `char->integer`,
  `integer->char`, `eqv?`/`equal?` character handling, value printer; deletion of the intern
  tables and `HDR_CHAR` layout), `src/emit.ss` (inline character tag/predicate checks,
  `#\`-literal emission), and any shared value-printer path used by both `display` and the
  final-value/`write` printer.
- **Contract**: the tagged-word value representation is shared verbatim between the runtime
  and the emitter; both must be changed together or programs miscompile. Verified by the
  existing demos and the AOT/JIT/bitcode equivalence and REPL-vs-batch harnesses.
- **Docs**: `docs/PERFORMANCE.md` (P2 check-off), and any README/`LLVM.md` text that
  describes characters as heap/extended-tag objects.
- **No new dependencies.**
