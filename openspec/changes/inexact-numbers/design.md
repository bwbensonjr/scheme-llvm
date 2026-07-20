## Context

Emit represents values as tagged 64-bit words: the low 3 bits are a primary tag
(`runtime.c:40-48`), and all 8 tags are assigned — fixnum (0), the misc-immediate
family (1, hosting booleans/characters), nil (2), pair (3), closure (4), box (5),
symbol (6), and the tag-7 *extended object*, whose first heap word is a header
code (`HDR_STRING=0` … `HDR_MV=7`). Arithmetic today is fixnum-only:
`rt_add`/`rt_sub`/`rt_mul`/`rt_num_eq`/`rt_lt` do native `intptr_t` ops on the
unfixed payload (`runtime.c:124-140`), and `src/emit.ss` emits an inline fast
path guarded by a fixnum-tag test that **delegates any non-fixnum operand to
those `rt_*` functions** (`emit.ss:321-382`). `>`/`>=`/`<=` are not primitives —
the expander rewrites them to chains over `<` and `=` (`expand.ss:341-374`).

Three facts make this change land cleanly on existing seams:

- The inline emitter is already documented (in the `aot-codegen` spec) as a
  transparent accelerator whose non-fixnum path must match the runtime, "so that
  a future change to numeric semantics (e.g. flonum/bignum support) made in the
  runtime is honored … without further emitter changes."
- `rt_eqv_p` (`runtime.c:144`) already notes it "diverges from `rt_eq_p` only once
  non-immediate numbers (flonums/bignums) need value comparison."
- The `core-language` `eqv?` requirement explicitly defers flonum value
  comparison "until such numbers exist."

Constraints unique to this project: **dev→ship fidelity** (the REPL/JIT and the
AOT exe share one compiler core and must stay byte-identical), **the prelude runs
under two hosts** (bootstrap Chez and Emit itself), and there are **two readers** —
the bootstrap `src/parse.ss` (operating on the Chez `read`er's s-expressions) and
the self-hosted `rd-*` reader in `src/prelude.scm`.

## Goals / Non-Goals

**Goals:**
- A real, disjoint, printable **flonum** type sufficient to run
  `demos/mandelbrot.scm` on both backends with byte-identical output.
- A two-type numeric tower with **contagion**: mixed fixnum/flonum → flonum;
  pure-fixnum arithmetic unchanged (exact, inline, no perf regression).
- The orthogonal pieces the demo needs: real division `/`, `modulo`,
  `write-char`, the `do` macro.
- Predicates that remain truthful with two number types, and `eqv?` value
  comparison for flonums.

**Non-Goals:**
- Bignums / overflow-promotion, exact rationals, NaN-boxing, the transcendental
  and rounding library (`sqrt`/`floor`/`round`/`expt`/…), `string->number`, the
  `#e`/`#i`/`#x`/`+inf.0`/`+nan.0` reader syntax, and non-stdout ports. All are
  additive follow-ons (see the proposal's non-goals).
- **Flonum performance (unboxing).** This change ships the straightforward boxed
  representation, which allocates one flonum per arithmetic result — fine for
  correctness, costly in tight float loops (mandelbrot allocates several flonums
  per pixel per iteration). The chosen performance follow-on (explored in
  `openspec/explorations/flonum-unboxing.md`) is **compiler flonum unboxing**:
  keep the boxed representation, but
  have the emitter hold intermediate flonums in native `f64` registers across a
  hot region, emitting native `fadd`/`fmul`/`fcmp` and calling `rt_make_flonum`
  only at *escape points* (a flonum stored into a pair/vector, returned into a
  `val` slot, or passed to a non-inlined call). This was chosen over a
  value-representation change (NaN-boxing, or stealing a primary tag from
  symbol/closure for a dedicated flonum tag) because a 64-bit `double` does not
  fit a low-tagged immediate word (61-bit payload), so tag-stealing yields only a
  cheaper *box*, not zero allocation — and unboxing recovers most of the speed
  touching only codegen, not the representation. Because numeric semantics are
  isolated in `rt_*` (D2), the boxed representation here needs no rework to be
  optimized later. **Note for that follow-on:** it will REVISE decision D2 ("no
  flonum inline path") and the `aot-codegen` requirement's clause that the emitter
  "SHALL NOT gain a flonum inline path" — the unboxing pass *is* that path.

## Decisions

### D1. Flonum = boxed tag-7 object `HDR_FLONUM = 8`

A `double` needs all 64 bits, so it cannot share a word with a 3-bit tag; an
immediate encoding is impossible under the current scheme (only a NaN-boxing
redesign — a non-goal — would avoid the box). The natural slot is a new tag-7
header code, `HDR_FLONUM = 8` (the next free code after `HDR_MV = 7`), backing a
two-word heap block `{ HDR_FLONUM, double }`. This mirrors how every non-immediate
type already works and needs no change to the tagging core.

- `val rt_make_flonum(double d)` allocates the block and returns a tag-7 pointer;
  `double flo_val(val v)` reads word 1. A `#define is_flonum(v)` tests
  `tag_of(v)==TAG_EXT && ext_hdr(v)==HDR_FLONUM`.
- *Alternative considered — reuse a misc-immediate subtype (tag 1):* rejected;
  the payload is only ~56 bits, far too small for a `double`.

### D2. All numeric semantics live in `rt_*`; the inline path is untouched

The single semantic seam is the runtime. Extend the five arithmetic/comparison
functions to a **type-dispatched** shape:

```
if both operands fixnum:  existing exact fixnum path        (hot, common)
else if both numbers:     coerce any fixnum to double, do the double op
else:                     rt_fatal("<op>: not a number")
```

`rt_add`/`rt_sub`/`rt_mul` return a fixnum when both inputs are fixnums, else a
flonum. `rt_num_eq`/`rt_lt` compare numerically across the mix (e.g. `(= 2 2.0)`
→ `#t`). Because the inline fast path only takes its shortcut when **both**
operands carry the fixnum tag and otherwise calls these same `rt_*` functions,
**`src/emit.ss` needs no new inline logic** — it already routes mixed/flonum
operands to the runtime. `/` and `modulo` are new `rt_div`/`rt_modulo` functions
(no inline path, like `quotient`/`remainder` today).

- This preserves dev→ship fidelity for free: JIT and AOT share the emitter *and*
  link the same `runtime.c`, so both see identical numeric behavior.
- *Alternative — add flonum inline paths in the emitter:* rejected for now; it
  would duplicate semantics across the emitter and runtime (the exact thing the
  `aot-codegen` requirement warns against) for no demo benefit, since mandelbrot's
  hot loop is dominated by the boxed-double ops that must be `rt_*` calls anyway.

### D3. `/` exactness policy without rationals

R7RS makes `(/ 1 2)` an exact ratio, but Emit has no rationals. Policy:

- Any **inexact** operand → flonum result (real division).
- **exact/exact that divides evenly** (`remainder == 0`) → the exact fixnum
  quotient, so `(/ 6 3)` → `2` (exact), preserving the identity for integer-valued
  results.
- **exact/exact that does not divide evenly** → a flonum (`(/ 1 2)` → `0.5`).
- Division by an **exact zero** traps, consistent with `quotient`/`remainder`
  (`runtime.c:131`). Division by inexact zero follows IEEE (`±inf.0`/`nan`),
  which the printer must render safely.

This is the conventional stopgap for a rational-less Scheme: exact where it can
be, inexact otherwise, never silently truncating. `mandelbrot.scm` only divides a
flonum by a fixnum, so it always takes the inexact branch. `/` is n-ary and
left-folds through `expand-arith` alongside `+ - *` (with `(/ a)` → `(/ 1 a)`,
matching `(- a)` → `(- 0 a)`).

### D4. `modulo` is flooring, distinct from `remainder`

`remainder` (truncating, result sign = dividend) already exists. `modulo` is the
flooring variant (result sign = divisor): `(modulo -7 3)` → `2`, `(modulo 7 -3)`
→ `-2`. Implement `rt_modulo` as `r = a % b; if (r != 0 && sign(r) != sign(b)) r
+= b;` on the fixnum path, with the tower coercion for flonum operands. Divide by
zero traps. (The demo's `(modulo n len)` always has non-negative operands, where
`modulo == remainder`, but the general flooring semantics are specified so the
name is correct.)

### D5. Reader: extend both readers; disambiguate `.` and symbols

A flonum literal is `[sign] intpart [. fracpart] [exponent]` with at least one
digit and at least one of a fractional part or exponent present (a token that is
all digits stays a fixnum). Exponent is `(e|E) [sign] digits`.

- **Bootstrap `src/parse.ss`** (`const` clause, line 229): the Chez host's `read`
  already tokenizes `2.5` as a flonum s-expr; accept `(and (number? e) (not (and
  (integer? e) (exact? e))))` as `(const e)` (an inexact literal), so it flows
  through instead of hitting the `bad expression` error.
- **Self-hosted `rd-*`** (`prelude.scm:442-495`): `.` is *not* a token delimiter
  today, so `2.5` reads as one token and is currently `string->symbol`'d into
  `|2.5|`. Extend `rd-numeric?` to recognize the flonum grammar and add a
  `rd-parse-flonum` that assembles the `double`. **Disambiguation:** a lone `.`
  (dotted-pair syntax) and any token that fails the numeric grammar (`2.5.6`,
  `1e`, `foo`) still read as before (`.` handling / symbol). A token like `-`
  stays the symbol `-`.
- Both readers must agree: the same source text yields the same flonum on both
  backends (a byte-identical-backends requirement).

### D6. Flonum printing: shortest round-trippable decimal, always a point

`display`/`write`/`number->string` render a flonum so the reader reads it back
equal, and so a flonum is visually distinct from a fixnum: there is **always** a
decimal point or exponent — `0.0`, `2.5`, `-1.25`, `100.0`, `1e30`. `print_val`
(`runtime.c:930`) gets a `HDR_FLONUM` case; `number->string` (`prelude.scm:248`)
gets a flonum branch (delegating to a runtime formatter to avoid reimplementing
float→string in Scheme). Non-finite values print as `+inf.0`/`-inf.0`/`+nan.0`.
mandelbrot never prints a flonum, but a coherent, safe printer is required so a
stray flonum never crashes or misprints (the same discipline as the mv-bundle
`#<values>` marker).

### D7. `eqv?` value comparison for flonums; `=` vs `eqv?` distinction

Fulfilling the deferred clause: `rt_eqv_p` returns `#t` for two flonums with
`flo_val` bit-equal by value (so `(eqv? 2.5 2.5)` → `#t` even though the boxes
differ), and `#f` across the fixnum/flonum boundary (`(eqv? 2 2.0)` → `#f`, since
they are not the same type — while `(= 2 2.0)` → `#t`, the numeric comparison).
`eq?` on two distinct flonum boxes stays `#f` (identity). This is the textbook
`eqv?`/`=`/`eq?` split.

### D8. Predicate refinement and conversions

With two number types the current "`integer?`/`exact?` are both true for all
numbers" text becomes false. New/updated runtime predicates:
`number?`=`real?`=fixnum∨flonum; `exact?`=fixnum only; `inexact?`=flonum only;
`integer?`=fixnum ∨ integral-flonum; `flonum?`=flonum. Add `exact->inexact`
(fixnum→flonum) and `inexact->exact` (integral flonum→fixnum; non-integral traps,
lacking rationals). These are small and not needed by the demo but keep the type
system honest and the surface coherent.

### D9. `do` as a `syntax-rules` macro in `(scheme base)`

`do` is pure derived syntax over `letrec`/named-`let`, added as a `define-syntax`
in `src/prelude.scm` beside `when`/`cond`/`case`. It must expand identically under
both hosts (bootstrap Chez and Emit) — it uses only forms both already support, so
no host-specific code. The standard R7RS expansion:
`(do ((v i s) …) (test e …) cmd …)` →
`(let loop ((v i) …) (if test (begin (if #f #f) e …) (begin cmd … (loop s …))))`,
with the `(var init)` (no-step) shape defaulting `step` to `var`. Because it lands
in `(scheme base)`, the generated `lib/scheme/base.sld` must be regenerated for
the AOT path (D11).

### D10. Table wiring

`src/parse.ss` `*integrable*` gains the user-facing ordinary bindings mapping to
raw ops: `(/ %/ 2 quotient-like-fold)`, `(modulo %modulo 2)`,
`(write-char %write-char 1)`, `(flonum? %flonum? 1)`, `(number? %number? 1)`,
`(real? %real? 1)`, `(inexact? %inexact? 1)`,
`(exact->inexact %exact->inexact 1)`, `(inexact->exact %inexact->exact 1)`; the
existing `(integer? …)`/`(exact? …)` entries are unchanged (only their runtime
behavior refines). `src/emit.ss` gains prim→runtime rows and `declare`s for
`rt_div`, `rt_modulo`, `rt_write_char`, `rt_make_flonum`, and the predicates/
conversions. `/` is added to `expand-arith`'s n-ary fold in `expand.ss`.

### D11. Bootstrap ordering

New reserved `%`-primcall heads require a staged regen (the `first-class-
primitives` D3 lesson): try one direct `make regen`; if the self-host fixed point
does not converge, add a synonym-first stage. Per the multiple-values lesson,
regenerate `lib/scheme/base.sld` via `tools/gen-scheme-base.ss` **before**
`make regen`, so `bootstrap/scheme.base.ll` is consistent with the `.sld` (`do`
and `modulo` live in `(scheme base)`).

## Risks / Trade-offs

- **`/` exactness policy is non-standard** (no rationals) → documented explicitly
  in the spec and design; the chosen "exact when it divides, else inexact" rule is
  the least-surprising rational-less behavior and is forward-compatible with a
  later rationals change (which would only make the non-dividing case exact).
- **Float printing must round-trip and match across backends** → back it with a
  single runtime formatter shared by JIT and AOT (both link `runtime.c`), and
  test `(read-from-string (number->string x)) = x` plus byte-identical stdout on
  both backends. Risk: locale/`printf` `%g` shortest-form differences — mitigate
  by pinning a deterministic format (e.g. `%.17g` normalized, or a Grisu-style
  shortest) in one place.
- **Reader ambiguity** (`.`, `1e`, `+`, `-`, `2.5.6`) → the numeric grammar is a
  strict recognizer; anything failing it falls back to the existing symbol/dot
  path, and a spec scenario pins that `-`/`...`/`1+2i` etc. still read as symbols.
- **Fixnum overflow still silently wraps** (unchanged) → out of scope; noted so
  reviewers don't expect flonum promotion on overflow.
- **Regen non-convergence** on the new primcall heads → the fixed-point loop fails
  loudly; fall back to the documented synonym-first staging.

## Migration Plan

Additive; no user-facing removals. Ship runtime + tables + reader + prelude
together, regenerate `base.sld` then `make regen`, confirm the fixed point and
byte-identical backends, then register demos with captured expected output.
Rollback is a straight revert (no persisted state, no external interface).

## Open Questions

- **Float→string algorithm**: shortest round-trippable (Grisu/Ryu-lite) vs. a
  simpler pinned `%.17g`-normalized form? The demo doesn't print floats, so a
  simple deterministic form is acceptable for this change; shortest-form can be a
  follow-on. Decide during implementation of D6.
- **`inexact->exact` on non-integral flonums**: trap (chosen, no rationals) vs.
  round-to-nearest-integer? Trapping is the honest choice absent rationals; revisit
  when/if rationals land.
