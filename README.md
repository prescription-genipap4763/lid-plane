# Lid Plane

Your MacBook has the folding animation at home.

A tiny menu bar app that holds your desktop at an apparent fixed angle and progressively blurs it as you close the lid below 90°. Open it above that angle and your desktop is untouched. Your apps stay clickable and keep keyboard focus. An alternative movement-based mode can settle the effect when you pause.

## Download and run

**[Download Lid Plane for Apple silicon (DMG)](https://github.com/jh3y/lid-plane/releases/download/v0.3.1/LidPlane-0.3.1-arm64.dmg)** · [ZIP alternative](dist/LidPlane-0.3.1-arm64.zip?raw=true) · v0.3.1 · experimental

You need macOS 13 or newer, an Apple silicon MacBook, and a readable lid angle sensor. Sensor support varies between models; Apple silicon alone does not guarantee compatibility. This is not an Intel or Windows download.

1. Download and open the DMG above (or unzip the ZIP alternative).
2. Drag **LidPlane.app** into **Applications**, eject the disk image, then open the installed app.
3. Look for the **lid-angle readout in your menu bar**, such as `105°` (or a laptop icon if you have turned the readout off). There is no Dock icon or app window.
4. Click the readout or icon to enable the effect. Allow **Screen Recording** when macOS asks. If asked to quit and reopen, reopen the same app from Applications, then enable it again.
5. Gently close your lid below **90°** to see the default effect. Keep the laptop base and your head roughly still for the best illusion. Normal lid-close sleep still applies.

No terminal, Xcode, or build step is needed for the download. The effect starts **off** each time you open the app.

### macOS says it cannot verify the app?

This experimental build is **not notarized by Apple**. If you trust this download, first try opening it, then go to **System Settings → Privacy & Security → Open Anyway** and confirm. If macOS reports malware or that the app will damage your computer, stop—do not bypass that warning. You do not need to disable Gatekeeper or run security-bypass commands.

## Controls

| Action | How |
| --- | --- |
| Turn the effect on/off | Click the menu bar readout/icon, or press **Control–Command–L** |
| Open options | Right-click or Control-click the readout/icon |
| Enable only below a chosen lid angle | **Use Activation Angle**, then adjust **Activate at or below** (10–180°, in 1° steps) |
| Ignore small hinge movements | **Jitter tolerance** slider (0–5°, in 0.5° steps; default 2°) |
| Reset the starting angle | **Anchor Here** |
| Settle back after you stop moving | Turn **Use Activation Angle** off, then use **Auto-anchor When Still** |
| Change the settling delay | **Pause Before Anchoring** → 0.15, 0.3, 0.5, 1, or 2 seconds |
| Blur without angle distortion | Keep **Progressive Blur** on; turn **Hold Content Angle** off |
| Less dramatic distortion | Turn **Perspective Taper** off (on by default) |
| See the sensor reading | **Show Lid Angle in Menu Bar** replaces the icon with a number like `105°` |
| Test without moving the lid | Enable the effect, then choose **Simulate a Fold** |
| Close the app completely | **Quit Lid Plane** |

The shortcut works while Lid Plane is running, including when you are using another app. If another app has reserved it, the options menu reports it as unavailable.

Auto-anchor waits just **150 milliseconds** by default, then eases back over **200 milliseconds**. Turn it off if you want the image to hold its original angle while you film. Options are remembered between launches; if you previously chose a slower pause, select **0.15 seconds** in the menu for the quicker timing.

### Angle mode and jitter tolerance

**Use Activation Angle** defaults to **on at 90°**. Saved preferences take precedence, including an explicit choice to turn this mode off. Above 90° the desktop is untouched; at 90° the image is aligned, and closing further builds the effect. In this mode the selected angle is the fixed anchor, so **Anchor Here** and auto-anchor controls are disabled. Turn angle mode off to return to movement-based auto-anchor. The app itself still starts with the effect disabled until you toggle it on.

Fresh installs also default to **2° jitter tolerance**, with **Progressive Blur**, **Hold Content Angle**, **Perspective Taper** and **Show Lid Angle in Menu Bar** all on. Updating does not overwrite existing saved choices. To match these defaults on an existing installation, select these options in the right-click menu.

**Jitter tolerance** applies in either mode. At **2°**, movements within 2° of the last accepted reading are ignored; larger accumulated movement is accepted. Try **1°** for a lighter touch or **0°** for maximum sensitivity. This filters the hinge sensor, not whole-laptop motion: there is no accelerometer or head tracking. Above the activation angle the effect always hides, even if the filtered reading is still below it. Small movements just below the boundary can also be suppressed by the tolerance.

### Closed-lid and external-display safety

Closing the lid pauses capture and hides the effect, even if an external display keeps the Mac awake. The app also pauses if the built-in display is unavailable, asleep or mirrored, or its angle sensor stops reporting. It never chooses an external display as a substitute. Once the lid is open and the built-in display and sensor have been usable for half a second, an enabled app resumes with a fresh anchor. Turning the app off while paused prevents that automatic resume. A reading of 5° or less is treated as closed as an extra safeguard.

Clamshell transitions are covered by automated state tests, but hardware combinations have not been broadly tested. Normal macOS sleep behaviour is unchanged.

## If something is not working

- **Nothing happens when I open it:** look in the menu bar and enable it.
- **Enabled, but no blur:** make sure **Progressive Blur** is checked. Try **Simulate a Fold**. If that works but moving the lid does not, turn on the angle readout; a missing or unchanging reading can mean an unsupported sensor.
- **The effect disappears when I pause:** that is auto-anchor. Disable it to keep the effect.
- **Enabled but waiting or paused:** check the status at the top of the menu. In angle mode, lower the lid past the selected angle. For display pauses, open the lid and use the built-in display without mirroring.
- **Screen Recording is enabled but capture fails:** quit Lid Plane. In **System Settings → Privacy & Security → Screen & System Audio Recording** (called **Screen Recording** on some versions), remove the old Lid Plane entry, reopen your installed copy, enable the effect and approve it again. This can happen after replacing an experimental build. Keep one installed copy and launch that same copy each time.
- **A click lands somewhere unexpected while moving:** only the image is transformed, not macOS’s underlying click targets. Let the lid settle before precise clicking.

Only the built-in display is transformed. Protected video may appear blank. The capture is SDR, and the fixed-viewpoint illusion is approximate. Compatibility has not been tested across all MacBook models.

## Privacy and removal

Screen Recording permission lets the app process your display. Frames stay in memory on your Mac; the effect does **not** save a video or send images anywhere. There is no networking in the app, audio capture, camera use, Accessibility permission, Input Monitoring permission, or login helper.

To remove it: choose **Quit Lid Plane**, then move **LidPlane.app** to the Trash. You can also remove its Screen Recording permission in System Settings. Only saved preferences and macOS’s permission record remain outside the app; there is no background service to uninstall.

## What is `dist`?

It is the folder containing downloadable app packages and checksums. **If you only want to use Lid Plane, download the DMG or ZIP above—you do not need the rest of this repository.**

The `.app` inside either download is the complete application. Do not try to run a Swift source file, the whole `dist` folder, or GitHub’s source-code ZIP as an app. More detail: [dist/README.md](dist/README.md).

## Build or contribute

See [DEVELOPMENT.md](DEVELOPMENT.md) for build instructions, test/demo commands and standalone export. See [DISTRIBUTION.md](DISTRIBUTION.md) for packaging and publishing. No third-party dependencies are required.

## How it works (ELI5)

Imagine a live picture of your desktop laid over your real desktop. When you move the lid, we reshape and blur that picture—not your actual apps.

1. **ScreenCaptureKit supplies the picture.** Apple’s screen-capture framework gives us live frames of the built-in display. We leave our own overlay out of the capture so it does not turn into an endless hall of mirrors. Frames stay in memory; nothing is recorded to disk.
2. **The lid angle sensor tells us how far you moved.** On supported MacBooks, we read the hinge angle through IOKit's HID interface, roughly 30 times a second while enabled. We compare it with the chosen activation angle, or a saved starting angle in movement mode. This sensor interface is undocumented, which is why support varies by model.
3. **A Metal shader reshapes the picture.** A shader is a small program running on the GPU. Ours uses the angle difference to move the image’s pixels, creating the illusion that the content holds its angle while the physical display tilts around it. It is an approximation, not head tracking.
4. **Progressive blur sells the effect.** Metal Performance Shaders makes several increasingly blurred copies of the frame. Our shader blends between them: more lid movement means more blur, and the top of the display gets more than the area near the hinge. The image’s outer boundary softens too, instead of ending in a hard cut.
5. **When aligned, the overlay hides.** In the default angle mode, opening back to the chosen angle clears the effect. In movement mode, auto-anchor adopts the new lid angle when you stop moving. You then see the original desktop again. The overlay lets clicks through and never takes keyboard focus, so your real apps remain underneath, working normally.

Built with Swift, ScreenCaptureKit, IOKit and Metal. An independent experiment, not affiliated with or endorsed by Apple.

## License

[MIT](LICENSE) · Copyright (c) 2026 Jhey.

You can use, modify and redistribute this software, including commercially. Keep the copyright and license notice with copies or substantial portions. This license also covers the published v0.2.0 source and app downloads; its release includes a separate `LICENSE` asset.
