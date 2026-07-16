> **Scope note (decided during apply):** re-home the **Chez driver (`compile.ss`) + the
> REPL** in this change; **defer the Chez-free embedded runner** (`scheme-run` /
> `bin/scheme-compile`) to a follow-on. Consequence: `embed.ll` is unchanged, so the demo
> values and the Stage-0 byte-identity baseline are **untouched** (only `embed-repl.ll`
> regenerates). Section 5 is therefore deferred; section 8 becomes "confirm the baseline still
> passes" rather than regenerating it.

## 1. Baseline

- [x] 1.1 Confirm `run-all-tests.sh` and `run-dev-tests.sh` are green on the current tree (Stage 2 landed); note the Stage-0 byte-identity baseline (`test/module-scaffold-baseline.sha256`) currently passes (and, per the scope note, stays unchanged since `scheme-run` is not re-homed this stage)
- [x] 1.2 Inventory the prelude split points: `src/prelude.scm` (89 procedures + 9 `define-syntax`), and every prepend site (`src/compile.ss`, `src/entry-embed.scm`, `src/repl-core.ss`), plus the `*prelude-source*` baking in `tools/regen.sh`

## 2. Split the prelude into (scheme base) + macro set (single source: src/prelude.scm)

- [x] 2.1 Write a small generator (`tools/gen-scheme-base.ss`) that reads `src/prelude.scm` and emits the runtime half — wraps the non-`define-syntax` forms as `(define-library (scheme base) (export …) (begin …))` at `lib/scheme/base.sld`, exporting every procedure name (the `define-syntax` forms stay in the body so the library compiles, but are not exported)
- [x] 2.2 (superseded) No separate `*prelude-macros-source*` bake is needed — both doors filter the prelude source they already have (`src/prelude.scm` for the Chez driver, the baked `*prelude-source*` for the embedded REPL) for `define-syntax` at compile time. Simpler, one fewer baked constant, same result.
- [x] 2.3 Check in `lib/scheme/base.sld` and add a **regenerate-and-diff guard** (a test that reruns the generator and fails if the checked-in copy is stale) so it cannot drift from `src/prelude.scm`. (Simplification found during apply: the macro half needs **no separate baked constant** — both doors filter the prelude source they already have for `define-syntax`; only `base.sld` is generated.)
- [x] 2.4 Add `(library (scheme base) (source "lib/scheme/base.sld"))` to the default `emit-libs.scm` (and the test manifest)

## 3. Compile (scheme base) as a library (runtime half), committed and kept fresh

- [x] 3.1 Compile `lib/scheme/base.sld` in isolation with the derived-form macros in scope (prelude procedures use `cond`/`case`/…); confirm it compiles without an unbound-macro error
- [x] 3.2 Verify the emitted `scheme.base.ll` exports the prelude procedures, has a guarded `@"scheme.base:__init"`, and defines no `@scheme_entry`; verify `scheme.base.exports` maps each procedure name to `scheme.base:<name>`
- [x] 3.3 Confirm `mangle` yields the expected `scheme.base:x` for the two-part `(scheme base)` name
- [x] 3.4 Build `scheme.base.{ll,exports}` **on demand** (cached by Stage-2 stale-rebuild in `build/lib`) rather than committing them. (Revised during apply: the compiled `.ll` embeds a host-specific target-triple header, so a committed copy is non-portable across dev machines; both active doors already build it once (~1s) and cache it, and the byte-identity baseline is untouched. The `base.sld` **source** is committed and guarded (2.3), so "edit prelude.scm → regenerate → commit" stays one motion; the committed-compiled-artifact optimization moves to the embedded follow-on if it proves worthwhile.)

## 4. Auto-import (scheme base) — Chez batch door (src/compile.ss)

- [x] 4.1 Route a prelude-enabled program through `compile-program-with-imports` with macro-only `prelude-forms` (the derived-form macros) and an implicit `(scheme base)` import added to the program's imports; `--no-prelude` bypasses both
- [x] 4.2 Ensure the implicit `(scheme base)` participates in the transitive closure / topological order and links exactly once alongside any explicit imports
- [x] 4.3 Confirm user-wins shadowing: a program defining its own `map` uses its definition, not the `(scheme base)` export

## 5. Auto-import (scheme base) — AOT embedded door (DEFERRED to a follow-on)

> **Deferred (scope decision):** `scheme-run` / `bin/scheme-compile` keep prepending the
> prelude this stage; re-homing the Chez-free embedded runner (a new `run.cpp` preload
> protocol + embedded compile-mode dispatch) is a follow-on. Keeping `embed.ll` unchanged is
> what leaves the demo-values suite and the byte-identity baseline untouched.

- [ ] 5.1 (deferred) Embedded compile mode compiling the user program via import+macros against `(scheme base)`
- [ ] 5.2 (deferred) `src/run.cpp` preloads `scheme.base.ll`; `--emit` links it
- [ ] 5.3 (deferred) `bin/scheme-compile` links `scheme.base.ll`
- [ ] 5.4 (deferred) dev→ship fidelity across the embedded runner and the Chez driver

## 6. Auto-import (scheme base) — REPL door (src/repl-core.ss + src/repl/host.cpp)

- [x] 6.1 `init-session`: stop prepending the full prelude batch; merge the derived-form macros into `*repl-macro-env*`/`*repl-known*`, and auto-import the preloaded `(scheme base)` by merging its exports into the session scope
- [x] 6.2 Confirm the host still preloads `(scheme base)` as a manifest library (existing behavior) and that `--no-prelude` yields an empty session (no macros, no auto-import)
- [x] 6.3 Confirm an interactive form using a prelude procedure and a derived-form macro (e.g. `(cond …)` over `map`) returns the expected value

## 7. Regen and fixed point

- [x] 7.1 `make regen` — only `embed-repl.ll` changes (repl-core re-home; `entry-embed`/`embed.ll` untouched this stage); confirm a stable fixed point is reached
- [x] 7.2 Confirm `regen.sh`'s `T-* = prelude ++ compiler` structure is unchanged and `(scheme base)` is NOT linked into `schemec`/`scheme-run`/`repl-host` for their own execution (scope boundary held)
- [x] 7.3 Run the anti-stale trust-check: `make regen` from a clean tree reproduces the committed `bootstrap/*.ll` byte-for-byte

## 8. Byte-identity baseline (unchanged this stage)

- [x] 8.1 Confirm demo **values** are unchanged (behavior preserved)
- [x] 8.2 Confirm `test/module-scaffold-baseline.sh` still passes WITHOUT regeneration — `scheme-run` is not re-homed this stage, so demo IR is unchanged (the baseline regeneration moves to the embedded follow-on)

## 9. Tests (test/modules-* and demos)

- [x] 9.1 Prelude-only program (uses only prelude procedures, no explicit import) builds+runs via `(scheme base)` — AOT door — asserting the value
- [x] 9.2 Same program in the REPL — asserting the value
- [x] 9.3 Derived-form macros without a prepended prelude: `cond`/`case`/`when` in a prelude-only program work on both doors
- [x] 9.4 `--no-prelude`: a reference to a prelude procedure AND to a derived-form macro are both unbound/undefined errors
- [x] 9.5 `(scheme base)` links exactly once when auto-import coincides with an explicit import
- [x] 9.6 User-shadow: a program defining its own `map` uses its own definition
- [x] 9.7 Wire the new cases into `run-all-tests.sh` (Chez-free doors) and `run-dev-tests.sh` (Chez-gated pieces)

## 10. Verification

- [x] 10.1 Run `run-all-tests.sh` — all suites pass, including demo values and the REPL doors
- [x] 10.2 Run `run-dev-tests.sh` — self-emission-equivalence, self-hosting fixed point, and the anti-stale trust-check all pass; the AOT module suite passes
- [x] 10.3 Commit regenerated `bootstrap/*.ll`, the regenerated baseline, `lib/scheme/base.sld`, and the source changes together
