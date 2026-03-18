#ifndef ASC_STORAGE_MQH
#define ASC_STORAGE_MQH

#include "ASC_Common.mqh"

#define ASC_STORAGE_FOLDER "AuroraSentinelCore"
#define ASC_STORAGE_SNAPSHOT_FILE ASC_STORAGE_FOLDER "\\UniverseSnapshot.txt"
#define ASC_STORAGE_SNAPSHOT_TEMP_FILE ASC_STORAGE_FOLDER "\\UniverseSnapshot.tmp"
#define ASC_STORAGE_SNAPSHOT_LASTGOOD_FILE ASC_STORAGE_FOLDER "\\UniverseSnapshot.lastgood.txt"
#define ASC_STORAGE_FORMAT_VERSION "ASC_UNIVERSE_SNAPSHOT_V1"

string ASC_Storage_BoolToText(const bool value)
  {
   return value ? "1" : "0";
  }

bool ASC_Storage_TextToBool(const string value)
  {
   string normalized=value;
   StringTrimLeft(normalized);
   StringTrimRight(normalized);
   const string lowered=StringToLower(normalized);
   return (normalized=="1" || lowered=="true");
  }

string ASC_Storage_IntToText(const int value)
  {
   return IntegerToString(value);
  }

string ASC_Storage_DoubleToText(const double value)
  {
   return DoubleToString(value,8);
  }

string ASC_Storage_DateTimeToText(const datetime value)
  {
   return IntegerToString((int)value);
  }

int ASC_Storage_TextToInt(const string value)
  {
   string normalized=value;
   StringTrimLeft(normalized);
   StringTrimRight(normalized);
   return (int)StringToInteger(normalized);
  }

double ASC_Storage_TextToDouble(const string value)
  {
   string normalized=value;
   StringTrimLeft(normalized);
   StringTrimRight(normalized);
   return StringToDouble(normalized);
  }

datetime ASC_Storage_TextToDateTime(const string value)
  {
   string normalized=value;
   StringTrimLeft(normalized);
   StringTrimRight(normalized);
   return (datetime)StringToInteger(normalized);
  }

string ASC_Storage_EncodeValue(string value)
  {
   StringReplace(value,"\\","\\\\");
   StringReplace(value,"\r","\\r");
   StringReplace(value,"\n","\\n");
   StringReplace(value,"\t","\\t");
   return value;
  }

string ASC_Storage_DecodeValue(string value)
  {
   StringReplace(value,"\\r","\r");
   StringReplace(value,"\\n","\n");
   StringReplace(value,"\\t","\t");
   StringReplace(value,"\\\\","\\");
   return value;
  }

int ASC_Storage_FileFlags(const ASC_RuntimeConfig &config)
  {
   int flags=FILE_TXT|FILE_ANSI;
   if(config.UseCommonFiles)
      flags|=FILE_COMMON;
   return flags;
  }

bool ASC_Storage_EnsureFolder(const ASC_RuntimeConfig &config)
  {
   if(FolderCreate(ASC_STORAGE_FOLDER))
      return true;

   return true;
  }

bool ASC_Storage_FileExists(const ASC_RuntimeConfig &config,const string file_name)
  {
   return FileIsExist(file_name,ASC_Storage_FileFlags(config));
  }

bool ASC_Storage_WriteLine(const int handle,const string key,const string value)
  {
   return FileWriteString(handle,key+"="+ASC_Storage_EncodeValue(value)+"\r\n")>0;
  }

string ASC_Storage_SessionTruthToText(const ASC_SessionTruthStatus status)
  {
   return IntegerToString((int)status);
  }

ASC_SessionTruthStatus ASC_Storage_TextToSessionTruth(const string value)
  {
   string normalized=value;
   StringTrimLeft(normalized);
   StringTrimRight(normalized);
   const int parsed=(int)StringToInteger(normalized);
   if(parsed<(int)ASC_SESSION_UNKNOWN || parsed>(int)ASC_SESSION_STALE_FEED)
      return ASC_SESSION_UNKNOWN;

   return (ASC_SessionTruthStatus)parsed;
  }

void ASC_Storage_ResetRecord(ASC_SymbolRecord &record)
  {
   ZeroMemory(record);
   record.MarketTruth.SessionTruthStatus=ASC_SESSION_UNKNOWN;
  }

void ASC_Storage_AssignField(ASC_SymbolRecord &record,const string key,const string raw_value)
  {
   const string value=ASC_Storage_DecodeValue(raw_value);

   if(key=="Identity.RawSymbol")
      record.Identity.RawSymbol=value;
   else if(key=="Identity.NormalizedSymbol")
      record.Identity.NormalizedSymbol=value;
   else if(key=="Identity.CanonicalSymbol")
      record.Identity.CanonicalSymbol=value;
   else if(key=="Identity.AssetClass")
      record.Identity.AssetClass=value;
   else if(key=="Identity.PrimaryBucket")
      record.Identity.PrimaryBucket=value;
   else if(key=="Identity.Sector")
      record.Identity.Sector=value;
   else if(key=="Identity.Industry")
      record.Identity.Industry=value;
   else if(key=="Identity.Theme")
      record.Identity.Theme=value;
   else if(key=="Identity.ClassificationResolved")
      record.Identity.ClassificationResolved=ASC_Storage_TextToBool(value);
   else if(key=="Identity.ClassificationReason")
      record.Identity.ClassificationReason=value;
   else if(key=="MarketTruth.Exists")
      record.MarketTruth.Exists=ASC_Storage_TextToBool(value);
   else if(key=="MarketTruth.Selected")
      record.MarketTruth.Selected=ASC_Storage_TextToBool(value);
   else if(key=="MarketTruth.Visible")
      record.MarketTruth.Visible=ASC_Storage_TextToBool(value);
   else if(key=="MarketTruth.QuoteWindowOpen")
      record.MarketTruth.QuoteWindowOpen=ASC_Storage_TextToBool(value);
   else if(key=="MarketTruth.TradeWindowOpen")
      record.MarketTruth.TradeWindowOpen=ASC_Storage_TextToBool(value);
   else if(key=="MarketTruth.TradeAllowed")
      record.MarketTruth.TradeAllowed=ASC_Storage_TextToBool(value);
   else if(key=="MarketTruth.SessionTruthStatus")
      record.MarketTruth.SessionTruthStatus=ASC_Storage_TextToSessionTruth(value);
   else if(key=="MarketTruth.Layer1Eligible")
      record.MarketTruth.Layer1Eligible=ASC_Storage_TextToBool(value);
   else if(key=="MarketTruth.LastQuoteTime")
      record.MarketTruth.LastQuoteTime=ASC_Storage_TextToDateTime(value);
   else if(key=="MarketTruth.NextRecheckTime")
      record.MarketTruth.NextRecheckTime=ASC_Storage_TextToDateTime(value);
   else if(key=="MarketTruth.IneligibleReason")
      record.MarketTruth.IneligibleReason=value;
   else if(key=="ConditionsTruth.SpecsReadable")
      record.ConditionsTruth.SpecsReadable=ASC_Storage_TextToBool(value);
   else if(key=="ConditionsTruth.SpecsReason")
      record.ConditionsTruth.SpecsReason=value;
   else if(key=="ConditionsTruth.Digits")
      record.ConditionsTruth.Digits=ASC_Storage_TextToInt(value);
   else if(key=="ConditionsTruth.SpreadPoints")
      record.ConditionsTruth.SpreadPoints=ASC_Storage_TextToInt(value);
   else if(key=="ConditionsTruth.SpreadFloat")
      record.ConditionsTruth.SpreadFloat=ASC_Storage_TextToBool(value);
   else if(key=="ConditionsTruth.Point")
      record.ConditionsTruth.Point=ASC_Storage_TextToDouble(value);
   else if(key=="ConditionsTruth.TickSize")
      record.ConditionsTruth.TickSize=ASC_Storage_TextToDouble(value);
   else if(key=="ConditionsTruth.TickValue")
      record.ConditionsTruth.TickValue=ASC_Storage_TextToDouble(value);
   else if(key=="ConditionsTruth.ContractSize")
      record.ConditionsTruth.ContractSize=ASC_Storage_TextToDouble(value);
   else if(key=="ConditionsTruth.VolumeMin")
      record.ConditionsTruth.VolumeMin=ASC_Storage_TextToDouble(value);
   else if(key=="ConditionsTruth.VolumeMax")
      record.ConditionsTruth.VolumeMax=ASC_Storage_TextToDouble(value);
   else if(key=="ConditionsTruth.VolumeStep")
      record.ConditionsTruth.VolumeStep=ASC_Storage_TextToDouble(value);
  }

bool ASC_Storage_ParseSnapshotFile(const ASC_RuntimeConfig &config,const string file_name,ASC_SymbolRecord &records[],int &count)
  {
   count=0;
   ArrayResize(records,0);

   const int handle=FileOpen(file_name,ASC_Storage_FileFlags(config)|FILE_READ);
   if(handle==INVALID_HANDLE)
      return false;

   bool header_seen=false;
   bool inside_record=false;
   ASC_SymbolRecord current_record;
   ASC_Storage_ResetRecord(current_record);
   int declared_count=-1;

   while(!FileIsEnding(handle))
     {
      string line=FileReadString(handle);
      StringTrimLeft(line);
      StringTrimRight(line);

      if(line=="")
         continue;

      if(!header_seen)
        {
         header_seen=(line==ASC_STORAGE_FORMAT_VERSION);
         if(!header_seen)
           {
            FileClose(handle);
            ArrayResize(records,0);
            return false;
           }

         continue;
        }

      if(StringFind(line,"Count=")==0)
        {
         declared_count=ASC_Storage_TextToInt(StringSubstr(line,6));
         continue;
        }

      if(line=="[Record]")
        {
         if(inside_record)
           {
            FileClose(handle);
            ArrayResize(records,0);
            return false;
           }

         ASC_Storage_ResetRecord(current_record);
         inside_record=true;
         continue;
        }

      if(line=="[/Record]")
        {
         if(!inside_record || current_record.Identity.RawSymbol=="")
           {
            FileClose(handle);
            ArrayResize(records,0);
            return false;
           }

         const int next_index=ArraySize(records);
         ArrayResize(records,next_index+1);
         records[next_index]=current_record;
         inside_record=false;
         continue;
        }

      if(!inside_record)
         continue;

      const int separator=StringFind(line,"=");
      if(separator<=0)
         continue;

      const string key=StringSubstr(line,0,separator);
      const string value=StringSubstr(line,separator+1);
      ASC_Storage_AssignField(current_record,key,value);
     }

   FileClose(handle);

   if(inside_record || !header_seen)
     {
      ArrayResize(records,0);
      return false;
     }

   count=ArraySize(records);
   if(declared_count>=0 && declared_count!=count)
     {
      ArrayResize(records,0);
      count=0;
      return false;
     }

   return true;
  }

bool ASC_Storage_LoadPreferredSnapshot(const ASC_RuntimeConfig &config,const string primary_file,const string fallback_file,ASC_SymbolRecord &records[],int &count)
  {
   if(ASC_Storage_ParseSnapshotFile(config,primary_file,records,count))
      return true;

   if(fallback_file!="" && ASC_Storage_ParseSnapshotFile(config,fallback_file,records,count))
      return true;

   count=0;
   ArrayResize(records,0);
   return false;
  }

bool ASC_Storage_WriteSnapshotFile(const ASC_RuntimeConfig &config,const string file_name,const ASC_SymbolRecord &records[],const int count)
  {
   if(!ASC_Storage_EnsureFolder(config))
      return false;

   const int handle=FileOpen(file_name,ASC_Storage_FileFlags(config)|FILE_WRITE);
   if(handle==INVALID_HANDLE)
      return false;

   bool ok=true;
   ok=ok && FileWriteString(handle,ASC_STORAGE_FORMAT_VERSION+"\r\n")>0;
   ok=ok && FileWriteString(handle,"Count="+IntegerToString(count)+"\r\n")>0;

   for(int index=0; ok && index<count; ++index)
     {
      const ASC_SymbolRecord &record=records[index];
      ok=ok && FileWriteString(handle,"[Record]\r\n")>0;
      ok=ok && ASC_Storage_WriteLine(handle,"Identity.RawSymbol",record.Identity.RawSymbol);
      ok=ok && ASC_Storage_WriteLine(handle,"Identity.NormalizedSymbol",record.Identity.NormalizedSymbol);
      ok=ok && ASC_Storage_WriteLine(handle,"Identity.CanonicalSymbol",record.Identity.CanonicalSymbol);
      ok=ok && ASC_Storage_WriteLine(handle,"Identity.AssetClass",record.Identity.AssetClass);
      ok=ok && ASC_Storage_WriteLine(handle,"Identity.PrimaryBucket",record.Identity.PrimaryBucket);
      ok=ok && ASC_Storage_WriteLine(handle,"Identity.Sector",record.Identity.Sector);
      ok=ok && ASC_Storage_WriteLine(handle,"Identity.Industry",record.Identity.Industry);
      ok=ok && ASC_Storage_WriteLine(handle,"Identity.Theme",record.Identity.Theme);
      ok=ok && ASC_Storage_WriteLine(handle,"Identity.ClassificationResolved",ASC_Storage_BoolToText(record.Identity.ClassificationResolved));
      ok=ok && ASC_Storage_WriteLine(handle,"Identity.ClassificationReason",record.Identity.ClassificationReason);
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.Exists",ASC_Storage_BoolToText(record.MarketTruth.Exists));
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.Selected",ASC_Storage_BoolToText(record.MarketTruth.Selected));
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.Visible",ASC_Storage_BoolToText(record.MarketTruth.Visible));
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.QuoteWindowOpen",ASC_Storage_BoolToText(record.MarketTruth.QuoteWindowOpen));
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.TradeWindowOpen",ASC_Storage_BoolToText(record.MarketTruth.TradeWindowOpen));
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.TradeAllowed",ASC_Storage_BoolToText(record.MarketTruth.TradeAllowed));
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.SessionTruthStatus",ASC_Storage_SessionTruthToText(record.MarketTruth.SessionTruthStatus));
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.Layer1Eligible",ASC_Storage_BoolToText(record.MarketTruth.Layer1Eligible));
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.LastQuoteTime",ASC_Storage_DateTimeToText(record.MarketTruth.LastQuoteTime));
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.NextRecheckTime",ASC_Storage_DateTimeToText(record.MarketTruth.NextRecheckTime));
      ok=ok && ASC_Storage_WriteLine(handle,"MarketTruth.IneligibleReason",record.MarketTruth.IneligibleReason);
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.SpecsReadable",ASC_Storage_BoolToText(record.ConditionsTruth.SpecsReadable));
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.SpecsReason",record.ConditionsTruth.SpecsReason);
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.Digits",ASC_Storage_IntToText(record.ConditionsTruth.Digits));
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.SpreadPoints",ASC_Storage_IntToText(record.ConditionsTruth.SpreadPoints));
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.SpreadFloat",ASC_Storage_BoolToText(record.ConditionsTruth.SpreadFloat));
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.Point",ASC_Storage_DoubleToText(record.ConditionsTruth.Point));
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.TickSize",ASC_Storage_DoubleToText(record.ConditionsTruth.TickSize));
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.TickValue",ASC_Storage_DoubleToText(record.ConditionsTruth.TickValue));
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.ContractSize",ASC_Storage_DoubleToText(record.ConditionsTruth.ContractSize));
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.VolumeMin",ASC_Storage_DoubleToText(record.ConditionsTruth.VolumeMin));
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.VolumeMax",ASC_Storage_DoubleToText(record.ConditionsTruth.VolumeMax));
      ok=ok && ASC_Storage_WriteLine(handle,"ConditionsTruth.VolumeStep",ASC_Storage_DoubleToText(record.ConditionsTruth.VolumeStep));
      ok=ok && FileWriteString(handle,"[/Record]\r\n")>0;
     }

   FileFlush(handle);
   FileClose(handle);

   if(!ok)
      FileDelete(file_name,ASC_Storage_FileFlags(config));

   return ok;
  }

bool ASC_Storage_LoadUniverseSnapshot(const ASC_RuntimeConfig &config, ASC_SymbolRecord &records[], int &count)
  {
   return ASC_Storage_LoadPreferredSnapshot(config,
                                            ASC_STORAGE_SNAPSHOT_FILE,
                                            ASC_STORAGE_SNAPSHOT_LASTGOOD_FILE,
                                            records,
                                            count);
  }

bool ASC_Storage_SaveUniverseSnapshot(const ASC_RuntimeConfig &config, const ASC_SymbolRecord &records[], const int count)
  {
   if(count<0)
      return false;

   if(count==0 && ASC_Storage_FileExists(config,ASC_STORAGE_SNAPSHOT_FILE))
      return false;

   if(!ASC_Storage_WriteSnapshotFile(config,ASC_STORAGE_SNAPSHOT_TEMP_FILE,records,count))
      return false;

   ASC_SymbolRecord verification_records[];
   int verification_count=0;
   if(!ASC_Storage_ParseSnapshotFile(config,ASC_STORAGE_SNAPSHOT_TEMP_FILE,verification_records,verification_count) || verification_count!=count)
     {
      FileDelete(ASC_STORAGE_SNAPSHOT_TEMP_FILE,ASC_Storage_FileFlags(config));
      return false;
     }

   if(ASC_Storage_FileExists(config,ASC_STORAGE_SNAPSHOT_LASTGOOD_FILE))
      FileDelete(ASC_STORAGE_SNAPSHOT_LASTGOOD_FILE,ASC_Storage_FileFlags(config));

   if(ASC_Storage_FileExists(config,ASC_STORAGE_SNAPSHOT_FILE))
     {
      if(!FileCopy(ASC_STORAGE_SNAPSHOT_FILE,
                   config.UseCommonFiles ? FILE_COMMON : 0,
                   ASC_STORAGE_SNAPSHOT_LASTGOOD_FILE,
                   (config.UseCommonFiles ? FILE_COMMON : 0)|FILE_REWRITE))
        {
         FileDelete(ASC_STORAGE_SNAPSHOT_TEMP_FILE,ASC_Storage_FileFlags(config));
         return false;
        }
     }

   if(ASC_Storage_FileExists(config,ASC_STORAGE_SNAPSHOT_FILE))
      FileDelete(ASC_STORAGE_SNAPSHOT_FILE,ASC_Storage_FileFlags(config));

   if(!FileCopy(ASC_STORAGE_SNAPSHOT_TEMP_FILE,
                config.UseCommonFiles ? FILE_COMMON : 0,
                ASC_STORAGE_SNAPSHOT_FILE,
                (config.UseCommonFiles ? FILE_COMMON : 0)|FILE_REWRITE))
     {
      FileDelete(ASC_STORAGE_SNAPSHOT_TEMP_FILE,ASC_Storage_FileFlags(config));
      return false;
     }

   FileDelete(ASC_STORAGE_SNAPSHOT_TEMP_FILE,ASC_Storage_FileFlags(config));
   return true;
  }

#endif
