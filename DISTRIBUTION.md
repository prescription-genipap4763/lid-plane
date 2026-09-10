# Distribution

`./script/package_release.sh --experimental` builds an optimized app for the current Mac's architecture and produces an app ZIP, source archive, and SHA-256 checksums in `dist/release/`. It also copies the app ZIP and its checksum to `dist/`, where Git can include them and the README links directly to the download. It does not overwrite the everyday-use app at `dist/LidPlane.app`, and does not publish anything.

The current README download targets **v0.2.0 arm64 (Apple silicon)**. If you change the version or target architecture, update the links in `README.md` and `dist/README.md` before packaging. Do not advertise an Intel build unless that build and sensor support have been tested.

The experimental binary is ad-hoc signed, not notarized. Label it clearly as an experimental build in release notes. Gatekeeper may block downloaded copies; building from reviewed source is an alternative. Do not tell users to disable Gatekeeper. Each newly compiled ad-hoc build may need Screen Recording permission again.

For a notarized release, install your **Developer ID Application** certificate with its private key and configure a `notarytool` keychain profile. Then run:

```sh
LIDPLANE_SIGN_IDENTITY='Developer ID Application: YOUR NAME (TEAMID)' \
LIDPLANE_NOTARY_PROFILE='your-notary-profile' \
./script/package_release.sh --notarize
```

This signs with hardened runtime and a secure timestamp, submits the ZIP to Apple, staples and validates the ticket, checks Gatekeeper assessment, and recreates the ZIP with the stapled app. Credentials remain in Keychain. The script has no upload-to-GitHub step.

## Suggested GitHub release

### Easiest handoff: a repo with the download included

1. Run `./script/package_release.sh --experimental`.
2. Run `./script/export_standalone.sh`. The clean project is in `dist/standalone/lid-plane/`.
3. Choose a source license before advertising the project as open source; none has been chosen automatically.
4. Create your new GitHub repository from the **contents of that exported folder**. Include its `dist` ZIP, checksum and README; do not upload unrelated files or build caches.
5. Commit and push the project. Check that the README download link downloads the app ZIP, not a source archive.
6. Test that GitHub download on another supported Mac, including Gatekeeper approval and Screen Recording permission.

Until step 5 happens, the files are only local and there is no public download. Once pushed, visitors can use the download link without a GitHub Release. A Release is an optional, cleaner home for versioned downloads.

### Optional: attach a GitHub Release

Repository name: `lid-plane`. Version: `v0.2.0`. Attach the architecture-labelled app ZIP and `SHA256SUMS.txt` from the same build. GitHub supplies source archives once this project is committed; the locally prepared source archive is also standalone.

Before publishing, choose a source license and add a short demonstration clip. Test the downloaded, quarantined app on another Mac; validation of a local bundle alone does not establish that Gatekeeper will accept it elsewhere. Verify both sensor support and screen capture on that Mac. No certificate is available in the development environment at the time these instructions were written, so only experimental packaging has been tested.

Suggested release notes:

> Your MacBook had a folding animation all along. Lid Plane is a menu bar experiment that uses the lid angle sensor to hold desktop content in place and progressively blur it as the lid moves.
>
> Click the laptop icon or press Control–Command–L to toggle. Right-click for auto-anchor, delay, blur and perspective options. The overlay lets clicks through, leaves keyboard focus in your apps, and disappears once the image settles. Auto-anchor defaults to a 150-millisecond pause and a 200-millisecond ease.
>
> Requires macOS 13+, a supported lid sensor, and Screen Recording permission. No audio, camera, network, recording to disk, or login service. While moving, transformed pixels and underlying click targets can differ. Protected content and HDR are not supported by this capture path.
>
> Experimental build: ad-hoc signed and not notarized. Hardware compatibility is not yet broadly tested.
