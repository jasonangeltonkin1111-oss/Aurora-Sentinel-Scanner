# ASC Stage Board

## 1. Purpose

This is the live stage board for ASC implementation.
It should stay simple and current.
It exists so anyone entering the repo can immediately answer:
- what phase ASC is in
- what is allowed next
- what is blocked next
- what must be tested before advancing

---

## 2. Current status

### Current overall status
- ASC blueprint refoundation: COMPLETE
- ASC office normalization: COMPLETE
- clean live `mt5/` rebuild: NOT STARTED

### Current implementation phase
- **READY TO START PHASE 0 / PHASE 1**

### Current allowed work
- shared runtime constitution
- kernel/restore/runtime shell

### Current blocked work
- Layer 1 implementation beyond shell dependencies
- Layer 1.2 implementation beyond shell dependencies
- ranking
- promotion
- Layer 3 deep work
- final UI
- hardening

---

## 3. Phase board

## Phase 0 — Shared runtime constitution
Status: READY

Entry:
- blueprint refoundation complete
- office plan in place

Exit:
- enums/DTOs/reason vocabulary stable
- no naming drift
- no product-surface workflow wording

## Phase 1 — Kernel, restore, and runtime shell
Status: READY AFTER PHASE 0

Entry:
- Phase 0 stable

Exit:
- heartbeat works
- re-entry guard works
- restore runs before fill
- runtime modes visible
- runtime-state shell honest
- paused/degraded/recovery-hold shell visible

## Phase 2 — Universe continuity and identity
Status: BLOCKED UNTIL PHASE 1 PROVEN

Exit:
- whole-universe merge stable
- no shrink collapse
- identity continuity stable
- disappearance shell exists

## Phase 3 — Layer 1 market truth
Status: BLOCKED UNTIL PHASE 2 PROVEN

Exit:
- explicit Layer 1 outcomes
- recheck ownership
- fastlane ownership
- pending ownership

## Phase 4 — Layer 1.2 broker snapshot
Status: BLOCKED UNTIL PHASE 3 PROVEN

Exit:
- minimum snapshot truth stable
- suspicious-zero handling stable
- shrink protection stable

## Phase 5 — Atomic publication shell
Status: BLOCKED UNTIL PHASE 4 PROVEN

Exit:
- atomic commits stable
- journal checks stable
- pending-safe symbol publication stable
- summary-last gating stable

## Phase 6 — Layer 2 surface competition
Status: BLOCKED UNTIL PHASE 5 PROVEN

Exit:
- score families stable
- penalty system stable
- bucket honesty stable

## Phase 7 — Promotion and freeze model
Status: BLOCKED UNTIL PHASE 6 PROVEN

Exit:
- promoted-set stability
- hysteresis stable
- freeze model stable

## Phase 8 — Layer 3 deep rolling continuity
Status: BLOCKED UNTIL PHASE 7 PROVEN

Exit:
- bounded deep continuity stable
- no full-universe deep overload

## Phase 9 — Final UI surfaces
Status: BLOCKED UNTIL PHASE 8 PROVEN

Exit:
- operator HUD truthful
- trader HUD truthful
- read-model-only display surfaces

## Phase 10 — Hardening
Status: BLOCKED UNTIL PHASE 9 PROVEN

Exit:
- degraded mode stable
- recovery-hold stable
- retention and cleanup stable

---

## 4. Current contradiction targets

The first implementation passes should explicitly target:
- C1 init too feature-heavy
- C2 runtime collapsed into one pass
- C5 restore-first not yet embodied as a full runtime constitution

These are the correct first targets because they sit at the bottom of the stack.

---

## 5. Advancement law

A phase may advance only when:
- the implementation exists
- runtime behavior was tested
- failure cases were tested
- restart continuity remained honest
- the next phase no longer depends on invention

If any of those fail, the phase is not complete.
