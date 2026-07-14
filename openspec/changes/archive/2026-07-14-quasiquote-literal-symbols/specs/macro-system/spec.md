## MODIFIED Requirements

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
