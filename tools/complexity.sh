#!/usr/bin/env bash
# complexity.sh -- catalogue the git-tracked code by component, role, and language.
#
# Enumerates every git-tracked regular file, classifies each by ROLE (what kind of
# code it is), COMPONENT (where it lives / what part of the system it is), and
# LANGUAGE (from its extension), counts its lines, and emits a Markdown catalogue.
#
# The point is NOT the headline line count -- it is the ROLE split: a repo total
# conflates hand-authored complexity (the compiler/runtime/stdlib/tools) with
# generated IR, vendored third-party code, imported reference docs, and OpenSpec
# tracking.  The catalogue reports the authored subtotal and the full total side by
# side so the difference is the deliverable.
#
# Usage (from anywhere; it cd's to the repo root):
#   tools/complexity.sh            # print the generated Markdown block to stdout
#   tools/complexity.sh --write    # splice that block into docs/COMPLEXITY.md
#                                   # between its BEGIN/END GENERATED markers
#
# Output discipline (docs/OUTPUT.md): the Markdown catalogue is machine-consumable
# DATA and goes to stdout; all narration goes to stderr; EMIT_VERBOSITY controls it.
set -eu
cd "$(dirname "$0")/.."
. tools/log.sh

DOC="docs/COMPLEXITY.md"
MARK_BEGIN="<!-- BEGIN GENERATED: complexity-catalogue -->"
MARK_END="<!-- END GENERATED: complexity-catalogue -->"
REGEN_CMD="make catalogue"   # the command a reader runs to refresh the block

# Metrics-history data file: an append-only, long-format CSV recording the catalogue
# totals over time.  One snapshot = a group of rows sharing a timestamp+commit, covering
# the whole-tree total, each role, and each component.  A snapshot is appended (in --write
# mode) only when the measured metrics differ from the last recorded snapshot, so repeated
# regenerations against an unchanged tree stay idempotent.  This file is EXCLUDED from the
# catalogue's own count (see the git-ls-files loop) -- counting a file the tool appends to
# would be self-referential and would never converge.
HIST="docs/complexity-history.csv"
HIST_HEADER="timestamp,commit,dimension,key,files,loc"

WRITE=0
[ "${1:-}" = "--write" ] && WRITE=1

# ===========================================================================
# CLASSIFICATION POLICY -- the one place to edit when code moves.
# ===========================================================================
# classify PATH -> prints "role<TAB>component<TAB>language".
#
# ROLE taxonomy (authored is the headline subtotal):
#   authored  hand-written compiler / runtime / stdlib / build+dev tooling source
#   docs      hand-written project prose (README, docs/, design notes)
#   generated build artifacts checked into the tree (bootstrap/*.ll)
#   vendored  third-party code copied into the tree (none currently)
#   reference external material reproduced for convenience (imported specs, genesis)
#   tracking  OpenSpec changes + specs (process history, not system code)
#   config    agent / editor config (.claude)
#   test      test programs and harnesses
#   demo      example programs under demos/
#   spike     first-party experiments under spike/ (none currently)
#   other     anything the rules do not match (a visible gap to fix, never dropped)
#
# Rules are ORDERED, first match wins -- most specific paths first.
classify() {
  local f="$1" role comp lang
  case "$f" in
    # --- generated / vendored / reference (non-authored, path-specific first) ---
    bootstrap/*.ll)               role=generated; comp="bootstrap-ir" ;;
    # vendored: no third-party code is checked in today (the nanopass copy under
    # spike/ was removed by the retire-spikes change); this rule stays so any future
    # vendored tree classifies consistently.
    spike/nanopass/vendor/*)      role=vendored;  comp="nanopass-vendor" ;;
    docs/r7rs-small.md)           role=reference; comp="reference-docs" ;;
    historical/*)                 role=reference; comp="historical" ;;
    # --- process / tracking / config ---
    openspec/changes/archive/*)   role=tracking;  comp="openspec-archive" ;;
    openspec/*)                   role=tracking;  comp="openspec-active" ;;
    .claude/*)                    role=config;    comp="agent-config" ;;
    .gitignore)                   role=config;    comp="repo-config" ;;
    # --- tests, demos, spikes ---
    test/*)                       role=test;      comp="test" ;;
    run-all-tests.sh|run-dev-tests.sh) role=test; comp="test-harness" ;;
    demos/*)                      role=demo;      comp="demos" ;;
    spike/*)                      role=spike;     comp="spike" ;;
    # --- authored code (compiler, runtime, stdlib, tools, build) ---
    src/runtime/*)                role=authored;  comp="runtime" ;;
    src/passes/*)                 role=authored;  comp="compiler-passes" ;;
    src/*.cpp)                    role=authored;  comp="native-drivers" ;;
    src/*.md)                     role=docs;      comp="docs" ;;
    src/*)                        role=authored;  comp="compiler-core" ;;
    lib/*)                        role=authored;  comp="stdlib" ;;
    tools/*)                      role=authored;  comp="tools" ;;
    Makefile|*.mk)                role=authored;  comp="build" ;;
    emit-libs.scm)                role=authored;  comp="build" ;;
    # --- authored prose ---
    docs/*)                       role=docs;      comp="docs" ;;
    README.md|CLAUDE.md|LLVM.md)  role=docs;      comp="docs" ;;
    # --- fallback: visible, never dropped ---
    *)                            role=other;     comp="root" ;;
  esac
  case "$f" in
    *.scm|*.ss|*.sls|*.sld)       lang="Scheme" ;;
    *.c|*.h)                      lang="C" ;;
    *.cpp|*.cc|*.hpp)             lang="C++" ;;
    *.ll)                         lang="LLVM-IR" ;;
    *.sh)                         lang="Shell" ;;
    *.mk|Makefile)                lang="Make" ;;
    *.md)                         lang="Markdown" ;;
    *.yaml|*.yml)                 lang="YAML" ;;
    *.stex)                       lang="TeX" ;;
    *.bib)                        lang="BibTeX" ;;
    *.pdf)                        lang="Binary" ;;
    *)                            lang="Other" ;;
  esac
  printf '%s\t%s\t%s\n' "$role" "$comp" "$lang"
}

# ROLES that count toward the authored-code subtotal.
authored_role() { case "$1" in authored) return 0 ;; *) return 1 ;; esac; }

# ===========================================================================
# Gather the per-file catalogue into a temp TSV: role, comp, lang, lines, path.
# ===========================================================================
say "catalogue git-tracked files -> $([ $WRITE -eq 1 ] && echo "$DOC" || echo "stdout")"
TSV="$(mktemp)"
trap 'rm -f "$TSV"' EXIT

nfiles=0
while IFS= read -r -d '' f; do
  [ -f "$f" ] || continue
  # The tool's own metrics ledger is instrumentation, not catalogued code: counting a file
  # the tool itself appends to would be self-referential and the history append could never
  # converge (see the HIST comment above).  It is the sole tracked file excluded from the count.
  [ "$f" = "$HIST" ] && continue
  IFS=$'\t' read -r role comp lang < <(classify "$f")
  lines=$(wc -l < "$f" | tr -d ' ')
  printf '%s\t%s\t%s\t%s\t%s\n' "$role" "$comp" "$lang" "$lines" "$f" >> "$TSV"
  nfiles=$((nfiles + 1))
done < <(git ls-files -z)
vsay "classified $nfiles tracked files"

# ===========================================================================
# Render the generated Markdown block to a temp file, then emit or splice it.
# ===========================================================================
BLOCK="$(mktemp)"
trap 'rm -f "$TSV" "$BLOCK"' EXIT

{
  echo "_Generated by \`$REGEN_CMD\` (see \`tools/complexity.sh\`). Do not edit this block by hand;_"
  echo "_edit the classification policy in the script, then regenerate. Prose outside the_"
  echo "_BEGIN/END GENERATED markers is hand-authored and is preserved on regeneration._"
  echo

  # --- Totals -------------------------------------------------------------
  awk -F'\t' '
    { tf++; tl += $4; if ($1 == "authored") { af++; al += $4 } }
    END {
      printf "**Authored code:** %d files, **%d LOC** &nbsp;·&nbsp; ", af, al
      printf "**Full tree:** %d files, %d LOC &nbsp;·&nbsp; ", tf, tl
      printf "authored is %.1f%% of the tree by LOC.\n", (tl ? 100*al/tl : 0)
    }' "$TSV"
  echo

  # --- By role ------------------------------------------------------------
  echo "### By role"
  echo
  echo "| Role | Files | LOC | Authored? |"
  echo "|---|---:|---:|:--:|"
  awk -F'\t' '
    { f[$1]++; l[$1] += $4 }
    END { for (r in l) printf "%s\t%d\t%d\n", r, f[r], l[r] }' "$TSV" \
    | sort -t$'\t' -k3 -rn \
    | awk -F'\t' '{
        mark = ($1 == "authored") ? "✅" : "";
        printf "| %s | %d | %d | %s |\n", $1, $2, $3, mark
      }'
  echo

  # --- By language (whole tree) ------------------------------------------
  echo "### By language (whole tree)"
  echo
  echo "| Language | Files | LOC |"
  echo "|---|---:|---:|"
  awk -F'\t' '
    { f[$3]++; l[$3] += $4 }
    END { for (k in l) printf "%s\t%d\t%d\n", k, f[k], l[k] }' "$TSV" \
    | sort -t$'\t' -k3 -rn \
    | awk -F'\t' '{ printf "| %s | %d | %d |\n", $1, $2, $3 }'
  echo

  # --- By component -------------------------------------------------------
  echo "### By component"
  echo
  echo "| Component | Role | Files | LOC |"
  echo "|---|---|---:|---:|"
  awk -F'\t' '
    { key = $2 SUBSEP $1; f[key]++; l[key] += $4; role[key] = $1; comp[key] = $2 }
    END { for (k in l) printf "%s\t%s\t%d\t%d\n", comp[k], role[k], f[k], l[k] }' "$TSV" \
    | sort -t$'\t' -k4 -rn \
    | awk -F'\t' '{ printf "| %s | %s | %d | %d |\n", $1, $2, $3, $4 }'
  echo

  # --- Authored code: component x language matrix -------------------------
  echo "### Authored code — component × language (LOC)"
  echo
  awk -F'\t' '
    $1 == "authored" {
      cell[$2 SUBSEP $3] += $4
      comps[$2] = 1
      langs[$3] = 1
      crow[$2] += $4
      ccol[$3] += $4
      total += $4
    }
    END {
      nl = 0; for (g in langs) L[++nl] = g
      # sort languages by descending column total (simple insertion sort)
      for (i = 1; i <= nl; i++) for (j = i+1; j <= nl; j++)
        if (ccol[L[j]] > ccol[L[i]]) { t = L[i]; L[i] = L[j]; L[j] = t }
      nc = 0; for (g in comps) C[++nc] = g
      for (i = 1; i <= nc; i++) for (j = i+1; j <= nc; j++)
        if (crow[C[j]] > crow[C[i]]) { t = C[i]; C[i] = C[j]; C[j] = t }

      # header
      hdr = "| Component"; sep = "|---"
      for (i = 1; i <= nl; i++) { hdr = hdr " | " L[i]; sep = sep "|---:" }
      hdr = hdr " | **Total** |"; sep = sep "|---:|"
      print hdr; print sep
      # rows
      for (i = 1; i <= nc; i++) {
        row = "| " C[i]
        for (k = 1; k <= nl; k++) {
          v = cell[C[i] SUBSEP L[k]]
          row = row " | " (v ? v : "")
        }
        row = row " | **" crow[C[i]] "** |"
        print row
      }
      # footer
      ftr = "| **Total**"
      for (k = 1; k <= nl; k++) ftr = ftr " | **" ccol[L[k]] "**"
      ftr = ftr " | **" total "** |"
      print ftr
    }' "$TSV"
} > "$BLOCK"

# --- metrics (stderr) -----------------------------------------------------
metrics="$(awk -F'\t' '
  { tf++; tl += $4; if ($1 == "authored") { af++; al += $4 } }
  END { printf "%d authored LOC (%d files), %d total LOC (%d files)", al, af, tl, tf }' "$TSV")"
say "catalogue: $metrics"

if [ "$WRITE" -eq 0 ]; then
  cat "$BLOCK"
  exit 0
fi

# ===========================================================================
# --write: splice BLOCK into DOC between the markers (idempotent; fail if absent).
# ===========================================================================
[ -f "$DOC" ] || { echo "complexity: $DOC does not exist -- create it with the markers first" >&2; exit 1; }
grep -qF "$MARK_BEGIN" "$DOC" || { echo "complexity: missing '$MARK_BEGIN' marker in $DOC" >&2; exit 1; }
grep -qF "$MARK_END"   "$DOC" || { echo "complexity: missing '$MARK_END' marker in $DOC" >&2; exit 1; }

NEWDOC="$(mktemp)"
trap 'rm -f "$TSV" "$BLOCK" "$NEWDOC"' EXIT
awk -v begin="$MARK_BEGIN" -v end="$MARK_END" -v blockfile="$BLOCK" '
  $0 == begin {
    print; print ""
    while ((getline line < blockfile) > 0) print line
    print ""
    skip = 1
    next
  }
  $0 == end { skip = 0; print; next }
  skip != 1 { print }
' "$DOC" > "$NEWDOC"

if cmp -s "$NEWDOC" "$DOC"; then
  say "$DOC already current -> no change"
else
  cat "$NEWDOC" > "$DOC"
  say "regen $DOC  [$(bytes "$DOC") bytes]"
fi

# ===========================================================================
# --write: append a metrics snapshot to the history CSV, but only when the
# measured metrics differ from the last recorded snapshot (change-gated, so an
# unchanged tree records nothing and the tool stays idempotent).  Reuses the same
# per-file TSV the tables were built from -- no second classification path.
# ===========================================================================
CAND="$(mktemp)"; PREV="$(mktemp)"
trap 'rm -f "$TSV" "$BLOCK" "$NEWDOC" "$CAND" "$PREV"' EXIT

# Candidate snapshot data rows: "dimension,key,files,loc", sorted so the comparison
# and the appended order are order-independent and stable.
awk -F'\t' '
  { tf++; tl += $4; rf[$1]++; rl[$1] += $4; cf[$2]++; cl[$2] += $4 }
  END {
    printf "total,ALL,%d,%d\n", tf, tl
    for (r in rl) printf "role,%s,%d,%d\n", r, rf[r], rl[r]
    for (c in cl) printf "component,%s,%d,%d\n", c, cf[c], cl[c]
  }' "$TSV" | sort > "$CAND"

# Last recorded snapshot: the group of rows sharing the final data line's timestamp,
# reduced to the same "dimension,key,files,loc" shape and sorted.  Empty if the history
# file is absent or header-only.
if [ -f "$HIST" ]; then
  last_ts="$(awk -F, 'NR>1 { ts=$1 } END { print ts }' "$HIST")"
  [ -n "$last_ts" ] && awk -F, -v ts="$last_ts" \
    'NR>1 && $1==ts { print $3","$4","$5","$6 }' "$HIST" | sort > "$PREV"
fi

if [ -s "$PREV" ] && cmp -s "$CAND" "$PREV"; then
  say "$HIST unchanged -> no snapshot recorded"
else
  ts="$(date +%Y-%m-%dT%H:%M:%S%z)"
  commit="$(git rev-parse --short HEAD 2>/dev/null || echo unknown)"
  [ -f "$HIST" ] || printf '%s\n' "$HIST_HEADER" > "$HIST"
  while IFS= read -r row; do
    printf '%s,%s,%s\n' "$ts" "$commit" "$row" >> "$HIST"
  done < "$CAND"
  nrows="$(wc -l < "$CAND" | tr -d ' ')"
  say "record $HIST  [+$nrows rows @ $commit]"
fi
