## ADDED Requirements

### Requirement: Compositional car/cdr combinators

The standard prelude SHALL provide the compositional `car`/`cdr` accessors `caar`, `cadr`,
`cdar`, `cddr` and the depth-3 forms (`caaar` … `cdddr`), each equivalent to the
corresponding composition of `car` and `cdr`.

#### Scenario: cadr and caddr

- **WHEN** a program evaluates `(cadr '(1 2 3))` and `(caddr '(1 2 3))`
- **THEN** the results are `2` and `3` respectively

#### Scenario: mixed accessor

- **WHEN** a program evaluates `(cdar '((1 2) 3))`
- **THEN** the result is `(2)`

### Requirement: case derived form

The language SHALL support `case` as a derived syntactic form: `(case KEY ((datum ...) body
...) ... (else body ...))` evaluates KEY once and runs the first clause whose datum list
contains KEY (compared with `eqv?`), or the `else` clause if none match.

#### Scenario: case selects a matching clause

- **WHEN** a program evaluates `(case 2 ((1) 'a) ((2 3) 'b) (else 'c))`
- **THEN** the result is `'b`

#### Scenario: case falls through to else

- **WHEN** a program evaluates `(case 9 ((1) 'a) ((2 3) 'b) (else 'c))`
- **THEN** the result is `'c`
