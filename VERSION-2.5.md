# Version 2.5 update

Version 2.5 adds library-driven workshop effects while keeping library media separate from the repository. Add media you are licensed to use in NVG's Library tab at the paths declared by each plugin.

## New plugins

- `version-2.5-remix-library.lua` provides dance, remix, music, keyframe and animation-oriented libraries for video and image media.
- `wtf-boom-library-effect.lua` provides an optional BOOM image-overlay and impact-sound library effect.
- `microsoft-windows-sound-remix.lua` provides optional error, startup, shutdown, logon, logoff, image and extra-video library categories.

## Existing libraries

- `ytp_tennis.lua` continues to declare tennis tournament, overlay and sound libraries.
- `short_commercial_overlay.lua` continues to use the `Commercials` video library for commercial overlays.

All new generators gracefully copy the input video when FFmpeg is unavailable, their chance roll does not run, or optional library media is empty.
