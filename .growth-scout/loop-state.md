# Growth Scout Loop State

## Last-run metadata

- [Known] Last run timestamp: 2026-07-01T09:00:02Z.
- [Known] Trigger type: monthly cron.
- [Known] Working branch: `cursor/monthly-growth-scout-loop-5fab`.
- [Known] Repository: `008993368-yaz/expect-the-unexpected`.
- [Known] Base branch: `main`.
- [Known] Requested workflow file `.cursor/skills/growth-scout/SKILL.md` was absent in `/workspace` during this run.
- [Known] Requested GitHub issue template `.cursor/skills/growth-scout/templates/github-issues-template.md` was absent in `/workspace` during this run.
- [Known] Prior state files `.growth-scout/loop-state.md` and `.growth-scout/product-map-draft.md` were present and read.
- [Known] Growth Scout MCP server `growth-scout-mcp` returned a live discovery error, so no Growth Scout MCP tools were available.
- [Known] `scout_competitors` was not available; competitor scouting could not be refreshed through Growth Scout MCP.
- [Known] `preview_work_item_mine` was not available; work-item mining was not previewed.
- [Known] Work-item mining was not performed.
- [Known] Work-item mining requires explicit approval after a preview.
- [Known] No explicit approval to mine work items was available in this automated cron run.
- [Known] GitHub MCP server `github-expect-the-unexpected` was connected and used for read-only issue searches.
- [Known] No repository source files were modified during this Growth Scout run.

## Material-change decision

- [Known] `CHANGELOG.md` still lists `1.1.0` dated 2026-06-12 as the latest changelog entry.
- [Known] `SKILL.md` frontmatter still declares version `1.1.0`.
- [Known] `gh release list --repo 008993368-yaz/expect-the-unexpected --limit 5` returned `v1.1.0` as the latest release.
- [Known] `git tag --sort=-creatordate` returned `v1.1.0`.
- [Known] The previous loop-state recorded zero open issues, zero open `enhancement` issues, and zero open `feature-request` issues on 2026-06-19.
- [Known] GitHub MCP `search_issues` returned four open issues on 2026-07-01: epic #7 and tasks #8, #9, and #10.
- [Known] GitHub MCP `search_issues` returned four open `enhancement` issues on 2026-07-01: #7, #8, #9, and #10.
- [Known] GitHub MCP `search_issues` returned zero open `feature-request` issues on 2026-07-01.
- [Inferred] Open issues changed materially since the last run because Phase 7 issues created after the previous baseline are now open demand and planning signals.
- [Inferred] The open-issue change is not independent external demand; the visible issues are the existing Growth Scout epic and tasks for the prior Build now opportunity.
- [Inferred] Phase 1-2 were refreshed for product-map demand context, while Phase 5-6 scoring remains anchored to the current product surface because changelog, releases, and tags did not change.

## Signals checked

- [Known] Local product surface: `README.md`, `SKILL.md`, `CHANGELOG.md`, `.growth-scout/product-map-draft.md`, and `.growth-scout/loop-state.md`.
- [Known] Release surface: GitHub releases and local tags both show `v1.1.0` as latest.
- [Known] Demand surface: GitHub MCP open issue searches for all open issues, `enhancement`, `feature-request`, and duplicate Build now epic terms.
- [Known] Duplicate epic search for `host-specific adoption recipes activation checklist` found existing open epic #7.
- [Known] Existing task issues #8, #9, and #10 are already linked to parent epic #7 via `parent_issue_url`.
- [Unknown] External install analytics, support tickets, marketplace traffic, and package-use telemetry remain unavailable.
- [Unknown] Work-item demand signals remain unavailable because `preview_work_item_mine` was not connected and no approval to mine existed.

## Draft competitor matrix reviewed before scoring

| Competitor / adjacent product | Known facts | Inferred relevance | Open unknowns |
| --- | --- | --- | --- |
| Anthropic Agent Skills / Claude Skills | [Known] Anthropic Agent Skills use directories containing `SKILL.md` files with YAML frontmatter. [Known] The previous product map records progressive disclosure as a relevant Agent Skills pattern. | [Inferred] This is the closest platform-native analogue because `expect-the-unexpected` is itself a skill package. | [Unknown] Relative install volume, retention, and conversion from Claude users are unknown. |
| Cursor Project Rules | [Known] The previous product map records Cursor Project Rules as version-controlled `.mdc` files with activation metadata. [Known] `README.md` lists Cursor skill install paths. | [Inferred] Cursor Rules compete for developer attention when users want agent behavior guidance, but they are less specialized than a task workflow skill. | [Unknown] Cursor users' preference for rules versus skills for pre-ship risk analysis is unknown. |
| OpenAI Codex `AGENTS.md` and skills | [Known] The previous product map records Codex repository guidance through `AGENTS.md`. [Known] `README.md` lists Codex skill install paths. | [Inferred] Codex users may expect repo instructions first and task-specific skills second, so install guidance should clarify the division. | [Unknown] Codex skill packaging expectations for this specific repo are unknown. |
| GitHub Copilot custom instructions and prompt files | [Known] The previous product map records Copilot repository custom instructions and path-specific instruction files. [Known] `README.md` lists `.github/skills/expect-the-unexpected/` as the GitHub Copilot project path. | [Inferred] Copilot's built-in instruction files compete as a lighter-weight onboarding path for teams. | [Unknown] Whether Copilot users can or will adopt this package as a skill rather than instructions is unknown. |
| Community rule and skill collections | [Known] The previous product map records public collections for Cursor rules and Anthropic skills. | [Inferred] Discovery and example quality matter because users can choose from many free agent-instruction assets. | [Unknown] Which collections drive qualified traffic for this package is unknown. |

## Ranked opportunities

| Rank | Opportunity | Claim basis | Why it matters | Confidence |
| --- | --- | --- | --- | --- |
| 1 | [Inferred] Complete the existing host-specific adoption recipes and activation checklist epic. | [Known] Epic #7 and tasks #8-#10 are open. [Known] `README.md` lists install paths. [Inferred] Native host instruction systems make adoption expectations host-specific. | [Inferred] Clear recipes reduce friction for users deciding whether this belongs in a skill directory, rule file, or repo instruction file. | [Inferred] Medium |
| 2 | [Inferred] Expand examples around high-risk developer workflows such as deployment diffs, webhook handlers, bulk imports, and billing changes. | [Known] Existing examples include webhook double delivery and checkout diff Stage 0. [Known] The taxonomy explicitly covers SaaS, payments, time, and external dependencies. | [Inferred] More examples can demonstrate value faster than abstract process docs once adoption docs are underway. | [Inferred] Medium |
| 3 | [Inferred] Validate demand for an automated eval harness before building it. | [Known] `evals/README.md` says benchmark scoring is manual or semi-automated and that a future harness can grep for required strings or structural checks. [Known] No open issue currently requests eval automation. | [Inferred] Automation could improve credibility, but usage demand is not visible from open issues. | [Inferred] Low |
| 4 | [Inferred] Validate demand for deeper pre-deploy gate integrations before expanding host coverage. | [Known] The repo ships a fail-open pre-deploy gate for Cursor and Claude Code host configs. [Known] No open `feature-request` issues request additional host integrations. | [Inferred] Additional host integrations may help distribution, but could add maintenance without clear demand. | [Inferred] Low |
| 5 | [Inferred] Add external demand instrumentation or collection before selecting larger growth bets. | [Known] Current loop has no analytics, support-channel, work-item mining, or install telemetry. | [Inferred] Better demand data would reduce reliance on ecosystem inference for future Growth Scout loops. | [Inferred] Low |

## Decisions

### Build now

- [Inferred] Build now: complete the existing host-specific adoption recipes and activation checklist work.
- [Known] Existing epic issue: [#7 Growth Scout: Host-specific adoption recipes and activation checklist](https://github.com/008993368-yaz/expect-the-unexpected/issues/7).
- [Known] Existing task issue: [#10 Document host-specific adoption recipes](https://github.com/008993368-yaz/expect-the-unexpected/issues/10).
- [Known] Existing task issue: [#8 Add activation and compatibility checklist](https://github.com/008993368-yaz/expect-the-unexpected/issues/8).
- [Known] Existing task issue: [#9 Add documentation QA for adoption guidance](https://github.com/008993368-yaz/expect-the-unexpected/issues/9).
- [Known] GitHub MCP duplicate search found open epic #7 for this opportunity.
- [Known] No new epic or task issues were created during this run to avoid duplicating the existing open Build now epic.
- [Known] This can be scoped to documentation and examples without changing runtime behavior.
- [Inferred] This remains the conservative next product move because the current repository already exposes install paths, validation, examples, and host-specific extension docs.

#### Phase 7 breakdown for existing Build now epic

| Issue | Type | Scope | Acceptance criteria | Success metrics |
| --- | --- | --- | --- | --- |
| [#7](https://github.com/008993368-yaz/expect-the-unexpected/issues/7) | [Known] Epic | [Inferred] Reduce adoption friction across Claude Code, Cursor, Codex, GitHub Copilot, and open Agent Skills-compatible installs. | [Inferred] Host adoption recipes, activation checklist, and documentation QA are completed or deliberately descoped. | [Inferred] A new user can identify install path, activation check, and skill-versus-native-instructions decision from docs alone. |
| [#10](https://github.com/008993368-yaz/expect-the-unexpected/issues/10) | [Known] Task | [Inferred] Document concise host-specific adoption recipes. | [Inferred] Each supported host has project-local install guidance, global install guidance where supported, copy/symlink notes, and skill-versus-native-instruction guidance. | [Inferred] A new user can complete install and know where `SKILL.md` should live for their host from docs alone. |
| [#8](https://github.com/008993368-yaz/expect-the-unexpected/issues/8) | [Known] Task | [Inferred] Add activation and compatibility checklist. | [Inferred] Checklist covers package layout, frontmatter, trigger prompts, non-trigger cases, execution-mode opt-in, and mocking boundaries. | [Inferred] Users can distinguish successful skill activation from generic agent advice. |
| [#9](https://github.com/008993368-yaz/expect-the-unexpected/issues/9) | [Known] Task | [Inferred] Add lightweight documentation QA for adoption guidance. | [Inferred] Existing validation is reviewed for coverage of new docs and links, with either automated checks or a manual release-checklist path. | [Inferred] Docs changes have a clear QA signal before release and are less likely to drift from actual package layout. |

### Validate first

- [Inferred] Validate first: confirm whether users want an automated eval harness or more host integrations before implementing either.
- [Known] No open `feature-request` issues currently request an eval harness or additional host integrations.
- [Known] No independent open enhancement issues beyond the existing Growth Scout Build now epic/tasks are visible through GitHub MCP.
- [Unknown] Demand from support channels, analytics, package installs, or work-item mining is unknown.

## Next actions

- [Known] Keep work-item mining disabled until `preview_work_item_mine` is available and explicit approval is provided after preview.
- [Known] Re-run open issue checks for `enhancement` and `feature-request` labels on the next monthly loop.
- [Known] Re-check `CHANGELOG.md`, GitHub releases, and tags on the next monthly loop.
- [Inferred] Treat #7-#10 as the current Build now backlog and avoid creating another epic for the same adoption-docs opportunity while #7 remains open.
- [Inferred] If #7 is closed before the next loop and no release, changelog, or external demand signal changes appear, update only the last-run date and note no material change.
- [Inferred] If validation work is approved, gather demand for eval harness and pre-deploy gate expansion before implementation.
