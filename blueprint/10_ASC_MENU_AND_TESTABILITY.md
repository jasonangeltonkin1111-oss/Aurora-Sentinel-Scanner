# ASC Menu and Testability Plan

## Purpose

This file defines the foundation-stage MT5 properties menu shape and the staged verification order for the active ASC runtime.

It exists so the EA menu, the flat runtime, and the future semantic MT5 layout can grow without later retrofits or renaming churn.

## Menu law

The EA properties menu must be:
- grouped by ownership
- human-readable
- stable enough for later layers
- explicit about what is active now versus reserved later
- free of phase/dev jargon

## Active menu groups now

### Runtime
Owns:
- heartbeat interval
- universe sync interval
- bounded symbol budget

### Scheduler
Owns:
- fairness budget
- due pacing
- bounded work progression

### Market Status Detection
Owns:
- fresh tick threshold
- open-market recheck cadence
- uncertain-state burst limits
- fast and slow uncertain rechecks
- closed-market pacing windows
- unknown-state pacing

### Recovery & Persistence
Owns:
- runtime save cadence
- scheduler save cadence
- summary save cadence
- dossier repair on boot
- last-good preservation policy

### Logging & Attention
Owns:
- verbosity
- scheduler decision logging
- recovery logging
- dossier repair logging
- attention visibility thresholds

### Dossiers & Publication
Owns:
- due-based dossier writing toggle
- inclusion of pending layer placeholders
- publication metadata stability
- snapshot adapter invalidation policy later

### Explorer HUD
Owns:
- explorer visibility
- explorer refresh cadence
- explorer density
- breadcrumb visibility
- safe scroll step size
- focus downgrade timeout later

## Reserved menu groups for later capabilities

These groups should already exist in menu design even when their logic is pending.

### Open Symbol Snapshot (Reserved)
Reserved for Open Symbol Snapshot behavior and early snapshot/timeframe scaffolding such as:
- Reserved: Snapshot M1 Bars
- Reserved: Snapshot M5 Bars
- Reserved: Snapshot M15 Bars
- Reserved: Snapshot Focus Refresh Seconds

### Deep Selective Analysis (Reserved)
Reserved for Deep Selective Analysis controls and deeper ATR/history cadence scaffolding such as:
- Reserved: ATR Refresh Seconds
- Reserved: Deep H1 Bars
- Reserved: Deep H4 Bars
- Reserved: Deep D1 Bars
- Reserved: Deep Focus Refresh Ceiling Seconds

### Future Selection / Ranking (Pending)
Reserved for Candidate Filtering and Shortlist Selection controls such as later selected-set limits.

## Menu naming rules

Use labels like:
- `Heartbeat Interval Seconds`
- `Runtime Save Interval Seconds`
- `Reserved: M15 Bars`

Do not use labels like:
- `Phase 1 Budget`
- `Worker Burst`
- `Packet Count`
- `Temp Layer Settings`

## Reserved-control honesty rule

If a menu group is not active yet:
- keep the group in the menu
- mark the control as Reserved or Pending
- keep naming final and stable
- do not pretend the feature is already implemented

## Flat runtime ownership mapping

In the active flat runtime surface, the menu should map approximately as:
- `AuroraSentinel_Foundation.mq5` -> input groups and input-to-settings wiring
- `ASC_Common.mqh` -> settings structs and shared types
- `ASC_MarketState.mqh` -> scheduler pacing consumption of market-state settings
- `ASC_Persistence.mqh` -> continuity metadata and save cadence consumers
- `ASC_Dossiers.mqh` -> dossier placeholder policy
- `ASC_Logging.mqh` -> verbosity and domain logging behavior

## Testability law

Future implementation must be able to prove the refresh and explorer boundaries, not merely claim them.
The minimum observable proofs are:
- focused symbol or stat views do not trigger full-universe recomputation
- focus exit lowers work back to the non-focused cadence
- unchanged fields and sections do not rewrite unnecessarily
- expensive fields do not churn on every redraw
- HUD buttons do not perform hidden heavy compute
- adapter snapshots are reused until invalidated by owned state change or stale expiry
- downgrade events preserve last-good truth instead of blanking valid surfaces casually

## Staged build and verification order

### Stage 1 — Paths and logger
Pass means:
- server path resolves
- root folders exist
- logger writes without spam

### Stage 2 — Runtime shell and menu wiring
Pass means:
- grouped inputs load into one runtime settings surface
- timer uses configured heartbeat interval
- settings summary logs once on init

### Stage 3 — Continuity restore and repair
Pass means:
- runtime continuity loads when present
- `.last-good` fallback is attempted when needed
- missing dossiers are queued for repair honestly

### Stage 4 — Market State Detection heartbeat
Pass means:
- open / closed / uncertain / unknown states advance under bounded work
- fairness cursor prevents head-of-list starvation
- degraded mode is logged when the budget cap binds
- opening the explorer does not change the whole-universe heartbeat cost

### Stage 5 — Canonical publication
Pass means:
- dossiers write atomically
- runtime, scheduler, and summary continuity files carry schema and generated-at metadata
- future-capability sections remain Reserved or Pending rather than missing
- unchanged publication sections are not rewritten without cause

### Stage 6 — Explorer boundary verification
Pass means:
- button clicks route through one action surface
- explorer redraw reuses prepared snapshots unless they are invalidated
- focus entry elevates only the authorized focused surface
- focus exit or focus change removes elevated work promptly
- no explorer action triggers history pulls, bucket rebuilds, or heavy recomputation unless a later active capability explicitly owns and schedules that work

## Foundation test matrix summary

The minimum foundation pass should verify:
1. first run with no files
2. restart with intact files
3. restart with partial continuity and `.last-good` fallback
4. missing dossier repair
5. long market-closed cadence behavior
6. bounded-work pressure on a large universe
7. stale tick versus trade-session ambiguity
8. folder/path failure visibility
9. atomic write failure visibility
10. focus entry/exit does not change unrelated symbol cadence
11. explorer redraw does not churn expensive fields
12. snapshot reuse until invalidation

## Final rule

The menu and staged test order are part of the foundation design, not optional polish.
A runtime that cannot be configured cleanly or verified in sequence is not hardened enough for future layer expansion.

## Logging verification signals

A healthy Market State Detection test run should make it easy to find:
- one init settings summary
- one recovery outcome line
- dossier repair queue lines when files are missing
- scheduler decision lines only when debug logging is enabled
- bounded-work warnings only when the heartbeat cap binds
- save and restore events for runtime, scheduler, summary, and dossiers
- explicit focus elevation / downgrade signals once focus-scoped refresh exists
- snapshot reuse or invalidation traces when explorer boundary diagnostics are enabled

## Version bump discipline

Every meaningful edit to the wrapper, menu, or explorer contract must bump version.
Use a patch bump for non-breaking fixes and polish, a minor bump for meaningful subsystem expansion, and a major bump only for architectural revision.
