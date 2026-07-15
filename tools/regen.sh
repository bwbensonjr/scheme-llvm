#!/usr/bin/env bash
# regen.sh -- Chez-free regeneration of the committed compiler IR (change:
# self-hosting-completion).  This is the standard edit->rebuild loop for a
# developer who changed the compiler source: it needs only LLVM + libgc, no Chez.
#
# Two steps, both Chez-free:
#   1. ASSEMBLE by ordered `cat` (no Chez assembler): the flat source files
#      concatenate into one program per target.  The `*prelude-source*` constant
#      (embed / embed-repl bake the prelude in as data) is produced by a shell
#      escaper (\ -> \\, " -> \", newlines kept literal); the self-hosted reader
#      `rd-string` decodes it back to the exact prelude bytes.
#   2. COMPILE with the SELF-HOSTED `schemec` (the committed compiler, linked from
#      bootstrap/schemec.ll).  Because a compiler-source change means the committed
#      binary is the OLD compiler, we iterate schemec to its byte-identical fixed
#      point (compile source, relink, repeat until stable) before emitting the
#      other artifacts -- so the committed IR is always a self-hosting fixed point.
#
# Output: rewrites bootstrap/{schemec,embed,embed-repl}.ll.  Relinking binaries is
# the Makefile's job (`make regen` runs this then `make all schemec`).
set -eu
cd "$(dirname "$0")/.."

CC="${CC:-/opt/homebrew/opt/llvm@22/bin/clang}"
GC_INC="${GC_INC:-/opt/homebrew/include}"
GC_LIB="${GC_LIB:-/opt/homebrew/lib}"

# Flat core, in concatenation order (this list == the Chez driver's include order).
CORE_FLAT="src/match.scm src/util.scm src/parse.ss \
           src/passes/expand.ss src/passes/recognize-let.ss \
           src/passes/convert-assignments.ss src/passes/convert-closures.ss \
           src/passes/lower.ss src/emit.ss src/core.ss"

mkdir -p build bootstrap

link_schemec () { # <in.ll> <out-binary>
  "$CC" -O2 -DRT_FILTER_MAIN -I"$GC_INC" -L"$GC_LIB" \
        src/runtime/runtime.c "$1" -lgc -o "$2" 2>/dev/null
}

echo "== regen [1/3] assemble flat source (ordered cat; no Chez) =="
# the *prelude-source* constant, baked Chez-free
{ printf '(define *prelude-source* "'
  sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' src/prelude.scm
  printf '")\n'; } > build/prelude-source.scm
# one assembled program per target (entry concatenated last)
cat $CORE_FLAT src/entry-schemec.scm                                > build/schemec.scm
cat $CORE_FLAT build/prelude-source.scm src/entry-embed.scm         > build/embed.scm
cat $CORE_FLAT src/repl-core.ss build/prelude-source.scm src/entry-repl.scm > build/embed-repl.scm
# T = prelude ++ program (schemec is a no-prelude filter, so prepend the prelude)
cat src/prelude.scm build/schemec.scm    > build/T-schemec.scm
cat src/prelude.scm build/embed.scm      > build/T-embed.scm
cat src/prelude.scm build/embed-repl.scm > build/T-embed-repl.scm

echo "== regen [2/3] self-compile schemec to its fixed point (no Chez) =="
if [ ! -f bootstrap/schemec.ll ]; then
  echo "regen: bootstrap/schemec.ll is missing -- cannot bootstrap Chez-free." >&2
  echo "       re-derive it from the genesis path (see historical/genesis/)."   >&2
  exit 1
fi
link_schemec bootstrap/schemec.ll build/schemec        # start from committed IR
converged=0
for i in 1 2 3 4 5; do
  build/schemec < build/T-schemec.scm > build/schemec.ll        # source via current binary
  link_schemec build/schemec.ll build/schemec-next             # binary from that IR
  build/schemec-next < build/T-schemec.scm > build/schemec.ll.check
  if cmp -s build/schemec.ll build/schemec.ll.check; then
    mv build/schemec-next build/schemec                        # the fixed-point compiler
    converged=1
    echo "   schemec fixed point reached (iteration $i)"
    break
  fi
  mv build/schemec-next build/schemec
done
[ "$converged" = 1 ] || { echo "regen: schemec did not converge in 5 iterations" >&2; exit 1; }
cp build/schemec.ll bootstrap/schemec.ll

echo "== regen [3/3] emit embed / embed-repl with the fixed-point schemec =="
build/schemec < build/T-embed.scm      > bootstrap/embed.ll
build/schemec < build/T-embed-repl.scm > bootstrap/embed-repl.ll

echo "regen: committed IR rebuilt Chez-free:"
echo "   bootstrap/schemec.ll     $(wc -c < bootstrap/schemec.ll) bytes"
echo "   bootstrap/embed.ll       $(wc -c < bootstrap/embed.ll) bytes"
echo "   bootstrap/embed-repl.ll  $(wc -c < bootstrap/embed-repl.ll) bytes"
