#!/usr/bin/env bash
# DEVELOPER / CI test runner -- Chez-GATED (change: self-hosting-completion, D5/D6).
#
# This suite answers "does the SOURCE still build correctly and reproduce the
# committed binaries?".  It runs the suites that need Chez as an independent host
# or exercise compiler internals the shipped binaries don't expose:
#   * backend equivalence (AOT/JIT/bitcode) and demo values via the Chez AOT path
#   * IL-level unit tests (expander, read-all reader, REPL front-end, batch)
#   * process-I/O primitives
#   * self-emission equivalence (schemec IR == Chez-hosted IR)
#   * self-hosting fixed point + independent-host re-derivation of committed IR
#   * embedded runner vs AOT parity
#   * the anti-stale TRUST-CHECK: `make regen` must reproduce the committed IR
#
# If `chez` is not on PATH the whole suite is SKIPPED (exit 0) -- a Chez-less
# machine builds and tests via ./run-all-tests.sh.  Run from anywhere:
# ./run-dev-tests.sh
set -u
cd "$(dirname "$0")"

if ! command -v chez >/dev/null 2>&1; then
  echo "chez not found -- skipping the Chez-gated developer/CI suite."
  echo "(the Chez-free default suite is ./run-all-tests.sh)"
  exit 0
fi

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

run_suite "demo values (AOT/chez)"      env RUNNER=aot demos/run-tests.sh
run_suite "backend equivalence"         demos/run-backends.sh
run_suite "expander units"              chez --libdirs src --script test/expander-tests.ss
run_suite "read-all reader"             chez --libdirs src --script test/read-all-tests.ss
run_suite "process-I/O primitives"      test/io-primitives-tests.sh
run_suite "self-emission equivalence"   bash -c 'make build/schemec >/dev/null 2>&1 && test/self-emit-equiv.sh'
run_suite "self-hosting fixed point"    test/self-host-fixpoint.sh
run_suite "embedded runner vs AOT"      demos/run-embedded.sh
run_suite "REPL front-end units"        chez --libdirs src --script test/repl-frontend.ss
run_suite "REPL interactive (--repl)"   test/repl-interactive-tests.sh
run_suite "REPL vs batch equivalence"   test/repl-equiv-tests.sh
run_suite "REPL persistent-globals batch" test/repl-batch-tests.sh
run_suite "anti-stale trust-check"      test/trust-check.sh

echo
echo "================================================================"
echo "== summary (Chez-gated developer/CI suite)"
echo "================================================================"
printf '%s\n' "${SUMMARY[@]}"
echo
if [ "$failed" -eq 0 ]; then
  echo "all suites passed"
else
  echo "$failed suite(s) failed"
fi
[ "$failed" -eq 0 ]
