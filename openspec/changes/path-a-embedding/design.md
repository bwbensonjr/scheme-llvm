## Context

The REPL has two halves in two processes: **compilation** (`chez compile.ss --repl`
reads a form, runs the pass pipeline, emits a per-form IR module) and **execution**
(`build/repl-host`, a C++ ORC/LLJIT process that `parseIR`s the module, `addIRModule`s
it, looks up the form's thunk, and calls it). They are coupled by a stdin frame protocol:
`"<entry> <byte-count>\n"` then that many bytes of IR (`src/repl/host.cpp:118`).

The batch path already has a Chez-free compiler: `build/schemec`, the assembled core
compiled to native by the Chez-hosted compiler, wrapped by `tools/assemble-core.ss
--filter-main` as `(display (compile-source-string (read-all-stdin)))` — a stdin→stdout
IR filter. That same assembled core is what we now want to call *in-process* from the
host. The FFI surface is one function: build a Scheme string from the entered text, call
`compile-source-string`, hand back the result string's bytes.

Constraints: keep the text-IR seam (the host still `parseIR`s text); preserve every
observable REPL behavior; do not foreclose the module-scoped namespaces of the follow-on
modules work (`openspec/explorations/modules-and-embedding.md`).

## Goals / Non-Goals

**Goals:**
- Remove Chez from `--repl`; compile each form in one process via the embedded compiler.
- Guarantee dev→ship fidelity: `--repl` and batch use the same compiler core.
- Add a callable `rt_compile` C-ABI entry as a sibling of the existing `--filter-main`.
- Preserve all observable REPL behavior and keep both REPL test harnesses green.

**Non-Goals:**
- Modules / namespaces / `.exports` (the follow-on; only *don't preclude* them here).
- Loading the compiler *into the JIT* at runtime (A-jit) or user-redefinable compiler.
- Moving off textual IR toward LLVM-C IR building.
- Changing batch/AOT/JIT/bitcode paths, or the value representation / calling convention.

## Decisions

### D1: A-link (static link) over A-jit

Statically link the compiled compiler into the host: `clang compiler.ll runtime.c
host.cpp → build/repl-host`, and call `rt_compile` as a plain C function pointer.

*Alternative — A-jit* (host `parseIR`s `compiler.ll` into its own LLJIT at startup and
`lookup`s `rt_compile`): more "live" (compiler is another module in the world) but costs
whole-compiler materialization at every REPL startup and shares the JITDylib between
compiler and user code. A-link has zero startup cost and the host is *already* rebuilt
whenever the runtime changes (the Makefile staleness graph), so "rebuild when the
compiler changes too" is a natural extension, not a new mechanism. A-jit is only needed
for a user-redefinable compiler — out of scope. Choose A-link.

### D2: `--repl-entry` — a callable C-ABI shim, sibling of `--filter-main`

Add a `--repl-entry` mode to `tools/assemble-core.ss` that ends the assembled core with a
C-ABI entry instead of a stdin→stdout main. The entry, `char* rt_compile(const char*
src, size_t len)`, builds a Scheme string from `(src,len)` with the runtime's existing
string constructor, calls `compile-source-string`, and returns a pointer to the result
string's bytes (NUL-terminated or paired with an out-length). The core proper is
unchanged — this is purely an alternate entry, exactly as `--filter-main` is.

*Alternative — call `compile-source-string` (a `tailcc` closure) directly from C++*:
forces the host to construct closure/argc/overflow frames and speak the internal calling
convention. The shim keeps the ABI crossing in one generated Scheme-side function and
gives C++ a stable plain-C symbol. Choose the shim.

### D3: The host owns the loop; source text in, no frame protocol

`src/repl/host.cpp` reads a whole form's *source text* from stdin (the driver just relays
keystrokes/lines), calls `rt_compile` to get IR text, then runs its existing
`parseIR → addIRModule → lookup → call → rt_write` path. The `"<name> <count>\n"+IR`
frame protocol and the Chez compile step in `src/compile.ss --repl` are removed.

Each per-form module must expose a **distinct** entry thunk symbol, because every module
is added to the same JITDylib and duplicate definitions collide — the compiler already
names them `@__repl_1`, `@__repl_2`, … via an internal counter (`emit-repl-module`),
which now lives in the persistent embedded compiler (D4).

### D3a: Entry-name handshake — the compiler returns the name

The host learns the entry symbol from `rt_compile`'s output rather than predicting it:
`rt_compile` reports the name it chose (a companion nullary `rt_compile_entry_name()`
returning the most recently compiled form's symbol — natural given persistent state — or
`rt_compile` returning `{ir, entry}`), and the host looks up exactly that string. This is
today's design relocated in-process: the frame header's `name` field
(`src/compile.ss:226`) becomes a return value.

*Alternative — fixed scheme (host predicts the name)*: either a single fixed symbol
(`@__repl_entry` every form — rejected, it collides across modules in one JITDylib) or a
**lockstep counter** where the host maintains its own `N` in parallel with the compiler.
The lockstep counter works but creates two counters that must never drift: it couples the
host to the compiler's counting rule, and forces both sides to agree on whether `N`
advances when a form fails to compile. The handshake keeps one source of truth (the
compiler), decouples the host from naming internals, and makes compile-failure trivially
correct (no name returned → the host looks up nothing). Choose the handshake; the only
cost is one extra return value / companion call.

*Alternative — keep the driver, embed only the compiler*: leaves two processes and a
protocol for no benefit once Chez is gone. Fold the loop into the host.

### D4: Persistent compiler state is a feature, kept in-process

The embedded compiler's globals (gensym counter, rename environment, interned symbols)
persist across `rt_compile` calls within the one host process — exactly what incremental
per-form compilation needs (a subprocess would start fresh each form). Determinism
within a session is preserved because the gensym counter advances monotonically; no
`reset-counter!` between forms.

### D5: Host build tracks the compiler source (staleness graph extension)

`compiler.ll` becomes a build input to `build/repl-host`. The Makefile gains a rule to
produce `compiler.ll` from the core sources (via `schemec`/Chez) and lists it — and the
core sources behind it — as prerequisites of the host, so a compiler-source change
rebuilds the host before next use, mirroring the existing runtime/host staleness handling
(and its documented mtime caveat).

### D6: Check in `compiler.ll` as the stage-0 artifact

Commit `compiler.ll` to the repo rather than regenerating it on every host build. This is
safe because the compiler core emits **host-agnostic IR** — the `target datalayout`/
`triple` header is prepended by the *driver* (`host-target-header`, `src/compile.ss`), not
the core — so the checked-in IR carries no platform lock-in and clang applies the native
target when linking `build/repl-host` on any host. This resolves the stage-0 policy
reopened by D3 of self-hosting-bootstrap: a `chez`-free checkout can build the REPL host
from the committed `compiler.ll`, and the Makefile rule that regenerates it stays as the
way to refresh it after a compiler-source change (the D5 staleness graph still points the
host at the sources behind it).

*Alternative — regenerate each build*: cleaner in that no generated file is tracked, but
requires Chez/`schemec` at host-build time and slows every host build. The cross-platform
property of the emitted IR removes the usual objection to committing a build artifact, so
prefer checking it in.

## Risks / Trade-offs

- **Global-name collision between compiler and user globals in one process** → the
  compiler's internals are lambda-lifted/mangled, but audit for any *unmangled* top-level
  global that could clash with a user `define`; keep a compiler-private prefix and do not
  assume a shared flat namespace (also the seam for future modules).
- **String-ownership / lifetime across the FFI** → `rt_compile` returns a GC-managed
  Scheme string; the host must consume its bytes (copy into the `parseIR` buffer) before
  the next allocation-heavy call. Document that the pointer is valid until the next
  `rt_compile`.
- **GC pressure: compiler now allocates in the heap it compiles into** → single
  `GC_INIT()` unchanged; Boehm is conservative so no frame unwinding needed. Watch
  session-long heap growth; acceptable for a dev REPL.
- **Bootstrap: `compiler.ll` must exist at host-build time** → regenerate via
  `schemec`/Chez each build (clean but slower) vs. commit a stage-0 artifact (fast,
  checked-in generated file). Reopens self-hosting-bootstrap D3; see Open Questions.
- **mtime staleness caveat** inherited from the existing host graph → same recovery
  (`touch` / `rm build/repl-host`); accepted limitation.

## Migration Plan

1. Add `--repl-entry` to `tools/assemble-core.ss`; verify it assembles the same core with
   the `rt_compile` entry (sanity: assemble + compile, no pipeline change).
2. Add the runtime-side glue if needed (string in/out helpers already exist for
   `read-all-stdin`/`display`; reuse them).
3. Makefile: rule for `compiler.ll` from the core; link it into `build/repl-host`; add
   compiler sources to the host's prerequisites.
4. `src/repl/host.cpp`: read source text, call `rt_compile`, feed the returned IR into the
   existing parse/add/lookup/call path; drop the frame reader.
5. `src/compile.ss`: `--repl` launches the host and relays source text; remove the Chez
   compile step and frame writer.
6. Run REPL end-to-end, interactive, equivalence, and batch harnesses; require a
   Chez-free `--repl` to pass all.
7. **Rollback:** the change is confined to the `--repl` path and the host build; reverting
   restores the Chez frame protocol. Batch/AOT/JIT/bitcode are untouched throughout.

## Open Questions

- ~~**Stage-0 artifact policy**~~ **Resolved (D6):** check in `compiler.ll`; the emitted
  core IR is host-agnostic, so the committed artifact is cross-platform.
- ~~**Entry-name handshake**~~ **Resolved (D3a):** the compiler returns the entry symbol
  name; the host looks up exactly that string.
- **Result-string convention**: NUL-terminated `char*` vs. `(ptr,len)` pair — the latter
  is safer if emitted IR could ever contain a NUL (it should not, but be explicit).
- **Compiler-private namespace prefix**: what prefix guarantees no clash with user
  globals, and does it double as the first step toward module-scoped names?
