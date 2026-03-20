# ASC Symbol Files and Publication

## Purpose

ASC symbol files are the evolving per-symbol truth containers.
They are created early and fill gradually as layers do their work.

## Symbol-file-first law

The symbol file exists before the summary.
The summary is downstream and later.
Layer 1 must not create the summary.

## Evolution model

1. Layer 1 creates the base file and placeholder sections
2. Layer 2 adds open-symbol snapshot content
3. Layer 3 adds filter content
4. Layer 4 adds top-list selection content
5. Layer 5 adds deep selective-analysis content
6. summary publication happens later from prepared state

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
- Layer 1 writes only Layer 1 state and base scaffolding it owns
- Layer 2 writes only Layer 2 snapshot state
- Layer 4 writes only selection state
- the HUD writes nothing to symbol files

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
