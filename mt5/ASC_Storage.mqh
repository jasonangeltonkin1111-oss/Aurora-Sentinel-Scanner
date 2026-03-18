#ifndef ASC_STORAGE_MQH
#define ASC_STORAGE_MQH

#include "ASC_Common.mqh"

#define ASC_STORAGE_SNAPSHOT_FILE_NAME "AuroraSentinelCore\\UniverseSnapshot.txt"
#define ASC_STORAGE_SNAPSHOT_TEMP_FILE_NAME "AuroraSentinelCore\\UniverseSnapshot.tmp"
#define ASC_STORAGE_SNAPSHOT_BACKUP_FILE_NAME "AuroraSentinelCore\\UniverseSnapshot.bak"
#define ASC_STORAGE_SNAPSHOT_HEADER "ASC_UNIVERSE_SNAPSHOT_V1"
#define ASC_STORAGE_RECORD_FIELD_COUNT 33
#define ASC_STORAGE_COUNT_UNKNOWN -1

string ASC_Storage_EscapeField(const string value)
  {
   string escaped = value;
   StringReplace(escaped,"\\","\\\\");
   StringReplace(escaped,"|","\\p");
   StringReplace(escaped,"\r","\\r");
   StringReplace(escaped,"\n","\\n");
   return(escaped);
  }

string ASC_Storage_UnescapeField(const string value)
  {
   string result = "";
   const int length = StringLen(value);

   for(int index = 0; index < length; ++index)
     {
      const string current = StringSubstr(value,index,1);
      if(current != "\\")
        {
         result += current;
         continue;
        }

      if(index + 1 >= length)
        {
         result += "\\";
         continue;
        }

      const string next = StringSubstr(value,index + 1,1);
      if(next == "\\")
         result += "\\";
      else if(next == "p")
         result += "|";
      else if(next == "r")
         result += "\r";
      else if(next == "n")
         result += "\n";
      else
        {
         result += "\\";
         result += next;
        }

      ++index;
     }

   return(result);
  }

int ASC_Storage_OpenFlags(const bool use_common_files)
  {
   int flags = FILE_TXT | FILE_ANSI;
   if(use_common_files)
      flags |= FILE_COMMON;
   return(flags);
  }

bool ASC_Storage_DeleteFile(const ASC_RuntimeConfig &config,const string file_name)
  {
   ResetLastError();
   return(FileDelete(file_name,config.UseCommonFiles ? FILE_COMMON : 0));
  }

bool ASC_Storage_ReadAllLines(const ASC_RuntimeConfig &config,const string file_name,string &lines[])
  {
   ArrayResize(lines,0);

   const int handle = FileOpen(file_name,ASC_Storage_OpenFlags(config.UseCommonFiles) | FILE_READ);
   if(handle == INVALID_HANDLE)
      return(false);

   while(!FileIsEnding(handle))
     {
      const int next_index = ArraySize(lines);
      ArrayResize(lines,next_index + 1);
      lines[next_index] = FileReadString(handle);
     }

   FileClose(handle);
   return(true);
  }

bool ASC_Storage_WriteAllLines(const ASC_RuntimeConfig &config,const string file_name,const string &lines[])
  {
   const int handle = FileOpen(file_name,ASC_Storage_OpenFlags(config.UseCommonFiles) | FILE_WRITE);
   if(handle == INVALID_HANDLE)
      return(false);

   const int line_count = ArraySize(lines);
   for(int index = 0; index < line_count; ++index)
      FileWrite(handle,lines[index]);

   FileClose(handle);
   return(true);
  }

string ASC_Storage_FormatBool(const bool value)
  {
   if(value)
      return("1");
   return("0");
  }

bool ASC_Storage_ParseBool(const string value)
  {
   return(StringToInteger(value) != 0);
  }

string ASC_Storage_FormatRecord(const ASC_SymbolRecord &record)
  {
   string fields[];
   ArrayResize(fields,ASC_STORAGE_RECORD_FIELD_COUNT);

   fields[0] = ASC_Storage_EscapeField(record.Identity.RawSymbol);
   fields[1] = ASC_Storage_EscapeField(record.Identity.NormalizedSymbol);
   fields[2] = ASC_Storage_EscapeField(record.Identity.CanonicalSymbol);
   fields[3] = ASC_Storage_EscapeField(record.Identity.AssetClass);
   fields[4] = ASC_Storage_EscapeField(record.Identity.PrimaryBucket);
   fields[5] = ASC_Storage_EscapeField(record.Identity.Sector);
   fields[6] = ASC_Storage_EscapeField(record.Identity.Industry);
   fields[7] = ASC_Storage_EscapeField(record.Identity.Theme);
   fields[8] = ASC_Storage_FormatBool(record.Identity.ClassificationResolved);
   fields[9] = ASC_Storage_EscapeField(record.Identity.ClassificationReason);

   fields[10] = ASC_Storage_FormatBool(record.MarketTruth.Exists);
   fields[11] = ASC_Storage_FormatBool(record.MarketTruth.Selected);
   fields[12] = ASC_Storage_FormatBool(record.MarketTruth.Visible);
   fields[13] = ASC_Storage_FormatBool(record.MarketTruth.QuoteWindowOpen);
   fields[14] = ASC_Storage_FormatBool(record.MarketTruth.TradeWindowOpen);
   fields[15] = ASC_Storage_FormatBool(record.MarketTruth.TradeAllowed);
   fields[16] = IntegerToString((int)record.MarketTruth.SessionTruthStatus);
   fields[17] = ASC_Storage_FormatBool(record.MarketTruth.Layer1Eligible);
   fields[18] = IntegerToString((int)record.MarketTruth.LastQuoteTime);
   fields[19] = IntegerToString((int)record.MarketTruth.NextRecheckTime);
   fields[20] = ASC_Storage_EscapeField(record.MarketTruth.IneligibleReason);

   fields[21] = ASC_Storage_FormatBool(record.ConditionsTruth.SpecsReadable);
   fields[22] = ASC_Storage_EscapeField(record.ConditionsTruth.SpecsReason);
   fields[23] = IntegerToString(record.ConditionsTruth.Digits);
   fields[24] = IntegerToString(record.ConditionsTruth.SpreadPoints);
   fields[25] = ASC_Storage_FormatBool(record.ConditionsTruth.SpreadFloat);
   fields[26] = DoubleToString(record.ConditionsTruth.Point,16);
   fields[27] = DoubleToString(record.ConditionsTruth.TickSize,16);
   fields[28] = DoubleToString(record.ConditionsTruth.TickValue,16);
   fields[29] = DoubleToString(record.ConditionsTruth.ContractSize,16);
   fields[30] = DoubleToString(record.ConditionsTruth.VolumeMin,16);
   fields[31] = DoubleToString(record.ConditionsTruth.VolumeMax,16);
   fields[32] = DoubleToString(record.ConditionsTruth.VolumeStep,16);

   string line = "";
   for(int index = 0; index < ASC_STORAGE_RECORD_FIELD_COUNT; ++index)
     {
      if(index > 0)
         line += "|";
      line += fields[index];
     }

   return(line);
  }

bool ASC_Storage_ParseRecordLine(const string line,ASC_SymbolRecord &record)
  {
   string fields[];
   const int count = StringSplit(line,'|',fields);
   if(count != ASC_STORAGE_RECORD_FIELD_COUNT)
      return(false);

   record.Identity.RawSymbol = ASC_Storage_UnescapeField(fields[0]);
   record.Identity.NormalizedSymbol = ASC_Storage_UnescapeField(fields[1]);
   record.Identity.CanonicalSymbol = ASC_Storage_UnescapeField(fields[2]);
   record.Identity.AssetClass = ASC_Storage_UnescapeField(fields[3]);
   record.Identity.PrimaryBucket = ASC_Storage_UnescapeField(fields[4]);
   record.Identity.Sector = ASC_Storage_UnescapeField(fields[5]);
   record.Identity.Industry = ASC_Storage_UnescapeField(fields[6]);
   record.Identity.Theme = ASC_Storage_UnescapeField(fields[7]);
   record.Identity.ClassificationResolved = ASC_Storage_ParseBool(fields[8]);
   record.Identity.ClassificationReason = ASC_Storage_UnescapeField(fields[9]);

   record.MarketTruth.Exists = ASC_Storage_ParseBool(fields[10]);
   record.MarketTruth.Selected = ASC_Storage_ParseBool(fields[11]);
   record.MarketTruth.Visible = ASC_Storage_ParseBool(fields[12]);
   record.MarketTruth.QuoteWindowOpen = ASC_Storage_ParseBool(fields[13]);
   record.MarketTruth.TradeWindowOpen = ASC_Storage_ParseBool(fields[14]);
   record.MarketTruth.TradeAllowed = ASC_Storage_ParseBool(fields[15]);
   record.MarketTruth.SessionTruthStatus = (ASC_SessionTruthStatus)StringToInteger(fields[16]);
   record.MarketTruth.Layer1Eligible = ASC_Storage_ParseBool(fields[17]);
   record.MarketTruth.LastQuoteTime = (datetime)StringToInteger(fields[18]);
   record.MarketTruth.NextRecheckTime = (datetime)StringToInteger(fields[19]);
   record.MarketTruth.IneligibleReason = ASC_Storage_UnescapeField(fields[20]);

   record.ConditionsTruth.SpecsReadable = ASC_Storage_ParseBool(fields[21]);
   record.ConditionsTruth.SpecsReason = ASC_Storage_UnescapeField(fields[22]);
   record.ConditionsTruth.Digits = (int)StringToInteger(fields[23]);
   record.ConditionsTruth.SpreadPoints = (int)StringToInteger(fields[24]);
   record.ConditionsTruth.SpreadFloat = ASC_Storage_ParseBool(fields[25]);
   record.ConditionsTruth.Point = StringToDouble(fields[26]);
   record.ConditionsTruth.TickSize = StringToDouble(fields[27]);
   record.ConditionsTruth.TickValue = StringToDouble(fields[28]);
   record.ConditionsTruth.ContractSize = StringToDouble(fields[29]);
   record.ConditionsTruth.VolumeMin = StringToDouble(fields[30]);
   record.ConditionsTruth.VolumeMax = StringToDouble(fields[31]);
   record.ConditionsTruth.VolumeStep = StringToDouble(fields[32]);

   return(true);
  }

bool ASC_Storage_ParseSnapshotLines(const string &lines[],ASC_SymbolRecord &records[],int &count)
  {
   count = 0;
   ArrayResize(records,0);

   const int line_count = ArraySize(lines);
   if(line_count < 2)
      return(false);

   if(lines[0] != ASC_STORAGE_SNAPSHOT_HEADER)
      return(false);

   const int expected_count = (int)StringToInteger(lines[1]);
   if(expected_count < 0 || line_count != expected_count + 2)
      return(false);

   ArrayResize(records,expected_count);
   for(int index = 0; index < expected_count; ++index)
     {
      if(!ASC_Storage_ParseRecordLine(lines[index + 2],records[index]))
        {
         ArrayResize(records,0);
         return(false);
        }
     }

   count = expected_count;
   return(true);
  }


int ASC_Storage_ReadSnapshotRecordCount(const string &lines[])
  {
   const int line_count = ArraySize(lines);
   if(line_count < 2)
      return(ASC_STORAGE_COUNT_UNKNOWN);

   if(lines[0] != ASC_STORAGE_SNAPSHOT_HEADER)
      return(ASC_STORAGE_COUNT_UNKNOWN);

   const int expected_count = (int)StringToInteger(lines[1]);
   if(expected_count < 0 || line_count != expected_count + 2)
      return(ASC_STORAGE_COUNT_UNKNOWN);

   return(expected_count);
  }

bool ASC_Storage_LoadSnapshotFromFile(const ASC_RuntimeConfig &config,const string file_name,ASC_SymbolRecord &records[],int &count)
  {
   string lines[];
   if(!ASC_Storage_ReadAllLines(config,file_name,lines))
      return(false);

   return(ASC_Storage_ParseSnapshotLines(lines,records,count));
  }

void ASC_Storage_CopyRecords(const ASC_SymbolRecord &source[],ASC_SymbolRecord &target[],const int count)
  {
   ArrayResize(target,count);
   for(int index = 0; index < count; ++index)
      target[index] = source[index];
  }

bool ASC_Storage_LoadUniverseSnapshot(const ASC_RuntimeConfig &config,ASC_SymbolRecord &records[],int &count)
  {
   ASC_SymbolRecord loaded_records[];
   int loaded_count = 0;

   if(ASC_Storage_LoadSnapshotFromFile(config,ASC_STORAGE_SNAPSHOT_FILE_NAME,loaded_records,loaded_count))
     {
      ASC_Storage_CopyRecords(loaded_records,records,loaded_count);
      count = loaded_count;
      return(true);
     }

   if(ASC_Storage_LoadSnapshotFromFile(config,ASC_STORAGE_SNAPSHOT_BACKUP_FILE_NAME,loaded_records,loaded_count))
     {
      ASC_Storage_CopyRecords(loaded_records,records,loaded_count);
      count = loaded_count;
      return(true);
     }

   count = 0;
   ArrayResize(records,0);
   return(false);
  }

bool ASC_Storage_SaveUniverseSnapshot(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count)
  {
   if(count < 0)
      return(false);

   string new_lines[];
   ArrayResize(new_lines,count + 2);
   new_lines[0] = ASC_STORAGE_SNAPSHOT_HEADER;
   new_lines[1] = IntegerToString(count);

   for(int index = 0; index < count; ++index)
      new_lines[index + 2] = ASC_Storage_FormatRecord(records[index]);

   ASC_SymbolRecord validation_records[];
   int validation_count = 0;
   if(!ASC_Storage_ParseSnapshotLines(new_lines,validation_records,validation_count) || validation_count != count)
      return(false);

   string prior_lines[];
   const bool prior_exists = ASC_Storage_ReadAllLines(config,ASC_STORAGE_SNAPSHOT_FILE_NAME,prior_lines);

   int largest_prior_count = ASC_STORAGE_COUNT_UNKNOWN;
   if(prior_exists)
      largest_prior_count = ASC_Storage_ReadSnapshotRecordCount(prior_lines);

   string backup_lines[];
   if(ASC_Storage_ReadAllLines(config,ASC_STORAGE_SNAPSHOT_BACKUP_FILE_NAME,backup_lines))
     {
      const int backup_count = ASC_Storage_ReadSnapshotRecordCount(backup_lines);
      if(backup_count > largest_prior_count)
         largest_prior_count = backup_count;
     }

   if(largest_prior_count != ASC_STORAGE_COUNT_UNKNOWN && count < largest_prior_count)
      return(false);

   if(!ASC_Storage_WriteAllLines(config,ASC_STORAGE_SNAPSHOT_TEMP_FILE_NAME,new_lines))
      return(false);

   string staged_lines[];
   if(!ASC_Storage_ReadAllLines(config,ASC_STORAGE_SNAPSHOT_TEMP_FILE_NAME,staged_lines))
     {
      ASC_Storage_DeleteFile(config,ASC_STORAGE_SNAPSHOT_TEMP_FILE_NAME);
      return(false);
     }

   if(!ASC_Storage_ParseSnapshotLines(staged_lines,validation_records,validation_count) || validation_count != count)
     {
      ASC_Storage_DeleteFile(config,ASC_STORAGE_SNAPSHOT_TEMP_FILE_NAME);
      return(false);
     }

   if(prior_exists)
      ASC_Storage_WriteAllLines(config,ASC_STORAGE_SNAPSHOT_BACKUP_FILE_NAME,prior_lines);

   if(ASC_Storage_WriteAllLines(config,ASC_STORAGE_SNAPSHOT_FILE_NAME,new_lines))
     {
      ASC_Storage_DeleteFile(config,ASC_STORAGE_SNAPSHOT_TEMP_FILE_NAME);
      return(true);
     }

   if(prior_exists)
      ASC_Storage_WriteAllLines(config,ASC_STORAGE_SNAPSHOT_FILE_NAME,prior_lines);

   ASC_Storage_DeleteFile(config,ASC_STORAGE_SNAPSHOT_TEMP_FILE_NAME);
   return(false);
  }

#endif
