# ASC Implementation Master Plan

## 1. Purpose

This is the master implementation plan for ASC after refoundation.
It is the office copy of the staged build plan we will work from.

This file exists so implementation can begin from a clear, test-gated order instead of falling back into old collapsed workflows.

The rule is simple:
- build the lowest layer first
- test it hard
- prove it
- only then unlock the next layer

---

## 2. Current phase position

ASC is currently at:
- blueprint canon complete
- office planning canon established
- live clean `mt5/` rebuild not yet started
- ready to start from the first implementation foundation only

This means ASC is **not** in higher-phase implementation yet.
It is in **foundation-start readiness**.

---

## 3. Phase law

No phase may jump ahead.
No phase may pretend later truth already exists.
No phase may use HUD/output to stand in for missing runtime behavior.

A phase is complete only when:
- the code for that phase exists
- the runtime behavior is visible and honest
- the failure cases were tested
- restart continuity still behaves safely
- the next phase no longer depends on invention

---

## 4. Canonical implementation phases

## Phase 0 — Shared runtime constitution

### Build
- canonical enums
- DTOs / record blocks
- reason codes
- lifecycle vocabulary
- hydration vocabulary
- runtime mode vocabulary
- continuity-origin vocabulary
- publish-state vocabulary
- schema/version constants

### Why first
Because every later phase depends on stable language and state ownership.

### Test before moving on
- one shared vocabulary only
- no duplicate enum drift
- no dev/workflow names leaking into runtime/product names

### Exit rule
Do not begin the kernel until this language layer is stable.

---

## Phase 1 — Kernel, restore, and runtime shell

### Build
- timer heartbeat
- re-entry guard
- runtime modes
- due-service registry shell
- budget/debt shell
- cursor shell
- runtime-state shell
- journal inspection shell
- restore shell
- paused/degraded/recovery-hold shell

### Why now
Because old systems repeatedly failed when work was enabled before the nervous system existed.

### Test this phase
- repeated timers do not overlap
- restore runs before fill
- empty restore is honest
- corrupt restore/journal state is honest
- paused mode remains alive
- recovery-hold is visible
- runtime-state output explains actual mode and cycle truth

### Exit rule
Do not begin universe/identity work until this shell is proven stable.

---

## Phase 2 — Universe continuity and identity

### Build
- broker universe discovery
- restore merge with known universe
- identity continuity blocks
- raw/normalized/canonical symbol handling
- unresolved classification visibility
- disappearance observation shell

### Why now
Because all later truth depends on stable whole-universe continuity.

### Test this phase
- clean startup discovery
- merge with restored universe
- partial discovery does not shrink the universe
- rename/mapping conflicts stay explicit
- unresolved classification stays visible
- disappeared symbols do not vanish instantly

### Exit rule
Do not begin Layer 1 until known-universe continuity is trustworthy.

---

## Phase 3 — Layer 1 market truth

### Build
- quote/tick/session triple confirmation
- explicit Layer 1 outcomes
- recheck classes
- fastlane retry ladder
- pending-state ownership
- next recheck / next expected open logic

### Why now
Because ranking and publication are worthless if present-open truth is weak or guessed.

### Test this phase
- `OPEN_TRADABLE`
- `CLOSED_SESSION`
- `QUOTE_ONLY`
- `TRADE_DISABLED`
- `NO_QUOTE`
- `STALE_FEED`
- `UNKNOWN`
- just-open transitions
- crypto-like 24/7 edge cases
- stock-like stale off-session quote cases

### Exit rule
Do not begin Layer 1.2 completion work beyond shell-level helpers until every known symbol can reach explicit Layer 1 ownership.

---

## Phase 4 — Layer 1.2 broker snapshot

### Build
- minimum broker snapshot intake
- suspicious-zero handling
- explicit missing/unreadable markers
- field-family freshness clocks
- shrink protection
- minimum universe dump shell

### Why now
Because ranking without stable broker/spec truth recreates the old false-confidence trap.

### Test this phase
- zero vs missing vs unreadable
- partial spec reads
- dynamic trade mode changes
- disappear/return behavior
- restore continuity of snapshot truth
- bounded refresh cannot shrink prior valid universe state

### Exit rule
Do not begin publication shell until snapshot continuity is safe.

---

## Phase 5 — Atomic publication shell

### Build
- Class A atomic commit flow
- temp/backup/final replacement flow
- write journal
- runtime-state commit
- pending-safe symbol commit
- universe dump commit
- summary-last gating shell

### Why now
Because old lineage repeatedly proved that publication safety must exist before higher-level output authority.

### Test this phase
- interrupted write
- corrupt temp
- restart after mid-commit crash
- last-good preservation
- pending-safe symbol publication
- summary blocked until upstream truth is safe

### Exit rule
Do not begin Layer 2 ranking until commit safety is proven.

---

## Phase 6 — Layer 2 surface competition

### Build
- score families
- penalty family
- bucket-relative comparison
- normalization
- quality floors
- smaller-than-five bucket honesty

### Why now
Because ranking is a consumer of lower truth, not a substitute for it.

### Test this phase
- quiet cheap symbols do not dominate
- fast garbage symbols do not dominate
- stale/weak names sink appropriately
- thin buckets publish fewer than five
- `UNKNOWN` bucket remains explicit
- tiny score noise does not create obvious churn

### Exit rule
Do not begin promotion/deep rights until Layer 2 is stable.

---

## Phase 7 — Promotion and freeze model

### Build
- promoted-set persistence
- deterministic tie-breaks
- hysteresis
- hold-period logic
- demotion freeze transitions
- near-promoted allowance logic

### Why now
Because Layer 3 must be budget-authorized, not implied.

### Test this phase
- promotion stability
- oscillation at the boundary
- promoted symbol closing
- promoted symbol degrading
- demotion preserves frozen deep continuity

### Exit rule
Do not begin Layer 3 until promotion rights are real and stable.

---

## Phase 8 — Layer 3 deep rolling continuity

### Build
- bounded tick window
- OHLC rings
- ATR families
- approved indicator families
- regime/environment blocks
- deep freshness clocks
- frozen/thaw behavior

### Why now
Because only now do promoted symbols legitimately own deep budget.

### Test this phase
- no full-universe deep scan
- no blind recompute when no new bar exists
- new-bar-only behavior where required
- thin history handling
- demotion freeze behavior
- promoted set does not starve broad runtime coverage

### Exit rule
Do not begin final UI until deep truth exists and is bounded.

---

## Phase 9 — Final UI surfaces

### Build
- operator HUD
- trader HUD
- bounded menu/operator actions
- read-model-only display surfaces

### Why last
Because the archive repeatedly shows UI creep and logic leakage when HUD appears too early.

### Test this phase
- no heavy compute in redraw
- no filesystem crawling in HUD
- trader HUD remains concise
- operator HUD shows health honestly
- no dev/workflow language reaches product surfaces

### Exit rule
Do not treat ASC as complete until hardening is done.

---

## Phase 10 — Hardening

### Build
- degraded mode behavior
- recovery-hold behavior
- retention rules
- disappearance cleanup rules
- performance/debt telemetry hardening
- restart/recovery hardening

### Test this phase
- runtime remains honest under pressure
- recovery-hold blocks unsafe optimism
- no symbol is silently forgotten

---

## 5. Immediate next implementation move

The next allowed implementation move is:
1. Phase 0
2. Phase 1

Meaning:
- shared runtime constitution
- kernel/restore/runtime shell

Nothing higher should begin first.

---

## 6. What must not start now

Do not start now with:
- summary polish
- trader HUD polish
- ranking refinement
- deep analytics
- promotion tuning
- Aurora integration
- wrapper planning

Those are too high.

---

## 7. Final instruction

Work from this plan.
Do not jump upward.
Do not treat a higher layer as allowed because documents for it exist.
Only proven lower truth unlocks higher implementation.
