# Execution Mode

Use this ONLY when both are true: (1) the per-scenario flow has finished — the
FMEA table and coverage note were delivered; (2) the user explicitly accepted
the execution offer (Step 6 in `SKILL.md`). Never enter execution mode
uninvited, and never skip the reasoning-mode output to get here faster.

The job: turn the FMEA rows the user picked into real test files, run them
with the project's **own** test runner, report a per-row verdict, and offer
the row's mitigation — one fix at a time, each with user approval — for every
confirmed failure.

This mode modifies the working tree (test files; approved fixes). That is the
point — but only within the rules below.

## Hard rules

- **Mock or fake every external dependency.** Never contact real third-party
  services (payment APIs, email providers, live deploys). Never perform
  destructive operations against real data.

### Trust boundary — how mocking works

Use the **project's existing test framework** — do not add a parallel mocking
stack without explicit approval.

| Stack | Prefer | Avoid |
|-------|--------|-------|
| Vitest / Jest | `vi.mock` / `jest.mock` on modules; `msw` only if the project already uses it | Real `fetch` to Stripe, SendGrid, etc. |
| pytest | `unittest.mock.patch`, `monkeypatch`, project fixtures / `responses` if already present | Hitting staging DB or live APIs |
| Go | `httptest`, interface fakes, existing `gomock` / mockgen stubs | `os.Getenv` pointing at prod |
| .NET | `Moq` / NSubstitute patterns already in the repo | Integration tests against shared envs |

Rules of thumb:

- **Read two existing tests first** — match file location, naming, and how that
  repo already stubs HTTP/DB/email.
- **Inject at the boundary** the production code calls (the Stripe client module,
  the `db.orders` repository), not deep internals — unless the repo does.
- **No network by default** — if a test would dial out, it is NOT EXECUTABLE until
  a mock is identified or the user approves adding a dev dependency.
- **No destructive writes** — use transactions rolled back, in-memory fakes, or
  temp dirs; never truncate shared tables or delete prod-like fixtures.
- **Env vars** — do not point tests at `DATABASE_URL`, API keys, or webhooks
  from the user's shell; use test-only values or mocks.
- **Never install or scaffold test infrastructure without explicit approval.**
- **Never batch-apply fixes.** One confirmed failure → one offered fix → one
  approval → one re-run.
- **Never loosen a test to make it pass.** If a fix doesn't make the test
  green, report that honestly.
- **Never present a verdict as certification.** A passing test is evidence,
  not proof.

## Procedure

### 1. Gate — find the test runner

Detect the project's test setup: `package.json` scripts (`test`, `vitest`,
`jest`), `pytest.ini` / `pyproject.toml` / `setup.cfg`, `go.mod` (`go test`),
`Cargo.toml` (`cargo test`), `*.csproj` (`dotnet test`), `Gemfile` + `spec/`
(`rspec`), or equivalent.

If nothing is found: report that, and ask the user for the command they use to
run tests. If they have none, you may **offer** a minimal setup — install only
with their explicit approval.

### 2. Select executable rows

From the rows the user picked ("top 3" is a valid pick):

- A row is **executable** only if its FMEA "Mitigation / Test" entry describes
  a concrete test (inputs + expected behavior) that can run against mocked or
  faked dependencies.
- A row that requires real external infrastructure (a live webhook delivery, a
  real deploy, a third-party outage) is **NOT EXECUTABLE** — say so, give the
  reason, and name the mock/fake/harness that would make it testable.

### 3. Write the tests

- Follow the project's conventions: test directory, framework, file naming,
  assertion style. Read one or two existing test files first and match them.
- One test per failure mode. The test asserts the **correct** expected
  behavior — so the test *failing* means the predicted failure mode is real.
- Add a comment at the top of each test linking back to its FMEA row: the
  scenario and the failure mode it probes.

### 4. Run the new tests only

Invoke the runner targeted at the new files (e.g. `npx vitest run path/`,
`pytest path/ -v`, `go test ./pkg -run TestName`). Do not run the whole suite.
Capture the output.

### 5. Report verdicts

One row per selected failure mode:

| Failure mode | Test file | Verdict |
|--------------|-----------|---------|

- **CONFIRMED** — the test fails: the predicted failure mode is real. Quote
  the failing output as evidence.
- **NOT REPRODUCED** — the test passes: the failure was not observed under
  this test. This is NOT proof the failure mode is absent.
- **INCONCLUSIVE** — the test errored, was flaky, or could not run. State the
  reason; do not guess a verdict.

Include the NOT EXECUTABLE rows from step 2 so the user sees full coverage of
their picks.

### 6. Fix loop (CONFIRMED rows only)

For each confirmed failure, **one at a time**:

1. Present the mitigation from that FMEA row as a concrete change.
2. Get the user's approval. They may skip this fix or stop the loop entirely.
3. Apply the fix.
4. Re-run that test, then the other generated tests — a fix must not break a
   sibling probe. Report the new verdicts.

If the user declines a fix, keep the test but mark it as an expected failure
using the framework's convention (`xfail`, `test.todo`, `skip` with a reason —
include the FMEA row in the reason) so the suite stays green while the known
bug stays documented. Note it in the close-out.

### 7. Artifact lifecycle

Keep the generated tests by default: they are regression coverage from now on.
Discard them only if the user asks.

### 8. Close-out caveat (REQUIRED)

End every execution-mode run with, verbatim in spirit:

> "Executed tests cover only the selected failure modes. A passing test is
> evidence, not proof of correctness. Unselected rows, NOT EXECUTABLE rows,
> and anything outside these scenarios remain unverified."

Also list: declined fixes (known bugs, tests marked expected-failure) and any
INCONCLUSIVE rows.
