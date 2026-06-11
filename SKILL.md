---
name: expect-the-unexpected
license: MIT
description: >-
  Use when the user asks what could break / go wrong / fail in a SPECIFIC
  scenario (e.g. "what if this webhook fires twice", "a user uploads a 2GB
  file"); OR gives a bounded surface (a diff/PR, one file, an endpoint, or a
  feature description) and wants the risky scenarios surfaced FOR them ("what
  should I worry about before shipping this change?"); asks to pressure-test,
  stress-test, or red-team a path; or wants a pre-launch / pre-ship / pre-deploy
  check. Works at design time and on existing code. Do NOT use for generic
  full-codebase reviews, "review my whole repo", or "find bugs everywhere" —
  that needs a bounded surface (a diff, file, endpoint, or feature), not the
  whole repo.
---

# Expect the Unexpected

## Overview

Scenario-driven failure-mode analysis. Given **one specific scenario**, trace
its execution path and systematically surface what could break — ranked by risk,
each with a concrete mitigation or a test to write.

**Core principle:** Forward reasoning misses things. Walk a fixed taxonomy
against the path AND run a pre-mortem ("assume it already failed in prod"). The
two passes catch different failures.

## Capabilities

**Reasoning mode (default).** Two analysis paths: (a) the user gives one scenario
→ trace and analyze it; (b) the user gives a bounded surface but no scenario →
**generate** the scenarios worth tracing, rank them, let the user pick, then
analyze each. Either way: predict failures and generate test cases for the user
to run. Do **not** execute tests, run code, or modify files.

**Execution mode (opt-in).** After the FMEA table and coverage note, offer to
write the selected test cases as real test files and run them with the
project's own test runner — reporting a per-row verdict (CONFIRMED / NOT
REPRODUCED / INCONCLUSIVE) and offering a fix for each confirmed failure, one
at a time, each requiring user approval. Entered ONLY on explicit user
acceptance (see Step 6). In read-only hosts/modes, skip the offer; reasoning
mode stands alone.

Optional pre-deploy hook (Cursor, Claude Code, …): see `extensions/pre-deploy-gate/README.md`.

## When to Use

- "What could go wrong if…" / "what breaks when…" for a named scenario
- "Pressure-test / stress-test / red-team this path before we ship"
- Pre-launch / pre-deploy gut-check on a feature or endpoint
- Design-time review: a proposed flow, no code yet
- A bounded surface (a diff/PR, file, endpoint, or feature) but **no scenario yet** — Stage 0 generates the candidate scenarios for you

**Do NOT use when:** the user wants a whole-repo review or open-ended bug hunt
with no scenario. Route that to a code-review skill instead.

## Routing

| User gives… | Do |
|-------------|-----|
| A specific scenario | Skip to the per-scenario flow below (Steps 1–6). |
| A bounded surface, no scenario | Run **Stage 0** (scenario generation), then Steps 1–6 per chosen scenario. |
| Nothing / "review my whole repo" | Refuse — ask for a bounded surface (a diff, file, endpoint, or feature). |

### Stage 0 — generate scenarios (when no scenario was given)

The user has a bounded surface (usually a diff/PR, or a file, endpoint, or
feature description) but doesn't know what to fear. **READ
`references/scenario-generation.md` now** and follow it: gather the surface →
extract risk anchors → run the taxonomy *in reverse* as a scenario generator →
rank by blast radius × plausibility → present a ranked menu of ~5–8 concrete
scenarios → let the user pick ("top N" is valid). Then run Steps 1–6 below on
each chosen scenario.

## Per-scenario flow (Steps 1–6)

### 1. Pin down the scenario

The scenario is the primary input. If the user gave code but **no scenario**, do not analyze a whole file blindly —
go to Routing above.

Then state the execution path you will trace in 1-3 lines: entry point →
key steps → external calls → side effects → response. This anchors the analysis.

### 2. Walk the failure taxonomy

**READ `references/failure-taxonomy.md` now** and walk every category against
this scenario's path. Categories: inputs, state & timing, external dependencies,
resources & scale, auth & security, time, money/SaaS, and
failure-of-the-failure. Skip a category only after confirming it does not touch
this path.

### 3. Pre-mortem pass

After the forward walk, run this prompt explicitly:

> "Assume this scenario has ALREADY caused a catastrophic, customer-visible
> failure in production. Narrate exactly what happened, step by step."

Use the narration to catch failures the forward walk missed. Add any new ones to
the findings.

### 4. Output FMEA-style, ranked by risk

For each failure mode, one row:

| Failure mode | Trigger | Symptom | Likelihood | Impact | Risk | Mitigation / Test to write |

- **Likelihood** and **Impact**: Low / Med / High.
- **Risk**: combined rating used to sort — highest risk on top.
- **Mitigation / Test**: a concrete fix OR a specific test case the user can
  write (inputs + expected behavior). Prefer a test when the fix is unclear.

Group nothing; just rank. Lead with the top 3-5 so the user sees what matters.

### 5. Coverage note (REQUIRED — end every run with this)

Always close with, verbatim in spirit:

> "These are known failure classes for this path; this is not proof of
> correctness. Untested classes and anything outside this scenario remain
> unverified."

If Stage 0 ran, also note: scenarios that were generated but **not selected**,
and any surface area dropped by the cap, remain unanalyzed.

Never imply the software is now safe or "done."

### 6. Offer execution (opt-in)

If the host can write files and run commands, append one line after the
coverage note:

> "Want me to write and run tests for any of these failure modes?"

If the user accepts, have them pick rows if they haven't ("top N" is valid),
then **READ `references/execution-mode.md` now** and follow it. If the user
declines, or the host is read-only, the run ends here — a pure reasoning-mode
run.

## Quick Reference

| Step | Do | Don't |
|------|-----|-------|
| Input | Require a scenario OR a bounded surface | Analyze whole repo |
| Generate | Stage 0: surface → ranked scenario menu | Invent scenarios with no surface |
| Trace | State the path first | Jump to findings |
| Taxonomy | Read the reference, walk all 8 | Rely on memory |
| Pre-mortem | Narrate the prod disaster | Skip it (forward-only misses things) |
| Output | FMEA table ranked by risk | Unranked wall of text |
| Code/tests | Suggest tests; write/run them only in execution mode after opt-in | Execute or fix anything without the explicit opt-in |
| Close | Coverage caveat | Claim it's safe |

## Common Mistakes

- **No scenario → analyzing the whole file anyway.** Don't. Either run Stage 0
  to generate scenarios from the bounded surface, or ask for a bounded surface.
- **Generating without a surface.** Stage 0 needs a fence (diff, file, endpoint,
  feature). Inventing scenarios from nothing = the whole-repo hunt this skill
  refuses.
- **Menu of vague scenarios.** Each generated scenario must be concrete and
  traceable ("the webhook fires twice"), anchored to a real entry point/side
  effect — never a category label ("check inputs").
- **Forward-only.** Skipping the pre-mortem is the #1 way real failures slip
  through. Do both passes.
- **Vague mitigations** ("add validation"). Name the input and the expected
  behavior, or write the actual test case.
- **Unranked output.** The user needs the highest-risk items first.
- **Overreach.** Reasoning mode does not run tests or change code. Enter
  execution mode only after the user explicitly accepts the Step 6 offer —
  never uninvited, and never by skipping the FMEA output.
- **Treating NOT REPRODUCED as proof.** A passing generated test is evidence
  the failure wasn't observed under that test — not proof the failure mode is
  absent.
- **False assurance.** Always end with the coverage caveat.

See `README.md` for install paths and optional extensions.
