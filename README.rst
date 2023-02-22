subs2srs for .NET 4.8
=====================

`Official builds of subs2srs`__ are targeting .NET 3.5, which is no longer installed by default.
This repository provides builds of subs2srs that don't require legacy .NET 3.5 to be installed.

__ https://sourceforge.net/projects/subs2srs/files/subs2srs/

In addition to that, TagLibSharp and SourceGrid dependencies are updated to their latest versions,
and long path support is enabled for both subs2srs and SubsReTimer.

WARNING: External Dependencies are not Bundled
----------------------------------------------

subs2srs has external dependencies. They are frequently updated, and thus are not bundled with
these builds of subs2srs. (Official build do include very outdated versions of these dependencies.)

To get a fully working subs2srs:

- Download FFmpeg from e.g. https://github.com/yt-dlp/FFmpeg-Builds/releases, and place
  ``ffmpeg.exe`` into ``subs2srs\Utils\ffmpeg\``.

- Download portable MKVToolNix from https://mkvtoolnix.download/downloads.html#windows, and place
  ``mkvextract.exe`` and ``mkvinfo.exe`` into ``subs2srs\Utils\mkvtoolnix\``.

- Download portable MP3Gain from https://mp3gain.sourceforge.net/download.php, and place
  ``mp3gain.exe`` into ``subs2srs\Utils\mp3gain\``.

Simply having above mentioned executables in ``%PATH%`` is a viable alternative.
