## ADDED Requirements

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
