#!/usr/bin/env bash
# Copyright (c) 2026 Jhey
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"
MODE="${1:---experimental}"
case "$MODE" in --experimental|--notarize) ;; *) echo "usage: $0 [--experimental|--notarize]" >&2; exit 2 ;; esac
if [ "$MODE" = --notarize ]; then
  : "${LIDPLANE_SIGN_IDENTITY:?Set a Developer ID Application identity}"
  : "${LIDPLANE_NOTARY_PROFILE:?Set an existing notarytool keychain profile}"
  case "$LIDPLANE_SIGN_IDENTITY" in "Developer ID Application:"*) ;; *) echo "Notarization requires a Developer ID Application identity." >&2; exit 2 ;; esac
fi
swift build --configuration release --product LidPlane
BUILD_DIR="$(swift build --configuration release --show-bin-path)"
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' Info.plist)"
ARCH="$(uname -m)"
RELEASE_DIR="$PROJECT_DIR/dist/release"
APP_BUNDLE="$RELEASE_DIR/LidPlane.app"
ARCHIVE="$RELEASE_DIR/LidPlane-$VERSION-$ARCH.zip"
DISK_IMAGE="$RELEASE_DIR/LidPlane-$VERSION-$ARCH.dmg"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
cp "$BUILD_DIR/LidPlane" "$APP_BUNDLE/Contents/MacOS/LidPlane"
cp Info.plist "$APP_BUNDLE/Contents/Info.plist"
mkdir -p "$APP_BUNDLE/Contents/Resources"
cp LICENSE COPYRIGHT "$APP_BUNDLE/Contents/Resources/"
if [ "$MODE" = --notarize ]; then
  /usr/bin/codesign --force --options runtime --timestamp --sign "$LIDPLANE_SIGN_IDENTITY" "$APP_BUNDLE"
else
  /usr/bin/codesign --force --sign - --identifier dev.jhey.lidplane "$APP_BUNDLE"
fi
/usr/bin/codesign --verify --strict --verbose=2 "$APP_BUNDLE"
/usr/bin/ditto -c -k --sequesterRsrc --keepParent "$APP_BUNDLE" "$ARCHIVE"
if [ "$MODE" = --notarize ]; then
  xcrun notarytool submit "$ARCHIVE" --keychain-profile "$LIDPLANE_NOTARY_PROFILE" --wait
  xcrun stapler staple "$APP_BUNDLE"
  xcrun stapler validate "$APP_BUNDLE"
  /usr/sbin/spctl --assess --type execute --verbose=2 "$APP_BUNDLE"
  /usr/bin/ditto -c -k --sequesterRsrc --keepParent "$APP_BUNDLE" "$ARCHIVE"
fi
./script/package_dmg.sh "$APP_BUNDLE" "$DISK_IMAGE"
if [ "$MODE" = --notarize ]; then
  /usr/bin/codesign --timestamp --sign "$LIDPLANE_SIGN_IDENTITY" "$DISK_IMAGE"
  xcrun notarytool submit "$DISK_IMAGE" --keychain-profile "$LIDPLANE_NOTARY_PROFILE" --wait
  xcrun stapler staple "$DISK_IMAGE"
  xcrun stapler validate "$DISK_IMAGE"
fi
tar --exclude='.DS_Store' -czf "$RELEASE_DIR/LidPlane-$VERSION-source.tar.gz" Package.swift Info.plist Sources Tests script LICENSE COPYRIGHT LICENSE-MIT README.md DEVELOPMENT.md DISTRIBUTION.md AGENTS.md .gitignore .codex/environments/environment.toml dist/README.md
(
  cd "$RELEASE_DIR"
  shasum -a 256 "LidPlane-$VERSION-$ARCH.zip" "LidPlane-$VERSION-$ARCH.dmg" "LidPlane-$VERSION-source.tar.gz" > SHA256SUMS.txt
)
# Publishable repo artifact; leave the user's approved dist/LidPlane.app untouched.
cp "$ARCHIVE" "$DISK_IMAGE" "$PROJECT_DIR/dist/"
(
  cd "$PROJECT_DIR/dist"
  shasum -a 256 "LidPlane-$VERSION-$ARCH.zip" "LidPlane-$VERSION-$ARCH.dmg" > SHA256SUMS.txt
)
echo "Packaged: $ARCHIVE"
if [ "$MODE" = --experimental ]; then echo "EXPERIMENTAL: ad-hoc signed, not notarized. Gatekeeper may block downloaded copies."; fi
