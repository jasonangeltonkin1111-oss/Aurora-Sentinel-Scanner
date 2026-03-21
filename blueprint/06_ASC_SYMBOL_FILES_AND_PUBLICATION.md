# ASC Symbol Files and Publication

## Purpose

ASC symbol files are the evolving per-symbol truth containers.
They are created early and fill gradually as capabilities do their work.

## Symbol-file-first law

The symbol file exists before the summary.
The summary is downstream and later.
Market State Detection must not create the final ranked summary.
Reserved Layer 2 publication scaffolding may exist before activation, but it must stay explicitly inactive and must not imply live snapshot compute.

## Evolution model

1. Market State Detection creates the base file and reserved capability sections
2. Open Symbol Snapshot later adds snapshot content; current runtime only carries reserved Layer 2 scaffolding so activation can land without renaming churn
3. Candidate Filtering adds filter content
4. Shortlist Selection adds shortlist content
5. Deep Selective Analysis adds deep-analysis content
6. prepared overview, bucket, symbol, and stat snapshots adapt from already persisted truth
7. summary publication happens later from prepared state

## Canonical major sections

- `SYMBOL_HEADER`
- `SYMBOL_IDENTITY`
- `SYMBOL_RUNTIME_STATE`
- `SYMBOL_SCHEDULE_STATE`
- `LAYER_1_OPEN_CLOSED_STATE`
- `LAYER_2_OPEN_SYMBOL_SNAPSHOT`
- `LAYER_3_FILTER`
- `LAYER_4_TOP_LIST_SELECTION`
- `LAYER_5_DEEP_SELECTIVE_ANALYSIS`
- `PUBLICATION_STATE`
- `WRITE_STATE`
- `ERROR_STATE`

## Section ownership law

Each section has one owner.

Examples:
- Market State Detection writes only its owned state and the reserved scaffolding it owns
- Open Symbol Snapshot writes only snapshot state when activated; until then the dossier/runtime may expose reserved readiness, last-built, pending-reason, and cadence markers only
- Shortlist Selection writes only shortlist state
- the HUD writes nothing to symbol files

## Atomic rolling persistence law

HUD-visible runtime truth must be persisted as rolling state rather than rebuilt on render.
That means:
- canonical sections update atomically by owned payload, not by ad hoc partial text mutation
- unchanged sections should not be rewritten merely because another surface was viewed
- changed sections may be recalculated and rewritten without forcing a whole dossier rebuild
- last-good section truth must survive transient refresh failure or downgrade
- focus entry may request bounded freshness work but must not trigger full dossier regeneration
- focus exit may drop elevation while retaining valid last-good truth until an owned expiry or replacement rule applies

## Atomic write law

Canonical files must not be written directly to final destination.
Use a safe write path:
1. build payload
2. write temp
3. validate temp
4. replace final atomically or equivalently safely
5. preserve last good where appropriate

## Stronger-truth preservation

A weak current pass must not casually destroy stronger earlier truth.
Downgrades must be explicit.

## Snapshot adapter law

Explorer-facing surfaces are adapted from prepared runtime truth.
Examples include:
- overview snapshot
- bucket list snapshot
- bucket detail snapshot
- symbol detail snapshot
- stat detail snapshot
- later combined or Aurora-reserved snapshots

These snapshots consume persisted capability-owned sections.
They must not crawl raw files, rebuild classifiers, or re-derive heavy fields on click.

## Summary law

The summary is a publication artifact built from already prepared state.
It is not the primary store of truth.
It is not the universe.

## Human-readable publication law

Published labels must be readable.
Use `Daily Change`, not `daily_change`.
Use `Market Status`, not `LAYER_1_OPEN_CLOSED_STATE`.

## Minimum publication rule

Even before deep analysis exists, base symbol files should still express:
- symbol identity
- market open or closed state
- next recheck expectation
- placeholder state for future sections

## Bridge-ready dossier law

Because Aurora may later ingest ASC dossiers, symbol files should remain both operator-readable and machine-parseable.

That means the dossier should preserve stable section names and include enough scanner-owned timing and continuity truth to support downstream ingestion without adding strategy logic.

Minimum bridge-friendly scanner facts include:
- symbol
- server
- current status
- last tick seen
- next due / next check
- session availability
- runtime mode
- degraded or recovery markers where relevant

## Future insertion law

Later capabilities and later explorer surfaces must be insertable by adding owned sections and new adapted snapshots, not by changing the whole publication model.
Any future layer must inherit the same rules:
- owned cadence
- stale-bound refresh
- atomic rolling persistence
- last-good preservation
- HUD consumption through adapters rather than raw recomputation

## Version discipline law

Meaningful edits to the wrapper, dossier contract, or explorer subsystem must bump version.
The version shown in dossier metadata must stay aligned with the active EA wrapper so downstream readers never have to guess which contract generated a file.
