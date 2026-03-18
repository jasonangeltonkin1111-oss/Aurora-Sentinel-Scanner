# HQ OPERATOR MANUAL

Version: 2026-03-18
Purpose: This is the continuity manual for the active Aurora Sentinel Scanner build. A fresh HQ chat should be able to read this file and resume control without drifting the architecture.

---

# 1. ACTIVE MISSION

The only active product mission is:
- produce `SUMMARY.txt`
- produce `SYMBOLS/<symbol>.txt`

This is a broker-aware scanner and market-selection product.
It is not an auto-trader.
It is not the old Aurora research OS.
It is not a strategy engine.

The intended trader workflow is locked:
1. open `SUMMARY.txt`
2. inspect top 5 per bucket
3. choose one symbol
4. open `SYMBOLS/<symbol>.txt`
5. inspect broker spec, OHLC history, and calculations
6. trade manually outside the EA

Everything else is subordinate to that.

---

# 2. AUTHORITY ORDER

When any ambiguity appears, authority flows in this order:
1. current active mission
2. current `blueprint/` contracts
3. current `office/` governance docs
4. archive source material for provenance only
5. future ideas

Active product meaning comes from `blueprint/`, not from archives directly.
Archives inform, but they do not govern live implementation. This matches the repo authority rule in `README.md` and `INDEX.md`. fileciteturn113file0 fileciteturn114file0

---

# 3. WHAT ASC IS

According to the current system overview, Aurora Sentinel Core is:
- a scanner
- a classifier
- a market-awareness engine
- a ranking and shortlisting engine
- a structured output publisher

It is not:
- a trade executor
- a position manager
- an account-history engine
- a monolithic one-file EA fileciteturn115file0

HQ must preserve that distinction at all times.

---

# 4. HARD PRODUCT LAWS

## 4.1 Output laws
- broker-level outputs only
- write to `Common\\Files\\AuroraSentinelCore\\`
- summary shows top 5 per bucket only
- symbol files contain exactly 3 major sections:
  - `[BROKER_SPEC]`
  - `[OHLC_HISTORY]`
  - `[CALCULATIONS]`
- writers format only and never calculate or invent fallback values fileciteturn118file0 fileciteturn119file0

## 4.2 Architecture laws
- one EA only in normal operation
- MT5 layout remains flat
- no nested MT5 module folders
- no dev/task/phase/worker wording in MT5 product code
- no hidden renaming of meanings across modules
- archives are reference-only and not active implementation fileciteturn116file0 fileciteturn117file0

## 4.3 Persistence laws
- read existing broker-level state first
- refresh only what is missing, invalid, or stale
- do not blindly rebuild everything on every reload
- multiple accounts on the same broker reuse the same broker output set
- writes must be atomic or equivalent safe replacement writes fileciteturn118file0

---

# 5. ARCHIVE LAWS

`archives/` is permanently immutable as a source layer.

Allowed:
- additive markdown navigation, mapping, and indexing files only
- provenance analysis
- blueprint translation outside archives

Forbidden:
- deleting archive files or folders
- renaming archive files or folders
- moving archive files or folders
- editing non-markdown archive files
- reformatting source files

This is already formalized in `archives/ARCHIVE_IMMUTABILITY.md` and must be treated as non-negotiable.

HQ must never assign a worker to edit archive source files.

---

# 6. BUILD GOVERNANCE MODEL

The office layer is already locked around one-active-worker execution.

## Master responsibilities
The master must:
- protect blueprint intent
- assign bounded module projects
- enforce one-active-worker execution
- keep Clerk and Debug in idle-only post-run windows fileciteturn120file0

## Worker classes
There are only two worker classes:
- build workers
- post-run workers (`Clerk`, `Debug`) fileciteturn121file0

## Execution protocol
The system runs in this sequence:
1. Master assigns one bounded build project
2. Assigned worker claims locks and runs
3. Worker stops at scope completion
4. Clerk may run manually
5. Debug may run manually
6. Return to idle before next project starts fileciteturn122file0

HQ must not violate this rhythm.

---

# 7. CURRENT PRODUCT MODULES

Current logical product modules are:
- Common
- Engine
- Market
- Conditions
- Surface
- Ranking
- Output
- Storage
- UI
- Diagnostics

These are logical ownership domains, not folder requirements. MT5 stays physically flat. fileciteturn117file0

## Current build order
Vertical slice first:
1. Common
2. Engine
3. Market
4. Conditions
5. Storage
6. Output

Only after that:
7. Surface
8. Ranking

Later:
9. Diagnostics
10. UI fileciteturn124file0

## Current active first slice
- Engine worker
- Market worker
- Conditions worker
- Storage + Output worker fileciteturn123file0 fileciteturn125file0

---

# 8. WHAT THE ARCHIVES TEACH HQ

HQ must understand the archives correctly.
The important non-Aurora archive zones are:
- `BLUEPRINT_REFERENCE/`
- `EXTRACTED_REFERENCE/`
- `LEGACY_SYSTEMS/`
- `MAPS/`

## 8.1 What older Aurora blueprints prove
The older `AURORA.txt` and `AURORA — UNIVERSAL MULTI-ASSET MARK.txt` prove that the historical system drifted into a very large layered research OS with many roles, registries, telemetry systems, journaling systems, and mode arbitration. fileciteturn126file0 fileciteturn127file0

This teaches HQ two critical things:
1. the old Aurora lineage is powerful but much broader than the current scanner mission
2. current ASC must not re-import that complexity into the first scanner milestone

HQ must therefore use the old blueprint archive only for:
- provenance
- no-drift awareness
- conceptual caution
- naming and doctrine archaeology

HQ must not use it to expand the current scanner scope.

## 8.2 What EA1 MarketCore proves
The archived EA1 MarketCore blueprint is extremely important because it shows a stable, bounded, deterministic observability design.
Key lessons from EA1:
- timer-only cadence is preferred over heavy tick-driven orchestration
- truth before completeness
- unknown stays unknown
- no fake zero values
- explicit separation of observed vs derived fields
- explicit path/state/reason channels
- bounded publish flow
- deterministic current/previous snapshot safety
- private continuity is not the public contract
- canonical handoff files matter more than internal continuity fileciteturn129file0

HQ should reuse these ideas carefully in ASC, especially:
- deterministic cadence
- truthful missing-data handling
- bounded work
- output contract discipline
- atomic write thinking

HQ must not copy EA1 wholesale because EA1 was part of a different multi-EA pipeline.

## 8.3 What extracted runtime references prove
The extracted runtime/export references show:
- stage-style export contracts mattered in prior systems
- atomic writes and temp-file replacement patterns mattered
- deterministic file output and read/write safety mattered
- clear separation between input snapshots and downstream outputs mattered fileciteturn130file0

HQ should carry forward the principle, not the entire old architecture.

---

# 9. TRUE FLOW OF THE CURRENT SCANNER

This is the actual scanner flow HQ must preserve.

## Step A — product contract first
Before code changes, the output contract must stay locked:
- broker-level output
- exact section names
- top 5 per bucket
- writer purity

## Step B — broker universe intake
The EA must discover broker symbols and determine usable identity.
This includes:
- broker symbol enumeration
- suffix/prefix tolerance
- canonical identity mapping
- asset/bucket assignment

## Step C — broker spec intake
For each accepted symbol, read broker truth such as:
- digits
- point
- tick size
- tick value
- contract size
- min lot
- max lot
- lot step
- spread
- trade mode / tradability where available

This becomes `[BROKER_SPEC]`.

## Step D — OHLC intake and validation
For each accepted symbol, read bounded recent price history.
Validate:
- enough bars exist
- ordering is sane
- data is not obviously broken

This becomes `[OHLC_HISTORY]`.

## Step E — calculations
Only after broker specs and OHLC are valid, compute scanner surface measurements.
This becomes `[CALCULATIONS]`.

## Step F — symbol dossier assembly
Only completed symbol dossiers may enter the summary engine.
The system is not ranking raw symbols.
It is ranking completed symbol dossiers.

## Step G — safe persistence and output write
Write complete dossiers safely.
Avoid half-written files.
Respect current-state-first persistence rules.

## Step H — summary aggregation
Load all valid symbol dossiers.
Group into buckets.
Rank within bucket.
Trim to top 5.
Write `SUMMARY.txt`.

## Step I — diagnostics
Record:
- universe count
- valid dossier count
- skipped symbols
- failure reasons
- write outcomes

## Step J — trader use
The trader opens summary first, then a selected symbol dossier.
That is the entire intended use loop.

---

# 10. WHAT IS STILL NOT LOCKED ENOUGH

HQ must know the remaining unresolved decisions before coding can be clean.

## 10.1 Summary bucket model
This is still the biggest unresolved blueprint choice.
HQ must lock whether `SUMMARY.txt` is grouped by:
- asset class buckets
- scanner-condition buckets
- hybrid buckets

Current recommendation for fastest path to trading:
- asset-class buckets first
- one balanced rank inside each bucket

Example:
- Forex
- Metals
- Indices
- Crypto
- Other

## 10.2 Timeframe set for OHLC intake
HQ must lock:
- one timeframe only, or
- one small fixed set

## 10.3 Minimum calculations list
HQ must lock the minimum fields that must always exist in `[CALCULATIONS]`.

## 10.4 Refresh cadence
HQ must lock:
- OnInit behavior
- OnTimer behavior
- refresh interval
- full rebuild vs bounded refresh behavior

Until these are explicit, worker instructions will remain weaker than they should be.

---

# 11. RECOMMENDED FIRST-STABLE PRODUCT SHAPE

This is the current HQ recommendation for the first usable scanner milestone.

## Summary grouping
Use asset-class buckets, not strategy-condition buckets.
Why:
- easier to understand
- easier to implement correctly
- easier to trust early
- keeps ranking single-purpose

## Symbol dossier philosophy
Each symbol file should be a complete, trustworthy scanner dossier.
No prediction.
No signal.
No trade bias.
Just measured market reality.

## Ranking philosophy
Use one balanced score per bucket driven by:
- movement usefulness
- spread cost
- volatility usefulness
- cleanliness / consistency
- freshness / validity

No strategy logic.
No buy/sell language.

## Runtime philosophy
Use bounded periodic orchestration.
Do not build a tick-reactive monster.
Carry forward the timer-discipline lesson from EA1. fileciteturn129file0

---

# 12. WHAT HQ MUST NEVER LET HAPPEN

HQ must prevent these failures:

## 12.1 Old Aurora complexity leakage
Do not let workers import:
- telemetry engines
- rulecard systems
- vault systems
- mode arbitration
- lifecycle identity systems
- SIAM surface complexity
into the current scanner milestone.

## 12.2 Archive as active implementation
Do not let workers treat archive code or archive blueprints as live product contracts.
Blueprint translation must happen first.

## 12.3 Writer corruption
Do not let Output or Storage compute analytics or repair values.
Writers format only.

## 12.4 MT5 folder pollution
Do not let workers create nested MT5 product folders.
Logical modules are not physical subfolders.

## 12.5 Scope leakage into signals
Do not let calculations turn into strategy logic.
The scanner must remain a selection and inspection machine.

---

# 13. CURRENT STATE OF THE PROJECT

As of this manual:
- root layout is locked
- office governance is locked
- Clerk and Debug are installed
- archives are hardlocked
- archive indexing exists
- current active build slice is still:
  - Engine
  - Market
  - Conditions
  - Storage + Output
- the active product objective remains the first working EA slice that writes truthful broker-level outputs fileciteturn125file0

There is no justification for expanding scope beyond that right now.

---

# 14. HQ OPERATING PROCEDURE

A fresh HQ chat should operate in this order:

1. Read `README.md`
2. Read `INDEX.md`
3. Read this HQ manual
4. Read `blueprint/SYSTEM_OVERVIEW.md`
5. Read `blueprint/ARCHITECTURE_RULES.md`
6. Read `blueprint/MODULE_MAP.md`
7. Read `blueprint/PERSISTENCE_CONTRACT.md`
8. Read `blueprint/OUTPUT_CONTRACT.md`
9. Read `office/MASTER_RULES.md`
10. Read `office/WORKER_RULES.md`
11. Read `office/MODULE_OWNERSHIP.md`
12. Read `office/BUILD_ORDER.md`
13. Read `office/EXECUTION_PROTOCOL.md`
14. Read `office/TASK_BOARD.md`
15. Use archives only if no-drift or provenance checking is needed

Then HQ should do only one of these:
- lock unresolved scanner decisions
- assign one bounded worker project
- invoke Clerk after completion
- invoke Debug after completion
- create a stable milestone tag after successful validation

HQ should never jump ahead into future phases while the first scanner milestone is unfinished.

---

# 15. NEXT REQUIRED HQ ACTIONS

Before large coding begins, HQ should lock these items explicitly in blueprint or office guidance:

1. final summary bucket model
2. final timeframe set for OHLC intake
3. final minimum calculation list
4. final refresh cadence
5. first stable validation checklist

After that, HQ can assign the first real implementation worker with zero ambiguity.

---

# 16. FINAL HQ JUDGMENT

The current system is strongest when interpreted as:
- a broker-aware scanner
- a dossier writer
- a summary generator
- a trader-support data machine

The current system becomes weakest when interpreted as:
- a rebirth of the full Aurora research OS
- a semi-auto trade engine
- a strategy extractor
- a multi-mode intelligence platform

HQ must preserve the former and block the latter until the first scanner milestone is complete.

This is the central command truth for continuation.
