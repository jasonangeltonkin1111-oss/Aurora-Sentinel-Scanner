#ifndef ASC_ENGINE_MQH
#define ASC_ENGINE_MQH

#include "ASC_Common.mqh"

static ASC_RuntimeConfig g_asc_runtime_config;
static ASC_SymbolRecord  g_asc_universe_records[];
static int               g_asc_universe_count = 0;

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
   record.ConditionsTruth.Digits = 0;
   record.ConditionsTruth.SpreadPoints = 0;
   record.ConditionsTruth.SpreadFloat = false;
   record.ConditionsTruth.Point = 0.0;
   record.ConditionsTruth.TickSize = 0.0;
   record.ConditionsTruth.TickValue = 0.0;
   record.ConditionsTruth.ContractSize = 0.0;
   record.ConditionsTruth.VolumeMin = 0.0;
   record.ConditionsTruth.VolumeMax = 0.0;
   record.ConditionsTruth.VolumeStep = 0.0;
  }

int ASC_Engine_FindRecordIndexBySymbol(const string symbol)
  {
   if(StringLen(symbol) == 0)
      return(-1);

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

int ASC_Engine_FindRecordIndex(const ASC_SymbolRecord &record)
  {
   int index = ASC_Engine_FindRecordIndexBySymbol(record.Identity.RawSymbol);
   if(index >= 0)
      return(index);

   index = ASC_Engine_FindRecordIndexBySymbol(record.Identity.NormalizedSymbol);
   if(index >= 0)
      return(index);

   return(ASC_Engine_FindRecordIndexBySymbol(record.Identity.CanonicalSymbol));
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

void ASC_Engine_ProcessSymbols(const string &symbols[],const int discovered_count,const int max_pass)
  {
   const int bounded_count = MathMin(discovered_count,max_pass);
   if(bounded_count <= 0)
      return;

   for(int index = 0; index < bounded_count; ++index)
     {
      ASC_SymbolRecord built_record;
      ASC_Engine_ResetRecord(built_record);

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

   ASC_Engine_ProcessSymbols(symbols,ArraySize(symbols),g_asc_runtime_config.MaxSymbolsPerTimerPass);

   ASC_Storage_SaveUniverseSnapshot(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count);
   if(g_asc_runtime_config.UseCommonFiles)
      ASC_Output_WriteUniverseSnapshotMirror(g_asc_runtime_config,g_asc_universe_records,g_asc_universe_count);
  }

#endif
