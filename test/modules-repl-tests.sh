#!/usr/bin/env bash
# modules-repl-tests.sh -- Stage 1 module REPL door (change:
# module-artifacts-vertical-slice).  Chez-FREE: drives the shipped build/repl-host,
# which preloads the manifest's libraries into the shared JITDylib and honors
# interactive (import (L)) by merging the unit's exports into the session scope.
#
# Run from the repo root:  test/modules-repl-tests.sh
set -u
cd "$(dirname "$0")/.."
. tools/log.sh

export EMIT_MANIFEST=test/modules/emit-libs.scm
HOST=build/repl-host
make "$HOST" >/dev/null 2>&1 || { echo "failed to build $HOST"; exit 1; }

pass=0; fail=0
# feed <input> and grab the last non-empty stdout line (the final form's value)
run_last () { printf '%s' "$1" | "$HOST" 2>/dev/null | awk 'NF{v=$0} END{print v}'; }

check () {  # <name> <input> <expected-last-value>
  local got; got="$(run_last "$2")"
  if [ "$got" = "$3" ]; then echo "  [OK  ] $1 => $got"; pass=$((pass+1))
  else echo "  [FAIL] $1 => $got  (expected $3)"; fail=$((fail+1)); fi
}

echo "module vertical-slice (REPL door)"
check repl-import   $'(import (mylib))\n(greet)\n'                       142
check repl-both     $'(import (liba))\n(import (libb))\n(+ (a-val) (b-val))\n' 43
check repl-shadow   $'(import (mylib))\n(define (greet) 99)\n(greet)\n'  99

echo "generalize: transitive imports, rename, diamond (REPL door)"
# (chain-a) transitively imports (chain-b); the fixpoint preload loads chain-b first
# even though the manifest lists chain-a earlier (topological, not manifest, order).
check repl-chain    $'(import (chain-a))\n(a-plus)\n'                    15
check repl-rename   $'(import (rename-lib))\n(fmap)\n'                   77
# diamond: (dia-a) and (dia-b) both import (dia-c); loaded/initialized once each.
check repl-diamond  $'(import (dia-a))\n(import (dia-b))\n(+ (a-val) (b-val))\n' 35

# a renamed export exposes only its EXTERNAL name; the internal name stays unbound.
echo "rename hides the internal name (REPL door)"
rerr="$(printf '(import (rename-lib))\n(%%fast-map)\n' | "$HOST" 2>&1 >/dev/null)"
rval="$(printf '(import (rename-lib))\n(fmap)\n' | "$HOST" 2>/dev/null | awk 'NF{v=$0}END{print v}')"
if echo "$rerr" | grep -q "unbound variable %fast-map" && [ "$rval" = "77" ]; then
  echo "  [OK  ] rename-hides-internal  (fmap => 77, %fast-map unbound)"; pass=$((pass+1))
else
  echo "  [FAIL] rename-hides-internal  (fmap=$rval; internal name should be unbound)"; fail=$((fail+1))
fi

# an imported name is unbound until imported; the session must survive the error.
echo "unbound-before-import (session survives)"
errout="$(printf '(greet)\n(+ 2 3)\n' | "$HOST" 2>&1 >/dev/null)"   # stderr only
valout="$(printf '(greet)\n(+ 2 3)\n' | "$HOST" 2>/dev/null)"        # stdout only
if echo "$errout" | grep -q "unbound variable greet" && echo "$valout" | grep -qx "5"; then
  echo "  [OK  ] unbound-then-continue"; pass=$((pass+1))
else
  echo "  [FAIL] unbound-then-continue"; fail=$((fail+1))
fi

echo "-------------------------------------------"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
