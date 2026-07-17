## ADDED Requirements

### Requirement: define-record-type is a built-in definition form

The frontend SHALL recognize `define-record-type` as a built-in definition form and lower each
occurrence, before macro expansion sees the folded program, into the bindings it introduces: one
fresh record type descriptor, the constructor, the predicate, and the per-field accessors and
mutators, all expressed over the record runtime primitives. Because `collect-toplevel` (which
understands top-level `define`s) runs before the `expand` stage, the lowering SHALL be performed
where definitions are collected rather than by the syntax-rules expander — but it SHALL leave no
residual `define-record-type` form for later stages, so only core forms plus primitive calls
survive to `parse`. Identifiers the lowering introduces (the descriptor binding) SHALL NOT
capture user identifiers.

#### Scenario: define-record-type lowers to core forms

- **WHEN** the frontend processes a `define-record-type` form
- **THEN** no `define-record-type` form survives to later passes, and the constructor,
  predicate, and accessors/mutators are bound over the record primitives

#### Scenario: No residual form after the frontend

- **WHEN** a program using `define-record-type` is compiled
- **THEN** the collect-toplevel/expand output contains no remaining `define-record-type` form

#### Scenario: REPL lowers define-record-type equivalently

- **WHEN** `define-record-type` is entered at the interactive REPL
- **THEN** its constructor, predicate, and accessors/mutators become persistent globals and
  behave identically to the batch compiler (dev→ship fidelity)
