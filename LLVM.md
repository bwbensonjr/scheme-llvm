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

```sh
# Chez Scheme + nanopass on the library path (see nanopass README for --libdirs).
# LLVM/clang toolchain matching the pinned major version:
sudo apt-get install clang-22 llvm-22        # or your distro's LLVM 22 packages
# Conservative GC for phase 1:
sudo apt-get install libgc-dev
# Phase 2 only: the libLLVM shared library for FFI (bundled with the llvm-22 package).
```

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
test target.

1. **AOT (default, phase 1).** Emit `.ll` (or `.bc`), then compile and link with
   `clang` against the runtime + GC to produce a native executable. This is what
   `akeep/scheme-to-llvm` does and what the first milestone uses.
2. **JIT.** Phase 1 pragmatic option: run emitted IR with `lli`, or re-invoke the
   toolchain per form (clunky, fine for early bring-up). Phase 2: in-process ORC via
   the C-API FFI backend. ORC is the current LLVM JIT API; MCJIT is retired and not a
   target here.
3. **Bitcode.** Emit `.bc` for `opt`, inspection, or downstream tooling.

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
