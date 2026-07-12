# core-language Specification

## Purpose

Defines the M1 core-lambda subset of Scheme that the compiler accepts and the runtime
guarantees for programs written in it: the supported data types, special forms, and
primitives, and the requirement that tail calls execute in bounded stack space.

## Requirements

### Requirement: Compile and run the M1 core-lambda subset

The compiler SHALL accept a **program consisting of a sequence of one or more top-level
forms** over the M1 core subset — fixnums, booleans, the empty list, and pairs; the
forms `quote`, `if`, `lambda`, application, `let`, `letrec`, `begin`, `set!`, and
top-level `define` (both `(define x e)` and the `(define (f arg ...) body ...)` lambda
shorthand); and the primitives `+ - * = <`, `cons`, `car`, `cdr`, `null?`, `pair?`,
`eq?`, `eqv?`, `not` — and compile it to a native executable that computes the program's value. The
**value of a program is the value of its last top-level expression**; a program of a
single expression (the M1 case) is the one-form instance of this rule.

#### Scenario: Recursive arithmetic

- **WHEN** a tail-recursive `fact`-style program over fixnums, `if`, `letrec`, and
  arithmetic primitives is compiled and run
- **THEN** the executable produces the mathematically correct result

#### Scenario: Allocation and pairs

- **WHEN** a program builds and traverses a list via `cons`, `car`, `cdr`, and `null?`
- **THEN** the executable produces the correct result, with pairs heap-allocated under
  Boehm GC

#### Scenario: Assignment

- **WHEN** a program uses `set!` on a captured variable (exercising assignment
  conversion)
- **THEN** the executable produces the correct result and no `set!` survives into the
  emitted IR

#### Scenario: Multi-form program with top-level define

- **WHEN** a program of several top-level forms — top-level `define`s (including the
  `(define (f arg ...) ...)` procedure shorthand) that refer to one another, followed by
  a trailing expression — is compiled and run
- **THEN** the executable produces the value of the last top-level expression, with the
  definitions mutually visible (as under `letrec`)

#### Scenario: Single-expression program still valid

- **WHEN** a program consisting of exactly one top-level expression (no `define`) is
  compiled and run
- **THEN** the executable produces that expression's value, matching M1 behavior

### Requirement: Proper tail calls run in bounded stack

Calls in tail position SHALL be compiled as guaranteed tail calls (`musttail`), so that
tail-recursive loops execute in constant stack space.

#### Scenario: Deep tail loop does not overflow

- **WHEN** a tail-recursive loop iterating a large number of times (beyond the native
  stack depth) is compiled and run
- **THEN** the executable completes and returns the correct result without stack overflow

### Requirement: Support derived syntactic forms

The compiler SHALL accept the derived forms `cond`, `and`, `or`, `when`, `unless`,
`let*`, and named `let`, and SHALL compile each with the same semantics as its expansion
into the core language — including short-circuit evaluation for `and`/`or`, single
evaluation of each `or` operand, and preservation of tail position for the final form of
a selected branch. These forms SHALL be expanded by a source→source `expand` stage prior
to core parsing.

#### Scenario: Multi-way cond

- **WHEN** a program uses `(cond [test body ...] ... [else body ...])` with several
  clauses
- **THEN** the executable selects the first clause whose test is true (or the `else`
  clause) and produces that clause body's value

#### Scenario: Short-circuit and / or

- **WHEN** a program uses `(and a b ...)` and `(or a b ...)`
- **THEN** `and` yields `#f` at the first false operand (otherwise the last operand's
  value) and `or` yields the first true operand's value (otherwise `#f`), with each
  operand evaluated at most once

#### Scenario: when / unless

- **WHEN** a program uses `(when test body ...)` and `(unless test body ...)`
- **THEN** the guarded body runs only when the condition is (respectively) true or false,
  and its value is the body's value

#### Scenario: Sequential let*

- **WHEN** a program uses `(let* ([x e1] [y e2]) body ...)` where `e2` refers to `x`
- **THEN** the bindings take effect left-to-right and the executable produces the correct
  result

#### Scenario: Named let loop

- **WHEN** a tail-recursive loop written with named `let`
  (`(let loop ([i n]) (if ... (loop ...) ...))`) is compiled and run
- **THEN** the executable produces the correct result and the loop runs in bounded stack
  (the expansion to `letrec` preserves the tail call)

### Requirement: N-ary arithmetic operators

The arithmetic operators `+`, `-`, and `*` SHALL accept any number of arguments and
evaluate to the same result as the left-folded binary application, with the standard
identities: `(+)` = 0, `(*)` = 1, `(- a)` = negation of `a`. `(-)` with no arguments is a
compile-time error. This SHALL be a frontend expansion into binary primitive calls, with
no change to the runtime or the emitted calling convention.

#### Scenario: N-ary sum and product

- **WHEN** a program evaluates `(+ 1 2 3 4)` and `(* 2 3 4)`
- **THEN** the results are `10` and `24`

#### Scenario: Left-associative subtraction and unary negation

- **WHEN** a program evaluates `(- 10 1 2)` and `(- 5)`
- **THEN** the results are `7` and `-5`

#### Scenario: Identities

- **WHEN** a program evaluates `(+)` and `(*)`
- **THEN** the results are `0` and `1`

### Requirement: N-ary comparison operators

The comparison operators `=`, `<`, `>`, `<=`, and `>=` SHALL accept any number of
arguments as chained (pairwise) comparisons: for operands `a b c …` the result is the
conjunction `(op a b) ∧ (op b c) ∧ …`, short-circuiting to `#f` on the first false pair.
Each operand SHALL be evaluated exactly once, left to right. A comparison of fewer than
two arguments (`(op)` or `(op a)`) SHALL evaluate to `#t`. The operators `>`, `<=`, and
`>=` SHALL be derived in the frontend from the existing `<` and `=` primitives
(`(> x y)` = `(< y x)`, `(<= x y)` = `(or (< x y) (= x y))`,
`(>= x y)` = `(or (< y x) (= x y))`). This SHALL be a frontend expansion into `<` / `=`
primitive calls and `if`/`let` core forms, with no change to the runtime or the emitted
calling convention.

#### Scenario: Chained less-than and equality

- **WHEN** a program evaluates `(< 1 2 3)`, `(< 1 3 2)`, and `(= 4 4 4)`
- **THEN** the results are `#t`, `#f`, and `#t`

#### Scenario: Derived greater-than and inclusive comparisons

- **WHEN** a program evaluates `(> 3 2 1)`, `(<= 1 1 2)`, and `(>= 3 3 2)`
- **THEN** the results are `#t`, `#t`, and `#t`

#### Scenario: Single evaluation of operands

- **WHEN** a program uses a middle operand with a side effect in an n-ary comparison,
  such as `(< 0 (begin (set! calls (+ calls 1)) 5) 10)` where `calls` starts at `0`
- **THEN** the comparison is `#t` and the operand runs exactly once (`calls` ends at `1`),
  even though the middle operand participates in two adjacent pairwise tests

#### Scenario: Trivial arity

- **WHEN** a program evaluates `(< 5)` and `(=)`
- **THEN** both results are `#t`

### Requirement: N-ary identity predicates

The identity predicates `eq?` and `eqv?` SHALL accept any number of arguments as chained
(pairwise) comparisons: for operands `a b c …` the result is the conjunction
`(op a b) ∧ (op b c) ∧ …`, short-circuiting to `#f` on the first false pair. Each operand
SHALL be evaluated exactly once, left to right. A comparison of fewer than two arguments
(`(op)` or `(op a)`) SHALL evaluate to `#t`. This SHALL be a frontend expansion into
binary `eq?` / `eqv?` primitive calls, reusing the comparison-chaining mechanism, with no
change to the runtime calling convention.

#### Scenario: Chained identity comparison

- **WHEN** a program evaluates `(eq? 'a 'a 'a)` and `(eq? 'a 'a 'b)`
- **THEN** the results are `#t` and `#f`

#### Scenario: Single evaluation of operands

- **WHEN** a program uses a middle operand with a side effect in an n-ary `eq?`,
  such as `(eq? 1 (begin (set! calls (+ calls 1)) 1) 1)` where `calls` starts at `0`
- **THEN** the comparison is `#t` and the operand runs exactly once (`calls` ends at `1`)

#### Scenario: Trivial arity

- **WHEN** a program evaluates `(eqv? 5)` and `(eq?)`
- **THEN** both results are `#t`

### Requirement: Character interning

Characters SHALL be interned by Unicode scalar value: two characters with the same
codepoint SHALL be the same object, regardless of how each was constructed (a `#\c`
literal, `(integer->char n)`, or `(string-ref s i)`). Consequently `eq?` and `eqv?` SHALL
return `#t` for characters with equal codepoints and `#f` for characters with different
codepoints. Interned characters SHALL survive garbage collection under both the AOT and JIT
backends.

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
with `eq?`: it holds for fixnums (immediate), interned symbols, and interned characters
(equal codepoints are the same object). Value comparison for non-immediate numbers
(flonums, bignums) — where `eqv?` would diverge from `eq?` — is deferred until such numbers
exist.

#### Scenario: eqv? on fixnums, symbols, and characters

- **WHEN** a program evaluates `(eqv? 3 3)`, `(eqv? 3 4)`, `(eqv? 'x 'x)`, and
  `(eqv? #\a #\a)`
- **THEN** the results are `#t`, `#f`, `#t`, and `#t`

### Requirement: not primitive

The compiler SHALL provide `not` as a reserved boolean-negation primitive that returns
`#t` when its argument is `#f` and `#f` for every other value. `not` SHALL be a primitive
(not a prelude procedure).

#### Scenario: Boolean negation

- **WHEN** a program evaluates `(not #f)`, `(not #t)`, and `(not 0)`
- **THEN** the results are `#t`, `#f`, and `#f` (only `#f` is false)

### Requirement: Variadic procedures, rest parameters, and apply

The compiler SHALL accept variadic `lambda` forms — dotted rest parameters
`(lambda (a b . rest) …)` and an all-arguments rest `(lambda args …)` — binding the rest
parameter to a proper list of the excess arguments. The compiler SHALL support `apply`
(`(apply f a1 … aN lst)`), passing `a1 … aN` followed by the elements of `lst` as the
arguments to `f`, for lists of arbitrary length. Fixed-arity procedures SHALL be
arity-checked at call time: a mismatch reports an error and aborts.

#### Scenario: Dotted rest parameter

- **WHEN** a program calls `((lambda (a b . rest) rest) 1 2 3 4)`
- **THEN** the result is the list `(3 4)` and calling with exactly the fixed args yields
  the empty list

#### Scenario: All-arguments variadic

- **WHEN** a program defines `(define (list* . xs) xs)` and calls `(list* 1 2 3)`
- **THEN** the result is the list `(1 2 3)`

#### Scenario: Apply over a runtime list

- **WHEN** a program evaluates `(apply f 1 2 lst)` where `lst` is a runtime-built list
  longer than the maximum fixed arity
- **THEN** `f` receives `1`, `2`, and every element of `lst` as arguments, and the result
  is correct

#### Scenario: Arity mismatch is reported

- **WHEN** a fixed-arity procedure is called with the wrong number of arguments
- **THEN** the program reports an arity error and exits non-zero (rather than silently
  computing a wrong result)

#### Scenario: Tail calls still bounded

- **WHEN** a tail-recursive fixed-arity loop is compiled after this change
- **THEN** it still compiles as `musttail` and runs in bounded stack, and its hot path
  performs no rest-list allocation

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

### Requirement: Strings and characters

The compiler SHALL support strings and characters as first-class data types. String and
character literals SHALL be self-evaluating (`"foo"` evaluates to that string, `#\a` to
that character, with no `quote`). Characters SHALL be Unicode codepoints and strings SHALL
be Unicode text (stored as UTF-8); both SHALL round-trip and print faithfully for non-ASCII
content. Strings and characters SHALL be printable — a string as its contents in double
quotes, a character as `#\` followed by the character — and SHALL be usable as elements of
quoted list structure.

#### Scenario: String literal value

- **WHEN** a program's value is the string literal `"hello"`
- **THEN** the executable prints `"hello"`

#### Scenario: Character literal value

- **WHEN** a program's value is the character literal `#\a`
- **THEN** the executable prints `#\a`

#### Scenario: Strings and characters inside quoted structure

- **WHEN** a program evaluates `(quote (a "b" #\c))` and traverses it with `car`/`cdr`
- **THEN** it is a proper list whose elements are the symbol `a`, the string `"b"`, and the
  character `#\c`, printing as `(a "b" #\c)`

#### Scenario: Non-ASCII string and character

- **WHEN** a program's value is a non-ASCII string literal (e.g. `"héllo 日本語"`) or a
  non-ASCII character literal (e.g. `#\λ`)
- **THEN** the string prints with its UTF-8 contents intact between double quotes and the
  character prints as `#\` followed by its UTF-8 encoding (`#\λ`)

### Requirement: String and character operations

The compiler SHALL provide operations over the string and character data types:
`char->integer` and `integer->char` (between a character and its Unicode codepoint),
`string-length`, `string-ref`, `substring`, and `string->symbol`. String length and
indexing SHALL be measured in **Unicode codepoints** (not bytes), so `string-ref` returns
the requested character and `string-length` equals the character count. `string->symbol`
SHALL return the interned symbol of the string's text, so it is `eq?` to a symbol literal
of the same name.

#### Scenario: Character and codepoint conversion

- **WHEN** a program evaluates `(char->integer #\A)` and `(integer->char 97)`
- **THEN** the results are the fixnum `65` and the character `#\a`

#### Scenario: String length and reference

- **WHEN** a program evaluates `(string-length "abc")` and `(string-ref "abc" 1)`
- **THEN** the results are `3` and the character `#\b`

#### Scenario: Substring

- **WHEN** a program evaluates `(substring "hello" 1 4)`
- **THEN** the result is the string `"ell"`

#### Scenario: Codepoint indexing over non-ASCII text

- **WHEN** a program evaluates `(string-length "héllo")` and `(string-ref "héllo" 1)`
- **THEN** the results are `5` and the character `#\é` (indexing counts codepoints, not
  UTF-8 bytes)

#### Scenario: string->symbol interns

- **WHEN** a program evaluates `(eq? (string->symbol "foo") (quote foo))`
- **THEN** the result is `#t`

### Requirement: Standard library prelude procedures

The compiler SHALL provide a set of standard list and boolean procedures, defined in Scheme
in the prelude and available to every program: `not`, `list` (variadic), `length`,
`reverse`, `append`, `map` (over a single list), `memq`, and `assq`. Their behavior SHALL
match the usual Scheme semantics (`memq`/`assq` compare with `eq?`).

#### Scenario: List construction and mapping

- **WHEN** a program evaluates `(map (lambda (x) (* x x)) (list 1 2 3))`
- **THEN** the result is the list `(1 4 9)`

#### Scenario: Reverse and length

- **WHEN** a program evaluates `(length (reverse (list 1 2 3)))` and `(reverse (list 1 2 3))`
- **THEN** the results are `3` and the list `(3 2 1)`

#### Scenario: Association and membership

- **WHEN** a program evaluates `(assq (quote b) (list (list (quote a) 1) (list (quote b) 2)))`
  and `(memq 2 (list 1 2 3))`
- **THEN** `assq` returns the pair for `b` and `memq` returns the sublist starting at `2`

### Requirement: Read data from source text

The compiler SHALL provide `read-from-string`, which parses a source string and returns the
first datum it contains. The reader SHALL recognize integers (optionally signed), symbols,
the empty list and proper lists `( … )`, booleans `#t`/`#f`, single-codepoint characters
`#\x`, strings `" … "` (without escape sequences), and `'`-quote sugar (`'x` reads as
`(quote x)`), skipping interleaved whitespace and `;` line comments. Symbols SHALL be
interned (a read symbol is `eq?` to the same-named literal).

#### Scenario: Read a nested list

- **WHEN** a program evaluates `(read-from-string "(a (b c) 42)")`
- **THEN** the result is the list `(a (b c) 42)` — the symbol `a`, the list `(b c)`, and the
  fixnum `42`

#### Scenario: Read atoms of each type

- **WHEN** a program reads `"42"`, `"hello"`, `"#t"`, `"#\\z"`, and `"\"hi\""`
- **THEN** the results are the fixnum `42`, the symbol `hello`, the boolean `#t`, the
  character `#\z`, and the string `"hi"`

#### Scenario: Read symbols are interned

- **WHEN** a program evaluates `(eq? (read-from-string "foo") (quote foo))`
- **THEN** the result is `#t`

#### Scenario: Quote sugar and comments

- **WHEN** a program evaluates `(read-from-string "; a comment\n 'x")`
- **THEN** the comment is skipped and the result is the list `(quote x)`
