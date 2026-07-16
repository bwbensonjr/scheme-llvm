## Context

This is Stage 0 of Modules v0 (`docs/superpowers/specs/2026-07-15-modules-v0-design.md`).
The full design is approved; this change lands only the behavior-preserving scaffolding so
the module-artifact stages that follow are small and safe.

Today resolution is flat: `resolve-globals` (`src/parse.ss:224`) maps a free identifier to
`(global-ref sym)` via a flat `name→sym` alist or errors "unbound". Emission names lifted
code blocks `@codeN` from a per-program counter (`src/passes/lower.ss:48`, reset per compile
in `src/core.ss`) and top-level globals as `@"name"` (`src/emit.ss:590`). These per-program
names are exactly what would collide if two separately-compiled units were linked. The REPL
already emits `external global i64` for referenced-but-undefined globals
(`src/emit.ss:706-710`) — the hook the `imported` binding kind will reuse.

The constraint that dominates this change: the touched files are all in `CORE_FLAT` (the
regen source list), so the compiler's own committed IR is regenerated. Correctness is proven
two ways — the compiler's *output* for library-free programs is byte-identical, and the
regenerated *committed IR* is a reproducible self-hosting fixed point (trust-check).

## Goals / Non-Goals

**Goals:**
- A typed scope/binding-kind resolver (`local` / `imported` / `primitive`) replacing the
  flat alist, with `imported` structured but unpopulated.
- A deterministic, unit-parameterized symbol-naming function fixing the export ABI
  (`p₁.….pₙ:x`), routed through global and code-label emission.
- Byte-identical IR for every library-free program; regenerated committed IR is a stable
  fixed point.

**Non-Goals (this change):**
- `define-library`, `export`, `import` syntax — no new surface (Stage 1).
- Emitting library units, `.exports`, `__init` functions, or any artifact.
- Populating `imported` bindings or reading a manifest.
- Any change to `(scheme base)` / the prelude.

## Decisions

### D1 — Typed scope as a thin wrapper over today's resolution

Model a scope as a lookup returning a *binding* record `(kind, symbol)` rather than a bare
symbol. `local` and `primitive` reproduce today's two cases exactly; `imported` is defined
in the datatype and in the emitter (a referenced `imported` binding emits `external global
i64`, reusing the existing REPL hook) but is never produced by the resolver in this change.
This keeps the diff behavior-preserving while giving Stage 1 a populated-by-imports path with
no emitter changes.

*Alternative rejected:* wait and introduce the typed scope together with `import` in Stage 1.
Rejected — bundling the resolver rewrite with new syntax makes the byte-identity guarantee
impossible to isolate and test.

### D2 — Unit-parameterized naming with the program as the empty-prefix unit

Introduce `(mangle library-name internal-name)` returning `p₁.….pₙ:x` (library-name parts
joined by `.`, then `:`, then the internal name). Emission of top-level globals and lifted
code labels takes a *unit* argument; the program unit carries the empty prefix, for which the
naming function returns exactly the pre-change string (`@codeN`, `@"name"`). Library units
(Stage 1) will pass a real library name and get `@"L:x"`.

*Alternative rejected:* mangle immediately for all units including the program. Rejected —
it would change every program's IR now, forfeiting the byte-identity acceptance and forcing a
much larger, riskier review.

### D3 — Prove correctness by byte-identity against a captured baseline

Before editing, capture the emitted `.ll` for every demo (via the existing compile paths).
After the change (and `make regen`), recompile and diff. Any difference for a library-free
program is a defect. This is layered on top of the existing suites and the trust-check, which
independently prove runtime behavior and self-hosting stability.

### D4 — Regenerate committed IR as part of the change

Because `CORE_FLAT` files change, `make regen` is mandatory and its output (`bootstrap/*.ll`)
is committed. The compiler's *output* for user programs is unchanged, but its *own* compiled
form changes because its source changed; the trust-check confirms the new IR is a stable
fixed point reproducible from source.

## Risks / Trade-offs

- **[A subtle naming reroute changes some program's IR]** → the captured-baseline byte-diff
  over all demos is the gate; the empty-prefix program unit must round-trip to the identical
  string. Mitigation: make `mangle` of the empty prefix provably return the input unchanged
  (unit-test it directly).
- **[regen not run / committed IR left stale]** → the anti-stale trust-check in
  `run-dev-tests.sh` fails loudly if committed IR doesn't match a clean regen.
- **[Scope refactor accidentally changes resolution order]** → the resolution-order scenarios
  and the byte-identity diff both catch it; keep `local`/`primitive` behavior literally
  equal to today's two branches.
- **[Change feels like a no-op refactor not worth isolating]** → accepted deliberately: it
  fixes the two hardest blockers (code-label collision, resolution model) under a
  byte-identity guarantee that the combined module change could never offer.

## Migration Plan

1. Capture the demo IR baseline (pre-change).
2. Introduce the binding record + typed scope in `parse.ss`; keep `local`/`primitive`
   identical to today; define `imported` + its `external global` emission but never produce
   it from the resolver.
3. Introduce `mangle` and the unit argument in `lower.ss`/`emit.ss`/`core.ss`; program unit =
   empty prefix.
4. Diff demo IR against the baseline (must be identical); run `run-all-tests.sh`.
5. `make regen`; run `run-dev-tests.sh` (self-emission-equivalence + trust-check).

Rollback is a single revert; the change is additive scaffolding with no new surface.

## Open Questions

- Final printable-safe rule for library-name parts with integer or punctuation components
  (e.g. `(srfi 1)`) — only the *function* is exercised in Stage 0 (via its unit test), so the
  rule can be finalized here without affecting emitted program IR.
- Exact representation of the binding record (tagged pair vs record) — pick whatever keeps
  the `match` passes readable and self-hostable.
