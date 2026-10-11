# vAmigaWeb build for geekychris.github.io

This branch is the exact source of the vAmigaWeb build used by the Amiga dev bench at
https://geekychris.github.io/tools/amiga-devbench/ — upstream commit
42bdfa2f70c0f1a34d6bad74a378c021cf04e42a, unchanged, plus the files in this folder:

- `build.sh` — the Emscripten/CMake/Ninja build used to produce `vAmiga.js` / `vAmiga.wasm`.
- `patch_index.py` — the only changes, applied to the generated `index.html` (analytics, PWA
  manifest and service worker removed; unused editor bundle not loaded; icon tweaks). No C++ or
  JavaScript source is modified.
- `SOURCE.md` — licences and provenance (vAmigaWeb GPL-3.0, vAmiga core MPL-2.0, AROS ROM under
  the AROS Public License).

All credit to Dirk W. Hoffmann (vAmiga) and mithrendal and contributors (vAmigaWeb).
