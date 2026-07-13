## Why

Strings are immutable in the current subset: they are created (literals, `make-string`,
`string-append`, …) and read (`string-ref`, `string-length`), but never modified in place.
R7RS provides `string-set!` for destructive update, and it is the one string operation the
earlier changes deliberately deferred — twice — because it raises a representation question
the accessor/library changes did not need to answer: strings are stored as **variable-width
UTF-8**, so replacing the character at a codepoint index can change the byte length of the
string. This change answers that question and adds mutation.

## What Changes

- **Representation decision** — keep the existing UTF-8 representation and implement
  `string-set!` by **splicing**: rebuild the byte buffer with the replacement codepoint's
  bytes in place of the old codepoint's bytes, then update the string object's byte-length and
  bytes-pointer words **in place** so object identity (and aliasing) is preserved (design D1).
- **Runtime** — add `rt_string_set` (`string-set!`): mutate the string at a codepoint index,
  and `rt_string_copy` (`string-copy`): a fresh, independently-mutable duplicate, so callers
  can mutate a copy rather than a shared literal.
- **Frontend / codegen** — wire `string-set!` and `string-copy` as reserved primitives.
- **`make-string` note** — `string-char-library` defined `(make-string k ch)` as producing a
  filled string; with this change that string is mutable via `string-set!` (design D2).

## Capabilities

### New Capabilities
<!-- None: extends the existing string data type with in-place mutation. -->

### Modified Capabilities
- `core-language`: add in-place string mutation (`string-set!`) and `string-copy`, with
  codepoint-indexed, identity-preserving semantics.

## Impact

- **Code:**
  - `src/runtime/runtime.c` — `rt_string_set` (splice + update length/pointer words in place)
    and `rt_string_copy`; reuse the UTF-8 encode/decode helpers.
  - `src/parse.ss` — add `string-set! string-copy` to `*prims*`.
  - `src/emit.ss` — add each to `prim-table` and emit its `declare` (arities 3, 1).
  - `demos/` — mutation demos including a case that changes the byte length (ASCII ↔ multibyte)
    and an aliasing case.
- **Verification:** `demos/run-tests.sh` and `demos/run-backends.sh` (3-way) with the new
  demos; existing demos unaffected.
- **Unaffected:** value representation (still tag-7 `HDR_STRING`) and the calling convention
  are unchanged, so `aot-codegen` is untouched — a `core-language` addition.
- **Depends on:** `string-char-library` — `make-string` gives a natural mutable target, and
  `rt_string_set` reuses that change's UTF-8 encode helper. Sequence after it.
- **Enables:** in-place text building; completes the R7RS-style `make-string` + `string-set!`
  idiom.
