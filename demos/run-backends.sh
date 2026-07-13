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

run3_fail () {  # name  source  -- expects a non-zero run under all three exits
  local name="$1" src="$2"
  local arc brc jrc

  if ! $CC "$src" -o "$TMP/${name}_aot" >/dev/null 2>"$TMP/$name.aot.err"; then
    echo "  [FAIL] $name  (aot compile)"; sed 's/^/         /' "$TMP/$name.aot.err"; fail=$((fail+1)); return
  fi
  timeout 90 "$TMP/${name}_aot" >/dev/null 2>&1; arc=$?

  if ! $CC "$src" -o "$TMP/${name}_bc" --backend bitcode >/dev/null 2>"$TMP/$name.bc.err"; then
    echo "  [FAIL] $name  (bitcode compile)"; sed 's/^/         /' "$TMP/$name.bc.err"; fail=$((fail+1)); return
  fi
  timeout 90 "$TMP/${name}_bc" >/dev/null 2>&1; brc=$?

  # JIT compiles and runs in one step; a non-zero program exit makes it fail.
  timeout 90 $CC "$src" -o "$TMP/${name}_jit" --backend jit >/dev/null 2>&1; jrc=$?

  if [ "$arc" -ne 0 ] && [ "$brc" -ne 0 ] && [ "$jrc" -ne 0 ]; then
    echo "  [OK  ] $name => non-zero exit (aot=$arc jit=$jrc bitcode=$brc)"; pass=$((pass+1))
  else
    echo "  [FAIL] $name  aot=$arc jit=$jrc bitcode=$brc  (want all non-zero)"; fail=$((fail+1))
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
run3 narycmp   demos/nary-compare.scm    11111101  # chained < = > <= >=, single-eval
run3 eqnot     demos/eq-not.scm          1100110101  # n-ary eq?/eqv? + not primitive
run3 charintern demos/char-intern.scm    1101111     # interned chars: eq?/eqv? + survive GC
run3 varrest   demos/variadic-rest.scm   "(3 4)"   # dotted rest parameter
run3 varall    demos/variadic-all.scm    "(1 2 3)" # all-args variadic
run3 apply     demos/apply.scm           45        # apply spreads overflow; variadic musttail
run3_fail arityerr demos/arity-error.scm            # arity mismatch aborts under all 3
run3 qsym      demos/quote-symbol.scm    hello         # quoted symbol prints by name
run3 symeq     demos/symbol-eq.scm       "#t"          # interned symbol eq? identity
run3 qlist     demos/quote-list.scm      "(a (b c) 1)" # materialized quoted structure
run3 qtrav     demos/quote-traverse.scm  "(b c)"       # car/cdr over quoted structure
run3 symgc     demos/symbol-gc.scm       "#t"          # intern table survives GC
run3 strlit    demos/string-lit.scm      '"hello"'          # self-evaluating string literal
run3 charlit   demos/char-lit.scm        '#\a'              # self-evaluating char literal
run3 strchar   demos/string-char.scm     '(a "b" #\c)'      # strings/chars in quoted structure
run3 unicode   demos/unicode.scm         '("héllo 日本語" #\λ)'  # UTF-8 round-trip, byte-for-byte
run3 strops    demos/string-ops.scm      '(65 3 #\b "ell" foo)'  # char/string accessors
run3 strsym    demos/string-symbol.scm   '#t'                    # string->symbol interns
run3 struni    demos/string-unicode.scm  '(5 #\é "日本")'         # codepoint indexing, non-ASCII
run3 strchlib  demos/string-char-lib.scm '(#t #f #t #f "foobar" "xxx" (#\a #\b) "héllo")'  # char cmp + string ctor library
run3 prelude   demos/prelude.scm          '(1 4 9 6 5 4)'  # standard library procedures
run3 equallist demos/equal-list.scm       '(1 1 0 ((2) (3)) ("b" . 2) (2 3 4) -6 (1 2 3))'  # equal? + member/assoc/filter/fold
run3 vectors   demos/vectors.scm          '(20 4 99 #t #f #(1 2 3) #t #f 9)'  # vector type: ops + printer + #(...) reader, survives GC under lli
run3 rdlist    demos/reader-list.scm      '(a (b c) 42)'            # reader: nested list
run3 rdatoms   demos/reader-atoms.scm     '(42 hello #t #\z "hi")'  # reader: atom types
run3 rdeq      demos/reader-eq.scm        '#t'                      # reader: interned symbol
run3 rdquote   demos/reader-quote.scm     '(quote x)'               # reader: comment + quote
run3 rdlex     demos/reader-lexical.scm   '(3 9 65 32 10 (a . b) (x y . z))'  # reader: escapes, named chars, dotted pairs
run3 macrouser demos/macro-user.scm       '(3 10 10 11)'            # define-syntax + ellipsis
run3 macrohyg  demos/macro-hygiene.scm    '(2 1 99 5 5)'            # macro hygiene

echo "-------------------------------------------"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
