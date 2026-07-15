## Why

The project's build, compile, regen, and test scripts currently narrate their work
inconsistently: some emit a bare `built $@`, others a byte-count summary, most say
nothing about *what* they are doing or *how expensive* it was. A developer watching a
build or a compile cannot tell which stage is running, what inputs and outputs are
involved, or how long anything took. Issue #3 asks that the tools and pipelines produce
useful, concise output describing each action with accompanying data and metrics — the
kind of transparency Chez Scheme's own build gives (per-file `compiling X with output to
Y`, plus `(time ...)` blocks reporting elapsed time, collections, bytes allocated, peak
memory) — and that this be captured as a **durable project principle** the tools are held
to, not a one-off cleanup.

This directly serves two stated design goals: "clear control flow, stages, logging, and
transparency," and treating binary size/cleanliness as a first-class concern (which
requires the numbers be *reported* to be managed).

## What Changes

- **Establish an observability principle** as a versioned capability spec: every tool,
  script, and pipeline stage announces the action it is about to perform, names its
  concrete inputs and outputs, and reports the metrics relevant to that action
  (durations, byte sizes, counts, pass/fail), on a consistent, greppable output format
  that is concise by default and verbose on request.
- **Define a shared convention** for how messages look (a `stage`/`did` verb, an
  arrow-style `input -> output`, a trailing metrics clause) and for which stream they go
  to (human/status narration to stderr; machine-consumable payloads such as emitted IR
  to stdout), so status text never contaminates a tool's data output.
- **Retrofit the existing tooling** to comply:
  - `Makefile` targets (`all`, `schemec`, `regen`) — announce each link/compile with its
    output artifact and report the resulting binary/IR byte sizes.
  - `bin/scheme-compile` — narrate the emit and link steps, and report the emitted-IR
    size and final executable size (feeds the "small, clean executables" goal).
  - `tools/regen.sh` — keep its numbered step banners but add per-artifact metrics
    (already reports byte sizes; add fixed-point iteration count and timing).
  - `run-all-tests.sh` / `run-dev-tests.sh` — keep the PASS/FAIL summary and add per-suite
    timing and a total.
  - The compiler driver's stage logging (`--dump`, stage progress) — make each pass
    announce itself under a common verbosity flag.
- **Add a verbosity/quiet control** so the concise default can be dialed up (per-stage
  metrics) or down (errors only) without changing the tools' contract.

## Capabilities

### New Capabilities
- `tooling-observability`: The project-wide principle and its concrete conventions for
  informational and status output — what every tool/pipeline stage must announce (action,
  inputs, outputs), what metrics it must report, the message format and output-stream
  discipline, and the verbosity controls. Also enumerates the specific tools required to
  conform.

### Modified Capabilities
<!-- None. The observability contract is captured as a new cross-cutting capability;
     the behavioral contracts of compiler-pipeline, aot-codegen, etc. are unchanged —
     only their tools' reporting is, which the new capability governs. -->

## Impact

- **Scripts/build:** `Makefile`, `bin/scheme-compile`, `tools/regen.sh`,
  `run-all-tests.sh`, `run-dev-tests.sh`.
- **Compiler driver:** stage/verbosity logging in `src/core.ss` / `src/compile.ss`
  (and the embedded runner `src/run.cpp` where it prints status).
- **No behavioral change to compiled output:** stdout data (emitted IR from
  `scheme-run --emit`, filter output from `schemec`) must remain byte-identical; all new
  narration goes to stderr. This preserves the self-hosting fixed-point and
  self-emission-equivalence checks.
- **Docs:** a short pointer from `CLAUDE.md`/`README.md` to the principle.
- **Dependencies:** none added; timing uses the shell's built-in facilities and the
  compiler's existing host clock.
