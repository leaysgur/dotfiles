#!/usr/bin/env bash
set -euo pipefail

cmd=$(jq -r '.tool_input.command // ""')

if ! echo "$cmd" | grep -q 'gh api'; then
  exit 0
fi

if echo "$cmd" | grep -Eq '\-X\s+(POST|PATCH|PUT|DELETE)|--method\s+(POST|PATCH|PUT|DELETE)'; then
  echo "`gh api` is only allowed for readonly usage." >&2
  exit 2
fi

exit 0
