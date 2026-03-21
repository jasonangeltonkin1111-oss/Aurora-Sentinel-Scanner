# Task Board

## Current repo posture

- active blueprint canon exists and remains the authoritative ASC design surface, and its identity/bucketing wording is now aligned to current runtime truth
- flat MT5 foundation exists and remains the active runtime surface
- office normalization is active and now needs stricter task/state/ledger discipline
- Market State Detection remains the only fully working capability
- standalone classification and dynamic bucket generation are now active but still provisional; prepared bucket truth now exists for Layer 1 explorer use and must stay runtime-owned
- Explorer HUD is materially advanced, but it still violates the intended ownership boundary by rebuilding bucket truth in explorer-side code paths
- debug observability for prepared buckets/HUD is now active as a debug-only lane and must stay threshold-based rather than becoming normal-log spam
- ASC-to-Aurora separation remains structurally good and must be preserved while upstream scanner truth is hardened
- ranking, shortlist, strategy logic, execution logic, and account logic remain blocked

## Mandatory control laws

### Version bump law
Every meaningful repo pass must bump version.
- code-facing meaningful pass: bump `ASC_WRAPPER_VERSION`
- explorer/HUD-facing meaningful pass: bump `ASC_EXPLORER_SUBSYSTEM_VERSION`
- documentation / office-only pass that changes active control truth: still record the intended version discipline in `WORK_LOG.md`, and if runtime-facing files are changed in the same pass, bump the active version constants too
- patch bump = non-breaking fix / hardening
- minor bump = meaningful subsystem expansion or reshaping
- major bump = architecture revision only

### SHA ledger law
When any tracked file is added or changed in a meaningful pass:
- update `office/SHA_LEDGER.md`
- refresh hashes for every changed tracked file
- add newly tracked files when they become active control, blueprint, or runtime truth
- do not leave the SHA ledger stale after a committed pass

### Fault-finding law
Every active pass must include a sweep for:
- drift between blueprint and runtime
- drift between work log claims and repo truth
- stale placeholder language that no longer matches active implementation
- ownership leakage from runtime into explorer/HUD
- provisional behavior being described as complete
- version / ledger discipline failures

Do not treat “recent” as “correct”.
Do not continue building on unresolved contradiction.

## Repo state by stream

| STREAM | STATUS | MATURITY | CURRENT TRUTH | NEXT REQUIRED ACTION |
|---|---|---:|---|---|
| Office control | ACTIVE | 70% | compact office exists but task/state mapping is too shallow for current repo complexity | deepen task board, tighten stage ledger honesty, keep work log and SHA ledger in lockstep |
| Blueprint canon | ACTIVE | 80% | strong ownership laws exist and identity/bucketing wording now reflects active-but-provisional runtime truth with runtime-prepared, explorer-consumed Layer 1 bucket surfaces | keep canon aligned as architecture hardening continues |
| Foundation runtime | ACTIVE | 84% | heartbeat, fairness, persistence, dossier publication, continuity, and Layer 1 readiness gating are structurally strong, but warmup exit now needs explicit readiness-field doctrine instead of dossier-missing gating assumptions | keep stable while readiness wording and persistence stay aligned |
| Market State Detection | WORKING | 88% | still the only fully working capability with real runtime truth | compile/test re-verify after any structural runtime change |
| Classification catalog | ACTIVE-PROVISIONAL | 55% | standalone classification exists and drives buckets, but catalog quality is mixed and some mappings are too broad or wrong | audit classification truth before treating bucket output as trusted |
| Dynamic buckets | ACTIVE-PROVISIONAL | 64% | membership is live/classification-driven, with the first operator surface compressed into six Layer 1 main buckets and now promoted through rolling prepared-state batches that carry explicit working, last-good, pending, and reuse markers; deeper stock taxonomy still remains metadata-grade and incomplete | harden batch reuse, verify compile/runtime behavior in MT5, and keep richer stock metadata out of fake first-class bucket claims |
| Explorer HUD | ACTIVE-FRAGILE | 52% | advanced navigation and layout exist, but render/delete churn and bucket recompute-in-render are still architectural faults | fix ownership boundary first, then performance, then behavior/layout polish |
| Dossiers and summary | ACTIVE | 79% | atomic publication and scaffold output now states identity/bucketing is active-but-provisional, Layer 1 prepared bucket truth is active, and later capabilities remain reserved | keep publication wording aligned if runtime ownership changes again |
| ASC ⇄ Aurora bridge | ACTIVE | 80% | separation is still good and future insertion points remain preserved | preserve boundary while tightening upstream truth discipline |
| Deep intelligence | BLOCKED | 0% | not allowed to activate yet | keep blocked |
| Trade / account logic | BLOCKED | 0% | not part of ASC foundation | keep blocked |

## What is complete enough to preserve

### Keep stable
- runtime continuity save/load
- scheduler continuity save/load
- dossier atomic publication discipline
- market-state scheduling ownership
- degraded/backlog observability
- ASC-to-Aurora reserved insertion points
- server-scoped path identity

These must not be destabilized while fixing explorer and classification problems.

## What is half-done

### 1. Blueprint hardening
Half-done because:
- modern ownership laws exist
- active docs now describe identity/bucketing as active-but-provisional, but that wording still needs to stay synchronized with runtime ownership changes

Still needed:
- keep blueprint sections synchronized with runtime ownership and publication wording
- preserve classification/bucketing as active-but-provisional without overstating trust
- keep runtime-prepared snapshot law explicit for bucket truth

### 2. Classification activation
Half-done because:
- classification is active and standalone
- but quality control is not yet strong enough to trust all resulting memberships

Still needed:
- audit active classification catalog versus researched source
- identify wrong / over-broad equity mappings
- distinguish high-confidence from provisional mappings where needed

### 3. Dynamic bucket architecture
Half-done because:
- buckets are no longer pure placeholders
- but the explorer still prepares bucket truth instead of only consuming it

Still needed:
- introduce runtime-owned bucket state / snapshot / adapter structure
- stop building full bucket models in render and click handlers
- expose only prepared bucket truth to explorer

### 4. Explorer HUD
Half-done because:
- layout/navigation/paging/filtering are materially advanced
- Layer 1 warmup and background hydration truth is now surfaced explicitly
- but render churn, full object recreation, and recompute-in-render remain unresolved

Still needed:
- reduce delete/recreate churn
- separate render from data preparation
- retest page fit, clipping, rail fit, and bucket detail honesty after ownership fix

### 5. Repo control discipline
Half-done because:
- work log and SHA ledger exist
- but task/state mapping is too shallow and fault-finding is not embedded as a standing rule

Still needed:
- maintain a real execution map here
- update working stage ledger to reflect current explorer reality honestly
- keep SHA ledger synced every meaningful pass

## What is wrong or fragile now

### Structural faults
1. rolling prepared-state ownership is now runtime-side with explicit working/last-good/pending/reuse markers, but unchanged-batch reuse is still scope-grade rather than diff-driven and remains runtime-memory-only
2. render path still deletes and recreates all owned chart objects
3. bucket truth can still look more mature than it really is because classification quality is mixed
4. stock taxonomy enrichment is still metadata-only and not yet a deeper snapshot surface
5. blueprint/runtime/publication wording can still drift if office files are not kept aligned

### Behavior faults to verify and fix
1. Home vs Overview redundancy
2. dead or low-value rail actions
3. bucket page explosion from granularity / page fit / both
4. bucket detail still needing to expose preserved stock-region metadata without turning it into first-class main pages
5. stat/symbol flows depending too heavily on explorer-side rebuilding

## Required fault-finding sweep on every pass

Before closing any future pass, explicitly check:

### Repo-truth sweep
- did any active doc become stale because of the code change?
- did any work log claim overstate maturity?
- did any placeholder wording become false?

### Ownership sweep
- did runtime compute more truth or did explorer compute it?
- did a click/render path gain data preparation work?
- did HUD start crawling files, rebuilding classifications, or walking the full universe?

### Version / ledger sweep
- was version bumped where required?
- were changed tracked files re-hashed in `office/SHA_LEDGER.md`?
- was the work log updated?
- does this board still reflect repo truth after the pass?

## Recommended next implementation order

1. office control hardening
2. blueprint/runtime wording alignment
3. runtime-owned bucket snapshot architecture
4. explorer/HUD performance correction
5. classification catalog truth audit
6. HUD behavior/layout refinement
7. compile/test pass
8. only then consider deeper identity/snapshot expansion
9. much later: Open Symbol Snapshot promotion
10. later still: Candidate Filtering / Shortlist / Aurora downstream work

## Layer 2 posture guardrail

- **Layer 2 preparation ready:** reserved runtime structs, status markers, publication slots, and mirrored cadence inputs may exist now so Open Symbol Snapshot can be inserted later without renaming churn.
- **Layer 2 activation blocked:** no live snapshot compute, no history pulls, no broad open-symbol refresh loop, and no dossier/runtime wording may describe Layer 2 as active behavior.

## Immediate next tasks

### Immediate task group A — office and control truth
1. expand this task board into the standing control map for all active work
2. update `office/WORKING_STAGE_LEDGER.md` so explorer ownership problems are described honestly
3. append a work-log entry for this office-control / HQ continuity hardening pass
4. refresh `office/SHA_LEDGER.md`
5. keep office compact; do not create more root office files unless a truly new long-lived role exists

### Immediate task group B — blueprint truth correction
1. keep blueprint wording aligned with runtime when identity/bucketing posture changes again
2. keep Market State Detection as the only fully working capability
3. preserve classification and dynamic buckets as active but provisional
4. preserve runtime-prepared bucket truth and explorer-consumed snapshot law explicitly

### Immediate task group C — runtime / explorer architecture
1. preserve runtime-owned Layer 1 warmup threshold and background hydration truth using compressed-priority-bucket promotion plus configurable first-pass symbol coverage
2. harden the new runtime-owned rolling prepared-state scaffold and batch reuse markers
3. verify explorer render/click paths stay consumer-only against promoted last-good state
4. reduce full chart-object delete/recreate churn where feasible
5. keep explorer presentation-only after the refactor
6. persist compact Layer 1 readiness continuity in runtime state, including total discovered, initial assessed, compressed-primary-ready, warmup minimum, background completion, and readiness percent

### Immediate task group D — classification truth
1. compare active ASC classification to researched AFS source
2. isolate clearly wrong stock mappings
3. tighten sectors/themes/industries where over-broad
4. keep unresolved symbols outside claimed bucket truth until safely classified

### Immediate task group E — testing and evidence
1. after any structural runtime change, test in MT5 / MetaEditor
2. verify compile status
3. verify startup / restore / heartbeat / dossier / summary behavior
4. verify HUD responsiveness and bucket behavior using uploaded logs/results
5. verify the debug observability lane in debug verbosity: prep summary threshold lines, render/page-switch threshold lines, warmup transition reasons, unchanged-batch rewrite signals, last-good preservation, Open Only visibility anomalies, and bounded-work severity buckets
6. prefer testing after ownership fixes before more visual polishing

## Blocking rules

Do not open:
- ranking
- basket selection logic beyond truthful bucket membership display
- strategy logic
- trading logic
- account logic
- past-trade logic
- fake Aurora intelligence inside ASC runtime

until:
- bucket truth is runtime-owned
- explorer is presentation-only again
- classification truth is materially safer
- Market State Detection remains compile-clean and restart-safe

## Execution style from here

When driving the repo with `next`:
- prefer one meaningful pass at a time
- keep the pass bounded and named
- update office + work log + SHA ledger in the same pass
- say “test first” when repo truth says evidence is needed before coding further
- do not skip fault-finding just because the path looks obvious
