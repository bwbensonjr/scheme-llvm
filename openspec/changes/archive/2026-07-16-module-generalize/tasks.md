## 1. Baseline and fixtures

- [x] 1.1 Confirm `run-all-tests.sh` and `run-dev-tests.sh` are green on the current tree (Stage 1 landed); note the Stage 1 `test/modules-*` cases and the demo byte-identity guard still pass
- [x] 1.2 Add transitive-chain fixtures: library `(b)` exporting a procedure (e.g. `add1`), library `(a)` that `(import (b))`s and exports a procedure calling `add1`, a program importing `(a)`, and manifest entries for all
- [x] 1.3 Add export-rename fixture: a library defining `%fast-map` and declaring `(export (rename %fast-map map))`, plus a program importing it and calling `map`
- [x] 1.4 Add diamond fixtures: `(c)` with an observable one-time init effect, `(a)` and `(b)` each importing `(c)`, and a program importing both `(a)` and `(b)`
- [x] 1.5 Add a cycle fixture: `(a)` importing `(b)` and `(b)` importing `(a)` (used only by the cycle-error test)

## 2. Export-rename surface

- [x] 2.1 Extend the export parser to accept `(rename <internal> <external>)` alongside bare `<name>`; represent each export as `(external . internal)` (bare name → `(name . name)`)
- [x] 2.2 Validate the **internal** side of each export is defined at the library's top level; error at compile time otherwise (extend the Stage 1 undefined-export check)
- [x] 2.3 Compute the export-table entry as external-name key → `mangle(L, internal)` symbol; confirm emission still names the internal global `@"L:<internal>"` (no new emission logic)

## 3. Transitive lib→lib imports

- [x] 3.1 Recognize `(import (<lib>))` declarations inside `define-library` (reuse the Stage 1 library-front split, now applied to library units)
- [x] 3.2 In the driver, build a library unit's import environment from its dependencies' `.exports` and pass it to the same `compile-unit` used for programs (no core change to resolution)
- [x] 3.3 Confirm a library's reference to a dependency's export resolves as `imported` (`b:add1`) → external global the library does not define, and that the library's own defines shadow an imported name of the same spelling

## 4. Dependency graph, cycle detection, ordering (src/compile.ss / bin/scheme-compile)

- [x] 4.1 Build the transitive dependency graph from the manifest + each unit's `import` forms (nodes = libraries + program, edges = imports), closing over the graph
- [x] 4.2 Detect cycles (DFS back-edge) and report a compile-time error naming the cycle before any compile/link
- [x] 4.3 Topologically sort the graph; use the one order to drive unit compile order, `clang` link order, and `__init` call order
- [x] 4.4 Do not link libraries outside the program's transitive import closure

## 5. Initialization ordering and diamonds (src/emit.ss / drivers)

- [x] 5.1 Emit `@scheme_entry` calls to every transitive-closure library's `@"L:__init"` in topological order (dependencies first) before the program body; declare each `__init` external
- [x] 5.2 Confirm the Stage 1 `@"L:__inited"` guard makes a diamond's shared unit run its body once even when reached via multiple dependents

## 6. REPL door — transitive import (src/repl/host.cpp + src/repl-core.ss)

- [x] 6.1 On `(import (L))`, resolve `L`'s transitive dependency closure via the manifest and `addIRModule` each unit `.ll` in topological order into the shared JITDylib
- [x] 6.2 Track already-initialized units in session state; call each unit's `@"L:__init"` once (guard also protects against a redundant call); merge `L`'s export table into the session scope
- [x] 6.3 Confirm a later interactive form calling an export of `(a)` that relies on transitively-imported `(b)` returns the expected value

## 7. Stale-artifact rebuild (driver/host)

- [x] 7.1 Before compiling a unit, compare source mtime to `.ll`/`.exports` mtimes; recompile (rewrite both) when missing/older, reuse when newer
- [x] 7.2 Narrate the rebuild-vs-reuse decision and the resolved build order per `docs/OUTPUT.md`, honoring `EMIT_VERBOSITY`

## 8. Manifest polish (driver)

- [x] 8.1 Generalize the manifest reader to an arbitrary list of `(library (p …) (source …) (artifacts …))` entries keyed by library name; apply a default artifact dir (`build/lib`) when `artifacts` is omitted
- [x] 8.2 Report a compile-time error naming the missing library when an imported library has no manifest entry

## 9. Tests (test/modules-*)

- [x] 9.1 Transitive chain — AOT: build the program importing `(a)`→`(b)`, run it, assert the printed value
- [x] 9.2 Transitive chain — REPL: import `(a)` interactively, assert a form relying on `(b)` returns the expected value
- [x] 9.3 Export-rename: importer sees `map`, `%fast-map` is not visible; export table keys `map` → `@"L:%fast-map"`
- [x] 9.4 Diamond init-once: a program importing `(a)` and `(b)` (both importing `(c)`) runs `(c)`'s one-time effect exactly once
- [x] 9.5 Cycle: a graph with `(a)`↔`(b)` reports a compile-time cycle error (no loop, no link)
- [x] 9.6 Stale-rebuild: touch/edit a library source and assert a recompile; unchanged source reuses artifacts
- [x] 9.7 Missing-library: importing a library absent from the manifest reports the naming error
- [x] 9.8 Confirm all Stage 1 `test/modules-*` cases and Stage 0's demo byte-identity guard still pass; wire new cases into `run-all-tests.sh` (Chez-free doors) and `run-dev-tests.sh` (Chez-gated pieces)

## 10. Regen and verification

- [x] 10.1 If any `CORE_FLAT` file changed (export/import parser tweaks), `make regen` to rebuild `bootstrap/{schemec,embed,embed-repl}.ll`
- [x] 10.2 Run `run-all-tests.sh` — all suites pass, including Stage 0/1 module guards and the demo byte-identity guard
- [x] 10.3 Run `run-dev-tests.sh` — self-emission-equivalence (incl. cross-door unit byte-identity), self-hosting fixed point, and the anti-stale trust-check all pass
- [x] 10.4 Commit regenerated `bootstrap/*.ll` (if any) together with the source change
