# Exploration: packaging and the unified `emit` CLI

Status: exploration / living roadmap (individual steps become their own changes)
Related:
- `docs/superpowers/specs/2026-07-15-modules-v0-design.md` (decision **D7** — the four-verb mapping and the "settle modules before packaging" sequencing)
- `openspec/changes/archive/2026-07-17-aot-release-profile` (delivered the *first slice* of `emit build`: release profile — `-O2` at link + root-set-driven, unit-general reachability tree-shaking)
- `openspec/explorations/modules-and-embedding.md`, `openspec/explorations/namespace-model.md` (the module surface packaging sits on top of)
- `docs/MODULES.md` (the manifest `emit-libs.scm`; "extending the embedded runner with a manifest is future work")
- `CLAUDE.md` design goals: standalone executables as a first-class deliverable; a module is the shared unit of compilation; dev→ship fidelity
Captured: 2026-07-17

## Why this note exists

The desire for a `cargo`/`uv`-style project tool ("compile the project and deliver it")
is real and recurring, but it currently lives only as **motivating prose scattered across
an archived change and a design note**. There is no active OpenSpec change, no capability
spec, and no roadmap entry tracking it — so it is only rediscoverable by grepping. This
note consolidates every reference into one place so the vision can be designed and acted
on later without archaeology.

## The vision (as recorded so far)

A single `emit` binary fronting four verbs, each a rename/unification of a tool that
**already exists today** (modules-v0-design D7):

| Future verb | Today's capability | Today's artifact |
|---|---|---|
| `emit lib`   | compile-unit (source + name + import env → `.ll` + `.exports`) | embedded-compiler entry in `src/compile.ss` |
| `emit build` | build-program (import-aware, resolves manifest, links) | `bin/scheme-compile` (Chez driver) + `build/schemec` |
| `emit run`   | run-program (compile + run in-process, Chez-free) | `build/scheme-run` |
| `emit repl`  | repl (interactive, honors `import`) | `build/repl-host` |

D7's exact framing: v0 "adds these on the *existing* binaries and wrapper, renaming
nothing — respecting the decision to settle modules before packaging. The four map 1:1
onto a future `emit lib` / `emit build` / `emit run` / `emit repl` (+ `repl-host`→
`emit-repl`), so that unification is later **pure packaging over a proven surface**."

The manifest already exists as the seed of a project file — a readable s-expression
(default `./emit-libs.scm`, override `--manifest` / `EMIT_MANIFEST`):

```scheme
;; emit-libs.scm
((library (scheme base) (source "lib/scheme/base.sld") (artifacts "build/lib"))
 (library (foo bar)      (source "examples/foo/bar.sld")))
```

## What is already true (foundations in place)

- **Manifest-driven resolution.** `src/compile.ss` resolves imports through the manifest,
  compiles each library to a unit, and links them (`docs/MODULES.md`). The prelude is
  "unit zero."
- **Separate compilation + whole-program strip.** The `aot-release-profile` change
  established, and explicitly justified as matching `cargo`/`uv`: *separate compilation for
  dev; whole-program strip at final link.* Its reachability pass is **root-set-driven and
  unit-general** by deliberate factoring — "a future manifest can supply richer roots (a
  bin entry, or a delivered library's exports) without reworking the pass." That is the
  compile-and-deliver half of `emit build`, already landed as a first slice.
- **Dev→ship fidelity.** One shared compiler core across REPL/JIT and AOT; the dev door
  keeps full cached units (open world), the ship door builds a pruned per-program `__init`
  (closed world). Observable behavior is identical.

## What is missing (the packaging work proper)

- **Manifest → project file.** Today `emit-libs.scm` maps library names to sources. A
  project tool needs richer roots: a **bin entry** (the program to build/deliver), a
  library's **exports** as roots, and per-target artifact dirs. (The reachability pass is
  already shaped to consume these.)
- **The `emit` binary + verb dispatch.** A single front-end that dispatches to the four
  capabilities. D7 defers the rename deliberately; nothing dispatches today.
- **Embedded-runner manifest support.** `build/scheme-run` auto-imports only `(scheme
  base)` and has no manifest; user libraries on the Chez-free path still require the Chez
  driver (`docs/MODULES.md`: "future work").
- **Open, deliberately-unanswered questions** (not decided anywhere yet):
  - Dependency model — local paths only, or eventually a **registry** + version
    constraints + a lockfile? The `cargo`/`uv` analogy is invoked for the *build shape*,
    not (yet) for a network registry. This needs an explicit scope decision.
  - Artifact caching / incremental builds across manifest units.
  - Binary/CLI naming and back-compat for the current `scheme-run`/`repl-host`/`schemec`
    names and `bin/scheme-compile`.

## Sequencing gate (corrected 2026-07-17)

modules-v0-design records the decision plainly: **settle modules before packaging** —
packaging is "pure packaging over a proven surface." An earlier draft of this note read
that as a wall in front of *all* packaging work. Grounding it in the actual specs corrects
that: the surface is largely proven already.

`openspec/specs/module-system/spec.md` carries **22 requirements**, and nine module-related
changes are archived. The doors packaging would unify mostly exist:

| Capability | Module-system requirement | State |
|---|---|---|
| build + link an importer (`emit build`) | "AOT door — build and link an importing program" | ✅ shipped (needs Chez: `bin/scheme-compile`) |
| import interactively (`emit repl`)       | "REPL door — import a library interactively"      | ✅ shipped, Chez-free (`repl-host`) |
| manifest resolution                       | "Library manifest"                                | ✅ shipped |
| run in-process (`emit run`)               | *(no requirement yet)*                            | ❌ **the one gap** |

So the gate is **not** modules-at-large; it is one concrete, bounded gap: the Chez-free
in-process runner (`build/scheme-run`) auto-imports only `(scheme base)` and has "no
manifest" (`docs/MODULES.md:117,126`), so it cannot resolve *user* libraries the way the
AOT and REPL doors already can. Closing that gap is a **module-system completion**, and it
is the thing that finishes "the proven surface."

## Toward a first proposable slice — the path forward

Reranked after the gate correction. The genuinely-proposable-now slice turns out not to be
"packaging" at all — it is the last module door. Packaging-proper still wants design.

| # | Slice | Proposable now? | Why |
|---|---|---|---|
| **3** | **`scheme-run` resolves user libs via `--manifest` (Chez-free)** | **Yes — now** | A *module-system completion*, not packaging. Clear spec home (a new `module-system` requirement: "run-program door resolves user libraries via manifest"), clear acceptance (parity with the shipped AOT door), no undecided first-order questions. Unblocks `emit run` parity. |
| 2 | Manifest bin-entry + `emit build <project>` | Soon (needs design) | The reachability pass already accepts explicit roots; but "what is a bin/project entry in the manifest" is a real schema-design question. Most direct continuation of `aot-release-profile`. |
| 1 | Unified `emit` CLI dispatcher / rename | Later | D7 defers the rename; low value until the verbs are coherent; entangled with the CLI-naming/back-compat open question. |

```
   packaging vision ──┬─▶ #1 dispatcher / rename   ⏸  design (CLI naming, back-compat)
                      ├─▶ #2 emit build + bin-entry ◐  design (manifest schema, roots)
                      └─▶ #3 scheme-run --manifest  ✅ PROPOSE NOW
                                                    (module-system finisher; the gate itself)
```

## Open first-order questions (for packaging-proper, NOT slice #3)

- **Dependency model.** The `cargo`/`uv` analogy is invoked only for the *build shape*
  (separate-compile + whole-program strip), never for a network **registry / version
  constraints / lockfile**. That scope is genuinely undecided and should be an explicit
  decision before slice #2 grows a dependency notion.
- **CLI naming / back-compat.** Whether `scheme-run` / `repl-host` / `schemec` /
  `bin/scheme-compile` get renamed under a single `emit` binary, and with what deprecation
  path, is undecided. Slice #1 is blocked on this.

## Status of the follow-on proposal

- **Slice #3 → landed & archived** as a `module-system` change (change:
  `run-door-user-libraries`, 2026-07-17). It finished the run-program door and thereby "proved
  the surface" packaging sits on.
- **Slice #2 → landed** as the `emit-build-bin-entry` change (2026-07-17). It adds the
  `(program NAME (source S) [(output O)])` manifest entry and a `bin/emit build [NAME]` verb
  that resolves it and delivers a standalone executable. Two decisions departed from this note's
  initial framing:
  - **Chez-free door, not the Chez ship path.** `emit build` delivers via `bin/scheme-compile`
    (Chez-free: `scheme-run --emit` + clang), *not* the Chez driver's tree-shaking release
    profile. So this slice links full library units — **no whole-program strip yet**. Porting
    the closed-world strip (the `aot-release-profile` pass) to the Chez-free door is now its own
    deferred item, distinct from the dependency-model question.
  - **Chez-free resolver.** The `(program …)` entry is resolved by the embedded compiler
    (`src/repl-core.ss` mode 10, exposed as `scheme-run --resolve-program NAME`), reusing the run
    door's manifest machinery — keeping `emit build` Chez-free end to end.
  - `emit` was introduced **additively** (`bin/emit`, `build` verb only); nothing was renamed,
    so the CLI-naming/back-compat question below stays with slice #1.
- **Slice #1 → remains in exploration.** The unified `emit lib`/`run`/`repl` dispatch and any
  rename/deprecation of `scheme-run` / `repl-host` / `schemec` / `bin/scheme-compile` still
  carry the CLI-naming/back-compat open question.

## Open items after slice #2

- **Dependency model** — unchanged and still undecided (registry / version constraints /
  lockfile); decide before any dependency notion grows.
- **CLI naming / back-compat** — unchanged; blocks slice #1.
- **Chez-free tree-shaking** — new: `emit build` links full units. Bringing the closed-world
  strip to the Chez-free door would shrink delivered binaries without needing Chez at build time.
