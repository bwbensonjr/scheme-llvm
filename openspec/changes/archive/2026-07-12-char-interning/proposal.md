## Why

`n-ary-equality-and-not` added `eqv?` but left a known gap: characters are boxed
`{ HDR_CHAR, codepoint }` objects created fresh per literal and never interned, so
`(eqv? #\a #\a)` is `#f` — violating R7RS, which requires `eqv?` on equal characters to be
`#t`. The fix is the same mechanism symbols already use: **intern characters** so equal
codepoints share one object. Because `rt_eqv_p`/`rt_eq_p` are already identity (`a == b`),
interning makes both correct on characters with **no frontend change** — a small,
self-contained runtime change that closes the gap the previous change deferred.

## What Changes

- Intern characters in `rt_make_char`: canonicalize by codepoint through a char intern
  table (mirroring the symbol `intern_table` — a growable, `GC_MALLOC_UNCOLLECTABLE`,
  scanned array held as a GC root), so two chars with the same Unicode scalar value are the
  same word.
- As a consequence, `(eqv? #\a #\a)` ⇒ `#t` and `(eq? #\a #\a)` ⇒ `#t`; chars obtained
  different ways but with equal codepoints (`#\A`, `(integer->char 65)`, `(string-ref "A" 0)`)
  are all identical objects.
- **No frontend, ABI, or calling-convention change.** `rt_make_char` is the single factory
  for every char (literals via `@rt_make_char`, `integer->char`, `string-ref`), so
  interning there covers all paths; `eqv?`/`eq?` stay `a == b`.
- Update the `core-language` spec: the `eqv? primitive` requirement's caveat that
  characters are not covered is removed, and a `Character interning` requirement is added.

## Capabilities

### New Capabilities
<!-- None: characters and eqv? already exist in core-language; this corrects their identity semantics. -->

### Modified Capabilities
- `core-language`: add a requirement that characters are interned (equal codepoints are the
  same object, so `eq?`/`eqv?` hold on them), and amend the `eqv?` requirement to drop the
  character exclusion.

## Impact

- **Runtime:** `src/runtime/runtime.c` — add a char intern table and route `rt_make_char`
  through it. This is the only code change.
- **Unaffected:** `src/emit.ss`, `src/parse.ss`, `src/passes/*`, `src/prelude.scm` — no
  frontend change; `eqv?`/`eq?` bodies are unchanged.
- **Demos:** a new demo asserting `eqv?`/`eq?` on characters (including cross-construction
  identity) plus entries in `demos/run-tests.sh` / `demos/run-backends.sh`. Existing string
  and Unicode demos must still pass (chars are immutable, so sharing is transparent).
- **Performance:** char creation gains an intern lookup. Interning mirrors symbols
  (linear scan); a Latin-1 fast path keeps the common ASCII case O(1) (see design).
