# Performance & Size Backlog

Known performance, memory, and binary-size debt — each item **deferred by design**, not
overlooked. This is the working list the OpenSpec process chips away at: every entry names
its symptom, its cause (with file references), a possible fix, its OpenSpec change (once one
exists), and a check-off when remediation lands.

Binary size/cleanliness is a first-class design concern here (see `CLAUDE.md` — "small,
clean, self-contained native executables" is a defining niche), so size items sit alongside
speed items in this list.

## Status at a glance

| ID | Item | Kind | Value | Cost | OpenSpec change | Done |
|----|------|------|-------|------|-----------------|------|
| [P1](#p1-dead-code-elimination-for-library-units) | Dead-code elimination for library units | size | high | med | — | ☐ |
| [P2](#p2-immediate-non-heap-characters) | Immediate (non-heap) characters | speed + cleanup | med | med | `immediate-characters` | ☑ |
| [P3](#p3-precompiled-prelude--library-objects) | Precompiled prelude / library objects | build speed | low | low | — | ☐ |
| [P4](#p4-on-codepoint-string-indexing) | O(n) codepoint string indexing | speed | low–med | med–high | `codepoint-string-indexing` | ☑ |

Legend — **Value**: benefit if fixed. **Cost**: rough implementation effort/risk. These are
estimates to aid sequencing, not commitments.

**Suggested sequencing:** P2 first (self-contained; deletes code as well as speeding things
up), then P1 (serves the flagship size goal, but carries a design decision — see its note),
with P3 folding into P1's link rework. P4 waits for a workload that actually random-indexes
strings; it is the highest cost and lowest present value.

---

## P1 — Dead-code elimination for library units

**Status:** ☐ not started

**Symptom.** Every AOT binary links the *entire* `(scheme base)` unit — all 196 defined
functions (`bootstrap/scheme.base.ll`) — even a program that calls only `car`. The same is
true for any user library: the whole unit ships whether or not the program references it.
This works directly against the "small, clean, self-contained executables" design goal.

**Cause.**
- The emitter gives every `scheme.base:*` (and every user-library) function **external
  linkage** (`src/emit.ss` — contrast `__apply0` at `src/emit.ss:324`, which the emitter
  *does* mark `internal`). External symbols are globally visible, so the linker must assume
  something outside the module might reference them and cannot drop them.
- The AOT link (`link-modular-aot`, `src/compile.ss:468`) passes no
  `-flto` / `-dead_strip` / `--gc-sections` / `opt -internalize -globaldce`. Nothing prunes
  the graph even if linkage allowed it.

Result: DCE is not merely absent — the linkage choice actively **blocks** the linker from
doing it.

**Possible fix.** LLVM-native and already half-scaffolded:
1. Mark library functions `internal` (the emitter already knows how — see `__apply0`), or
   emit them `external` and internalize at link with a keep-list = program entry + `rt_*`.
2. Run `opt -internalize -globaldce` on the already-merged module. The JIT and bitcode
   backends *already* `llvm-link` the unit set into one module (`src/compile.ss` JIT/bitcode
   paths), so the merge point where globaldce is cheap already exists; AOT would need the
   same merge (or `-flto`).

**Design decision to settle first — DCE vs. dev→ship fidelity.** In the REPL you cannot
strip "unused" prelude functions, because you do not know what the user will type next. So
DCE must be an **AOT ship-time-only transform**, not part of the shared compiler core. That
is consistent with the size-is-a-shipping-concern framing, but it means the "one compiler
core" rule (`CLAUDE.md`) needs an explicit, documented carve-out: identical IR on every
door, plus a link-time pruning pass only on the `--backend aot` path. Decide and record this
in the change's design before implementing.

**OpenSpec change:** _none yet._

---

## P2 — Immediate (non-heap) characters

**Status:** ☑ done (change: `immediate-characters`)

**Symptom.** Every character is a heap allocation. `string-ref`, the reader, and
`integer->char` all call `rt_make_char`, which allocates a 2-word object (or interns) per
character. Two permanent, `GC_MALLOC_UNCOLLECTABLE` intern tables sit resident for the whole
process just to make `eq?`/`eqv?` hold on characters.

**Cause.** All 8 primary tags are spent (`src/runtime/runtime.c:37-50`), so characters were
placed under the extended-heap tag (`TAG_EXT`, tag 7) as `{ HDR_CHAR, codepoint }`
(`src/runtime/runtime.c:230`). To preserve `eq?`/`eqv?` by identity, chars are interned via a
Latin-1 array (`char_latin1[256]`) plus a growable linear-scan astral table
(`src/runtime/runtime.c:240-278`) — ~40 lines of machinery whose only job is to fake the
identity that an immediate representation would give for free.

**Possible fix.** Encode the codepoint directly in the tagged word (no heap, no intern
tables). Since the primary tags are full, this needs a **secondary immediate encoding**
carved from the boolean/nil tag space (tag `001`/`010` use only a handful of their 2^61
payload values). One shape:

```
  [ payload : 56 | subtype : 5 | 001 ]
    subtype 0 → boolean (#f / #t)
    subtype 1 → char    (payload = Unicode codepoint)
    subtype 2 → eof-object       ┐ room to grow — future
    subtype 3 → unspecified      ┘ immediates cost nothing
```

Done this way it also future-proofs the immediate space for `eof-object`, the unspecified
value, and similar singletons.

**Cost / risk.** The tag scheme is "shared verbatim with the LLVM IR emitter", so three
places must agree: `src/runtime/runtime.c` (tag/predicate/`make_char`/`eq` logic),
`src/emit.ss` (inline tag checks + char-literal emission), and the value printer. Bounded and
highly testable; deletes the intern machinery on the way through (cleanup + speed together).

**OpenSpec change:** `immediate-characters` (implemented). The boolean tag `001` became a
misc-immediate family with a 5-bit subtype: subtype 0 = boolean (`#f`=1, `#t`=257), subtype 1
= character (codepoint in bits 8+), subtypes 2/3 reserved for `eof-object`/unspecified. The
Latin-1 + astral intern tables and the `HDR_CHAR` heap layout were removed; character
literals now emit an inline immediate constant instead of an `rt_make_char` call.

---

## P3 — Precompiled prelude / library objects

**Status:** ☐ not started (mostly done — remaining scope is narrow)

**Note — the README's "separate/precompiled prelude" bullet is partly stale.** `(scheme
base)` (and every user library) **already** compiles to a *separate, cached* `.ll` unit with
freshness-based reuse: `build-modular-artifacts` builds each unit once and
`artifacts-fresh?` reuses it when the source has not changed
(`src/compile.ss:391-461`). So "separate prelude" is done.

Freshness now also keys on **compiler identity** (change: `artifact-compiler-stamp`): each unit
carries a `.stamp` sidecar (version + content hash of the compiler sources + host target
header), and a stamp mismatch forces recompilation. Any future precompiled `.bc`/`.o` prelude
units must key on the same stamp so a compiler change never links a stale precompiled unit.

**Symptom (remaining).** Each build still re-assembles the unit `.ll` (text LLVM IR) to
bitcode/object at link time; there is no committed precompiled `.bc`/`.o` for the stable
`(scheme base)`. Minor build-time cost, repeated on every link.

**Possible fix.** Precompile stable library units to `.bc`/`.o` and link the object rather
than re-assembling the `.ll`. This composes with **P1**: the natural place to internalize +
`globaldce` is over the merged module, so this item is best folded into P1's link rework
rather than pursued alone.

**OpenSpec change:** _none yet._

---

## P4 — O(n) codepoint string indexing

**Status:** ☑ done (change: `codepoint-string-indexing`)

**Symptom.** `string-ref` at index _i_ costs O(_i_): a loop nested over `string-ref` is
O(n²). This is inherent to the current storage decision (design D1: UTF-8 bytes,
codepoint-indexed API).

**Cause.** `utf8_offset` walks from byte 0 counting codepoints to reach the requested index
(`src/runtime/runtime.c:321`), used by `rt_string_ref` (`:338`) and `substring` (`:344`).

**Mitigating context.** Sequential iteration (a cursor advancing one codepoint at a time) is
already O(1) per step — only *random* indexing in a loop is pathological, which is rare in
practice. The compiler's own reader/parser iterate sequentially. So the present value of
fixing this is low until a workload appears that random-indexes large strings.

**Possible fixes** (a representation/design decision — revisits D1):
- Leave storage as-is; document and prefer the O(1) forward-iteration idiom.
- Add a codepoint→byte breadcrumb/index cache on large strings (amortize repeated indexing).
- Switch to a fixed-width representation (e.g. Latin-1/UTF-32 hybrid à la CPython/Racket) —
  O(1) index at a memory cost; touches `string-set!`, `substring`, `equal?`, and storage.

**OpenSpec change:** `codepoint-string-indexing` (implemented). Chose the middle path — kept
UTF-8 storage and added, to the string header, a stored codepoint length plus a lazily-built
fixed-stride (32) codepoint→byte breadcrumb index. `string-length` is now O(1); an all-ASCII
string (byte length == codepoint length) indexes in O(1) since codepoint index == byte offset;
a multi-byte string builds the breadcrumb on first random access, turning an indexed traversal
from O(n²) into O(n). `string-set!` drops the stale index. The change is confined to
`src/runtime/runtime.c` — the emitter still lowers a literal to one `rt_make_string(ptr, i64)`
call, so no IR or committed bootstrap regeneration was needed (self-hosting fixed point holds).
The fixed-width rewrite was rejected as too heavy for a rare-in-practice case, against the
small-clean-binary goal.

---

## Maintaining this file

- When an OpenSpec change is proposed for an item, fill its **OpenSpec change** line and the
  status-table cell with the change name.
- When remediation lands and the change is archived, tick the ☐ → ☑ in both the item heading
  and the status table, and add a one-line note pointing at the archived change.
- New performance/size debt discovered during development goes here first (with cause + fix
  sketch), so the backlog stays the single source of truth the README points to.
