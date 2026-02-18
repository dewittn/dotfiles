#!/bin/bash
# Creates a .started timestamp file for tracking feature planning duration.
# Usage: start-timer.sh <docs-dir> <NNN> <feature-slug>
# Example: start-timer.sh ./docs 001 hybrid-memory-search
# Creates: docs/.feature-plan-001-hybrid-memory-search.started

set -euo pipefail

DOCS_DIR="${1:?Usage: start-timer.sh <docs-dir> <NNN> <feature-slug>}"
NUM="${2:?Usage: start-timer.sh <docs-dir> <NNN> <feature-slug>}"
SLUG="${3:?Usage: start-timer.sh <docs-dir> <feature-slug>}"

STARTED_FILE="${DOCS_DIR}/.feature-plan-${NUM}-${SLUG}.started"

if [ -f "$STARTED_FILE" ]; then
    echo "Timer already running: $STARTED_FILE"
    echo "Started at: $(cat "$STARTED_FILE")"
    exit 0
fi

mkdir -p "$DOCS_DIR"
date -u +"%Y-%m-%dT%H:%M:%S" > "$STARTED_FILE"
echo "Timer started: $STARTED_FILE"
echo "Timestamp: $(cat "$STARTED_FILE")"
