#!/usr/bin/env bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"
MODE="${1:-run}"
case "$MODE" in
  run|--verify|--build|--probe|--preview|--window-check|--debug|--logs|--telemetry) ;;
  *) echo "usage: $0 [--build|--probe|--preview|--verify|--window-check|--debug|--logs|--telemetry]" >&2; exit 2 ;;
esac
case "$MODE" in
  --probe|--preview|--build) ;;
  *) pkill -x LidPlane >/dev/null 2>&1 || true ;;
esac
swift build
BUILD_DIR="$(swift build --show-bin-path)"
APP_BUNDLE="$PROJECT_DIR/dist/LidPlane.app"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
# Leave the approved bundle untouched when the executable and metadata match.
if [ -n "${LIDPLANE_SIGN_IDENTITY:-}" ] || [ ! -x "$APP_BUNDLE/Contents/MacOS/LidPlane" ] || ! cmp -s "$BUILD_DIR/LidPlane" "$PROJECT_DIR/.build/bundled-input" || ! cmp -s Info.plist "$APP_BUNDLE/Contents/Info.plist" || ! cmp -s LICENSE "$APP_BUNDLE/Contents/Resources/LICENSE"; then
  cp "$BUILD_DIR/LidPlane" "$APP_BUNDLE/Contents/MacOS/LidPlane"
  cp Info.plist "$APP_BUNDLE/Contents/Info.plist"
  mkdir -p "$APP_BUNDLE/Contents/Resources"
  cp LICENSE "$APP_BUNDLE/Contents/Resources/LICENSE"
  /usr/bin/codesign --force --sign "${LIDPLANE_SIGN_IDENTITY:--}" --identifier dev.jhey.lidplane "$APP_BUNDLE"
  cp "$BUILD_DIR/LidPlane" "$PROJECT_DIR/.build/bundled-input"
fi
case "$MODE" in
  --build) exit 0 ;;
  --probe) exec "$BUILD_DIR/LidPlane" --probe ;;
  --preview) exec "$BUILD_DIR/LidPlane" --preview ;;
esac
if [ "$MODE" = --debug ]; then exec lldb -- "$APP_BUNDLE/Contents/MacOS/LidPlane"; fi
if [ "$MODE" = --window-check ]; then
  /usr/bin/open -n -W "$APP_BUNDLE" --args --window-check
  cat "$PROJECT_DIR/dist/window-check.txt"
  grep -q '^PASS:' "$PROJECT_DIR/dist/window-check.txt"
  exit 0
fi
/usr/bin/open -n "$APP_BUNDLE"
case "$MODE" in
  --verify) sleep 1; pgrep -x LidPlane ;;
  --logs|--telemetry) /usr/bin/log stream --info --style compact --predicate 'process == "LidPlane"' ;;
esac
