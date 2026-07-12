## ADDED Requirements

### Requirement: Persistent top-level environment across forms

In REPL mode the compiler SHALL treat each entered form independently and SHALL bind
top-level `define`s as persistent global bindings that remain visible to every
subsequently entered form, rather than folding all top-level forms into a single
monolithic `letrec`. Whole-program (batch) compilation SHALL retain its existing
monolithic-`letrec` behavior unchanged.

#### Scenario: A later form sees an earlier definition

- **WHEN** a form `(define x 41)` is entered and then a separate form `(+ x 1)` is entered
- **THEN** the second form evaluates to `42`, resolving `x` to the binding established by
  the first form

#### Scenario: A later definition builds on an earlier one

- **WHEN** `(define (square n) (* n n))` is entered and then `(square 9)` is entered as a
  separate form
- **THEN** the second form evaluates to `81`

#### Scenario: Batch compilation is unaffected

- **WHEN** a program file containing the same sequence of top-level forms is compiled in
  batch mode
- **THEN** it is compiled as a single whole-program module exactly as before this change

### Requirement: Redefinition of top-level bindings

REPL mode SHALL allow a top-level name to be redefined by a later form, after which
references to that name resolve to the most recent definition. Earlier compiled forms
that already captured the previous definition SHALL continue to observe the value they
captured (no retroactive rebinding of already-evaluated code).

#### Scenario: Redefinition takes effect for subsequent forms

- **WHEN** `(define y 1)` is entered, then `(define y 2)`, then `(+ y y)`
- **THEN** the final form evaluates to `4`, using the most recent definition of `y`

#### Scenario: Redefining a procedure

- **WHEN** `(define (f) 10)` is entered, then `(define (f) 20)`, then `(f)`
- **THEN** the final form evaluates to `20`

### Requirement: Incremental per-form compilation to independent modules

REPL mode SHALL compile each entered form into its own LLVM IR module that declares every
previously-defined global binding and every required `rt_*` runtime function as
`external`, defines global slots for any bindings the form introduces, and exposes exactly
one entry thunk that evaluates the form, initializes any new slots, and returns the value
to be printed. A form SHALL be able to reference globals defined by earlier forms and
SHALL NOT be able to reference globals defined by later forms.

#### Scenario: Prior globals are referenced as external

- **WHEN** a form that uses an earlier-defined binding is compiled
- **THEN** its emitted module declares that binding's global symbol and the `rt_*`
  functions it uses as `external`, and defines only the globals the form itself introduces

#### Scenario: Forward references are rejected

- **WHEN** a form references a name that has not yet been defined by any earlier form
- **THEN** compilation of that form reports an unbound-variable error rather than
  succeeding

### Requirement: Persistent JIT host preserves runtime state across forms

REPL mode SHALL execute entered forms in a single long-lived process in which the garbage
collector is initialized exactly once and the GC heap, symbol-intern table, and `rt_*`
runtime persist for the entire session. Each form's module SHALL be added to the running
JIT and its entry thunk resolved and called such that heap values (pairs, closures,
strings, symbols) produced by one form remain valid and usable by later forms.

#### Scenario: Heap values survive across forms

- **WHEN** `(define p (cons 1 2))` is entered and then `(car p)` is entered as a separate
  form
- **THEN** the second form evaluates to `1`, dereferencing the pair allocated during the
  first form without a fresh heap being initialized

#### Scenario: Interned symbols remain eq? across forms

- **WHEN** a symbol is produced in one form and the same symbol is produced in a later
  form and compared with `eq?`
- **THEN** the comparison reports true, because the symbol-intern table persists

### Requirement: Read-eval-print loop prints results interactively

The project SHALL provide an interactive REPL driver that reads a Scheme form from input,
drives the existing reader/expander/codegen to produce the form's IR, executes it in the
persistent JIT host, and prints the resulting value using the runtime value printer, then
awaits the next form. Entering end-of-input SHALL end the session cleanly.

#### Scenario: A form is read, evaluated, and printed

- **WHEN** the user enters `(+ 1 2)` at the REPL prompt
- **THEN** the REPL prints `3` and prompts for the next form

#### Scenario: End of input ends the session

- **WHEN** the input stream reaches end-of-file
- **THEN** the REPL exits cleanly without error
