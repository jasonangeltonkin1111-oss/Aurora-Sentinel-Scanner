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
static datetime          g_asc_last_scan_time = 0;
static datetime          g_asc_next_run_time = 0;
static bool              g_asc_force_refresh = false;
static bool              g_asc_force_republish = false;
static bool              g_asc_force_reload_universe = false;
static bool              g_asc_force_rebuild_snapshot = false;
static bool              g_asc_force_clean_stale_outputs = false;

void ASC_Engine_ResetRecord(ASC_SymbolRecord &record)
  {
   ZeroMemory(record);
   record.Identity.PrimaryBucket = "";
   record.Identity.AssetClass = "";
   record.Identity.ClassificationReason = "";
   record.MarketTruth.SessionTruthStatus = ASC_SESSION_UNKNOWN;
   record.ConditionsTruth.Digits = -1;
   record.ConditionsTruth.SpreadPoints = -1;
   record.SurfaceTruth.ScanState = ASC_SURFACE_NOT_RUN;
   record.SurfaceTruth.BarsM15 = -1;
   record.SurfaceTruth.BarsH1 = -1;
   record.SurfaceTruth.QuoteAgeSeconds = -1.0;
   record.SurfaceTruth.SpreadCostPoints = -1.0;
   record.SurfaceTruth.SurfaceScore = -1.0;
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
      if(g_asc_universe_records[index].Identity.RawSymbol == symbol ||
         g_asc_universe_records[index].Identity.NormalizedSymbol == symbol ||
         g_asc_universe_records[index].Identity.CanonicalSymbol == symbol)
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

void ASC_Engine_ProcessSymbols(const string &symbols[],const int total_symbols,const int max_to_process,int &cursor)
  {
   if(total_symbols <= 0)
      return;
   int limit = total_symbols;
   if(max_to_process > 0 && max_to_process < total_symbols)
      limit = max_to_process;
   cursor = ASC_Engine_AdvanceCursor(cursor,total_symbols,0);

   for(int processed = 0; processed < limit; ++processed)
     {
      const int index = (cursor + processed) % total_symbols;
      ASC_SymbolRecord built_record;
      if(!ASC_Market_BuildIdentityAndTruth(symbols[index],g_asc_runtime_config,built_record))
         continue;

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
        }

      if(g_asc_runtime_config.EnableSurfaceLayer)
         ASC_Surface_Evaluate(g_asc_runtime_config,merged_record);

      ASC_Engine_UpsertRecord(merged_record);
     }

   cursor = ASC_Engine_AdvanceCursor(cursor,total_symbols,limit);
  }

bool ASC_Engine_ShouldPublishRecord(const ASC_SymbolRecord &record)
  {
   if(!g_asc_runtime_config.PublishPendingRecords && !ASC_Output_RecordHasPublishedTruth(record))
      return(false);
   if(g_asc_runtime_config.HideUnresolvedClassification && !record.Identity.ClassificationResolved)
      return(false);
   if(g_asc_runtime_config.HideWeakSpecs && !record.ConditionsTruth.SpecsReadable)
      return(false);
   return(true);
  }

bool ASC_Engine_PublishOutputs()
  {
   ASC_SymbolRecord publish_records[];
   ArrayResize(publish_records,0);
   for(int index = 0; index < g_asc_universe_count; ++index)
     {
      if(!ASC_Engine_ShouldPublishRecord(g_asc_universe_records[index]))
         continue;
      const int next_index = ArraySize(publish_records);
      ArrayResize(publish_records,next_index + 1);
      publish_records[next_index] = g_asc_universe_records[index];
     }

   if(g_asc_runtime_config.PublishMirror)
     {
      if(!ASC_Output_WriteUniverseSnapshotMirror(g_asc_runtime_config,publish_records,ArraySize(publish_records)))
         return(false);
     }
   else
     {
      if(g_asc_runtime_config.PublishSymbolFiles && !ASC_Output_WriteSymbolSurfaces(g_asc_runtime_config,publish_records,ArraySize(publish_records)))
         return(false);
      if(g_asc_runtime_config.PublishSummary && !ASC_Output_WriteSummarySurface(g_asc_runtime_config,publish_records,ArraySize(publish_records)))
         return(false);
      if(g_asc_runtime_config.CleanStaleSymbolFiles)
         ASC_Output_RemoveStaleSymbolFiles(g_asc_runtime_config,publish_records,ArraySize(publish_records));
     }
   return(true);
  }

void ASC_Engine_RunPass(const bool init_pass)
  {
   if(!g_asc_runtime_config.ScannerEnabled && !g_asc_force_refresh && !g_asc_runtime_config.PublishNow && !g_asc_force_republish)
      return;

   if(g_asc_force_rebuild_snapshot)
     {
      ArrayResize(g_asc_universe_records,0);
      g_asc_universe_count = 0;
      g_asc_init_cursor = 0;
      g_asc_timer_cursor = 0;
     }

   string symbols[];
   if(!ASC_Market_DiscoverSymbols(symbols))
      return;

   ASC_Engine_PreserveUniverseMembership(symbols,ArraySize(symbols));

   const bool do_full_pass = init_pass || g_asc_runtime_config.ForceFullRediscovery || g_asc_force_reload_universe || g_asc_force_refresh;
   const int max_to_process = do_full_pass ? ArraySize(symbols) : g_asc_runtime_config.MaxSymbolsPerTimerPass;
   if(init_pass)
      ASC_Engine_ProcessSymbols(symbols,ArraySize(symbols),g_asc_runtime_config.MaxSymbolsPerInitPass,g_asc_init_cursor);
   else
      ASC_Engine_ProcessSymbols(symbols,ArraySize(symbols),max_to_process,g_asc_timer_cursor);

   ASC_Storage_SaveUniverseSnapshot(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count);
   if(g_asc_runtime_config.PublishNow || g_asc_runtime_config.ForceRepublish || g_asc_force_republish || g_asc_force_clean_stale_outputs || g_asc_force_refresh || init_pass)
      ASC_Engine_PublishOutputs();

   g_asc_last_scan_time = TimeCurrent();
   g_asc_next_run_time = g_asc_last_scan_time + MathMax(g_asc_runtime_config.TimerSeconds,1);

   g_asc_runtime_config.ForceFullRediscovery = false;
   g_asc_runtime_config.ForceRepublish = false;
   g_asc_runtime_config.ForceSnapshotReload = false;
   g_asc_runtime_config.PublishNow = false;
   g_asc_runtime_config.CleanStaleOutputsNow = false;
   g_asc_force_refresh = false;
   g_asc_force_republish = false;
   g_asc_force_reload_universe = false;
   g_asc_force_rebuild_snapshot = false;
   g_asc_force_clean_stale_outputs = false;
  }

bool ASC_Engine_RunInit(ASC_RuntimeConfig &config)
  {
   g_asc_runtime_config = config;
   ASC_Storage_LoadUniverseSnapshot(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count);
   ASC_Engine_RunPass(true);
   return(true);
  }

void ASC_Engine_RunTimer()
  {
   ASC_Engine_RunPass(false);
  }

void ASC_Engine_Shutdown()
  {
  }

void ASC_Engine_RequestImmediateRefresh() { g_asc_force_refresh = true; }
void ASC_Engine_RequestRepublish() { g_asc_force_republish = true; }
void ASC_Engine_RequestReloadUniverse() { g_asc_force_reload_universe = true; }
void ASC_Engine_RequestRebuildSnapshot() { g_asc_force_rebuild_snapshot = true; }
void ASC_Engine_RequestCleanStaleOutputs() { g_asc_force_clean_stale_outputs = true; }
void ASC_Engine_UpdateRuntimeConfig(const ASC_RuntimeConfig &config) { g_asc_runtime_config = config; g_asc_next_run_time = TimeCurrent() + MathMax(g_asc_runtime_config.TimerSeconds,1); }
void ASC_Engine_GetRuntimeConfig(ASC_RuntimeConfig &config) { config = g_asc_runtime_config; }

bool ASC_Engine_GetRuntimeSnapshot(ASC_RuntimeSnapshot &snapshot)
  {
   ZeroMemory(snapshot);
   snapshot.ScannerEnabled = g_asc_runtime_config.ScannerEnabled;
   snapshot.BrokerName = ASC_Output_BrokerName();
   snapshot.UniverseCount = g_asc_universe_count;
   snapshot.LastScanTime = g_asc_last_scan_time;
   snapshot.NextRunTime = g_asc_next_run_time;
   snapshot.PhaseText = (g_asc_runtime_config.EnableSurfaceLayer ? "Layer 1 / Layer 1.2 / Surface" : "Layer 1 / Layer 1.2");
   snapshot.PublicationText = (g_asc_runtime_config.PublishSummary || g_asc_runtime_config.PublishSymbolFiles || g_asc_runtime_config.PublishMirror) ? "publication enabled" : "publication paused";

   for(int index = 0; index < g_asc_universe_count; ++index)
     {
      const ASC_SymbolRecord record = g_asc_universe_records[index];
      const bool hydrated = (record.Identity.ClassificationResolved || record.ConditionsTruth.SpecsReadable || record.MarketTruth.LastQuoteTime > 0);
      if(hydrated)
         ++snapshot.HydratedCount;
      if(!ASC_Output_RecordHasPublishedTruth(record))
         ++snapshot.PendingCount;
      if(ASC_Output_RecordHasPublishedTruth(record))
         ++snapshot.PublishedCount;
      if(record.MarketTruth.Layer1Eligible)
         ++snapshot.Layer1EligibleCount;
      if(record.Identity.ClassificationResolved)
         ++snapshot.BucketResolvedCount;
      if(record.SurfaceTruth.RankingEligible)
         ++snapshot.RankingEligibleCount;
      if(record.ConditionsTruth.SpecsReadable)
         ++snapshot.SpecsReadableCount;
      else if(StringLen(record.Identity.RawSymbol) > 0)
         ++snapshot.SpecsWeakCount;

      switch(record.MarketTruth.SessionTruthStatus)
        {
         case ASC_SESSION_OPEN_TRADABLE: ++snapshot.OpenTradableCount; break;
         case ASC_SESSION_STALE_FEED: ++snapshot.StaleFeedCount; break;
         case ASC_SESSION_NO_QUOTE: ++snapshot.NoQuoteCount; break;
         case ASC_SESSION_CLOSED_SESSION: ++snapshot.ClosedSessionCount; break;
         default: ++snapshot.UnknownCount; break;
        }
     }

   snapshot.SpecSummary = "readable=" + IntegerToString(snapshot.SpecsReadableCount) + ", weak=" + IntegerToString(snapshot.SpecsWeakCount);
   return(true);
  }

#endif
