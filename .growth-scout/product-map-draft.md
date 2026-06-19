# Product Map Draft

## Last refreshed

- [Known] This draft was created on 2026-06-19 during the monthly Growth Scout cron run.
- [Known] The previously requested `.growth-scout/product-map-draft.md` file was absent before this run.

## Product surface

- [Known] `expect-the-unexpected` is a scenario-driven failure-mode analysis skill package for AI coding agents.
- [Known] The package root contains `SKILL.md`, `README.md`, `CHANGELOG.md`, `references/`, `examples/`, `evals/`, `extensions/`, and `scripts/`.
- [Known] `SKILL.md` frontmatter declares version `1.1.0`.
- [Known] `README.md` documents install paths for Open standard, Cursor, Claude Code, Codex, and GitHub Copilot skill directories.
- [Known] `SKILL.md` routes either a specific scenario or a bounded surface into failure-mode analysis.
- [Known] `references/scenario-generation.md` documents Stage 0 generation from a bounded surface.
- [Known] `references/failure-taxonomy.md` defines eight failure categories and a pre-mortem prompt.
- [Known] `references/execution-mode.md` documents an opt-in mode for writing and running generated tests after explicit acceptance.
- [Known] `evals/benchmark.json` and `evals/README.md` define benchmark cases and a manual or semi-automated scoring approach.
- [Known] `extensions/pre-deploy-gate/` provides an advisory fail-open deploy hook.

## Intended users and jobs

- [Known] `README.md` says the skill is for users who ask what could go wrong in one specific scenario or bounded surface.
- [Inferred] Primary users are AI coding-agent users who want a repeatable pre-ship failure-mode analysis workflow.
- [Inferred] Secondary users are teams that want reusable review discipline across Cursor, Claude Code, Codex, Copilot, or other Agent Skills-compatible hosts.
- [Inferred] A high-value job is "turn an ambiguous pre-launch concern into a ranked, testable FMEA table without performing a broad code review."
- [Inferred] Another high-value job is "generate concrete risky scenarios from a PR, diff, endpoint, file, or feature description before deployment."

## Current differentiators

- [Known] The skill requires a bounded surface or scenario and rejects generic whole-repo bug hunting.
- [Known] The workflow combines taxonomy coverage with an explicit catastrophic pre-mortem pass.
- [Known] The output format uses a fixed Likelihood x Impact risk matrix.
- [Known] Execution mode requires explicit user opt-in and mocks external dependencies through the project's existing test stack.
- [Known] The pre-deploy gate is advisory and fail-open by design.
- [Inferred] The product is differentiated by disciplined risk analysis rather than broad persistent agent instructions.
- [Inferred] The product is less differentiated on install/distribution than platform-native instruction systems.

## Distribution and ecosystem context

- [Known] Anthropic Agent Skills use directories containing `SKILL.md` files with YAML frontmatter.
- [Known] Cursor Project Rules live in `.cursor/rules` as `.mdc` files with activation metadata.
- [Known] OpenAI Codex supports repository guidance through `AGENTS.md`.
- [Known] GitHub Copilot supports repository custom instructions through `.github/copilot-instructions.md` and path-specific `.github/instructions/*.instructions.md` files.
- [Inferred] Native host instruction systems compete for the same "make agents behave consistently" budget, even when they are not one-for-one substitutes for a reusable skill package.

## Demand signals

- [Known] GitHub CLI returned no open issues for this repository on 2026-06-19.
- [Known] GitHub CLI returned no open issues labeled `enhancement` on 2026-06-19.
- [Known] GitHub CLI returned no open issues labeled `feature-request` on 2026-06-19.
- [Known] GitHub release list returned `v1.1.0` as the latest release on 2026-06-19.
- [Unknown] External user demand by segment is unknown because no Growth Scout MCP work-item mining tool was available in this session.
- [Unknown] Marketplace install, package download, and active-use metrics are unknown because no analytics source was available in this session.
