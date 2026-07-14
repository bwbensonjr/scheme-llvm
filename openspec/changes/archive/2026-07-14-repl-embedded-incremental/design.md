## Context

The interactive `--repl` is the last place Chez is required at runtime. Its execution half
(`build/repl-host`, C++ ORC/LLJIT) is already Chez-free; its *compilation* half is Chez:
`run-repl` (`src/compile.ss:179`) reads a form, threads persistent state
(`env`/`macro-env`/`known`/`n`), runs `expand-form` → `repl-lower-form` → `repl-lcode` →
`emit-repl-module` → `(ir-text, entry-name, defd)`, frames it to the host, and prints the
value. Compile errors are caught by an R6RS `(guard (e …) …)` that rolls session state back
so a bad form doesn't kill the session.

Three prerequisites now exist:
- **path-a-embedding** — the compiled compiler can be A-linked into a host, called in-process,
  and its returned IR JIT-run (`scheme_entry` ccc, `rt_string_bytes`/`_len`, the parse→add→
  lookup→call loop).
- **r7rs-exceptions-subset** — in-language `guard`/`raise`/error objects, so the compile-error
  rollback can be written in compiled Scheme.
- **namespace-model** — the scope abstraction the ported env must honor to stay module-ready.

## Goals / Non-Goals

**Goals:**
- `--repl` compiles each form via the embedded compiler in one process: no Chez, no per-form
  subprocess, no IR frame protocol.
- Preserve every observable behavior of `interactive-repl` (persistent env, redefinition,
  incremental per-form modules, trap isolation, interactive printing, EOF exits).
- dev→ship fidelity: `--repl` and batch share one compiler core (the same core already
  embedded by `scheme-run`).

**Non-Goals:**
- Modules / `import` in the REPL (namespace-model keeps it additive; not built here).
- `call/cc`, mutual top-level recursion interactively (unsupported today; stays unsupported).
- Changing batch/AOT/JIT/bitcode.

## Decisions

### D1: Host drives the loop; the embedded compiler is stateful

Keep the thin-host / logic-in-compiled-Scheme split (interactive-repl D4). The C++ host owns
the outer loop (it must — it owns the JIT): read a form's text, call the embedded
`compile-one-form`, then run its existing `parseIR → addIRModule → lookup(name) → call →
rt_write`. The embedded compiler owns all *compilation* state and logic. The Chez co-process
and the `"<name> <count>\n"+IR` frame protocol are removed.

*Alternative — compiled Scheme calls back into the host to JIT (fully inverted)*: more
faithful to "loop logic in Scheme" but needs the compiled side to call ORC across the FFI per
form; the host-drives split gets the same Chez-free result with far less new boundary.

### D2: `compile-one-form` — stateful entry + entry-name handshake

Port `run-repl`'s `feed`/`expand-form` into a compiled, stateful entry:

```
compile-one-form(source-text) -> (status . payload)
   status = 'ok     : payload = (ir-text . entry-name)      ; host JITs + looks up entry-name
   status = 'error  : payload = message-string              ; host reports; session continues
   status = 'syntax : payload = name                        ; a define-syntax was registered
```

Session state — `env` (the REPL scope), `macro-env`, `known`, and the form counter `n` —
lives as top-level mutable variables in the embedded compiler; being A-linked in one process,
they persist across calls (exactly what incremental compilation needs). The host reads the
returned strings' bytes via `rt_string_bytes`/`_len` and looks up the returned `entry-name`
(the handshake — the compiler chose it via `emit-repl-module`, so the host is never told a
symbol it must predict). Counters are initialized once at startup and **not** reset per form
(preserving `run-repl`'s gensym discipline).

### D3: Compile-error rollback via in-language `guard`

`feed`'s snapshot-and-restore becomes an in-language `guard` inside `compile-one-form`:
snapshot `env`/`macro-env`/`known`/`n`, `guard` the expand/lower/emit, and on a raised error
restore the snapshot and return `('error . message)`. This is the concrete consumer of
`r7rs-exceptions-subset`. (Internal compiler errors already `raise` via `error`, now
catchable.)

### D4: Input — reading exactly one form (the genuine fork)

The host must hand `compile-one-form` exactly one complete form's text per iteration. Two
options:

- **(a) Host-side balanced reader.** The host accumulates stdin and detects a complete form
  by tracking paren depth while skipping strings, `;` comments, and `#\(`/`#\)` char literals.
  Small but must mirror the reader's lexical rules or it miscounts.
- **(b) In-language completeness probe (recommended).** The host accumulates raw input and
  calls a compiled `form-complete?(buffer) -> (complete . consumed) | incomplete`, reusing the
  real in-language reader (`rd-datum`, which already returns `(datum . next-index)` and handles
  strings/comments/char literals/brackets). The host stays dumb (append bytes, retry on
  `incomplete`); correctness lives in the one reader we already trust.

Recommend (b): it reuses the authoritative reader and avoids a second, drifting lexer in C++.
It needs one new compiled entry (`form-complete?`) and a small host accumulate-until-complete
loop. This is the main open design point (see Open Questions).

### D5: Prelude as a startup batch

`load-prelude!` (compile the prelude as one mutually-recursive batch module, `addIRModule`,
seed `env`/`known`/`macro-env`) becomes an init entry the host calls once: `init-session() ->
prelude-ir`; the host `addIRModule`s it before the first form. Per namespace-model D6, the
prelude is treated as the session's first (implicit) import, not as session-local defines, so
real `import` stays additive later.

### D6: Reuse repl-host; extend the staleness graph

`src/repl/host.cpp` keeps its ORC/LLJIT machinery and trap isolation; it gains the embedded
compiler (A-linked, like `scheme-run`) and calls it instead of reading frames. The Makefile
builds `embed-repl.ll` (the assembled core with the `--repl-entry` stateful entries) and lists
it + the core sources as prerequisites of `build/repl-host`, so a compiler-source change
rebuilds the host (mirroring `scheme-run` / the existing runtime staleness graph). Committed
stage-0 artifact as in path-a-embedding D6.

## Risks / Trade-offs

- **State-snapshot completeness (D3)** → if any mutable compilation state is missed by the
  guard snapshot, a bad form could corrupt the session. Enumerate the state
  (`env`/`macro-env`/`known`/`n`) and snapshot all of it, as `feed` does today. Test with a
  deliberately-erroring form followed by a good one.
- **Counter discipline** → the form/gensym counters must persist across forms but not leak
  cross-session; initialize once in `init-session`, never per form. A wrong reset reintroduces
  the `@__repl_N` collisions the current code avoids.
- **Input completeness (D4)** → an incomplete form must block for more input, not error;
  ensure the probe distinguishes "incomplete" from "malformed".
- **Error-object rendering across the handshake** → the `('error . message)` string is
  produced in-language; ensure it matches today's diagnostics closely enough for the harnesses.
- **Equivalence to Chez REPL** → the REPL-vs-batch and interactive harnesses must pass
  unchanged; they are the acceptance gate.

## Migration Plan

1. Assembly: a `--repl-entry` mode of `assemble-core.ss` emitting the stateful entries
   (`init-session`, `compile-one-form`, `form-complete?`) around the ported `run-repl` logic.
2. Port `feed`/`expand-form`/`load-prelude!` from `compile.ss` into the core (compiled), with
   `guard`-based rollback (D3) and the typed-scope env (namespace-model constraint).
3. Build `embed-repl.ll`; link it into `build/repl-host`; extend the staleness graph (D6).
4. Rewrite `host.cpp`'s loop: accumulate input → `form-complete?` → `compile-one-form` →
   JIT/lookup/call/print; drop the frame reader.
5. Rewrite `run-repl` in `compile.ss` to just launch the host and relay stdin; drop the Chez
   compile step and frame writer.
6. Verify: all REPL harnesses (host, interactive, equivalence, batch-globals) pass Chez-free;
   full `run-all-tests.sh` green.
7. **Rollback:** confined to the `--repl` path + host build; reverting restores the Chez
   frame protocol. Batch/AOT/JIT/bitcode and `scheme-run` are untouched.

## Open Questions

- **Input handling (D4)**: host-side balanced reader vs. in-language `form-complete?` probe.
  Recommend the probe; confirm the incremental-reader boundary with a small spike.
- **Prompt placement**: the `scheme> ` prompt / EOF handling in the host vs. a compiled entry.
- **Where the ported `run-repl` logic physically lives**: extend `core.ss` vs. a new
  `repl-core.ss` assembled only into the REPL entry (keeps batch/`scheme-run` lean).
- **Bootstrap artifact**: one combined embedded compiler (batch entry + REPL entries) vs.
  separate `embed.ll` / `embed-repl.ll` (size vs. simplicity).
