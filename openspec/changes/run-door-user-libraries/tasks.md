## 1. Shared host-side library preload

- [ ] 1.1 Factor `preload_libraries()` and its helpers (manifest read via mode 5,
      unit compile+JIT via mode 4, topological fixpoint with cycle / missing-from-manifest
      detection, `L:__init` invocation) out of `src/repl/host.cpp` into a shared C++
      translation unit (e.g. `src/repl/module-loader.{h,cpp}` or similar).
- [ ] 1.2 Update `src/repl/host.cpp` to use the shared loader with no behavior change;
      confirm `repl-host` still passes its existing module suites.

## 2. Run host wiring

- [ ] 2.1 Point `build/scheme-run` at the mode-dispatched entry (`bootstrap/embed-repl.ll`)
      in the Makefile `$(RUN)` rule so `src/run.cpp` can drive modes 4/5/6 (D2).
- [ ] 2.2 Add `--manifest FILE` / `EMIT_MANIFEST` handling to `src/run.cpp`'s argument
      parsing, matching the AOT/REPL resolution order (env > flag > default `emit-libs.scm`).
- [ ] 2.3 In `src/run.cpp`, before running: read the program's imports, preload the
      transitive user-library closure via the shared loader (task 1), and auto-import
      `(scheme base)` (mode 6) — mirroring `host.cpp`'s startup.

## 3. Program compilation against preloaded units

- [ ] 3.1 Add the dispatched compiler mode (D3) that compiles the whole user-program text
      against the host-supplied direct-import export tables by calling the existing
      `compile-program-with-imports` (`src/compile.ss:553`) — a thin wrapper, no new codegen.
      (First confirm no existing mode already does this; generalize if so — Open Question.)
- [ ] 3.2 Have `src/run.cpp` invoke that mode to get the program module IR, then JIT it into
      the shared JITDylib alongside the preloaded units and run the program's `scheme_entry`,
      initializing units in topological order (D5).
- [ ] 3.3 Preserve the fast path (D4): a program importing only `(scheme base)` / nothing
      with no resolvable manifest keeps today's two-module bake-in path unchanged.

## 4. Regen + build

- [ ] 4.1 `make regen` to rebuild committed IR after the `repl-core.ss` mode addition; verify
      the fixed point converges and a clean-tree regen leaves `git diff bootstrap/` empty
      (trust-check).
- [ ] 4.2 Build `scheme-run` and `repl-host`; report `build/scheme-run` size delta from
      linking the dispatched entry (output convention).

## 5. Tests and fidelity

- [ ] 5.1 Add a run-door test to `test/modules/`: run an importing program (single import and
      a transitive `(a)->(b)` chain) through `build/scheme-run` and assert the value.
- [ ] 5.2 Assert dev→ship fidelity: the run-door value equals the AOT-door value for the same
      manifest, and the run-door program module is byte-identical to the AOT `prog.ll`.
- [ ] 5.3 Add negative tests: an import cycle and an import of a library missing from the
      manifest each report a diagnostic and exit non-zero (no loop).
- [ ] 5.4 Regression: existing `demos/run-tests.sh` (no user imports) still passes unchanged
      on the `scheme-run` backend.

## 6. --emit scope decision

- [ ] 6.1 Decide (per Open Questions) whether `scheme-run --emit` / `bin/scheme-compile`
      emits the full transitive closure for importing programs in this change or as a
      follow-up. If deferred, `log()`/note the limitation so units are never silently dropped.

## 7. Docs

- [ ] 7.1 Update `docs/MODULES.md`: remove the "extending the embedded runner with a manifest
      is future work" caveat and document `scheme-run --manifest` user-library loading.

## 8. Spec sync

- [ ] 8.1 After green tests, sync the delta in `specs/module-system/spec.md` into
      `openspec/specs/module-system/spec.md` (sync/archive workflow).
