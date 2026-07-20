## MODIFIED Requirements

### Requirement: Fixnum numeric primitives lower to an inline fast path

The numeric primitives `+`, `-`, `*`, `=`, and `<` SHALL be lowered to an inline instruction sequence for the
common case where both operands are fixnums (and the comparisons `>`, `>=`, `<=` reduce to
`<`/`=` before emission), rather than always emitting an out-of-line runtime
call. The emitter SHALL guard the inline path with a fixnum-tag test on the operands and, when
the test fails, SHALL delegate to the existing runtime primitive (`rt_add`, `rt_sub`, `rt_mul`,
`rt_num_eq`, `rt_lt`). The runtime primitive SHALL remain the single definition of numeric
semantics: the inline path is a transparent accelerator that MUST produce a result identical to
the runtime primitive for fixnum operands, so that a change to numeric semantics (flonum
support) made in the runtime is honored by the non-fixnum path without further emitter changes.

Now that the runtime implements a fixnum/flonum numeric tower, the non-fixnum path SHALL carry
flonum and mixed fixnum/flonum operands to the runtime primitive, which performs the inexact
(contagious) arithmetic or comparison. The emitter SHALL NOT gain a flonum inline path: the
inline shortcut remains fixnum-only, and any operand that is not a fixnum flows to `rt_*`. The
division and flooring-remainder primitives `/` and `modulo` have NO inline path (like
`quotient`/`remainder`); they lower to out-of-line calls to `rt_div` and `rt_modulo`, which the
emitter SHALL declare as externs and map in the prim→runtime table.

The observable behavior of every numeric primitive SHALL be unchanged for all fixnum inputs
relative to the current runtime-call lowering — same results for fixnums — and SHALL match the
runtime's tower behavior for flonum and mixed operands.

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

#### Scenario: Flonum and mixed operands take the runtime path

- **WHEN** a program compiles `(+ 1 2.0)` or `(< x 4.0)` and runs it
- **THEN** the fixnum-tag guard fails for the flonum operand and the code calls `rt_add` /
  `rt_lt`, producing the tower result (a flonum sum, a numeric comparison) — with no flonum
  inline path in the emitted IR

#### Scenario: Division and modulo lower to runtime calls

- **WHEN** a program compiles `(/ a b)` or `(modulo a b)`
- **THEN** the emitted IR contains an out-of-line call to `rt_div` / `rt_modulo` (no inline
  fast path), with the corresponding extern declared
