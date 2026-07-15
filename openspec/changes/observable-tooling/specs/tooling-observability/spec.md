## ADDED Requirements

### Requirement: Tools and pipeline stages announce their actions

Every tool, script, and pipeline stage in the project SHALL emit a concise
informational message describing the action it is performing and the concrete inputs it
consumes and outputs it produces. A developer reading the output SHALL be able to tell,
without consulting the source, which stage is running and what artifacts it reads and
writes. Silent success (an action that produces no describing output) SHALL NOT be the
default behavior for any action that reads or writes a file, links a binary, or runs a
compilation.

#### Scenario: A build step names its output artifact

- **WHEN** a `Makefile` target links a binary or the driver emits an IR file
- **THEN** the output includes a message naming the action and the resulting artifact
  (e.g. `link repl-host -> build/repl-host`)
- **AND** the message identifies the principal input(s) when they are not obvious from
  the target name

#### Scenario: A compiler pass identifies itself

- **WHEN** the compiler runs its frontend passes at a verbosity that shows stage progress
- **THEN** each pass announces the stage it represents (e.g. `expand`, `convert-closures`,
  `lower`, `emit`) in the order it runs

#### Scenario: An action with no describing output is a defect

- **WHEN** a tool reads or writes a file, links a binary, or compiles a program
- **THEN** it produces at least one message describing that action unless the active
  verbosity level is `quiet`

### Requirement: Actions report relevant metrics

An action SHALL report the metrics that make it observable and manageable: durations for
work that takes non-trivial time, byte sizes for artifacts produced, and counts for
repeated or iterated work (files processed, tests run, fixed-point iterations). Metrics
SHALL be reported in a form that is both human-readable and easy to extract, and SHALL
accompany the action they describe rather than being reported only in aggregate.

#### Scenario: A produced binary or IR artifact reports its size

- **WHEN** a tool produces a native executable or an IR artifact (`bootstrap/*.ll`,
  a linked binary, an emitted `.ll`)
- **THEN** the output includes the artifact's size in bytes

#### Scenario: A compile reports its duration

- **WHEN** a compilation or link that takes non-trivial time completes
- **THEN** the output includes the elapsed time for that step

#### Scenario: Iterated work reports its count

- **WHEN** the regen fixed-point loop or a test suite runs
- **THEN** the output includes the count of iterations to convergence, or the number of
  suites/tests run and how many passed and failed

### Requirement: Message format is consistent and greppable

Informational and status messages SHALL follow a single documented convention across all
tools so that output from different tools reads as one system and can be filtered with
simple text tools. The convention SHALL define a leading action verb, an
`input -> output` form for transformations, and a trailing clause for metrics. The
convention SHALL be recorded in a project document that the tools are held to.

#### Scenario: Transformations use the arrow form

- **WHEN** a step transforms one artifact into another
- **THEN** the message expresses it as `<verb> <input> -> <output>` with any metrics in a
  trailing clause

#### Scenario: The convention is documented

- **WHEN** the change is complete
- **THEN** a project document describes the message format, the stream discipline, and the
  verbosity levels, and is linked from `CLAUDE.md` or `README.md`

### Requirement: Status output and data output are separated by stream

Human-facing informational and status narration SHALL be written to standard error.
Standard output SHALL carry only a tool's machine-consumable payload (for example the IR
emitted by `scheme-run --emit`, or the filtered IR produced by `schemec`). Adding or
changing narration SHALL NOT alter the bytes a tool writes to standard output.

#### Scenario: Emitted IR is unaffected by narration

- **WHEN** `scheme-run --emit` or `schemec` compiles a program with narration enabled
- **THEN** the bytes written to standard output are identical to the output with narration
  suppressed
- **AND** the self-hosting fixed-point and self-emission-equivalence checks still pass

#### Scenario: Narration goes to stderr

- **WHEN** a tool emits an informational or status message
- **THEN** that message is written to standard error, not standard output

### Requirement: Verbosity is controllable

Tools SHALL support a concise default level of output and SHALL allow that level to be
raised (to include per-stage and per-metric detail) or lowered (to errors only) through a
consistent control, without changing the tool's data contract. The concise default SHALL
be informative enough to follow the work but SHALL NOT flood the terminal with per-item
detail.

#### Scenario: Quiet suppresses narration

- **WHEN** a tool is run at the `quiet` level
- **THEN** it emits only errors and its data output, with no informational narration

#### Scenario: Verbose adds per-stage detail

- **WHEN** a tool is run at the `verbose` level
- **THEN** it emits per-stage and per-metric detail beyond the concise default

#### Scenario: Default is concise

- **WHEN** a tool is run with no verbosity override
- **THEN** it announces its principal actions and headline metrics but not every
  per-item step

### Requirement: The project's tools conform to the observability principle

The build, compile, regeneration, and test tooling SHALL be brought into conformance with
this capability. Specifically, `Makefile` targets, `bin/scheme-compile`, `tools/regen.sh`,
`run-all-tests.sh`, `run-dev-tests.sh`, and the compiler driver's stage logging SHALL each
announce their actions, report their relevant metrics, and respect the format, stream, and
verbosity requirements above.

#### Scenario: Each listed tool announces action, inputs/outputs, and metrics

- **WHEN** any of `Makefile` targets, `bin/scheme-compile`, `tools/regen.sh`,
  `run-all-tests.sh`, `run-dev-tests.sh`, or the compiler driver runs at the default level
- **THEN** it announces the action it performs, names its inputs and outputs, and reports
  the metrics relevant to that action

#### Scenario: A test runner reports a per-suite and total summary

- **WHEN** `run-all-tests.sh` or `run-dev-tests.sh` finishes
- **THEN** it reports each suite's pass/fail result and its timing, plus a total count and
  total elapsed time
