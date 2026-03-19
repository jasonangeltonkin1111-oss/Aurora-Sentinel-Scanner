# 05 ASC Build Stages and Acceptance

## 1. Purpose

This file defines the **implementation order implied by the EA design**.

It is not office workflow.  
It is the build order required so the finished EA actually matches the blueprint.

Each stage must be:
- built
- tested
- observed
- corrected
- accepted

Only then does the next stage begin.

## 2. Global build laws

1. Never build later intelligence on top of unstable foundation truth.
2. Do not let UI own missing runtime behavior.
3. Do not build deep logic before the kernel, persistence, and Layer 1/1.2 work.
4. Do not publish trader summary from partial unsafe truth.
5. Each stage must expose logs and HUD evidence proving it ran.

## 3. Stage 0 — Canon shell and naming

### Build
- runtime config shell
- shared enums / reason codes / freshness vocab
- file naming model
- folder structure
- runtime state DTOs
- symbol lifecycle DTOs

### Must prove
- no product/dev language confusion
- no duplicate enum drift
- all later stages have stable shared vocabulary

### Forbidden jump
- no market logic yet
- no ranking
- no deep data

## 4. Stage 1 — Kernel, restore, and nervous system shell

### Build
- timer heartbeat
- re-entry guard
- runtime mode state
- due-service registry
- per-service last-run timestamps
- cycle budget/debt shell
- cursor persistence
- runtime state file
- structured log shell
- operator HUD shell that only displays runtime state

### Must prove
- init completes without heavy full-feature collapse
- restore path runs before fill
- kernel can show due services and cycle counts
- no heavy scanning lives in UI

### Failure points to test
- repeated timers
- pause/resume
- empty state restore
- stale/corrupt runtime state

## 5. Stage 2 — Layer 1 market truth

### Build
- symbol discovery
- per-symbol identity minimum
- triple confirmation open/closed logic
- reason codes
- next recheck logic
- fastlane retry classes
- full-universe Layer 1 batching

### Must prove
- closed is not declared from broker flags alone
- stale/no-quote/unknown stay distinct
- every symbol reaches explicit Layer 1 result
- recheck times are assigned honestly

### Failure points to test
- live quote but closed schedule reference
- schedule present but no quote
- stale feed
- newly opened market
- disabled symbol
- custom symbol edge cases

## 6. Stage 3 — Layer 1.2 full broker snapshot

### Build
- broker spec intake
- suspicious-zero handling
- snapshot freshness
- field-family refresh cadences
- universe dump minimum schema
- per-symbol snapshot blocks

### Must prove
- all discoverable symbols get snapshot records
- zero and missing are not confused
- old valid spec truth is not wiped by one weak pass

### Failure points to test
- unreadable broker fields
- partial spec reads
- dynamic trade mode changes
- symbol disappears then returns

## 7. Stage 4 — Persistence and publication shell

### Build
- Class A atomic commit
- temp/backup/final promotion flow
- symbol-file writer
- universe-dump writer
- summary writer shell
- runtime state writer
- last-good preservation
- corruption detection
- summary-last publication order

### Must prove
- no half-written canonical files
- summary only routes to already-committed symbol files
- pending symbol files can exist safely
- restore can reject corrupt files honestly

### Failure points to test
- interrupted write
- corrupt prior file
- failed temp validation
- publish while some symbols remain pending

## 8. Stage 5 — Layer 2 surface competition

### Build
- score families
- penalty family
- bucket competition
- top-5 ceiling logic
- quality floors
- 10-minute surface cadence
- surface fields in symbol files and summary

### Must prove
- weak symbols do not rank highly by accident
- quiet low-spread junk cannot dominate
- stale or degraded symbols are penalized hard
- empty/weak buckets publish fewer than five leaders when appropriate

### Failure points to test
- bucket with few usable symbols
- ranking churn on tiny score changes
- unknown bucket behavior
- stale leader versus fresh runner-up

## 9. Stage 6 — Promotion engine and freeze model

### Build
- promoted-set persistence
- promotion tie-breaks
- demotion freeze rules
- recent-promoted continuity handling
- summary leadership promotion contract

### Must prove
- promotion is stable enough
- demotion preserves last good deep state
- promoted set survives restart appropriately

### Failure points to test
- rapid oscillation
- promoted symbol closes
- deep refresh fails during promotion
- bucket leader replacement

## 10. Stage 7 — Layer 3 rolling deep data

### Build
- tick window
- OHLC rings
- timeframe-specific cadence logic
- ATR families
- regime/environment surface-deep bridge
- per-domain freshness
- deep block persistence

### Must prove
- new bars update only when due
- no full-history recompute each cycle
- promoted symbols receive depth without starving the rest of the system
- stale deep domains are downgraded honestly

### Failure points to test
- no new bar boundary
- missing bars
- thin history
- budget pressure
- promoted symbol leaves active set

## 11. Stage 8 — Final UI surfaces

### Build
- operator HUD final fields
- trader HUD fields
- menu controls that mutate config only
- display of pending reasons, budget debt, and freshness

### Must prove
- HUD uses prepared runtime state only
- no heavy compute inside redraw
- trader and operator surfaces are not blended badly

### Failure points to test
- repaint storms
- stale HUD state
- bad menu changes
- huge universe counts

## 12. Stage 9 — Hardening and recovery

### Build
- degraded mode actions
- cleanup and retention rules
- stale continuity rejection rules
- backup retention
- performance sampling
- recovery tests

### Must prove
- restart continuity is bounded and honest
- degraded mode remains useful
- logs explain what happened when something fails

## 13. Stage acceptance checklist

A stage is accepted only if all are true:
- runtime behavior matches blueprint scope
- logs prove execution path
- HUD exposes stage health honestly
- files commit safely
- no hidden destructive resets
- no forbidden jump was introduced
- observed failure cases were tested

## 14. Migration guidance from current ASC

### 14.1 Keep
- existing identity/classification work where truthful
- existing session/snapshot read work where strong
- existing storage helper pieces that are actually atomic-safe
- existing summary and symbol render ideas where presentation is useful

### 14.2 Rewrite or reorganize
- collapsed init configuration
- engine single-pass orchestration
- phase-text HUD language
- publication too tightly coupled to processing pass
- insufficiently explicit nervous-system state
- mixed feature activation too early

### 14.3 Do not carry forward
- “enable everything at init and hope”
- summary publication before safe current symbol files
- UI as a logic owner
- giant later-stage assumptions before the kernel is real

## 15. Final acceptance of the entire EA

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
