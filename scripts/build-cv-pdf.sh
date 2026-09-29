#!/usr/bin/env bash
# Render the home page to a PDF CV with headless Chrome, using the print styles in assets/css/cv.css.
# Usage: scripts/build-cv-pdf.sh [output.pdf]   (default: static/cv.pdf)
# Set CHROME=/path/to/chrome if it isn't found automatically.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
out="${1:-$root/static/cv.pdf}"
port="${CV_PORT:-8765}"
tmp="$(mktemp -d)"
server=""
trap '[[ -n "$server" ]] && kill "$server" 2>/dev/null; rm -rf "$tmp"' EXIT

chrome="${CHROME:-}"
if [[ -z "$chrome" ]]; then
  for c in google-chrome google-chrome-stable chromium chromium-browser \
           "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"; do
    if command -v "$c" >/dev/null 2>&1; then chrome="$(command -v "$c")"; break; fi
    if [[ -x "$c" ]]; then chrome="$c"; break; fi
  done
fi
[[ -n "$chrome" ]] || { echo "Chrome/Chromium not found; set CHROME" >&2; exit 1; }

# Production build (so TODO placeholders are left out), served locally for Chrome to print
hugo --quiet --source "$root" --environment production \
  --baseURL "http://127.0.0.1:$port/" --destination "$tmp/site"
python3 -m http.server "$port" --bind 127.0.0.1 --directory "$tmp/site" >/dev/null 2>&1 &
server=$!
disown "$server"
for _ in $(seq 50); do
  curl -fs "http://127.0.0.1:$port/" >/dev/null && break
  sleep 0.1
done

"$chrome" --headless=new --disable-gpu --no-sandbox --no-pdf-header-footer \
  --virtual-time-budget=5000 --print-to-pdf="$tmp/cv.pdf" "http://127.0.0.1:$port/" 2>/dev/null

mkdir -p "$(dirname "$out")"
cp "$tmp/cv.pdf" "$out"
echo "Wrote $out"
