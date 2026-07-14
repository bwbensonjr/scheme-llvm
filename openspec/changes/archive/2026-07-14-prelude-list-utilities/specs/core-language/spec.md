## ADDED Requirements

### Requirement: Additional standard prelude procedures

The standard prelude SHALL provide the following procedures, with their conventional
R7RS/Scheme semantics, defined over the existing primitives and library:

- `andmap` — returns `#t` iff a predicate holds for every element of a list (short-circuits).
- `memp` — returns the first tail of a list whose head satisfies a predicate, else `#f`.
- `for-each` — applies a procedure to each element for effect, returning an unspecified value.
- `cadddr` — the fourth element accessor (`(car (cdddr x))`).
- `list?` — `#t` iff its argument is a proper list.
- `list-ref`, `list-tail`, `list-head` — indexed element, the sublist after `n` elements, and
  the sublist of the first `n` elements.
- `make-list` — a list of `n` copies of a fill value.
- `iota` — the list `(0 1 … n-1)` for a count `n`.
- `max` — the larger of its (numeric) arguments.
- `zero?` — `#t` iff its argument is `0`.
- `void` — returns the unspecified value.
- `string` — constructs a string from its character arguments.

These complete the library surface the compiler core depends on. User-wins shadowing applies: a
program that defines any of these names overrides the prelude definition.

#### Scenario: List utilities compute standard results

- **WHEN** a program evaluates `(andmap odd? (list 1 3 5))`, `(memp even? (list 1 2 3))`,
  `(list-ref (list 'a 'b 'c) 1)`, and `(iota 3)`
- **THEN** the results are `#t`, `(2 3)`, `b`, and `(0 1 2)` respectively

#### Scenario: Misc utilities

- **WHEN** a program evaluates `(max 2 5)`, `(zero? 0)`, and `(string #\h #\i)`
- **THEN** the results are `5`, `#t`, and `"hi"` respectively
