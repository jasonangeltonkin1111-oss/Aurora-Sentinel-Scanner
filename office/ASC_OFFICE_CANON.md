# ASC Office Canon

## 1. Purpose

This file is the single control constitution for ASC implementation.
It replaces the need to recover implementation intent from many scattered office files.

This office layer must stay:
- small
- canonical
- explicit
- stage-gated
- separate from blueprint law

This file defines:
- what belongs in office
- what belongs in `mt5/`
- what the active implementation target is
- what contradictions remain open
- how stages are approved
- how handoff and review should work

---

## 2. Folder law

### 2.1 `ASC Blueprint/`
Purpose:
- define how ASC must behave at runtime
- define architecture, runtime spine, persistence, ranking, publication, and acceptance law

### 2.2 `office/`
Purpose:
- define build sequence
- define current implementation status
- define contradiction tracking
- define review and handoff law
- define which stage is allowed next

### 2.3 `mt5/`
Purpose:
- hold the future live ASC product code only

Allowed content:
- `.mq5`
- `.mqh`

Not allowed:
- planning documents
- handoff files
- review notes
- design memos
- temporary office clutter

### 2.4 `archives/`
Purpose:
- preserve lineage and provenance
- support translation into modern ASC form

It is not active product code.
It is not active office canon.

---

## 3. Office design rules

### 3.1 Keep file count small
The office layer must remain intentionally small.
Preferred pattern:
- one office constitution
- one implementation master plan
- one stage board

Do not recreate:
- wave files for every change
- many overlapping HQ state files
- duplicated handoff notes at the root
- dozens of narrow control documents

### 3.2 Prefer large canonical documents
When office truth matters, prefer:
- one strong complete file
instead of:
- many tiny partial files

### 3.3 Blueprint and office must remain separate
Blueprint says:
- how the EA works

Office says:
- how implementation proceeds safely

Office must not redefine runtime law.
Blueprint must not become cluttered with workflow control language.

---

## 4. Active ASC target

The active target is now:
- ASC only
- scanner EA runtime only
- no Aurora doctrine
- no wrapper planning
- no strategy layer
- no execution system

The immediate goal is not feature breadth.
The immediate goal is correct staged implementation.

---

## 5. Current repo state

ASC should currently be considered:
- refoundation complete in blueprint form
- office layer normalized enough to guide implementation
- not yet rebuilt as a clean staged MT5 runtime
- ready to begin implementation from the lowest approved stage only

This means:
- architecture truth is ahead of implementation truth
- implementation must begin from foundation rather than jumping to higher layers

---

## 6. Archive translation law

Before using archive material, classify it as one of:
- **PRESERVE**
- **ADAPT**
- **REJECT**

### 6.1 Preserve
Keep the principle directly, translated into ASC language.

### 6.2 Adapt
Keep the truth but reshape the implementation or product wording.

### 6.3 Reject
Keep only as warning/provenance. Do not carry into the active design.

### 6.4 Current lineage decisions
#### AFS
Preserve:
- heartbeat-first thinking
- staged rotation
- summary-last discipline
- HUD honesty
- pending/stale/weak distinctions

Adapt:
- dossier model into canonical symbol continuity files
- dev/trader HUD split into modern operator/trader surfaces

Reject:
- broad HUD sprawl
- downstream theater and overgrown control language

#### EA1
Preserve:
- timer-first runtime
- separate snapshot-path and tick-history path
- bounded cursors
- restore-first continuity

Adapt:
- historical runtime cadence ideas into ASC service families

Reject:
- old narrow-slice assumptions as final ASC architecture

#### ISSX
Preserve:
- kernel/service-class thinking
- budget and fairness surfaces
- degraded-mode honesty
- resumable runtime state
- publication reserve / critical commit thinking

Adapt:
- ISSX stage-heavy naming into ASC layer/service naming

Reject:
- raw ISSX system sprawl and direct transplantation

#### Archived ASC office
Preserve:
- stage-gated implementation discipline
- archive reference discipline
- separation of blueprint vs office vs mt5

Adapt:
- many legacy office docs into a few canonical files

Reject:
- office sprawl
- wave packet clutter as the primary planning system

---

## 7. Current contradiction register

These contradictions remain the active implementation control targets.

### C1. Init is still too feature-heavy in the archived MT5 implementation
Observed:
- init enables too many later-stage surfaces early
- configuration and runtime scope are too broad too soon

Required outcome:
- shell-first init only
- later-stage activation only after lower stages exist

### C2. Runtime is still collapsed into one broad pass in archived MT5
Observed:
- restore, discovery, truth fill, surface work, save, and publication happen too close together

Required outcome:
- kernel-owned due-service runtime
- separated runtime phases and commit phases

### C3. Publication remains too near in-progress truth mutation
Observed:
- publication still behaves like part of the processing pass

Required outcome:
- publication becomes its own due service
- symbol-first, summary-last commit discipline

### C4. HUD/menu shape still leaks build/control thinking
Observed:
- runtime/UI language still behaves too much like a control rail

Required outcome:
- operator HUD = runtime health truth
- trader HUD = shortlist truth
- neither HUD owns logic

### C5. Restore-first exists conceptually but not as a full runtime constitution
Observed:
- restore is present in spirit, but journal/compatibility/recovery-hold law is not yet embodied in clean live code

Required outcome:
- restore shell, compatibility checks, journal checks, and recovery-hold become first-class runtime behavior

### C6. Whole-universe, promoted-set, and summary boundaries are still easy to blur
Observed:
- older systems repeatedly blurred universe truth, active shortlist truth, and publication truth

Required outcome:
- explicit separate runtime objects and publication roles for:
  - universe
  - Layer 2 eligible set
  - promoted set
  - summary shortlist

### C7. Office clutter can return if not actively controlled
Observed:
- the archive shows repeated document multiplication around continuity, handoff, and wave control

Required outcome:
- keep office to the canonical file set only unless a new large canonical document is truly needed

---

## 7.5 Final sweep checklist

Before implementation begins, office must confirm all of these are explicitly covered somewhere in blueprint + office canon:
- runtime modes
- restore-first law
- write-journal and crash recovery
- whole-universe continuity
- Layer 1 explicit outcome classes
- Layer 1.2 minimum broker snapshot
- coverage debt and cycle debt
- fastlane retry ownership
- promotion hysteresis
- demotion freeze
- symbol disappearance handling
- summary quality floors
- operator/trader HUD separation
- product-language boundary
- stage-gated implementation and testing

If a feature is important but only implied, office must treat it as missing until canon makes it explicit.

## 7.6 Feature return map

The restored feature families should return to implementation in this order:
1. nervous-system safety
2. continuity safety
3. whole-universe truth
4. publication safety
5. Layer 2 competition
6. promotion/freeze behavior
7. Layer 3 depth
8. final visibility surfaces

This prevents “bringing features back” from turning into another higher-layer collapse.

---

## 8. What must be in office besides the plan

To stay clear without becoming messy again, office should hold only these kinds of large canonical documents:

### A. Office constitution
One file that defines:
- folder law
- source order
- contradiction register
- archive use law
- review/handoff rules

That is this file.

### B. Implementation master plan
One file that defines:
- build order
- exact stage sequence
- what to test before moving forward
- why higher stages are blocked until lower stages are proven

### C. Stage board
One file that defines:
- current stage
- current allowed next stage
- entry criteria
- exit criteria
- status of each stage

That is enough for now.

Do not add separate files yet for:
- reviews
- handoffs
- HQ state
- recovery state
- release state
unless the implementation later becomes deep enough that a new canonical large file is truly justified.

---

## 9. Source order for implementation work

Use source authority in this order:
1. `ASC Blueprint/README.md`
2. `ASC Blueprint/01_ASC_SYSTEM_BLUEPRINT.md`
3. `ASC Blueprint/02_ASC_RUNTIME_NERVOUS_SYSTEM.md`
4. `ASC Blueprint/03_ASC_DATA_PERSISTENCE_AND_PUBLICATION.md`
5. `ASC Blueprint/04_ASC_SURFACE_RANKING_AND_DEEP_ENRICHMENT.md`
6. `ASC Blueprint/05_ASC_BUILD_STAGES_AND_ACCEPTANCE.md`
7. `ASC Blueprint/06_ASC_REFOUNDATION_AUDIT_AND_RUNTIME_CANON.md`
8. this office file
9. `office/ASC_IMPLEMENTATION_MASTER_PLAN.md`
10. `office/ASC_STAGE_BOARD.md`
11. `archives/` as translated lineage evidence only

---

## 10. Review and handoff law

### 10.1 Every implementation stage must prove
- what blueprint law it satisfies
- what contradiction(s) it retires
- what runtime truths became real
- what remains intentionally incomplete
- what tests were run
- what failure cases were exercised

### 10.2 Handoff style
Handoffs should remain compact and structured inside the stage board or PR summary.
Do not create a new office document for every handoff by default.

### 10.3 Review focus
Review must look for:
- layer collapse
- hidden higher-stage assumptions
- UI taking logic ownership
- publication bypassing validation order
- restart dishonesty
- symbol amnesia
- archive import without translation
- office sprawl returning

---

## 11. Final office definition

The office layer is correct only when:
- it keeps blueprint and planning separate
- it keeps file count small
- it makes the next allowed stage obvious
- it records contradictions explicitly
- it stops premature jumps to higher layers
- it keeps `mt5/` clean for code only
