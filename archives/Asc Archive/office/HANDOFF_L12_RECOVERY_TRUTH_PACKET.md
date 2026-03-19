# HANDOFF L1.2 RECOVERY TRUTH PACKET

## Status
Active bounded office note.

This packet is the HQ-controlled Layer 1.2 recovery baseline.
It reconciles the live Layer 1 law, Layer 1.2 law, trader-facing output law, and continuity/logging expectations so the next bounded task can start from one controlled prep input.

---

## Layer 1 Active Laws
From `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`, Layer 1 remains the market-truth and symbol-truth gate that decides whether a broker symbol is eligible to move forward now.

### Layer 1 purpose
- determine whether a specific broker symbol is eligible to scan now
- decide whether the symbol is open, deferred, or uncertain
- produce the next session-aware recheck boundary when the symbol is not eligible

### Required Layer 1 truth inputs
- broker session schedule
- symbol session quote windows
- symbol session trade windows
- symbol trade mode / enabled state
- symbol-specific quote/tick evidence
- symbol-specific market state

### Required Layer 1 outputs
Per symbol, Layer 1 must produce at minimum:
- `MarketOpenNow`
- `NextMarketOpenTime` or `NextRecheckTime`
- `SessionTruthStatus`
- `Layer1Eligible`
- explicit ineligibility reason when the symbol cannot advance

### Required Layer 1 session-truth states
Layer 1 must preserve these blueprint-facing distinctions:
- `OPEN_TRADABLE`
- `CLOSED_SESSION`
- `QUOTE_ONLY`
- `TRADE_DISABLED`
- `NO_QUOTE`
- `STALE_FEED`
- `UNKNOWN`

### Layer 1 operating laws
- if the market is closed, do not run Layer 2 or Layer 3 for that symbol
- closed symbols must be rescheduled rather than blindly rescanned
- truth is broker-symbol specific
- quote-session truth and trade-session truth must not be collapsed into one guessed state
- no generic asset-class assumptions are allowed
- if truth is uncertain, preserve uncertainty explicitly and do not guess
- Layer 1 decides eligibility truth only; it does not rank, score, or publish shortlist authority
- unresolved classification may remain explicit, but it must not by itself falsify open-market eligibility

### Layer 1 recheck law
Layer 1 recheck behavior must stay broker-symbol specific:
- `CLOSED_SESSION` -> recheck by next known open boundary when available, otherwise bounded delayed retry
- `QUOTE_ONLY` -> bounded retry because session truth is incomplete
- `TRADE_DISABLED` -> bounded slower retry and no default tradable assumption
- `NO_QUOTE` -> bounded retry and no open-market inference from classification or asset family
- `STALE_FEED` -> bounded freshness retry and no silent stale-as-live treatment
- `UNKNOWN` -> bounded retry with uncertainty preserved

---

## Layer 1.2 Active Laws
From `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`, Layer 1.2 is the startup broker-universe snapshot.
It captures broad broker truth for all discoverable symbols and must not become a hidden dossier system.

### Layer 1.2 purpose and scope
- capture a broad broker-truth inventory at EA startup
- preserve universe membership, broker identity/spec truth, classification truth if available, and session metadata
- apply to all discoverable broker symbols regardless of promotion state

### Required minimum record shape
Every snapshot record must preserve, when truth is available:
- raw broker symbol identity
- normalized/canonical symbol identity if Market resolved it
- description/path/exchange metadata if available
- broker-provided sector/industry/class metadata if available
- classification fields if resolved
- contract/spec fields needed for downstream conditions truth
- margin/calc/trade/filling/order mode fields where readable
- volume min/max/step/limit fields where readable
- session metadata or explicit session-availability markers
- record snapshot timestamp
- explicit unknown/missing markers for unreadable fields

### Layer 1.2 interpretation laws
- preserve broker-provided readable truth as-is
- if the broker does not provide or expose a field, mark it explicit missing/unknown
- do not invent normalized replacements for missing broker truth
- do not drop a symbol just because some spec/session fields are unavailable
- snapshot presence does not imply activation, promotion, or dossier rights

### Forbidden Layer 1.2 content
The universe snapshot must not carry:
- Layer 2 ranking calculations
- promotion scores
- deep history persistence
- rolling dossier windows
- activation-only intelligence fields
- Layer 3 continuation metadata
- shortlist-only file routing decisions
- hidden carry-forward of deep dossier ownership state

### Snapshot write law
Universe snapshot writes may be simpler than active dossier atomic writes, but they must still:
- preserve truthful structure
- preserve prior valid structure unless replacement is verified
- avoid destructive reset during routine refresh
- keep unreadable fields explicit instead of silently dropping them
- avoid rewriting the snapshot as if missing became valid by assumption
- avoid letting a bounded or partial refresh overwrite a previously larger valid universe snapshot unless the replacement pass is explicitly known to be complete and verified

### Layer 1.2 relationship to activation
A symbol may exist in the universe snapshot and still remain:
- `DEFERRED`
- `INACTIVE`
- never promoted

---

## Trader-Facing Output Law
From `blueprint/OUTPUT_CONTRACT.md`, ASC exposes only two canonical trader-facing outputs under `Common\Files\AuroraSentinelCore\`.
These outputs are runtime artifacts, not trader-facing repository artifacts.

### Canonical outputs
1. `<Broker>.Summary.txt`
   - purpose: show which symbols deserve attention now
   - rules: top 5 symbols per bucket only, compact but decision-useful, no raw OHLC dump, no writer-side calculations, no fake zero placeholders
2. `<Broker>.Symbols/<Symbol>.txt`
   - purpose: show deeper intelligence for one shortlisted symbol
   - rules: exactly 3 major sections only:
     - `[BROKER_SPEC]`
     - `[OHLC_HISTORY]`
     - `[CALCULATIONS]`
   - section names must not drift or be casually renamed

### Writer purity law
Output formats and renders already-prepared snapshot data.
It does not fetch, calculate, rank, normalize, or repair values.

---

## Continuity and Logging Expectations
From `office/HQ_STATE.md` and `office/TASK_BOARD.md`, the next bounded task must preserve the normalized post-Wave-1 control truth and must not reopen already-resolved blocker loops.

### Continuity baseline
- blueprint hardening, merged Wave 1 fix work, post-fix Clerk review, and post-fix Debug review are the live baseline
- HQ is active and owns orchestration, contradiction resolution, and next-packet control
- the system is in bounded advancement preparation, not later-layer completion
- later summary, ranking, dossier, Layer 3, and Layer 4 work must remain explicit rather than implied

### Required continuity behavior
- use the normalized office layer as the active HQ recovery baseline
- preserve truthful continuity across `HQ_STATE.md`, `HQ_DECISION_LOG.md`, `TASK_BOARD.md`, and worker handoffs
- do not write the repo state as if Wave 1 is still in blocker failure
- do not reopen resolved fix packets without new evidence
- do not bypass documented HQ continuity
- maintain the locked stage sequence: Layer 1 -> Layer 1.2 -> Layer 2 -> Activation Gate -> Layer 3

### Current HQ-controlled objective
- move from completed Wave 1 hardening into the next bounded HQ-controlled stage
- use this packet as the prep input alongside the canonical lineage and recovery planning documents
- keep recognition of later-slice domains separate from active authorization

### Current gate truths that must remain preserved
1. the merged Wave 1 fix wave is complete
2. the control layer reflects the merged Wave 1 fix state truthfully
3. the latest Clerk verdict is `PASS WITH CLERK CORRECTIONS`
4. the latest Debug verdict is `PASS WITH NON-BLOCKING FIXES`
5. no new feature or later-slice expansion should be implied merely because Wave 1 is healthier

---

## NEXT TASK INPUTS
The next task must read these exact files:
- `office/HANDOFF_L12_RECOVERY_TRUTH_PACKET.md`
- `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`
- `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`
- `blueprint/OUTPUT_CONTRACT.md`
- `office/HQ_STATE.md`
- `office/TASK_BOARD.md`
- `office/HQ_DECISION_LOG.md`
- `office/MASTER_SYSTEM_ARCHIVE_MAP.md`
- `office/LEGACY_RECOVERY_EXECUTION_PLAN.md`
