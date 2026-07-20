## ADDED Requirements

### Requirement: Inexact real (flonum) numbers

The language SHALL provide **inexact real numbers** (flonums), each an IEEE
double-precision value, as a first-class number type disjoint from fixnums and
from every other value. A flonum SHALL be a heap-allocated tagged object (it does
not fit an immediate word), and two flonums produced by different computations
with the same value SHALL be indistinguishable by their value even when they are
distinct objects. Flonums SHALL be usable everywhere any other value is — bound,
stored in pairs/vectors, passed, and returned.

The reader (`read-from-string` and the program reader on both backends) SHALL
recognize inexact real literals: an optionally-signed token that contains a
decimal point and/or an exponent — `2.5`, `-1.25`, `0.0`, `100.`, `.5`,
`1e30`, `-2.5e-3` — SHALL read as the corresponding flonum. A token consisting
only of an optional sign and digits SHALL continue to read as an exact integer
(fixnum), a lone `.` SHALL continue to denote dotted-pair syntax, and any token
that is neither a valid integer nor a valid flonum (e.g. `2.5.6`, `1e`, `+`, `-`,
`foo`) SHALL continue to read as a symbol. Both backends SHALL read identical
source text to the identical flonum.

#### Scenario: Inexact literals read as flonums

- **WHEN** a program reads `"2.5"`, `"-1.25"`, `"0.0"`, and `"1e3"`
- **THEN** each result is a flonum (an inexact real), distinct in type from any
  fixnum, and `(inexact? (read-from-string "2.5"))` is `#t`

#### Scenario: Integers stay exact, dot stays dotted-pair

- **WHEN** a program reads `"42"`, `"-7"`, and `"(a . b)"`
- **THEN** `42` and `-7` are fixnums (exact), and `(a . b)` is the pair of `a`
  and `b` — the reader's integer and dotted-pair handling is unchanged

#### Scenario: Non-numeric tokens stay symbols

- **WHEN** a program reads `"2.5.6"`, `"1e"`, `"-"`, and `"foo"`
- **THEN** each result is a symbol — a token that is neither a valid integer nor a
  valid flonum is not a number

#### Scenario: Flonums of equal value compare equal by value

- **WHEN** a program evaluates `(= 2.5 (+ 1.0 1.5))`
- **THEN** the result is `#t`, even though the two flonums are distinct heap
  objects

### Requirement: Numeric tower with fixnum/flonum contagion

The arithmetic operators `+`, `-`, `*`, `/` and the comparisons `=`, `<`, `>`, `<=`, `>=` SHALL operate over a two-type numeric tower of exact integers (fixnums)
and inexact reals (flonums). When every operand of an
arithmetic operation is a fixnum, the result SHALL be exact (a fixnum), with the
current semantics unchanged. When any operand is a flonum, each fixnum operand
SHALL be coerced to a flonum and the operation SHALL be performed in inexact
arithmetic, yielding a flonum (contagion). Comparisons SHALL compare numerically
across the mix, so a fixnum and a numerically-equal flonum compare equal under
`=`. Applying an arithmetic or comparison operator to a non-number SHALL raise a
runtime trap.

#### Scenario: Pure-fixnum arithmetic is unchanged and exact

- **WHEN** a program evaluates `(+ 1 2 3)`, `(* 2 3 4)`, and `(- 10 1 2)`
- **THEN** the results are the exact fixnums `6`, `24`, and `7`

#### Scenario: A flonum operand makes the result inexact

- **WHEN** a program evaluates `(+ 1 2.0)`, `(* 2 0.5)`, and `(- 5.0 1)`
- **THEN** the results are the flonums `3.0`, `1.0`, and `4.0` (inexact)

#### Scenario: Mixed comparison compares numerically

- **WHEN** a program evaluates `(= 2 2.0)`, `(< 1 2.5)`, and `(> 3.0 2)`
- **THEN** the results are `#t`, `#t`, and `#t`

#### Scenario: Arithmetic on a non-number traps

- **WHEN** a program evaluates `(+ 1 'a)` with no enclosing guard
- **THEN** the computation aborts via the runtime trap mechanism

### Requirement: Real division

The language SHALL provide `/`, real division, as an n-ary operator that
left-folds like the other arithmetic operators: `(/ a b c)` = `(/ (/ a b) c)`,
`(/ a)` = `(/ 1 a)` (reciprocal), and `(/)` with no arguments is a compile-time
error. Division SHALL follow the tower: if any operand is inexact, the result is
a flonum. For exact integer operands, `(/ a b)` SHALL be the exact quotient when
`b` divides `a` evenly, and a flonum otherwise. Division by an exact zero SHALL
raise a runtime trap, consistent with `quotient`/`remainder`.

#### Scenario: Exact division that divides evenly stays exact

- **WHEN** a program evaluates `(/ 6 3)` and `(/ 12 2 3)`
- **THEN** the results are the exact fixnums `2` and `2`

#### Scenario: Exact division that does not divide evenly is inexact

- **WHEN** a program evaluates `(/ 1 2)` and `(/ 7 2)`
- **THEN** the results are the flonums `0.5` and `3.5`

#### Scenario: Division with an inexact operand

- **WHEN** a program evaluates `(/ 5.0 2)` and `(/ (- 1.25 (- 2.5)) 4)`
- **THEN** the results are the flonums `2.5` and `0.9375`

#### Scenario: Division by exact zero traps

- **WHEN** a program evaluates `(/ 1 0)` with no enclosing guard
- **THEN** the computation aborts via the runtime trap mechanism

### Requirement: Flooring modulo

The language SHALL provide `modulo`, the flooring remainder, distinct from the
existing truncating `remainder`: for integers `n` and `d` (`d ≠ 0`), `(modulo n
d)` SHALL satisfy `(+ (* (floor (/ n d)) d) (modulo n d))` = `n` and SHALL have
the sign of the divisor `d` (or be zero). Division by zero SHALL raise a runtime
trap.

#### Scenario: Non-negative operands

- **WHEN** a program evaluates `(modulo 17 5)` and `(modulo 5 5)`
- **THEN** the results are `2` and `0`

#### Scenario: Sign follows the divisor

- **WHEN** a program evaluates `(modulo -7 3)` and `(modulo 7 -3)`
- **THEN** the results are `2` and `-2` (the sign of the divisor), in contrast to
  `(remainder -7 3)` = `-1`

#### Scenario: Modulo by zero traps

- **WHEN** a program evaluates `(modulo 5 0)` with no enclosing guard
- **THEN** the computation aborts via the runtime trap mechanism

### Requirement: Flonums print in round-trippable inexact form

`display`, `write`, and `number->string` SHALL render a flonum as decimal text
that the reader reads back to an equal flonum and that is visually distinguishable
from an exact integer: the rendering SHALL always contain a decimal point or an
exponent (e.g. `0.0`, `2.5`, `-1.25`, `100.0`). A flonum reaching the final-value
printer SHALL render safely rather than crashing or misprinting. Non-finite
flonums SHALL render as `+inf.0`, `-inf.0`, and `+nan.0`.

#### Scenario: display and write of a flonum

- **WHEN** a program evaluates `(number->string 2.5)`, and displays `0.0` and
  `-1.25`
- **THEN** the string is `"2.5"`, and the displayed text is `0.0` and `-1.25`
  (each with a decimal point)

#### Scenario: Flonum output round-trips through the reader

- **WHEN** a program evaluates `(= x (read-from-string (number->string x)))` for a
  flonum `x` such as `2.5` or `-1.25`
- **THEN** the result is `#t`

#### Scenario: A flonum is distinguishable from an integer in output

- **WHEN** a program displays `(/ 6 3)` and `(/ 7 2)`
- **THEN** the outputs are `2` (an integer) and `3.5` (a flonum, with a decimal
  point)

### Requirement: write-char output primitive

The language SHALL provide `write-char`, a unary primitive that writes the single
character argument to standard output as its UTF-8 encoding and returns the
unspecified value. It SHALL be an ordinary, first-class, shadowable binding in the
always-present primitive layer, defined over a reserved raw primcall
(`%write-char`); a direct, unshadowed call SHALL still compile to the bare
primitive. It SHALL NOT require importing `(scheme base)`.

#### Scenario: write-char emits a character's bytes

- **WHEN** a program evaluates `(write-char #\A)` then `(write-char #\newline)`
- **THEN** it writes `A` followed by a line feed to standard output

#### Scenario: write-char emits a non-ASCII character as UTF-8

- **WHEN** a program evaluates `(write-char (integer->char 955))` (`λ`)
- **THEN** it writes the UTF-8 bytes of `λ` to standard output

#### Scenario: write-char is first-class and shadowable

- **WHEN** a program evaluates `(for-each write-char (string->list "hi"))`, or
  defines `(define (write-char c) 'mine)`
- **THEN** `write-char` behaves as an ordinary procedure value, and a user
  definition shadows it (user-wins)

### Requirement: do iteration macro

The standard library `(scheme base)` SHALL provide the `do` iteration macro with
the R7RS form `(do ((var init step) …) (test expr …) command …)`, where a binding
may omit its `step` (defaulting to `var`, i.e. the variable is unchanged each
iteration). Each iteration SHALL evaluate `test`; when `test` is true the loop
SHALL evaluate the result `expr`s in order and return the last (or the unspecified
value if there are none); otherwise it SHALL evaluate the `command`s for effect,
then rebind each `var` to its `step` and iterate. All `step`s SHALL be evaluated
before any rebinding (parallel update). `do` SHALL be an ordinary shadowable macro
(user-wins).

#### Scenario: do accumulates over a range

- **WHEN** a program evaluates
  `(do ((i 0 (+ i 1)) (acc 0 (+ acc i))) ((= i 5) acc))`
- **THEN** the result is `10` (0+1+2+3+4)

#### Scenario: do with a body command for effect

- **WHEN** a program evaluates
  `(do ((i 0 (+ i 1))) ((= i 3)) (display i))`
- **THEN** it displays `012` and returns the unspecified value

#### Scenario: do binding without an explicit step

- **WHEN** a program evaluates
  `(do ((i 0 (+ i 1)) (n 5)) ((= i n) i))`
- **THEN** `n` is unchanged each iteration and the result is `5`

### Requirement: Exact/inexact conversion

The language SHALL provide `exact->inexact`, converting an exact integer to the
flonum of the same value (and returning a flonum argument unchanged), and
`inexact->exact`, converting a flonum with an integer value to the exact fixnum of
that value (and returning a fixnum argument unchanged). `inexact->exact` of a
non-integral flonum SHALL raise a runtime trap (there are no exact rationals).

#### Scenario: exact to inexact

- **WHEN** a program evaluates `(exact->inexact 3)` and `(inexact? (exact->inexact 3))`
- **THEN** the results are the flonum `3.0` and `#t`

#### Scenario: inexact to exact on an integral flonum

- **WHEN** a program evaluates `(inexact->exact 3.0)` and `(exact? (inexact->exact 3.0))`
- **THEN** the results are the fixnum `3` and `#t`

#### Scenario: inexact to exact on a non-integral flonum traps

- **WHEN** a program evaluates `(inexact->exact 2.5)` with no enclosing guard
- **THEN** the computation aborts via the runtime trap mechanism

## MODIFIED Requirements

### Requirement: N-ary arithmetic operators

The arithmetic operators `+`, `-`, `*`, and `/` SHALL accept any number of
arguments and evaluate to the same result as the left-folded binary application,
with the standard identities: `(+)` = 0, `(*)` = 1, `(- a)` = negation of `a`,
`(/ a)` = `(/ 1 a)`. `(-)` and `(/)` with no arguments are compile-time errors.
The n-ary-to-binary reduction SHALL be a frontend expansion into binary primitive
calls, with no change to the emitted calling convention; the binary operations
themselves follow the numeric tower (fixnum-exact, flonum-contagious — see the
"Numeric tower with fixnum/flonum contagion" and "Real division" requirements).

#### Scenario: N-ary sum and product

- **WHEN** a program evaluates `(+ 1 2 3 4)` and `(* 2 3 4)`
- **THEN** the results are `10` and `24`

#### Scenario: Left-associative subtraction and unary negation

- **WHEN** a program evaluates `(- 10 1 2)` and `(- 5)`
- **THEN** the results are `7` and `-5`

#### Scenario: Left-associative division

- **WHEN** a program evaluates `(/ 24 2 3)` and `(/ 2.0)`
- **THEN** the results are the fixnum `4` and the flonum `0.5`

#### Scenario: Identities

- **WHEN** a program evaluates `(+)` and `(*)`
- **THEN** the results are `0` and `1`

### Requirement: eqv? primitive

The compiler SHALL provide `eqv?` as an equivalence operation that returns `#t`
when its two arguments are equivalent, and `#f` otherwise. `eqv?` SHALL hold for
fixnums (immediate), interned symbols, and immediate characters (equal codepoints
are the same immediate word), and SHALL compare flonums **by value** — two flonums
are `eqv?` when they denote the same inexact real, even when they are distinct
heap objects. `eqv?` SHALL return `#f` across the exact/inexact boundary: a fixnum
and a flonum are never `eqv?` (while `=` compares them numerically). `eqv?` SHALL
be exposed as an ordinary, first-class, shadowable binding in the always-present
primitive layer, defined over a reserved raw primcall (`%eqv?`); a direct,
unshadowed call SHALL still compile to the bare primitive operation (see the
`primitive-layer` capability). It SHALL NOT require importing `(scheme base)`.

#### Scenario: eqv? on fixnums, symbols, and characters

- **WHEN** a program evaluates `(eqv? 3 3)`, `(eqv? 3 4)`, `(eqv? 'x 'x)`, and
  `(eqv? #\a #\a)`
- **THEN** the results are `#t`, `#f`, `#t`, and `#t`

#### Scenario: eqv? compares flonums by value

- **WHEN** a program evaluates `(eqv? 2.5 2.5)`, `(eqv? 2.5 (+ 1.0 1.5))`, and
  `(eqv? 2.5 2.75)`
- **THEN** the results are `#t`, `#t`, and `#f`

#### Scenario: eqv? separates exact from inexact

- **WHEN** a program evaluates `(eqv? 2 2.0)`
- **THEN** the result is `#f` (a fixnum and a flonum are never `eqv?`), even though
  `(= 2 2.0)` is `#t`

#### Scenario: eqv? is first-class and shadowable

- **WHEN** a program evaluates `(map eqv? (list 1 2) (list 1 9))`, or defines
  `(define (eqv? a b) 'mine)`
- **THEN** `eqv?` behaves as an ordinary procedure value, and a user definition
  shadows it (user-wins), like any other binding

### Requirement: Type predicate primitives

The language SHALL provide the type predicates `symbol?`, `string?`, `char?`,
`boolean?`, `integer?`, `exact?`, `inexact?`, `number?`, `real?`, and `flonum?`
as primitives, each returning `#t` or `#f` by inspecting the runtime type of its
argument. `symbol?`, `string?`, and `char?` SHALL be true exactly for values of
those types; `boolean?` SHALL be true exactly for `#t` and `#f`. With a two-type
numeric tower (exact fixnums and inexact flonums): `number?` and `real?` SHALL be
true exactly for numbers (fixnums or flonums); `exact?` SHALL be true exactly for
fixnums; `inexact?` and `flonum?` SHALL be true exactly for flonums; and
`integer?` SHALL be true for fixnums and for flonums with an integral value
(`3.0`), and false for non-integral flonums (`2.5`) and non-numbers. Together with
the existing `pair?`, `null?`, and `vector?`, these complete the set of type
predicates the compiler core relies on.

#### Scenario: Predicates classify by type

- **WHEN** a program evaluates `(symbol? 'a)`, `(string? "x")`, `(char? #\z)`,
  `(boolean? #f)`, and `(integer? 7)`
- **THEN** each yields `#t`

#### Scenario: Exact and inexact numbers

- **WHEN** a program evaluates `(exact? 7)`, `(inexact? 7)`, `(exact? 2.5)`,
  `(inexact? 2.5)`, `(number? 2.5)`, and `(flonum? 2.5)`
- **THEN** the results are `#t`, `#f`, `#f`, `#t`, `#t`, and `#t`

#### Scenario: integer? spans exact and integral inexact

- **WHEN** a program evaluates `(integer? 7)`, `(integer? 3.0)`, `(integer? 2.5)`,
  and `(integer? 'a)`
- **THEN** the results are `#t`, `#t`, `#f`, and `#f`

#### Scenario: Predicates reject other types

- **WHEN** a program evaluates `(symbol? 1)`, `(string? 'a)`, `(char? "x")`, and
  `(number? 'a)`
- **THEN** each yields `#f`
