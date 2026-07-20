## Context

`tools/complexity.sh` classifies every git-tracked file into a role, component, and
language, counts lines, and splices Markdown tables into `docs/COMPLEXITY.md` between
BEGIN/END markers. It already computes every aggregate we want to track (whole-tree total,
per-role, per-component) in a temp TSV, and it already narrates on stderr / emits data on
stdout per `docs/OUTPUT.md`. Today those numbers are only ever a snapshot; nothing records
them over time. The `complexity-catalogue` spec requires the tool to be deterministic and
its document regeneration to be idempotent — any history mechanism must not break that.

This change adds a small, append-only history data file and wires a change-gated append into
the existing regeneration path. It touches one script, one new data file, a one-line prose
pointer in `docs/COMPLEXITY.md`, and the skill's instructions.

## Goals / Non-Goals

**Goals:**
- Record the catalogue's total/role/component metrics over time in a versioned, diff-friendly
  data file.
- Reuse the metrics the tool already computes (the per-file TSV) — no second classification
  path, no new dependencies.
- Keep regeneration idempotent: an unchanged tree records nothing on subsequent runs.
- Keep the format robust to roles/components appearing and disappearing.

**Non-Goals:**
- No plotting, dashboard, or analysis tooling — the CSV is the deliverable; reading it is a
  future concern.
- No backfill of historical commits. History starts accumulating from the first run after
  this change lands (one optional seed row for the current commit is acceptable).
- No per-file or per-language history rows in this change (total/role/component only).
- No change to how the Markdown tables themselves are produced.

## Decisions

### Long (tidy) CSV format over wide

`timestamp,commit,dimension,key,files,loc`, one row per aggregate.

- **Why:** Roles and components come and go (e.g. `repo-config` was just added; `nanopass-vendor`
  is gone). A wide format (one column per role/component) would force a schema change and ragged
  historical rows every time the set shifts. Long format absorbs that churn — a vanished
  component simply stops emitting rows; a new one starts. Consumers `filter(dimension, key)`.
- **Alternative considered:** wide format (`timestamp,commit,authored_files,authored_loc,...`).
  Easier to eyeball and plot directly, but brittle against component churn and it buries the
  role/component detail the user asked for. Rejected.
- The whole-tree total is carried as a `dimension = total`, `key = ALL` row so totals are
  queryable the same way as the breakdowns.

### File location: `docs/complexity-history.csv`

Sits beside `docs/COMPLEXITY.md`, the document it derives from. It is data, so it is written
directly (not spliced between markers).

### Append is change-gated, comparing against the last snapshot

Before appending, the tool computes the candidate snapshot's data rows (the
`dimension,key,files,loc` tuples, excluding `timestamp`/`commit`) and compares them as a set
against the rows of the most recent snapshot already in the file (the group sharing the last
file's final timestamp). Identical ⇒ append nothing. Different (or file absent/empty) ⇒
append the full new snapshot.

- **Why compare the measured values, not the timestamp/commit:** the timestamp always differs
  run-to-run, and the working tree can differ from `HEAD` (the tool counts working-tree
  content of tracked files, so a dirty tree has real metrics that may differ from the last
  commit's). Gating on the measured aggregates is the honest "did the numbers move" test and
  is what preserves idempotency.
- **Alternative considered:** upsert one row per commit hash. Rejected — it fights the
  working-tree-vs-HEAD reality, needs in-place rewrite rather than pure append, and the user
  chose change-gating.

### Timestamp and commit provenance

`timestamp` is an ISO 8601 instant from `date` at measurement time (the script is a shell
tool and may call `date`; the determinism requirement constrains the *catalogue tables*, and
the change-gate keeps the CSV idempotent regardless). `commit` is `git rev-parse --short HEAD`.
If a shorter, dependency-free provenance is wanted for a dirty tree, a `-dirty` suffix is an
option to weigh during implementation but is not required by the spec.

### Wiring: always on the regeneration path, gated internally

The append runs whenever the tables are regenerated (the `--write` path invoked by
`make catalogue`), per the user's choice of "always on `make catalogue`." There is no
separate flag; the change-gate is what prevents noise. The plain stdout-only invocation
(`tools/complexity.sh` with no `--write`) SHALL NOT modify any file, including the history —
it stays a pure reporter.

### The history file is excluded from the counted set (RESOLVED)

`docs/complexity-history.csv` is git-tracked, so the catalogue would count it by default —
but it **must not be counted**, and the earlier "measure before append, self-limiting"
reasoning was wrong. Trace it: the gate appends a snapshot only when the metrics differ from
the last recorded snapshot. If the CSV is counted, appending a snapshot grows the CSV's line
count, which changes the `total`/role/component metrics that own the CSV, which makes the
*next* `make catalogue` see changed metrics and append *again* — and so on every run. This is
**non-convergent** and directly violates the new idempotency requirement ("an unchanged tree
records no new snapshot").

**Decision:** exclude `docs/complexity-history.csv` from the counted set entirely (both the
`docs/COMPLEXITY.md` tables and the history snapshot). The catalogue measures the codebase;
the tool's own metrics ledger is instrumentation, not subject matter — a metric that includes
its own bookkeeping is self-referential. With the CSV excluded, changing only the CSV leaves
the measured metrics identical, so the gate appends nothing and the tool converges. This is
the "cleaner cut" the trade-offs section anticipated; the churn is not merely noisy, it never
converges, so exclusion is required, not optional.

This carves a single, documented exception into the existing "every tracked file counted
exactly once" requirement (see the spec delta): the tool's own history data file is the lone
tracked file excluded from the count, for the self-reference reason above.

## Risks / Trade-offs

- **[The history CSV's own growth perturbs the metrics it records]** → If the file were
  counted, each appended snapshot would grow its LOC and trigger another snapshot on the next
  run, never converging (see the RESOLVED decision above). Mitigation: exclude
  `docs/complexity-history.csv` from the counted set. This is now a decided part of the
  implementation, not an open trade-off.
- **[Idempotency regression]** → A bug in the change-gate could append on every run.
  Mitigation: a task-level test that runs regeneration twice against an unchanged tree and
  asserts the CSV is byte-identical after the first run.
- **[Timestamp non-determinism leaks into tests]** → Tests must assert on the gate behavior
  and row *content* (dimension/key/files/loc), never on the exact timestamp.
- **[Snapshot vs commit mismatch on a dirty tree]** → `commit` labels a snapshot that may
  include uncommitted edits. Accepted and documented; the `timestamp` is the authoritative
  "when measured," `commit` is a reference point.

## Migration Plan

Additive. No existing data or behavior is removed. On first `make catalogue` after landing,
the history file is created (or seeded with one snapshot for the current commit) and grows
from there. Rollback is deleting the file and reverting the script hunk; nothing else depends
on it.

## Open Questions

- ~~Should `docs/complexity-history.csv` be counted or excluded?~~ **RESOLVED: excluded** —
  counting it is non-convergent (see the RESOLVED decision).
- Is a `-dirty` marker on the `commit` column worth the small extra logic? (Leaning: no for
  the first cut.)
