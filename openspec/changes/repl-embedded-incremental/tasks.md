## 1. Input handling spike (design D4)

- [ ] 1.1 Spike the `form-complete?(buffer)` in-language probe over the existing reader
  (`rd-datum`): given a partial buffer, return `(complete . consumed-text)` or an
  `incomplete` signal, distinguishing incomplete from malformed. Confirm it handles strings,
  `;` comments, `#\(`/`#\)` char literals, and `[...]` brackets.
- [ ] 1.2 If the probe proves awkward, fall back to a host-side balanced reader (D4 option a)
  and record the decision.

## 2. Port the REPL orchestration into the compiled core

- [ ] 2.1 Move `feed` / `expand-form` / `load-prelude!` logic from `src/compile.ss run-repl`
  into the core (a `repl-core.ss` assembled only into the REPL entry, per design open Q), with
  the session state as top-level mutable variables (`env`/`macro-env`/`known`/`n`).
- [ ] 2.2 Model the session env as a typed scope (local / imported / intrinsic) per
  `namespace-model.md`; treat the prelude as the implicit first import (not session-local).
- [ ] 2.3 Wrap per-form compilation in in-language `guard` (r7rs-exceptions-subset): snapshot
  `env`/`macro-env`/`known`/`n`, restore on raise, return an error status (design D3).
- [ ] 2.4 Ensure the form/gensym counters initialize once and never reset per form (preserve
  `run-repl`'s naming discipline; no `@__repl_N` collisions).

## 3. The stateful embedded entries (assembly)

- [ ] 3.1 `--repl-entry` mode in `tools/assemble-core.ss` emitting `init-session`,
  `compile-one-form`, and `form-complete?` around the ported logic → `build/embed-repl.scm`.
- [ ] 3.2 `compile-one-form(text) -> (status . payload)`: `ok` → `(ir . entry-name)`,
  `error` → message, `syntax` → registered name (design D2). Return values readable by the
  host via `rt_string_bytes`/`_len`.
- [ ] 3.3 `init-session()` compiles the prelude as one batch module and seeds session state
  (design D5); host `addIRModule`s the returned IR once at startup.

## 4. Build integration

- [ ] 4.1 Makefile: `build/embed-repl.scm` → `bootstrap/embed-repl.ll` (assemble +
  `--emit-ir` with prelude); decide combined-vs-separate embedded artifact (design open Q).
- [ ] 4.2 Link `bootstrap/embed-repl.ll` into `build/repl-host`; extend the staleness graph to
  the embedded compiler + core sources (design D6).
- [ ] 4.3 Commit the host-agnostic stage-0 `bootstrap/embed-repl.ll`.

## 5. Host: drive the embedded compiler

- [ ] 5.1 `src/repl/host.cpp`: at startup call `init-session` and `addIRModule` the prelude
  batch.
- [ ] 5.2 Loop: accumulate stdin → `form-complete?` → `compile-one-form` → on `ok`
  `parseIR`/`addIRModule`/`lookup(entry-name)`/`call`/`rt_write`; on `error`/`syntax` report
  and continue. Drop the `"<name> <count>\n"+IR` frame reader.
- [ ] 5.3 Preserve trap isolation (`setjmp`/`rt_trap`/`rt_guard_reset`), the `scheme> ` prompt,
  and clean EOF exit.

## 6. Driver: retire Chez from `--repl`

- [ ] 6.1 `src/compile.ss run-repl`: launch `build/repl-host` and relay stdin; remove the Chez
  per-form compile step, the frame writer, and the persistent Chez state.
- [ ] 6.2 Confirm no Chez process is involved in a `--repl` session.

## 7. Verification

- [ ] 7.1 Persistent env across forms; redefinition; forward-reference rejection (unbound).
- [ ] 7.2 Compile-error recovery: a bad form is reported and the session survives the next form.
- [ ] 7.3 Runtime-trap isolation still works (arity error mid-session).
- [ ] 7.4 All REPL harnesses pass Chez-free: `test/repl-host-tests.sh`,
  `test/repl-interactive-tests.sh`, `test/repl-equiv-tests.sh`, `test/repl-batch-tests.sh`.
- [ ] 7.5 Compiler-source-change rebuilds the host (staleness graph).
- [ ] 7.6 Full `./run-all-tests.sh` green; batch/AOT/JIT/bitcode and `scheme-run` unaffected.

## 8. Documentation

- [ ] 8.1 README: `--repl` is now fully Chez-free (embedded compiler); update the pipeline /
  "Backends & process" text and the self-hosting notes (Chez remains only as the bootstrap
  that regenerates the committed embedded IR).
