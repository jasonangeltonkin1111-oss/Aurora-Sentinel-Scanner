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

struct ASC_RuntimeConfig
  {
   int  TimerSeconds;
   int  MaxSymbolsPerInitPass;
   int  MaxSymbolsPerTimerPass;
   int  StaleFeedSeconds;
   bool UseCommonFiles;
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
   bool   TickValueProfitReadable;
   double TickValueProfit;
   bool   TickValueLossReadable;
   double TickValueLoss;
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

struct ASC_SymbolRecord
  {
   ASC_SymbolIdentity   Identity;
   ASC_MarketTruth      MarketTruth;
   ASC_ConditionsTruth  ConditionsTruth;
   ASC_SurfaceTruth     SurfaceTruth;
  };

bool ASC_Engine_RunInit(ASC_RuntimeConfig &config);
void ASC_Engine_RunTimer();

bool ASC_Market_DiscoverSymbols(string &symbols[]);
bool ASC_Market_BuildIdentityAndTruth(const string symbol,const ASC_RuntimeConfig config,ASC_SymbolRecord &record);
bool ASC_Conditions_Load(const string symbol,ASC_SymbolRecord &record);
bool ASC_Surface_Evaluate(const ASC_RuntimeConfig &config,ASC_SymbolRecord &record);
bool ASC_Storage_LoadUniverseSnapshot(const ASC_RuntimeConfig &config,ASC_SymbolRecord &records[],int &count);
bool ASC_Storage_SaveUniverseSnapshot(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count);
bool ASC_Output_WriteUniverseSnapshotMirror(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count);

#endif
