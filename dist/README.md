# Downloads and build output

**[Download Lid Plane v0.2.0 for Apple silicon](LidPlane-0.2.0-arm64.zip?raw=true)**

Unzip, move `LidPlane.app` into Applications, and open it. Follow the [main README](../README.md) for first-launch approval, Screen Recording permission and controls. This build is experimental and not notarized.

## Files worth sharing

- `LidPlane-0.2.0-arm64.zip`: the complete app for Apple silicon MacBooks.
- `SHA256SUMS.txt`: the ZIP’s integrity checksum, not Apple notarization or proof of publisher identity.

Optional integrity check, from a folder containing both files:

```sh
shasum -a 256 -c SHA256SUMS.txt
```

## Local files you may see after building

- `LidPlane.app`: the everyday development build.
- `release/`: optimized packaging output and a source archive.
- `standalone/lid-plane/`: a self-contained repository export.
- `*.png` and `window-check.txt`: diagnostic artwork and reports.

Those local outputs are ignored by Git. Only this README, downloadable app ZIPs and their checksum file belong in the repository. Share the ZIP rather than a loose `.app`: it preserves the bundle structure and executable permissions.
