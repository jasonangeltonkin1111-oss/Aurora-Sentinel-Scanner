#ifndef ASC_COMMON_MQH
#define ASC_COMMON_MQH

enum ASC_SessionTruthStatus
  {
   ASC_SESSION_UNKNOWN = 0,
   ASC_SESSION_OPEN_TRADABLE,
   ASC_SESSION_CLOSED_SESSION,
   ASC_SESSION_QUOTE_ONLY,
   ASC_SESSION_TRADE_DISABLED,
   ASC_SESSION_NO_QUOTE,
   ASC_SESSION_STALE_FEED
  };

enum ASC_SurfaceScanState
  {
   ASC_SURFACE_NOT_RUN = 0,
   ASC_SURFACE_SKIPPED,
   ASC_SURFACE_EVALUATED
  };

enum ASC_RecordHydrationState
  {
   ASC_RECORD_UNHYDRATED = 0,
   ASC_RECORD_PENDING_DISCOVERY_HYDRATION,
   ASC_RECORD_MARKET_PASS_COMPLETE,
   ASC_RECORD_MARKET_PASS_ONLY,
   ASC_RECORD_MARKET_PASS_ABSENT,
   ASC_RECORD_CURRENT_PASS_READY,
   ASC_RECORD_LEGACY_RECOVERED
  };

enum ASC_RecordAuthorityState
  {
   ASC_RECORD_AUTHORITY_NONE = 0,
   ASC_RECORD_AUTHORITY_PLACEHOLDER,
   ASC_RECORD_AUTHORITY_CURRENT_PASS,
   ASC_RECORD_AUTHORITY_SNAPSHOT_V3,
   ASC_RECORD_AUTHORITY_LEGACY
  };

enum ASC_RecordPublishabilityState
  {
   ASC_RECORD_PUBLISH_BLOCKED = 0,
   ASC_RECORD_PUBLISH_READY
  };

enum ASC_RecordIntegrityState
  {
   ASC_RECORD_INTEGRITY_UNREAD = 0,
   ASC_RECORD_INTEGRITY_SPEC_OK,
   ASC_RECORD_INTEGRITY_SPEC_SUSPICIOUS,
   ASC_RECORD_INTEGRITY_SPEC_PRESERVED_PRIOR,
   ASC_RECORD_INTEGRITY_SPEC_UNREADABLE,
   ASC_RECORD_INTEGRITY_SPEC_BROKER_MISSING,
   ASC_RECORD_INTEGRITY_SPEC_CONTRADICTORY,
   ASC_RECORD_INTEGRITY_SPEC_BROKEN
  };

string ASC_RecordHydrationStateText(const ASC_RecordHydrationState state)
  {
   switch(state)
     {
      case ASC_RECORD_PENDING_DISCOVERY_HYDRATION: return("PENDING_DISCOVERY_HYDRATION");
      case ASC_RECORD_MARKET_PASS_COMPLETE: return("MARKET_PASS_COMPLETE");
      case ASC_RECORD_MARKET_PASS_ONLY: return("MARKET_PASS_ONLY");
      case ASC_RECORD_MARKET_PASS_ABSENT: return("MARKET_PASS_ABSENT");
      case ASC_RECORD_CURRENT_PASS_READY: return("CURRENT_PASS_READY");
      case ASC_RECORD_LEGACY_RECOVERED: return("LEGACY_RECOVERED");
      default: return("UNHYDRATED");
     }
  }

string ASC_RecordAuthorityStateText(const ASC_RecordAuthorityState state)
  {
   switch(state)
     {
      case ASC_RECORD_AUTHORITY_PLACEHOLDER: return("PLACEHOLDER");
      case ASC_RECORD_AUTHORITY_CURRENT_PASS: return("CURRENT_PASS");
      case ASC_RECORD_AUTHORITY_SNAPSHOT_V3: return("SNAPSHOT_V3");
      case ASC_RECORD_AUTHORITY_LEGACY: return("LEGACY");
      default: return("NONE");
     }
  }

string ASC_RecordNormalizePublishabilityState(const string value);

string ASC_RecordPublishabilityStateText(const ASC_RecordPublishabilityState state)
  {
   return(state == ASC_RECORD_PUBLISH_READY ? "READY" : "BLOCKED");
  }

string ASC_RecordIntegrityStateText(const ASC_RecordIntegrityState state)
  {
   switch(state)
     {
      case ASC_RECORD_INTEGRITY_SPEC_OK: return("SPEC_OK");
      case ASC_RECORD_INTEGRITY_SPEC_SUSPICIOUS: return("SPEC_SUSPICIOUS");
      case ASC_RECORD_INTEGRITY_SPEC_PRESERVED_PRIOR: return("SPEC_PRESERVED_PRIOR");
      case ASC_RECORD_INTEGRITY_SPEC_UNREADABLE: return("SPEC_UNREADABLE");
      case ASC_RECORD_INTEGRITY_SPEC_BROKER_MISSING: return("SPEC_BROKER_MISSING");
      case ASC_RECORD_INTEGRITY_SPEC_CONTRADICTORY: return("SPEC_CONTRADICTORY");
      case ASC_RECORD_INTEGRITY_SPEC_BROKEN: return("SPEC_BROKEN");
      default: return("UNREAD");
     }
  }

bool ASC_RecordPublishableTruthFromState(const string publishability_state)
  {
   return(ASC_RecordNormalizePublishabilityState(publishability_state) == ASC_RecordPublishabilityStateText(ASC_RECORD_PUBLISH_READY));
  }

string ASC_RecordNormalizeHydrationState(const string value)
  {
   if(value == ASC_RecordHydrationStateText(ASC_RECORD_PENDING_DISCOVERY_HYDRATION) ||
      value == ASC_RecordHydrationStateText(ASC_RECORD_MARKET_PASS_COMPLETE) ||
      value == ASC_RecordHydrationStateText(ASC_RECORD_MARKET_PASS_ONLY) ||
      value == ASC_RecordHydrationStateText(ASC_RECORD_MARKET_PASS_ABSENT) ||
      value == ASC_RecordHydrationStateText(ASC_RECORD_CURRENT_PASS_READY) ||
      value == ASC_RecordHydrationStateText(ASC_RECORD_LEGACY_RECOVERED))
      return(value);
   return(ASC_RecordHydrationStateText(ASC_RECORD_UNHYDRATED));
  }

string ASC_RecordNormalizeAuthorityState(const string value)
  {
   if(value == ASC_RecordAuthorityStateText(ASC_RECORD_AUTHORITY_PLACEHOLDER) ||
      value == ASC_RecordAuthorityStateText(ASC_RECORD_AUTHORITY_CURRENT_PASS) ||
      value == ASC_RecordAuthorityStateText(ASC_RECORD_AUTHORITY_SNAPSHOT_V3) ||
      value == ASC_RecordAuthorityStateText(ASC_RECORD_AUTHORITY_LEGACY))
      return(value);
   return(ASC_RecordAuthorityStateText(ASC_RECORD_AUTHORITY_NONE));
  }

string ASC_RecordNormalizePublishabilityState(const string value)
  {
   if(value == ASC_RecordPublishabilityStateText(ASC_RECORD_PUBLISH_READY))
      return(value);
   return(ASC_RecordPublishabilityStateText(ASC_RECORD_PUBLISH_BLOCKED));
  }

string ASC_RecordNormalizeIntegrityState(const string value)
  {
   if(value == ASC_RecordIntegrityStateText(ASC_RECORD_INTEGRITY_SPEC_OK) ||
      value == ASC_RecordIntegrityStateText(ASC_RECORD_INTEGRITY_SPEC_SUSPICIOUS) ||
      value == ASC_RecordIntegrityStateText(ASC_RECORD_INTEGRITY_SPEC_PRESERVED_PRIOR) ||
      value == ASC_RecordIntegrityStateText(ASC_RECORD_INTEGRITY_SPEC_UNREADABLE) ||
      value == ASC_RecordIntegrityStateText(ASC_RECORD_INTEGRITY_SPEC_BROKER_MISSING) ||
      value == ASC_RecordIntegrityStateText(ASC_RECORD_INTEGRITY_SPEC_CONTRADICTORY) ||
      value == ASC_RecordIntegrityStateText(ASC_RECORD_INTEGRITY_SPEC_BROKEN))
      return(value);
   return(ASC_RecordIntegrityStateText(ASC_RECORD_INTEGRITY_UNREAD));
  }

enum ASC_UICorner
  {
   ASC_UI_TOP_LEFT = 0,
   ASC_UI_TOP_RIGHT,
   ASC_UI_BOTTOM_LEFT,
   ASC_UI_BOTTOM_RIGHT
  };

struct ASC_RuntimeConfig
  {
   bool           ScannerEnabled;
   int            TimerSeconds;
   int            MaxSymbolsPerInitPass;
   int            MaxSymbolsPerTimerPass;
   int            DiscoveryRefreshMinutes;
   int            StaleFeedSeconds;
   int            NoQuoteSeconds;
   bool           UseCommonFiles;

   bool           ForceFullRediscovery;
   bool           ForceRepublish;
   bool           ForceSnapshotReload;
   bool           PublishNow;
   bool           CleanStaleOutputsNow;

   bool           IncludeCustomSymbols;
   bool           IncludeDisabledTradeSymbols;
   bool           PreserveFullUniverseSnapshot;
   bool           PendingHydrationAllowed;
   bool           EnableBucketFiltering;
   string         EnabledPrimaryBuckets;
   string         UnknownBucketPolicy;
   string         UnresolvedClassificationPolicy;

   string         ContinuousMarketBias;
   string         SessionWindowTrustMode;
   bool           UseSessionReferenceEvidence;
   int            RecheckOpenSeconds;
   int            RecheckClosedSeconds;
   int            RecheckUnknownSeconds;

   bool           StrictSpecValidation;
   bool           PreservePartialTruth;
   bool           RejectBrokerZeroEconomics;
   string         SuspiciousTickValueHandling;
   string         SuspiciousTickSizeHandling;
   bool           AllowPublishWhenSpecsPartial;
   bool           RequireStrongEconomicsForPublish;

   bool           EnableHistoryIntake;
   int            BarsPerTimeframe;
   int            MinimumBarsRequired;
   string         HistoryLoadMode;
   bool           PublishHistorySection;
   bool           RequireHistoryBeforeSurface;

   bool           EnableATR;
   int            ATRPeriod;
   ENUM_TIMEFRAMES ATRTimeframe;
   string         ATRThresholdProfile;
   bool           EnableEMA;
   int            EMAFastPeriod;
   int            EMASlowPeriod;
   ENUM_TIMEFRAMES EMATimeframe;
   bool           EnableRSI;
   int            RSIPeriod;
   ENUM_TIMEFRAMES RSITimeframe;
   string         RSIThresholdProfile;

   ENUM_TIMEFRAMES PrimaryScanTimeframe;
   ENUM_TIMEFRAMES ConfirmationTimeframe;
   ENUM_TIMEFRAMES ContextTimeframe;
   string         EnabledTimeframeSet;

   bool           EnableSurfaceLayer;
   int            MinimumSurfaceInputs;
   double         SurfaceScoreThreshold;
   bool           RequireConditionsBeforeSurface;

   bool           PublishSummary;
   bool           PublishSymbolFiles;
   bool           PublishMirror;
   bool           PublishPendingRecords;
   bool           HideUnresolvedClassification;
   bool           HideWeakSpecs;
   bool           IncludeSuspiciousTruthWithWarning;
   string         SummaryMode;
   int            MaxItemsPerBucket;
   bool           CleanStaleSymbolFiles;
   bool           CleanStaleSummary;
   bool           CleanLegacyBadRoots;

   bool           HUDEnabled;
   bool           MenuEnabled;
   bool           CompactMode;
   ASC_UICorner   PanelCorner;
   int            PanelXOffset;
   int            PanelYOffset;
   int            FontSize;
   int            RowSpacing;
   bool           ShowReasons;
   bool           ShowCounts;
   bool           ExpertMode;
  };

struct ASC_SymbolIdentity
  {
   string RawSymbol;
   string NormalizedSymbol;
   string CanonicalSymbol;
   string DisplayName;
   string BrokerPath;
   string BrokerExchange;
   string BrokerCountry;
   string AssetClass;
   string PrimaryBucket;
   string Sector;
   string Industry;
   string Theme;
   string ClassificationServerKey;
   string ClassificationSubType;
   string ClassificationAliasKind;
   string ClassificationConfidence;
   string ClassificationReviewStatus;
   string ClassificationNotes;
   bool   ClassificationResolved;
   string ClassificationReason;
  };

struct ASC_MarketTruth
  {
   bool                   Exists;
   bool                   Selected;
   bool                   Visible;
   bool                   QuoteWindowOpen;
   bool                   TradeWindowOpen;
   bool                   TradeAllowed;
   bool                   HasUsableQuote;
   bool                   QuoteFresh;
   bool                   QuoteScheduleReadable;
   bool                   TradeScheduleReadable;
   ASC_SessionTruthStatus SessionTruthStatus;
   bool                   Layer1Eligible;
   datetime               LastQuoteTime;
   datetime               NextRecheckTime;
   int                    QuoteAgeSeconds;
   string                 QuoteFreshnessStatus;
   string                 QuoteScheduleSunday;
   string                 QuoteScheduleMonday;
   string                 QuoteScheduleTuesday;
   string                 QuoteScheduleWednesday;
   string                 QuoteScheduleThursday;
   string                 QuoteScheduleFriday;
   string                 QuoteScheduleSaturday;
   string                 TradeScheduleSunday;
   string                 TradeScheduleMonday;
   string                 TradeScheduleTuesday;
   string                 TradeScheduleWednesday;
   string                 TradeScheduleThursday;
   string                 TradeScheduleFriday;
   string                 TradeScheduleSaturday;
   string                 SessionReadStatus;
   string                 SessionReadReason;
   string                 SessionConsistencyReason;
   string                 IneligibleReason;
  };

struct ASC_ConditionsTruth
  {
   bool   SpecsReadable;
   string SpecsReason;
   string SpecIntegrityStatus;
   string EconomicsTrust;
   string NormalizationStatus;
   string TruthCoverageStatus;

   bool   DigitsReadable;
   int    Digits;
   bool   SpreadPointsReadable;
   int    SpreadPoints;
   bool   SpreadFloatReadable;
   bool   SpreadFloat;
   bool   StopsLevelReadable;
   int    StopsLevel;
   bool   FreezeLevelReadable;
   int    FreezeLevel;

   bool   PointReadable;
   double Point;
   bool   TickSizeReadable;
   double TickSize;
   bool   TickValueReadable;
   double TickValue;
   bool   TickValueRawReadable;
   double TickValueRaw;
   bool   TickValueDerivedReadable;
   double TickValueDerived;
   bool   TickValueValidatedReadable;
   double TickValueValidated;
   bool   TickValueProfitReadable;
   double TickValueProfit;
   bool   TickValueLossReadable;
   double TickValueLoss;
   string EconomicsMismatchFlags;
   bool   EconomicsAuthoritative;
   bool   EconomicsPreservedFromPrior;
   bool   ContractSizeReadable;
   double ContractSize;

   bool   VolumeMinReadable;
   double VolumeMin;
   bool   VolumeMaxReadable;
   double VolumeMax;
   bool   VolumeStepReadable;
   double VolumeStep;
   bool   VolumeLimitReadable;
   double VolumeLimit;

   bool   MarginCurrencyReadable;
   string MarginCurrency;
   bool   ProfitCurrencyReadable;
   string ProfitCurrency;
   bool   BaseCurrencyReadable;
   string BaseCurrency;

   bool   CalcModeReadable;
   int    CalcMode;
   bool   ChartModeReadable;
   int    ChartMode;
   bool   TradeModeReadable;
   int    TradeMode;
   bool   ExecutionModeReadable;
   int    ExecutionMode;
   bool   GtcModeReadable;
   int    GtcMode;
   bool   FillingModeReadable;
   int    FillingMode;
   bool   ExpirationModeReadable;
   int    ExpirationMode;
   bool   OrderModeReadable;
   int    OrderMode;

   bool   SwapModeReadable;
   int    SwapMode;
   bool   SwapLongReadable;
   double SwapLong;
   bool   SwapShortReadable;
   double SwapShort;
   bool   SwapSundayReadable;
   double SwapSunday;
   bool   SwapMondayReadable;
   double SwapMonday;
   bool   SwapTuesdayReadable;
   double SwapTuesday;
   bool   SwapWednesdayReadable;
   double SwapWednesday;
   bool   SwapThursdayReadable;
   double SwapThursday;
   bool   SwapFridayReadable;
   double SwapFriday;
   bool   SwapSaturdayReadable;
   double SwapSaturday;

   bool   MarginInitialReadable;
   double MarginInitial;
   bool   MarginMaintenanceReadable;
   double MarginMaintenance;
   bool   MarginHedgedReadable;
   double MarginHedged;
   bool   MarginRateBuyReadable;
   double MarginRateBuyInitial;
   double MarginRateBuyMaintenance;
   bool   MarginRateSellReadable;
   double MarginRateSellInitial;
   double MarginRateSellMaintenance;
  };

struct ASC_SurfaceTruth
  {
   ASC_SurfaceScanState ScanState;
   bool                 SurfaceEligible;
   bool                 RankingEligible;
   string               SurfaceReason;
   int                  BarsM15;
   int                  BarsH1;
   datetime             LastBarTimeM15;
   datetime             LastBarTimeH1;
   double               QuoteAgeSeconds;
   double               SpreadCostPoints;
   double               SurfaceScore;
  };

struct ASC_RecordHydration
  {
   string HydrationState;
   string SnapshotAuthority;
   bool   PublishableTruth;
  };

void ASC_RecordSetHydration(ASC_RecordHydration &hydration,const ASC_RecordHydrationState hydration_state,const ASC_RecordAuthorityState authority_state,const ASC_RecordPublishabilityState publishability_state)
  {
   hydration.HydrationState = ASC_RecordHydrationStateText(hydration_state);
   hydration.SnapshotAuthority = ASC_RecordAuthorityStateText(authority_state);
   hydration.PublishableTruth = (publishability_state == ASC_RECORD_PUBLISH_READY);
  }

void ASC_RecordNormalizeHydration(ASC_RecordHydration &hydration)
  {
   hydration.HydrationState = ASC_RecordNormalizeHydrationState(hydration.HydrationState);
   hydration.SnapshotAuthority = ASC_RecordNormalizeAuthorityState(hydration.SnapshotAuthority);
   hydration.PublishableTruth = (ASC_RecordNormalizePublishabilityState(hydration.PublishableTruth ? ASC_RecordPublishabilityStateText(ASC_RECORD_PUBLISH_READY) : ASC_RecordPublishabilityStateText(ASC_RECORD_PUBLISH_BLOCKED)) == ASC_RecordPublishabilityStateText(ASC_RECORD_PUBLISH_READY));
  }


struct ASC_SymbolRecord
  {
   ASC_SymbolIdentity   Identity;
   ASC_MarketTruth      MarketTruth;
   ASC_ConditionsTruth  ConditionsTruth;
   ASC_SurfaceTruth     SurfaceTruth;
   ASC_RecordHydration  RecordHydration;
  };

struct ASC_RuntimeSnapshot
  {
   bool     ScannerEnabled;
   string   BrokerName;
   int      UniverseCount;
   int      HydratedCount;
   int      PendingCount;
   int      PublishedCount;
   int      Layer1EligibleCount;
   int      OpenTradableCount;
   int      StaleFeedCount;
   int      NoQuoteCount;
   int      ClosedSessionCount;
   int      UnknownCount;
   int      BucketResolvedCount;
   int      RankingEligibleCount;
   int      SpecsReadableCount;
   int      SpecsWeakCount;
   datetime LastScanTime;
   datetime NextRunTime;
   string   PhaseText;
   string   PublicationText;
   string   SpecSummary;
  };

bool ASC_Engine_RunInit(ASC_RuntimeConfig &config);
void ASC_Engine_RunTimer();
void ASC_Engine_Shutdown();
void ASC_Engine_RequestImmediateRefresh();
void ASC_Engine_RequestRepublish();
void ASC_Engine_RequestReloadUniverse();
void ASC_Engine_RequestRebuildSnapshot();
void ASC_Engine_RequestCleanStaleOutputs();
void ASC_Engine_UpdateRuntimeConfig(const ASC_RuntimeConfig &config);
void ASC_Engine_GetRuntimeConfig(ASC_RuntimeConfig &config);
bool ASC_Engine_GetRuntimeSnapshot(ASC_RuntimeSnapshot &snapshot);

bool ASC_Market_DiscoverSymbols(string &symbols[]);
bool ASC_Market_BuildIdentityAndTruth(const string symbol,const ASC_RuntimeConfig &config,ASC_SymbolRecord &record);
bool ASC_Conditions_Load(const string symbol,ASC_SymbolRecord &record);
bool ASC_Surface_Evaluate(const ASC_RuntimeConfig &config,ASC_SymbolRecord &record);
bool ASC_Storage_LoadUniverseSnapshot(const ASC_RuntimeConfig &config,ASC_SymbolRecord &records[],int &count);
bool ASC_Storage_SaveUniverseSnapshot(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count);
bool ASC_Output_WriteUniverseSnapshotMirror(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count);

void ASC_Record_Reset(ASC_SymbolRecord &record)
  {
   ZeroMemory(record);

   record.Identity.AssetClass = "UNKNOWN";
   record.Identity.PrimaryBucket = "UNKNOWN";
   record.Identity.Sector = "UNKNOWN";
   record.Identity.Industry = "UNKNOWN";
   record.Identity.Theme = "UNKNOWN";
   record.Identity.ClassificationServerKey = "";
   record.Identity.ClassificationSubType = "UNKNOWN";
   record.Identity.ClassificationAliasKind = "UNKNOWN";
   record.Identity.ClassificationConfidence = "UNKNOWN";
   record.Identity.ClassificationReviewStatus = "UNKNOWN";
   record.Identity.ClassificationNotes = "";
   record.MarketTruth.QuoteAgeSeconds = -1;
   record.MarketTruth.QuoteFreshnessStatus = "UNKNOWN";
   record.MarketTruth.QuoteScheduleSunday = "UNKNOWN";
   record.MarketTruth.QuoteScheduleMonday = "UNKNOWN";
   record.MarketTruth.QuoteScheduleTuesday = "UNKNOWN";
   record.MarketTruth.QuoteScheduleWednesday = "UNKNOWN";
   record.MarketTruth.QuoteScheduleThursday = "UNKNOWN";
   record.MarketTruth.QuoteScheduleFriday = "UNKNOWN";
   record.MarketTruth.QuoteScheduleSaturday = "UNKNOWN";
   record.MarketTruth.TradeScheduleSunday = "UNKNOWN";
   record.MarketTruth.TradeScheduleMonday = "UNKNOWN";
   record.MarketTruth.TradeScheduleTuesday = "UNKNOWN";
   record.MarketTruth.TradeScheduleWednesday = "UNKNOWN";
   record.MarketTruth.TradeScheduleThursday = "UNKNOWN";
   record.MarketTruth.TradeScheduleFriday = "UNKNOWN";
   record.MarketTruth.TradeScheduleSaturday = "UNKNOWN";
   record.MarketTruth.SessionReadStatus = "UNREAD";
   record.ConditionsTruth.SpecIntegrityStatus = ASC_RecordIntegrityStateText(ASC_RECORD_INTEGRITY_UNREAD);
   record.ConditionsTruth.EconomicsTrust = "UNREAD";
   record.ConditionsTruth.NormalizationStatus = "NORMALIZATION_UNKNOWN";
   record.ConditionsTruth.TruthCoverageStatus = "UNREAD";
   record.ConditionsTruth.Digits = -1;
   record.ConditionsTruth.SpreadPoints = -1;
   record.ConditionsTruth.StopsLevel = -1;
   record.ConditionsTruth.FreezeLevel = -1;
   record.ConditionsTruth.Point = -1.0;
   record.ConditionsTruth.TickSize = -1.0;
   record.ConditionsTruth.TickValue = -1.0;
   record.ConditionsTruth.TickValueRaw = -1.0;
   record.ConditionsTruth.TickValueDerived = -1.0;
   record.ConditionsTruth.TickValueValidated = -1.0;
   record.ConditionsTruth.TickValueProfit = -1.0;
   record.ConditionsTruth.TickValueLoss = -1.0;
   record.ConditionsTruth.ContractSize = -1.0;
   record.ConditionsTruth.VolumeMin = -1.0;
   record.ConditionsTruth.VolumeMax = -1.0;
   record.ConditionsTruth.VolumeStep = -1.0;
   record.ConditionsTruth.VolumeLimit = -1.0;
   record.ConditionsTruth.CalcMode = -1;
   record.ConditionsTruth.ChartMode = -1;
   record.ConditionsTruth.TradeMode = -1;
   record.ConditionsTruth.ExecutionMode = -1;
   record.ConditionsTruth.GtcMode = -1;
   record.ConditionsTruth.FillingMode = -1;
   record.ConditionsTruth.ExpirationMode = -1;
   record.ConditionsTruth.OrderMode = -1;
   record.ConditionsTruth.SwapMode = -1;
   record.ConditionsTruth.SwapSunday = -1.0;
   record.ConditionsTruth.SwapMonday = -1.0;
   record.ConditionsTruth.SwapTuesday = -1.0;
   record.ConditionsTruth.SwapWednesday = -1.0;
   record.ConditionsTruth.SwapThursday = -1.0;
   record.ConditionsTruth.SwapFriday = -1.0;
   record.ConditionsTruth.SwapSaturday = -1.0;
   record.ConditionsTruth.MarginInitial = -1.0;
   record.ConditionsTruth.MarginMaintenance = -1.0;
   record.ConditionsTruth.MarginHedged = -1.0;
   record.ConditionsTruth.MarginRateBuyInitial = -1.0;
   record.ConditionsTruth.MarginRateBuyMaintenance = -1.0;
   record.ConditionsTruth.MarginRateSellInitial = -1.0;
   record.ConditionsTruth.MarginRateSellMaintenance = -1.0;
   record.SurfaceTruth.ScanState = ASC_SURFACE_NOT_RUN;
   record.SurfaceTruth.BarsM15 = -1;
   record.SurfaceTruth.BarsH1 = -1;
   record.SurfaceTruth.QuoteAgeSeconds = -1.0;
   record.SurfaceTruth.SpreadCostPoints = -1.0;
   record.SurfaceTruth.SurfaceScore = -1.0;
   ASC_RecordSetHydration(record.RecordHydration,ASC_RECORD_UNHYDRATED,ASC_RECORD_AUTHORITY_NONE,ASC_RECORD_PUBLISH_BLOCKED);
  }

#endif
