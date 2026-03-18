# DEBUG REVIEW — WAVE 1

## 1. Files Reviewed
- README.md
- INDEX.md
- office/HQ_OPERATOR_MANUAL.md
- office/MODULE_OWNERSHIP.md
- office/WORKER_RULES.md
- office/LAYERED_BUILD_ORDER.md
- office/TEST_AND_VERIFICATION_PLAN.md
- blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md
- blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md
- blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md
- blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md
- blueprint/RANKING_AND_PROMOTION_CONTRACT.md
- blueprint/PRODUCT_NAMING_AND_OUTPUT_LANGUAGE_RULES.md
- mt5/AuroraSentinel.mq5
- mt5/ASC_Common.mqh
- mt5/ASC_Engine.mqh
- mt5/ASC_Market.mqh
- mt5/ASC_Conditions.mqh
- mt5/ASC_Storage.mqh
- mt5/ASC_Output.mqh
- office/HANDOFF_ENGINE_WAVE1.md
- office/HANDOFF_MARKET_WAVE1.md
- office/HANDOFF_CONDITIONS_WAVE1.md
- office/HANDOFF_STORAGE_OUTPUT_WAVE1.md

## 2. Signature / Compile-Risk Findings
- FAIL: The current product entrypoint includes only `ASC_Common.mqh` and `ASC_Engine.mqh`. `ASC_Market.mqh`, `ASC_Conditions.mqh`, `ASC_Storage.mqh`, and `ASC_Output.mqh` are not included anywhere in the compiled EA unit, so the frozen function declarations exist but the implementations are not linked into the build.
- FAIL: `mt5/ASC_Market.mqh` does not include `ASC_Common.mqh`, yet it uses `ASC_RuntimeConfig`, `ASC_SymbolRecord`, and the frozen session enum contract indirectly. That is a compile-risk and contract-surface mismatch.
- FAIL: `mt5/ASC_Market.mqh` writes to non-existent top-level fields such as `record.Exists`, `record.Selected`, `record.Visible`, `record.TradeAllowed`, `record.SessionTruthStatus`, `record.PrimaryBucket`, and `record.ClassificationResolved`. The frozen shared contract stores those fields under `record.Identity.*` and `record.MarketTruth.*`. As written, the Market implementation is not signature-consistent with `ASC_SymbolRecord`.
- FAIL: `mt5/ASC_Market.mqh` returns and compares session status as strings like `"OPEN_TRADABLE"` and `"UNKNOWN"`, but the frozen contract requires `ASC_SessionTruthStatus` enum values. This is a direct type mismatch against the shared contract and downstream storage/output code.
- FAIL: `mt5/ASC_Engine.mqh` calls frozen functions with correct names, but integrated compile safety is not met because the active EA file does not include the implementation headers for those functions.
- PASS: `mt5/ASC_Common.mqh`, `mt5/ASC_Conditions.mqh`, `mt5/ASC_Storage.mqh`, and `mt5/ASC_Output.mqh` keep the frozen function names unchanged.

## 3. Engine Orchestration Findings
- PASS WITH CORRECTION: `OnTick()` is empty, so heavy scanner work is not running on tick.
- PASS WITH CORRECTION: The intended engine order is bounded and follows load -> discover/process -> save -> mirror on init and discover/process -> save -> mirror on timer.
- FAIL: The current engine resets the in-memory universe to the current bounded pass size and rebuilds only the first `MaxSymbolsPerInitPass` / `MaxSymbolsPerTimerPass` discovered symbols. That means timer passes do not merge with restored snapshot state and do not preserve the full universe in memory before save. This conflicts with restore-first, non-destructive snapshot expectations.
- FAIL: `ASC_Engine_RunInit` returns `false` when symbol discovery fails even after loading a prior snapshot. That blocks startup instead of preserving restore-first continuity when broker discovery is temporarily unavailable.
- FAIL: Engine currently loads Conditions for every `record.MarketTruth.Exists` symbol, not for Layer-1-eligible symbols only. That is broader than the required Layer 1 -> Layer 1.2 -> Conditions safety gate described in the task and review scope.

## 4. Market Truth Findings
- FAIL: Because Market writes string statuses instead of the frozen enum, Layer 1 session-truth states are not preserved in the shared contract shape and will not serialize correctly through Storage / Output.
- FAIL: `Layer1Eligible` is gated on `ClassificationResolved && SessionTruthStatus == "OPEN_TRADABLE"`. Classification resolution is Market-owned identity truth, but Layer 1 eligibility should not be falsified merely because archive classification is unresolved. This wrongly converts unresolved classification into non-open market truth.
- FAIL: The Market handoff claims unresolved classification leaves `PrimaryBucket = UNKNOWN`, which aligns with contract intent, but the implementation uses wrong field locations and therefore does not actually preserve that truth in the frozen record shape.
- FAIL: Session stale-feed logic ignores the runtime config freshness threshold and hardcodes `900` seconds. The shared config exposes `StaleFeedSeconds`, but the implementation does not consume it.
- FAIL: `NO_QUOTE` is returned whenever there is no tick, even if there are no readable session windows at all. That collapses uncertainty into a stronger state instead of keeping unresolved truth explicit as `UNKNOWN` when session truth cannot be determined safely.

## 5. Conditions Truth Findings
- PASS WITH CORRECTION: Conditions stays out of ranking, classification, and output logic.
- PASS WITH CORRECTION: Missing/unreadable fields are kept explicit through unreadable reasons and invalid sentinels during reset.
- FAIL: The loader only copies broker values into the record when *all* reads succeed. If even one required read fails, all successfully-read fields remain at sentinel values. That loses truthful partial broker data instead of preserving readable fields explicitly as required by the blueprint.
- FAIL: `SpecsReadable` is set from the final reason string only, but readable fields that later fail integrity checks are not separated from unreadable fields. The record preserves only an all-or-nothing valid block, not the partial truth the contract requires.

## 6. Storage / Recovery Findings
- PASS WITH CORRECTION: Storage loads the active snapshot first and then the last-good fallback.
- PASS WITH CORRECTION: Snapshot writes use temp staging and parse verification before promotion.
- FAIL: Engine behavior defeats restore-first storage intent because the save path writes only the currently processed bounded pass rather than merging against the restored full snapshot. Storage itself is conservative, but orchestration still risks routine partial shrink of universe truth.
- FAIL: `ASC_Storage_SaveUniverseSnapshot` protects only the zero-count destructive case. It does not detect non-zero partial refreshes, so a bounded timer/init pass can still overwrite a larger previously valid snapshot with a smaller subset.
- PASS WITH CORRECTION: Output renders stored fields and does not compute ranking or bucket replacements.

## 7. Product Language Findings
- PASS: The visible mirror labels in `ASC_Output.mqh` use market/state language and do not leak worker/task/debug terminology.
- PASS WITH CORRECTION: Internal reason strings such as `CLASSIFICATION_UNRESOLVED`, `ARCHIVE_MAP_MATCH`, and `NO_ARCHIVE_MATCH` appear implementation-oriented. They are not currently written by the mirror with dev-role wording, but they are still uppercase internal status codes that may surface in product files via `Classification Reason` and should be normalized if intended for trader-facing persistence.

## 8. Scope Drift Findings
- PASS: No ranking implementation was added.
- PASS: No deep dossier / Layer 3 persistence was added.
- PASS WITH CORRECTION: The storage mirror is still a Layer 1.2 artifact, not a top-5 summary or symbol dossier, so it does not constitute early Layer 3/4 work.
- FAIL: README and blueprint define the trader-facing canonical outputs as broker summary and per-symbol dossier, while this wave writes only a universe snapshot mirror. That is acceptable for incomplete stage work only if it is clearly treated as internal verification output, not as milestone completion.

## 9. Required Corrections
1. Fix compile integration: include the Market, Conditions, Storage, and Output implementation headers in the EA build path so the frozen functions are defined in the compiled unit.
2. Fix `ASC_Market.mqh` to include `ASC_Common.mqh` and to use the actual frozen record shape (`record.Identity.*` and `record.MarketTruth.*`) everywhere.
3. Replace all string-based session statuses in Market with the frozen `ASC_SessionTruthStatus` enum values end-to-end.
4. Rework Market truth so unresolved classification stays explicit without being used to falsify Layer 1 market-open truth.
5. Use `config.StaleFeedSeconds` for stale-feed determination rather than a hardcoded threshold.
6. Preserve partial Conditions truth: write each readable spec field into the record even when other fields fail, and keep unreadable/invalid state explicit field-by-field.
7. Preserve restore-first snapshot behavior at the engine level: merge newly processed records into the restored universe instead of replacing the in-memory universe with only the current bounded pass.
8. Block partial destructive snapshot rewrites, not just zero-count rewrites. Saving a bounded subset over a larger prior universe must be treated conservatively.
9. Revisit startup behavior so discovery failure after a successful snapshot restore does not force init failure by default.

## 10. Debug Verdict
FAIL
