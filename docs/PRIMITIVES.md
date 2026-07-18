# The Primitive Layer

How Emit exposes its built-in operations — `cons`, `+`, `car`, `vector-ref`, `display`, … —
and how the compiler turns each one into either a bare machine primitive or a real
first-class procedure, *per occurrence*, depending on how it is used.

This is the reworked design shipped in the `first-class-primitives` change (archived under
`openspec/changes/archive/2026-07-18-first-class-primitives/`). It replaced an older model in
which primitive names were reserved keywords with a short hand-maintained "eta list" of the
few that could also be used as values. `PIPELINE.md` covers the whole frontend pass ladder;
this document zooms in on the one pass and two tables that make primitives what they are.

---

## The one-sentence version

> **Every standard primitive is an ordinary, shadowable procedure that is available
> everywhere — and a shadow-aware compiler pass recovers bare-metal codegen whenever you
> call one directly without having redefined it.**

Three properties fall out of that, and the rest of this document is how each is realized:

- **Universal** — a primitive works in a top-level program, in a user `define-library` that
  does *not* import `(scheme base)`, and in a `--no-prelude` build. No import, no linked
  "primitive library," no special environment.
- **Shadowable** — `(define (cons a b) …)`, a `let`-bound `+`, or a `(set! car …)` wins over
  the primitive, exactly as it would for any user procedure. User-wins, always.
- **First-class** — `(map cons xs ys)`, `(apply + ns)`, `(fold-left * 1 ns)` all work; a
  primitive passed by value becomes a genuine closure. There is no curated list of "which
  primitives may be values" — *all* of them may.

And two properties keep it honest as an implementation choice, not just an ergonomic one:

- **Codegen unchanged in the common case** — the overwhelmingly common shape, a direct
  unshadowed call like `(+ a b)` or `(cons x y)`, compiles to the *same* IR as before:
  inline `add` / a bare `@rt_cons`. Binary size and hot-path speed do not regress.
- **Dev→ship fidelity** — the REPL and the AOT build run the *same* pass and make *identical*
  inlining decisions, because they share one compiler core.

---

## Three layers, one floor

```
  ┌─ (scheme base)  — optional library ─────────────────────────────┐
  │   list  map  append  fold-left  assq  cond/and/or/when … (macros)│   ← imported; shadowable
  └──────────────────────────────────────────────────────────────────┘
  ┌─ integrable primitives — the compiler-intrinsic FLOOR ───────────┐
  │   cons  +  car  vector-ref  string-length  display  string-append │   ← always present, shadowable
  │   (ordinary bindings; plain names; NOT reserved keywords)         │
  └──────────────────────────────────────────────────────────────────┘
  ┌─ raw %-primcalls — reserved, internal ───────────────────────────┐
  │   %cons  %add… (%+)  %car  %vector-ref  %display  %string-append   │   → lower directly to rt_*
  │   (reserved primcall heads; never user-facing; never a value)     │
  └──────────────────────────────────────────────────────────────────┘
```

- **Raw `%`-ops** (`%cons`, `%+`, `%car`, …) are the only reserved primcall heads left. They
  lower straight to runtime C entry points (`rt_cons`, `rt_add`, …) and never appear in a
  user program, never leak into LLVM IR as a `%`-name, and are never used as a value. Only
  compiler/host internals stay down here permanently (hashing, records, error plumbing,
  `%no-prelude?`, the REPL-state ops).
- **The integrable floor** is the key idea. Each plain primitive name (`cons`, `+`, …) is an
  *ordinary shadowable binding* defined in terms of its raw `%`-op. It is **compiler-intrinsic**:
  the names are baked into the compiler's set of known bindings, not exported from any library,
  so they are present by construction in every build path. This is the "primitive layer," and
  it is *library zero* — below `(scheme base)`, not part of it.
- **`(scheme base)`** is the ordinary standard library (`list`, `map`, `append`, the
  `cond`/`and`/`or` derived-form macros, …). It is imported, optional, and skipped by
  `--no-prelude`. It sits *on top of* the primitive floor.

The critical distinction — and the finding that reshaped the design (see the archived spike) —
is that making primitives `(scheme base)` *exports* would make them **non-universal**: user
libraries don't import `(scheme base)`, and `--no-prelude` skips it, so both would lose their
primitives. The intrinsic floor avoids that entirely.

---

## How it's reflected in the compiler

Everything lives in three places: the two tables in `src/parse.ss`, the lowering table in
`src/emit.ss`, and the `inline-primitives` pass wired into every compile door in `src/core.ss`.

### 1. The tables — `src/parse.ss`

`*integrable*` is the list of plain names, each mapped to its raw `%`-op, its fixed arity, and
(for the variadic folding ops) a *fold kind*:

```scheme
(define *integrable*
  '((cons %cons 2)
    (+ %+ 2 sum) (- %- 2 diff) (* %* 2 product) (= %= 2 cmp) (< %< 2 cmp)
    (eq? %eq? 2) (eqv? %eqv? 2)
    (quotient %quotient 2) (remainder %remainder 2)
    (car %car 1) (cdr %cdr 1) (null? %null? 1) (pair? %pair? 1)
    (equal? %equal? 2) (not %not 1)
    (char->integer %char->integer 1) (integer->char %integer->char 1)
    (string-length %string-length 1) (string-ref %string-ref 2)
    ;; … 40-odd more …
    (display %display 1) (write %write 1) (newline %newline 0)
    (string-append %string-append 2 str)))
```

Each entry is `(name raw arity [fold-kind])`:

| field | meaning |
|-------|---------|
| `name` | the plain, shadowable source name the user writes (`cons`, `+`) |
| `raw`  | the reserved primcall head it inlines to (`%cons`, `%+`) |
| `arity` | the fixed arity for **direct-call** inlining (the expander has already reduced n-ary `(+ a b c)` to binary form, so `+` is arity 2 here) |
| `fold-kind` | *optional*; present only for ops that are variadic **as a value** — `sum`, `product`, `str`, `diff`, `cmp`. Drives the value-position eta (below). `eq?`/`eqv?` are binary in R7RS, so they have no fold kind. |

`*prims*` is the companion list of the reserved raw `%`-ops (and the handful of permanently
internal ops). `prim?` and `integrable?` are the two predicates the resolver uses.

### 2. The lowering table — `src/emit.ss`

Each raw `%`-op maps to a runtime C entry point. `%cons → rt_cons`, `%display → rt_display`,
and so on. A second small table gives the arithmetic/comparison ops an *inline* fast path
(e.g. `%+ → add i64`) so `(+ 1 2)` emits a machine `add` rather than a call — that inline path
is why direct-call codegen is unchanged.

### 3. The resolver leaves the symbol alone — `src/parse.ss`

During alpha-renaming (`rename-program`), the resolver treats an integrable exactly like a raw
prim: it **leaves the bare source symbol in place**. A *shadow* — a lexical binding, a
top-level user `define`, or a `set!` — is alpha-renamed to a unique gensym like `cons.7`.

That renaming is the whole trick. After rename you can tell, with **no scope tracking at all**,
whether a given `cons` is the primitive or a shadow:

- bare `cons` (unrenamed) → the primitive
- `cons.7` (renamed) → a user binding that shadowed it

### 4. The pass that decides — `inline-primitives` (`src/parse.ss`)

A universal core→core pass, run **after** rename/resolve, on every occurrence:

```scheme
(define (inline-primitives e)
  (define (I e)
    (match e
      …
      ;; bare symbol in VALUE position → synthesize an eta lambda
      [,x (guard (symbol? x))
          (let ([p (integrable-lookup x)]) (if p (eta-integrable p) x))]
      ;; DIRECT CALL of the right arity → bare primcall
      [(call ,f . ,args)
       (let ([p (and (symbol? f) (integrable-lookup f))])
         (if (and p (= (length args) (caddr p)))
             `(primcall ,(cadr p) ,@(map I args))   ; (cons a b) → (primcall %cons a b)
             `(call ,(I f) ,@(map I args))))]       ; value / wrong-arity → falls to symbol case
      …)))
```

Three outcomes, keyed on the post-rename symbol:

| the occurrence | becomes | why |
|----------------|---------|-----|
| **direct call**, unshadowed, right arity — `(cons a b)` | `(primcall %cons a b)` → `rt_cons` | recover baseline codegen; the `%`-op never reaches LLVM as a name |
| **value / apply / wrong-arity** use of the bare symbol — `(map cons xs)` | an **eta lambda** `(lambda (p q) (primcall %cons p q))` | a genuine, tree-shakeable closure |
| **shadowed** — the renamed `cons.7` | **left untouched** | it's an ordinary user binding; user wins |

Because the shadowed name was renamed away, the pass simply never matches it against the
table — shadowing is respected for free.

### 5. Value-position etas — fixed-arity vs. variadic folds

`eta-integrable` builds the closure for a value use:

- **Fixed-arity** ops get the obvious wrapper: `car` → `(lambda (p) (primcall %car p))`.
- **Variadic folding** ops (those with a fold kind) get a **self-contained rest-param fold
  built from raw primcalls** — crucially, *not* a call into a prelude helper. A rest-param
  lambda `(lambda gs …)` collects every argument into a list `gs`, which serves both
  `(map + xs ys)` (args passed individually) and `(apply + ns)` (a list) uniformly:

  | fold kind | ops | value-use semantics |
  |-----------|-----|---------------------|
  | `sum`     | `+` | left fold from `0` over `%+` |
  | `product` | `*` | left fold from `1` over `%*` |
  | `str`     | `string-append` | left fold from `""` over `%string-append` |
  | `diff`    | `-` | `(- a)` negates, `(- a b …)` subtracts left-to-right |
  | `cmp`     | `= <` | short-circuit pairwise chain (0/1 operand → `#t`) |

  Because these fold over *raw* `%`-ops, the synthesized closure has **no prelude dependency**
  and works identically under `--no-prelude`. This is what let `string-append` become
  fully first-class and shadowable, retiring the last parse-time special case.

### 6. Universality and the REPL — the "known" sets

Universality is achieved by making the integrable names **compiler-intrinsic knowledge**, not
imports:

- **Batch/AOT door** — `compute-known` in `src/core.ss` unions `(map car *integrable*)` into
  the set of known bindings, so the names are present in every program, every user library,
  and every `--no-prelude` build.
- **REPL door** — `init-session` in `src/repl-core.ss` unions the same `(map car *integrable*)`
  into `*repl-known*`. This mirrors the batch path and also serves macro hygiene: a macro
  template that mentions an integrable (e.g. `(syntax-rules () ((_ e) (+ e e)))`) must treat
  `+` as a *known* binding, or hygiene would rename it to `+.0` and leave it unbound.

`inline-primitives` itself runs in **every** door — `compile-forms`,
`compile-program-with-imports`, and `repl-lower-form` — right after rename/resolve. One pass,
every path: that is the mechanical reason dev and ship inline identically.

---

## Examples

### Direct call — baseline codegen, no closure

```scheme
(+ a b)          ; ⇒ inline  add i64  (never a call)
(cons x y)       ; ⇒ (primcall %cons x y) ⇒ @rt_cons
```

### As a value — a real procedure is synthesized

```scheme
(map cons xs ys) ; cons ⇒ (lambda (p q) (primcall %cons p q))
(apply + ns)     ; + ⇒ a self-contained rest-param sum-fold over %+
(fold-left * 1 ns)
(for-each display items)
```

### Shadowing — user always wins

```scheme
;; top-level redefinition
(define (cons a b) (list 'shadowed a b))
(cons 1 2)                       ; ⇒ (shadowed 1 2)

;; lexical binding
(let ((+ (lambda (a b) (* a b)))) ; a local "+" that multiplies
  (+ 3 4))                        ; ⇒ 12, not 7

;; even set! shadows
(set! car (lambda (p) 'nope))     ; the ordinary binding wins from here on
```

### Universal — no import needed

```scheme
;; a user library that does NOT import (scheme base)
(define-library (my lib)
  (export bump)
  (begin
    (define (bump x) (+ x 100))))  ; + resolves to the intrinsic floor — builds and runs
```

```
$ build/emit run --no-prelude prog.scm   # (cons 1 2) / (+ 1 2) still work: the floor is always present
```

---

## Adding a new integrable primitive

Because the raw `%`-op is a reserved primcall head that the *committed bootstrap seed* must
already recognize, adding a primitive is a **staged bootstrap** (design decision D3), not a
one-line table edit. The safe procedure:

1. **Emit lowering** — add `(%foo "rt_foo")` to the table in `src/emit.ss` (and the inline
   fast-path table too, if it's an arithmetic/comparison op).
2. **Reserve the `%`-name** — add `%foo` to `*prims*` in `src/parse.ss` and **regen** the
   bootstrap, so the committed seed learns `%foo` as a recognized primcall head.
3. **Make the plain name integrable** — add `(foo %foo <arity> [fold-kind])` to `*integrable*`
   and **regen** again.
4. **Verify** — `make && ./run-dev-tests.sh` (18/18), including the self-host fixed point and
   the trust-check (a second regen is a no-op).

The D3 lesson recorded in the archived change: the "two regens per batch" rule is a *safe
upper bound*, not always required — when a batch only renames a primcall head to a `%`-synonym
that lowers to the same `rt_*`, one direct regen often converges. The fixed-point loop fails
loudly (no convergence in 5 iterations) if a jump is too big, at which point you insert the
stage-1 synonym regen. Try direct first.

If a new integrable is used inside macro templates, no extra work is needed: unioning
`(map car *integrable*)` into both known-sets (§6) covers it automatically.

---

## Known limitation — shadowed n-ary folding ops (task 4.3, deferred)

The n-ary → binary reduction for the folding ops (`+ - * = < string-append`) is done by the
**expander**, which runs *before* rename and therefore has **no shadow information**. It keys
on the head symbol unconditionally. So a **shadowed** folding op **called with 3+ args, or
with 0/1 args**, is folded as if it were the primitive:

```scheme
(let ((+ f)) (+ 1 2 3))  ; folds to (f (f 1 2) 3), not (f 1 2 3)
(let ((+ f)) (+))        ; folds to 0 (the identity), ignoring f
```

The **2-ary** shadowed case is correct — `(let ((+ f)) (+ 1 2))` → `(f 1 2)` — which is the
spec's shadowing scenario. The gap bites only when a user *both* rebinds one of these six ops
to a *non-associative* function *and* calls it at a non-binary arity — vanishingly rare, and an
associative custom `+` folds to the same result anyway.

The fix (task 4.3, if ever wanted) is to move the n-ary fold out of the expander and into the
shadow-aware `inline-primitives` pass, so it fires only on the unshadowed integrable. It was
rated low-value / moderate-risk and deliberately left as a separate future change. Every other
primitive — every fixed-arity op, and every value/`apply` use of the folding ops — shadows
correctly.

---

## Related documents

- `docs/PIPELINE.md` — the full frontend pass ladder; the `inline-primitives` entry there
  places this pass among its neighbors.
- `openspec/specs/primitive-layer/spec.md` — the normative requirements and scenarios.
- `openspec/specs/core-language/spec.md` — how "primitive" is defined for the core language.
- `openspec/changes/archive/2026-07-18-first-class-primitives/` — the design (`design.md`,
  including decisions D0–D4), proposal, and the batch-by-batch rollout record.
- `docs/MODULES.md` — how `(scheme base)` and user libraries are assembled on top of the floor.
