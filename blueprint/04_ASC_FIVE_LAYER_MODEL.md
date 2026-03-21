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
- any currently permitted focus-safe refresh of Market State Detection-owned fields

### Does not own
- open-symbol snapshots
- candidate filtering
- shortlist ranking
- deep selective analysis
- final ranked summary creation
- focus-triggered activation of later capability work

### Runtime law
- live tick reality first
- session schedule second
- restored persisted state as support
- closed symbols do not get pointless every-second checks forever
- near expected open, aggressive 1-second rechecks may run for up to 1 minute
- focused symbol viewing may only elevate fields already owned by Market State Detection and only within stale-bound limits

### Layer 1 readiness and warmup law
- boot and recovery enter `ASC_RUNTIME_WARMUP` until a minimum Layer 1 readiness threshold is met
- warmup readiness is not defined by missing dossiers alone
- readiness must be computed from current Layer 1 truth only: initial assessments completed across a configurable minimum portion of the live universe plus all currently discovered compressed priority-set-1 buckets
- compressed priority-set-1 buckets currently mean `FX_MAJOR`, `INDEX_US`, `INDEX_EUROPE`, `METALS_PRECIOUS`, `ENERGY`, and `CRYPTO_LARGE_CAP`
- once that threshold is met, runtime promotes to `ASC_RUNTIME_STEADY` even if lower-priority symbols still need their first pass
- lower-priority hydration may continue in the background and must be surfaced honestly as background preparation rather than keeping warmup active forever
- runtime continuity and HUD surfaces must carry explicit readiness fields: total symbols discovered, initial symbols assessed, compressed primary buckets ready, warmup minimum met, background completion active, and readiness percent
- the warmup exit rule is Layer 1-only: all compressed priority-set-1 buckets must have promoted prepared truth and the first market-state assessment must cover the configured minimum share of discovered live symbols

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
- later focus-safe elevation only for snapshot-owned fields that are both relevant and stale

### Does not own
- candidate filtering
- shortlist ranking
- deep selective analysis
- blanket fast refresh of all open-symbol fields merely because the HUD is open

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
- prepared bucket summaries when this capability becomes active

### Does not own
- deep indicator engines
- heavy history work
- final shortlist authority
- HUD-side bucket rebuilding

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
- later shortlist-focused refresh rights within stale and budget bounds

### Does not own
- full deep analysis
- raw discovery
- blanket focus permission to recompute every candidate on redraw

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
- future stat-detail focus elevation for deep-analysis-owned fields only

### Does not own
- broad-universe scanning
- cheap first-pass filtering
- permission for HUD redraws to trigger history pulls or indicator recalculation directly

## Cross-capability law

The five capabilities are ordered.
They must not collapse into one giant function.
Each capability owns its meaning, its publication blocks, its refresh tiers, and its insertion point in the runtime sequence.

## Capability-stage refresh law

Focused exploration is not a separate capability.
It is a bounded runtime request that each capability may honor only for fields it already owns.
That means:
- Market State Detection may only elevate market-state-owned fields
- Open Symbol Snapshot may later elevate snapshot-owned fields
- Candidate Filtering may later elevate prepared bucket/filter views
- Shortlist Selection may later elevate shortlist views
- Deep Selective Analysis may later elevate deep stats for already selected symbols

Focus does not authorize inactive downstream work early.
