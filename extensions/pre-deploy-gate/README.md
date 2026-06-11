# Pre-deploy gate hook (Cursor)

Optional Cursor hook for [expect-the-unexpected](../../README.md). When you run a
deploy command, it **pauses** and injects the current git diff so the agent can
run **Stage 0** failure-mode scenario generation before you proceed.

This is an **advisory soft gate** — you can allow deploy after review. It is not
a security control and does not prove correctness.

## What it does

1. Intercepts matched deploy shell commands (`beforeShellExecution`).
2. Runs `git diff ${base}...HEAD` as the bounded surface.
3. Returns `permission: ask` with the diff and Stage 0 routing instructions.
4. Allows deploy when the diff is empty, git is unavailable, or the hook is disabled.

## Prerequisites

- [Cursor hooks](https://cursor.com/docs/agent/hooks) enabled in your project
- `git` and `bash` (on Windows: [Git Bash](https://git-scm.com/))
- [expect-the-unexpected](../../README.md#install) skill installed in the project

## Install

From your **application project** (not the skill folder):

1. Copy the hook script:

   ```bash
   mkdir -p .cursor/hooks
   cp /path/to/expect-the-unexpected/extensions/pre-deploy-gate/cursor/hooks/pre-deploy-gate.sh .cursor/hooks/
   chmod +x .cursor/hooks/pre-deploy-gate.sh
   ```

   **PowerShell** (adjust source path):

   ```powershell
   New-Item -ItemType Directory -Force -Path .cursor\hooks
   Copy-Item C:\path\to\expect-the-unexpected\extensions\pre-deploy-gate\cursor\hooks\pre-deploy-gate.sh .cursor\hooks\
   ```

2. Merge [hooks.json.example](cursor/hooks.json.example) into `.cursor/hooks.json`.
   Preserve any existing hook entries.

3. Restart Cursor if hooks do not load immediately.

## Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `DEPLOY_GATE_ENABLED` | `1` | Set to `0` to skip the gate |
| `DEPLOY_GATE_BASE_REF` | `origin/main` | Diff base (falls back to `main`) |
| `DEPLOY_GATE_MAX_LINES` | `500` | Max diff lines in the injected message |

Set these in your shell environment or Cursor settings as appropriate for your OS.

## Customize the matcher

Edit the `matcher` regex in `.cursor/hooks.json` to match your deploy commands.
Matchers use **JavaScript** regex syntax. Examples to add:

- `gh workflow run deploy`
- `railway up`
- `sam deploy`

## Manual test

### 1. Smoke test (script only)

From a git repo with unmerged changes vs your base branch:

```bash
echo '{"command":"vercel deploy --prod"}' | bash .cursor/hooks/pre-deploy-gate.sh
```

Expected: JSON with `"permission":"ask"` and diff content in `agent_message`.

### 2. Empty diff allows deploy

```bash
echo '{"command":"vercel deploy"}' | DEPLOY_GATE_BASE_REF=HEAD bash .cursor/hooks/pre-deploy-gate.sh
```

Expected: `{"permission":"allow"}`

### 3. Kill switch

```bash
echo '{"command":"vercel deploy"}' | DEPLOY_GATE_ENABLED=0 bash .cursor/hooks/pre-deploy-gate.sh
```

Expected: `{"permission":"allow"}`

### 4. Integration in Cursor

1. Make a small code change and commit or leave staged vs `main`.
2. Ask the agent to run a matched deploy command (e.g. `vercel deploy`).
3. Confirm the ask dialog appears with the diff and Stage 0 instructions.
4. Run `npm test` — the hook should **not** fire (matcher excludes it).

## Limitations

- **Advisory only** — not proof the software is safe; the skill's coverage caveat still applies.
- **Fail-open** — hook errors do not block deploy (`failClosed: false`).
- **Diff may contain secrets** — review before sharing logs or screenshots.
- **Matcher is best-effort** — uncommon deploy commands may bypass until you add them.
- **Windows** — requires Git Bash or WSL for the bash script; native PowerShell variant is not included in v1.
