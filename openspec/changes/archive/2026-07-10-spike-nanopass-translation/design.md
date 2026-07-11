## Context

The compiler is Chez-hosted with an eventual self-hosting goal, and its guiding
constraint is maximal simplicity and transparency of stages (`CLAUDE.md`). `LLVM.md`
commits the pass pipeline to nanopass, citing two precedents: Chez itself, and Andy
Keep's `akeep/scheme-to-llvm` (same host, same framework).

A survey of the Chez backend (`s/cpnanopass.ss`, `s/np-languages.ss`) established the
shape of the problem:

- Chez runs **~50 passes over ~30 intermediate languages** (`L1`..`L16`, with
  fractional interpolations like `L4.9375` — one micro-language delta per pass).
- A Scheme → LLVM compiler needs only the **top third**. The line falls right after
  lambda-lifting / closure lowering (Chez's `L7`). Everything below — overflow-trap
  insertion, `remove-complex-opera*` (ANF), calling-convention imposition, allocation-
  pointer exposure, basic-block exposure, instruction selection, register allocation,
  code generation — is exactly what LLVM does. The two largest single passes in the
  Chez file (`impose-calling-conventions` ~1700 loc; instruction-selection +
  `generate-code` ~2700 loc) are entirely subsumed.
- The transferable spine is short and maps almost 1:1 onto `LLVM.md`'s pipeline:

  ```
  read → expand → core(Lsrc) → assignment-conv → closure-conv → lambda-lift → emit .ll
                               └─ Chez L3→L4 ──┘ └─ L5→L6 ──┘ └─ L6→L7 ──┘
  ```

- Corollary for the minimal subset: **neither CPS nor ANF is needed.** Chez is
  direct-style (no CPS; `call/cc` via stack copying) and ANF is redundant against
  LLVM's SSA/mem2reg. CPS in `LLVM.md` is correctly tied to `call/cc`, which is
  phase 2.

At this reduced pass count the nanopass-vs-hand-rolled question is a genuine fork,
because nanopass's value scales with pass count and here the count is small.

## Goals / Non-Goals

**Goals:**

- Get empirical evidence — real translated passes, not argument — on whether nanopass
  or stylized hand-rolled Scheme better serves this project at its actual pass count.
- Hold everything constant except the framework, so the comparison is fair.
- Produce a durable frontend/pass-ladder design doc as the spike's lasting output.

**Non-Goals:**

- Not building the real compiler or any production pass. The spike code is **kept** as
  a reference implementation under `spike/nanopass/`, but it is not yet the production
  compiler source.
- Not touching the LLVM backend layer (that is `LLVM.md`'s scope, below the fork).
- Not resolving self-hosting (explicitly parked; noted only where it colors the fork,
  since nanopass is a `syntax-case`-heavy Chez-ism a future self-host must reckon with).
- Not deciding the minimal source-language subset here (separate exploration).

## Decisions

### D1 — Translate three passes, chosen to stress nanopass's strengths

Picking passes where nanopass should win *most* makes a close hand-rolled result
decisive.

| Pass (Chez)              | Transition | Why this probe |
|--------------------------|------------|----------------|
| `np-recognize-let`       | L1→L2      | Boilerplate floor: trivial, pure traversal. Exposes nanopass's fixed overhead vs. the hand-rolled baseline. |
| `np-convert-assignments` | L3→L4      | Sweet spot: the delta is literally `(- (set! x e))` plus boxing captured mutable vars. If hand-rolled is comparably clean *here*, the margin is thin everywhere. |
| `np-convert-closures`    | L5→L6      | Structural: `letrec` → `closures` form — tests whether hand-rolled stays readable when the language *shape* shifts, not just when a form is dropped. |

Alternative considered: translate the whole L1→L7 spine. Rejected for the spike —
three well-chosen passes answer the framework question; translating all of them is
the real implementation, not the experiment.

### D2 — Stylized hand-rolled convention: `match` + subform-recur helper

The hand-rolled side is a `match`-based recursive descent over plain s-expressions,
built on the **standard Chez Scheme `match` macro** (the Friedman/Hilsdale/Dybvig
`match.ss`), plus one "recur over subforms" helper to stand in for nanopass's automatic
catamorphism. Fixing this up front ensures the two versions differ only in framework,
not in personal style.

Note on availability: base `(chezscheme)` does **not** export `match`; the Chez `match`
is loaded as a library (`match.ss`). This is a setup step, not a variable under test.

Assuming a capable `match` macro is a deliberate decision: it is what makes the
hand-rolled code simple and clear, and it resolves the earlier portability question in
favor of clarity now (a `match`-free R6RS/R7RS fallback is not a concern for the
spike).

Alternative considered: bare `cond`/`car`/`cdr` deconstruction. Rejected — it would
handicap the hand-rolled side unfairly and isn't how anyone would actually write it.

### D3 — Fair-comparison rig: same IL in, same IL out, same test program

Both versions of each pass consume the same input intermediate representation and
must produce the same output representation, verified by running the same small test
program(s) through each. The IR is represented as plain s-expressions on the
hand-rolled side and via `define-language` on the nanopass side; a tiny shared set of
example inputs (including one exercising captured-mutable boxing and one exercising a
non-trivial closure) drives both.

### D4 — Scoring rubric

Score each pass, each way, on:

- **Line count** and **share that is boilerplate** (traversal plumbing vs. real logic).
- **Readability** — can a newcomer follow the transformation without knowing the
  framework?
- **Safety lost** — specifically, what nanopass's automatic "every form handled"
  checker gives that the hand-rolled version must reproduce by hand (and how much that
  costs).

### D5 — Documentation sequencing

Do the spike first; document the verdict second. The frontend/pass-ladder design doc
(new file — `docs/PIPELINE.md`, sibling to `LLVM.md`) is the spike's output,
not its input. `LLVM.md` stays untouched during the spike; after the verdict, at most
its one framing sentence about nanopass is reconciled.

Alternative considered: rewrite `LLVM.md` toward hand-rolled first, then spike.
Rejected — it writes the conclusion before the evidence and risks editing the doc
twice.

## Risks / Trade-offs

- **Three passes may under-sample.** → Chosen to bracket the range (trivial →
  sweet-spot → structural); if the verdict is ambiguous, the follow-up is to translate
  one more pass rather than to guess.
- **Spike quality bias** — whichever side is written more carefully looks better. →
  D2 and D3 hold style and interface constant; write both versions of a pass in one
  sitting.
- **Nanopass setup cost is a one-time tax** that could unfairly inflate its
  line-count. → Report per-pass logic separately from one-time framework/`define-
  language` setup.
- **Self-hosting is parked but real.** → Note it as a tie-breaker input in the verdict,
  not a scored dimension.

## Resolved

- **Spike code location and lifetime** → a tracked `spike/nanopass/` directory,
  **kept** as a reference implementation rather than discarded after the verdict.
- **Frontend design doc** → `docs/PIPELINE.md`, sibling to `LLVM.md`.
- **`match` macro** → the standard Chez Scheme `match` (Friedman/Hilsdale/Dybvig
  `match.ss`), loaded as a library; a `match`-free portable fallback is out of scope
  for the spike.

## Open Questions

<!-- None outstanding. -->
- (none)
