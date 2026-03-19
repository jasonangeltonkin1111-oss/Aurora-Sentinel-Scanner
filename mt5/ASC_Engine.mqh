#ifndef ASC_ENGINE_MQH
#define ASC_ENGINE_MQH

#include "ASC_Common.mqh"
#include "ASC_Market.mqh"
#include "ASC_Conditions.mqh"
#include "ASC_Surface.mqh"
#include "ASC_Storage.mqh"
#include "ASC_Output.mqh"

static ASC_SymbolRecord  g_asc_universe_records[];
static int               g_asc_universe_count = 0;
static ASC_RuntimeConfig g_asc_runtime_config;
static int               g_asc_init_cursor = 0;
static int               g_asc_timer_cursor = 0;

void ASC_Engine_ResetRecord(ASC_SymbolRecord &record)
  {
   record.Identity.RawSymbol = "";
   record.Identity.NormalizedSymbol = "";
   record.Identity.CanonicalSymbol = "";
   record.Identity.DisplayName = "";
   record.Identity.BrokerPath = "";
   record.Identity.BrokerExchange = "";
   record.Identity.BrokerCountry = "";
   record.Identity.AssetClass = "UNKNOWN";
   record.Identity.PrimaryBucket = "UNKNOWN";
   record.Identity.Sector = "UNKNOWN";
   record.Identity.Industry = "UNKNOWN";
   record.Identity.Theme = "UNKNOWN";
   record.Identity.ClassificationResolved = false;
   record.Identity.ClassificationReason = "";

   record.MarketTruth.Exists = false;
   record.MarketTruth.Selected = false;
   record.MarketTruth.Visible = false;
   record.MarketTruth.QuoteWindowOpen = false;
   record.MarketTruth.TradeWindowOpen = false;
   record.MarketTruth.TradeAllowed = false;
   record.MarketTruth.HasUsableQuote = false;
   record.MarketTruth.QuoteFresh = false;
   record.MarketTruth.QuoteScheduleReadable = false;
   record.MarketTruth.TradeScheduleReadable = false;
   record.MarketTruth.SessionTruthStatus = ASC_SESSION_UNKNOWN;
   record.MarketTruth.Layer1Eligible = false;
   record.MarketTruth.LastQuoteTime = 0;
   record.MarketTruth.NextRecheckTime = 0;
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
   record.MarketTruth.SessionReadReason = "";
   record.MarketTruth.SessionConsistencyReason = "";
   record.MarketTruth.IneligibleReason = "";

   record.ConditionsTruth.SpecsReadable = false;
   record.ConditionsTruth.SpecsReason = "";
   record.ConditionsTruth.SpecIntegrityStatus = "UNREAD";
   record.ConditionsTruth.EconomicsTrust = "UNREAD";
   record.ConditionsTruth.NormalizationStatus = "NORMALIZATION_UNKNOWN";
   record.ConditionsTruth.TruthCoverageStatus = "UNREAD";
   record.ConditionsTruth.DigitsReadable = false;
   record.ConditionsTruth.Digits = -1;
   record.ConditionsTruth.SpreadPointsReadable = false;
   record.ConditionsTruth.SpreadPoints = -1;
   record.ConditionsTruth.SpreadFloatReadable = false;
   record.ConditionsTruth.SpreadFloat = false;
   record.ConditionsTruth.StopsLevelReadable = false;
   record.ConditionsTruth.StopsLevel = -1;
   record.ConditionsTruth.FreezeLevelReadable = false;
   record.ConditionsTruth.FreezeLevel = -1;
   record.ConditionsTruth.PointReadable = false;
   record.ConditionsTruth.Point = -1.0;
   record.ConditionsTruth.TickSizeReadable = false;
   record.ConditionsTruth.TickSize = -1.0;
   record.ConditionsTruth.TickValueReadable = false;
   record.ConditionsTruth.TickValue = -1.0;
   record.ConditionsTruth.TickValueProfitReadable = false;
   record.ConditionsTruth.TickValueProfit = -1.0;
   record.ConditionsTruth.TickValueLossReadable = false;
   record.ConditionsTruth.TickValueLoss = -1.0;
   record.ConditionsTruth.ContractSizeReadable = false;
   record.ConditionsTruth.ContractSize = -1.0;
   record.ConditionsTruth.VolumeMinReadable = false;
   record.ConditionsTruth.VolumeMin = -1.0;
   record.ConditionsTruth.VolumeMaxReadable = false;
   record.ConditionsTruth.VolumeMax = -1.0;
   record.ConditionsTruth.VolumeStepReadable = false;
   record.ConditionsTruth.VolumeStep = -1.0;
   record.ConditionsTruth.VolumeLimitReadable = false;
   record.ConditionsTruth.VolumeLimit = -1.0;
   record.ConditionsTruth.MarginCurrencyReadable = false;
   record.ConditionsTruth.MarginCurrency = "";
   record.ConditionsTruth.ProfitCurrencyReadable = false;
   record.ConditionsTruth.ProfitCurrency = "";
   record.ConditionsTruth.BaseCurrencyReadable = false;
   record.ConditionsTruth.BaseCurrency = "";
   record.ConditionsTruth.CalcModeReadable = false;
   record.ConditionsTruth.CalcMode = -1;
   record.ConditionsTruth.ChartModeReadable = false;
   record.ConditionsTruth.ChartMode = -1;
   record.ConditionsTruth.TradeModeReadable = false;
   record.ConditionsTruth.TradeMode = -1;
   record.ConditionsTruth.ExecutionModeReadable = false;
   record.ConditionsTruth.ExecutionMode = -1;
   record.ConditionsTruth.GtcModeReadable = false;
   record.ConditionsTruth.GtcMode = -1;
   record.ConditionsTruth.FillingModeReadable = false;
   record.ConditionsTruth.FillingMode = -1;
   record.ConditionsTruth.ExpirationModeReadable = false;
   record.ConditionsTruth.ExpirationMode = -1;
   record.ConditionsTruth.OrderModeReadable = false;
   record.ConditionsTruth.OrderMode = -1;
   record.ConditionsTruth.SwapModeReadable = false;
   record.ConditionsTruth.SwapMode = -1;
   record.ConditionsTruth.SwapLongReadable = false;
   record.ConditionsTruth.SwapLong = 0.0;
   record.ConditionsTruth.SwapShortReadable = false;
   record.ConditionsTruth.SwapShort = 0.0;
   record.ConditionsTruth.SwapSundayReadable = false;
   record.ConditionsTruth.SwapSunday = -1.0;
   record.ConditionsTruth.SwapMondayReadable = false;
   record.ConditionsTruth.SwapMonday = -1.0;
   record.ConditionsTruth.SwapTuesdayReadable = false;
   record.ConditionsTruth.SwapTuesday = -1.0;
   record.ConditionsTruth.SwapWednesdayReadable = false;
   record.ConditionsTruth.SwapWednesday = -1.0;
   record.ConditionsTruth.SwapThursdayReadable = false;
   record.ConditionsTruth.SwapThursday = -1.0;
   record.ConditionsTruth.SwapFridayReadable = false;
   record.ConditionsTruth.SwapFriday = -1.0;
   record.ConditionsTruth.SwapSaturdayReadable = false;
   record.ConditionsTruth.SwapSaturday = -1.0;
   record.ConditionsTruth.MarginInitialReadable = false;
   record.ConditionsTruth.MarginInitial = -1.0;
   record.ConditionsTruth.MarginMaintenanceReadable = false;
   record.ConditionsTruth.MarginMaintenance = -1.0;
   record.ConditionsTruth.MarginHedgedReadable = false;
   record.ConditionsTruth.MarginHedged = -1.0;
   record.ConditionsTruth.MarginRateBuyReadable = false;
   record.ConditionsTruth.MarginRateBuyInitial = -1.0;
   record.ConditionsTruth.MarginRateBuyMaintenance = -1.0;
   record.ConditionsTruth.MarginRateSellReadable = false;
   record.ConditionsTruth.MarginRateSellInitial = -1.0;
   record.ConditionsTruth.MarginRateSellMaintenance = -1.0;

   record.SurfaceTruth.ScanState = ASC_SURFACE_NOT_RUN;
   record.SurfaceTruth.SurfaceEligible = false;
   record.SurfaceTruth.RankingEligible = false;
   record.SurfaceTruth.SurfaceReason = "";
   record.SurfaceTruth.BarsM15 = 0;
   record.SurfaceTruth.BarsH1 = 0;
   record.SurfaceTruth.LastBarTimeM15 = 0;
   record.SurfaceTruth.LastBarTimeH1 = 0;
   record.SurfaceTruth.QuoteAgeSeconds = 0.0;
   record.SurfaceTruth.SpreadCostPoints = 0.0;
   record.SurfaceTruth.SurfaceScore = 0.0;
  }

int ASC_Engine_FindRecordIndex(const ASC_SymbolRecord &record)
  {
   const string raw_symbol = record.Identity.RawSymbol;
   const string normalized_symbol = record.Identity.NormalizedSymbol;
   const string canonical_symbol = record.Identity.CanonicalSymbol;

   for(int index = 0; index < g_asc_universe_count; ++index)
     {
      if(StringLen(raw_symbol) > 0 && g_asc_universe_records[index].Identity.RawSymbol == raw_symbol)
         return(index);

      if(StringLen(normalized_symbol) > 0 && g_asc_universe_records[index].Identity.NormalizedSymbol == normalized_symbol)
         return(index);

      if(StringLen(canonical_symbol) > 0 && g_asc_universe_records[index].Identity.CanonicalSymbol == canonical_symbol)
         return(index);
     }

   return(-1);
  }

int ASC_Engine_FindRecordIndexBySymbol(const string symbol)
  {
   for(int index = 0; index < g_asc_universe_count; ++index)
     {
      if(g_asc_universe_records[index].Identity.RawSymbol == symbol)
         return(index);

      if(g_asc_universe_records[index].Identity.NormalizedSymbol == symbol)
         return(index);

      if(g_asc_universe_records[index].Identity.CanonicalSymbol == symbol)
         return(index);
     }

   return(-1);
  }

void ASC_Engine_UpsertRecord(const ASC_SymbolRecord &record)
  {
   int target_index = ASC_Engine_FindRecordIndex(record);
   if(target_index < 0)
     {
      target_index = g_asc_universe_count;
      ArrayResize(g_asc_universe_records,target_index + 1);
      ++g_asc_universe_count;
     }

   g_asc_universe_records[target_index] = record;
  }

void ASC_Engine_PreserveUniverseMembership(const string &symbols[],const int total_symbols)
  {
   for(int index = 0; index < total_symbols; ++index)
     {
      const string symbol = symbols[index];
      if(StringLen(symbol) == 0)
         continue;

      const int existing_index = ASC_Engine_FindRecordIndexBySymbol(symbol);
      if(existing_index >= 0)
        {
         if(StringLen(g_asc_universe_records[existing_index].Identity.RawSymbol) == 0)
            g_asc_universe_records[existing_index].Identity.RawSymbol = symbol;
         continue;
        }

      ASC_SymbolRecord placeholder_record;
      ASC_Engine_ResetRecord(placeholder_record);
      placeholder_record.Identity.RawSymbol = symbol;
      placeholder_record.Identity.NormalizedSymbol = symbol;
      placeholder_record.Identity.ClassificationReason = "PENDING_INIT_PASS";
      placeholder_record.MarketTruth.Exists = true;
      placeholder_record.MarketTruth.IneligibleReason = "PENDING_DISCOVERY_HYDRATION";
      placeholder_record.ConditionsTruth.SpecsReason = "PENDING_INIT_PASS";
      ASC_Engine_UpsertRecord(placeholder_record);
     }
  }

int ASC_Engine_AdvanceCursor(const int cursor,const int total_symbols,const int step)
  {
   if(total_symbols <= 0)
      return(0);

   int normalized_cursor = cursor % total_symbols;
   if(normalized_cursor < 0)
      normalized_cursor += total_symbols;

   if(step <= 0)
      return(normalized_cursor);

   return((normalized_cursor + step) % total_symbols);
  }

void ASC_Engine_ProcessSymbols(const string &symbols[],
                               const int total_symbols,
                               const int max_to_process,
                               int &cursor)
  {
   if(total_symbols <= 0)
     {
      ASC_Logger_Log("WARN","ENGINE","ASC_Engine_ProcessSymbols","no symbols available for processing");
      return;
     }

   int limit = total_symbols;
   if(max_to_process > 0 && max_to_process < total_symbols)
      limit = max_to_process;

   cursor = ASC_Engine_AdvanceCursor(cursor,total_symbols,0);
   ASC_Logger_Log("INFO","ENGINE","ASC_Engine_ProcessSymbols",
                  "processing limit=" + IntegerToString(limit) +
                  " total_symbols=" + IntegerToString(total_symbols) +
                  " start_cursor=" + IntegerToString(cursor));

   for(int processed = 0; processed < limit; ++processed)
     {
      const int index = (cursor + processed) % total_symbols;
      ASC_Logger_Log("INFO","ENGINE","ASC_Engine_ProcessSymbols",
                     "building symbol=" + symbols[index] +
                     " index=" + IntegerToString(index));
      ASC_SymbolRecord built_record;
      if(!ASC_Market_BuildIdentityAndTruth(symbols[index],g_asc_runtime_config,built_record))
        {
         ASC_Logger_Log("ERROR","ENGINE","ASC_Engine_ProcessSymbols",
                        "market build failed symbol=" + symbols[index]);
         continue;
        }

      ASC_SymbolRecord merged_record = built_record;
      const int existing_index = ASC_Engine_FindRecordIndex(built_record);
      if(existing_index >= 0)
         merged_record = g_asc_universe_records[existing_index];

      merged_record.Identity = built_record.Identity;
      merged_record.MarketTruth = built_record.MarketTruth;

      ASC_SymbolRecord conditions_record = merged_record;
      if(merged_record.MarketTruth.Exists)
        {
         if(ASC_Conditions_Load(symbols[index],conditions_record) || existing_index < 0)
            merged_record.ConditionsTruth = conditions_record.ConditionsTruth;
         else
            ASC_Logger_Log("WARN","ENGINE","ASC_Engine_ProcessSymbols",
                           "conditions load failed, preserved prior truth symbol=" + symbols[index]);
        }

      ASC_Surface_Evaluate(g_asc_runtime_config,merged_record);

      ASC_Engine_UpsertRecord(merged_record);
      ASC_Logger_Log("INFO","ENGINE","ASC_Engine_ProcessSymbols",
                     "upserted symbol=" + symbols[index] +
                     " eligible=" + (merged_record.MarketTruth.Layer1Eligible ? "true" : "false") +
                     " session=" + IntegerToString((int)merged_record.MarketTruth.SessionTruthStatus));
     }

   cursor = ASC_Engine_AdvanceCursor(cursor,total_symbols,limit);
   ASC_Logger_Log("INFO","ENGINE","ASC_Engine_ProcessSymbols",
                  "processing complete next_cursor=" + IntegerToString(cursor));
  }

bool ASC_Engine_RunInit(ASC_RuntimeConfig &config)
  {
   g_asc_runtime_config = config;
   ASC_Logger_Log("INFO","ENGINE","ASC_Engine_RunInit","init run started");

   const bool restore_succeeded = ASC_Storage_LoadUniverseSnapshot(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count);
   ASC_Logger_LogResult("ENGINE","ASC_Engine_RunInit",restore_succeeded,
                        "snapshot restore status count=" + IntegerToString(g_asc_universe_count));

   string symbols[];
   if(!ASC_Market_DiscoverSymbols(symbols))
     {
      g_asc_universe_count = ArraySize(g_asc_universe_records);
      ASC_Logger_Log("ERROR","ENGINE","ASC_Engine_RunInit",
                     "symbol discovery failed restored_count=" + IntegerToString(g_asc_universe_count));
      return(restore_succeeded && g_asc_universe_count > 0);
   }

   ASC_Logger_Log("INFO","ENGINE","ASC_Engine_RunInit",
                  "symbol discovery succeeded total_symbols=" + IntegerToString(ArraySize(symbols)));
   ASC_Engine_PreserveUniverseMembership(symbols,ArraySize(symbols));
   ASC_Engine_ProcessSymbols(symbols,ArraySize(symbols),g_asc_runtime_config.MaxSymbolsPerInitPass,g_asc_init_cursor);

   ASC_Logger_LogResult("ENGINE","ASC_Engine_RunInit",
                        ASC_Storage_SaveUniverseSnapshot(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count),
                        "snapshot save count=" + IntegerToString(g_asc_universe_count));
   if(g_asc_runtime_config.UseCommonFiles)
      ASC_Logger_LogResult("ENGINE","ASC_Engine_RunInit",
                           ASC_Output_WriteUniverseSnapshotMirror(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count),
                           "mirror write count=" + IntegerToString(g_asc_universe_count));

   ASC_Logger_Log("INFO","ENGINE","ASC_Engine_RunInit","init run complete");
   return(true);
  }

void ASC_Engine_RunTimer()
  {
   ASC_Logger_Log("INFO","ENGINE","ASC_Engine_RunTimer","timer run started");
   string symbols[];
   if(!ASC_Market_DiscoverSymbols(symbols))
     {
      ASC_Logger_Log("ERROR","ENGINE","ASC_Engine_RunTimer","symbol discovery failed");
      return;
     }

   ASC_Engine_PreserveUniverseMembership(symbols,ArraySize(symbols));
   ASC_Engine_ProcessSymbols(symbols,ArraySize(symbols),g_asc_runtime_config.MaxSymbolsPerTimerPass,g_asc_timer_cursor);

   ASC_Logger_LogResult("ENGINE","ASC_Engine_RunTimer",
                        ASC_Storage_SaveUniverseSnapshot(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count),
                        "snapshot save count=" + IntegerToString(g_asc_universe_count));
   if(g_asc_runtime_config.UseCommonFiles)
      ASC_Logger_LogResult("ENGINE","ASC_Engine_RunTimer",
                           ASC_Output_WriteUniverseSnapshotMirror(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count),
                           "mirror write count=" + IntegerToString(g_asc_universe_count));
   ASC_Logger_Log("INFO","ENGINE","ASC_Engine_RunTimer","timer run complete");
  }

#endif
