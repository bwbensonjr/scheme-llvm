#!/usr/bin/env bash
# Self-hosting fixed-point (triple) test + independent-host trust-check.
#
# Proves scheme-llvm is self-hosting: the compiler, compiled by itself, compiles
# its own source into a BYTE-IDENTICAL compiler.  Let T = the assembled compiler
# source (prelude ++ flat core ++ schemec entry).  We build three stages:
#
#   stage-1 = chez(T)        IR emitted by the Chez-hosted compiler (compile.ss)
#   schemec1 = link(stage-1) native compiler built from stage-1
#   stage-2 = schemec1(T)    IR emitted by the self-compiled compiler
#   schemec2 = link(stage-2) native compiler built from stage-2
#   stage-3 = schemec2(T)    IR emitted by the twice-self-compiled compiler
#
# The FIXED POINT is  stage-2 == stage-3  (byte-identical): both are produced by
# native, self-compiled binaries running the SAME runtime, so once emission is
# deterministic they converge.  stage-1 (Chez) is NOT required to match stage-2 --
# different host runtimes intern the constant pool in different orders.
#
# INDEPENDENT-HOST TRUST-CHECK (change: self-hosting-completion, design D6): the
# Chez stage-1 here is built from the CURRENT flat source, assembled by ordered
# `cat` (Chez-FREE assembly -- no more tools/assemble-core.ss).  Chez is used only
# as a SECOND, independent host: if its self-hosted fixed point (stage-2) equals
# the committed bootstrap/schemec.ll, then the committed IR is faithfully derived
# from source by two independent hosts ("trusting trust").  This is the genesis
# re-derivation the frozen historical/genesis/ tooling used to provide.
#
# Requires Chez + LLVM 22 + libgc.  Run from the repo root: test/self-host-fixpoint.sh
set -u
cd "$(dirname "$0")/.."

CC="${CC:-/opt/homebrew/opt/llvm@22/bin/clang}"
GC_INC="${GC_INC:-/opt/homebrew/include}"
GC_LIB="${GC_LIB:-/opt/homebrew/lib}"

# Flat core in concatenation order (== the Makefile/regen assembly order).
CORE_FLAT="src/match.scm src/util.scm src/parse.ss \
           src/passes/expand.ss src/passes/recognize-let.ss \
           src/passes/convert-assignments.ss src/passes/convert-closures.ss \
           src/passes/lower.ss src/emit.ss src/core.ss"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

link_schemec () {  # <in.ll> <out-binary>
  "$CC" -O2 -DRT_FILTER_MAIN -I"$GC_INC" -L"$GC_LIB" \
        src/runtime/runtime.c "$1" -lgc -o "$2" 2>/dev/null
}

echo "self-hosting fixed-point (triple) test + independent-host trust-check"

echo "  [1/6] assemble the flat schemec program (ordered cat; no Chez assembler)"
cat $CORE_FLAT src/entry-schemec.scm > "$work/schemec.scm"
# T = prelude ++ program (the native filter gets no prelude of its own).
cat src/prelude.scm "$work/schemec.scm" > "$work/T.scm"

echo "  [2/6] stage-1 = chez(T) via compile.ss (--emit-ir prepends the prelude)"
if ! chez --libdirs src --script src/compile.ss --emit-ir < "$work/schemec.scm" > "$work/s1.ll" 2>/dev/null; then
  echo "  [FAIL] Chez-hosted stage-1 emission failed"; exit 1
fi
if ! link_schemec "$work/s1.ll" "$work/schemec1"; then
  echo "  [FAIL] could not link schemec1 from stage-1 IR"; exit 1
fi

echo "  [3/6] stage-2 = schemec1(T)"
if ! "$work/schemec1" < "$work/T.scm" > "$work/s2.ll" 2>/dev/null; then
  echo "  [FAIL] stage-1 schemec failed to compile T"; exit 1
fi

echo "  [4/6] build schemec2 from stage-2 IR"
if ! link_schemec "$work/s2.ll" "$work/schemec2"; then
  echo "  [FAIL] could not link schemec2 from stage-2 IR"; exit 1
fi

echo "  [5/6] stage-3 = schemec2(T)"
if ! "$work/schemec2" < "$work/T.scm" > "$work/s3.ll" 2>/dev/null; then
  echo "  [FAIL] schemec2 failed to compile T"; exit 1
fi

echo "  [6/6] compare stage-2 vs stage-3, and stage-2 vs committed IR"
fail=0
s2b="$(wc -c < "$work/s2.ll" | tr -d ' ')"
s3b="$(wc -c < "$work/s3.ll" | tr -d ' ')"
if diff -q "$work/s2.ll" "$work/s3.ll" >/dev/null; then
  echo "  [OK  ] stage-2 == stage-3 (byte-identical, ${s2b} bytes) -- FIXED POINT"
else
  n="$(diff "$work/s2.ll" "$work/s3.ll" | grep -c '^[<>]')"
  echo "  [FAIL] stage-2 (${s2b}b) != stage-3 (${s3b}b): ${n} diff lines"
  fail=1
fi

if [ -f bootstrap/schemec.ll ]; then
  if diff -q "$work/s2.ll" bootstrap/schemec.ll >/dev/null; then
    echo "  [OK  ] stage-2 == committed bootstrap/schemec.ll -- INDEPENDENT-HOST re-derivation"
  else
    n="$(diff "$work/s2.ll" bootstrap/schemec.ll | grep -c '^[<>]')"
    echo "  [FAIL] Chez-derived fixed point != committed bootstrap/schemec.ll: ${n} diff lines"
    echo "         (committed IR is not what an independent host reproduces from source)"
    fail=1
  fi
else
  echo "  [WARN] bootstrap/schemec.ll absent -- skipping independent-host check"
fi

echo
if [ "$fail" -eq 0 ]; then echo "  passed"; else echo "  failed"; fi
[ "$fail" -eq 0 ]
