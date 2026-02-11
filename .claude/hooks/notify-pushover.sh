#!/usr/bin/env bash
# Send a Pushover notification when Claude Code is waiting for input

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/.env"

if [[ -z "$PUSHOVER_USER_KEY" || -z "$PUSHOVER_APP_TOKEN" ]]; then
  exit 0
fi

curl -s \
  --form-string "token=$PUSHOVER_APP_TOKEN" \
  --form-string "user=$PUSHOVER_USER_KEY" \
  --form-string "title=Claude Code" \
  --form-string "message=Waiting for your input" \
  https://api.pushover.net/1/messages.json > /dev/null 2>&1
