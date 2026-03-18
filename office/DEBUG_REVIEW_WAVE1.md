# DEBUG REVIEW — WAVE 1

## 1. Debug Scope
- Post-run Debug review only.
- Live product state was checked against the mandated office control files, active blueprint law, current review/handoff documents, live MT5 product files, and the named archive classification references.
- MT5 product files were inspected directly and were **not edited** in this run.
- This review specifically re-checked the previously blocked areas: compile/integration wiring, restore-first continuity, bounded-pass shrink behavior, Layer 1 vs Layer 1.2 separation, archive-backed classification translation, canonical identity / `PrimaryBucket` truth, preservation of non-eligible and unknown symbols, conditions partial-truth handling, fail-fast handling, and blueprint-vs-product alignment.

## 2. Files Inspected
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
- `office/FOUNDATION_HARMONIZATION_REPORT.md`
- `office/ARCHIVE_SURGICAL_MAP.md`
- `office/FOUNDATION_GAP_CLOSURE_REPORT.md`
- `office/CLERK_REVIEW_WAVE1.md`
- `office/DEBUG_REVIEW_WAVE1.md` (prior state)
- `office/BLUEPRINT_INTEGRITY_AUDIT.md`
- `office/HANDOFF_ENGINE_WAVE1.md`
- `office/HANDOFF_MARKET_WAVE1.md`
- `office/HANDOFF_CONDITIONS_WAVE1.md`
- `office/HANDOFF_STORAGE_OUTPUT_WAVE1.md`
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
- `mt5/AuroraSentinel.mq5`
- `mt5/ASC_Common.mqh`
- `mt5/ASC_Engine.mqh`
- `mt5/ASC_Market.mqh`
- `mt5/ASC_Conditions.mqh`
- `mt5/ASC_Storage.mqh`
- `mt5/ASC_Output.mqh`
- `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
- `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`

## 3. Compile / Integration Findings
- **PASS**  
  **What is right:** The EA build unit is now wired as one compiled chain. `mt5/AuroraSentinel.mq5` includes `ASC_Common.mqh`, `ASC_Market.mqh`, `ASC_Conditions.mqh`, `ASC_Storage.mqh`, `ASC_Output.mqh`, and `ASC_Engine.mqh` directly, so the implementation headers used by Engine are present in the live translation unit.  
  **Why it is right:** This closes the prior compile/integration blocker where declarations existed without the implementation include chain.  
  **What breaks if left unfixed:** Previously this blocked build safety; in the current state that specific blocker is no longer present.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **MINOR**  
  **What is wrong:** There is still no repository-local MT5 compiler or automated compile artifact proving the code in this environment compiled end-to-end. This review could confirm wiring and syntax-consistency patterns from live source, but not execute a native MetaEditor build.  
  **Why it is wrong:** Compile safety is materially improved, but not mechanically proven inside this container.  
  **What breaks if left unfixed:** Nothing in source logic immediately breaks, but final signoff still relies on source inspection rather than a native MT5 compile result.  
  **Worker/domain to fix:** Engine / verification workflow, if HQ wants a later native compile confirmation.  
  **Blocks rerun / advancement:** No.

## 4. Layer / Contract Findings
- **PASS**  
  **What is right:** Restore-first continuity now actually exists in engine flow. `ASC_Engine_RunInit` loads the universe snapshot before discovery, keeps restored records in memory, and only upserts records discovered in the current pass instead of rebuilding the array from scratch.  
  **Why it is right:** This matches the office/blueprint law of restore first, never wipe, and gap-fill only.  
  **What breaks if left unfixed:** This was a prior destructive continuity blocker; current live code materially resolves it.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **PASS**  
  **What is right:** Layer 1 and Layer 1.2 are no longer collapsed together. `ASC_Market_BuildIdentityAndTruth` now returns `true` for discoverable symbols even when market truth is closed, quote-only, stale, trade-disabled, or unreadable, and Engine upserts those records into the snapshot.  
  **Why it is right:** Layer 1 eligibility remains explicit in `SessionTruthStatus` / `Layer1Eligible`, while Layer 1.2 still preserves the symbol in the universe snapshot.  
  **What breaks if left unfixed:** This used to drop non-eligible symbols; the current code now preserves them.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **MINOR**  
  **What is wrong:** `NextRecheckTime` is still a simple bounded timer offset for all non-open outcomes instead of a more state-specific recheck schedule.  
  **Why it is wrong:** The blueprint prefers more specific recheck behavior for closed-session vs stale-feed vs trade-disabled states.  
  **What breaks if left unfixed:** Recheck behavior is conservative but coarse; it does not presently violate the first-slice safety floor, yet it is less expressive than the blueprint’s fuller Layer 1 recheck intent.  
  **Worker/domain to fix:** Market domain.  
  **Blocks rerun / advancement:** No.

## 5. Market / Classification Findings
- **PASS**  
  **What is right:** Archive-backed classification translation is now active in live product code. `ASC_Market.mqh` embeds archive-derived classification rows, normalizes broker symbols, resolves server-specific matches first, falls back to cross-server symbol matches when needed, and applies translated `CanonicalSymbol`, `AssetClass`, `PrimaryBucket`, `Sector`, `Industry`, and `Theme` into live identity truth.  
  **Why it is right:** This materially satisfies the blueprint rule that Market owns archive translation and `PrimaryBucket` truth.  
  **What breaks if left unfixed:** This was a prior advancement blocker; it is materially resolved in the current live state.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **PASS**  
  **What is right:** Canonical identity and `PrimaryBucket` now have meaningful truth when translation exists, while unresolved cases remain explicit as `UNKNOWN` with a clear unresolved reason.  
  **Why it is right:** This matches the blueprint requirement that unresolved classification stay explicit only when genuine and that downstream layers must not invent replacement buckets.  
  **What breaks if left unfixed:** The prior “everything unresolved” state is no longer true in live product code.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **PASS**  
  **What is right:** Non-eligible and unknown symbols are preserved instead of filtered away. Market writes explicit `SessionTruthStatus` and `IneligibleReason`, while Engine retains those records in the universe snapshot.  
  **Why it is right:** This restores truthful Layer 1.2 preservation behavior for visibility-only symbols and unknown-state symbols.  
  **What breaks if left unfixed:** This was previously a direct layer-separation blocker; in the current state it is resolved.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **MINOR**  
  **What is wrong:** `ClassificationResolved` is currently treated as true when either asset class, primary bucket, or canonical translation meaningfully differs from the normalized symbol. That is workable for Wave 1, but it still compresses “partially translated identity” and “fully translated identity” into one boolean.  
  **Why it is wrong:** The blueprint tolerates explicit unresolved/unknown handling, but a single boolean cannot express partial-vs-full classification quality if later layers need that distinction.  
  **What breaks if left unfixed:** No immediate Wave 1 contract break; it is mainly a future fidelity limitation.  
  **Worker/domain to fix:** Market / shared Common contract if later granularity is required.  
  **Blocks rerun / advancement:** No.

## 6. Conditions Findings
- **PASS**  
  **What is right:** Conditions no longer discard readable fields just because one sibling field failed. Each spec field is read independently and applied independently into the record, so partial truth is now preserved in memory and in storage.  
  **Why it is right:** This materially resolves the earlier all-or-nothing conditions-truth blocker and aligns with the fail-fast rule to preserve readable truth while marking unreadable/invalid truth explicitly.  
  **What breaks if left unfixed:** The prior “partial read collapses to full reset sentinel” behavior is no longer the live product behavior.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **PASS**  
  **What is right:** Unreadable and invalid states are handled more truthfully. Read failures append explicit unreadable reasons; validation failures append explicit invalid reasons; reset sentinels remain explicit invalid markers rather than fake zeros.  
  **Why it is right:** This materially improves fail-fast honesty and avoids fake values.  
  **What breaks if left unfixed:** The prior conditions-truth distortion is materially reduced.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **MINOR**  
  **What is wrong:** `SpecsReadable` still means “every requested field was readable,” not “some meaningful conditions truth exists,” and `SpecsReason` collapses unreadable and invalid details into one aggregate string.  
  **Why it is wrong:** The snapshot is now materially more truthful internally, but the contract surface still does not expose per-field readability/validity flags.  
  **What breaks if left unfixed:** Downstream consumers and mirror output cannot perfectly distinguish partial readability from fully unreadable state using only the current summary fields.  
  **Worker/domain to fix:** Conditions / shared Common contract.  
  **Blocks rerun / advancement:** No.

## 7. Storage / Restore / Atomicity Findings
- **PASS**  
  **What is right:** Storage now supports restore-first continuity safely enough for Wave 1. Load prefers the primary snapshot, falls back to backup if needed, and save validates serialized lines before promotion. Engine restores before discovery and preserves those restored records in memory during bounded update passes.  
  **Why it is right:** This materially aligns with the restore-first / gap-fill continuity requirement for the universe snapshot layer.  
  **What breaks if left unfixed:** The prior restore-destructive behavior is no longer present in the live product path.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **PASS**  
  **What is right:** Smaller bounded refreshes are now blocked from replacing a larger previously valid universe snapshot. `ASC_Storage_SaveUniverseSnapshot` compares the new count to the prior parsed count and refuses a shrink replacement when the new count is smaller.  
  **Why it is right:** This directly addresses the blueprint rule that a bounded or partial refresh must not overwrite a larger valid universe snapshot unless full replacement is intentionally verified.  
  **What breaks if left unfixed:** This was a direct persistence blocker; in current live code it is resolved.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **MINOR**  
  **What is wrong:** Universe-snapshot promotion is structurally conservative, but it is not a fully atomic rename-based swap. The module writes temp and backup files, validates staged content, then rewrites the active file rather than performing a true filesystem-atomic replace.  
  **Why it is wrong:** The blueprint’s strict atomic write law is primarily for active rolling dossier persistence, and Layer 1.2 allows simpler writes; still, the current pattern is “conservative staged rewrite” rather than literal atomic replacement.  
  **What breaks if left unfixed:** This does not look like a Wave 1 blocker for the snapshot layer, but it remains a lower-grade durability risk under abnormal write interruption.  
  **Worker/domain to fix:** Storage domain.  
  **Blocks rerun / advancement:** No.

## 8. Output / Writer-Boundary Findings
- **PASS**  
  **What is right:** Writers still do not compute. `ASC_Output.mqh` formats and persists already-populated record fields only; it does not invent classification, eligibility, or ranking truth.  
  **Why it is right:** This preserves the writer boundary required by the blueprint and office law.  
  **What breaks if left unfixed:** No active writer-side logic contamination was found.  
  **Worker/domain to fix:** None.  
  **Blocks rerun / advancement:** No.

- **MINOR**  
  **What is wrong:** The mirror output still gates all floating-point conditions fields behind the single `SpecsReadable` boolean. When some fields were readable and preserved but not all fields were readable, the mirror prints `UNKNOWN` for every gated float field even though partial truth exists in the record and serialized snapshot.  
  **Why it is wrong:** This is an output-surface fidelity loss, not a storage/logic loss. It understates partial conditions truth in the verification mirror.  
  **What breaks if left unfixed:** Operators reading only the mirror may believe conditions truth is more absent than it really is.  
  **Worker/domain to fix:** Storage + Output / Conditions contract coordination.  
  **Blocks rerun / advancement:** No.

- **MINOR**  
  **What is wrong:** The only current publication surface is still `UniverseSnapshotMirror.txt`, not the later canonical broker summary and symbol outputs.  
  **Why it is wrong:** This is acceptable for the current Wave 1 hardening loop, but it is not evidence that later summary/dossier publication milestones are complete.  
  **What breaks if left unfixed:** Nothing for the current decision about exiting the present fix loop, but HQ should not misread this as Layer 2 publication completion.  
  **Worker/domain to fix:** Storage + Output domain in a later bounded slice.  
  **Blocks rerun / advancement:** No.

## 9. Blueprint vs Product Mismatches
- **MINOR**  
  **Mismatch:** Layer 1 recheck behavior is still generic rather than differentiated by closure/quote-only/stale/disabled state.  
  **Why it matters:** The blueprint describes more state-specific recheck intent.  
  **What breaks:** Mainly efficiency and semantic precision, not current truth safety.  
  **Worker/domain to fix:** Market domain.  
  **Blocks rerun / advancement:** No.

- **MINOR**  
  **Mismatch:** Conditions truth preservation is materially improved, but the current contract surface still exposes one aggregate readability boolean and one aggregate reason string rather than per-field truth flags.  
  **Why it matters:** This leaves some blueprint-level fail-fast granularity unexpressed in the current first-slice record schema.  
  **What breaks:** Partial-truth interpretation is less precise for downstream consumers and mirror readers.  
  **Worker/domain to fix:** Conditions / Common.  
  **Blocks rerun / advancement:** No.

- **MINOR**  
  **Mismatch:** Universe snapshot saving is conservative and validated, but not a true atomic replace operation.  
  **Why it matters:** The blueprint’s strictest atomicity language applies most strongly to active rolling dossier persistence; Layer 1.2 permits simpler writes, so this is not a direct contradiction severe enough to block advancement.  
  **What breaks:** Only abnormal interruption durability remains less-than-ideal.  
  **Worker/domain to fix:** Storage domain.  
  **Blocks rerun / advancement:** No.

## 10. Critical Risks
1. No live source-level CRITICAL blocker remains in the Wave 1 fix targets that were explicitly assigned for this post-fix review.
2. The main residual risks are second-order fidelity and durability issues, not core logic-collapse issues:
   - mirror output understates partial conditions truth;
   - conditions contract surface is still aggregate rather than per-field;
   - Layer 1 recheck scheduling is coarse;
   - snapshot persistence is conservative but not a literal atomic replace.
3. A native MT5 compile was not executable in this container, so source inspection—not a MetaEditor build artifact—supports the compile safety judgment.

## 11. Required Fix Targets
1. **Storage + Output / MINOR / non-blocking:** Make mirror rendering reflect preserved partial conditions truth per field instead of hiding all float fields behind the aggregate `SpecsReadable` flag.
2. **Conditions + Common / MINOR / non-blocking:** If later layers need stronger fail-fast introspection, extend the contract to preserve per-field readability/validity markers instead of only `SpecsReadable` plus `SpecsReason`.
3. **Market / MINOR / non-blocking:** Refine `NextRecheckTime` policy by session truth subtype when HQ schedules the next bounded Market hardening slice.
4. **Storage / MINOR / non-blocking:** Consider a stronger replace strategy for universe-snapshot writes if HQ wants higher interruption durability before later persistence layers expand.

## 12. Explicit Non-Findings
- I did **not** find the prior compile/include-chain blocker still present in the live EA build unit.
- I did **not** find the prior restore-destructive in-memory rebuild behavior still present in Engine.
- I did **not** find the prior bounded-pass shrink overwrite still allowed in Storage.
- I did **not** find the prior “all symbols unresolved” classification state still present in Market.
- I did **not** find unresolved classification being used to falsify Layer 1 eligibility.
- I did **not** find writer-side bucket computation, ranking computation, or fake-value invention in Output.
- I did **not** find worker/task/debug wording leaking into the inspected MT5 output surface.
- I did **not** edit MT5 product files during this Debug run.

## 13. Debug Verdict
**PASS WITH NON-BLOCKING FIXES**

Reason:
- compile/integration wiring is now source-level safe;
- restore-first continuity is materially active;
- bounded-pass shrink replacement is guarded;
- Layer 1 vs Layer 1.2 separation is materially restored;
- archive-backed classification translation and `PrimaryBucket` truth are materially active;
- non-eligible / unknown symbols are preserved explicitly;
- conditions partial truth is materially preserved;
- remaining issues are secondary fidelity/durability cleanups rather than advancement blockers.
