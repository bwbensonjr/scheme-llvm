#!/usr/bin/env bash
# toolchain.sh -- single source of truth for locating the external LLVM 22 and
# Boehm libgc toolchain across hosts (macOS Homebrew keg, Linux distro packages,
# or a custom prefix).  The Makefile, the Scheme compiler driver (via
# src/toolchain.ss), and the shell test harnesses all shell out to this script,
# so one override/discovery result governs every backend.
# See the openspec change `configurable-llvm-toolchain`.
#
# Overrides (environment):
#   LLVM_CONFIG    full path to an llvm-config (highest precedence)
#   LLVM_PREFIX    install dir whose bin/ holds the LLVM 22 tools
#   GC_PREFIX      libgc install dir (expects include/ and lib/)
#   GC_INC/GC_LIB  finer libgc include/lib overrides
#
# Resolution: env override -> llvm-config-22/llvm-config on PATH -> known
# prefixes (Homebrew keg, Linux distro).  libgc: env -> Homebrew keg -> system.
#
# Usage: tools/toolchain.sh <query>
#   llvm-config | llvm-bindir | cc | gc-inc | gc-lib | gc-shared | check
# Each query prints one value on stdout; on failure it prints an actionable
# message on stderr and exits non-zero.
set -u

LLVM_MAJOR=22

llvm_hint() {
  cat >&2 <<EOF
toolchain: LLVM ${LLVM_MAJOR} not found.
  Override:  export LLVM_CONFIG=/path/to/llvm-config   (or LLVM_PREFIX=/install/dir)
  Install:   macOS    brew install llvm@${LLVM_MAJOR}
             Ubuntu   sudo apt-get install llvm-${LLVM_MAJOR} llvm-${LLVM_MAJOR}-dev clang-${LLVM_MAJOR}
EOF
}

gc_hint() {
  cat >&2 <<EOF
toolchain: Boehm libgc (gc/gc.h + libgc) not found.
  Override:  export GC_PREFIX=/install/dir            (expects include/ and lib/)
  Install:   macOS    brew install bdw-gc
             Ubuntu   sudo apt-get install libgc-dev
EOF
}

# Echo a validated LLVM 22 llvm-config path, or return non-zero:
#   1 = none found   2 = found but not major ${LLVM_MAJOR}
find_llvm_config() {
  local c=""
  if [ -n "${LLVM_CONFIG:-}" ]; then
    c="$LLVM_CONFIG"
  elif [ -n "${LLVM_PREFIX:-}" ]; then
    c="$LLVM_PREFIX/bin/llvm-config"
  else
    c="$(command -v "llvm-config-${LLVM_MAJOR}" 2>/dev/null || true)"
    [ -n "$c" ] || c="$(command -v llvm-config 2>/dev/null || true)"
    if [ -z "$c" ]; then
      local p
      for p in "/opt/homebrew/opt/llvm@${LLVM_MAJOR}/bin/llvm-config" \
               "/usr/lib/llvm-${LLVM_MAJOR}/bin/llvm-config" \
               "/usr/bin/llvm-config-${LLVM_MAJOR}"; do
        [ -x "$p" ] && { c="$p"; break; }
      done
    fi
  fi
  { [ -n "$c" ] && [ -x "$c" ]; } || return 1
  local v
  v="$("$c" --version 2>/dev/null | cut -d. -f1)"
  [ "$v" = "$LLVM_MAJOR" ] || return 2
  echo "$c"
}

resolve_llvm_config() {
  local c rc
  c="$(find_llvm_config)"; rc=$?
  if [ "$rc" -eq 2 ]; then
    echo "toolchain: an llvm-config was found but it is not major ${LLVM_MAJOR}." >&2
    llvm_hint; exit 1
  fi
  [ "$rc" -eq 0 ] || { llvm_hint; exit 1; }
  echo "$c"
}

# resolve_llvm_config exits the script on failure, but that only escapes a $(...)
# subshell -- so callers capture it and propagate with `|| exit 1`.
llvm_bindir() {
  local cfg; cfg="$(resolve_llvm_config)" || exit 1
  "$cfg" --bindir
}

# AOT C compiler + host-triple probe: prefer an unversioned clang on PATH (Apple
# clang on macOS, a distro default on Linux), else the resolved LLVM 22 clang.
resolve_cc() {
  local c
  c="$(command -v clang 2>/dev/null || true)"
  [ -n "$c" ] && { echo "$c"; return; }
  local bindir; bindir="$(llvm_bindir)" || exit 1
  echo "$bindir/clang"
}

# libgc: sets GC_INC_R / GC_LIB_R / GC_SHARED_R, or exits with a hint.
gc_from_dirs() {  # inc lib
  GC_INC_R="$1"; GC_LIB_R="$2"
  if [ -e "$GC_LIB_R/libgc.dylib" ]; then GC_SHARED_R="$GC_LIB_R/libgc.dylib"
  else GC_SHARED_R="$GC_LIB_R/libgc.so"; fi
}

resolve_gc() {
  if [ -n "${GC_PREFIX:-}" ]; then
    gc_from_dirs "$GC_PREFIX/include" "$GC_PREFIX/lib"; return
  fi
  if [ -n "${GC_INC:-}" ] && [ -n "${GC_LIB:-}" ]; then
    gc_from_dirs "$GC_INC" "$GC_LIB"; return
  fi
  if [ -e /opt/homebrew/include/gc/gc.h ]; then
    gc_from_dirs /opt/homebrew/include /opt/homebrew/lib; return
  fi
  if [ -e /usr/include/gc/gc.h ] || [ -e /usr/include/gc.h ]; then
    # Header is on the default include path; find the shared object (multiarch
    # lib dir varies) via ldconfig, else fall back to /usr/lib.
    local shared
    shared="$(ldconfig -p 2>/dev/null | awk '/libgc\.so/ {print $NF; exit}')"
    if [ -n "$shared" ]; then
      GC_INC_R=/usr/include; GC_LIB_R="$(dirname "$shared")"; GC_SHARED_R="$shared"; return
    fi
    gc_from_dirs /usr/include /usr/lib; return
  fi
  gc_hint; exit 1
}

case "${1:-check}" in
  llvm-config) resolve_llvm_config ;;
  llvm-bindir) llvm_bindir ;;
  cc)          resolve_cc ;;
  gc-inc)      resolve_gc; echo "$GC_INC_R" ;;
  gc-lib)      resolve_gc; echo "$GC_LIB_R" ;;
  gc-shared)   resolve_gc; echo "$GC_SHARED_R" ;;
  check)
    cfg="$(resolve_llvm_config)" || exit 1
    echo "llvm-config: $cfg  ($("$cfg" --version))"
    echo "llvm-bindir: $(llvm_bindir)"
    echo "cc:          $(resolve_cc)"
    resolve_gc
    echo "gc-inc:      $GC_INC_R"
    echo "gc-lib:      $GC_LIB_R"
    echo "gc-shared:   $GC_SHARED_R"
    ;;
  *) echo "toolchain: unknown query: $1" >&2; exit 2 ;;
esac
