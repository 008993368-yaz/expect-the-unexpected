#!/usr/bin/env bash
set -euo pipefail

# pre-deploy-gate.sh — Cursor beforeShellExecution hook
# Soft-gates deploy commands: injects git diff for expect-the-unexpected Stage 0.

allow() {
  printf '%s\n' '{"permission":"allow"}'
}

enabled="${DEPLOY_GATE_ENABLED:-1}"
if [[ "$enabled" == "0" ]]; then
  allow
  exit 0
fi

input="$(cat)"

# Extract .command from JSON without jq (minimal parser for "command":"...")
command=""
if [[ "$input" =~ \"command\"[[:space:]]*:[[:space:]]*\"((\\.|[^\"\\])*)\" ]]; then
  command="${BASH_REMATCH[1]}"
fi

base_ref="${DEPLOY_GATE_BASE_REF:-origin/main}"
max_lines="${DEPLOY_GATE_MAX_LINES:-500}"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "pre-deploy-gate: not a git repo, allowing" >&2
  allow
  exit 0
fi

if ! git rev-parse --verify "$base_ref" >/dev/null 2>&1; then
  if git rev-parse --verify main >/dev/null 2>&1; then
    base_ref="main"
  else
    echo "pre-deploy-gate: base ref not found, allowing" >&2
    allow
    exit 0
  fi
fi

diff_out="$(git diff "$base_ref"...HEAD 2>/dev/null || true)"
if [[ -z "${diff_out//[[:space:]]/}" ]]; then
  allow
  exit 0
fi

truncated="false"
line_count="$(printf '%s\n' "$diff_out" | wc -l | tr -d ' ')"
if [[ "$line_count" -gt "$max_lines" ]]; then
  diff_out="$(printf '%s\n' "$diff_out" | head -n "$max_lines")"
  truncated="true"
fi

# JSON-escape diff for embedding in agent_message (escape \ and ")
escape_json() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

diff_escaped="$(escape_json "$diff_out")"
trunc_note=""
if [[ "$truncated" == "true" ]]; then
  trunc_note=" Diff truncated to ${max_lines} lines; note in coverage caveat."
fi

agent_msg="Before deploy: run expect-the-unexpected Stage 0 on the bounded surface below. READ references/scenario-generation.md. Present a ranked scenario menu (~5-8); analyze scenarios the user picks. Do not claim the software is safe — end with the coverage caveat.${trunc_note}\\n\\nBase ref: ${base_ref}...HEAD\\n\\n--- diff ---\\n${diff_escaped}"

user_msg="Deploy paused — review failure-mode scenarios for this diff before proceeding. You can cancel or allow deploy after review."

printf '%s\n' "{\"permission\":\"ask\",\"user_message\":\"${user_msg}\",\"agent_message\":\"${agent_msg}\"}"
exit 0
