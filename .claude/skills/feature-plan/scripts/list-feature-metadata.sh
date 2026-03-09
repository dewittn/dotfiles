#!/bin/bash
# Reads YAML frontmatter from feature docs and outputs structured metadata.
# Usage: list-feature-metadata.sh <features-dir>
# Example: list-feature-metadata.sh ~/Programing/dewittn/agentic-docs/projects/dotfiles/features
# Scans *.md in <features-dir> and <features-dir>/complete/

set -euo pipefail

DIR="${1:?Usage: list-feature-metadata.sh <features-dir>}"

extract_metadata() {
    local file="$1"
    local filename
    filename="$(basename "$file")"

    local in_frontmatter=0
    local status=""
    local systems=""

    # Extract frontmatter fields with awk (POSIX-compatible, avoids macOS sed quirks)
    while IFS= read -r line; do
        if [ "$in_frontmatter" -eq 0 ] && [ "$line" = "---" ]; then
            in_frontmatter=1
            continue
        fi
        if [ "$in_frontmatter" -eq 1 ] && [ "$line" = "---" ]; then
            break
        fi
        if [ "$in_frontmatter" -eq 1 ]; then
            case "$line" in
                status:*) status="$(echo "$line" | awk -F': ' '{print $2}')" ;;
                systems:*) systems="$(echo "$line" | awk -F': ' '{$1=""; print $0}' | sed 's/^ //')" ;;
            esac
        fi
    done < "$file"

    echo "file: $filename"
    echo "status: ${status:-unknown}"
    echo "systems: ${systems:-[]}"
    echo ""
}

# Scan main directory
if [ -d "$DIR" ]; then
    for f in "$DIR"/*.md; do
        [ -f "$f" ] || continue
        extract_metadata "$f"
    done
fi

# Scan complete/ subdirectory
if [ -d "$DIR/complete" ]; then
    for f in "$DIR/complete"/*.md; do
        [ -f "$f" ] || continue
        extract_metadata "$f"
    done
fi
