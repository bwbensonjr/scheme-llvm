## 1. Baseline and fixtures

- [x] 1.1 Confirm `run-all-tests.sh` and `run-dev-tests.sh` are green on the current tree (Stage 0 landed); note the demo byte-identity guard (`test/module-scaffold-baseline.sh`) still passes
- [x] 1.2 Add the Stage 1 fixtures: a trivial library source `(mylib)` that defines and `(export …)`s one procedure (e.g. `greet`), a program that `(import (mylib))` and prints its result, and a two-entry `emit-libs.scm` manifest mapping `(mylib)` to its source
- [x] 1.3 Add second-library fixtures for the no-collision test: `(liba)` and `(libb)`, each with an internal `helper` of the same spelling plus a lifted code block (a closure), each exporting one procedure

## 2. Surface syntax (define-library / export / import)

- [x] 2.1 Recognize `define-library` at the front of the pipeline and split its declarations into `(library-name imports exports body-forms)`; keep the split ahead of/within expansion so later passes are unchanged
- [x] 2.2 Parse `(export <name> …)` (bare names only) into an export list; validate each exported name is defined at the library's top level, erroring at compile time otherwise
- [x] 2.3 Parse whole-module `(import (<lib>))` into an import list; leave `only`/`except`/`prefix`/rename unimplemented (explicit Stage 2)

## 3. compile-unit core entry (src/core.ss)

- [x] 3.1 Add a `compile-unit` core function: `(body-forms, library-name, import-env) -> (values ir-text export-table)`, a sibling of `compile-source-with-prelude`, keeping the core free of file/subprocess I/O (import-env arrives as in-memory data; export-table is returned as data)
- [x] 3.2 Build the in-memory import environment (external-name -> mangled-symbol) from the imported libraries' export tables and thread it into resolution

## 4. Resolution: populate the imported binding kind (src/parse.ss)

- [x] 4.1 Extend `scope-resolve`/`resolve-globals` to consult the import environment between "own top-level" and "primitive", producing `(make-binding 'imported @"L:x")` on a hit (own defines still win — shadowing)
- [x] 4.2 Confirm an `imported` binding flows through the existing `imported -> (global-ref sym)` arm to an `external global i64` reference the importing unit does not define (Stage 0 hook)

## 5. Library-mode emission (src/emit.ss)

- [x] 5.1 Add a library-mode emit path (sibling of `emit-program`) that binds `*emit-unit*`/`*unit*` to the library name and emits one external-linkage `@"L:x" = global i64 0` per export
- [x] 5.2 Emit `@"L:__init"` that runs the library's top-level defines to populate the export globals, wrapped in a one-shot `@"L:__inited"` guard (idempotent), and emit NO `@scheme_entry`
- [x] 5.3 Produce the `<unit>.exports` table data (external-name -> mangled-symbol; reserved unused macro slot) returned from `compile-unit`
- [x] 5.4 Generalize the program unit's `@scheme_entry` to call each imported library's `@"L:__init"` (declared external) before the program body

## 6. AOT door — build-program (src/compile.ss / bin/scheme-compile)

- [x] 6.1 Add a manifest reader for `emit-libs.scm` (default path, `--manifest` override) mapping a library name to source (+ optional artifact dir, defaulting under `build/lib/`)
- [x] 6.2 Add an import-aware build path: resolve the program's imports via the manifest, `compile-unit` each library (writing `L.ll` + `L.exports`), compile the program against the import env, and link `clang runtime.c L.ll prog.ll -lgc -o exe`; do not link unimported libraries
- [x] 6.3 Narrate unit compiles/links per `docs/OUTPUT.md` (`compile (mylib) -> build/lib/mylib.ll [N bytes]`, `link … -> exe`), honoring `EMIT_VERBOSITY`

## 7. REPL door — import (src/repl/host.cpp + src/repl-core.ss)

- [x] 7.1 Handle `(import (<lib>))` in the REPL front-end: resolve via manifest, `compile-unit` the library, `addIRModule` `L.ll` into the shared JITDylib
- [x] 7.2 Look up and call `@"L:__init"` exactly once on import; merge `L.exports` into the session scope as imported bindings so later forms reference them via external globals
- [x] 7.3 Confirm a later interactive form calling an imported procedure resolves and returns the expected value

## 8. Tests (test/modules-*)

- [x] 8.1 AOT: build the importing program via build-program, run it, assert the printed value
- [x] 8.2 REPL: import `(mylib)` interactively and assert calling the export returns the expected value
- [x] 8.3 Shadowing: a program defining its own `greet` while importing `(mylib)` uses its own definition
- [x] 8.4 Cross-door byte-identity: the `mylib.ll` produced for AOT equals the one produced for the REPL, byte-for-byte (extend self-emission-equivalence to the unit)
- [x] 8.5 No-collision blocker: a program importing both `(liba)` and `(libb)` (same-named internal `helper` + lifted code) links and runs with no symbol conflict
- [x] 8.6 Init-once: calling `@"mylib:__init"` twice runs the body once (guard works)
- [x] 8.7 Wire the new suite into `run-all-tests.sh` (Chez-free doors) and `run-dev-tests.sh` (Chez-gated pieces)

## 9. Regen and verification

- [x] 9.1 If any `CORE_FLAT` file changed, `make regen` to rebuild `bootstrap/{schemec,embed,embed-repl}.ll`
- [x] 9.2 Run `run-all-tests.sh` — all suites pass, including the Stage 0 demo byte-identity guard (library-free programs unchanged)
- [x] 9.3 Run `run-dev-tests.sh` — self-emission-equivalence (incl. the unit), self-hosting fixed point, and the anti-stale trust-check all pass
- [x] 9.4 Commit regenerated `bootstrap/*.ll` (if any) together with the source change
