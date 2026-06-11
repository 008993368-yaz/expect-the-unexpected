# Pre-deploy gate hook

Optional host hook for [expect-the-unexpected](../../README.md). When a deploy
command runs, it **pauses** and injects the current git diff so the agent can
run **Stage 0** failure-mode scenario generation before you proceed.

Works with any AI coding agent whose hook system can gate shell commands and pass
JSON on stdin/stdout. Host-specific install configs live under `hosts/`.

This is an **advisory soft gate** — you can allow deploy after review. It is not
a security control and does not prove correctness.

## What it does

1. Intercepts deploy shell commands (via your host's hook config).
2. Runs `git diff ${base}...HEAD` as the bounded surface.
3. Returns an ask/pause decision with the diff and Stage 0 routing instructions.
4. Allows deploy when the diff is empty, the command is not a deploy, git is
   unavailable, or the hook is disabled.

## Shared script

All hosts use the same script:

```
extensions/pre-deploy-gate/scripts/pre-deploy-gate.sh
```

It auto-detects the host from hook input (Cursor vs Claude Code). Override with
`DEPLOY_GATE_HOST=cursor` or `DEPLOY_GATE_HOST=claude-code` if needed.

## Install by host

| Agent / host | Hook config | Script install path | Guide |
|--------------|-------------|---------------------|-------|
| Cursor | `.cursor/hooks.json` | `.cursor/hooks/pre-deploy-gate.sh` | [hosts/cursor/README.md](hosts/cursor/README.md) |
| Claude Code | `.claude/settings.json` | `.claude/hooks/pre-deploy-gate.sh` | [hosts/claude-code/README.md](hosts/claude-code/README.md) |
| Codex, Copilot, others | — | — | Use the shared script if your host supports equivalent shell-command hooks; contribute a `hosts/<name>/` example via PR |

Copy `scripts/pre-deploy-gate.sh` to the script path for your host, merge the
example hook config from `hosts/<host>/`, and `chmod +x` the script.

## Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `DEPLOY_GATE_ENABLED` | `1` | Set to `0` to skip the gate |
| `DEPLOY_GATE_HOST` | *(auto)* | `cursor` or `claude-code` |
| `DEPLOY_GATE_BASE_REF` | `origin/main` | Diff base (falls back to `main`) |
| `DEPLOY_GATE_MAX_LINES` | `500` | Max diff lines in the injected message |

## Manual test (any host)

From a git repo with changes vs your base branch:

```bash
# Cursor-style input
echo '{"command":"vercel deploy --prod"}' | bash scripts/pre-deploy-gate.sh

# Claude Code-style input
echo '{"tool_name":"Bash","tool_input":{"command":"vercel deploy --prod"}}' | bash scripts/pre-deploy-gate.sh
```

Expected: JSON with an ask/pause decision and diff content in the agent context field.

Kill switch and empty-diff cases:

```bash
echo '{"command":"vercel deploy"}' | DEPLOY_GATE_ENABLED=0 bash scripts/pre-deploy-gate.sh
# → allow

echo '{"command":"vercel deploy"}' | DEPLOY_GATE_BASE_REF=HEAD bash scripts/pre-deploy-gate.sh
# → allow
```

## Limitations

- **Advisory only** — not proof the software is safe; the skill's coverage caveat still applies.
- **Fail-open** — configure your host hook so errors do not block deploy.
- **Diff may contain secrets** — review before sharing logs or screenshots.
- **Deploy matcher** — Cursor filters in `hooks.json`; Claude Code filters inside the script (matcher is `Bash`).
- **Windows** — requires Git Bash or WSL; native PowerShell variant not included in v1.
