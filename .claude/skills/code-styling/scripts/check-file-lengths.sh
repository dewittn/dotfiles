#!/usr/bin/env bash
# Check files for length exceeding threshold
set -euo pipefail

THRESHOLD=${FILE_LENGTH_THRESHOLD:-600}
found=0

for file in "$@"; do
  [ -f "$file" ] || continue
  lines=$(wc -l < "$file")
  if [ "$lines" -gt "$THRESHOLD" ]; then
    printf "WARNING: %s (%d lines) — consider splitting\n" "$file" "$lines"
    found=1
  fi
done

exit "$found"
