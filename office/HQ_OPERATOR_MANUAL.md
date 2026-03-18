# HQ OPERATOR MANUAL — ASC MASTER CONTROL

## PURPOSE

This file is the **handoff brain** for Aurora Sentinel Scanner.

A fresh HQ chat must be able to read:
1. this file
2. `README.md`
3. `INDEX.md`

and then recover the system correctly without the user re-explaining:
- what ASC is
- what ASC is not
- the real layer model
- the real worker model
- module ownership boundaries
- first milestone scope
- later-slice boundaries
- post-run review law

HQ is responsible for preserving system truth, assigning bounded work, and blocking scope drift.

---

## WHAT ASC IS

Aurora Sentinel Scanner (ASC) is:
- a scanner
- a classification-aware market intelligence engine
- a ranking + shortlist system
- an output publisher

ASC is built to:
- discover the broker universe
- classify symbols truthfully
- read broker conditions and market state
- rank symbols inside their `PrimaryBucket`
- publish broker-level summary and symbol intelligence outputs

ASC produces only trader-facing broker outputs such as:
- `<Broker>.Summary.txt`
- `<Broker>.Symbols/<Symbol>.txt`

---

## WHAT ASC IS NOT

ASC is not:
- a trading EA
- a signal generator
- a strategy engine
- an execution engine
- the old Aurora system
- a disguised research OS rebuild

If a proposed task drifts into trading, execution, strategy, or archive-system reconstruction, HQ must reject it.

---

## ARCHITECTURAL TRUTHS HQ MUST PRESERVE

### 1. Product identity
- ASC is a scanner-first market intelligence product.
- It is classification-aware.
- It is shortlist-oriented.
- It publishes truthful broker-level outputs.

### 2. Layer flow
The active runtime order is locked:
1. **Layer 1 = Market Truth**
2. **Layer 1.2 = Universe Snapshot**
3. **Layer 2 = Surface Scan**
4. **Activation Gate**
5. **Layer 3 = Deep persistent dossier**
6. **Layer 4 = Future expansion only**

No later layer may be assigned as if earlier-layer truth already exists.

### 3. Classification law
- Classification is upstream truth.
- Market owns classification translation and `PrimaryBucket` truth.
- Output, summary, ranking display, and storage must consume that truth.
- Downstream systems must not invent replacement bucket systems.

### 4. Summary law
- Summary grouping uses `PrimaryBucket`.
- Ranking and activation also use `PrimaryBucket`.
- “Asset-class buckets only” is not the active system truth and must not be reintroduced.

### 5. Persistence law
- restore first
- never wipe
- gap-fill only
- atomic writes for active rolling dossier persistence
- only ACTIVE symbols may receive rolling dossier continuation

### 6. Writer law
- writers never compute
- writers format and persist only
- missing truth stays explicit
- no fake values

### 7. Language boundary law
- office docs may use worker / task / stage / review wording
- product-facing MT5 code, runtime labels, and output artifacts must stay domain-based
- dev workflow language must not leak into product surfaces

### 8. Post-run law
- Clerk and Debug are post-run workers only
- neither Clerk nor Debug builds product features
- both run only when no build worker is active

---

## SYMBOL LIFECYCLE HQ MUST REMEMBER

The active symbol lifecycle is:
- DISCOVERED
- DEFERRED
- SNAPSHOTTED
- SURFACE_ELIGIBLE
- INACTIVE
- ACTIVE
- SUSPENDED

Interpretation:
- Layer 1 decides scan eligibility truth.
- Layer 1.2 captures universe state.
- Layer 2 gathers shortlist intelligence.
- Activation Gate decides ACTIVE vs INACTIVE.
- Layer 3 is reserved for ACTIVE symbols only.
- Integrity failures may force SUSPENDED status.

---

## THE LOCKED 7-ROLE WORKER MODEL

HQ must preserve the real control-layer worker system.
Do not expand it into an oversized staffing model unless the repository truth changes explicitly.

### Role 1. HQ
Owns:
- system truth recovery
- assignment sequencing
- scope enforcement
- contradiction resolution
- stage approval

### Role 2. Engine Worker
Owns:
- runtime engine domain
- orchestration order
- scheduling / cadence
- guarded call sequencing
- startup / timer / idle control flow

### Role 3. Market Worker
Owns:
- broker symbol discovery
- canonical identity
- archive-classification translation
- `PrimaryBucket` truth
- session truth inputs and market identity truth
- universe snapshot identity fields

### Role 4. Conditions Worker
Owns:
- broker conditions intake
- tradability / spread / spec truth
- conditions-side validation needed by ranking eligibility
- truthful condition fields consumed downstream

### Role 5. Storage + Output Worker
Owns:
- storage paths and broker naming
- restore/read/merge/persist behavior
- atomic writes
- summary and symbol output formatting
- writer-only publication logic

This worker does **not** own bucket computation or ranking logic.

### Role 6. Clerk
Owns post-run checks for:
- file placement
- naming compliance
- repo hygiene
- handoff completeness
- boundary adherence

### Role 7. Debug
Owns post-run checks for:
- logic integrity
- truth handling
- fail-fast behavior
- activation/persistence safety
- contradiction detection after implementation work

---

## MODULE OWNERSHIP MODEL HQ MUST USE

The worker model is smaller than the full module list.
HQ must map module domains into the real worker system without inventing extra workers.

### First-slice implementation domains
- **Engine domain** -> Engine Worker
- **Market domain** -> Market Worker
- **Conditions domain** -> Conditions Worker
- **Storage domain** -> Storage + Output Worker
- **Output domain** -> Storage + Output Worker

### Cross-domain shared support
- **Common domain** -> shared contract surface coordinated by HQ; no worker may redefine shared meanings unilaterally

### Later-slice domains
These domains are real, but they are **not separate workers in the locked 7-role model**:
- **Surface domain** -> later slice, assigned under HQ to the most relevant build worker packet without changing the worker roster
- **Ranking domain** -> later slice, assigned under HQ to the most relevant build worker packet without changing the worker roster
- **Diagnostics domain** -> later slice product domain; distinct from the Debug post-run worker
- **UI domain** -> later slice product domain

HQ must keep the distinction clear:
- product modules may outnumber workers
- module ownership does not imply a new worker role

---

## BUILD ORDER AND MILESTONE CONTROL

### First milestone goal
Reach the first working scanner slice that can:
- start cleanly
- discover broker symbols
- read broker conditions
- restore broker state first
- write truthful broker-level outputs

### First milestone build sequence
1. Layer 1 / Market Truth
2. Layer 1.2 / Universe Snapshot
3. Layer 2 / Surface Scan foundations needed for the first usable shortlist
4. Activation Gate
5. Layer 3 / ACTIVE-only rolling dossier persistence

### Layer 4 status
- future only
- blocked until Layers 1 to 3 and Activation Gate are verified stable

### Stage gate law
No stage progresses until all of the following are complete:
1. assigned build worker completes bounded scope
2. Clerk runs post-run review
3. Debug runs post-run review
4. HQ approves progression

---

## WHAT HQ MUST CHECK BEFORE ASSIGNING WORK

Before issuing a task packet, HQ must verify:
- the layer being assigned is actually unblocked
- the target domain owner is clear
- the required blueprint contracts are named explicitly
- relevant archive sources are named explicitly when translation is needed
- out-of-scope items are written down
- later-slice domains are not leaking into first-slice work

HQ must reject assignments that:
- mix multiple major domains without necessity
- silently rewrite blueprint truth
- move ranking/output bucket logic away from `PrimaryBucket`
- give Layer 3 rights to non-ACTIVE symbols
- treat Clerk or Debug as implementation workers

---

## HQ RECOVERY ORDER IN A NEW CHAT

Read in this order:
1. `office/HQ_OPERATOR_MANUAL.md`
2. `README.md`
3. `INDEX.md`
4. mandatory office files for current control state
5. relevant blueprint files for current assignment
6. archive references only where blueprint or office files require truth confirmation

Mandatory control-state follow-up after this file:
- `office/MODULE_OWNERSHIP.md`
- `office/TASK_BOARD.md`
- `office/WORKER_RULES.md`
- `office/ARCHIVE_REFERENCE_MAP.md`
- `office/WORKER_EXECUTION_PROTOCOL.md`
- `office/LAYERED_BUILD_ORDER.md`
- `office/TEST_AND_VERIFICATION_PLAN.md`

HQ should then read the blueprint contracts most relevant to the next assignment, especially:
- `blueprint/SYSTEM_OVERVIEW.md`
- `blueprint/MODULE_MAP.md`
- `blueprint/MARKET_IDENTITY_MAP.md`
- `blueprint/SUMMARY_SCHEMA.md`
- `blueprint/RUNTIME_RULES.md`
- `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`
- `blueprint/SYMBOL_LIFECYCLE_AND_ACTIVATION.md`
- `blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`
- `blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md`
- `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`
- `blueprint/RANKING_AND_PROMOTION_CONTRACT.md`
- `blueprint/PRODUCT_NAMING_AND_OUTPUT_LANGUAGE_RULES.md`

---

## HQ APPROVAL STANDARD

HQ should consider the foundation ready for implementation only when:
- the worker model is clear
- module ownership is clear
- first milestone scope is clear
- later-slice modules are identified without leaking into first slice
- summary/ranking/activation all align on `PrimaryBucket`
- persistence law is preserved
- product naming boundary is preserved
- no major control-layer contradiction remains between office and blueprint files

---

## FINAL RULE

HQ is not here to be clever.
HQ is here to:
- preserve truth
- enforce structure
- assign bounded work
- block drift
- keep ASC implementation-ready without repeated user re-explanation
