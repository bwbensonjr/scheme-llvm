## MODIFIED Requirements

### Requirement: Read data from source text

The compiler SHALL provide `read-from-string`, which parses a source string and returns the
first datum it contains. The reader SHALL recognize integers (optionally signed), symbols,
the empty list, proper lists `( … )` and dotted/improper lists `( … . x)`, booleans
`#t`/`#f`, characters `#\x` (single codepoint) and named characters, strings `" … "` with
escape sequences, `#(...)` vectors, and `'`-quote sugar (`'x` reads as `(quote x)`), skipping
interleaved whitespace and `;` line comments. Symbols SHALL be interned (a read symbol is
`eq?` to the same-named literal).

String literals SHALL support the escape sequences `\n` (newline), `\t` (tab), `\r` (return),
`\\` (backslash), `\"` (double quote), and `\xHH…;` (a hexadecimal Unicode codepoint
terminated by `;`), decoding each to the intended character.

Character literals SHALL support named characters in addition to the single-character form:
`#\space`, `#\newline`, `#\tab`, `#\return`, `#\nul` (and `#\null`), `#\delete`, and
`#\altmode` (and `#\esc`), each denoting its corresponding character.

List syntax SHALL support dotted pairs: a standalone `.` before the final element within
parentheses SHALL produce an improper list whose tail is the datum following the `.`, so
`(a . b)` reads as the pair of `a` and `b`.

Malformed input for these extensions (an unrecognized escape, an unknown character name, or a
misplaced `.`) is undefined for this subset.

#### Scenario: Read a nested list

- **WHEN** a program evaluates `(read-from-string "(a (b c) 42)")`
- **THEN** the result is the list `(a (b c) 42)` — the symbol `a`, the list `(b c)`, and the
  fixnum `42`

#### Scenario: Read atoms of each type

- **WHEN** a program reads `"42"`, `"hello"`, `"#t"`, `"#\\z"`, and `"\"hi\""`
- **THEN** the results are the fixnum `42`, the symbol `hello`, the boolean `#t`, the
  character `#\z`, and the string `"hi"`

#### Scenario: Read symbols are interned

- **WHEN** a program evaluates `(eq? (read-from-string "foo") (quote foo))`
- **THEN** the result is `#t`

#### Scenario: Quote sugar and comments

- **WHEN** a program evaluates `(read-from-string "; a comment\n 'x")`
- **THEN** the comment is skipped and the result is the list `(quote x)`

#### Scenario: String escape sequences

- **WHEN** a program evaluates `(string-length (read-from-string "\"a\\nb\""))`
- **THEN** the result is `3` (the string `a`, newline, `b`)

#### Scenario: Escaped double quote

- **WHEN** a program evaluates `(read-from-string "\"say \\\"hi\\\"\"")`
- **THEN** the result is the string `say "hi"`

#### Scenario: Named character literal

- **WHEN** a program evaluates `(char->integer (read-from-string "#\\newline"))`
- **THEN** the result is `10`

#### Scenario: Dotted pair

- **WHEN** a program evaluates `(read-from-string "(a . b)")`
- **THEN** the result is the pair `(a . b)` (`car` is the symbol `a`, `cdr` is the symbol `b`)

#### Scenario: Improper list with leading elements

- **WHEN** a program evaluates `(read-from-string "(a b . c)")`
- **THEN** the result is the improper list `(a b . c)`
