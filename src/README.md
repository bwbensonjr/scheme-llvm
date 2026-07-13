# Compiler internals (`src/`)

This directory **is** the compiler. This document describes its internals: the
compilation pipeline and where each stage lives, the source-tree layout, the
runtime value representation, and the shared calling convention. It is a guide
for working *on* the compiler.

For everything outside that scope, see:

- **Usage, current status, and the language feature set** — the root `README.md`.
- **The pass framework** (how stages are structured and dumped) — `../docs/PIPELINE.md`.
- **IR conventions** (opaque pointers, `tailcc`, `musttail`) — `../LLVM.md`.
- **Toolchain dependencies** (Chez, clang, libgc, LLVM 22) — `TOOLCHAIN.md`.

## Pipeline

The driver (`compile.ss`) reads the program, prepends the prelude, and runs it
through a sequence of hand-rolled `match` passes to textual LLVM IR, then hands
that IR to one of three backends. Each stage is an observable intermediate
language, printable with `--dump`:

```
read (host) + prepend prelude.scm                             compile.ss
  -> collect-toplevel   (gather top-level defines)            compile.ss
  -> expand             (syntax-rules macros, fixpoint)       passes/expand.ss
  -> parse + alpha-rename                                      parse.ss
  -> recognize-let                                             passes/recognize-let.ss
  -> convert-assignments  (set! -> boxes)                      passes/convert-assignments.ss
  -> convert-closures     (letrec / lambda -> closures)        passes/convert-closures.ss
  -> lambda-lift + lower  (-> L-code)                          passes/lower.ss
  -> emit LLVM IR                                              emit.ss
  -> backend: AOT | JIT | bitcode                              compile.ss
```

The `--dump` stages, in order, are `collect-toplevel`, `expand`, `parse+rename`,
`recognize-let`, `convert-assignments`, `convert-closures`, and `lower`.

The three backends all consume one emitted `.ll`: AOT links it with the runtime
via the system clang; bitcode assembles it to `.bc` and codegens a native exe
via LLVM 22; JIT links program + runtime bitcode and runs in-process under
`lli`. See `../LLVM.md` for the backend details.

## Layout

```
compile.ss         driver: pipeline, stage dumps, three backends, --repl
parse.ss           source -> core IL, then alpha-rename
passes/            one pass per file (expand, recognize-let,
                     convert-assignments, convert-closures, lower)
emit.ss            L-code -> textual LLVM IR (opaque ptrs, tailcc, musttail)
prelude.scm        standard library, prepended to every program
runtime/runtime.c  C runtime: tagged values, primitives, libgc, printer, main
repl/              persistent ORC/LLJIT host: host.cpp + build-host.sh
match.sls          vendored Chez match macro (from akeep/scheme-to-llvm)
util.ss            set ops + deterministic fresh names
```

## Value representation

One 64-bit tagged word, shared verbatim between `emit.ss` and `runtime.c`. The
low 3 bits are the tag; a heap object's type is encoded in its pointer tag, so
heap objects carry no header word. All 8 tags are assigned:

| tag | value | kind    | representation |
|-----|-------|---------|----------------|
| 000 | 0 | fixnum  | immediate, payload = `n << 3` (signed) |
| 001 | 1 | boolean | immediate, `#f` = 1, `#t` = 9 |
| 010 | 2 | nil     | immediate, `()` = 2 |
| 011 | 3 | pair    | heap `{car, cdr}` |
| 100 | 4 | closure | heap `{code_ptr, free0, ...}`, called indirectly |
| 101 | 5 | box     | heap `{value}`, for assignment-converted vars |
| 110 | 6 | symbol  | heap `{name}`, interned (`eq?` / `eqv?` by identity) |
| 111 | 7 | ext     | extended heap object; first word is a header code |

Tags 0–6 are exhausted, so further heap types live under `ext` (tag 7) and are
discriminated by a header code in their first word:

| header code | kind      | layout |
|-------------|-----------|--------|
| 0 (`HDR_STRING`) | string    | `{hdr, byte-length, char *bytes}` — UTF-8, explicit length |
| 1 (`HDR_CHAR`)   | character | `{hdr, codepoint}` — full Unicode scalar value |
| 2 (`HDR_VECTOR`) | vector    | `{hdr, length, elem0, …}` — mutable, fixed-length |

## Calling convention

Every Scheme function shares ONE prototype, so tail calls can be marked
`musttail` (LLVM requires matching caller/callee prototypes):

```
tailcc i64 (i64 self, i64 argc, i64 a0 ... i64 a{K-1}, ptr overflow)
```

`K` is the whole-program maximum fixed arity. `self` is the called closure
(arg 0), from which free variables are loaded. `argc` is the actual argument
count: the first `K` arguments ride in the positional slots (padded with 0 when
fewer), and any excess spills through the `overflow` vector (null when there is
none). A fixed-arity callee checks `argc == f`; a variadic callee (`argc >= f`)
rebuilds its rest list from the positional excess plus `overflow`. Tail calls
are emitted `musttail`; `@scheme_entry` is `ccc` (called from C `main`) and its
calls are regular, not tail.
