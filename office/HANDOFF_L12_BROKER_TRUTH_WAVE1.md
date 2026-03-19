# L1.2 BROKER TRUTH WAVE 1 HANDOFF

### 1. CHANGED FILES
- `mt5/ASC_Common.mqh`
- `mt5/ASC_Market.mqh`
- `mt5/ASC_Conditions.mqh`
- `mt5/ASC_Storage.mqh`
- `mt5/ASC_Output.mqh`
- `mt5/ASC_Engine.mqh`
- `office/HANDOFF_L12_BROKER_TRUTH_WAVE1.md`

### 2. SCOPE CHECK
- Stayed inside Layer 1.2 broker-truth and session-truth recovery.
- No ranking, activation, UI, strategy, or execution logic was added.
- `ASC_Engine.mqh` was touched only to keep the widened shared contract reset path coherent.

### 3. ARCHIVE USE NOTE
- `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh` — REFERENCE ONLY. Existing archive-backed identity translation remained the upstream classification spine.
- `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh` — TRANSLATE. Used for spec integrity, economics trust, normalization-status, and validated spec-surface vocabulary.
- `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh` — TRANSLATE. Used for broker observation breadth, session handling, and richer market/broker-state separation.
- `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5` — TRANSLATE. Used for concrete symbol-spec/session/swap/margin field coverage targets.
- `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5` — TRANSLATE. Used for cleaner dossier/snapshot separation and broader symbol-spec serialization discipline.
- Legacy scope rejected: giant legacy structs, ranking gates, execution behavior, commission engines, debug/UI ecosystems, and broader framework wrappers.

### 4. COMPLETION CHECK
- Layer 1.2 now preserves richer broker identity metadata, explicit weekly quote/trade schedules, quote freshness truth, and session consistency reasoning.
- Conditions truth now captures materially broader MT5 broker specification fields including stops, currencies, calc/chart/trade/execution/order modes, swap surfaces, and margin-rate surfaces.
- Shared vocabulary now includes bounded spec integrity, economics trust, normalization status, and truth-coverage status.
- Universe snapshot storage now persists the expanded truth surface under an explicit V3 schema while retaining legacy V1/V2 parse support.
- Symbol outputs are now structured as operator-facing broker dossiers with coherent sections rather than a thin broker-spec dump.

### 5. OPEN RISKS
- Native MetaEditor compile validation was not available in this container, so compile integrity could only be checked by source-level review and consistency passes.
- MT5 broker support for some advanced symbol properties varies by broker/build; unreadable fields remain explicit rather than guessed.
- Commission tables visible in MT5 Specification screenshots remain outside this bounded packet because current owned scope did not add a commission-truth submodel.
