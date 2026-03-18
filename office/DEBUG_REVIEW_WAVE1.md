# DEBUG REVIEW — WAVE 1

## 1. Debug Scope
- Post-run Debug audit only.
- Live-repo truth checked in the mandated order: office control files -> current review/hardening state -> active blueprint law -> live MT5 product files -> limited archive references.
- MT5 product files were inspected directly and were **not edited** in this run.
- Target of this review: current Wave 1 MT5 implementation safety, contract alignment, restore/persistence safety, and readiness for another correction step.

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
- `office/HANDOFF_ENGINE_WAVE1.md`
- `office/HANDOFF_MARKET_WAVE1.md`
- `office/HANDOFF_CONDITIONS_WAVE1.md`
- `office/HANDOFF_STORAGE_OUTPUT_WAVE1.md`
- `office/BLUEPRINT_INTEGRITY_AUDIT.md`
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
- **CRITICAL — confirmed from live code**  
  **What is wrong:** The compiled EA unit still does not include the implementation headers for Market, Conditions, Storage, or Output. `mt5/AuroraSentinel.mq5` includes only `ASC_Common.mqh` and `ASC_Engine.mqh`, while `mt5/ASC_Engine.mqh` itself includes only `ASC_Common.mqh`. The engine then calls `ASC_Market_*`, `ASC_Conditions_Load`, `ASC_Storage_*`, and `ASC_Output_*` functions that are declared in Common but not brought into the translation unit by any include chain.  
  **Why it is wrong:** MQL compile integration requires the implementations to be included into the EA build unit; declarations alone are not sufficient for a working product compile boundary.  
  **What breaks if left unfixed:** Compile/link boundary remains broken or likely broken; Wave 1 cannot be considered runnable.  
  **Worker/domain to fix:** Engine domain, with shared-contract awareness from Common ownership discipline.  
  **Blocks rerun / compile / advancement:** Yes; blocks compile and blocks Wave 1 advancement.

- **MINOR — confirmed from live code**  
  **What is wrong:** `g_runtime_config` is defined in `mt5/AuroraSentinel.mq5` but not used by the engine runtime path after `ASC_Engine_RunInit` copies the values into `g_asc_runtime_config`.  
  **Why it is wrong:** It is dead product-state surface and adds confusion at the runtime boundary.  
  **What breaks if left unfixed:** No direct logic break, but it weakens integration clarity.  
  **Worker/domain to fix:** Engine domain.  
  **Blocks rerun / compile / advancement:** No.

## 4. Layer / Contract Findings
- **CRITICAL — confirmed from live code**  
  **What is wrong:** Engine orchestration still destroys restored universe continuity. `ASC_Engine_ProcessSymbols` resizes `g_asc_universe_records` to the current bounded pass, sets `g_asc_universe_count = 0`, and rebuilds only the first `max_pass` discovered symbols.  
  **Why it is wrong:** The office and blueprint law require restore first, never wipe, and gap-fill only. A bounded discovery pass may update part of the universe, but it may not replace the restored larger universe in memory before save.  
  **What breaks if left unfixed:** Valid prior snapshot truth is routinely lost during init/timer passes; universe continuity is not trustworthy.  
  **Worker/domain to fix:** Engine domain, coordinated with Storage domain because save semantics depend on merge behavior.  
  **Blocks rerun / compile / advancement:** Yes; blocks safe rerun and advancement.

- **CRITICAL — confirmed from live code**  
  **What is wrong:** The engine records only symbols for which `ASC_Market_BuildIdentityAndTruth` returns `true`, but that function returns `record.MarketTruth.Layer1Eligible`. Closed-session, quote-only, stale-feed, trade-disabled, or unknown-session symbols are therefore dropped from the in-memory universe instead of remaining in the Layer 1.2 snapshot with explicit state.  
  **Why it is wrong:** Layer 1 decides eligibility; Layer 1.2 preserves broad universe truth. Snapshot law explicitly forbids dropping symbols merely because some session/spec fields are unavailable or the symbol is not currently eligible.  
  **What breaks if left unfixed:** The supposed universe snapshot becomes an open-tradable subset, collapsing Layer 1 and Layer 1.2 into a destructive filter.  
  **Worker/domain to fix:** Engine + Market domains.  
  **Blocks rerun / compile / advancement:** Yes; blocks contract-aligned Wave 1 behavior.

- **MAJOR — confirmed from live code**  
  **What is wrong:** `ASC_Engine_RunInit` returns `false` whenever discovery fails, even if a prior snapshot was successfully restored at startup.  
  **Why it is wrong:** Restore-first continuity exists specifically to keep the product alive when broker discovery is temporarily unavailable.  
  **What breaks if left unfixed:** Temporary broker discovery failure forces init failure instead of degraded continuity from restored truth.  
  **Worker/domain to fix:** Engine domain.  
  **Blocks rerun / compile / advancement:** Blocks safe rerun behavior; not the only blocker, but still material.

## 5. Market / Classification Findings
- **CRITICAL — confirmed from live code**  
  **What is wrong:** Market classification translation is still not implemented in live product code. `ASC_Market_BuildIdentityAndTruth` hardcodes normalized symbol as canonical symbol, leaves `AssetClass`, `PrimaryBucket`, `Sector`, `Industry`, and `Theme` as `"UNKNOWN"`, and writes `ClassificationReason = "classification unresolved: archive translation not loaded"` for every symbol.  
  **Why it is wrong:** Active blueprint law says Market owns archive-classification translation and `PrimaryBucket` truth. Unresolved classification may remain explicit when genuinely unresolved, but the active product cannot treat the entire universe as unresolved because the translation layer was never connected.  
  **What breaks if left unfixed:** `PrimaryBucket` truth is absent across the universe, downstream ranking/summary cannot be trusted, and the live product materially lags the hardened blueprint.  
  **Worker/domain to fix:** Market domain.  
  **Blocks rerun / compile / advancement:** Yes; blocks Wave 1 readiness because classification ownership remains materially unimplemented.

- **PASS — confirmed from live code**  
  **What is right:** Layer 1 eligibility is no longer falsified by unresolved classification. `Layer1Eligible` is derived from session-truth status only, not `ClassificationResolved`.  
  **Why it matters:** This matches the hardened blueprint rule that unresolved classification must stay explicit but must not itself falsify open-market truth.  
  **Worker/domain:** No immediate fix required.  
  **Blocks rerun / compile / advancement:** No.

- **MAJOR — confirmed from live code**  
  **What is wrong:** `ASC_Market_BuildIdentityAndTruth` returns `false` for empty symbols, non-existent symbols, unreadable session/property state, and any non-open outcome. That return value is being used by Engine as an inclusion gate rather than a narrow function-success indicator.  
  **Why it is wrong:** Market correctly populates explicit ineligible reasons and session states, but the return contract is too aggressive for Layer 1.2 consumption because it converts many explicit outcomes into dropped records.  
  **What breaks if left unfixed:** Explicit unknown/closed/ineligible market truth never reaches the snapshot for many symbols.  
  **Worker/domain to fix:** Market domain, with Engine call-site correction.  
  **Blocks rerun / compile / advancement:** Yes, because it contributes directly to destructive shrink behavior.

- **MINOR — confirmed from live code**  
  **What is wrong:** `TradeAllowed` is treated as `SYMBOL_TRADE_MODE_FULL` only. Other broker trade modes are collapsed into disabled for current logic.  
  **Why it is wrong:** This may be intentionally conservative for Wave 1, but the contract meaning should be explicit because MT5 trade-mode semantics can be broader than one exact full-trade mode.  
  **What breaks if left unfixed:** Potential over-conservative eligibility classification on some brokers.  
  **Worker/domain to fix:** Market domain.  
  **Blocks rerun / compile / advancement:** Not by itself.

## 6. Conditions Findings
- **PASS — confirmed from live code**  
  **What is right:** Conditions reset uses explicit invalid sentinels (`-1`, `-1.0`) instead of fake valid zeros for unreadable state.  
  **Why it matters:** This aligns with the fail-fast/no-fake-values rule better than the prior all-zero reset pattern.  
  **Worker/domain:** No immediate fix required.  
  **Blocks rerun / compile / advancement:** No.

- **MAJOR — confirmed from live code**  
  **What is wrong:** Conditions still preserve truth as an all-or-nothing block. The code copies broker spec fields into the record only inside `if(all_readable)`, so if any one read fails then every otherwise-readable field stays at the reset sentinels.  
  **Why it is wrong:** Fail-fast law requires explicit unknown/unreadable handling, not silent destruction of readable partial truth. Snapshot law also says do not drop or falsify available fields just because others are unavailable.  
  **What breaks if left unfixed:** Conditions truth is understated and the snapshot cannot distinguish partially readable specs from totally unreadable specs.  
  **Worker/domain to fix:** Conditions domain.  
  **Blocks rerun / compile / advancement:** Yes for contract alignment; not a compile blocker, but still a required logic fix.

- **MAJOR — confirmed from live code**  
  **What is wrong:** `SpecsReadable` conflates unreadable fields with readable-but-invalid values into one final boolean and one concatenated reason string. There is no per-field validity/readability surface.  
  **Why it is wrong:** The blueprint requires explicit handling of unknown vs invalid vs usable truth. The current shape preserves only a collapsed final status.  
  **What breaks if left unfixed:** Downstream consumers cannot tell whether a field was unreadable, structurally invalid, or simply absent.  
  **Worker/domain to fix:** Conditions domain, potentially with Common contract coordination if field-level markers are needed.  
  **Blocks rerun / compile / advancement:** Material logic blocker for truthful Wave 1 conditions handling.

## 7. Storage / Restore / Atomicity Findings
- **CRITICAL — confirmed from live code**  
  **What is wrong:** `ASC_Storage_SaveUniverseSnapshot` will save any non-negative `count`, including a bounded partial subset smaller than a previously valid full snapshot. There is no conservative guard against non-zero shrink replacement.  
  **Why it is wrong:** Hardened snapshot law explicitly forbids bounded/partial refresh overwrites of a previously larger valid universe unless completeness is intentionally verified.  
  **What breaks if left unfixed:** A normal timer pass can atomically replace a good large universe snapshot with a smaller partial subset, silently destroying continuity while still appearing structurally valid.  
  **Worker/domain to fix:** Storage domain, but only together with Engine merge semantics.  
  **Blocks rerun / compile / advancement:** Yes; this is a direct FAIL condition.

- **MAJOR — confirmed from live code**  
  **What is wrong:** Storage temp/backup flow validates structure before promotion, but it does not clean up or roll back the temp file when staged validation fails after temp write.  
  **Why it is wrong:** This does not break the active snapshot immediately, but it weakens operational hygiene and leaves stale temp artifacts behind.  
  **What breaks if left unfixed:** Confusing stale temp state; lower operational clarity during recovery/debug.  
  **Worker/domain to fix:** Storage domain.  
  **Blocks rerun / compile / advancement:** No, not by itself.

- **PASS — confirmed from live code**  
  **What is right:** Load prefers the active snapshot first and falls back to the backup snapshot only if the primary cannot be parsed. Save also validates staged content before attempting promotion.  
  **Why it matters:** The storage module itself is directionally conservative; the larger restore-first break is caused by orchestration and shrink acceptance, not by primary/backup ordering.  
  **Worker/domain:** No immediate fix required on this specific point.  
  **Blocks rerun / compile / advancement:** No.

## 8. Output / Writer-Boundary Findings
- **PASS — confirmed from live code**  
  **What is right:** `ASC_Output.mqh` formats fields already present on the record and does not compute classification, ranking, or bucket replacement logic.  
  **Why it matters:** Writer purity is preserved in the current output implementation.  
  **Worker/domain:** No immediate fix required.  
  **Blocks rerun / compile / advancement:** No.

- **MINOR — confirmed from live code**  
  **What is wrong:** The only current published file is `UniverseSnapshotMirror.txt`, which is a verification-style artifact rather than the canonical broker summary/symbol outputs described in README and later-layer contracts.  
  **Why it is wrong:** This is acceptable only as an incomplete Wave 1 internal verification artifact, not as evidence that the product has reached canonical summary/dossier publication.  
  **What breaks if left unfixed:** Progress reporting can overstate milestone completeness.  
  **Worker/domain to fix:** Storage + Output domain, but not before current Wave 1 blockers are resolved.  
  **Blocks rerun / compile / advancement:** Not by itself.

- **PASS — confirmed from live code**  
  **What is right:** Product-facing mirror labels use domain language and do not leak worker/task/debug wording.  
  **Why it matters:** The product-language boundary is currently respected in the visible mirror surface.  
  **Worker/domain:** No immediate fix required.  
  **Blocks rerun / compile / advancement:** No.

## 9. Blueprint vs Product Mismatches
- **CRITICAL — confirmed from live code**  
  **Mismatch:** Blueprint/office law says restore first, never wipe, gap-fill only, and preserve prior valid universe truth unless replacement completeness is verified. Live Engine + Storage behavior still allows bounded-pass rebuild and smaller replacement saves.  
  **Why it matters:** This is a direct contradiction of hardened persistence and Layer 1.2 law.  
  **What breaks:** Universe continuity and trustworthy recovery.  
  **Worker/domain to fix:** Engine + Storage.  
  **Blocks rerun / compile / advancement:** Yes.

- **CRITICAL — confirmed from live code**  
  **Mismatch:** Blueprint says Layer 1.2 captures the full broker universe with explicit unknown/missing markers. Live product stores only records that passed the Market function’s success/eligibility gate.  
  **Why it matters:** The product is still behaving like a filtered shortlist precursor rather than a broad universe snapshot.  
  **What breaks:** Layer separation and snapshot contract meaning.  
  **Worker/domain to fix:** Engine + Market.  
  **Blocks rerun / compile / advancement:** Yes.

- **CRITICAL — confirmed from live code**  
  **Mismatch:** Blueprint and office law say Market owns archive-classification translation and `PrimaryBucket` truth. Live Market code still leaves the entire active universe unresolved because archive translation is not loaded.  
  **Why it matters:** The hardened blueprint is now stronger than the product; live code still materially lags that law.  
  **What breaks:** Classification-aware product identity and future summary/ranking continuity.  
  **Worker/domain to fix:** Market.  
  **Blocks rerun / compile / advancement:** Yes.

- **MAJOR — confirmed from live code**  
  **Mismatch:** Fail-fast law distinguishes unknown, invalid, and unusable truth, but current Conditions implementation collapses partial reads into full sentinel fallback.  
  **Why it matters:** Truth granularity is lost.  
  **What breaks:** Contract-aligned conditions persistence and downstream interpretability.  
  **Worker/domain to fix:** Conditions.  
  **Blocks rerun / compile / advancement:** Yes for Wave 1 correctness.

## 10. Critical Risks
1. **Compile boundary risk remains open.** The EA still appears unable to compile as a fully wired unit until implementation headers are actually included.
2. **Restore-first law is still violated in practice.** Restored snapshot truth is overwritten by bounded-pass in-memory rebuilds.
3. **Bounded snapshot shrink is still possible.** A smaller partial pass can replace a larger valid prior universe snapshot.
4. **Layer 1.2 is still not a full universe snapshot.** Non-eligible or partially unreadable symbols are dropped instead of preserved explicitly.
5. **Classification ownership is still materially unimplemented.** Market does not yet load archive translation into active product code.
6. **Conditions truth still loses readable partial fields.** This weakens fail-fast and snapshot fidelity.

## 11. Required Fix Targets
1. **Engine / CRITICAL / blocks compile:** Wire the live EA include chain so Market, Conditions, Storage, and Output implementations are part of the compiled unit.
2. **Engine + Storage / CRITICAL / blocks rerun:** Rework restore-first runtime behavior so restored universe records are retained and updated incrementally; do not rebuild the whole in-memory universe from the bounded current pass.
3. **Engine + Market / CRITICAL / blocks advancement:** Separate “record construction succeeded” from “symbol is currently Layer-1-eligible” so Layer 1.2 can preserve non-eligible, unknown, and closed symbols explicitly.
4. **Storage / CRITICAL / blocks rerun:** Add conservative protection against non-zero partial shrink overwrites of a previously larger valid universe snapshot unless completeness is explicitly verified.
5. **Market / CRITICAL / blocks advancement:** Implement active archive classification translation so Market owns real canonical identity and `PrimaryBucket` truth instead of leaving the whole universe unresolved.
6. **Conditions / MAJOR / blocks advancement:** Preserve readable spec fields even when other fields fail, and keep unreadable vs invalid state explicit rather than collapsing everything into reset sentinels.
7. **Engine / MAJOR / blocks safe continuity:** Allow startup to continue from restored snapshot truth when broker discovery fails transiently after a valid restore.

## 12. Explicit Non-Findings
- I did **not** find writer-side ranking, bucket invention, or score computation in `mt5/ASC_Output.mqh`.
- I did **not** find worker/task/debug wording leaking into the visible output mirror labels.
- I did **not** find unresolved classification being used directly to falsify `Layer1Eligible` in the current Market code.
- I did **not** find any active Layer 3 rolling dossier implementation in the current MT5 Wave 1 slice.
- I did **not** edit MT5 product files during this debug run.

## 13. Debug Verdict
**FAIL — FIX WAVE REQUIRED**

Reason:
- compile/integration is still broken or likely broken due to missing implementation include wiring;
- restore-first law is still violated by bounded-pass in-memory rebuild behavior;
- bounded snapshot processing can still destroy prior valid universe truth;
- Layer 1.2 snapshot behavior is still contract-broken because non-eligible/unreadable symbols are dropped;
- live Market code still materially lags the active blueprint by not loading archive classification translation into product truth.
