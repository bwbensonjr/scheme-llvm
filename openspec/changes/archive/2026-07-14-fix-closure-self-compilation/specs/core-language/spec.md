## MODIFIED Requirements

### Requirement: Standard library prelude procedures

The compiler SHALL provide a set of standard list and boolean procedures, defined in Scheme
in the prelude and available to every program: `not`, `list` (variadic), `length`,
`reverse`, `append` (variadic — zero or more lists), `map` and `for-each` (variadic — a
procedure plus one or more lists, walked in lockstep and stopping at the shortest), `memq`,
and `assq`. Their behavior SHALL match the usual Scheme semantics (`memq`/`assq` compare with
`eq?`). The variadic `map`/`for-each`/`append` are required for the compiler to compile its
own source: the core uses multi-list `map`/`for-each` (e.g. `rename`'s `(map cons names new)`,
`emit`'s `(for-each … slots (iota k))`) and three-argument `append` (e.g. `emit-code-def`'s
argument declarations). Chez's built-ins are variadic, so matching them keeps self-compilation
faithful; the single-list/two-argument forms remain the common fast path.

#### Scenario: List construction and mapping

- **WHEN** a program evaluates `(map (lambda (x) (* x x)) (list 1 2 3))`
- **THEN** the result is the list `(1 4 9)`

#### Scenario: Multi-list map

- **WHEN** a program evaluates `(map (lambda (a b) (+ a b)) (list 10 20 30) (list 1 2 3))`
- **THEN** the result is the list `(11 22 33)` (the procedure is applied to corresponding
  elements of each list, stopping at the shortest)

#### Scenario: Variadic append

- **WHEN** a program evaluates `(append (list 1) (list 2) (list 3))`
- **THEN** the result is the list `(1 2 3)`

#### Scenario: Reverse and length

- **WHEN** a program evaluates `(length (reverse (list 1 2 3)))` and `(reverse (list 1 2 3))`
- **THEN** the results are `3` and the list `(3 2 1)`

#### Scenario: Association and membership

- **WHEN** a program evaluates `(assq (quote b) (list (list (quote a) 1) (list (quote b) 2)))`
  and `(memq 2 (list 1 2 3))`
- **THEN** `assq` returns the pair for `b` and `memq` returns the sublist starting at `2`
