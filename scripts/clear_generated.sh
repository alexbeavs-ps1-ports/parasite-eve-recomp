#!/usr/bin/env bash
# Clear generated game/BIOS C so CI can build a BIOS-free setup host.
# The framework no longer ships this helper; each game repository keeps its own.
#
# Usage (from game repo root):
#   scripts/clear_generated.sh [--root DIR]
set -euo pipefail

ROOT="${PWD}"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="${2:?}"; shift 2 ;;
    -h|--help)
      sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "error: unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

ROOT="$(cd "${ROOT}" && pwd)"
rm -rf "${ROOT}/generated" "${ROOT}/psxrecomp/generated"
echo "cleared generated/ under ${ROOT} (setup-host mode)"
