#!/bin/bash
# docker_job_search.sh - Orchestrate job search via Docker containers
#
# This script runs the job search workflow in isolated Docker containers:
# 1. Pipeline Agent (with web access) searches and fetches job listings
# 2. Review Agent (process isolated) evaluates jobs and writes summary
#
# Usage: docker_job_search.sh [--test] [--skip-pipeline] [--run-dir DIR] [--refresh-auth]
#   --test          Run minimal search (1-2 jobs) for testing
#   --skip-pipeline Skip pipeline, just run review on existing jobs
#   --run-dir DIR   Use specific run directory (for --skip-pipeline)
#   --refresh-auth  Re-authenticate with Claude (run interactive OAuth flow)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Log functions
error() { echo -e "${RED}ERROR:${NC} $*" >&2; }
warn() { echo -e "${YELLOW}WARNING:${NC} $*" >&2; }
success() { echo -e "${GREEN}✓${NC} $*"; }
info() { echo "$*"; }

# Configuration
PROJECT_DIR="${PROJECT_DIR:-/Users/dewittn/Programing/dewittn/Other/el-archivo-en-vivo}"
JOBS_DIR="$PROJECT_DIR/jobs"
CREDS_VOL="claude-credentials"
IMAGE="claude-job-search:latest"
DATE_ISO=$(date +%Y-%m-%d)
DOCKER_CONTEXT="orbstack"  # Use OrbStack for faster container execution

# Pre-flight checks
preflight_checks() {
    local failures=0

    info "Running pre-flight checks..."

    # Check Docker is running
    if ! docker info >/dev/null 2>&1; then
        error "Docker is not running. Start OrbStack or Docker Desktop."
        failures=$((failures + 1))
    else
        success "Docker is running"
    fi

    # Ensure correct Docker context
    local context=$(docker context show 2>/dev/null)
    if [[ "$context" != "$DOCKER_CONTEXT" ]]; then
        info "Switching Docker context from '$context' to '$DOCKER_CONTEXT'..."
        if docker context use "$DOCKER_CONTEXT" >/dev/null 2>&1; then
            success "Docker context set to $DOCKER_CONTEXT"
        else
            error "Failed to switch to Docker context '$DOCKER_CONTEXT'"
            failures=$((failures + 1))
        fi
    else
        success "Docker context is $DOCKER_CONTEXT"
    fi

    # Check image exists
    if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
        error "Docker image '$IMAGE' not found."
        error "Build it with: cd ~/.claude && docker build -f docker/Dockerfile.job-search -t $IMAGE ."
        failures=$((failures + 1))
    else
        success "Docker image '$IMAGE' exists"
    fi

    # Check credentials volume exists
    if ! docker volume inspect "$CREDS_VOL" >/dev/null 2>&1; then
        error "Credentials volume '$CREDS_VOL' not found."
        error "Create it with: docker volume create $CREDS_VOL"
        failures=$((failures + 1))
    else
        success "Credentials volume '$CREDS_VOL' exists"
    fi

    # Check OAuth token exists in volume
    local token_check=$(docker run --rm \
        -v "$CREDS_VOL:/home/agent/.claude" \
        alpine:latest \
        sh -c "test -f /home/agent/.claude/.credentials.json && echo exists" 2>/dev/null)

    if [[ "$token_check" != "exists" ]]; then
        error "OAuth token not found in credentials volume."
        error "Re-authenticate with: $0 --refresh-auth"
        failures=$((failures + 1))
    else
        success "OAuth token found in credentials volume"
        # Check token freshness (warning only, not a failure)
        check_token_freshness
    fi

    echo ""

    if [[ $failures -gt 0 ]]; then
        error "$failures pre-flight check(s) failed. Fix and try again."
        exit 1
    fi

    success "All pre-flight checks passed"
    echo ""
}

# Run container with error handling
run_container() {
    local container_name="$1"
    local network_mode="$2"
    local prompt="$3"
    local max_turns="$4"
    local extra_mounts="${5:-}"

    local docker_args=(
        "--rm"
        "-v" "$CREDS_VOL:/home/agent/.claude"
        "-v" "$JOBS_DIR:/workspace/jobs"
    )

    # Add extra mounts
    if [[ -n "$extra_mounts" ]]; then
        while IFS= read -r mount; do
            docker_args+=("-v" "$mount")
        done <<< "$extra_mounts"
    fi

    # Network mode
    if [[ "$network_mode" == "none" ]]; then
        docker_args+=("--network" "none")
    fi

    docker_args+=("-w" "/workspace" "$IMAGE")

    # Capture both stdout and stderr, check exit code
    local output
    local exit_code

    output=$(docker run "${docker_args[@]}" \
        claude --dangerously-skip-permissions \
            -p "$prompt" \
            --output-format json \
            --max-turns "$max_turns" 2>&1) || exit_code=$?

    # Check for common error patterns
    if [[ $exit_code -ne 0 ]] || echo "$output" | grep -qi "error\|failed\|unauthorized\|authentication"; then
        error "Container '$container_name' may have encountered issues"

        # Check for auth errors
        if echo "$output" | grep -qi "unauthorized\|authentication\|token\|401\|403"; then
            error "Authentication error detected. Re-run OAuth setup:"
            error "  docker run -it -v $CREDS_VOL:/home/agent/.claude docker/sandbox-templates:claude-code claude --dangerously-skip-permissions"
        fi

        # Show last 20 lines of output for debugging
        warn "Last 20 lines of output:"
        echo "$output" | tail -20
        echo ""
    fi

    echo "$output"
}

# Refresh OAuth credentials
refresh_auth() {
    info "Starting interactive OAuth flow..."
    info "This will open a browser window for authentication."
    echo ""
    docker run -it --rm \
        -v "$CREDS_VOL:/home/agent/.claude" \
        docker/sandbox-templates:claude-code \
        claude --dangerously-skip-permissions
    success "OAuth flow complete"
}

# Check if token exists and is recent (less than 6 hours old)
check_token_freshness() {
    local token_age
    token_age=$(docker run --rm \
        -v "$CREDS_VOL:/home/agent/.claude" \
        alpine:latest \
        sh -c "
            if [ -f /home/agent/.claude/.credentials.json ]; then
                # Get file modification time in seconds since epoch
                stat -c %Y /home/agent/.claude/.credentials.json 2>/dev/null || stat -f %m /home/agent/.claude/.credentials.json
            else
                echo 0
            fi
        " 2>/dev/null)

    if [[ -z "$token_age" ]] || [[ "$token_age" == "0" ]]; then
        return 1  # No token
    fi

    local now=$(date +%s)
    local age_hours=$(( (now - token_age) / 3600 ))

    if [[ $age_hours -ge 6 ]]; then
        warn "OAuth token is $age_hours hours old (max 8-12 hours)"
        warn "Consider running with --refresh-auth if you experience auth errors"
        return 0  # Still valid but warn
    fi

    return 0  # Token is fresh
}

# Parse arguments
TEST_MODE=false
SKIP_PIPELINE=false
SPECIFIED_RUN_DIR=""
REFRESH_AUTH=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --test) TEST_MODE=true; shift ;;
        --skip-pipeline) SKIP_PIPELINE=true; shift ;;
        --run-dir) SPECIFIED_RUN_DIR="$2"; shift 2 ;;
        --refresh-auth) REFRESH_AUTH=true; shift ;;
        -h|--help)
            echo "Usage: docker_job_search.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --test          Run minimal search (1-2 jobs) for testing"
            echo "  --skip-pipeline Skip pipeline, just run review on existing jobs"
            echo "  --run-dir DIR   Use specific run directory (for --skip-pipeline)"
            echo "  --refresh-auth  Re-authenticate with Claude (run interactive OAuth flow)"
            echo "  -h, --help      Show this help message"
            exit 0
            ;;
        *) error "Unknown option: $1"; exit 1 ;;
    esac
done

# Handle refresh-auth mode
if [[ "$REFRESH_AUTH" == true ]]; then
    refresh_auth
    exit 0
fi

# Determine run directory name (YYYY-MM-DD-NNN format)
determine_run_dir() {
    local suffix=1
    local run_dir

    while true; do
        run_dir=$(printf "%s-%03d" "$DATE_ISO" "$suffix")
        if [ ! -d "$JOBS_DIR/$run_dir" ]; then
            echo "$run_dir"
            return
        fi
        suffix=$((suffix + 1))
    done
}

# Use specified run dir or determine new one
if [ -n "$SPECIFIED_RUN_DIR" ]; then
    RUN_DIR="$SPECIFIED_RUN_DIR"
elif [ "$SKIP_PIPELINE" = true ]; then
    # Find most recent run directory for today
    RUN_DIR=$(ls -d "$JOBS_DIR"/$DATE_ISO-* 2>/dev/null | sort -V | tail -1 | xargs basename 2>/dev/null || echo "")
    if [ -z "$RUN_DIR" ]; then
        echo "ERROR: No existing run directory found for today. Use --run-dir to specify one."
        exit 1
    fi
else
    RUN_DIR=$(determine_run_dir)
fi

RUN_PATH="$JOBS_DIR/$RUN_DIR"

info "Run directory: $RUN_DIR"
echo ""

# Create directory structure
mkdir -p "$RUN_PATH/descriptions" "$RUN_PATH/quarantine"

# Run pre-flight checks
preflight_checks

# Run security audit
info "Running security audit..."
if ! python3 ~/.claude/scripts/job_search_security_audit.py; then
    error "Security audit failed. Fix issues and try again."
    exit 1
fi
echo ""

# Step 1: Pipeline Agent (skip if --skip-pipeline)
if [ "$SKIP_PIPELINE" = false ]; then
    info "Starting Pipeline Agent container..."

    if [ "$TEST_MODE" = true ]; then
        PIPELINE_PROMPT="Search for 1-2 'platform engineer remote' jobs on greenhouse.io. Fetch the listings and write to jobs/$RUN_DIR/descriptions/ using the filename format NNN-Company-Title.md (e.g., 001-Acme-Corp-Platform-Engineer.md). Sanitize filenames: replace spaces with hyphens, remove special chars (: / \\ ? * \" < > |), replace & with 'and', title case, max 30 chars for company and 40 for title. Return only {\"status\":\"complete\",\"jobs_found\":N,\"jobs_written\":N,\"urls_blocked\":0,\"quarantine_flags\":0}"
        MAX_TURNS=15
    else
        PIPELINE_PROMPT="Run a comprehensive job search using these criteria:
Target roles: Platform Engineer, Solutions Architect, Staff Engineer (Infrastructure), DevOps, SRE, AI Engineer
Target companies: GitLab, Fly.io, Railway, Cloudflare, Vercel, Netlify, Tailscale, Anthropic, 1Password
Search job boards (greenhouse.io, lever.co, ashbyhq.com) for remote positions.

Write each job to jobs/$RUN_DIR/descriptions/ using filename format: NNN-Company-Title.md
Example: 001-Anthropic-Platform-Engineer.md, 002-Cloudflare-Staff-SRE.md

Filename sanitization rules:
- Replace spaces with hyphens
- Remove: : / \\ ? * \" < > | # @ % \$ ;
- Replace & with 'and'
- Title case each word
- Max 30 chars for company, 40 for title
- Keep non-ASCII chars (accents, etc.)

Write index.json to jobs/$RUN_DIR/index.json

Return only {\"status\":\"complete\",\"jobs_found\":N,\"jobs_written\":N,\"urls_blocked\":N,\"quarantine_flags\":N}"
        MAX_TURNS=50
    fi

    PIPELINE_EXIT=0
    PIPELINE_RESULT=$(docker run --rm \
        -v "$CREDS_VOL:/home/agent/.claude" \
        -v "$JOBS_DIR:/workspace/jobs" \
        -w /workspace \
        "$IMAGE" \
        claude --dangerously-skip-permissions \
            --no-session-persistence \
            -p "$PIPELINE_PROMPT" \
            --output-format json \
            --max-turns $MAX_TURNS 2>&1) || PIPELINE_EXIT=$?

    if [[ $PIPELINE_EXIT -ne 0 ]]; then
        warn "Pipeline container exited with code $PIPELINE_EXIT"
        if echo "$PIPELINE_RESULT" | grep -qi "unauthorized\|authentication\|token expired"; then
            error "Authentication error - OAuth token may have expired"
            error "Re-authenticate with:"
            error "  docker run -it -v $CREDS_VOL:/home/agent/.claude docker/sandbox-templates:claude-code claude --dangerously-skip-permissions"
            exit 1
        fi
        warn "Output: $(echo "$PIPELINE_RESULT" | tail -10)"
    fi

    # Extract result from JSON envelope
    PIPELINE_STATUS=$(echo "$PIPELINE_RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('result','{}'))" 2>/dev/null || echo "{}")

    success "Pipeline complete"
    info "Result: $PIPELINE_STATUS"
    echo ""
fi

# Step 2: Review Agent (process isolated)
info "Starting Review Agent container..."

REVIEW_EXIT=0
REVIEW_RESULT=$(docker run --rm \
    -v "$CREDS_VOL:/home/agent/.claude" \
    -v "$JOBS_DIR:/workspace/jobs" \
    -v "$PROJECT_DIR/Prompts:/workspace/Prompts:ro" \
    -v "$PROJECT_DIR/key-insights-nelson-career.md:/workspace/key-insights-nelson-career.md:ro" \
    -w /workspace \
    "$IMAGE" \
    claude --dangerously-skip-permissions \
        --no-session-persistence \
        -p "Evaluate all jobs in jobs/$RUN_DIR/descriptions/ against the methodology fit criteria. Read key-insights-nelson-career.md for context. Score each job /60 and classify as High/Medium/Lower fit. Write summary to jobs/$RUN_DIR/summary.md. Return only {\"complete\":true,\"evaluated\":N,\"high_fit\":N,\"medium_fit\":N,\"low_fit\":N,\"summary_file\":\"jobs/$RUN_DIR/summary.md\"}" \
        --output-format json \
        --max-turns 20 2>&1) || REVIEW_EXIT=$?

if [[ $REVIEW_EXIT -ne 0 ]]; then
    warn "Review container exited with code $REVIEW_EXIT"
    if echo "$REVIEW_RESULT" | grep -qi "unauthorized\|authentication\|token expired"; then
        error "Authentication error - OAuth token may have expired"
        error "Re-authenticate with:"
        error "  docker run -it -v $CREDS_VOL:/home/agent/.claude docker/sandbox-templates:claude-code claude --dangerously-skip-permissions"
        exit 1
    fi
    warn "Output: $(echo "$REVIEW_RESULT" | tail -10)"
fi

# Extract result from JSON envelope
REVIEW_STATUS=$(echo "$REVIEW_RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('result','{}'))" 2>/dev/null || echo "{}")

success "Review complete"
info "Result: $REVIEW_STATUS"
echo ""

# Step 3: Post-workflow security audit
info "Running post-workflow security audit..."
AUDIT_RESULT=$(python3 ~/.claude/scripts/post_workflow_audit.py "$RUN_DIR" 2>&1)
AUDIT_EXIT=$?

if [[ $AUDIT_EXIT -eq 0 ]]; then
    success "Security audit passed"
    # Extract summary
    AUDIT_SUMMARY=$(echo "$AUDIT_RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); s=d.get('summary',{}); print(f\"Writes: {s.get('writes_checked',0)}, Jobs: {s.get('job_files',0)}, Flagged: {s.get('flagged_content',0)}\")" 2>/dev/null || echo "")
    if [[ -n "$AUDIT_SUMMARY" ]]; then
        info "  $AUDIT_SUMMARY"
    fi
    # Check for warnings
    WARNINGS=$(echo "$AUDIT_RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); w=d.get('warnings',[]); print('\\n'.join(w))" 2>/dev/null || echo "")
    if [[ -n "$WARNINGS" ]]; then
        warn "$WARNINGS"
    fi
else
    warn "Security audit flagged issues"
    # Show issues
    ISSUES=$(echo "$AUDIT_RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); print('\\n'.join(d.get('issues',[])))" 2>/dev/null || echo "Unknown issue")
    warn "$ISSUES"
fi
echo ""

# Final report
echo "=========================================="
success "Job search complete"
echo ""
info "Run folder: $RUN_DIR"
echo ""
info "Contents:"
info "  $RUN_PATH/descriptions/       - Job listings"
info "  $RUN_PATH/summary.md          - Evaluation results"
info "  $RUN_PATH/quarantine/         - Flagged content (if any)"
info "  $RUN_PATH/index.json          - Job metadata"
info "  $RUN_PATH/workflow-status.json - Audit results"
echo ""
info "To review:"
info "  open $RUN_PATH/summary.md"
echo ""
info "Audit logs (root level):"
info "  $JOBS_DIR/audit.jsonl       - All web calls"
info "  $JOBS_DIR/write-audit.jsonl - Content scans"
echo "=========================================="
