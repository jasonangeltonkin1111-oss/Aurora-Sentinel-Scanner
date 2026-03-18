# MARKET WAVE 1 HANDOFF

## Files Changed
- `mt5/ASC_Market.mqh`
- `office/HANDOFF_MARKET_WAVE1.md`

## Exact Fixes Applied
- Added `mt5/ASC_Market.mqh` using the shared `ASC_Common.mqh` contract names directly instead of introducing alternate Market-side types.
- Implemented `ASC_Market_DiscoverSymbols(string &symbols[])` using broker symbol discovery from the terminal symbol list.
- Implemented `ASC_Market_BuildIdentityAndTruth(const string symbol, const ASC_RuntimeConfig &config, ASC_SymbolRecord &record)` so identity and market truth populate only the shared struct fields.
- Removed string-based session-state handling by using only `ASC_SessionTruthStatus` enum values in Market truth resolution.

## Session Truth Alignment
- `SessionTruthStatus` is populated only with shared enum values: `ASC_SESSION_UNKNOWN`, `ASC_SESSION_OPEN_TRADABLE`, `ASC_SESSION_CLOSED_SESSION`, `ASC_SESSION_QUOTE_ONLY`, `ASC_SESSION_TRADE_DISABLED`, `ASC_SESSION_NO_QUOTE`, and `ASC_SESSION_STALE_FEED`.
- `Layer1Eligible` is true only when Market resolves `ASC_SESSION_OPEN_TRADABLE`.
- `IneligibleReason` stays explicit for unknown, closed, quote-only, disabled, no-quote, and stale-feed outcomes.
- `NextRecheckTime` uses a bounded timer-based retry and does not guess a synthetic market-open boundary.

## Shared Contract Alignment
- `ASC_SymbolIdentity` fields are populated exactly from the shared contract surface.
- `PrimaryBucket` remains `"UNKNOWN"` when classification is unresolved.
- `ClassificationReason` remains explicit instead of inventing a fallback bucket.
- `ASC_MarketTruth` fields are populated without adding string-based duplicate state.

## Classification Handling
- The file preserves unresolved classification truth explicitly.
- `CanonicalSymbol` currently follows the normalized symbol because the archive translation table has not yet been loaded into active product code.
- No guessed asset-class, sector, industry, theme, or bucket replacement logic was added.

## Remaining Dependency Risks
- `mt5/ASC_Common.mqh` is still absent in the repository, so full compile validation of the shared contract remains blocked.
- The archive classification table has not yet been translated into active Market lookup code, so classification remains explicitly unresolved instead of being guessed.
- Session APIs can differ across brokers; unreadable or missing session data currently fail fast into `ASC_SESSION_UNKNOWN` as required by the contract.

## ARCHIVE USE NOTE
- `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh` — TRANSLATE. Extracted only the rule that Market owns broker symbol identity/classification truth and must preserve unresolved outcomes explicitly.
- `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh` — REFERENCE ONLY. Used only as naming/state-surface reference to avoid inventing non-contract Market fields.
- Legacy scope rejected: old scanner-wide shared structs, publication scaffolding, HUD/runtime modes, ranking logic, and any output/storage/execution behavior.
- Active files changed as a result: `mt5/ASC_Market.mqh`, `office/HANDOFF_MARKET_WAVE1.md`.
