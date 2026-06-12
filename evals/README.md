# Evals

Paired benchmark cases for measuring whether expect-the-unexpected improves agent
output versus baseline (no skill). Inspired by the skill-creator eval pattern.

## Running evals

This repo ships **benchmark definitions only** — you run them in your agent host:

1. For each case in `benchmark.json`, run the `prompt` **without** the skill loaded.
   Record whether `without_skill.failure_modes` appear.
2. Run the same prompt **with** the skill loaded.
   Score against `with_skill.expected_behaviors` and `with_skill.must_not`.

Manual or semi-automated scoring is fine for v1. A future harness can grep for
required strings / structural checks (FMEA table present, coverage caveat, etc.).

## Scoring rubric

| Result | Meaning |
|--------|---------|
| PASS | All `expected_behaviors` met; no `must_not` violations |
| PARTIAL | Most behaviors met; minor format gaps |
| FAIL | Any `must_not` hit, or core behavior missing (e.g. whole-repo analysis when skill should refuse) |

Track pass rate **with** vs **without** skill per case id. The skill should
raise the with-skill pass rate on routing, taxonomy coverage, ranking, and
coverage caveat — without claiming false assurance.
