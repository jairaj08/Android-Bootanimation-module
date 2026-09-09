# Cool Bootanimation Module Template

A minimal systemless overlay module for replacing Android's boot animation. It is intended for Magisk, KernelSU, and APatch module managers and does not modify or remount read-only system partitions.

## Features
- Uses the root manager's systemless overlay on dynamic and read-only partitions.
- Detects known boot-animation locations, with `/system/media` and `/product/media` as safe fallbacks.
- Replaces `bootanimation-dark.zip` only when the ROM already provides that file.
- Installs optional `bootaudio.mp3` alongside the animation.
- Lets the root manager own installation and uninstallation; no files are deleted from the real system.

## Requirements
- A rooted Android device with Magisk, KernelSU, or APatch or any similar app.
- A valid `bootanimation.zip`.

## Installation
1. Download the module ZIP release. Install it from a supported root manager. The included `META-INF` files also retain compatibility with recovery-based Magisk module installers.
2. Open the root manager's module installer.
3. Select the ZIP and install it.
4. Reboot to apply the animation.

## Build or Replace the animation
1. Extract the module ZIP.
2. Place your custom `bootanimation.zip` in `common/`.
3. Optionally place `bootaudio.mp3` in `common/`.
4. Create the ZIP with `customize.sh`, `module.prop`, and `common/` at its root.

The animation archive must contain a root-level `desc.txt` and one or more `part*` directories. Store (uncompressed) ZIP entries are recommended for boot-time performance. The installer validates the archive and aborts before installation if it is corrupt or lacks `desc.txt`.

## Troubleshooting
- **Black screen or animation does not start:** Check that `desc.txt` dimensions match the frames, frame names are valid, and the archive contains `part0`, `part1`, etc. Recreate it using Store compression.
- **Stock animation still appears:** The ROM may use a proprietary boot animation service or an unlisted path. Inspect the ROM's animation location and add it to `BA_MEDIA_PATHS` in `customize.sh`. Do not blindly remount or write to `/system`. Reach to me on support group mentioned below, I would love to help.
- **No boot audio:** Audio is ROM/device dependent. Some Android builds disable boot sound or use a vendor-specific filename/service; this module cannot enable a disabled service.
- **Install error:** Install through the manager's module installer. `module.prop` must be at the ZIP root, do not flash using recovery.

## Compatibility Scope
No bootanimation module can honestly guarantee every Android phone or ROM. A device may not use the AOSP `bootanimation` service, may select a vendor animation before overlays are mounted, or may enforce a custom SELinux policy. This template covers standard systemless overlay behavior on Android 10 through current Android releases, but proprietary ROM behavior may needs device-specific handling.


## Credits
- Creator: [Jairaj08](https://github.com/Jairaj08)
- Bootanimation bot: [@bootanimations_bot](https://t.me/bootanimations_bot)
- Support group: [@bootanimations_group](https://t.me/bootanimations_group)
- License: Creative Commons Attribution 4.0 International (CC BY 4.0)
