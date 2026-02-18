#!/bin/bash
# Reads a .started timestamp file, calculates duration, optionally logs it, and cleans up.
# Usage: log-duration.sh <docs-dir> <NNN> <feature-slug> [--log <project-name>]
# Example: log-duration.sh ./docs 001 hybrid-memory-search --log wfid-manuscript-v2
#
# Without --log: prints duration and deletes .started file
# With --log: also appends to ~/.claude/docs/planning/planning-log.md

set -euo pipefail

DOCS_DIR="${1:?Usage: log-duration.sh <docs-dir> <NNN> <feature-slug> [--log <project-name>]}"
NUM="${2:?Usage: log-duration.sh <docs-dir> <NNN> <feature-slug> [--log <project-name>]}"
SLUG="${3:?Usage: log-duration.sh <docs-dir> <NNN> <feature-slug> [--log <project-name>]}"

STARTED_FILE="${DOCS_DIR}/.feature-plan-${NUM}-${SLUG}.started"

if [ ! -f "$STARTED_FILE" ]; then
    echo "Error: No timer found at $STARTED_FILE"
    exit 1
fi

START_TS=$(cat "$STARTED_FILE")
END_TS=$(date -u +"%Y-%m-%dT%H:%M:%S")

# Calculate duration in seconds (macOS date)
START_EPOCH=$(date -juf "%Y-%m-%dT%H:%M:%S" "$START_TS" +"%s" 2>/dev/null) || \
    START_EPOCH=$(date -d "$START_TS" +"%s" 2>/dev/null)  # Linux fallback
END_EPOCH=$(date -juf "%Y-%m-%dT%H:%M:%S" "$END_TS" +"%s" 2>/dev/null) || \
    END_EPOCH=$(date -d "$END_TS" +"%s" 2>/dev/null)

DIFF=$((END_EPOCH - START_EPOCH))
MINUTES=$((DIFF / 60))

if [ $MINUTES -lt 1 ]; then
    DURATION="<1 min"
elif [ $MINUTES -lt 60 ]; then
    DURATION="~${MINUTES} min"
else
    HOURS=$((MINUTES / 60))
    REMAINING=$((MINUTES % 60))
    DURATION="~${HOURS}h ${REMAINING}m"
fi

echo "Started:  $START_TS"
echo "Ended:    $END_TS"
echo "Duration: $DURATION"

# Log if requested
if [ "${4:-}" = "--log" ]; then
    PROJECT="${5:?--log requires a project name}"
    LOG_DIR="$HOME/.claude/docs/planning"
    LOG_FILE="$LOG_DIR/planning-log.md"
    TODAY=$(date +"%Y-%m-%d")

    mkdir -p "$LOG_DIR"

    if [ ! -f "$LOG_FILE" ]; then
        cat > "$LOG_FILE" << 'HEADER'
# Planning Log

| Date | Project | Feature | Duration |
|------|---------|---------|----------|
HEADER
    fi

    echo "| $TODAY | $PROJECT | $SLUG | $DURATION |" >> "$LOG_FILE"
    echo "Logged to $LOG_FILE"
fi

# Clean up
rm "$STARTED_FILE"
echo "Timer file removed."
