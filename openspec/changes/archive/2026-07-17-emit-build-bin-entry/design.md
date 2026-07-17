## Context

`run-door-user-libraries` completed the Chez-free doors: `scheme-run` resolves user
libraries through the manifest in-process, and `bin/scheme-compile` (the Chez-free
AOT door: `scheme-run --emit` + clang `-O2`) builds and links importing programs
without Chez. This change supplies the *project* half — a manifest that names the
program to build, and a `emit build` command that delivers it as a standalone
executable, **staying Chez-free end-to-end** per the design goal that standalone
executables and the Chez-free path are first-class.

Current state:

- **Two manifest parsers.** The Chez driver `src/compile.ss` has `read-manifest`
  (line ~326), which `map`s *every* top-level form as a `(library …)` entry. The
  embedded compiler `src/repl-core.ss` has `repl-manifest-paths` (mode 5) and
  `repl-manifest-user-paths` (mode 9), which likewise extract `(source …)` from
  *every* entry. Neither guards on the entry keyword — so both would mis-read a
  `(program …)` entry as a library.
- **Chez-free mode channel.** `src/run.cpp` (compiled into `build/scheme-run` with
  `bootstrap/embed-repl.ll`, which is assembled from `repl-core.ss`) sets a mode +
  input buffer via `rt_repl_set(mode, bytes, len)`, calls `scheme_entry()`, and
  reads the result with `scm_str(...)`. Modes 5/9 already return newline-joined
  paths this way. Adding a mode reuses this exact channel.
- **Regen.** The committed embedded IR is authoritative; a `repl-core.ss` edit is
  picked up by `make regen` (Chez-free: the existing `scheme-run` recompiles the
  sources to a byte-stable fixed point) followed by a relink. Regen only *compiles*
  the new source — it never invokes the new mode — so there is no bootstrap
  chicken-and-egg.
- **Build+link.** `bin/scheme-compile SRC -o OUT` links full library units (no
  tree-shaking); user-library imports in `SRC` resolve against `EMIT_MANIFEST` /
  default `emit-libs.scm` via `scheme-run --emit`.

User decisions for this slice: manifest program entries use `(program NAME …)`;
`emit build` delivers via the **Chez-free** door (`bin/scheme-compile`, no
tree-shaking); the program-entry **resolver is Chez-free**, added to the embedded
compiler and driven by a `scheme-run --resolve-program` flag.

## Goals / Non-Goals

**Goals:**

- A `(program NAME (source S) [(output O)])` manifest entry that coexists with
  library entries and is ignored by library resolution in **both** parsers.
- A Chez-free resolver: `scheme-run --resolve-program NAME [--manifest FILE]` prints
  the resolved source and output for the named program (or errors).
- An additive `emit` binary (`bin/emit`) exposing `emit build [NAME]`, delivering a
  standalone executable via `bin/scheme-compile` — Chez-free end-to-end.
- Narration per `docs/OUTPUT.md`; committed IR regenerated and byte-stable.

**Non-Goals:**

- No renaming/removal/deprecation of `scheme-compile`, `scheme-run`, `repl-host`, or
  `bin/scheme-compile` (slice #1's CLI-naming/back-compat decision).
- No `emit lib` / `emit run` / `emit repl` verbs — only `build`.
- **No tree-shaking on the Chez-free door.** Full units are linked, matching
  `bin/scheme-compile` today. Porting the closed-world strip to the Chez-free path
  is deferred.
- No dependency model: no registry, version constraints, or lockfile.

## Decisions

### D1: Manifest program entry — `(program NAME (source S) [(output O)])`

`NAME` is a bare symbol (not a library-style list), making program entries
syntactically distinct from `(library (…) …)` whose name is a list. Both manifest
parsers dispatch on the head keyword of each entry.

- **Why `program` over `bin`**: reads naturally against `library`; `bin` is a cargo
  term we can still adopt at the `emit` verb level later without committing the
  manifest vocabulary now.
- **Alternative rejected**: a top-level `(package …)` block — larger schema surface,
  over-scoped for the first packaging slice.

### D2: Both parsers ignore non-`library` entries during library resolution

`read-manifest` (`compile.ss`) and `repl-manifest-paths` / `repl-manifest-user-paths`
(`repl-core.ss`) add a guard so they process only entries whose head is `library`.
This is the spec's "library resolution is unchanged by program entries," and it is
required for correctness: without it, a program entry's `(source …)` would be loaded
as a spurious library unit. The two parsers are edited in lockstep to stay
consistent (module-system spec applies to every door).

### D3: Chez-free resolver as an embedded-compiler mode + host flag

Add a new dispatch mode (next free integer, 10) to `repl-core.ss`:
`repl-manifest-program`. Its input buffer is the program `NAME` on the first line
followed by the manifest text (a single buffer, matching the one-buffer
`rt_repl_set` channel); it parses the manifest, finds the `(program NAME …)` entry,
and returns `source` and `output` (newline-joined; empty output line when the
`(output O)` clause is absent). An unknown name, or an omitted name that is
ambiguous (zero or >1 program entries), returns an error marker the host surfaces.

`src/run.cpp` gains `--resolve-program NAME`: it reads the manifest (same resolution
order — `--manifest` > `EMIT_MANIFEST` > `emit-libs.scm`), sets mode 10 with
`"NAME\n" + manifest-text`, calls `scheme_entry()`, prints `scm_str(...)` to stdout,
and returns without JIT/run. This reuses the proven Chez-free manifest machinery and
keeps the manifest grammar single-sourced in the compiler.

- **Alternative rejected (bash/awk parser)**: a second, fragile manifest parser
  outside the compiler — fails on comments/strings/nesting, departs from
  single-source-of-truth.
- **Alternative rejected (Chez resolver)**: reusing `compile.ss` needs Chez, so
  `emit build` would not be Chez-free end-to-end — undercutting the chosen door.

### D4: `emit` is a thin additive bash wrapper, `build` verb only

`bin/emit` mirrors `bin/scheme-compile`'s shape (discover toolchain via
`tools/llvm-env.sh`, ensure `scheme-run` exists). `emit build [NAME]`:

1. Resolve the manifest path (`--manifest` / `EMIT_MANIFEST` / default).
2. `scheme-run --resolve-program "$NAME" --manifest "$MAN"` → `source`, `output`.
3. Default `output` from `NAME` (under `build/`) when the resolver returns none.
4. `EMIT_MANIFEST="$MAN" bin/scheme-compile "$source" -o "$output"` — so the
   program's own library imports resolve against the same manifest.
5. Narrate program name, resolved source, delivered exe path + size (stderr,
   `EMIT_VERBOSITY`-controlled).

Any verb other than `build` prints a usage error listing only `build`. No existing
binary is renamed; `emit` is purely additive. Because step 4 *is* `bin/scheme-compile`,
parity with the AOT door holds by construction.

## Risks / Trade-offs

- **[Editing the manifest parsers could regress library resolution]** → The guard is
  additive (only *narrows* to `library` entries); covered by the module-system parity
  scenario and the existing `test/modules-*` suites, plus a mixed-manifest test.
- **[`make regen` must converge and stay byte-stable]** → regen is Chez-free and
  idempotent by design; run it and verify `git diff bootstrap/` is empty after a
  second pass (the repo's existing trust-check).
- **[No tree-shaking → larger binaries than the Chez driver]** → Accepted for this
  slice and called out in the spec; the closed-world strip on the Chez-free door is
  future work, not a regression of any shipped behavior.
- **[Two build entry points (`emit build`, `bin/scheme-compile`) could drift]** →
  `emit build` adds only resolution; the build itself *is* `bin/scheme-compile`.

## Migration Plan

Purely additive. Existing library-only manifests and all existing binaries keep
working; `make regen` + relink ships the new mode. Rollback is removing `bin/emit`,
the `--resolve-program` flag, mode 10, and the keyword guards, then regenerating —
library builds are unaffected either way.

## Open Questions

- Exact default output path for a program entry with no `(output O)` — proposed
  `build/NAME`; confirm during implementation against the module-artifact
  convention (artifacts default under `build/`).
- Whether `bin/scheme-compile` should also grow a `--manifest` passthrough (today it
  relies on `EMIT_MANIFEST`); out of scope here — `emit build` sets `EMIT_MANIFEST`.
