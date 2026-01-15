#!/bin/bash
# Claude Code Status Line
# Displays: Model | Directory | Git Branch | Context Usage

input=$(cat)

# Extract values from JSON
MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"')
USED=$(echo "$input" | jq -r '.context_window.used // 0')
MAX=$(echo "$input" | jq -r '.context_window.max // 1')

# Shorten directory to basename
DIR_SHORT="${DIR##*/}"

# Calculate context percentage
if [ "$MAX" -gt 0 ] 2>/dev/null; then
    PCT=$((USED * 100 / MAX))
else
    PCT=0
fi

# Get git branch if in a repo
BRANCH=""
if git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH_NAME=$(git -C "$DIR" branch --show-current 2>/dev/null)
    [ -n "$BRANCH_NAME" ] && BRANCH=" | $BRANCH_NAME"
fi

# ANSI colors
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RESET='\033[0m'

# Color context based on usage
if [ "$PCT" -lt 50 ]; then
    CTX_COLOR="$GREEN"
elif [ "$PCT" -lt 80 ]; then
    CTX_COLOR="$YELLOW"
else
    CTX_COLOR='\033[31m'  # Red
fi

echo -e "${CYAN}${MODEL}${RESET} | ${DIR_SHORT}${GREEN}${BRANCH}${RESET} | ${CTX_COLOR}${PCT}%${RESET}"
