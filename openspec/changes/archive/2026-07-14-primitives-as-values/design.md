## Context

In the M1 subset, primitive names are reserved keywords: `parse-expr` checks `(prim? op)`
*before* the general application case, so `(car x)` always lowers to `(primcall car x)`. There
is no value binding named `car`, so a bare `car` in operand position (e.g. `(map car binds)`)
parses as a symbol reference and fails in `lower` as an unbound variable. `string-append` has
the additional problem that the primitive is strictly binary, so both `(apply string-append lst)`
and the direct N-ary calls throughout `emit.ss` (`(string-append a b c …)`) are ill-defined
against a 2-arg op — this is the earlier G4.

## Goals / Non-Goals

**Goals:** make `car`, `cons`, and `string-append` usable as first-class values, and
`string-append` work for any arity (direct or via `apply`), without slowing direct calls and
without breaking the prelude's cross-host invariant.

**Non-Goals:** a general "every primitive is also a procedure" surface — the sweep found exactly
these three used as values; the eta table extends one line at a time. Also out of scope:
multi-argument `map` (the core's `(map cons names new)` is 2-list `map`, a *separate* runtime
gap the compile-only sweep did not model).

## Decisions

### D1: The fix belongs in the compiler, not the prelude

The obvious prelude approach — `(define (car x) (car x))`, a primcall body under scheme-llvm —
is **infinite self-recursion under the bootstrap host**, which loads `src/prelude.scm` directly
(`test/read-all-tests.ss`, by design: the prelude is common-subset code that must run under both
hosts). So value-position handling is done in the front end instead, leaving the prelude pure.

### D2: Eta-expand a primitive in value position (parser)

`parse-expr`'s symbol case: when the symbol is a primitive, rewrite it to a lambda that calls the
primitive, then parse that lambda. Fixed-arity prims use an arity table
(`*prim-eta-arity*`: `car` 1, `cdr` 1, `cons` 2) → `(lambda (p1 … pn) (op p1 … pn))`. The lambda
body's `op` is in operator position, so it lowers to a primcall — no recursion, no overhead
beyond the wrapper closure, and only value-position references reach this path (the prim check is
head-only, so direct calls are byte-identical). An unrecognized prim in value position is a clear
error rather than a silent unbound.

### D3: `string-append` — expander fold for direct calls, `%str-concat` for value position

The runtime `string-append` is binary. Direct N-ary calls are folded to nested binary primcalls
in the expander (`expand-string-append`, reusing `fold-arith`, exactly as `+`/`-`/`*`): `()` →
`""`, one arg → that arg, N → left fold. Value position eta-expands to `(lambda gs (%str-concat
gs))`, where `%str-concat` is a common-subset prelude helper that folds 2-arg `string-append`
(native under the host, the binary primcall under scheme-llvm). So `(apply string-append lst)`
applies the variadic lambda to `lst`, collecting into `gs` and folding — well-defined for any
arity. The prelude stays host-loadable because `%str-concat` uses only 2-arg `string-append`.

## Risks / Trade-offs

- **Prelude cross-host invariant** → preserved: no primitive-in-value trickery in the prelude;
  `%str-concat` is ordinary 2-arg-`string-append` code. Verified by re-running the Chez-hosted
  `read-all` reader suite (which `(load)`s the prelude).
- **IR drift on direct calls** → none: eta only fires in value position, and the N-ary fold
  reproduces `(string-append a b)` unchanged for two operands. Verified byte-identical.
- **Adjacent gap surfaced** → the compile-only sweep did not catch that the core uses 2-list
  `map` (`(map cons names new)`); that is a separate runtime gap, logged for the backlog, not
  fixed here.
