# 05 ASC Build Stages and Acceptance

## 1. Purpose

This file defines the **implementation order implied by the EA design**.
It is not office choreography.
It is the build order required so the finished EA actually behaves like the blueprint.

Every stage must be:
- built
- tested
- observed
- corrected
- accepted

Only then may the next stage begin.

## 2. Global build laws

1. Never build later intelligence on top of unstable foundation truth.
2. Do not let UI stand in for missing runtime behavior.
3. Do not build deep logic before the kernel, persistence, and Layer 1/1.2 work.
4. Do not publish trader summary from unsafe partial truth.
5. Every stage must expose logs and HUD evidence proving it ran.
6. Every stage must preserve restart continuity and file safety.

## 3. Stage 0 — Canon shell and shared vocabulary

### Build
- shared enums
- reason codes
- freshness vocabulary
- lifecycle vocabulary
- file naming and folder structure
- schema version constants
- runtime DTOs and symbol DTOs

### Must prove
- one shared language exists for all later stages
- no duplicate enum drift
- product language and developer language are separated early

### Forbidden jump
- no market logic
- no ranking
- no deep analytics

## 4. Stage 1 — Kernel, restore, and nervous-system shell

### Build
- timer heartbeat
- re-entry guard
- runtime mode state
- due-service registry
- service timestamps
- budget and coverage debt shell
- cursor persistence
- runtime state file
- structured log shell
- operator HUD shell that displays runtime state only

### Must prove
- init completes without feature collapse
- restore path runs before fill
- kernel exposes cycle and due-service visibility
- UI does not own heavy work

### Test focus
- repeated timers
- pause/resume
- empty-state restore
- stale/corrupt runtime state

## 5. Stage 2 — Universe discovery and identity minimum

### Build
- universe discovery
- minimum identity block per symbol
- raw/normalized/canonical symbol handling
- primary bucket assignment shell
- unknown/custom/synthetic handling

### Must prove
- universe membership persists cleanly
- identity blocks survive restart
- symbol naming mismatches do not corrupt continuity

### Test focus
- broker symbol rename edge cases
- custom symbols
- disappearing and reappearing symbols

## 6. Stage 3 — Layer 1 market truth

### Build
- triple confirmation open/closed logic
- reason codes
- next recheck logic
- fastlane retry classes
- full-universe Layer 1 batching
- market-truth block in symbol files

### Must prove
- closed is not declared from broker flags alone
- stale/no-quote/unknown remain distinct
- every symbol reaches explicit Layer 1 result
- recheck scheduling is honest

### Test focus
- live quote but closed schedule reference
- schedule present but no quote
- stale feed
- newly opened market
- disabled symbol
- crypto-like 24/7 edge cases
- stock-like stale-off-session quotes

## 7. Stage 4 — Layer 1.2 broker snapshot

### Build
- full broker spec intake
- suspicious-zero handling
- snapshot freshness clocks
- field-family refresh cadences
- minimum universe dump schema
- snapshot block in symbol files

### Must prove
- all discoverable symbols get snapshot records
- zero and missing are never confused
- prior strong spec truth is not wiped by one weak pass

### Test focus
- unreadable broker fields
- partial spec reads
- dynamic trade mode changes
- symbol disappears then returns

## 8. Stage 5 — Persistence and publication shell

### Build
- Class A atomic commit
- temp/backup/final promotion flow
- write journal
- symbol writer
- universe dump writer
- summary writer shell
- runtime state writer
- corruption detection
- summary-last order

### Must prove
- no half-written canonical files
- pending symbol files can exist safely
- summary only routes to already-committed symbol files
- restore rejects corrupt files honestly

### Test focus
- interrupted write
- failed temp validation
- corrupt prior file
- pending symbol population during publish

## 9. Stage 6 — Layer 2 surface competition

### Build
- score families
- penalty family
- bucket competition
- top-5 ceiling logic
- quality floors
- 10-minute surface cadence
- surface block in symbol files and summary

### Must prove
- weak symbols do not rank highly by accident
- quiet low-spread junk cannot dominate
- stale or degraded symbols are penalized hard
- weak buckets publish fewer than five leaders when appropriate

### Test focus
- bucket with few usable symbols
- ranking churn on tiny score changes
- unknown bucket behavior
- stale leader vs fresh runner-up

## 10. Stage 7 — Promotion engine and freeze model

### Build
- promoted-set persistence
- promotion tie-break rules
- hysteresis logic
- demotion freeze rules
- near-promoted allowance logic

### Must prove
- promotion is stable enough
- demotion preserves useful deep state
- promoted set survives restart honestly

### Test focus
- rapid oscillation
- promoted symbol closes
- promoted symbol becomes stale
- bucket leader replacement

## 11. Stage 8 — Layer 3 deep rolling data

### Build
- tick window
- OHLC rings
- timeframe-specific cadence logic
- ATR families
- deep regime/environment
- deep freshness clocks
- deep block persistence

### Must prove
- new bars update only when due
- no full-history recompute every cycle
- promoted symbols receive depth without starving the system
- stale deep domains are downgraded honestly

### Test focus
- no new bar boundary
- missing bars
- thin history
- budget pressure
- demotion freeze behavior

## 12. Stage 9 — Final UI surfaces

### Build
- operator HUD final fields
- trader HUD final fields
- menu controls that modify config/state only
- visibility of pending reasons, budget debt, freshness, and promotion state

### Must prove
- HUD uses prepared runtime state only
- no heavy compute inside redraw
- trader and operator surfaces stay distinct
- manual actions enqueue work rather than execute it inline

### Test focus
- repaint storms
- stale HUD state
- bad menu changes
- large universe counts

## 13. Stage 10 — Hardening, recovery, and retention

### Build
- degraded mode actions
- cleanup rules
- retention rules
- stale continuity rejection rules
- performance sampling
- recovery tests

### Must prove
- restart continuity is bounded and honest
- degraded mode remains useful
- logs explain failures well enough for recovery

## 14. Stage acceptance checklist

A stage is accepted only if all are true:
- runtime behavior matches blueprint scope
- logs prove execution path
- HUD exposes stage health honestly
- files commit safely
- no hidden destructive reset exists
- forbidden jumps were not introduced
- relevant failure cases were tested
- restart continuity remains intact

## 15. Migration guidance from the current ASC tree

### 15.1 Carry forward carefully
- truthful identity/classification work
- truthful session/snapshot read helpers
- storage helpers that are actually atomic-safe
- useful render ideas for symbol and summary output

### 15.2 Rewrite or reorganize
- collapsed init configuration
- engine single-pass orchestration
- workflow-like phase text on HUD
- publication too tightly coupled to process pass
- under-specified nervous-system state
- mixed later-layer feature activation too early

### 15.3 Do not carry forward
- “enable everything at init and hope”
- summary publication before safe current symbol files
- UI as a logic owner
- giant later-stage assumptions before the kernel is real

## 16. Final acceptance of the entire EA

ASC is ready only when:
- restart restore is honest and stable
- every symbol reaches explicit market truth
- full-universe snapshot is preserved
- surface ranking refreshes every 10 minutes
- promoted symbols receive proper rolling deep updates
- canonical files commit atomically
- summary is current and truthful
- HUD tells the operator what is happening without doing the work itself
- no symbol is silently forgotten
- no dev workflow language contaminates product surfaces
