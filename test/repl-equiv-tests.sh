#!/usr/bin/env bash
# REPL vs batch equivalence (change: interactive-repl, task 6.2 / backends spec).
# For each program, the value the interactive REPL prints for the LAST form must
# equal the value the whole-program batch (AOT) build prints.  Uses demos that
# are sequences of definitions ending in an expression, with no *mutual* top-
# level recursion (which batch's single letrec allows but the sequential REPL,
# by design, does not).
# Run from the repo root: test/repl-equiv-tests.sh
set -u
cd "$(dirname "$0")/.."

if [ ! -x build/repl-host ]; then
  echo "building host..."; src/repl/build-host.sh >/dev/null || { echo "host build failed"; exit 1; }
fi

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
pass=0; fail=0

check () {  # demo-name
  local name="$1" src="demos/$1.scm"
  # batch AOT: the whole-program value
  if ! chez --libdirs src --script src/compile.ss "$src" -o "$TMP/$name" \
        >/dev/null 2>"$TMP/$name.b.err"; then
    echo "  [FAIL] $name (batch compile error)"; fail=$((fail+1)); return
  fi
  local batch; batch="$("$TMP/$name")"
  # REPL: feed the same forms; the last printed line is the final form's value
  local repl; repl="$(chez --libdirs src --script src/compile.ss --repl < "$src" 2>/dev/null | tail -1)"
  if [ "$batch" = "$repl" ]; then
    echo "  [OK  ] $name  (batch = repl = $batch)"; pass=$((pass+1))
  else
    echo "  [FAIL] $name  batch=$batch  repl=$repl"; fail=$((fail+1))
  fi
}

echo "REPL vs batch equivalence"
for d in fact length countdown derived named-let-loop \
         nary-arith nary-compare eq-not quote-list quote-traverse \
         string-ops string-symbol symbol-eq prelude; do
  check "$d"
done
# NOTE: demos/toplevel.scm is intentionally excluded -- it uses mutual top-level
# recursion (even?/odd?), which the whole-program batch letrec supports but the
# sequential REPL rejects by design (no forward references).  The REPL correctly
# errors on it; that behavior is covered by test/repl-interactive-tests.sh.

echo
echo "  $pass passed, $fail failed"
[ "$fail" -eq 0 ]
