## Context

The emitted ABI is the uniform prototype
`tailcc i64 (i64 self, i64 argc, i64 a0 … i64 a{K-1}, ptr overflow)` (`K` = whole-program
max fixed arity). Today every `lambda` is fixed-arity: `parse` reads a flat param list,
`lower` carries `params` verbatim, `emit-code-def` binds them to `%a0..%a{n-1}`, and every
call passes `argc` = actual count, positional slots padded to `K`, and `overflow` = null.
So `argc`/`overflow` are present but unused. This change consumes them.

## Goals / Non-Goals

**Goals:**
- Dotted rest params `(lambda (a b . rest) …)` and all-args `(lambda args …)`.
- `apply` over arbitrary-length lists (unbounded, via `overflow`).
- Runtime arity checking for fixed-arity procedures.
- Preserve `musttail`/bounded stack and cross-backend equivalence.

**Non-Goals:**
- Optional/keyword arguments, multiple values, `case-lambda`.
- Optimizing the rest-list allocation away for non-escaping rests.
- Changing the fixed-arity hot path (must stay allocation-free, as the spike required).

## Decisions

### D1 — IL: mark fixed arity + rest param

`parse` lowers a variadic lambda to `(lambda (p0 … p{f-1}) #:rest r body)` (or an
equivalent IL field); `lower`'s `code` def records `(fixed-count, rest-name|#f)`. A bare
symbol param list `(lambda args …)` is `fixed-count = 0, rest = args`. `free-vars`/rename
treat the rest name as an ordinary bound variable.

### D2 — Variadic callee prologue (rest construction)

At entry, a variadic callee binds `rest` to a freshly built list of the `argc - f` excess
arguments, in order:

1. the real positional slots `a{f} … a{min(argc,K)-1}` (those with index `< argc`), then
2. the `overflow` vector elements `overflow[0 … argc-K-1]` when `argc > K`.

Built via a runtime helper — e.g. `rt_build_rest(i64 argc, i64 fixed, ptr slots, ptr overflow)`
returning a tagged list — where `slots` points at the positional args spilled to a small
entry array. Fixed-arity callees skip this entirely (hot path unchanged).

**Alternative considered:** build the list with inline IR `rt_cons` chains. Rejected for
the general case — the count is dynamic, so a runtime loop helper is simpler and keeps the
emitted IR small; inline chains would only help a known-small rest.

### D3 — `apply` lowering

`(apply f a1 … aN lst)`: evaluate `f`, `a1…aN`, and `lst`; fill positional slots `a0..`
with `a1..` up to `K`; spill the remaining fixed args and every element of `lst` into a
freshly allocated `overflow` vector; set `argc = N + length(lst)`. A runtime helper
(`rt_spread`/`rt_list_to_overflow`) turns the tail into the overflow vector. `apply` is
thus unbounded regardless of `K`. `apply` in tail position can still be `musttail` (the
call has the uniform prototype).

### D4 — Arity checking

- Fixed-arity callee: at entry, if `argc != f` → `rt_arity_error(expected=f, got=argc)`
  which prints a message and aborts (non-zero exit).
- Variadic callee: if `argc < f` → same error.
The check is a couple of instructions on the cold path; the hot self-call still passes the
right `argc` so it never trips.

### D5 — Overflow vector representation

`overflow` = pointer to a heap block of the `max(argc-K,0)` excess args as raw `i64`
words (length implied by `argc` and `K`), allocated through `libgc`. Only ever non-null
when `argc > K` (variadic calls / `apply` with many args); fixed-arity calls keep passing
`ptr null`, so their codegen and cost are unchanged.

## Risks / Trade-offs

- **`musttail` + rest construction** → rest is built at entry (straight-line, before the
  tail body); the tail call itself is unchanged, so `musttail` holds. Verified by keeping
  `countdown`/`namedloop` green.
- **Allocation on every variadic call** → inherent to rest lists / `apply`; the fixed-arity
  hot path allocates nothing (the property the spike protected). Note the cost; optimize
  only if a benchmark demands it.
- **Change size** → this touches parse, lower, emit, and runtime at once. Mitigation: land
  dotted-rest + variadic callee + arity check first, then `apply` (they share the runtime
  helpers); split the change if it proves large at apply-time.
- **GC of the entry slot-array / overflow vector** → allocate through `libgc`; do not stash
  raw pointers where the collector can't see them. Covered by running the GC-heavy demos
  through all three backends.
- **arity-error abort path under `lli`** → the 3-backend harness includes an arity-error
  demo to confirm the abort behaves identically across AOT/JIT/bitcode.
