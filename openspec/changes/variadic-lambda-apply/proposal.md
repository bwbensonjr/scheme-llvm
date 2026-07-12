## Why

The `argc`+`overflow` calling convention is now the emitted ABI, but it is inert — every
function is fixed-arity, so `argc` is ignored and `overflow` is always null. This change
makes the ABI pay off: dotted rest parameters, fully variadic `lambda`, and `apply` — the
features real Scheme needs and that the compiler's own source (`map`/`for-each`/`apply`)
relies on for self-hosting. It also introduces runtime arity checking (today a mismatch is
silently miscompiled via padding).

## What Changes

- **Frontend** — `parse` accepts variadic parameter lists:
  - dotted rest: `(lambda (a b . rest) …)`
  - all-args rest: `(lambda args …)` (a bare symbol parameter)
  `lower` marks each code block with its fixed arity and whether it is variadic.
- **Codegen** — a variadic callee builds its `rest` list at entry from the excess
  arguments: the real positional slots beyond the fixed count (`argc` says how many are
  real) plus the `overflow` vector. Fixed-arity callees gain an **arity check** on `argc`.
- **`apply`** — `(apply f a1 … aN lst)` fills the positional slots with `a1…` then spills
  the remaining args and the elements of `lst` into an `overflow` vector, setting `argc`
  accordingly, so `apply` is unbounded.
- **Runtime** — helpers to build a rest list (from positional excess + overflow) and to
  spread a list for `apply`, plus an arity-error abort with a message.
- `musttail` is preserved (rest-building happens at callee entry, before the tail body;
  the uniform prototype is unchanged).

## Capabilities

### New Capabilities
<!-- None: extends the existing core language and codegen convention. -->

### Modified Capabilities
- `core-language`: add support for variadic `lambda` / dotted rest parameters, `apply`,
  and runtime arity checking for fixed-arity procedures.
- `aot-codegen`: the "Emit the argc + overflow calling convention" requirement is updated
  so `argc` is consumed and `overflow` is populated (no longer always `ptr null`) for
  variadic calls and `apply`.

## Impact

- **Code:**
  - `src/parse.ss` — parse dotted/rest parameter lists into a lambda IL that records the
    fixed params and the rest param.
  - `src/passes/lower.ss` — thread the fixed-arity / variadic marking into `code` defs and
    `app`/`apply` call sites; `free-vars` handles the rest param as bound.
  - `src/emit.ss` — variadic callee prologue (build `rest` from positional excess +
    overflow), fixed-arity `argc` check, and `apply` call-site lowering (fill slots + spill
    overflow).
  - `src/runtime/runtime.c` — rest-list builder, `apply` list-spread helper, arity-error
    abort.
  - `demos/` — variadic, rest-param, `apply`, and arity-error demos.
- **Verification:** `demos/run-backends.sh` (3-way) plus new variadic/`apply` demos;
  `countdown`/`namedloop` still bounded-stack (musttail intact).
- **Possible split (noted for apply-time):** dotted rest params + variadic callee first,
  then `apply` — they share runtime helpers but `apply` is separable if the change proves
  large.
