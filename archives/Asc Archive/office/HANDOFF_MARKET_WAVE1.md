# MARKET WAVE 1 HANDOFF

### 1. CHANGED FILES
- `mt5/ASC_Market.mqh`
- `office/HANDOFF_MARKET_WAVE1.md`

### 2. SCOPE CHECK
- Domain remained inside Market-owned symbol discovery, identity truth, classification translation, and session-truth handling.
- No Storage, Output, ranking, or execution logic was added.
- No writer-side computation was introduced.
- No later-layer summary or dossier logic was introduced.

### 3. ARCHIVE USE NOTE
- `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh` — TRANSLATE. Used to activate archive-backed classification translation into current Market identity truth.
- `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh` — REFERENCE ONLY. Used only as structural reference to avoid inventing non-contract fields.
- Legacy scope rejected: old scanner-wide shared structs, publication scaffolding, HUD/runtime modes, ranking logic, and any output/storage/execution behavior.

### 4. COMPLETION CHECK
- `ASC_Market_DiscoverSymbols(string &symbols[])` is active in live product code.
- `ASC_Market_BuildIdentityAndTruth(const string symbol, const ASC_RuntimeConfig &config, ASC_SymbolRecord &record)` now populates shared contract fields only.
- Archive-backed classification translation is now active in live product code.
- `CanonicalSymbol`, `AssetClass`, `PrimaryBucket`, `Sector`, `Industry`, and `Theme` now receive translated truth when translation exists.
- Unresolved cases remain explicit as `UNKNOWN` with explicit unresolved reason rather than guessed replacements.
- `SessionTruthStatus` uses shared enum values only.
- Layer 1 eligibility is no longer falsified by unresolved classification.
- Non-eligible and unknown symbols are preserved into Layer 1.2 snapshot truth instead of being dropped.

### 5. OPEN RISKS
- Non-blocking follow-up remains around finer `ClassificationResolved` granularity if later layers need partial-vs-full classification quality.
- Non-blocking follow-up remains around more state-specific `NextRecheckTime` behavior.
- Market success in Wave 1 does not imply later ranking or summary layers are complete.
