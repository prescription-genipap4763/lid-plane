# Distribution

`./script/package_release.sh --experimental` builds an optimized app for the current Mac's architecture and produces an app ZIP, drag-to-Applications DMG, source archive, and SHA-256 checksums in `dist/release/`. It also copies the ZIP, DMG and their checksums to `dist/`, where Git can include them. It does not overwrite the everyday-use app at `dist/LidPlane.app`, and does not publish anything.

The current README download targets **v0.3.0 arm64 (Apple silicon)**. If you change the version or target architecture, update the links in `README.md` and `dist/README.md` before packaging. Do not advertise an Intel build unless that build and sensor support have been tested.

The experimental binary is ad-hoc signed, not notarized. Label it clearly as an experimental build in release notes. Gatekeeper may block downloaded copies; building from reviewed source is an alternative. Do not tell users to disable Gatekeeper. Each newly compiled ad-hoc build may need Screen Recording permission again.

Lid Plane uses the MIT license, copyright (c) 2026 Jhey. Build and packaging scripts include `LICENSE` at `Contents/Resources/LICENSE` before signing, and source archives and standalone exports include it at the root. Preserve the full notice when redistributing. The original v0.2.0 ZIP and DMG are unchanged; their release provides the applicable license as a separate asset. Include that file when redistributing those original downloads.

For a notarized release, install your **Developer ID Application** certificate with its private key and configure a `notarytool` keychain profile. Then run:

```sh
LIDPLANE_SIGN_IDENTITY='Developer ID Application: YOUR NAME (TEAMID)' \
LIDPLANE_NOTARY_PROFILE='your-notary-profile' \
./script/package_release.sh --notarize
```

This signs with hardened runtime and a secure timestamp, submits the ZIP to Apple, staples and validates the ticket, checks Gatekeeper assessment, and recreates the ZIP with the stapled app. It then creates, signs, submits and staples the DMG. Credentials remain in Keychain. The script has no upload-to-GitHub step. Only the experimental path has been tested here; notarization requires your signing setup.

## Suggested GitHub release

### Easiest handoff: a repo with the download included

1. Run `./script/package_release.sh --experimental`.
2. Run `./script/export_standalone.sh`. The clean project is in `dist/standalone/lid-plane/`.
3. Include `LICENSE` with its copyright and permission notice intact.
4. Create your new GitHub repository from the **contents of that exported folder**. Include its `dist` ZIP, DMG, checksums and README; do not upload unrelated files or build caches. Update the README's release URL if publishing under a different owner.
5. Commit and push the project, then publish the matching release below. Check that README download links download an app package, not a source archive.
6. Test that GitHub download on another supported Mac, including Gatekeeper approval and Screen Recording permission.

Until step 5 happens, the files are only local and there is no public download. The ZIP alternative and `dist/README.md` links work directly from the repository; the main README DMG button points to the matching GitHub Release.

### Attach a GitHub Release

Repository name: `jh3y/lid-plane`. Version: `v0.3.0`. Tag the tested commit and attach the architecture-labelled app ZIP, DMG and `dist/SHA256SUMS.txt` from the same build. GitHub supplies source archives once this project is committed; the locally prepared source archive is also standalone. Keep previous versioned downloads intact.

Before publishing, verify that the license notice is included. Test the downloaded, quarantined app on another Mac; validation of a local bundle alone does not establish that Gatekeeper will accept it elsewhere. Verify both sensor support and screen capture on that Mac. No certificate is available in the development environment at the time these instructions were written, so only experimental packaging has been tested.

Suggested release notes:

> Your MacBook had a folding animation all along. Lid Plane is a menu bar experiment that uses the lid angle sensor to hold desktop content in place and progressively blur it as the lid moves.
>
> Click the laptop icon or press Control–Command–L to toggle. Right-click for the optional absolute activation angle and independent jitter tolerance sliders. Choose 90° to keep the desktop untouched above 90° and build the effect as you close below it. Jitter tolerance defaults to 2°, adjustable from 0–5° in 0.5° steps. Ordinary motion mode still auto-anchors after a 150-millisecond pause and a 200-millisecond ease.
>
> Capture pauses for a closed lid, missing/asleep/mirrored built-in display or lost sensor; it never falls back to an external display. An enabled app resumes after the built-in display and sensor recover. Automated safety tests pass; physical clamshell combinations still need testing.
>
> Requires macOS 13+, a supported lid sensor, and Screen Recording permission. No audio, camera, network, recording to disk, or login service. While moving, transformed pixels and underlying click targets can differ. Protected content and HDR are not supported by this capture path.
>
> Experimental build: ad-hoc signed and not notarized. Hardware compatibility is not yet broadly tested.
