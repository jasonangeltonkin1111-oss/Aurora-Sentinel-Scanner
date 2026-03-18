# THREE LAYER SCAN ARCHITECTURE

## Status
Active blueprint law.

This file locks the real ASC scan model.
It replaces any simplified interpretation that collapses session truth, surface scan, and deep computation into one layer.

---

## Core Principle
ASC is a staged intelligence engine.
It does not treat every symbol equally.
It does not recompute blindly.
It does not wipe state.
It progresses through layers only when the prior layer truth is valid.

---

## LAYER 1 — MARKET TRUTH / SYMBOL TRUTH GATE

### Purpose
Determine whether a broker symbol is eligible to be scanned now.

### Questions this layer answers
- Does this specific broker symbol trade right now?
- If not, when does it next open?
- When should this symbol be checked again?
- Is this symbol currently worth scanning, or should it be deferred?

### Required truth sources
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
- explicit reason if the symbol is not currently eligible

### Session truth sub-states
Layer 1 truth must distinguish at least these states:
- `OPEN_TRADABLE`
- `CLOSED_SESSION`
- `QUOTE_ONLY`
- `TRADE_DISABLED`
- `NO_QUOTE`
- `STALE_FEED`
- `UNKNOWN`

Interpretation:
- `OPEN_TRADABLE` means quote/trade/session truth is sufficiently consistent to allow Layer 2 work.
- `CLOSED_SESSION` means the symbol should be deferred until a later session-aware recheck.
- `QUOTE_ONLY` means some market activity may be visible, but trade-session truth is not sufficient for normal promotion flow.
- `TRADE_DISABLED` means the broker currently does not permit normal trading for that symbol.
- `NO_QUOTE` means required quote evidence is absent.
- `STALE_FEED` means quote evidence exists but is too old to treat as current market truth.
- `UNKNOWN` means ASC could not determine truth safely without guessing.

These names are blueprint-facing truth classes.
Product-facing output may translate them into domain language later, but implementation must preserve the distinctions.

### Layer 1 recheck law
Layer 1 must not use one generic retry loop for every non-open symbol.
Recheck handling must remain broker-symbol specific.

Minimum behavior:
- `CLOSED_SESSION` -> recheck by next known open boundary when available, otherwise bounded delayed retry
- `QUOTE_ONLY` -> bounded retry because session truth is incomplete
- `TRADE_DISABLED` -> bounded slower retry; do not treat as tradable by default
- `NO_QUOTE` -> bounded retry; do not infer open market from classification or asset family
- `STALE_FEED` -> bounded freshness retry; do not silently treat stale as live
- `UNKNOWN` -> bounded retry with explicit uncertainty preserved

### Hard laws
- If market is closed, do not run Layer 2 or Layer 3 for that symbol.
- Closed symbols must be rescheduled, not repeatedly rescanned.
- This truth is broker-symbol specific.
- Quote-session truth and trade-session truth must not be collapsed into one guessed state.
- No generic asset-class assumptions are allowed.
- If truth is uncertain, mark uncertain. Do not guess.
- Layer 1 determines eligibility truth only; it does not rank, score, or publish shortlist authority.

### Completion condition
Layer 1 is complete only when ASC can reliably:
- detect open vs closed per broker symbol
- separate closed-session, disabled, no-quote, stale-feed, and unknown states
- determine next recheck time for deferred symbols
- skip unnecessary scanning work without guessing

---

## LAYER 1.2 — UNIVERSE SNAPSHOT

### Purpose
Capture a startup snapshot of the full broker universe.

### Scope
All discoverable broker symbols.

### Required minimum snapshot content
Every snapshot record must preserve, where truth is available:
- raw broker symbol name
- normalized/canonical identity fields if resolved
- display/description/path metadata if available
- exchange/country/sector/industry metadata if the broker exposes it
- classification fields if resolved
- contract/spec fields needed for later conditions work
- margin/calc/trade/filling/order mode fields needed for truthful runtime interpretation
- volume min/max/step/limit fields where available
- session metadata or session-availability markers
- snapshot timestamp
- explicit unknown/missing markers where fields could not be read

### Allowed data
- broker symbol name
- canonical symbol identity if resolved
- description
- path
- exchange
- sector / industry if broker provides it
- contract specs
- volume limits
- calc / margin / trade / filling / order modes
- session metadata
- classification result if available
- explicit read-status / missing-status markers

### Forbidden at Layer 1.2
- no rolling dossier writes
- no Layer 2 calculations
- no ranking or promotion scores
- no activation-only fields
- no deep history persistence
- no atomic dossier continuation logic required here
- no hidden carry-forward of Layer 3 continuation metadata

### Nature of this layer
This is an updateable broker-universe snapshot.
It is not the rolling intelligence dossier system.
It exists to preserve broad broker truth, not shortlist intelligence.

### Snapshot write law
Layer 1.2 writes may be simpler than Layer 3 atomic dossier writes, but they must still:
- preserve truthful structure
- preserve prior valid snapshot truth unless replacement is intentional and verified
- keep missing values explicit
- avoid destructive reset for routine refreshes

---

## LAYER 2 — SURFACE SCAN

### Purpose
Run broad broker-aware intelligence acquisition over symbols that passed Layer 1.

### Scope
Only symbols with `Layer1Eligible = true`.

### Layer 2 responsibilities
- read broker symbol surface
- read broker specs
- read quote/trade state
- read classification truth from Market identity layer
- collect M15 + H1 history
- perform light computation
- measure spread and friction surface
- compute shortlist-relevant metrics
- rank by `PrimaryBucket`
- output top 5 per bucket

### Layer 2 is NOT trivial
It must respect:
- broker differences
- bucket differences
- sector differences
- symbol-specific behavior differences
- variation across all supported brokers

### Output of Layer 2
- `SUMMARY.txt`
- `SYMBOLS/<symbol>.txt`
- only for current shortlistable intelligence scope

### Layer 2 file contract
`SYMBOLS/<symbol>.txt` contains only:
- `[BROKER_SPEC]`
- `[OHLC_HISTORY]`
- `[CALCULATIONS]`

### Hard laws
- Writers never compute.
- No fake values.
- No guessed bucket assignment.
- Summary grouping uses `PrimaryBucket` from classification.
- Ranking must not invent buckets.
- If classification fails, bucket = `UNKNOWN`.
- Layer 2 may consume Layer 1.2 snapshot truth, but must not silently mutate Layer 1.2 into a hidden dossier.

### Completion condition
Layer 2 is complete only when ASC can reliably:
- surface-scan all open symbols
- respect broker/symbol truth
- compute shortlist metrics from real data
- publish top 5 per bucket correctly

---

## ACTIVATION GATE

Layer 2 does not grant rolling dossier rights to all scanned symbols.
Layer 2 decides which symbols become active.

Only promoted symbols may enter Layer 3 rolling dossier continuation.

---

## LAYER 3 — DEEP COMPUTATION / PERSISTENT SYMBOL INTELLIGENCE

### Purpose
Run heavy persistent symbol computation only after shortlist/scope selection.

### Nature of this layer
Layer 3 is not a restartable dump.
It is a long-lived, persistent, rolling intelligence store.

### Data depth examples
- lower timeframe history: up to ~1500 bars where required
- higher timeframe history: up to ~500 bars where required
- D / W / M depth as defined by blueprint stage

### Required persistence behavior
- always read existing stored data first
- all persisted data must carry timestamps
- only fill gaps
- only roll forward
- never wipe old data
- never rebuild from zero unless explicitly performing a controlled migration
- writes must be atomic
- updates must be rolling, not destructive

### Required write behavior
- temp/build target first
- validate integrity
- replace atomically only after success
- never leave partial file as active truth

### Output of Layer 3
A richer persistent symbol intelligence record built on top of Layer 2 truth.

### Completion condition
Layer 3 is complete only when ASC can reliably:
- restore prior symbol intelligence
- detect missing/stale ranges
- append/fill without destroying history
- roll deep datasets forward safely

---

## LAYER 4 — POST-LAYER-3 EXPANSION ("SS4")

### Status
Future stage only.
Not part of first working slice.

### Examples
- regime awareness
- broader indicator framework
- deeper ATR variants / regime-sensitive volatility logic
- richer state engines
- advanced symbol intelligence overlays

### Hard law
Layer 4 work is forbidden until Layers 1 to 3 are confirmed correct and stable.

---

## BUILD ORDER LAW
ASC must be built and validated in this order:
1. Layer 1
2. Layer 1.2
3. Layer 2
4. Activation Gate
5. Layer 3
6. Layer 4 expansion

No later layer may be built on assumed truth from an unfinished earlier layer.

---

## TEST GATE LAW
Each layer must pass:
- structure review
- logic review
- runtime verification
- broker reality verification
before the next layer starts.

---

## DESIGN WARNING
Do not call Layer 2 "just a simple scanner".
It is broad and comparatively lighter than Layer 3, but it still contains meaningful broker-aware intelligence work.

Do not call Layer 3 "more of the same".
It is a persistence-native rolling intelligence layer and must be designed differently.
