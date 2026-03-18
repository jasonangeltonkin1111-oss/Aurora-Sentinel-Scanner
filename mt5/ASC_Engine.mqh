#ifndef ASC_ENGINE_MQH
#define ASC_ENGINE_MQH

#include "ASC_Common.mqh"
#include "ASC_Market.mqh"
#include "ASC_Conditions.mqh"
#include "ASC_Storage.mqh"
#include "ASC_Output.mqh"

static ASC_SymbolRecord  g_asc_universe_records[];
static int               g_asc_universe_count = 0;
static ASC_RuntimeConfig g_asc_runtime_config;

void ASC_Engine_ResetRecord(ASC_SymbolRecord &record)
  {
   record.Identity.RawSymbol = "";
   record.Identity.NormalizedSymbol = "";
   record.Identity.CanonicalSymbol = "";
   record.Identity.AssetClass = "";
   record.Identity.PrimaryBucket = "";
   record.Identity.Sector = "";
   record.Identity.Industry = "";
   record.Identity.Theme = "";
   record.Identity.ClassificationResolved = false;
   record.Identity.ClassificationReason = "";

   record.MarketTruth.Exists = false;
   record.MarketTruth.Selected = false;
   record.MarketTruth.Visible = false;
   record.MarketTruth.QuoteWindowOpen = false;
   record.MarketTruth.TradeWindowOpen = false;
   record.MarketTruth.TradeAllowed = false;
   record.MarketTruth.SessionTruthStatus = ASC_SESSION_UNKNOWN;
   record.MarketTruth.Layer1Eligible = false;
   record.MarketTruth.LastQuoteTime = 0;
   record.MarketTruth.NextRecheckTime = 0;
   record.MarketTruth.IneligibleReason = "";

   record.ConditionsTruth.SpecsReadable = false;
   record.ConditionsTruth.SpecsReason = "";
   record.ConditionsTruth.Digits = -1;
   record.ConditionsTruth.SpreadPoints = -1;
   record.ConditionsTruth.SpreadFloat = false;
   record.ConditionsTruth.Point = 0.0;
   record.ConditionsTruth.TickSize = 0.0;
   record.ConditionsTruth.TickValue = 0.0;
   record.ConditionsTruth.ContractSize = 0.0;
   record.ConditionsTruth.VolumeMin = 0.0;
   record.ConditionsTruth.VolumeMax = 0.0;
   record.ConditionsTruth.VolumeStep = 0.0;

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
      placeholder_record.MarketTruth.IneligibleReason = "PENDING_INIT_PASS";
      placeholder_record.ConditionsTruth.SpecsReason = "PENDING_INIT_PASS";
      ASC_Engine_UpsertRecord(placeholder_record);
     }
  }

void ASC_Engine_ProcessSymbols(const string &symbols[],const int total_symbols,const int max_to_process)
  {
   int limit = total_symbols;
   if(max_to_process > 0 && max_to_process < limit)
      limit = max_to_process;

   for(int index = 0; index < limit; ++index)
     {
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

      ASC_Surface_Evaluate(g_asc_runtime_config,merged_record);

      ASC_Engine_UpsertRecord(merged_record);
     }
  }

bool ASC_Engine_RunInit(ASC_RuntimeConfig &config)
  {
   g_asc_runtime_config = config;

   const bool restore_succeeded = ASC_Storage_LoadUniverseSnapshot(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count);

   string symbols[];
   if(!ASC_Market_DiscoverSymbols(symbols))
     {
      g_asc_universe_count = ArraySize(g_asc_universe_records);
      return(restore_succeeded && g_asc_universe_count > 0);
     }

   ASC_Engine_PreserveUniverseMembership(symbols,ArraySize(symbols));
   ASC_Engine_ProcessSymbols(symbols,ArraySize(symbols),g_asc_runtime_config.MaxSymbolsPerInitPass);

   ASC_Storage_SaveUniverseSnapshot(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count);
   if(g_asc_runtime_config.UseCommonFiles)
      ASC_Output_WriteUniverseSnapshotMirror(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count);

   return(true);
  }

void ASC_Engine_RunTimer()
  {
   string symbols[];
   if(!ASC_Market_DiscoverSymbols(symbols))
      return;

   ASC_Engine_PreserveUniverseMembership(symbols,ArraySize(symbols));
   ASC_Engine_ProcessSymbols(symbols,ArraySize(symbols),g_asc_runtime_config.MaxSymbolsPerTimerPass);

   ASC_Storage_SaveUniverseSnapshot(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count);
   if(g_asc_runtime_config.UseCommonFiles)
      ASC_Output_WriteUniverseSnapshotMirror(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count);
  }

#endif
