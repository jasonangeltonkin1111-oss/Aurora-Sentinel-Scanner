# ASC System Overview

## Product identity

ASC is a stateful MT5 scanner EA.
Its job is to maintain a truthful, rolling, broker-facing, and human-usable view of the symbol universe.

## ASC is
- a broker-universe scanner
- a market-state observer
- a broker-spec snapshot system
- a cheap broad filter and selection system
- a selective deep-analysis system for promoted symbols only
- a persistence and publication system
- a presentation surface for already prepared truth

## ASC is not
- an execution EA
- a signal generator
- a strategy selector
- a portfolio allocator
- a giant all-at-once every-second analytics monolith
- a HUD-driven calculation engine

## Core runtime question set

ASC exists to answer, continuously and honestly:
1. Which symbols exist in the current broker universe?
2. Which symbols are open now and which are closed now?
3. What is the latest available market-watch state for each symbol?
4. What are the current broker-defined symbol constraints?
5. Which open symbols are worth carrying forward?
6. Which selected symbols deserve deeper rolling analysis?
7. What truth is current, stale, pending, degraded, restored, or unavailable?

## Core design laws

### Restore-first law
Startup restores viable prior state before aggressive rebuild work begins.

### Whole-universe law
The universe must remain preserved even when only a small set reaches deep analysis.

### Cheap broad, expensive narrow law
Broad discovery and filtering must stay light.
Heavy enrichment belongs only to the final selected set.

### Separation law
Discovery, stored state, accessors, filtering, selection, deep analysis, publication, and presentation must not collapse into one logic blob.

### Due-based runtime law
The heartbeat only decides what is due.
It does not force every symbol and every field to update every second.

### Publication discipline law
Symbol files come first and evolve by owned sections.
The summary comes later and must not be created too early.

### Human-readable output law
The HUD, menu, and output files must show readable labels, not mechanic names.

## Runtime spine

The runtime is built from:
- a 1-second kernel heartbeat
- a due-based scheduler
- retrieval modules with collector/store/accessor separation
- an explicit ordered capability stack
- atomic publication rules
- symbol files that evolve over time

## Canonical ordered capability stack

1. Market State Detection
2. Open Symbol Snapshot
3. Candidate Filtering
4. Shortlist Selection
5. Deep Selective Analysis

The ordered progression must stay explicit for debugging and future implementation sequencing.
Internal ownership keys may still retain stable architecture identifiers in code, but operator-facing naming must stay capability-first.

## Canonical discovery modules

- `SymbolSpecs`
- `MarketWatchFeed`

These modules retrieve and store truth.
They do not decide ranking, filtering, or selection.

## Canonical publication order

1. symbol file exists
2. capability-owned sections fill over time
3. selection and deep-analysis sections appear when earned
4. summary appears later from already prepared state

## Canonical future code shape

Future MT5 product code should be arranged around:
- `Common`
- `Discovery`
- `Runtime`
- `Layers`
- `Publication`
- `Presentation`

That structure is described in `07_ASC_MT5_STRUCTURE_MAP.md`.


## Current active implementation boundary

Right now the active implementation is **Market State Detection** only.

That tested foundation owns:
- universe sync
- tick presence and freshness
- trade session awareness
- market-status classification
- next-check scheduling
- dossier publication
- runtime continuity
- scheduler continuity
- summary scaffold continuity
- degraded/backlog honesty

It does **not** own:
- Open Symbol Snapshot
- Candidate Filtering
- Shortlist Selection
- Deep Selective Analysis
- execution readiness
- volume validation
- strategy logic
- order-send feasibility logic

The later capabilities remain architecturally present but behaviorally reserved.
They must stay visible in layout, menu planning, runtime insertion points, and dossier placeholders without pretending they are already implemented.
