#ifndef ASC_OUTPUT_MQH
#define ASC_OUTPUT_MQH

#include "ASC_Common.mqh"
#include "ASC_Storage.mqh"

#define ASC_OUTPUT_ROOT_PATH "AuroraSentinelCore\\"
#define ASC_OUTPUT_MIRROR_FILE_NAME ASC_OUTPUT_ROOT_PATH "UniverseSnapshotMirror.txt"
#define ASC_OUTPUT_REVIEW_QUEUE_SUFFIX ".ClassificationReviewQueue.txt"
#define ASC_OUTPUT_BROKER_FALLBACK "Broker"
#define ASC_OUTPUT_SUMMARY_HEADER "Aurora Sentinel Summary"
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
   return(value ? "YES" : "NO");
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
   return(StringLen(trimmed) > 0 && trimmed != "UNKNOWN");
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
      sanitized = ASC_OUTPUT_BROKER_FALLBACK;
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

string ASC_Output_ReviewQueueFileName(const string broker_name)
  {
   return(ASC_OUTPUT_ROOT_PATH + broker_name + ASC_OUTPUT_REVIEW_QUEUE_SUFFIX);
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

string ASC_Output_RecordTitle(const ASC_SymbolRecord &record)
  {
   const string symbol_name = ASC_Output_RecordDisplaySymbol(record);
   if(ASC_Output_IsMeaningfulValue(record.Identity.DisplayName) && record.Identity.DisplayName != symbol_name)
      return(symbol_name + ", " + record.Identity.DisplayName);
   return(symbol_name);
  }

string ASC_Output_RecordFileComponent(const ASC_SymbolRecord &record)
  {
   return(ASC_Output_SanitizePathComponent(ASC_Output_RecordDisplaySymbol(record),"Symbol"));
  }

string ASC_Output_SymbolFileName(const string broker_name,const ASC_SymbolRecord &record)
  {
   const string symbol_name = ASC_Output_RecordFileComponent(record);
   return(ASC_Output_SymbolDirectory(broker_name) + "\\" + symbol_name + ".txt");
  }

void ASC_Output_WriteStringField(const int handle,const string label,const string value)
  {
   FileWrite(handle,label + ": " + (StringLen(value) > 0 ? value : "UNKNOWN"));
  }

void ASC_Output_WriteIntegerField(const int handle,const string label,const int value,const bool readable)
  {
   FileWrite(handle,label + ": " + (readable ? IntegerToString(value) : "UNKNOWN"));
  }

void ASC_Output_WriteDoubleField(const int handle,const string label,const double value,const bool readable)
  {
   FileWrite(handle,label + ": " + (readable ? DoubleToString(value,16) : "UNKNOWN"));
  }

void ASC_Output_WriteSectionHeader(const int handle,const string title)
  {
   FileWrite(handle,title);
  }

string ASC_Output_SessionStatusText(const ASC_SessionTruthStatus status)
  {
   switch(status)
     {
      case ASC_SESSION_OPEN_TRADABLE: return("OPEN_TRADABLE");
      case ASC_SESSION_CLOSED_SESSION: return("CLOSED_SESSION");
      case ASC_SESSION_QUOTE_ONLY: return("QUOTE_ONLY");
      case ASC_SESSION_TRADE_DISABLED: return("TRADE_DISABLED");
      case ASC_SESSION_NO_QUOTE: return("NO_QUOTE");
      case ASC_SESSION_STALE_FEED: return("STALE_FEED");
      default: return("UNKNOWN");
     }
  }

string ASC_Output_TradeModeText(const int value)
  {
   switch(value)
     {
      case SYMBOL_TRADE_MODE_DISABLED: return("Disabled");
      case SYMBOL_TRADE_MODE_LONGONLY: return("Long only");
      case SYMBOL_TRADE_MODE_SHORTONLY: return("Short only");
      case SYMBOL_TRADE_MODE_CLOSEONLY: return("Close only");
      case SYMBOL_TRADE_MODE_FULL: return("Full access");
      default: return("UNKNOWN");
     }
  }

string ASC_Output_CalcModeText(const int value)
  {
   switch(value)
     {
      case SYMBOL_CALC_MODE_FOREX: return("Forex");
      case SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE: return("Forex no leverage");
      case SYMBOL_CALC_MODE_FUTURES: return("Futures");
      case SYMBOL_CALC_MODE_CFD: return("CFD");
      case SYMBOL_CALC_MODE_CFDINDEX: return("CFD Index");
      case SYMBOL_CALC_MODE_CFDLEVERAGE: return("CFD Leverage");
      case SYMBOL_CALC_MODE_EXCH_STOCKS: return("Exchange Stocks");
      case SYMBOL_CALC_MODE_EXCH_FUTURES: return("Exchange Futures");
      case SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS: return("Exchange Futures Forts");
      default: return("UNKNOWN");
     }
  }

string ASC_Output_ChartModeText(const int value)
  {
   switch(value)
     {
      case SYMBOL_CHART_MODE_BID: return("By bid price");
      case SYMBOL_CHART_MODE_LAST: return("By last price");
      default: return("UNKNOWN");
     }
  }

string ASC_Output_ExecutionModeText(const int value)
  {
   switch(value)
     {
      case SYMBOL_TRADE_EXECUTION_REQUEST: return("Request");
      case SYMBOL_TRADE_EXECUTION_INSTANT: return("Instant");
      case SYMBOL_TRADE_EXECUTION_MARKET: return("Market");
      case SYMBOL_TRADE_EXECUTION_EXCHANGE: return("Exchange");
      default: return("UNKNOWN");
     }
  }

string ASC_Output_GtcModeText(const int value)
  {
   switch(value)
     {
      case SYMBOL_ORDERS_GTC: return("Good till cancelled");
      case SYMBOL_ORDERS_DAILY: return("Daily");
#ifdef SYMBOL_ORDERS_DAILY_NO_STOPS
      case SYMBOL_ORDERS_DAILY_NO_STOPS: return("Daily no stops");
#endif
      default: return("UNKNOWN");
     }
  }

string ASC_Output_FillingModeText(const int value)
  {
   string text = "";
   if((value & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
      text = (StringLen(text) == 0 ? "Fill or Kill" : text + ", Fill or Kill");
   if((value & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC)
      text = (StringLen(text) == 0 ? "Immediate or Cancel" : text + ", Immediate or Cancel");
   if((value & SYMBOL_FILLING_BOC) == SYMBOL_FILLING_BOC)
      text = (StringLen(text) == 0 ? "Book or Cancel" : text + ", Book or Cancel");
   return(StringLen(text) > 0 ? text : "UNKNOWN");
  }

string ASC_Output_ExpirationModeText(const int value)
  {
   string text = "";
   if((value & SYMBOL_EXPIRATION_GTC) == SYMBOL_EXPIRATION_GTC)
      text = (StringLen(text) == 0 ? "GTC" : text + ", GTC");
   if((value & SYMBOL_EXPIRATION_DAY) == SYMBOL_EXPIRATION_DAY)
      text = (StringLen(text) == 0 ? "Day" : text + ", Day");
   if((value & SYMBOL_EXPIRATION_SPECIFIED) == SYMBOL_EXPIRATION_SPECIFIED)
      text = (StringLen(text) == 0 ? "Specified" : text + ", Specified");
   if((value & SYMBOL_EXPIRATION_SPECIFIED_DAY) == SYMBOL_EXPIRATION_SPECIFIED_DAY)
      text = (StringLen(text) == 0 ? "Specified day" : text + ", Specified day");
   return(StringLen(text) > 0 ? text : "UNKNOWN");
  }

string ASC_Output_OrderModeText(const int value)
  {
   if(value < 0)
      return("UNKNOWN");
   if(value == 0)
      return("None");

   string text = "";
   if((value & SYMBOL_ORDER_MARKET) == SYMBOL_ORDER_MARKET)
      text = (StringLen(text) == 0 ? "Market" : text + ", Market");
   if((value & SYMBOL_ORDER_LIMIT) == SYMBOL_ORDER_LIMIT)
      text = (StringLen(text) == 0 ? "Limit" : text + ", Limit");
   if((value & SYMBOL_ORDER_STOP) == SYMBOL_ORDER_STOP)
      text = (StringLen(text) == 0 ? "Stop" : text + ", Stop");
   if((value & SYMBOL_ORDER_STOP_LIMIT) == SYMBOL_ORDER_STOP_LIMIT)
      text = (StringLen(text) == 0 ? "Stop limit" : text + ", Stop limit");
   if((value & SYMBOL_ORDER_SL) == SYMBOL_ORDER_SL)
      text = (StringLen(text) == 0 ? "Stop loss" : text + ", Stop loss");
   if((value & SYMBOL_ORDER_TP) == SYMBOL_ORDER_TP)
      text = (StringLen(text) == 0 ? "Take profit" : text + ", Take profit");
   if((value & SYMBOL_ORDER_CLOSEBY) == SYMBOL_ORDER_CLOSEBY)
      text = (StringLen(text) == 0 ? "Close by" : text + ", Close by");
   return(text);
  }

string ASC_Output_SwapModeText(const int value)
  {
   switch(value)
     {
      case SYMBOL_SWAP_MODE_DISABLED: return("Disabled");
      case SYMBOL_SWAP_MODE_POINTS: return("In points");
      case SYMBOL_SWAP_MODE_CURRENCY_SYMBOL: return("In margin currency");
      case SYMBOL_SWAP_MODE_CURRENCY_MARGIN: return("In deposit currency");
      case SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT: return("In deposit currency");
      case SYMBOL_SWAP_MODE_INTEREST_CURRENT: return("Interest current");
      case SYMBOL_SWAP_MODE_INTEREST_OPEN: return("Interest open");
      case SYMBOL_SWAP_MODE_REOPEN_CURRENT: return("Reopen current");
      case SYMBOL_SWAP_MODE_REOPEN_BID: return("Reopen bid");
      default: return("UNKNOWN");
     }
  }

bool ASC_Output_RecordHasPublishedTruth(const ASC_SymbolRecord &record)
  {
   if(!record.Identity.ClassificationResolved)
     {
      string path = ASC_Output_Trim(record.Identity.BrokerPath);
      StringToUpper(path);
      string exchange = ASC_Output_Trim(record.Identity.BrokerExchange);
      StringToUpper(exchange);
      if(StringFind(path,"SHARE",0) >= 0 ||
         StringFind(path,"STOCK",0) >= 0 ||
         StringFind(path,"EQUIT",0) >= 0 ||
         StringFind(exchange,"NASDAQ",0) >= 0 ||
         StringFind(exchange,"NYSE",0) >= 0 ||
         StringFind(exchange,"XETRA",0) >= 0 ||
         StringFind(exchange,"EURONEXT",0) >= 0 ||
         StringFind(exchange,"LONDON",0) >= 0)
         return(false);
     }

   if(record.Identity.ClassificationResolved)
      return(true);
   if(ASC_Output_IsMeaningfulValue(record.Identity.AssetClass))
      return(true);
   if(record.MarketTruth.Exists)
      return(true);
   if(record.ConditionsTruth.SpecsReadable)
      return(true);
   if(record.ConditionsTruth.TruthCoverageStatus == "PARTIAL")
      return(true);
   return(false);
  }

bool ASC_Output_RecordNeedsClassificationReview(const ASC_SymbolRecord &record)
  {
   if(record.Identity.ClassificationResolved)
      return(false);

   string path = record.Identity.BrokerPath;
   StringToUpper(path);
   string exchange = ASC_Output_Trim(record.Identity.BrokerExchange);
   StringToUpper(exchange);
   return(StringFind(path,"SHARE",0) >= 0 ||
          StringFind(path,"STOCK",0) >= 0 ||
          StringFind(path,"EQUIT",0) >= 0 ||
          StringFind(exchange,"NASDAQ",0) >= 0 ||
          StringFind(exchange,"NYSE",0) >= 0 ||
          StringFind(exchange,"XETRA",0) >= 0 ||
          StringFind(exchange,"EURONEXT",0) >= 0 ||
          StringFind(exchange,"LONDON",0) >= 0);
  }

string ASC_Output_PublicationStateText(const ASC_SymbolRecord &record)
  {
   if(ASC_Output_RecordHasPublishedTruth(record))
      return("PUBLISHED");
   if(record.MarketTruth.Exists || ASC_Output_IsMeaningfulValue(record.Identity.RawSymbol))
      return("PENDING_SCAN");
   return("UNAVAILABLE");
  }

string ASC_Output_PrimaryBucketLabel(const ASC_SymbolRecord &record)
  {
   return(ASC_Output_IsMeaningfulValue(record.Identity.PrimaryBucket) ? record.Identity.PrimaryBucket : "UNKNOWN");
  }

string ASC_Output_RecordRoute(const string broker_name,const ASC_SymbolRecord &record)
  {
   return(broker_name + ".Symbols\\" + ASC_Output_RecordFileComponent(record) + ".txt");
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

void ASC_Output_WriteIdentityFields(const int handle,const ASC_SymbolRecord &record)
  {
   ASC_Output_WriteStringField(handle,"Symbol",ASC_Output_RecordDisplaySymbol(record));
   ASC_Output_WriteStringField(handle,"DisplayName",record.Identity.DisplayName);
   ASC_Output_WriteStringField(handle,"RawSymbol",record.Identity.RawSymbol);
   ASC_Output_WriteStringField(handle,"NormalizedSymbol",record.Identity.NormalizedSymbol);
   ASC_Output_WriteStringField(handle,"CanonicalSymbol",record.Identity.CanonicalSymbol);
   ASC_Output_WriteStringField(handle,"BrokerPath",record.Identity.BrokerPath);
   ASC_Output_WriteStringField(handle,"BrokerExchange",record.Identity.BrokerExchange);
   ASC_Output_WriteStringField(handle,"BrokerCountry",record.Identity.BrokerCountry);
   FileWrite(handle,"");
  }

void ASC_Output_WriteClassificationFields(const int handle,const ASC_SymbolRecord &record)
  {
   ASC_Output_WriteStringField(handle,"AssetClass",record.Identity.AssetClass);
   ASC_Output_WriteStringField(handle,"PrimaryBucket",ASC_Output_PrimaryBucketLabel(record));
   ASC_Output_WriteStringField(handle,"Sector",record.Identity.Sector);
   ASC_Output_WriteStringField(handle,"Industry",record.Identity.Industry);
   ASC_Output_WriteStringField(handle,"Theme",record.Identity.Theme);
   FileWrite(handle,"ClassificationResolved: " + ASC_Output_BoolText(record.Identity.ClassificationResolved));
   ASC_Output_WriteStringField(handle,"ClassificationReason",record.Identity.ClassificationReason);
   ASC_Output_WriteStringField(handle,"NormalizationStatus",record.ConditionsTruth.NormalizationStatus);
   FileWrite(handle,"");
  }

void ASC_Output_WriteMarketStateFields(const int handle,const ASC_SymbolRecord &record)
  {
   FileWrite(handle,"Exists: " + ASC_Output_BoolText(record.MarketTruth.Exists));
   FileWrite(handle,"Selected: " + ASC_Output_BoolText(record.MarketTruth.Selected));
   FileWrite(handle,"Visible: " + ASC_Output_BoolText(record.MarketTruth.Visible));
   FileWrite(handle,"TradeAllowed: " + ASC_Output_BoolText(record.MarketTruth.TradeAllowed));
   FileWrite(handle,"HasUsableQuote: " + ASC_Output_BoolText(record.MarketTruth.HasUsableQuote));
   FileWrite(handle,"QuoteFresh: " + ASC_Output_BoolText(record.MarketTruth.QuoteFresh));
   ASC_Output_WriteStringField(handle,"QuoteFreshnessStatus",record.MarketTruth.QuoteFreshnessStatus);
   ASC_Output_WriteIntegerField(handle,"QuoteAgeSeconds",record.MarketTruth.QuoteAgeSeconds,(record.MarketTruth.QuoteAgeSeconds >= 0));
   FileWrite(handle,"SessionTruthStatus: " + ASC_Output_SessionStatusText(record.MarketTruth.SessionTruthStatus));
   FileWrite(handle,"Layer1Eligible: " + ASC_Output_BoolText(record.MarketTruth.Layer1Eligible));
   ASC_Output_WriteIntegerField(handle,"LastQuoteTime",(int)record.MarketTruth.LastQuoteTime,(record.MarketTruth.LastQuoteTime > 0));
   ASC_Output_WriteIntegerField(handle,"NextRecheckTime",(int)record.MarketTruth.NextRecheckTime,(record.MarketTruth.NextRecheckTime > 0));
   ASC_Output_WriteStringField(handle,"SessionReadStatus",record.MarketTruth.SessionReadStatus);
   ASC_Output_WriteStringField(handle,"SessionReadReason",record.MarketTruth.SessionReadReason);
   ASC_Output_WriteStringField(handle,"SessionConsistencyReason",record.MarketTruth.SessionConsistencyReason);
   ASC_Output_WriteStringField(handle,"IneligibleReason",record.MarketTruth.IneligibleReason);
   FileWrite(handle,"");
  }

void ASC_Output_WriteTradingRulesFields(const int handle,const ASC_SymbolRecord &record)
  {
   ASC_ConditionsTruth t = record.ConditionsTruth;
   FileWrite(handle,"SpecsReadable: " + ASC_Output_BoolText(t.SpecsReadable));
   ASC_Output_WriteStringField(handle,"SpecsReason",t.SpecsReason);
   ASC_Output_WriteStringField(handle,"SpecIntegrityStatus",t.SpecIntegrityStatus);
   ASC_Output_WriteStringField(handle,"TruthCoverageStatus",t.TruthCoverageStatus);
   ASC_Output_WriteIntegerField(handle,"Digits",t.Digits,t.DigitsReadable);
   ASC_Output_WriteIntegerField(handle,"SpreadPoints",t.SpreadPoints,t.SpreadPointsReadable);
   FileWrite(handle,"SpreadFloat: " + (t.SpreadFloatReadable ? ASC_Output_BoolText(t.SpreadFloat) : "UNKNOWN"));
   ASC_Output_WriteIntegerField(handle,"StopsLevel",t.StopsLevel,t.StopsLevelReadable);
   ASC_Output_WriteIntegerField(handle,"FreezeLevel",t.FreezeLevel,t.FreezeLevelReadable);
   ASC_Output_WriteStringField(handle,"CalcMode",t.CalcModeReadable ? ASC_Output_CalcModeText(t.CalcMode) : "UNKNOWN");
   ASC_Output_WriteStringField(handle,"ChartMode",t.ChartModeReadable ? ASC_Output_ChartModeText(t.ChartMode) : "UNKNOWN");
   ASC_Output_WriteStringField(handle,"TradeMode",t.TradeModeReadable ? ASC_Output_TradeModeText(t.TradeMode) : "UNKNOWN");
   ASC_Output_WriteStringField(handle,"ExecutionMode",t.ExecutionModeReadable ? ASC_Output_ExecutionModeText(t.ExecutionMode) : "UNKNOWN");
   ASC_Output_WriteStringField(handle,"GtcMode",t.GtcModeReadable ? ASC_Output_GtcModeText(t.GtcMode) : "UNKNOWN");
   ASC_Output_WriteStringField(handle,"FillingMode",t.FillingModeReadable ? ASC_Output_FillingModeText(t.FillingMode) : "UNKNOWN");
   ASC_Output_WriteStringField(handle,"ExpirationMode",t.ExpirationModeReadable ? ASC_Output_ExpirationModeText(t.ExpirationMode) : "UNKNOWN");
   ASC_Output_WriteStringField(handle,"OrderMode",t.OrderModeReadable ? ASC_Output_OrderModeText(t.OrderMode) : "UNKNOWN");
   ASC_Output_WriteDoubleField(handle,"VolumeMin",t.VolumeMin,t.VolumeMinReadable);
   ASC_Output_WriteDoubleField(handle,"VolumeMax",t.VolumeMax,t.VolumeMaxReadable);
   ASC_Output_WriteDoubleField(handle,"VolumeStep",t.VolumeStep,t.VolumeStepReadable);
   ASC_Output_WriteDoubleField(handle,"VolumeLimit",t.VolumeLimit,t.VolumeLimitReadable);
   FileWrite(handle,"");
  }

void ASC_Output_WriteEconomicsFields(const int handle,const ASC_SymbolRecord &record)
  {
   ASC_ConditionsTruth t = record.ConditionsTruth;
   ASC_Output_WriteStringField(handle,"EconomicsTrust",t.EconomicsTrust);
   ASC_Output_WriteDoubleField(handle,"Point",t.Point,t.PointReadable);
   ASC_Output_WriteDoubleField(handle,"TickSize",t.TickSize,t.TickSizeReadable);
   ASC_Output_WriteDoubleField(handle,"TickValue",t.TickValue,t.TickValueReadable);
   ASC_Output_WriteDoubleField(handle,"TickValueProfit",t.TickValueProfit,t.TickValueProfitReadable);
   ASC_Output_WriteDoubleField(handle,"TickValueLoss",t.TickValueLoss,t.TickValueLossReadable);
   ASC_Output_WriteDoubleField(handle,"ContractSize",t.ContractSize,t.ContractSizeReadable);
   ASC_Output_WriteStringField(handle,"MarginCurrency",t.MarginCurrencyReadable ? t.MarginCurrency : "UNKNOWN");
   ASC_Output_WriteStringField(handle,"ProfitCurrency",t.ProfitCurrencyReadable ? t.ProfitCurrency : "UNKNOWN");
   ASC_Output_WriteStringField(handle,"BaseCurrency",t.BaseCurrencyReadable ? t.BaseCurrency : "UNKNOWN");
   FileWrite(handle,"");
  }

void ASC_Output_WriteSwapFields(const int handle,const ASC_SymbolRecord &record)
  {
   ASC_ConditionsTruth t = record.ConditionsTruth;
   ASC_Output_WriteStringField(handle,"SwapType",t.SwapModeReadable ? ASC_Output_SwapModeText(t.SwapMode) : "UNKNOWN");
   ASC_Output_WriteDoubleField(handle,"SwapLong",t.SwapLong,t.SwapLongReadable);
   ASC_Output_WriteDoubleField(handle,"SwapShort",t.SwapShort,t.SwapShortReadable);
   ASC_Output_WriteDoubleField(handle,"SwapSunday",t.SwapSunday,t.SwapSundayReadable);
   ASC_Output_WriteDoubleField(handle,"SwapMonday",t.SwapMonday,t.SwapMondayReadable);
   ASC_Output_WriteDoubleField(handle,"SwapTuesday",t.SwapTuesday,t.SwapTuesdayReadable);
   ASC_Output_WriteDoubleField(handle,"SwapWednesday",t.SwapWednesday,t.SwapWednesdayReadable);
   ASC_Output_WriteDoubleField(handle,"SwapThursday",t.SwapThursday,t.SwapThursdayReadable);
   ASC_Output_WriteDoubleField(handle,"SwapFriday",t.SwapFriday,t.SwapFridayReadable);
   ASC_Output_WriteDoubleField(handle,"SwapSaturday",t.SwapSaturday,t.SwapSaturdayReadable);
   FileWrite(handle,"");
  }

void ASC_Output_WriteSessionsFields(const int handle,const ASC_SymbolRecord &record)
  {
   FileWrite(handle,"QuoteScheduleReadable: " + ASC_Output_BoolText(record.MarketTruth.QuoteScheduleReadable));
   FileWrite(handle,"TradeScheduleReadable: " + ASC_Output_BoolText(record.MarketTruth.TradeScheduleReadable));
   ASC_Output_WriteStringField(handle,"SundayQuotes",record.MarketTruth.QuoteScheduleSunday);
   ASC_Output_WriteStringField(handle,"SundayTrade",record.MarketTruth.TradeScheduleSunday);
   ASC_Output_WriteStringField(handle,"MondayQuotes",record.MarketTruth.QuoteScheduleMonday);
   ASC_Output_WriteStringField(handle,"MondayTrade",record.MarketTruth.TradeScheduleMonday);
   ASC_Output_WriteStringField(handle,"TuesdayQuotes",record.MarketTruth.QuoteScheduleTuesday);
   ASC_Output_WriteStringField(handle,"TuesdayTrade",record.MarketTruth.TradeScheduleTuesday);
   ASC_Output_WriteStringField(handle,"WednesdayQuotes",record.MarketTruth.QuoteScheduleWednesday);
   ASC_Output_WriteStringField(handle,"WednesdayTrade",record.MarketTruth.TradeScheduleWednesday);
   ASC_Output_WriteStringField(handle,"ThursdayQuotes",record.MarketTruth.QuoteScheduleThursday);
   ASC_Output_WriteStringField(handle,"ThursdayTrade",record.MarketTruth.TradeScheduleThursday);
   ASC_Output_WriteStringField(handle,"FridayQuotes",record.MarketTruth.QuoteScheduleFriday);
   ASC_Output_WriteStringField(handle,"FridayTrade",record.MarketTruth.TradeScheduleFriday);
   ASC_Output_WriteStringField(handle,"SaturdayQuotes",record.MarketTruth.QuoteScheduleSaturday);
   ASC_Output_WriteStringField(handle,"SaturdayTrade",record.MarketTruth.TradeScheduleSaturday);
   FileWrite(handle,"");
  }

void ASC_Output_WriteMarginFields(const int handle,const ASC_SymbolRecord &record)
  {
   ASC_ConditionsTruth t = record.ConditionsTruth;
   ASC_Output_WriteDoubleField(handle,"MarginInitial",t.MarginInitial,t.MarginInitialReadable);
   ASC_Output_WriteDoubleField(handle,"MarginMaintenance",t.MarginMaintenance,t.MarginMaintenanceReadable);
   ASC_Output_WriteDoubleField(handle,"MarginHedged",t.MarginHedged,t.MarginHedgedReadable);
   if(t.MarginRateBuyReadable)
     {
      FileWrite(handle,"BuyMarginInitial: " + DoubleToString(t.MarginRateBuyInitial,16));
      FileWrite(handle,"BuyMarginMaintenance: " + DoubleToString(t.MarginRateBuyMaintenance,16));
     }
   else
     {
      FileWrite(handle,"BuyMarginInitial: UNKNOWN");
      FileWrite(handle,"BuyMarginMaintenance: UNKNOWN");
     }
   if(t.MarginRateSellReadable)
     {
      FileWrite(handle,"SellMarginInitial: " + DoubleToString(t.MarginRateSellInitial,16));
      FileWrite(handle,"SellMarginMaintenance: " + DoubleToString(t.MarginRateSellMaintenance,16));
     }
   else
     {
      FileWrite(handle,"SellMarginInitial: UNKNOWN");
      FileWrite(handle,"SellMarginMaintenance: UNKNOWN");
     }
   FileWrite(handle,"");
  }

void ASC_Output_WriteHistoryFields(const int handle)
  {
   FileWrite(handle,"HistoryStatus: PENDING_UPSTREAM_TRUTH");
   FileWrite(handle,"HistoryNote: Layer 1.2 preserves broker/session/spec truth only; history depth is not claimed here.");
   FileWrite(handle,"");
  }

void ASC_Output_WriteCalculationFields(const int handle)
  {
   FileWrite(handle,"CalculationStatus: PENDING_UPSTREAM_TRUTH");
   FileWrite(handle,"CalculationNote: No ranking, signal, or later-layer calculations are implied by this broker dossier.");
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
   int review_queue_count = 0;
   string lines[];
   ArrayResize(lines,0);

   const int header_end = ArraySize(lines);
   ArrayResize(lines,header_end + 11);
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
   lines[header_end + 10] = "UnresolvedReviewQueueCount: 0";

   string published_buckets[];
   ArrayResize(published_buckets,0);

   for(int index = 0; index < count; ++index)
     {
      const ASC_SymbolRecord record = records[index];
      if(record.MarketTruth.Layer1Eligible)
         ++eligible_count;
      if(ASC_Output_IsMeaningfulValue(record.Identity.PrimaryBucket))
         ++bucket_known_count;
      if(ASC_Output_RecordNeedsClassificationReview(record))
         ++review_queue_count;

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
   lines[10] = "UnresolvedReviewQueueCount: " + IntegerToString(review_queue_count);

   Print("ASC classification coverage for server " + broker_name +
         ": unresolved review queue count=" + IntegerToString(review_queue_count));

   const int guidance_start = ArraySize(lines);
   ArrayResize(lines,guidance_start + 4);
   lines[guidance_start] = "";
   lines[guidance_start + 1] = "[ROUTING_GUIDANCE]";
   lines[guidance_start + 2] = "Published symbol routes appear below only when a symbol dossier was actually written this cycle.";
   lines[guidance_start + 3] = "Pending symbols remain preserved in the universe snapshot and mirror output until a later pass supplies publishable truth.";

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
      line += " | Quote=" + record.MarketTruth.QuoteFreshnessStatus;
      line += " | Specs=" + record.ConditionsTruth.SpecIntegrityStatus;
      const int next_index = ArraySize(lines);
      ArrayResize(lines,next_index + 1);
      lines[next_index] = line;
     }

   return(ASC_Output_WriteLinesAtomically(config,file_name,lines));
  }

bool ASC_Output_WriteSymbolDossier(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &record)
  {
   if(!ASC_Output_RecordHasPublishedTruth(record))
      return(true);

   const string broker_name = ASC_Output_BrokerName();
   FolderCreate(ASC_OUTPUT_ROOT_PATH,config.UseCommonFiles ? FILE_COMMON : 0);
   FolderCreate(ASC_Output_SymbolDirectory(broker_name),config.UseCommonFiles ? FILE_COMMON : 0);

   const int handle = FileOpen(ASC_Output_SymbolFileName(broker_name,record),ASC_Output_OpenFlags(config.UseCommonFiles) | FILE_WRITE);
   if(handle == INVALID_HANDLE)
      return(false);

   FileWrite(handle,ASC_Output_RecordTitle(record));
   FileWrite(handle,"Broker: " + broker_name);
   FileWrite(handle,"");

   ASC_Output_WriteSectionHeader(handle,"[BROKER_SPEC]");
   ASC_Output_WriteIdentityFields(handle,record);
   ASC_Output_WriteClassificationFields(handle,record);
   ASC_Output_WriteMarketStateFields(handle,record);
   ASC_Output_WriteTradingRulesFields(handle,record);
   ASC_Output_WriteEconomicsFields(handle,record);
   ASC_Output_WriteSwapFields(handle,record);
   ASC_Output_WriteSessionsFields(handle,record);
   ASC_Output_WriteMarginFields(handle,record);

   ASC_Output_WriteSectionHeader(handle,"[OHLC_HISTORY]");
   ASC_Output_WriteHistoryFields(handle);
   FileWrite(handle,"");

   ASC_Output_WriteSectionHeader(handle,"[CALCULATIONS]");
   ASC_Output_WriteCalculationFields(handle);

   FileClose(handle);
   return(true);
  }

bool ASC_Output_WriteSymbolSurfaces(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count)
  {
   for(int index = 0; index < count; ++index)
     {
      if(!ASC_Output_WriteSymbolDossier(config,records[index]))
         return(false);
     }
   return(true);
  }

bool ASC_Output_WriteClassificationReviewQueue(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count)
  {
   const string broker_name = ASC_Output_BrokerName();
   FolderCreate(ASC_OUTPUT_ROOT_PATH,config.UseCommonFiles ? FILE_COMMON : 0);

   const int handle = FileOpen(ASC_Output_ReviewQueueFileName(broker_name),ASC_Output_OpenFlags(config.UseCommonFiles) | FILE_WRITE);
   if(handle == INVALID_HANDLE)
      return(false);

   int queued = 0;
   FileWrite(handle,"Classification Review Queue");
   FileWrite(handle,"Broker: " + broker_name);
   FileWrite(handle,"");

   for(int index = 0; index < count; ++index)
     {
      if(!ASC_Output_RecordNeedsClassificationReview(records[index]))
         continue;

      ++queued;
      FileWrite(handle,"[REVIEW]");
      ASC_Output_WriteStringField(handle,"RawSymbol",records[index].Identity.RawSymbol);
      ASC_Output_WriteStringField(handle,"DisplayName",records[index].Identity.DisplayName);
      ASC_Output_WriteStringField(handle,"BrokerExchange",records[index].Identity.BrokerExchange);
      ASC_Output_WriteStringField(handle,"BrokerPath",records[index].Identity.BrokerPath);
      ASC_Output_WriteStringField(handle,"ClassificationReason",records[index].Identity.ClassificationReason);
      FileWrite(handle,"");
     }

   FileWrite(handle,"QueuedCount: " + IntegerToString(queued));
   FileClose(handle);
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

         string expected_name = ASC_Output_RecordFileComponent(records[index]) + ".txt";
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

void ASC_Output_WriteMirrorRecord(const int handle,const ASC_SymbolRecord &record)
  {
   FileWrite(handle,"[SYMBOL]");
   FileWrite(handle,"Title: " + ASC_Output_RecordTitle(record));
   FileWrite(handle,"DisplaySymbol: " + ASC_Output_RecordDisplaySymbol(record));
   FileWrite(handle,"PublicationState: " + ASC_Output_PublicationStateText(record));
   ASC_Output_WriteStringField(handle,"HydrationState",record.RecordHydration.HydrationState);
   ASC_Output_WriteStringField(handle,"SnapshotAuthority",record.RecordHydration.SnapshotAuthority);
   FileWrite(handle,"PublishableTruth: " + ASC_Output_BoolText(record.RecordHydration.PublishableTruth));
   ASC_Output_WriteStringField(handle,"PrimaryBucket",ASC_Output_PrimaryBucketLabel(record));
   FileWrite(handle,"SessionTruthStatus: " + ASC_Output_SessionStatusText(record.MarketTruth.SessionTruthStatus));
   ASC_Output_WriteStringField(handle,"QuoteFreshnessStatus",record.MarketTruth.QuoteFreshnessStatus);
   ASC_Output_WriteStringField(handle,"SpecIntegrityStatus",record.ConditionsTruth.SpecIntegrityStatus);
   ASC_Output_WriteStringField(handle,"TruthCoverageStatus",record.ConditionsTruth.TruthCoverageStatus);
   ASC_Output_WriteStringField(handle,"SessionConsistencyReason",record.MarketTruth.SessionConsistencyReason);
   FileWrite(handle,"");
  }

bool ASC_Output_WriteUniverseSnapshotMirror(const ASC_RuntimeConfig &config,const ASC_SymbolRecord &records[],const int count)
  {
   FolderCreate(ASC_OUTPUT_ROOT_PATH,config.UseCommonFiles ? FILE_COMMON : 0);

   const int handle = FileOpen(ASC_OUTPUT_LAYER12_MIRROR_FILE_NAME,ASC_Output_OpenFlags(config.UseCommonFiles) | FILE_WRITE);
   if(handle == INVALID_HANDLE)
      return(false);

   int hydrated_count = 0;
   int partial_count = 0;
   int eligible_count = 0;
   int published_truth_count = 0;
   for(int index = 0; index < count; ++index)
     {
      const ASC_SymbolRecord record = records[index];
      if(record.ConditionsTruth.SpecsReadable)
         ++hydrated_count;
      if(record.ConditionsTruth.TruthCoverageStatus == "PARTIAL")
         ++partial_count;
      if(record.MarketTruth.Layer1Eligible)
         ++eligible_count;
      if(ASC_Output_RecordHasPublishedTruth(record))
         ++published_truth_count;
     }

   FileWrite(handle,"Universe Recovery Debug Mirror");
   FileWrite(handle,"RecordCount: " + IntegerToString(count));
   FileWrite(handle,"Layer1EligibleCount: " + IntegerToString(eligible_count));
   FileWrite(handle,"HydratedSpecCount: " + IntegerToString(hydrated_count));
   FileWrite(handle,"PartialCoverageCount: " + IntegerToString(partial_count));
   FileWrite(handle,"PublishedTruthCount: " + IntegerToString(published_truth_count));
   FileWrite(handle,"");

   for(int index = 0; index < count; ++index)
      ASC_Output_WriteMirrorRecord(handle,records[index]);

   FileClose(handle);

   if(!ASC_Output_WriteSymbolSurfaces(config,records,count))
      return(false);

   if(!ASC_Output_WriteClassificationReviewQueue(config,records,count))
      return(false);

   ASC_Output_RemoveStaleSymbolFiles(config,records,count);

   if(!ASC_Output_WriteSummarySurface(config,records,count))
      return(false);

   return(true);
  }

#endif
