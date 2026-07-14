# interactive-repl Specification

## Purpose

Defines the interactive read-eval-print loop: a persistent top-level environment in which
top-level `define`s survive across entered forms and may be redefined, incremental
per-form compilation to independent LLVM IR modules, execution in a single long-lived LLVM
ORC/LLJIT process (shared GC heap, symbol table, and runtime), and interactive printing of
each form's value. Whole-program (batch) compilation is unchanged.

## Requirements

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
SHALL NOT be able to reference globals defined by later forms. This compilation SHALL be
performed by the embedded compiler **in-process** — with no Chez Scheme process and no
per-form subprocess — with the compiler's per-form compilation state (the REPL environment,
macro environment, known-names set, and form counter) persisting across forms in the one
host process.

#### Scenario: Prior globals are referenced as external

- **WHEN** a form that uses an earlier-defined binding is compiled
- **THEN** its emitted module declares that binding's global symbol and the `rt_*`
  functions it uses as `external`, and defines only the globals the form itself introduces

#### Scenario: Forward references are rejected

- **WHEN** a form references a name that has not yet been defined by any earlier form
- **THEN** compilation of that form reports an unbound-variable error rather than
  succeeding

#### Scenario: Forms are compiled without Chez

- **WHEN** a sequence of forms is entered in a `--repl` session
- **THEN** each form is compiled by the embedded compiler within the host process (no Chez
  process, no per-form subprocess), and definitions entered earlier remain visible to later
  forms because the compiler's state persists in-process

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

### Requirement: Persistent JIT host stays in sync with the runtime source

Before the persistent JIT host is used — whether launched by the interactive REPL driver
or by a REPL test harness — the project SHALL ensure the host binary is up to date with
respect to the runtime, host, and embedded-compiler sources it links. The host SHALL be
(re)built whenever `src/runtime/runtime.c`, `src/repl/host.cpp`, the assembled/compiled
compiler it embeds (and the core sources behind it), or the host build recipe is newer than
the existing binary, so that every `rt_*` runtime function and the embedded compiler entry
the host relies on are present and resolvable. It SHALL NOT be sufficient for the host
binary to merely exist; an out-of-date binary SHALL be rebuilt before use.

#### Scenario: A newly added runtime function is available to the prelude

- **WHEN** a new `rt_*` function is added to `src/runtime/runtime.c` and the REPL is then
  started (via the driver or a test harness) with a host binary that predates the change
- **THEN** the host is rebuilt before the first form is evaluated, and a prelude
  procedure that uses the new runtime function resolves and evaluates successfully instead
  of failing with `Failed to materialize symbols`

#### Scenario: A compiler-source change rebuilds the host

- **WHEN** a compiler core source (a pass, `emit`, or the assembly step) is changed and the
  REPL is then started with a host binary that predates the change
- **THEN** the host is rebuilt before the first form is evaluated, so `--repl` compiles
  forms with the updated compiler rather than a stale embedded copy

#### Scenario: An up-to-date host is not rebuilt

- **WHEN** the REPL is started and `build/repl-host` is newer than `runtime.c`,
  `host.cpp`, the embedded compiler, and the build recipe
- **THEN** the freshness check performs no compilation and the session starts without
  rebuilding the host

#### Scenario: A prelude-defined global resolves across forms

- **WHEN** the REPL loads the standard prelude and a later form references a
  prelude-defined global procedure such as `(map (lambda (x) (* x x)) (quote (1 2 3 4)))`
- **THEN** the form evaluates to `(1 4 9 16)`, because the prelude batch module
  materialized successfully and its global slots are resolvable
