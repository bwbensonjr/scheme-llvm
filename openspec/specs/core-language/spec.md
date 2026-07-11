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
`eq?` — and compile it to a native executable that computes the program's value. The
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
