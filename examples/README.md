# Examples

Worked examples showing what expect-the-unexpected produces. Use these to
calibrate Stage 0 scenario generation, taxonomy walks, pre-mortem passes, and
FMEA table format.

| Example | Mode | What it demonstrates |
|---------|------|----------------------|
| [webhook-double-delivery](webhook-double-delivery/) | Per-scenario (user gives scenario) | Full Steps 1–6 on a named scenario |
| [checkout-diff-stage0](checkout-diff-stage0/) | Stage 0 → pick → analyze | Bounded diff → ranked menu → one deep dive |

Each example folder contains:

- `input.md` — what the user provided (scenario or bounded surface)
- `output.md` — representative skill output (abbreviated where noted)

These are **illustrative**, not live test runs. Execution-mode verdicts are
shown only in `webhook-double-delivery/output.md` as a sample close-out.
