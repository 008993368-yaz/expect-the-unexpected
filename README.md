# expect-the-unexpected

A scenario-driven failure-mode analysis skill for [Claude Code](https://claude.com/claude-code).

Give it **one specific scenario** — "a payment webhook arrives twice", "a user
uploads a 2GB file", "1,000 signups land in one minute" — and it traces the
execution path, systematically surfaces what could break (ranked by risk), and
proposes a concrete mitigation or a test case for each finding. It works at
design time (before code exists) as well as on existing code.

## Install

The skill is project-local. It lives at:

```
.claude/skills/expect-the-unexpected/
```

Claude Code auto-discovers skills under `.claude/skills/`, so cloning this repo
into your workspace is enough — no further setup.

## Usage

Just describe a scenario in plain language. The skill triggers when you:

- ask what could break / go wrong / fail in a **specific** scenario
- ask to pressure-test, stress-test, or red-team a particular code path
- want a pre-launch / pre-ship / pre-deploy check on a feature

It does **not** trigger for generic full-codebase reviews ("review my whole
repo") — that's a code-review skill's job. It needs one scenario to trace.

Examples:

> "Before we ship checkout — what if a customer's payment succeeds at Stripe but
> our confirmation webhook fires twice?"

> "Pressure-test this file-upload handler." *(it will ask which scenario first)*

> "We're planning a CSV bulk-import of 50k contacts. What should we worry about?"

## How it works

1. **Pin the scenario.** If you give code but no scenario, it asks which path to
   analyze before going further.
2. **Walk the taxonomy.** It walks 8 failure categories (inputs, state & timing,
   external dependencies, resources & scale, auth & security, time, money/SaaS,
   failure-of-the-failure) against the path.
3. **Pre-mortem.** It assumes the scenario *already* caused a production outage
   and narrates what happened — catching what forward reasoning missed.
4. **FMEA output.** Findings come back as a risk-ranked table: failure mode →
   trigger → symptom → likelihood × impact → mitigation or test to write.
5. **Coverage note.** Every run ends with an explicit caveat: these are known
   failure classes, not proof of correctness.

## Scope

**v1 is reasoning-only.** It predicts failures and generates test cases for you
to run. It does not execute tests or modify code, and it never claims the
software is "safe."

## Layout

```
.claude/skills/expect-the-unexpected/
  SKILL.md                     # Lean entry point + workflow
  references/
    failure-taxonomy.md        # Full 8-category taxonomy + pre-mortem prompt
  README.md                    # Skill-internal notes + future-proofing
```

The skill folder is fully self-contained (no external dependencies), so it can
be moved into a plugin's `skills/` directory unchanged. See the skill's own
`README.md` for planned-but-not-built future additions (a pre-deploy gate hook
and an MCP server to execute generated tests).
