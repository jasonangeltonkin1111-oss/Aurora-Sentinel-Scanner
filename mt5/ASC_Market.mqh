#ifndef ASC_MARKET_MQH
#define ASC_MARKET_MQH

#include "ASC_Common.mqh"

namespace ASC_Market_Internal
{
   struct ClassificationRow
   {
      string ServerKey;
      string RawSymbol;
      string CanonicalSymbol;
      string DisplayName;
      string AssetClass;
      string PrimaryBucket;
      string Sector;
      string Industry;
      string Theme;
      string SubType;
      string AliasKind;
      string Confidence;
      string ReviewStatus;
      string Notes;
   };

   ClassificationRow g_classification_rows[];
   bool              g_classification_loaded = false;

   #include "generated/ASC_ClassificationEmbeddedRows.mqh"

   string Trim(const string value)
   {
      string s = value;
      StringTrimLeft(s);
      StringTrimRight(s);
      return s;
   }

   string UpperTrim(const string value)
   {
      string s = Trim(value);
      StringToUpper(s);
      return s;
   }

   void ResetIdentity(ASC_SymbolIdentity &identity)
   {
      identity.RawSymbol              = "";
      identity.NormalizedSymbol       = "";
      identity.CanonicalSymbol        = "";
      identity.DisplayName            = "";
      identity.BrokerPath             = "";
      identity.BrokerExchange         = "";
      identity.BrokerCountry          = "";
      identity.AssetClass             = "UNKNOWN";
      identity.PrimaryBucket          = "UNKNOWN";
      identity.Sector                 = "UNKNOWN";
      identity.Industry               = "UNKNOWN";
      identity.Theme                  = "UNKNOWN";
      identity.ClassificationResolved = false;
      identity.ClassificationReason   = "classification unresolved";
   }

   void ResetMarketTruth(const ASC_RuntimeConfig &config, ASC_MarketTruth &truth)
   {
      truth.Exists                    = false;
      truth.Selected                  = false;
      truth.Visible                   = false;
      truth.QuoteWindowOpen           = false;
      truth.TradeWindowOpen           = false;
      truth.TradeAllowed              = false;
      truth.HasUsableQuote            = false;
      truth.QuoteFresh                = false;
      truth.QuoteScheduleReadable     = false;
      truth.TradeScheduleReadable     = false;
      truth.SessionTruthStatus        = ASC_SESSION_UNKNOWN;
      truth.Layer1Eligible            = false;
      truth.LastQuoteTime             = 0;
      truth.NextRecheckTime           = TimeCurrent() + MathMax(config.TimerSeconds, 1);
      truth.QuoteAgeSeconds           = -1;
      truth.QuoteFreshnessStatus      = "UNKNOWN";
      truth.QuoteScheduleSunday       = "UNKNOWN";
      truth.QuoteScheduleMonday       = "UNKNOWN";
      truth.QuoteScheduleTuesday      = "UNKNOWN";
      truth.QuoteScheduleWednesday    = "UNKNOWN";
      truth.QuoteScheduleThursday     = "UNKNOWN";
      truth.QuoteScheduleFriday       = "UNKNOWN";
      truth.QuoteScheduleSaturday     = "UNKNOWN";
      truth.TradeScheduleSunday       = "UNKNOWN";
      truth.TradeScheduleMonday       = "UNKNOWN";
      truth.TradeScheduleTuesday      = "UNKNOWN";
      truth.TradeScheduleWednesday    = "UNKNOWN";
      truth.TradeScheduleThursday     = "UNKNOWN";
      truth.TradeScheduleFriday       = "UNKNOWN";
      truth.TradeScheduleSaturday     = "UNKNOWN";
      truth.SessionReadStatus         = "UNREAD";
      truth.SessionReadReason         = "session truth not loaded";
      truth.SessionConsistencyReason  = "session truth unresolved";
      truth.IneligibleReason          = "market truth unresolved";
   }

   bool EndsWith(const string value, const string suffix)
   {
      const int value_len = StringLen(value);
      const int suffix_len = StringLen(suffix);
      if(suffix_len <= 0 || value_len < suffix_len)
         return false;

      return (StringSubstr(value, value_len - suffix_len, suffix_len) == suffix);
   }

   bool IsAsciiAlphaNumeric(const ushort ch)
   {
      if(ch >= 'A' && ch <= 'Z')
         return true;
      if(ch >= '0' && ch <= '9')
         return true;
      return false;
   }

   string TrimTrailingNormalizationNoise(const string value)
   {
      string s = value;
      int len = StringLen(s);
      while(len > 0)
      {
         const ushort ch = (ushort)StringGetCharacter(s, len - 1);
         if(IsAsciiAlphaNumeric(ch))
            break;

         s = StringSubstr(s, 0, len - 1);
         len = StringLen(s);
      }

      return s;
   }

   string StripKnownBrokerSuffixes(const string value)
   {
      string s = TrimTrailingNormalizationNoise(UpperTrim(value));
      string always_strip_suffixes[] =
      {
         ".C", ".NX", ".PRO", ".RAW", ".M",
         "_C", "_NX", "_PRO", "_RAW", "_M",
         "-C", "-NX", "-PRO", "-RAW", "-M"
      };
      string long_symbol_suffixes[] =
      {
         "MICRO", "MINI", "PRO", "RAW", "ECN", "STD", "CASH", "SPOT", "PLUS", "RW"
      };
      bool changed = true;

      while(changed && StringLen(s) > 0)
      {
         changed = false;
         for(int i = 0; i < ArraySize(always_strip_suffixes); ++i)
         {
            if(EndsWith(s, always_strip_suffixes[i]))
            {
               s = StringSubstr(s, 0, StringLen(s) - StringLen(always_strip_suffixes[i]));
               changed = true;
               break;
            }
         }

         if(changed)
            continue;

         for(int i = 0; i < ArraySize(long_symbol_suffixes); ++i)
         {
            if(EndsWith(s, long_symbol_suffixes[i]))
            {
               const string candidate = StringSubstr(s, 0, StringLen(s) - StringLen(long_symbol_suffixes[i]));
               if(StringLen(candidate) < 6)
                  continue;

               s = candidate;
               changed = true;
               break;
            }
         }
      }

      return s;
   }

   string RemovePunctuation(const string value)
   {
      string s = value;
      StringReplace(s, ".", "");
      StringReplace(s, "_", "");
      StringReplace(s, "-", "");
      StringReplace(s, "/", "");
      StringReplace(s, "\\", "");
      StringReplace(s, " ", "");
      StringReplace(s, "\t", "");
      return s;
   }

   string NormalizeSymbol(const string symbol)
   {
      return RemovePunctuation(StripKnownBrokerSuffixes(symbol));
   }

   string NormalizeSearchText(const string value)
   {
      return RemovePunctuation(UpperTrim(value));
   }

   bool TextContains(const string haystack, const string needle)
   {
      return (StringLen(needle) > 0 && StringFind(haystack, needle, 0) >= 0);
   }

   bool ExchangeMatchesAlias(const string alias_kind,
                             const string broker_exchange)
   {
      const string exchange = NormalizeSearchText(broker_exchange);
      if(StringLen(exchange) == 0)
         return false;

      if(alias_kind == "NASDAQ_ALIAS")
         return (TextContains(exchange, "NASDAQ") || TextContains(exchange, "NSDQ"));
      if(alias_kind == "NYSE_ALIAS")
         return (TextContains(exchange, "NYSE") || TextContains(exchange, "NEWYORK"));
      if(alias_kind == "XETRA_ALIAS")
         return (TextContains(exchange, "XETRA") || TextContains(exchange, "DEUTSCHEBORSE"));
      if(alias_kind == "PARIS_ALIAS")
         return (TextContains(exchange, "PARIS") || TextContains(exchange, "EURONEXT"));
      if(alias_kind == "LSE_ALIAS")
         return (TextContains(exchange, "LSE") || TextContains(exchange, "LONDON"));

      return false;
   }

   bool PathHintsEquity(const string broker_path)
   {
      const string path = NormalizeSearchText(broker_path);
      if(StringLen(path) == 0)
         return false;

      return (TextContains(path, "SHARE") ||
              TextContains(path, "STOCK") ||
              TextContains(path, "EQUIT") ||
              TextContains(path, "NASDAQ") ||
              TextContains(path, "NYSE") ||
              TextContains(path, "XETRA") ||
              TextContains(path, "EURONEXT"));
   }

   bool ShouldTryEquitySecondPass(const ASC_SymbolIdentity &identity)
   {
      if(IsMeaningfulValue(identity.BrokerExchange) && identity.BrokerExchange != "UNKNOWN")
         return true;
      if(PathHintsEquity(identity.BrokerPath))
         return true;
      return false;
   }

   string CurrentServerKey()
   {
      return UpperTrim(AccountInfoString(ACCOUNT_SERVER));
   }

   bool ParseClassificationRow(const string line, ClassificationRow &row)
   {
      string parts[];
      const int count = StringSplit(line, '~', parts);
      if(count < 14)
         return false;

      row.ServerKey       = UpperTrim(parts[0]);
      row.RawSymbol       = Trim(parts[1]);
      row.CanonicalSymbol = Trim(parts[2]);
      row.DisplayName     = Trim(parts[3]);
      row.AssetClass      = Trim(parts[4]);
      row.PrimaryBucket   = Trim(parts[5]);
      row.Sector          = Trim(parts[6]);
      row.Industry        = Trim(parts[7]);
      row.Theme           = Trim(parts[8]);
      row.SubType         = Trim(parts[9]);
      row.AliasKind       = Trim(parts[10]);
      row.Confidence      = Trim(parts[11]);
      row.ReviewStatus    = Trim(parts[12]);
      row.Notes           = Trim(parts[13]);
      return true;
   }

   void EnsureClassificationLoaded()
   {
      if(g_classification_loaded)
         return;

      const int total = ArraySize(ClassificationEmbeddedRows);
      ArrayResize(g_classification_rows, total);
      int loaded = 0;

      for(int i = 0; i < total; ++i)
      {
         ClassificationRow row;
         if(!ParseClassificationRow(ClassificationEmbeddedRows[i], row))
            continue;

         g_classification_rows[loaded] = row;
         ++loaded;
      }

      ArrayResize(g_classification_rows, loaded);
      g_classification_loaded = true;

      string server_keys[];
      ArrayResize(server_keys, 0);
      for(int idx = 0; idx < loaded; ++idx)
      {
         bool seen = false;
         for(int key_idx = 0; key_idx < ArraySize(server_keys); ++key_idx)
         {
            if(server_keys[key_idx] == g_classification_rows[idx].ServerKey)
            {
               seen = true;
               break;
            }
         }
         if(!seen)
         {
            const int next = ArraySize(server_keys);
            ArrayResize(server_keys, next + 1);
            server_keys[next] = g_classification_rows[idx].ServerKey;
         }
      }

      const string active_server = CurrentServerKey();
      int active_rows = 0;
      for(int idx = 0; idx < loaded; ++idx)
      {
         if(g_classification_rows[idx].ServerKey == active_server)
            ++active_rows;
      }

      PrintFormat("ASC classification map loaded: rows=%d servers=%d active_server=%s active_rows=%d",
                  loaded,
                  ArraySize(server_keys),
                  active_server,
                  active_rows);
   }

   bool ClassificationRowMatches(const ClassificationRow &row,
                                 const string            server_key,
                                 const string            normalized_symbol,
                                 const bool              require_server)
   {
      if(require_server && row.ServerKey != server_key)
         return false;

      const string row_raw_normalized = NormalizeSymbol(row.RawSymbol);
      const string row_canonical_normalized = NormalizeSymbol(row.CanonicalSymbol);
      return (row_raw_normalized == normalized_symbol || row_canonical_normalized == normalized_symbol);
   }

   bool IsMeaningfulValue(const string value)
   {
      const string trimmed = UpperTrim(value);
      return (trimmed != "" && trimmed != "UNKNOWN");
   }

   void ApplyClassification(const ClassificationRow &row, ASC_SymbolIdentity &identity)
   {
      identity.CanonicalSymbol = NormalizeSymbol(row.CanonicalSymbol);
      if(!IsMeaningfulValue(identity.CanonicalSymbol))
         identity.CanonicalSymbol = identity.NormalizedSymbol;

      identity.AssetClass = IsMeaningfulValue(row.AssetClass) ? UpperTrim(row.AssetClass) : "UNKNOWN";
      identity.PrimaryBucket = IsMeaningfulValue(row.PrimaryBucket) ? UpperTrim(row.PrimaryBucket) : "UNKNOWN";
      identity.Sector = IsMeaningfulValue(row.Sector) ? row.Sector : "UNKNOWN";
      identity.Industry = IsMeaningfulValue(row.Industry) ? row.Industry : "UNKNOWN";
      identity.Theme = IsMeaningfulValue(row.Theme) ? UpperTrim(row.Theme) : "UNKNOWN";
      identity.ClassificationResolved = (identity.AssetClass != "UNKNOWN" || identity.PrimaryBucket != "UNKNOWN" || identity.CanonicalSymbol != identity.NormalizedSymbol);

      string reason = "classification resolved from archive translation";
      if(StringLen(row.ServerKey) > 0)
         reason += " [" + row.ServerKey + "]";
      if(StringLen(row.AliasKind) > 0)
         reason += " alias=" + row.AliasKind;
      if(StringLen(row.Confidence) > 0)
         reason += " confidence=" + row.Confidence;
      if(StringLen(row.ReviewStatus) > 0)
         reason += " review=" + row.ReviewStatus;
      identity.ClassificationReason = reason;
   }

   int ScoreEquitySecondPassCandidate(const ClassificationRow &row,
                                      const string            server_key,
                                      const ASC_SymbolIdentity &identity)
   {
      if(UpperTrim(row.AssetClass) != "STOCK")
         return -1;

      int score = 0;
      if(row.ServerKey == server_key)
         score += 100;
      else if(StringLen(row.ServerKey) > 0)
         score += 15;

      const string normalized_symbol = identity.NormalizedSymbol;
      const string display_name = NormalizeSearchText(identity.DisplayName);
      const string broker_path = NormalizeSearchText(identity.BrokerPath);
      const string row_raw = NormalizeSymbol(row.RawSymbol);
      const string row_canonical = NormalizeSymbol(row.CanonicalSymbol);
      const string row_display = NormalizeSearchText(row.DisplayName);

      if(normalized_symbol == row_raw || normalized_symbol == row_canonical)
         score += 150;

      if(StringLen(display_name) > 0 && StringLen(row_display) > 0)
      {
         if(display_name == row_display)
            score += 120;
         else if(TextContains(display_name, row_display) || TextContains(row_display, display_name))
            score += 80;
      }

      if(StringLen(broker_path) > 0)
      {
         if(TextContains(broker_path, row_canonical) || TextContains(broker_path, row_raw))
            score += 60;
         else if(StringLen(row_display) > 6 && TextContains(broker_path, row_display))
            score += 50;
      }

      if(ExchangeMatchesAlias(row.AliasKind, identity.BrokerExchange))
         score += 40;

      return score;
   }

   bool ResolveEquityClassificationSecondPass(const string server_key,
                                              ASC_SymbolIdentity &identity)
   {
      int best_index = -1;
      int best_score = -1;
      int second_score = -1;

      for(int i = 0; i < ArraySize(g_classification_rows); ++i)
      {
         const int score = ScoreEquitySecondPassCandidate(g_classification_rows[i], server_key, identity);
         if(score > best_score)
         {
            second_score = best_score;
            best_score = score;
            best_index = i;
         }
         else if(score > second_score)
            second_score = score;
      }

      if(best_index < 0 || best_score < 140)
         return false;
      if(second_score >= 0 && (best_score - second_score) < 25)
         return false;

      ApplyClassification(g_classification_rows[best_index], identity);
      identity.ClassificationReason += "; equity second-pass match using broker metadata";
      return true;
   }

   bool ResolveClassification(const string raw_symbol,
                              ASC_SymbolIdentity &identity)
   {
      EnsureClassificationLoaded();

      const string server_key = CurrentServerKey();
      const string normalized_symbol = identity.NormalizedSymbol;
      int fallback_index = -1;

      for(int i = 0; i < ArraySize(g_classification_rows); ++i)
      {
         if(!ClassificationRowMatches(g_classification_rows[i], server_key, normalized_symbol, false))
            continue;

         if(g_classification_rows[i].ServerKey == server_key)
         {
            ApplyClassification(g_classification_rows[i], identity);
            return true;
         }

         if(fallback_index < 0)
            fallback_index = i;
      }

      if(fallback_index >= 0)
      {
         ApplyClassification(g_classification_rows[fallback_index], identity);
         identity.ClassificationReason += "; server fallback from archive match";
         return true;
      }

      if(ShouldTryEquitySecondPass(identity) && ResolveEquityClassificationSecondPass(server_key, identity))
         return true;

      identity.CanonicalSymbol = identity.NormalizedSymbol;
      identity.ClassificationResolved = false;
      if(ShouldTryEquitySecondPass(identity))
         identity.ClassificationReason = "classification unresolved after equity metadata second pass";
      else
         identity.ClassificationReason = "classification unresolved: no archive translation match";
      return false;
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

   bool TradeModePermitsNewExposure(const long trade_mode)
   {
      return (trade_mode == SYMBOL_TRADE_MODE_FULL ||
              trade_mode == SYMBOL_TRADE_MODE_LONGONLY ||
              trade_mode == SYMBOL_TRADE_MODE_SHORTONLY);
   }

   struct SessionWindowProbe
   {
      bool Readable;
      bool HasData;
      bool IsOpen;
      string Issue;
   };

   struct WeeklySessionSchedule
   {
      bool QuoteReadable;
      bool TradeReadable;
      string QuoteSunday;
      string QuoteMonday;
      string QuoteTuesday;
      string QuoteWednesday;
      string QuoteThursday;
      string QuoteFriday;
      string QuoteSaturday;
      string TradeSunday;
      string TradeMonday;
      string TradeTuesday;
      string TradeWednesday;
      string TradeThursday;
      string TradeFriday;
      string TradeSaturday;
   };

   struct TickEvidence
   {
      bool Readable;
      bool HasQuote;
      bool HasTimestamp;
      datetime QuoteTime;
      int AgeSeconds;
   };

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

   void LoadTickEvidence(const string symbol,
                         const datetime current_time,
                         TickEvidence &evidence)
   {
      evidence.Readable     = false;
      evidence.HasQuote     = false;
      evidence.HasTimestamp = false;
      evidence.QuoteTime    = 0;
      evidence.AgeSeconds   = -1;

      MqlTick tick;
      if(!SymbolInfoTick(symbol, tick))
         return;

      evidence.Readable     = true;
      evidence.HasTimestamp = ((datetime)tick.time > 0);
      evidence.QuoteTime    = (datetime)tick.time;
      evidence.HasQuote     = (evidence.HasTimestamp && tick.bid > 0.0 && tick.ask > 0.0 && tick.ask >= tick.bid);

      if(evidence.HasTimestamp)
         evidence.AgeSeconds = (int)MathMax(0, (long)(current_time - evidence.QuoteTime));
   }

   bool HasSessionReference(const string symbol)
   {
      ResetLastError();
      const double session_open = SymbolInfoDouble(symbol, SYMBOL_SESSION_OPEN);
      const bool open_ok = (GetLastError() == 0);

      ResetLastError();
      const double session_close = SymbolInfoDouble(symbol, SYMBOL_SESSION_CLOSE);
      const bool close_ok = (GetLastError() == 0);

      ResetLastError();
      const double bid_high = SymbolInfoDouble(symbol, SYMBOL_BIDHIGH);
      const bool bid_high_ok = (GetLastError() == 0);

      ResetLastError();
      const double bid_low = SymbolInfoDouble(symbol, SYMBOL_BIDLOW);
      const bool bid_low_ok = (GetLastError() == 0);

      ResetLastError();
      const double ask_high = SymbolInfoDouble(symbol, SYMBOL_ASKHIGH);
      const bool ask_high_ok = (GetLastError() == 0);

      ResetLastError();
      const double ask_low = SymbolInfoDouble(symbol, SYMBOL_ASKLOW);
      const bool ask_low_ok = (GetLastError() == 0);

      return ((open_ok && session_open > 0.0) ||
              (close_ok && session_close > 0.0) ||
              (bid_high_ok && bid_high > 0.0) ||
              (bid_low_ok && bid_low > 0.0) ||
              (ask_high_ok && ask_high > 0.0) ||
              (ask_low_ok && ask_low > 0.0));
   }

   datetime CurrentServerTime()
   {
      datetime server_time = TimeTradeServer();
      if(server_time <= 0)
         server_time = TimeCurrent();
      return server_time;
   }

   string FormatTimeOfDay(const datetime value)
   {
      MqlDateTime parts;
      TimeToStruct(value, parts);
      return StringFormat("%02d:%02d", parts.hour, parts.min);
   }

   string FormatSessionRange(const datetime from_time, const datetime to_time)
   {
      return FormatTimeOfDay(from_time) + "-" + FormatTimeOfDay(to_time);
   }

   string AppendSessionRange(const string existing, const string range_text)
   {
      if(StringLen(existing) == 0)
         return range_text;
      return existing + "; " + range_text;
   }

   string BuildSessionDaySummary(const string symbol,
                                 const ENUM_DAY_OF_WEEK day,
                                 const bool quote_window,
                                 bool &readable)
   {
      string summary = "";
      readable = true;

      for(uint session_index = 0; session_index < 16; ++session_index)
      {
         datetime from_time = 0;
         datetime to_time = 0;
         const bool ok = quote_window
                         ? SymbolInfoSessionQuote(symbol, day, session_index, from_time, to_time)
                         : SymbolInfoSessionTrade(symbol, day, session_index, from_time, to_time);
         if(!ok)
         {
            if(session_index == 0)
               readable = false;
            break;
         }

         summary = AppendSessionRange(summary, FormatSessionRange(from_time, to_time));
      }

      if(!readable)
         return "UNREADABLE";
      if(StringLen(summary) == 0)
         return "CLOSED";
      return summary;
   }

   void LoadWeeklySessionSchedule(const string symbol,
                                  WeeklySessionSchedule &schedule)
   {
      schedule.QuoteReadable = true;
      schedule.TradeReadable = true;

      bool day_readable = true;
      schedule.QuoteSunday = BuildSessionDaySummary(symbol, SUNDAY, true, day_readable);
      schedule.QuoteReadable = (schedule.QuoteReadable && day_readable);
      schedule.QuoteMonday = BuildSessionDaySummary(symbol, MONDAY, true, day_readable);
      schedule.QuoteReadable = (schedule.QuoteReadable && day_readable);
      schedule.QuoteTuesday = BuildSessionDaySummary(symbol, TUESDAY, true, day_readable);
      schedule.QuoteReadable = (schedule.QuoteReadable && day_readable);
      schedule.QuoteWednesday = BuildSessionDaySummary(symbol, WEDNESDAY, true, day_readable);
      schedule.QuoteReadable = (schedule.QuoteReadable && day_readable);
      schedule.QuoteThursday = BuildSessionDaySummary(symbol, THURSDAY, true, day_readable);
      schedule.QuoteReadable = (schedule.QuoteReadable && day_readable);
      schedule.QuoteFriday = BuildSessionDaySummary(symbol, FRIDAY, true, day_readable);
      schedule.QuoteReadable = (schedule.QuoteReadable && day_readable);
      schedule.QuoteSaturday = BuildSessionDaySummary(symbol, SATURDAY, true, day_readable);
      schedule.QuoteReadable = (schedule.QuoteReadable && day_readable);

      schedule.TradeSunday = BuildSessionDaySummary(symbol, SUNDAY, false, day_readable);
      schedule.TradeReadable = (schedule.TradeReadable && day_readable);
      schedule.TradeMonday = BuildSessionDaySummary(symbol, MONDAY, false, day_readable);
      schedule.TradeReadable = (schedule.TradeReadable && day_readable);
      schedule.TradeTuesday = BuildSessionDaySummary(symbol, TUESDAY, false, day_readable);
      schedule.TradeReadable = (schedule.TradeReadable && day_readable);
      schedule.TradeWednesday = BuildSessionDaySummary(symbol, WEDNESDAY, false, day_readable);
      schedule.TradeReadable = (schedule.TradeReadable && day_readable);
      schedule.TradeThursday = BuildSessionDaySummary(symbol, THURSDAY, false, day_readable);
      schedule.TradeReadable = (schedule.TradeReadable && day_readable);
      schedule.TradeFriday = BuildSessionDaySummary(symbol, FRIDAY, false, day_readable);
      schedule.TradeReadable = (schedule.TradeReadable && day_readable);
      schedule.TradeSaturday = BuildSessionDaySummary(symbol, SATURDAY, false, day_readable);
      schedule.TradeReadable = (schedule.TradeReadable && day_readable);
   }

   string ResolveQuoteFreshnessStatus(const TickEvidence &tick_evidence,
                                      const int stale_feed_seconds)
   {
      if(!tick_evidence.Readable || !tick_evidence.HasTimestamp)
         return "MISSING";
      if(!tick_evidence.HasQuote)
         return "UNUSABLE";
      if(stale_feed_seconds > 0 && tick_evidence.AgeSeconds > stale_feed_seconds)
         return "STALE";
      return "FRESH";
   }

   void LoadIdentityMetadata(const string symbol,
                             ASC_SymbolIdentity &identity)
   {
      SymbolInfoString(symbol, SYMBOL_DESCRIPTION, identity.DisplayName);
      SymbolInfoString(symbol, SYMBOL_PATH, identity.BrokerPath);
      SymbolInfoString(symbol, SYMBOL_EXCHANGE, identity.BrokerExchange);
      SymbolInfoString(symbol, SYMBOL_COUNTRY, identity.BrokerCountry);

      if(!IsMeaningfulValue(identity.DisplayName))
         identity.DisplayName = symbol;
      if(!IsMeaningfulValue(identity.BrokerExchange))
         identity.BrokerExchange = "UNKNOWN";
      if(!IsMeaningfulValue(identity.BrokerCountry))
         identity.BrokerCountry = "UNKNOWN";
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

   void ProbeSessionWindow(const string symbol,
                           const bool quote_window,
                           SessionWindowProbe &probe)
   {
      probe.Readable = true;
      probe.HasData  = false;
      probe.IsOpen   = false;
      probe.Issue    = "";

      datetime current_time = CurrentServerTime();
      const int now_seconds = SecondsOfDay(current_time);
      MqlDateTime current_time_struct;
      TimeToStruct(current_time, current_time_struct);
      const ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)current_time_struct.day_of_week;

      for(uint session_index = 0; session_index < 16; ++session_index)
      {
         datetime from_time = 0;
         datetime to_time   = 0;
         const bool ok = quote_window
                         ? SymbolInfoSessionQuote(symbol, day, session_index, from_time, to_time)
                         : SymbolInfoSessionTrade(symbol, day, session_index, from_time, to_time);

         if(!ok)
         {
            if(session_index == 0)
            {
               probe.Readable = false;
               probe.Issue = quote_window ? "quote_session missing_or_unreadable" : "trade_session missing_or_unreadable";
            }
            break;
         }

         probe.HasData = true;
         if(IsWithinSessionRange(now_seconds, from_time, to_time))
         {
            probe.IsOpen = true;
            return;
         }
      }

      if(!probe.HasData && StringLen(probe.Issue) == 0)
         probe.Issue = quote_window ? "quote_session missing" : "trade_session missing";
   }

   bool IsContinuousMarketClass(const string asset_class)
   {
      return (asset_class == "CRYPTO");
   }

   int CompareSymbols(const string left,const string right)
   {
      string left_upper = left;
      string right_upper = right;
      StringToUpper(left_upper);
      StringToUpper(right_upper);
      const int compare_normalized = StringCompare(left_upper,right_upper);
      if(compare_normalized != 0)
         return(compare_normalized);
      return(StringCompare(left,right));
   }

   void SortSymbols(string &symbols[])
   {
      const int total = ArraySize(symbols);
      for(int i = 1; i < total; ++i)
        {
         const string key = symbols[i];
         int j = i - 1;
         while(j >= 0 && CompareSymbols(symbols[j],key) > 0)
           {
            symbols[j + 1] = symbols[j];
            --j;
           }
         symbols[j + 1] = key;
        }
   }

   void UniqueInPlace(string &symbols[])
   {
      const int total = ArraySize(symbols);
      if(total <= 1)
         return;

      int write_index = 1;
      string last_symbol = symbols[0];
      for(int i = 1; i < total; ++i)
        {
         if(CompareSymbols(last_symbol,symbols[i]) == 0)
            continue;
         symbols[write_index] = symbols[i];
         last_symbol = symbols[i];
         ++write_index;
        }

      ArrayResize(symbols,write_index);
   }

   datetime ResolveNextRecheckTime(const ASC_RuntimeConfig &config,
                                   const ASC_SessionTruthStatus status)
   {
      const datetime now = CurrentServerTime();
      const int base_gap = MathMax(config.TimerSeconds, 1);

      switch(status)
      {
         case ASC_SESSION_OPEN_TRADABLE:
            return now + base_gap;
         case ASC_SESSION_QUOTE_ONLY:
            return now + MathMax(base_gap, 15);
         case ASC_SESSION_NO_QUOTE:
            return now + MathMax(base_gap, 30);
         case ASC_SESSION_STALE_FEED:
            return now + MathMax(base_gap, 20);
         case ASC_SESSION_CLOSED_SESSION:
            return now + MathMax(base_gap, 60);
         case ASC_SESSION_TRADE_DISABLED:
            return now + MathMax(base_gap, 120);
         case ASC_SESSION_UNKNOWN:
         default:
            return now + MathMax(base_gap, 20);
      }
   }

   ASC_SessionTruthStatus ResolveSessionStatus(const ASC_RuntimeConfig &config,
                                               const string asset_class,
                                               const SessionWindowProbe &quote_probe,
                                               const SessionWindowProbe &trade_probe,
                                               const bool trade_allowed,
                                               const datetime last_quote_time,
                                               const TickEvidence &tick_evidence,
                                               const bool has_session_reference,
                                               string &ineligible_reason)
   {
      const bool continuous_market_class = IsContinuousMarketClass(asset_class);
      const bool have_quote_timestamp = (last_quote_time > 0 || tick_evidence.HasTimestamp);
      const datetime effective_quote_time = (tick_evidence.HasTimestamp ? tick_evidence.QuoteTime : last_quote_time);
      const bool stale_quote = (have_quote_timestamp && config.StaleFeedSeconds > 0 && (CurrentServerTime() - effective_quote_time) > config.StaleFeedSeconds);
      const bool fresh_live_quote = (tick_evidence.HasQuote && !stale_quote);
      const bool recent_quote_timestamp = (have_quote_timestamp && !stale_quote);
      const bool explicit_session_open = (quote_probe.HasData && quote_probe.IsOpen && trade_probe.HasData && trade_probe.IsOpen);
      const bool explicit_quote_only = (quote_probe.HasData && quote_probe.IsOpen && trade_probe.HasData && !trade_probe.IsOpen);
      const bool explicit_session_closed = (quote_probe.HasData && !quote_probe.IsOpen && trade_probe.HasData && !trade_probe.IsOpen);
      const bool session_truth_missing = (!quote_probe.HasData || !trade_probe.HasData);
      const bool session_windows_unreadable = (!quote_probe.Readable || !trade_probe.Readable);
      const bool strong_live_evidence = (fresh_live_quote && (continuous_market_class || quote_probe.IsOpen || trade_probe.IsOpen));
      const bool weak_recent_evidence = (recent_quote_timestamp && (has_session_reference || continuous_market_class));

      if(!trade_allowed)
      {
         ineligible_reason = "trading disabled";
         return ASC_SESSION_TRADE_DISABLED;
      }

      if(explicit_session_open)
      {
         if(fresh_live_quote)
         {
            ineligible_reason = "";
            return ASC_SESSION_OPEN_TRADABLE;
         }

         if(have_quote_timestamp && stale_quote)
         {
            ineligible_reason = "stale feed during open session";
            return ASC_SESSION_STALE_FEED;
         }

         ineligible_reason = "open session but no usable quote";
         return ASC_SESSION_NO_QUOTE;
      }

      if(explicit_quote_only)
      {
         if(fresh_live_quote)
            ineligible_reason = "quote window open but trade window closed";
         else if(have_quote_timestamp && stale_quote)
            ineligible_reason = "quote window open but feed stale and trade window closed";
         else
            ineligible_reason = "quote window open but no usable trade quote";
         return ASC_SESSION_QUOTE_ONLY;
      }

      if(strong_live_evidence)
      {
         ineligible_reason = "";
         return ASC_SESSION_OPEN_TRADABLE;
      }

      if(fresh_live_quote)
      {
         if(session_windows_unreadable || session_truth_missing)
         {
            ineligible_reason = "live quote present but session truth incomplete";
            return ASC_SESSION_QUOTE_ONLY;
         }
      }

      if(have_quote_timestamp && stale_quote)
      {
         if(explicit_session_closed && !continuous_market_class)
            ineligible_reason = "session windows closed and last quote is stale";
         else if(continuous_market_class)
            ineligible_reason = "continuous market quote is stale";
         else if(has_session_reference)
            ineligible_reason = "session reference present but feed stale";
         else
            ineligible_reason = "stale feed";
         return ASC_SESSION_STALE_FEED;
      }

      if(explicit_session_closed)
      {
         if(weak_recent_evidence)
         {
            ineligible_reason = continuous_market_class
                                ? "recent quote evidence conflicts with closed session windows"
                                : "recent quote evidence conflicts with closed session windows; holding quote state, not closed certainty";
            return ASC_SESSION_NO_QUOTE;
         }

         if(have_quote_timestamp)
            ineligible_reason = "session windows closed; no live quote evidence";
         else
            ineligible_reason = "session windows closed; no quote evidence";
         return ASC_SESSION_CLOSED_SESSION;
      }

      if(!have_quote_timestamp)
      {
         if(has_session_reference)
         {
            ineligible_reason = "session reference present but no quote evidence";
            return ASC_SESSION_NO_QUOTE;
         }

         if(session_windows_unreadable)
         {
            string details = "market truth unresolved: no quote evidence";
            if(StringLen(quote_probe.Issue) > 0)
               details += "; " + quote_probe.Issue;
            if(StringLen(trade_probe.Issue) > 0)
               details += "; " + trade_probe.Issue;
            ineligible_reason = details;
            return ASC_SESSION_UNKNOWN;
         }

         ineligible_reason = "market truth unresolved: no quote evidence";
         return ASC_SESSION_UNKNOWN;
      }

      if(session_truth_missing)
      {
         if(weak_recent_evidence)
         {
            ineligible_reason = tick_evidence.HasQuote
                                ? "live quote present but session windows missing"
                                : "recent quote timestamp present but session windows missing";
            return ASC_SESSION_NO_QUOTE;
         }

         string details = "market truth unresolved";
         if(StringLen(quote_probe.Issue) > 0)
            details += "; " + quote_probe.Issue;
         if(StringLen(trade_probe.Issue) > 0)
            details += "; " + trade_probe.Issue;
         ineligible_reason = details;
         return ASC_SESSION_UNKNOWN;
      }

      if(has_session_reference)
      {
         ineligible_reason = "session reference present but quote is not usable yet";
         return ASC_SESSION_NO_QUOTE;
      }

      ineligible_reason = "market truth unresolved: mixed session and quote evidence";
      return ASC_SESSION_UNKNOWN;
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

   ASC_Market_Internal::SortSymbols(symbols);
   ASC_Market_Internal::UniqueInPlace(symbols);

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
   ASC_Market_Internal::LoadIdentityMetadata(symbol, record.Identity);
   ASC_Market_Internal::ResolveClassification(symbol, record.Identity);

   if(StringLen(symbol) == 0)
   {
      record.MarketTruth.IneligibleReason = "symbol is empty";
      return false;
   }

   bool is_custom_symbol = false;
   record.MarketTruth.Exists = SymbolExist(symbol, is_custom_symbol);
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
   ASC_Market_Internal::SessionWindowProbe quote_probe;
   ASC_Market_Internal::SessionWindowProbe trade_probe;
   ASC_Market_Internal::WeeklySessionSchedule weekly_schedule;
   ASC_Market_Internal::TickEvidence tick_evidence;
   const datetime current_time = ASC_Market_Internal::CurrentServerTime();

   const bool selected_ok = ASC_Market_Internal::LoadFlag(symbol, SYMBOL_SELECT, selected, "selected", read_reason);
   const bool visible_ok = ASC_Market_Internal::LoadFlag(symbol, SYMBOL_VISIBLE, visible, "visible", read_reason);
   const bool trade_mode_ok = ASC_Market_Internal::LoadInteger(symbol, SYMBOL_TRADE_MODE, trade_mode, "trade_mode", read_reason);
   const bool quote_time_ok = ASC_Market_Internal::LoadTickTime(symbol, last_quote_time, read_reason);
   ASC_Market_Internal::ProbeSessionWindow(symbol, true, quote_probe);
   ASC_Market_Internal::ProbeSessionWindow(symbol, false, trade_probe);
   ASC_Market_Internal::LoadWeeklySessionSchedule(symbol, weekly_schedule);
   ASC_Market_Internal::LoadTickEvidence(symbol, current_time, tick_evidence);
   const bool has_session_reference = ASC_Market_Internal::HasSessionReference(symbol);

   record.MarketTruth.Selected              = selected;
   record.MarketTruth.Visible               = visible;
   record.MarketTruth.QuoteWindowOpen       = quote_probe.IsOpen;
   record.MarketTruth.TradeWindowOpen       = trade_probe.IsOpen;
   record.MarketTruth.LastQuoteTime         = tick_evidence.HasTimestamp ? tick_evidence.QuoteTime : last_quote_time;
   record.MarketTruth.HasUsableQuote        = tick_evidence.HasQuote;
   record.MarketTruth.QuoteFresh            = (ASC_Market_Internal::ResolveQuoteFreshnessStatus(tick_evidence, config.StaleFeedSeconds) == "FRESH");
   record.MarketTruth.QuoteAgeSeconds       = tick_evidence.AgeSeconds;
   record.MarketTruth.QuoteFreshnessStatus  = ASC_Market_Internal::ResolveQuoteFreshnessStatus(tick_evidence, config.StaleFeedSeconds);
   record.MarketTruth.QuoteScheduleReadable = weekly_schedule.QuoteReadable;
   record.MarketTruth.TradeScheduleReadable = weekly_schedule.TradeReadable;
   record.MarketTruth.QuoteScheduleSunday   = weekly_schedule.QuoteSunday;
   record.MarketTruth.QuoteScheduleMonday   = weekly_schedule.QuoteMonday;
   record.MarketTruth.QuoteScheduleTuesday  = weekly_schedule.QuoteTuesday;
   record.MarketTruth.QuoteScheduleWednesday = weekly_schedule.QuoteWednesday;
   record.MarketTruth.QuoteScheduleThursday = weekly_schedule.QuoteThursday;
   record.MarketTruth.QuoteScheduleFriday   = weekly_schedule.QuoteFriday;
   record.MarketTruth.QuoteScheduleSaturday = weekly_schedule.QuoteSaturday;
   record.MarketTruth.TradeScheduleSunday   = weekly_schedule.TradeSunday;
   record.MarketTruth.TradeScheduleMonday   = weekly_schedule.TradeMonday;
   record.MarketTruth.TradeScheduleTuesday  = weekly_schedule.TradeTuesday;
   record.MarketTruth.TradeScheduleWednesday = weekly_schedule.TradeWednesday;
   record.MarketTruth.TradeScheduleThursday = weekly_schedule.TradeThursday;
   record.MarketTruth.TradeScheduleFriday   = weekly_schedule.TradeFriday;
   record.MarketTruth.TradeScheduleSaturday = weekly_schedule.TradeSaturday;
   record.MarketTruth.SessionReadStatus     = (weekly_schedule.QuoteReadable && weekly_schedule.TradeReadable) ? "FULL" : ((weekly_schedule.QuoteReadable || weekly_schedule.TradeReadable) ? "PARTIAL" : "UNREADABLE");

   if(trade_mode_ok)
      record.MarketTruth.TradeAllowed = ASC_Market_Internal::TradeModePermitsNewExposure(trade_mode);

   if(!(selected_ok && visible_ok && trade_mode_ok))
   {
      record.MarketTruth.SessionTruthStatus = ASC_SESSION_UNKNOWN;
      record.MarketTruth.Layer1Eligible = false;
      record.MarketTruth.SessionReadReason = read_reason;
      record.MarketTruth.SessionConsistencyReason = read_reason;
      record.MarketTruth.IneligibleReason = read_reason;
      return true;
   }

   if(!quote_time_ok && !tick_evidence.HasTimestamp)
      ASC_Market_Internal::AppendReason(read_reason, "no broker quote timestamp");
   if(StringLen(quote_probe.Issue) > 0)
      ASC_Market_Internal::AppendReason(read_reason, quote_probe.Issue);
   if(StringLen(trade_probe.Issue) > 0)
      ASC_Market_Internal::AppendReason(read_reason, trade_probe.Issue);

   string ineligible_reason = "";
   record.MarketTruth.SessionTruthStatus = ASC_Market_Internal::ResolveSessionStatus(config,
                                                                                      record.Identity.AssetClass,
                                                                                      quote_probe,
                                                                                      trade_probe,
                                                                                      record.MarketTruth.TradeAllowed,
                                                                                      record.MarketTruth.LastQuoteTime,
                                                                                      tick_evidence,
                                                                                      has_session_reference,
                                                                                      ineligible_reason);

   record.MarketTruth.Layer1Eligible = (record.MarketTruth.SessionTruthStatus == ASC_SESSION_OPEN_TRADABLE);
   record.MarketTruth.NextRecheckTime = ASC_Market_Internal::ResolveNextRecheckTime(config,
                                                                                     record.MarketTruth.SessionTruthStatus);
   record.MarketTruth.SessionReadReason = (StringLen(read_reason) > 0 ? read_reason : "session inputs readable");
   record.MarketTruth.SessionConsistencyReason = (record.MarketTruth.Layer1Eligible ? "schedule and live quote evidence agree" : ineligible_reason);
   record.MarketTruth.IneligibleReason = record.MarketTruth.Layer1Eligible ? "" : ineligible_reason;

   return true;
}

#endif
