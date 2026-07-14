## Context

Every way of running Scheme today spawns a process: AOT/bitcode link with `clang`, JIT
runs `lli`, and `--repl` runs a Chez front end (`run-repl`, `src/compile.ss:179`) that
frames per-form IR to `build/repl-host` (a C++ ORC/LLJIT executor). The batch compiler is
already Chez-free as a subprocess (`build/schemec`, the assembled core wrapped by
`tools/assemble-core.ss --filter-main` as `(display (compile-source-string
(read-all-stdin)))`).

Two facts make an in-process **batch** runner small and clean:

- The emitted whole-program entry `@scheme_entry` is **ccc** and returns a tagged `val`
  (`src/emit.ss:519`, `src/runtime/runtime.c:619`). So the embedded compiler can be called
  as an ordinary linked C symbol, and a JIT'd user program's entry is reached with
  `JIT->lookup("scheme_entry")`.
- `rt_make_string`, `str_bytes`, `str_len` already exist (`runtime.c:211`), and
  `with-prelude` lives in the core (`core.ss:41`) — so prelude-correct, file-I/O-free
  compilation runs fully in-language.

The interactive REPL, by contrast, needs *stateful, incremental* compilation (persistent
`env`/`macro-env`/`known`/`n`, per-form modules, compile-error rollback) — orchestration
that lives in the Chez driver, not the core, and whose rollback depends on the unfinished
`error`/`guard` downgrade. That is deferred to `repl-embedded-incremental`; this change
proves the mechanism on the whole-program path.

## Goals / Non-Goals

**Goals:**
- One binary that compiles *and* runs a whole Scheme program in-process — no Chez, no
  `clang`/`lli`, no subprocess.
- Establish the reusable embedding primitives: a C-callable compiler entry that returns IR
  text, exported string accessors, and the parse→add→lookup→call→print loop.
- Prelude-correct compilation (user-wins shadowing) with zero file I/O in the compiler.
- dev→ship fidelity: the embedded runner and the batch AOT path agree on emitted IR /
  observable output.

**Non-Goals:**
- The interactive, incremental REPL (persistent env, per-form modules, rollback) — that is
  `repl-embedded-incremental`.
- Modules / namespaces (`.exports`), A-jit (loading the compiler into the JIT), and moving
  off textual IR.
- Changing AOT/JIT/bitcode or the existing `--repl`.

## Decisions

### D1: A-link (static link) over A-jit

Link the embedded compiler (`embed.ll`) natively into `build/scheme-run` and call its
`scheme_entry` as a plain C symbol. A-jit (loading the compiler *into* the JIT) costs
whole-compiler materialization at startup and shares the JITDylib with user code, for no
benefit here. Choose A-link.

### D2: `--embed-entry` — the compiler returns IR as a value (no stdin/stdout `display`)

Add an `--embed-entry` mode to `tools/assemble-core.ss` that ends the assembled core with
`(compile-source-string/prelude *prelude-source* (read-all-stdin))` — so the program's
ccc `scheme_entry` **returns** the IR string instead of `display`ing it. The runner calls
`scheme_entry()` and reads the returned string's bytes. Reading source via `read-all-stdin`
(rather than a `char*` parameter) means the entry keeps the existing zero-argument ccc
shape — no new emitter capability for parameterized entries. The single program's source
arrives on the runner's own stdin.

*Alternative — a `char* rt_compile(char*, size_t)` shim*: would require emitting a
parameterized ccc wrapper (new emitter work) or a C→tailcc trampoline. Returning a value
from the existing zero-arg entry and taking input on stdin avoids both. (The follow-on
REPL change, which must feed many forms, revisits a parameterized entry.)

### D3: Prelude baked in; `with-prelude` runs in-language

Add `compile-source-string/prelude` to the core:
`(compile-forms (with-prelude (read-forms-from-string prelude) (read-forms-from-string user)) no-dump)`.
The `--embed-entry` assembly bakes the prelude text into the program as a string constant
(`*prelude-source*`), read at build time by Chez and present at runtime as an ordinary
string. This reproduces the batch driver's user-wins shadowing (`program-forms` →
`with-prelude`) without the compiler ever touching the filesystem, and makes `scheme-run`
a self-contained standalone binary (supports the standalone-exe niche).

*Alternative — the runner concatenates prelude + user text*: simple, but text
concatenation double-defines any prelude name the user overrides, breaking user-wins
shadowing and dev→ship fidelity. Rejected.

### D4: The runner owns the JIT loop; entry symbols do not collide

`src/run.cpp`: `GC_INIT`, init native target, create `LLJIT`, add a process-symbol
generator (resolves `rt_*` from the linked runtime, as `host.cpp` does). Call the
linked-in `scheme_entry()` (the embedded compiler; it reads stdin) → IR string; copy its
bytes via `rt_string_bytes`/`rt_string_len`; `parseIR` → `setDataLayout` → `addIRModule`;
`JIT->lookup("scheme_entry")` (resolves to the *JIT'd* module's definition, not the linked
compiler's — module-defined symbols are served from the JITDylib, the process generator is
only a fallback for unresolved names); call it; `rt_write` the result + newline (matching
the AOT `main`, `runtime.c:626`). Reuse `setjmp`/`rt_trap` isolation so a runtime trap is
reported rather than aborting.

### D5: Build graph and staleness

`bootstrap/embed.ll` is generated by assembling the core with `--embed-entry`
(`build/embed.scm`) and compiling it with prelude via `chez … compile.ss --emit-ir` (the
compiler program itself uses prelude procedures, so it is built *with* prelude, exactly as
`schemec.ll` is). `build/scheme-run` links `bootstrap/embed.ll` + `runtime.c` (`RT_NO_MAIN`)
+ `run.cpp`, and lists the runtime/host/`embed.ll` (and the core sources behind it) as
prerequisites so a source change rebuilds it, mirroring the `repl-host` staleness graph and
its mtime caveat.

### D6: Check in `bootstrap/embed.ll` as the stage-0 artifact

Commit `embed.ll` at a tracked path (`/build/` is gitignored). It is safe to commit because
the core emits **host-agnostic IR** — no `target datalayout`/`triple` (those come from the
driver, not the core; the `--emit-ir` path omits them). So the committed IR is
cross-platform: `clang` applies the native target when linking, and `run.cpp` sets the JIT
data layout. A Chez-free checkout can build `scheme-run` from the committed artifact; the
D5 rule refreshes it after a compiler-source change. Resolves self-hosting-bootstrap D3.

## Risks / Trade-offs

- **Prelude literal escaping** → bake `*prelude-source*` with correct escaping of `\` and
  `"` (and newlines) so Chez reads it back at build time and the emitter emits a valid LLVM
  string global; verify by diffing embedded-vs-batch IR on a prelude-using demo.
- **`scheme_entry` name appears both linked and JIT'd** → the linked compiler entry is
  called by C symbol; the user program's entry is reached only via `JIT->lookup`, served
  from its module. No external `scheme_entry` reference exists in user IR, so the process
  generator never shadows it. Verified by running a demo end-to-end.
- **IR-string lifetime across the call** → `rt_string_bytes` returns a GC-managed buffer;
  the runner copies it into the `parseIR` `MemoryBuffer` immediately (before further
  allocation). Documented at the call site.
- **Committed `embed.ll` drift** → the D5 staleness graph rebuilds from source when core
  sources are newer; the mtime caveat (checkout timestamps) is the same accepted limitation
  as the existing host graph (`touch`/`rm` to recover).
- **GC in one heap** → `GC_INIT()` once; conservative GC needs no unwinding. The embedded
  compiler and the JIT'd program share the heap; acceptable for a one-shot runner.

## Migration Plan

1. `runtime.c`: add exported `rt_string_bytes` / `rt_string_len`.
2. `core.ss`: add `compile-source-string/prelude`.
3. `assemble-core.ss`: add `--embed-entry` (bakes `*prelude-source*`, emits the value-
   returning entry) → `build/embed.scm`.
4. Makefile: `build/embed.scm` → `bootstrap/embed.ll` (assemble + `--emit-ir`); link
   `build/scheme-run` from `embed.ll` + `runtime.c` + `run.cpp`; add staleness prerequisites.
5. `src/run.cpp`: the JIT runner (D4).
6. Commit `bootstrap/embed.ll` (D6).
7. Verify: `build/scheme-run < demos/fact.scm` ⇒ `120`; new harness runs all demos through
   `scheme-run` and matches expected/AOT; wire into `run-all-tests.sh`; update README.
8. **Rollback:** the change is additive (new mode, new file, new binary); removing
   `scheme-run` and its Makefile/README stanzas restores the prior state. AOT/JIT/bitcode
   and `--repl` are untouched throughout.

## Open Questions

- ~~Stage-0 artifact policy~~ **Resolved (D6):** commit `bootstrap/embed.ll` (host-agnostic).
- ~~Entry-name handshake~~ **Not needed for batch:** the whole-program entry is the fixed
  `scheme_entry`. (Reopens in the follow-on REPL change, which emits per-form thunks.)
- **Result-string convention** for the *follow-on* parameterized entry: `char*` vs
  `(ptr,len)`. Here the value is a Scheme string read via `rt_string_len`, so N/A.
- **Where `scheme-run` prepends the prelude long-term** — baked-in text (this change) vs. a
  separately-compiled prelude module once modules land.
