## ADDED Requirements

### Requirement: Vector data type and operations

The compiler SHALL provide a mutable, fixed-length vector data type and the operations
`make-vector`, `vector`, `vector-ref`, `vector-set!`, `vector-length`, `vector?`, and
`list->vector`. `(make-vector k fill)` SHALL return a vector of `k` elements each initialized
to `fill`. `(vector e …)` SHALL return a vector of its arguments in order. `(vector-ref v i)`
SHALL return the `i`-th element (0-based). `(vector-set! v i x)` SHALL replace the `i`-th
element with `x` in place. `(vector-length v)` SHALL return the element count as a fixnum.
`(vector? x)` SHALL return `#t` iff `x` is a vector. `(list->vector xs)` SHALL return a vector
of the list's elements in order. Out-of-range indices are undefined for this subset.

#### Scenario: Construct and index

- **WHEN** a program evaluates `(vector-ref (vector 10 20 30) 1)`
- **THEN** the result is `20`

#### Scenario: Length

- **WHEN** a program evaluates `(vector-length (make-vector 4 0))`
- **THEN** the result is `4`

#### Scenario: Mutation

- **WHEN** a program evaluates `(let ((v (make-vector 2 0))) (vector-set! v 0 99) (vector-ref v 0))`
- **THEN** the result is `99`

#### Scenario: Predicate

- **WHEN** a program evaluates `(vector? (vector 1))` and `(vector? (quote (1)))`
- **THEN** the results are `#t` and `#f`

### Requirement: Vector printing and reader syntax

A vector SHALL print as `#(` followed by its elements separated by spaces and a closing `)`.
`read-from-string` SHALL read `#(...)` syntax as a vector of the parenthesized data.

#### Scenario: Vector prints in #(...) form

- **WHEN** a program's result value is `(vector 1 2 3)`
- **THEN** it prints as `#(1 2 3)`

#### Scenario: Reader reads a vector literal

- **WHEN** a program evaluates `(vector-ref (read-from-string "#(7 8 9)") 2)`
- **THEN** the result is `9`
