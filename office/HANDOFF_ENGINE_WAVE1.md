# ENGINE WAVE 1 HANDOFF

## Files Changed
- `mt5/AuroraSentinel.mq5`
- `mt5/ASC_Common.mqh`
- `mt5/ASC_Engine.mqh`
- `office/HANDOFF_ENGINE_WAVE1.md`

## Exact Fixes Applied
- Added `mt5/ASC_Common.mqh` as the single shared contract surface for the current frozen first-slice integration, defining only the shared types and function signatures required by `ASC_Market.mqh` and Engine wiring.
- Added `mt5/ASC_Engine.mqh` with a minimal Engine orchestration entrypoint that calls Market discovery and Market truth-building without introducing ranking, storage, output, or cross-domain logic.
- Added `mt5/AuroraSentinel.mq5` with flat-layout includes for the shared contract, Market module, and Engine module so the EA is structurally wired for MT5 integration in one folder.
- Normalized this handoff file to the required format and restricted it to Engine-owned integration fixes.

## Remaining Dependency Risks
- `office/CLERK_REVIEW_WAVE1.md` and `office/DEBUG_REVIEW_WAVE1.md` were referenced by the task packet but are not present in the repository, so this fix wave could not address any file-specific inline comments from those documents.
- `mt5/ASC_Conditions.mqh`, `mt5/ASC_Storage.mqh`, and `mt5/ASC_Output.mqh` are still absent from the repository, so full end-to-end module include integration remains dependent on future worker-owned deliveries.
- `mt5/ASC_Market.mqh` remains owned by Market and was intentionally left unchanged, including any unresolved compile or behavior risks inside that file.
