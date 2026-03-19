# DEBUG REVIEW — WAVE 2

## 1. Debug Scope

This pass re-checked the live post-truth-repair MT5 product against the active blueprint law, the prior Wave 1 debug findings, the Wave 2 handoffs, and the stated repair targets for Market, Conditions, Engine, Storage, and Output.

The review was limited to verification of the current repository state. No MT5 product files were edited in this run.

Targeted decision question: whether the truth-repair wave removed the load-bearing failures in live product behavior across market/session truth, broker spec truth, universe continuity, artifact integrity, and publication honesty.

## 2. Files Inspected

Mandatory governance and continuity read order completed:
- `office/HQ_OPERATOR_MANUAL.md`
- `README.md`
- `INDEX.md`
- `office/HQ_STATE.md`
- `office/HQ_TASK_FLOW.md`
- `office/HQ_DECISION_LOG.md`
- `office/MODULE_OWNERSHIP.md`
- `office/TASK_BOARD.md`
- `office/WORKER_RULES.md`
- `office/ARCHIVE_REFERENCE_MAP.md`
- `office/WORKER_EXECUTION_PROTOCOL.md`
- `office/LAYERED_BUILD_ORDER.md`
- `office/TEST_AND_VERIFICATION_PLAN.md`

Review / integrity context read:
- `office/BLUEPRINT_INTEGRITY_AUDIT.md`
- `office/CLERK_REVIEW_WAVE1.md`
- `office/DEBUG_REVIEW_WAVE1.md`
- `office/HANDOFF_ENGINE_WAVE1.md`
- `office/HANDOFF_MARKET_WAVE1.md`
- `office/HANDOFF_CONDITIONS_WAVE1.md`
- `office/HANDOFF_STORAGE_OUTPUT_WAVE1.md`
- `office/HANDOFF_ENGINE_WAVE2.md`
- `office/HANDOFF_STORAGE_OUTPUT_WAVE2.md`

Archive references read before judgment:
- `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`
- `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`
- `archives/LEGACY_SYSTEMS/AFS/ORIGINAL/BP1.txt`

Active blueprint law read:
- `blueprint/SYSTEM_OVERVIEW.md`
- `blueprint/MODULE_MAP.md`
- `blueprint/MARKET_IDENTITY_MAP.md`
- `blueprint/SUMMARY_SCHEMA.md`
- `blueprint/RUNTIME_RULES.md`
- `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`
- `blueprint/SYMBOL_LIFECYCLE_AND_ACTIVATION.md`
- `blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`
- `blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md`
- `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`
- `blueprint/RANKING_AND_PROMOTION_CONTRACT.md`
- `blueprint/PRODUCT_NAMING_AND_OUTPUT_LANGUAGE_RULES.md`

Live MT5 product files inspected directly:
- `mt5/AuroraSentinel.mq5`
- `mt5/ASC_Common.mqh`
- `mt5/ASC_Engine.mqh`
- `mt5/ASC_Market.mqh`
- `mt5/ASC_Conditions.mqh`
- `mt5/ASC_Storage.mqh`
- `mt5/ASC_Output.mqh`
- `mt5/ASC_Surface.mqh`

## 3. Market / Session Truth Findings

- **PASS — The prior false-closed load-bearing failure is materially repaired in live code.**
  - **What is right:** `ASC_Market_Internal::ResolveSessionStatus` now separates `OPEN_TRADABLE`, `QUOTE_ONLY`, `TRADE_DISABLED`, `NO_QUOTE`, `STALE_FEED`, `CLOSED_SESSION`, and `UNKNOWN` instead of collapsing mixed evidence into a closed verdict.
  - **Why it is right:** This aligns with Layer 1 law requiring explicit separation of closed-session, disabled, no-quote, stale-feed, and unknown states, and it prevents continuous markets from being marked closed just because session-window metadata is weak.
  - **Evidence:** Continuous markets are explicitly recognized by asset class, strong live quote evidence can override missing session windows, stale quotes are downgraded separately, and explicit conflict cases now retain quote-side ambiguity instead of returning false-closed certainty.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking; this is the main repaired success criterion.
  - **Owner:** none.

- **PASS — Mixed quote/session evidence is now handled explicitly rather than silently flattened.**
  - **What is right:** The resolver distinguishes explicit open windows, explicit quote-only windows, explicit closed windows, missing session truth, unreadable session truth, strong live tick evidence, weak recent quote timestamps, and session-reference presence.
  - **Why it is right:** Blueprint Layer 1 requires broker-symbol-specific market truth rather than one generic fallback. The current code now emits state-specific reasons such as "live quote present but session windows missing", "recent quote evidence conflicts with closed session windows", and "market truth unresolved: mixed session and quote evidence".
  - **What this fixes:** The product no longer treats mixed evidence as an implicit permission to publish a false `CLOSED_SESSION` story.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

- **PASS — Layer 1 eligibility and ineligible reasons are now tied to session truth rather than generic discovery collapse.**
  - **What is right:** `Layer1Eligible` is assigned only when `SessionTruthStatus == ASC_SESSION_OPEN_TRADABLE`, and `IneligibleReason` is now blank only for truly eligible records and otherwise keeps the state-specific rejection reason.
  - **Why it is right:** This preserves the blueprint boundary that Layer 1 decides eligibility truth while still letting Layer 1.2 preserve discovered but ineligible members.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

- **PASS — State-specific recheck handling is no longer generic.**
  - **What is right:** `ResolveNextRecheckTime` now varies retry cadence by `OPEN_TRADABLE`, `QUOTE_ONLY`, `NO_QUOTE`, `STALE_FEED`, `CLOSED_SESSION`, `TRADE_DISABLED`, and `UNKNOWN`.
  - **Why it is right:** This materially improves on the Wave 1 generic-offset weakness and satisfies the blueprint direction that recheck handling remain state-specific.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

## 4. Conditions / Spec Truth Findings

- **PASS — False-good `SpecsReadable: YES / ok` is no longer easy to obtain from broken economics.**
  - **What is right:** `ASC_Conditions_Load` now requires all requested fields to be readable, all validated fields to be valid, and key economics (`tick_size`, `tick_value`) to remain strong before publishing `SpecsReadable = true` and `SpecsReason = ok`.
  - **Why it is right:** This closes the prior false-good path where unreadable or suspicious spec sets could still look healthy.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

- **PASS — Broker-zero vs unreadable vs invalid distinction is now materially preserved.**
  - **What is right:** Unreadable fields add `field unreadable`; finite zero values add `field broker-zero`; negatives add `field negative`; non-finite values add `field non-finite`; other invalid cases remain explicit.
  - **Why it is right:** This matches the no-fake-values / fail-fast law better than the old aggregate-good surface and keeps broker truth visible instead of silently normalizing it.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

- **PASS — Tick size / tick value trustworthiness is now materially stronger.**
  - **What is right:** The Conditions module separately validates positive finite `point`, `tick_size`, `tick_value`, `contract_size`, and volume fields; rejects `tick_size < point`; and downgrades suspicious economics when `tick_value` materially mismatches `contract_size * tick_size`.
  - **Why it is right:** This directly addresses the repair target around false or misleading broker spec truth.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

- **MINOR — Shared conditions truth is still contract-compressed even though the loader is now materially more honest.**
  - **What is wrong:** `ASC_Common.mqh` still exposes only one aggregate `SpecsReadable` boolean plus one free-text `SpecsReason` string. The loader preserves richer distinctions internally through reason text, but shared downstream consumers still lack per-field readability/validity flags.
  - **Why it is wrong:** Output can display partial numeric truth, but it still cannot structurally express which fields were unreadable, broker-zero, valid-but-suspect, or rejected except by parsing prose.
  - **What breaks if left unfixed:** This does not recreate the old false-good bug, but it limits future ranking, summary filtering, and operator-facing explanation precision.
  - **Repair status against target:** PARTIALLY FIXED at the shared-contract surface, but FIXED at the load-bearing Conditions logic level.
  - **Blocking:** Non-blocking.
  - **Owner:** Conditions + Common shared-contract coordination.

## 5. Coverage / Universe Continuity Findings

- **PASS — Bounded init hydration no longer acts as the published-universe ceiling.**
  - **What is right:** `OnInit` still caps hydration at 200 symbols, but Engine now first discovers the full broker universe and inserts placeholder membership records for all discovered symbols before bounded processing begins.
  - **Why it is right:** The 200 limit is now a hydration budget, not a structural universe-membership cap.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

- **PASS — The prior 200-record collapse is no longer structurally possible through normal bounded startup.**
  - **What is right:** `ASC_Engine_PreserveUniverseMembership` preserves all discovered symbols, `ASC_Engine_ProcessSymbols` only hydrates a bounded subset, and `ASC_Storage_SaveUniverseSnapshot` refuses to replace a larger prior snapshot with a smaller new count.
  - **Why it is right:** This directly answers the blueprint prohibition on bounded-pass shrink overwrite and removes the prior collapse path that would have published an artificially small universe.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

- **PASS — Discovered-but-unhydrated symbols are now preserved honestly rather than dropped.**
  - **What is right:** Placeholder records keep raw membership and explicit `PENDING_INIT_PASS` reasons without fabricating classification, market truth, or conditions truth.
  - **Why it is right:** That preserves Layer 1.2 continuity while keeping unknown truth explicit.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

- **PASS — Publication is now more routing-first and continuity-aware than the old mirror-only surface.**
  - **What is right:** Output now publishes a broker summary, per-symbol files, and a universe snapshot mirror. The summary explicitly separates published, pending, and unavailable counts, and routes only records considered publishable.
  - **Why it is right:** This is materially more honest than a single dump-like verification mirror because it tells the operator where finished symbol files exist and where truth is still pending.
  - **Repair status against target:** FIXED for the intended honesty repair.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

## 6. Publication / Artifact Integrity Findings

- **PASS — Stale broken snapshot trees are less likely to be treated as current truth.**
  - **What is right:** Storage load prefers the active snapshot, falls back to backup if the active file cannot be parsed, validates staged lines before promotion, preserves the larger known snapshot size, and restores prior lines if a replacement write fails.
  - **Why it is right:** This is materially safer than the prior continuity failure because partial or structurally bad snapshot writes no longer become the easy active truth.
  - **Repair status against target:** FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

- **PASS — Publication order is safer and stale-file cleanup is bounded.**
  - **What is right:** `ASC_Output_WriteUniverseSnapshotMirror` writes the mirror first, then writes the current symbol surfaces, removes stale symbol files only after current symbol writes complete, and writes the summary last.
  - **Why it is right:** This reduces the chance that stale routes survive after the set of publishable symbols changes.
  - **Repair status against target:** FIXED enough for advancement.
  - **Blocking:** Non-blocking.
  - **Owner:** none.

- **MINOR — Product-facing symbol and mirror files are still direct writes rather than staged atomic replacements.**
  - **What is wrong:** `ASC_Output_WriteSymbolSurface` and `ASC_Output_WriteUniverseSnapshotMirror` write directly to active output files. Snapshot persistence itself is staged, but publication artifacts are not.
  - **Why it is wrong:** A terminal interruption during publication could leave a truncated summary, mirror, or symbol file as the active trader-facing artifact for that cycle.
  - **What breaks if left unfixed:** This is an artifact-integrity quality gap, not a reintroduction of the prior truth failures. It matters mainly for last-mile file robustness.
  - **Repair status against target:** PARTIALLY FIXED overall because stale/broken snapshot continuity is repaired, but publication-file atomicity is still weaker than ideal.
  - **Blocking:** Non-blocking.
  - **Owner:** Storage + Output.

## 7. Shared-Contract / Surface Ceiling Findings

- **MAJOR — `ASC_Common` is now the main remaining truth-ceiling, but it is no longer a wave-blocking ceiling.**
  - **What is wrong:** The shared record contract still lacks structured publication-state fields and per-field conditions validity markers. Output therefore decides publishability through `ASC_Output_RecordHasPublishedTruth` heuristics and must compress nuanced loader truth into aggregate booleans plus prose reasons.
  - **Why it is wrong:** The Output layer remains writer-only in implementation, but it is forced to infer "published vs pending vs unavailable" from coarse shared surfaces because Common does not expose a first-class publication contract.
  - **What breaks if left unfixed:** This limits precision in summary counts and future ranking/promotion integration, and it leaves the system relying on heuristics instead of a fully explicit surface contract.
  - **Why it is not blocking now:** The current heuristics are conservative enough that the major truth failures are no longer load-bearing. The remaining limitation is contract refinement, not active false-market or false-spec truth.
  - **Repair status against target:** PARTIALLY FIXED.
  - **Blocking:** Non-blocking.
  - **Owner:** HQ-coordinated Common + Output contract refinement.

## 8. Blueprint vs Product Mismatches

- **MAJOR — Summary publication is now more honest, but it is still not the full blueprint summary contract.**
  - **Mismatch:** The current summary is routing-first and publication-status oriented, not a ranked top-5-per-`PrimaryBucket` shortlist.
  - **Why it exists:** The Wave 2 handoff explicitly limited this packet to truthful publication scaffolding because ranking/promotion outputs and later-layer payloads do not yet exist on the shared record contract.
  - **What breaks:** This does not falsify current truth, but HQ must not mistake the new summary for completion of the blueprint ranking/promotion milestone.
  - **Blocking:** Non-blocking for this debug pass because the target wave was truth repair, not ranking completion.
  - **Owner:** future Ranking + Storage/Output packet after shared-contract extension.

- **MINOR — Symbol files remain intentionally sparse relative to the canonical later blueprint.**
  - **Mismatch:** `[OHLC_HISTORY]` and `[CALCULATIONS]` sections are explicit placeholders rather than live later-layer payloads.
  - **Why it exists:** The writer correctly refuses to invent later-layer truth that was not supplied.
  - **What breaks:** Nothing in present truth integrity; this is an intentional incompleteness, not dishonesty.
  - **Blocking:** Non-blocking.
  - **Owner:** future Layer 2/3 expansion.

## 9. Critical Risks

- **No CRITICAL live blocker was confirmed in the post-repair areas that motivated this wave.**
- The highest remaining risk is contract compression, not a reappearance of the prior false market/session or false-good conditions behavior.
- The next risk behind that is non-atomic product-surface publication, which affects artifact robustness more than truth classification.

## 10. Required Fix Targets

1. **Common + Output / MAJOR / non-blocking:** Add structured shared publication-state and per-field conditions validity/readability surfaces so Output can stop using publishability heuristics and prose-only nuance.
2. **Storage + Output / MINOR / non-blocking:** Stage summary, mirror, and symbol publication through temp-to-active replacement so product-facing artifacts do not remain vulnerable to truncation on interrupted writes.
3. **Ranking + Output / MAJOR but later-slice:** Replace the current routing-first summary with the blueprint top-5-per-`PrimaryBucket` shortlist only after ranking/promotion truth exists upstream.

## 11. Explicit Non-Findings

- I did **not** confirm the old crypto false-`CLOSED_SESSION` failure still present in live code.
- I did **not** confirm the old generic recheck timing still present in live code.
- I did **not** confirm the old false-good `SpecsReadable: YES / ok` behavior still present for weak or unreadable economics values.
- I did **not** confirm the old 200-record startup collapse still structurally possible through normal bounded init behavior.
- I did **not** confirm writer-side computation, fake-value invention, or downstream bucket recomputation in current Output.
- I did **not** edit MT5 product files in this debug pass.

## 12. Debug Verdict

**Verdict: `PASS WITH NON-BLOCKING FIXES`**

Reasoned judgment:
- The major truth failures that motivated the repair wave are materially repaired in the live system.
- Market/session truth is now explicit enough to avoid the prior false-closed and mixed-evidence collapse.
- Conditions/spec truth is now materially more trustworthy and no longer falsely "good" under suspicious economics.
- Universe continuity now preserves discovered membership separately from bounded hydration, and snapshot shrink overwrite is guarded.
- Publication is materially more honest and more useful than the prior mirror-only state.
- The remaining issues are contract-refinement and artifact-hardening gaps, not advancement blockers.

HQ can advance after this review, provided it treats the remaining Common/Output contract ceiling and product-surface atomicity as follow-up work rather than reasons to reopen the completed truth-repair wave.
