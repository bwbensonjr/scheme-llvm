## MODIFIED Requirements

### Requirement: A reproducible tool catalogues tracked code by component, role, and language

The project SHALL provide a catalogue tool that enumerates the git-tracked files of the
repository and, for each file, reports its line count together with three classifications:
its **component** (derived from its path), its **role** (see the role taxonomy
requirement), and its **language** (derived from its file extension). The tool SHALL
operate on the set of git-tracked files only (so untracked scratch and build output are
excluded), with the sole documented exception of the tool's own metrics-history data file
(`docs/complexity-history.csv`), which SHALL be excluded from the counted set: counting a
file whose contents the tool itself appends to would make the metrics self-referential and
prevent the change-gated history append from converging. The tool SHALL be deterministic:
the same working tree SHALL always produce the same catalogue. The tool SHALL run from the
repository toolchain alone (`git`, a POSIX shell, `wc`) without requiring an agent.

#### Scenario: The catalogue reports every tracked file exactly once

- **WHEN** the catalogue tool runs against the repository
- **THEN** every git-tracked regular file, except the tool's own metrics-history data file
  (`docs/complexity-history.csv`), is counted exactly once
- **AND** each counted file is assigned exactly one component, one role, and one language
- **AND** the per-file line counts sum to the reported totals

#### Scenario: The tool's own history ledger is excluded from the count

- **WHEN** the catalogue tool runs and `docs/complexity-history.csv` is tracked
- **THEN** the history file does not appear in the catalogue tables and contributes to no
  total, role, or component count
- **AND** changing only the history file leaves the catalogue's reported metrics unchanged

#### Scenario: The tool runs without an agent

- **WHEN** a developer invokes the tool via its `make` target
- **THEN** the mechanical tables are produced using only the repository toolchain
  (`git`, POSIX shell, `wc`) with no network or agent dependency

## ADDED Requirements

### Requirement: The tool persists a timestamped metrics-history data file

The catalogue tool SHALL maintain a versioned, append-only history data file at
`docs/complexity-history.csv` that records the catalogue metrics over time. The file SHALL
use a stable long (tidy) format with the header
`timestamp,commit,dimension,key,files,loc`, where each recorded snapshot contributes one
row per measured aggregate: the whole-tree total, each role, and each component. All rows of
one snapshot SHALL share the same `timestamp` (an ISO 8601 instant identifying when the
snapshot was measured) and the same `commit` (the short git revision of `HEAD` at
measurement time). The `files` and `loc` values SHALL be the same counts the catalogue
reports for that dimension and key. The history file SHALL be machine-consumable data
(stdout-class output), not narration, and SHALL be tracked in the repository.

The long format is chosen deliberately so that roles and components appearing or
disappearing over time add or omit rows rather than requiring columns to change; consumers
filter by `dimension` and `key`.

#### Scenario: A recorded snapshot covers total, roles, and components

- **WHEN** the tool records a snapshot to the history file
- **THEN** the file gains one row for the whole-tree total (`dimension = total`)
- **AND** one row for each role present in the catalogue (`dimension = role`)
- **AND** one row for each component present in the catalogue (`dimension = component`)
- **AND** every row of that snapshot shares one `timestamp` and one `commit`
- **AND** each row's `files` and `loc` equal the counts the catalogue reports for that
  `dimension`/`key` pair

#### Scenario: The history format is stable across role and component churn

- **WHEN** a role or component gains or loses members between two recorded snapshots
- **THEN** the change is reflected as differing rows (added, omitted, or changed values)
  under the same header
- **AND** the CSV header and column meaning are unchanged

### Requirement: Regeneration appends a snapshot only when the metrics change

When the catalogue is regenerated (the same invocation that refreshes
`docs/COMPLEXITY.md`), the tool SHALL append a new snapshot to the history file if and only
if the current metrics differ from the most recently recorded snapshot. If the current
metrics are identical to the last recorded snapshot (comparing the measured aggregates, not
the timestamp), the tool SHALL append nothing, so that repeated regenerations against an
unchanged working tree neither grow the history nor alter it. This preserves the catalogue's
idempotency: running regeneration twice in succession against an unchanged tree leaves both
`docs/COMPLEXITY.md` and `docs/complexity-history.csv` unchanged after the first run. The
tool SHALL narrate whether a snapshot was recorded or skipped, following the
tooling-observability conventions.

#### Scenario: An unchanged tree records no new snapshot

- **WHEN** the catalogue is regenerated twice in succession against an unchanged working
  tree
- **THEN** the first run records at most one snapshot reflecting the current metrics
- **AND** the second run appends no row to `docs/complexity-history.csv`
- **AND** the history file is byte-identical before and after the second run

#### Scenario: Changed metrics record a new snapshot

- **WHEN** the tracked code changes such that a total, role, or component count differs from
  the last recorded snapshot, and the catalogue is regenerated
- **THEN** the tool appends exactly one new snapshot (its group of rows) to the history file
- **AND** the prior snapshots in the history file are left intact
- **AND** the tool's narration reports that a snapshot was recorded

#### Scenario: The history append reuses the computed metrics

- **WHEN** the tool regenerates the catalogue and records a snapshot
- **THEN** it derives the history rows from the same per-file classification it used for the
  `docs/COMPLEXITY.md` tables
- **AND** it requires no tools beyond `git`, a POSIX shell, and `wc`
