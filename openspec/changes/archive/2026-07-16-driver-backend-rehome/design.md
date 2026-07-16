## Context

`src/compile.ss`'s `main` dispatch routes a prelude-enabled or importing program to
`build-modular-program` **only for `--backend aot`**:

```scheme
[(and (string=? backend "aot") (or prelude? (pair? (program-imports src))))
 (build-modular-program src out prelude?)]           ; re-home: auto-import (scheme base) + imports
[else
 (compile-file src ll dumpf prelude? via?)            ; PREPEND, single module, no import resolution
 (case backend [(aot) (link …)] [(bitcode) …] [(jit) (run-jit …)] …)]
```

So `--backend jit` and `--backend bitcode` always hit `compile-file`, which prepends the prelude
(`with-prelude`) and strips no `import` forms — confirmed: `--backend jit` on `(import (mylib))`
dies with "lower: unbound variable import". The three backend exits (`link`, `emit-bitcode` +
`build-bitcode-exe`, `run-jit`) each consume **one** `.ll`.

`build-modular-program` already does the re-home + import resolution, but is AOT-specific: it ends
by `clang`-linking `runtime + unit.ll… + prog.ll → exe`. The unit `.ll`s (the transitive closure
incl. `(scheme base)`) never reach jit/bitcode.

## Goals / Non-Goals

**Goals:**
- Route `--backend jit` and `--backend bitcode` through the same re-home + import resolution as aot,
  so all three backends consume the same modular artifact set (`(scheme base)` + imports + program).
- Preserve the 3-way identical-results guarantee (`run-backends.sh`).
- Keep aot behavior byte-identical to today.

**Non-Goals:**
- `--emit-ir` — stays the single-module raw core-IR filter (self-hosting/piping contract, mirrors
  `schemec`); documented as the intentional non-re-homed exception.
- Any change to the committed compiler IR (`bootstrap/*.ll`) — this is Chez-driver-only, no regen.
- `--no-prelude` + no-imports programs — they legitimately stay single-module (no `(scheme base)`).

## Decisions

### D1 — Split `build-modular-program` into a modular-artifacts builder + per-backend consumers

Extract the resolve-imports / build-units / compile-program half of `build-modular-program` into a
driver function that returns the ordered artifact set — the unit `.ll` paths (transitive closure in
topological order, including `(scheme base)`) plus the program `.ll` — after writing them. The three
backends then consume the set:
- **aot**: `clang` links `runtime + units… + prog.ll → exe` (exactly today's tail of
  `build-modular-program`).
- **jit**: `llvm-as` each unit + prog to `.bc`, `clang -emit-llvm` the runtime, `llvm-link` **all**
  of them into one combined `.bc`, run via `lli` (generalizes `run-jit` from one `.bc` to the set).
- **bitcode**: `llvm-as`/`llvm-link` the unit + prog `.ll`s into the program `.bc`, then link the
  `.bc` + runtime → exe (generalizes `emit-bitcode`/`build-bitcode-exe`).

**Why:** one resolution path feeds all backends — the "one frontend, many backends" thesis now holds
over the modular set, not a single module. **Alternative — teach each backend to re-resolve imports
independently:** rejected; duplicates the manifest/closure logic three ways.

### D2 — Dispatch condition becomes backend-independent

Replace the aot-only guard with:

```scheme
(if (or prelude? (pair? (program-imports src)))
    (build-modular <backend> src out prelude?)   ; re-home path for ALL backends
    (single-module <backend> src out prelude?))  ; --no-prelude + no imports: one self-contained module
```

The `single-module` arm keeps `compile-file` for the genuinely library-free case (`--no-prelude`
and no imports), where a single module with no `(scheme base)` is correct — for every backend.

**Why:** the re-home vs single-module split is about whether `(scheme base)`/imports are present, not
about which backend; making the condition backend-independent is what removes the jit/bitcode prepend.

### D3 — `--emit-ir` unchanged (documented exception)

`emit-ir-filter` stays as-is: a single-module raw core-IR emitter (prelude prepend, or `--no-prelude`
prelude-free), for piping and `self-emit-equiv`. It is not a "backend" and its single-module output
is an intentional contract. Documented as the one non-re-homed driver path. (Confirmed with the user.)

## Risks / Trade-offs

- **[jit/bitcode diverge from aot after re-home]** → `run-backends.sh` asserts byte-identical stdout
  across all three per demo; it is the standing guard and must stay green.
- **[`lli` module-set linking differs from the single-module path]** → `run-jit` already
  `llvm-link`s program + runtime bitcode; extending the link to the unit `.bc`s is the same tool,
  more inputs. The `(scheme base)` `__init` ordering is already baked into the program's
  `@scheme_entry` (via `compile-program-with-imports`), independent of backend.
- **[`compile-file` becomes dead for jit/bitcode]** → retained only for the `--no-prelude`+no-imports
  arm (all backends); if that arm proves fully subsumable it can be dropped, but keeping it is the
  minimal, lowest-risk change.
- **[Chez-only, so no committed-IR guard catches regressions]** → covered by `run-backends.sh` and
  the AOT/JIT module suites (Chez-gated dev tests).

## Migration Plan

1. Refactor `build-modular-program` → `build-modular-artifacts` (returns unit-lls + prog-ll) + an
   aot linker that consumes it (behavior-identical to today).
2. Add jit and bitcode consumers of the artifact set; make the `main` dispatch backend-independent
   (D2).
3. Verify `run-backends.sh` (3-way equivalence) stays green; add jit+bitcode checks for a
   prelude-using and an importing program.
4. Docs: backend notes + the `--emit-ir` exception.

**Rollback:** revert `src/compile.ss`; no committed IR or artifacts change, so rollback is a single
source revert.

## Open Questions

- Whether to drop `compile-file` entirely by routing `--no-prelude`+no-imports through the modular
  builder with an empty closure — deferred; keeping `compile-file` for that arm is lower-risk and
  preserves today's single-module output for library-free programs.
