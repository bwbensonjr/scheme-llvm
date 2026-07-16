#!/usr/bin/env bash
# modules-tests.sh -- Stage 1 module vertical-slice suite (change:
# module-artifacts-vertical-slice).  Chez-GATED: it drives the import-aware AOT
# build path (chez src/compile.ss), which resolves (import (L)) through the
# manifest, compiles each library to a unit .ll + .exports, compiles the program
# against the imports, and links runtime + units + program into one exe.
#
# Covers: AOT import (mylib), own-define shadowing, the two-unit no-collision
# blocker, and the library __init one-shot guard (structural).  The REPL door and
# cross-door byte-identity are exercised by the REPL suites once wired.
#
# Run from the repo root:  test/modules-tests.sh
set -u
cd "$(dirname "$0")/.."
. tools/log.sh

if ! command -v chez >/dev/null 2>&1; then
  echo "chez not found -- skipping module vertical-slice suite."; exit 0
fi

MOD=test/modules
MAN="$MOD/emit-libs.scm"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass=0; fail=0

build () {  # <name> <src>
  chez --libdirs src --script src/compile.ss "$2" --manifest "$MAN" -o "$TMP/$1" \
    >"$TMP/$1.build" 2>&1
}

check () {  # <name> <src> <expected>
  local name="$1" src="$2" want="$3"
  if ! build "$name" "$src"; then
    echo "  [FAIL] $name  (build error)"; sed 's/^/         /' "$TMP/$name.build"; fail=$((fail+1)); return
  fi
  local got; got="$(timeout 30 "$TMP/$name" 2>"$TMP/$name.run")"
  if [ "$got" = "$want" ]; then
    echo "  [OK  ] $name => $got"; pass=$((pass+1))
  else
    echo "  [FAIL] $name => $got  (expected $want)"; fail=$((fail+1))
  fi
}

# assert a build FAILS and its diagnostic matches a regex (change: module-generalize)
check_fail () {  # <name> <src> <manifest> <regex>
  local name="$1" src="$2" man="$3" re="$4"
  if chez --libdirs src --script src/compile.ss "$src" --manifest "$man" -o "$TMP/$name" \
       >"$TMP/$name.build" 2>&1; then
    echo "  [FAIL] $name  (expected build failure, but it succeeded)"; fail=$((fail+1)); return
  fi
  if grep -qE "$re" "$TMP/$name.build"; then
    echo "  [OK  ] $name  (build failed as expected)"; pass=$((pass+1))
  else
    echo "  [FAIL] $name  (failed, but not matching /$re/)"; sed 's/^/         /' "$TMP/$name.build"; fail=$((fail+1))
  fi
}

echo "module vertical-slice (AOT door)"
check aot-import   "$MOD/prog-mylib.scm"  142   # import (mylib); greet -> 142
check aot-shadow   "$MOD/prog-shadow.scm" 7     # own greet shadows the import
check aot-nocollide "$MOD/prog-both.scm"  43    # (liba)+(libb) same-named internals link

echo "generalize: transitive imports, rename, diamond (AOT door)"
check aot-chain    "$MOD/prog-chain.scm"   15   # (chain-a) transitively imports (chain-b)
check aot-rename   "$MOD/prog-rename.scm"  77   # (rename (rename-lib)); importer sees fmap
check aot-diamond  "$MOD/prog-diamond.scm" 35   # (dia-a)+(dia-b) both import (dia-c)

echo "library artifact shape"
# a fresh build populates build/lib; inspect the emitted unit module.
LIB=build/lib/mylib.ll
if [ -f "$LIB" ]; then
  # __init one-shot guard present, and NO scheme_entry in the unit.
  if grep -q 'load i64, ptr @"mylib:__inited"' "$LIB" \
     && grep -q 'define i64 @"mylib:__init"()' "$LIB" \
     && ! grep -q 'scheme_entry' "$LIB"; then
    echo "  [OK  ] init-guard  (guarded @\"mylib:__init\", no @scheme_entry)"; pass=$((pass+1))
  else
    echo "  [FAIL] init-guard  (missing guard / stray scheme_entry in $LIB)"; fail=$((fail+1))
  fi
  # export table maps external name -> mangled symbol.
  if grep -q '(greet . "mylib:greet")' build/lib/mylib.exports; then
    echo "  [OK  ] exports  (greet -> mylib:greet)"; pass=$((pass+1))
  else
    echo "  [FAIL] exports  (bad build/lib/mylib.exports)"; fail=$((fail+1))
  fi
else
  echo "  [FAIL] library artifact  (build/lib/mylib.ll missing)"; fail=$((fail+1))
fi

echo "generalize: artifact shape (rename, transitive, diamond init-once)"
# rename: export table keys the EXTERNAL name, symbol is the INTERNAL name.
if grep -q '(fmap . "rename-lib:%fast-map")' build/lib/rename-lib.exports; then
  echo "  [OK  ] rename-exports  (fmap -> rename-lib:%fast-map)"; pass=$((pass+1))
else
  echo "  [FAIL] rename-exports  (bad build/lib/rename-lib.exports)"; fail=$((fail+1))
fi
# rename: the emitted symbol is the internal name; the external name is NOT a global.
if grep -q 'rename-lib:%fast-map' build/lib/rename-lib.ll \
   && ! grep -q '@"rename-lib:fmap"' build/lib/rename-lib.ll; then
  echo "  [OK  ] rename-symbol  (internal %fast-map emitted, external fmap absent)"; pass=$((pass+1))
else
  echo "  [FAIL] rename-symbol  (wrong symbol in build/lib/rename-lib.ll)"; fail=$((fail+1))
fi
# transitive: chain-a references chain-b's export as an EXTERNAL global it does not define.
if grep -q '@"chain-b:base-val" = external global i64' build/lib/chain-a.ll; then
  echo "  [OK  ] transitive-extern  (chain-a declares @\"chain-b:base-val\" external)"; pass=$((pass+1))
else
  echo "  [FAIL] transitive-extern  (chain-a missing external base-val decl)"; fail=$((fail+1))
fi
# diamond init-once: the program's @scheme_entry calls the shared unit's __init exactly
# once (topo-order dedup); the guard would make even a double call a no-op, but the
# closure is deduplicated so only one call is emitted.
DIA="$TMP/aot-diamond.ll"
if [ -f "$DIA" ]; then
  n="$(grep -c 'call i64 @"dia-c:__init"' "$DIA")"
  if [ "$n" = "1" ]; then
    echo "  [OK  ] diamond-init-once  (one @\"dia-c:__init\" call in @scheme_entry)"; pass=$((pass+1))
  else
    echo "  [FAIL] diamond-init-once  ($n calls to @\"dia-c:__init\", expected 1)"; fail=$((fail+1))
  fi
  # the shared unit still carries its one-shot guard.
  if grep -q 'load i64, ptr @"dia-c:__inited"' build/lib/dia-c.ll; then
    echo "  [OK  ] diamond-guard  (dia-c carries @\"dia-c:__inited\" one-shot guard)"; pass=$((pass+1))
  else
    echo "  [FAIL] diamond-guard  (dia-c missing one-shot guard)"; fail=$((fail+1))
  fi
else
  echo "  [FAIL] diamond artifacts  ($DIA missing)"; fail=$((fail+1))
fi

echo "generalize: errors (cycle, missing library, hidden internal name)"
check_fail cycle   "$MOD/prog-cycle.scm"      "$MOD/emit-libs-cycle.scm" "import cycle"
check_fail missing "$MOD/prog-missing.scm"    "$MAN"                      "not found in manifest"
check_fail hidden  "$MOD/prog-rename-bad.scm" "$MAN"                      "unbound variable.*%fast-map"

echo "generalize: stale-rebuild (reuse fresh, recompile changed)"
# build once so artifacts exist and are fresh.
build sr1 "$MOD/prog-chain.scm" >/dev/null 2>&1
# a second build reuses (no recompile of the unchanged units).
chez --libdirs src --script src/compile.ss "$MOD/prog-chain.scm" --manifest "$MAN" -o "$TMP/sr2" \
  >"$TMP/sr2.build" 2>&1
if grep -q 'reuse (chain-b)' "$TMP/sr2.build" && grep -q 'reuse (chain-a)' "$TMP/sr2.build"; then
  echo "  [OK  ] reuse-fresh  (unchanged units reused)"; pass=$((pass+1))
else
  echo "  [FAIL] reuse-fresh  (expected reuse of chain-a/chain-b)"; sed 's/^/         /' "$TMP/sr2.build"; fail=$((fail+1))
fi
# touch a source; the next build recompiles that unit (and reuses the untouched one).
sleep 1; touch "$MOD/chain-b.sld"
chez --libdirs src --script src/compile.ss "$MOD/prog-chain.scm" --manifest "$MAN" -o "$TMP/sr3" \
  >"$TMP/sr3.build" 2>&1
if grep -q 'compile (chain-b)' "$TMP/sr3.build" && grep -q 'reuse (chain-a)' "$TMP/sr3.build"; then
  echo "  [OK  ] recompile-changed  (touched chain-b recompiled, chain-a reused)"; pass=$((pass+1))
else
  echo "  [FAIL] recompile-changed  (expected chain-b recompile, chain-a reuse)"; sed 's/^/         /' "$TMP/sr3.build"; fail=$((fail+1))
fi

echo "dev->ship fidelity (cross-door byte-identity)"
# The library unit emitted for the AOT door (chez compile.ss, above) must be
# byte-identical to the one the embedded compiler emits for the REPL door.
# build/scheme-run --emit compiles a lone define-library through the SAME core the
# REPL host uses; compare it to the AOT unit (host target header stripped).
if make scheme-run >/dev/null 2>&1; then
  for L in mylib; do
    aot="$TMP/$L.aot.ll"; repl="$TMP/$L.repl.ll"
    grep -v '^target ' "build/lib/$L.ll" > "$aot"
    build/scheme-run --emit < "$MOD/$L.sld" > "$repl" 2>/dev/null
    if diff -q "$aot" "$repl" >/dev/null; then
      echo "  [OK  ] $L unit identical (AOT door == REPL door)"; pass=$((pass+1))
    else
      echo "  [FAIL] $L unit differs across doors"; fail=$((fail+1))
    fi
  done
else
  echo "  [SKIP] cross-door (could not build scheme-run)"
fi

echo "-------------------------------------------"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
