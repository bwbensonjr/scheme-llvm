## Why

The modular-build artifact cache reuses a library's compiled `.ll`/`.exports` whenever they
are newer than the **library source** (`artifacts-fresh?`, `src/compile.ss:395`). It never
considers the **compiler** that produced them. So when the compiler changes but a library's
source does not, the stale artifact is silently reused.

This is not hypothetical — it is a live, shipped bug. The `immediate-characters` change
re-encoded `#t` from `9` to `257` in the emitter (`src/emit.ss`) without touching
`src/prelude.scm`, so the cached `build/lib/scheme.base.ll` — compiled by the old emitter —
was never regenerated. Every prelude-level `#t` literal (e.g. the `#t` returned by `chr-cmp`,
which backs `char<?`/`char=?`/…) is still emitted as `9`, which is also the immediate encoding
of `#\nul`. The result: in the **Chez `compile.ss` driver** path (`RUNNER=aot`,
`demos/run-backends.sh`, module + embedded-runner suites), `(char<? #\a #\b)` returns `#\nul`
instead of `#t`. Runtime-primitive booleans (e.g. `string=?` → `rt_string_eq`) are unaffected,
which is exactly why the failure looked selective. Deleting `build/lib/scheme.base.ll` makes
all 53 AOT demos pass — confirming the artifact, not the emitter, is stale.

The `bootstrap/*.ll` committed IR is correct (`#t` = `257`) and is separately guarded by the
anti-stale trust-check, so the shipped `scheme-run`/`schemec` binaries are fine; only the
`build/lib` cache used by the Chez driver is affected. But the underlying defect — a cache key
that omits the compiler — will re-fire on every future emitter change. The fix is to make
compiler identity part of artifact freshness, per the standard practice of Rust (`.rlib` SVH),
GHC (`.hi` version), Go, and Bazel: the toolchain is an input to the cache key.

## What Changes

- **Compute a compiler-identity stamp**: a version string plus a content hash over the
  compiler sources that determine emitted IR — the files `src/compile.ss` `(include ...)`s
  (`match.scm`, `util.scm`, `parse.ss`, the `passes/*.ss`, `emit.ss`, `core.ss`) plus
  `compile.ss` itself. In the affected path the compiler runs as interpreted source under
  Chez, so these files are present at run time and hashing them is the exact, always-available
  identity.
- **Record the stamp** in a sidecar written next to each unit's `.ll`/`.exports` at compile
  time (a new `.stamp`, or a stamp line prepended to `.exports` — decided in design).
- **Extend `artifacts-fresh?`** (`src/compile.ss:395`) so an artifact is fresh only when it
  exists, is not older than the library source (unchanged), **and** its recorded stamp equals
  the current compiler's stamp. A stamp mismatch forces recompilation.
- **Narrate the reason**: the `reuse`/`compile` note (`src/compile.ss:449/460`) reports when a
  rebuild is triggered by a stamp mismatch vs. a source change, per `docs/OUTPUT.md`.
- **One-time remediation**: regenerate the currently-stale `build/lib/*` artifacts (the fix
  makes the next build do this automatically; the change verifies the previously-failing Chez
  AOT/backend/module/embedded suites go green).

No language-visible behavior changes; this corrects a build-cache correctness bug. Not marked
BREAKING (artifacts are regenerated build outputs, not a public interface).

## Capabilities

### New Capabilities
<!-- none; this change modifies existing build-driver behavior only -->

### Modified Capabilities
- `module-system`: the "Stale-artifact rebuild" requirement is strengthened — artifact
  freshness depends on **both** the library source being unchanged **and** the compiler
  identity being unchanged, so a compiler/emitter change invalidates cached units even when
  their source is untouched.

## Impact

- **Code**: `src/compile.ss` — a new compiler-stamp helper (version + content hash of the
  included compiler sources), the sidecar write in `build-modular-artifacts`
  (`:439-461`), and the `artifacts-fresh?` predicate (`:395`) gaining the stamp comparison;
  the reuse/compile narration lines.
- **Artifacts**: each `build/lib/<unit>.{ll,exports}` gains an associated stamp; existing
  stale artifacts are regenerated on the next build.
- **Scope**: only the Chez `compile.ss` driver path consumes this cache (`build-modular-artifacts`
  has no other caller); the self-hosted `scheme-run`/`schemec` binaries do not cache library
  units, and `bootstrap/*.ll` remains guarded by the trust-check — both out of scope.
- **Docs**: `docs/PERFORMANCE.md` note if relevant (P3 precompiled-prelude item touches the
  same caching path); `docs/MODULES.md` if it documents artifact reuse.
- **No new dependencies** (the hash uses in-language/Chez-available primitives).
