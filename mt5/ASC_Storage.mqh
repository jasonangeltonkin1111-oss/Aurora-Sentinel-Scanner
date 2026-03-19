#ifndef ASC_STORAGE_MQH
#define ASC_STORAGE_MQH

#include "ASC_Common.mqh"

#define ASC_STORAGE_SNAPSHOT_FILE_NAME "AuroraSentinelCore\\UniverseSnapshot.txt"
#define ASC_STORAGE_SNAPSHOT_TEMP_FILE_NAME "AuroraSentinelCore\\UniverseSnapshot.tmp"
#define ASC_STORAGE_SNAPSHOT_BACKUP_FILE_NAME "AuroraSentinelCore\\UniverseSnapshot.bak"
#define ASC_STORAGE_SNAPSHOT_HEADER "ASC_UNIVERSE_SNAPSHOT_V4"
#define ASC_STORAGE_SNAPSHOT_HEADER_V3 "ASC_UNIVERSE_SNAPSHOT_V3"
#define ASC_STORAGE_SNAPSHOT_HEADER_V2 "ASC_UNIVERSE_SNAPSHOT_V2"
#define ASC_STORAGE_SNAPSHOT_HEADER_V1 "ASC_UNIVERSE_SNAPSHOT_V1"
#define ASC_STORAGE_SNAPSHOT_HEADER_V3 "ASC_UNIVERSE_SNAPSHOT_V3"
#define ASC_STORAGE_RECORD_FIELD_COUNT_V1 33
#define ASC_STORAGE_RECORD_FIELD_COUNT_V2 43
#define ASC_STORAGE_RECORD_FIELD_COUNT_V3 138
#define ASC_STORAGE_RECORD_FIELD_COUNT_V4 147
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
   return(value ? "1" : "0");
  }

bool ASC_Storage_ParseBool(const string value)
  {
   return(StringToInteger(value) != 0);
  }

void ASC_Storage_ResetRecord(ASC_SymbolRecord &record)
  {
   ASC_Record_Reset(record);
  }

void ASC_Storage_PushString(string &fields[],int &cursor,const string value)
  {
   fields[cursor++] = ASC_Storage_EscapeField(value);
  }

void ASC_Storage_PushBool(string &fields[],int &cursor,const bool value)
  {
   fields[cursor++] = ASC_Storage_FormatBool(value);
  }

void ASC_Storage_PushInt(string &fields[],int &cursor,const int value)
  {
   fields[cursor++] = IntegerToString(value);
  }

void ASC_Storage_PushDatetime(string &fields[],int &cursor,const datetime value)
  {
   fields[cursor++] = IntegerToString((int)value);
  }

void ASC_Storage_PushDouble(string &fields[],int &cursor,const double value)
  {
   fields[cursor++] = DoubleToString(value,16);
  }

bool ASC_Storage_PullString(const string &fields[],const int count,int &cursor,string &value)
  {
   if(cursor >= count)
      return(false);
   value = ASC_Storage_UnescapeField(fields[cursor++]);
   return(true);
  }

bool ASC_Storage_PullBool(const string &fields[],const int count,int &cursor,bool &value)
  {
   if(cursor >= count)
      return(false);
   value = ASC_Storage_ParseBool(fields[cursor++]);
   return(true);
  }

bool ASC_Storage_PullInt(const string &fields[],const int count,int &cursor,int &value)
  {
   if(cursor >= count)
      return(false);
   value = (int)StringToInteger(fields[cursor++]);
   return(true);
  }

bool ASC_Storage_PullDatetime(const string &fields[],const int count,int &cursor,datetime &value)
  {
   if(cursor >= count)
      return(false);
   value = (datetime)StringToInteger(fields[cursor++]);
   return(true);
  }

bool ASC_Storage_PullDouble(const string &fields[],const int count,int &cursor,double &value)
  {
   if(cursor >= count)
      return(false);
   value = StringToDouble(fields[cursor++]);
   return(true);
  }

void ASC_Storage_FormatIdentityFields(const ASC_SymbolRecord &record,string &fields[],int &cursor)
  {
   ASC_Storage_PushString(fields,cursor,record.Identity.RawSymbol);
   ASC_Storage_PushString(fields,cursor,record.Identity.NormalizedSymbol);
   ASC_Storage_PushString(fields,cursor,record.Identity.CanonicalSymbol);
   ASC_Storage_PushString(fields,cursor,record.Identity.DisplayName);
   ASC_Storage_PushString(fields,cursor,record.Identity.BrokerPath);
   ASC_Storage_PushString(fields,cursor,record.Identity.BrokerExchange);
   ASC_Storage_PushString(fields,cursor,record.Identity.BrokerCountry);
   ASC_Storage_PushString(fields,cursor,record.Identity.AssetClass);
   ASC_Storage_PushString(fields,cursor,record.Identity.PrimaryBucket);
   ASC_Storage_PushString(fields,cursor,record.Identity.Sector);
   ASC_Storage_PushString(fields,cursor,record.Identity.Industry);
   ASC_Storage_PushString(fields,cursor,record.Identity.Theme);
   ASC_Storage_PushBool(fields,cursor,record.Identity.ClassificationResolved);
   ASC_Storage_PushString(fields,cursor,record.Identity.ClassificationReason);
  }

void ASC_Storage_FormatMarketFields(const ASC_SymbolRecord &record,string &fields[],int &cursor)
  {
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.Exists);
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.Selected);
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.Visible);
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.QuoteWindowOpen);
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.TradeWindowOpen);
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.TradeAllowed);
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.HasUsableQuote);
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.QuoteFresh);
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.QuoteScheduleReadable);
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.TradeScheduleReadable);
   ASC_Storage_PushInt(fields,cursor,(int)record.MarketTruth.SessionTruthStatus);
   ASC_Storage_PushBool(fields,cursor,record.MarketTruth.Layer1Eligible);
   ASC_Storage_PushDatetime(fields,cursor,record.MarketTruth.LastQuoteTime);
   ASC_Storage_PushDatetime(fields,cursor,record.MarketTruth.NextRecheckTime);
   ASC_Storage_PushInt(fields,cursor,record.MarketTruth.QuoteAgeSeconds);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.QuoteFreshnessStatus);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.QuoteScheduleSunday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.QuoteScheduleMonday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.QuoteScheduleTuesday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.QuoteScheduleWednesday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.QuoteScheduleThursday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.QuoteScheduleFriday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.QuoteScheduleSaturday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.TradeScheduleSunday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.TradeScheduleMonday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.TradeScheduleTuesday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.TradeScheduleWednesday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.TradeScheduleThursday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.TradeScheduleFriday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.TradeScheduleSaturday);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.SessionReadStatus);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.SessionReadReason);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.SessionConsistencyReason);
   ASC_Storage_PushString(fields,cursor,record.MarketTruth.IneligibleReason);
  }

void ASC_Storage_FormatConditionsFields(const ASC_SymbolRecord &record,string &fields[],int &cursor)
  {
   ASC_ConditionsTruth t = record.ConditionsTruth;
   ASC_Storage_PushBool(fields,cursor,t.SpecsReadable);
   ASC_Storage_PushString(fields,cursor,t.SpecsReason);
   ASC_Storage_PushString(fields,cursor,t.SpecIntegrityStatus);
   ASC_Storage_PushString(fields,cursor,t.EconomicsTrust);
   ASC_Storage_PushString(fields,cursor,t.NormalizationStatus);
   ASC_Storage_PushString(fields,cursor,t.TruthCoverageStatus);
   ASC_Storage_PushBool(fields,cursor,t.DigitsReadable);
   ASC_Storage_PushInt(fields,cursor,t.Digits);
   ASC_Storage_PushBool(fields,cursor,t.SpreadPointsReadable);
   ASC_Storage_PushInt(fields,cursor,t.SpreadPoints);
   ASC_Storage_PushBool(fields,cursor,t.SpreadFloatReadable);
   ASC_Storage_PushBool(fields,cursor,t.SpreadFloat);
   ASC_Storage_PushBool(fields,cursor,t.StopsLevelReadable);
   ASC_Storage_PushInt(fields,cursor,t.StopsLevel);
   ASC_Storage_PushBool(fields,cursor,t.FreezeLevelReadable);
   ASC_Storage_PushInt(fields,cursor,t.FreezeLevel);
   ASC_Storage_PushBool(fields,cursor,t.PointReadable);
   ASC_Storage_PushDouble(fields,cursor,t.Point);
   ASC_Storage_PushBool(fields,cursor,t.TickSizeReadable);
   ASC_Storage_PushDouble(fields,cursor,t.TickSize);
   ASC_Storage_PushBool(fields,cursor,t.TickValueReadable);
   ASC_Storage_PushDouble(fields,cursor,t.TickValue);
   ASC_Storage_PushBool(fields,cursor,t.TickValueRawReadable);
   ASC_Storage_PushDouble(fields,cursor,t.TickValueRaw);
   ASC_Storage_PushBool(fields,cursor,t.TickValueDerivedReadable);
   ASC_Storage_PushDouble(fields,cursor,t.TickValueDerived);
   ASC_Storage_PushBool(fields,cursor,t.TickValueValidatedReadable);
   ASC_Storage_PushDouble(fields,cursor,t.TickValueValidated);
   ASC_Storage_PushBool(fields,cursor,t.TickValueProfitReadable);
   ASC_Storage_PushDouble(fields,cursor,t.TickValueProfit);
   ASC_Storage_PushBool(fields,cursor,t.TickValueLossReadable);
   ASC_Storage_PushDouble(fields,cursor,t.TickValueLoss);
   ASC_Storage_PushString(fields,cursor,t.EconomicsMismatchFlags);
   ASC_Storage_PushBool(fields,cursor,t.EconomicsAuthoritative);
   ASC_Storage_PushBool(fields,cursor,t.EconomicsPreservedFromPrior);
   ASC_Storage_PushBool(fields,cursor,t.ContractSizeReadable);
   ASC_Storage_PushDouble(fields,cursor,t.ContractSize);
   ASC_Storage_PushBool(fields,cursor,t.VolumeMinReadable);
   ASC_Storage_PushDouble(fields,cursor,t.VolumeMin);
   ASC_Storage_PushBool(fields,cursor,t.VolumeMaxReadable);
   ASC_Storage_PushDouble(fields,cursor,t.VolumeMax);
   ASC_Storage_PushBool(fields,cursor,t.VolumeStepReadable);
   ASC_Storage_PushDouble(fields,cursor,t.VolumeStep);
   ASC_Storage_PushBool(fields,cursor,t.VolumeLimitReadable);
   ASC_Storage_PushDouble(fields,cursor,t.VolumeLimit);
   ASC_Storage_PushBool(fields,cursor,t.MarginCurrencyReadable);
   ASC_Storage_PushString(fields,cursor,t.MarginCurrency);
   ASC_Storage_PushBool(fields,cursor,t.ProfitCurrencyReadable);
   ASC_Storage_PushString(fields,cursor,t.ProfitCurrency);
   ASC_Storage_PushBool(fields,cursor,t.BaseCurrencyReadable);
   ASC_Storage_PushString(fields,cursor,t.BaseCurrency);
   ASC_Storage_PushBool(fields,cursor,t.CalcModeReadable);
   ASC_Storage_PushInt(fields,cursor,t.CalcMode);
   ASC_Storage_PushBool(fields,cursor,t.ChartModeReadable);
   ASC_Storage_PushInt(fields,cursor,t.ChartMode);
   ASC_Storage_PushBool(fields,cursor,t.TradeModeReadable);
   ASC_Storage_PushInt(fields,cursor,t.TradeMode);
   ASC_Storage_PushBool(fields,cursor,t.ExecutionModeReadable);
   ASC_Storage_PushInt(fields,cursor,t.ExecutionMode);
   ASC_Storage_PushBool(fields,cursor,t.GtcModeReadable);
   ASC_Storage_PushInt(fields,cursor,t.GtcMode);
   ASC_Storage_PushBool(fields,cursor,t.FillingModeReadable);
   ASC_Storage_PushInt(fields,cursor,t.FillingMode);
   ASC_Storage_PushBool(fields,cursor,t.ExpirationModeReadable);
   ASC_Storage_PushInt(fields,cursor,t.ExpirationMode);
   ASC_Storage_PushBool(fields,cursor,t.OrderModeReadable);
   ASC_Storage_PushInt(fields,cursor,t.OrderMode);
   ASC_Storage_PushBool(fields,cursor,t.SwapModeReadable);
   ASC_Storage_PushInt(fields,cursor,t.SwapMode);
   ASC_Storage_PushBool(fields,cursor,t.SwapLongReadable);
   ASC_Storage_PushDouble(fields,cursor,t.SwapLong);
   ASC_Storage_PushBool(fields,cursor,t.SwapShortReadable);
   ASC_Storage_PushDouble(fields,cursor,t.SwapShort);
   ASC_Storage_PushBool(fields,cursor,t.SwapSundayReadable);
   ASC_Storage_PushDouble(fields,cursor,t.SwapSunday);
   ASC_Storage_PushBool(fields,cursor,t.SwapMondayReadable);
   ASC_Storage_PushDouble(fields,cursor,t.SwapMonday);
   ASC_Storage_PushBool(fields,cursor,t.SwapTuesdayReadable);
   ASC_Storage_PushDouble(fields,cursor,t.SwapTuesday);
   ASC_Storage_PushBool(fields,cursor,t.SwapWednesdayReadable);
   ASC_Storage_PushDouble(fields,cursor,t.SwapWednesday);
   ASC_Storage_PushBool(fields,cursor,t.SwapThursdayReadable);
   ASC_Storage_PushDouble(fields,cursor,t.SwapThursday);
   ASC_Storage_PushBool(fields,cursor,t.SwapFridayReadable);
   ASC_Storage_PushDouble(fields,cursor,t.SwapFriday);
   ASC_Storage_PushBool(fields,cursor,t.SwapSaturdayReadable);
   ASC_Storage_PushDouble(fields,cursor,t.SwapSaturday);
   ASC_Storage_PushBool(fields,cursor,t.MarginInitialReadable);
   ASC_Storage_PushDouble(fields,cursor,t.MarginInitial);
   ASC_Storage_PushBool(fields,cursor,t.MarginMaintenanceReadable);
   ASC_Storage_PushDouble(fields,cursor,t.MarginMaintenance);
   ASC_Storage_PushBool(fields,cursor,t.MarginHedgedReadable);
   ASC_Storage_PushDouble(fields,cursor,t.MarginHedged);
   ASC_Storage_PushBool(fields,cursor,t.MarginRateBuyReadable);
   ASC_Storage_PushDouble(fields,cursor,t.MarginRateBuyInitial);
   ASC_Storage_PushDouble(fields,cursor,t.MarginRateBuyMaintenance);
   ASC_Storage_PushBool(fields,cursor,t.MarginRateSellReadable);
   ASC_Storage_PushDouble(fields,cursor,t.MarginRateSellInitial);
   ASC_Storage_PushDouble(fields,cursor,t.MarginRateSellMaintenance);
  }

bool ASC_Storage_ParseV4Record(const string &fields[],const int count,ASC_SymbolRecord &record)
  {
   int cursor = 0;
   ASC_Storage_ResetRecord(record);

   ASC_Storage_PullString(fields,count,cursor,record.Identity.RawSymbol);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.NormalizedSymbol);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.CanonicalSymbol);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.DisplayName);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.BrokerPath);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.BrokerExchange);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.BrokerCountry);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.AssetClass);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.PrimaryBucket);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.Sector);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.Industry);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.Theme);
   ASC_Storage_PullBool(fields,count,cursor,record.Identity.ClassificationResolved);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.ClassificationReason);

   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.Exists);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.Selected);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.Visible);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.QuoteWindowOpen);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.TradeWindowOpen);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.TradeAllowed);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.HasUsableQuote);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.QuoteFresh);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.QuoteScheduleReadable);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.TradeScheduleReadable);
   int session_status = 0;
   ASC_Storage_PullInt(fields,count,cursor,session_status);
   record.MarketTruth.SessionTruthStatus = (ASC_SessionTruthStatus)session_status;
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.Layer1Eligible);
   ASC_Storage_PullDatetime(fields,count,cursor,record.MarketTruth.LastQuoteTime);
   ASC_Storage_PullDatetime(fields,count,cursor,record.MarketTruth.NextRecheckTime);
   ASC_Storage_PullInt(fields,count,cursor,record.MarketTruth.QuoteAgeSeconds);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteFreshnessStatus);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleSunday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleMonday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleTuesday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleWednesday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleThursday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleFriday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleSaturday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleSunday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleMonday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleTuesday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleWednesday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleThursday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleFriday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleSaturday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.SessionReadStatus);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.SessionReadReason);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.SessionConsistencyReason);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.IneligibleReason);

   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SpecsReadable);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.SpecsReason);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.SpecIntegrityStatus);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.EconomicsTrust);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.NormalizationStatus);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.TruthCoverageStatus);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.DigitsReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.Digits);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SpreadPointsReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.SpreadPoints);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SpreadFloatReadable);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SpreadFloat);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.StopsLevelReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.StopsLevel);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.FreezeLevelReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.FreezeLevel);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.PointReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.Point);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickSizeReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickSize);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickValueReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickValue);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickValueRawReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickValueRaw);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickValueDerivedReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickValueDerived);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickValueValidatedReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickValueValidated);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickValueProfitReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickValueProfit);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickValueLossReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickValueLoss);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.EconomicsMismatchFlags);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.EconomicsAuthoritative);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.EconomicsPreservedFromPrior);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.ContractSizeReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.ContractSize);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.VolumeMinReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.VolumeMin);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.VolumeMaxReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.VolumeMax);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.VolumeStepReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.VolumeStep);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.VolumeLimitReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.VolumeLimit);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginCurrencyReadable);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.MarginCurrency);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.ProfitCurrencyReadable);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.ProfitCurrency);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.BaseCurrencyReadable);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.BaseCurrency);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.CalcModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.CalcMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.ChartModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.ChartMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TradeModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.TradeMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.ExecutionModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.ExecutionMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.GtcModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.GtcMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.FillingModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.FillingMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.ExpirationModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.ExpirationMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.OrderModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.OrderMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.SwapMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapLongReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapLong);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapShortReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapShort);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapSundayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapSunday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapMondayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapMonday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapTuesdayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapTuesday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapWednesdayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapWednesday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapThursdayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapThursday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapFridayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapFriday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapSaturdayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapSaturday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginInitialReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginInitial);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginMaintenanceReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginMaintenance);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginHedgedReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginHedged);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginRateBuyReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginRateBuyInitial);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginRateBuyMaintenance);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginRateSellReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginRateSellInitial);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginRateSellMaintenance);

   return(cursor == count);
  }



bool ASC_Storage_ParseV3Record(const string &fields[],const int count,ASC_SymbolRecord &record)
  {
   int cursor = 0;
   ASC_Storage_ResetRecord(record);

   ASC_Storage_PullString(fields,count,cursor,record.Identity.RawSymbol);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.NormalizedSymbol);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.CanonicalSymbol);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.DisplayName);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.BrokerPath);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.BrokerExchange);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.BrokerCountry);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.AssetClass);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.PrimaryBucket);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.Sector);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.Industry);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.Theme);
   ASC_Storage_PullBool(fields,count,cursor,record.Identity.ClassificationResolved);
   ASC_Storage_PullString(fields,count,cursor,record.Identity.ClassificationReason);

   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.Exists);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.Selected);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.Visible);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.QuoteWindowOpen);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.TradeWindowOpen);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.TradeAllowed);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.HasUsableQuote);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.QuoteFresh);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.QuoteScheduleReadable);
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.TradeScheduleReadable);
   int session_status = 0;
   ASC_Storage_PullInt(fields,count,cursor,session_status);
   record.MarketTruth.SessionTruthStatus = (ASC_SessionTruthStatus)session_status;
   ASC_Storage_PullBool(fields,count,cursor,record.MarketTruth.Layer1Eligible);
   ASC_Storage_PullDatetime(fields,count,cursor,record.MarketTruth.LastQuoteTime);
   ASC_Storage_PullDatetime(fields,count,cursor,record.MarketTruth.NextRecheckTime);
   ASC_Storage_PullInt(fields,count,cursor,record.MarketTruth.QuoteAgeSeconds);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteFreshnessStatus);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleSunday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleMonday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleTuesday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleWednesday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleThursday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleFriday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.QuoteScheduleSaturday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleSunday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleMonday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleTuesday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleWednesday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleThursday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleFriday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.TradeScheduleSaturday);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.SessionReadStatus);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.SessionReadReason);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.SessionConsistencyReason);
   ASC_Storage_PullString(fields,count,cursor,record.MarketTruth.IneligibleReason);

   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SpecsReadable);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.SpecsReason);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.SpecIntegrityStatus);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.EconomicsTrust);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.NormalizationStatus);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.TruthCoverageStatus);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.DigitsReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.Digits);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SpreadPointsReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.SpreadPoints);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SpreadFloatReadable);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SpreadFloat);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.StopsLevelReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.StopsLevel);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.FreezeLevelReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.FreezeLevel);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.PointReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.Point);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickSizeReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickSize);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickValueReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickValue);
   record.ConditionsTruth.TickValueRawReadable = record.ConditionsTruth.TickValueReadable;
   record.ConditionsTruth.TickValueRaw = record.ConditionsTruth.TickValue;
   record.ConditionsTruth.TickValueDerivedReadable = false;
   record.ConditionsTruth.TickValueDerived = -1.0;
   record.ConditionsTruth.TickValueValidatedReadable = false;
   record.ConditionsTruth.TickValueValidated = -1.0;
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickValueProfitReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickValueProfit);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TickValueLossReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.TickValueLoss);
   record.ConditionsTruth.EconomicsMismatchFlags = "";
   record.ConditionsTruth.EconomicsAuthoritative = false;
   record.ConditionsTruth.EconomicsPreservedFromPrior = false;
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.ContractSizeReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.ContractSize);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.VolumeMinReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.VolumeMin);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.VolumeMaxReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.VolumeMax);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.VolumeStepReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.VolumeStep);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.VolumeLimitReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.VolumeLimit);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginCurrencyReadable);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.MarginCurrency);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.ProfitCurrencyReadable);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.ProfitCurrency);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.BaseCurrencyReadable);
   ASC_Storage_PullString(fields,count,cursor,record.ConditionsTruth.BaseCurrency);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.CalcModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.CalcMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.ChartModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.ChartMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.TradeModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.TradeMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.ExecutionModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.ExecutionMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.GtcModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.GtcMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.FillingModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.FillingMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.ExpirationModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.ExpirationMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.OrderModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.OrderMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapModeReadable);
   ASC_Storage_PullInt(fields,count,cursor,record.ConditionsTruth.SwapMode);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapLongReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapLong);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapShortReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapShort);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapSundayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapSunday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapMondayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapMonday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapTuesdayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapTuesday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapWednesdayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapWednesday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapThursdayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapThursday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapFridayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapFriday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.SwapSaturdayReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.SwapSaturday);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginInitialReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginInitial);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginMaintenanceReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginMaintenance);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginHedgedReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginHedged);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginRateBuyReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginRateBuyInitial);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginRateBuyMaintenance);
   ASC_Storage_PullBool(fields,count,cursor,record.ConditionsTruth.MarginRateSellReadable);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginRateSellInitial);
   ASC_Storage_PullDouble(fields,count,cursor,record.ConditionsTruth.MarginRateSellMaintenance);

   if(count >= ASC_STORAGE_RECORD_FIELD_COUNT_V4)
     {
      ASC_Storage_PullString(fields,count,cursor,record.RecordHydration.HydrationState);
      ASC_Storage_PullString(fields,count,cursor,record.RecordHydration.SnapshotAuthority);
      ASC_Storage_PullBool(fields,count,cursor,record.RecordHydration.PublishableTruth);
      ASC_RecordNormalizeHydration(record.RecordHydration);
     }
   else
     {
      ASC_RecordSetHydration(record.RecordHydration,ASC_RECORD_CURRENT_PASS_READY,ASC_RECORD_AUTHORITY_SNAPSHOT_V3,ASC_RECORD_PUBLISH_READY);
     }

   record.ConditionsTruth.SpecIntegrityStatus = ASC_RecordNormalizeIntegrityState(record.ConditionsTruth.SpecIntegrityStatus);
   ASC_RecordNormalizeHydration(record.RecordHydration);
   return(cursor == count);
  }

bool ASC_Storage_ParseLegacyRecord(const string &fields[],const int count,ASC_SymbolRecord &record)
  {
   ASC_Storage_ResetRecord(record);

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
   if(StringLen(record.Identity.DisplayName) == 0)
      record.Identity.DisplayName = record.Identity.RawSymbol;

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
   record.MarketTruth.SessionConsistencyReason = record.MarketTruth.IneligibleReason;
   record.MarketTruth.SessionReadReason = "legacy snapshot record";
   record.MarketTruth.SessionReadStatus = "LEGACY";
   record.MarketTruth.QuoteFreshnessStatus = "UNKNOWN";

   record.ConditionsTruth.SpecsReadable = ASC_Storage_ParseBool(fields[21]);
   record.ConditionsTruth.SpecsReason = ASC_Storage_UnescapeField(fields[22]);
   record.ConditionsTruth.SpecIntegrityStatus = ASC_RecordIntegrityStateText(record.ConditionsTruth.SpecsReadable ? ASC_RECORD_INTEGRITY_SPEC_OK : ASC_RECORD_INTEGRITY_SPEC_UNREADABLE);
   record.ConditionsTruth.EconomicsTrust = (record.ConditionsTruth.SpecsReadable ? "PASS" : "UNREAD");
   record.ConditionsTruth.NormalizationStatus = (record.Identity.ClassificationResolved ? "NORMALIZATION_OK" : "NORMALIZATION_UNRESOLVED");
   record.ConditionsTruth.TruthCoverageStatus = "LEGACY";
   ASC_RecordSetHydration(record.RecordHydration,ASC_RECORD_LEGACY_RECOVERED,ASC_RECORD_AUTHORITY_LEGACY,ASC_RECORD_PUBLISH_BLOCKED);

   if(count == ASC_STORAGE_RECORD_FIELD_COUNT_V1)
     {
      record.ConditionsTruth.DigitsReadable = (StringToInteger(fields[23]) >= 0);
      record.ConditionsTruth.Digits = (int)StringToInteger(fields[23]);
      record.ConditionsTruth.SpreadPointsReadable = (StringToInteger(fields[24]) >= 0);
      record.ConditionsTruth.SpreadPoints = (int)StringToInteger(fields[24]);
      record.ConditionsTruth.SpreadFloatReadable = record.ConditionsTruth.SpecsReadable;
      record.ConditionsTruth.SpreadFloat = ASC_Storage_ParseBool(fields[25]);
      record.ConditionsTruth.PointReadable = (StringToDouble(fields[26]) >= 0.0);
      record.ConditionsTruth.Point = StringToDouble(fields[26]);
      record.ConditionsTruth.TickSizeReadable = (StringToDouble(fields[27]) >= 0.0);
      record.ConditionsTruth.TickSize = StringToDouble(fields[27]);
      record.ConditionsTruth.TickValueReadable = (StringToDouble(fields[28]) >= 0.0);
      record.ConditionsTruth.TickValue = StringToDouble(fields[28]);
      record.ConditionsTruth.ContractSizeReadable = (StringToDouble(fields[29]) >= 0.0);
      record.ConditionsTruth.ContractSize = StringToDouble(fields[29]);
      record.ConditionsTruth.VolumeMinReadable = (StringToDouble(fields[30]) >= 0.0);
      record.ConditionsTruth.VolumeMin = StringToDouble(fields[30]);
      record.ConditionsTruth.VolumeMaxReadable = (StringToDouble(fields[31]) >= 0.0);
      record.ConditionsTruth.VolumeMax = StringToDouble(fields[31]);
      record.ConditionsTruth.VolumeStepReadable = (StringToDouble(fields[32]) >= 0.0);
      record.ConditionsTruth.VolumeStep = StringToDouble(fields[32]);
      record.ConditionsTruth.SpecIntegrityStatus = ASC_RecordNormalizeIntegrityState(record.ConditionsTruth.SpecIntegrityStatus);
      ASC_RecordNormalizeHydration(record.RecordHydration);
      return(true);
     }

   record.ConditionsTruth.DigitsReadable = ASC_Storage_ParseBool(fields[23]);
   record.ConditionsTruth.Digits = (int)StringToInteger(fields[24]);
   record.ConditionsTruth.SpreadPointsReadable = ASC_Storage_ParseBool(fields[25]);
   record.ConditionsTruth.SpreadPoints = (int)StringToInteger(fields[26]);
   record.ConditionsTruth.SpreadFloatReadable = ASC_Storage_ParseBool(fields[27]);
   record.ConditionsTruth.SpreadFloat = ASC_Storage_ParseBool(fields[28]);
   record.ConditionsTruth.PointReadable = ASC_Storage_ParseBool(fields[29]);
   record.ConditionsTruth.Point = StringToDouble(fields[30]);
   record.ConditionsTruth.TickSizeReadable = ASC_Storage_ParseBool(fields[31]);
   record.ConditionsTruth.TickSize = StringToDouble(fields[32]);
   record.ConditionsTruth.TickValueReadable = ASC_Storage_ParseBool(fields[33]);
   record.ConditionsTruth.TickValue = StringToDouble(fields[34]);
   record.ConditionsTruth.ContractSizeReadable = ASC_Storage_ParseBool(fields[35]);
   record.ConditionsTruth.ContractSize = StringToDouble(fields[36]);
   record.ConditionsTruth.VolumeMinReadable = ASC_Storage_ParseBool(fields[37]);
   record.ConditionsTruth.VolumeMin = StringToDouble(fields[38]);
   record.ConditionsTruth.VolumeMaxReadable = ASC_Storage_ParseBool(fields[39]);
   record.ConditionsTruth.VolumeMax = StringToDouble(fields[40]);
   record.ConditionsTruth.VolumeStepReadable = ASC_Storage_ParseBool(fields[41]);
   record.ConditionsTruth.VolumeStep = StringToDouble(fields[42]);
   record.ConditionsTruth.SpecIntegrityStatus = ASC_RecordNormalizeIntegrityState(record.ConditionsTruth.SpecIntegrityStatus);
   ASC_RecordNormalizeHydration(record.RecordHydration);
   return(true);
  }

string ASC_Storage_FormatRecord(const ASC_SymbolRecord &record)
  {
   string fields[];
   ArrayResize(fields,ASC_STORAGE_RECORD_FIELD_COUNT_V4);
   int cursor = 0;
   ASC_Storage_FormatIdentityFields(record,fields,cursor);
   ASC_Storage_FormatMarketFields(record,fields,cursor);
   ASC_Storage_FormatConditionsFields(record,fields,cursor);
   ASC_Storage_PushString(fields,cursor,record.RecordHydration.HydrationState);
   ASC_Storage_PushString(fields,cursor,record.RecordHydration.SnapshotAuthority);
   ASC_Storage_PushBool(fields,cursor,record.RecordHydration.PublishableTruth);

   string line = "";
   for(int index = 0; index < cursor; ++index)
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
   if(count == ASC_STORAGE_RECORD_FIELD_COUNT_V4)
      return(ASC_Storage_ParseV4Record(fields,count,record));
   if(count == ASC_STORAGE_RECORD_FIELD_COUNT_V3)
      return(ASC_Storage_ParseV3Record(fields,count,record));
   if(count == ASC_STORAGE_RECORD_FIELD_COUNT_V2 || count == ASC_STORAGE_RECORD_FIELD_COUNT_V1)
      return(ASC_Storage_ParseLegacyRecord(fields,count,record));
   return(false);
  }

bool ASC_Storage_ParseSnapshotLines(const string &lines[],ASC_SymbolRecord &records[],int &count)
  {
   count = 0;
   ArrayResize(records,0);

   const int line_count = ArraySize(lines);
   if(line_count < 2)
      return(false);

   if(lines[0] != ASC_STORAGE_SNAPSHOT_HEADER &&
      lines[0] != ASC_STORAGE_SNAPSHOT_HEADER_V3 &&
      lines[0] != ASC_STORAGE_SNAPSHOT_HEADER_V2 &&
      lines[0] != ASC_STORAGE_SNAPSHOT_HEADER_V1)
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

   if(lines[0] != ASC_STORAGE_SNAPSHOT_HEADER &&
      lines[0] != ASC_STORAGE_SNAPSHOT_HEADER_V3 &&
      lines[0] != ASC_STORAGE_SNAPSHOT_HEADER_V2 &&
      lines[0] != ASC_STORAGE_SNAPSHOT_HEADER_V1)
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
