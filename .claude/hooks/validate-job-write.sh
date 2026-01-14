#!/bin/bash
#
# validate-job-write.sh - Validate and scan content before writing job files
#
# This hook runs BEFORE Write calls to:
# 1. Check if the write is to the jobs/ folder
# 2. Run the sanitizer on content
# 3. Log results (allows write but flags suspicious content)
#
# Exit codes:
#   0 = Allow the write
#   2 = Block the write (only for writes outside allowed paths)
#
# Note: We LOG suspicious content but don't block writes to avoid data loss.
# The Pipeline Agent is responsible for checking flagged.jsonl and moving
# suspicious files to quarantine/ if needed.
#
# Usage: Called automatically by Claude Code PreToolUse hook
# Input: JSON on stdin with tool_name and tool_input

set -euo pipefail

# Find the jobs directory
find_jobs_dir() {
    local search_paths=(
        "${PWD}/jobs"
        "/workspace/jobs"
        "${HOME}/Programing/dewittn/Other/el-archivo-en-vivo/jobs"
    )

    for path in "${search_paths[@]}"; do
        if [[ -d "$path" ]]; then
            echo "$path"
            return 0
        fi
    done

    echo ""
}

# Extract run directory from file path (e.g., /workspace/jobs/2026-01-12-001/descriptions/foo.md -> 2026-01-12-001)
extract_run_dir() {
    local file_path="$1"
    local jobs_dir="$2"

    # Remove jobs_dir prefix and get first path component
    local relative="${file_path#$jobs_dir/}"
    local run_dir="${relative%%/*}"

    # Check if it looks like a run directory (YYYY-MM-DD-NNN pattern)
    if [[ "$run_dir" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{3}$ ]]; then
        echo "$run_dir"
    else
        echo ""
    fi
}

# Read input from stdin
INPUT=$(cat)

# Extract tool info
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // empty')

# Only process Write tool calls
if [[ "$TOOL_NAME" != "Write" ]]; then
    exit 0
fi

# If no file path, allow (let the tool handle the error)
if [[ -z "$FILE_PATH" ]]; then
    exit 0
fi

# Find jobs directory
JOBS_DIR=$(find_jobs_dir)

# If no jobs directory found, this isn't a job search context - allow
if [[ -z "$JOBS_DIR" ]]; then
    exit 0
fi

# Normalize paths for comparison
JOBS_DIR_REAL=$(realpath "$JOBS_DIR" 2>/dev/null || echo "$JOBS_DIR")
FILE_PATH_REAL=$(realpath "$(dirname "$FILE_PATH")" 2>/dev/null || echo "$(dirname "$FILE_PATH")")

# If not writing to jobs/, this hook doesn't apply
if [[ "$FILE_PATH_REAL" != "$JOBS_DIR_REAL"* ]]; then
    exit 0
fi

# Get timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Path to sanitizer script (check both container and host locations)
SANITIZER=""
for path in "/home/agent/.claude/scripts/job_content_scanner.py" "${HOME}/.claude/scripts/job_content_scanner.py"; do
    if [[ -x "$path" ]]; then
        SANITIZER="$path"
        break
    fi
done

# Check if sanitizer exists
if [[ -z "$SANITIZER" ]]; then
    echo "WARNING: Sanitizer script not found" >&2
    exit 0  # Allow write but warn
fi

# Run sanitizer on content
# Note: sanitizer exits 0 for safe, 1 for unsafe - capture output regardless
SCAN_RESULT=$(echo "$CONTENT" | python3 "$SANITIZER" --stdin 2>/dev/null) || true

# If scanner failed completely, use fallback
if [[ -z "$SCAN_RESULT" ]] || ! echo "$SCAN_RESULT" | jq -e . >/dev/null 2>&1; then
    SCAN_RESULT='{"safe": false, "error": "scanner_failed", "matches": [], "match_count": 0}'
fi

# Parse result
IS_SAFE=$(echo "$SCAN_RESULT" | jq -r '.safe // false')
MATCH_COUNT=$(echo "$SCAN_RESULT" | jq -r '.match_count // 0')

# Write audit log to root jobs/ directory
WRITE_LOG="${JOBS_DIR}/write-audit.jsonl"
# Use jq to combine JSON safely - avoid shell expansion issues with matches array
log_entry=$(echo "$SCAN_RESULT" | jq -c --arg ts "$TIMESTAMP" --arg file "$FILE_PATH" \
    '{timestamp: $ts, file: $file, safe: .safe, match_count: (.match_count // 0), matches: (.matches // [])}')

echo "$log_entry" >> "$WRITE_LOG"

# If content is suspicious, log a warning but ALLOW the write
if [[ "$IS_SAFE" != "true" ]]; then
    echo "WARNING: Suspicious content detected in $FILE_PATH" >&2
    echo "Matches: $MATCH_COUNT pattern(s) found" >&2
    echo "Content will be written but flagged for review." >&2

    # Determine where to write flagged.jsonl
    # If file is in a run directory, use that run's quarantine folder
    RUN_DIR=$(extract_run_dir "$FILE_PATH" "$JOBS_DIR")

    if [[ -n "$RUN_DIR" ]]; then
        FLAGGED_LOG="${JOBS_DIR}/${RUN_DIR}/quarantine/flagged.jsonl"
    else
        # Fallback to root quarantine (legacy structure)
        FLAGGED_LOG="${JOBS_DIR}/quarantine/flagged.jsonl"
    fi

    mkdir -p "$(dirname "$FLAGGED_LOG")"

    # Use jq to combine JSON safely - avoid shell expansion issues with matches array
    flagged_entry=$(echo "$SCAN_RESULT" | jq -c --arg ts "$TIMESTAMP" --arg file "$FILE_PATH" \
        '{timestamp: $ts, file: $file, match_count: (.match_count // 0), matches: (.matches // []), action: "flagged_on_write"}')

    echo "$flagged_entry" >> "$FLAGGED_LOG"
    echo "Flagged content logged to: $FLAGGED_LOG" >&2
fi

# Always allow the write (defense-in-depth means we have other protections)
exit 0
