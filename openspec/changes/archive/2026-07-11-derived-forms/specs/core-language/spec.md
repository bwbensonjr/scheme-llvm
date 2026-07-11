## ADDED Requirements

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
