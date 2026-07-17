# LLVM Backend

Reference for the LLVM-specific parts of the Scheme → LLVM IR compiler: toolchain,
IR conventions this project commits to, the backends, known gotchas, and citations.
If you are working on codegen, the runtime, or the JIT, read this first.

The compiler is **hosted in Chez Scheme** (bootstrap host) and expresses its pass
pipeline as a sequence of small typed passes (hand-rolled over s-expressions with
`match` initially, revisiting nanopass if the pass count grows — see `docs/PIPELINE.md`).
For the broader design rationale (why LLVM at all,
how it compares to meta-tracing and partial-evaluation approaches), see the project
design notes. This document assumes that decision is made and covers *how* the LLVM
layer works here.

---

## Scope

The compiler lowers full Scheme to a small core language, then to LLVM IR:

```
read → macro-expand → core Scheme → CPS/ANF → closure convert → LLVM IR → { AOT | JIT | bitcode }
```

Everything up to "core Scheme → LLVM IR" is backend-independent and documented
elsewhere. **This file covers the final arrow and everything downstream of it.**

---

## Toolchain and versions

| Component | Choice | Notes |
|-----------|--------|-------|
| Host / bootstrap | Chez Scheme | nanopass's primary host; matches the `akeep/scheme-to-llvm` reference. |
| Pass framework | hand-rolled `match` (nanopass if pass count grows) | Expand → core → assignment-convert → closure-convert → lambda-lift as a sequence of small typed passes. See `docs/PIPELINE.md`. |
| LLVM interface (phase 1) | **Textual `.ll` + `clang` / `llc` / `opt`** | No bindings. Emit IR as text, shell out. This is the default. |
| LLVM interface (phase 2, optional) | LLVM **C API** via Chez FFI (`foreign-procedure`) | Only when an in-process ORC JIT is wanted. |
| LLVM | 22.x | Pin it. The `.ll` text syntax is relatively stable but not frozen (see Gotchas re: opaque pointers). |
| GC (phase 1) | Boehm–Demers–Weiser (`libgc`) | Conservative, no IR cooperation needed. |
| GC (phase 2) | LLVM statepoints | Precise/relocating; x86_64 + AArch64 only (see Gotchas). |

### Why emit textual IR rather than bind to LLVM (to start)

LLVM's own FAQ lists three ways for a non-C++ compiler to interface: call into the
LLVM libraries through your language's FFI, emit LLVM assembly text, or emit LLVM
bitcode. For a Chez-hosted compiler, text is the right default:

- **No binding to write or maintain.** You generate strings and shell out. Chez's
  `system` / `process` procedures drive `clang` directly.
- **Not coupled to LLVM's C/C++ ABI.** FFI bindings break across LLVM major versions;
  emitted text only has to track `.ll` syntax, which moves far less.
- **Text supports every IR feature** — custom calling conventions, `musttail`,
  statepoints — with none of the C API's historical feature gaps.
- **Direct precedent, same author as nanopass.** Andy Keep's `scheme-to-llvm` is
  written in Chez Scheme with nanopass; under the covers it produces a `.ll` file and
  uses `clang` to compile and link it into an executable. Same host, same framework,
  same architecture we're building. Read it as a template.
  (https://github.com/akeep/scheme-to-llvm)

The one real tradeoff is the JIT story: shelling out gives you AOT for free, but a
REPL means re-invoking the toolchain per top-level form or leaning on `lli`, which is
clunkier than an in-process engine. That is what phase 2 addresses.

### Why this ordering matters for bootstrapping

The compiler is hosted on Chez only to get off the ground; the goal is self-hosting.
The textual-IR approach keeps the self-hosting porting surface small: the compiler's
*output* (LLVM IR text → native code) has **no dependency on Chez**, and the only
host-specific things the compiler itself needs are nanopass and the ability to shell
out. A C-API FFI backend, by contrast, would be written against *Chez's* FFI and
would have to be re-ported to the new Scheme's FFI at self-hosting time. Emitting
text first means the day you can compile the compiler, you can drop Chez cleanly.
This is a deliberate argument for deferring the FFI backend, not just a convenience.

### When to add the C-API FFI backend (phase 2)

Add it when you want a genuine in-process ORC JIT (live redefinition without
re-invoking `clang` per form), and accept the coupling cost. Chez's
`foreign-procedure` + shared-object loading can bind `libLLVM`'s C API directly.

The historical objection to the C API is now resolved: the *Compiling with
Continuations and LLVM* paper noted in 2018 that the C API lacked some features such
as `musttail`, but **LLVM 18 added `LLVMSetTailCallKind` / `LLVMGetTailCallKind`**
(including `LLVMTailCallKindMustTail`), so on our LLVM 22 pin the C API can emit
guaranteed tail calls. Precedent: Extempore's Scheme-hosted xtlang compiler drives
LLVM through a C/C++ FFI shim for exactly this in-process-JIT purpose.

### Install (development)

The toolchain is discovered via `llvm-config` + `pkg-config bdw-gc` (`tools/llvm-env.sh`),
so any reasonably recent LLVM works — LLVM 19+ is expected (older warns, set `EMIT_LLVM_MIN`
to change), with no upper bound.

```sh
# Chez Scheme + nanopass on the library path (see nanopass README for --libdirs).
# A recent LLVM/clang toolchain (any version discoverable via llvm-config):
sudo apt-get install llvm-22 clang-22        # or your distro's LLVM packages / Homebrew `llvm`
# Conservative GC:
sudo apt-get install libgc-dev
# Phase 2 only: the libLLVM shared library for FFI (bundled with the llvm-NN package).
```

Override discovery when needed: `LLVM_CONFIG` / `EMIT_LLVM_BIN` for the LLVM tools, `CC`
for the AOT compiler, `GC_INC` / `GC_LIB` / `GC_DYLIB` for libgc.

Sanity checks:

```sh
clang --version        # confirm 22.x
llc --version          # confirm the target you expect (x86_64 / aarch64)
```

```scheme
;; From Chez, with nanopass on the libdirs path, mirroring akeep/scheme-to-llvm:
;;   scheme --libdirs <nanopass>:<project-src>
;; then import the compiler library and round-trip a trivial program through
;; emit-.ll → clang → run.
```

---

## IR conventions used by this project

These are the conventions codegen must uphold. Changing any of them is a
cross-cutting change — discuss before touching.

### Value representation — tagged pointers

Every Scheme value is one machine word. Low bits are a type tag; the rest is either
an immediate (fixnum, char, boolean, `'()`) or a pointer to a heap object whose first
word is a header tag. Rationale: cheap fixnum arithmetic (shift/mask), aligned heap
objects, standard Scheme practice.

- Fixnums: tagged immediately, no allocation.
- Pairs, closures, strings, vectors, bignums, etc.: heap-allocated, header-tagged.
- All runtime primitives dispatch on the tag.

**Current tag assignments (3-bit tag, `src/runtime/runtime.c`).** `0` fixnum, `1`
boolean, `2` nil, `3` pair, `4` closure, `5` box, `6` symbol, `7` **extended object**.
All eight primary tags are now assigned: tag `7` is a header-word "extended" heap object
whose first word is a small type code, so every further heap type (strings, characters,
and later vectors/bytevectors/flonums) adds a header code with **no new primary tag**.

**Symbols (tag 6, interned).** A symbol is a heap object holding its name; `rt_intern`
canonicalizes by name through a process-wide table so equal names are pointer-identical,
which makes `eq?` (word equality) correct for symbols with no special case, and `rt_write`
prints the name. The intern table is allocated `GC_MALLOC_UNCOLLECTABLE` — permanent,
pointer-scanned memory that keeps the interned symbols alive as roots. A plain static
pointer into the GC heap is *not* sufficient: under `lli`'s ORC JIT the module's data
segment is not a registered Boehm root, so the table array would be collected mid-run
(caught by the `symbol-gc` demo across all three backends).

**Strings (tag 7, header-word) and characters (immediate).** A string is an extended object
`{HDR_STRING, byte-length, codepoint-length, char *bytes, cpidx *index}` storing UTF-8 bytes
with an explicit byte length (so embedded NULs are fine). The stored codepoint length makes
`string-length` O(1) and drives an ASCII fast path — when byte-length equals codepoint-length
the string is all-ASCII, so codepoint index equals byte offset and `string-ref`/`substring`
are O(1) with no scan. For genuinely multi-byte strings, `index` is a lazily-built (NULL until
first random access), fixed-stride codepoint→byte breadcrumb table that turns an indexed
traversal from O(n²) into O(n) — see backlog **P4** / change `codepoint-string-indexing`. A
character is an **immediate**: the boolean tag `001` is a
misc-immediate family, and subtype `SUB_CHAR` carries the full Unicode scalar value in the
payload bits — no heap object, no interning, so equal codepoints are the same word and
`eq?`/`eqv?` hold intrinsically. `rt_write` prints a string write-style between quotes (its
bytes verbatim) and a character as `#\` followed by the codepoint UTF-8-encoded, with a small
named-char set (`#\space`, `#\newline`). String literals reuse the symbol constant-emitter
path: a private byte-array global (`@.str.lit.N`) plus a per-use `rt_make_string(ptr, len)`;
character literals emit the immediate constant inline (`(codepoint << 8) | SUB_CHAR | tag`),
no runtime call. Strings are
**mutable**: `string-set!` (`rt_string_set`) splices the UTF-8 buffer for the new codepoint
and rewrites the object's byte-length/bytes words in place, so the identity is preserved and
aliases observe the change (O(n) per set); it drops any built breadcrumb `index` (now stale)
back to NULL. `string-copy` gives an independent duplicate.

**Vectors (tag 7, header-word).** A vector is an extended object
`{HDR_VECTOR, length, elem0, …}` — mutable and fixed-length, each element a tagged `i64`.
`rt_make_vector`/`rt_vector_ref`/`rt_vector_set`/`rt_vector_length`/`rt_vector_p` are the
primitives; the `vector` constructor and `list->vector` are prelude Scheme. `rt_write` prints
`#(e0 e1 …)` and the reader reads `#(…)`. `rt_equal` recurses element-wise into vectors.

**Bytevectors (tag 7, header-word).** A bytevector is an extended object
`{HDR_BYTEVECTOR, byte-length, uchar *bytes}` (header code 1, reclaiming the retired
`HDR_CHAR` slot) — mutable, fixed-length, elements are raw bytes (0–255) in a separate
`GC_MALLOC_ATOMIC` buffer (pointer-free, like a string's bytes).
`rt_make_bytevector`/`rt_bytevector_u8_ref`/`rt_bytevector_u8_set`/`rt_bytevector_length`/`rt_bytevector_p`
are the primitives; the `bytevector` constructor and `list->bytevector` are prelude Scheme.
`rt_write` prints `#u8(b0 b1 …)` and the reader reads `#u8(…)`. `rt_equal` compares bytevectors
byte-wise (`memcmp`).

**Hash tables (tag 7, header-word).** A hash table is an extended object
`{HDR_HASHTABLE, spine}` (header code 4) — an opaque wrapper around a mutable *spine* vector
`#(count buckets _)`, where `buckets` is a vector of association lists. The wrapper is the whole
runtime footprint (`rt_make_hash_table`/`rt_hash_table_spine`/`rt_hash_table_p`); every
`hash-table-*` operation lives in the prelude over the spine, keyed by `equal?` and bucketed by
`rt_hash` (`%hash`) — an FNV-1a/word hash guaranteed only to be *consistent with* `equal?` (the
bucket scan is the source of truth, so collisions are slow, never wrong). The table grows
(rehashes into ~2× buckets) past a load factor. `rt_write` prints the opaque `#<hash-table N>`
(N = count); tables are not readable.

**Records (tag 7, header-word).** `define-record-type` lowers (in the frontend, at
`collect-toplevel` — before `expand`) to a fresh type descriptor plus a constructor, predicate,
and per-field accessors/mutators over the record primitives. A record instance is
`{HDR_RECORD, type-descriptor, field0, …}` (header code 5); the descriptor is a distinct object
`{HDR_RECORD_TYPE, name-string}` (code 6) minted once per definition, so two records share a type
iff their descriptors are the same object (`eq?`) — making types disjoint.
`rt_make_record_type`/`rt_make_record`/`rt_record_ref`/`rt_record_set`/`rt_record_of_type_p`/`rt_record_p`
are the primitives. `rt_write` prints the opaque `#<record TYPE>`; records are identity types
(`eqv?`/`equal?` only on the same object, no field recursion — handled by `rt_equal`'s existing
`a == b` fast path, so no record-specific arm is needed).

**Quoted structure is materialized at runtime.** `(quote sym)` emits a private
string-constant global (`@.str.sym.N = private … c"name\00"`) plus a per-use
`rt_intern` call; `(quote (a . d))` emits `rt_cons` over the recursively encoded car/cdr,
with immediates (fixnum/bool/`()`) still encoded inline and strings/chars via their
extended-object encoders. Consequence: a quoted list literal is rebuilt on each evaluation,
so two evaluations are `equal?` but not `eq?` — only symbols guarantee `eq?`. Hoisting a
literal into a build-once global (for identity + speed) is a noted future optimization.

Alternatives considered and *not* used by default: NaN-boxing (attractive only if
float-heavy) and a tagged struct/union (simplest to emit, worst on space/cache). Keep
the representation behind the `values` module so codegen and the runtime don't
hard-code bit layouts.

> Design note: dynamic typing is the real cost center of Scheme-on-LLVM. This is
> where the boxing/dispatch work lives, and it is the interesting engineering
> question of the project. A cautionary precedent: Extempore pairs an interpreted
> Scheme with `xtlang`, a *statically typed* lisp that JITs to LLVM IR, and chose
> static typing for the compiled layer precisely because dynamically-typed Scheme is
> hard to make fast on LLVM. We keep the LLVM layer dynamically typed on purpose —
> eyes open about the cost.

> ABI split, know it: the tagged-word layout currently has **two owners**. The C
> runtime (`src/runtime/runtime.c`) owns fixnum/pair/box arithmetic and the tag
> constants; the emitter (`src/emit.ss`) independently hardcodes the *same* layout in
> `encode-const` (fixnum `<<3`, `#t`=9, `#f`=1, `()`=2), closure tagging (`or …, 4`),
> and untagging (`and …, -8`). Any change to the representation must touch both. The
> higher-value cleanup, whenever the representation next moves, is to document the
> tagged-word ABI as one authoritative spec both sides cite rather than to add a third
> owner.

### Runtime primitives — defined in C, not IR

Primitives (`+ - * = <`, `cons`/`car`/`cdr`, `null?`/`pair?`/`eq?`, `box`/`unbox`/`set-box!`,
and the string/char accessors `char->integer`/`integer->char`, `string-length`/`string-ref`/
`substring`, `string->symbol`) are C functions in `src/runtime/runtime.c`; the emitter
declares them and lowers each `(primcall op …)` to a `call i64 @rt_op(…)`. The string
accessors are codepoint-indexed over the UTF-8 storage (decode on access; O(n) indexing for
now). **This is a deliberate decision, not an
interim shortcut.** The alternative — open-coding primitives as inline LLVM IR (or a
hand-written `.ll` runtime) — was considered and rejected for phase 1:

- **Simplicity/transparency (the project's stated goal).** `val rt_car(val v) { return
  as_ptr(v)[0]; }` is self-documenting; the IR equivalent scatters bit-layout knowledge
  into `emit.ss` as string-built `and`/`inttoptr`/`getelementptr`/`load`. C wins plainly
  on arithmetic too.
- **A C runtime exists regardless.** Allocation (`GC_MALLOC` via `rt_cons`/`rt_box`/
  `rt_alloc_words`), `main`/`GC_INIT`, and the `rt_write` printer cannot leave C. Since
  `runtime.c` must exist for those, the leaf primitives ride along at ~zero marginal
  complexity.
- **Self-hosting is unaffected.** The runtime is not the compiler. The compiler's
  *output* already has no Chez dependency, and clang stays in the toolchain either way.
  Rewriting the runtime in `.ll` advances self-hosting by nothing, so the usual "get off
  the host" argument does not apply here.

The one genuine cost is call overhead: every `rt_add`/`rt_lt`/`rt_car` is an un-inlined
cross-translation-unit call (the current `clang` link in `src/compile.ss` passes no `-O`
/ `-flto`), so a hot tail loop pays a call per primitive. See below for how to buy that
back without giving up readable C.

### Deferred: inline the C primitives via bitcode/LTO

When a benchmark shows primitive call overhead matters (**not before** — M1 is
explicitly "no optimization passes"), the fix is *not* to hand-write IR primitives. It is
to let LLVM inline the C ones:

- Compile the runtime to bitcode and link at the IR level (`clang -O2 -emit-llvm -c
  runtime.c`), or mark the leaf primitives `__attribute__((always_inline))` and build
  with `-flto`. Then `opt`/LTO folds `rt_add` down to `shl`/`add`/`ashr` at the call
  site — open-coded primitives, zero call overhead, source stays readable C.

This is strictly better than IR-authored primitives (same codegen, none of the
maintenance cost) and is a pure build-pipeline change, not a codegen change. If a few
primitives ever *do* warrant inline IR, restrict it to the non-allocating tag tests and
fixnum ops (`null?`, `pair?`, `eq?`, `+`, `-`, `<`) — worst work-to-call-overhead ratio —
and treat it explicitly as an optimization, not the default lowering. Tracking: no
OpenSpec change filed yet; open one when acting on this.

### Closures

Closure conversion runs before codegen. A closure is a heap object of
`{ code_ptr, env_slot_0, ..., env_slot_n }`. Calls go indirect through `code_ptr`.
Free variables are captured explicitly into env slots; there are no nested LLVM
functions.

### Calling convention

All Scheme-level functions use a single internal calling convention (not the C
convention), which lets us (a) mark tail calls `musttail` reliably and (b) pin
runtime registers if we later adopt a CPS-with-registers scheme. C-visible entry
points (runtime primitives, FFI) use the C convention and are bridged explicitly.

**Shape.** The original M1 convention shared one prototype
`tailcc i64 (i64 self, i64 a0 … i64 a{K-1})`, `K` = whole-program max arity, calls padded
with `0`. That was fixed-arity only: it could not express dotted rest params, variadic
`lambda`, or `apply` (padding is ambiguous with a real `0`, there is no arg count, and
`apply` over a list longer than `K` is impossible).

**Emitted convention (decided by the calling-convention spike; now implemented in
`emit.ss`).** Every Scheme function shares the widened prototype
`tailcc i64 (i64 self, i64 argc, i64 a0 … i64 a{K-1}, ptr overflow)`:

- `argc` — real argument count. Every callee checks it at entry: fixed-arity requires
  `argc == f`, variadic requires `argc >= f`; a mismatch calls `rt_arity_error` and aborts
  (non-zero exit) instead of miscomputing.
- `a0..a{K-1}` — positional slots (`K` = whole-program max fixed arity, as today).
- `overflow` — pointer to a heap vector of args beyond `K` (or null). A variadic callee
  binds `rest` to `rt_build_rest(argc, fixed, K, slots, overflow)`, which walks arg indices
  `[fixed, argc)` — reading `slots[i]` for `i < K` (the positional slots spilled to a small
  array) and `overflow[i-K]` beyond — building a proper list. `apply` fills the positional
  slots with the leading args and the first list elements, then points `overflow` at the
  remaining flattened args (`rt_apply_argv`), so it is unbounded regardless of `K`.

The convention is now **fully consumed** (as of the variadic/`apply` change). A direct
call passes the true `argc`, the first `K` args in the positional slots, and either
`ptr null` (no excess) or a freshly spilled `overflow` vector when the call supplies more
than `K` args. The **fixed-arity hot path stays allocation-free** — only variadic callees
build a rest list and only over-`K`/`apply` call sites allocate an overflow vector; the
entry arity check is a compare-and-branch on the cold path and the self tail-call passes
the right `argc`, so it never trips. `musttail` is preserved: the rest list is built as
straight-line code at callee entry, before the tail body, and the uniform prototype is
unchanged (verified by `countdown`/`namedloop` at 10M iterations and by a variadic callee
whose body tail-calls under `musttail`).

The spike (`spike/calling-convention/`, real LLVM 22 IR, 100e6 tail iterations) showed
this preserves `musttail`/bounded stack, costs ~0 on the fixed-arity hot path vs. today's
convention (~0.5 ns/call for both), and expresses rest + unbounded `apply`. An
arg-vector-only convention was ~5.4× slower on the hot path and rejected; a hybrid
fast/slow scheme was deemed unnecessary since the overhead is already ~0. Full data and
rationale: `spike/calling-convention/RESULTS.md`.

If/when we go the register-pinning route, the reference is Manticore's "JWA"
convention: fixed argument positions for runtime state (e.g. the allocation pointer
is always argument 0), threading allocator state through SSA values. See references.

### Tail calls

Scheme requires unbounded proper tail calls. In emitted `.ll` we write the
`musttail` marker directly on the call (e.g. `musttail call cc <sig> ...` immediately
followed by the matching `ret`), which forces a guaranteed tail call or a
compile-time error. Constraints codegen must respect:

- The call must be in genuine tail position (immediately followed by `ret`, or a
  bitcast then `ret`).
- Caller and callee calling conventions must match (hence the single internal
  convention above).
- Caller and callee prototypes must match; pointer pointee types may differ but not
  address spaces.
- `musttail` calls may not access caller-provided allocas or varargs.

The decided variadic convention (above) keeps a **single uniform prototype** and passes
overflow args through an explicit `ptr` to a heap vector — **not** LLVM `varargs` and not
a caller alloca — so all of these constraints continue to hold; the spike confirmed
`musttail` at 100e6 iterations under the wider prototype.

`musttail` is guaranteed only where the target supports it — fine on our
x86_64/AArch64 targets; some targets (e.g. WASM without the tail-call extension)
cannot honor it. If phase 2 (FFI) is adopted, the equivalent is
`LLVMSetTailCallKind(call, LLVMTailCallKindMustTail)` (LLVM 18+).

Fallback for hot mutually-tail-recursive cliques: merge into one LLVM function with
internal branches. Avoids per-call overhead but does not handle tail calls to
*unknown* functions, so it is an optimization, not the general mechanism.

### First-class continuations (`call/cc`)

Not in phase 1. When added, the plan is CPS conversion + heap-allocated
continuations: after CPS every continuation is an ordinary closure, `call/cc` grabs
the current one, and there is no native stack to capture. This also simplifies GC
(no stack scanning). The reference implementation of this pattern on LLVM is
Farvardin & Reppy, *Compiling with Continuations and LLVM* (see references) — copy
its control and GC story, not its surface language.

### Garbage collection

- **Phase 1 — Boehm.** Link `libgc`, allocate through it, no IR cooperation. Gets the
  system running and is swappable later. LLVM ships no collector; it only provides
  machinery to describe one, and its docs explicitly target Scheme among other
  collected languages.
- **Phase 2 — precise/relocating via statepoints.** Emit the abstract `gc.statepoint`
  form and let `RewriteStatepointsForGC` lower it to stack maps; do not hand-write
  the explicit relocation form (it inhibits optimization). Hard constraint:
  statepoint lowering is supported **only on x86_64 and AArch64**.
- The CPS route (above) removes stack scanning entirely, a strong argument for
  adopting CPS *before* attempting precise GC.

---

## Backends

One frontend, three exits from the IR. All three should stay working — the
"one frontend, many backends" property is a core project thesis and a regression
test target. **All three are implemented** (`src/compile.ss --backend aot|jit|bitcode`,
default `aot`) and kept honest by `demos/run-backends.sh`, which runs every demo through
all three and asserts byte-identical output.

1. **AOT (default, phase 1).** Emit `.ll` (or `.bc`), then compile and link with
   `clang` against the runtime + GC to produce a native executable. This is what
   `akeep/scheme-to-llvm` does and what the first milestone uses.
2. **JIT (phase 1, `lli`).** Assemble the program to `.bc`, `llvm-link` it with the
   runtime compiled to bitcode (so the C `main` + `rt_*` join the module — `lli` runs the
   *input module's* `main`), and run in-process via `lli` with `libgc` loaded
   (`-load=…/libgc.<so|dylib>`). `musttail` and Boehm GC both work under `lli` (verified by the
   10M-iteration `countdown` and the allocation-heavy demos in the equivalence harness).
   Phase 2: in-process ORC via the C-API FFI backend. ORC is the current LLVM JIT API;
   MCJIT is retired and not a target here.
3. **Bitcode.** Emit `.bc` (`llvm-as`) for `opt`, inspection, or downstream tooling; the
   bitcode backend also codegens it to a native exe (the discovered `clang`) so the harness
   can execute it.

> The JIT/bitcode exits use the **discovered** LLVM tools (via `llvm-config`; overridable
> with `LLVM_CONFIG` / `EMIT_LLVM_BIN`), and load libgc into `lli` with the platform's
> shared-object extension (`.so` / `.dylib`); the AOT exit prefers a system clang on `PATH`.
> Discovery is single-sourced in `tools/llvm-env.sh`. See `src/TOOLCHAIN.md`.

The LLVM Kaleidoscope tutorial maps onto these even though it is C++: chapter 3 (IR
generation), chapter 4 (JIT + optimizer), chapter 8 (object files); the separate
"Building a JIT" sub-tutorial covers ORC layers. The IR-shaping lessons transfer to
text emission directly.

---

## Gotchas

- **Opaque pointers.** Modern LLVM uses opaque `ptr` (no pointee type); typed
  pointers like `i8*` / `i64*` are gone. `akeep/scheme-to-llvm` targets LLVM 10 and
  therefore emits *typed* pointers — do **not** copy its pointer syntax verbatim onto
  our LLVM 22 pin. Emit `ptr` and carry element types yourself where GEP/load/store
  need them.
- **LLVM version churn is a real maintenance cost**, and worse for the FFI backend
  than for text emission. Pin LLVM, and treat an upgrade as a scoped task. Extempore's
  public LLVM 3.8→10 upgrade log (and its MCJIT→ORC migration) is a realistic picture
  of what an FFI-based upgrade involves — an argument for staying on text as long as
  possible.
- **`musttail` is not portable to all targets** (see Tail calls). Guard target
  assumptions.
- **Statepoints are x86_64/AArch64 only.** Don't design phase-2 GC around targets that
  can't lower them.
- **C API and `musttail`:** available from LLVM 18 on. If for some reason an older
  LLVM is pinned, the FFI backend loses guaranteed tail calls and the text route
  becomes mandatory.
- **ORC ≠ MCJIT.** Tutorials/answers referencing MCJIT are stale; use ORC (phase 2).
- **Mature Schemes deliberately avoid LLVM.** Chez itself has its own nanopass-built
  native backend; Guile has its own bytecode VM plus a lightening JIT. The usual
  reasons are compile speed, backend control, and avoiding the LLVM version treadmill.
  Not a reason to abandon LLVM here, but know the tradeoff we accept.

---

## References

### Directly on-point precedent (Chez + nanopass → LLVM)
- Keep, `scheme-to-llvm` (Chez Scheme + nanopass, emits `.ll`, links with clang):
  https://github.com/akeep/scheme-to-llvm

### LLVM core
- How to interface a non-C++ compiler with LLVM (FFI vs. assembly vs. bitcode),
  LLVM FAQ: https://llvm.org/docs/FAQ.html
- Language-frontend tutorial (Kaleidoscope): https://llvm.org/docs/tutorial/
- Garbage Collection framework: https://llvm.org/docs/GarbageCollection.html
- GC statepoints / safepoints: https://llvm.org/docs/Statepoints.html
- `musttail` / tail-call semantics: LLVM Language Reference, `call` instruction
- Tail-call state of play (2025): https://blog.reverberate.org/2025/02/10/tail-call-updates.html

### C API (phase 2)
- `LLVMSetTailCallKind` / `LLVMGetTailCallKind` (added LLVM 18); C bindings in
  `include/llvm-c/Core.h`

### Compiler structure (frontend → core, pass discipline)
- Nanopass framework: https://nanopass.org/
- Nanopass repo: https://github.com/nanopass/nanopass-framework-scheme
- Keep & Dybvig, "A Nanopass Framework for Commercial Compiler Development," ICFP '13

### CPS, continuations, and GC on LLVM
- Farvardin & Reppy, "Compiling with Continuations and LLVM," arXiv:1805.08842:
  https://arxiv.org/abs/1805.08842

### Live precedent (FFI-driven, in-process JIT)
- Extempore (Scheme interpreter + xtlang JITing to LLVM IR via a C/C++ FFI shim, on
  LLVM 22 / ORC): https://github.com/digego/extempore
- Extempore philosophy (why the compiled layer is statically typed):
  https://extemporelang.github.io/docs/overview/philosophy/
