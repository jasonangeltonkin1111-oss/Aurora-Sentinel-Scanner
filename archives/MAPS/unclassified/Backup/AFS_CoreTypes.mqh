//+------------------------------------------------------------------+
//|                                                    AFS_CoreTypes |
//|                     Aegis Forge Scanner - Phase 1 / Step 2       |
//+------------------------------------------------------------------+
#ifndef __AFS_CORETYPES_MQH__
#define __AFS_CORETYPES_MQH__

#define AFS_MAX_SPREAD_SAMPLES 16

//==================================================================
// AFS PROTECTED CORE CONTRACT MAP
//==================================================================
// CORE / HARD-LOCKED:
// - AFS_UniverseSymbol
// - AFS_RuntimeState
// - AFS_MemoryShell
// - AFS_OutputPathState
//
// DO NOT casually repurpose, rename, or change semantics of fields in
// these shared structs. They are read by scan/runtime, selection,
// correlation, warm-state, dossier, summary, HUD, and publication
// routing layers.
//
// SAFE CHANGE MODES AROUND THESE STRUCTS:
// - additive field only
// - shadow/effective field beside raw field
// - wrapper/helper around read access
//
// FORBIDDEN WITHOUT FULL TRACE:
// - changing raw runtime fields into display/effective fields
// - reusing Step 8 / 9 / 10 truth fields for publication shortcuts
// - mutating startup / warm-state contracts indirectly through edits here
//==================================================================

enum AFS_EffectiveMode
  {
   MODE_DEV = 0,
   MODE_TRADER = 1
  };

enum AFS_HUDProfile
  {
   HUD_COMPACT = 0,
   HUD_NORMAL  = 1,
   HUD_DEBUG   = 2
  };

enum AFS_OutputProfile
  {
   OUTPUT_FINAL_ONLY     = 0,
   OUTPUT_SELECTED_SCOPE = 1,
   OUTPUT_ANOMALIES_ONLY = 2,
   OUTPUT_MODULE_SUMMARY = 3,
   OUTPUT_RAW_DEBUG      = 4
  };

enum AFS_PipelineTarget
  {
   PIPELINE_SURFACE          = 0,
   PIPELINE_CLASSIFICATION   = 1,
   PIPELINE_MARKETCORE       = 2,
   PIPELINE_HISTORY_FRICTION = 3,
   PIPELINE_ELIGIBILITY      = 4,
   PIPELINE_RANKING          = 5,
   PIPELINE_CORRELATION      = 6,
   PIPELINE_FULL             = 7
  };

enum AFS_TestTarget
  {
   TEST_NONE           = 0,
   TEST_SURFACE        = 1,
   TEST_CLASSIFICATION = 2,
   TEST_ECONOMICS      = 3,
   TEST_HISTORY        = 4,
   TEST_FRICTION       = 5,
   TEST_ELIGIBILITY    = 6,
   TEST_RANKING        = 7,
   TEST_CORRELATION    = 8,
   TEST_SCHEDULING     = 9,
   TEST_TRADER_INTEL   = 10
  };

enum AFS_ModuleStateCode
  {
   MODULE_IDLE    = 0,
   MODULE_READY   = 1,
   MODULE_RUNNING = 2,
   MODULE_OK      = 3,
   MODULE_WARN    = 4,
   MODULE_FAIL    = 5
  };

enum AFS_RotationMode
  {
   ROTATION_STAGED = 0
  };

enum AFS_SurfaceUpdatePolicy
  {
   SURFACE_ROUND_ROBIN = 0
  };

enum AFS_DeepUpdatePolicy
  {
   DEEP_PRIORITY_REFRESH = 0
  };

enum AFS_PromoteThresholdProfile
  {
   PROMOTE_BALANCED = 0
  };

struct AFS_ModuleState
  {
   string               Name;
   AFS_ModuleStateCode  State;
   string               Detail;
  };

struct AFS_OutputPathState
  {
   // Shared path shell. Canonical trader-package targets are trader/ and logs/.
   // Legacy-looking fields below remain preserved because startup, route state,
   // warm-state, or downstream continuity may still depend on them.
   bool     UseCommonFiles;
   bool     Ready;

   string   RootFolderName;
   string   ServerKey;

   string   RootFolder;
   string   ServerFolder;
   string   RuntimeFolder;
   string   LogsFolder;
   string   DebugFolder;
   string   DevFolder;
   string   TraderFolder;
   string   FinalOutputFolder;
   string   FinalOutputFile;
   string   TraderDataFolder;
   string   TraderDataFile;

   string   ActiveModeFolder;
   string   ActiveSummaryFile;
   string   ActiveCsvFile;

   string   LastError;
  };

struct AFS_MemoryShell
  {
   bool      Ready;
   datetime  CreatedAt;
   datetime  LastTouchedAt;
   datetime  LastSurfaceAt;
   datetime  LastFullSurfaceAt;
   datetime  LastSurfaceResetAt;

   int       BrokerSymbolCount;
   int       LoadedUniverseCount;
   int       EligibleSymbolCount;
   int       UniverseCount;
   int       ClassifiedSymbolCount;
   int       UnresolvedSymbolCount;
   int       SurfaceCount;
   int       SurfaceLoadedCount;
   int       DeepCount;
   int       FinalistCount;

   int       ExchangeCoverageCount;
   int       ISINCoverageCount;
   int       BrokerSectorCoverageCount;
   int       BrokerIndustryCoverageCount;
   int       BrokerClassCoverageCount;

   int       SurfaceCursor;
   int       SurfaceLastBatchCount;
   int       SurfacePassCount;
   int       SurfaceFreshCount;
   int       SurfaceStaleCount;
   int       SurfaceNoQuoteCount;
   int       SurfacePromotedCount;
   int       SurfaceFirstSeenCount;

   int       SpecCount;
   int       SpecPassCount;
   int       SpecWeakCount;
   int       SpecFailCount;
   int       SpecCursor;

   int       HistoryCount;
   int       HistoryPassCount;
   int       HistoryWeakCount;
   int       HistoryFailCount;
   int       HistoryCursor;

   int       FrictionCount;
   int       FrictionPassCount;
   int       FrictionWeakCount;
   int       FrictionFailCount;
   int       FrictionCursor;

   string    LastSurfaceResetReason;
  };

//==================================================================
// PROTECTED SHARED STATE: AFS_UniverseSymbol
// Raw scanner/runtime truth lives here.
// Publication must READ from here or from downstream effective/shadow
// views; publication must not overwrite semantic meaning here.
//==================================================================

struct AFS_UniverseSymbol
  {
   string   Symbol;
   string   Path;
   string   Description;
   string   ISIN;
   string   Exchange;
   string   CurrencyBase;
   string   CurrencyProfit;
   string   CurrencyMargin;

   string   BrokerSector;
   string   BrokerIndustry;
   string   Sector;
   string   Industry;
   string   BrokerClass;
   string   SessionQuotes;
   string   SessionTrades;

   string   NormalizedSymbol;
   string   NormalizedAlias;
   string   CanonicalSymbol;
   string   DisplayName;
   string   AssetClass;
   string   PrimaryBucket;
   string   ThemeBucket;
   string   SubType;
   string   AliasKind;
   string   ClassificationStatus;
   string   ClassificationConfidence;
   string   ClassificationReviewStatus;
   string   ClassificationNotes;

   int      Digits;
   int      Spread;
   int      StopsLevel;
   int      FreezeLevel;
   int      TradeMode;
   int      CalcMode;
   int      ExecMode;
   int      FillingMode;
   int      ExpirationMode;
   int      OrderMode;
   int      SwapMode;

   double   Point;
   double   TickSize;
   double   TickValue;
   double   TickValueProfit;
   double   TickValueLoss;
   double   ContractSize;
   double   VolumeMin;
   double   VolumeMax;
   double   VolumeStep;
   double   VolumeLimit;
   double   SwapLong;
   double   SwapShort;
   double   MarginInitial;
   double   MarginMaintenance;
   double   MarginLong;
   double   MarginShort;

   bool     Exists;
   bool     Selected;
   bool     Visible;
   bool     Custom;
   bool     SpreadFloat;
   bool     TradeAllowed;
   bool     ScopeIncluded;
   bool     ClassificationResolved;
   bool     SurfaceSeen;
   bool     QuotePresent;
   bool     PromotionCandidate;

   datetime LastTickTime;
   datetime LastSurfaceUpdateAt;
   datetime LastSpecUpdateAt;
   datetime LastHistoryUpdateAt;
   datetime LastFrictionUpdateAt;

   int      TickAgeSec;
   int      SpecUpdateCount;
   int      SurfaceUpdateCount;
   int      HistoryUpdateCount;
   int      FrictionUpdateCount;
   int      FrictionSampleCountUsed;
   int      BarsM15;
   int      BarsH1;
   int      SpreadSampleWritePos;
   int      SpreadSampleCount;

   double   Bid;
   double   Ask;
   double   SpreadSnapshot;
   double   SessionHigh;
   double   SessionLow;
   double   SessionOpen;
   double   SessionClose;
   double   BidHigh;
   double   BidLow;
   double   AskHigh;
   double   AskLow;
   double   DailyChangePercent;
   double   TickValueRaw;
   double   TickValueDerived;
   double   TickValueValidated;
   double   MarginHedged;
   double   CommissionValue;
   double   AtrM15;
   double   AtrH1;
   double   BaselineMove;
   double   MovementCapacityScore;
   double   MedianSpread;
   double   MaxSpread;
   double   SpreadAtrRatio;
   double   LivelinessScore;
   double   FreshnessScore;
   double   CostEfficiencyScore;
   double   TrustScore;
   double   TotalScore;
   double   CorrMax;
   double   SpreadSampleRing[AFS_MAX_SPREAD_SAMPLES];
   datetime SpreadSampleTimeRing[AFS_MAX_SPREAD_SAMPLES];

   string   CommissionMode;
   string   CommissionCurrency;
   string   CommissionStatus;
   string   SpecIntegrityStatus;
   string   EconomicsTrust;
   string   NormalizationStatus;
   string   PracticalityStatus;
   string   EconomicsFlags;

   string   QuoteState;
   string   SessionState;
   string   SurfaceFlags;
   string   PromotionState;
   string   PromotionReason;

   string   HistoryStatus;
   string   HistoryFlags;
   string   FrictionStatus;
   string   FrictionFlags;
   string   FrictionTruthState;
   string   FrictionFailReason;
   string   FrictionWeakReason;
   string   FrictionHydrationStage;
   string   CorrClosestSymbol;
   string   CorrContextFlag;

   bool     FrictionHoldPass;
   bool     FrictionMarketLive;
   bool     FrictionSessionOpen;
   bool     FrictionQuoteUsable;
   bool     FinalistSelected;

   int      FrictionHydrationScore;
   int      BucketRank;
   int      FrictionGoodPasses;
   int      FrictionBadPasses;

   datetime LastTradableEvidenceAt;
   datetime LastAliveEvidenceAt;
   datetime LastRankingUpdateAt;
  };


struct AFS_TI_OhlcBar
  {
   long     TimeUnix;
   double   Open;
   double   High;
   double   Low;
   double   Close;
   long     TickVolume;
   int      Spread;
   long     RealVolume;
  };

struct AFS_TI_TimeframeCache
  {
   ENUM_TIMEFRAMES Timeframe;
   int             TargetBars;
   int             RefreshAgeSec;
   datetime        LastRefreshAt;
   datetime        LastBarTime;
   bool            HasData;
   int             BarCount;
   string          Status;
   string          LastError;
   AFS_TI_OhlcBar  Bars[];
  };

struct AFS_TI_SymbolCache
  {
   string                 RawSymbol;
   string                 CanonicalSymbol;
   string                 MaterialSignature;
   datetime               LastTouchedAt;
   datetime               LastMaterialChangeAt;
   bool                   Dirty;

   AFS_TI_TimeframeCache  M1;
   AFS_TI_TimeframeCache  M5;
   AFS_TI_TimeframeCache  M15;
   AFS_TI_TimeframeCache  H1;
  };

struct AFS_TraderIntelState
  {
   bool                Enabled;
   string              SchemaVersion;
   string              LastShortlistSignature;
   string              LastPayloadSignature;
   datetime            LastWriteAt;
   bool                ForceRefresh;
   int                 CacheCount;
   AFS_TI_SymbolCache  Caches[];
  };


struct AFS_RuntimeState
  {
   bool                 Initialized;
   bool                 Enabled;
   bool                 ModeForcedToDev;
   bool                 TimerPaused;
   bool                 ClassificationMapReady;

   int                  InitCount;
   int                  TimerCount;

   datetime             LastTimerAt;
   datetime             LastHudAt;
   datetime             ServerTime;

   string               ServerName;
   string               SymbolName;
   long                 ChartId;
   ENUM_TIMEFRAMES      ChartTf;

   AFS_EffectiveMode    RequestedMode;
   AFS_EffectiveMode    EffectiveMode;
   string               EffectiveModeText;

   AFS_HUDProfile       ActiveHUDProfile;

   bool                 ViewShowNotes;
   bool                 ViewShowModules;
   bool                 ViewShowScheduling;
   bool                 ViewShowScope;
   bool                 ViewShowCorrelationPreview;
   bool                 ViewShowDebugFooter;
   bool                 ViewShowControlRail;

   string               LastWarning;
   string               LastError;
   string               LastInfo;
   string               BuildStamp;
   string               ClassificationMapFile;
   string               ClassificationAliasFile;
   string               ClassificationCanonicalFile;

   AFS_OutputPathState  PathState;
   AFS_MemoryShell      MemoryShell;
   AFS_UniverseSymbol   Universe[];
   string               UniverseRawFile;
   string               UniverseBrokerViewFile;
   string               ClassificationReviewFile;

   AFS_ModuleState      Classification;
   AFS_ModuleState      MarketCore;
   AFS_ModuleState      HistoryFriction;
   AFS_ModuleState      Selection;
   AFS_ModuleState      OutputDebug;
   AFS_TraderIntelState TraderIntel;
  };

string AFS_ModeToText(AFS_EffectiveMode mode)
  {
   switch(mode)
     {
      case MODE_DEV:    return "Dev Mode";
      case MODE_TRADER: return "Trader Mode";
     }
   return "Unknown Mode";
  }

string AFS_HUDProfileToText(AFS_HUDProfile profile)
  {
   switch(profile)
     {
      case HUD_COMPACT: return "Compact";
      case HUD_NORMAL:  return "Normal";
      case HUD_DEBUG:   return "Debug";
     }
   return "Unknown HUD";
  }

string AFS_OutputProfileToText(AFS_OutputProfile profile)
  {
   switch(profile)
     {
      case OUTPUT_FINAL_ONLY:     return "Final Only";
      case OUTPUT_SELECTED_SCOPE: return "Selected Scope";
      case OUTPUT_ANOMALIES_ONLY: return "Anomalies Only";
      case OUTPUT_MODULE_SUMMARY: return "Module Summary";
      case OUTPUT_RAW_DEBUG:      return "Raw Debug";
     }
   return "Unknown Output";
  }

string AFS_PipelineTargetToText(AFS_PipelineTarget target)
  {
   switch(target)
     {
      case PIPELINE_SURFACE:          return "Surface";
      case PIPELINE_CLASSIFICATION:   return "Classification";
      case PIPELINE_MARKETCORE:       return "Market Core";
      case PIPELINE_HISTORY_FRICTION: return "History Friction";
      case PIPELINE_ELIGIBILITY:      return "Eligibility";
      case PIPELINE_RANKING:          return "Selection";
      case PIPELINE_CORRELATION:      return "Correlation";
      case PIPELINE_FULL:             return "Full";
     }
   return "Unknown Pipeline";
  }

string AFS_TestTargetToText(AFS_TestTarget target)
  {
   switch(target)
     {
      case TEST_NONE:           return "None";
      case TEST_SURFACE:        return "Surface";
      case TEST_CLASSIFICATION: return "Classification";
      case TEST_ECONOMICS:      return "Economics";
      case TEST_HISTORY:        return "History";
      case TEST_FRICTION:       return "Friction";
      case TEST_ELIGIBILITY:    return "Eligibility";
      case TEST_RANKING:        return "Selection";
      case TEST_CORRELATION:    return "Correlation";
      case TEST_SCHEDULING:     return "Scheduling";
      case TEST_TRADER_INTEL:   return "Trader Intel";
     }
   return "Unknown Test";
  }

string AFS_ModuleStateToText(AFS_ModuleStateCode state)
  {
   switch(state)
     {
      case MODULE_IDLE:    return "Idle";
      case MODULE_READY:   return "Ready";
      case MODULE_RUNNING: return "Running";
      case MODULE_OK:      return "OK";
      case MODULE_WARN:    return "Warn";
      case MODULE_FAIL:    return "Fail";
     }
   return "UNKNOWN";
  }

string AFS_RotationModeToText(AFS_RotationMode mode)
  {
   switch(mode)
     {
      case ROTATION_STAGED: return "Staged";
     }
   return "ROTATION_UNKNOWN";
  }

string AFS_SurfaceUpdatePolicyToText(AFS_SurfaceUpdatePolicy policy)
  {
   switch(policy)
     {
      case SURFACE_ROUND_ROBIN: return "Round Robin";
     }
   return "SURFACE_POLICY_UNKNOWN";
  }

string AFS_DeepUpdatePolicyToText(AFS_DeepUpdatePolicy policy)
  {
   switch(policy)
     {
      case DEEP_PRIORITY_REFRESH: return "Priority Refresh";
     }
   return "DEEP_POLICY_UNKNOWN";
  }

string AFS_PromoteThresholdProfileToText(AFS_PromoteThresholdProfile profile)
  {
   switch(profile)
     {
      case PROMOTE_BALANCED: return "Balanced";
     }
   return "PROMOTE_PROFILE_UNKNOWN";
  }

#endif