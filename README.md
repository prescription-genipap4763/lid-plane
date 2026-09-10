# Lid Plane

Your MacBook has the folding animation at home.

A tiny menu bar app that holds your desktop at an apparent fixed angle and progressively blurs it as you move the lid. Pause, and it settles back into place. Your apps stay clickable and keep keyboard focus.

## Download and run

**[Download Lid Plane for Apple silicon](dist/LidPlane-0.2.0-arm64.zip?raw=true)** · v0.2.0 · experimental

You need macOS 13 or newer, an Apple silicon MacBook, and a readable lid angle sensor. Sensor support varies between models; Apple silicon alone does not guarantee compatibility. This is not an Intel or Windows download.

1. Download the ZIP above and double-click it to unzip.
2. Drag **LidPlane.app** into **Applications**, then open it.
3. Look for the **laptop icon in your menu bar**. There is no Dock icon or app window.
4. Click the icon to enable the effect. Allow **Screen Recording** when macOS asks. If asked to quit and reopen, reopen the same app from Applications, then enable it again.
5. Gently move your lid. Keep the laptop base and your head roughly still for the best illusion. Normal lid-close sleep still applies.

No terminal, Xcode, or build step is needed for the download. The effect starts **off** each time you open the app.

### macOS says it cannot verify the app?

This experimental build is **not notarized by Apple**. If you trust this download, first try opening it, then go to **System Settings → Privacy & Security → Open Anyway** and confirm. If macOS reports malware or that the app will damage your computer, stop—do not bypass that warning. You do not need to disable Gatekeeper or run security-bypass commands.

## Controls

| Action | How |
| --- | --- |
| Turn the effect on/off | Click the menu bar icon, or press **Control–Command–L** |
| Open options | Right-click or Control-click the icon |
| Reset the starting angle | **Anchor Here** |
| Settle back after you stop moving | **Auto-anchor When Still** (on by default) |
| Change the settling delay | **Pause Before Anchoring** → 0.15, 0.3, 0.5, 1, or 2 seconds |
| Blur without angle distortion | Keep **Progressive Blur** on; turn **Hold Content Angle** off |
| More dramatic distortion | Turn **Perspective Taper** on |
| See the sensor reading | **Show Lid Angle in Menu Bar** replaces the icon with a number like `105°` |
| Test without moving the lid | Enable the effect, then choose **Simulate a Fold** |
| Close the app completely | **Quit Lid Plane** |

The shortcut works while Lid Plane is running, including when you are using another app. If another app has reserved it, the options menu reports it as unavailable.

Auto-anchor waits just **150 milliseconds** by default, then eases back over **200 milliseconds**. Turn it off if you want the image to hold its original angle while you film. Options are remembered between launches; if you previously chose a slower pause, select **0.15 seconds** in the menu for the quicker timing.

## If something is not working

- **Nothing happens when I open it:** look in the menu bar and enable it.
- **Enabled, but no blur:** make sure **Progressive Blur** is checked. Try **Simulate a Fold**. If that works but moving the lid does not, turn on the angle readout; a missing or unchanging reading can mean an unsupported sensor.
- **The effect disappears when I pause:** that is auto-anchor. Disable it to keep the effect.
- **Screen Recording is enabled but capture fails:** quit Lid Plane. In **System Settings → Privacy & Security → Screen & System Audio Recording** (called **Screen Recording** on some versions), remove the old Lid Plane entry, reopen your installed copy, enable the effect and approve it again. This can happen after replacing an experimental build. Keep one installed copy and launch that same copy each time.
- **A click lands somewhere unexpected while moving:** only the image is transformed, not macOS’s underlying click targets. Let the lid settle before precise clicking.

Only the built-in display is transformed. Protected video may appear blank. The capture is SDR, and the fixed-viewpoint illusion is approximate. Compatibility has not been tested across all MacBook models.

## Privacy and removal

Screen Recording permission lets the app process your display. Frames stay in memory on your Mac; the effect does **not** save a video or send images anywhere. There is no networking in the app, audio capture, camera use, Accessibility permission, Input Monitoring permission, or login helper.

To remove it: choose **Quit Lid Plane**, then move **LidPlane.app** to the Trash. You can also remove its Screen Recording permission in System Settings. Only saved preferences and macOS’s permission record remain outside the app; there is no background service to uninstall.

## What is `dist`?

It is the folder containing the downloadable app ZIP and its checksum. **If you only want to use Lid Plane, download the ZIP above—you do not need the rest of this repository.**

The `.app` inside the ZIP is the complete application. Do not try to run a Swift source file, the whole `dist` folder, or GitHub’s source-code ZIP as an app. More detail: [dist/README.md](dist/README.md).

## Build or contribute

See [DEVELOPMENT.md](DEVELOPMENT.md) for build instructions, test/demo commands and standalone export. See [DISTRIBUTION.md](DISTRIBUTION.md) for packaging and publishing. No third-party dependencies are required.

## How it works (ELI5)

Imagine a live picture of your desktop laid over your real desktop. When you move the lid, we reshape and blur that picture—not your actual apps.

1. **ScreenCaptureKit supplies the picture.** Apple’s screen-capture framework gives us live frames of the built-in display. We leave our own overlay out of the capture so it does not turn into an endless hall of mirrors. Frames stay in memory; nothing is recorded to disk.
2. **The lid angle sensor tells us how far you moved.** On supported MacBooks, we read the hinge angle through IOKit’s HID interface, roughly 30 times a second while enabled. We compare it with a saved starting angle. This sensor interface is undocumented, which is why support varies by model.
3. **A Metal shader reshapes the picture.** A shader is a small program running on the GPU. Ours uses the angle difference to move the image’s pixels, creating the illusion that the content holds its angle while the physical display tilts around it. It is an approximation, not head tracking.
4. **Progressive blur sells the effect.** Metal Performance Shaders makes several increasingly blurred copies of the frame. Our shader blends between them: more lid movement means more blur, and the top of the display gets more than the area near the hinge. The image’s outer boundary softens too, instead of ending in a hard cut.
5. **When you stop, it settles.** Auto-anchor adopts the new lid angle and clears the effect. Once aligned, the overlay hides and you see the original desktop again. The overlay lets clicks through and never takes keyboard focus, so your real apps remain underneath, working normally.

Built with Swift, ScreenCaptureKit, IOKit and Metal. An independent experiment, not affiliated with or endorsed by Apple.
