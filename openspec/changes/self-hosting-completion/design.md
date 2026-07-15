## Context

Self-hosting is proven in *capability* but not realized in *plumbing*. `self-host-fixpoint.sh`
compiles the whole compiler with a self-built `schemec` to a byte-identical fixed point, so
there is no language gap — the compiled compiler handles 100% of its own source. Yet
regenerating the shipped `bootstrap/*.ll` still uses Chez twice:

```
  src/*.ss ──①assemble──▶ program.scm ──②compile──▶ bootstrap/*.ll ──clang──▶ binaries
             chez tools/               chez compile.ss                LLVM (no Chez)
             assemble-core.ss          --emit-ir
             (de-library, drop          (REDUNDANT: schemec/
              includes, rename,          scheme-run can do this —
              append entry)              self-hosting proves it)
```

Step ② is habit; the fixed-point test *is* `schemec` doing exactly this. Step ① is the real
Chez dependency: a text-munging script using Chez file I/O — and the project deliberately keeps
file/subprocess I/O **out of the language** (`core.ss`: "self-hosting never has to bring the
filesystem … into the language"), so making the *assembler itself* run under `schemec` is off
the table. The way out is to remove the *need* for a smart assembler.

Prior thinking: `openspec/explorations/chez-free-repl.md` and `…/modules-and-embedding.md`.

## Goals / Non-Goals

**Goals:**
- A developer with only LLVM 22 + libgc can edit the compiler source, regenerate the committed
  compiler IR, and rebuild all binaries — **no Chez**.
- The flat, self-hostable source is the single source of truth; the committed self-compiled IR
  is favored and authoritative.
- Bare `make` builds the compiler runner and the REPL; the default test suite is Chez-free.
- Preserve the byte-identical self-hosting fixed point and all observable behavior.

**Non-Goals:**
- Removing Chez from the repo. It stays as the historical genesis and an optional CI trust-check.
- Adding filesystem/subprocess primitives to the language (would violate the core's I/O stance).
- New language features (modules, numeric tower, etc.) — this is pipeline/plumbing only.
- Changing what the compiler emits for user programs (IR must be unchanged / fixed-point-stable).

## Decisions

### D1: Single source of truth = the flat, self-hostable source (no dual maintenance)

The flat program `schemec` self-compiles becomes the authoritative source. Editing a
library-structured original and re-translating with Chez would leave "developer needs only LLVM"
unmet, so we do **not** keep two live forms. The `library`-structured source is frozen as
genesis provenance (it may drift; it is a museum piece showing the lift-off from Chez), not a
maintained parallel tree.

*Alternative — commit the generated blob and edit it directly*: avoids restructuring but makes
the day-to-day source a mangled concatenation. Rejected: the source must stay pleasant to edit.

### D2: Chez-free assembly via source flattening + concatenation

Bake the assembler's transformations into the source *once*, so "assembly" is ordered `cat`:

| File | Today | After |
|---|---|---|
| `match.sls` | `(library …)`, helper `match-pat` collides with `expand.ss` | flat `define-syntax` + helpers pre-renamed `%match-pat`/`%match-clauses` |
| `util.ss` | `(library …)` | flat top-level `define`s |
| `src/passes/*.ss`, `emit.ss` | already flat top-level | unchanged |
| `core.ss` | `(include …)` the passes; port-based file reader | drop the `include` block (passes are concatenated); unify on `read-all-from-string` (Chez can use it too) |
| entry | assembler appends per `--filter-main`/`--embed-entry`/`--repl-entry` | small committed `entry-{schemec,embed,repl}.scm`, concatenated last |

Assembly becomes a Make/shell recipe: `cat` the ordered source list + the chosen entry →
`program.scm`. No Chez, no de-library logic, no drift from a separate assembler.

`tools/assemble-core.ss` is retired from the default build and kept under a `bootstrap/` or
`historical/` note for provenance / re-deriving the genesis.

### D3: Commit a self-compiled `schemec`; regenerate the committed IR with the compiled compiler

Add `bootstrap/schemec.ll` (self-compiled, like `embed.ll`/`embed-repl.ll`) so `schemec` builds
from committed IR + clang, Chez-free. The Make recipes that (re)produce every committed
`bootstrap/*.ll` invoke the compiled `schemec` (or `scheme-run --emit`) over the concatenated
source, not `chez … --emit-ir`. Concretely the regen loop is:

```
  edit src/*.ss ──▶ make regen:
      cat sources+entry → program.scm            (Chez-free)
      schemec < program.scm > bootstrap/X.ll     (Chez-free, self-hosting)
      clang X.ll runtime.c → binary              (LLVM)
```

`schemec` compiling the source that *includes `schemec`'s own definition* is the self-hosting
loop; the fixed-point test already exercises exactly this.

### D4: Committed IR is a checked-in input, not a default build product (mtime-caveat fix)

Bare `make` links binaries from the committed `bootstrap/*.ll` with LLVM only and **never runs
Chez or regeneration**. The `.ll` targets carry no source prerequisites in the default graph, so
`make` cannot decide they are "stale" and try to rebuild them (which on a fresh clone, under
mtime rules, would shell out to the regenerator). Regeneration is the explicit opt-in `make
regen`. Bare `make` (`all`) builds `scheme-run` and `repl-host`.

This **reverses `fix-stale-repl-host-rebuild`'s** auto-rebuild-on-source-change mechanism. That
change's real concern — shipping a binary that silently lacks a new `rt_*` / a compiler edit —
is preserved by moving the guarantee to D6's trust-check rather than an mtime rule.

### D5: Chez-free default tests; Chez dev/CI suite

`run-all-tests.sh` (default, Chez-free) runs the behavioral suites on the shipped binaries:
demos through `scheme-run` (expected values are already hardcoded), the REPL through
`repl-host`. A separate `run-dev-tests.sh` (Chez, auto-skipped if `chez` is absent) runs the
IL-level unit tests (`expander-tests`, `read-all-tests`, `repl-frontend`), the AOT/JIT/bitcode
backend-equivalence and self-emit checks, and D6's trust-check. Split rationale: the default
suite answers "do the shipped binaries work?"; the dev suite answers "does the source still
build correctly and reproduce the binaries?".

### D6: Anti-stale guarantee = a Chez-gated trust-check

CI (and any developer who wants it) runs `make regen` from a *clean* tree and asserts `git diff
--exit-code bootstrap/` — the committed IR must be exactly what the current source regenerates.
This catches "edited the compiler, forgot to regen" (the failure mode `fix-stale-repl-host-
rebuild` guarded) and doubles as a "trusting-trust" re-derivation: a second host (Chez) rebuilds
the compiler from the frozen genesis source and must reach the same committed fixed point.

### D7: Chez-free standalone executable via `scheme-run --emit`

Add an `--emit` mode to `src/run.cpp`: instead of JITting the IR the embedded compiler returns,
write its bytes to stdout. Reuses the **existing** committed `embed.ll` (which bakes the
prelude), so `scheme-run --emit < prog.scm > prog.ll && clang prog.ll runtime.c -lgc -o prog`
is a fully Chez-free AOT-to-native path — no new committed artifact beyond D3's `schemec.ll`
(and `schemec` itself is the no-prelude filter variant; `scheme-run --emit` is the
prelude-baked one). Provide a thin `bin/scheme-compile` wrapper for the emit+clang step.

## Risks / Trade-offs

- **Fixed-point fragility (gate).** Flattening reorders/renames definitions; emission is
  order-sensitive (temp numbering, symbol-pool intern order), so the byte-identical convergence
  could break. → **Spike first**: produce the flattened source, run it through the current
  `schemec`, confirm stage-2 ≡ stage-3 and that `scheme-run`/`repl-host` built from it are
  behaviorally identical. Everything after the spike is mechanical.
- **Losing auto-rebuild (D4).** A developer who edits the compiler and forgets `make regen`
  builds stale binaries. → the D6 trust-check fails loudly in CI; document the regen step.
- **Genesis drift (D1).** The frozen `library` source rots. → accept it; its only job is
  provenance, and D6 re-derives from it periodically.
- **Two `schemec`-ish entries.** `schemec` (no prelude, driver merges) vs `scheme-run --emit`
  (prelude baked). → keep both; document which is which. Consider unifying later.
- **Coverage moved, not lost.** Backends/self-host/unit suites leave the default runner. → they
  remain in the Chez dev/CI suite; the behavioral guarantees users rely on stay in the default.

## Migration Plan (layered; each layer independently green-able)

```
 L0  Chez-free USER build   commit IR as inputs; sever regen from default graph (D4);
                            make = scheme-run + repl-host; README/test reshuffle (D5)
 SPIKE                      prove flattened source preserves the fixed point + behavior
 L1  Chez-free RECOMPILE    commit schemec.ll (D3); rewire regen recipes to schemec /
                            scheme-run --emit (D3, D7)
 L2  Chez-free ASSEMBLE     flatten match/util/core + entry files; cat-assembly (D2);
                            retire assemble-core.ss from the default path
 VERIFY                     Chez-free default suite green; Chez dev/CI trust-check green (D6)
 DOCS                       README/Makefile restructure; genesis note
```

**Rollback:** confined to build plumbing + source structure. The committed `bootstrap/*.ll` and
the frozen genesis source let any layer be reverted to the Chez-driven path.

## Open Questions

- **Where the frozen genesis source lives** — leave in `src/` with a header note, or move to
  `historical/` / `bootstrap/genesis/`? Moving is cleaner but churns paths the archived changes
  reference.
- **`schemec` vs `scheme-run --emit`** — keep both, or make one the canonical batch compiler
  and derive the other? Affects how many committed IR artifacts there are.
- **Whether the IL-level unit tests should also go Chez-free** (compile them with `schemec` and
  run the binaries) or stay a Chez-only convenience. They test compiler internals the shipped
  binaries don't expose.
- **Trust-check host** — is Chez the only genesis host, or should the trust-check also allow a
  second independent path (defends "trusting trust" more strongly)?
