#!/usr/bin/env bash
# End-to-end tests for the persistent ORC/LLJIT REPL host (change:
# interactive-repl, Group 4).  Each session's top-level forms are emitted as
# separate per-form modules (test/repl-frames.ss) and streamed into the host;
# we check the newline-separated values the host prints.  This exercises real
# incremental persistence: cross-module global resolution, closures called
# across modules, heap survival, and trap isolation.
# Run from the repo root: test/repl-host-tests.sh
set -u
cd "$(dirname "$0")/.."

HOST=build/repl-host
if [ ! -x "$HOST" ]; then
  echo "building host..."; src/repl/build-host.sh >/dev/null || { echo "host build failed"; exit 1; }
fi

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
pass=0; fail=0

check () {  # name  expected-newline-joined  <<forms
  local name="$1" want="$2"
  cat > "$TMP/$name.scm"
  local got
  got="$(chez --libdirs src --script test/repl-frames.ss "$TMP/$name.scm" 2>"$TMP/$name.err" \
           | "$HOST" 2>/dev/null)"
  if [ "$got" = "$want" ]; then
    echo "  [OK  ] $name"; pass=$((pass+1))
  else
    echo "  [FAIL] $name"
    echo "         got:  $(echo "$got" | tr '\n' '|')"
    echo "         want: $(echo "$want" | tr '\n' '|')"
    fail=$((fail+1))
  fi
}

echo "REPL persistent-host end-to-end tests"

check earlier-define "$(printf '41\n42')" <<'EOF'
(define x 41)
(+ x 1)
EOF

check redefinition "$(printf '1\n2\n4')" <<'EOF'
(define y 1)
(define y 2)
(+ y y)
EOF

check cross-module-recursion "$(printf '#<procedure>\n720')" <<'EOF'
(define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))
(fact 6)
EOF

check heap-survival "$(printf '(1 . 2)\n1')" <<'EOF'
(define p (cons 1 2))
(car p)
EOF

check nested-heap "$(printf '(1 . 2)\n((1 . 2) 1 . 2)\n1')" <<'EOF'
(define p (cons 1 2))
(define q (cons p p))
(car (cdr q))
EOF

check symbol-eq-persist "$(printf 'a\nb\n#t')" <<'EOF'
(define s (quote a))
(define t (quote b))
(eq? (quote a) s)
EOF

check trap-isolation "$(printf '#<procedure>\n25\n!trap: arity error: expected 1 argument(s), got 2\n81')" <<'EOF'
(define (f n) (* n n))
(f 5)
(f 1 2)
(f 9)
EOF

echo
echo "  $pass passed, $fail failed"
[ "$fail" -eq 0 ]
