## Resumption state (2026-07-18) — Batches A + B SHIPPED (48 prims first-class); next: cleanup

**Branch:** `feat/first-class-primitives` (off `main` @ the D0-decision commit). `main` is
clean of implementation code.

**48 primitives are now first-class and shadowable.** Every direct `make regen` converged at
iter 1; `scheme.base.ll` byte-identical every slice; self-host fixed point + Chez
independent-host re-derivation green; full `./run-dev-tests.sh` 18/18 after each. Slices:
- **Batch A** (commits 0a18580 `cons`, 4303bf0 the 30 fixed-arity prims) — `cons quotient
  remainder car cdr null? pair? equal? not char->integer integer->char string-length
  string-ref string->symbol symbol->string list->string string-set! vector-ref vector-set!
  vector-length vector? bytevector-u8-ref bytevector-u8-set! bytevector-length bytevector?
  symbol? string? char? boolean? integer? exact?`.
- **Batch B.1** (47001c2 + REPL-hygiene fix 0a28c22) — `+ - * = < eq? eqv?`. The D2 expander
  fold already reduces n-ary operator calls to binary forms emitting the plain name, so these
  are plain arity-2 integrables: rename gives binary shadowing, the inliner rewrites to
  `%+`/…, and the inline fixnum fast path is preserved (`(+ 1 2)` still emits `add i64`).
- **Batch B.2** (b141bf5) — `substring string=? make-string string-copy make-vector
  make-bytevector read-all-stdin display write newline` (all fixed-arity in Emit).

**Two things to know for anyone continuing:**
1. **The REPL hygiene known-set** (`init-session` in `repl-core.ss`) must union
   `(map car *integrable*)`, mirroring `compute-known` — else a macro template mentioning an
   integrable (e.g. `+` in `(syntax-rules () ((_ e) (+ e e)))`) gets hygiene-renamed to `+.0`
   and is unbound (fix 0a28c22). Any new integrable is covered automatically now.
2. **White-box golden tests** that assert emitted IL (`test/repl-frontend.ss`) hardcode the
   raw op name, so renaming `+`→`%+` etc. requires updating those goldens.

**Still reserved (by design or pending):**
- **`string-append`** — first-class as a VALUE (via `prim-as-value` at parse time) but NOT
  shadowable and NOT integrable, because its value-eta folds over the prelude global
  `%str-concat`, which must be name-resolved; the post-rename inliner cannot synthesize a
  reference to a prelude binding. Making it integrable needs a **pre-rename value-eta path**.
- Internal `%`-ops (hashing, records, error plumbing, `%no-prelude?`) and the REPL-state ops
  (`repl-mode`/`repl-input`/`repl-state-ref`/`repl-state-set!`) — compiler/host internals,
  never used as values; reserved by design (raw `%`-ops staying internal is a Non-Goal).

**Next (cleanup / completion):**
1. **Variadic value-use gap.** `+ - * = <` have BINARY value-etas, so `(map + xs ys)` works
   but `(apply + ns)` works only for a 2-element `ns` (the spec's `(apply + ns)` scenario is
   only partially met; still a strict improvement — it did not compile at all before). Full
   variadic value-use of the folding ops (`+ - * = < string-append`) needs pre-rename
   fold-helper etas (a shared mechanism with string-append). Solving this closes task 4.1
   (retire `prim-as-value`) and makes `string-append` shadowable too.
2. **Task 4.2** — reconcile "reserved primitive" wording in `core-language` specs/comments.
3. **Task 4.3** (optional) — unify the expander fold into the shadow-aware inliner, which would
   also make n-ary *operator* calls of a shadowed folding op correct (today a 3+-ary call of a
   shadowed `+` still folds as the primitive — a narrow edge, since 2-ary shadowing is correct).
4. **Verification** — 5.3 binary size / regen time within noise; 5.4 `make catalogue`.

**Cons slice (the first Batch A slice), for reference (commit 0a18580):**
- A single **direct `make regen` converged** — the staged 2-regen (D3) proved unnecessary
  for this shape: the old seed never needs to emit `%cons` to compile the new source (it
  compiles the new source treating `cons` as its own prim; the new compiler's inliner only
  fires when the *new* compiler recompiles, and it recognizes `%cons`). The fixed-point loop
  plus the Chez independent-host re-derivation both confirm convergence to a unique point.
- `bootstrap/scheme.base.ll` is **byte-identical** (unchanged) — `cons` and `%cons` both
  lower to `@rt_cons`, and `%cons` never leaks into LLVM IR. Only the three compiler IRs
  (`embed`, `embed-repl`, `schemec`) changed, because their *source* grew the
  `inline-primitives` pass + `*integrable*` table.
- Verified green: trust-check (2nd regen is a no-op), self-host fixed point, and — through
  the **shipped binary** — direct call, `(map cons …)` value, top-level shadow, lexical
  shadow, `--no-prelude`; and — through the **AOT path** — a library using `cons` without
  importing `(scheme base)` → `(5 . 6)` (the spike failure, now fixed).

**Lesson for D3:** the "two regens per batch" rule is a *safe upper bound*, not always
required. When a batch only renames a primcall head to a `%`-synonym that lowers to the same
`rt_*` and the compiler's own source never emits that `%`-op through the *old* seed, one
direct regen converges. Try direct first; the fixed-point loop fails loudly (no convergence
in 5 iters) if the jump is too big, at which point insert the stage-1 synonym regen.

**Done & verified earlier (Chez driver), now also shipped:** the intrinsic-floor mechanism
for `cons`.
- `src/parse.ss`: `cons` removed from `*prims*`, `%cons` added; new `*integrable*` table
  (`(cons %cons 2)`), `integrable-lookup`/`integrable?`; `scope-resolve` treats integrables
  like prims (leaves the symbol); new **`inline-primitives`** pass + `eta-integrable`/
  `fresh-syms`; `*prim-eta-arity*` no longer lists `cons`.
- `src/emit.ss`: prim-table `(cons "rt_cons")` → `(%cons "rt_cons")`.
- `src/core.ss`: `inline-primitives` wired into `compile-forms` AND
  `compile-program-with-imports` (after rename/resolve, before `recognize-let`);
  `repl-lower-form` prep wraps it too; `compute-known` unions `(map car *integrable*)`.
- Verified: direct `(cons a b)` → bare `@rt_cons`; `(map cons …)` eta works; shadowing
  works whole-program; **library-without-`(scheme base)` and `--no-prelude` both work**
  (the two spike failures); `read-all-tests` 6/6 → **no Chez host shim needed**.

**Key design win vs the spike:** the intrinsic floor keeps `%`-ops out of prelude *source*,
so the dual-host shim (task 1.3) is unnecessary.

**Next states (in order):**
1. ~~**Ship the `cons` slice**~~ — **DONE (commit 0a18580).**
2. ~~**Expand Batch A — remaining fixed-arity prims**~~ — **DONE (commit 4303bf0).** 30 prims
   moved to `*integrable*`; direct regen converged; the legacy fixed-arity eta is retired;
   18/18 dev-tests green. (See the Batch A note at the top for membership and the deferred
   `eqv?`/optional-arity ops.)
3. ~~**Batch B — variadic + optional-arity**~~ — **DONE (commits 47001c2, 0a28c22, b141bf5).**
   `+ - * = < eq? eqv?` (B.1) and `substring string=? make-* string-copy display write newline
   read-all-stdin` (B.2) are integrable. The "optional-arity" ops turned out fixed-arity in
   Emit (fixed rt_* C signatures). `string-append` deferred (pre-rename value-eta needed).
4. **Cleanup / completion** (see the top-of-file "Next" list): close the variadic value-use
   gap for the folding ops (shared pre-rename fold-eta mechanism, which also retires
   `prim-as-value` and makes `string-append` shadowable — task 4.1); reconcile spec wording
   (4.2); optionally unify the fold into the inliner (4.3); final verification (5.3) and
   `make catalogue` (5.4).

**How to resume:** `git switch feat/first-class-primitives`; re-baseline with `make &&
./run-dev-tests.sh` (green — bootstrap matches source); then pick up the cleanup list above.

## Context

Grounded in the archived `primitives-first-class-spike`, which took `cons` and `+` through
the full vertical slice. Established: first-class use and shadowability work for free once
primitives are ordinary bindings (the resolver already tracks lexical shadow, user-wins
redefinition, and `set!`); the self-host fixed point converges; tree-shaking prunes unused
wrappers. The spike's dominant finding reshapes the design: making primitives `(scheme base)`
exports makes them **non-universal**, breaking user libraries (which do not import
`(scheme base)`) and `--no-prelude`. Hence D0 below.

## Goals / Non-Goals

**Goals:** every primitive is a first-class, shadowable, universally-available procedure;
direct-call codegen and binary size unchanged where the inliner fires; dev→ship fidelity
(REPL and AOT inline identically via the shared core).

**Non-Goals:** changing the runtime ABI; adding new primitives; making the `%`-raw ops
user-facing (they stay internal/reserved); CPS/ANF or any change below the LLVM boundary.

## Decisions

### D0 — Compiler-intrinsic primitive floor (DECIDED, task 1.1)

**Mechanism chosen: compiler-intrinsic floor (no linked artifact).** The plain primitive
names join a compiler-intrinsic integrable set (like `*prims*` is universal today), so they
are available by construction in programs, user libraries, and `--no-prelude` — no import, no
`primitive-layer.ll`, no module-system change. Realization:

- operator position, resolves to the intrinsic primitive, unshadowed/un-`set!` → **inline** to
  the bare `(primcall %op …)`;
- value position, same conditions → **eta-synthesize** `(lambda (a …) (primcall %op a …))`;
- shadowed (lexical, top-level user define, or `set!`) → the ordinary user binding wins.

The wrapper is thus never a linked closure; it is either inlined away or synthesized per
value-use (tree-shakeable). Universality falls out of the set being intrinsic to the compiler
(in `compute-known`), not imported. The raw `%`-ops remain reserved primcall heads and still
require the staged bootstrap (D3). *Alternative rejected:* an always-imported linked layer
library — more module-system machinery and a link edge on every unit, for a shared closure we
mostly inline away anyway.

```
   raw primcalls (reserved, internal)   %cons %add %car …   → rt_*
              ▲ referenced only by
   PRIMITIVE LAYER (always linked)       (define (cons a b) (%cons a b)) …
              ▲ universally available (programs, libraries, --no-prelude, Chez host)
   (scheme base)  (optional, library-level)   list, map, append, …   ← unchanged
```

- **Alternatives (rejected):** wrappers only in `(scheme base)` — breaks libraries /
  `--no-prelude` (the spike failure); or exposing `%`-ops to users — defeats the purpose.
- **Open sub-question for apply:** is the layer a distinguished always-imported library, or a
  set of definitions merged into every unit's base environment? Decide against how
  `--no-prelude` and library builds currently assemble their environments.

### D1 — Shadow-aware inliner
A pass after resolution rewrites `(call <op> a…)` → `(primcall %raw a…)` iff `<op>` resolves
to the global primitive-layer binding and is neither lexically shadowed, user-redefined, nor
`set!`-ed. All three conditions are already computed (resolver `bound` set; user-wins
resolution; `find-assigned`). Keyed on the resolved binding, not the raw symbol, so
shadowing is respected automatically (spike Q2). Variadic ops carry a fold rule
(arity/identity) in an integrable table.

### D2 — Variadic: keep the expander fold initially
Leave `fold-arith`/`expand-string-append` in place (they already emit correct binary
primcalls for literal n-ary calls); the layer wrapper serves value/`apply` position. Unify
into the table-driven inliner as a later, separate step once the inliner is proven.

### D3 — Staged bootstrap (inherent, from the spike)
Each primitive batch is **two regens**: (1) add the `%`-names as recognized primcalls
(synonyms alongside the plain names), regen so the committed seed learns them; (2) flip the
plain names to layer wrappers, regen. Roll out in batches (fixed-arity first, then variadic)
rather than all at once, to keep each step diagnosable.

### D4 — Dual-host shim
Wherever the primitive-layer/prelude source is `(load)`-ed under Chez (today
`test/read-all-tests.ss`), provide `(define %cons cons)(define %add +)…` so the wrapper
bodies resolve. Keep the shim in one place, applied at those load sites.

## Risks / Trade-offs

- **[Availability regression]** a build path that had raw prims loses them → Mitigation:
  D0 makes the layer as universal as the raw prims; add explicit library + `--no-prelude`
  tests (the spike failures) to the suite as regression guards.
- **[Inliner misses a hot shape]** closure calls on hot paths → Mitigation: byte-compare
  emitted IR against the pre-change baseline for representative programs; the self-host
  regen time is a sensitive whole-compiler benchmark (spike measured +40% un-inlined).
- **[Bootstrap breakage mid-stage]** → Mitigation: each batch is a 2-regen with the full
  dev-suite (incl. trust-check) run at the end of each stage.

## Migration Plan

Staged batches, each: add `%`-synonyms → regen → flip to wrappers + inliner → regen →
full dev-tests. Commit the regenerated `bootstrap/*.ll` at each stable stage. Retire the
eta special-case only after the last batch. Rollback = revert the batch's commits.

## Open Questions

- D0 layer mechanism (distinguished library vs base-env merge) — decide during apply.
- Whether `--no-prelude` should still exist, or become "no `(scheme base)`, primitive layer
  always present" (likely the latter, since the layer is now the floor).
