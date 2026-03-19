# 02 ASC Runtime Nervous System

## 1. Why ASC needs a nervous system

The EA must not be a loose collection of feature calls.  
It must behave like a living system with time, memory, debt, cadence, rechecks, and bounded work.

The runtime nervous system exists to answer:

- what is due now?
- what is still missing?
- what is too stale?
- what can wait?
- what deserves budget first?
- what should be retried quickly?
- what can be published safely right now?

## 2. Runtime modes

### 2.1 Boot mode
Purpose:
- create shell objects
- load config
- verify folders
- start timer heartbeat
- initialize runtime counters and cursors

### 2.2 Restore mode
Purpose:
- load universe membership
- load per-symbol state
- load prior summary/runtime state
- validate schema compatibility
- reject corrupt or stale continuity honestly

Rules:
- restore is bounded
- restore does not imply blind trust
- corrupt or incompatible state is rejected explicitly
- stale state is retained only as stale/frozen context, not as current truth

### 2.3 Warmup mode
Purpose:
- fill all missing minimum truths
- reduce unknown states to explicit meaningful states
- reach minimum viable scanner coherence without a giant destructive recompute

Warmup ends only when:
- every universe symbol has Layer 1 outcome
- every universe symbol has minimum Layer 1.2 snapshot outcome
- pending symbols are pending for truthful reasons, not merely because the scanner never got there

### 2.4 Steady-state mode
Purpose:
- roll forward cheaply
- refresh only what is due
- preserve continuity
- avoid startup-style full pressure

### 2.5 Degraded mode
Purpose:
- keep the scanner honest under budget stress, broker read stress, or file stress

In degraded mode:
- Layer 1 stays highest priority
- Layer 1.2 stays next
- Layer 2 continues if affordable
- Layer 3 optional work is reduced first
- publication continues only for safe current truth

### 2.6 Paused mode
Purpose:
- retain runtime shell and visibility while suspending heavy scanner services

Paused mode must still:
- stamp heartbeat
- update state
- keep operator HUD alive
- allow manual controls safely

## 3. Kernel heartbeat

### 3.1 Kernel cadence
Kernel heartbeat should run every 1 second or another similarly cheap fixed timer cadence.

Its job is orchestration, not deep scanning.

### 3.2 Kernel responsibilities
On each kernel heartbeat:

1. stamp current time and heartbeat sequence
2. enforce re-entry guard
3. sample broker/server/chart timing shell
4. refresh runtime mode state
5. determine which services are due
6. allocate cycle budget
7. dispatch bounded due work
8. collect service outcomes
9. perform safe write commits if due
10. update runtime snapshot, log state, and HUD

### 3.3 Kernel must track
- cycle number
- cycle start/end time
- current mode
- total budget
- remaining budget
- budget debt
- skipped service count
- deferred service count
- failed service count
- degraded flag
- service last-run timestamps

## 4. Due-service model

ASC must schedule services, not blindly call layers in one loop.

### 4.1 Service classes
Every due unit belongs to one of these classes:

- `BOOTSTRAP`
- `DELTA_FIRST`
- `RETRY_FASTLANE`
- `BACKLOG`
- `CONTINUITY`
- `PUBLISH_CRITICAL`
- `OPTIONAL_ENRICHMENT`

### 4.2 Service priority
Priority order:
1. kernel / safety
2. Layer 1 market truth
3. Layer 1.2 broker snapshot
4. state persistence needed for safe continuity
5. Layer 2 surface ranking
6. publication commits
7. Layer 3 optional enrichment
8. cosmetic operator extras

### 4.3 Service outcomes
Every service completion must return one of:
- success
- skipped
- deferred
- invalid-data
- failed
- budget-exceeded
- not-ready

No silent service disappearance.

## 5. Layer cadence model

### 5.1 Layer 1 cadence
Target full-universe revisit window: **60 minutes**

Meaning:
- every symbol should be revisited within one hour under normal operation
- the full-universe pass is split into bounded batches
- uncertain symbols can enter fastlane retries much sooner

#### Layer 1 fastlane
Use shorter retries for:
- pending market truth
- stale feed ambiguity
- no quote near expected open
- recent session transitions
- newly restored symbols with weak live evidence

Suggested fastlane ladder:
- 10 seconds
- 30 seconds
- 60 seconds
- 5 minutes

### 5.2 Layer 1.2 cadence
Target full-universe broker snapshot revisit window: **60 minutes**

Split by field family:

#### Static-ish fields
Refresh slowly:
- description
- path
- exchange
- long classification helpers
- instrument metadata

#### Dynamic broker fields
Refresh more actively:
- trade mode
- volume constraints
- fill/order modes
- margin/calc modes
- session metadata
- current quote snapshot fields if valid

### 5.3 Layer 2 cadence
Layer 2 runs every **10 minutes**.

Purpose:
- rescan the open universe cheaply
- refresh per-bucket competition
- re-evaluate top 5 leaders
- refresh summary candidate pool

### 5.4 Layer 3 cadences
Layer 3 is not one cadence. It is a family.

#### Every 10 seconds
- promoted symbol tick window maintenance
- micro spread and micro freshness
- short tactical movement state

#### Every 1 minute
- M1 rolling OHLC
- recent spread regime
- short tactical stats

#### Every 5 minutes
- M5 rolling OHLC
- M5 ATR / movement context
- short intraday environment updates

#### Every 15 minutes
- M15 rolling OHLC
- M15 ATR
- medium surface/deep bridge context
- regime drift refresh

#### Every 60 minutes
- H1 OHLC
- H1 ATR
- slower cost and environment refresh
- deeper regime context

#### On actual new bar only
- H4
- D1
- any slower timeframe family

No slower domain is recomputed when no new bar exists.

## 6. Budget and debt model

### 6.1 Why budget exists
The runtime must remain stable even when:
- the broker universe is large
- history calls are heavy
- file writes are pending
- several services become due together

### 6.2 Cycle budget
Each kernel cycle has:
- total work budget
- per-service budget hints
- overrun detection
- debt carry-forward

### 6.3 Budget debt rules
If a cycle cannot finish all due optional work:
- Layer 1 and Layer 1.2 keep priority
- Layer 2 keeps next priority
- Layer 3 optional enrichment yields first
- UI never steals budget from critical truth services

### 6.4 Overrun rules
If repeated overruns happen:
- set degraded mode
- lower optional budgets
- reduce deep batch sizes
- keep truth and publication honest

## 7. Rotation and fairness

### 7.1 Separate cursors
The runtime must keep separate cursors for:
- Layer 1 universe pass
- Layer 1.2 snapshot pass
- Layer 2 surface pass
- Layer 3 deep pass
- publication backlog pass
- retry-fastlane pass

### 7.2 Rotation laws
- no symbol class may monopolize the runtime
- closed symbols are revisited on their own cadence
- weak symbols remain represented
- pending symbols do not starve
- one bucket cannot trap the scanner forever
- recently promoted symbols do not erase the need to revisit others

### 7.3 Symbol classes by revisit urgency
- fastlane retry
- currently open
- promoted
- recently demoted
- closed with next-open reference
- dead/stale/inactive
- frozen

## 8. Hydration model

ASC needs explicit hydration levels.

### 8.1 Hydration states
- `NONE`
- `IDENTITY_READY`
- `MARKET_TRUTH_READY`
- `SNAPSHOT_MIN_READY`
- `SURFACE_READY`
- `PROMOTED_READY`
- `DEEP_CURRENT`
- `FROZEN_RETAINED`

### 8.2 Hydration rules
- Layer 1 requires identity
- Layer 2 requires market truth
- promotion requires surface-ready
- deep refresh requires promotion rights
- frozen retained means file exists and is useful, but is not current promoted truth

## 9. Recheck policy

### 9.1 Recheck is part of truth
A symbol state is incomplete unless it includes when it should be checked again.

### 9.2 Recheck categories
- open
- uncertain
- closed with next-open reference
- closed without next-open reference
- disabled
- stale feed
- frozen
- deep active

### 9.3 Recheck resolution
The system should prefer:
- exact next open when known
- otherwise a cadence-appropriate fallback
- shorter retries when evidence conflicts
- slower retries when truth is stable and low urgency

## 10. Mode transitions

### 10.1 Restore to warmup
Enter warmup after restore completes and before steady-state begins.

### 10.2 Warmup to steady-state
Allowed only when minimum truth coverage is reached.

### 10.3 Steady-state to degraded
Triggered by:
- repeated budget exhaustion
- repeated file commit failures
- widespread broker read failures
- sustained history acquisition stress

### 10.4 Degraded to steady-state
Allowed only after repeated stable cycles.

## 11. Startup and shutdown semantics

### 11.1 Startup
On startup:
1. initialize kernel
2. load state
3. validate compatibility
4. restore viable prior truth
5. mark stale/corrupt/incompatible honestly
6. begin warmup
7. only publish final summary once minimum coherence exists

### 11.2 Shutdown
On shutdown:
- close kernel cleanly
- flush safe runtime state
- do not attempt huge cleanup work
- preserve current continuity state
- leave last-good published files intact

## 12. Nervous-system failure points

### 12.1 Fastlane starvation
If fastlane keeps consuming cycles, the broad universe is neglected.

Fix:
- hard cap fastlane budget share
- broad coverage debt monitoring

### 12.2 Deep starvation
If deep work always yields to truth work, promoted symbols never get depth.

Fix:
- minimum deep budget floor when healthy
- degrade only under real pressure

### 12.3 Warmup never ends
If pending states lack expiry discipline, the EA remains forever in warmup.

Fix:
- pending states require reason, retry cadence, and eventual conclusion paths

### 12.4 Retry storms
If uncertain symbols retry too often, the runtime thrashes.

Fix:
- tiered retry ladder with backoff and promotion of stable outcomes

### 12.5 Single-cursor collapse
If all layers share one cursor, rotation becomes unfair and mixed.

Fix:
- independent cursors and debt tracking per service family

## 13. Operator visibility requirements

The nervous system must expose:
- current runtime mode
- cycle number
- cycle duration
- budget used / debt
- due service backlog
- last successful run per service
- current cursor positions
- degraded or paused status
- current fastlane size

Without this, the operator cannot tell whether the runtime is healthy.
