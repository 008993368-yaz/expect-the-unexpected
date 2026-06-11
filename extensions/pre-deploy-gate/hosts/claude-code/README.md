# Claude Code install

## Prerequisites

- [Claude Code hooks](https://code.claude.com/docs/en/hooks)
- `git` and `bash`
- [expect-the-unexpected](../../../../README.md#install) skill in the project

## Install

From your **application project**:

```bash
mkdir -p .claude/hooks
cp /path/to/expect-the-unexpected/extensions/pre-deploy-gate/scripts/pre-deploy-gate.sh .claude/hooks/
chmod +x .claude/hooks/pre-deploy-gate.sh
```

Merge the `hooks` block from [settings.hooks.example.json](settings.hooks.example.json)
into `.claude/settings.json` (or use `/hooks` in Claude Code to register). Preserve
existing hook entries.

## Hook details

| Field | Value |
|-------|-------|
| Event | `PreToolUse` |
| Matcher | `Bash` |
| Filter | Shared script allows non-deploy Bash commands |

Claude Code receives `permissionDecision: ask` with Stage 0 context in
`additionalContext`. The script auto-detects Claude input (`tool_name` / `tool_input`).

## Integration test

1. Commit a change vs `main`.
2. Ask Claude to run `vercel deploy`.
3. Confirm the permission prompt with diff and Stage 0 instructions.
4. Run `npm test` — hook runs but script allows (not a deploy command).
