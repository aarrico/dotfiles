#!/usr/bin/env bash
# Status line: model · dir ⎇ branch · ctx. Reads session JSON on stdin.
input=$(cat)
model=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // "?"')
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // "."')
base=$(basename "$dir")
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
over=$(printf '%s' "$input" | jq -r 'if .exceeds_200k_tokens == true then "200k+" else empty end')

out="$model · $base"
[ -n "$branch" ] && out="$out ⎇ $branch"
[ -n "$over" ] && out="$out · ctx $over"
printf '%s' "$out"
