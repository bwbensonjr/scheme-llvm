#!/usr/bin/env bash
# log.sh -- shared informational/status output for the project's tools.
#
# The single source of the output CONVENTION documented in docs/OUTPUT.md.  Source
# this from a script (after cd-ing to the repo root) and use the helpers below.
#
# Discipline (see docs/OUTPUT.md):
#   * ALL narration goes to standard error -- stdout carries only machine data
#     (e.g. the IR emitted by scheme-run --emit / schemec, compared byte-for-byte
#     by the self-hosting checks).  say/vsay therefore always write to fd 2.
#   * Verbosity is read once from EMIT_VERBOSITY (unset = default):
#       quiet|q|0   -> errors + data only, no narration
#       verbose|v|2 -> per-stage / per-metric detail
#       (anything)  -> concise default
#
# Helpers:
#   say  MSG...    concise line, shown at default and verbose (hidden when quiet)
#   vsay MSG...    detail line, shown only at verbose
#   bytes FILE     print FILE's size in bytes (for a "[N bytes]" metrics clause);
#                  empty string if FILE is missing

case "${EMIT_VERBOSITY:-default}" in
  quiet|q|0)   EMIT_LEVEL=0 ;;
  verbose|v|2) EMIT_LEVEL=2 ;;
  *)           EMIT_LEVEL=1 ;;
esac
export EMIT_LEVEL

say()  { [ "${EMIT_LEVEL:-1}" -ge 1 ] && printf '%s\n' "$*" >&2 || true; }
vsay() { [ "${EMIT_LEVEL:-1}" -ge 2 ] && printf '%s\n' "$*" >&2 || true; }
bytes() { wc -c < "$1" 2>/dev/null | tr -d ' '; }
