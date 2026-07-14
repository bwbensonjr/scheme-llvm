## ADDED Requirements

### Requirement: Stateful incremental per-form compilation entry

The embedded compiler SHALL expose an entry that compiles one entered form at a time,
maintaining its compilation state (REPL environment, macro environment, known-names set, and
form counter) across successive calls within one process, so that a form can reference
bindings and macros established by earlier forms. The entry SHALL return, for a successfully
compiled form, both the emitted IR and the name of that form's entry thunk (the entry-name
handshake), so the host looks up exactly the symbol the compiler chose rather than predicting
it.

#### Scenario: A later form sees an earlier definition, compiled in-process

- **WHEN** `(define x 41)` is compiled by the entry and then `(+ x 1)` is compiled as a
  separate call
- **THEN** the second call succeeds with `x` resolved to the earlier binding, and returns the
  IR together with the entry-thunk name for the host to run

#### Scenario: The compiler reports the entry-thunk name

- **WHEN** the entry compiles a form
- **THEN** it returns the form's entry-thunk symbol name alongside the IR, and the host
  resolves that exact name

### Requirement: Compile-error recovery preserves the session

When compiling one form raises an error, the embedded compiler SHALL restore the compilation
state it held before that form and report the error, so that a subsequent form compiles as if
the failed form had never been entered. This recovery SHALL be expressed with the in-language
exception facility (`guard`), not by aborting the process.

#### Scenario: A bad form does not corrupt the session

- **WHEN** a form that fails to compile (for example, one referencing an unbound variable) is
  entered, followed by a valid form
- **THEN** the failed form is reported, the compiler's state is unchanged by it, and the valid
  form compiles and runs normally

#### Scenario: Recovery uses in-language guard

- **WHEN** the embedded compiler compiles a form that raises during expansion or lowering
- **THEN** the raise is caught in-language and the pre-form state is restored, rather than the
  raise reaching the outermost trap and ending compilation
