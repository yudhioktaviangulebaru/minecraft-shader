#!/usr/bin/env bash
# Validate GLSL syntax + pack consistency. Requires glslang-tools and python3.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! command -v glslangValidator >/dev/null 2>&1; then
    echo "glslangValidator not found. Install: sudo apt install glslang-tools" >&2
    exit 2
fi
exec python3 -I "$HERE/validate.py" "$@"
