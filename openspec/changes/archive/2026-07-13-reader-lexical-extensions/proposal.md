## Why

The Scheme reader (`read-from-string` in `src/prelude.scm`) reads a useful v1 subset —
integers, symbols, lists, `#t`/`#f`, `#\c`, `"strings"` (no escapes), `'`-quote, comments —
but three common lexical constructs are missing, and each blocks reading ordinary Scheme
source: **string escapes** (so `"a\nb"` and `"say \"hi\""` cannot be read), **named
characters** (so `#\newline`, `#\space`, `#\tab` are unreadable), and **dotted pairs** (so
`(a . b)` and improper-tail list literals cannot be read). These are purely lexical: they add
no new data types, only richer surface syntax over values that already exist. Adding them
moves the reader closer to reading its own source — a step on the self-hosting path.

## What Changes

- **Reader — string escapes** (`rd-string`): recognize backslash escapes inside string
  literals — `\n`, `\t`, `\r`, `\\`, `\"`, and `\xHH…;` (hex codepoint) — decoding them to the
  intended characters, and assemble the decoded characters into the resulting string.
- **Reader — named characters** (`rd-hash`, the `#\` branch): after `#\`, read the following
  token; a single character is that character, and a multi-character name maps to its
  character — `newline`, `space`, `tab`, `return`, `nul`/`null`, `delete`, and `altmode`/`esc`.
- **Reader — dotted pairs** (`rd-list`): recognize a standalone `.` token before the final
  element to read an improper list, so `(a . b)` reads as the pair `(a . b)` and
  `(a b . c)` as `(a b . c)`.
- No new value types; the printer already renders dotted pairs (`(cons 1 2)` prints
  `(1 . 2)`), so reading them needs no printer change.

## Capabilities

### New Capabilities
<!-- None: extends the existing reader with lexical syntax over existing value types. -->

### Modified Capabilities
- `core-language`: extend `read-from-string` to accept string escape sequences, named
  character literals, and dotted-pair (improper list) syntax.

## Impact

- **Code:**
  - `src/prelude.scm` — extend `rd-string` (escapes), `rd-hash` (named chars), and `rd-list`
    (dotted tail); add small helpers (hex-digit parse, char-name table lookup).
  - `demos/` — reader demos exercising escapes, named characters, and dotted pairs.
- **Verification:** `demos/run-tests.sh` and `demos/run-backends.sh` (3-way) with the new
  demos; existing reader demos unaffected.
- **Unaffected:** runtime, value representation, calling convention, and the frontend passes
  are all untouched — this is prelude-only Scheme. `aot-codegen` untouched.
- **Depends on:** `string-char-library` — assembling a string from decoded escape characters
  uses `list->string` (and named-character handling uses `char=?`/`string=?`-style lookups
  expressible via existing accessors). Sequence this change after `string-char-library`.
- **Enables:** reading real Scheme source with escaped strings and improper lists; a
  companion to `quasiquote` (which adds the remaining reader sugar) and to `vectors` (which
  adds `#(...)`).
