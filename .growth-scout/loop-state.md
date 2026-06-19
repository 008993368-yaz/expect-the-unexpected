# Growth Scout Loop State

## Last-run metadata

- [Known] Last run timestamp: 2026-06-19T20:49:55Z.
- [Known] Trigger type: monthly cron.
- [Known] Working branch: `cursor/monthly-growth-scout-loop-4cf4`.
- [Known] Repository: `008993368-yaz/expect-the-unexpected`.
- [Known] Base branch: `main`.
- [Known] Requested skill file `.cursor/skills/growth-scout/SKILL.md` was absent in `/workspace` during this run.
- [Known] Requested GitHub issues template `.cursor/skills/growth-scout/templates/github-issues-template.md` was absent in `/workspace` during this run.
- [Known] Prior state files `.growth-scout/loop-state.md` and `.growth-scout/product-map-draft.md` were present and read during this run.
- [Known] No material product signal change was found in `CHANGELOG.md`, GitHub releases, tags, or pre-existing open issues since the previous recorded loop timestamp.
- [Known] Phase 1-2 product map refresh was not performed because the checked product signals were materially unchanged.
- [Known] Phase 5-6 was run minimum viable against the current saved context.
- [Known] No visible Growth Scout MCP tools named `scout_competitors` or `preview_work_item_mine` were available in this session.
- [Known] Work-item mining was not performed.
- [Known] Work-item mining requires explicit approval after a preview.
- [Known] No explicit approval to mine work items was available in this automated cron run.
- [Known] GitHub MCP server `github-expect-the-unexpected` was connected and used for read-only demand-signal searches plus Phase 7 issue creation.

## Signals checked

- [Known] `CHANGELOG.md` lists `1.1.0` dated 2026-06-12 as the latest changelog entry.
- [Known] `SKILL.md` frontmatter declares version `1.1.0`.
- [Known] GitHub MCP `list_releases` returned `v1.1.0` as the latest release.
- [Known] GitHub MCP `list_tags` returned `v1.1.0`.
- [Known] GitHub MCP `search_issues` returned no pre-existing open issues before Phase 7 issue creation.
- [Known] GitHub MCP `search_issues` returned no pre-existing open issues labeled `enhancement` before Phase 7 issue creation.
- [Known] GitHub MCP `search_issues` returned no pre-existing open issues labeled `feature-request` before Phase 7 issue creation.
- [Known] GitHub MCP `list_commits` on `main` since `2026-06-19T15:13:06Z` returned commit `94da404835027924ebfb02b521bf6237d2335f8c` (`Add growth scout baseline (#6)`).
- [Inferred] Commit `94da404835027924ebfb02b521bf6237d2335f8c` is not a material product-surface change because it added Growth Scout baseline documentation rather than product behavior, release, changelog, or user-demand changes.
- [Known] GitHub MCP `search_issues` for an existing open epic matching `host-specific adoption`, `activation checklist`, or `adoption recipes` returned zero results before issue creation.

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
| 1 | [Inferred] Build host-specific adoption recipes for Claude Code, Cursor, Codex, and Copilot. | [Known] README lists install paths. [Known] No pre-existing open issue covered this opportunity before Phase 7. [Inferred] Native host instruction systems make adoption expectations host-specific. | [Inferred] Clear recipes reduce friction for users deciding whether this belongs in a skill directory, rule file, or repo instruction file. | [Inferred] Medium |
| 2 | [Inferred] Add a lightweight compatibility and activation checklist for `SKILL.md` consumers. | [Known] The package already includes a validation script. [Known] Competing systems rely on frontmatter or filename conventions. | [Inferred] A checklist can help users verify the skill triggers only for bounded surfaces and does not behave like a whole-repo review tool. | [Inferred] Medium |
| 3 | [Inferred] Expand examples around high-risk developer workflows such as deployment diffs, webhook handlers, bulk imports, and billing changes. | [Known] Existing examples include webhook double delivery and checkout diff Stage 0. [Known] The taxonomy explicitly covers SaaS, payments, time, and external dependencies. | [Inferred] More examples can demonstrate value faster than abstract process docs. | [Inferred] Medium |
| 4 | [Inferred] Validate demand for an automated eval harness before building it. | [Known] `evals/README.md` says benchmark scoring is manual or semi-automated and that a future harness can grep for required strings or structural checks. | [Inferred] Automation could improve credibility, but usage demand is not visible from open issues. | [Inferred] Low |
| 5 | [Inferred] Validate demand for deeper pre-deploy gate integrations before expanding host coverage. | [Known] The repo ships a fail-open pre-deploy gate for Cursor and Claude Code host configs. | [Inferred] Additional host integrations may help distribution, but could add maintenance without clear demand. | [Inferred] Low |

## Decisions

### Build now

- [Inferred] Build now: improve documentation for host-specific adoption recipes and activation checks.
- [Known] This can be scoped to documentation and examples without changing runtime behavior.
- [Inferred] This is a conservative next product move because the current repository already exposes install paths, validation, examples, and host-specific extension docs.
- [Known] Phase 7 epic created: [Growth Scout: Host-specific adoption recipes and activation checklist](https://github.com/008993368-yaz/expect-the-unexpected/issues/7).
- [Known] Phase 7 task issue created: [Document host-specific adoption recipes](https://github.com/008993368-yaz/expect-the-unexpected/issues/10).
- [Known] Phase 7 task issue created: [Add activation and compatibility checklist](https://github.com/008993368-yaz/expect-the-unexpected/issues/8).
- [Known] Phase 7 task issue created: [Add documentation QA for adoption guidance](https://github.com/008993368-yaz/expect-the-unexpected/issues/9).
- [Known] GitHub MCP `sub_issue_write` was called to link the three task issues under epic issue #7.

### Validate first

- [Inferred] Validate first: confirm whether users want an automated eval harness or more host integrations before implementing either.
- [Known] No open GitHub issues currently request an eval harness or additional host integrations.
- [Unknown] Demand from support channels, analytics, package installs, or work-item mining is unknown.

## Phase 7 GitHub issue breakdown

### Epic: host-specific adoption recipes and activation checklist

- [Known] Epic issue URL: https://github.com/008993368-yaz/expect-the-unexpected/issues/7
- [Inferred] Growth lever: reduce adoption friction for developers evaluating `expect-the-unexpected` across Claude Code, Cursor, Codex, GitHub Copilot, and other Agent Skills-compatible hosts.
- [Inferred] Problem: users need host-specific install, activation, and native-instructions-vs-skill guidance beyond the current install-path table.
- [Known] Evidence: `README.md` lists install paths; `SKILL.md` defines routing and activation constraints; GitHub MCP returned no pre-existing open issues before Phase 7; Growth Scout MCP was unavailable.
- [Inferred] MVP scope: add host recipes, add activation checklist, add lightweight documentation QA.
- [Inferred] Success metrics: each supported host has a clear install and activation path; users can distinguish skill installation from native host instructions; documentation QA reduces drift.

| Task | URL | Type | Acceptance criteria | Success metrics |
| --- | --- | --- | --- | --- |
| [Known] Document host-specific adoption recipes | https://github.com/008993368-yaz/expect-the-unexpected/issues/10 | [Inferred] Docs | [Inferred] Each supported host has project-local/global guidance where supported; recipes explain when to use the skill package versus native instructions; existing install paths are preserved unless verified stale. | [Inferred] A new user can complete install and identify where `SKILL.md` belongs for their host. |
| [Known] Add activation and compatibility checklist | https://github.com/008993368-yaz/expect-the-unexpected/issues/8 | [Inferred] Docs | [Inferred] Checklist covers package layout, frontmatter, trigger phrases, non-trigger cases, smoke prompt, execution-mode opt-in, and mocking boundary. | [Inferred] Users can distinguish successful skill activation from generic agent advice. |
| [Known] Add documentation QA for adoption guidance | https://github.com/008993368-yaz/expect-the-unexpected/issues/9 | [Inferred] Testing / docs QA | [Inferred] Existing validation is reviewed for new docs; automated or manual QA path covers links, required files, and recipe/checklist references. | [Inferred] Docs changes have a clear QA signal before release. |

- [Known] These are planning artifacts for the current Build-now opportunity.
- [Known] These planning artifacts are not proof of demand or product correctness.
- [Unknown] External demand, analytics, and unmined work-item classes remain unverified.

## Next actions

- [Known] Keep work-item mining disabled until `preview_work_item_mine` is available and explicit approval is provided after preview.
- [Known] Re-run open issue checks for `enhancement` and `feature-request` labels on the next monthly loop.
- [Known] Re-check `CHANGELOG.md`, GitHub releases, and tags on the next monthly loop.
- [Inferred] If no material release, changelog, demand-signal, or Phase 7 backlog change appears next run, update only the last-run date and note no material change.
- [Inferred] If documentation work starts, begin with issue #10, then issue #8, then issue #9.
- [Inferred] If validation work is approved, gather demand for eval harness and pre-deploy gate expansion before implementation.
