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
a selected branch. `cond`, `and`, `or`, `when`, `unless`, and `let*` SHALL be realized as
`syntax-rules` macros carried by the standard prelude and rewritten by the source→source
`expand` stage prior to core parsing (rather than hardwired into `expand`); `cond` SHALL
additionally support `else`, `=>`, and bare-test clauses. Named `let` SHALL be recognized
structurally by `expand` (it overloads the core `let` keyword and so cannot be a distinct
macro). `define-syntax` and `syntax-rules` are reserved keywords. Because the macro-based
forms are supplied by the prelude, compiling with the prelude disabled does not provide
them.

#### Scenario: Multi-way cond

- **WHEN** a program uses `(cond [test body ...] ... [else body ...])` with several
  clauses
- **THEN** the executable selects the first clause whose test is true (or the `else`
  clause) and produces that clause body's value

#### Scenario: cond => and bare-test clauses

- **WHEN** a program uses a `(cond (test => proc) ...)` clause or a bare-test `(cond
  (test) ...)` clause
- **THEN** the `=>` clause applies `proc` to the test value (evaluated once) when the test
  is true, and the bare-test clause yields the test value when it is true

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

### Requirement: Quasiquote construction

The compiler SHALL support `quasiquote` with `unquote` and `unquote-splicing` over list
structure. A quasiquoted datum SHALL evaluate to that structure as a constant, except that an
`unquote`d subform SHALL be replaced by the value of its expression and an `unquote-splicing`d
subform SHALL have the elements of its (list) value spliced into the enclosing list. Nesting
SHALL be respected: an `unquote`/`unquote-splicing` takes effect only at the matching
quasiquote level. The reader SHALL accept the sugar `` `x `` for `(quasiquote x)`, `,x` for
`(unquote x)`, and `,@x` for `(unquote-splicing x)`.

#### Scenario: Unquote a value into a list

- **WHEN** a program evaluates `` (let ((x 2)) `(a ,x b)) ``
- **THEN** the result is `(a 2 b)`

#### Scenario: Splice a list into a list

- **WHEN** a program evaluates `` (let ((ys (list 1 2))) `(0 ,@ys 3)) ``
- **THEN** the result is `(0 1 2 3)`

#### Scenario: Quasiquote with no unquotes is constant

- **WHEN** a program evaluates `` `(a b c) ``
- **THEN** the result is `(a b c)`

#### Scenario: Nested quasiquote

- **WHEN** a program evaluates `` (car `(a `(b ,(+ 1 2)))) ``
- **THEN** the result is the symbol `a` and the inner quasiquote is left intact (the `,(+ 1 2)`
  is not evaluated at the outer level)

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

### Requirement: Read data from source text

The compiler SHALL provide `read-from-string`, which parses a source string and returns the
first datum it contains. The reader SHALL recognize integers (optionally signed), symbols,
the empty list, proper lists `( … )`, bracketed lists `[ … ]` (accepted interchangeably with
parentheses), and dotted/improper lists `( … . x)`, booleans `#t`/`#f`, characters `#\x`
(single codepoint) and named characters, strings `" … "` with escape sequences, `#(...)`
vectors, and `'`-quote sugar (`'x` reads as `(quote x)`), skipping interleaved whitespace and
`;` line comments. Symbols SHALL be interned (a read symbol is `eq?` to the same-named
literal).

String literals SHALL support the escape sequences `\n` (newline), `\t` (tab), `\r` (return),
`\\` (backslash), `\"` (double quote), and `\xHH…;` (a hexadecimal Unicode codepoint
terminated by `;`), decoding each to the intended character.

Character literals SHALL support named characters in addition to the single-character form:
`#\space`, `#\newline`, `#\tab`, `#\return`, `#\nul` (and `#\null`), `#\delete`, and
`#\altmode` (and `#\esc`), each denoting its corresponding character.

List syntax SHALL support dotted pairs: a standalone `.` before the final element within
parentheses SHALL produce an improper list whose tail is the datum following the `.`, so
`(a . b)` reads as the pair of `a` and `b`.

Bracketed list syntax `[ … ]` SHALL be accepted as equivalent to `( … )`: a `[` opens a list
and a `]` closes one, and brackets and parentheses are interchangeable (a list opened with `[`
may be closed with `)` and vice-versa). This mirrors the source the compiler consumes (Chez
`pretty-print` emits `[...]` for binding forms). Strict bracket/paren matching is not required.

Malformed input for these extensions (an unrecognized escape, an unknown character name, or a
misplaced `.`) is undefined for this subset.

#### Scenario: Read a nested list

- **WHEN** a program evaluates `(read-from-string "(a (b c) 42)")`
- **THEN** the result is the list `(a (b c) 42)` — the symbol `a`, the list `(b c)`, and the
  fixnum `42`

#### Scenario: Read a bracketed list

- **WHEN** a program evaluates `(read-from-string "(let ([x 5]) x)")`
- **THEN** the result is the list `(let ((x 5)) x)` — the `[x 5]` binding reads as the list
  `(x 5)`, identical to the parenthesized form

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

#### Scenario: String escape sequences

- **WHEN** a program evaluates `(string-length (read-from-string "\"a\\nb\""))`
- **THEN** the result is `3` (the string `a`, newline, `b`)

#### Scenario: Escaped double quote

- **WHEN** a program evaluates `(read-from-string "\"say \\\"hi\\\"\"")`
- **THEN** the result is the string `say "hi"`

#### Scenario: Named character literal

- **WHEN** a program evaluates `(char->integer (read-from-string "#\\newline"))`
- **THEN** the result is `10`

#### Scenario: Dotted pair

- **WHEN** a program evaluates `(read-from-string "(a . b)")`
- **THEN** the result is the pair `(a . b)` (`car` is the symbol `a`, `cdr` is the symbol `b`)

#### Scenario: Improper list with leading elements

- **WHEN** a program evaluates `(read-from-string "(a b . c)")`
- **THEN** the result is the improper list `(a b . c)`

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

Note: `car`, `cons`, and `string-append` may be passed as bare primitives (see "Primitives
usable as first-class values"); any other primitive used in value position must be wrapped in a
lambda (e.g. `(lambda (a b) (- a b))`).

### Requirement: Character comparison procedures

The compiler SHALL provide the character comparison procedures `char=?`, `char<?`, `char>?`,
`char<=?`, and `char>=?`. Each SHALL accept two or more characters and SHALL return `#t` iff
the characters, ordered by Unicode codepoint, satisfy the relation pairwise across the whole
argument list (chained comparison), otherwise `#f`.

#### Scenario: Chained character ordering

- **WHEN** a program evaluates `(char<? #\a #\b #\c)` and `(char<? #\a #\c #\b)`
- **THEN** the results are `#t` and `#f`

#### Scenario: Character equality

- **WHEN** a program evaluates `(char=? #\x #\x)` and `(char=? #\x #\y)`
- **THEN** the results are `#t` and `#f`

### Requirement: String content equality

The compiler SHALL provide `string=?`, which compares two strings and returns `#t` iff they
have identical codepoint content, otherwise `#f`. Comparison is by content, not object
identity.

#### Scenario: Equal content, distinct objects

- **WHEN** a program evaluates `(string=? (substring "xhello" 1 6) "hello")`
- **THEN** the result is `#t`

#### Scenario: Unequal content

- **WHEN** a program evaluates `(string=? "abc" "abd")`
- **THEN** the result is `#f`

### Requirement: String construction procedures

The compiler SHALL provide `string-append`, `symbol->string`, `list->string`, and
`make-string`. `string-append` SHALL return a new string that is the concatenation of its two
string arguments. `symbol->string` SHALL return a fresh string of the symbol's name.
`list->string` SHALL return a string built from a list of characters, in order.
`(make-string k ch)` SHALL return a string of `k` copies of the character `ch`. The results
are immutable strings; codepoint content round-trips through UTF-8, including non-ASCII.

#### Scenario: Append and symbol->string

- **WHEN** a program evaluates `(string-append "foo" (symbol->string (quote bar)))`
- **THEN** the result is the string `"foobar"`

#### Scenario: make-string

- **WHEN** a program evaluates `(make-string 3 #\x)`
- **THEN** the result is the string `"xxx"`

#### Scenario: string->list / list->string round-trip

- **WHEN** a program evaluates `(list->string (string->list "héllo"))`
- **THEN** the result is the string `"héllo"` (codepoint content preserved)

### Requirement: String to character list

The compiler SHALL provide `string->list`, which returns a list of the characters of a
string, in codepoint order.

#### Scenario: Decompose a string

- **WHEN** a program evaluates `(string->list "ab")`
- **THEN** the result is the list `(#\a #\b)`

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

### Requirement: In-place string mutation

The compiler SHALL provide `string-set!` and `string-copy`. `(string-set! s i ch)` SHALL
replace the character at codepoint index `i` of string `s` with character `ch`, in place, for
any character — including one whose UTF-8 encoding differs in byte length from the character it
replaces — and SHALL preserve the identity of the string object so that all aliases observe the
change. `(string-copy s)` SHALL return a fresh string with the same content that can be mutated
independently of `s`. Out-of-range indices are undefined for this subset, and mutating a string
literal is undefined (use `string-copy` or `make-string` for a mutable target).

#### Scenario: Set a character in place

- **WHEN** a program evaluates `(let ((s (make-string 3 #\a))) (string-set! s 1 #\b) s)`
- **THEN** the result is the string `"aba"`

#### Scenario: Replacement changes byte length (ASCII to multibyte)

- **WHEN** a program evaluates
  `(let ((s (make-string 2 #\a))) (string-set! s 0 #\é) (list (string-length s) (string-ref s 0)))`
- **THEN** the result is `(2 #\é)` (length stays 2 codepoints; index 0 is the multibyte character)

#### Scenario: Mutation is visible through an alias

- **WHEN** a program evaluates
  `(let* ((s (make-string 1 #\x)) (t s)) (string-set! s 0 #\y) (string-ref t 0))`
- **THEN** the result is `#\y` (the alias `t` sees the mutation)

#### Scenario: string-copy is independent

- **WHEN** a program evaluates
  `(let* ((s (make-string 1 #\x)) (c (string-copy s))) (string-set! c 0 #\z) (string-ref s 0))`
- **THEN** the result is `#\x` (mutating the copy leaves the original unchanged)

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

### Requirement: Integer division primitives

The language SHALL provide `quotient` and `remainder` on integers with truncating-toward-zero
semantics: for integers n and d (d ≠ 0), `(quotient n d)` is n/d truncated toward zero and
`(remainder n d)` satisfies `(+ (* (quotient n d) d) (remainder n d))` = n. Division by zero
SHALL raise a runtime trap (consistent with other runtime errors).

#### Scenario: quotient and remainder

- **WHEN** a program evaluates `(quotient 17 5)` and `(remainder 17 5)`
- **THEN** the results are `3` and `2`

#### Scenario: truncation toward zero with negatives

- **WHEN** a program evaluates `(quotient -17 5)` and `(remainder -17 5)`
- **THEN** the results are `-3` and `-2`

### Requirement: number->string for decimal integers

The standard prelude SHALL provide `(number->string n)` producing the base-10 signed decimal
text of the integer n, such that it round-trips with the reader's integer parsing.

#### Scenario: positive and negative

- **WHEN** a program evaluates `(number->string 420)` and `(number->string -7)`
- **THEN** the results are the strings `"420"` and `"-7"`

#### Scenario: zero

- **WHEN** a program evaluates `(number->string 0)`
- **THEN** the result is the string `"0"`

#### Scenario: round-trips with the reader

- **WHEN** a program reads `(read-from-string (number->string n))` for an integer n in range
- **THEN** the result equals n

### Requirement: error aborts with a diagnostic

The language SHALL provide `error` with the R7RS-small signature `(error message obj ...)`,
where `message` is a string and the `obj`s are irritants. `error` SHALL raise a catchable
**error object** that satisfies `error-object?`, whose message is recoverable with
`error-object-message` and whose irritants are recoverable with `error-object-irritants`.
When not caught by an enclosing `guard`, a raised error object SHALL report its message and
irritants and abort the current computation via the runtime trap mechanism: under a host that
installs the outermost trap (the REPL host, the in-process runner) the abort is reported and
the process survives; in a standalone executable it terminates with a nonzero status.

#### Scenario: error creates a catchable error object

- **WHEN** `(guard (e ((error-object? e) (error-object-message e))) (error "bad expression" 'x))`
  is evaluated
- **THEN** it returns `"bad expression"`, and `(error-object-irritants e)` within the handler
  would be `(x)`

#### Scenario: uncaught error reports and aborts under the host

- **WHEN** a form evaluates `(error "bad expression" 'x)` with no enclosing `guard`, in the
  interactive REPL or the in-process runner
- **THEN** the host reports the message and irritant and remains alive for the next input,
  rather than returning a value

#### Scenario: uncaught error terminates a standalone program

- **WHEN** a standalone (AOT) program evaluates `(error "no")` with no enclosing `guard`
- **THEN** the program terminates with a nonzero exit status after reporting the diagnostic

### Requirement: raise raises an object to the nearest handler

The language SHALL provide `(raise obj)`, which raises `obj` as an exception to the nearest
enclosing `guard`. Any object MAY be raised, not only error objects. If there is no enclosing
`guard`, the raised object SHALL reach the outermost trap and abort exactly as an uncaught
`error` does.

#### Scenario: a raised non-error object is caught by guard

- **WHEN** `(guard (e ((symbol? e) e)) (raise 'boom))` is evaluated
- **THEN** it returns the symbol `boom`

#### Scenario: an uncaught raise aborts

- **WHEN** `(raise 'boom)` is evaluated with no enclosing `guard` in a standalone program
- **THEN** the program terminates with a nonzero exit status

### Requirement: guard catches exceptions and recovers

The language SHALL provide `guard` with the form `(guard (variable clause ...) body ...)`.
The `body` SHALL be evaluated; if it raises (via `raise` or `error`), the raised object SHALL
be bound to `variable` and the `clause`s evaluated as a `cond` in the continuation of the
`guard` expression. If a clause's test succeeds, its result SHALL be the value of the `guard`
expression and control SHALL NOT return to `body`. If no clause matches and there is no
`else`, the object SHALL be re-raised to the next enclosing handler. If `body` completes
without raising, its value SHALL be the value of the `guard` expression. `guard`s SHALL nest.

#### Scenario: guard returns the body value when nothing is raised

- **WHEN** `(guard (e (#t 'caught)) (+ 1 2))` is evaluated
- **THEN** it returns `3`

#### Scenario: guard catches and dispatches on the raised object

- **WHEN** `(guard (e ((eq? e 'a) 1) ((eq? e 'b) 2) (else 3)) (raise 'b))` is evaluated
- **THEN** it returns `2`

#### Scenario: guard re-raises when no clause matches

- **WHEN** `(guard (outer (#t 'outer-caught)) (guard (inner ((eq? inner 'x) 'inner)) (raise 'y)))`
  is evaluated
- **THEN** the inner `guard` re-raises `y` (no clause matched, no `else`) and the outer
  `guard` catches it, returning `outer-caught`

#### Scenario: a bad form recovers under the embedded REPL

- **WHEN** a form raises during compilation or evaluation inside a `guard` that wraps one
  REPL interaction
- **THEN** the raised object is caught, the interaction is abandoned, and the session
  continues with the next form (the in-language basis for REPL recover-and-continue)

### Requirement: Read all top-level forms from source text

The standard prelude SHALL provide an in-language reader that, given a source string, returns
the list of all top-level data it contains, in order — skipping inter-form whitespace and
`;` line comments and stopping at end of input — built on the existing single-datum reader.

#### Scenario: Reads a sequence of forms

- **WHEN** the reader is applied to `"(define x 1) (define y 2) (+ x y)"`
- **THEN** it returns `((define x 1) (define y 2) (+ x y))`

#### Scenario: Skips comments and whitespace between and after forms

- **WHEN** the reader is applied to source with `;` comments and blank lines between forms
  and a trailing comment
- **THEN** the returned list contains exactly the forms, with comments and whitespace ignored

#### Scenario: Empty source yields no forms

- **WHEN** the reader is applied to `""` or a string of only whitespace/comments
- **THEN** it returns the empty list

### Requirement: Internal defines with letrec* semantics

The language SHALL accept a run of `define` forms at the head of a `lambda`, `let`, `letrec`,
or `begin` body, binding those names over the rest of the body with `letrec*` semantics: each
defined name is visible to the body expressions and to the other defines in the run, so mutual
and forward references within the run resolve. The defines SHALL produce the same core-IL as
the equivalent top-level defines. A `define` that does not form part of the leading run (i.e.
appears after a non-define body expression) SHALL remain an error.

#### Scenario: Internal define is bound over the body

- **WHEN** `((lambda (x) (define y (+ x 1)) (* y y)) 4)` is evaluated
- **THEN** the result is `25`

#### Scenario: Mutual reference within a body

- **WHEN** a body defines two procedures that call each other (e.g. even?/odd?) before a
  trailing expression that calls one of them
- **THEN** the mutual references resolve and the expression yields the correct result

#### Scenario: Define after a body expression is rejected

- **WHEN** a body places a `(define …)` after a non-define expression
- **THEN** compilation reports an error (defines must lead the body)

### Requirement: Emitter is expressible in the self-hostable subset

The emitter's LLVM C-string escaping SHALL be expressed using only operations in the language
scheme-llvm accepts (string/char access, integer arithmetic), without `string->utf8`,
bytevector operations, a radix argument to `number->string`, or `string-upcase`. The escaped
`c"…"` literal and its byte count (printable ASCII except `"` and `\` verbatim; every other
UTF-8 byte as an uppercase `\XX`; trailing NUL counted) SHALL be identical to the prior
output for all inputs.

#### Scenario: Escaping output is unchanged

- **WHEN** the emitter escapes any symbol or string name (ASCII, control characters, and
  multi-byte UTF-8 scalars) into an LLVM `c"…"` literal
- **THEN** the emitted literal and byte count are byte-for-byte identical to the previous
  implementation

#### Scenario: Emitter compiles in the subset

- **WHEN** the emitter source is compiled by scheme-llvm
- **THEN** it uses no operation outside the accepted subset (self-hosting gap G2 is closed)

### Requirement: Two-armed if

The language SHALL accept a two-armed conditional `(if test then)` as equivalent to
`(if test then UNSPEC)`, where `UNSPEC` is the unspecified value (the value denoted by
`(if #f #f)`). When `test` is false and no alternative is given, the expression SHALL evaluate
to that unspecified value rather than being treated as a procedure call to `if`. Three-armed
`(if test then else)` SHALL be unaffected. This makes the `case` derived form's no-match
default and the `(if #f #f)` unspecified-value idiom valid throughout the language, including
in the compiler core itself.

#### Scenario: False test with no alternative yields the unspecified value

- **WHEN** a program evaluates `(if #f 1)`
- **THEN** it yields the unspecified value — identical to `(if #f #f)` — and does not error as
  an unbound `if` reference

#### Scenario: case with no matching key and no else

- **WHEN** a program evaluates `(case 9 ((1 2) 'a) ((3 4) 'b))` (no match, no `else` clause)
- **THEN** it compiles and yields the unspecified value (the macro's `(if #f #f)` default now
  parses)

### Requirement: Type predicate primitives

The language SHALL provide the type predicates `symbol?`, `string?`, `char?`, `boolean?`,
`integer?`, and `exact?` as primitives, each returning `#t` or `#f` by inspecting the runtime
type tag of its argument. `symbol?`, `string?`, and `char?` SHALL be true exactly for values of
those types; `boolean?` SHALL be true exactly for `#t` and `#f`. In the current fixnum-only
number representation `integer?` and `exact?` SHALL both be true exactly for numbers; they are
provided under distinct names for forward compatibility. Together with the existing `pair?`,
`null?`, and `vector?`, these complete the set of type predicates the compiler core relies on.

#### Scenario: Predicates classify by type

- **WHEN** a program evaluates `(symbol? 'a)`, `(string? "x")`, `(char? #\z)`, `(boolean? #f)`,
  and `(integer? 7)`
- **THEN** each yields `#t`

#### Scenario: Predicates reject other types

- **WHEN** a program evaluates `(symbol? 1)`, `(string? 'a)`, and `(char? "x")`
- **THEN** each yields `#f`

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

### Requirement: Primitives usable as first-class values

The language SHALL allow a primitive to be used as a first-class value — at minimum `car`,
`cons`, and `string-append` — so it can be passed to a higher-order procedure such as `map`,
`apply`, or a fold. A primitive name appearing in value (non-operator) position SHALL evaluate to
a procedure with the primitive's behavior, while a call in operator position SHALL continue to
compile directly to the primitive. `string-append` SHALL accept any number of arguments, whether
called directly (`(string-append a b c …)`) or via `apply`, with zero arguments yielding the
empty string. This SHALL be achieved without any construct in the standard prelude that behaves
differently under the bootstrap host than under scheme-llvm, so the prelude continues to load and
run directly under the bootstrap host.

#### Scenario: Primitive passed to a higher-order procedure

- **WHEN** a program evaluates `(map car (list (cons 1 2) (cons 3 4)))`
- **THEN** it yields `(1 3)` — `car` resolves as a value — and a direct `(car (cons 1 2))` still
  compiles to the primitive

#### Scenario: string-append for any arity, direct or applied

- **WHEN** a program evaluates `(string-append "a" "b" "c")`, `(apply string-append (list "a" "b"
  "c"))`, and `(string-append)`
- **THEN** the results are `"abc"`, `"abc"`, and `""` respectively

### Requirement: Minimal process I/O for a standalone filter

The language SHALL provide two process-I/O primitives sufficient to write a standalone
text-filter program: `read-all-stdin`, which reads all of standard input to end-of-file and
returns it as a string; and `display`, which writes a string's bytes to standard output
verbatim — no surrounding quotes and no added newline — and returns an unspecified value.
These are distinct from the final-value printer (which quotes strings and adds a newline).

#### Scenario: display writes raw bytes

- **WHEN** a program evaluates `(display "hello")`
- **THEN** standard output contains exactly `hello` — no quotes and no trailing newline

#### Scenario: read-all-stdin round-trips input

- **WHEN** a program evaluates `(display (read-all-stdin))` with `abc\n(x y)` piped to stdin
- **THEN** standard output contains exactly `abc\n(x y)`

### Requirement: Standalone schemec filter is expressible

The language SHALL support expressing a standalone compiler filter: with the I/O primitives
above and the other self-hosting gaps closed, the compiler core plus a thin entry
`(display (compile-source-string (read-all-stdin)))` compiles to a native `schemec` that maps
source text on stdin to IR text on stdout, with no filesystem or subprocess surface in the
compiled program.

#### Scenario: Core builds to a stdin→stdout filter

- **WHEN** the assembled core with the stdin/stdout entry is compiled
- **THEN** the result is a native program that reads source from stdin and writes the emitted
  IR to stdout (self-hosting gap G3 is closed)

