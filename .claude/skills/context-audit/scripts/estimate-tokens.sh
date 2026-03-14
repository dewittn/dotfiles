#!/usr/bin/env bash
# Estimate token count from word count for markdown files
# Multiplier: ~1.3 tokens per word (rough English prose estimate)
set -euo pipefail

MULTIPLIER="1.3"

if [ $# -eq 0 ]; then
  printf "Usage: %s <file|directory> [...]\n" "$(basename "$0")" >&2
  exit 1
fi

total_words=0
total_tokens=0

process_file() {
  local file="$1"
  [ -f "$file" ] || return 0
  local words
  words=$(wc -w < "$file" | tr -d ' ')
  local tokens
  tokens=$(awk -v w="$words" -v m="$MULTIPLIER" 'BEGIN { printf "%d", w * m }')
  printf "%-60s %6d words  ~%6d tokens\n" "$file" "$words" "$tokens"
  total_words=$((total_words + words))
  total_tokens=$((total_tokens + tokens))
}

for arg in "$@"; do
  if [ -d "$arg" ]; then
    while IFS= read -r -d '' file; do
      process_file "$file"
    done < <(find "$arg" -name '*.md' -type f -print0 | sort -z)
  else
    process_file "$arg"
  fi
done

if [ $total_words -gt 0 ]; then
  printf "\n%-60s %6d words  ~%6d tokens\n" "TOTAL" "$total_words" "$total_tokens"
fi
