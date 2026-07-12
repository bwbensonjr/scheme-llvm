## ADDED Requirements

### Requirement: Symbols and quoted structure

The compiler SHALL support symbols as a first-class data type: symbols are interned (two
symbols with the same name are `eq?`), and are printed by name. The compiler SHALL support
`quote` of a symbol and `quote` of arbitrary list/atom structure (nested pairs whose
elements are symbols, fixnums, booleans, `()`, or further pairs).

#### Scenario: Quoted symbol and eq?

- **WHEN** a program evaluates `(eq? (quote foo) (quote foo))` and `(eq? (quote foo) (quote bar))`
- **THEN** the results are `#t` and `#f` (symbols with the same name are identical)

#### Scenario: Quoted list structure

- **WHEN** a program evaluates `(quote (a (b c) 1))` and traverses it with `car`/`cdr`
- **THEN** it is a proper list whose elements are the symbol `a`, the list `(b c)`, and the
  fixnum `1`, printing as `(a (b c) 1)`

#### Scenario: Symbol printed by name

- **WHEN** a program's value is a symbol (e.g. `(quote hello)`)
- **THEN** the executable prints `hello`
