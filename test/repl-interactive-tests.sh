#!/usr/bin/env bash
# End-to-end tests for the interactive REPL driver (change: interactive-repl,
# Group 5): `compile.ss --repl` driving build/repl-host as a co-process.  Feeds a
# scripted session on stdin and checks the values echoed on stdout (prompts and
# diagnostics go to stderr, so stdout is values only).
# Run from the repo root: test/repl-interactive-tests.sh
set -u
cd "$(dirname "$0")/.."

if [ ! -x build/repl-host ]; then
  echo "building host..."; src/repl/build-host.sh >/dev/null || { echo "host build failed"; exit 1; }
fi

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
pass=0; fail=0

check () {  # name  flags  expected-newline-joined  <<session
  local name="$1" flags="$2" want="$3"
  local got
  got="$(chez --libdirs src --script src/compile.ss --repl $flags 2>/dev/null)"
  if [ "$got" = "$want" ]; then
    echo "  [OK  ] $name"; pass=$((pass+1))
  else
    echo "  [FAIL] $name"
    echo "         got:  $(printf '%s' "$got" | tr '\n' '|')"
    echo "         want: $(printf '%s' "$want" | tr '\n' '|')"
    fail=$((fail+1))
  fi
}

echo "interactive REPL end-to-end tests"

# --- core model, no prelude (fast) ---
check earlier-define --no-prelude "$(printf '41\n42')" <<'EOF'
(define x 41)
(+ x 1)
EOF

check redefinition --no-prelude "$(printf '1\n2\n4')" <<'EOF'
(define y 1)
(define y 2)
(+ y y)
EOF

check heap-persist --no-prelude "$(printf '(1 . 2)\n1')" <<'EOF'
(define p (cons 1 2))
(car p)
EOF

check error-recovery --no-prelude "$(printf '#<procedure>\n25\n36')" <<'EOF'
(define (sq n) (* n n))
(sq 5)
(nope 1)
(sq 6)
EOF

check arity-trap-survives --no-prelude "$(printf '#<procedure>\n!trap: arity error: expected 1 argument(s), got 2\n81')" <<'EOF'
(define (f n) (* n n))
(f 1 2)
(f 9)
EOF

# spec: forward references are rejected (a referenced to b before b exists),
# and the session recovers so later forms work
check forward-ref-rejected --no-prelude "$(printf '10\n11')" <<'EOF'
(define a (+ b 1))
(define b 10)
(+ b 1)
EOF

# spec: interned symbols stay eq? across forms (shared symbol table)
check symbol-eq-persist --no-prelude "$(printf 'foo\n#t')" <<'EOF'
(define s (quote foo))
(eq? s (quote foo))
EOF

# --- with prelude: macros, library, user macros, the in-language reader ---
check cond-macro "" "$(printf '#<procedure>\nneg\npos')" <<'EOF'
(define (classify n) (cond ((< n 0) (quote neg)) (else (quote pos))))
(classify -3)
(classify 7)
EOF

check library-map "" "$(printf '(1 4 9 16)')" <<'EOF'
(map (lambda (x) (* x x)) (quote (1 2 3 4)))
EOF

# define-syntax acknowledges on stderr; stdout carries only the two values
check user-macro "" "$(printf '42\n10')" <<'EOF'
(define-syntax twice (syntax-rules () ((_ e) (+ e e))))
(twice 21)
(twice 5)
EOF

check in-language-reader "" "$(printf '(a (b c) 42)')" <<'EOF'
(read-from-string "(a (b c) 42)")
EOF

# spec: end-of-input ends the session cleanly (exit code 0)
printf '(+ 1 2)\n' | chez --libdirs src --script src/compile.ss --repl --no-prelude >/dev/null 2>&1
if [ "$?" -eq 0 ]; then
  echo "  [OK  ] eof-clean-exit"; pass=$((pass+1))
else
  echo "  [FAIL] eof-clean-exit (nonzero exit on EOF)"; fail=$((fail+1))
fi

echo
echo "  $pass passed, $fail failed"
[ "$fail" -eq 0 ]
