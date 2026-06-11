# expect-the-unexpected

A scenario-driven failure-mode analysis skill for AI coding agents — Cursor,
Claude Code, Codex, GitHub Copilot, and any host that supports the [Agent Skills](https://agentskills.io) format.

Give it **one specific scenario** — "a payment webhook arrives twice", "a user
uploads a 2GB file" — and it traces the execution path, surfaces what could break
(ranked by risk), and proposes a concrete mitigation or test case for each. Or,
when you *don't* know what to worry about, give it a **bounded surface** — a
diff/PR, a file, an endpoint, or a feature description — and it generates the
riskiest scenarios for you, ranked, then analyzes the ones you pick. Works at
design time (before code exists) as well as on existing code.

## Install

This repo **is** the skill package. Clone it, then link or copy it into the
skills directory your agent expects.

| Agent / host | Project path | Global path |
|--------------|--------------|-------------|
| Open standard | `.agents/skills/expect-the-unexpected/` | `~/.agents/skills/expect-the-unexpected/` |
| Cursor | `.cursor/skills/expect-the-unexpected/` | `~/.cursor/skills/expect-the-unexpected/` |
| Claude Code | `.claude/skills/expect-the-unexpected/` | `~/.claude/skills/expect-the-unexpected/` |
| Codex | `.codex/skills/expect-the-unexpected/` | `~/.codex/skills/expect-the-unexpected/` |
| GitHub Copilot | `.github/skills/expect-the-unexpected/` | — |

Cursor also loads `.claude/skills/` and `.codex/skills/` for compatibility, but
installing to the path for your primary agent keeps discovery explicit.

**Unix / macOS (symlink, project-local):**

```bash
git clone https://github.com/008993368-yaz/expect-the-unexpected.git
ln -s /path/to/expect-the-unexpected .cursor/skills/expect-the-unexpected
```

**PowerShell (symlink, project-local):**

```powershell
git clone https://github.com/008993368-yaz/expect-the-unexpected.git
New-Item -ItemType SymbolicLink -Path .cursor\skills\expect-the-unexpected -Target C:\path\to\expect-the-unexpected
```

**Copy instead of symlink:** copy the cloned repo directory to the target path
above. The skill folder must contain `SKILL.md` at its root.

## Usage

Describe a scenario in plain language, or invoke the skill by name (`/expect-the-unexpected`
where your host supports slash commands). The skill triggers when you:

- ask what could break / go wrong / fail in a **specific** scenario
- give a **bounded surface** (a diff/PR, file, endpoint, or feature) and want the
  risky scenarios surfaced *for* you
- ask to pressure-test, stress-test, or red-team a particular code path
- want a pre-launch / pre-ship / pre-deploy check on a feature

It does **not** trigger for generic full-codebase reviews ("review my whole
repo") — it needs a bounded surface (a scenario, diff, file, endpoint, or
feature), not the whole repo.

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
7. **Execution offer (opt-in).** If the host can write files and run commands,
   it offers to turn selected FMEA rows into real test files, run them with
   your project's test runner, and report per-row verdicts — offering a fix
   for each confirmed failure, one at a time, each requiring your approval.
   Declining leaves the run identical to reasoning mode.

## Scope

**Reasoning mode (default).** The skill predicts failures and generates test
cases for you to run — and generates scenarios themselves from a bounded surface
when needed. It does not execute tests or modify code, and it never claims the
software is "safe."

**Execution mode (opt-in).** After every analysis — when the host can write
files and run commands — the skill can, with your explicit go-ahead, write the
generated test cases into your project's test suite, run them with your own
test runner, and report which failure modes are CONFIRMED, NOT REPRODUCED, or
INCONCLUSIVE. Confirmed failures get the
FMEA row's mitigation offered as a fix, one at a time, each requiring your
approval. Generated tests are kept by default as regression coverage. External
dependencies are always mocked — it never contacts real third-party services
or touches real data destructively.

## Layout

```
expect-the-unexpected/
  SKILL.md                     # Lean entry point + routing + per-scenario flow
  references/
    failure-taxonomy.md        # 8-category taxonomy (lens + generator) + pre-mortem
    scenario-generation.md     # Stage 0: bounded surface -> ranked scenario menu
    execution-mode.md          # Opt-in: write & run generated tests, verdicts, fix loop
  README.md                    # Install + design notes (this file)
```

## Design

**Self-contained.** This package has no external dependencies. Nothing references
paths outside this folder — copy or symlink it into any host's skills directory
unchanged.

**Agent-agnostic.** The skill uses standard `SKILL.md` frontmatter (`name`,
`description`) and folder-relative `references/` links. No host-specific APIs or
assumptions.

## Optional extensions

The structure stays compatible with host-specific add-ons. The skill works
standalone without them.

- **Pre-deploy gate hook** *(built)* — optional host hook (Cursor, Claude Code, …)
  that pauses deploy commands and injects the current git diff for Stage 0 analysis.
  Install from [`extensions/pre-deploy-gate/`](extensions/pre-deploy-gate/README.md)
  into your project's host hooks config (not into the skill folder).

## License

MIT — see [LICENSE](LICENSE).
