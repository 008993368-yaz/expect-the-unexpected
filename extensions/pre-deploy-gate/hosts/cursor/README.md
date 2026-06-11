# Cursor install

## Prerequisites

- [Cursor hooks](https://cursor.com/docs/agent/hooks)
- `git` and `bash` (Git Bash on Windows)
- [expect-the-unexpected](../../../../README.md#install) skill in the project

## Install

From your **application project**:

```bash
mkdir -p .cursor/hooks
cp /path/to/expect-the-unexpected/extensions/pre-deploy-gate/scripts/pre-deploy-gate.sh .cursor/hooks/
chmod +x .cursor/hooks/pre-deploy-gate.sh
```

Merge [hooks.json.example](hooks.json.example) into `.cursor/hooks.json`. Preserve
existing hook entries. Restart Cursor if hooks do not load.

## Hook details

| Field | Value |
|-------|-------|
| Event | `beforeShellExecution` |
| Matcher | Deploy commands (JS regex in example) |
| `failClosed` | `false` |

The shared script auto-detects Cursor input (`{"command":"..."}`).

## Integration test

1. Commit a change vs `main`.
2. Ask the agent to run `vercel deploy` (or another matched command).
3. Confirm the ask dialog with diff and Stage 0 instructions.
4. Run `npm test` — hook should not fire.
