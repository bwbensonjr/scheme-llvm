---
name: complexity-catalogue
description: Refresh docs/COMPLEXITY.md — the catalogue of this repo's code by component, role, and language. Use when the user wants to update the complexity document, re-run the code audit, or see how much authored code there is after changes.
allowed-tools: Bash(make catalogue), Bash(tools/complexity.sh:*), Read, Edit
license: MIT
metadata:
  author: emit
  version: "1.0"
---

Refresh `docs/COMPLEXITY.md`: regenerate the mechanical catalogue tables **and** the
hand-authored interpretation, so the whole document reflects the current tree.

The mechanical tables are produced deterministically by `tools/complexity.sh`; the
"Reading the numbers" prose needs judgment. This skill does both in one pass. If you only
need the tables refreshed (no commentary), `make catalogue` alone suffices — no agent
required.

## Steps

1. **Regenerate the tables.** Run:
   ```sh
   make catalogue
   ```
   This runs `tools/complexity.sh --write`, which classifies every git-tracked file by
   role/component/language and splices fresh tables into `docs/COMPLEXITY.md` between the
   `BEGIN/END GENERATED: complexity-catalogue` markers. Note the authored-subtotal and
   full-tree totals it reports on stderr.

   The same run also appends a timestamped snapshot to `docs/complexity-history.csv` — but
   **only when the metrics changed** from the last recorded snapshot. Watch the stderr for
   either `record docs/complexity-history.csv [+N rows @ <commit>]` (a snapshot was recorded)
   or `docs/complexity-history.csv unchanged -> no snapshot recorded` (numbers unchanged, so
   the history was left alone). This is expected behavior, not an error.

2. **Check for misclassified files.** Look at the generated `By component` table for the
   `other` role or any component that looks wrong (e.g. a new source directory landing in
   `root`/`other`). If found, the fix is a one-line edit to the **classification policy** —
   the single ordered `case` block in `tools/complexity.sh` — then rerun `make catalogue`.
   Do NOT hand-edit the generated block; it will be overwritten.

3. **Read the freshly generated tables** in `docs/COMPLEXITY.md` (the span between the
   markers).

4. **Refresh the interpretation.** Update the `## Reading the numbers` section (which lives
   *outside* the generated markers, so `make catalogue` never touches it) so its claims match
   the current numbers. Keep it about *where the code is* and *what kind it is* — not a
   difficulty ranking. Call out any notable shift since the prose was last written (e.g. an
   authored component that grew substantially, a new large generated/vendored mass, or a file
   that fell into `other`).

5. **Report** the authored subtotal, the full-tree total, whether a new history snapshot was
   recorded (naming `docs/complexity-history.csv` when it was, or noting the metrics were
   unchanged), and any classification fix you made or any `other`/misclassified file the user
   should resolve in the policy.

## Guardrails

- Never edit the generated block by hand — edit the policy in `tools/complexity.sh` and
  regenerate.
- The interpretation prose is authored content; refresh it to match the numbers, don't
  fabricate trends you can't see in the tables.
- LOC is a volume proxy, not a complexity score — keep the commentary honest about that.
