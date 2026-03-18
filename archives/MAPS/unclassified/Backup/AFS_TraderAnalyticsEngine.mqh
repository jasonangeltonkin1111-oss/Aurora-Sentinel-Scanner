#ifndef __AFS_TRADER_ANALYTICS_ENGINE_MQH__
#define __AFS_TRADER_ANALYTICS_ENGINE_MQH__

//==================================================================
// AFS PREPARED / EFFECTIVE ANALYTICS LAYER
//==================================================================
// DOWNSTREAM-ONLY ZONE.
// This file may derive prepared/effective publication truth, but it
// must not mutate raw scanner truth, Step 8/9/10 semantics, startup
// order, or warm-state contracts.
//
// SAFE HERE:
// - effective value resolution
// - source labels
// - guarded fallback selection
// - dossier/summary readiness packaging
//
// NOT SAFE HERE:
// - repurposing raw fields on AFS_UniverseSymbol
// - changing selection/correlation meaning
// - hiding unavailable values as fake 0.00
//==================================================================

struct AFS_TraderAnalytics
  {
   bool     Ready;
   bool     HeavyRequested;

   int      BarsM1;
   int      BarsM5;
   int      BarsM15;
   int      BarsH1;
   int      BarsH4;
   int      BarsD1;
   int      BarsW1;

   string   CoverageStateM1;
   string   CoverageStateM5;
   string   CoverageStateM15;
   string   CoverageStateH1;
   string   CoverageStateH4;
   string   CoverageStateD1;
   string   CoverageStateW1;

   bool     HasAtrM5;
   bool     HasAtrM15;
   bool     HasAtrH1;
   bool     HasAtrH4;
   bool     HasAtrD1;
   double   AtrM5;
   double   AtrM15;
   double   AtrH1;
   double   AtrH4;
   double   AtrD1;

   bool     HasExpectedMoveM15;
   bool     HasExpectedMoveH1;
   bool     HasExpectedMoveH4;
   bool     HasExpectedMoveD1;
   double   ExpectedMoveM15;
   double   ExpectedMoveH1;
   double   ExpectedMoveH4;
   double   ExpectedMoveD1;

   bool     HasTrendStrengthM15;
   bool     HasTrendStrengthH1;
   double   TrendStrengthM15;
   double   TrendStrengthH1;
   string   HTFTrend;
   string   VolatilityRegime;
   double   RangePositionDaily;
   double   RangePositionWeekly;

   bool     HasAtrEfficiency;
   bool     HasSpreadToAtr;
   bool     HasHistoryCompleteness;
   bool     HasDataIntegrityScore;
   double   AtrEfficiency;
   double   SpreadToAtr;
   double   HistoryCompleteness;
   double   DataIntegrityScore;

   string   HistoryState;
   string   AtrState;
   string   TrendState;
   string   QualityState;
   string   HTFReadiness;
   string   HistoryDepthStatus;
   string   HTFDeferredReason;
   string   DeferredReasons;

   string   TacticalReadiness;
   string   TacticalContextStatus;
   string   TacticalLightState;
   string   TacticalMediumState;
   string   TacticalHeavyState;
   string   TacticalDeferredReason;
   string   ExecutionQualityState;
   string   SpreadBand;
   string   FreshnessBand;
   string   MovementBand;
   string   IntradayBias;
   string   TacticalM1Summary;
   string   TacticalM5Summary;

   bool     HasEffectiveAtrM15;
   bool     HasEffectiveAtrH1;
   double   EffectiveAtrM15;
   double   EffectiveAtrH1;
   string   AtrM15Source;
   string   AtrH1Source;
   string   TradeEligibility;
   string   ExecutionPermission;
   string   EligibilityReasons;
   double   ExecutionQualityScore;
   int      DisplayHydrationScore;
   string   DisplayHydrationStage;

   bool     HasRecentSpreadStats;
   double   RecentSpreadMinPrice;
   double   RecentSpreadAvgPrice;
   double   RecentSpreadMaxPrice;

   bool     HasRecentMoveM1;
   bool     HasRecentMoveM5;
   double   RecentMoveM1;
   double   RecentMoveM5;
   double   RangePositionM1;
   double   RangePositionM5;
  };

void AFS_TA_Reset(AFS_TraderAnalytics &ta)
  {
   ta.Ready                  = false;
   ta.HeavyRequested         = false;

   ta.BarsM1                 = -1;
   ta.BarsM5                 = -1;
   ta.BarsM15                = -1;
   ta.BarsH1                 = -1;
   ta.BarsH4                 = -1;
   ta.BarsD1                 = -1;
   ta.BarsW1                 = -1;

   ta.CoverageStateM1        = "PENDING";
   ta.CoverageStateM5        = "PENDING";
   ta.CoverageStateM15       = "PENDING";
   ta.CoverageStateH1        = "PENDING";
   ta.CoverageStateH4        = "PENDING";
   ta.CoverageStateD1        = "PENDING";
   ta.CoverageStateW1        = "PENDING";

   ta.HasAtrM5               = false;
   ta.HasAtrM15              = false;
   ta.HasAtrH1               = false;
   ta.HasAtrH4               = false;
   ta.HasAtrD1               = false;
   ta.AtrM5                  = 0.0;
   ta.AtrM15                 = 0.0;
   ta.AtrH1                  = 0.0;
   ta.AtrH4                  = 0.0;
   ta.AtrD1                  = 0.0;

   ta.HasExpectedMoveM15     = false;
   ta.HasExpectedMoveH1      = false;
   ta.HasExpectedMoveH4      = false;
   ta.HasExpectedMoveD1      = false;
   ta.ExpectedMoveM15        = 0.0;
   ta.ExpectedMoveH1         = 0.0;
   ta.ExpectedMoveH4         = 0.0;
   ta.ExpectedMoveD1         = 0.0;

   ta.HasTrendStrengthM15    = false;
   ta.HasTrendStrengthH1     = false;
   ta.TrendStrengthM15       = 0.0;
   ta.TrendStrengthH1        = 0.0;
   ta.HTFTrend               = "PENDING";
   ta.VolatilityRegime       = "PENDING";
   ta.RangePositionDaily     = -1.0;
   ta.RangePositionWeekly    = -1.0;

   ta.HasAtrEfficiency       = false;
   ta.HasSpreadToAtr         = false;
   ta.HasHistoryCompleteness = false;
   ta.HasDataIntegrityScore  = false;
   ta.AtrEfficiency          = 0.0;
   ta.SpreadToAtr            = 0.0;
   ta.HistoryCompleteness    = 0.0;
   ta.DataIntegrityScore     = 0.0;

   ta.HistoryState           = "PENDING";
   ta.AtrState               = "PENDING";
   ta.TrendState             = "PENDING";
   ta.QualityState           = "PENDING";
   ta.HTFReadiness           = "PENDING";
   ta.HistoryDepthStatus     = "PENDING";
   ta.HTFDeferredReason      = "";
   ta.DeferredReasons        = "";

   ta.TacticalReadiness      = "PENDING";
   ta.TacticalContextStatus  = "PENDING";
   ta.TacticalLightState     = "PENDING";
   ta.TacticalMediumState    = "PENDING";
   ta.TacticalHeavyState     = "PENDING";
   ta.TacticalDeferredReason = "";
   ta.ExecutionQualityState  = "PENDING";
   ta.SpreadBand             = "PENDING";
   ta.FreshnessBand          = "PENDING";
   ta.MovementBand           = "PENDING";
   ta.IntradayBias           = "PENDING";
   ta.TacticalM1Summary      = "PENDING";
   ta.TacticalM5Summary      = "PENDING";

   ta.HasEffectiveAtrM15     = false;
   ta.HasEffectiveAtrH1      = false;
   ta.EffectiveAtrM15        = 0.0;
   ta.EffectiveAtrH1         = 0.0;
   ta.AtrM15Source           = "UNAVAILABLE";
   ta.AtrH1Source            = "UNAVAILABLE";
   ta.TradeEligibility       = "PENDING";
   ta.ExecutionPermission    = "PENDING";
   ta.EligibilityReasons     = "";
   ta.ExecutionQualityScore  = 0.0;
   ta.DisplayHydrationScore  = 0;
   ta.DisplayHydrationStage  = "PENDING";

   ta.HasRecentSpreadStats   = false;
   ta.RecentSpreadMinPrice   = 0.0;
   ta.RecentSpreadAvgPrice   = 0.0;
   ta.RecentSpreadMaxPrice   = 0.0;

   ta.HasRecentMoveM1        = false;
   ta.HasRecentMoveM5        = false;
   ta.RecentMoveM1           = 0.0;
   ta.RecentMoveM5           = 0.0;
   ta.RangePositionM1        = -1.0;
   ta.RangePositionM5        = -1.0;
  }

int AFS_TA_SafeBars(const string symbol,const ENUM_TIMEFRAMES tf)
  {
   ResetLastError();
   int bars = Bars(symbol, tf);
   if(bars <= 0)
      return -1;
   return bars;
  }

double AFS_TA_SafeATR(const string symbol,const ENUM_TIMEFRAMES tf,const int period)
  {
   ResetLastError();
   int handle = iATR(symbol, tf, period);
   if(handle == INVALID_HANDLE)
      return 0.0;

   double buf[];
   ArraySetAsSeries(buf, true);
   int copied = CopyBuffer(handle, 0, 0, 1, buf);
   IndicatorRelease(handle);

   if(copied < 1)
      return 0.0;
   if(!MathIsValidNumber(buf[0]) || buf[0] <= 0.0)
      return 0.0;
   return buf[0];
  }

double AFS_TA_SafeClose(const string symbol,const ENUM_TIMEFRAMES tf,const int shift)
  {
   ResetLastError();
   double value = iClose(symbol, tf, shift);
   if(!MathIsValidNumber(value) || value <= 0.0)
      return 0.0;
   return value;
  }

double AFS_TA_SafeHigh(const string symbol,const ENUM_TIMEFRAMES tf,const int shift)
  {
   ResetLastError();
   double value = iHigh(symbol, tf, shift);
   if(!MathIsValidNumber(value) || value <= 0.0)
      return 0.0;
   return value;
  }

double AFS_TA_SafeLow(const string symbol,const ENUM_TIMEFRAMES tf,const int shift)
  {
   ResetLastError();
   double value = iLow(symbol, tf, shift);
   if(!MathIsValidNumber(value) || value <= 0.0)
      return 0.0;
   return value;
  }

double AFS_TA_RangePosition(const double low,const double high,const double ref_price)
  {
   if(low <= 0.0 || high <= 0.0 || high <= low || ref_price <= 0.0)
      return -1.0;

   double pos = ((ref_price - low) / (high - low)) * 100.0;
   if(pos < 0.0)   pos = 0.0;
   if(pos > 100.0) pos = 100.0;
   return pos;
  }

double AFS_TA_TrendStrength(const double now_close,const double prior_close,const double atr_value)
  {
   if(now_close <= 0.0 || prior_close <= 0.0 || atr_value <= 0.0)
      return -1.0;

   double ratio = MathAbs(now_close - prior_close) / atr_value;
   double score = ratio * 100.0;
   if(score > 100.0)
      score = 100.0;
   return score;
  }

string AFS_TA_HTFTrendLabel(const double c_h4_now,const double c_h4_prev,const double c_d1_now,const double c_d1_prev)
  {
   bool h4_up = (c_h4_now > 0.0 && c_h4_prev > 0.0 && c_h4_now > c_h4_prev);
   bool h4_dn = (c_h4_now > 0.0 && c_h4_prev > 0.0 && c_h4_now < c_h4_prev);
   bool d1_up = (c_d1_now > 0.0 && c_d1_prev > 0.0 && c_d1_now > c_d1_prev);
   bool d1_dn = (c_d1_now > 0.0 && c_d1_prev > 0.0 && c_d1_now < c_d1_prev);

   if(h4_up && d1_up) return "UP";
   if(h4_dn && d1_dn) return "DOWN";
   if((h4_up && d1_dn) || (h4_dn && d1_up)) return "MIXED";
   if(h4_up || d1_up) return "UP_PARTIAL";
   if(h4_dn || d1_dn) return "DOWN_PARTIAL";
   return "PENDING";
  }

string AFS_TA_VolatilityRegimeLabel(const double atr_m15,const double atr_h1,const double atr_d1)
  {
   if(atr_m15 <= 0.0 || atr_h1 <= 0.0)
      return "PENDING";

   double ratio = atr_m15 / atr_h1;
   if(atr_d1 > 0.0)
      ratio = (ratio + (atr_h1 / atr_d1)) / 2.0;

   if(ratio >= 0.80) return "EXPANDING";
   if(ratio <= 0.35) return "COMPRESSED";
   return "BALANCED";
  }

void AFS_TA_AppendReason(string &dst,const string reason)
  {
   if(StringLen(reason) <= 0)
      return;
   if(StringLen(dst) > 0)
      dst += ",";
   dst += reason;
  }

string AFS_TA_CoverageState(const int bars,const int min_bars,const bool heavy_requested)
  {
   if(bars >= min_bars)
      return "READY";
   if(bars > 0)
      return "THIN";
   if(heavy_requested)
      return "PENDING_OR_UNAVAILABLE";
   return "DEFERRED";
  }

bool AFS_TA_BarsReady(const int bars,const int min_bars)
  {
   return (bars >= min_bars);
  }

double AFS_TA_SpreadPriceNow(const AFS_UniverseSymbol &rec)
  {
   if(rec.SpreadSnapshot <= 0.0)
      return 0.0;
   if(rec.Point > 0.0)
      return rec.SpreadSnapshot * rec.Point;
   return rec.SpreadSnapshot;
  }

double AFS_TA_AbsRatioGap(const double a,const double b)
  {
   if(a <= 0.0 || b <= 0.0)
      return 0.0;
   double hi = MathMax(a, b);
   if(hi <= 0.0)
      return 0.0;
   return MathAbs(a - b) / hi;
  }

bool AFS_TA_SelectTrustedTickValue(const AFS_UniverseSymbol &rec,
                                   double &trusted_tick_value,
                                   string &provenance,
                                   string &trust_state,
                                   bool &estimated)
  {
   trusted_tick_value = 0.0;
   provenance = "PENDING";
   trust_state = "PENDING_TRUSTED_TICK_VALUE";
   estimated = false;

   if(rec.TickValueValidated > 0.0)
     {
      trusted_tick_value = rec.TickValueValidated;
      provenance = "VALIDATED";
      trust_state = "VALIDATED_MONETARY_TICK";
      return true;
     }

   if(rec.TickValueDerived > 0.0)
     {
      trusted_tick_value = rec.TickValueDerived;
      provenance = "DERIVED";
      trust_state = "DERIVED_MONETARY_TICK";
      estimated = true;

      if(rec.TickValueRaw > 0.0)
        {
         double gap = AFS_TA_AbsRatioGap(rec.TickValueRaw, rec.TickValueDerived);
         if(gap <= 0.50)
            provenance = "DERIVED_BROKER_ALIGNED";
         else
            provenance = "DERIVED_BROKER_MISMATCH";
        }

      return true;
     }

   double broker_tick_value = (rec.TickValueRaw > 0.0 ? rec.TickValueRaw : rec.TickValue);
   if(broker_tick_value > 0.0)
     {
      trusted_tick_value = broker_tick_value;
      provenance = "ESTIMATED_BROKER";
      trust_state = "ESTIMATED_MONETARY_TICK";
      estimated = true;
      return true;
     }

   if(rec.TickValueProfit > 0.0 || rec.TickValueLoss > 0.0)
     {
      double sided = 0.0;
      if(rec.TickValueProfit > 0.0 && rec.TickValueLoss > 0.0)
         sided = (rec.TickValueProfit + rec.TickValueLoss) * 0.5;
      else if(rec.TickValueProfit > 0.0)
         sided = rec.TickValueProfit;
      else
         sided = rec.TickValueLoss;

      if(sided > 0.0)
        {
         trusted_tick_value = sided;
         provenance = "ESTIMATED_SIDE_SPEC";
         trust_state = "ESTIMATED_MONETARY_TICK";
         estimated = true;
         return true;
        }
     }

   return false;
  }


string AFS_TA_HTFReadinessState(const AFS_TraderAnalytics &ta,const bool include_heavy)
  {
   if(!include_heavy)
      return "DEFERRED";
   int ready = 0;
   int total = 3;
   if(ta.BarsH4 > 0 && ta.HasAtrH4) ready++;
   if(ta.BarsD1 > 0 && ta.HasAtrD1) ready++;
   if(ta.BarsW1 > 0) ready++;
   if(ready >= total)
      return "READY";
   if(ready > 0)
      return "PARTIAL";
   return "PENDING";
  }


double AFS_TA_SafeOpen(const string symbol,const ENUM_TIMEFRAMES tf,const int shift)
  {
   ResetLastError();
   double value = iOpen(symbol, tf, shift);
   if(!MathIsValidNumber(value) || value <= 0.0)
      return 0.0;
   return value;
  }

string AFS_TA_FreshnessBand(const int tick_age_sec,const bool quote_present)
  {
   if(!quote_present)
      return "QUOTE_PENDING";
   if(tick_age_sec < 0)
      return "PENDING";
   if(tick_age_sec <= 3)
      return "FRESH";
   if(tick_age_sec <= 15)
      return "OK";
   if(tick_age_sec <= 60)
      return "STALE";
   return "OLD";
  }

string AFS_TA_SpreadBand(const double spread_price_now,const double atr_m15)
  {
   if(spread_price_now <= 0.0)
      return "PENDING";
   if(atr_m15 <= 0.0)
      return "KNOWN_UNSCALED";
   double ratio_pct = (spread_price_now / atr_m15) * 100.0;
   if(ratio_pct <= 2.0)
      return "TIGHT";
   if(ratio_pct <= 5.0)
      return "NORMAL";
   if(ratio_pct <= 10.0)
      return "WIDE";
   return "VERY_WIDE";
  }

bool AFS_TA_LoadRates(const string symbol,const ENUM_TIMEFRAMES tf,const int want,MqlRates &rates[])
  {
   ArraySetAsSeries(rates, true);
   ResetLastError();
   int copied = CopyRates(symbol, tf, 0, want, rates);
   return (copied >= want);
  }

double AFS_TA_BoundedMove(const MqlRates &rates[],const int count)
  {
   if(count < 2)
      return 0.0;
   double newest = rates[0].close;
   double oldest = rates[count - 1].open;
   if(newest <= 0.0 || oldest <= 0.0)
      return 0.0;
   return MathAbs(newest - oldest);
  }

double AFS_TA_LocalRangePosition(const MqlRates &rates[],const int count)
  {
   if(count < 1)
      return -1.0;
   double hi = rates[0].high;
   double lo = rates[0].low;
   for(int i=1;i<count;i++)
     {
      if(rates[i].high > hi) hi = rates[i].high;
      if(rates[i].low < lo)  lo = rates[i].low;
     }
   return AFS_TA_RangePosition(lo, hi, rates[0].close);
  }

string AFS_TA_MovementBand(const double move_m1,const double atr_m15)
  {
   if(move_m1 <= 0.0)
      return "PENDING";
   if(atr_m15 <= 0.0)
      return "KNOWN_UNSCALED";
   double ratio_pct = (move_m1 / atr_m15) * 100.0;
   if(ratio_pct < 10.0)
      return "QUIET";
   if(ratio_pct < 35.0)
      return "BALANCED";
   if(ratio_pct < 70.0)
      return "ACTIVE";
   return "FAST";
  }

string AFS_TA_IntradayBias(const MqlRates &m5[],const int m5_count,const MqlRates &m15[],const int m15_count)
  {
   bool have_m5 = (m5_count >= 3);
   bool have_m15 = (m15_count >= 3);
   if(!have_m5 && !have_m15)
      return "PENDING";

   int votes_up = 0;
   int votes_dn = 0;

   if(have_m5)
     {
      if(m5[0].close > m5[m5_count - 1].open) votes_up++;
      if(m5[0].close < m5[m5_count - 1].open) votes_dn++;
     }
   if(have_m15)
     {
      if(m15[0].close > m15[m15_count - 1].open) votes_up++;
      if(m15[0].close < m15[m15_count - 1].open) votes_dn++;
     }

   if(votes_up >= 2) return "BULLISH";
   if(votes_dn >= 2) return "BEARISH";
   if(votes_up > votes_dn) return "BULLISH_LIGHT";
   if(votes_dn > votes_up) return "BEARISH_LIGHT";
   return "BALANCED";
  }

string AFS_TA_TacticalSummary(const string tf_label,const double move_value,const double range_pos,const string bias,const double atr_ref)
  {
   string move_state = "PENDING";
   if(move_value > 0.0)
     {
      if(atr_ref > 0.0)
        {
         double ratio_pct = (move_value / atr_ref) * 100.0;
         if(ratio_pct < 10.0) move_state = "COMPRESSED";
         else if(ratio_pct < 35.0) move_state = "BALANCED";
         else move_state = "EXPANDING";
        }
      else
         move_state = "KNOWN_UNSCALED";
     }

   string pos_state = "PENDING";
   if(range_pos >= 0.0)
     {
      if(range_pos >= 70.0) pos_state = "NEAR_HIGH";
      else if(range_pos <= 30.0) pos_state = "NEAR_LOW";
      else pos_state = "MID_RANGE";
     }

   return tf_label + ":" + bias + "|" + move_state + "|" + pos_state;
  }

string AFS_TA_ExecutionQualityState(const AFS_UniverseSymbol &rec,const string freshness_band,const string spread_band)
  {
   if(!rec.QuotePresent || rec.Bid <= 0.0 || rec.Ask <= 0.0 || rec.Ask < rec.Bid)
      return "INVALID";
   if(!rec.FrictionQuoteUsable)
      return "INVALID";
   if(rec.FrictionSampleCountUsed <= 0)
      return "UNTRUSTED";
   if(rec.FrictionStatus == "FAIL")
      return "BLOCKED";
   if(freshness_band == "OLD" || freshness_band == "STALE")
      return "CAUTION_STALE";
   if(spread_band == "VERY_WIDE")
      return "CAUTION_VERY_WIDE";
   if(spread_band == "WIDE")
      return "CAUTION_WIDE";
   if(rec.FrictionStatus == "WEAK")
      return "CAUTION_WEAK";
   if(freshness_band == "FRESH" && (spread_band == "TIGHT" || spread_band == "NORMAL"))
      return "GOOD";
   return "WORKABLE";
  }



int AFS_TA_MinExecutionSamplesForTrustedQuality()
  {
   return 1;
  }

double AFS_TA_MaxSpreadToAtrForAttentionPct()
  {
   return 35.0;
  }

double AFS_TA_EffectiveAtrValue(const double runtime_atr,const bool analytics_has_atr,const double analytics_atr,bool &has_value,string &source)
  {
   has_value = false;
   source = "UNAVAILABLE_TRUE";
   if(runtime_atr > 0.0)
     {
      has_value = true;
      source = "RUNTIME";
      return runtime_atr;
     }
   if(analytics_has_atr && analytics_atr > 0.0)
     {
      has_value = true;
      source = "ANALYTICS_FALLBACK";
      return analytics_atr;
     }
   return 0.0;
  }

double AFS_TA_DerivedExecutionQualityScore(const AFS_UniverseSymbol &rec,
                                           const double spread_to_atr_pct,
                                           const bool has_effective_atr)
  {
   if(!rec.QuotePresent || rec.Bid <= 0.0 || rec.Ask <= 0.0 || rec.Ask < rec.Bid)
      return 0.0;
   if(!rec.FrictionQuoteUsable)
      return 0.0;
   if(rec.FrictionSampleCountUsed <= 0)
      return 0.0;
   if(rec.FrictionStatus == "FAIL")
      return 0.0;
   if(!has_effective_atr)
      return 0.0;

   double live = rec.LivelinessScore;
   if(live < 0.0) live = 0.0;
   if(live > 100.0) live = 100.0;

   double fresh = rec.FreshnessScore;
   if(fresh < 0.0) fresh = 0.0;
   if(fresh > 100.0) fresh = 100.0;

   double spread_penalty = 100.0;
   if(spread_to_atr_pct > 0.0)
      spread_penalty = MathMin(100.0, spread_to_atr_pct);
   else
      spread_penalty = 100.0;

   double score = (live * 0.40) + (fresh * 0.40) + ((100.0 - spread_penalty) * 0.20);
   if(score < 0.0) score = 0.0;
   if(score > 100.0) score = 100.0;
   return score;
  }

string AFS_TA_DisplayHydrationStage(const AFS_UniverseSymbol &rec,int &display_score)
  {
   display_score = rec.FrictionHydrationScore;
   if(display_score < 0)
      display_score = 0;
   if(display_score > 100)
      display_score = 100;

   if(rec.FrictionSampleCountUsed <= 0)
     {
      display_score = 0;
      return "BUILDING";
     }

   if(rec.FrictionHoldPass)
      return "HELD";
   if(display_score >= 60)
      return "READY";
   if(display_score >= 20)
      return "BUILDING";
   return "COLD";
  }

string AFS_TA_EligibilityReasons(const AFS_UniverseSymbol &rec,
                                 const AFS_TraderAnalytics &ta,
                                 const bool history_ready)
  {
   string reasons = "";
   if(!rec.QuotePresent || rec.Bid <= 0.0 || rec.Ask <= 0.0 || rec.Ask < rec.Bid)
      reasons = "QUOTE_UNUSABLE";
   if(!rec.FrictionQuoteUsable)
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "FRICTION_QUOTE_UNUSABLE";
     }
   if(!ta.HasEffectiveAtrM15)
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "ATR_UNAVAILABLE";
     }
   if(rec.FrictionSampleCountUsed <= 0)
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "NO_EXECUTION_SAMPLES";
     }
   if(!history_ready)
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "HISTORY_INCOMPLETE";
     }
   if(ta.DisplayHydrationScore <= 0 || ta.DisplayHydrationStage == "COLD")
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "FRICTION_BUILDING";
     }
   if(ta.HasSpreadToAtr && ta.SpreadToAtr > AFS_TA_MaxSpreadToAtrForAttentionPct())
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "SPREAD_TO_ATR_HIGH";
     }
   if(rec.FrictionStatus == "FAIL")
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "FRICTION_FAIL";
     }
   if(StringLen(reasons) == 0)
      reasons = "NONE";
   return reasons;
  }

string AFS_TA_TradeEligibility(const AFS_UniverseSymbol &rec,const AFS_TraderAnalytics &ta,const bool history_ready)
  {
   if(rec.FrictionStatus == "FAIL")
      return "BLOCKED";
   if(!rec.QuotePresent || rec.Bid <= 0.0 || rec.Ask <= 0.0 || rec.Ask < rec.Bid)
      return "BLOCKED";
   if(!rec.FrictionQuoteUsable)
      return "BLOCKED";
   if(!ta.HasEffectiveAtrM15)
      return "BLOCKED";
   if(rec.FrictionSampleCountUsed <= 0)
      return "BLOCKED";
   if(!history_ready)
      return "CAUTION";
   if(ta.HasSpreadToAtr && ta.SpreadToAtr > AFS_TA_MaxSpreadToAtrForAttentionPct())
      return "CAUTION";
   if(ta.DisplayHydrationStage == "BUILDING" || ta.DisplayHydrationStage == "COLD")
      return "CAUTION";
   if(rec.FrictionStatus == "WEAK")
      return "CAUTION";
   return "ALLOWED";
  }

string AFS_TA_ExecutionPermission(const AFS_UniverseSymbol &rec,const AFS_TraderAnalytics &ta,const bool history_ready)
  {
   if(rec.FrictionStatus == "FAIL")
      return "BLOCKED";
   if(!rec.QuotePresent || rec.Bid <= 0.0 || rec.Ask <= 0.0 || rec.Ask < rec.Bid)
      return "BLOCKED";
   if(!rec.FrictionQuoteUsable)
      return "BLOCKED";
   if(!ta.HasEffectiveAtrM15)
      return "BLOCKED";
   if(rec.FrictionSampleCountUsed <= 0)
      return "BLOCKED";
   if(!history_ready)
      return "HOLD";
   if(ta.DisplayHydrationStage == "BUILDING" || ta.DisplayHydrationStage == "COLD")
      return "HOLD";
   if(ta.HasSpreadToAtr && ta.SpreadToAtr > AFS_TA_MaxSpreadToAtrForAttentionPct())
      return "HOLD";
   if(ta.ExecutionQualityState == "INVALID" || ta.ExecutionQualityState == "UNTRUSTED")
      return "HOLD";
   return "ALLOWED";
  }

//==================================================================
// CORE-STABILITY NOTE: AFS_TA_Build
// This builder prepares downstream dossier/summary truth. It must not
// overwrite raw runtime contracts. Effective values must prefer raw
// runtime truth first, bounded fallback second, and explicit source
// labels always.
//==================================================================
bool AFS_TA_Build(const AFS_UniverseSymbol &rec,const bool include_heavy,AFS_TraderAnalytics &ta)
  {
   AFS_TA_Reset(ta);

   bool heavy_enabled = (include_heavy && AnalyticsIncludeHeavyHTF);
   ta.HeavyRequested = heavy_enabled;

   int min_m1  = MathMax(1, AnalyticsMinBarsM1);
   int min_m5  = MathMax(1, AnalyticsMinBarsM5);
   int min_m15 = MathMax(1, AnalyticsMinBarsM15);
   int min_h1  = MathMax(1, AnalyticsMinBarsH1);
   int min_h4  = MathMax(1, AnalyticsMinBarsH4);
   int min_d1  = MathMax(1, AnalyticsMinBarsD1);
   int min_w1  = MathMax(1, AnalyticsMinBarsW1);
   int atr_period = MathMax(2, AnalyticsAtrPeriod);
   int window_m1  = MathMax(2, TacticalWindowM1Bars);
   int window_m5  = MathMax(2, TacticalWindowM5Bars);
   int window_m15 = MathMax(2, TacticalWindowM15Bars);

   ta.BarsM15 = (rec.BarsM15 > 0 ? rec.BarsM15 : AFS_TA_SafeBars(rec.Symbol, PERIOD_M15));
   ta.BarsH1  = (rec.BarsH1  > 0 ? rec.BarsH1  : AFS_TA_SafeBars(rec.Symbol, PERIOD_H1));
   ta.BarsM1  = AFS_TA_SafeBars(rec.Symbol, PERIOD_M1);
   ta.BarsM5  = AFS_TA_SafeBars(rec.Symbol, PERIOD_M5);

   if(heavy_enabled)
     {
      ta.BarsH4 = AFS_TA_SafeBars(rec.Symbol, PERIOD_H4);
      ta.BarsD1 = AFS_TA_SafeBars(rec.Symbol, PERIOD_D1);
      ta.BarsW1 = AFS_TA_SafeBars(rec.Symbol, PERIOD_W1);
     }
   else
     {
      if(!AnalyticsIncludeHeavyHTF)
         AFS_TA_AppendReason(ta.DeferredReasons, "HTF_HEAVY_DISABLED");
      else
         AFS_TA_AppendReason(ta.DeferredReasons, "HTF_HEAVY_DEFERRED");
     }

   double runtime_atr_m15 = (rec.AtrM15 > 0.0 ? rec.AtrM15 : 0.0);
   double runtime_atr_h1  = (rec.AtrH1  > 0.0 ? rec.AtrH1  : 0.0);
   double analytics_atr_m15 = (runtime_atr_m15 > 0.0 ? runtime_atr_m15 : AFS_TA_SafeATR(rec.Symbol, PERIOD_M15, atr_period));
   double analytics_atr_h1  = (runtime_atr_h1  > 0.0 ? runtime_atr_h1  : AFS_TA_SafeATR(rec.Symbol, PERIOD_H1, atr_period));

   ta.AtrM15 = analytics_atr_m15;
   ta.HasAtrM15 = (ta.AtrM15 > 0.0);
   ta.AtrH1  = analytics_atr_h1;
   ta.HasAtrH1 = (ta.AtrH1 > 0.0);

   ta.EffectiveAtrM15 = AFS_TA_EffectiveAtrValue(runtime_atr_m15, ta.HasAtrM15, ta.AtrM15, ta.HasEffectiveAtrM15, ta.AtrM15Source);
   ta.EffectiveAtrH1  = AFS_TA_EffectiveAtrValue(runtime_atr_h1,  ta.HasAtrH1,  ta.AtrH1,  ta.HasEffectiveAtrH1,  ta.AtrH1Source);

   ta.AtrM5  = AFS_TA_SafeATR(rec.Symbol, PERIOD_M5, atr_period);
   ta.HasAtrM5 = (ta.AtrM5 > 0.0);

   if(heavy_enabled)
     {
      ta.AtrH4 = AFS_TA_SafeATR(rec.Symbol, PERIOD_H4, atr_period);
      ta.HasAtrH4 = (ta.AtrH4 > 0.0);
      ta.AtrD1 = AFS_TA_SafeATR(rec.Symbol, PERIOD_D1, atr_period);
      ta.HasAtrD1 = (ta.AtrD1 > 0.0);
     }

   ta.ExpectedMoveM15 = ta.AtrM15;
   ta.HasExpectedMoveM15 = ta.HasAtrM15;
   ta.ExpectedMoveH1  = ta.AtrH1;
   ta.HasExpectedMoveH1 = ta.HasAtrH1;
   ta.ExpectedMoveH4  = ta.AtrH4;
   ta.HasExpectedMoveH4 = ta.HasAtrH4;
   ta.ExpectedMoveD1  = ta.AtrD1;
   ta.HasExpectedMoveD1 = ta.HasAtrD1;

   double c_m15_now  = AFS_TA_SafeClose(rec.Symbol, PERIOD_M15, 0);
   double c_m15_prev = AFS_TA_SafeClose(rec.Symbol, PERIOD_M15, 4);
   double c_h1_now   = AFS_TA_SafeClose(rec.Symbol, PERIOD_H1, 0);
   double c_h1_prev  = AFS_TA_SafeClose(rec.Symbol, PERIOD_H1, 4);
   double c_h4_now   = (heavy_enabled ? AFS_TA_SafeClose(rec.Symbol, PERIOD_H4, 0) : 0.0);
   double c_h4_prev  = (heavy_enabled ? AFS_TA_SafeClose(rec.Symbol, PERIOD_H4, 2) : 0.0);
   double c_d1_now   = (heavy_enabled ? AFS_TA_SafeClose(rec.Symbol, PERIOD_D1, 0) : 0.0);
   double c_d1_prev  = (heavy_enabled ? AFS_TA_SafeClose(rec.Symbol, PERIOD_D1, 2) : 0.0);

   ta.TrendStrengthM15 = AFS_TA_TrendStrength(c_m15_now, c_m15_prev, ta.AtrM15);
   ta.HasTrendStrengthM15 = (ta.TrendStrengthM15 >= 0.0);
   if(!ta.HasTrendStrengthM15)
      ta.TrendStrengthM15 = 0.0;

   ta.TrendStrengthH1  = AFS_TA_TrendStrength(c_h1_now, c_h1_prev, ta.AtrH1);
   ta.HasTrendStrengthH1 = (ta.TrendStrengthH1 >= 0.0);
   if(!ta.HasTrendStrengthH1)
      ta.TrendStrengthH1 = 0.0;

   ta.HTFTrend         = AFS_TA_HTFTrendLabel(c_h4_now, c_h4_prev, c_d1_now, c_d1_prev);
   ta.VolatilityRegime = AFS_TA_VolatilityRegimeLabel(ta.AtrM15, ta.AtrH1, ta.AtrD1);

   double d1_high = (heavy_enabled ? AFS_TA_SafeHigh(rec.Symbol, PERIOD_D1, 0) : 0.0);
   double d1_low  = (heavy_enabled ? AFS_TA_SafeLow(rec.Symbol, PERIOD_D1, 0)  : 0.0);
   double w1_high = (heavy_enabled ? AFS_TA_SafeHigh(rec.Symbol, PERIOD_W1, 0) : 0.0);
   double w1_low  = (heavy_enabled ? AFS_TA_SafeLow(rec.Symbol, PERIOD_W1, 0)  : 0.0);

   double ref_price = AFS_TraderReferencePrice(rec);
   ta.RangePositionDaily  = AFS_TA_RangePosition(d1_low, d1_high, ref_price);
   ta.RangePositionWeekly = AFS_TA_RangePosition(w1_low, w1_high, ref_price);

   if(ta.HasAtrM15 && ta.HasAtrH1)
     {
      ta.AtrEfficiency = (ta.AtrM15 / ta.AtrH1) * 100.0;
      ta.HasAtrEfficiency = true;
     }

   double spread_price_now = AFS_TA_SpreadPriceNow(rec);
   if(spread_price_now > 0.0 && ta.HasAtrM15)
     {
      ta.SpreadToAtr = (spread_price_now / ta.AtrM15) * 100.0;
      ta.HasSpreadToAtr = true;
     }

   ta.CoverageStateM1  = AFS_TA_CoverageState(ta.BarsM1,  min_m1,  true);
   ta.CoverageStateM5  = AFS_TA_CoverageState(ta.BarsM5,  min_m5,  true);
   ta.CoverageStateM15 = AFS_TA_CoverageState(ta.BarsM15, min_m15, true);
   ta.CoverageStateH1  = AFS_TA_CoverageState(ta.BarsH1,  min_h1,  true);
   ta.CoverageStateH4  = AFS_TA_CoverageState(ta.BarsH4,  min_h4,  heavy_enabled);
   ta.CoverageStateD1  = AFS_TA_CoverageState(ta.BarsD1,  min_d1,  heavy_enabled);
   ta.CoverageStateW1  = AFS_TA_CoverageState(ta.BarsW1,  min_w1,  heavy_enabled);

   int completeness_hits = 0;
   int completeness_total = (heavy_enabled ? 7 : 4);
   if(AFS_TA_BarsReady(ta.BarsM1,  min_m1))  completeness_hits++;
   if(AFS_TA_BarsReady(ta.BarsM5,  min_m5))  completeness_hits++;
   if(AFS_TA_BarsReady(ta.BarsM15, min_m15)) completeness_hits++;
   if(AFS_TA_BarsReady(ta.BarsH1,  min_h1))  completeness_hits++;
   if(heavy_enabled && AFS_TA_BarsReady(ta.BarsH4, min_h4)) completeness_hits++;
   if(heavy_enabled && AFS_TA_BarsReady(ta.BarsD1, min_d1)) completeness_hits++;
   if(heavy_enabled && AFS_TA_BarsReady(ta.BarsW1, min_w1)) completeness_hits++;
   if(completeness_total > 0)
     {
      ta.HistoryCompleteness = (100.0 * completeness_hits) / (double)completeness_total;
      ta.HasHistoryCompleteness = true;
     }

   int integrity_hits = 0;
   int integrity_total = 5;
   if(rec.Exists) integrity_hits++;
   if(rec.TradeAllowed) integrity_hits++;
   if(rec.QuotePresent) integrity_hits++;
   if(ta.HasAtrM15 || ta.HasAtrH1) integrity_hits++;
   if(rec.TickValueValidated > 0.0 || rec.TickValueRaw > 0.0 || rec.TickValue > 0.0) integrity_hits++;
   ta.DataIntegrityScore = (100.0 * integrity_hits) / (double)integrity_total;
   ta.HasDataIntegrityScore = true;

   ta.HistoryState = ((AFS_TA_BarsReady(ta.BarsM15, min_m15) && AFS_TA_BarsReady(ta.BarsH1, min_h1) && ta.HasAtrM15 && ta.HasAtrH1) ? "READY" :
                      ((ta.BarsM15 > 0 || ta.BarsH1 > 0 || ta.HasAtrM15 || ta.HasAtrH1) ? "PARTIAL" : "PENDING"));
   ta.AtrState     = ((ta.HasAtrM15 || ta.HasAtrH1 || ta.HasAtrM5 || ta.HasAtrH4 || ta.HasAtrD1) ? "READY" : "PENDING");
   ta.TrendState   = ((ta.HasTrendStrengthM15 || ta.HasTrendStrengthH1 || ta.RangePositionDaily >= 0.0 || ta.RangePositionWeekly >= 0.0) ? "READY" : "PENDING");
   ta.QualityState = (ta.DataIntegrityScore >= 80.0 ? "PASS" : (ta.DataIntegrityScore >= 50.0 ? "PARTIAL" : "THIN"));
   ta.HTFReadiness = AFS_TA_HTFReadinessState(ta, heavy_enabled);
   ta.HistoryDepthStatus = (AFS_TA_BarsReady(ta.BarsW1, min_w1) ? "FULL_STACK" : (AFS_TA_BarsReady(ta.BarsD1, min_d1) || AFS_TA_BarsReady(ta.BarsH4, min_h4) ? "HTF_PARTIAL" : (AFS_TA_BarsReady(ta.BarsH1, min_h1) && AFS_TA_BarsReady(ta.BarsM15, min_m15) ? "INTRADAY_READY" : "THIN")));

   if(ta.BarsM15 < min_m15) AFS_TA_AppendReason(ta.DeferredReasons, "M15_HISTORY_THIN");
   if(ta.BarsH1  < min_h1)  AFS_TA_AppendReason(ta.DeferredReasons, "H1_HISTORY_THIN");
   if(ta.AtrM15 <= 0.0) AFS_TA_AppendReason(ta.DeferredReasons, "ATR_M15_PENDING");
   if(ta.AtrH1  <= 0.0) AFS_TA_AppendReason(ta.DeferredReasons, "ATR_H1_PENDING");
   if(heavy_enabled && ta.BarsH4 < min_h4) AFS_TA_AppendReason(ta.DeferredReasons, "H4_HISTORY_THIN");
   if(heavy_enabled && ta.BarsD1 < min_d1) AFS_TA_AppendReason(ta.DeferredReasons, "D1_HISTORY_THIN");
   if(heavy_enabled && ta.BarsW1 < min_w1) AFS_TA_AppendReason(ta.DeferredReasons, "W1_HISTORY_THIN");
   if(heavy_enabled && ta.AtrH4 <= 0.0) AFS_TA_AppendReason(ta.DeferredReasons, "ATR_H4_PENDING");
   if(heavy_enabled && ta.AtrD1 <= 0.0) AFS_TA_AppendReason(ta.DeferredReasons, "ATR_D1_PENDING");
   if(!rec.QuotePresent) AFS_TA_AppendReason(ta.DeferredReasons, "QUOTE_PENDING");
   ta.HTFDeferredReason = ta.DeferredReasons;

   MqlRates m1_rates[];
   MqlRates m5_rates[];
   MqlRates m15_rates[];
   bool have_m1 = AFS_TA_LoadRates(rec.Symbol, PERIOD_M1, window_m1, m1_rates);
   bool have_m5 = AFS_TA_LoadRates(rec.Symbol, PERIOD_M5, window_m5, m5_rates);
   bool have_m15 = AFS_TA_LoadRates(rec.Symbol, PERIOD_M15, window_m15, m15_rates);

   double spread_price_current = AFS_TA_SpreadPriceNow(rec);
   ta.FreshnessBand = AFS_TA_FreshnessBand(rec.TickAgeSec, rec.QuotePresent);
   ta.SpreadBand = AFS_TA_SpreadBand(spread_price_current, ta.AtrM15);
   ta.TacticalLightState = ((ta.FreshnessBand != "PENDING" && ta.SpreadBand != "PENDING") ? "READY" : "PARTIAL");

   if(rec.SpreadSampleCount > 0 && rec.Point > 0.0)
     {
      double sum_spread = 0.0;
      double min_spread = 0.0;
      double max_spread = 0.0;
      int used = 0;
      for(int i=0;i<rec.SpreadSampleCount && i<AFS_MAX_SPREAD_SAMPLES;i++)
        {
         double raw = rec.SpreadSampleRing[i];
         if(raw <= 0.0)
            continue;
         double px = raw * rec.Point;
         if(used == 0 || px < min_spread) min_spread = px;
         if(used == 0 || px > max_spread) max_spread = px;
         sum_spread += px;
         used++;
        }
      if(used > 0)
        {
         ta.HasRecentSpreadStats = true;
         ta.RecentSpreadMinPrice = min_spread;
         ta.RecentSpreadAvgPrice = sum_spread / (double)used;
         ta.RecentSpreadMaxPrice = max_spread;
        }
     }

   ta.RecentMoveM1 = (have_m1 ? AFS_TA_BoundedMove(m1_rates, window_m1) : 0.0);
   ta.HasRecentMoveM1 = (ta.RecentMoveM1 > 0.0);
   ta.RecentMoveM5 = (have_m5 ? AFS_TA_BoundedMove(m5_rates, window_m5) : 0.0);
   ta.HasRecentMoveM5 = (ta.RecentMoveM5 > 0.0);
   ta.RangePositionM1 = (have_m1 ? AFS_TA_LocalRangePosition(m1_rates, window_m1) : -1.0);
   ta.RangePositionM5 = (have_m5 ? AFS_TA_LocalRangePosition(m5_rates, window_m5) : -1.0);

   ta.MovementBand = AFS_TA_MovementBand(ta.RecentMoveM1, ta.AtrM15);
   ta.IntradayBias = AFS_TA_IntradayBias(m5_rates, (have_m5 ? window_m5 : 0), m15_rates, (have_m15 ? window_m15 : 0));
   ta.TacticalM1Summary = AFS_TA_TacticalSummary("M1", ta.RecentMoveM1, ta.RangePositionM1, ta.IntradayBias, ta.AtrM15);
   ta.TacticalM5Summary = AFS_TA_TacticalSummary("M5", ta.RecentMoveM5, ta.RangePositionM5, ta.IntradayBias, ta.AtrH1);
   ta.ExecutionQualityState = AFS_TA_ExecutionQualityState(rec, ta.FreshnessBand, ta.SpreadBand);

   ta.TacticalMediumState = ((ta.HasRecentMoveM1 || ta.HasRecentMoveM5 || have_m15) ? "READY" : "PARTIAL");
   ta.TacticalHeavyState = (heavy_enabled ? ta.HTFReadiness : (AnalyticsIncludeHeavyHTF ? "DEFERRED" : "DISABLED"));
   ta.TacticalDeferredReason = (heavy_enabled ? ta.HTFDeferredReason : (AnalyticsIncludeHeavyHTF ? "HEAVY_TACTICAL_DEFERRED" : "HEAVY_TACTICAL_DISABLED"));
   ta.TacticalReadiness = ((ta.TacticalLightState == "READY" && ta.TacticalMediumState == "READY") ? "READY" :
                           ((ta.TacticalLightState == "READY" || ta.TacticalMediumState == "READY") ? "PARTIAL" : "PENDING"));
   ta.TacticalContextStatus = (StringLen(ta.IntradayBias) > 0 && ta.IntradayBias != "PENDING" ? "ACTIVE_SYMBOL_CONTEXT_READY" : "TACTICAL_PENDING");
   if(!have_m1) AFS_TA_AppendReason(ta.TacticalDeferredReason, "M1_CONTEXT_PENDING");
   if(!have_m5) AFS_TA_AppendReason(ta.TacticalDeferredReason, "M5_CONTEXT_PENDING");
   if(!have_m15) AFS_TA_AppendReason(ta.TacticalDeferredReason, "M15_CONTEXT_PENDING");

   bool history_ready = (AFS_TA_BarsReady(ta.BarsM15, min_m15) && AFS_TA_BarsReady(ta.BarsH1, min_h1) &&
                         ta.HasEffectiveAtrM15 && ta.HasEffectiveAtrH1);
   ta.DisplayHydrationStage = AFS_TA_DisplayHydrationStage(rec, ta.DisplayHydrationScore);
   ta.ExecutionQualityScore = AFS_TA_DerivedExecutionQualityScore(rec, ta.SpreadToAtr, ta.HasEffectiveAtrM15);
   ta.EligibilityReasons    = AFS_TA_EligibilityReasons(rec, ta, history_ready);
   ta.TradeEligibility      = AFS_TA_TradeEligibility(rec, ta, history_ready);
   ta.ExecutionPermission   = AFS_TA_ExecutionPermission(rec, ta, history_ready);

   ta.Ready = true;
   return true;
  }

#endif