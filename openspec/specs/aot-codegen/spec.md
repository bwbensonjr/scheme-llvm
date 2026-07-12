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

### Requirement: Calling-convention decision for variadic application is evidence-backed and recorded

The project SHALL record a decision on the calling convention used for Scheme functions —
how dotted rest parameters, variadic `lambda`, and `apply` over arbitrary-length lists are
supported while preserving guaranteed tail calls (`musttail`) under a single uniform
function prototype — supported by a direct comparison of candidate conventions that emit
and run real LLVM IR, together with the rationale and the scoring that produced it.

#### Scenario: Candidate conventions are exercised in real IR

- **WHEN** the calling-convention decision is made
- **THEN** at least the leading candidate conventions have been implemented as throwaway
  LLVM IR experiments that compile and run
- **AND** each is shown to express a dotted-rest function and an `apply` over a
  runtime-built list longer than the fixed-argument width
- **AND** each is shown either to preserve `musttail` on a tail-recursive loop (running in
  bounded stack) or to be eliminated for failing to

#### Scenario: Decision is recorded with rationale

- **WHEN** the comparison is complete
- **THEN** the chosen convention, the scoring (correctness, `musttail` preserved,
  hot-loop overhead vs. the current fixed-arity baseline, emission complexity), and the
  rationale are recorded in the design doc
- **AND** `LLVM.md`'s "Calling convention" and "Tail calls" sections are updated to be
  consistent with the recorded decision

### Requirement: Emit the argc + overflow calling convention

Every emitted Scheme function SHALL use the single uniform prototype
`tailcc i64 (i64 self, i64 argc, i64 a0 … i64 a{K-1}, ptr overflow)` (`K` = whole-program
max fixed arity), and every emitted call SHALL pass `argc` = the number of actual
arguments and the positional arguments padded to `K`. When a call supplies more than `K`
arguments (variadic calls and `apply`), the excess arguments SHALL be passed through the
`overflow` vector; fixed-arity calls with no excess SHALL pass `ptr null`. Variadic
callees SHALL consume `argc` and `overflow` to build their rest list, and fixed-arity
callees SHALL check `argc`. The convention SHALL preserve guaranteed tail calls
(`musttail`), and the fixed-arity hot path SHALL remain allocation-free.

#### Scenario: Widened prototype and call shape

- **WHEN** a program is compiled to LLVM IR
- **THEN** each Scheme function is defined with the `(self, argc, a0 … a{K-1}, overflow)`
  prototype, and each call site passes the actual-argument count as `argc`, the padded
  positional arguments, and either `ptr null` (no excess) or an `overflow` vector (excess
  args)

#### Scenario: Overflow carries excess arguments

- **WHEN** a variadic procedure or `apply` is called with more than `K` arguments
- **THEN** the first `K` arguments occupy the positional slots and the remainder are passed
  through the `overflow` vector, and the callee reconstructs the full argument sequence

#### Scenario: Tail calls remain guaranteed

- **WHEN** a tail-recursive loop (e.g. the 10M-iteration `countdown` / named-`let` loop)
  is compiled under the convention
- **THEN** the tail call is emitted as `musttail`, the program runs in bounded stack, and
  the loop allocates nothing on its hot path
