## Why

`string-char-operations` added the foundational accessors (`string-length`, `string-ref`,
`substring`, `char->integer`, `integer->char`, `string->symbol`) but deliberately deferred
the *comparison and construction* library — `char=?`/`char<?`, `string=?`, `string-append`,
`symbol->string`, `string->list`/`list->string`, `make-string` — to "add when a consumer
needs them." Those consumers have arrived: comparing and building strings/chars is needed to
write richer programs and is a prerequisite for a fuller reader and for text-producing code.
This change fills in that non-mutating string/character library. (String *mutation* —
`string-set!` — is a separate change, `string-mutation`, because it raises a
representation question this change does not.)

## What Changes

- **Runtime** — add content-level primitives on the existing tag-7 string objects:
  `string=?` (content equality of two strings), `string-append` (concatenate two strings),
  `symbol->string` (a symbol's name as a fresh string), `list->string` (a list of characters
  → a string), and `make-string` (a string of *k* copies of a fill character).
- **Prelude** — add the operations expressible in Scheme over existing primitives:
  the character comparisons `char=?`, `char<?`, `char>?`, `char<=?`, `char>=?` (n-ary,
  reducing through `char->integer` and the existing n-ary numeric comparisons), and
  `string->list` (a string → list of its characters).
- **Arity decision** — `string=?` and `string-append` are **binary** in this change;
  character comparisons are **n-ary**. N-ary string variants are deferred (design D2).
- **Immutability decision** — `make-string` produces an **immutable** filled string; whether
  it should yield a mutable buffer is revisited by the `string-mutation` change (design D3).

## Capabilities

### New Capabilities
<!-- None: extends the existing string/char data types with library operations. -->

### Modified Capabilities
- `core-language`: add the string/character comparison and construction procedures
  (`char=?`, `char<?`, `char>?`, `char<=?`, `char>=?`, `string=?`, `string-append`,
  `symbol->string`, `string->list`, `list->string`, `make-string`).

## Impact

- **Code:**
  - `src/runtime/runtime.c` — `rt_string_eq`, `rt_string_append`, `rt_symbol_to_string`,
    `rt_list_to_string`, `rt_make_string_fill` (UTF-8 aware; reuse the existing decode/encode
    helpers).
  - `src/parse.ss` — add `string=? string-append symbol->string list->string make-string`
    to `*prims*`.
  - `src/emit.ss` — add each to `prim-table` and emit its `declare` (correct arity).
  - `src/prelude.scm` — `char=?`/`char<?`/`char>?`/`char<=?`/`char>=?` and `string->list`.
  - `demos/` — comparison/construction demos including a non-ASCII round-trip.
- **Verification:** `demos/run-tests.sh` and `demos/run-backends.sh` (3-way) with the new
  demos; existing demos unaffected.
- **Unaffected:** value representation and the calling convention are unchanged (new
  primitives + prelude procedures), so `aot-codegen` is untouched — a `core-language`
  addition.
- **Depends on:** nothing (Wave A; independent).
- **Enables:** `string-mutation` (`make-string` is its starting point), richer reader/text
  code; complements `equality-and-list-library` (`equal?` already compares string content
  internally; `string=?` exposes it directly).
