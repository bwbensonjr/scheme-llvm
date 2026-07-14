## Why

The self-hosting gate check ([[self-hosting-bootstrap]] task 1.2) found `emit.ss`'s LLVM
C-string escaping (`hex2`, `llvm-cstring`) uses Chez operations scheme-llvm does not provide:
`string->utf8`, `bytevector-length`, `bytevector-u8-ref`, `(number->string b 16)` (a radix
argument — the in-language `number->string` is base-10 / one-arg), and `string-upcase`. So the
emitter — the stage that turns every symbol/string name into an LLVM `c"…"` literal with `\XX`
hex escapes — cannot compile itself. This is gap **G2**.

## What Changes

- Rewrite `hex2` and `llvm-cstring` to run in the scheme-llvm subset: iterate a string's
  Unicode scalars via `string-ref`/`char->integer`, encode each to its UTF-8 byte sequence
  **in-language**, and hex-format each non-verbatim byte with an in-language two-digit
  uppercase hex formatter (a fixed digit table, not `number->string` radix / `string-upcase`).
- Keep the emitted IR **byte-for-byte identical** to today's output (printable ASCII except
  `"` and `\` pass through; every other byte becomes `\XX`, uppercase, trailing NUL counted).
- Add no runtime primitives — the escaping becomes pure Scheme over existing string/char ops,
  consistent with keeping the self-hosting language surface small.

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `core-language`: (internal-refactor) the emitter's C-string escaping is expressed in the
  self-hostable subset; no observable language behavior changes — the emitted IR is identical.

## Impact

- **Code**: `src/emit.ss` (`hex2`, `llvm-cstring`, and a small in-language UTF-8 encoder + hex
  helper). No runtime change.
- **Depends on**: nothing hard; unblocks [[self-hosting-bootstrap]] (G2). Pairs with
  [[internal-defines]] (G1) so the whole core becomes compilable.
- **Risk guard**: the existing byte-identical backend-equivalence suite catches any escaping
  drift.
