# Parasite Eve Recompiled

<!-- retcomm-readme-metrics -->
[![GitHub downloads (all assets, all releases)](https://img.shields.io/github/downloads/Alexbeav/parasite-eve-recomp/total)](https://github.com/Alexbeav/parasite-eve-recomp/releases)
[![GitHub downloads (latest release)](https://img.shields.io/github/downloads/Alexbeav/parasite-eve-recomp/latest/total)](https://github.com/Alexbeav/parasite-eve-recomp/releases/latest)
[![GitHub release](https://img.shields.io/github/v/release/Alexbeav/parasite-eve-recomp)](https://github.com/Alexbeav/parasite-eve-recomp/releases/latest)
<!-- /retcomm-readme-metrics -->

Static recompilation of **Parasite Eve** built on
[psxrecomp](https://github.com/Alexbeav/psxrecomp) and
[recomp-ui](https://github.com/mstan/recomp-ui).

A native recompilation setup host for the two-disc USA release of Parasite Eve.

| | |
|---|---|
| Players | 1 |
| Region | USA |
| Publisher | - |
| Year | - |

Scaffolded with the New Project Layout. See
`psxrecomp/docs/GAME_PROJECT_SETUP.md` for the full flow.

<!-- release-standard:bios -->
**BIOS:** SCPH-1001 (USA) retail BIOS, 524288 bytes, SHA-256 `71af94d1e47a68c11e8fdb9f8368040601514a42a5a399cda48c7d3bff1e99d3`. Supply your own dump; releases do not use OpenBIOS.
<!-- /release-standard:bios -->

<!-- retcomm-readme-launcher -->
## RetComM Launcher

You can run this title **standalone** (release zip + the built-in recomp-ui
Generate & Build flow), or manage installs, updates, ROM/BIOS wiring, and queued
builds more intuitively with
**[RetComM Launcher](https://github.com/TechnicallyComputers/RetComM-Launcher)** —
the Retro Compilation Manager hub for self-compiling recomps.

[Downloads](https://github.com/TechnicallyComputers/RetComM-Launcher/releases) ·
[Full README & features](https://github.com/TechnicallyComputers/RetComM-Launcher#readme)

<p align="center">
  <img src="https://raw.githubusercontent.com/TechnicallyComputers/RetComM-Launcher/main/docs/screenshots/hub-and-game-launcher.png" alt="RetComM hub with a background build, next to a title’s recomp-ui launcher" width="720">
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/TechnicallyComputers/RetComM-Launcher/main/docs/screenshots/queue-and-background-build.png" alt="Background cmake build with titles queued" width="720">
</p>

RetComM checks for updates, rebuilds with existing build data when possible,
uses the same platform build tools as per-title launchers, and automates
BIOS/ROM/save plumbing so you are not stuck repeating each game’s wizard by hand.
<!-- /retcomm-readme-launcher -->

## Legal

You must own the original game and provide both supported disc images. Disc
images under `disc/` are ignored by Git and must never be committed. The
package contains no retail BIOS. Supply a supported USA-region SCPH BIOS from
hardware that you own. OpenBIOS is not used.

Default app icon: `assets/psxrecomp.ico` (and `.png` / `.svg`) — RetComM-themed controller mark from `psxrecomp/assets/`. Windows builds embed it via `APP_ICON`.

Optional box art under `launcher_assets/img/` may come from
[libretro-thumbnails](https://github.com/libretro-thumbnails/libretro-thumbnails)
(`Named_Boxarts`); see `BOXART_SOURCE.txt` when present.

## Quick start (dev)

```bash
git submodule update --init --recursive
./psxrecomp/tools/ci/build_emitters.sh
python3 psxrecomp/psxrecomp_cli.py generate \
  --config game.toml --project-root . --disc disc/<your>.cue
cmake -S . -B build-release -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build-release --target psx-runtime
```

Zip prefix for CI artifacts: `Parasite-Eve-Recompiled`.

## Symbols

Progressive map: `symbols.toml` → `python3 tools/sync_symbols.py` →
`psx_symbols.h` (`PSX_FN_*`). See `psxrecomp/docs/SYMBOLS.md`.

## Framework pins

Submodule gitlinks (`psxrecomp`, optional `recomp-ui`, nested `recomp-net`)
are authoritative. `framework_pins.txt` is an optional scaffold snapshot;
release CI logs SHAs with `record_pins.sh` but builds whatever the gitlinks
resolve to. Bump submodules deliberately — do not float on `main`/`master`
in release CI.

<!-- retcomm-readme-raid -->
---

<p align="center">
  <sub><b>R.A.I.D. — Retro AI Development</b> · a Discord for AI-assisted retro reverse-engineering, decomp &amp; recomp</sub>
</p>

<p align="center">
  <a href="https://discord.gg/Ad9BwSzctP"><img src=".github/raid-discord.png" alt="Join the Retro AI Development (R.A.I.D.) Discord" width="200"></a>
</p>
<!-- /retcomm-readme-raid -->

## Platform support

Release 0.3.3 supports Windows x64. Linux and macOS remain in the workflow,
but their release jobs are deferred under the Wave 2 Windows-first exception.

## Multi-disc status

Both supported discs contain the same executable. The setup host validates and
remembers both images. Each disc passed an independent startup test. A natural
in-game disc change still needs a connected manual gameplay test.

## License boundary

Portfolio-owned source, scripts, configuration, and documentation use
GPL-3.0-only. The `LICENSE` file contains the complete terms.

PSXRecomp keeps PolyForm Noncommercial 1.0.0. Recomp-UI keeps MIT. The GPL
does not cover retail content, generated retail code, artwork, trademarks, or
these separately licensed dependencies.

## About this project

These ports are developed by a hobbyist (a DevSecOps engineer, not a game
programmer) with substantial AI assistance. Every release must pass its
recorded build, package, and gameplay gates. AI writes most of the code, but I
always test it myself before pushing. Bug reports are welcome.

## v0.3.5 three-platform candidate

The next release targets Windows x64, Linux x64, macOS Apple Silicon ARM64,
and macOS Intel x64. These packages remain candidates until the exact archives
pass the required native setup, startup, responsiveness, and clean-exit gates.
