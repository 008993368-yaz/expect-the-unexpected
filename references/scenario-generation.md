# Scenario Generation (Stage 0)

Use this when the user gives a **bounded surface** but no scenario. The job: turn
the surface into a short, ranked menu of concrete scenarios worth tracing, then
hand each chosen one to the normal analysis pipeline.

This is still reasoning only. Generating scenarios is prediction, not action — do
not run tests or modify code.

## Bounded surface — required

A surface is one of:

- **Git diff / PR** *(default)* — the changed lines. Get them, e.g.
  `git diff`, `git diff <base>...<head>`, or the PR's changed files.
- **One file / function** — the named handler/module.
- **A feature description** — prose, no code yet (design time).
- **An endpoint / entry point** — a named route; trace inward from it.

If the user gives none of these (e.g. "review my whole repo", "find all bugs"),
**refuse** — name the four surfaces and ask the user to pick one (e.g. "point me
at the diff, a file, an endpoint, or describe the feature"). Reasoning mode
generates scenarios from a bounded surface, not from the whole codebase.

## Procedure

### 1. Gather the surface

Read only the surface. For a diff, read the changed hunks (plus immediately
surrounding context needed to understand them); do not read the whole repo.

### 2. Extract risk anchors

On that surface, list:

- **Entry points** — how data/control enters (routes, handlers, jobs, events).
- **Untrusted inputs** — request bodies, params, headers, files, messages.
- **Side effects** — DB writes, charges, emails, file writes, external POSTs.
- **External calls** — DB, cache, queue, third-party APIs.
- **Shared / concurrent state** — counters, rows, files multiple requests touch.

### 3. Run the taxonomy IN REVERSE as a generator

**READ `references/failure-taxonomy.md` now.** For each of its 8 categories, ask:

> "What concrete scenario on THIS surface would exercise this category?"

This is the inverse of the per-scenario taxonomy walk. The per-scenario flow
asks "given this scenario, what does this category break?"; here you ask "given
this surface, what scenario makes this category bite?" One category often yields
several candidate scenarios — keep each as its own candidate. Anchor every
scenario to a specific anchor from step 2 (e.g. "the Stripe webhook handler" not
"some endpoint").

A scenario is concrete and traceable, e.g. "the payment webhook is delivered
twice" — never a category label like "check inputs".

### 4. Rank candidates by blast radius × plausibility

- **Blast radius** — how bad if it happens (data loss, double-charge, outage,
  silent corruption rank high; cosmetic ranks low).
- **Plausibility** — how likely THIS surface actually hits it (a surface that
  charges money and retries makes double-charge highly plausible).

Rank highest combined first.

### 5. Cap and present a menu

Present the top **5–8** scenarios as a ranked menu (fewer is fine for a small
surface — don't pad a sparse menu to hit a number). One line each: the scenario +
why it's risky (the anchor it touches and the category it exercises). The menu is
useful output on its own, before any deep analysis. See
`examples/checkout-diff-stage0/` for a worked Stage 0 menu.

If the surface was large (e.g. a diff spanning many files) and you focused on the
highest-risk parts, **say what you skipped** — this feeds the coverage caveat.

Then ask the user which to analyze. "Do the top N" is a valid pick.

## Handoff to the analysis pipeline

For each scenario the user picks, run the normal per-scenario flow in `SKILL.md`
(state the path → walk the taxonomy → pre-mortem → FMEA → coverage caveat),
exactly as for a user-supplied scenario.

The closing coverage caveat must additionally note: scenarios that were generated
but **not selected**, and any surface area dropped by the cap, remain unanalyzed.
