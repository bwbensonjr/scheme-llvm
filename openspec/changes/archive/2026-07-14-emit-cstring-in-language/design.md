## Context

`llvm-cstring name` currently does `(string->utf8 name)` then walks the bytevector, passing
printable ASCII (except `"`/`\`) through verbatim and emitting `\XX` (via `hex2`) for every
other byte, with a trailing NUL added to the count. `hex2 b` does `(number->string b 16)` then
pads to two digits and `string-upcase`s. scheme-llvm strings are UTF-8 with codepoint-indexed
`string-ref` (returns a char whose `char->integer` is the scalar value), and its in-language
`number->string` is base-10 / single-arg — so both helpers must be re-expressed over
`string-ref`/`char->integer` and explicit byte math.

## Goals / Non-Goals

**Goals:** the same `\XX`-escaped `c"…"` payload and byte count as today, computed with only
scheme-llvm subset operations (no `string->utf8`, bytevector ops, radix `number->string`, or
`string-upcase`).

**Non-Goals:** a general `string->utf8` primitive or bytevector type (not needed — only the
emitter consumes bytes, and it can encode them inline); changing the escape policy or the
literal format.

## Decisions

### D1: In-language UTF-8 encoder over scalars

Walk the string by codepoint index `0..(string-length s)`; for each `(char->integer
(string-ref s i))` scalar `cp`, produce its UTF-8 bytes with the standard ranges:
`cp < #x80` → one byte; `< #x800` → two; `< #x10000` → three; else four (using
`quotient`/`remainder` by 64 for the continuation bytes, all in-language). Feed each byte
through the same pass-through/escape decision as today. This reproduces exactly what
`string->utf8` yielded, so the emitted literal is unchanged.

### D2: In-language two-digit uppercase hex

`byte→hh`: index a fixed 16-char uppercase hex-digit string `"0123456789ABCDEF"` by
`(quotient b 16)` and `(remainder b 16)` via `string-ref`, concatenating the two chars. This
replaces `(number->string b 16)` + pad + `string-upcase` and is trivially deterministic.

### D3: Verify by byte-identical IR

Correctness = the `.ll` output is unchanged. The backend-equivalence / demo suites already
compare emitted IR byte-for-byte across the AOT/JIT/bitcode backends and a broad demo set
(including Unicode string/char demos: `unicode.scm`, `string-unicode.scm`), so any drift in
the escaping surfaces immediately. Add a targeted case if a byte range is under-covered
(e.g. a 3- and 4-byte codepoint, and a control char) .

## Risks / Trade-offs

- **UTF-8 encoding bug** → guarded by the existing Unicode demos plus a targeted multi-byte
  case; the encoder is the classic fixed-range algorithm.
- **Performance** → per-codepoint encode is O(n) like the current bytevector walk; symbol/
  string names are short, so no concern.
