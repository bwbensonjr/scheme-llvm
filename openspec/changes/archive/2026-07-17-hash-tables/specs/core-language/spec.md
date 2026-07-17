## ADDED Requirements

### Requirement: Hash-table data type and operations

The compiler SHALL provide a mutable hash-table data type keyed by `equal?`, and the
operations `make-hash-table`, `hash-table?`, `hash-table-set!`, `hash-table-ref`,
`hash-table-ref/default`, `hash-table-delete!`, `hash-table-contains?`, `hash-table-size`,
`hash-table-keys`, `hash-table-values`, and `hash-table->alist`.

- `(make-hash-table)` SHALL return a new, empty hash table.
- `(hash-table? x)` SHALL return `#t` iff `x` is a hash table.
- `(hash-table-set! ht key val)` SHALL associate `key` with `val`, replacing any existing
  association for an `equal?` key, and return an unspecified value.
- `(hash-table-ref/default ht key default)` SHALL return the value associated with an `equal?`
  `key`, or `default` if none is present.
- `(hash-table-contains? ht key)` SHALL return `#t` iff an `equal?` `key` is present.
- `(hash-table-delete! ht key)` SHALL remove any association for an `equal?` `key`.
- `(hash-table-size ht)` SHALL return the number of associations as a fixnum.
- `(hash-table-keys ht)` / `(hash-table-values ht)` SHALL return a list of the keys / values.
- `(hash-table->alist ht)` SHALL return a list of `(key . value)` pairs.

The table SHALL grow (rehash into a larger bucket store) automatically as associations are
added, keeping lookup amortized O(1).

#### Scenario: Set and retrieve

- **WHEN** a program evaluates `(let ((h (make-hash-table))) (hash-table-set! h "a" 1) (hash-table-ref/default h "a" 0))`
- **THEN** the result is `1`

#### Scenario: Missing key returns default

- **WHEN** a program evaluates `(hash-table-ref/default (make-hash-table) "x" 42)`
- **THEN** the result is `42`

#### Scenario: Overwrite an equal? key

- **WHEN** a program evaluates `(let ((h (make-hash-table))) (hash-table-set! h "k" 1) (hash-table-set! h "k" 2) (hash-table-ref/default h "k" 0))`
- **THEN** the result is `2`

#### Scenario: Delete and contains?

- **WHEN** a program evaluates `(let ((h (make-hash-table))) (hash-table-set! h 'k 9) (hash-table-delete! h 'k) (hash-table-contains? h 'k))`
- **THEN** the result is `#f`

#### Scenario: Size and growth

- **WHEN** a program inserts 100 distinct keys into a fresh hash table and evaluates `(hash-table-size h)`
- **THEN** the result is `100` and every inserted key is still retrievable

#### Scenario: Predicate

- **WHEN** a program evaluates `(hash-table? (make-hash-table))` and `(hash-table? (vector 1))`
- **THEN** the results are `#t` and `#f`

### Requirement: Value-to-hash primitive

The runtime SHALL provide a `%hash` primitive that maps any value to a fixnum hash code such
that `equal?` values produce equal hash codes (identity-based for fixnums, symbols, characters,
and booleans; content-based for strings).

#### Scenario: Equal values hash equally

- **WHEN** a program evaluates `(= (%hash "abc") (%hash (string-append "ab" "c")))`
- **THEN** the result is `#t`

### Requirement: Hash-table printing

A hash table SHALL print in an opaque form `#<hash-table N>` where `N` is its current element
count. Hash tables are not readable.

#### Scenario: Opaque print

- **WHEN** a program's result value is an empty hash table
- **THEN** it prints as `#<hash-table 0>`
