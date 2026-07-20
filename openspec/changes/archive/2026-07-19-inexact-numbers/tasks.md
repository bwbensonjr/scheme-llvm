## 1. Runtime: the flonum type

- [x] 1.1 In `src/runtime/runtime.c`, add `HDR_FLONUM = 8` to the tag-7 header
      codes (after `HDR_MV = 7`); define `is_flonum(v)`, `val rt_make_flonum(double
      d)` (allocate `{HDR_FLONUM, double}`, return tag-7 pointer), and a `flo_val`
      accessor. Update the top-of-file tag/header-code comment.
- [x] 1.2 Add a coercion helper `double to_double(val v)` (fixnum → `(double)UNFIX`,
      flonum → `flo_val`) and an `is_number(v)` predicate, for use by the arithmetic
      functions.

## 2. Runtime: two-type arithmetic tower

- [x] 2.1 Rewrite `rt_add`/`rt_sub`/`rt_mul` (`runtime.c:124-126`) with the
      dispatch: both-fixnum → existing exact path; both-number → flonum result via
      `to_double`; else `rt_fatal("<op>: not a number")`.
- [x] 2.2 Rewrite `rt_num_eq`/`rt_lt` (`runtime.c:139-140`) to compare numerically:
      both-fixnum → existing path; both-number → compare as doubles; else trap.
- [x] 2.3 Add `val rt_div(val a, val b)`: any inexact operand → double division;
      exact/exact dividing evenly → exact fixnum quotient; exact/exact otherwise →
      flonum; exact zero divisor → `rt_fatal` (division by zero). Non-number → trap.
- [x] 2.4 Add `val rt_modulo(val a, val b)`: flooring remainder (result sign =
      divisor sign) on the fixnum path; flonum operands via `to_double` + `fmod`
      adjusted to floor; zero divisor → trap.
- [x] 2.5 Update `rt_eqv_p` (`runtime.c:144`) to compare two flonums by value
      (`flo_val` equal), while staying `#f` across the fixnum/flonum boundary and
      unchanged for all existing immediate/interned cases.

## 3. Runtime: predicates, conversions, printing, write-char

- [x] 3.1 Add `rt_flonum_p`, `rt_number_p`, `rt_real_p`, `rt_inexact_p`; refine
      `rt_integer_p` (fixnum ∨ integral flonum) and `rt_exact_p` (fixnum only)
      (`runtime.c:760-761`).
- [x] 3.2 Add `rt_exact_to_inexact` (fixnum → flonum; flonum unchanged) and
      `rt_inexact_to_exact` (integral flonum → fixnum; non-integral → trap; fixnum
      unchanged).
- [x] 3.3 Add a `HDR_FLONUM` case to `print_val` (`runtime.c:930`) rendering a
      round-trippable decimal that always shows a point/exponent (`0.0`, `2.5`,
      `-1.25`), with `+inf.0`/`-inf.0`/`+nan.0` for non-finite values. Use one
      deterministic formatter (design D6 / open question) so both backends agree.
- [x] 3.4 Add `val rt_write_char(val c)` writing the character's UTF-8 bytes to
      stdout (reuse `utf8_encode`, `runtime.c:282`) and returning the unspecified
      value.
- [x] 3.5 Add a runtime flonum formatter callable from `number->string` (so the
      Scheme side does not reimplement float→string).

## 4. Compiler wiring

- [x] 4.1 In `src/parse.ss` `*integrable*`, add `(/ %/ 2 …)`, `(modulo %modulo 2)`,
      `(write-char %write-char 1)`, `(flonum? %flonum? 1)`, `(number? %number? 1)`,
      `(real? %real? 1)`, `(inexact? %inexact? 1)`, `(exact->inexact
      %exact->inexact 1)`, `(inexact->exact %inexact->exact 1)`. Add the raw heads
      to `*prims*` as needed.
- [x] 4.2 In `src/parse.ss`, accept inexact literals in the bootstrap `const`
      clause (`parse.ss:229`): an s-expr that is a number but not exact-integer
      becomes `(const <flonum>)` instead of hitting the `bad expression` error.
- [x] 4.3 In `src/emit.ss`, add prim→runtime rows for `%/ → rt_div`, `%modulo →
      rt_modulo`, `%write-char → rt_write_char`, and the predicates/conversions;
      add the matching `declare`s (`rt_div`, `rt_modulo`, `rt_write_char`,
      `rt_make_flonum`, `rt_flonum_p`, …). Do NOT add any inline path for `/` or
      `modulo`, and do NOT add a flonum inline path.
- [x] 4.4 In `src/passes/expand.ss`, add `/` to `expand-arith`'s n-ary left fold
      (`(/ a)` → `(/ 1 a)`, `(/)` → error), mirroring `+ - *`.

## 5. Prelude: self-hosted reader, macros, library procs

- [x] 5.1 In `src/prelude.scm`, extend the `rd-*` reader (`rd-numeric?` and a new
      `rd-parse-flonum`, ~lines 442-495) to recognize the flonum grammar (`[sign]
      digits [. digits] [exponent]`, with `.digits`/`digits.`), assembling a
      `double`. A lone `.`, ordinary symbols, and integer tokens read as before.
- [x] 5.2 In `src/prelude.scm`, extend `number->string` (~line 248) with a flonum
      branch delegating to the runtime formatter (task 3.5).
- [x] 5.3 In `src/prelude.scm`, add the `do` `syntax-rules` macro in `(scheme
      base)` beside `when`/`cond`/`case`, covering the `(var init step)` and `(var
      init)` binding shapes and the `(test expr …)` result clause. Verify it
      expands correctly under both the bootstrap (Chez) host and Emit.
- [x] 5.4 If any of `modulo`/predicates/conversions is better expressed in the
      prelude than as a primitive, define it there over the primitives (otherwise
      they stay primitives from task 4.1); keep bindings shadowable (user-wins).

## 6. Bootstrap regen (new primcall heads)

- [x] 6.1 Regenerate `lib/scheme/base.sld` via `chez --script
      tools/gen-scheme-base.ss` FIRST (so the AOT path sees `do` and the new
      bindings), then verify the staleness guard.
- [x] 6.2 Run `make regen`; confirm the self-host fixed point converges (try one
      direct regen; if the fixed-point loop does not converge in 5 iters, add a
      synonym-first stage per the `first-class-primitives` D3 lesson). Commit the
      regenerated `bootstrap/*.ll` at the stable stage.

## 7. Demos and harness

- [x] 7.1 Add small demos: `demos/flonum-arith.scm` (float + mixed `+ - * /` and
      comparisons, including contagion), `demos/modulo.scm`, `demos/write-char.scm`,
      and `demos/do.scm`, each with a header comment per the demo convention.
- [x] 7.2 Register `demos/mandelbrot.scm` and the new small demos in
      `demos/run-tests.sh` with exact expected stdout (capture the mandelbrot ASCII
      art once the feature works), on both backends.

## 8. Verification

- [x] 8.1 Build `emit run` and run `demos/run-tests.sh` (default `emit-run`
      backend) — all demos pass, including `mandelbrot` and the new ones.
- [x] 8.2 Run `RUNNER=aot demos/run-tests.sh` — same expected values on the native
      exe; output byte-identical to `emit-run` (including the flonum-printing and
      mandelbrot output).
- [x] 8.3 Verify the reader-disambiguation and predicate scenarios from the spec:
      `2.5`/`-1.25`/`.5`/`1e3` read as flonums; `2.5.6`/`1e`/`-`/`foo` read as
      symbols; `(= 2 2.0)` `#t` but `(eqv? 2 2.0)` `#f`; `(inexact->exact 2.5)`
      traps.
- [x] 8.4 Verify float output round-trips: `(= x (read-from-string (number->string
      x)))` for a sample of flonums, on both backends.
- [x] 8.5 Run `./run-dev-tests.sh` — self-hosting fixed point, backend
      equivalence, embedded-vs-AOT, and anti-stale trust-check all green.
      **18 suites, 0 failed.**

## 9. Spec sync + docs

- [x] 9.1 After implementation and green tests, sync the deltas in
      `specs/core-language/spec.md` and `specs/aot-codegen/spec.md` into
      `openspec/specs/**` (via the sync/archive workflow).
- [x] 9.2 Update the README: numeric-tower bullet (fixnums-only → fixnums +
      flonums), the tag/header-code note (`HDR_FLONUM`), and the primitive list
      (`/ modulo write-char do` and the flonum predicates).
