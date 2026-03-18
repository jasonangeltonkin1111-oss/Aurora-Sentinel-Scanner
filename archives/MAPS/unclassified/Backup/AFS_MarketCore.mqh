//+------------------------------------------------------------------+
//|                                                   AFS_MarketCore |
//|              Aegis Forge Scanner - Phase 1 / Step 6             |
//+------------------------------------------------------------------+
#ifndef __AFS_MARKETCORE_MQH__
#define __AFS_MARKETCORE_MQH__

#include "AFS_CoreTypes.mqh"

void AFS_MC_ResetSurfaceState(AFS_UniverseSymbol &rec)
  {
   rec.SurfaceSeen         = false;
   rec.QuotePresent        = false;
   rec.PromotionCandidate  = false;
   rec.LastTickTime        = 0;
   rec.LastSurfaceUpdateAt = 0;
   rec.TickAgeSec          = -1;
   rec.SurfaceUpdateCount  = 0;
   rec.Bid                 = 0.0;
   rec.Ask                 = 0.0;
   rec.SpreadSnapshot      = 0.0;
   rec.SessionHigh         = 0.0;
   rec.SessionLow          = 0.0;
   rec.SessionOpen         = 0.0;
   rec.SessionClose        = 0.0;
   rec.BidHigh             = 0.0;
   rec.BidLow              = 0.0;
   rec.AskHigh             = 0.0;
   rec.AskLow              = 0.0;
   rec.DailyChangePercent  = 0.0;
   rec.SpreadSampleWritePos = 0;
   rec.SpreadSampleCount    = 0;
   ArrayInitialize(rec.SpreadSampleRing, 0.0);
   ArrayInitialize(rec.SpreadSampleTimeRing, 0);
   rec.QuoteState          = "UNSCANNED";
   rec.SessionState        = "UNSCANNED";
   rec.SurfaceFlags        = "UNSCANNED";
   rec.PromotionState      = "NONE";
   rec.PromotionReason     = "";
  }

void AFS_MC_ResetSpecState(AFS_UniverseSymbol &rec)
  {
   rec.LastSpecUpdateAt    = 0;
   rec.SpecUpdateCount     = 0;
   rec.TickValueRaw        = 0.0;
   rec.TickValueDerived    = 0.0;
   rec.TickValueValidated  = 0.0;
   rec.MarginHedged        = 0.0;
   rec.CommissionValue     = 0.0;
   rec.CommissionMode      = "";
   rec.CommissionCurrency  = "";
   rec.CommissionStatus    = "UNREAD";
   rec.SpecIntegrityStatus = "UNSCANNED";
   rec.EconomicsTrust      = "UNSCANNED";
   rec.NormalizationStatus = "NORMALIZATION_NOT_REQUIRED";
   rec.PracticalityStatus  = "UNKNOWN";
   rec.EconomicsFlags      = "";
  }

bool AFS_MC_IsFinitePositive(const double value)
  {
   return (value > 0.0 && MathIsValidNumber(value));
  }

double AFS_MC_AbsRatioGap(const double a,const double b)
  {
   if(a <= 0.0 || b <= 0.0)
      return 0.0;
   double hi = MathMax(a, b);
   if(hi <= 0.0)
      return 0.0;
   return MathAbs(a - b) / hi;
  }

bool AFS_MC_TryValidateTickValue(const AFS_UniverseSymbol &rec,double &validated_value)
  {
   validated_value = 0.0;

   if(!rec.TradeAllowed || rec.TickSize <= 0.0 || rec.VolumeMin <= 0.0)
      return false;

   MqlTick tick;
   if(!SymbolInfoTick(rec.Symbol, tick))
      return false;

   double volume = rec.VolumeMin;
   double profit = 0.0;

   if(tick.ask > 0.0)
     {
      ResetLastError();
      if(OrderCalcProfit(ORDER_TYPE_BUY,
                         rec.Symbol,
                         volume,
                         tick.ask,
                         tick.ask + rec.TickSize,
                         profit))
        {
         validated_value = MathAbs(profit) / volume;
         if(validated_value > 0.0)
            return true;
        }
     }

   if(tick.bid > 0.0)
     {
      ResetLastError();
      if(OrderCalcProfit(ORDER_TYPE_SELL,
                         rec.Symbol,
                         volume,
                         tick.bid,
                         tick.bid - rec.TickSize,
                         profit))
        {
         validated_value = MathAbs(profit) / volume;
         if(validated_value > 0.0)
            return true;
        }
     }

   return false;
  }

bool AFS_MC_RefreshSpecRecord(AFS_UniverseSymbol &rec,const datetime now,string &detail)
  {
   detail = "";
   string flags = "";

   AFS_UniverseSymbol staged = rec;

   staged.Digits          = (int)SymbolInfoInteger(rec.Symbol, SYMBOL_DIGITS);
   staged.TradeMode       = (int)SymbolInfoInteger(rec.Symbol, SYMBOL_TRADE_MODE);
   staged.CalcMode        = (int)SymbolInfoInteger(rec.Symbol, SYMBOL_TRADE_CALC_MODE);
   staged.Point           = SymbolInfoDouble(rec.Symbol, SYMBOL_POINT);
   staged.TickSize        = SymbolInfoDouble(rec.Symbol, SYMBOL_TRADE_TICK_SIZE);
   staged.TickValue       = SymbolInfoDouble(rec.Symbol, SYMBOL_TRADE_TICK_VALUE);
   staged.TickValueProfit = SymbolInfoDouble(rec.Symbol, SYMBOL_TRADE_TICK_VALUE_PROFIT);
   staged.TickValueLoss   = SymbolInfoDouble(rec.Symbol, SYMBOL_TRADE_TICK_VALUE_LOSS);
   staged.ContractSize    = SymbolInfoDouble(rec.Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
   staged.VolumeMin       = SymbolInfoDouble(rec.Symbol, SYMBOL_VOLUME_MIN);
   staged.VolumeMax       = SymbolInfoDouble(rec.Symbol, SYMBOL_VOLUME_MAX);
   staged.VolumeStep      = SymbolInfoDouble(rec.Symbol, SYMBOL_VOLUME_STEP);
   staged.VolumeLimit     = SymbolInfoDouble(rec.Symbol, SYMBOL_VOLUME_LIMIT);
   staged.MarginHedged    = SymbolInfoDouble(rec.Symbol, SYMBOL_MARGIN_HEDGED);
   staged.CurrencyProfit  = SymbolInfoString(rec.Symbol, SYMBOL_CURRENCY_PROFIT);
   staged.CurrencyMargin  = SymbolInfoString(rec.Symbol, SYMBOL_CURRENCY_MARGIN);

   staged.TickValueRaw       = staged.TickValue;
   staged.TickValueDerived   = 0.0;
   staged.TickValueValidated = 0.0;

   if(AFS_MC_IsFinitePositive(staged.TickValueProfit) && AFS_MC_IsFinitePositive(staged.TickValueLoss))
      staged.TickValueDerived = (staged.TickValueProfit + staged.TickValueLoss) * 0.5;
   else if(AFS_MC_IsFinitePositive(staged.TickValueProfit))
      staged.TickValueDerived = staged.TickValueProfit;
   else if(AFS_MC_IsFinitePositive(staged.TickValueLoss))
      staged.TickValueDerived = staged.TickValueLoss;
   else if(AFS_MC_IsFinitePositive(staged.TickValueRaw))
      staged.TickValueDerived = staged.TickValueRaw;

   bool have_validated_tick = AFS_MC_TryValidateTickValue(staged, staged.TickValueValidated);

   staged.CommissionValue    = 0.0;
   staged.CommissionMode     = "";
   staged.CommissionCurrency = staged.CurrencyProfit;
   staged.CommissionStatus   = "UNREAD";

#ifdef SYMBOL_TRADE_COMMISSION
   ResetLastError();
   staged.CommissionValue = SymbolInfoDouble(rec.Symbol, SYMBOL_TRADE_COMMISSION);
   if(GetLastError() == 0)
      staged.CommissionStatus = (MathIsValidNumber(staged.CommissionValue) ? "READ" : "MISSING");
   else
      staged.CommissionStatus = "UNAVAILABLE";
#endif

#ifdef SYMBOL_TRADE_COMMISSION_TYPE
   long commission_mode = -1;
   ResetLastError();
   commission_mode = SymbolInfoInteger(rec.Symbol, SYMBOL_TRADE_COMMISSION_TYPE);
   if(GetLastError() == 0)
      staged.CommissionMode = IntegerToString((int)commission_mode);
#endif

   bool spec_broken     = false;
   bool spec_suspicious = false;

   if(!AFS_MC_IsFinitePositive(staged.Point))
     {
      spec_broken = true;
      flags = AFS_MC_AddFlag(flags, "POINT_BAD");
     }

   if(!AFS_MC_IsFinitePositive(staged.TickSize))
     {
      spec_broken = true;
      flags = AFS_MC_AddFlag(flags, "TICKSIZE_BAD");
     }

   if(!AFS_MC_IsFinitePositive(staged.ContractSize))
     {
      spec_suspicious = true;
      flags = AFS_MC_AddFlag(flags, "CONTRACT_BAD");
     }

   if(!AFS_MC_IsFinitePositive(staged.VolumeMin) ||
      !AFS_MC_IsFinitePositive(staged.VolumeStep) ||
      staged.VolumeMax < staged.VolumeMin)
     {
      spec_broken = true;
      flags = AFS_MC_AddFlag(flags, "VOLUME_BAD");
     }

   if(staged.CalcMode < 0)
     {
      spec_broken = true;
      flags = AFS_MC_AddFlag(flags, "CALCMODE_BAD");
     }

   if(!AFS_MC_IsFinitePositive(staged.TickValueRaw) &&
      !AFS_MC_IsFinitePositive(staged.TickValueDerived) &&
      !have_validated_tick)
     {
      spec_suspicious = true;
      flags = AFS_MC_AddFlag(flags, "TICKVALUE_MISSING");
     }

   if(have_validated_tick && AFS_MC_IsFinitePositive(staged.TickValueRaw))
     {
      double gap = AFS_MC_AbsRatioGap(staged.TickValueRaw, staged.TickValueValidated);
      if(gap > 0.50)
        {
         spec_suspicious = true;
         flags = AFS_MC_AddFlag(flags, "TICKVALUE_MISMATCH");
        }
     }

   if(!have_validated_tick)
      flags = AFS_MC_AddFlag(flags, "VALIDATION_THIN");

   if(!staged.ClassificationResolved)
      flags = AFS_MC_AddFlag(flags, "NORMALIZATION_FAIL");
   else if(StringLen(staged.AliasKind) > 0)
      flags = AFS_MC_AddFlag(flags, "NORMALIZATION_PARTIAL");

   if(spec_broken)
      staged.SpecIntegrityStatus = "SPEC_BROKEN";
   else if(spec_suspicious)
      staged.SpecIntegrityStatus = "SPEC_SUSPICIOUS";
   else
      staged.SpecIntegrityStatus = "SPEC_OK";

   if(!staged.ClassificationResolved)
      staged.NormalizationStatus = "NORMALIZATION_FAIL";
   else if(StringLen(staged.AliasKind) > 0)
      staged.NormalizationStatus = "NORMALIZATION_PARTIAL";
   else
      staged.NormalizationStatus = "NORMALIZATION_OK";

   if(staged.VolumeMin > 1.0 || staged.VolumeStep > 0.10)
      staged.PracticalityStatus = "AWKWARD";
   else if(staged.VolumeMin > 0.0 && staged.VolumeStep > 0.0)
      staged.PracticalityStatus = "PRACTICAL";
   else
      staged.PracticalityStatus = "IMPRACTICAL";

   if(staged.SpecIntegrityStatus == "SPEC_BROKEN")
      staged.EconomicsTrust = "FAIL";
   else if(staged.SpecIntegrityStatus == "SPEC_SUSPICIOUS")
      staged.EconomicsTrust = "WEAK";
   else
      staged.EconomicsTrust = "PASS";

   if(StringLen(flags) == 0)
      flags = "OK";

   staged.EconomicsFlags = flags;

   bool preserve_previous = false;
   if(rec.SpecUpdateCount > 0)
     {
      bool old_good = (rec.SpecIntegrityStatus == "SPEC_OK" || rec.SpecIntegrityStatus == "SPEC_SUSPICIOUS");
      bool new_broken = (staged.SpecIntegrityStatus == "SPEC_BROKEN");

      if(old_good && new_broken)
         preserve_previous = true;
     }

   if(preserve_previous)
     {
      rec.EconomicsFlags = AFS_MC_AddFlag(rec.EconomicsFlags, "CARRY_FORWARD");
      detail = "CARRY_FORWARD|" + rec.SpecIntegrityStatus + "|" + rec.EconomicsTrust + "|" + rec.EconomicsFlags;
      return true;
     }

   staged.LastSpecUpdateAt = now;
   staged.SpecUpdateCount  = rec.SpecUpdateCount + 1;

   rec = staged;

   detail = rec.SpecIntegrityStatus + "|" + rec.EconomicsTrust + "|" + rec.EconomicsFlags;
   return true;
  }

string AFS_MC_GetPromotionState(const AFS_UniverseSymbol &rec)
  {
   if(!rec.TradeAllowed)
      return "BLOCKED";
   if(!rec.ScopeIncluded)
      return "OUT_OF_SCOPE";
   if(!rec.ClassificationResolved)
      return "REVIEW";
   if(!rec.QuotePresent)
      return "NO_QUOTE";
   if(rec.TickAgeSec < 0)
      return "UNKNOWN";
   if(rec.TickAgeSec > 0 && rec.TickAgeSec <= 60)
      return "FRESH";
   if(rec.TickAgeSec <= 120)
      return "VERIFY";
   return "STALE";
  }

string AFS_MC_AddFlag(const string base_value,const string add_value)
  {
   if(StringLen(add_value) == 0)
      return base_value;
   if(StringLen(base_value) == 0)
      return add_value;
   return base_value + "|" + add_value;
  }

double AFS_MC_SafeDouble(const string symbol,const ENUM_SYMBOL_INFO_DOUBLE prop)
  {
   ResetLastError();
   double value = SymbolInfoDouble(symbol, prop);
   if(GetLastError() != 0)
      return 0.0;
   return value;
  }

string AFS_MC_GetQuoteState(const AFS_UniverseSymbol &rec)
  {
   if(!rec.TradeAllowed)
      return "TRADE_BLOCKED";
   if(!rec.QuotePresent)
      return "NO_QUOTE";
   if(rec.TickAgeSec < 0)
      return "UNKNOWN";
   if(rec.TickAgeSec <= 60)
      return "FRESH";
   if(rec.TickAgeSec <= 300)
      return "THIN";
   return "STALE";
  }

string AFS_MC_GetSessionState(const AFS_UniverseSymbol &rec)
  {
   if(!rec.TradeAllowed)
      return "TRADE_BLOCKED";

   bool has_session_ref = (rec.SessionOpen > 0.0 || rec.SessionClose > 0.0 ||
                           rec.SessionHigh > 0.0 || rec.SessionLow > 0.0);

   if(rec.QuotePresent && rec.TickAgeSec >= 0 && rec.TickAgeSec <= 60)
      return has_session_ref ? "ACTIVE" : "ACTIVE_NOREF";
   if(rec.QuotePresent && rec.TickAgeSec >= 0 && rec.TickAgeSec <= 300)
      return has_session_ref ? "QUIET" : "QUIET_NOREF";
   if(has_session_ref && rec.TickAgeSec < 0)
      return "SESSION_REF_NO_QUOTE";
   if(has_session_ref)
      return "SESSION_REF_STALE";
   return "UNKNOWN";
  }

void AFS_MC_RecordSpreadSample(AFS_UniverseSymbol &rec,const datetime now)
  {
   if(rec.SpreadSnapshot <= 0.0 || !MathIsValidNumber(rec.SpreadSnapshot))
      return;
   if(rec.Point <= 0.0 || !rec.QuotePresent)
      return;

   int slot = rec.SpreadSampleWritePos;
   if(slot < 0 || slot >= AFS_MAX_SPREAD_SAMPLES)
      slot = 0;

   rec.SpreadSampleRing[slot]     = rec.SpreadSnapshot;
   rec.SpreadSampleTimeRing[slot] = now;

   slot++;
   if(slot >= AFS_MAX_SPREAD_SAMPLES)
      slot = 0;

   rec.SpreadSampleWritePos = slot;
   if(rec.SpreadSampleCount < AFS_MAX_SPREAD_SAMPLES)
      rec.SpreadSampleCount++;
  }

string AFS_MC_GetPromotionReason(const AFS_UniverseSymbol &rec)
  {
   if(!rec.TradeAllowed)
      return "TRADE_BLOCKED";
   if(!rec.ScopeIncluded)
      return "OUT_OF_SCOPE";
   if(!rec.ClassificationResolved)
      return "CLASSIFICATION_REVIEW";
   if(!rec.QuotePresent)
      return "NO_QUOTE";
   if(rec.SurfaceUpdateCount <= 1 && rec.TickAgeSec >= 0 && rec.TickAgeSec <= 120)
      return "INITIAL_DISCOVERY";
   if(rec.TickAgeSec >= 0 && rec.TickAgeSec <= 60)
      return "FRESH_QUOTE";
   if(rec.TickAgeSec <= 120)
      return "VERIFY_THIN_QUOTE";
   return "VERIFY_STALE_QUOTE";
  }

bool AFS_MC_RefreshSurfaceRecord(AFS_UniverseSymbol &rec,const datetime now,string &detail)
  {
   detail = "";
   string flags = "";

   MqlTick tick;
   bool got_tick = SymbolInfoTick(rec.Symbol, tick);
   bool tick_has_time = (got_tick && (datetime)tick.time > 0);
   bool quote_usable  = (got_tick &&
                         tick_has_time &&
                         tick.bid > 0.0 &&
                         tick.ask > 0.0 &&
                         tick.ask >= tick.bid);

   rec.LastSurfaceUpdateAt = now;
   rec.SurfaceSeen         = true;
   rec.SurfaceUpdateCount++;
   rec.SurfaceFlags        = "";
   rec.PromotionCandidate  = false;
   rec.PromotionState      = "NONE";
   rec.PromotionReason     = "";

   if(got_tick)
     {
      rec.LastTickTime = (datetime)tick.time;
      rec.Bid          = tick.bid;
      rec.Ask          = tick.ask;
      rec.QuotePresent = quote_usable;

      if(rec.Point > 0.0 && rec.Ask > 0.0 && rec.Bid > 0.0 && rec.Ask >= rec.Bid)
         rec.SpreadSnapshot = (rec.Ask - rec.Bid) / rec.Point;
      else
         rec.SpreadSnapshot = 0.0;

      if(rec.QuotePresent)
         AFS_MC_RecordSpreadSample(rec, now);
      else
        {
         flags = AFS_MC_AddFlag(flags, "NO_USABLE_QUOTE");
         if(!tick_has_time)
            flags = AFS_MC_AddFlag(flags, "TICK_TIME_UNKNOWN");
        }
     }
   else
     {
      rec.QuotePresent    = false;
      rec.LastTickTime    = 0;
      rec.Bid             = 0.0;
      rec.Ask             = 0.0;
      rec.SpreadSnapshot  = 0.0;
      flags               = AFS_MC_AddFlag(flags, "NO_TICK");
     }

   if(rec.LastTickTime > 0)
      rec.TickAgeSec = (int)MathMax(0, (long)(now - rec.LastTickTime));
   else
      rec.TickAgeSec = -1;

   rec.SessionOpen  = AFS_MC_SafeDouble(rec.Symbol, SYMBOL_SESSION_OPEN);
   rec.SessionClose = AFS_MC_SafeDouble(rec.Symbol, SYMBOL_SESSION_CLOSE);
   rec.BidHigh      = AFS_MC_SafeDouble(rec.Symbol, SYMBOL_BIDHIGH);
   rec.BidLow       = AFS_MC_SafeDouble(rec.Symbol, SYMBOL_BIDLOW);
   rec.AskHigh      = AFS_MC_SafeDouble(rec.Symbol, SYMBOL_ASKHIGH);
   rec.AskLow       = AFS_MC_SafeDouble(rec.Symbol, SYMBOL_ASKLOW);

   rec.SessionHigh = MathMax(rec.BidHigh, rec.AskHigh);
   rec.SessionLow  = 0.0;

   if(rec.BidLow > 0.0 && rec.AskLow > 0.0)
      rec.SessionLow = MathMin(rec.BidLow, rec.AskLow);
   else if(rec.BidLow > 0.0)
      rec.SessionLow = rec.BidLow;
   else if(rec.AskLow > 0.0)
      rec.SessionLow = rec.AskLow;

   rec.DailyChangePercent = 0.0;
   if(rec.SessionOpen > 0.0)
     {
      double anchor = (rec.QuotePresent && rec.Bid > 0.0) ? rec.Bid : rec.SessionClose;
      if(anchor > 0.0)
         rec.DailyChangePercent = ((anchor - rec.SessionOpen) / rec.SessionOpen) * 100.0;
     }

   if(!rec.ClassificationResolved)
      flags = AFS_MC_AddFlag(flags, "UNCLASSIFIED");
   if(!rec.TradeAllowed)
      flags = AFS_MC_AddFlag(flags, "TRADE_BLOCKED");
   if(!rec.ScopeIncluded)
      flags = AFS_MC_AddFlag(flags, "OUT_OF_SCOPE");
   if(rec.QuotePresent && rec.TickAgeSec > 60)
      flags = AFS_MC_AddFlag(flags, "STALE_TICK");
   if(rec.QuotePresent && rec.TickAgeSec > 60 && rec.TickAgeSec <= 300)
      flags = AFS_MC_AddFlag(flags, "THIN_TICK");
   if(!rec.QuotePresent && rec.Exists)
      flags = AFS_MC_AddFlag(flags, "NO_QUOTE");
   if((rec.SessionHigh > 0.0 || rec.SessionLow > 0.0 || rec.SessionOpen > 0.0 || rec.SessionClose > 0.0))
      flags = AFS_MC_AddFlag(flags, "SESSION_REF");
   if(rec.SurfaceUpdateCount <= 1)
      flags = AFS_MC_AddFlag(flags, "FIRST_SEEN");

   rec.QuoteState     = AFS_MC_GetQuoteState(rec);
   rec.SessionState   = AFS_MC_GetSessionState(rec);
   rec.PromotionState = AFS_MC_GetPromotionState(rec);
   rec.PromotionReason = AFS_MC_GetPromotionReason(rec);

   if(rec.ScopeIncluded && rec.TradeAllowed && rec.ClassificationResolved && rec.QuotePresent)
     {
      if(rec.TickAgeSec >= 0 && rec.TickAgeSec <= 120)
         rec.PromotionCandidate = true;
     }

   if(StringLen(flags) == 0)
      flags = "OK";

   rec.SurfaceFlags = flags;
   detail = flags + "|Quote=" + rec.QuoteState + "|Session=" + rec.SessionState + "|Promotion=" + rec.PromotionState;
   return true;
  }

#endif
