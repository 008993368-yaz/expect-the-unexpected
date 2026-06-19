# Growth Scout Loop State

## Last-run metadata

- [Known] Last run timestamp: 2026-06-19T20:44:50Z.
- [Known] Previous loop-state timestamp: 2026-06-19T15:13:06Z.
- [Known] Trigger type: monthly cron.
- [Known] Working branch: `cursor/monthly-growth-scout-loop-c650`.
- [Known] Repository: `008993368-yaz/expect-the-unexpected`.
- [Known] Base branch: `main`.
- [Known] Requested skill file `.cursor/skills/growth-scout/SKILL.md` was absent in `/workspace` during this run.
- [Known] Required state files `.growth-scout/loop-state.md` and `.growth-scout/product-map-draft.md` were present and read during this run.
- [Known] Required GitHub issue template `.cursor/skills/growth-scout/templates/github-issues-template.md` was absent in `/workspace` during this run.
- [Known] No visible Growth Scout MCP tools named `scout_competitors` or `preview_work_item_mine` were available in this session.
- [Known] No visible GitHub MCP tools named `search_issues`, `issue_write`, or `sub_issue_write` for `github-expect-the-unexpected` were available in this session.
- [Known] GitHub CLI read-only checks were used for releases, pull requests, tags, and open issues.
- [Known] Work-item mining was not performed.
- [Known] Work-item mining requires explicit approval after a preview.
- [Known] No explicit approval to mine work items was available in this automated cron run.
- [Known] No material changelog, release, tag, or open issue demand-signal change was found compared with the previous loop-state baseline.
- [Known] PR #6, "Add Growth Scout baseline documentation", was merged after the previous loop-state timestamp and is documentation for the Growth Scout loop rather than a product changelog, release, or open issue demand signal.
- [Inferred] Because no material product or demand signal changed, the current ranked opportunities remain unchanged.

## Signals checked

- [Known] `CHANGELOG.md` lists `1.1.0` dated 2026-06-12 as the latest changelog entry.
- [Known] `SKILL.md` frontmatter declares version `1.1.0`.
- [Known] `gh release list` returned `v1.1.0` as the latest release.
- [Known] `git tag --sort=-creatordate` returned `v1.1.0`.
- [Known] `gh issue list --state open` returned no open issues.
- [Known] `gh issue list --state open --label enhancement` returned no open issues.
- [Known] `gh issue list --state open --label feature-request` returned no open issues.
- [Known] `gh issue list --state open --json number,title,labels,url,updatedAt` returned `[]`.
- [Known] Recent merged PRs visible through GitHub CLI were PR #1 through PR #6, ending with PR #6 for Growth Scout baseline documentation.
- [Known] Open issues, enhancement-labeled open issues, feature-request-labeled open issues, changelog version, latest release, and latest tag matched the previous loop-state baseline.
- [Inferred] No Phase 1-2 refresh was needed because the material inputs named by the loop instructions did not change.

## Draft competitor matrix reviewed before scoring

| Competitor / adjacent product | Known facts | Inferred relevance | Open unknowns |
| --- | --- | --- | --- |
| Anthropic Agent Skills / Claude Skills | [Known] Anthropic Agent Skills use directories containing `SKILL.md` files with YAML frontmatter. [Known] Anthropic documents progressive disclosure for skill metadata, body, and supporting files. | [Inferred] This is the closest platform-native analogue because `expect-the-unexpected` is itself a skill package. | [Unknown] Relative install volume, retention, and conversion from Claude users are unknown. |
| Cursor Project Rules | [Known] Cursor Project Rules live in `.cursor/rules` as version-controlled `.mdc` files with activation metadata. [Known] Cursor also supports `AGENTS.md` for simpler persistent guidance. | [Inferred] Cursor Rules compete for developer attention when users want agent behavior guidance, but they are less specialized than a task workflow skill. | [Unknown] Cursor users' preference for rules versus skills for pre-ship risk analysis is unknown. |
| OpenAI Codex `AGENTS.md` and skills | [Known] Codex supports `AGENTS.md` for durable project guidance. [Known] OpenAI documentation describes skills as reusable workflows and domain expertise. | [Inferred] Codex users may expect repo instructions first and task-specific skills second, so install guidance should clarify the division. | [Unknown] Codex skill packaging expectations for this specific repo are unknown. |
| GitHub Copilot custom instructions and prompt files | [Known] GitHub Copilot supports `.github/copilot-instructions.md` for repository-wide custom instructions. [Known] GitHub Copilot supports path-specific `.github/instructions/*.instructions.md` files. | [Inferred] Copilot's built-in instruction files compete as a lighter-weight onboarding path for teams. | [Unknown] Whether Copilot users can or will adopt this package as a skill rather than instructions is unknown. |
| Community rule and skill collections | [Known] Public collections exist for Cursor rules and Anthropic skills. | [Inferred] Discovery and example quality matter because users can choose from many free agent-instruction assets. | [Unknown] Which collections drive qualified traffic for this package is unknown. |

- [Known] `scout_competitors` was not called because the Growth Scout MCP tool was not visible in this session.
- [Inferred] The prior draft matrix remains adequate for minimum viable Phase 5-6 because no material product or demand signal changed.

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
- [Known] GitHub issues were not created for this Build-now opportunity during this run because `search_issues`, `issue_write`, and `sub_issue_write` MCP tools were not visible.

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

## Decisions

### Build now

- [Inferred] Decision: pursue host-specific adoption recipes and activation checks as the Build-now opportunity.
- [Known] Epic issue URL: not created during this run.
- [Known] Task issue URLs: not created during this run.
- [Known] Reason issues were not created: no visible `github-expect-the-unexpected` MCP `search_issues`, `issue_write`, or `sub_issue_write` tools were available.
- [Known] Related open issues: none found through read-only `gh issue list` checks.

#### Phase 7 local GitHub issue breakdown

##### Draft epic

- [Inferred] Title: Host-specific adoption recipes and activation checks.
- [Inferred] Labels: `enhancement`, `feature-request`.
- [Inferred] Growth lever: improve activation by reducing first-run setup ambiguity across Claude Code, Cursor, Codex, GitHub Copilot, and Agent Skills-compatible hosts.
- [Inferred] Problem: users deciding where and how to install `expect-the-unexpected` must translate the generic skill package into host-specific setup, trigger, and validation steps.
- [Known] Evidence summary:
  - [Known] `README.md` lists install paths for Open standard, Cursor, Claude Code, Codex, and GitHub Copilot.
  - [Known] `scripts/validate.sh` exists for package validation.
  - [Known] `extensions/pre-deploy-gate/` exists as an optional host-specific extension.
  - [Known] Open GitHub issue checks returned no direct demand signal for this opportunity.
  - [Unknown] Install funnel drop-off, activation rate, and support-channel demand are unknown.
- [Inferred] MVP scope:
  - [Inferred] Add concise adoption recipes for the primary supported hosts.
  - [Inferred] Add an activation checklist that helps users verify the skill triggers for bounded surfaces and specific scenarios.
  - [Inferred] Add copy/symlink and smoke-test guidance that stays documentation-only.
  - [Inferred] Keep runtime behavior, skill routing, and extension scripts unchanged.
- [Inferred] Success metrics:
  - [Inferred] A new user can identify the correct install location for their host without reading unrelated host docs.
  - [Inferred] A new user can run one documented smoke test that confirms the skill activates for a bounded surface or scenario.
  - [Inferred] Documentation clearly distinguishes skills from host-native persistent instruction systems.
  - [Inferred] No package validation regressions are introduced.

##### Draft task breakdown

| Task | Type | Acceptance criteria | Success metrics |
| --- | --- | --- | --- |
| [Inferred] Document host-specific adoption recipes. | [Inferred] Docs | [Inferred] Add one concise recipe each for Claude Code, Cursor, Codex, GitHub Copilot, and the open Agent Skills path. [Inferred] Each recipe includes project-local path, global path where applicable, and copy/symlink guidance. | [Inferred] Readers can choose the correct install path for their host from one section. |
| [Inferred] Add an activation and smoke-test checklist. | [Inferred] Docs/testing guidance | [Inferred] Checklist covers required `SKILL.md` location, bounded-surface trigger, specific-scenario trigger, and non-trigger for generic whole-repo review. [Inferred] Checklist does not require live external services. | [Inferred] Readers can verify expected activation behavior with documented prompts. |
| [Inferred] Clarify skill-vs-instructions positioning. | [Inferred] Docs | [Inferred] Explain when to use this reusable skill versus Cursor rules, `AGENTS.md`, or Copilot instruction files. [Inferred] Avoid claiming unsupported host behavior. | [Inferred] Documentation reduces ambiguity for users already using host-native instructions. |
| [Inferred] Add documentation validation coverage for new links/examples. | [Inferred] Testing | [Inferred] Ensure `scripts/validate.sh` passes after documentation changes. [Inferred] Add or update validation only if new documentation structure needs it. | [Inferred] CI continues to validate the package without new dependencies. |
