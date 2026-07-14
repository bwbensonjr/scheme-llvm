## 1. Re-express the escaping in-language

- [x] 1.1 Replace `hex2` with an in-language two-digit uppercase hex formatter over a fixed hex-digit table (`quotient`/`remainder` by 16 + `string-ref`); no `number->string` radix, no `string-upcase`.
- [x] 1.2 Add an in-language UTF-8 encoder: Unicode scalar → its 1–4 byte sequence via the standard range checks and `quotient`/`remainder` math (`utf8-bytes`).
- [x] 1.3 Rewrite `llvm-cstring` to walk the string by codepoint (`string-ref`/`char->integer`), encode each scalar to bytes, and apply the existing pass-through/`\XX` decision + trailing-NUL count. Dropped `string->utf8`/`bytevector-*` (and the `#x` literals, using decimal).

## 2. Verification

- [x] 2.1 Confirm emitted IR is byte-identical to before across the demo + backend-equivalence suites (esp. the Unicode demos `unicode.scm`, `string-unicode.scm`). — direct new-vs-old `.ll` diff byte-identical on all escaping-heavy demos.
- [x] 2.2 Add a targeted case covering a 2-, 3-, and 4-byte codepoint and a control character (`\XX`). — 2/3-byte via existing unicode demos; new `demos/utf8-4byte.scm` covers the 4-byte path (😀 → `\F0\9F\98\80`), byte-identical to old; control chars via `reader-lexical.scm`.
- [x] 2.3 Re-run the [[self-hosting-bootstrap]] gate probe: `emit.ss` compiles in the subset (G2 closed). Run `./run-all-tests.sh`; all suites pass. — G2 ops removed from `emit.ss`; all 9 suites pass.
