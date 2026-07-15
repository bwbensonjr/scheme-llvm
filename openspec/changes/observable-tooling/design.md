## Context

The tooling grew organically: `Makefile` says `built $@`, `tools/regen.sh` prints
numbered banners plus byte sizes, `bin/scheme-compile` prints `wrote $out`, and the test
runners print PASS/FAIL banners. There is no shared convention, so a build reads as a
patchwork. Issue #3 wants the Chez-build experience — each action named, each transform
shown as `input -> output`, and a `(time ...)`-style metrics block on expensive steps —
captured as a principle the tools are held to.

The hard constraint is the self-hosting machinery. `scheme-run --emit` and `schemec` are
**filters**: their stdout IS compiler data (LLVM IR), and the trust-check
(`make regen` reproduces committed IR byte-for-byte) and self-emission-equivalence tests
compare that stdout exactly. Any narration MUST stay off stdout. This is why the
stream-discipline requirement is non-negotiable rather than stylistic.

The tools split across three implementation surfaces — Make, Bash, and Scheme/C++ — so
"one convention" cannot mean "one code path." It means one *documented* format that each
surface implements with a tiny local helper.

## Goals / Non-Goals

**Goals:**
- A short, durable, written convention for informational/status output (format, streams,
  verbosity) that lives in the repo and is linked from `CLAUDE.md`/`README.md`.
- Every build/compile/regen/test tool announces action + inputs/outputs + metrics.
- Byte sizes surfaced for produced binaries and IR (feeds the "small executables" goal).
- A consistent verbosity control (quiet / default / verbose).
- Zero change to any tool's stdout data contract.

**Non-Goals:**
- Structured/JSON log output or a logging library. Plain text on stderr is the target.
- Instrumenting the runtime or compiled programs' own output — this is about the *tools*.
- GC/allocation metrics matching Chez's `(time ...)` exactly. We report wall-clock and
  sizes; per-pass allocation is a possible later addition, noted but out of scope.
- Changing pass structure or build graph; only their reporting changes.

## Decisions

### D1: Capture the principle as a written convention doc, not just spec prose

Add `docs/OUTPUT.md` (or a section appended to an existing doc) describing the format, the
stream discipline, and verbosity levels, and link it from `CLAUDE.md`/`README.md`. The
OpenSpec capability is the normative contract; the doc is the human-facing "how to write a
conforming message" that contributors actually read.

*Alternative considered:* put it only in the spec. Rejected — contributors edit shell
scripts far more than they read `openspec/specs/`, so the guidance needs to sit next to the
code and be linked from the front door.

### D2: Message format — `<verb> <input> -> <output>  [<metrics>]`

Leading lowercase verb (`link`, `compile`, `emit`, `assemble`, `regen`, `run`), an
optional `input -> output` arrow for transforms, and a trailing bracketed/comma metrics
clause (`1.2s`, `48213 bytes`, `iter 2`). Concise, greppable, and close to what
`regen.sh` already does. Prefixing multi-stage tools with a short tag (`regen:`, `test:`)
keeps interleaved output attributable.

*Alternative considered:* aligned columns / a box-drawing UI. Rejected as over-engineered
and fragile under piping; violates the "simple" design value.

### D3: Stream discipline — narration to stderr, data to stdout

All narration uses stderr. The filter tools (`scheme-run --emit`, `schemec`) already put
their `wrote`/status text on stderr in the one place that matters; the rule is generalized
and made explicit, and the self-emission-equivalence + trust-check tests are the automated
guard that no regression pushes narration onto stdout.

### D4: Verbosity via one env var plus conventional flags

A single `EMIT_VERBOSITY` env var (`quiet` | `default` | `verbose`) read uniformly by the
shell tools and threaded into the compiler driver, with the usual `-q`/`-v` flags as
front-ends where a tool already parses argv. Env var chosen as the common denominator
because `make`, bash scripts, and the driver can all read it without argument plumbing
through `make -> script -> binary`.

*Alternative considered:* per-tool flags only. Rejected — `make` does not forward flags to
recipe scripts cleanly, so an env var is the least-friction shared channel.

### D5: Metrics sources per surface

- **Bash** (`regen.sh`, `scheme-compile`, test runners): `wc -c` for sizes; `SECONDS` or
  `date +%s` deltas for timing (both built-in; no dependency). Iteration/suite counts are
  already loop variables.
- **Make**: recipe lines shell out to the same helpers; sizes via `wc -c` in the recipe.
- **Compiler driver** (Scheme): stage announcements gated on the verbosity level; wall
  time from the host clock the driver already links. Per-pass timing is `verbose`-only.

A tiny shared bash helper (e.g. `tools/log.sh` sourced by the scripts) provides `say`,
`step`, and `bytes` so the format lives in one place per surface.

## Risks / Trade-offs

- **[Narration leaks onto stdout and breaks the trust-check]** → The stream rule is
  enforced by the existing self-emission-equivalence and `make regen` byte-comparison
  tests; run them as the acceptance gate for this change. This is the highest-severity
  risk and it is already automatically detectable.
- **[Timing makes test output non-deterministic, hurting diffability]** → Keep durations
  out of any output that is compared byte-for-byte (only the trust-check compares IR, not
  narration); test-runner timing is display-only and never asserted on.
- **[Verbosity var adds a hidden global]** → Document it in `docs/OUTPUT.md` and default to
  `default`; unset behaves exactly as today's concise output.
- **[Scope creep into a logging framework]** → Explicitly bounded by the Non-Goals; the
  deliverable is plain stderr text and three small helpers.
- **[Cross-surface drift]** → One helper file per surface and one written convention keep
  Make/Bash/Scheme messages in sync; a reviewer checklist item in `docs/OUTPUT.md`.

## Migration Plan

1. Land `docs/OUTPUT.md` and the shared bash helper first (no behavior change).
2. Retrofit tools one at a time (Make, `scheme-compile`, `regen.sh`, test runners, driver),
   running `run-all-tests.sh` after each.
3. Gate on `run-dev-tests.sh` (trust-check + self-emission equivalence) to prove stdout is
   unchanged.
4. Link the doc from `CLAUDE.md`/`README.md`.

Rollback is trivial and per-tool: the changes are additive narration plus a helper source
line; reverting any single tool's diff restores prior behavior without affecting others.

## Open Questions

- Name/location of the convention doc: standalone `docs/OUTPUT.md` vs. a section in an
  existing doc. (Leaning standalone for linkability.)
- Env var name: `EMIT_VERBOSITY` vs. reusing a shorter `V=1`-style make idiom. (Leaning
  explicit name to avoid clashing with `make`'s conventions.)
- Whether the compiler driver reports per-pass wall time now or defers it to a follow-on
  once a host timing primitive is confirmed available in the Chez-free build.
