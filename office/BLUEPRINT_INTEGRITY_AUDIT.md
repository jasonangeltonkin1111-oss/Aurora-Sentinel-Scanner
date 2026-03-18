# BLUEPRINT INTEGRITY AUDIT

## 1. System Identity Check
- **Flaw:** Front-door system wording still left room for bucket drift and outdated navigation references. `blueprint/SYSTEM_OVERVIEW.md` still said ASC ranks symbols inside generic “buckets,” and `README.md` / `INDEX.md` still pointed fresh HQ and workers toward retired file names such as `ARCHITECTURE_RULES.md`, `PERSISTENCE_CONTRACT.md`, and `OUTPUT_CONTRACT.md`.
- **Why it matters:** The mandatory reading path starts at `README.md` and `INDEX.md`. If those files point recovery toward retired documents or generic bucket wording, future HQ/worker runs can recover the wrong law before they ever reach the active blueprint files.
- **Risk if left unfixed:** Fresh workers can silently drift into stale read-order assumptions, weakening enforcement of `PrimaryBucket`, restore-first law, and the current office control stack.
- **Files needing hardening:** `README.md`, `INDEX.md`, `blueprint/SYSTEM_OVERVIEW.md`.
- **Timing:** **REQUIRED NOW**.

## 2. Layer Boundary Check
- **Flaw:** Layer 1 and Layer 1.2 contracts did not say strongly enough that classification resolution is downstream of market-open truth and that partial refreshes must not shrink the known universe. The live Wave 1 debug review exposed exactly those failure modes.
- **Why it matters:** Layer 1 is the market/session truth gate, not a classification gate. Layer 1.2 is broad universe continuity, not a bounded-pass overwrite surface.
- **Risk if left unfixed:** Workers can incorrectly block eligible-but-unresolved symbols before ranking, or overwrite a restored full snapshot with a smaller timer pass and still believe they followed the docs.
- **Files needing hardening:** `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`, `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`.
- **Timing:** **REQUIRED NOW**.

## 3. Classification / PrimaryBucket Contract Check
- **Flaw:** Market classification law still lacked an explicit unresolved-state contract. It said bucket assignment is authoritative, but it did not state clearly enough what happens when classification is unresolved or partial.
- **Why it matters:** `PrimaryBucket` is the shared truth that summary, ranking, and activation all consume. Unresolved handling is where downstream bucket invention usually sneaks in.
- **Risk if left unfixed:** Future workers may silently coerce unresolved symbols into resolved buckets, or treat `UNKNOWN` as if it were a true resolved class.
- **Files needing hardening:** `blueprint/MARKET_IDENTITY_MAP.md`.
- **Timing:** **REQUIRED NOW**.

## 4. Summary / Ranking / Activation Contract Check
- **Flaw:** Ranking law required deterministic tie handling but did not define the minimum deterministic fallback. It also did not explicitly state that fewer than five valid symbols must remain a smaller promoted set rather than padded output. Activation authority wording also needed sharper separation between ranking truth and writer publication.
- **Why it matters:** Top-5 per bucket is load-bearing for both trader visibility and ACTIVE rights. Tie churn or implicit padding would create unstable activation and misleading summaries.
- **Risk if left unfixed:** Two workers could both “follow the docs” yet implement incompatible bucket-boundary behavior, causing shortlist churn and activation drift.
- **Files needing hardening:** `blueprint/RANKING_AND_PROMOTION_CONTRACT.md`, `blueprint/SYMBOL_LIFECYCLE_AND_ACTIVATION.md`.
- **Timing:** **REQUIRED NOW**.

## 5. Persistence / Restore / Atomicity Check
- **Flaw:** Persistence law already protected atomic active dossier writes, but snapshot continuity law still needed a stronger explicit ban on bounded-pass shrink overwrites.
- **Why it matters:** The current live engine behavior already demonstrated that a restore-first load can still be defeated later by an incomplete save path.
- **Risk if left unfixed:** Future workers may preserve atomic dossier law yet still destroy Layer 1.2 continuity through partial snapshot rewrites.
- **Files needing hardening:** `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`, `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`, with existing support from `blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`.
- **Timing:** **REQUIRED NOW**.

## 6. Validity / Fail-Fast Check
- **Flaw:** Fail-fast law was directionally correct, but the interaction between unresolved classification and Layer 1 eligibility was too implicit.
- **Why it matters:** Fail-fast must exclude bad promotion candidates without collapsing earlier-layer market truth into classification truth.
- **Risk if left unfixed:** Invalid promotion gating could leak backward and falsify open-market eligibility, exactly the kind of layer collapse the blueprint is supposed to prevent.
- **Files needing hardening:** `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`, `blueprint/MARKET_IDENTITY_MAP.md`, `blueprint/RANKING_AND_PROMOTION_CONTRACT.md`.
- **Timing:** **REQUIRED NOW**.

## 7. Worker Ownership / Boundary Check
- **Flaw:** Office ownership law is materially stronger than before, but live Wave 1 evidence still shows shared-contract ambiguity around `ASC_Common.mqh` and the engine-led creation of Common contract surfaces.
- **Why it matters:** Common is a HQ-coordinated shared contract surface. If that is not enforced tightly, every module can drift while still claiming ownership compliance.
- **Risk if left unfixed:** Future implementation waves can repeat Common-surface ownership theft even if domain files remain otherwise well bounded.
- **Files needing hardening:** No new ownership-law edit was required in this pass; the existing office law is already explicit. Enforcement remains a workflow issue tracked in `office/CLERK_REVIEW_WAVE1.md`, `office/DEBUG_REVIEW_WAVE1.md`, and control-state files.
- **Timing:** **REQUIRED NOW** for workflow enforcement, **not** for new module-ownership wording.

## 8. Product Language Boundary Check
- **Flaw:** The naming/output law is strong, but front-door repo navigation still referenced outdated master/worker file names and older control surfaces.
- **Why it matters:** Product language boundaries are only enforceable if the governance path itself is clear and current.
- **Risk if left unfixed:** Future workers may inherit stale governance terminology or rely on retired files that no longer define the active law set.
- **Files needing hardening:** `README.md`, `INDEX.md`.
- **Timing:** **REQUIRED NOW**.

## 9. Blueprint vs Live Product Reality Check
- **Flaw:** The live MT5 files still show blueprint-reality mismatches already called out by Debug: missing include/link wiring, wrong record-field paths in Market, string-vs-enum session truth drift, restore-first snapshot merge failure, and partial snapshot overwrite risk.
- **Why it matters:** This audit run is document-first, but the live product proves which blueprint contracts were still not sharp enough to stop those errors.
- **Risk if left unfixed:** HQ could send Debug too early again, and future workers could cite incomplete blueprint wording as cover for repeating the same runtime mistakes.
- **Files needing hardening:** The required blueprint files listed above were hardened now. Product files still need a later corrective implementation run in `mt5/AuroraSentinel.mq5`, `mt5/ASC_Engine.mqh`, `mt5/ASC_Market.mqh`, and `mt5/ASC_Storage.mqh` under the existing review findings.
- **Timing:** Blueprint hardening **REQUIRED NOW**; MT5 correction remains **REQUIRED NOW** before claiming Wave 1 readiness.

## 10. Required Blueprint Corrections
- **Completed in this run:**
  - lock `PrimaryBucket` wording in `blueprint/SYSTEM_OVERVIEW.md`
  - add unresolved-classification handling law in `blueprint/MARKET_IDENTITY_MAP.md`
  - state that Layer 1 eligibility must not be falsified by unresolved classification in `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`
  - forbid bounded/partial snapshot shrink overwrites in `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md` and `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`
  - define smaller-than-five promoted sets and a minimum deterministic tie fallback in `blueprint/RANKING_AND_PROMOTION_CONTRACT.md`
  - separate ranking authority from writer publication in `blueprint/RANKING_AND_PROMOTION_CONTRACT.md` and `blueprint/SYMBOL_LIFECYCLE_AND_ACTIVATION.md`
  - repair front-door reading/navigation references in `README.md` and `INDEX.md`
- **Still required later:**
  - MT5 implementation fixes for the already-documented Wave 1 product failures
  - post-fix Clerk and Debug reruns after implementation correction

## 11. Explicit Non-Changes
- Did **not** redesign ASC.
- Did **not** add new runtime layers.
- Did **not** add worker roles.
- Did **not** expand scope into execution, strategy, or legacy Aurora rebuild behavior.
- Did **not** introduce MT5 product logic changes in this run.
- Did **not** rewrite office ownership law where current wording was already sufficient; the remaining issue there is enforcement against live implementation drift.

## 12. HQ Recommendation
- **Do not send Debug next yet.**
- Reason: the blueprint is now materially stronger, but the live MT5 product still contains open Wave 1 failures already documented by Debug and Clerk. A bounded implementation correction run is still required before another Debug pass is worthwhile.
- Recommended next step:
  1. keep the system in correction mode
  2. run the required MT5 fix packet(s) against the existing Debug/Clerk findings
  3. rerun Clerk
  4. rerun Debug
  5. only then consider progression
