## ADDED Requirements

### Requirement: Fixnum numeric primitives lower to an inline fast path

The numeric primitives `+`, `-`, `*`, `=`, and `<` (and the comparisons `>`, `>=`, `<=`, which
reduce to `<`/`=` before emission) SHALL be lowered to an inline instruction sequence for the
common case where both operands are fixnums, rather than always emitting an out-of-line runtime
call. The emitter SHALL guard the inline path with a fixnum-tag test on the operands and, when
the test fails, SHALL delegate to the existing runtime primitive (`rt_add`, `rt_sub`, `rt_mul`,
`rt_num_eq`, `rt_lt`). The runtime primitive SHALL remain the single definition of numeric
semantics: the inline path is a transparent accelerator that MUST produce a result identical to
the runtime primitive for fixnum operands, so that a future change to numeric semantics (e.g.
flonum/bignum support) made in the runtime is honored by the non-fixnum path without further
emitter changes.

The observable behavior of every numeric primitive SHALL be unchanged for all inputs relative
to the current runtime-call lowering — same results for fixnums, and the same behavior the
runtime exhibits for non-fixnum operands.

#### Scenario: Inline fast path emitted for fixnum arithmetic

- **WHEN** a program containing `(+ a b)`, `(- a b)`, `(= a b)`, or `(< a b)` is compiled to
  LLVM IR
- **THEN** the emitted IR contains a native arithmetic/compare instruction
  (`add`/`sub`/`icmp`) reached under a fixnum-tag guard, with a call to the corresponding
  `rt_*` primitive on the non-fixnum path

#### Scenario: Results are identical to the runtime primitive

- **WHEN** the demo suite (which exercises n-ary `+ - *` and chained `< = > <= >=`) is compiled
  and run
- **THEN** every demo produces exactly the same value it produced under the previous
  runtime-call lowering

#### Scenario: N-ary and chained forms are covered

- **WHEN** a program uses n-ary arithmetic `(+ a b c)` or a chained comparison `(< a b c)`
- **THEN** each reduced binary operation is lowered through the same inline fast path (the
  reduction to binary forms happens before emission), producing the correct result

#### Scenario: Runtime remains the single definition of semantics

- **WHEN** an operand is not a fixnum at run time
- **THEN** the emitted code calls the runtime primitive, so the runtime alone determines the
  outcome for non-fixnum operands

### Requirement: A function's self-call lowers to a direct call

When a call's operator is the enclosing function's own self-binding (its self-reference,
captured at closure creation), the emitter SHALL lower it to a direct call to that function's
code (`call fastcc @code_N`) rather than loading the code pointer from the closure and calling
indirectly, and SHALL elide the redundant argument-count (`argc`) arity check for that call
since the arity is statically known. This lowering SHALL be observably identical to the indirect
call: the self-reference is fixed for the lifetime of the activation, so a direct call resolves
to the same code the indirect call would have.

The function's entry SHALL continue to check `argc` for calls that arrive through the closure
(external callers); only the direct self-call path elides the check.

#### Scenario: Self-recursive call is emitted as a direct call

- **WHEN** a self-recursive function such as
  `(define (ack m n) (cond ((= m 0) (+ n 1)) ((= n 0) (ack (- m 1) 1)) (else (ack (- m 1) (ack m (- n 1))))))`
  is compiled to LLVM IR
- **THEN** its recursive calls are emitted as direct `call fastcc @code_N` instructions rather
  than closure-loaded indirect calls, without the per-call `argc` guard on that path

#### Scenario: Result is unchanged

- **WHEN** `(ack 3 12)` is evaluated
- **THEN** the result is `32765`, identical to the indirect-call lowering

#### Scenario: External callers still arity-checked

- **WHEN** the same function is also called through its closure from another site with the wrong
  number of arguments
- **THEN** the function still reports an arity error (the entry arity check is preserved for
  closure-entry callers)

#### Scenario: Tail self-calls remain guaranteed tail calls

- **WHEN** a self-recursive tail call (e.g. `(ack (- m 1) 1)` in tail position) is compiled
- **THEN** the direct self-call is still emitted as a `musttail` call and runs in bounded stack
