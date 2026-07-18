# primitive-layer Specification

## Purpose

Every primitive is an ordinary, shadowable, universally-available procedure, exposed over a
reserved raw `%`-prefixed primcall. The plain names form a compiler-intrinsic *integrable*
set (universal by construction — available in programs, user libraries that do not import
`(scheme base)`, and `--no-prelude` builds, with no import and no linked layer library). A
shadow-aware inlining pass recovers bare primcalls for direct, unshadowed, un-`set!` calls, so
hot-path codegen and binary size are unchanged; value-position uses eta-expand (self-contained,
so even variadic ops like `+`/`string-append` need no prelude helper). The REPL and the AOT
build share one compiler core, so both make identical inlining decisions (dev→ship fidelity).
Only the raw `%`-ops remain reserved primcall heads.

## Requirements

### Requirement: Primitives are ordinary, universally-available procedures

The compiler SHALL expose each primitive as an ordinary procedure binding (`cons`, `+`, …)
defined over a reserved raw primcall (`%cons`, `%add`, …). These procedure bindings SHALL be
available in every context where the raw primitives are available today — top-level programs,
user libraries that do not import `(scheme base)`, and `--no-prelude` builds — via an
always-present primitive layer that is not the optional `(scheme base)` library. Only the raw
`%`-prefixed operators SHALL remain reserved primcall heads; the plain primitive names SHALL
be ordinary bindings.

#### Scenario: A user library uses a primitive without importing (scheme base)

- **WHEN** a `define-library` that does not import `(scheme base)` uses `(+ x 100)`
- **THEN** it builds and runs correctly, resolving `+` to the always-present primitive layer

#### Scenario: A --no-prelude program uses a primitive

- **WHEN** a program is built with `--no-prelude` and uses `(cons 1 2)` / `(+ 1 2)`
- **THEN** it builds and runs, because the primitive layer is present independent of
  `(scheme base)`

### Requirement: Primitives are first-class values

Any primitive SHALL be usable as a first-class value — passed as an argument, returned, or
stored — like any other procedure, with no special-case eta list.

#### Scenario: A primitive is passed to a higher-order procedure

- **WHEN** a program evaluates `(map cons xs ys)` or `(apply + ns)`
- **THEN** the result is correct (`cons`/`+` behave as ordinary procedures passed by value)

#### Scenario: A primitive used as a value needs no eta special-case

- **WHEN** a primitive not previously in the eta list (e.g. `string-length`) is used as a value
- **THEN** it works, because the primitive is an ordinary binding rather than a keyword

### Requirement: Primitives are shadowable

A user definition or lexical binding of a primitive name SHALL shadow the primitive, exactly
as it does for any other procedure (user-wins), and the shadow SHALL be observed by all calls
in its scope.

#### Scenario: Top-level redefinition wins

- **WHEN** a program defines `(define (cons a b) (list 'shadowed a b))` and then calls `(cons 1 2)`
- **THEN** the result is `(shadowed 1 2)`

#### Scenario: A lexical binding shadows the primitive

- **WHEN** `+` is bound by an enclosing `let`/`lambda`
- **THEN** references to `+` in that scope use the lexical binding, not the primitive

### Requirement: Direct primitive calls retain bare-primcall codegen

A direct call whose operator resolves to the global, unshadowed, un-`set!` primitive-layer
binding SHALL compile to the same bare primcall (and inline fast paths) as before this change,
so binary size and hot-path performance are unchanged in the common case. Value-position,
shadowed, and `set!`-ed uses MAY compile to an ordinary closure call.

#### Scenario: An unshadowed direct call inlines to a bare primcall

- **WHEN** `(cons a b)` / `(+ a b)` is compiled with the primitive unshadowed and un-`set!`
- **THEN** the emitted IR contains the bare `rt_cons` / inline `add` for that call, matching
  the pre-change baseline

#### Scenario: Dev and ship inline identically

- **WHEN** the same code is run through the REPL and built AOT
- **THEN** both apply the same inlining decision, because they share one compiler core
