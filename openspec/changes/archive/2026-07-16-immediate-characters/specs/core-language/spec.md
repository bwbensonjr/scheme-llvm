## MODIFIED Requirements

### Requirement: Character interning

Characters SHALL be **immediate** tagged values: the Unicode scalar value is encoded
directly in the tagged word, with no heap allocation and no intern table. Because equal
codepoints produce the identical immediate word, two characters with the same codepoint
SHALL be the same value regardless of how each was constructed (a `#\c` literal,
`(integer->char n)`, or `(string-ref s i)`). Consequently `eq?` and `eqv?` SHALL return
`#t` for characters with equal codepoints and `#f` for characters with different codepoints.
As immediates, characters are trivially GC-safe (they are never heap objects) under both the
AOT and JIT backends.

#### Scenario: Equal characters are identical

- **WHEN** a program evaluates `(eqv? #\a #\a)` and `(eq? #\a #\a)`
- **THEN** both results are `#t`

#### Scenario: Identity across construction paths

- **WHEN** a program evaluates `(eq? #\A (integer->char 65))` and
  `(eq? (string-ref "A" 0) #\A)`
- **THEN** both results are `#t`

#### Scenario: Distinct characters differ

- **WHEN** a program evaluates `(eqv? #\a #\b)`
- **THEN** the result is `#f`

### Requirement: eqv? primitive

The compiler SHALL provide `eqv?` as a reserved primitive that returns `#t` when its two
arguments are the same object, and `#f` otherwise. In the current subset `eqv?` SHALL agree
with `eq?`: it holds for fixnums (immediate), interned symbols, and immediate characters
(equal codepoints are the same immediate word). Value comparison for non-immediate numbers
(flonums, bignums) — where `eqv?` would diverge from `eq?` — is deferred until such numbers
exist.

#### Scenario: eqv? on fixnums, symbols, and characters

- **WHEN** a program evaluates `(eqv? 3 3)`, `(eqv? 3 4)`, `(eqv? 'x 'x)`, and
  `(eqv? #\a #\a)`
- **THEN** the results are `#t`, `#f`, `#t`, and `#t`
