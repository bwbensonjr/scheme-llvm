## Context

Characters are currently heap objects. A character is a two-word block under the extended
tag (`TAG_EXT` = 7) with layout `{ HDR_CHAR, codepoint }` (`src/runtime/runtime.c:230`). To
keep `eq?`/`eqv?` holding for equal codepoints, characters are interned by codepoint through
a Latin-1 array (`char_latin1[256]`) plus a growable linear-scan astral table, both
`GC_MALLOC_UNCOLLECTABLE` so they survive collection under the JIT
(`src/runtime/runtime.c:240-278`). Every `#\` literal, `integer->char`, and `string-ref`
allocates or does an intern lookup.

The tagged 64-bit value representation is **shared verbatim** between the C runtime and the
LLVM IR emitter (`src/emit.ss`). All eight primary 3-bit tags are assigned
(`runtime.c:37-50`): `000` fixnum, `001` boolean, `010` nil, `011` pair, `100` closure,
`101` box, `110` symbol, `111` extended-heap. There is no free primary tag for a new
immediate type, so characters must live under a **secondary** discriminator within an
existing immediate tag.

Two facts (verified in the current code) shape the design:
- **Truthiness depends only on `#f`.** `rt_not` tests `x == FALSE_V` and the emitter's
  boolean branch tests `icmp ne i64 v, 1` (`emit.ss:275`); `TRUE_V` (currently `9`) is never
  load-bearing. So `#t` may be re-encoded freely **provided `#f` stays `1`**.
- The emitter hardcodes `#t`→`"9"`, `#f`→`"1"` (`emit.ss:118-119`) and lowers a character
  literal to a `rt_make_char` call (`emit.ss:132-135`).

This change is backlog item **P2** in `docs/PERFORMANCE.md`.

## Goals / Non-Goals

**Goals:**
- Represent characters as immediate tagged words — no heap allocation, no intern tables.
- Preserve every observable character behavior: `char?`, `char->integer`, `integer->char`,
  `eq?`/`eqv?`/`equal?` on characters, the n-ary comparisons (`char=? char<? char>?
  char<=? char>=?`), `#\` literals incl. named chars, and characters returned by
  `string-ref`.
- Delete the intern machinery (`char_latin1`, the astral table, `char_lookup`,
  `char_intern_add`, `HDR_CHAR`).
- Keep runtime and emitter in exact agreement, verified by the existing demos and the
  AOT/JIT/bitcode and REPL-vs-batch equivalence harnesses.
- Reserve encoding headroom for future non-heap singletons (`eof-object`, unspecified).

**Non-Goals:**
- Implementing `eof-object` or the unspecified value now (only reserving subtype space).
- Changing the string representation or fixing O(n) string indexing (backlog **P4**).
- Dead-code elimination / prelude precompilation (backlog **P1**/**P3**).
- Altering the encoding of any other value type (fixnum, pair, closure, box, symbol,
  string, vector) or changing character comparison/case semantics.

## Decisions

### D1 — A "misc-immediate" family under tag `001`, with a 5-bit subtype

Repurpose tag `001` (today "boolean") as a general **immediate-constant family**. The word
layout becomes:

```
   bit  63 …………………………………… 8 | 7 6 5 4 3 | 2 1 0
        [   payload : 56 bits   ] [ subtype:5 ] [ tag=001 ]

   subtype 0 → boolean    payload 0 = #f, payload 1 = #t
   subtype 1 → character  payload   = Unicode codepoint
   subtype 2 → eof-object      ] reserved — not implemented in this change
   subtype 3 → unspecified     ] (headroom only)
```

Concrete values:
- `#f` = subtype 0, payload 0 = `0b001` = **1** (⇒ `FALSE_V` unchanged, truthiness intact).
- `#t` = subtype 0, payload 1 = `(1<<8)|1` = **257** (⇒ `TRUE_V` changes `9`→`257`;
  safe per the truthiness analysis above).
- `#\c` = subtype 1, payload = codepoint = `(codepoint<<8) | (1<<3) | 1` = `(codepoint<<8)|9`.
  - `#\nul` (0) = `9`; `#\a` (97) = `24841`.

Derived predicates/ops (both runtime and emitter):
- `boolean?` : `(v & 0xFF) == 1` (tag `001`, subtype 0).
- `char?` : `(v & 0xFF) == 9` (tag `001`, subtype 1).
- `char->integer` : `v >> 8`. `integer->char` : `(cp << 8) | 9`.

**Rationale.** This gives a single principled home for all immediate singletons (the
proposal explicitly wants room for `eof-object`/unspecified), keeps `#f` — the only
load-bearing boolean constant — bit-for-bit unchanged, and needs no new primary tag. The
cost is re-encoding `#t` and teaching every `tag_of(v) == TAG_BOOL` site to sub-discriminate
by subtype (characters now also carry primary tag `001`).

**Alternative considered — carve characters out of the nil tag (`010`).** `nil` uses only
the single value `2`; a character could be `(codepoint<<4) | (1<<3) | 010` with bit 3 as a
nil/char discriminator, leaving booleans (`#t`=9, `#f`=1) completely untouched and thus
churning less runtime/emitter code. Rejected as the primary plan because it is an ad-hoc
hack that provides no principled room for future singletons and semantically overloads
`nil`. Kept as a fallback if re-encoding `#t` proves to disturb something unforeseen.

### D2 — `char->integer` / `integer->char` stay runtime calls initially

Keep the existing `rt_char_to_integer` / `rt_integer_to_char` externs (reimplemented as pure
bit shifts) rather than inlining the shift into the emitter. This minimizes the emitter diff
and keeps one obvious place per operation; inlining is a later, optional optimization.
Character **literals**, by contrast, are emitted inline as the immediate constant (that is
the whole point — no `rt_make_char`).

### D3 — Change runtime and emitter atomically, then regenerate bootstrap IR

The representation is a shared contract, so `runtime.c` and `emit.ss` change in one commit.
Because the emitter now emits different bits for `#t` and for character literals, the
committed stage-0 bootstrap IR that the emitter produced (`bootstrap/embed.ll`,
`embed-repl.ll`, `schemec.ll`, and `scheme.base.ll` if it embeds any character/boolean
constants) must be **regenerated** from source as part of this change and re-verified against
the self-hosting fixed point.

## Risks / Trade-offs

- **Runtime/emitter drift** → both are edited in the same change and validated by the
  existing demo suite plus the AOT/JIT/bitcode 3-way equivalence and REPL-vs-batch harnesses;
  a mismatch shows up as a diverging final value.
- **A hidden assumption that `#t == 9`** → audit: grep the runtime and emitter for literal
  `9`/`TRUE`; rely on the verified invariant that only `FALSE_V == 1` is load-bearing for
  truthiness; update `TRUE_V` and the emitter's `#t` constant in lockstep.
- **`tag_of(v) == TAG_BOOL` sites now also match characters** (both are tag `001`) → audit
  every such site (`rt_boolean_p`, `equal?`, both value printers) and order the character
  check before the boolean case, or switch on the low-byte discriminator.
- **Self-hosting fixed point** depends on byte-identical emitted IR → regenerating the
  committed bootstrap IR (D3) is a required, verified step, not optional cleanup.
- **REPL char identity via pointer** — nothing may assume a character is a heap pointer
  (e.g. GC scanning it). Immediates are inert to GC; the removed intern tables were the only
  place that mattered, and they go away.
- **Trade-off**: 56-bit character payload comfortably covers the 21-bit Unicode range;
  no practical loss of range.

## Open Questions

- Subtype numbering (`boolean=0`, `char=1`) is arbitrary but must be fixed once; confirm no
  external artifact hardcodes it. (Low risk — the encoding is internal.)
- Whether to inline `char->integer`/`integer->char` in the emitter (D2 defers this); revisit
  only if profiling shows the call overhead matters.
