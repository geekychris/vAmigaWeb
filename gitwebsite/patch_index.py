"""Adapt vAmigaWeb's generated vAmiga.html for embedding in the dev bench (see SOURCE.md)."""
import re, sys
src, dst = sys.argv[1], sys.argv[2]
s = open(src, encoding='utf-8').read()
n0 = len(s)
# Third-party analytics: never load on this site.
s, a = re.subn(r'<script[^>]*cloud\.umami\.is[^>]*>\s*</script>', '', s)
# PWA bits: manifest, apple icon, service worker registration.
s, b = re.subn(r'<link[^>]*rel=manifest[^>]*>', '', s)
s, c = re.subn(r'<link[^>]*rel=apple-touch-icon[^>]*>', '', s)
s, d = re.subn(r'navigator\.serviceWorker\.register\("sw\.js"\)', 'Promise.resolve()', s)
# Script-editor bundle (1 MB) is not used by the bench.
s, e = re.subn(r'<script src=js/cm6/[^>]*>\s*</script>', '', s)
# SVG icons use height=auto, which Chrome rejects as an attribute (console noise); auto is the default.
s, f = re.subn(r'(<svg[^>]*?)\s?height=auto', r'\1', s)
assert a == 1 and b == 1 and d == 1 and e == 2, (a, b, c, d, e)
open(dst, 'w', encoding='utf-8').write(s)
print(f'index.html: {n0} -> {len(s)} bytes')
