# Working Stage Ledger

Compact regression ledger for the current ASC foundation. This file is operational by design: each item states what must pass now, how it fails, who owns it, and how later capability work may extend it without silently breaking the foundation.

## Ordered capability stack

1. Market State Detection — **working**
2. Open Symbol Snapshot — **reserved**
3. Candidate Filtering — **reserved**
4. Shortlist Selection — **reserved**
5. Deep Selective Analysis — **reserved**

The sequence above remains active canon for debugging and future implementation order. Only Market State Detection currently owns live behavior.

## Working items

### Server path identity
- **Status:** working
- **Pass:** storage roots resolve under `AuroraSentinel/<Clean Server Name>/` with stable `Symbol Universe` and `Dev` subfolders.
- **Break symptoms:** dossier/runtime/scheduler/summary writes land under the wrong server path, cross-server contamination appears, or files move when account identity changes.
- **Owners:** `mt5_runtime_flat/ASC_ServerPaths.mqh`, `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`
- **Regression warning:** do not reintroduce account-scoped identity or alternate folder roots.
- **Future extension:** later capabilities must inherit the same cleaned server scope rather than creating their own storage root.

### Bootstrap / init
- **Status:** working
- **Pass:** init loads settings, resolves paths, restores continuity, syncs universe, and arms the 1-second heartbeat without wiping recoverable state.
- **Break symptoms:** boot loops, missing timer activation, restore skipped, or first-run rebuild wipes continuity.
- **Owners:** `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`, `mt5_runtime_flat/ASC_Logging.mqh`, `mt5_runtime_flat/ASC_Persistence.mqh`
- **Regression warning:** do not move heavy capability work into init or bypass restore-first behavior.
- **Future extension:** later capabilities should register due work after bootstrap, not replace bootstrap ownership.

### Universe sync
- **Status:** working
- **Pass:** `ASC_SyncUniverse()` refreshes the broker symbol list, preserves per-symbol state when possible, and queues missing dossier repair honestly.
- **Break symptoms:** symbol count drift, known symbols disappear, new symbols never appear, or missing dossiers stay invisible.
- **Owners:** `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`
- **Regression warning:** do not narrow the universe early for shortlist-style behavior.
- **Future extension:** Open Symbol Snapshot and later capabilities may consume the synced universe but must not own discovery membership.

### Heartbeat dispatch
- **Status:** working
- **Pass:** due symbols advance under bounded work, skipped re-entry is logged honestly, and the fairness cursor keeps moving even when dossier promotion fails.
- **Break symptoms:** repeated head-of-list starvation, non-advancing backlog, recursive heartbeat overlap, or failure paths that pin the cursor.
- **Owners:** `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`, `mt5_runtime_flat/ASC_MarketState.mqh`
- **Regression warning:** do not let later capabilities consume the full heartbeat budget or hide failed progress accounting.
- **Future extension:** reserved capability dispatch hooks already exist and must stay bounded behind the current market-state pass.

### Market-state classification
- **Status:** working
- **Pass:** market status resolves to honest `Open`, `Closed`, `Uncertain`, or `Unknown` outcomes using tick freshness, session availability, and degraded evidence rules.
- **Break symptoms:** closed symbols polled forever at open cadence, stale feed marked as open, session-only evidence treated as certainty, or unknown state flattened into false closure.
- **Owners:** `mt5_runtime_flat/ASC_MarketState.mqh`, `mt5_runtime_flat/ASC_Common.mqh`
- **Regression warning:** do not let snapshot/filter/selection logic bleed into this capability.
- **Future extension:** Open Symbol Snapshot may consume market-state outputs but must not rewrite market-status truth ownership.

### Due scheduling
- **Status:** working
- **Pass:** next-check timing adapts to open, uncertain, near-open, soon-open, idle-closed, and unknown cases without hammering symbols needlessly.
- **Break symptoms:** every symbol falls back to one cadence, near-open acceleration disappears, or closed symbols spin every heartbeat.
- **Owners:** `mt5_runtime_flat/ASC_MarketState.mqh`, `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`
- **Regression warning:** do not replace capability-owned scheduling with blanket timer rewrites.
- **Future extension:** later capabilities may add their own due times, but Market State Detection must keep owning `next_check_at`.

### Dossier atomic promotion
- **Status:** working
- **Pass:** final `.txt` dossier exists and promotion completes without orphan `.tmp` accumulation.
- **Break symptoms:** orphan `.tmp` files, repeated repair queueing, missing final dossier, or silent validation mismatch.
- **Owners:** `mt5_runtime_flat/ASC_FileIO.mqh`, `mt5_runtime_flat/ASC_Dossiers.mqh`
- **Regression warning:** do not mix text/binary semantics or bypass the promote flow.
- **Future extension:** later capability sections must append through the same atomic writer instead of writing directly.

### Runtime continuity save / load
- **Status:** working
- **Pass:** runtime state writes atomically, reloads on restart, and may fall back to `.last-good` with honest logging when the primary file is invalid.
- **Break symptoms:** mode/heartbeat timestamps reset unexpectedly, false save success timestamps, or silent fallback without a log trail.
- **Owners:** `mt5_runtime_flat/ASC_Persistence.mqh`, `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`
- **Regression warning:** do not mark save timestamps successful when promotion fails.
- **Future extension:** add new runtime fields only if restore logic remains backward-safe and fallback-safe.

### Scheduler continuity save / load
- **Status:** working
- **Pass:** per-symbol scheduler fields persist and restore with the fairness cursor still usable after restart.
- **Break symptoms:** symbols lose next due times, fairness restarts from the head every boot, or uncertain burst tracking disappears.
- **Owners:** `mt5_runtime_flat/ASC_Persistence.mqh`, `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`
- **Regression warning:** do not widen scheduler files with fake future-capability outputs that are not yet restored.
- **Future extension:** reserved capabilities may add their own scheduler metadata later, but current per-symbol market-state fields stay authoritative.

### Summary scaffold save
- **Status:** working
- **Pass:** summary scaffold writes as a downstream runtime artifact without pretending shortlist or deep-analysis output exists.
- **Break symptoms:** summary missing despite dirty save attempts, ranked content appears without owning capability, or summary becomes the only persisted truth.
- **Owners:** `mt5_runtime_flat/ASC_Persistence.mqh`, `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`
- **Regression warning:** do not let the summary outrun dossiers or carry fake shortlist claims.
- **Future extension:** Shortlist Selection may enrich the summary later, but dossier-first publication remains the gate.

### Degraded / backlog observability
- **Status:** working
- **Pass:** degraded mode, skipped re-entry, repair queueing, failed promotions, and bounded-heartbeat behavior are visible through logs and summary/runtime state.
- **Break symptoms:** backlog pressure is invisible, degraded mode never surfaces, or repair/promotion failures leave no operator clue.
- **Owners:** `mt5_runtime_flat/ASC_Logging.mqh`, `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`, `mt5_runtime_flat/ASC_Persistence.mqh`
- **Regression warning:** do not reduce failure logging to cosmetic noise or hide bounded-work skips.
- **Future extension:** later capabilities may add richer backlog metrics, but the current honesty signals must stay intact.

### Reserved future capability scaffolding
- **Status:** reserved
- **Pass:** Open Symbol Snapshot, Candidate Filtering, Shortlist Selection, and Deep Selective Analysis remain explicitly named, clearly reserved, and visibly insertable in runtime inputs, placeholder hooks, dossier progression, and blueprint order.
- **Break symptoms:** placeholder hooks disappear, reserved capabilities are renamed ambiguously, or docs imply later behavior is already live.
- **Owners:** `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`, `mt5_runtime_flat/ASC_Dossiers.mqh`, `blueprint/04_ASC_FIVE_LAYER_MODEL.md`, `blueprint/10_ASC_MENU_AND_TESTABILITY.md`
- **Regression warning:** do not over-clean placeholders until future insertion points become unclear.
- **Future extension:** each later capability should promote from Reserved to Working only when it has owned runtime behavior, owned persistence/publication, and ledger coverage added here.

### Explorer HUD shell
- **Status:** working
- **Pass:** the explorer owns only its prefixed chart objects, consumes a runtime-prepared bucket snapshot instead of rebuilding bucket truth in render/click handlers, keeps Open Only tied strictly to prepared live `Open` symbols, preserves placeholder honesty under All Symbols, and falls back to a compact surface instead of going blank when a terminal viewport cannot fit the full HUD.
- **Break symptoms:** chart clutter overlaps unrelated objects, render or click paths rebuild full bucket classification ad hoc, page buttons overrun the viewport, Open Only shows buckets with no prepared live open symbols, or small/odd chart sizes produce silent blank renders.
- **Owners:** `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`, `mt5_runtime_flat/ASC_Common.mqh`, `mt5_runtime_flat/ASC_ExplorerHUD.mqh`, `mt5_runtime_flat/ASC_ExplorerBuckets.mqh`
- **Regression warning:** do not move scanner computation into button handlers, do not let HUD render begin by wiping all owned objects, do not widen normalization beyond evidenced patterns, and do not let placeholder references read as confirmed broker truth.
- **Future extension:** bucket detail, stat detail, identity cards, operator filters, and later Aurora-facing reserved panels should plug into the existing controller/layout/action split rather than replacing it.
