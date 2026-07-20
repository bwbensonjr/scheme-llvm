## 1. History-file emit in the catalogue tool

- [x] 1.1 In `tools/complexity.sh`, add a step that derives the current snapshot's history
      rows (`dimension,key,files,loc` for `total`/`ALL`, each role, each component) from the
      existing per-file TSV — reuse the same awk aggregation the tables use; do not
      re-classify.
- [x] 1.2 Capture the snapshot provenance: `timestamp` from `date` in ISO 8601 and `commit`
      from `git rev-parse --short HEAD`. Keep them out of the change-comparison.
- [x] 1.3 Define the history file path (`docs/complexity-history.csv`) and header
      (`timestamp,commit,dimension,key,files,loc`) as named constants near the existing
      `DOC`/marker constants.

## 2. Change-gated append

- [x] 2.1 Implement reading the most recent recorded snapshot from the history file: the
      group of rows sharing the last non-header line's timestamp. Handle a missing or
      header-only file as "no prior snapshot."
- [x] 2.2 Compare the candidate snapshot's measured tuples (`dimension,key,files,loc`, sorted,
      timestamp/commit excluded) against the last recorded snapshot's tuples.
- [x] 2.3 If identical, append nothing and narrate a skip; if different (or no prior
      snapshot), append the full candidate snapshot and narrate that a snapshot was recorded.
      Create the file with its header when absent.
- [x] 2.4 Wire the append into the `--write` path only (invoked by `make catalogue`); ensure
      the stdout-only invocation (no `--write`) writes no files, including the history file.

## 3. Self-classification and docs

- [x] 3.1 Exclude `docs/complexity-history.csv` from the counted set (skip it in the
      git-tracked-file loop) with a comment explaining the self-reference/convergence reason;
      no classification rule is added since the file is never classified.
- [x] 3.2 Add a one-line pointer to `docs/complexity-history.csv` in the hand-authored prose
      of `docs/COMPLEXITY.md` (outside the generated markers).

## 4. Skill update

- [x] 4.1 Update `.claude/skills/complexity-catalogue/SKILL.md` so the workflow notes that
      regeneration records a history snapshot when metrics change.
- [x] 4.2 Update the skill's closing "Report" step to state whether a new snapshot row was
      recorded (and name the history file when it was).

## 5. Verification

- [x] 5.1 Idempotency test: run regeneration twice against an unchanged tree; assert
      `docs/complexity-history.csv` is byte-identical after the first run (no second row) and
      that `docs/COMPLEXITY.md` is likewise unchanged.
- [x] 5.2 Change test: alter a tracked file's line count, regenerate, and assert exactly one
      new snapshot (a group of rows) is appended with the expected `dimension`/`key`/`files`/
      `loc` values and a shared timestamp/commit, prior rows intact.
- [x] 5.3 Confirm narration/data discipline: history file contains only data; the
      recorded/skipped narration appears on stderr and respects `EMIT_VERBOSITY`.
- [x] 5.4 Run `make catalogue`, review the resulting first real snapshot in
      `docs/complexity-history.csv`, and confirm the catalogue's own tables still classify the
      new CSV file as intended.
