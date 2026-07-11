# aot-codegen Specification

## Purpose

Defines the ahead-of-time code generation backend: lowering the lambda-lifted core IL to
textual LLVM IR, linking it into a native executable against the C runtime and Boehm GC,
the value representation used at runtime, and the observability of each pipeline stage.

## Requirements

### Requirement: Emit textual LLVM IR and link a native executable

The compiler SHALL lower the lambda-lifted core IL to textual LLVM IR (opaque `ptr`,
LLVM 22 syntax) and drive `clang` to compile and link that IR against the C runtime and
Boehm GC (`libgc`) into a runnable native executable.

#### Scenario: End-to-end AOT build

- **WHEN** a demo program is compiled
- **THEN** the compiler writes a `.ll` file, invokes `clang` to link it with the runtime
  and `libgc`, and the resulting executable runs and reports the program's value

#### Scenario: Values are tagged pointers with heap objects under Boehm

- **WHEN** the emitted IR and runtime represent values
- **THEN** immediates (fixnums, booleans, `()`) are tagged inline, heap objects (pairs,
  closures) are header-tagged and allocated through `libgc`, and closures are called
  indirectly through their `code_ptr`

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
