#!/usr/bin/env bash
# Build dist/<pack>-vX.Y.Z.zip (version from VERSION file)
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_DIR="$(dirname "$HERE")"
PACK_NAME="$(basename "$PACK_DIR")"
VERSION="$(tr -d "[:space:]" < "$PACK_DIR/VERSION")"
[ -n "$VERSION" ] || { echo "VERSION file empty" >&2; exit 1; }

"$HERE/validate.sh"

DIST="$PACK_DIR/../dist"
OUT="$DIST/$PACK_NAME-v$VERSION.zip"
mkdir -p "$DIST"
rm -f "$OUT"
(cd "$PACK_DIR" && zip -qr -X "$OUT" shaders README.md CHANGELOG.md -x '*.DS_Store')
echo "Packaged: $(realpath "$OUT")"
