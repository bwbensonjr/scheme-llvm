#!/usr/bin/env bash
# Batch-JIT validation of the persistent-globals REPL model (change:
# interactive-repl, Group 3).  Each SRC treats its top-level forms as separate
# REPL entries; the emitted single module runs them in order via @scheme_entry.
# We build it with clang + the C runtime (AOT path) and check the final value.
# Run from the repo root: test/repl-batch-tests.sh
set -u
cd "$(dirname "$0")/.."

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass=0; fail=0

check () {  # name  expected  <<forms
  local name="$1" want="$2"
  cat > "$TMP/$name.scm"
  if ! chez --libdirs src --script test/repl-batch.ss "$TMP/$name.scm" -o "$TMP/$name.ll" \
        >/dev/null 2>"$TMP/$name.err"; then
    echo "  [FAIL] $name (emit error)"; sed 's/^/         /' "$TMP/$name.err"; fail=$((fail+1)); return
  fi
  if ! clang -I/opt/homebrew/include -L/opt/homebrew/lib src/runtime/runtime.c \
        "$TMP/$name.ll" -lgc -o "$TMP/$name" 2>"$TMP/$name.cc"; then
    echo "  [FAIL] $name (clang error)"; sed 's/^/         /' "$TMP/$name.cc"; fail=$((fail+1)); return
  fi
  local got; got="$(timeout 30 "$TMP/$name")"
  if [ "$got" = "$want" ]; then
    echo "  [OK  ] $name => $got"; pass=$((pass+1))
  else
    echo "  [FAIL] $name => $got  (expected $want)"; fail=$((fail+1))
  fi
}

echo "REPL persistent-globals batch validation"

check earlier-define 42     <<'EOF'
(define x 41)
(+ x 1)
EOF

check redefinition 4        <<'EOF'
(define y 1)
(define y 2)
(+ y y)
EOF

check proc-redef 20         <<'EOF'
(define (f) 10)
(define (f) 20)
(f)
EOF

check recursion 120         <<'EOF'
(define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))
(fact 5)
EOF

check heap-survival 1       <<'EOF'
(define p (cons 1 2))
(car p)
EOF

check nested-heap 1         <<'EOF'
(define p (cons 1 2))
(define q (cons p p))
(car (cdr q))
EOF

check value-redef-old 20    <<'EOF'
(define w 10)
(define w (* w 2))
w
EOF

check build-on-earlier 81   <<'EOF'
(define (square n) (* n n))
(define a (square 9))
a
EOF

echo
echo "  $pass passed, $fail failed"
[ "$fail" -eq 0 ]
