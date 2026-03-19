# 01 ASC System Blueprint

## 1. Product identity

ASC is a **multi-layer scanner EA**.
Its job is to maintain a truthful, rolling, broker-facing and trader-usable view of the symbol universe.

### ASC is
- a broker-universe discovery engine
- a market-truth engine
- a broker snapshot engine
- a surface-ranking engine
- a deep enrichment engine for promoted symbols
- a rolling persistence and publication engine
- an operator/trader visibility surface

### ASC is not
- an execution EA
- a signal generator
- a strategy-family engine
- a portfolio allocator
- an Aurora wrapper
- a repo/worker workflow viewer
- a “run everything every tick” analytics monolith

## 2. Core purpose

ASC exists to answer, continuously and truthfully:

1. Which symbols exist in the broker universe?
2. Which symbols are truly open now, and what evidence supports that answer?
3. What are the real current broker conditions and specs for each symbol?
4. Which open symbols are the strongest current leaders per bucket?
5. What deeper rolling context exists for the promoted shortlist?
6. What truth is current, stale, pending, resumed, frozen, degraded, or incompatible?

## 3. Non-negotiable design laws

### 3.1 Restore-first law
Startup must restore all viable prior state before gap-filling begins.
Restart is not permission to wipe useful truth.

### 3.2 Whole-universe law
The scanner must preserve the whole known universe even when only a shortlist is promoted.
The summary is not the universe.

### 3.3 Truth-before-preference law
A symbol must reach explicit market truth before it can participate honestly in surface competition.
Truth may be weak or partial, but it must be explicit.

### 3.4 Cheap broad, expensive narrow law
The full universe gets light truth and light competition.
Only promoted symbols receive expensive rolling enrichment.

### 3.5 Closed-only hard market block law
If a symbol is truthfully closed, it is deferred from active competition.
Most other weakness states remain visible and are penalized rather than erased.

### 3.6 Domain freshness law
Market truth, snapshot, surface, OHLC, ticks, ATR, indicators, regime, publication, runtime state, and HUD state each own separate freshness clocks.

### 3.7 Rolling continuity law
ASC must roll forward from last good state, replacing only what has been truthfully refreshed.

### 3.8 Atomic publication law
Canonical published files must be committed atomically and only from validated payloads.

### 3.9 UI boundary law
HUD/menu may display prepared state but may never perform heavy calculations, file crawls, or truth mutation.

### 3.10 Product language law
Trader-facing surfaces must not expose internal dev workflow language such as worker, packet, wave, debug mirror, or raw build-stage chatter.
Diagnostic/operator surfaces may expose technical runtime truth but still should not become dev workflow theater.

### 3.11 No symbol amnesia law
Closed, inactive, stale, demoted, or dead-feed symbols remain represented by lifecycle state and recheck policy.
No symbol vanishes merely because current attention moved elsewhere.

### 3.12 Stronger-truth-preservation law
A weak current pass must not casually destroy stronger prior truth.
Downgrades must be explicit.

## 4. Inputs and outputs

### 4.1 Runtime inputs
- broker symbol list
- SymbolInfo* metadata
- SymbolInfoTick snapshot path
- CopyTicks rolling path
- CopyRates / OHLC path
- timer heartbeat time
- persisted runtime/symbol files
- operator configuration changes

### 4.2 Runtime outputs
- canonical per-symbol files
- universe dump
- top-5-by-bucket summary
- runtime state
- rolling logs
- HUD/menu surfaces fed from prepared state

## 5. Canonical runtime architecture

ASC is not one pass. It is a runtime with a kernel and due services.

### 5.1 Runtime tiers
- **Kernel tier**
- **Layer 1 market truth tier**
- **Layer 1.2 broker snapshot tier**
- **Layer 2 surface competition tier**
- **Promotion tier**
- **Layer 3 deep enrichment tier**
- **Publication tier**
- **UI and logging tier**

### 5.2 Canonical runtime order
1. boot shell
2. restore persisted state
3. validate universe membership and continuity compatibility
4. run due Layer 1 work
5. run due Layer 1.2 work
6. run due Layer 2 work
7. update promoted set
8. run due Layer 3 work
9. perform safe publication commits
10. update runtime snapshot, logs, and HUD state

This order repeats under kernel control.
It may not collapse into “discover + compute + publish everything in one pass”.

## 6. Runtime object model

### 6.1 Universe
The full discovered broker symbol set known to ASC.
Universe membership is persistent and versioned.

### 6.2 Symbol record
The in-memory authoritative record for one symbol.
It contains logical blocks for identity, lifecycle, market truth, snapshot, surface, promotion, deep state, freshness, publication, and reasons.

### 6.3 Bucket
A stable comparison class, usually `PrimaryBucket`, used for fair ranking.
A symbol competes first inside its assigned bucket.

### 6.4 Promoted set
The bounded set of symbols currently allowed to consume Layer 3 budget.
Promotion gives budget rights, not eternal status.

### 6.5 Runtime snapshot
The kernel-produced read model used by logs and HUDs.
It compresses runtime state but must not replace raw truth blocks.

## 7. Data domains

### 7.1 Identity domain
Fields include:
- raw broker symbol
- normalized symbol
- canonical symbol
- description
- path
- exchange
- sector/industry if available
- asset class
- primary bucket
- classification confidence
- classification reason
- custom/synthetic flag

### 7.2 Market truth domain
Fields include:
- market state
- session state
- quote usability state
- tick freshness state
- tradeability reference state
- reason code
- confidence class
- next recheck time
- next expected open time
- evidence timestamps

### 7.3 Broker snapshot domain
Fields include:
- digits, point
- tick size, tick value
- contract size
- volume min/max/step/limit
- stops level, freeze level
- swap fields
- margin/profit/currency fields
- fill mode, order mode, calc mode
- session metadata
- suspicious-zero markers
- unreadable/missing markers

### 7.4 Surface domain
Fields include:
- cost efficiency score family
- movement quality score family
- execution usability score family
- data quality score family
- environment quality score family
- penalty bundle
- surface score
- rank inside bucket
- rank reasons
- quality-floor eligibility

### 7.5 Promotion domain
Fields include:
- promoted status
- promotion source bucket
- promotion timestamp
- hysteresis/tie-break metadata
- near-promoted status
- freeze-on-demotion metadata

### 7.6 Deep domain
Fields include:
- bounded tick window state
- rolling OHLC rings by timeframe
- ATR families
- approved indicator families
- regime/environment fields
- friction persistence
- deep freshness and stale markers
- last good deep refresh

### 7.7 Continuity domain
Fields include:
- continuity origin (`FRESH`, `RESTORED`, `MIXED`, `FROZEN`, `DEGRADED`)
- last good server time
- restore outcome
- compatibility outcome
- corruption outcome
- frozen reason

### 7.8 Publication domain
Fields include:
- symbol publish state
- universe dump publish state
- summary publish state
- last commit success/failure
- pending reasons
- validation result
- last-good fallback presence

## 8. Asset-class awareness

ASC must not assume all symbols behave like spot FX.

### 8.1 FX / metals / energies / index CFDs
Common issues:
- sessions can close while stale prices remain visible
- spreads can widen around opens and closes
- trade mode may change independently of quote visibility

### 8.2 Crypto CFDs or 24/7 products
Common issues:
- 24/7 expectations can break naive session-closed assumptions
- maintenance pauses and stale-feed periods can mimic closure

### 8.3 Stocks / stock CFDs / exchange products
Common issues:
- auction windows
- lunch breaks in some markets
- long off-session periods with plausible last quotes
- trade-disabled pre-open and after-hours distinctions

### 8.4 Futures / expiring contracts
Common issues:
- expiry/roll behavior
- contract replacement
- session gaps and overnight pauses

### 8.5 Custom or synthetic symbols
Common issues:
- broker metadata may be incomplete or misleading
- tick and quote semantics may differ from regular tradables

Asset class does not change the runtime spine, but it changes interpretation thresholds and reason codes.

## 9. Symbol lifecycle model

Every symbol lives in an explicit lifecycle.

### 9.1 Canonical lifecycle states
- `DISCOVERED`
- `RESTORED`
- `PENDING_MARKET_TRUTH`
- `DEFERRED_CLOSED`
- `DEFERRED_DISABLED`
- `DEFERRED_STALE`
- `SNAPSHOT_MIN_READY`
- `SURFACE_READY`
- `PROMOTED`
- `DEEP_ACTIVE`
- `DEEP_FROZEN`
- `ARCHIVED_INACTIVE`

### 9.2 Lifecycle rules
- discovery does not imply open
- open does not imply promotion
- promotion does not imply permanence
- demotion freezes useful deep state rather than deleting it
- stale does not imply absence
- unknown never silently becomes a negative fact

## 10. File architecture

The file model must stay simple.

### 10.1 Canonical root files
- `UNIVERSE_DUMP.txt`
- `SUMMARY_TOP5_BY_BUCKET.txt`
- `RUNTIME_STATE.txt`
- `ASC_LOG.txt` (rolled)

### 10.2 Canonical symbol folder
- `SYMBOLS/<symbol>.txt`

### 10.3 Philosophy
- one broad universe truth file
- one shortlist routing file
- one canonical file per symbol
- one runtime read-model file
- one rolled log family

Internal helper fragments may exist, but they do not replace canonical files.

## 11. UI and language boundary

### 11.1 Operator HUD
Shows runtime reality:
- mode
- heartbeat age
- due service states
- counts by lifecycle and truth class
- budget debt
- current cursors
- fastlane size
- publish headline
- pending clusters

### 11.2 Trader HUD
Shows trader-usable summary:
- leading buckets
- leader freshness
- high-level cost/movement summary
- last deep refresh age
- quality caveats

### 11.3 UI restrictions
HUD/menu must not:
- compute ranking
- call deep history paths on redraw
- crawl symbol files heavily every paint
- mutate runtime state beyond explicit operator actions
- become a runtime stall point

## 12. Operator actions

Operator actions are allowed, but must schedule work rather than execute heavy work inline.
Examples:
- request immediate Layer 1 refresh
- request republish
- request summary rebuild
- pause/resume scanner
- adjust timer or budget parameters

Menu actions must feed config/state and let the kernel execute them safely later.

## 13. Major failure points and countermeasures

### 13.1 False closed detection
Cause: trusting broker-closed/session flags without live-evidence discipline.
Countermeasure: triple confirmation with quote, tick, and session/trade reference.

### 13.2 Quiet symbols ranking well for the wrong reason
Cause: low spread outranks low movement.
Countermeasure: cost must be evaluated relative to movement and quality.

### 13.3 Fast garbage symbols dominate
Cause: movement outranks economics and freshness.
Countermeasure: strong penalties for stale feed, suspicious-zero economics, degraded continuity, thin history, and poor usability.

### 13.4 Restart wipes good state
Cause: no restore-first nervous system.
Countermeasure: compatibility-aware restore, carry-forward until verified replacement, and explicit stale/frozen labels.

### 13.5 Publication exposes half-written truth
Cause: writing live files before validation succeeds.
Countermeasure: classed atomic commit, symbol-file-first then summary-last order, and last-good preservation.

### 13.6 UI stalls runtime
Cause: HUD/menu compute or crawl too much.
Countermeasure: strict read-model contract.

### 13.7 Universe amnesia
Cause: symbols disappear if not processed in the current pass.
Countermeasure: universe persistence, lifecycle states, revisit classes, and retention rules.

### 13.8 Scheduler starvation
Cause: fastlane or promoted set monopolizes cycles.
Countermeasure: budgets, debt, fairness shares, and independent cursors.

## 14. End-state definition

ASC is correct only when it behaves like this:

- restart loads useful prior state
- every symbol reaches explicit market truth
- every symbol has a truthful minimum broker snapshot
- the full open universe competes every 10 minutes on cheap broad logic
- only promoted symbols receive expensive rolling depth
- per-domain refresh happens only when due
- published files are atomic, validated, and continuity-safe
- the HUD tells the operator what is known, pending, stale, resumed, degraded, frozen, and promoted without doing the work itself
