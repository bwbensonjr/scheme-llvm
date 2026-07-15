## 1. Spike: prove flattening preserves the fixed point (the gate)

- [ ] 1.1 Produce the flattened source by hand or a one-off script: `match`/`util` de-`library`'d
  with the `%match-pat`/`%match-clauses` rename baked in, `core.ss` with `include`s dropped and
  the reader unified on `read-all-from-string`, per-target entry files split out.
- [ ] 1.2 Concatenate (ordered `cat`) → the assembled program; run it through the **current**
  `schemec` and confirm the self-hosting triple still reaches a byte-identical fixed point
  (stage-2 ≡ stage-3).
- [ ] 1.3 Build `scheme-run` / `repl-host` from the flattened source's IR and confirm behavior is
  identical (spot-check demos + the REPL harnesses). Record the finding (go / adjust).

## 2. L0 — Chez-free user build (commit IR as inputs; default = link only)

- [ ] 2.1 Makefile: give `bootstrap/*.ll` no source prerequisites in the default graph; add
  `all: scheme-run repl-host` as the default target (bare `make` builds both).
- [ ] 2.2 Move every Chez-invoking regeneration recipe behind an explicit `regen` target (not on
  the default path), so `make` on a Chez-less machine only links committed IR (design D4).
- [ ] 2.3 `run-all-tests.sh`: make the default suite Chez-free — demos via `scheme-run`
  (reuse the hardcoded expected values), REPL via `repl-host`. Add `run-dev-tests.sh` for the
  Chez-bound suites (backends, self-emit/fixed-point, IL-level units), auto-skipping if `chez`
  is absent (design D5).
- [ ] 2.4 Verify a Chez-less build+test: with `chez` off `PATH`, `make && ./run-all-tests.sh`
  is green and invokes no Chez.

## 3. L1 — Chez-free recompile (commit schemec IR; regenerate via the compiled compiler)

- [ ] 3.1 Add `src/run.cpp --emit` (write the embedded compiler's returned IR to stdout instead
  of JITting it), reusing committed `embed.ll`; a `bin/` wrapper does emit + `clang` → native exe
  (design D7).
- [ ] 3.2 Commit `bootstrap/schemec.ll` (self-compiled), so `schemec` builds from committed IR +
  clang with no Chez (design D3).
- [ ] 3.3 Rewire the `regen` recipes to emit the committed `bootstrap/*.ll` via the compiled
  compiler (`schemec` / `scheme-run --emit`) over the assembled source, not `chez … --emit-ir`.
- [ ] 3.4 Confirm the regen loop is Chez-free end to end: edit a trivial compiler source detail,
  `make regen`, rebuild, and see the change reflected — no Chez.

## 4. L2 — Chez-free assembly (flatten source; concatenation replaces the assembler)

- [ ] 4.1 Land the flattening from the spike as the real source: `match` → flat `define-syntax`
  (+ `%`-renamed helpers), `util` → flat defines, `core.ss` → no `include`s / unified reader,
  `entry-{schemec,embed,repl}.scm` committed (design D2).
- [ ] 4.2 Replace assembly with an ordered-`cat` Make/shell recipe producing each target program;
  retire `tools/assemble-core.ss` from the default build (keep as historical/reproduction tool).
- [ ] 4.3 Update the Chez-hosted `compile.ss` and IL-level unit tests to consume the flat source
  (they may keep using Chez, but must load the same flat files — no separate `library` tree to
  maintain).
- [ ] 4.4 Decide + record where the frozen genesis source/tooling lives (in place with a note vs
  a `historical/` move) (design open Q).

## 5. Anti-stale trust-check (Chez-gated, CI)

- [ ] 5.1 Add the trust-check: from a clean tree, `make regen` and assert `git diff --exit-code
  bootstrap/` — the committed IR must equal what current source regenerates (design D6).
- [ ] 5.2 Have the trust-check also re-derive the fixed point from the frozen genesis source under
  Chez (second-host confirmation), reusing `self-host-fixpoint.sh`.

## 6. Verification

- [ ] 6.1 Fresh clone, LLVM-only (no Chez): `make` builds `scheme-run` + `repl-host`; both run
  correctly; `scheme-run --emit | clang` yields a working native exe.
- [ ] 6.2 Chez-free regeneration: a compiler-source change rebuilds all committed IR + binaries
  with no Chez and the new behavior is observable.
- [ ] 6.3 Default `run-all-tests.sh` green and Chez-free (no `chez` invoked); `run-dev-tests.sh`
  (with Chez) green including the trust-check.
- [ ] 6.4 Self-hosting fixed point still byte-identical; `scheme-run`/`repl-host`/AOT outputs
  unchanged vs before the change.

## 7. Documentation

- [ ] 7.1 README/Makefile restructure: lead with "install LLVM → `make` → run / build exe / REPL"
  (Chez-free); move Chez to a secondary "Regenerating the compiler (bootstrap)" section; explain
  the committed-IR-as-source-of-truth model and the trust-check.
- [ ] 7.2 Note the deliberate reversal of `fix-stale-repl-host-rebuild`'s auto-rebuild (committed
  IR is authoritative; anti-stale guarantee moved to the trust-check).
