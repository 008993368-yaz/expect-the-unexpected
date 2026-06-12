#!/usr/bin/env bash
set -euo pipefail

# pre-deploy-gate.sh — host-agnostic deploy gate for expect-the-unexpected Stage 0
# Supports Cursor (beforeShellExecution) and Claude Code (PreToolUse / Bash).
# Set DEPLOY_GATE_HOST=cursor|claude-code to skip auto-detection.

DEPLOY_PATTERN='vercel deploy|firebase deploy|netlify deploy|fly deploy|serverless deploy|npm run deploy|pnpm run deploy|yarn deploy|kubectl apply|helm upgrade|terraform apply'

allow_cursor() {
  printf '%s\n' '{"permission":"allow"}'
}

allow_claude() {
  exit 0
}

emit_allow() {
  case "$HOST_FORMAT" in
    cursor) allow_cursor ;;
    claude-code) allow_claude ;;
    *) allow_cursor ;;
  esac
}

emit_ask() {
  local user_msg="$1"
  local agent_msg="$2"
  case "$HOST_FORMAT" in
    cursor)
      local user_esc agent_esc
      user_esc="$(escape_json "$user_msg")"
      agent_esc="$(escape_json "$agent_msg")"
      printf '%s\n' "{\"permission\":\"ask\",\"user_message\":\"${user_esc}\",\"agent_message\":\"${agent_esc}\"}"
      ;;
    claude-code)
      local reason_esc context_esc
      reason_esc="$(escape_json "$user_msg")"
      context_esc="$(escape_json "$agent_msg")"
      printf '%s\n' "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"ask\",\"permissionDecisionReason\":\"${reason_esc}\",\"additionalContext\":\"${context_esc}\"}}"
      ;;
  esac
}

escape_json() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

extract_command() {
  local input="$1"
  local cmd=""
  local rest
  # Claude Code PreToolUse: tool_input.command
  if [[ "$input" == *\"tool_input\"* ]]; then
    rest="${input#*\"tool_input\"}"
    if [[ "$rest" =~ \"command\"[[:space:]]*:[[:space:]]*\"((\\.|[^\"\\])*)\" ]]; then
      cmd="${BASH_REMATCH[1]}"
    fi
  fi
  # Cursor beforeShellExecution: top-level command
  if [[ -z "$cmd" && "$input" =~ \"command\"[[:space:]]*:[[:space:]]*\"((\\.|[^\"\\])*)\" ]]; then
    cmd="${BASH_REMATCH[1]}"
  fi
  printf '%s' "$cmd"
}

is_deploy_command() {
  local cmd="$1"
  [[ "$cmd" =~ ($DEPLOY_PATTERN) ]]
}

detect_host() {
  local input="$1"
  if [[ -n "${DEPLOY_GATE_HOST:-}" ]]; then
    printf '%s' "$DEPLOY_GATE_HOST"
    return
  fi
  if [[ "$input" =~ \"tool_name\" ]]; then
    printf 'claude-code'
    return
  fi
  printf 'cursor'
}

main() {
  local enabled input command base_ref max_lines diff_out truncated line_count
  local trunc_note agent_msg user_msg

  enabled="${DEPLOY_GATE_ENABLED:-1}"
  if [[ "$enabled" == "0" ]]; then
    HOST_FORMAT="${DEPLOY_GATE_HOST:-cursor}"
    emit_allow
    return 0
  fi

  input="$(cat)"
  HOST_FORMAT="$(detect_host "$input")"

  command="$(extract_command "$input")"
  if [[ -n "$command" ]] && ! is_deploy_command "$command"; then
    emit_allow
    return 0
  fi

  base_ref="${DEPLOY_GATE_BASE_REF:-origin/main}"
  max_lines="${DEPLOY_GATE_MAX_LINES:-500}"

  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "pre-deploy-gate: not a git repo, allowing" >&2
    emit_allow
    return 0
  fi

  if ! git rev-parse --verify "$base_ref" >/dev/null 2>&1; then
    if git rev-parse --verify main >/dev/null 2>&1; then
      base_ref="main"
    else
      echo "pre-deploy-gate: base ref not found, allowing" >&2
      emit_allow
      return 0
    fi
  fi

  diff_out="$(git diff "$base_ref"...HEAD 2>/dev/null || true)"
  if [[ -z "${diff_out//[[:space:]]/}" ]]; then
    emit_allow
    return 0
  fi

  truncated="false"
  line_count="$(printf '%s\n' "$diff_out" | wc -l | tr -d ' ')"
  if [[ "$line_count" -gt "$max_lines" ]]; then
    diff_out="$(printf '%s\n' "$diff_out" | head -n "$max_lines")"
    truncated="true"
  fi

  trunc_note=""
  if [[ "$truncated" == "true" ]]; then
    trunc_note=" Diff truncated to ${max_lines} lines; note in coverage caveat."
  fi

  agent_msg="Before deploy: run expect-the-unexpected Stage 0 on the bounded surface below. READ references/scenario-generation.md. Present a ranked scenario menu (~5-8); analyze scenarios the user picks. Do not claim the software is safe — end with the coverage caveat.${trunc_note}

Base ref: ${base_ref}...HEAD

--- diff ---
${diff_out}"

  user_msg="Deploy paused — review failure-mode scenarios for this diff before proceeding. You can cancel or allow deploy after review."

  emit_ask "$user_msg" "$agent_msg"
}

# Fail-open: hook errors must never block deploy (hosts should set failClosed: false too)
if ! main; then
  echo "pre-deploy-gate: internal error, allowing deploy (fail-open)" >&2
  HOST_FORMAT="${HOST_FORMAT:-${DEPLOY_GATE_HOST:-cursor}}"
  emit_allow
fi
