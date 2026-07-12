#!/usr/bin/env bash
# Backend equivalence harness: compile+run each demo through all three exits
# (AOT native, JIT via lli, bitcode->native) and assert identical results.
# This operationalizes LLVM.md's "one frontend, many backends" thesis as a
# standing regression check.  Run from the repo root: demos/run-backends.sh
set -u
cd "$(dirname "$0")/.."

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

CC="chez --libdirs src --script src/compile.ss"
pass=0; fail=0

run3 () {  # name  source  expected
  local name="$1" src="$2" want="$3"
  local aot jit bc

  # AOT: textual IR -> native exe (system clang), then run
  if ! $CC "$src" -o "$TMP/${name}_aot" >/dev/null 2>"$TMP/$name.aot.err"; then
    echo "  [FAIL] $name  (aot compile)"; sed 's/^/         /' "$TMP/$name.aot.err"; fail=$((fail+1)); return
  fi
  aot="$(timeout 90 "$TMP/${name}_aot")"

  # Bitcode: OUT.ll -> OUT.bc -> native exe (LLVM 22 clang), then run
  if ! $CC "$src" -o "$TMP/${name}_bc" --backend bitcode >/dev/null 2>"$TMP/$name.bc.err"; then
    echo "  [FAIL] $name  (bitcode compile)"; sed 's/^/         /' "$TMP/$name.bc.err"; fail=$((fail+1)); return
  fi
  bc="$(timeout 90 "$TMP/${name}_bc")"

  # JIT: driver links the runtime in and runs via lli; its stdout is the value
  jit="$(timeout 90 $CC "$src" -o "$TMP/${name}_jit" --backend jit 2>"$TMP/$name.jit.err")"

  if [ "$aot" = "$want" ] && [ "$jit" = "$want" ] && [ "$bc" = "$want" ]; then
    echo "  [OK  ] $name => $want   (aot = jit = bitcode)"; pass=$((pass+1))
  else
    echo "  [FAIL] $name  aot=$aot jit=$jit bitcode=$bc  (want $want)"; fail=$((fail+1))
  fi
}

echo "backend equivalence (AOT | JIT | bitcode)"
run3 fact      demos/fact.scm           120
run3 length    demos/length.scm         3
run3 counter   demos/counter.scm        3     # GC: closures + boxes under lli
run3 countdown demos/countdown.scm      999   # 10M tail iters: musttail under lli
run3 toplevel  demos/toplevel.scm       102
run3 derived   demos/derived.scm        180
run3 namedloop demos/named-let-loop.scm 42
run3 naryarith demos/nary-arith.scm      43    # n-ary + - *, unary neg, identities

echo "-------------------------------------------"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
