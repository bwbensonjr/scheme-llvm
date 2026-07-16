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
. tools/log.sh   # EMIT_LEVEL for quiet-aware banners (see docs/OUTPUT.md)

# The per-suite banner is part of this runner's report (stdout), suppressed at quiet.
banner () {
  [ "${EMIT_LEVEL:-1}" -ge 1 ] || return 0
  echo
  echo "================================================================"
  echo "== $1"
  echo "================================================================"
}

run_suite () {
  local name="$1"; shift
  local start=$SECONDS
  banner "$name"
  if "$@"; then
    SUMMARY+=("  [PASS] $name ($((SECONDS - start))s)")
  else
    SUMMARY+=("  [FAIL] $name ($((SECONDS - start))s)")
    failed=$((failed+1))
  fi
}

SUMMARY=()
failed=0
total_start=$SECONDS

# Build the shipped binaries from committed IR (LLVM only; no Chez).
if ! make all >/dev/null 2>&1; then
  echo "fatal: 'make all' failed (could not link the shipped binaries)"; exit 1
fi

run_suite "demo values (scheme-run)"  env RUNNER=scheme-run demos/run-tests.sh
run_suite "module-scaffold byte-identity" test/module-scaffold-baseline.sh check
run_suite "REPL persistent host"      test/repl-host-tests.sh
run_suite "module vertical-slice (REPL)" test/modules-repl-tests.sh
run_suite "(scheme base) auto-import (REPL)" test/prelude-base-repl-tests.sh
run_suite "(scheme base) re-home (scheme-run/compile)" test/prelude-base-run-tests.sh

echo
echo "================================================================"
echo "== summary (Chez-free default suite)"
echo "================================================================"
printf '%s\n' "${SUMMARY[@]}"
echo
echo "${#SUMMARY[@]} suite(s), $failed failed, $((SECONDS - total_start))s total"
if [ "$failed" -eq 0 ]; then
  echo "all suites passed"
  echo "(run ./run-dev-tests.sh for the Chez-gated backend/self-host/trust-check suites)"
else
  echo "$failed suite(s) failed"
fi
[ "$failed" -eq 0 ]
