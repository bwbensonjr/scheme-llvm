#!/usr/bin/env bash
# In-process embedded-runner parity harness (change: path-a-embedding).
#
# For every demo, compare the in-process runner (build/scheme-run: the compiled
# compiler linked into a JIT host, no Chez/clang/lli) against the batch AOT path
# (chez compile.ss + clang).  Asserting runner == AOT for both stdout and
# exit-code parity is the concrete dev->ship fidelity check: what you run
# in-process is what a standalone executable produces.
#
# Run from the repo root: demos/run-embedded.sh
set -u
cd "$(dirname "$0")/.."

# Ensure the runner is up to date (rebuilds embed.ll / relinks if sources changed).
make build/scheme-run 1>&2 || { echo "failed to build build/scheme-run"; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

pass=0; fail=0

check () {  # demo-source
  local src="$1"
  local name; name="$(basename "$src" .scm)"

  # AOT reference: compile + run.
  if ! chez --libdirs src --script src/compile.ss "$src" -o "$TMP/$name" \
        >/dev/null 2>"$TMP/$name.aot.err"; then
    echo "  [FAIL] $name  (AOT compile error)"
    sed 's/^/         /' "$TMP/$name.aot.err"; fail=$((fail+1)); return
  fi
  local aot_out aot_rc
  aot_out="$(timeout 120 "$TMP/$name" 2>/dev/null)"; aot_rc=$?

  # In-process embedded runner.
  local run_out run_rc
  run_out="$(timeout 120 build/scheme-run < "$src" 2>/dev/null)"; run_rc=$?

  # Parity: same stdout, and same success/failure (exit-code zero-ness).
  local aot_ok=$([ "$aot_rc" -eq 0 ] && echo y || echo n)
  local run_ok=$([ "$run_rc" -eq 0 ] && echo y || echo n)
  if [ "$run_out" = "$aot_out" ] && [ "$aot_ok" = "$run_ok" ]; then
    echo "  [OK  ] $name => ${run_out:-<exit $run_rc>}"; pass=$((pass+1))
  else
    echo "  [FAIL] $name"
    echo "         runner => ${run_out:-<exit $run_rc>}"
    echo "         AOT    => ${aot_out:-<exit $aot_rc>}"
    fail=$((fail+1))
  fi
}

echo "in-process embedded runner vs AOT (all demos)"
for src in demos/*.scm; do
  check "$src"
done

echo "-------------------------------------------"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
