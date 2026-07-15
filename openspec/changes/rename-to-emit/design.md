## Context

The compiler has gone by the working name *Scheme LLVM* (repo `scheme-llvm`).
[Issue #2](https://github.com/bwbensonjr/scheme-llvm/issues/2) settles on the
name **Emit** and asks for the repository, README, and GitHub description to be
updated. Beyond those three, the string `scheme-llvm` is used internally as the
name of the compiler/language in code comments, the `Makefile`, two user-visible
REPL banners, and the requirement prose of three specs (`core-language`,
`self-hosting`, `compiler-pipeline`). The user has chosen a full sweep: rename
everywhere the project is *named*, leaving only build-artifact names
(`schemec`, `scheme-run`, `repl-host`) and historical/spike snapshots untouched.

The one non-obvious wrinkle is self-hosting. The committed bootstrap IR
(`bootstrap/embed.ll`, `bootstrap/embed-repl.ll`, `bootstrap/schemec.ll`) embeds
the prelude and compiler source *text* — including comments — as string
literals. Editing a comment that mentions `scheme-llvm` in `src/prelude.scm` (or
any embedded source) changes those literals, so the committed IR goes stale and
the self-host byte-identical fixed point must be re-established. This is why the
rename is one deliberate change rather than a scattering of find-and-replace
edits.

## Goals / Non-Goals

**Goals:**
- The project is named *Emit* everywhere it is referred to by name: GitHub repo
  and description, `README.md`, user-visible REPL banners, active source
  comments, `Makefile` header, and the requirement prose of the three specs.
- The self-hosting invariant stays intact: after source-comment edits, the
  committed IR is regenerated and the triple/fixpoint test passes.
- Existing links and clones keep working (rely on GitHub's rename redirect) and
  the local `origin` remote points at the canonical new URL.

**Non-Goals:**
- Renaming build artifacts / binaries (`schemec`, `scheme-run`, `repl-host`) or
  any Makefile target names. Separable, larger blast radius; deferred.
- Renaming the local working-directory path. Cosmetic and machine-local.
- Rewriting `historical/` and `spike/` contents — they are a point-in-time
  record and are intentionally left as-is.
- Introducing a `.ll`-level find/replace on embedded strings by hand — the IR is
  regenerated from source, never hand-edited.

## Decisions

**Name rendering: `Emit` (prose) / `emit` (repo, URLs).** The product name is
`Emit`; the repository slug and URLs use lowercase `emit`. In requirement and
comment prose that previously read "the language scheme-llvm accepts", the
replacement is "the language Emit accepts". Chosen over keeping a
`scheme-llvm` internal alias because the user asked for a clean, single-name
sweep and a lingering internal name is exactly the confusion this removes.

**Spec terminology via MODIFIED requirement deltas + a direct prose edit.**
OpenSpec's delta mechanism operates on `### Requirement` blocks, so each
requirement whose prose names the compiler is carried as a full MODIFIED block
(two in `core-language`, four in `self-hosting`, two in `compiler-pipeline`).
Non-requirement prose that also names the compiler — the `self-hosting` spec's
**Purpose** paragraph — is not expressible as a delta, so it is updated by a
direct edit to the main spec at implementation time. These do not conflict:
deltas touch only requirement bodies; the Purpose edit touches only the Purpose.

**Regenerate IR, then verify the fixpoint — don't hand-edit `.ll`.** The
bootstrap `.ll` files are treated as generated. After the source-comment edits,
run the Chez-free regeneration path and then the self-host fixpoint check so the
committed IR matches current source and stage-2 == stage-3. This keeps the
"committed IR is self-produced" requirement true.

**GitHub rename first, then fix the local remote.** Rename the repo on GitHub
(`scheme-llvm` → `emit`) and update its description, then repoint local
`origin`. GitHub auto-redirects the old path so outstanding clones, the open
issue, and any inbound links keep resolving; the local remote is made canonical
rather than relying on the redirect indefinitely.

## Risks / Trade-offs

- **Stale committed IR after comment edits** → Regenerate the bootstrap IR and
  run the fixpoint/triple test as an explicit task; do not consider the change
  done until it passes. If any embedded-source comment changed, the default
  build (which only links committed IR) would otherwise carry the old text.
- **Comment edits perturb the fixed point unexpectedly** → If regeneration does
  not converge byte-identically, treat it as a real self-hosting regression and
  debug via `test/self-host-fixpoint.sh`, not by hand-editing IR.
- **Broken inbound links after rename** → Rely on GitHub's automatic redirect
  from the old repo name; additionally update the `origin` remote so local work
  is unaffected.
- **CLAUDE.md path references / tooling that keys off the directory name** →
  Out of scope here (directory not renamed); flagged so a later change can
  address it deliberately.

## Migration Plan

1. Land the in-repo edits (README, banners, comments, Makefile, spec prose) on a
   branch.
2. Regenerate bootstrap IR and verify the self-host fixpoint; commit regenerated
   artifacts.
3. Merge to `main`.
4. Rename the GitHub repository and update its description.
5. Update the local `origin` remote URL to the new repository.

Rollback: the GitHub rename is reversible (rename back; the redirect works in
both directions during the grace period). In-repo edits are ordinary revertible
commits.

## Open Questions

- Should the build artifacts (`schemec`, `scheme-run`, `repl-host`) and the
  local working-directory eventually be renamed to match *Emit*? Deferred to a
  possible follow-up change; not resolved here.
