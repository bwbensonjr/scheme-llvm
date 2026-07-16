## Context

The Chez `compile.ss` driver caches each compiled library unit as
`build/lib/<base>.ll` + `<base>.exports` and reuses it across builds. Reuse is gated by
`artifacts-fresh?` (`src/compile.ss:395`):

```scheme
(define (artifacts-fresh? src ll expf)
  (and (file-exists? ll) (file-exists? expf)
       (let ([st (file-modification-time src)])
         (and (time<=? st (file-modification-time ll))
              (time<=? st (file-modification-time expf))))))
```

The key is **library-source mtime only**. The compiler is not part of it — the classic Make
footgun (a target is invalidated only by its *listed* prerequisites, and the compiler is not
listed). So a compiler change with unchanged library source reuses stale IR.

This fired for real: `immediate-characters` re-encoded `#t` `9`→`257` in `src/emit.ss`; the
`(scheme base)` source (`src/prelude.scm`) was untouched; `build/lib/scheme.base.ll` (old
emitter, `#t` = `9`) was reused. Verified directly:

| File | `i64 257` (#t) | `i64 9` |
|------|-----|-----|
| `bootstrap/scheme.base.ll` (committed, trust-checked) | 8 | 0 |
| `build/lib/scheme.base.ll` (cached, reused) | 0 | 8 |

Because `9` is also the immediate for `#\nul`, every prelude-level `#t` literal (e.g. the `#t`
in `chr-cmp`, which backs `char<?`/`char=?`/…) surfaced as `#\nul`; runtime-primitive booleans
(`string=?` → `rt_string_eq` → `truthy`) were correct, explaining the selective symptom.
Deleting the cached unit turned 51/2 into 53/0 on the AOT demos.

**Scope facts (verified):**
- `build-modular-artifacts`/`artifacts-fresh?` have **no caller outside `src/compile.ss`**;
  only the Chez driver (`chez --script src/compile.ss …`) consumes this cache.
- In that path the compiler runs as **interpreted source**: `compile.ss` `(include ...)`s
  `match.scm`, `util.scm`, `parse.ss`, `passes/{expand,recognize-let,convert-assignments,
  convert-closures,lower}.ss`, `emit.ss`, `core.ss` (`compile.ss:20-29`). These files are
  therefore present at run time — hashing them *is* the running compiler's identity.
- The self-hosted `scheme-run`/`schemec` binaries emit combined IR and split it with `awk`
  (`bin/scheme-compile`); they do **not** use this unit cache. `bootstrap/*.ll` is guarded by
  the anti-stale trust-check. Both are out of scope.

The chosen direction (from the decision discussion) is a **compiler-identity stamp**, matching
how Rust (`.rlib` SVH), GHC (`.hi` version), Go, and Bazel make the toolchain part of the
cache key.

## Goals / Non-Goals

**Goals:**
- Make artifact freshness depend on compiler identity as well as source freshness, so a
  compiler/emitter change invalidates unchanged-source units automatically.
- Compute identity correctly for the only path that caches (interpreted `compile.ss` under
  Chez): a version marker + content hash of the included compiler sources, read at run time.
- Regenerate the currently-stale `build/lib/*`; verify the previously-failing Chez
  AOT/backend/module/embedded suites pass.
- Keep it simple and transparent (`CLAUDE.md`): a readable stamp, narrated rebuild reasons.

**Non-Goals:**
- Baking a stamp into the self-hosted binaries — they do not cache library units.
- Changing `bootstrap/*.ll` handling (trust-check already guards it).
- Switching the source-freshness check away from mtime (kept as-is; the stamp is *added*).
- Fixing anything in `src/emit.ss` — the emitter is correct; this is a cache-key bug.
- Precompiled `.bc`/`.o` prelude units (backlog **P3**), though this shares that cache path.

## Decisions

### D1 — Identity = version marker + content hash of the compiler sources

The stamp is a small S-expression, e.g. `(emit-artifact-stamp 1 <hex-digest>)`, where:
- `1` is a hand-bumped **format/version** integer (lets us force global invalidation
  deliberately, e.g. if the stamp scheme itself changes — the GHC/Rust "version" role).
- `<hex-digest>` is a content hash over the concatenated bytes of the compiler sources that
  determine emitted IR: the `compile.ss` include list (`match.scm`, `util.scm`, `parse.ss`,
  `passes/*.ss`, `emit.ss`, `core.ss`) **plus `compile.ss` itself**, hashed in a fixed order.

**Rationale.** These files are exactly what turns library source → IR in the caching path, and
they are on disk at run time (interpreted). Hashing content (not mtime) is immune to `touch`,
`git checkout`, and clock skew — the failure modes mtime already has for sources. A version
marker on top is the cheap coarse gate the mature implementations all keep.

**Alternative — mtime of compiler sources.** Extend `artifacts-fresh?` to also require the
artifact be newer than each compiler source file. Fewer lines, matches the current idiom, but
re-inherits every mtime fragility (a `checkout` that back-dates `emit.ss` would wrongly keep a
stale artifact fresh) precisely where correctness just bit us. Rejected as the primary; the
content hash costs one read+digest of a handful of files per build, which is negligible.

**Alternative — full input hash à la Bazel/Nix** (hash library source bytes + compiler +
flags, drop mtime entirely). Most precise, but the biggest departure from the existing design
for a single-target compiler with one prelude. Rejected as over-built; the version+source-hash
stamp captures the compiler dimension that was actually missing.

### D2 — Hashing primitive

Prefer a hash already available in the Chez driver environment. Options, in order of
preference: (a) a Chez library digest if one is readily importable; (b) a small, dependency-free
in-language hash (e.g. FNV-1a / djb2 over the source bytes) defined in the driver. A
non-cryptographic 64-bit hash is sufficient — this guards against *accidental* staleness, not
adversarial collisions — and keeps "no new dependencies." Decide (a) vs (b) at implementation
time based on what Chez exposes cleanly; default to (b) for self-containment.

### D3 — Record the stamp in a dedicated `.stamp` sidecar

Write `build/lib/<base>.stamp` next to `<base>.ll`/`<base>.exports`, containing the stamp
S-expression. `artifacts-fresh?` reads it back (via the existing `read-program`) and compares
to the freshly computed current stamp.

**Rationale.** The `.exports` file is consumed as a datum (`(car (read-program expf))` →
export table); prepending a stamp line would entangle the stamp with the export-table format
and every reader of it. A separate sidecar is non-invasive and self-describing. A missing
`.stamp` (older artifacts from before this change) reads as "no stamp" ≠ current ⇒ stale ⇒
rebuild, which is the safe default and also performs the one-time remediation for free.

### D4 — Fold the stamp check into `artifacts-fresh?`; narrate the reason

`artifacts-fresh?` becomes: files exist ∧ source not newer than artifacts ∧ recorded stamp ==
current stamp. Compute the current stamp **once per build** (not per unit) and thread it in.
The reuse/compile narration (`compile.ss:449/460`) distinguishes `[fresh]` from a rebuild
caused by a stamp mismatch vs. a source change, so a compiler change visibly recompiles units
(`docs/OUTPUT.md`).

## Risks / Trade-offs

- **Hashing the wrong file set** (miss a file that affects emitted IR ⇒ a real compiler change
  not caught) → derive the list directly from `compile.ss`'s `(include ...)` set plus
  `compile.ss`; add a test that mutating any listed file changes the stamp, and a comment
  tying the list to the include block so they stay in sync.
- **Over-invalidation** (any whitespace edit to a compiler source rebuilds all units) →
  acceptable and correct: units are cheap to rebuild and correctness dominates; this is the
  intended behavior, not a regression.
- **`.stamp` drift vs `.ll`/`.exports`** (a crash between writes) → write the `.stamp` last,
  after `.ll` and `.exports`; a missing/mismatched stamp forces rebuild, so a torn write fails
  safe toward recompilation.
- **Self-hosted binary path** wrongly assumed to need a baked-in stamp → it does not cache
  library units (verified: no caller of `build-modular-artifacts` there), so it is untouched.
- **Non-crypto hash collision** → astronomically unlikely for accidental edits and the version
  marker gives a manual override; not a security boundary.

## Migration Plan

1. Add the stamp helper (version + content hash over the compiler-source list) to `compile.ss`.
2. Write `<base>.stamp` in `build-modular-artifacts` after the `.ll`/`.exports` writes.
3. Extend `artifacts-fresh?` to compare the recorded stamp to the current stamp; narrate the
   rebuild reason.
4. Delete/allow-regeneration of existing `build/lib/*` (they lack a stamp ⇒ auto-rebuilt).
5. Verify: `RUNNER=aot demos/run-tests.sh`, `demos/run-backends.sh`, module-slice, and
   embedded-runner suites pass; the anti-stale trust-check and self-hosting fixed point still
   pass; touching `src/emit.ss` alone now forces a `build/lib` rebuild.

Rollback: revert the `compile.ss` change and delete the `.stamp` files; behavior returns to
mtime-only (with the known bug). No persisted format depends on the stamp beyond the sidecars.

## Open Questions

- D2: use a Chez-provided digest vs. an in-language hash — settle at implementation time by
  what Chez exposes without adding a dependency (default: in-language FNV-1a/djb2).
  **Resolved:** in-language 64-bit FNV-1a over the source bytes (no dependency added).
- Whether the host target header (`host-target-header`) should feed the stamp too — it can
  affect emitted IR. Likely yes for completeness; low cost to include. Confirm during
  implementation. **Resolved: yes** — the header is prepended to every `.ll`, so it determines
  emitted IR; it is folded into the digest after the compiler sources.

## Outcome (verified)

- **Root cause was cache invalidation, not the emitter.** `src/emit.ss` was already correct
  (`#t` = `257`); the defect was that `artifacts-fresh?` keyed only on library-source mtime and
  omitted the compiler, so the pre-`immediate-characters` `build/lib/scheme.base.ll` (`#t` = `9`,
  which aliases `#\nul`) was reused. No emitter change was needed or made.
- Adding the compiler-identity stamp forced the one-time regeneration automatically (units
  lacked a `.stamp` ⇒ treated as compiler-changed): the regenerated `scheme.base.ll` carries
  `#t` = `i64 257` (×8, matching `bootstrap/scheme.base.ll`), and `(char<? #\a #\b)` now returns
  `#t` instead of `#\nul`.
- Full verification: `RUNNER=aot demos/run-tests.sh` 53/0 (was 51/2), `demos/run-backends.sh`
  43/0 (aot=jit=bitcode), `demos/run-embedded.sh` 53/0, `./run-all-tests.sh` 6/6 suites,
  `./run-dev-tests.sh` 17/17 suites (incl. self-hosting fixed point, REPL-vs-batch, anti-stale
  trust-check). Direct invalidation check: editing `src/emit.ss` triggers
  `recompile: compiler changed`; a no-op rerun reports `[fresh]`; reverting restores the identical
  digest (content-based, deterministic).
