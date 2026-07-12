## Why

The final step of the reader arc: a **reader written in Scheme**. With symbols, strings,
characters, the string/char accessors, and a prelude to host shared code all in place, the
compiler can now parse Scheme source text into data — the front of its own pipeline
(`read → expand → …`), and the piece self-hosting most concretely needs. This change adds
`read-from-string`, a recursive-descent reader living in the prelude (arc:
strings/char-ops → prelude → **`read.ss`**).

## What Changes

- **`read.ss` in the prelude** — a Scheme reader providing `read-from-string`: given a
  source string, it returns the first datum. Written in the M-subset (recursion, `cond`,
  the string/char accessors, `cons`, arithmetic), threading the scan position functionally.
- **Datums read (v1):** integers (optionally signed), symbols, the empty list and proper
  lists `( … )`, booleans `#t`/`#f`, single-codepoint characters `#\x`, strings `" … "`
  (no escape sequences yet), and `'`-quote sugar (`'x` → `(quote x)`); interleaved
  whitespace and `;` line comments are skipped.
- **Interning** — symbols are produced via `string->symbol`, so a read symbol is `eq?` to
  the same-named literal (the property the expander/compiler will rely on).

## Capabilities

### New Capabilities
<!-- None: adds a reader procedure to the existing core language / prelude. -->

### Modified Capabilities
- `core-language`: add `read-from-string`, parsing source text into data (symbols, strings,
  characters, integers, booleans, and proper lists, with quote sugar and comments).

## Impact

- **Code:**
  - `src/prelude.scm` — add the reader (`read-from-string` + internal helpers); depends on
    the prelude mechanism and the string/char operations already shipped.
  - `demos/` — read a nested list, a mix of datum types, quote sugar, and traverse the
    result.
- **Verification:** reader demos across AOT/JIT/bitcode; existing demos unaffected.
- **Unaffected:** the runtime, the emitter, the calling convention, and the passes — the
  reader is ordinary Scheme in the prelude.
- **Deferred (noted):** string escape sequences (`\n`, `\"`, …; need string-building ops),
  named characters (`#\space`, `#\newline`), dotted pairs `( a . b )`, quasiquote/unquote,
  vectors `#( … )`, the fuller number tower (floats, rationals, radix prefixes), and reading
  from a port / stdin (no I/O yet).
- **Enables (future):** replacing the host Chez `read` at the front of the pipeline (a
  self-hosting milestone) and a `syntax-rules` expander that consumes read data.
