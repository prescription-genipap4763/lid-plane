# Downloads and build output

**[Download Lid Plane v0.3.2 for Apple silicon (DMG)](LidPlane-0.3.2-arm64.dmg?raw=true)** · [ZIP alternative](LidPlane-0.3.2-arm64.zip?raw=true)

Open the DMG, drag `LidPlane.app` into Applications, eject the image, and open the installed app. Or unzip the ZIP alternative. Follow the [main README](../README.md) for first-launch approval, Screen Recording permission and controls. This build is experimental and not notarized.

[Corresponding source for v0.3.2](https://github.com/jh3y/lid-plane/releases/download/v0.3.2/LidPlane-0.3.2-source.tar.gz) · [Build instructions](../DEVELOPMENT.md)

The v0.3.2 packages are GPL-3.0-or-later. Older packages retained here remain MIT-licensed; see [COPYRIGHT](../COPYRIGHT) and [LICENSE-MIT](../LICENSE-MIT).

## Files worth sharing

- `LidPlane-0.3.2-arm64.dmg`: drag-to-Applications installer image.
- `LidPlane-0.3.2-arm64.zip`: the same app in a ZIP.
- `SHA256SUMS.txt`: integrity checksums for both v0.3.2 downloads, not Apple notarization or proof of publisher identity. Older release downloads remain available on GitHub.

Optional integrity check, from a folder containing both files:

```sh
shasum -a 256 -c SHA256SUMS.txt
```

## Local files you may see after building

- `LidPlane.app`: the everyday development build.
- `release/`: optimized packaging output and a source archive.
- `standalone/lid-plane/`: a self-contained repository export.
- `*.png` and `window-check.txt`: diagnostic artwork and reports.

Those local outputs are ignored by Git. Only this README, downloadable app ZIPs/DMGs and their checksum file belong in the repository. Share a package rather than a loose `.app`: it preserves the bundle structure and executable permissions.
