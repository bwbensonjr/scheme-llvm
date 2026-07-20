## Why

Emit's numeric tower is fixnums-only: there are no inexact reals, no real
division, and no `modulo`. `demos/mandelbrot.scm` — a plain R7RS program that
iterates `z <- z^2 + c` over the complex plane — cannot run: its float literals
(`0.0`, `2.5`, `-1.25`) are silently misparsed as symbols, `/` and `modulo` are
unbound, `write-char` was explicitly deferred by the earlier
`io-output-primitives` change, and there is no `do` iteration macro. This change
adds **inexact reals (flonums)** as a real, disjoint, printable number type and
the three orthogonal pieces the demo needs alongside them, so a first genuinely
numeric graphics demo runs on both backends.

The runtime is already pre-wired for this seam: the inline fixnum arithmetic
fast path guards on a fixnum tag and **routes any non-fixnum operand to the
`rt_*` slow path** (see the `aot-codegen` spec's forward-compatibility clause),
the reserved tag-7 header-code space anticipates a flonum subtype, and the
`eqv?` requirement already records that flonum value comparison is "deferred
until such numbers exist." They now exist.

## What Changes

- Add the **flonum** (inexact real) type: an IEEE double, represented as a new
  tag-7 extended-object subtype (`HDR_FLONUM`, the next free header code after
  the mv bundle), disjoint from fixnums and every other value. A `double` cannot
  fit an immediate word, so a heap box is the only option under the current
  tagging scheme.
- Teach **both readers** to parse inexact literals — `[sign] digits . digits`,
  `digits.`, `.digits`, and an optional `e` exponent — producing a flonum: the
  bootstrap `const` clause in `src/parse.ss` and the self-hosted `rd-*` reader in
  `src/prelude.scm` (where `2.5` currently reads as the symbol `|2.5|`). A bare
  `.` (dotted-pair syntax) and ordinary symbols must still read as before.
- Make arithmetic a **two-type tower with contagion**: `+ - *`, real division
  `/`, and the comparisons `= <` (hence `> >= <=`, which the expander reduces to
  `<`/`=`) accept flonum and mixed fixnum/flonum operands. A mixed operation
  coerces the fixnum to a flonum and returns a flonum; two-fixnum operations are
  unchanged (still exact, still inline). All of this lands in the `rt_*` runtime
  functions; the inline path is untouched and delegates automatically.
- Add **`/` (real division)** — currently absent everywhere. `(/ a b …)` folds
  left like the other n-ary operators. Its exactness policy: exact/exact that
  divides evenly stays exact; any inexact operand, or an exact/exact that does
  not divide evenly, yields a flonum. Division by an exact zero traps (as
  `quotient` does today).
- Add **`modulo`** — flooring remainder (result takes the divisor's sign),
  distinct from the existing truncating `remainder`, on integers (with flonum
  operands permitted via the tower). Division by zero traps.
- Add **`write-char`** — a unary primitive writing one character's UTF-8 bytes to
  standard output (over the existing `utf8_encode`), returning the unspecified
  value. The write-style companion `write` already exists; this is the raw-char
  emitter mandelbrot uses per cell.
- Add the **`do`** iteration macro (`syntax-rules`, in `(scheme base)`) with the
  R7RS `(do ((var init step) …) (test expr …) command …)` shape.
- Make flonums **printable and comparable**: `display`/`write`/`number->string`
  render a flonum in round-trippable form (a decimal point always present:
  `0.0`, `2.5`, `-1.25`), and `eqv?` compares two flonums **by value** (fulfilling
  the deferred clause), while staying `#f` across the fixnum/flonum boundary.
- Refine the **numeric predicates** so they stop lying now that a second number
  type exists: `exact?` is `#t` only for fixnums, `integer?` is `#t` for fixnums
  and integral flonums; add `inexact?`, `number?`, and `real?`. Add the
  `exact->inexact` / `inexact->exact` conversions.

Non-goals (deferred): bignums / arbitrary precision (fixnums still wrap on
overflow); exact rationals (so `/` has the exactness policy above rather than
returning a ratio); a NaN-boxing value-representation redesign; the transcendental
and rounding library (`sqrt`, `floor`, `truncate`, `round`, `expt`, `sin`, …);
`string->number` / a radix argument to `number->string`; reader support for the
`#e`/`#i`/`#x` prefixes and `+inf.0`/`+nan.0` literals; and ports / `write-char`
to a non-stdout port. Each is additive on top of this change.

## Capabilities

### New Capabilities
<!-- None — this extends the existing core-language and codegen surface. -->

### Modified Capabilities
- `core-language`: add the flonum type and inexact literals; the two-type
  arithmetic tower with contagion for `+ - * /` and `= <`; real division `/`;
  `modulo`; flonum printing (`display`/`write`/`number->string`); the refined
  numeric predicates (`exact?`/`integer?` for flonums, plus `inexact?`,
  `number?`, `real?`) and `exact->inexact`/`inexact->exact`; flonum value
  comparison in `eqv?` (fulfilling the previously deferred clause); the
  `write-char` output primitive; and the `do` iteration macro.
- `aot-codegen`: extend the "fixnum numeric primitives lower to an inline fast
  path" requirement — the inline path stays fixnum-only and its non-fixnum
  delegation to `rt_*` now covers flonum and mixed operands, with `rt_div`/
  `rt_modulo` added to the runtime-lowering and extern tables.

## Impact

- **Code**:
  - `src/runtime/runtime.c` — `HDR_FLONUM` subtype + `rt_make_flonum`/accessor;
    flonum-aware `rt_add`/`rt_sub`/`rt_mul`/`rt_num_eq`/`rt_lt` and new
    `rt_div`/`rt_modulo`; `rt_flonum_p`/`rt_number_p`/`rt_real_p` and refined
    `rt_integer_p`/`rt_exact_p`; value comparison in `rt_eqv_p`; a `HDR_FLONUM`
    case in `print_val`; `rt_write_char`.
  - `src/parse.ss` — accept inexact in the bootstrap `const` clause; add
    `%/ %modulo %flonum? %number? %real? %inexact? %exact->inexact
    %inexact->exact %write-char` to the tables (`*integrable*` for the
    user-facing ones, mapping to raw `%`-ops).
  - `src/emit.ss` — prim→runtime rows and `declare`s for `rt_div`, `rt_modulo`,
    `rt_write_char`, and the new predicates/conversions; no new inline path.
  - `src/passes/expand.ss` — add `/` to `expand-arith` (n-ary left fold).
  - `src/prelude.scm` — self-hosted reader accepts inexact literals; `modulo`,
    the numeric predicates/conversions layered where they belong, `number->string`
    extended for flonums, and the `do` `syntax-rules` macro in `(scheme base)`.
  - `lib/scheme/base.sld` — regenerated (`tools/gen-scheme-base.ss`) so the
    Chez-driven AOT path sees `do`/`modulo`/the new bindings.
- **Bootstrap**: new reserved `%`-primcall heads (`%/`, `%modulo`,
  `%write-char`, the predicates/conversions) mean a staged `make regen` per the
  `first-class-primitives` D3 lesson — one direct regen first; the fixed-point
  loop fails loudly if a synonym stage is needed. `base.sld` is regenerated
  **before** `make regen` (the multiple-values ordering lesson).
- **Backends**: `scheme-run` (in-process JIT) and `aot` must stay byte-identical;
  the regen fixed point and byte-identical-backends invariants must hold.
- **Tests/Demos**: register `demos/mandelbrot.scm` in `demos/run-tests.sh` on both
  backends with its exact ASCII-art stdout (captured once the feature works);
  smaller demos for float arithmetic/printing, `/`, `modulo`, `write-char`, `do`.
- **Docs**: README numeric-tower bullet (fixnums-only → fixnums + flonums), the
  tag/header-code note (`HDR_FLONUM`), and the primitive list gain `/ modulo
  write-char do` and the flonum predicates.
- **Compatibility**: additive. Every new name is currently unbound; the reader
  change only affects tokens that are today misparsed (float literals) — no
  existing valid program changes meaning. Refining `exact?`/`integer?` changes
  their result only for the newly-introduced flonums, never for any fixnum.
