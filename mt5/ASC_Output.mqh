#ifndef ASC_OUTPUT_MQH
#define ASC_OUTPUT_MQH

#include "ASC_Common.mqh"

#define ASC_OUTPUT_FOLDER "AuroraSentinelCore"
#define ASC_OUTPUT_UNIVERSE_MIRROR_FILE ASC_OUTPUT_FOLDER "\\UniverseSnapshotMirror.txt"
#define ASC_OUTPUT_UNIVERSE_MIRROR_TEMP_FILE ASC_OUTPUT_FOLDER "\\UniverseSnapshotMirror.tmp"

int ASC_Output_FileFlags(const ASC_RuntimeConfig &config)
  {
   int flags=FILE_TXT|FILE_ANSI;
   if(config.UseCommonFiles)
      flags|=FILE_COMMON;
   return flags;
  }

bool ASC_Output_EnsureFolder(const ASC_RuntimeConfig &config)
  {
   if(FolderCreate(ASC_OUTPUT_FOLDER))
      return true;

   return true;
  }

string ASC_Output_BoolText(const bool value)
  {
   return value ? "Yes" : "No";
  }

string ASC_Output_BoolOrUnknown(const bool value,const bool is_known)
  {
   if(!is_known)
      return "Unknown";

   return ASC_Output_BoolText(value);
  }

string ASC_Output_DateTimeText(const datetime value)
  {
   if(value<=0)
      return "Unknown";

   return TimeToString(value,TIME_DATE|TIME_SECONDS);
  }

string ASC_Output_SessionTruthText(const ASC_SessionTruthStatus status)
  {
   switch(status)
     {
      case ASC_SESSION_OPEN_TRADABLE:
         return "Open tradable";
      case ASC_SESSION_CLOSED_SESSION:
         return "Closed session";
      case ASC_SESSION_QUOTE_ONLY:
         return "Quote only";
      case ASC_SESSION_TRADE_DISABLED:
         return "Trade disabled";
      case ASC_SESSION_NO_QUOTE:
         return "No quote";
      case ASC_SESSION_STALE_FEED:
         return "Stale feed";
      case ASC_SESSION_UNKNOWN:
      default:
         return "Unknown";
     }
  }

string ASC_Output_TextOrUnknown(const string value)
  {
   return (value=="") ? "Unknown" : value;
  }

string ASC_Output_DoubleOrUnknown(const double value,const bool is_known)
  {
   if(!is_known)
      return "Unknown";

   return DoubleToString(value,8);
  }

string ASC_Output_IntOrUnknown(const int value,const bool is_known)
  {
   if(!is_known)
      return "Unknown";

   return IntegerToString(value);
  }

bool ASC_Output_WriteLine(const int handle,const string line)
  {
   return FileWriteString(handle,line+"\r\n")>0;
  }

bool ASC_Output_WriteUniverseSnapshotMirror(const ASC_RuntimeConfig &config, const ASC_SymbolRecord &records[], const int count)
  {
   if(count<0)
      return false;

   if(!ASC_Output_EnsureFolder(config))
      return false;

   const int flags=ASC_Output_FileFlags(config);
   const int handle=FileOpen(ASC_OUTPUT_UNIVERSE_MIRROR_TEMP_FILE,flags|FILE_WRITE);
   if(handle==INVALID_HANDLE)
      return false;

   bool ok=true;
   ok=ok && ASC_Output_WriteLine(handle,"Aurora Sentinel Scanner");
   ok=ok && ASC_Output_WriteLine(handle,"Universe Snapshot Mirror");
   ok=ok && ASC_Output_WriteLine(handle,"Symbol Count: "+IntegerToString(count));
   ok=ok && ASC_Output_WriteLine(handle,"");

   for(int index=0; ok && index<count; ++index)
     {
      const ASC_SymbolRecord &record=records[index];
      ok=ok && ASC_Output_WriteLine(handle,"["+ASC_Output_TextOrUnknown(record.Identity.RawSymbol)+"]");
      ok=ok && ASC_Output_WriteLine(handle,"Raw Symbol: "+ASC_Output_TextOrUnknown(record.Identity.RawSymbol));
      ok=ok && ASC_Output_WriteLine(handle,"Normalized Symbol: "+ASC_Output_TextOrUnknown(record.Identity.NormalizedSymbol));
      ok=ok && ASC_Output_WriteLine(handle,"Canonical Symbol: "+ASC_Output_TextOrUnknown(record.Identity.CanonicalSymbol));
      ok=ok && ASC_Output_WriteLine(handle,"Asset Class: "+ASC_Output_TextOrUnknown(record.Identity.AssetClass));
      ok=ok && ASC_Output_WriteLine(handle,"Primary Bucket: "+ASC_Output_TextOrUnknown(record.Identity.PrimaryBucket));
      ok=ok && ASC_Output_WriteLine(handle,"Sector: "+ASC_Output_TextOrUnknown(record.Identity.Sector));
      ok=ok && ASC_Output_WriteLine(handle,"Industry: "+ASC_Output_TextOrUnknown(record.Identity.Industry));
      ok=ok && ASC_Output_WriteLine(handle,"Theme: "+ASC_Output_TextOrUnknown(record.Identity.Theme));
      ok=ok && ASC_Output_WriteLine(handle,"Classification Resolved: "+ASC_Output_BoolText(record.Identity.ClassificationResolved));
      ok=ok && ASC_Output_WriteLine(handle,"Classification Reason: "+ASC_Output_TextOrUnknown(record.Identity.ClassificationReason));
      ok=ok && ASC_Output_WriteLine(handle,"Exists: "+ASC_Output_BoolText(record.MarketTruth.Exists));
      ok=ok && ASC_Output_WriteLine(handle,"Selected: "+ASC_Output_BoolText(record.MarketTruth.Selected));
      ok=ok && ASC_Output_WriteLine(handle,"Visible: "+ASC_Output_BoolText(record.MarketTruth.Visible));
      ok=ok && ASC_Output_WriteLine(handle,"Quote Window Open: "+ASC_Output_BoolText(record.MarketTruth.QuoteWindowOpen));
      ok=ok && ASC_Output_WriteLine(handle,"Trade Window Open: "+ASC_Output_BoolText(record.MarketTruth.TradeWindowOpen));
      ok=ok && ASC_Output_WriteLine(handle,"Trade Allowed: "+ASC_Output_BoolText(record.MarketTruth.TradeAllowed));
      ok=ok && ASC_Output_WriteLine(handle,"Session Status: "+ASC_Output_SessionTruthText(record.MarketTruth.SessionTruthStatus));
      ok=ok && ASC_Output_WriteLine(handle,"Layer 1 Eligible: "+ASC_Output_BoolText(record.MarketTruth.Layer1Eligible));
      ok=ok && ASC_Output_WriteLine(handle,"Last Quote Time: "+ASC_Output_DateTimeText(record.MarketTruth.LastQuoteTime));
      ok=ok && ASC_Output_WriteLine(handle,"Next Recheck Time: "+ASC_Output_DateTimeText(record.MarketTruth.NextRecheckTime));
      ok=ok && ASC_Output_WriteLine(handle,"Ineligible Reason: "+ASC_Output_TextOrUnknown(record.MarketTruth.IneligibleReason));
      ok=ok && ASC_Output_WriteLine(handle,"Specs Readable: "+ASC_Output_BoolText(record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"Specs Reason: "+ASC_Output_TextOrUnknown(record.ConditionsTruth.SpecsReason));
      ok=ok && ASC_Output_WriteLine(handle,"Digits: "+ASC_Output_IntOrUnknown(record.ConditionsTruth.Digits,record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"Spread Points: "+ASC_Output_IntOrUnknown(record.ConditionsTruth.SpreadPoints,record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"Spread Float: "+ASC_Output_BoolOrUnknown(record.ConditionsTruth.SpreadFloat,record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"Point: "+ASC_Output_DoubleOrUnknown(record.ConditionsTruth.Point,record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"Tick Size: "+ASC_Output_DoubleOrUnknown(record.ConditionsTruth.TickSize,record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"Tick Value: "+ASC_Output_DoubleOrUnknown(record.ConditionsTruth.TickValue,record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"Contract Size: "+ASC_Output_DoubleOrUnknown(record.ConditionsTruth.ContractSize,record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"Volume Min: "+ASC_Output_DoubleOrUnknown(record.ConditionsTruth.VolumeMin,record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"Volume Max: "+ASC_Output_DoubleOrUnknown(record.ConditionsTruth.VolumeMax,record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"Volume Step: "+ASC_Output_DoubleOrUnknown(record.ConditionsTruth.VolumeStep,record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Output_WriteLine(handle,"");
     }

   FileFlush(handle);
   FileClose(handle);

   if(!ok)
     {
      FileDelete(ASC_OUTPUT_UNIVERSE_MIRROR_TEMP_FILE,flags);
      return false;
     }

   if(FileIsExist(ASC_OUTPUT_UNIVERSE_MIRROR_FILE,flags))
      FileDelete(ASC_OUTPUT_UNIVERSE_MIRROR_FILE,flags);

   if(!FileCopy(ASC_OUTPUT_UNIVERSE_MIRROR_TEMP_FILE,
                config.UseCommonFiles ? FILE_COMMON : 0,
                ASC_OUTPUT_UNIVERSE_MIRROR_FILE,
                (config.UseCommonFiles ? FILE_COMMON : 0)|FILE_REWRITE))
     {
      FileDelete(ASC_OUTPUT_UNIVERSE_MIRROR_TEMP_FILE,flags);
      return false;
     }

   FileDelete(ASC_OUTPUT_UNIVERSE_MIRROR_TEMP_FILE,flags);
   return true;
  }

#endif
