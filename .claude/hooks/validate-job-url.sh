#!/bin/bash
#
# validate-job-url.sh - Validate and audit web requests for job search workflow
#
# This hook runs BEFORE WebFetch/WebSearch calls to:
# 1. Log all web requests to audit.jsonl
# 2. Block requests to non-allowlisted domains
#
# Exit codes:
#   0 = Allow the request
#   2 = Block the request
#
# Usage: Called automatically by Claude Code PreToolUse hook
# Input: JSON on stdin with tool_name and tool_input

set -euo pipefail

# Configuration
ALLOWED_DOMAINS="greenhouse.io|lever.co|ashbyhq.com|linkedin.com|indeed.com|jobs.github.com|wellfound.com|angel.co|workable.com|breezy.hr|recruitee.com|smartrecruiters.com|icims.com|workday.com|myworkdayjobs.com|jobvite.com|1password.com|anthropic.com|docs.anthropic.com|support.anthropic.com|code.claude.com|openai.com|fly.io|railway.app|render.com|cloudflare.com|vercel.com|netlify.com|digitalocean.com|tailscale.com|hashicorp.com|ghost.org|substack.com|medium.com|sourcegraph.com|replit.com|cursor.com"

# Find the jobs directory (look in common locations)
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

    # Create default if none exists
    local default="${PWD}/jobs"
    mkdir -p "$default"
    echo "$default"
}

# Read input from stdin
INPUT=$(cat)

# Extract tool name and target (URL or query)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
URL=$(echo "$INPUT" | jq -r '.tool_input.url // empty')
QUERY=$(echo "$INPUT" | jq -r '.tool_input.query // empty')

# Determine what we're checking
TARGET=""
if [[ -n "$URL" ]]; then
    TARGET="$URL"
elif [[ -n "$QUERY" ]]; then
    TARGET="$QUERY"
fi

# Get timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Find jobs directory for audit log
JOBS_DIR=$(find_jobs_dir)
AUDIT_LOG="${JOBS_DIR}/audit.jsonl"

# Ensure audit log directory exists
mkdir -p "$(dirname "$AUDIT_LOG")"

# Log the request (always, even if blocked)
log_request() {
    local status="$1"
    local reason="${2:-}"

    local log_entry=$(jq -n \
        --arg ts "$TIMESTAMP" \
        --arg tool "$TOOL_NAME" \
        --arg target "$TARGET" \
        --arg status "$status" \
        --arg reason "$reason" \
        '{timestamp: $ts, tool: $tool, target: $target, status: $status, reason: $reason}')

    echo "$log_entry" >> "$AUDIT_LOG"
}

# For WebSearch, we allow most queries (hard to validate)
if [[ "$TOOL_NAME" == "WebSearch" ]]; then
    log_request "allowed" "search_query"
    exit 0
fi

# For WebFetch, validate the domain
if [[ "$TOOL_NAME" == "WebFetch" && -n "$URL" ]]; then
    # Extract domain from URL
    DOMAIN=$(echo "$URL" | sed -E 's|^https?://([^/]+).*|\1|' | sed 's/^www\.//')

    # Check against allowlist
    if echo "$DOMAIN" | grep -qE "($ALLOWED_DOMAINS)"; then
        log_request "allowed" "domain_allowlisted"
        exit 0
    else
        log_request "blocked" "domain_not_allowlisted: $DOMAIN"
        echo "BLOCKED: Domain '$DOMAIN' is not in the allowed job board list." >&2
        echo "Allowed domains: greenhouse.io, lever.co, ashbyhq.com, linkedin.com, etc." >&2
        exit 2
    fi
fi

# Default: allow (for other tools we don't specifically handle)
log_request "allowed" "default_allow"
exit 0
