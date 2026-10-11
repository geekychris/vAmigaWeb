# vAmigaWeb — self-hosted build for the Amiga dev bench

- vAmiga emulator core © Dirk W. Hoffmann, Mozilla Public License 2.0 — https://github.com/dirkwhoffmann/vAmiga
- vAmigaWeb (web front end and WebAssembly port) © mithrendal and contributors, GNU GPL v3
  (LICENSE) — https://github.com/vAmigaWeb/vAmigaWeb
- Built from vAmigaWeb commit 42bdfa2f70c0f1a34d6bad74a378c021cf04e42a (which includes the vAmiga
  core under `Core/`) with Emscripten 6.0.12, CMake and Ninja: `tools/wasm/vamiga/build.sh` in the
  gitwebsite repository. Corresponding source: https://github.com/vAmigaWeb/vAmigaWeb/tree/42bdfa2f70c0f1a34d6bad74a378c021cf04e42a
- Changes from upstream, all in the generated `index.html` (`tools/wasm/vamiga/patch_index.py`):
  the third-party analytics script, the PWA manifest and the service-worker registration are
  removed, the unused script-editor bundle is not loaded, and `height=auto` on inline SVG icons is
  dropped. The app icon is resized to 76 px. Unused files (documentation, source maps, other ROMs,
  editor bundle, debugging console) are omitted. No C++ or JavaScript source is modified.
- `roms/aros-rom-20260820.bin` and `roms/aros-ext-20260820.bin`: the AROS Kickstart replacement
  ROM, © The AROS Development Team, AROS Public License (https://aros.sourceforge.io/license.html);
  built from AROS Git 3ffc074471 — source at https://github.com/aros-development-team/AROS.
  Shipped unmodified, as distributed with vAmigaWeb.
