# 02 ASC Stage Execution Plan

## 1. Purpose

This file is the lean implementation roadmap for ASC after refoundation.
It translates blueprint law into execution order without becoming runtime law itself.

Each stage below must be completed in order.
A later stage may refine an earlier stage, but may not assume it already exists.

---

## 2. Stage execution model

Every stage must contain five things:
1. objective
2. required runtime outcomes
3. explicit non-goals
4. minimum checks
5. retirement target from the contradiction register

---

## 3. Stage A — Shared runtime constitution

### Objective
Create the canonical shared vocabulary and DTO shell required by all later stages.

### Required runtime outcomes
- canonical enums for runtime mode, continuity origin, hydration state, publish state, service class, service outcome, lifecycle state, and recheck class
- canonical record blocks for identity, Layer 1, Layer 1.2, surface, promotion, deep, continuity, and publication
- canonical reason-code vocabulary
- canonical schema/version constants

### Explicit non-goals
- no discovery logic
- no live ranking
- no deep history logic
- no trader summary logic

### Minimum checks
- one shared vocabulary only
- no duplicate enum drift
- no old phase/wave wording leaking into product-facing names

### Retires
- prerequisite for every open contradiction

---

## 4. Stage B — Kernel, mode shell, and restore shell

### Objective
Build the real nervous-system shell.

### Required runtime outcomes
- heartbeat timer orchestration
- re-entry guard and skip accounting
- runtime modes including `RECOVERY_HOLD`
- runtime snapshot/read-model shell
- due-service registry shell
- budget shell and coverage-debt shell
- cursor persistence shell
- write-journal inspection shell
- restore compatibility classification shell

### Explicit non-goals
- no full market-truth implementation
- no ranking
- no deep enrichment

### Minimum checks
- repeated timer calls do not stack re-entry
- restore runs before fill
- corrupt or incomplete journal state is reported honestly
- paused mode and recovery-hold mode are visible in runtime state

### Retires
- C1 partially
- C2 partially
- C5 partially

---

## 5. Stage C — Universe continuity and identity merge

### Objective
Implement whole-universe continuity without shrink collapse.

### Required runtime outcomes
- current broker discovery intake
- merge with restored universe membership
- disappearance observation state
- identity continuity blocks per symbol
- unresolved classification visibility policy
- unknown/custom/synthetic explicit handling

### Explicit non-goals
- no market-open scoring beyond identity prerequisites
- no ranking authority

### Minimum checks
- symbols are not lost because discovery was partial
- symbol rename/mapping conflicts are explicit
- unresolved classification stays visible, not guessed

### Retires
- C6 partially

---

## 6. Stage D — Layer 1 market truth and recheck classes

### Objective
Implement truthful active-competition eligibility.

### Required runtime outcomes
- quote/tick/session triple confirmation
- explicit Layer 1 outcomes
- recheck class assignment
- fastlane retry ladder
- pending expiry/escalation ownership
- next recheck and next expected open stamping

### Explicit non-goals
- no summary generation
- no deep persistence

### Minimum checks
- closed is not inferred from one coarse signal
- stale, no-quote, disabled, unknown, and quote-only remain distinct
- every known symbol reaches explicit Layer 1 ownership

### Retires
- C2 further
- C6 further

---

## 7. Stage E — Layer 1.2 broker snapshot continuity

### Objective
Implement minimum snapshot truth for the whole universe.

### Required runtime outcomes
- broker field-family intake
- suspicious-zero handling
- snapshot freshness clocks
- partial-read explicit markers
- broker-universe shrink protection
- minimum universe dump schema shell

### Explicit non-goals
- no ranking logic yet
- no promotion
- no deep layer

### Minimum checks
- zero vs missing vs unreadable are distinct
- full-universe continuity survives restart
- bounded refresh cannot silently shrink prior valid universe state

### Retires
- C5 further
- C6 further

---

## 8. Stage F — Atomic publication shell and runtime state commit

### Objective
Separate truth mutation from commit.

### Required runtime outcomes
- class A atomic commit flow
- write journal and recovery handling
- symbol-file commit shell
- universe-dump commit shell
- runtime-state commit shell
- publish gating matrix
- summary-last placeholder shell

### Explicit non-goals
- no final trader summary ranking output
- no final HUD design

### Minimum checks
- interrupted write cannot destroy last good final file
- pending-safe symbol files can publish honestly
- summary is still blocked until later prerequisites exist

### Retires
- C3 materially
- C5 materially

---

## 9. Stage G — Layer 2 surface competition

### Objective
Implement cheap broad competition every 10 minutes.

### Required runtime outcomes
- score family computation
- penalty family
- bucket-relative ranking
- score normalization
- bucket quality floors
- smaller-than-five bucket honesty

### Explicit non-goals
- no deep promotion churn logic beyond prerequisites
- no final trader HUD

### Minimum checks
- weak quiet symbols do not win on spread alone
- stale or weak-truth symbols are penalized hard
- `UNKNOWN` bucket remains explicit and policy-bounded

### Retires
- C2 functionally for Layer 2
- C6 materially

---

## 10. Stage H — Promotion, hysteresis, and demotion freeze

### Objective
Convert ranking output into bounded deep-budget rights safely.

### Required runtime outcomes
- promoted-set persistence
- deterministic tie fallback
- hysteresis band
- hold-period law
- demotion freeze transitions
- near-promoted allowance logic

### Explicit non-goals
- no full deep engine yet

### Minimum checks
- promotion boundary does not thrash on tiny score moves
- demoted symbols preserve frozen deep continuity honestly
- summary authority is not allowed to invent promotion outside ranking truth

### Retires
- C6 fully at promotion boundary

---

## 11. Stage I — Layer 3 deep rolling continuity

### Objective
Implement bounded deep context for promoted symbols only.

### Required runtime outcomes
- tick window store
- OHLC rings by timeframe family
- ATR and approved indicator families
- regime/environment blocks
- deep freshness clocks
- frozen-state preservation and thaw path

### Explicit non-goals
- no Aurora logic
- no execution logic

### Minimum checks
- no full-universe deep scan
- no blind recompute when no new bar exists
- promoted symbols do not starve broad runtime coverage

### Retires
- remaining runtime-spine incompleteness around deep layer

---

## 12. Stage J — Final operator/trader surfaces

### Objective
Publish truthful visibility surfaces without logic ownership.

### Required runtime outcomes
- operator HUD from runtime read model
- trader HUD from published/trader-safe read model
- bounded operator actions that enqueue work only
- product-language cleanup of all live strings

### Explicit non-goals
- no runtime logic embedded in redraw
- no filesystem crawling HUD behavior

### Minimum checks
- HUD shows known/pending/stale/frozen/degraded honestly
- trader HUD remains concise
- operator HUD remains operational rather than theatrical

### Retires
- C4 fully

---

## 13. Stage K — Degraded mode, recovery hold, retention hardening

### Objective
Finish the runtime as an operationally safe system.

### Required runtime outcomes
- sustained degraded-mode actions
- recovery-hold transitions and exits
- stale continuity rejection policy
- disappearance retention and archival removal policy
- cleanup and backup retention rules
- performance/debt telemetry hardening

### Explicit non-goals
- no new product scope

### Minimum checks
- runtime stays honest under pressure
- recovery hold blocks unsafe optimism
- no symbol is silently forgotten due to retention shortcuts

### Retires
- remaining open contradiction debt

---

## 14. Acceptance law for all stages

A stage is accepted only when all are true:
- blueprint obligations for that stage are satisfied
- contradiction targets listed for that stage are retired or explicitly narrowed
- tests/checks prove the stage runs
- runtime state explains the stage honestly
- no forbidden later-stage assumptions were introduced
- no Aurora scope leaked in

---

## 15. Final execution definition

ASC implementation is now considered correctly planned only if work follows this sequence:
- constitution
- kernel/restore
- universe continuity
- Layer 1
- Layer 1.2
- atomic publication shell
- Layer 2
- promotion/freeze
- Layer 3
- final UI
- degraded/recovery/retention hardening

Any attempt to skip this order should be treated as refoundation drift.
