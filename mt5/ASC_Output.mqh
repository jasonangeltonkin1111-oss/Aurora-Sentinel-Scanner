#ifndef ASC_OUTPUT_MQH
#define ASC_OUTPUT_MQH

#include "ASC_Common.mqh"

#define ASC_OUTPUT_MIRROR_FILE_NAME "AuroraSentinelCore\\UniverseSnapshotMirror.txt"

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

bool ASC_Output_WriteUniverseSnapshotMirror(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count)
  {
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
      FileWrite(handle,"SpecsReadable: " + ASC_Output_BoolText(record.ConditionsTruth.SpecsReadable));
      ASC_Output_WriteStringField(handle,"SpecsReason",record.ConditionsTruth.SpecsReason);
      ASC_Output_WriteIntegerField(handle,"Digits",record.ConditionsTruth.Digits);
      ASC_Output_WriteIntegerField(handle,"SpreadPoints",record.ConditionsTruth.SpreadPoints);
      FileWrite(handle,"SpreadFloat: " + ASC_Output_BoolText(record.ConditionsTruth.SpreadFloat));
      ASC_Output_WriteDoubleField(handle,"Point",record.ConditionsTruth.Point,record.ConditionsTruth.SpecsReadable);
      ASC_Output_WriteDoubleField(handle,"TickSize",record.ConditionsTruth.TickSize,record.ConditionsTruth.SpecsReadable);
      ASC_Output_WriteDoubleField(handle,"TickValue",record.ConditionsTruth.TickValue,record.ConditionsTruth.SpecsReadable);
      ASC_Output_WriteDoubleField(handle,"ContractSize",record.ConditionsTruth.ContractSize,record.ConditionsTruth.SpecsReadable);
      ASC_Output_WriteDoubleField(handle,"VolumeMin",record.ConditionsTruth.VolumeMin,record.ConditionsTruth.SpecsReadable);
      ASC_Output_WriteDoubleField(handle,"VolumeMax",record.ConditionsTruth.VolumeMax,record.ConditionsTruth.SpecsReadable);
      ASC_Output_WriteDoubleField(handle,"VolumeStep",record.ConditionsTruth.VolumeStep,record.ConditionsTruth.SpecsReadable);
      FileWrite(handle,"");
     }

   FileClose(handle);
   return(true);
  }

#endif
