## ADDED Requirements

### Requirement: Record data type via define-record-type

The compiler SHALL provide the R7RS-small `define-record-type` form, which defines a new,
disjoint record type together with a constructor, a type predicate, and field accessors and
optional mutators. The form is:

```
(define-record-type <type-name>
  (<constructor> <field-tag> …)
  <predicate>
  (<field-tag> <accessor> [<mutator>]) …)
```

- The `<constructor>` SHALL be bound to a procedure of the listed `<field-tag>`s (in order)
  that returns a fresh record whose fields are initialized to those arguments.
- The `<predicate>` SHALL be bound to a one-argument procedure returning `#t` iff its argument
  is a record of this type and `#f` for every other value, including records of other types.
- Each `<accessor>` SHALL be bound to a one-argument procedure returning the named field of a
  record of this type.
- Each optional `<mutator>` SHALL be bound to a two-argument procedure replacing the named
  field of a record of this type in place, returning an unspecified value.

Records of two distinct `define-record-type` definitions SHALL be disjoint (each predicate is
true only for its own type's instances).

#### Scenario: Construct, predicate, and access

- **WHEN** a program defines `(define-record-type point (make-point x y) point? (x point-x) (y point-y))` and evaluates `(point-x (make-point 3 4))`
- **THEN** the result is `3`

#### Scenario: Predicate is type-specific

- **WHEN** the same program evaluates `(point? (make-point 1 2))` and `(point? 5)`
- **THEN** the results are `#t` and `#f`

#### Scenario: Field mutation

- **WHEN** a program defines a record type with a mutator `set-point-x!` and evaluates `(let ((p (make-point 1 2))) (set-point-x! p 9) (point-x p))`
- **THEN** the result is `9`

#### Scenario: Distinct record types are disjoint

- **WHEN** a program defines record types `point` and `pair2` and evaluates `(point? (make-pair2 1 2))`
- **THEN** the result is `#f`

### Requirement: Record printing and equality

A record instance SHALL print opaquely as `#<record TYPE>` using the record type's name.
Records are not readable. Two records SHALL be `eqv?` and `equal?` iff they are the same
object; `equal?` SHALL NOT recurse into record fields.

#### Scenario: Opaque print

- **WHEN** a `point` record's value is printed
- **THEN** it prints as `#<record point>`

#### Scenario: Records compare by identity

- **WHEN** a program evaluates `(let ((p (make-point 1 2))) (equal? p p))` and `(equal? (make-point 1 2) (make-point 1 2))`
- **THEN** the results are `#t` and `#f`
