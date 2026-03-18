#ifndef ASC_MARKET_MQH
#define ASC_MARKET_MQH

#include "ASC_Common.mqh"

namespace ASC_Market_Internal
{
   void AppendReason(string &reason, const string message)
   {
      if(StringLen(message) == 0)
         return;

      if(StringLen(reason) > 0)
         reason += "; ";

      reason += message;
   }

   void ResetIdentity(ASC_SymbolIdentity &identity)
   {
      identity.RawSymbol             = "";
      identity.NormalizedSymbol      = "";
      identity.CanonicalSymbol       = "";
      identity.AssetClass            = "UNKNOWN";
      identity.PrimaryBucket         = "UNKNOWN";
      identity.Sector                = "UNKNOWN";
      identity.Industry              = "UNKNOWN";
      identity.Theme                 = "UNKNOWN";
      identity.ClassificationResolved = false;
      identity.ClassificationReason  = "classification unresolved";
   }

   void ResetMarketTruth(const ASC_RuntimeConfig &config, ASC_MarketTruth &truth)
   {
      truth.Exists             = false;
      truth.Selected           = false;
      truth.Visible            = false;
      truth.QuoteWindowOpen    = false;
      truth.TradeWindowOpen    = false;
      truth.TradeAllowed       = false;
      truth.SessionTruthStatus = ASC_SESSION_UNKNOWN;
      truth.Layer1Eligible     = false;
      truth.LastQuoteTime      = 0;
      truth.NextRecheckTime    = TimeCurrent() + MathMax(config.TimerSeconds, 1);
      truth.IneligibleReason   = "market truth unresolved";
   }

   string NormalizeSymbol(const string symbol)
   {
      string normalized = StringTrimLeft(StringTrimRight(symbol));
      normalized = StringUpper(normalized);
      return normalized;
   }

   bool LoadFlag(const string symbol,
                 const ENUM_SYMBOL_INFO_INTEGER property,
                 bool &value,
                 const string field_name,
                 string &reason)
   {
      long raw_value = 0;
      ResetLastError();
      if(!SymbolInfoInteger(symbol, property, raw_value))
      {
         AppendReason(reason, field_name + " unreadable");
         return false;
      }

      value = (raw_value != 0);
      return true;
   }

   bool LoadInteger(const string symbol,
                    const ENUM_SYMBOL_INFO_INTEGER property,
                    long &value,
                    const string field_name,
                    string &reason)
   {
      ResetLastError();
      if(!SymbolInfoInteger(symbol, property, value))
      {
         AppendReason(reason, field_name + " unreadable");
         return false;
      }

      return true;
   }

   bool LoadTickTime(const string symbol, datetime &last_quote_time, string &reason)
   {
      long raw_time = 0;
      ResetLastError();
      if(!SymbolInfoInteger(symbol, SYMBOL_TIME, raw_time))
      {
         AppendReason(reason, "last_quote_time unreadable");
         return false;
      }

      last_quote_time = (datetime)raw_time;
      return true;
   }

   datetime CurrentServerTime()
   {
      datetime server_time = TimeTradeServer();
      if(server_time <= 0)
         server_time = TimeCurrent();
      return server_time;
   }

   int SecondsOfDay(const datetime value)
   {
      MqlDateTime parts;
      TimeToStruct(value, parts);
      return parts.hour * 3600 + parts.min * 60 + parts.sec;
   }

   bool IsWithinSessionRange(const int now_seconds, const datetime from_time, const datetime to_time)
   {
      const int from_seconds = SecondsOfDay(from_time);
      const int to_seconds   = SecondsOfDay(to_time);

      if(from_seconds == to_seconds)
         return false;

      if(from_seconds < to_seconds)
         return (now_seconds >= from_seconds && now_seconds < to_seconds);

      return (now_seconds >= from_seconds || now_seconds < to_seconds);
   }

   bool SessionWindowOpen(const string symbol,
                          const bool quote_window,
                          bool &is_open,
                          string &reason)
   {
      datetime now = CurrentServerTime();
      const int now_seconds = SecondsOfDay(now);
      const ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)TimeDayOfWeek(now);

      is_open = false;
      bool any_session_data = false;

      for(uint session_index = 0; session_index < 16; ++session_index)
      {
         datetime from_time = 0;
         datetime to_time   = 0;
         bool ok = quote_window
                   ? SymbolInfoSessionQuote(symbol, day, session_index, from_time, to_time)
                   : SymbolInfoSessionTrade(symbol, day, session_index, from_time, to_time);

         if(!ok)
         {
            if(session_index == 0)
            {
               AppendReason(reason, quote_window ? "quote_session unreadable" : "trade_session unreadable");
               return false;
            }
            break;
         }

         any_session_data = true;
         if(IsWithinSessionRange(now_seconds, from_time, to_time))
         {
            is_open = true;
            return true;
         }
      }

      if(!any_session_data)
      {
         AppendReason(reason, quote_window ? "quote_session missing" : "trade_session missing");
         return false;
      }

      return true;
   }

   ASC_SessionTruthStatus ResolveSessionStatus(const ASC_RuntimeConfig &config,
                                               const bool quote_window_open,
                                               const bool trade_window_open,
                                               const bool trade_allowed,
                                               const datetime last_quote_time,
                                               string &ineligible_reason)
   {
      const datetime now = CurrentServerTime();

      if(last_quote_time <= 0)
      {
         ineligible_reason = "no quote timestamp";
         return ASC_SESSION_NO_QUOTE;
      }

      if(config.StaleFeedSeconds > 0 && (now - last_quote_time) > config.StaleFeedSeconds)
      {
         ineligible_reason = "stale feed";
         return ASC_SESSION_STALE_FEED;
      }

      if(!trade_allowed)
      {
         ineligible_reason = "trading disabled";
         return ASC_SESSION_TRADE_DISABLED;
      }

      if(quote_window_open && trade_window_open)
      {
         ineligible_reason = "";
         return ASC_SESSION_OPEN_TRADABLE;
      }

      if(quote_window_open)
      {
         ineligible_reason = "quote window open but trade window closed";
         return ASC_SESSION_QUOTE_ONLY;
      }

      ineligible_reason = "session closed";
      return ASC_SESSION_CLOSED_SESSION;
   }
}

bool ASC_Market_DiscoverSymbols(string &symbols[])
{
   ArrayResize(symbols, 0);

   const int total = SymbolsTotal(false);
   if(total <= 0)
      return false;

   int count = 0;
   for(int i = 0; i < total; ++i)
   {
      const string symbol = SymbolName(i, false);
      if(StringLen(symbol) == 0)
         continue;

      ArrayResize(symbols, count + 1);
      symbols[count] = symbol;
      ++count;
   }

   return (count > 0);
}

bool ASC_Market_BuildIdentityAndTruth(const string symbol,
                                      const ASC_RuntimeConfig &config,
                                      ASC_SymbolRecord &record)
{
   ASC_Market_Internal::ResetIdentity(record.Identity);
   ASC_Market_Internal::ResetMarketTruth(config, record.MarketTruth);

   record.Identity.RawSymbol        = symbol;
   record.Identity.NormalizedSymbol = ASC_Market_Internal::NormalizeSymbol(symbol);
   record.Identity.CanonicalSymbol  = record.Identity.NormalizedSymbol;
   record.Identity.ClassificationReason = "classification unresolved: archive translation not loaded";

   if(StringLen(symbol) == 0)
   {
      record.MarketTruth.IneligibleReason = "symbol is empty";
      return false;
   }

   record.MarketTruth.Exists = SymbolExist(symbol, false);
   if(!record.MarketTruth.Exists)
   {
      record.MarketTruth.SessionTruthStatus = ASC_SESSION_UNKNOWN;
      record.MarketTruth.IneligibleReason = "symbol does not exist";
      return false;
   }

   string read_reason = "";
   bool selected = false;
   bool visible = false;
   long trade_mode = 0;
   datetime last_quote_time = 0;
   bool quote_window_open = false;
   bool trade_window_open = false;

   const bool selected_ok = ASC_Market_Internal::LoadFlag(symbol, SYMBOL_SELECT, selected, "selected", read_reason);
   const bool visible_ok = ASC_Market_Internal::LoadFlag(symbol, SYMBOL_VISIBLE, visible, "visible", read_reason);
   const bool trade_mode_ok = ASC_Market_Internal::LoadInteger(symbol, SYMBOL_TRADE_MODE, trade_mode, "trade_mode", read_reason);
   const bool quote_time_ok = ASC_Market_Internal::LoadTickTime(symbol, last_quote_time, read_reason);
   const bool quote_session_ok = ASC_Market_Internal::SessionWindowOpen(symbol, true, quote_window_open, read_reason);
   const bool trade_session_ok = ASC_Market_Internal::SessionWindowOpen(symbol, false, trade_window_open, read_reason);

   record.MarketTruth.Selected        = selected;
   record.MarketTruth.Visible         = visible;
   record.MarketTruth.QuoteWindowOpen = quote_window_open;
   record.MarketTruth.TradeWindowOpen = trade_window_open;
   record.MarketTruth.LastQuoteTime   = last_quote_time;

   if(trade_mode_ok)
      record.MarketTruth.TradeAllowed = (trade_mode == SYMBOL_TRADE_MODE_FULL);

   if(!(selected_ok && visible_ok && trade_mode_ok && quote_time_ok && quote_session_ok && trade_session_ok))
   {
      record.MarketTruth.SessionTruthStatus = ASC_SESSION_UNKNOWN;
      record.MarketTruth.Layer1Eligible = false;
      record.MarketTruth.IneligibleReason = read_reason;
      return false;
   }

   string ineligible_reason = "";
   record.MarketTruth.SessionTruthStatus = ASC_Market_Internal::ResolveSessionStatus(config,
                                                                                      quote_window_open,
                                                                                      trade_window_open,
                                                                                      record.MarketTruth.TradeAllowed,
                                                                                      last_quote_time,
                                                                                      ineligible_reason);

   record.MarketTruth.Layer1Eligible = (record.MarketTruth.SessionTruthStatus == ASC_SESSION_OPEN_TRADABLE);
   record.MarketTruth.NextRecheckTime = ASC_Market_Internal::CurrentServerTime() + MathMax(config.TimerSeconds, 1);
   record.MarketTruth.IneligibleReason = record.MarketTruth.Layer1Eligible ? "" : ineligible_reason;

   return record.MarketTruth.Layer1Eligible;
}

#endif
