# ASC Master Canon

## Mission

Aurora Sentinel Scanner (ASC) is a **timer-driven, restore-first, broker-universe market intelligence EA** for MetaTrader 5.

Its job is to continuously answer, without pretending certainty where none exists:

1. What symbols exist?
2. What is the current truthful state of each symbol?
3. Which symbols are open enough and healthy enough to remain in active competition?
4. Which symbols deserve bounded deeper computation budget?
5. What state is fresh, stale, pending, degraded, frozen, or unknown?
6. What trader-facing artifacts can be published safely from already prepared truth?

## Core identity

ASC is:

- one EA
- timer-driven
- broker/server scoped
- restore-first
- symbol-file-first
- summary-last
- cheap broad first, expensive narrow second
- ordered-capability architecture
- publication-safe
- human-readable on the outside
- mechanically explicit on the inside

ASC is not:

- a trade executor
- a strategy engine
- an account-history engine
- a hidden multi-agent workflow
- a chart-driven tick-chaos design
- a full-universe deep analytics engine on every cycle
- a place to leak internal enum names into the trader surface

## Final architectural reading

The archive contains multiple architectural eras. The final working interpretation is:

- **Newest `blueprint/` is the active constitutional basis**
- **`mt5_runtime_flat/` is the current implementation seed**
- **`Asc Archive 2/ASC Blueprint` provides the deepest runtime doctrine**
- **older `Asc Archive` provides contracts, guardrails, and schema ancestry**
- **legacy systems (AFS, EA1, ISSX) provide reusable patterns but not authority**

## Non-negotiable laws

### 1. Restore-first law
On startup, ASC restores prior useful state before rebuilding anything expensive.

### 2. Whole-universe law
The scanner preserves the known symbol universe even when only a subset receives deeper work.

### 3. Truth-before-ranking law
A symbol must have explicit market/snapshot truth before it can compete honestly.

### 4. Cheap-broad / expensive-narrow law
Whole universe gets light truth; only promoted symbols get deep rolling enrichment.

### 5. Symbol-file-first law
Each symbol gets a canonical evolving file before any final summary is trusted.

### 6. Summary-is-downstream law
The summary is publication, not storage and not system truth.

### 7. Human-language law
Trader surfaces use readable names like `Daily Change` and `Market Status`, not internal field keys.

### 8. Ownership law
Every layer and module owns only its own data and behavior.

### 9. Fail-honestly law
Unknown, stale, incomplete, unsupported, invalid, or unsafe are real states. Do not flatten them into fake valid values.

### 10. Server-only storage identity law
Storage identity is the cleaned broker server name, not the account number and not the EA name alone.

## ASC runtime stages

### Boot
Create shell state, verify folders, load config, start orchestration.

### Restore
Load runtime continuity, scheduler continuity, and symbol continuity.

### Warmup
Fill missing minimum truths until every known symbol has explicit state rather than silent neglect.

### Steady
Refresh only what is due.

### Degraded
Protect continuity and minimum truth while yielding deep/cosmetic work first.

## Canonical domain split

### Runtime
Heartbeat, due items, budgets, fairness, degradation, restore orchestration.

### Discovery
Raw retrieval and storage of symbol specs, market-watch data, sessions, feed status, and time-domain truth.

### Ordered capabilities
The processing pipeline that transforms retrieved truth into eligibility, ranking, and deeper enrichment while preserving the explicit sequence:
1. Market State Detection
2. Open Symbol Snapshot
3. Candidate Filtering
4. Shortlist Selection
5. Deep Selective Analysis

### Publication
Dossiers, summary, runtime state, scheduler state, and safe writes.

### Presentation
HUD/menu/readable mapping of prepared state only.

## Evolution model

The earliest working foundation should do only:

- timer runtime
- server paths
- restore-safe continuity
- per-symbol minimum dossier creation
- Market State Detection truth
- scheduler persistence
- runtime persistence
- summary scaffold
- logging
- atomic writes

Later stages may add:

- snapshot modules
- filtering
- ranking
- top-list selection
- selective deep analysis
- richer summary
- richer HUD
