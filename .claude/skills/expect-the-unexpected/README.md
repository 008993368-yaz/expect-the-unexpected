# expect-the-unexpected

A scenario-driven failure-mode analysis skill. Given one specific scenario
(e.g. "a payment webhook arrives twice", "a user uploads a 2GB file", "1,000
signups land in one minute"), it traces the execution path, systematically
surfaces what could break — ranked by risk — and proposes concrete mitigations
or test cases. Works at design time (before code exists) and on existing code.

## Contents

```
expect-the-unexpected/
  SKILL.md                       # Lean entry point + routing + per-scenario flow (read first)
  references/
    failure-taxonomy.md          # 8-category taxonomy (lens + generator) + pre-mortem
    scenario-generation.md       # Stage 0: bounded surface -> ranked scenario menu
  README.md                      # This file
```

## Self-contained by design

This folder has **no external dependencies**. It can be moved into a plugin's
`skills/` directory unchanged — nothing references paths outside this folder.

## v2 scope: reasoning only, now with scenario generation

Two modes: analyze a user-supplied scenario, OR generate scenarios from a bounded
surface (diff/PR, file, endpoint, or feature description) and let the user pick
which to analyze. Either way it predicts failures and generates test cases — it
does **not** execute tests or modify code, and it never claims the software is
"safe."

## Future (NOT built — do not preclude)

The structure stays compatible with later promotion to a plugin that could add —
none of which exist today:

- **Pre-deploy gate hook** — a hook that auto-runs the analysis as a gate before
  deploy, using Stage 0's diff mode with no human-typed scenario. Would live in
  the plugin's `hooks/`, not here.
- **MCP server to execute tests** — a server that actually runs the generated
  test cases instead of only suggesting them (a possible v3). Would live in the
  plugin's MCP config, not here.

Keep `SKILL.md` and `references/` free of any assumption that these exist so the
skill keeps working standalone.
