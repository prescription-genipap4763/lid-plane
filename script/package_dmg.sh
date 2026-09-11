#!/usr/bin/env bash
set -euo pipefail
if [ "$#" -ne 2 ]; then echo "usage: $0 /path/LidPlane.app /path/output.dmg" >&2; exit 2; fi
APP_BUNDLE="$1"
OUTPUT_DMG="$2"
test -x "$APP_BUNDLE/Contents/MacOS/LidPlane"
test -f "$APP_BUNDLE/Contents/Resources/LICENSE"
DMG_STAGE="$(mktemp -d "${TMPDIR:-/tmp}/lid-plane-dmg.XXXXXX")"
/usr/bin/ditto "$APP_BUNDLE" "$DMG_STAGE/LidPlane.app"
ln -s /Applications "$DMG_STAGE/Applications"
cp "$APP_BUNDLE/Contents/Resources/LICENSE" "$DMG_STAGE/LICENSE"
/usr/bin/hdiutil create -ov -volname 'Lid Plane' -srcfolder "$DMG_STAGE" -format UDZO -fs HFS+ "$OUTPUT_DMG"
/usr/bin/hdiutil verify "$OUTPUT_DMG"
