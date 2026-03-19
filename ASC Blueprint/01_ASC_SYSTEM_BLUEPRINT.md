# 01 ASC System Blueprint

## 1. Product identity

ASC is a **multi-layer scanner EA**.

Its job is to build and maintain a truthful, rolling view of the broker universe, then present the best currently-usable symbols per bucket without pretending to be a trading brain.

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
- a portfolio allocator
- a strategy wrapper
- a worker-orchestration system
- a dev workflow viewer

## 2. Core purpose

The EA exists to answer these questions continuously and truthfully:

1. Which symbols exist in the broker universe?
2. Which of them are truly open now?
3. What are their real broker specs and market conditions?
4. Which open symbols are the strongest top-5 candidates per bucket right now?
5. What deeper contextual data exists for the promoted shortlist?
6. What state is current, stale, pending, frozen, resumed, or degraded?

## 3. Non-negotiable design laws

### 3.1 Restore-first law
Startup must restore all viable prior state before it begins filling gaps.  
Restart is never a reason to erase useful truth.

### 3.2 Truth-before-ranking law
No symbol may be surface-ranked until its market truth exists.  
No symbol may be deep-enriched merely because it exists.

### 3.3 Cheap broad, expensive narrow law
The full universe gets cheap truth and cheap ranking.  
Only promoted symbols receive expensive rolling enrichment.

### 3.4 Closed-only hard block law
A symbol that is truly closed is deferred.  
Everything else remains visible, explicit, and rankable, with penalties rather than fake disappearance.

### 3.5 Domain freshness law
Market truth, broker snapshot, surface rank, OHLC stores, ticks, ATR, indicators, regime, publication, and UI state each own separate freshness clocks.

### 3.6 Rolling continuity law
The system must roll forward from last good state, preserving continuity and replacing only what has been truthfully refreshed.

### 3.7 Atomic publication law
Canonical published files must be committed atomically and only from validated payloads.

### 3.8 UI boundary law
HUD/menu may display current prepared state but may never perform heavy calculations, file crawls, or truth mutation.

### 3.9 Product language law
The product surface must not expose dev workflow language such as packet, worker, wave, debug mirror, or raw layer jargon unless the operator explicitly switches to a diagnostic surface.

### 3.10 No symbol amnesia law
Closed, inactive, stale, demoted, and dead-feed symbols must remain represented by lifecycle state and recheck policy. They are not forgotten.

## 4. Canonical runtime architecture

ASC is not one pipeline pass.  
It is a runtime with a kernel and several due services.

### 4.1 Runtime tiers
- **Kernel tier**
- **Layer 1 market truth tier**
- **Layer 1.2 broker snapshot tier**
- **Layer 2 surface competition tier**
- **Promotion tier**
- **Layer 3 deep enrichment tier**
- **Publication tier**
- **UI and logging tier**

### 4.2 Canonical runtime order
1. boot shell
2. restore persisted state
3. load or validate universe membership
4. run Layer 1 due work
5. run Layer 1.2 due work
6. run Layer 2 due work
7. update promoted set
8. run Layer 3 due work
9. perform safe publication commits
10. refresh logs and HUD state

This order repeats under the control of the kernel scheduler.  
It is not allowed to collapse into “discover + compute + publish everything in one pass”.

## 5. Data domains

### 5.1 Identity domain
What symbol is this?

Fields include:
- raw broker symbol
- normalized symbol
- canonical symbol
- display name
- path
- exchange
- sector / industry where available
- asset class
- primary bucket
- classification confidence
- classification review reason

### 5.2 Market truth domain
Is the symbol truly open now, and what evidence supports that?

Fields include:
- market state
- session state
- tick freshness state
- quote usability state
- trade-mode state
- next recheck time
- next expected open time
- reason code
- confidence class

### 5.3 Broker snapshot domain
What broker metadata is currently known?

Fields include:
- contract size
- tick size
- tick value
- point
- digits
- margin and profit modes
- fill / order modes
- volume min / max / step / limit
- stops level
- freeze level
- swap fields
- currency fields
- session schedule metadata
- raw broker class metadata

### 5.4 Surface domain
How attractive is the symbol right now on a cheap broad scan?

Fields include:
- cost quality
- movement quality
- data quality
- execution usability
- environment quality
- penalty bundle
- surface score
- rank inside bucket
- rank reasons

### 5.5 Deep domain
What richer rolling context exists for promoted symbols?

Fields include:
- rolling OHLC windows
- tick rolling window
- ATR families
- indicator families
- regime classification
- environment state
- deeper friction and cost context
- continuity metrics
- deep freshness state

### 5.6 Continuity domain
How trustworthy is the current state origin?

Fields include:
- continuity origin
- last good server time
- restore outcome
- stale outcome
- compatibility outcome
- resumed / fresh / mixed / frozen origin class

### 5.7 Publication domain
What is safe to publish now?

Fields include:
- symbol-file publish state
- universe-dump publish state
- summary publish state
- last commit success
- pending reasons
- validation outcome

## 6. Symbol lifecycle model

Every symbol lives in an explicit lifecycle, not a silent boolean.

### 6.1 Lifecycle states
- `DISCOVERED`
- `RESTORED`
- `PENDING_MARKET_TRUTH`
- `DEFERRED_CLOSED`
- `DEFERRED_DISABLED`
- `DEFERRED_STALE`
- `SNAPSHOT_READY`
- `SURFACE_READY`
- `PROMOTED`
- `DEEP_ACTIVE`
- `DEEP_FROZEN`
- `ARCHIVED_INACTIVE`

### 6.2 Lifecycle rules
- discovery does not imply open
- open does not imply promotion
- promotion does not imply permanent deep rights
- demotion freezes deep state when useful
- inactive does not imply deletion
- stale does not imply absence
- unknown never silently turns into negative truth

## 7. File architecture

The file model must stay simple.

### 7.1 Canonical root files
- `UNIVERSE_DUMP`
- `SUMMARY_TOP5_BY_BUCKET`
- `RUNTIME_STATE`
- `ASC_LOG`

### 7.2 Canonical symbol folder
- `SYMBOLS/<symbol>`

### 7.3 File philosophy
- one full universe dump
- one top-level summary
- one file per symbol
- one runtime state file
- one rolling log file family

No explosion of dozens of front-door files.

## 8. Module family design

The live codebase should eventually collapse into a few major module families.

### 8.1 Kernel
Owns:
- boot
- restore
- timer orchestration
- due-service scheduling
- budgets and debt
- mode transitions
- heartbeat state

### 8.2 MarketTruth
Owns:
- triple confirmation of open/closed
- session interpretation
- quote/tick evidence
- market reason codes
- next recheck logic

### 8.3 Snapshot
Owns:
- full-universe broker snapshot
- field-read policies
- suspicious-zero handling
- snapshot freshness

### 8.4 Surface
Owns:
- cheap ranking inputs
- bucket competition
- top-5 selection
- promotion inputs

### 8.5 Deep
Owns:
- rolling OHLC windows
- tick window
- ATR/indicator families
- regime and environment
- promoted-symbol enrichments

### 8.6 Persistence
Owns:
- restore
- rolling state storage
- schema / compatibility
- corruption handling
- atomic commit mechanics

### 8.7 Publication
Owns:
- universe dump render
- summary render
- symbol render
- publish gating
- last-good preservation

### 8.8 UI
Owns:
- operator HUD
- trader HUD
- menu surfaces
- only read-model logic

### 8.9 Logging
Owns:
- structured runtime event log
- cycle stats
- service outcomes
- publish outcomes
- restore outcomes

## 9. UI and language boundary

The HUD/menu must exist from the beginning, but as a read surface.

### 9.1 Operator HUD
Shows:
- mode
- heartbeat age
- due-service states
- universe counts
- open / closed / pending / stale counts
- promoted / deep counts
- last publish result
- budget debt
- cursor positions
- pending reason clusters

### 9.2 Trader HUD
Shows:
- bucket leaders
- symbol readiness
- market freshness
- cost / movement summary
- last deep refresh age

### 9.3 UI restrictions
The UI must not:
- scan files heavily every paint
- call heavy history functions
- compute ranking
- mutate scheduler state beyond user input intent
- become a runtime stall point

### 9.4 Language rules
Operator surfaces may use technical phrases like freshness, deferred, pending, resumed, degraded, deep refresh.  
Trader surfaces may use simpler product language like open, fresh, active, cheap, expensive, fast-moving, quiet, top-ranked.

Do not expose wording like:
- packet
- worker
- wave
- debug mirror
- layer 1 / 1.2 / 3 to trader surfaces
- build slice / clerk / HQ

## 10. Major failure points and countermeasures

### 10.1 Failure: false closed detection
Cause:
- trusting broker closed flags without live evidence discipline

Countermeasure:
- triple confirmation with quote, tick, and broker session/trade reference

### 10.2 Failure: stale symbols ranking highly
Cause:
- movement/cost ranking without freshness penalties

Countermeasure:
- freshness and data quality are weighted score families with strong penalties

### 10.3 Failure: weak symbols filling buckets
Cause:
- forcing five symbols even when bucket quality is poor

Countermeasure:
- top-5 is a ceiling, not a quota; weak buckets may publish fewer than five leaders

### 10.4 Failure: restart wipes useful state
Cause:
- no restore-first nervous system

Countermeasure:
- bounded restore, compatibility checks, stale policy, carry-forward until verified replacement

### 10.5 Failure: publication exposes half-written truth
Cause:
- writing live files before payload validation completes

Countermeasure:
- strict atomic commit classes, summary last, last-good preservation

### 10.6 Failure: UI stalls the runtime
Cause:
- UI recomputes or crawls heavy data

Countermeasure:
- UI consumes only prepared runtime snapshots

### 10.7 Failure: universe amnesia
Cause:
- symbols vanish when not processed in the current cycle

Countermeasure:
- universe membership persistence, lifecycle states, slow recheck classes for inactive symbols

### 10.8 Failure: one heartbeat does everything
Cause:
- collapsed pipeline

Countermeasure:
- kernel plus due-service architecture with budgets, debt, and separate cadences

## 11. Current-tree contradictions this blueprint corrects

### 11.1 Init is too feature-heavy
The live init currently enables history, ATR, surface, summary, symbol files, HUD, and menu immediately.  
That couples startup to later-stage work too early.

### 11.2 Engine pass is too collapsed
The current engine still does discovery, process, save snapshot, and publish in the same broad pass.

### 11.3 Runtime text leaks workflow language
The current HUD uses internal phase text like `Layer 1 / Layer 1.2 / Surface`.  
That is not acceptable product-facing language.

### 11.4 Publication is too close to fill-pass truth
Publishing from the same runtime sweep that is still filling foundational truth risks half-complete surfaces.

### 11.5 Persistence exists without a complete nervous system
Storage logic exists, but the kernel mode model, service classes, debt, fastlane retries, and per-domain cadences are not yet fully constitutional.

## 12. End-state definition

ASC is correct only when it behaves like this:

- restart loads useful prior state
- the kernel knows what is due
- every symbol eventually reaches explicit market truth
- every symbol has a truthful broker snapshot
- the full open universe competes every 10 minutes on cheap broad logic
- only promoted symbols receive expensive rolling depth
- per-domain refresh happens only when due
- published files are atomic, validated, and rolling-safe
- the HUD tells the operator what is known, pending, stale, resumed, degraded, and promoted without doing heavy work itself
