#!/usr/bin/env bash
# Convenience wrapper: run a bpy script with the stub LD_LIBRARY_PATH applied.
# Usage: ./run_bpy.sh /tmp/tools/venv/bin/python script.py [args...]
set -euo pipefail
cd "$(dirname "$0")"
PY=${1:-/tmp/tools/venv/bin/python}; shift
LD_LIBRARY_PATH="$PWD/out${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" "$PY" "$@"
