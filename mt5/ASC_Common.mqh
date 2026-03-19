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
   string AssetClass;
   string PrimaryBucket;
   string Sector;
   string Industry;
   string Theme;
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
   ASC_SessionTruthStatus SessionTruthStatus;
   bool                   Layer1Eligible;
   datetime               LastQuoteTime;
   datetime               NextRecheckTime;
   string                 IneligibleReason;
  };

struct ASC_ConditionsTruth
  {
   bool   SpecsReadable;
   string SpecsReason;
   bool   DigitsReadable;
   int    Digits;
   bool   SpreadPointsReadable;
   int    SpreadPoints;
   bool   SpreadFloatReadable;
   bool   SpreadFloat;
   bool   PointReadable;
   double Point;
   bool   TickSizeReadable;
   double TickSize;
   bool   TickValueReadable;
   double TickValue;
   bool   ContractSizeReadable;
   double ContractSize;
   bool   VolumeMinReadable;
   double VolumeMin;
   bool   VolumeMaxReadable;
   double VolumeMax;
   bool   VolumeStepReadable;
   double VolumeStep;
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

struct ASC_SymbolRecord
  {
   ASC_SymbolIdentity   Identity;
   ASC_MarketTruth      MarketTruth;
   ASC_ConditionsTruth  ConditionsTruth;
   ASC_SurfaceTruth     SurfaceTruth;
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

#endif
