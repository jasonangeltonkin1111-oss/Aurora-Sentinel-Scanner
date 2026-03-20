# ASC Runtime Kernel and Event Model

## Runtime philosophy

ASC is not tick-driven in the architectural sense.
It is **timer-driven orchestration** with optional tick evidence as one input into symbol-state truth.

This distinction matters because:

- MT5 events are serialized
- `OnTick()` arrival can be symbol/chart specific and noisy
- whole-universe scanners need scheduler control
- persistence and publication need bounded timing

## Correct MT5 event stance

### `OnInit()`
Owns:
- path resolution
- folder verification
- logger configuration
- restore attempts
- universe shell creation
- timer activation
- initial mode selection

### `OnTimer()`
Owns:
- heartbeat
- due queue execution
- bounded dispatch
- scheduler fairness
- background refresh orchestration
- safe persistence triggers
- summary publication triggers
- degradation decisions

### `OnTick()`
Owns:
- either nothing heavy
- or only the thinnest possible instrumentation if absolutely required later

Do not let `OnTick()` own:
- whole-universe scans
- heavy history pulls
- summary rebuilds
- dossier file flush waves
- ranking passes

### `OnDeinit()`
Owns:
- timer kill
- final best-effort persistence
- shutdown reason logging

## Kernel responsibilities

The kernel decides:

- what is due now
- what may wait
- what is high priority
- what is stale
- what needs retry
- what is blocked
- what must publish
- what is too expensive this heartbeat

The kernel does **not** decide trader-facing interpretation.

## Heartbeat model

### Base heartbeat
1-second `OnTimer()` cadence is the active blueprint spine.

This does **not** mean:
- every symbol updates every second
- every layer runs every second
- every field is rewritten every second

It means:
- each second, the kernel checks due work and executes a bounded subset

## Re-entry guard

The runtime should protect against overlapping timer work.
Even though MQL5 events are serialized, long-running handlers can create operational confusion and backlog.
Use a simple guard such as:

- `g_heartbeat_running`
- timestamp of current cycle
- dropped/skipped cycle count

Policy:
- if a timer cycle is already active, mark the next as skipped/deferred rather than recursively entering

## Due item model

A due item is the atom of work.

Recommended fields:

- `due_id`
- `service_family`
- `symbol`
- `layer`
- `task_kind`
- `field_group`
- `timeframe`
- `priority`
- `reason`
- `last_run_at`
- `next_due_at`
- `retry_count`
- `max_retry_policy`
- `last_outcome`
- `estimated_cost`
- `dirty_dependencies`

## Due item families

### Runtime safety
- restore finalization
- persistence checkpoints
- backlog management
- journal rotation

### Universe maintenance
- universe resync
- symbol existence checks
- selection-state membership sync

### Market-state truth
- open/closed rechecks
- near-open aggressive checks
- stale feed reassessment

### Snapshot services
- SymbolSpecs refresh
- MarketWatch snapshot refresh

### Layer services
- filter recompute
- ranking recompute
- shortlist sync
- deep-analysis refresh by timeframe

### Publication
- dossier write
- summary write
- runtime state write
- scheduler state write

## Dispatch priority

Suggested priority order:

1. runtime safety
2. restore continuity
3. market-state truth
4. snapshot truth
5. layer 3 filter
6. layer 4 selection
7. essential publication
8. layer 5 deep analysis
9. cosmetic/HUD refresh

## Bounded-work law

Each heartbeat has caps:

- max symbols touched
- max due items executed
- max expensive calls
- max file promotions
- max history pulls
- reserved budget for persistence/publication

Without this, a spike in due work turns a timer design into hidden batch chaos.

## Fairness and starvation

The scheduler should not permanently favor the same symbols.

Use at least:
- round-robin cursoring
- age-based boost for neglected items
- debt tracking for deferred families
- separate caps for cheap vs expensive services

## Retry behavior

Not all failures are equal.

### Retry soon
- temporary feed unavailable
- history synchronization not ready
- file-share conflict
- symbol just selected but not warmed yet

### Retry later
- market closed
- session says next open hours away
- indicator handle not yet relevant
- demoted symbol deep state frozen

### Do not retry blindly
- unsupported symbol property
- permanently invalid schema version
- bad configuration

## Recommended timer services

### Every second
- heartbeat
- due dispatch
- near-open symbol checks
- runtime watchdog
- tiny persistence budget if due

### Every 10 seconds
- open-symbol snapshot publication target
- selected ATR refresh target
- selected forming-bar refresh target
- dossier write coalescing review

### Every 5 minutes
- universe resync
- slower market-state repair checks
- runtime state full save

### At timeframe boundaries
- M1/M5/M15/H1/H4/D1 rollovers
- completed-bar dependent metrics

## Why this matters for GPT/Codex

A weak codegen model often collapses a scanner into:
- one loop over all symbols inside `OnTimer()`
- full recalculation each cycle
- immediate file writing per symbol
- no restore model
- no budgets
- no data freshness

That is wrong for ASC.

ASC requires a kernel, due items, bounded work, and restore-first continuity.

## Recovery fallback detail

If a continuity file is unreadable, the runtime may try the matching `.last-good` file before falling back to fresh reconstruction.

This is allowed because the scanner foundation values continuity preservation over unnecessary rebuilds, provided the fallback is clearly logged and any stale areas are repaired honestly.
