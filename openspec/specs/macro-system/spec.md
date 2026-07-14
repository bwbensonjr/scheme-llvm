# macro-system Specification

## Purpose

Defines user-defined syntactic extensions via `define-syntax` and `syntax-rules`: pattern
matching with literals, the `_` wildcard, and ellipsis; hygiene for macro-introduced
identifiers; and fixpoint expansion that rewrites macro uses into core forms (or reports
non-termination).

## Requirements

### Requirement: Define syntactic extensions with define-syntax and syntax-rules

The compiler SHALL support top-level `(define-syntax <keyword> (syntax-rules (<literal>
...) (<pattern> <template>) ...))`, binding `<keyword>` to a transformer. A use of a bound
keyword SHALL be rewritten by the first rule whose `<pattern>` matches the use, with the
rule's `<template>` instantiated under the captured bindings. `define-syntax` and
`syntax-rules` are reserved keywords. These forms are compile-time only: no
`define-syntax` form survives into the parsed core language.

#### Scenario: User-defined macro expands and runs

- **WHEN** a program defines `(define-syntax swap! (syntax-rules () ((_ a b) (let ([tmp
  a]) (set! a b) (set! b tmp)))))` and uses `(swap! x y)`
- **THEN** the executable swaps the values of `x` and `y` and produces the correct result
  on all three backends

#### Scenario: First matching rule is selected

- **WHEN** a `syntax-rules` transformer has multiple rules and a use matches more than one
- **THEN** the earliest matching rule is used

#### Scenario: define-syntax leaves no runtime binding

- **WHEN** a program compiled with `--dump` defines and uses a macro
- **THEN** the `expand` stage output contains only core forms, with the macro fully
  rewritten and no `define-syntax`/`syntax-rules` form remaining

### Requirement: Pattern matching with literals, wildcard, and ellipsis

`syntax-rules` patterns SHALL support: the `_` wildcard (matches anything, binds nothing);
literal identifiers (declared in the literals list, matching only the identical
identifier); pattern variables (any other identifier, binding the aligned syntax); proper
and dotted list structure; and ellipsis (`...`), where `(p ... . tail)` matches zero or
more repetitions of `p` and each pattern variable within `p` is captured for lockstep
instantiation in the template.

#### Scenario: Ellipsis over a variadic macro

- **WHEN** a program defines `(define-syntax my-list (syntax-rules () ((_ e ...) (list e
  ...))))` and evaluates `(my-list 1 2 3)`
- **THEN** the result is the list `(1 2 3)`, and `(my-list)` yields the empty list

#### Scenario: Literal identifier matches only itself

- **WHEN** a transformer declares a literal (e.g. `=>` or `else`) and a use supplies that
  exact identifier in the corresponding position
- **THEN** the literal-bearing rule matches; a use with a different identifier there does
  not match that rule

#### Scenario: Nested ellipsis binds at the correct depth

- **WHEN** a macro pattern nests ellipsis (e.g. `((v e) ...)`) and the template uses `v`
  and `e` under a matching ellipsis
- **THEN** each captured group is instantiated in lockstep at the correct depth; a
  template use whose ellipsis depth does not match its capture depth is a compile error

### Requirement: Hygiene for macro-introduced identifiers

Expansion SHALL be hygienic with respect to identifiers a template introduces: an
identifier written in a template that is not a pattern variable and does not name a core
keyword, primitive, or known top-level/prelude binding SHALL be consistently renamed to a
fresh identifier per expansion, so a macro's introduced bindings can neither capture user
identifiers nor be captured by them. Syntax substituted from the macro use SHALL retain
its original identifiers.

#### Scenario: Introduced temporary does not capture user code

- **WHEN** a macro introduces a temporary binding (e.g. `or`'s `t`, or `swap!`'s `tmp`)
  and is used with argument expressions that reference an identifier of the same name
- **THEN** the user's identifier and the macro's temporary remain distinct and the program
  produces the correct result

#### Scenario: Referenced primitive stays bound to its definition

- **WHEN** a template references a core keyword or primitive (e.g. `let`, `if`, `cons`)
- **THEN** that identifier is left unrenamed and resolves to its usual definition

### Requirement: Expansion reaches a fixpoint or reports non-termination

The `expand` stage SHALL repeatedly rewrite macro uses until only core forms and known
primitive/arithmetic heads remain, re-expanding the output of each rewrite. Quoted data
(`quote`) SHALL NOT be expanded. A recursion-depth guard SHALL bound re-expansion and
raise a clear error when a macro fails to terminate, rather than looping indefinitely.

#### Scenario: Recursive macro terminates

- **WHEN** a recursively-defined macro (e.g. `and`/`or` over many operands) is used
- **THEN** expansion terminates and the resulting core form evaluates correctly

#### Scenario: Non-terminating macro is reported

- **WHEN** a macro expands into a use of itself without reducing
- **THEN** the compiler halts with a clear macro-expansion error rather than hanging

#### Scenario: Quoted data is not expanded

- **WHEN** a macro keyword or ellipsis-shaped form appears inside `(quote ...)`
- **THEN** it is left untouched as literal data

### Requirement: Expander rewrites quasiquote into core forms

The expander SHALL treat `quasiquote` as a built-in derived form (not a `syntax-rules` macro),
rewriting a quasiquoted datum into core forms — `cons`, `append`, `list`, and `quote` — with
`unquote` inserting an expanded expression and `unquote-splicing` contributing an `append`ed
list, and with quasiquote nesting levels tracked so that only level-matching unquotes splice
values. The rewrite SHALL run within the existing fixpoint expansion, so unquoted expressions
are themselves fully expanded, and no `quasiquote`, `unquote`, or `unquote-splicing` form SHALL
survive into the parsed core language. An `unquote` or `unquote-splicing` outside a
`quasiquote` SHALL be reported as an error. The symbols `unquote`, `unquote-splicing`, and
`quasiquote` MAY appear as ordinary list **data** inside a quasiquote (e.g. `` `(quote unquote) ``
or `` `(a unquote b) ``); the rewrite SHALL reproduce them as literal structure rather than
misparsing a datum whose head is one of those symbols but which is not a well-formed `(kw X)`
form.

#### Scenario: Quasiquote leaves no residual form after expansion

- **WHEN** a program compiled with `--dump` uses `` `(a ,x ,@ys) ``
- **THEN** the `expand` stage output contains only core forms (`cons`/`append`/`list`/`quote`
  and the expansion of `x`/`ys`), with no `quasiquote`/`unquote`/`unquote-splicing` remaining

#### Scenario: Unquote splicing lowers to append

- **WHEN** the expander rewrites `` `(0 ,@ys 3) ``
- **THEN** the result constructs the list by `append`ing the value of `ys` between the constant
  segments (equivalent to `(append (list 0) (append ys (list 3)))`)

#### Scenario: Stray unquote is an error

- **WHEN** a program contains `(unquote x)` outside any `quasiquote`
- **THEN** expansion reports an error

#### Scenario: Literal unquote/quasiquote symbols survive as data

- **WHEN** the expander rewrites `` `(list (quote unquote) ,(+ 1 2)) `` (the shape the
  expander's own nested-quasiquote handling emits)
- **THEN** expansion produces code that builds the list `(list unquote 3)` — the literal symbol
  `unquote` is preserved as data — with no crash and no spurious unquote interpretation

### Requirement: syntax-rules can host a runtime pattern matcher

The `syntax-rules` expander SHALL be powerful enough to host a pattern matcher defined as
`syntax-rules` macros — one that expands to runtime destructuring code over lists. In
particular the expander SHALL support recursive macro expansion to bounded depth and the
ellipsis escape `(... <tmpl>)`, which yields `<tmpl>` with its ellipses treated as literal
identifiers (so a matcher macro can generate output containing a literal `...`).

(Detecting ellipsis `...` *within a user pattern* — needed for `(p ...)` matching — requires
a further capability, a custom ellipsis identifier, added in the follow-up change
`port-match-ellipsis`; it is out of scope here.)

#### Scenario: Ellipsis escape yields a literal ellipsis

- **WHEN** a transformer template contains `(... ...)` (the ellipsis escape)
- **THEN** the expansion produces a literal `...` at that position rather than treating it
  as a repetition marker

#### Scenario: Ellipsis escape substitutes pattern variables

- **WHEN** a transformer template `(... (a ...))` is instantiated with pattern variable `a`
- **THEN** `a` is substituted and the `...` is emitted literally (yielding `(<a> ...)`)

#### Scenario: A syntax-rules matcher expands under the expander

- **WHEN** the `,x`-convention matcher (`match`/`match-clauses`/`match-pat`) is loaded and a
  use with binder, literal-head, dotted-rest, guard, and else clauses is expanded
- **THEN** it expands without error into core forms (`let`/`if`/`car`/`cdr`/`eq?`/…) with no
  residual `unquote` or matcher-macro heads
