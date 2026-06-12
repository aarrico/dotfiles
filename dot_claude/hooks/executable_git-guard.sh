#!/usr/bin/env bash
# PreToolUse(Bash) guard: deny git commit/push so the user runs them himself.
cmd=$(jq -r '.tool_input.command // ""')
if printf '%s' "$cmd" | grep -qE '(^|[;&|(])[[:space:]]*git[[:space:]]+([^[:space:]]+[[:space:]]+)*(commit|push)([^[:alnum:]]|$)'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked by global policy: you run all git commit/push operations yourself (~/.claude/CLAUDE.md). Stage/inspect freely and stop at a checkpoint."}}'
fi
