# expect-the-unexpected

A scenario-driven failure-mode analysis skill for [Claude Code](https://claude.com/claude-code).

Give it **one specific scenario** — "a payment webhook arrives twice", "a user
uploads a 2GB file" — and it traces the execution path, surfaces what could break
(ranked by risk), and proposes a concrete mitigation or test case for each. Or,
when you *don't* know what to worry about, give it a **bounded surface** — a
diff/PR, a file, an endpoint, or a feature description — and it generates the
riskiest scenarios for you, ranked, then analyzes the ones you pick. Works at
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
- give a **bounded surface** (a diff/PR, file, endpoint, or feature) and want the
  risky scenarios surfaced *for* you
- ask to pressure-test, stress-test, or red-team a particular code path
- want a pre-launch / pre-ship / pre-deploy check on a feature

It does **not** trigger for generic full-codebase reviews ("review my whole
repo") — that's a code-review skill's job. It needs one scenario to trace.

Examples:

> "Before we ship checkout — what if a customer's payment succeeds at Stripe but
> our confirmation webhook fires twice?"

> "What should I worry about in this diff before I ship?" *(it generates a ranked
> scenario menu, then analyzes the ones you pick)*

> "We're planning a CSV bulk-import of 50k contacts. What should we worry about?"

## How it works

1. **Route.** A specific scenario goes straight to analysis. A bounded surface
   with no scenario enters **Stage 0** (scenario generation). "Review my whole
   repo" is refused — it needs a bounded surface.
2. **Generate (Stage 0, when needed).** It reads the surface, extracts risk
   anchors (entry points, untrusted inputs, side effects, external calls), runs
   the taxonomy *in reverse* to produce candidate scenarios, ranks them by blast
   radius × plausibility, and presents a menu of ~5–8 for you to pick from.
3. **Walk the taxonomy.** For each scenario, it walks 8 failure categories
   (inputs, state & timing, external dependencies, resources & scale, auth &
   security, time, money/SaaS, failure-of-the-failure) against the path.
4. **Pre-mortem.** It assumes the scenario *already* caused a production outage
   and narrates what happened — catching what forward reasoning missed.
5. **FMEA output.** Findings come back as a risk-ranked table: failure mode →
   trigger → symptom → likelihood × impact → mitigation or test to write.
6. **Coverage note.** Every run ends with an explicit caveat: these are known
   failure classes, not proof of correctness — and any generated-but-unselected
   scenarios remain unanalyzed.

## Scope

**v2 is reasoning-only.** It predicts failures and generates test cases for you
to run — and now also generates the scenarios themselves from a bounded surface.
It does not execute tests or modify code, and it never claims the software is
"safe."

## Layout

```
.claude/skills/expect-the-unexpected/
  SKILL.md                     # Lean entry point + routing + per-scenario flow
  references/
    failure-taxonomy.md        # 8-category taxonomy (lens + generator) + pre-mortem
    scenario-generation.md     # Stage 0: bounded surface -> ranked scenario menu
  README.md                    # Skill-internal notes + future-proofing
```

The skill folder is fully self-contained (no external dependencies), so it can
be moved into a plugin's `skills/` directory unchanged. See the skill's own
`README.md` for planned-but-not-built future additions (a pre-deploy gate hook
and an MCP server to execute generated tests).
