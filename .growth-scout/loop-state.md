# Growth Scout Loop State

## Last-run metadata

- [Known] Last run timestamp: 2026-06-19T15:13:06Z.
- [Known] Trigger type: monthly cron.
- [Known] Working branch: `cursor/monthly-growth-scout-loop-2dd9`.
- [Known] Repository: `008993368-yaz/expect-the-unexpected`.
- [Known] Base branch: `main`.
- [Known] Requested skill file `.cursor/skills/growth-scout/SKILL.md` was absent in `/workspace` during this run.
- [Known] Required prior state files `.growth-scout/loop-state.md` and `.growth-scout/product-map-draft.md` were absent before this run.
- [Known] This run created baseline Growth Scout documentation instead of updating only a prior last-run date.
- [Unknown] Material change since the previous Growth Scout run is unknown because no previous loop-state was available.
- [Known] No MCP resources were listed by the available MCP resource discovery tool during this run.
- [Known] No visible Growth Scout MCP tools named `scout_competitors` or `preview_work_item_mine` were available in this session.
- [Known] Work-item mining was not performed.
- [Known] Work-item mining requires explicit approval after a preview.
- [Known] No explicit approval to mine work items was available in this automated cron run.

## Signals checked

- [Known] `CHANGELOG.md` lists `1.1.0` dated 2026-06-12 as the latest changelog entry.
- [Known] `SKILL.md` frontmatter declares version `1.1.0`.
- [Known] `gh release list` returned `v1.1.0` as the latest release.
- [Known] `git tag --sort=-creatordate` returned `v1.1.0`.
- [Known] `gh issue list --state open` returned no open issues.
- [Known] `gh issue list --state open --label enhancement` returned no open issues.
- [Known] `gh issue list --state open --label feature-request` returned no open issues.
- [Known] Recent merged PRs visible through GitHub CLI were PR #1 through PR #5, ending with PR #5 for `v1.1.0`.
- [Unknown] No conclusion can be drawn about changed issues or releases since the previous Growth Scout run because the previous run baseline was absent.

## Draft competitor matrix reviewed before scoring

| Competitor / adjacent product | Known facts | Inferred relevance | Open unknowns |
| --- | --- | --- | --- |
| Anthropic Agent Skills / Claude Skills | [Known] Anthropic Agent Skills use directories containing `SKILL.md` files with YAML frontmatter. [Known] Anthropic documents progressive disclosure for skill metadata, body, and supporting files. | [Inferred] This is the closest platform-native analogue because `expect-the-unexpected` is itself a skill package. | [Unknown] Relative install volume, retention, and conversion from Claude users are unknown. |
| Cursor Project Rules | [Known] Cursor Project Rules live in `.cursor/rules` as version-controlled `.mdc` files with activation metadata. [Known] Cursor also supports `AGENTS.md` for simpler persistent guidance. | [Inferred] Cursor Rules compete for developer attention when users want agent behavior guidance, but they are less specialized than a task workflow skill. | [Unknown] Cursor users' preference for rules versus skills for pre-ship risk analysis is unknown. |
| OpenAI Codex `AGENTS.md` and skills | [Known] Codex supports `AGENTS.md` for durable project guidance. [Known] OpenAI documentation describes skills as reusable workflows and domain expertise. | [Inferred] Codex users may expect repo instructions first and task-specific skills second, so install guidance should clarify the division. | [Unknown] Codex skill packaging expectations for this specific repo are unknown. |
| GitHub Copilot custom instructions and prompt files | [Known] GitHub Copilot supports `.github/copilot-instructions.md` for repository-wide custom instructions. [Known] GitHub Copilot supports path-specific `.github/instructions/*.instructions.md` files. | [Inferred] Copilot's built-in instruction files compete as a lighter-weight onboarding path for teams. | [Unknown] Whether Copilot users can or will adopt this package as a skill rather than instructions is unknown. |
| Community rule and skill collections | [Known] Public collections exist for Cursor rules and Anthropic skills. | [Inferred] Discovery and example quality matter because users can choose from many free agent-instruction assets. | [Unknown] Which collections drive qualified traffic for this package is unknown. |

## Minimum viable Phase 5-6 scoring

| Rank | Opportunity | Claim basis | Why it matters | Confidence |
| --- | --- | --- | --- | --- |
| 1 | [Inferred] Build host-specific adoption recipes for Claude Code, Cursor, Codex, and Copilot. | [Known] README lists install paths. [Inferred] Native host instruction systems make adoption expectations host-specific. | [Inferred] Clear recipes reduce friction for users deciding whether this belongs in a skill directory, rule file, or repo instruction file. | [Inferred] Medium |
| 2 | [Inferred] Add a lightweight compatibility and activation checklist for `SKILL.md` consumers. | [Known] The package already includes a validation script. [Known] Competing systems rely on frontmatter or filename conventions. | [Inferred] A checklist can help users verify the skill triggers only for bounded surfaces and does not behave like a whole-repo review tool. | [Inferred] Medium |
| 3 | [Inferred] Expand examples around high-risk developer workflows such as deployment diffs, webhook handlers, bulk imports, and billing changes. | [Known] Existing examples include webhook double delivery and checkout diff Stage 0. [Known] The taxonomy explicitly covers SaaS, payments, time, and external dependencies. | [Inferred] More examples can demonstrate value faster than abstract process docs. | [Inferred] Medium |
| 4 | [Inferred] Validate demand for an automated eval harness before building it. | [Known] `evals/README.md` says benchmark scoring is manual or semi-automated and that a future harness can grep for required strings or structural checks. | [Inferred] Automation could improve credibility, but usage demand is not visible from open issues. | [Inferred] Low |
| 5 | [Inferred] Validate demand for deeper pre-deploy gate integrations before expanding host coverage. | [Known] The repo ships a fail-open pre-deploy gate for Cursor and Claude Code host configs. | [Inferred] Additional host integrations may help distribution, but could add maintenance without clear demand. | [Inferred] Low |

## Build now

- [Inferred] Build now: improve documentation for host-specific adoption recipes and activation checks.
- [Known] This can be scoped to documentation and examples without changing runtime behavior.
- [Inferred] This is a conservative next product move because the current repository already exposes install paths, validation, examples, and host-specific extension docs.

## Validate first

- [Inferred] Validate first: confirm whether users want an automated eval harness or more host integrations before implementing either.
- [Known] No open GitHub issues currently request an eval harness or additional host integrations.
- [Unknown] Demand from support channels, analytics, package installs, or work-item mining is unknown.

## Next actions

- [Known] Keep work-item mining disabled until `preview_work_item_mine` is available and explicit approval is provided after preview.
- [Known] Re-run open issue checks for `enhancement` and `feature-request` labels on the next monthly loop.
- [Known] Re-check `CHANGELOG.md`, GitHub releases, and tags on the next monthly loop.
- [Inferred] If no material release, changelog, or demand signal changes appear next run, update only the last-run date and note no material change.
- [Inferred] If documentation work is approved, start with host-specific adoption recipes and an activation checklist.
- [Inferred] If validation work is approved, gather demand for eval harness and pre-deploy gate expansion before implementation.
