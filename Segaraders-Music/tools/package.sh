#!/usr/bin/env bash
# Build dist/<pack>.zip (resource pack: place in .minecraft/resourcepacks/)
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_DIR="$(dirname "$HERE")"
PACK_NAME="$(basename "$PACK_DIR")"

python3 -c "import json,sys; [json.load(open(f)) for f in sys.argv[1:]]" \
  "$PACK_DIR/pack.mcmeta" "$PACK_DIR/assets/minecraft/sounds.json"

DIST="$PACK_DIR/../dist"
OUT="$DIST/$PACK_NAME.zip"
mkdir -p "$DIST"
rm -f "$OUT"
(cd "$PACK_DIR" && zip -qr -X "$OUT" pack.mcmeta assets -x '*.DS_Store')
echo "Packaged: $(realpath "$OUT")"
