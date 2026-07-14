#!/usr/bin/env bash
# Aggregate test runner: invokes every harness in the project in one shot and
# prints a roll-up.  This is the single entry point for "run the full set"; the
# individual harnesses under demos/ and test/ remain runnable on their own.
# Needs chez, system clang, libgc, and (for JIT/bitcode/REPL) LLVM 22 at
# /opt/homebrew/opt/llvm@22.  Run from anywhere: ./run-all-tests.sh
set -u
cd "$(dirname "$0")"

# name  command...  (name is the roll-up label; the rest is run verbatim)
run_suite () {
  local name="$1"; shift
  echo
  echo "================================================================"
  echo "== $name"
  echo "================================================================"
  if "$@"; then
    SUMMARY+=("  [PASS] $name")
  else
    SUMMARY+=("  [FAIL] $name")
    failed=$((failed+1))
  fi
}

SUMMARY=()
failed=0

run_suite "demo values (AOT)"        demos/run-tests.sh
run_suite "backend equivalence"      demos/run-backends.sh
run_suite "expander units"           chez --libdirs src --script test/expander-tests.ss
run_suite "read-all reader"          chez --libdirs src --script test/read-all-tests.ss
run_suite "REPL front-end units"     chez --libdirs src --script test/repl-frontend.ss
run_suite "REPL persistent host"     test/repl-host-tests.sh
run_suite "REPL interactive (--repl)" test/repl-interactive-tests.sh
run_suite "REPL vs batch equivalence" test/repl-equiv-tests.sh
run_suite "REPL persistent-globals batch" test/repl-batch-tests.sh

echo
echo "================================================================"
echo "== summary"
echo "================================================================"
printf '%s\n' "${SUMMARY[@]}"
echo
if [ "$failed" -eq 0 ]; then
  echo "all suites passed"
else
  echo "$failed suite(s) failed"
fi
[ "$failed" -eq 0 ]
