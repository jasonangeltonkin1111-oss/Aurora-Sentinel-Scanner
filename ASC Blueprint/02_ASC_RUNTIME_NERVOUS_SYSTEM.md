# 02 ASC Runtime Nervous System

## 1. Purpose

The EA must behave like a living runtime with:

- time
- memory
- bounded work
- fairness
- rechecks
- retries
- budgets
- debt
- publication safety
- explicit degradation

The nervous system answers:

- what is due now?
- what is missing?
- what is stale?
- what deserves budget first?
- what may wait?
- what must retry quickly?
- what may publish safely now?

## 2. Time model

### 2.1 Time sources
ASC should track at least:
- broker/server time
- local terminal time
- last tick time per symbol
- last bar close time per timeframe domain

Server time is primary for session/open logic and new-bar boundaries where possible.
Local time may be used only for watchdogs and file/log timestamps.

### 2.2 Time honesty
A symbol may have old history and old last quote while being currently closed or stale.
Time interpretation must never confuse “last seen” with “currently tradable”.

## 3. Runtime modes

### 3.1 Boot mode
Purpose:
- create shell state
- load config
- verify folders
- initialize counters, cursors, and registries
- start timer heartbeat

### 3.2 Restore mode
Purpose:
- load runtime state
- load universe membership
- load symbol files
- validate schema compatibility
- reject corrupt or incompatible continuity honestly

Rules:
- restore is bounded
- restore does not imply trust
- stale continuity may be retained as stale/frozen, not as fresh current truth

### 3.3 Warmup mode
Purpose:
- fill missing minimum truths
- convert “not reached yet” into explicit states
- reach minimum viable scanner coherence without a destructive rebuild

Warmup ends only when:
- every known symbol has a Layer 1 outcome
- every known symbol has a minimum Layer 1.2 snapshot outcome
- remaining pending symbols are pending for truthful reasons rather than runtime neglect
- runtime state can explain current gaps and next rechecks

### 3.4 Steady-state mode
Purpose:
- roll forward cheaply
- refresh only what is due
- preserve continuity
- avoid startup-style full pressure

### 3.5 Degraded mode
Purpose:
- keep the scanner honest under budget stress, broker-read stress, file stress, or history pressure

Rules:
- Layer 1 remains highest priority
- Layer 1.2 remains next
- Layer 2 continues if affordable
- Layer 3 yields first
- publication may continue only for safe current truth

### 3.6 Paused mode
Purpose:
- suspend heavy scanning while keeping the shell alive

Paused mode still must:
- stamp heartbeat
- update runtime state
- keep operator HUD responsive
- allow safe resume

## 4. Kernel heartbeat

### 4.1 Cadence
Kernel heartbeat should run every 1 second, or another similarly cheap fixed interval.
Its job is orchestration, not deep scanning.

### 4.2 Responsibilities per cycle
1. stamp cycle start and sequence
2. enforce re-entry guard
3. sample time shell
4. refresh mode state
5. determine due services
6. allocate cycle budget
7. dispatch bounded work in priority order
8. collect service outcomes
9. commit safe writes if due
10. update runtime state, logs, and HUD snapshot

### 4.3 Re-entry guard
If a prior cycle is still active, the kernel must:
- skip re-entry
- increment a guard metric
- record the event
- consider degraded mode if repeated

## 5. Due-service model

ASC schedules services. Layers do not blindly self-run.

### 5.1 Service classes
Every due unit belongs to one of:
- `BOOTSTRAP`
- `DELTA_FIRST`
- `RETRY_FASTLANE`
- `BACKLOG`
- `CONTINUITY`
- `PUBLISH_CRITICAL`
- `OPTIONAL_ENRICHMENT`
- `OPERATOR_REQUEST`

### 5.2 Priority order
1. kernel safety and runtime state
2. Layer 1 market truth
3. Layer 1.2 broker snapshot
4. continuity/persistence required for safe operation
5. Layer 2 surface competition
6. publication commits
7. Layer 3 deep enrichment
8. cosmetic UI extras

### 5.3 Service outcomes
Every service returns one of:
- `SUCCESS`
- `SKIPPED`
- `DEFERRED`
- `NOT_READY`
- `INVALID_DATA`
- `FAILED`
- `BUDGET_EXCEEDED`

No silent disappearance.

## 6. Budget and debt

### 6.1 Why budget exists
The runtime must remain stable when:
- the universe is large
- several services become due together
- broker reads slow down
- file commits are pending
- history requests become expensive

### 6.2 Budget model
Each kernel cycle owns:
- total budget
- per-service budget hints
- hard/soft budget boundaries
- overrun detection
- debt carry-forward

### 6.3 Debt rules
If a cycle cannot finish all optional work:
- Layer 1 and 1.2 stay first
- Layer 2 keeps next priority
- Layer 3 yields first
- UI must never steal budget from critical services

### 6.4 Overrun response
If repeated overruns occur:
- enter degraded mode
- lower optional budgets
- reduce deep batch sizes
- preserve truthful publication behavior

## 7. Coverage and fairness

### 7.1 Separate cursors
The runtime keeps independent cursors for:
- Layer 1 universe pass
- Layer 1.2 snapshot pass
- Layer 2 surface pass
- Layer 3 deep pass
- retry fastlane
- publication backlog
- cleanup backlog

### 7.2 Fairness laws
- no single symbol class may monopolize runtime
- pending symbols do not starve forever
- promoted symbols do not erase broad coverage obligations
- dead/stale/closed symbols must still be revisited on slower schedules
- one bucket cannot trap the scanner forever

### 7.3 Coverage debt
The kernel must track how far each service family is from its intended full-coverage window.
Coverage debt is different from cycle debt.
A runtime can finish cycles on time while still neglecting broad coverage.

## 8. Warmup completeness model

Warmup is complete only when all four are true:

1. **Universe coverage completeness** — every known symbol has been visited for Layer 1 at least once.
2. **Snapshot minimum completeness** — every known symbol has minimum broker snapshot outcome.
3. **Pending honesty completeness** — unresolved symbols carry explicit reason and next recheck instead of “not processed yet”.
4. **Publication safety completeness** — symbol files and runtime state can be committed safely; summary may be delayed until enough surface truth exists.

Warmup need not finish all Layer 3 deep data.
Warmup is about minimum truth coverage, not maximum enrichment.

## 9. Layer cadence registry

### 9.1 Layer 1 cadence
Target full-universe revisit window: **60 minutes**.

Implementation:
- split into bounded batches
- every symbol revisited within the window under healthy operation
- uncertain/open-transition symbols may re-enter fastlane earlier

### 9.2 Layer 1 fastlane retry ladder
Suggested ladder:
- 10 seconds
- 30 seconds
- 60 seconds
- 5 minutes
- then fall back to class cadence

Use for:
- pending market truth
- stale-feed ambiguity
- no quote near expected open
- newly restored symbols with weak live evidence
- recent session transitions

### 9.3 Layer 1.2 cadence
Target full-universe snapshot revisit window: **60 minutes**.

Split by field family:
- static-ish metadata refresh slowly
- dynamic broker fields refresh more actively
- quote-derived snapshot fields refresh only when meaningful and valid

### 9.4 Layer 2 cadence
Layer 2 runs every **10 minutes**.
Its job is cheap broad competition across currently non-closed symbols.

### 9.5 Layer 3 cadence family
Layer 3 is multi-cadence.

#### Every 10 seconds
- promoted-symbol tick window maintenance
- micro spread and micro freshness
- short tactical movement state

#### Every 1 minute
- M1 rolling OHLC
- recent spread regime
- short tactical stats

#### Every 5 minutes
- M5 rolling OHLC
- M5 ATR/context
- short intraday environment refresh

#### Every 15 minutes
- M15 rolling OHLC
- M15 ATR
- medium surface/deep bridge context
- regime drift refresh

#### Every 60 minutes
- H1 OHLC
- H1 ATR
- slower environment and cost refresh

#### On actual new bar only
- H4
- D1
- any slower timeframe family

No slow timeframe domain is recomputed when no new bar exists.

## 10. Recheck model

### 10.1 Recheck is part of truth
A symbol state is incomplete unless it includes when it should be checked again.

### 10.2 Recheck classes
- open and stable
- open but weak
- pending/uncertain
- closed with next-open reference
- closed without next-open reference
- disabled
- stale feed
- promoted active
- deep frozen
- archived inactive

### 10.3 Resolution rules
Prefer:
- exact next-open when known
- otherwise cadence-appropriate fallback
- shorter retries when evidence conflicts
- slower retries when truth is stable and low urgency

## 11. Hydration model

### 11.1 Canonical hydration states
- `NONE`
- `IDENTITY_READY`
- `MARKET_TRUTH_READY`
- `SNAPSHOT_MIN_READY`
- `SURFACE_READY`
- `PROMOTED_READY`
- `DEEP_CURRENT`
- `FROZEN_RETAINED`

### 11.2 Hydration rules
- Layer 1 requires identity
- Layer 2 requires market truth
- promotion requires surface readiness
- Layer 3 requires promotion rights or explicit near-promoted allowance
- `FROZEN_RETAINED` means useful continuity exists but is not current promoted truth

## 12. Layer 1 detailed truth policy

### 12.1 Triple confirmation
Closed truth must never be declared from broker flags alone.
Use three evidence paths:

- **Evidence A: quote usability**
  - bid readable
  - ask readable
  - both structurally usable

- **Evidence B: tick evidence**
  - tick exists
  - timestamp exists
  - freshness within policy

- **Evidence C: broker session/trade reference**
  - quote sessions
  - trade sessions
  - trade mode
  - next-open reference where available

### 12.2 Present-open vs expected-open
Present-open truth and expected-open reference must remain separate.
A broker schedule may say the symbol should open soon, yet live evidence may still be absent.
That is not the same as open.

### 12.3 Typical outcomes
- `OPEN_TRADABLE`
- `CLOSED_SESSION`
- `QUOTE_ONLY`
- `TRADE_DISABLED`
- `NO_QUOTE`
- `STALE_FEED`
- `UNKNOWN`

## 13. Asset-specific Layer 1 cautions

### 13.1 Stock-like instruments
Stale last quotes outside active exchange sessions can look alive.
Use session reference and quote/tick freshness carefully.

### 13.2 Crypto-like instruments
Do not assume session closure simply because session metadata is weak.
Fresh tick/quote evidence dominates current-open truth.

### 13.3 Futures-like instruments
Expiry and contract roll can mimic closure or disappearance.
Lifecycle and identity logic must distinguish closure from replacement.

## 14. Mode transitions

### 14.1 Restore to warmup
After restore completes and compatibility results are stamped.

### 14.2 Warmup to steady-state
Allowed only when warmup completeness conditions are satisfied.

### 14.3 Steady-state to degraded
Triggered by sustained:
- budget exhaustion
- file commit failures
- broker read failures
- history acquisition stress
- repeated re-entry guard hits

### 14.4 Degraded to steady-state
Allowed only after repeated stable healthy cycles.

## 15. Operator-request service handling

Manual actions should enqueue service requests rather than run heavy logic inline.
Examples:
- immediate Layer 1 refresh
- immediate republish
- rebuild summary
- rebuild one symbol
- reload universe membership

The kernel decides safe execution order.

## 16. Health telemetry requirements

The nervous system must expose:
- mode
- cycle number
- cycle duration
- total budget used / debt
- coverage debt by service family
- last successful run per service family
- fastlane size
- publication backlog size
- current cursors
- degraded or paused status

Without this, the operator cannot tell whether the runtime is healthy.

## 17. Failure points and countermeasures

### 17.1 Fastlane starvation
Countermeasure:
- cap fastlane share
- track broad-coverage debt

### 17.2 Warmup never ends
Countermeasure:
- pending states must carry reason, retry, and eventual resolution path

### 17.3 Retry storms
Countermeasure:
- bounded retry ladders with backoff and class fallback

### 17.4 Single-cursor collapse
Countermeasure:
- independent cursors and fairness tracking per service family

### 17.5 Deep starvation
Countermeasure:
- minimum deep budget floor while healthy
- deep yields first only under real pressure

### 17.6 Budget-blind operator actions
Countermeasure:
- operator actions enqueue service requests and respect the same kernel budget model
