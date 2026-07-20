## MODIFIED Requirements

### Requirement: Fixnum numeric primitives lower to an inline fast path

The numeric primitives `+`, `-`, `*`, `=`, and `<` SHALL be lowered to an inline instruction sequence for the
common case where both operands are fixnums (and the comparisons `>`, `>=`, `<=` reduce to
`<`/`=` before emission), rather than always emitting an out-of-line runtime
call. The emitter SHALL guard the inline path with a fixnum-tag test on the operands and, when
the test fails, SHALL delegate to the existing runtime primitive (`rt_add`, `rt_sub`, `rt_mul`,
`rt_num_eq`, `rt_lt`). The runtime primitive SHALL remain the single definition of numeric
semantics: the inline path is a transparent accelerator that MUST produce a result identical to
the runtime primitive for fixnum operands.

The emitter SHALL ALSO provide a **flonum inline fast path** for the same primitives (`+`, `-`,
`*`, `=`, `<`, and the reduced `>`, `>=`, `<=`). When both operands are known or guarded to be
flonums, the emitter SHALL emit the native floating-point instruction (`fadd`, `fsub`, `fmul`,
`fcmp`) operating on unboxed `f64` values, rather than an out-of-line call to `rt_*`. The flonum
fast path MUST be a transparent accelerator: for flonum operands it MUST produce a result
identical to the corresponding runtime primitive, so that the `rt_*` runtime primitives remain
the single definition of numeric semantics for both fixnum and flonum operands. Any operand that
is proven or guarded to be neither a fixnum nor a flonum (and any mixed fixnum/flonum case that
is not specialized inline) SHALL flow to the `rt_*` runtime primitive, which performs the
inexact (contagious) tower arithmetic or comparison.

The flonum fast path SHALL keep intermediate flonum values **unboxed** in native `f64` machine
registers within a single expression tree. A flonum result that feeds another flonum operation
SHALL stay in an `f64` register (producer→consumer fusion); the emitter SHALL construct a boxed
flonum (`rt_make_flonum`) only at an **escape point**, and SHALL cancel every `box ∘ unbox`
(`rt_make_flonum` immediately followed by `flo_val`) pair. The escape points at which an `f64`
result MUST be boxed back into a `val` are: storage into a pair, vector, record, or box; use as a
function result returned into a `val` slot; passage to a call with a `val`-typed parameter
(INCLUDING the self-recursive loop back-edge under the uniform `tailcc` calling convention);
consumption by a `val`-only runtime operation (e.g. `display`, `write`, `eqv?`, `equal?`,
`cons`); and assignment to a type-unstable variable that also holds non-flonum values.

The flonum-ness required to select the fast path SHALL be established from cheap, certain type
sources — literal flonums, the result of any flonum-fast-path operation, and `exact->inexact` —
propagated forward within the expression; where flonum-ness cannot be proven, the emitter SHALL
fall back to the boxed `rt_*` path. This change does NOT alter the calling convention: flonum
parameters continue to be passed as boxed `val`s across the `tailcc` back-edge (loop-carried
unboxing is out of scope), and no unboxed flonum-array representation is introduced.

The division and flooring-remainder primitives `/` and `modulo` have NO inline path (like
`quotient`/`remainder`); they lower to out-of-line calls to `rt_div` and `rt_modulo`, which the
emitter SHALL declare as externs and map in the prim→runtime table.

The observable behavior of every numeric primitive SHALL be unchanged relative to the previous
lowering — identical results for all fixnum inputs, and results matching the runtime's tower
behavior for flonum and mixed operands. Because the unboxing decisions are made in the shared
emitter, the JIT and AOT backends SHALL emit byte-identical code, and the
`byte-identical-backends` demo check MUST continue to pass.

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

- **WHEN** an operand is not a fixnum or flonum at run time
- **THEN** the emitted code calls the runtime primitive, so the runtime alone determines the
  outcome for those operands

#### Scenario: Flonum fast path emitted for flonum arithmetic

- **WHEN** a program compiles `(+ 1.0 2.0)`, `(* zx zx)`, or `(< d 4.0)` where the operands are
  proven or guarded flonums
- **THEN** the emitted IR contains a native floating-point instruction (`fadd`/`fmul`/`fcmp`) on
  unboxed `f64` values, producing the same result the corresponding `rt_*` primitive would

#### Scenario: Intra-expression flonum intermediates stay unboxed

- **WHEN** a flonum-producing operation's result feeds directly into another flonum operation
  within one expression tree (e.g. the `(+ (* zx zx) (* zy zy))` subexpression)
- **THEN** the intermediate flonum stays in an `f64` register and NO `rt_make_flonum` allocation
  is emitted for it, with every `rt_make_flonum` immediately followed by `flo_val` cancelled

#### Scenario: Flonum boxed at escape points

- **WHEN** a flonum result is stored into a pair/vector/record, returned into a `val` slot,
  passed to a `val`-typed call, or consumed by a `val`-only operation such as `display`
- **THEN** the emitter constructs a boxed flonum (`rt_make_flonum`) at that point, so the value
  crosses the boundary as a canonical `val`

#### Scenario: Loop back-edge still boxes the loop-carried flonum

- **WHEN** a self-recursive (named-let) loop passes a flonum-valued loop variable across the
  `tailcc` back-edge
- **THEN** the value is boxed before the recursive call, because loop-carried unboxing across the
  calling convention is out of scope for this change

#### Scenario: Dev→ship byte-identity is preserved

- **WHEN** a program exercising the flonum fast path is compiled through both the JIT and the AOT
  backend
- **THEN** the two backends emit byte-identical code and the `byte-identical-backends` demo check
  passes

#### Scenario: Division and modulo lower to runtime calls

- **WHEN** a program compiles `(/ a b)` or `(modulo a b)`
- **THEN** the emitted IR contains an out-of-line call to `rt_div` / `rt_modulo` (no inline
  fast path), with the corresponding extern declared
