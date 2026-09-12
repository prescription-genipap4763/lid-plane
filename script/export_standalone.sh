#!/usr/bin/env bash
# Copyright (c) 2026 Jhey
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"
DESTINATION="${1:-$PROJECT_DIR/dist/standalone/lid-plane}"
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' Info.plist)"
ARCH="$(uname -m)"
ARCHIVE="LidPlane-$VERSION-$ARCH.zip"
if [ -e "$DESTINATION" ] || [ -L "$DESTINATION" ]; then
  echo "Destination already exists; choose a new folder: $DESTINATION" >&2
  exit 1
fi
if [ ! -f "dist/$ARCHIVE" ] || [ ! -f "dist/LidPlane-$VERSION-$ARCH.dmg" ] || [ ! -f dist/SHA256SUMS.txt ]; then
  echo "Run ./script/package_release.sh --experimental first." >&2
  exit 1
fi
(
  cd dist
  shasum -a 256 -c SHA256SUMS.txt
)
mkdir -p "$DESTINATION/dist" "$DESTINATION/.codex/environments"
for entry in Package.swift Info.plist Sources Tests script LICENSE COPYRIGHT LICENSE-MIT README.md DEVELOPMENT.md DISTRIBUTION.md AGENTS.md .gitignore; do
  /usr/bin/ditto "$entry" "$DESTINATION/$entry"
done
cp .codex/environments/environment.toml "$DESTINATION/.codex/environments/"
cp dist/README.md "dist/$ARCHIVE" "dist/LidPlane-$VERSION-$ARCH.dmg" dist/SHA256SUMS.txt "$DESTINATION/dist/"
echo "Standalone project: $DESTINATION"
echo "Includes the app ZIP. No Git repository was created and nothing was published."
