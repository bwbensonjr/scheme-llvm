## Resumption state (2026-07-18) — paused mid-implementation

**Branch:** `feat/first-class-primitives` (off `main` @ the D0-decision commit). `main` is
clean of implementation code. Work is Chez-driver-verified but NOT yet regen'd/shipped.

**Done & verified (Chez driver only — no regen yet):** the intrinsic-floor mechanism for
`cons`.
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
1. **Ship the `cons` slice** — staged 2-regen bootstrap (stage 1: add `%cons` as a
   `*prims*` synonym while `cons` still recognized, regen so the committed seed learns
   `%cons`; stage 2: the current source, regen), then full `./run-dev-tests.sh`. This proves
   self-hosting. (The spike proved convergence for the analogous shape.)
2. **Batch B — `+`/variadic**: add a fold/identity rule to `*integrable*` and teach
   `inline-primitives` to fold a direct n-ary `(+ …)` into nested `(primcall %add …)`
   (or keep the expander fold per D2 and only eta variadic value-use). Value/`apply` use is
   the eta lambda over a fold. 2-regen + tests.
3. **Scale** to the remaining primitives in staged batches (each a 2-regen + dev-tests).
4. `docs/PIPELINE.md` stage doc; automated regression guards (the library / `--no-prelude`
   cases, currently only manually checked); retire the residual eta special-case; final
   verification (binary size + regen time within noise of baseline).

**How to resume:** `git switch feat/first-class-primitives`; re-baseline with `make &&
./run-dev-tests.sh` (should be green — code changes are inert until regen); then do state 1.

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
