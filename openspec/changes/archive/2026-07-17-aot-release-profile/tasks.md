## 1. Baseline and measurement

- [x] 1.1 Record before state: AOT `(ack 3 12)` wall time + binary size at current -O0, and the AOT binary size for a `car`-only program (links full `scheme.base`). Capture the JIT time for the dev-vs-ship comparison.
- [x] 1.2 Confirm the seams: AOT link is `link-modular-aot` (`src/compile.ss:566`); the `__init` order and the unit export/reference data available for a reachability walk; verify no `eval`/dynamic name lookup exists (tree-shaking soundness).

## 2. Optimize at the AOT link (release profile)

- [x] 2.1 Add an optimizing step (opt/`-O2`) to the AOT backend over the linked module set, gated to the AOT/build door; keep the JIT and bitcode paths consistent in optimization level.
- [x] 2.2 Confirm the emitter's textual IR and committed `bootstrap/*.ll` are unchanged (optimization is link/codegen-time), so IR byte-identity and self-hosting fixed-point checks are unaffected.

## 3. Reachability tree-shaking (closed-world, AOT-only)

- [x] 3.1 Implement a root-set-driven reachability walk over the units' export/reference graph (prelude = one unit; not special-cased); input = explicit root set (program entry + top-level references).
- [x] 3.2 Generate a program-specific pruned `__init` that constructs only the reachable bindings, in dependency order, so unreachable `code_N` become genuinely unreferenced; let `globaldce`/`-O2` strip them.
- [x] 3.3 Keep the dev/REPL door on the full cached units (open world); apply shaking only on the AOT/build door. One compiler core; no REPL behavior change.

## 4. Tests

- [x] 4.1 Value-equivalence: all demos produce identical results AOT (optimized + shaken) vs before; backend-equivalence (AOT|JIT|bitcode) still holds.
- [x] 4.2 Size/shaking assertions: a `car`-only program's AOT binary omits unreachable `scheme.base` bindings and is smaller than the full-library link; a program that transitively uses a binding retains it.
- [x] 4.3 Root-set-driven check: reachability with a given root set retains exactly the transitively-reachable bindings (a different root set selects a different set through the same mechanism).
- [x] 4.4 Record after Ackermann time + binary sizes; note the before/after (dev-vs-ship inversion resolved).

## 5. Verify

- [x] 5.1 If the emitter is untouched, confirm `bootstrap/*.ll` is unchanged (no regen needed); otherwise `make regen` + trust-check.
- [x] 5.2 Run the Chez-free suite (`run-all-tests.sh`) and the Chez-gated suite (`run-dev-tests.sh`) incl. backend-equivalence, self-hosting fixed point, and the anti-stale trust-check.

## 6. Documentation

- [x] 6.1 Update `docs/PERFORMANCE.md`: mark P1 (DCE) addressed by this change with before/after sizes; cross-reference the P3 (cached-unit) interaction; note the release-profile framing and that B-general remains deferred.
