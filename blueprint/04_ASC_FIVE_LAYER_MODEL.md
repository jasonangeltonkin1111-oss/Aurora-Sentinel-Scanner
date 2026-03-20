# ASC Ordered Capability Model

## Purpose

This document keeps the ASC processing order explicit while moving active canon toward capability-first naming.
The sequence must stay visible for debugging, ownership, and future implementation order.

## Ordered capability stack

1. **Market State Detection**
2. **Open Symbol Snapshot**
3. **Candidate Filtering**
4. **Shortlist Selection**
5. **Deep Selective Analysis**

Internal schema/search keys may still preserve stable architecture identifiers where needed, but active canonical language should prefer the capability names above.

## Capability 1 — Market State Detection

### Internal mapping
- `LAYER_1_OPEN_CLOSED_STATE`

### Purpose
Determine whether each symbol is open, closed, uncertain, or unknown and decide when it should be checked again.

### Owns
- universe-linked market-state truth
- live tick reality check
- session-schedule use for recheck timing
- next open/closed recheck scheduling
- base symbol-file creation
- reserved capability-section scaffolding

### Does not own
- open-symbol snapshots
- candidate filtering
- shortlist ranking
- deep selective analysis
- final ranked summary creation

### Runtime law
- live tick reality first
- session schedule second
- restored persisted state as support
- closed symbols do not get pointless every-second checks forever
- near expected open, aggressive 1-second rechecks may run for up to 1 minute

## Capability 2 — Open Symbol Snapshot

### Internal mapping
- `LAYER_2_OPEN_SYMBOL_SNAPSHOT`

### Purpose
Capture a controlled snapshot of open symbols only.

### Owns
- open-symbol snapshot assembly
- static specs merge for open symbols
- changing Market Watch snapshot writes on controlled cadence
- atomic writes for snapshot-owned sections

### Does not own
- candidate filtering
- shortlist ranking
- deep selective analysis

## Capability 3 — Candidate Filtering

### Internal mapping
- `LAYER_3_FILTER`

### Purpose
Reduce the open universe to symbols worth further attention using cheap checks only.

### Owns
- validity gate
- cheap tradability gate
- cheap characterization
- bucket assignment for survivors

### Does not own
- deep indicator engines
- heavy history work
- final shortlist authority

## Capability 4 — Shortlist Selection

### Internal mapping
- `LAYER_4_TOP_LIST_SELECTION`

### Purpose
Rank filtered symbols inside each bucket and choose the bounded active set.

### Owns
- bucket competition
- score composition for selection
- shortlist cut
- anti-churn and stability controls
- final selected-set authority for deep-analysis entry

### Does not own
- full deep analysis
- raw discovery

## Capability 5 — Deep Selective Analysis

### Internal mapping
- `LAYER_5_DEEP_SELECTIVE_ANALYSIS`

### Purpose
Maintain high-detail rolling analytics only for the final selected set from Shortlist Selection.

### Owns
- last-minute tick memory
- tick-buffer flush scheduling
- OHLC by timeframe
- ATR by timeframe
- selective indicator refreshes by timeframe
- deep-analysis publication blocks

### Does not own
- broad-universe scanning
- cheap first-pass filtering

## Cross-capability law

The five capabilities are ordered.
They must not collapse into one giant function.
Each capability owns its meaning, its publication blocks, and its insertion point in the runtime sequence.
