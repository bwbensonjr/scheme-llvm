## Why

The complexity catalogue reports a point-in-time snapshot of how much code the project
maintains, but nothing records how that snapshot moves over time. We want to see whether
authored code, tracking history, and generated IR are growing or shrinking across commits
without hand-diffing regenerated docs. Persisting each regeneration's metrics as a row in a
versioned data file gives us that trend for free, using the numbers the catalogue tool
already computes.

## What Changes

- Add a versioned, append-only metrics-history data file (`docs/complexity-history.csv`) in
  a stable long format: `timestamp,commit,dimension,key,files,loc`. Each regeneration that
  changes the numbers contributes one snapshot — a group of rows sharing a timestamp and
  commit covering the whole-tree total, each role, and each component.
- Extend the catalogue tool (`tools/complexity.sh`) so that regenerating the catalogue also
  appends the current snapshot to the history file. The append is **change-gated**: if the
  metrics are identical to the most recently recorded snapshot, no row is written, so
  repeated regenerations against an unchanged tree remain idempotent.
- The append is wired into the existing regeneration path — running `make catalogue` records
  a snapshot when (and only when) the numbers have moved. No separate flag or target.
- Update the `complexity-catalogue` skill so its workflow and its closing report acknowledge
  the history file (note whether a new snapshot row was recorded, and report the file when
  metrics changed).
- Ensure the history file and any new emitted narration conform to the tooling-observability
  output conventions, and that the history file itself is classified sensibly by the
  catalogue's own policy rather than falling into `other`.

## Capabilities

### New Capabilities
<!-- None. This extends the existing catalogue capability. -->

### Modified Capabilities
- `complexity-catalogue`: adds requirements for persisting a timestamped metrics-history data
  file and for the change-gated (idempotent) append performed during regeneration.

## Impact

- **Code**: `tools/complexity.sh` (new snapshot-emit + change-gated append logic); the
  classification policy within it (to classify the new CSV data file).
- **Docs / data**: new `docs/complexity-history.csv`; `docs/COMPLEXITY.md` gains a short
  pointer to the history file (in hand-authored prose, outside the generated markers).
- **Tooling**: the `.claude/skills/complexity-catalogue` skill instructions and its
  reporting step.
- **Build**: no new dependencies — still `git`, POSIX shell, and `wc`; the append reuses the
  metrics the tool already computes.
