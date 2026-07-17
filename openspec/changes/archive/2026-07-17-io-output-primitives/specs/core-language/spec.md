## ADDED Requirements

### Requirement: newline writes a line separator

The `newline` primitive SHALL accept zero arguments and write a single newline
character (U+000A, `\n`) to standard output. It SHALL return the unspecified
value so it composes inside `begin` and after other output primitives.

Calling `newline` with any arguments SHALL be an error (arity mismatch),
consistent with how other fixed-arity primitives report arity errors.

#### Scenario: newline writes a single line feed

- **WHEN** a program runs `(begin (display "a") (newline) (display "b"))`
- **THEN** the program writes the three bytes `a`, `\n`, `b` to standard output
  in that order

#### Scenario: newline returns the unspecified value

- **WHEN** a program runs `(begin (newline) (quote done))`
- **THEN** the program completes normally and its value is the symbol `done`
  (the `newline` call does not contribute a value)

### Requirement: write writes any datum in write style

The `write` primitive SHALL accept a value of ANY type and write a machine-
readable rendering of it to standard output, in R7RS *write* style: a string
SHALL be written WITH surrounding double quotes, and a character SHALL be written
WITH its `#\` prefix (e.g. `#\a`, `#\newline`). Every other value type — fixnum,
boolean, the empty list, pair, symbol, vector, and any other representable value
— SHALL be written the same as `display`. Compound values (pairs, vectors) SHALL
be rendered by recursing in write style, so nested strings and characters inside
them are also quoted/prefixed. `write` SHALL return the unspecified value so it
composes inside `begin`.

The value printer SHALL be memory-safe: it SHALL dispatch on a value's runtime
tag and SHALL NOT interpret a value as a type it is not. Passing any value to
`write` SHALL NOT cause a memory fault or crash.

This is the write-style companion to the display-style `display` primitive, and
uses the same value printer that renders a program's final top-level value.

#### Scenario: write of a string keeps the quotes

- **WHEN** a program runs `(write "hello")`
- **THEN** the program writes `"hello"` (with surrounding double quotes) to
  standard output

#### Scenario: write of a character keeps the prefix

- **WHEN** a program runs `(write #\a)`
- **THEN** the program writes `#\a` to standard output

#### Scenario: write recurses in write style through structure

- **WHEN** a program runs `(write (list "a" #\b 3))`
- **THEN** the program writes `("a" #\b 3)` — the inner string is quoted and the
  inner character has its `#\` prefix

#### Scenario: write of a non-string never crashes

- **WHEN** a program runs `(write X)` for a non-string `X` — for example a
  fixnum, a pair such as `(cons 1 2)`, a symbol, or the empty list
- **THEN** the program renders `X` and completes normally, with no segmentation
  fault or memory error

#### Scenario: write matches the final-value print style

- **WHEN** a program runs `(write (list "a" #\b))` and a second program is just
  the bare expression `(list "a" #\b)` (printed by the runner as the top-level
  value)
- **THEN** both programs write the identical bytes `("a" #\b)` to standard output
