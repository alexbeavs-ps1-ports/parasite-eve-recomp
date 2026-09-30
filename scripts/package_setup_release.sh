#!/usr/bin/env bash
# Thin wrapper around the shared psxrecomp setup-host packager.
# Autofilled by tools/new_project_layout/setup_project.{sh,ps1}.
#
# Usage:
#   scripts/package_setup_release.sh <build-dir> <artifact-tag> [recompiler-build-dir]
#
# Writes: dist/Parasite-Eve-Recompiled-<VERSION>-<artifact-tag>.zip
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="${1:-}"
ARTIFACT_TAG="${2:-}"
RECOMPILER_BUILD="${3:-build-recompiler}"

if [[ -z "${BUILD_DIR}" || -z "${ARTIFACT_TAG}" ]]; then
  echo "usage: $0 <build-dir> <artifact-tag> [recompiler-build-dir]" >&2
  exit 2
fi

# mods/ is staged by the framework packager by default (catalog next to the
# exe, plus the source catalog for the setup-host rebuild) -- no flag needed.
# --project-dir src ships game-owned trusted-plugin sources; CMakeLists.txt
# references them unconditionally, so the rebuild cannot configure without it.
# copy_proj skips a path that does not exist, so it is inert for titles with
# no src/.
PACKAGER="${ROOT}/psxrecomp/tools/package_setup_host.sh"
if [[ ! -f "${PACKAGER}" ]]; then
  echo "error: missing ${PACKAGER} (psxrecomp submodule)" >&2
  exit 1
fi
chmod +x "${PACKAGER}" 2>/dev/null || true

EXTRA_PROJECT=()
if [[ -f "${ROOT}/catalog_identity.json" ]]; then
  EXTRA_PROJECT+=(--project-file catalog_identity.json)
fi
if [[ -f "${ROOT}/framework_pins.txt" ]]; then
  EXTRA_PROJECT+=(--project-file framework_pins.txt)
fi
# Optional in-game options defaults (titles that POST_BUILD-copy this file).
if [[ -f "${ROOT}/game_options.toml" ]]; then
  EXTRA_PROJECT+=(--project-file game_options.toml)
fi
# Game-owned C that CMakeLists.txt compiles into the runtime — mod activation
# plugins live here (CODEGEN_SETUP_SOURCES "src/<game>_mods.c"). Leaving this
# out ships a CMakeLists that references a file the zip does not contain, so
# the build dies at configure with "Cannot find source file".
if [[ -d "${ROOT}/src" ]]; then
  EXTRA_PROJECT+=(--project-dir src)
fi
# Preloaded mod packages (mods/preloaded/packages/<id>). The activation plugin
# above is compiled in, but selects itself through these marker files; without
# them the mod is built and never enabled.
if [[ -d "${ROOT}/mods" ]]; then
  EXTRA_PROJECT+=(--project-dir mods)
fi
# Desktop/app icon sources. CMakeLists.txt passes APP_ICON
# "${CMAKE_CURRENT_SOURCE_DIR}/assets/psxrecomp.ico" unguarded, so a zip
# without assets/ cannot configure. runtime.cmake also stages the sibling
# psxrecomp.png from this directory as the SDL window icon, so the rebuilt exe
# would otherwise come out unbranded even if configure had survived.
if [[ -d "${ROOT}/assets" ]]; then
  EXTRA_PROJECT+=(--project-dir assets)
fi
if [[ -d "${ROOT}/launcher_assets" ]] &&
   find "${ROOT}/launcher_assets" -type f -print -quit | grep -q .; then
  EXTRA_PROJECT+=(--project-dir launcher_assets)
fi
# Generated symbol headers. Game-owned C in src/ includes these by relative
# path ("../psx_symbols.h"), so they are compile inputs of the shipped tree even
# though nothing in CMakeLists.txt names them.
for _sym in psx_symbols.h psx_symbols_overlays.h; do
  if [[ -f "${ROOT}/${_sym}" ]]; then
    EXTRA_PROJECT+=(--project-file "${_sym}")
  fi
done

cd "${ROOT}"
exec bash "${PACKAGER}" \
  --root "${ROOT}" \
  --build-dir "${BUILD_DIR}" \
  --artifact "${ARTIFACT_TAG}" \
  --zip-prefix Parasite-Eve-Recompiled \
  --exe-name Parasite_Eve \
  --display-name "Parasite Eve" \
  --recompiler-build "${RECOMPILER_BUILD}" \
  --version-env RELEASE_VERSION \
  --disc-hint "your legally owned Parasite Eve two-disc set" \
  --bios-hint "your own SCPH-1001 (USA) BIOS dump (524288 bytes; SHA-256 71af94d1e47a68c11e8fdb9f8368040601514a42a5a399cda48c7d3bff1e99d3)" \
  --project-file CMakeLists.txt \
  --project-file game.toml \
  --project-file VERSION \
  --project-file codegen_setup.c \
  --project-file codegen_setup.h \
  --project-file README.md \
  --project-file LICENSE \
  --project-file project-manifest.toml \
  --project-dir docs \
  --project-dir seeds \
  "${EXTRA_PROJECT[@]}"
