#ifndef ASC_OUTPUT_MQH
#define ASC_OUTPUT_MQH

#include "ASC_Common.mqh"

#define ASC_OUTPUT_ROOT_PATH "AuroraSentinelCore\\"
#define ASC_OUTPUT_MIRROR_FILE_NAME ASC_OUTPUT_ROOT_PATH "UniverseSnapshotMirror.txt"
#define ASC_OUTPUT_BROKER_FALLBACK "BROKER"
#define ASC_OUTPUT_SUMMARY_HEADER "Aurora Sentinel Summary"
#define ASC_OUTPUT_SYMBOL_SECTION_BROKER_SPEC "[BROKER_SPEC]"
#define ASC_OUTPUT_SYMBOL_SECTION_OHLC_HISTORY "[OHLC_HISTORY]"
#define ASC_OUTPUT_SYMBOL_SECTION_CALCULATIONS "[CALCULATIONS]"

int ASC_Output_OpenFlags(const bool use_common_files)
  {
   int flags = FILE_TXT | FILE_ANSI;
   if(use_common_files)
      flags |= FILE_COMMON;
   return(flags);
  }

string ASC_Output_BoolText(const bool value)
  {
   if(value)
      return("YES");
   return("NO");
  }

string ASC_Output_SessionStatusText(const ASC_SessionTruthStatus status)
  {
   switch(status)
     {
      case ASC_SESSION_OPEN_TRADABLE:
         return("OPEN_TRADABLE");
      case ASC_SESSION_CLOSED_SESSION:
         return("CLOSED_SESSION");
      case ASC_SESSION_QUOTE_ONLY:
         return("QUOTE_ONLY");
      case ASC_SESSION_TRADE_DISABLED:
         return("TRADE_DISABLED");
      case ASC_SESSION_NO_QUOTE:
         return("NO_QUOTE");
      case ASC_SESSION_STALE_FEED:
         return("STALE_FEED");
      default:
         return("UNKNOWN");
     }
  }

string ASC_Output_Trim(const string value)
  {
   string result = value;
   StringTrimLeft(result);
   StringTrimRight(result);
   return(result);
  }

bool ASC_Output_IsMeaningfulValue(const string value)
  {
   const string trimmed = ASC_Output_Trim(value);
   if(StringLen(trimmed) == 0)
      return(false);

   return(trimmed != "UNKNOWN");
  }

string ASC_Output_SanitizePathComponent(const string value,const string fallback)
  {
   string sanitized = ASC_Output_Trim(value);
   const string invalid_characters = "\\/:*?\"<>|";

   for(int index = 0; index < StringLen(sanitized); ++index)
     {
      const string current = StringSubstr(sanitized,index,1);
      if(StringFind(invalid_characters,current) >= 0)
         StringSetCharacter(sanitized,index,'_');
     }

   if(StringLen(sanitized) == 0)
      sanitized = fallback;

   return(sanitized);
  }

string ASC_Output_BrokerName()
  {
   const string server = ASC_Output_Trim(AccountInfoString(ACCOUNT_SERVER));
   if(StringLen(server) > 0)
      return(ASC_Output_SanitizePathComponent(server,ASC_OUTPUT_BROKER_FALLBACK));

   const string company = ASC_Output_Trim(AccountInfoString(ACCOUNT_COMPANY));
   if(StringLen(company) > 0)
      return(ASC_Output_SanitizePathComponent(company,ASC_OUTPUT_BROKER_FALLBACK));

   return(ASC_OUTPUT_BROKER_FALLBACK);
  }

string ASC_Output_SummaryFileName(const string broker_name)
  {
   return(ASC_OUTPUT_ROOT_PATH + broker_name + ".Summary.txt");
  }

string ASC_Output_SymbolDirectory(const string broker_name)
  {
   return(ASC_OUTPUT_ROOT_PATH + broker_name + ".Symbols");
  }

string ASC_Output_SymbolFileName(const string broker_name,const ASC_SymbolRecord &record)
  {
   string symbol_name = record.Identity.CanonicalSymbol;
   if(!ASC_Output_IsMeaningfulValue(symbol_name))
      symbol_name = record.Identity.NormalizedSymbol;
   if(!ASC_Output_IsMeaningfulValue(symbol_name))
      symbol_name = record.Identity.RawSymbol;

   symbol_name = ASC_Output_SanitizePathComponent(symbol_name,"Symbol");
   return(ASC_Output_SymbolDirectory(broker_name) + "\\" + symbol_name + ".txt");
  }

void ASC_Output_WriteStringField(const int handle,const string label,const string value)
  {
   if(value == "")
      FileWrite(handle,label + ": UNKNOWN");
   else
      FileWrite(handle,label + ": " + value);
  }

void ASC_Output_WriteIntegerField(const int handle,const string label,const long value)
  {
   FileWrite(handle,label + ": " + IntegerToString((int)value));
  }

void ASC_Output_WriteDoubleField(const int handle,const string label,const double value,const bool readable)
  {
   if(!readable)
     {
      FileWrite(handle,label + ": UNKNOWN");
      return;
     }

   FileWrite(handle,label + ": " + DoubleToString(value,16));
  }

string ASC_Output_PrimaryBucketLabel(const ASC_SymbolRecord &record)
  {
   if(ASC_Output_IsMeaningfulValue(record.Identity.PrimaryBucket))
      return(record.Identity.PrimaryBucket);
   return("UNKNOWN");
  }

string ASC_Output_RecordDisplaySymbol(const ASC_SymbolRecord &record)
  {
   if(ASC_Output_IsMeaningfulValue(record.Identity.CanonicalSymbol))
      return(record.Identity.CanonicalSymbol);
   if(ASC_Output_IsMeaningfulValue(record.Identity.NormalizedSymbol))
      return(record.Identity.NormalizedSymbol);
   if(ASC_Output_IsMeaningfulValue(record.Identity.RawSymbol))
      return(record.Identity.RawSymbol);
   return("UNKNOWN");
  }

void ASC_Output_WriteConditionsFields(const int handle,const ASC_SymbolRecord &record)
  {
   FileWrite(handle,"SpecsReadable: " + ASC_Output_BoolText(record.ConditionsTruth.SpecsReadable));
   ASC_Output_WriteStringField(handle,"SpecsReason",record.ConditionsTruth.SpecsReason);

   if(record.ConditionsTruth.Digits >= 0)
      ASC_Output_WriteIntegerField(handle,"Digits",record.ConditionsTruth.Digits);
   else
      FileWrite(handle,"Digits: UNKNOWN");

   if(record.ConditionsTruth.SpreadPoints >= 0)
      ASC_Output_WriteIntegerField(handle,"SpreadPoints",record.ConditionsTruth.SpreadPoints);
   else
      FileWrite(handle,"SpreadPoints: UNKNOWN");

   if(record.ConditionsTruth.SpecsReadable)
      FileWrite(handle,"SpreadFloat: " + ASC_Output_BoolText(record.ConditionsTruth.SpreadFloat));
   else
      FileWrite(handle,"SpreadFloat: UNKNOWN");

   ASC_Output_WriteDoubleField(handle,"Point",record.ConditionsTruth.Point,record.ConditionsTruth.Point > 0.0);
   ASC_Output_WriteDoubleField(handle,"TickSize",record.ConditionsTruth.TickSize,record.ConditionsTruth.TickSize > 0.0);
   ASC_Output_WriteDoubleField(handle,"TickValue",record.ConditionsTruth.TickValue,record.ConditionsTruth.TickValue > 0.0);
   ASC_Output_WriteDoubleField(handle,"ContractSize",record.ConditionsTruth.ContractSize,record.ConditionsTruth.ContractSize > 0.0);
   ASC_Output_WriteDoubleField(handle,"VolumeMin",record.ConditionsTruth.VolumeMin,record.ConditionsTruth.VolumeMin > 0.0);
   ASC_Output_WriteDoubleField(handle,"VolumeMax",record.ConditionsTruth.VolumeMax,record.ConditionsTruth.VolumeMax > 0.0);
   ASC_Output_WriteDoubleField(handle,"VolumeStep",record.ConditionsTruth.VolumeStep,record.ConditionsTruth.VolumeStep > 0.0);
  }

bool ASC_Output_WriteSummarySurface(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count)
  {
   const string broker_name = ASC_Output_BrokerName();
   const string file_name = ASC_Output_SummaryFileName(broker_name);
   const int handle = FileOpen(file_name,ASC_Output_OpenFlags(config.UseCommonFiles) | FILE_WRITE);
   if(handle == INVALID_HANDLE)
      return(false);

   FileWrite(handle,ASC_OUTPUT_SUMMARY_HEADER);
   FileWrite(handle,"Broker: " + broker_name);
   FileWrite(handle,"UniverseRecordCount: " + IntegerToString(count));
   FileWrite(handle,"");

   string published_buckets[];
   ArrayResize(published_buckets,0);

   for(int index = 0; index < count; ++index)
     {
      const string bucket = ASC_Output_PrimaryBucketLabel(records[index]);
      bool already_published = false;

      for(int bucket_index = 0; bucket_index < ArraySize(published_buckets); ++bucket_index)
        {
         if(published_buckets[bucket_index] == bucket)
           {
            already_published = true;
            break;
           }
        }

      if(already_published)
         continue;

      const int next_bucket_index = ArraySize(published_buckets);
      ArrayResize(published_buckets,next_bucket_index + 1);
      published_buckets[next_bucket_index] = bucket;

      FileWrite(handle,"[PRIMARY_BUCKET] " + bucket);
      for(int record_index = 0; record_index < count; ++record_index)
        {
         if(ASC_Output_PrimaryBucketLabel(records[record_index]) != bucket)
            continue;

         const ASC_SymbolRecord record = records[record_index];
         string line = ASC_Output_RecordDisplaySymbol(record);
         line += " | Session=" + ASC_Output_SessionStatusText(record.MarketTruth.SessionTruthStatus);
         line += " | Layer1Eligible=" + ASC_Output_BoolText(record.MarketTruth.Layer1Eligible);
         line += " | SpecsReadable=" + ASC_Output_BoolText(record.ConditionsTruth.SpecsReadable);

         if(record.ConditionsTruth.SpreadPoints >= 0)
            line += " | SpreadPoints=" + IntegerToString(record.ConditionsTruth.SpreadPoints);
         else
            line += " | SpreadPoints=UNKNOWN";

         FileWrite(handle,line);
        }

      FileWrite(handle,"");
     }

   FileClose(handle);
   return(true);
  }

bool ASC_Output_WriteSymbolSurface(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &record)
  {
   const string broker_name = ASC_Output_BrokerName();
   const string directory_name = ASC_Output_SymbolDirectory(broker_name);
   FolderCreate(directory_name,config.UseCommonFiles ? FILE_COMMON : 0);

   const int handle = FileOpen(ASC_Output_SymbolFileName(broker_name,record),ASC_Output_OpenFlags(config.UseCommonFiles) | FILE_WRITE);
   if(handle == INVALID_HANDLE)
      return(false);

   FileWrite(handle,ASC_Output_RecordDisplaySymbol(record));
   FileWrite(handle,"Broker: " + broker_name);
   FileWrite(handle,"");

   FileWrite(handle,ASC_OUTPUT_SYMBOL_SECTION_BROKER_SPEC);
   ASC_Output_WriteStringField(handle,"RawSymbol",record.Identity.RawSymbol);
   ASC_Output_WriteStringField(handle,"NormalizedSymbol",record.Identity.NormalizedSymbol);
   ASC_Output_WriteStringField(handle,"CanonicalSymbol",record.Identity.CanonicalSymbol);
   ASC_Output_WriteStringField(handle,"AssetClass",record.Identity.AssetClass);
   ASC_Output_WriteStringField(handle,"PrimaryBucket",ASC_Output_PrimaryBucketLabel(record));
   ASC_Output_WriteStringField(handle,"Sector",record.Identity.Sector);
   ASC_Output_WriteStringField(handle,"Industry",record.Identity.Industry);
   ASC_Output_WriteStringField(handle,"Theme",record.Identity.Theme);
   FileWrite(handle,"ClassificationResolved: " + ASC_Output_BoolText(record.Identity.ClassificationResolved));
   ASC_Output_WriteStringField(handle,"ClassificationReason",record.Identity.ClassificationReason);
   FileWrite(handle,"SessionTruthStatus: " + ASC_Output_SessionStatusText(record.MarketTruth.SessionTruthStatus));
   FileWrite(handle,"Layer1Eligible: " + ASC_Output_BoolText(record.MarketTruth.Layer1Eligible));
   ASC_Output_WriteConditionsFields(handle,record);
   FileWrite(handle,"");

   FileWrite(handle,ASC_OUTPUT_SYMBOL_SECTION_OHLC_HISTORY);
   FileWrite(handle,"HistoryStatus: NOT_PUBLISHED");
   FileWrite(handle,"HistoryNote: No history values were supplied to this publication path.");
   FileWrite(handle,"");

   FileWrite(handle,ASC_OUTPUT_SYMBOL_SECTION_CALCULATIONS);
   FileWrite(handle,"CalculationStatus: NOT_PUBLISHED");
   FileWrite(handle,"CalculationNote: No calculation values were supplied to this publication path.");

   FileClose(handle);
   return(true);
  }

bool ASC_Output_WriteSymbolSurfaces(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count)
  {
   const string broker_name = ASC_Output_BrokerName();
   FolderCreate(ASC_OUTPUT_ROOT_PATH,config.UseCommonFiles ? FILE_COMMON : 0);
   FolderCreate(ASC_Output_SymbolDirectory(broker_name),config.UseCommonFiles ? FILE_COMMON : 0);

   for(int index = 0; index < count; ++index)
     {
      if(!ASC_Output_WriteSymbolSurface(config,records[index]))
         return(false);
     }

   return(true);
  }

bool ASC_Output_WriteUniverseSnapshotMirror(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count)
  {
   FolderCreate(ASC_OUTPUT_ROOT_PATH,config.UseCommonFiles ? FILE_COMMON : 0);

   const int handle = FileOpen(ASC_OUTPUT_MIRROR_FILE_NAME,ASC_Output_OpenFlags(config.UseCommonFiles) | FILE_WRITE);
   if(handle == INVALID_HANDLE)
      return(false);

   FileWrite(handle,"Universe Snapshot Mirror");
   FileWrite(handle,"RecordCount: " + IntegerToString(count));
   FileWrite(handle,"");

   for(int index = 0; index < count; ++index)
     {
      const ASC_SymbolRecord record = records[index];

      FileWrite(handle,"[Symbol]");
      ASC_Output_WriteStringField(handle,"RawSymbol",record.Identity.RawSymbol);
      ASC_Output_WriteStringField(handle,"NormalizedSymbol",record.Identity.NormalizedSymbol);
      ASC_Output_WriteStringField(handle,"CanonicalSymbol",record.Identity.CanonicalSymbol);
      ASC_Output_WriteStringField(handle,"AssetClass",record.Identity.AssetClass);
      ASC_Output_WriteStringField(handle,"PrimaryBucket",record.Identity.PrimaryBucket);
      ASC_Output_WriteStringField(handle,"Sector",record.Identity.Sector);
      ASC_Output_WriteStringField(handle,"Industry",record.Identity.Industry);
      ASC_Output_WriteStringField(handle,"Theme",record.Identity.Theme);
      FileWrite(handle,"ClassificationResolved: " + ASC_Output_BoolText(record.Identity.ClassificationResolved));
      ASC_Output_WriteStringField(handle,"ClassificationReason",record.Identity.ClassificationReason);

      FileWrite(handle,"[MarketState]");
      FileWrite(handle,"Exists: " + ASC_Output_BoolText(record.MarketTruth.Exists));
      FileWrite(handle,"Selected: " + ASC_Output_BoolText(record.MarketTruth.Selected));
      FileWrite(handle,"Visible: " + ASC_Output_BoolText(record.MarketTruth.Visible));
      FileWrite(handle,"QuoteWindowOpen: " + ASC_Output_BoolText(record.MarketTruth.QuoteWindowOpen));
      FileWrite(handle,"TradeWindowOpen: " + ASC_Output_BoolText(record.MarketTruth.TradeWindowOpen));
      FileWrite(handle,"TradeAllowed: " + ASC_Output_BoolText(record.MarketTruth.TradeAllowed));
      FileWrite(handle,"SessionTruthStatus: " + ASC_Output_SessionStatusText(record.MarketTruth.SessionTruthStatus));
      FileWrite(handle,"Layer1Eligible: " + ASC_Output_BoolText(record.MarketTruth.Layer1Eligible));
      ASC_Output_WriteIntegerField(handle,"LastQuoteTime",(long)record.MarketTruth.LastQuoteTime);
      ASC_Output_WriteIntegerField(handle,"NextRecheckTime",(long)record.MarketTruth.NextRecheckTime);
      ASC_Output_WriteStringField(handle,"IneligibleReason",record.MarketTruth.IneligibleReason);

      FileWrite(handle,"[Conditions]");
      ASC_Output_WriteConditionsFields(handle,record);
      FileWrite(handle,"");
     }

   FileClose(handle);

   if(!ASC_Output_WriteSummarySurface(config,records,count))
      return(false);

   if(!ASC_Output_WriteSymbolSurfaces(config,records,count))
      return(false);

   return(true);
  }

#endif
