#!/usr/bin/env bash
# Spike (change: self-hosting-completion, task 1): prove the FLATTENED source,
# assembled by ordered `cat` (no Chez assembler), still reaches the byte-identical
# self-hosting fixed point (stage-2 == stage-3) when run through the current
# Chez-built `schemec`.
#
# Flat assembly order (mirrors tools/assemble-core.ss, minus the Chez munging):
#   match.scm util.scm  <- flat, %-renamed / de-library'd (this dir)
#   src/passes/... emit.ss parse.ss  <- verbatim pass files (real src/)
#   core-flat.scm  <- core.ss with includes dropped + reader unified (this dir)
#   entry-schemec.scm  <- the stdin->stdout filter entry (this dir)
# T = prelude ++ (that assembled core).
set -u
cd "$(dirname "$0")/../.."   # repo root

CC="${CC:-/opt/homebrew/opt/llvm@22/bin/clang}"
GC_INC="${GC_INC:-/opt/homebrew/include}"
GC_LIB="${GC_LIB:-/opt/homebrew/lib}"
D=spike/flatten

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

link_schemec () { # <in.ll> <out-binary>
  "$CC" -O2 -DRT_FILTER_MAIN -I"$GC_INC" -L"$GC_LIB" \
        src/runtime/runtime.c "$1" -lgc -o "$2" 2>/dev/null
}

echo "flatten spike: cat-assembled flat source -> fixed point"

echo "  [1/6] build current (Chez) schemec"
if ! make build/schemec >/dev/null 2>&1; then
  echo "  [FAIL] make build/schemec failed"; exit 1
fi

echo "  [2/6] cat flat source -> assembled schemec program (no Chez)"
# ordered concatenation == the whole "assembly" step
cat "$D/match.scm" "$D/util.scm" \
    src/parse.ss \
    src/passes/expand.ss src/passes/recognize-let.ss \
    src/passes/convert-assignments.ss src/passes/convert-closures.ss \
    src/passes/lower.ss src/emit.ss \
    "$D/core-flat.scm" \
    "$D/entry-schemec.scm" > "$work/schemec-flat.scm"
# T = prelude ++ assembled core+entry (schemec is a no-prelude filter)
cat src/prelude.scm "$work/schemec-flat.scm" > "$work/T.scm"

echo "  [3/6] stage-2 = schemec1(T_flat)"
if ! build/schemec < "$work/T.scm" > "$work/s2.ll" 2>/dev/null; then
  echo "  [FAIL] current schemec failed to compile the flat T"; exit 1
fi

echo "  [4/6] build schemec2 from stage-2 IR"
if ! link_schemec "$work/s2.ll" "$work/schemec2"; then
  echo "  [FAIL] could not link schemec2 from stage-2 IR"; exit 1
fi

echo "  [5/6] stage-3 = schemec2(T_flat)"
if ! "$work/schemec2" < "$work/T.scm" > "$work/s3.ll" 2>/dev/null; then
  echo "  [FAIL] schemec2 failed to compile the flat T"; exit 1
fi

echo "  [6/6] compare stage-2 vs stage-3"
s2b="$(wc -c < "$work/s2.ll" | tr -d ' ')"
s3b="$(wc -c < "$work/s3.ll" | tr -d ' ')"
if diff -q "$work/s2.ll" "$work/s3.ll" >/dev/null; then
  echo "  [OK  ] stage-2 == stage-3 (byte-identical, ${s2b} bytes) -- FIXED POINT"
  echo "  flatten spike PASSED"
  exit 0
else
  n="$(diff "$work/s2.ll" "$work/s3.ll" | grep -c '^[<>]')"
  echo "  [FAIL] stage-2 (${s2b}b) != stage-3 (${s3b}b): ${n} diff lines"
  echo "  flatten spike FAILED -- flattening perturbed the fixed point"
  exit 1
fi
