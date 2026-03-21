# AGENTS.md

## Purpose

This root file defines the operational law for Codex work in this repository.
Keep it short, strict, and grounded in current repo truth.

## Authority order

Work from this order of authority:
1. current repository files
2. current active control surfaces
3. current ownership boundaries
4. explicit evidence in the repo
5. current official OpenAI/Codex documentation when tooling or workflow behavior matters

Never trust memory, stale summaries, screenshots, or recent edits over active repo truth.

## System ownership

### ASC
ASC is the upstream truth engine. It owns scanner/runtime truth, measured market context, publication/state surfaces, and degradation/staleness truth.

### Aurora
Aurora is the downstream interpretation system. It owns family-first interpretation, pattern-second interpretation, deployability/opportunity posture, geometry posture, and generated-card posture.

### Shared law
Preserve ownership boundaries. Preserve missingness honestly. Do not fabricate certainty. Update current files directly. Keep control surfaces truthful.

## Active control surfaces to read first

### ASC-side
- `blueprint/`
- `asc-mt5-scanner-blueprint/`
- `mt5_runtime_flat/`
- `office/`

### Aurora-side
- `Aurora Blueprint/office/README.md`
- `Aurora Blueprint/office/AURORA_OFFICE_CANON.md`
- `Aurora Blueprint/office/TASK_BOARD.md`
- `Aurora Blueprint/office/DECISIONS.md`
- `Aurora Blueprint/office/WORK_LOG.md`
- `Aurora Blueprint/office/SHA_LEDGER.md`
- `Aurora Blueprint/AURORA_CONTROL_INDEX_V5.md`
- `Aurora Blueprint/AURORA_OPERATOR_PROTOCOL.md`
- `Aurora Blueprint/AURORA_RECOVERY_ORDER_V5.md`
- `Aurora Blueprint/AURORA_PROGRESS_TRACKER_V6.md`
- latest file in `Aurora Blueprint/runs/`
- `Aurora Wrapper/` only as compiled canon, not source truth

## Working rules

- Update current owning files directly.
- Do not create parallel scaffolding unless explicitly authorized.
- Prefer merge-and-enrich over file explosion.
- Remove transitional files after lossless merge back into the owning file.
- Keep wrapper/package file counts bounded.
- Do not let wrapper or HUD layers silently become source-truth owners.
- Before broad edits, audit current control files, ownership boundaries, and implementation surfaces.

## Task sizing

Prefer bounded, file-specific tasks:
- one control lane
- one package lane
- one schema/enumeration alignment lane
- one merge lane
- one doctrinal expansion lane

Do not attempt vague repo-wide redesigns or speculative doctrine invention.

## Validation law

Every meaningful pass should leave evidence, not confidence.
Use applicable checks such as:
- file existence and ownership checks
- schema/enum alignment checks
- duplication/drift searches
- wrapper/package count checks
- tests/builds where applicable
- final diff review against source-truth intent

## Continuity law

If active files change materially:
- update the relevant version/generation posture
- update task/log/tracker/control surfaces as required
- refresh SHA coverage where applicable
- do not leave stale files pretending to be current

No fake freshness.

## OpenAI/Codex workflow law

When OpenAI/Codex workflow behavior matters, verify current official documentation first.
Use OpenAI Docs MCP when available. Do not hardcode stale workflow assumptions.

## Output law

Every substantial Codex pass should leave:
- clear file changes
- clear evidence
- clear statement of what remains out of scope
- clear note of any merges or deletions
- no silent architecture drift
