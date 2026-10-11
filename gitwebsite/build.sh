#!/usr/bin/env bash
# Build vAmigaWeb (Dirk Hoffmann's vAmiga core + mithrendal's web front end, GPL-3.0) from source
# and assemble the trimmed, self-hosted copy used by the Amiga dev bench:
#   site/static/wasm/vamiga/
# Requires Emscripten, CMake and Ninja (brew install emscripten cmake ninja).
set -euo pipefail
COMMIT="${VAMIGAWEB_COMMIT:-42bdfa2f70c0f1a34d6bad74a378c021cf04e42a}"
here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/../../.." && pwd)"
out="$repo/site/static/wasm/vamiga"
work="${WORK:-$(mktemp -d)}"
cd "$work"
[ -d vAmigaWeb ] || git clone -q https://github.com/vAmigaWeb/vAmigaWeb.git
cd vAmigaWeb && git checkout -q "$COMMIT"
mkdir -p build && cd build
emcmake cmake .. -G Ninja >/dev/null
ninja vAmiga
cd ..

rm -rf "$out"; mkdir -p "$out"/{js,css,img,sounds,roms}
cp build/vAmiga.js build/vAmiga.wasm LICENSE "$out/"
for f in jquery-3.7.1.min.js bootstrap.bundle.min.js vAmiga_browser.js ringbuffer.js vAmiga_canvas.js \
         vAmiga_canvas_gl_fast.js vAmiga_ui.js vAmiga_memview.js vAmiga_storage.js vAmiga_keyboard.js \
         vAmiga_action_script.js virtualjoystick.js jszip.min.js vAmiga_audioprocessor.js \
         vAmiga_audioprocessor_sharedarraybuffer.js; do cp "js/$f" "$out/js/"; done
cp css/bootstrap.min.css css/vAmiga.css "$out/css/"
cp img/{sprites.svg,rom_empty.png,rom.png,rom_unknown.png,rom_patched.png,rom_original.png,rom_hyperion.png,rom_aros.png,rom_emutos.png,favicon.ico,aros_half.png,emutos_header_shadow.png} "$out/img/"
# The 413 px app icon is only shown at 38 px: ship a 76 px copy.
sips -Z 76 img/icon_borderless_x413.png --out "$out/img/icon_borderless_x413.png" >/dev/null 2>&1 || cp img/icon_borderless_x413.png "$out/img/"
cp sounds/* "$out/sounds/"
# AROS Kickstart replacement (AROS Public License) — the free ROM the bench boots by default.
cp roms/aros-rom-20260820.bin roms/aros-ext-20260820.bin "$out/roms/"
sed -i '' 's|//# sourceMappingURL=.*||' "$out/js/bootstrap.bundle.min.js" 2>/dev/null || sed -i 's|//# sourceMappingURL=.*||' "$out/js/bootstrap.bundle.min.js"
sed -i '' 's|/\*# sourceMappingURL=.*\*/||' "$out/css/bootstrap.min.css" 2>/dev/null || sed -i 's|/\*# sourceMappingURL=.*\*/||' "$out/css/bootstrap.min.css"
# Embedding changes (documented in SOURCE.md): no third-party analytics, no PWA manifest/service
# worker (it would cache this sub-folder of the site aggressively), and no script editor bundle.
python3 "$here/patch_index.py" build/vAmiga.html "$out/index.html"
echo "vAmiga: $(du -sh "$out" | cut -f1) in $out"
