# expect-the-unexpected

A scenario-driven failure-mode analysis skill. Given one specific scenario
(e.g. "a payment webhook arrives twice", "a user uploads a 2GB file", "1,000
signups land in one minute"), it traces the execution path, systematically
surfaces what could break — ranked by risk — and proposes concrete mitigations
or test cases. Works at design time (before code exists) and on existing code.

## Contents

```
expect-the-unexpected/
  SKILL.md                       # Lean entry point + workflow (read first)
  references/
    failure-taxonomy.md          # Full 8-category taxonomy + pre-mortem prompt
  README.md                      # This file
```

## Self-contained by design

This folder has **no external dependencies**. It can be moved into a plugin's
`skills/` directory unchanged — nothing references paths outside this folder.

## v1 scope: reasoning only

v1 predicts failures and generates test cases for the user to run. It does
**not** execute tests or modify code, and it never claims the software is "safe."

## Future (NOT built — do not preclude)

The structure is intentionally compatible with later promotion to a plugin that
could add — none of which exist today:

- **Pre-deploy gate hook** — a hook that auto-runs this analysis as a gate
  before deploy. Would live in the plugin's `hooks/`, not here.
- **MCP server to execute tests** — a server that actually runs the generated
  test cases instead of only suggesting them. Would live in the plugin's MCP
  config, not here.

Keep `SKILL.md` and `references/` free of any assumption that these exist so the
skill keeps working standalone.
