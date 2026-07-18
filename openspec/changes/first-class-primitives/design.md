## Resumption state (2026-07-18) — Batch A (all fixed-arity) SHIPPED; next: Batch B

**Branch:** `feat/first-class-primitives` (off `main` @ the D0-decision commit). `main` is
clean of implementation code.

**Batch A shipped — all single-signature fixed-arity prims are first-class** (commits
0a18580 `cons`, 4303bf0 the 30-prim batch, 197f653 docs). Each was a single direct `make
regen` that converged at iter 1; `scheme.base.ll` byte-identical both times; self-host fixed
point + Chez independent-host re-derivation green; full `./run-dev-tests.sh` 18/18. The
legacy fixed-arity eta (`*prim-eta-arity*`, `nsyms`) is retired; `prim-as-value` now holds
only the variadic `string-append` case. `not` is fully first-class/shadowable/universal
(its `core-language` spec requirement is met).

**Batch A membership (31 integrable prims):** `cons quotient remainder car cdr null? pair?
equal? not char->integer integer->char string-length string-ref string->symbol
symbol->string list->string string-set! vector-ref vector-set! vector-length vector?
bytevector-u8-ref bytevector-u8-set! bytevector-length bytevector? symbol? string? char?
boolean? integer? exact?`.

**Next: Batch B — the deferred ops.** Two sub-groups, both still reserved prims today:
1. **Expander-folded variadic** (`+ - * = < eq? eqv? string-append`, and the `> <= >=`
   keyword forms): `expand.ss` folds n-ary calls to binary primcalls (`expand-arith`,
   `expand-compare`, `expand-string-append`) keyed on the head symbol, independent of
   `*prims*`. Per D2, keep that fold emitting binary raw primcalls for literal calls; add an
   integrable entry so **value/`apply` position** eta-expands (e.g. bare `+` → a fold lambda,
   bare `eq?` → `(lambda (a b) (primcall %eq? a b))`). Decide whether the fold should emit the
   `%`-op directly (then these names leave `*prims*` like Batch A) or keep emitting the plain
   name that the inliner then rewrites. Retiring `prim-as-value`/`string-append`'s special
   case (finishing task 4.1) lands here.
2. **R7RS optional-arity** (`make-string make-vector make-bytevector substring string-copy
   string=?`): the inliner keys on an exact arity, so these need either per-arity integrable
   entries or a variadic integrable shape. Verify actual call-site arities in the tree first.

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
3. **Batch B — variadic + optional-arity** (the two sub-groups in the resumption note above):
   the expander-folded family (`+ - * = < eq? eqv? string-append`) and the R7RS optional-arity
   ops (`make-*`, `substring`, `string-copy`, `string=?`). Keep the expander fold per D2 for
   literal n-ary calls; add integrable entries so value/`apply` position works; finish
   retiring `prim-as-value`. Regen + tests.
4. **Scale** to any remaining reserved prims (I/O `display`/`write`/`newline`/`read-all-stdin`,
   REPL state ops) if they should be first-class; leave the internal `%`-ops reserved.
5. `docs/PIPELINE.md` stage doc (**done**, commit 1a906f5); automated regression guards (the
   library / `--no-prelude` cases, currently only manually checked); final verification
   (binary size + regen time within noise of baseline); `make catalogue` refresh.

**How to resume:** `git switch feat/first-class-primitives`; re-baseline with `make &&
./run-dev-tests.sh` (green — bootstrap now matches source); then do state 2 (expand Batch A).

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
