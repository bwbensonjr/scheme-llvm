## 1. Reader: string escapes (`rd-string`)

- [x] 1.1 Rework `rd-string` to scan character-by-character, accumulating decoded characters
- [x] 1.2 Handle `\n`, `\t`, `\r`, `\\`, `\"` (single-character escapes)
- [x] 1.3 Handle `\xHH…;` — read hex digits to the `;`, decode via `integer->char`
- [x] 1.4 Assemble the accumulated characters into the string with `list->string`
- [x] 1.5 Document that an unrecognized escape is an error for this subset

## 2. Reader: named characters (`rd-hash` `#\` branch)

- [x] 2.1 Read the token after `#\` to the next delimiter
- [x] 2.2 Single-character token → that character (existing behavior preserved)
- [x] 2.3 Multi-character token → name→codepoint table (`space newline tab return nul/null delete altmode/esc`) via `integer->char`
- [x] 2.4 Document that an unknown multi-character name is an error for this subset

## 3. Reader: dotted pairs (`rd-list`)

- [x] 3.1 Detect a standalone `.` token (whole delimiter-bounded token equals `.`)
- [x] 3.2 Read one further datum as the improper tail; require the closing `)`
- [x] 3.3 Return the reversed accumulated elements terminated by the tail (improper list)
- [x] 3.4 Document that a misplaced `.` or multiple tail data is an error for this subset

## 4. Demos and tests

- [x] 4.1 Demo: `(read-from-string "\"a\\nb\"")` yields a 3-character string with an embedded newline
- [x] 4.2 Demo: `(read-from-string "#\\newline")` and `(read-from-string "#\\space")` yield the right characters
- [x] 4.3 Demo: `(read-from-string "(a . b)")` yields the pair `(a . b)`; `(a b . c)` improper list
- [x] 4.4 Add the demos to `demos/run-tests.sh` with expected values

## 5. Verify

- [x] 5.1 Build and run the demos; confirm the reader produces the expected data
- [x] 5.2 `demos/run-backends.sh`: the new demos agree across AOT/JIT/bitcode
- [x] 5.3 Confirm existing reader demos unaffected (prelude-only change)

## 6. Docs and spec sync

- [x] 6.1 Update the root `README.md` reader description (escapes / named chars / dotted pairs)
- [ ] 6.2 Sync the `core-language` (modified) delta into `openspec/specs/` (done at archive time via `openspec archive`)
