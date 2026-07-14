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

check_fail () {  # name  source   -- expects a clean compile but a non-zero run
  local name="$1" src="$2"
  if ! chez --libdirs src --script src/compile.ss "$src" -o "$TMP/$name" >/dev/null 2>"$TMP/$name.err"; then
    echo "  [FAIL] $name  (compile error)"; sed 's/^/         /' "$TMP/$name.err"; fail=$((fail+1)); return
  fi
  timeout 60 "$TMP/$name" >/dev/null 2>"$TMP/$name.run"; local rc=$?
  if [ "$rc" -ne 0 ]; then
    echo "  [OK  ] $name => exit $rc ($(head -1 "$TMP/$name.run"))"; pass=$((pass+1))
  else
    echo "  [FAIL] $name => exit 0  (expected non-zero, arity error)"; fail=$((fail+1))
  fi
}

echo "core-lambda-slice demos"
check fact      demos/fact.scm      120
check length    demos/length.scm    3
check counter   demos/counter.scm   3
check countdown demos/countdown.scm 999   # 10M tail iterations in bounded stack
check toplevel  demos/toplevel.scm  102   # multi-define program (letrec desugar)
check derived   demos/derived.scm   180   # cond/and/or/when/unless/let*/named-let
check casecxr   demos/case-cxr.scm  1511  # case derived form + cxr combinators (caar..cadar)
check intdef    demos/internal-define.scm '(30 100 105)'  # internal (body) defines, letrec* semantics
check namedloop demos/named-let-loop.scm 42  # named-let tail loop, bounded stack
check naryarith demos/nary-arith.scm 43  # n-ary + - *, unary negation, identities
check narycmp   demos/nary-compare.scm 11111101  # n-ary/chained < = > <= >=, single-eval
check eqnot     demos/eq-not.scm 1100110101  # n-ary eq?/eqv? + not primitive
check charintern demos/char-intern.scm 1101111  # interned chars: eq?/eqv? + survive GC

echo "variadic / apply demos"
check varrest  demos/variadic-rest.scm "(3 4)"   # dotted rest parameter
check varall   demos/variadic-all.scm  "(1 2 3)" # all-args variadic (bare symbol param)
check apply    demos/apply.scm         45        # apply over a list longer than K
check_fail arityerr demos/arity-error.scm        # fixed-arity mismatch aborts non-zero
check_fail errorabort demos/error-abort.scm      # (error ...) aborts non-zero standalone

echo "symbols / quote demos"
check qsym    demos/quote-symbol.scm   hello       # quoted symbol prints by name
check symeq   demos/symbol-eq.scm      "#t"        # interned symbols: eq? identity
check qlist   demos/quote-list.scm     "(a (b c) 1)"  # materialized nested structure
check qtrav   demos/quote-traverse.scm "(b c)"     # car/cdr over quoted structure
check symgc   demos/symbol-gc.scm      "#t"        # intern table survives GC

echo "strings / characters demos"
check strlit  demos/string-lit.scm     '"hello"'          # self-evaluating string literal
check charlit demos/char-lit.scm       '#\a'              # self-evaluating char literal
check strchar demos/string-char.scm    '(a "b" #\c)'      # strings/chars in quoted structure
check unicode demos/unicode.scm        '("héllo 日本語" #\λ)'  # UTF-8 string + char round-trip

echo "string / char operations demos"
check strops  demos/string-ops.scm     '(65 3 #\b "ell" foo)'  # char->integer/length/ref/substring/->symbol
check strsym  demos/string-symbol.scm  '#t'                    # string->symbol interns (eq? to literal)
check struni  demos/string-unicode.scm '(5 #\é "日本")'         # codepoint-indexed ops over non-ASCII
check utf84   demos/utf8-4byte.scm      '("a😀b" grin😀)'         # 4-byte UTF-8 codepoint escaping (emit-cstring-in-language)
check strchlib demos/string-char-lib.scm '(#t #f #t #f "foobar" "xxx" (#\a #\b) "héllo")'  # char cmp + string ctor library
check strmut  demos/string-mutation.scm '("aba" (2 #\é) #\y #\x)'  # string-set! (splice, alias) + string-copy

echo "prelude demos"
check prelude demos/prelude.scm        '(1 4 9 6 5 4)'  # standard library: list/map/reverse/append
check equallist demos/equal-list.scm   '(1 1 0 ((2) (3)) ("b" . 2) (2 3 4) -6 (1 2 3))'  # equal? + member/assoc/filter/fold
check vectors  demos/vectors.scm       '(20 4 99 #t #f #(1 2 3) #t #f 9)'  # vector type + ops + printer + #(...) reader

echo "reader demos"
check rdlist  demos/reader-list.scm    '(a (b c) 42)'         # read a nested list
check rdatoms demos/reader-atoms.scm   '(42 hello #t #\z "hi")'  # each atom type
check rdeq    demos/reader-eq.scm      '#t'                   # read symbol interned (eq? literal)
check rdquote demos/reader-quote.scm   '(quote x)'            # comment skipped + quote sugar
check rdlex   demos/reader-lexical.scm '(3 9 65 32 10 (a . b) (x y . z))'  # escapes, named chars, dotted pairs
check rdall   demos/read-all.scm '(((define x 1) (define y 2) (+ x y)) ((define a 1) (b c)) ())'  # read-all-from-string: whole-program read

echo "macro demos"
check macrouser demos/macro-user.scm    '(3 10 10 11)'  # define-syntax: swap!/ellipsis/my-let
check macrohyg  demos/macro-hygiene.scm '(2 1 99 5 5)'  # hygiene: introduced temps don't capture

echo "quasiquote demos"
check qqunq   demos/qq-unquote.scm '(a 2 b)'    # `,x unquote splices a value
check qqspl   demos/qq-splice.scm  '(0 1 2 3)'  # `,@ys unquote-splicing -> append
check qqplain demos/qq-plain.scm   '(a b c)'    # quasiquote, no unquotes -> constant
check qqnest  demos/qq-nested.scm  a            # nested quasiquote left intact

echo "-------------------------------------------"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
