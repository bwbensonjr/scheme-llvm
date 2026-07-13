## ADDED Requirements

### Requirement: Structural equality

The compiler SHALL provide `equal?`, a structural equality predicate. `equal?` SHALL return
`#t` when its two arguments are `eqv?`; when both are pairs whose cars and cdrs are
recursively `equal?`; or when both are strings with identical codepoint content. Otherwise it
SHALL return `#f`. `equal?` therefore compares strings by content (not identity) and compares
compound list structure element by element.

#### Scenario: Nested list structure by value

- **WHEN** a program evaluates `(equal? (list 1 (list 2 3)) (quote (1 (2 3))))`
- **THEN** the result is `#t`

#### Scenario: Strings compared by content, not identity

- **WHEN** a program evaluates `(equal? (substring "xhello" 1 6) "hello")`
- **THEN** the result is `#t` (the two strings are distinct objects with equal content)

#### Scenario: Unequal structure

- **WHEN** a program evaluates `(equal? (quote (1 2)) (quote (1 2 3)))`
- **THEN** the result is `#f`

### Requirement: Structural list search (member, assoc)

The compiler SHALL provide `member` and `assoc`, the structural analogues of `memq` and
`assq`. `member` SHALL return the first tail of the list whose head is `equal?` to the key,
or `#f`. `assoc` SHALL return the first pair in an association list whose car is `equal?` to
the key, or `#f`.

#### Scenario: member finds by value

- **WHEN** a program evaluates `(member (list 2) (quote ((1) (2) (3))))`
- **THEN** the result is `((2) (3))`

#### Scenario: assoc finds by value

- **WHEN** a program evaluates `(assoc "b" (quote (("a" . 1) ("b" . 2))))`
- **THEN** the result is `("b" . 2)`

### Requirement: List combinators (filter, fold-left, fold-right)

The compiler SHALL provide `filter`, `fold-left`, and `fold-right` over a single list.
`filter` SHALL return a new list of the elements satisfying the predicate, in order.
`fold-left` SHALL apply `(f acc elem)` left-to-right with a tail-recursive accumulator;
`fold-right` SHALL apply `(f elem acc)` right-to-left. Argument order follows R6RS.

#### Scenario: filter

- **WHEN** a program evaluates `(filter (lambda (n) (< 1 n)) (quote (1 2 3 0 4)))`
- **THEN** the result is `(2 3 4)`

#### Scenario: fold-left accumulates left to right

- **WHEN** a program evaluates `(fold-left (lambda (a b) (- a b)) 0 (quote (1 2 3)))`
- **THEN** the result is `-6` (`((0-1)-2)-3`)

#### Scenario: fold-right accumulates right to left

- **WHEN** a program evaluates `(fold-right (lambda (x acc) (cons x acc)) (quote ()) (quote (1 2 3)))`
- **THEN** the result is `(1 2 3)`

Note: primitives (`-`, `cons`, …) are not first-class values in this compiler, so a
higher-order argument must be a lambda (e.g. `(lambda (a b) (- a b))`), not the bare primitive.
