# Project Instructions 

## Design Goals 

- The compiler should be written in Scheme, bootstrapped with Chez
  Scheme (invoked as `chez`) with a long-term goal to eventually be
  self-hosting.
- This implementation should be as simple and easy-to-understand as
  possible with clear control flow, stages, logging, and transparency.
- **Standalone executables are a first-class deliverable.** Producing
  small, clean, self-contained native executables from Scheme is a
  defining niche of this implementation; the AOT path stays first-class
  and binary size/cleanliness is a design concern (favoring separate
  compilation over "prepend everything").
- **The REPL is the primary development loop, with dev→ship fidelity.**
  Code developed, tested, and debugged interactively must compile to an
  executable with identical behavior. The REPL and the batch compiler
  share one compiler core; a second compilation path is not acceptable.
  (This is the core argument for in-process embedding of the compiler —
  Path A — over a subprocess REPL.)
- **A module is the shared unit of compilation.** A library compiles
  once to an artifact (IR/object + a compile-time export interface) that
  is consumable identically in two contexts: loaded into the interactive
  REPL, and linked into a static executable. The prelude is "library
  zero." Macro exports require a phase-separated compile-time interface,
  not just IR. Target **R7RS-small** for the module surface
  (`define-library`, `import`, `export`).
- This project uses OpenSpec for tracking designs and tasks (see
  `openspec/specs` and `openspec/changes`).
- **Tools narrate what they do.** Every tool, script, and pipeline stage
  announces its action, names its inputs and outputs, and reports the
  relevant metrics (sizes, durations, counts) — concise by default,
  controllable via `EMIT_VERBOSITY`, with narration on stderr and data on
  stdout. Follow the convention in `docs/OUTPUT.md` when adding or editing a
  tool.
