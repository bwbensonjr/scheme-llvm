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
- **THEN** immediates (fixnums, booleans, `()`, and characters) are tagged inline, heap
  objects (pairs, closures, interned symbols, and header-tagged extended objects such as
  strings) are pointer-tagged and allocated through `libgc`, and closures are called
  indirectly through their `code_ptr`

#### Scenario: Symbols are interned and quoted structure is materialized

- **WHEN** the IR encodes a quoted symbol or a quoted list
- **THEN** a symbol is a call to `rt_intern` on an emitted private string constant (equal
  names canonicalize to one object), and a quoted pair is materialized by emitted
  `rt_cons` code over the recursively encoded elements

#### Scenario: Strings are materialized on the header-word scheme; characters are immediate

- **WHEN** the IR encodes a string or character literal
- **THEN** a string literal is a heap object on the last primary tag whose first word is a
  type header — a call to `rt_make_string` on an emitted private byte-array constant (with
  its byte length) — while a character literal is emitted as an inline **immediate** tagged
  constant encoding the codepoint, with no heap allocation and no `rt_make_char` call
- **AND** the string header object carries, in addition to its byte length and byte pointer,
  a stored codepoint length and a nullable auxiliary codepoint→byte index pointer (built
  lazily by the runtime, `NULL` at construction); the emitted IR is unchanged — it still
  lowers to a single `rt_make_string(ptr, i64)` call and the runtime populates the extra
  header words — so the runtime/emitter value-representation contract holds without an IR
  edit

### Requirement: Each pipeline stage is independently observable

The compiler SHALL expose a debug mode that prints the intermediate language after each
named pass, so every stage of the lowering can be inspected in isolation. This includes
the top-level pass that collects the program's sequence of top-level forms and desugars
top-level `define`s into the core IL, and the `expand` pass — now a fixpoint
`syntax-rules` macro expander that rewrites user and prelude macro uses (including the
derived forms `cond`, `and`, `or`, `when`, `unless`, `let*`, and named `let`, which are
supplied as prelude macros) into core forms.

#### Scenario: Stage dump

- **WHEN** a program is compiled with the stage-dump flag enabled
- **THEN** the compiler prints the IL after each pass — the top-level
  collection/`define`-desugaring pass, then `expand`, then `recognize-let`,
  `convert-assignments`, `convert-closures`, `lambda-lift`, and lowering — in order

#### Scenario: Expand stage shows fully macro-expanded core

- **WHEN** a program that uses macros (user-defined or prelude derived forms) is compiled
  with the stage-dump flag enabled
- **THEN** the `expand` stage output contains only core forms and known primitive heads,
  with every macro use rewritten and no `define-syntax`/`syntax-rules` form remaining

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
`fastcc i64 (i64 self, i64 argc, i64 a0 … i64 a{K-1}, ptr overflow)` (`K` = whole-program
max fixed arity), and every emitted call SHALL pass `argc` = the number of actual
arguments and the positional arguments padded to `K`. When a call supplies more than `K`
arguments (variadic calls and `apply`), the excess arguments SHALL be passed through the
`overflow` vector; fixed-arity calls with no excess SHALL pass `ptr null`. Variadic
callees SHALL consume `argc` and `overflow` to build their rest list, and fixed-arity
callees SHALL check `argc`. The convention SHALL preserve guaranteed tail calls
(`musttail`), and the fixed-arity hot path SHALL remain allocation-free.

Argument passing SHALL be correct at **every** arity `K`, including `K` large enough that a
call's argument count (`K + 3`) exceeds the target's register-argument budget and arguments
are passed on the stack. In particular, a non-tail call SHALL preserve the caller's live
arguments across the call regardless of `K`. (The convention uses `fastcc` rather than
`tailcc` precisely because a non-tail `call tailcc` with a stack-passed argument does not
preserve the caller's live arguments on arm64; `fastcc` does, and — because every emitted
tail call is `musttail`, which `fastcc` guarantees — guaranteed tail calls are unaffected.)

#### Scenario: Widened prototype and call shape

- **WHEN** a program is compiled to LLVM IR
- **THEN** each Scheme function is defined with the `fastcc (self, argc, a0 … a{K-1},
  overflow)` prototype, and each call site passes the actual-argument count as `argc`, the
  padded positional arguments, and either `ptr null` (no excess) or an `overflow` vector
  (excess args)

#### Scenario: Overflow carries excess arguments

- **WHEN** a variadic procedure or `apply` is called with more than `K` arguments
- **THEN** the first `K` arguments occupy the positional slots and the remainder are passed
  through the `overflow` vector, and the callee reconstructs the full argument sequence

#### Scenario: Tail calls remain guaranteed

- **WHEN** a tail-recursive loop (e.g. the 10M-iteration `countdown` / named-`let` loop)
  is compiled under the convention
- **THEN** the tail call is emitted as `musttail`, the program runs in bounded stack, and
  the loop allocates nothing on its hot path

#### Scenario: High arity preserves caller arguments across non-tail calls

- **WHEN** a program whose whole-program max fixed arity is `K ≥ 6` (so a call passes at least
  9 arguments and at least one is stack-passed) compiles a function that makes a non-tail
  closure call and then uses one of its own arguments after the call returns
- **THEN** the caller's argument is preserved and the function computes the correct result
  (e.g. `(define (big a1 a2 a3 a4 a5 a6) (+ a1 a2)) (define (helper x) (+ x 100))
  (define (f a b) (+ (helper a) b)) (f 10 20)` evaluates to `130`), with no corruption,
  hang, or crash

### Requirement: Emission order is independent of host evaluation order

The emitter SHALL produce the same textual IR — identical temporary numbering and instruction
order — regardless of the host's unspecified argument-evaluation order. Where a form emits two
or more independently-emitting sub-parts (e.g. a call's callee and its operands), the emitter
SHALL sequence them explicitly (rather than relying on the order in which a host evaluates
procedure-call arguments), so that the compiler run under the bootstrap host (Chez) and the
same compiler compiled to native `schemec` emit byte-identical IR for the same program. This is
the determinism the self-hosting fixed point (byte-identical stage-1/stage-2 IR) depends on.

#### Scenario: schemec and the host-hosted compiler agree byte-for-byte

- **WHEN** a program that emits calls, nested calls, closures, and recursion (e.g.
  `demos/fact.scm`) is compiled to IR by the Chez-hosted compiler and by the native `schemec`
- **THEN** the two IR outputs are byte-identical (not merely semantically equivalent)

#### Scenario: Callee and operands emit in a fixed order

- **WHEN** the emitter lowers a call `(f a b)` (or `(apply f … lst)`), which emits both the
  callee reference and the operand expressions
- **THEN** the sub-parts are emitted in a fixed, host-independent order, so temporary numbering
  does not depend on whether the host evaluates arguments left-to-right or right-to-left
