#!/usr/bin/env bash
# DEFAULT test runner -- Chez-FREE (change: self-hosting-completion, design D5).
#
# This suite answers "do the SHIPPED binaries work?".  Every suite here exercises
# a binary linked from the committed IR with LLVM only (no Chez): the demos run
# through build/scheme-run (compile+run in one process), the interactive REPL runs
# through build/repl-host.  No Chez process is invoked.
#
# The Chez-bound suites -- "does the source still build correctly and reproduce
# the committed binaries?" (backend equivalence, self-emission/fixed-point,
# IL-level unit tests, the anti-stale trust-check) -- live in ./run-dev-tests.sh,
# which auto-skips when `chez` is absent.
#
# Needs LLVM 22 at /opt/homebrew/opt/llvm@22, system clang, and libgc.
# Run from anywhere: ./run-all-tests.sh
set -u
cd "$(dirname "$0")"

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

# Build the shipped binaries from committed IR (LLVM only; no Chez).
if ! make all >/dev/null 2>&1; then
  echo "fatal: 'make all' failed (could not link the shipped binaries)"; exit 1
fi

run_suite "demo values (scheme-run)"  env RUNNER=scheme-run demos/run-tests.sh
run_suite "REPL persistent host"      test/repl-host-tests.sh

echo
echo "================================================================"
echo "== summary (Chez-free default suite)"
echo "================================================================"
printf '%s\n' "${SUMMARY[@]}"
echo
if [ "$failed" -eq 0 ]; then
  echo "all suites passed"
  echo "(run ./run-dev-tests.sh for the Chez-gated backend/self-host/trust-check suites)"
else
  echo "$failed suite(s) failed"
fi
[ "$failed" -eq 0 ]
