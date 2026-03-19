#ifndef ASC_OUTPUT_MQH
#define ASC_OUTPUT_MQH

#include "ASC_Common.mqh"
#include "ASC_Storage.mqh"

#define ASC_OUTPUT_ROOT_PATH "AuroraSentinelCore\\"
#define ASC_OUTPUT_MIRROR_FILE_NAME ASC_OUTPUT_ROOT_PATH "UniverseSnapshotMirror.txt"
#define ASC_OUTPUT_BROKER_FALLBACK "Broker"
#define ASC_OUTPUT_SUMMARY_HEADER "Aurora Sentinel Summary"
#define ASC_OUTPUT_SYMBOL_SECTION_BROKER_SPEC "[BROKER_SPEC]"
#define ASC_OUTPUT_SYMBOL_SECTION_OHLC_HISTORY "[OHLC_HISTORY]"
#define ASC_OUTPUT_SYMBOL_SECTION_CALCULATIONS "[CALCULATIONS]"
#define ASC_OUTPUT_SUMMARY_TEMP_SUFFIX ".tmp"

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
      const ushort code = StringGetCharacter(sanitized,index);
      const string current = StringSubstr(sanitized,index,1);
      if(code < 32 || StringFind(invalid_characters,current) >= 0)
         StringSetCharacter(sanitized,index,'_');
     }

   sanitized = ASC_Output_Trim(sanitized);
   while(StringLen(sanitized) > 0)
     {
      const string tail = StringSubstr(sanitized,StringLen(sanitized) - 1,1);
      if(tail != "." && tail != " ")
         break;
      sanitized = StringSubstr(sanitized,0,StringLen(sanitized) - 1);
     }

   if(StringLen(sanitized) == 0)
      sanitized = ASC_Output_Trim(fallback);

   if(StringLen(sanitized) == 0)
      sanitized = "Broker";

   return(sanitized);
  }

string ASC_Output_ResolveBrokerIdentity()
  {
   const string server = ASC_Output_Trim(AccountInfoString(ACCOUNT_SERVER));
   if(StringLen(server) > 0)
      return(server);

   const string company = ASC_Output_Trim(AccountInfoString(ACCOUNT_COMPANY));
   if(StringLen(company) > 0)
      return(company);

   const string terminal_company = ASC_Output_Trim(TerminalInfoString(TERMINAL_COMPANY));
   if(StringLen(terminal_company) > 0)
      return(terminal_company);

   const long login = AccountInfoInteger(ACCOUNT_LOGIN);
   if(login > 0)
      return("Account" + IntegerToString((int)login));

   return(ASC_OUTPUT_BROKER_FALLBACK);
  }

string ASC_Output_BrokerName()
  {
   static string broker_name = "";
   if(StringLen(broker_name) == 0)
      broker_name = ASC_Output_SanitizePathComponent(ASC_Output_ResolveBrokerIdentity(),ASC_OUTPUT_BROKER_FALLBACK);
   return(broker_name);
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


bool ASC_Output_RecordHasPublishedTruth(const ASC_SymbolRecord &record)
  {
   if(record.Identity.ClassificationResolved)
      return(true);
   if(ASC_Output_IsMeaningfulValue(record.Identity.AssetClass))
      return(true);
   if(ASC_Output_IsMeaningfulValue(record.Identity.PrimaryBucket))
      return(true);
   if(record.MarketTruth.Selected || record.MarketTruth.Visible || record.MarketTruth.QuoteWindowOpen || record.MarketTruth.TradeWindowOpen || record.MarketTruth.TradeAllowed)
      return(true);
   if(record.MarketTruth.SessionTruthStatus != ASC_SESSION_UNKNOWN)
      return(true);
   if(record.MarketTruth.Layer1Eligible)
      return(true);
   if(record.ConditionsTruth.SpecsReadable)
      return(true);
   if(record.ConditionsTruth.DigitsReadable || record.ConditionsTruth.SpreadPointsReadable || record.ConditionsTruth.SpreadFloatReadable)
      return(true);
   if(record.ConditionsTruth.PointReadable || record.ConditionsTruth.TickSizeReadable || record.ConditionsTruth.TickValueReadable ||
      record.ConditionsTruth.ContractSizeReadable || record.ConditionsTruth.VolumeMinReadable ||
      record.ConditionsTruth.VolumeMaxReadable || record.ConditionsTruth.VolumeStepReadable)
      return(true);

   return(false);
  }

string ASC_Output_PublicationStateText(const ASC_SymbolRecord &record)
  {
   if(ASC_Output_RecordHasPublishedTruth(record))
      return("PUBLISHED");

   if(record.MarketTruth.Exists || ASC_Output_IsMeaningfulValue(record.Identity.RawSymbol))
      return("PENDING_SCAN");

   return("UNAVAILABLE");
  }

string ASC_Output_RecordRoute(const string broker_name,const ASC_SymbolRecord &record)
  {
   return(broker_name + ".Symbols\\" + ASC_Output_SanitizePathComponent(ASC_Output_RecordDisplaySymbol(record),"Symbol") + ".txt");
  }

bool ASC_Output_WriteLinesAtomically(const ASC_RuntimeConfig &config,const string file_name,const string &lines[])
  {
   const string temp_file_name = file_name + ASC_OUTPUT_SUMMARY_TEMP_SUFFIX;
   if(!ASC_Storage_WriteAllLines(config,temp_file_name,lines))
      return(false);

   string staged_lines[];
   if(!ASC_Storage_ReadAllLines(config,temp_file_name,staged_lines))
     {
      ASC_Storage_DeleteFile(config,temp_file_name);
      return(false);
     }

   if(ArraySize(staged_lines) != ArraySize(lines))
     {
      ASC_Storage_DeleteFile(config,temp_file_name);
      return(false);
     }

   for(int index = 0; index < ArraySize(lines); ++index)
     {
      if(staged_lines[index] != lines[index])
        {
         ASC_Storage_DeleteFile(config,temp_file_name);
         return(false);
        }
     }

   if(!ASC_Storage_WriteAllLines(config,file_name,lines))
     {
      ASC_Storage_DeleteFile(config,temp_file_name);
      return(false);
     }

   ASC_Storage_DeleteFile(config,temp_file_name);
   return(true);
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

   if(record.ConditionsTruth.DigitsReadable)
      ASC_Output_WriteIntegerField(handle,"Digits",record.ConditionsTruth.Digits);
   else
      FileWrite(handle,"Digits: UNKNOWN");

   if(record.ConditionsTruth.SpreadPointsReadable)
      ASC_Output_WriteIntegerField(handle,"SpreadPoints",record.ConditionsTruth.SpreadPoints);
   else
      FileWrite(handle,"SpreadPoints: UNKNOWN");

   if(record.ConditionsTruth.SpreadFloatReadable)
      FileWrite(handle,"SpreadFloat: " + ASC_Output_BoolText(record.ConditionsTruth.SpreadFloat));
   else
      FileWrite(handle,"SpreadFloat: UNKNOWN");

   ASC_Output_WriteDoubleField(handle,"Point",record.ConditionsTruth.Point,record.ConditionsTruth.PointReadable);
   ASC_Output_WriteDoubleField(handle,"TickSize",record.ConditionsTruth.TickSize,record.ConditionsTruth.TickSizeReadable);
   ASC_Output_WriteDoubleField(handle,"TickValue",record.ConditionsTruth.TickValue,record.ConditionsTruth.TickValueReadable);
   ASC_Output_WriteDoubleField(handle,"ContractSize",record.ConditionsTruth.ContractSize,record.ConditionsTruth.ContractSizeReadable);
   ASC_Output_WriteDoubleField(handle,"VolumeMin",record.ConditionsTruth.VolumeMin,record.ConditionsTruth.VolumeMinReadable);
   ASC_Output_WriteDoubleField(handle,"VolumeMax",record.ConditionsTruth.VolumeMax,record.ConditionsTruth.VolumeMaxReadable);
   ASC_Output_WriteDoubleField(handle,"VolumeStep",record.ConditionsTruth.VolumeStep,record.ConditionsTruth.VolumeStepReadable);
  }

bool ASC_Output_WriteSummarySurface(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count)
  {
   const string broker_name = ASC_Output_BrokerName();
   const string file_name = ASC_Output_SummaryFileName(broker_name);

   int published_count = 0;
   int pending_count = 0;
   int unavailable_count = 0;
   int eligible_count = 0;
   int bucket_known_count = 0;
   string lines[];
   ArrayResize(lines,0);

   const int header_end = ArraySize(lines);
   ArrayResize(lines,header_end + 10);
   lines[header_end] = ASC_OUTPUT_SUMMARY_HEADER;
   lines[header_end + 1] = "Broker: " + broker_name;
   lines[header_end + 2] = "UniverseRecordCount: " + IntegerToString(count);
   lines[header_end + 3] = "";
   lines[header_end + 4] = "[PUBLICATION_STATUS]";
   lines[header_end + 5] = "PublishedSymbolFiles: 0";
   lines[header_end + 6] = "PendingUniverseMembers: 0";
   lines[header_end + 7] = "UnavailableUniverseMembers: 0";
   lines[header_end + 8] = "Layer1EligibleCount: 0";
   lines[header_end + 9] = "BucketResolvedCount: 0";

   string published_buckets[];
   ArrayResize(published_buckets,0);

   for(int index = 0; index < count; ++index)
     {
      const ASC_SymbolRecord record = records[index];
      if(record.MarketTruth.Layer1Eligible)
         ++eligible_count;
      if(ASC_Output_IsMeaningfulValue(record.Identity.PrimaryBucket))
         ++bucket_known_count;

      const string publication_state = ASC_Output_PublicationStateText(record);
      if(publication_state == "PUBLISHED")
         ++published_count;
      else if(publication_state == "PENDING_SCAN")
         ++pending_count;
      else
         ++unavailable_count;
     }

   lines[5] = "PublishedSymbolFiles: " + IntegerToString(published_count);
   lines[6] = "PendingUniverseMembers: " + IntegerToString(pending_count);
   lines[7] = "UnavailableUniverseMembers: " + IntegerToString(unavailable_count);
   lines[8] = "Layer1EligibleCount: " + IntegerToString(eligible_count);
   lines[9] = "BucketResolvedCount: " + IntegerToString(bucket_known_count);

   const int guidance_start = ArraySize(lines);
   ArrayResize(lines,guidance_start + 4);
   lines[guidance_start] = "";
   lines[guidance_start + 1] = "[ROUTING_GUIDANCE]";
   lines[guidance_start + 2] = "Published symbol routes appear below only when a symbol file was actually written this cycle.";
   lines[guidance_start + 3] = "Pending symbols remain in the universe count but are not routed as finished symbol publications.";

   for(int index = 0; index < count; ++index)
     {
      const ASC_SymbolRecord record = records[index];
      if(ASC_Output_PublicationStateText(record) != "PUBLISHED")
         continue;

      const string bucket = ASC_Output_PrimaryBucketLabel(record);
      bool already_published = false;
      for(int bucket_index = 0; bucket_index < ArraySize(published_buckets); ++bucket_index)
        {
         if(published_buckets[bucket_index] == bucket)
           {
            already_published = true;
            break;
           }
        }

      if(!already_published)
        {
         const int next_bucket_index = ArraySize(published_buckets);
         ArrayResize(published_buckets,next_bucket_index + 1);
         published_buckets[next_bucket_index] = bucket;

         const int section_start = ArraySize(lines);
         ArrayResize(lines,section_start + 2);
         lines[section_start] = "";
         lines[section_start + 1] = "[PRIMARY_BUCKET] " + bucket;
        }

      string line = ASC_Output_RecordDisplaySymbol(record);
      line += " | Route=" + ASC_Output_RecordRoute(broker_name,record);
      line += " | Session=" + ASC_Output_SessionStatusText(record.MarketTruth.SessionTruthStatus);
      line += " | Layer1Eligible=" + ASC_Output_BoolText(record.MarketTruth.Layer1Eligible);
      line += " | SpecsReadable=" + ASC_Output_BoolText(record.ConditionsTruth.SpecsReadable);
      const int next_index = ArraySize(lines);
      ArrayResize(lines,next_index + 1);
      lines[next_index] = line;
     }

   const int footer_start = ArraySize(lines);
   ArrayResize(lines,footer_start + 4);
   lines[footer_start] = "";
   lines[footer_start + 1] = "[PENDING_OR_UNAVAILABLE]";
   lines[footer_start + 2] = "Pending or unavailable universe members remain preserved in the universe snapshot and mirror output until a later pass supplies publishable truth.";
   lines[footer_start + 3] = "Use UniverseSnapshotMirror.txt for broad continuity review; use symbol routes above for finished per-symbol publication.";

   return(ASC_Output_WriteLinesAtomically(config,file_name,lines));
  }

bool ASC_Output_WriteSymbolSurface(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &record)
  {
   if(!ASC_Output_RecordHasPublishedTruth(record))
      return(true);

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
   FileWrite(handle,"HistoryStatus: PENDING_UPSTREAM_TRUTH");
   FileWrite(handle,"HistoryNote: This symbol file is intentionally limited to currently supplied broker and conditions truth.");
   FileWrite(handle,"");

   FileWrite(handle,ASC_OUTPUT_SYMBOL_SECTION_CALCULATIONS);
   FileWrite(handle,"CalculationStatus: PENDING_UPSTREAM_TRUTH");
   FileWrite(handle,"CalculationNote: No calculation payload was provided to this writer, so no later-layer values are implied.");

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


void ASC_Output_RemoveStaleSymbolFiles(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count)
  {
   const string broker_name = ASC_Output_BrokerName();
   const string search_root = ASC_Output_SymbolDirectory(broker_name) + "\\*.txt";
   string found_name = "";
   long search_handle = FileFindFirst(search_root,found_name,config.UseCommonFiles ? FILE_COMMON : 0);
   if(search_handle == INVALID_HANDLE)
      return;

   do
     {
      if(StringLen(found_name) == 0 || found_name == "." || found_name == "..")
         continue;

      bool keep_file = false;
      for(int index = 0; index < count; ++index)
        {
         if(!ASC_Output_RecordHasPublishedTruth(records[index]))
            continue;

         string expected_name = ASC_Output_SanitizePathComponent(ASC_Output_RecordDisplaySymbol(records[index]),"Symbol") + ".txt";
         if(expected_name == found_name)
           {
            keep_file = true;
            break;
           }
        }

      if(!keep_file)
         ASC_Storage_DeleteFile(config,ASC_Output_SymbolDirectory(broker_name) + "\\" + found_name);
     }
   while(FileFindNext(search_handle,found_name));

   FileFindClose(search_handle);
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

   if(!ASC_Output_WriteSymbolSurfaces(config,records,count))
      return(false);

   ASC_Output_RemoveStaleSymbolFiles(config,records,count);

   if(!ASC_Output_WriteSummarySurface(config,records,count))
      return(false);

   return(true);
  }

#endif
