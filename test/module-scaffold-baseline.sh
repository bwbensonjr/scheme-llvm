#!/usr/bin/env bash
# module-scaffold-baseline.sh -- byte-identity guard for Modules v0 Stage 0
# (change: module-resolution-scaffold).
#
# The scaffolding (typed-scope resolver + unit-parameterized symbol naming) MUST
# NOT change the LLVM IR emitted for any library-free program (spec: "Scaffolding
# preserves emitted IR").  This harness compiles every demos/*.scm through the
# shipped Chez-free front half (build/scheme-run --emit) and checks the emitted
# IR against a recorded reference.
#
# Modes:
#   capture DIR   compile every demo to DIR/<name>.ll (a raw IR snapshot)
#   manifest      print "<sha256>  <name>" for every demo's emitted IR (sorted)
#   check         recompute the manifest and diff it against the committed
#                 reference (test/module-scaffold-baseline.sha256); nonzero on drift
#
# `check` (also the default, so the suite can call it argument-free) is the
# re-checkable regression guard.  The pre/post byte-identity for the change
# itself was proven by capturing a pristine DIR and diffing a post-change
# capture against it (design D3); `check` keeps the guarantee live afterwards.
#
# Needs LLVM 22 + libgc (to link build/scheme-run); no Chez.  Run from anywhere.
set -u
cd "$(dirname "$0")/.."
. tools/log.sh   # say/vsay + EMIT_VERBOSITY (see docs/OUTPUT.md)

RUNNER=build/scheme-run
REF=test/module-scaffold-baseline.sha256

# The shipped Chez-free front half emits the exact IR the JIT path would run.
ensure_runner () {
  make scheme-run >/dev/null 2>&1 || { echo "fatal: could not build $RUNNER"; exit 1; }
}

demos () { ls demos/*.scm | sort; }

# emit one demo's IR to stdout; abort loudly if the compile fails.
emit_one () {  # <src>
  local src="$1"
  if ! "$RUNNER" --emit < "$src"; then
    echo "fatal: emit failed for $src" >&2
    return 1
  fi
}

do_capture () {  # <dir>
  local dir="$1"
  [ -n "$dir" ] || { echo "usage: $0 capture DIR" >&2; exit 2; }
  mkdir -p "$dir"
  ensure_runner
  local n=0
  for src in $(demos); do
    local name; name="$(basename "$src" .scm)"
    emit_one "$src" > "$dir/$name.ll" || exit 1
    n=$((n + 1))
  done
  say "captured $n demo IR snapshot(s) -> $dir"
}

do_manifest () {  # -> stdout: "<sha256>  <name>" per demo, sorted by name
  ensure_runner
  for src in $(demos); do
    local name; name="$(basename "$src" .scm)"
    local sum; sum="$(emit_one "$src" | shasum -a 256 | awk '{print $1}')" || exit 1
    printf '%s  %s\n' "$sum" "$name"
  done
}

do_check () {
  if [ ! -f "$REF" ]; then
    echo "fatal: reference manifest $REF is missing (run '$0 manifest > $REF')" >&2
    exit 1
  fi
  local tmp; tmp="$(mktemp)"
  do_manifest > "$tmp"
  if diff -u "$REF" "$tmp"; then
    rm -f "$tmp"
    say "byte-identity OK: $(wc -l < "$REF" | tr -d ' ') demo IR hashes match $REF"
  else
    rm -f "$tmp"
    echo "FAIL: emitted demo IR drifted from $REF (see diff above)" >&2
    exit 1
  fi
}

case "${1:-check}" in
  capture)  do_capture "${2:-}" ;;
  manifest) do_manifest ;;
  check)    do_check ;;
  *) echo "usage: $0 {capture DIR|manifest|check}" >&2; exit 2 ;;
esac
