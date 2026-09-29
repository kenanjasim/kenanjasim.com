#!/usr/bin/env bash
# Check every old kenanjasim.com URL in redirect-map.csv returns a 301 to the expected new URL.
set -euo pipefail
cd "$(dirname "$0")"

fail=0
while IFS=, read -r old new status _; do
  [[ "$old" == "old_url" ]] && continue
  read -r code location < <(curl -s -o /dev/null -w '%{http_code} %{redirect_url}\n' "$old")
  if [[ "$code" == "$status" && "$location" == "$new" ]]; then
    echo "ok    $old"
  else
    echo "FAIL  $old -> got $code ${location:-<none>}, want $status $new"
    fail=1
  fi
done < redirect-map.csv

exit $fail
