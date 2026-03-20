# ASC Code Shape and File Layout

## Purpose

This file tells GPT/Codex how the MT5 codebase should physically look so architecture is visible in the source tree.

## Current repo reality

The archive contains:
- active blueprint docs
- a flat `mt5_runtime_flat/` foundation implementation
- older archive code in flat MT5 style

## Recommended long-term source layout

```text
mt5/
  AuroraSentinel.mq5
  Include/
    ASC/
      Common/
        ASC_Types.mqh
        ASC_Enums.mqh
        ASC_Status.mqh
        ASC_Time.mqh
        ASC_Strings.mqh
      Runtime/
        ASC_RuntimeKernel.mqh
        ASC_RuntimeModes.mqh
        ASC_Scheduler.mqh
        ASC_Budgeting.mqh
        ASC_Restore.mqh
      Discovery/
        Specs/
          ASC_SymbolSpecs_Collector.mqh
          ASC_SymbolSpecs_Store.mqh
          ASC_SymbolSpecs_Accessor.mqh
        MarketWatch/
          ASC_MarketWatch_Collector.mqh
          ASC_MarketWatch_Store.mqh
          ASC_MarketWatch_Accessor.mqh
        Sessions/
          ASC_SessionTruth.mqh
        History/
          ASC_HistoryAccess.mqh
      Layers/
        ASC_Layer1_MarketState.mqh
        ASC_Layer2_Snapshot.mqh
        ASC_Layer3_Filter.mqh
        ASC_Layer4_Selection.mqh
        ASC_Layer5_DeepAnalysis.mqh
      Publication/
        ASC_DossierWriter.mqh
        ASC_SummaryWriter.mqh
        ASC_AtomicWrite.mqh
        ASC_Paths.mqh
        ASC_RuntimePersistence.mqh
        ASC_SchedulerPersistence.mqh
      Presentation/
        ASC_HUD.mqh
        ASC_LabelMap.mqh
      Diagnostics/
        ASC_Log.mqh
        ASC_Trace.mqh
```

## Current foundation mapping

The flat foundation files map approximately as:

- `ASC_F1_Common.mqh` -> common enums/types/helpers
- `ASC_F1_ServerPaths.mqh` -> publication paths
- `ASC_F1_Logging.mqh` -> diagnostics
- `ASC_F1_FileIO.mqh` -> atomic write helpers
- `ASC_F1_MarketState.mqh` -> Layer 1 market state logic
- `ASC_F1_Persistence.mqh` -> runtime/scheduler/summary persistence
- `ASC_F1_Dossiers.mqh` -> dossier text builder
- `AuroraSentinel_Foundation.mq5` -> root EA kernel shell

## File ownership rules

### Root EA file
Should:
- own globals/bootstrap
- wire services together
- start and stop timer
- call kernel heartbeat

Should not:
- hold every business rule directly
- contain giant feature logic blobs

### Include modules
Should:
- map to architecture domains
- expose narrow interfaces
- keep responsibilities meaningful

## Naming rules

Use names that reflect meaning, not office/build workflow chatter.

Good:
- `ASC_Layer1_MarketState.mqh`
- `ASC_DossierWriter.mqh`

Bad:
- `Phase3PacketWorker.mqh`
- `Step5RefactorTemp.mqh`

## Struct and DTO discipline

Use explicit structs/classes for:
- runtime state
- server paths
- symbol state
- due items
- specs records
- snapshot records
- publication state
- deep analysis state

Avoid:
- many parallel loose arrays with fragile implicit alignment
- giant catch-all global structs with no domain ownership

## Function-shape rules

Prefer:
- small functions with one ownership purpose
- collector/store/accessor pattern
- pure formatting functions in writers
- explicit `Try...` functions for possibly unavailable data

Avoid:
- “do everything” functions
- helper blobs with mixed retrieval, ranking, and writing
- hidden side effects in getters
