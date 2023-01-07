[![Release](https://github.com/erri120/cef.redist.linux64/actions/workflows/release.yml/badge.svg)](https://github.com/erri120/cef.redist.linux64/actions/workflows/release.yml) [![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/erri120/cef.redist.linux64)](https://github.com/erri120/cef.redist.linux64/releases)

# CEF Linux Redistributable Package

This repository contains a build script that compiles and packages the Chromium Embedded Framework (CEF) binary distribution files for Linux, found at [SpotifyCDN](https://cef-builds.spotifycdn.com/index.html).

Packages for other platforms:

- [Windows](https://github.com/cefsharp/cef-binary) ([`cef.redist.x64`](https://www.nuget.org/packages/cef.redist.x64))
- [MacOS](https://github.com/OutSystems/cef.redist.osx) ([`cef.redist.osx64`](https://www.nuget.org/packages/cef.redist.osx64))

**NuGet has a 250 MB size limit. The `libcef.so` file alone is ~1 GB in size. I have to put the `.nupkg` file in the [Release](https://github.com/erri120/cef.redist.linux64/releases) tab and on [GitHub Packages](https://github.com/erri120/cef.redist.linux64/pkgs/nuget/cef.redist.linux64) ([docs](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-nuget-registry#authenticating-to-github-packages)).**

## License

See [LICENSE.txt](./LICENSE.txt) for more information.
