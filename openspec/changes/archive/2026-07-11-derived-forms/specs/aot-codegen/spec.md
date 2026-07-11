## MODIFIED Requirements

### Requirement: Each pipeline stage is independently observable

The compiler SHALL expose a debug mode that prints the intermediate language after each
named pass, so every stage of the lowering can be inspected in isolation. This includes
the top-level pass that collects the program's sequence of top-level forms and desugars
top-level `define`s into the core IL, and the `expand` pass that rewrites derived
syntactic forms (`cond`, `and`, `or`, `when`, `unless`, `let*`, named `let`) into core
forms.

#### Scenario: Stage dump

- **WHEN** a program is compiled with the stage-dump flag enabled
- **THEN** the compiler prints the IL after each pass — the top-level
  collection/`define`-desugaring pass, then `expand`, then `recognize-let`,
  `convert-assignments`, `convert-closures`, `lambda-lift`, and lowering — in order
