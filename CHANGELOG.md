# Changelog

All notable changes to this skill package are documented here. The `version`
field in `SKILL.md` frontmatter matches the latest release tag.

## [1.1.0] - 2026-06-12

### Added

- `examples/` — worked input → FMEA output (per-scenario and Stage 0)
- Explicit 3×3 Likelihood × Impact → Risk matrix in `SKILL.md`
- Inline one-line gloss for all 8 taxonomy categories in `SKILL.md`
- `evals/benchmark.json` — paired with-skill / without-skill benchmark cases
- `scripts/validate.sh` and GitHub Actions `validate` workflow
- `CHANGELOG.md` and `version` in skill frontmatter

### Changed

- `references/execution-mode.md` — trust boundary: how mocking uses the project's existing test stack
- `SKILL.md` — execution-mode overview links to mocking rules
- Pre-deploy gate script — fail-open `ERR` trap; extension README documents graceful degradation

## [1.0.0] - prior releases

Initial skill: scenario-driven FMEA, Stage 0 generation, reasoning + opt-in execution mode, optional pre-deploy gate extension.
