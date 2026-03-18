# CONDITIONS WAVE 1 HANDOFF

### 1. CHANGED FILES
- `mt5/ASC_Conditions.mqh`
- `office/HANDOFF_CONDITIONS_WAVE1.md`

### 2. SCOPE CHECK
- Domain remained inside Conditions-owned broker-spec intake and validation.
- No ranking logic was added.
- No ATR/history retrieval was added.
- No output formatting was added.
- No file persistence was added.
- No classification logic was added.
- No downstream activation or promotion logic was added.

### 3. ARCHIVE USE NOTE
- No archive truth was translated directly into Conditions behavior in this fix wave.
- Archive materials remained reference only.
- No archive-derived ranking, strategy, or classification logic was introduced from Conditions.

### 4. COMPLETION CHECK
- `ASC_Conditions_Load(const string symbol, ASC_SymbolRecord &record)` is active in live product code.
- Broker spec intake covers digits, spread, spread-float mode, point, tick size, tick value, contract size, and volume min/max/step.
- Conditions truth is reset explicitly before broker reads.
- Readable fields are now copied into the record immediately instead of being gated behind an all-fields-readable block.
- Read failures remain explicit as unreadable.
- Validation failures remain explicit as invalid.
- Reset sentinels remain explicit invalid markers rather than fake zeros.
- The merged Conditions fix materially resolved the earlier all-or-nothing partial-truth blocker identified in pre-fix Debug review.

### 5. OPEN RISKS
- Non-blocking follow-up remains if HQ later wants per-field readability/validity markers in the shared contract instead of one aggregate `SpecsReadable` flag plus `SpecsReason`.
- Some brokers may expose readable fields with zero-like values; those remain preserved but can still fail integrity validation.
- Conditions success in Wave 1 does not imply later summary/dossier or ranking layers are complete.
