# Development

This is a standalone macOS Swift package with no third-party dependencies.

## Build and open

1. Install Apple’s Command Line Tools if needed: `xcode-select --install`.
2. Open Terminal in this folder (containing `Package.swift`).
3. Run `./script/build_and_run.sh`.

This builds, bundles and opens `dist/LidPlane.app`. Open that same app directly for later launches; no rebuild is needed. The Codex Run action invokes the same script when this folder is opened as a project.

The script stops an existing Lid Plane when launching a replacement. `--build` only builds and bundles, without stopping or opening the app. Local builds are ad-hoc signed unless you supply `LIDPLANE_SIGN_IDENTITY`.

## Checks and demo artwork

```sh
swift run LidPlaneChecks                  # Auto-anchor, activation, jitter and display-safety checks
./script/build_and_run.sh --probe         # Read-only sensor diagnostic
./script/build_and_run.sh --preview       # Generated artwork rendered into dist/*.png
./script/build_and_run.sh --window-check  # Briefly display artwork; check window pixels and hotkey dispatch
./script/build_and_run.sh --verify        # Build, open and check the app process exists
```

The window check covers hide/show, a CVPixelBuffer-backed frame, display scale, click-through and non-key-window configuration. It saves only its generated artwork window to `dist/window-check.png`, never your desktop, then exits. It does not physically move the hinge or replace a real desktop-capture test. The check executable does not require XCTest or full Xcode.

It also exercises the native jitter slider's target/action and step rounding without changing saved preferences. `MotionPolicyTests` covers 110°/0° defaults, absolute 90° and 110° gating, jitter dead bands, cumulative motion, lid-close, external-only displays, lost sensors and interrupted recovery. Physical closed-lid operation with external monitors still needs testing on the target hardware.

Diagnostic artwork lives in `Renderer.swift`; normal use captures the desktop, not that artwork. The preview command also runs `RenderChecks.swift`: a generated white rectangle verifies that blur crosses both warped side edges, softens inward, tightens near the hinge and respects blur-off. Successful GPU rendering alone does not prove the border is correct.

## Source map

- `Sources/LidPlane/MenuBarApp.swift`: menu bar, click-through panel, preferences and lifecycle.
- `Sources/LidPlane/Renderer.swift`: Metal projection, progressive blur and diagnostic artwork.
- `Sources/LidPlane/DesktopCapture.swift`: in-memory ScreenCaptureKit stream, excluding this app.
- `Sources/LidPlane/Sensor.swift`: read-only, undocumented HID lid-angle report.
- `Sources/LidPlane/GlobalShortcut.swift`: one system hotkey, Control–Command–L.
- `Sources/LidPlaneCore/AutoAnchor.swift`: motion/debounce logic independent of UI.
- `Sources/LidPlaneCore/MotionPolicy.swift`: jitter filter, absolute angle gate and safe display recovery.
- `Sources/LidPlane/DisplayEnvironment.swift`: read-only clamshell state and built-in display eligibility.
- `Sources/LidPlane/MenuSlider.swift`: accessible native controls inside the menu.
- `Tests/LidPlaneCoreTests/`: standalone motion checks.

## Permissions after rebuilding

Replacing an ad-hoc-signed executable can invalidate Screen Recording approval even if Settings still shows it enabled. Avoid rebuilding between approval and testing.

If needed, run `./script/repair_permissions.sh` **after the final build**. It quits Lid Plane, resets only Screen Recording for `dev.jhey.lidplane`, then opens the existing local bundle. Enable and approve it again. It does not reset other apps’ permissions. For a downloaded app in Applications, follow the manual README instructions instead.

## Extract a standalone project

```sh
./script/package_release.sh --experimental
./script/export_standalone.sh
```

The second command creates **`dist/standalone/lid-plane/`**, containing source, documentation, scripts, agent instructions, the Codex Run configuration, and the downloadable ZIP, DMG and checksums in its own `dist/` folder. It excludes build caches, temporary screenshots, loose app bundles and Git history.

The destination must not already exist; the script refuses to overwrite it. To export again, pass a new destination, such as `./script/export_standalone.sh /tmp/lid-plane-review-2`.

That folder can become a new repository. Neither script commits, pushes or publishes anything. See [DISTRIBUTION.md](DISTRIBUTION.md) for the handoff checklist.
