## Context

`scheme-reader` added `read-from-string`: a recursive-descent reader written in pure Scheme in
`src/prelude.scm`. The scan position is threaded functionally as `(datum . next-index)` pairs;
characters are classified by codepoint (`char->integer`) because character literals are not
interned. The v1 reader handles integers, symbols, lists, `#t`/`#f`, `#\c` (single char),
`"strings"` with **no escapes** (contents copied verbatim via `substring`), `'`-quote sugar,
whitespace, and `;` comments. This change extends three of those readers — `rd-string`,
`rd-hash`, `rd-list` — with additional lexical syntax. No new data types are introduced.

## Goals / Non-Goals

**Goals:**
- String escapes in `"…"`: `\n`, `\t`, `\r`, `\\`, `\"`, and `\xHH…;`.
- Named character literals: `#\newline`, `#\space`, `#\tab`, `#\return`, `#\nul`/`#\null`,
  `#\delete`, `#\altmode`/`#\esc` (a small, common set), plus the existing single-char form.
- Dotted-pair / improper-list syntax: `(a . b)`, `(a b . c)`.

**Non-Goals:**
- Quasiquote / unquote reader sugar (`` ` `` `,` `,@`) — the `quasiquote` change.
- Vector literal syntax `#(...)` — the `vectors` change (needs the vector type first).
- Block comments `#| |#`, datum comments `#;`, and `#!` directives — deferred.
- Non-integer numeric syntax (floats, radix prefixes, ratios) — out of scope (fixnums only).
- Full R7RS named-character set and `\xHH;` surrogate validation — a pragmatic subset.

## Decisions

### D1 — String escapes: scan character-by-character, assemble via `list->string`

`rd-string` changes from "copy the verbatim run up to the closing quote with `substring`" to
scanning character by character, accumulating decoded characters, and building the result with
`list->string` (from `string-char-library` — hence the dependency). On encountering `\`, the
next character selects the escape: `n`→newline, `t`→tab, `r`→return, `\`→backslash,
`"`→double-quote; `x` begins a hex sequence read up to a terminating `;`, decoded with
`integer->char`. A backslash before any other character is an error for this subset (kept
simple; documented). Characters are produced via `integer->char` on the intended codepoint so
no character interning assumptions are needed.

### D2 — Named characters: token lookup after `#\`

The `#\` branch of `rd-hash` reads the token following `#\` up to the next delimiter. If the
token is exactly one character, the literal is that character (the existing behavior). If it
is longer, it is looked up in a small name→codepoint table and produced with `integer->char`:

| name | codepoint |
|------|-----------|
| `space` | 32 |
| `newline` | 10 |
| `tab` | 9 |
| `return` | 13 |
| `nul` / `null` | 0 |
| `delete` | 127 |
| `altmode` / `esc` | 27 |

An unknown multi-character name is an error for this subset (documented). The table is a
straightforward `cond` over the token compared with `string=?` (from `string-char-library`).

### D3 — Dotted pairs: detect a standalone `.` token in `rd-list`

`rd-list` currently reverses an accumulator into a proper list at the closing `)`. It gains a
check: when the next token (delimiter-bounded) is exactly `.`, read one further datum as the
improper tail, skip whitespace, require the closing `)`, and return
`(append-reverse acc tail)` — i.e. the reversed accumulated elements terminated by `tail`
instead of `()`. A lone `.` not in tail position, or more than one datum after the `.`, is an
error for this subset (documented). Detection distinguishes the token `.` from symbols that
merely start with `.` by requiring the whole delimiter-bounded token to equal `.`.

### D4 — Prelude-only; no runtime, frontend, or printer change

All three extensions live in `read-from-string`'s helpers in `prelude.scm`. The value types
produced (characters, strings, pairs) already exist, and the runtime printer already renders
improper pairs (`(cons 1 2)` → `(1 . 2)`), so nothing outside the prelude changes. The reader
remains a set of pure functions threading `(datum . index)`.

## Risks / Trade-offs

- **Dependency on `string-char-library`** — `list->string` (escape assembly) and `string=?`
  (name lookup) come from that change; this one must be sequenced after it. Recorded in
  Impact.
- **Error handling is minimal** — malformed escapes, unknown character names, and misplaced
  `.` are documented as undefined/error for this subset, consistent with the reader's existing
  lenient stance; a checked-error reader comes with the broader error story.
- **`\xHH;` scope** — decodes to a codepoint via `integer->char` without validating Unicode
  scalar-value ranges (surrogates); acceptable for the subset, noted.
- **Named-character set is a subset** — the common names are covered; the full R7RS set can be
  extended in the same table later without interface change.
- **Distinguishing `.` from dotted symbols** — handled by requiring the entire token to be
  `.`; symbols like `...` (used by macros) are unaffected because they are longer tokens.
