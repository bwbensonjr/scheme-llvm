#!/usr/bin/env bash
# End-to-end test harness (task 1.3): compile each demo, run it, compare stdout
# to the expected value. Run from the repo root: demos/run-tests.sh
set -u
cd "$(dirname "$0")/.."

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

pass=0; fail=0

check () {  # name  source  expected
  local name="$1" src="$2" want="$3"
  if ! chez --libdirs src --script src/compile.ss "$src" -o "$TMP/$name" >/dev/null 2>"$TMP/$name.err"; then
    echo "  [FAIL] $name  (compile error)"; sed 's/^/         /' "$TMP/$name.err"; fail=$((fail+1)); return
  fi
  local got; got="$(timeout 60 "$TMP/$name")"
  if [ "$got" = "$want" ]; then
    echo "  [OK  ] $name => $got"; pass=$((pass+1))
  else
    echo "  [FAIL] $name => $got  (expected $want)"; fail=$((fail+1))
  fi
}

echo "core-lambda-slice demos"
check fact      demos/fact.scm      120
check length    demos/length.scm    3
check counter   demos/counter.scm   3
check countdown demos/countdown.scm 999   # 10M tail iterations in bounded stack
check toplevel  demos/toplevel.scm  102   # multi-define program (letrec desugar)
check derived   demos/derived.scm   180   # cond/and/or/when/unless/let*/named-let
check namedloop demos/named-let-loop.scm 42  # named-let tail loop, bounded stack
check naryarith demos/nary-arith.scm 43  # n-ary + - *, unary negation, identities

echo "-------------------------------------------"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
