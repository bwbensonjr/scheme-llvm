## MODIFIED Requirements

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

## ADDED Requirements

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
