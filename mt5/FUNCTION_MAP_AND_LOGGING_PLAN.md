# MT5 Function Map and Logging Plan

This file maps the active MT5 runtime surface so the logger can show whether each step ran, failed, or completed with usable state.

## Runtime call chain

`OnInit` -> `ASC_Logger_Start` -> `ASC_Engine_RunInit` -> `ASC_Storage_LoadUniverseSnapshot` -> `ASC_Market_DiscoverSymbols` -> `ASC_Engine_ProcessSymbols` -> `ASC_Market_BuildIdentityAndTruth` -> `ASC_Conditions_Load` -> `ASC_Surface_Evaluate` -> `ASC_Storage_SaveUniverseSnapshot` -> `ASC_Output_WriteUniverseSnapshotMirror`

`OnTimer` -> `ASC_Engine_RunTimer` -> same scan/write pipeline as above.

`OnDeinit` -> `ASC_Logger_Stop`

## Exact function inventory by MT5 file

### `ASC_Conditions.mqh`

- `IsFiniteNumber`
- `IsFinitePositive`
- `AppendReason`
- `ResetConditionsTruth`
- `ReadIntegerSpec`
- `ReadDoubleSpec`
- `ReadStringSpec`
- `ApplyIntegerSpec`
- `ApplyBooleanSpec`
- `ApplyDoubleSpec`
- `ApplyStringSpec`
- `AppendInvalidDoubleReason`
- `IsMeaningfulText`
- `AppendSpecWeakness`
- `TryReadMarginRate`
- `ResolveNormalizationStatus`
- `ASC_Conditions_Load`

### `ASC_Engine.mqh`

- `ASC_Engine_ResetRecord`
- `ASC_Engine_FindRecordIndex`
- `ASC_Engine_FindRecordIndexBySymbol`
- `ASC_Engine_UpsertRecord`
- `ASC_Engine_PreserveUniverseMembership`
- `ASC_Engine_AdvanceCursor`
- `ASC_Engine_ProcessSymbols`
- `ASC_Engine_RunInit`
- `ASC_Engine_RunTimer`

### `ASC_Logger.mqh`

- `ASC_Logger_OpenFlags`
- `ASC_Logger_Timestamp`
- `ASC_Logger_WriteLine`
- `ASC_Logger_Start`
- `ASC_Logger_Stop`
- `ASC_Logger_Log`
- `ASC_Logger_LogResult`

### `ASC_Market.mqh`

- `AppendReason`
- `Trim`
- `UpperTrim`
- `ResetIdentity`
- `ResetMarketTruth`
- `EndsWith`
- `IsAsciiAlphaNumeric`
- `TrimTrailingNormalizationNoise`
- `StripKnownBrokerSuffixes`
- `RemovePunctuation`
- `NormalizeSymbol`
- `CurrentServerKey`
- `ParseClassificationRow`
- `EnsureClassificationLoaded`
- `ClassificationRowMatches`
- `IsMeaningfulValue`
- `ApplyClassification`
- `ResolveClassification`
- `LoadFlag`
- `LoadInteger`
- `TradeModePermitsNewExposure`
- `LoadTickTime`
- `LoadTickEvidence`
- `HasSessionReference`
- `CurrentServerTime`
- `FormatTimeOfDay`
- `FormatSessionRange`
- `AppendSessionRange`
- `BuildSessionDaySummary`
- `LoadWeeklySessionSchedule`
- `ResolveQuoteFreshnessStatus`
- `LoadIdentityMetadata`
- `SecondsOfDay`
- `IsWithinSessionRange`
- `ProbeSessionWindow`
- `IsContinuousMarketClass`
- `CompareSymbols`
- `SortSymbols`
- `UniqueInPlace`
- `ResolveNextRecheckTime`
- `ResolveSessionStatus`
- `ASC_Market_DiscoverSymbols`
- `ASC_Market_BuildIdentityAndTruth`

### `ASC_Output.mqh`

- `ASC_Output_OpenFlags`
- `ASC_Output_BoolText`
- `ASC_Output_Trim`
- `ASC_Output_IsMeaningfulValue`
- `ASC_Output_SanitizePathComponent`
- `ASC_Output_ResolveBrokerIdentity`
- `ASC_Output_BrokerName`
- `ASC_Output_SummaryFileName`
- `ASC_Output_SymbolDirectory`
- `ASC_Output_RecordDisplaySymbol`
- `ASC_Output_RecordTitle`
- `ASC_Output_SymbolFileName`
- `ASC_Output_WriteStringField`
- `ASC_Output_WriteIntegerField`
- `ASC_Output_WriteDoubleField`
- `ASC_Output_WriteSectionHeader`
- `ASC_Output_SessionStatusText`
- `ASC_Output_TradeModeText`
- `ASC_Output_CalcModeText`
- `ASC_Output_ChartModeText`
- `ASC_Output_ExecutionModeText`
- `ASC_Output_GtcModeText`
- `ASC_Output_FillingModeText`
- `ASC_Output_ExpirationModeText`
- `ASC_Output_OrderModeText`
- `ASC_Output_SwapModeText`
- `ASC_Output_RecordHasPublishedTruth`
- `ASC_Output_PublicationStateText`
- `ASC_Output_PrimaryBucketLabel`
- `ASC_Output_RecordRoute`
- `ASC_Output_WriteLinesAtomically`
- `ASC_Output_WriteIdentityBlock`
- `ASC_Output_WriteClassificationBlock`
- `ASC_Output_WriteMarketStateBlock`
- `ASC_Output_WriteTradingRulesBlock`
- `ASC_Output_WriteEconomicsBlock`
- `ASC_Output_WriteSwapBlock`
- `ASC_Output_WriteSessionsBlock`
- `ASC_Output_WriteMarginBlock`
- `ASC_Output_WriteHistoryStatusBlock`
- `ASC_Output_WriteCalculationStatusBlock`
- `ASC_Output_WriteSummarySurface`
- `ASC_Output_WriteSymbolDossier`
- `ASC_Output_WriteSymbolSurfaces`
- `ASC_Output_RemoveStaleSymbolFiles`
- `ASC_Output_WriteMirrorRecord`
- `ASC_Output_WriteUniverseSnapshotMirror`

### `ASC_Storage.mqh`

- `ASC_Storage_EscapeField`
- `ASC_Storage_UnescapeField`
- `ASC_Storage_OpenFlags`
- `ASC_Storage_DeleteFile`
- `ASC_Storage_ReadAllLines`
- `ASC_Storage_WriteAllLines`
- `ASC_Storage_FormatBool`
- `ASC_Storage_ParseBool`
- `ASC_Storage_ResetRecord`
- `ASC_Storage_PushString`
- `ASC_Storage_PushBool`
- `ASC_Storage_PushInt`
- `ASC_Storage_PushDatetime`
- `ASC_Storage_PushDouble`
- `ASC_Storage_PullString`
- `ASC_Storage_PullBool`
- `ASC_Storage_PullInt`
- `ASC_Storage_PullDatetime`
- `ASC_Storage_PullDouble`
- `ASC_Storage_FormatIdentityFields`
- `ASC_Storage_FormatMarketFields`
- `ASC_Storage_FormatConditionsFields`
- `ASC_Storage_ParseV3Record`
- `ASC_Storage_ParseLegacyRecord`
- `ASC_Storage_FormatRecord`
- `ASC_Storage_ParseRecordLine`
- `ASC_Storage_ParseSnapshotLines`
- `ASC_Storage_ReadSnapshotRecordCount`
- `ASC_Storage_LoadSnapshotFromFile`
- `ASC_Storage_CopyRecords`
- `ASC_Storage_LoadUniverseSnapshot`
- `ASC_Storage_SaveUniverseSnapshot`

### `ASC_Surface.mqh`

- `AppendReason`
- `ResetSurfaceTruth`
- `ReadSeriesState`
- `ComputeQuoteAgeSeconds`
- `ComputeSpreadScore`
- `ComputeFreshnessScore`
- `ComputeHistoryScore`
- `ASC_Surface_Evaluate`

### `AuroraSentinel.mq5`

- `ASC_LogVersionBlock`
- `OnInit`
- `OnTimer`
- `OnTick`
- `OnDeinit`

## New logger coverage

- EA lifecycle logging in `OnInit`, `OnTimer`, and `OnDeinit`.
- Engine orchestration logging in `ASC_Engine_ProcessSymbols`, `ASC_Engine_RunInit`, and `ASC_Engine_RunTimer`.
- Market, conditions, and surface stage outcome logging for each processed symbol.
- Snapshot load/save and mirror-write outcome logging for persistence and output debugging.

## Recommended next steps

- Add `GetLastError()` capture on broker API failures if you need lower-level MT5 diagnostics.
- Add a runtime verbosity switch if helper-level logging becomes too noisy in large universes.
- Add a pass id or correlation id if you want to group all log lines from one timer cycle.
