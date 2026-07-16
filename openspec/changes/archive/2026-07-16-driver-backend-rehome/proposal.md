## Why

With the compiler bootstrap re-homed, `(scheme base)` is library zero everywhere — except the
Chez driver's **secondary backends**. Only `--backend aot` routes prelude/importing programs
through `build-modular-program` (auto-import `(scheme base)`, resolve imports, link the unit set);
`--backend jit` and `--backend bitcode` still fall through to `compile-file`, which **prepends the
prelude** and cannot resolve imports at all (`(import …)` → "unbound variable import"). So the same
prelude-using program has structurally different IR across backends, and jit/bitcode can't build a
modular program — the last prepend paths in the driver.

## What Changes

- **`--backend jit` and `--backend bitcode` re-home like `--backend aot`.** A prelude/importing
  program built with any of the three backends resolves the prelude through the auto-imported
  `(scheme base)` and its imports through the manifest — one compilation path, not three.
- **Generalize the modular build to yield an artifact set.** `build-modular-program` is split so
  the driver-owned modular build produces the ordered list of unit `.ll`s (the transitive import
  closure, including `(scheme base)`) plus the program `.ll`; each backend then consumes that set:
  - **aot**: `clang` links runtime + all units + program → native exe (unchanged behavior).
  - **jit**: `llvm-link` all units + program + runtime bitcode → `lli` (was: single module).
  - **bitcode**: assemble/`llvm-link` all units + program → `.bc`, linked with the runtime → exe.
- **jit/bitcode gain module-import support** as a direct consequence (they route through the same
  manifest-driven resolution the aot door uses).
- **`--emit-ir` is unchanged** — it stays the single-module, raw core-IR filter (its
  self-hosting/piping contract, mirroring `schemec`), documented as the intentional
  non-re-homed exception. `(scheme base)` is reached only via the aot/jit/bitcode backends.
- **No user-observable value change.** The 3-way backend equivalence harness (`run-backends.sh`)
  keeps asserting aot == jit == bitcode; re-homing changes the IR the secondary backends use, not
  the values they produce.

## Capabilities

### New Capabilities
<!-- None; this finishes an existing capability. -->

### Modified Capabilities
- `backends`: The "one frontend → AOT/JIT/bitcode exits" property is reframed from *a single
  emitted IR module* to *the same modular artifact set* (the program plus its linked libraries,
  including the auto-imported `(scheme base)`) driving all three exits; jit and bitcode re-home and
  gain module-import support; the three-way identical-results guarantee is preserved.

## Impact

- **Code**: `src/compile.ss` — split `build-modular-program` into a modular-artifacts builder +
  per-backend consumers; adapt `run-jit` and the bitcode path to link the unit set; retire the
  `compile-file`/prepend path for jit/bitcode (kept only where no prelude and no imports apply, or
  removed if fully subsumed). `--emit-ir`/`emit-ir-filter` untouched.
- **Tests**: `demos/run-backends.sh` (3-way equivalence) must stay green; add a jit + bitcode
  check that a prelude-using and an importing program build and run (exercising the re-homed path).
- **Docs**: `README.md` / `docs/PIPELINE.md` backend notes; note `--emit-ir` as the documented
  single-module filter exception.
- **Chez-only**: this touches the Chez driver (`compile.ss`), not the committed compiler IR — so
  `bootstrap/*.ll` are unaffected and no regen is required.
- **Not in scope**: `--emit-ir` re-home (documented exception); the committed compiler build (done
  in `compiler-bootstrap-rehome`).
- **No breaking change** to values.
