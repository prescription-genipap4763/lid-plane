#!/usr/bin/env bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_BUNDLE="$PROJECT_DIR/dist/LidPlane.app"
if [ ! -x "$APP_BUNDLE/Contents/MacOS/LidPlane" ]; then
  echo "Build Lid Plane before repairing its permission." >&2
  exit 1
fi
# A targeted reset, never all screen-recording permissions. No rebuilding here:
# the user must approve the exact bundle that they will subsequently launch.
pkill -x LidPlane >/dev/null 2>&1 || true
/usr/bin/tccutil reset ScreenCapture dev.jhey.lidplane
/usr/bin/open -n "$APP_BUNDLE"
echo "Allow Lid Plane in Screen Recording settings, then quit and reopen the same app if macOS requests it."
