## Why

The gap sweep ([[self-host-gap-sweep]]) found gap **G8** (which subsumes the earlier **G4**):
primitives are reserved keywords, not first-class values, so passing one to a higher-order
procedure leaves a bare, unbound reference. The core does this pervasively — `(map car binds)`,
`(map cons xs new)`, and, throughout `emit.ss`, `(apply string-append <list>)`. A bare `car` /
`cons` / `string-append` in operand position is compiled as an unbound variable, so the
assembled core will not compile until these prims are available as values.

## What Changes

The fix lives in the **compiler**, not the prelude. (A prelude `(define (car x) (car x))` would
be a fast primcall under scheme-llvm but *infinite self-recursion under the bootstrap host*,
which loads the prelude directly — `test/read-all-tests.ss`; the prelude must stay
common-subset code that runs under both hosts.)

- **Auto-eta-expand a primitive that appears in value position.** When the parser meets a
  primitive name as a value (not as a call head), it rewrites it to a lambda that calls the
  primitive: `car` → `(lambda (p1) (car p1))`, `cons` → `(lambda (p1 p2) (cons p1 p2))`. A call
  in operator position is still a primcall (the prim check is head-only), so direct calls are
  byte-for-byte unchanged.
- **`string-append` (variadic).** Value position eta-expands to `(lambda gs (%str-concat gs))`,
  where `%str-concat` is a common-subset prelude helper folding the 2-arg `string-append` (native
  under the host, the binary primcall under scheme-llvm). Direct N-ary calls
  `(string-append a b c …)` are folded to nested binary primcalls in the **expander** (mirroring
  the existing `+`/`-`/`*` handling), since the runtime op is binary. This closes G4 and the
  direct-N-ary case for any arity (`()` → `""`).
- Only `car`, `cons`, and `string-append` are used as values by the current core (the sweep's
  free-variable analysis found no others); the eta table is a one-line-per-prim extension point.

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `core-language`: primitives may be used as first-class values — passing one to a higher-order
  procedure (`map`/`apply`/fold) yields a procedure with the primitive's behavior, while a direct
  call still compiles to the primitive. `string-append` accepts any number of arguments (direct
  or via `apply`), zero args yielding `""`.

## Impact

- **Code**: `src/parse.ss` (eta-expand a prim in value position), `src/passes/expand.ss` (N-ary
  `string-append` fold), `src/prelude.scm` (the common-subset `%str-concat` helper). No runtime
  change.
- **Depends on**: variadic-lambda/`apply` support (already present). Unblocks
  [[self-hosting-bootstrap]] (the `(map car …)` / `(apply string-append …)` sites) and supersedes
  the standalone G4 item.
- **Invariant preserved**: the prelude still loads and runs directly under the bootstrap host
  (`%str-concat` uses only 2-arg `string-append`); no primitive-in-value trickery leaks into it.
