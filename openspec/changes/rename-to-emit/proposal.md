## Why

The working name *Scheme LLVM* is generic and descriptive rather than a real
product name. Per [issue #2](https://github.com/bwbensonjr/scheme-llvm/issues/2)
the project has been named **Emit**, and the repository, docs, and user-visible
strings should reflect that. Doing the rename as one deliberate change keeps the
self-hosting build coherent (the bootstrap IR embeds source text, so name edits
in comments must be regenerated to a fixed point rather than left inconsistent).

## What Changes

- Rename the GitHub repository `bwbensonjr/scheme-llvm` → `bwbensonjr/emit` and
  update the GitHub repository description to name the project *Emit*.
- Update the local git `origin` remote URL to the renamed repository (GitHub
  redirects the old path, but the remote should be canonical).
- Update `README.md`: the `# Scheme LLVM` title and prose to *Emit*.
- Update the two user-visible REPL banners that print `scheme-llvm REPL ...`
  (`src/repl/host.cpp`, `test/repl.ss`) to use the *Emit* name.
- Update remaining `scheme-llvm` / *Scheme LLVM* references in active source
  comments and the `Makefile` header comment.
- Update the requirement prose in the `core-language`, `self-hosting`, and
  `compiler-pipeline` specs that names the compiler/language "scheme-llvm"
  (e.g. "the language scheme-llvm accepts" → "the language Emit accepts").
  This is a terminology change only; no normative behavior changes.
- Regenerate the bootstrap artifacts (`bootstrap/*.ll`) that embed prelude and
  compiler source text, and re-establish the self-host byte-identical fixpoint,
  so the renamed comments are consistent across the compiler-compiling-itself
  loop.
- **Out of scope** (flagged for a possible later change): renaming build
  artifacts / binaries (`schemec`, `scheme-run`, `repl-host`) and the local
  working-directory path. Binary renames are a larger, separable decision and
  are not required by this change.

## Capabilities

### New Capabilities
<!-- None. This change introduces no new spec-level behavior. -->

### Modified Capabilities
<!-- Terminology-only deltas: these specs name the compiler/language
     "scheme-llvm" in requirement prose. No normative behavior changes. -->
- `core-language`: prose renamed from "scheme-llvm" to "Emit" in the
  requirements that name the accepting language.
- `self-hosting`: prose renamed from "scheme-llvm" to "Emit" in the
  requirements describing the assembled/self-hosted compiler.
- `compiler-pipeline`: prose renamed from "scheme-llvm" to "Emit" in the
  requirements that name the language/expander.

## Impact

- **Repository / hosting**: GitHub repo name and description; local `origin`
  remote URL. Existing clones and links keep working via GitHub's automatic
  redirect from the old name.
- **Docs**: `README.md`.
- **Source**: user-visible REPL banner strings (`src/repl/host.cpp`,
  `test/repl.ss`); comments in `src/emit.ss`, `src/parse.ss`, `src/prelude.scm`,
  `src/repl-core.ss`, `test/self-host-fixpoint.sh`; `Makefile` header comment.
- **Bootstrap**: `bootstrap/embed.ll`, `bootstrap/embed-repl.ll`,
  `bootstrap/schemec.ll` — regenerated (they embed source text as string
  literals); self-host fixpoint re-verified.
- **Specs**: terminology-only prose edits in `core-language`, `self-hosting`,
  and `compiler-pipeline` (no normative behavior change).
- **No behavior change**: no runtime semantics, APIs, or language behavior
  change. Historical (`historical/`) and spike (`spike/`) directories are left
  as-is as a point-in-time record.
