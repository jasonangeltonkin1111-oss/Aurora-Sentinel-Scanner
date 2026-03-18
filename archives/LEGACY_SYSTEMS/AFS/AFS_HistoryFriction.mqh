//+------------------------------------------------------------------+
//|                                             AFS_HistoryFriction  |
//|              Aegis Forge Scanner - Phase 1 / Step 8             |
//+------------------------------------------------------------------+
#ifndef __AFS_HISTORYFRICTION_MQH__
#define __AFS_HISTORYFRICTION_MQH__

#include "AFS_CoreTypes.mqh"

void AFS_HF_ResetHistoryState(AFS_UniverseSymbol &rec)
  {
   rec.LastHistoryUpdateAt   = 0;
   rec.HistoryUpdateCount    = 0;
   rec.BarsM15               = 0;
   rec.BarsH1                = 0;
   rec.AtrM15                = 0.0;
   rec.AtrH1                 = 0.0;
   rec.BaselineMove          = 0.0;
   rec.MovementCapacityScore = 0.0;
   rec.HistoryStatus         = "UNSCANNED";
   rec.HistoryFlags          = "";
  }

void AFS_HF_ResetFrictionState(AFS_UniverseSymbol &rec)
  {
   rec.LastFrictionUpdateAt    = 0;
   rec.FrictionUpdateCount     = 0;
   rec.FrictionSampleCountUsed = 0;
   rec.MedianSpread            = 0.0;
   rec.MaxSpread               = 0.0;
   rec.SpreadAtrRatio          = 0.0;
   rec.LivelinessScore         = 0.0;
   rec.FreshnessScore          = 0.0;
   rec.FrictionStatus          = "UNSCANNED";
   rec.FrictionFlags           = "";
   rec.FrictionTruthState      = "UNSCANNED";
   rec.FrictionFailReason      = "";
   rec.FrictionWeakReason      = "";
   rec.FrictionHydrationStage  = "COLD";
   rec.FrictionHoldPass        = false;
   rec.FrictionMarketLive      = false;
   rec.FrictionSessionOpen     = false;
   rec.FrictionQuoteUsable     = false;
   rec.FrictionHydrationScore  = 0;
   rec.FrictionGoodPasses      = 0;
   rec.FrictionBadPasses       = 0;
   rec.LastTradableEvidenceAt  = 0;
   rec.LastAliveEvidenceAt     = 0;
  }

bool AFS_HF_IsFinitePositive(const double value)
  {
   return (value > 0.0 && MathIsValidNumber(value));
  }

string AFS_HF_AddFlag(const string base_value,const string add_value)
  {
   if(StringLen(add_value) == 0)
      return base_value;
   if(StringLen(base_value) == 0)
      return add_value;
   return base_value + "|" + add_value;
  }

int AFS_HF_BoundInt(const int value,const int lo,const int hi)
  {
   if(value < lo)
      return lo;
   if(value > hi)
      return hi;
   return value;
  }

string AFS_HF_PrimaryReason(const string truth_state,
                            const bool severe_spread,
                            const bool elevated_spread,
                            const bool thin_data,
                            const bool weak_freshness,
                            const bool no_baseline)
  {
   if(truth_state == "CLOSED_SESSION")
      return "CLOSED_SESSION";
   if(truth_state == "DEAD_FEED")
      return "DEAD_FEED";
   if(truth_state == "STALE_FEED")
      return "STALE_FEED";
   if(truth_state == "NO_QUOTE")
      return "NO_QUOTE";
   if(severe_spread)
      return "FRICTION_UNUSABLE";
   if(no_baseline)
      return "NO_BASELINE";
   if(thin_data)
      return "THIN_EVIDENCE";
   if(elevated_spread)
      return "SPREAD_ELEVATED";
   if(weak_freshness)
      return "FRESHNESS_LIGHT";
   if(truth_state == "QUIET_ALIVE")
      return "QUIET_ALIVE";
   return "HYDRATING";
  }

string AFS_HF_HydrationStage(const int score,const bool hold_pass)
  {
   if(hold_pass)
      return "HELD";
   if(score >= 60)
      return "READY";
   if(score >= 20)
      return "BUILDING";
   return "COLD";
  }

bool AFS_HF_IsSessionClosedHint(const AFS_UniverseSymbol &rec,const bool active_tick)
  {
   if(rec.AssetClass == "CRYPTO" && active_tick)
      return false;

   if(rec.SessionState == "SESSION_REF_NO_QUOTE")
      return true;

   if(rec.SessionState == "SESSION_REF_STALE" && !active_tick && !rec.QuotePresent)
      return true;

   return false;
  }

string AFS_HF_DeriveTruthState(const AFS_UniverseSymbol &rec,
                               const bool quote_usable,
                               const bool no_baseline,
                               const bool session_closed,
                               const bool thin_data,
                               const int  max_tick_age)
  {
   bool active_tick = (rec.TickAgeSec >= 0 && rec.TickAgeSec <= MathMax(60, max_tick_age));

   if(quote_usable)
     {
      if(active_tick)
        {
         if(no_baseline || thin_data)
            return "THIN_BUILDING";
         return "ACTIVE_MARKET";
        }

      if(rec.TickAgeSec > max_tick_age && rec.TickAgeSec <= (max_tick_age * 2))
         return "QUIET_ALIVE";
      if(session_closed)
         return "QUIET_ALIVE";
      if(rec.TickAgeSec > (max_tick_age * 3))
         return "DEAD_FEED";
      return "STALE_FEED";
     }

   if(active_tick)
      return "NO_QUOTE";

   if(session_closed)
      return "CLOSED_SESSION";

   if(rec.TickAgeSec > (max_tick_age * 3))
      return "DEAD_FEED";

   if(rec.TickAgeSec > max_tick_age && rec.TickAgeSec <= (max_tick_age * 3))
      return "STALE_FEED";

   return "NO_QUOTE";
  }

void AFS_HF_UpdateHydrationState(AFS_UniverseSymbol &staged,
                                 const AFS_UniverseSymbol &rec,
                                 const datetime now,
                                 const string truth_state,
                                 const bool can_trade_now,
                                 const bool strong_positive,
                                 const bool soft_positive,
                                 const bool thin_building,
                                 const bool strong_negative)
  {
   int score = rec.FrictionHydrationScore;
   int good  = rec.FrictionGoodPasses;
   int bad   = rec.FrictionBadPasses;

   if(strong_positive)
     {
      score += 24;
      good++;
      bad = 0;
     }
   else if(soft_positive)
     {
      score += 12;
      if(good < 1)
         good = 1;
      bad = 0;
     }
   else if(thin_building)
     {
      score -= 3;
      if(bad > 0)
         bad--;
     }
   else if(strong_negative)
     {
      score -= 22;
      bad++;
      if(good > 0)
         good--;
     }
   else
     {
      score -= 8;
      bad++;
      if(good > 0)
         good--;
     }

   staged.FrictionHydrationScore = AFS_HF_BoundInt(score, 0, 100);
   staged.FrictionGoodPasses     = AFS_HF_BoundInt(good, 0, 8);
   staged.FrictionBadPasses      = AFS_HF_BoundInt(bad, 0, 8);

   if(truth_state == "ACTIVE_MARKET" || truth_state == "QUIET_ALIVE" || truth_state == "THIN_BUILDING")
      staged.LastAliveEvidenceAt = now;
   else
      staged.LastAliveEvidenceAt = rec.LastAliveEvidenceAt;

   if(can_trade_now)
      staged.LastTradableEvidenceAt = now;
   else
      staged.LastTradableEvidenceAt = rec.LastTradableEvidenceAt;
  }


bool AFS_HF_ComputeATRFromRates(MqlRates &rates[],const int count,const int period,double &atr_out)
  {
   atr_out = 0.0;

   if(count < (period + 1) || period < 1)
      return false;

   double tr_sum = 0.0;
   int used = 0;

   for(int i = 1; i <= period; i++)
     {
      double high  = rates[i - 1].high;
      double low   = rates[i - 1].low;
      double pclose= rates[i].close;

      double tr1 = high - low;
      double tr2 = MathAbs(high - pclose);
      double tr3 = MathAbs(low  - pclose);
      double tr  = MathMax(tr1, MathMax(tr2, tr3));

      if(MathIsValidNumber(tr) && tr >= 0.0)
        {
         tr_sum += tr;
         used++;
        }
     }

   if(used <= 0)
      return false;

   atr_out = tr_sum / used;
   return (atr_out > 0.0);
  }

double AFS_HF_MovementScore(const AFS_UniverseSymbol &rec)
  {
   double baseline = rec.BaselineMove;
   if(baseline <= 0.0)
      return 0.0;

   double spread_price = 0.0;
   if(rec.Point > 0.0 && rec.SpreadSnapshot > 0.0)
      spread_price = rec.SpreadSnapshot * rec.Point;

   if(spread_price <= 0.0)
      return 60.0;

   double ratio = baseline / spread_price;
   if(ratio <= 0.0)
      return 0.0;

   double score = ratio * 12.0;
   if(score > 100.0)
      score = 100.0;
   return score;
  }

bool AFS_HF_RefreshHistoryRecord(AFS_UniverseSymbol &rec,
                                 const datetime now,
                                 const int min_bars_m15,
                                 const int min_bars_h1,
                                 string &detail)
  {
   detail = "";

   AFS_UniverseSymbol staged = rec;
   string flags = "";

   int need_m15 = MathMax(min_bars_m15, 32);
   int need_h1  = MathMax(min_bars_h1,  32);

   MqlRates rates_m15[];
   MqlRates rates_h1[];

   ArraySetAsSeries(rates_m15, true);
   ArraySetAsSeries(rates_h1,  true);

   int copied_m15 = CopyRates(rec.Symbol, PERIOD_M15, 0, need_m15 + 32, rates_m15);
   int copied_h1  = CopyRates(rec.Symbol, PERIOD_H1,  0, need_h1  + 32, rates_h1);

   staged.BarsM15 = MathMax(0, copied_m15);
   staged.BarsH1  = MathMax(0, copied_h1);
   staged.AtrM15  = 0.0;
   staged.AtrH1   = 0.0;

   bool enough_m15 = (copied_m15 >= min_bars_m15);
   bool enough_h1  = (copied_h1  >= min_bars_h1);

   if(!enough_m15)
      flags = AFS_HF_AddFlag(flags, "M15_THIN");
   if(!enough_h1)
      flags = AFS_HF_AddFlag(flags, "H1_THIN");

   bool atr_m15_ok = false;
   bool atr_h1_ok  = false;

   if(copied_m15 >= 16)
      atr_m15_ok = AFS_HF_ComputeATRFromRates(rates_m15, copied_m15, 14, staged.AtrM15);
   if(copied_h1 >= 16)
      atr_h1_ok = AFS_HF_ComputeATRFromRates(rates_h1, copied_h1, 14, staged.AtrH1);

   if(!atr_m15_ok)
      flags = AFS_HF_AddFlag(flags, "ATR_M15_MISSING");
   if(!atr_h1_ok)
      flags = AFS_HF_AddFlag(flags, "ATR_H1_MISSING");

   staged.BaselineMove = 0.0;
   if(atr_m15_ok && atr_h1_ok)
      staged.BaselineMove = ((staged.AtrM15 * 0.60) + (staged.AtrH1 * 0.40));
   else if(atr_m15_ok)
      staged.BaselineMove = staged.AtrM15;
   else if(atr_h1_ok)
      staged.BaselineMove = staged.AtrH1;

   staged.MovementCapacityScore = AFS_HF_MovementScore(staged);

   if(!enough_m15 && !enough_h1)
      staged.HistoryStatus = "FAIL";
   else if(staged.BaselineMove <= 0.0)
      staged.HistoryStatus = "WEAK";
   else if(!enough_m15 || !enough_h1)
      staged.HistoryStatus = "WEAK";
   else
      staged.HistoryStatus = "PASS";

   if(StringLen(flags) == 0)
      flags = "OK";

   staged.HistoryFlags = flags;

   bool preserve_previous = false;
   if(rec.HistoryUpdateCount > 0)
     {
      bool old_good = (rec.HistoryStatus == "PASS" &&
                       rec.BarsM15 > 0 &&
                       rec.BarsH1 > 0 &&
                       rec.BaselineMove > 0.0);

      bool new_incomplete = ((!enough_m15 && !enough_h1) || staged.BaselineMove <= 0.0);

      if(old_good && new_incomplete)
         preserve_previous = true;
     }

   if(preserve_previous)
     {
      rec.HistoryFlags = AFS_HF_AddFlag(rec.HistoryFlags, "CARRY_FORWARD");
      detail = "CARRY_FORWARD|" + rec.HistoryStatus + "|" + rec.HistoryFlags +
               "|M15=" + IntegerToString(staged.BarsM15) +
               "|H1=" + IntegerToString(staged.BarsH1);
      return true;
     }

   staged.LastHistoryUpdateAt = now;
   staged.HistoryUpdateCount  = rec.HistoryUpdateCount + 1;

   rec = staged;

   detail = rec.HistoryStatus + "|" + rec.HistoryFlags +
            "|M15=" + IntegerToString(rec.BarsM15) +
            "|H1=" + IntegerToString(rec.BarsH1);

   return true;
  }

int AFS_HF_CollectRecentSpreadSamples(const AFS_UniverseSymbol &rec,
                                      const datetime now,
                                      const int window_sec,
                                      double &samples[])
  {
   ArrayResize(samples, 0);

   int used = 0;
   int capacity = MathMin(AFS_MAX_SPREAD_SAMPLES, rec.SpreadSampleCount);
   if(capacity <= 0)
      return 0;

   int win = MathMax(5, window_sec);

   for(int i = 0; i < capacity; i++)
     {
      datetime ts = rec.SpreadSampleTimeRing[i];
      double spread = rec.SpreadSampleRing[i];

      if(ts <= 0 || spread <= 0.0 || !MathIsValidNumber(spread))
         continue;
      if((now - ts) > win)
         continue;

      ArrayResize(samples, used + 1);
      samples[used] = spread;
      used++;
     }

   return used;
  }

void AFS_HF_SortAscending(double &values[],const int count)
  {
   for(int i = 0; i < count - 1; i++)
     {
      for(int j = i + 1; j < count; j++)
        {
         if(values[j] < values[i])
           {
            double tmp = values[i];
            values[i] = values[j];
            values[j] = tmp;
           }
        }
     }
  }

double AFS_HF_ComputeMedian(double &values[],const int count)
  {
   if(count <= 0)
      return 0.0;

   AFS_HF_SortAscending(values, count);

   int mid = count / 2;
   if((count % 2) == 1)
      return values[mid];

   return (values[mid - 1] + values[mid]) * 0.5;
  }

double AFS_HF_ComputeMax(double &values[],const int count)
  {
   if(count <= 0)
      return 0.0;

   double v = values[0];
   for(int i = 1; i < count; i++)
      if(values[i] > v)
         v = values[i];
   return v;
  }

double AFS_HF_ComputeFreshnessScore(const AFS_UniverseSymbol &rec,const int max_tick_age)
  {
   if(!rec.QuotePresent)
      return 0.0;
   if(rec.TickAgeSec < 0)
      return 0.0;

   int safe_max = MathMax(10, max_tick_age);
   if(rec.TickAgeSec <= 0)
      return 100.0;
   if(rec.TickAgeSec >= (safe_max * 3))
      return 0.0;

   double score = 100.0 - ((double)rec.TickAgeSec / (double)(safe_max * 3)) * 100.0;
   if(score < 0.0)
      score = 0.0;
   if(score > 100.0)
      score = 100.0;
   return score;
  }

double AFS_HF_ComputeLivelinessScore(const AFS_UniverseSymbol &rec,
                                     const int sample_count,
                                     const int min_update_count,
                                     const double freshness_score)
  {
   double update_ratio = 0.0;
   int need_updates = MathMax(1, min_update_count);
   if(rec.SurfaceUpdateCount > 0)
      update_ratio = MathMin(1.0, (double)rec.SurfaceUpdateCount / (double)need_updates);

   double sample_ratio = MathMin(1.0, (double)sample_count / (double)need_updates);
   double score = (update_ratio * 35.0) + (sample_ratio * 35.0) + (freshness_score * 0.30);

   if(rec.SessionState == "ACTIVE" || rec.SessionState == "ACTIVE_NOREF")
      score += 8.0;
   else if(rec.SessionState == "QUIET" || rec.SessionState == "QUIET_NOREF")
      score += 3.0;
   else if(rec.SessionState == "SESSION_REF_NO_QUOTE" || rec.SessionState == "SESSION_REF_STALE")
      score -= 15.0;

   if(score < 0.0)
      score = 0.0;
   if(score > 100.0)
      score = 100.0;
   return score;
  }

bool AFS_HF_RefreshFrictionRecord(AFS_UniverseSymbol &rec,
                                  const datetime now,
                                  const int sample_window_sec,
                                  const int sample_count_target,
                                  const int min_update_count,
                                  const int max_tick_age,
                                  const double max_spread_atr,
                                  string &detail)
  {
   detail = "";

   AFS_UniverseSymbol staged = rec;
   string flags = "";
   double samples[];
   int valid_samples = AFS_HF_CollectRecentSpreadSamples(rec, now, sample_window_sec, samples);

   staged.FrictionSampleCountUsed = valid_samples;
   staged.MedianSpread            = 0.0;
   staged.MaxSpread               = 0.0;
   staged.SpreadAtrRatio          = 0.0;
   staged.FreshnessScore          = AFS_HF_ComputeFreshnessScore(rec, max_tick_age);
   staged.LivelinessScore         = AFS_HF_ComputeLivelinessScore(rec, valid_samples, min_update_count, staged.FreshnessScore);
   staged.FrictionHoldPass        = false;
   staged.FrictionFailReason      = "";
   staged.FrictionWeakReason      = "";

   if(valid_samples <= 0)
      flags = AFS_HF_AddFlag(flags, "NO_RECENT_SAMPLES");
   else
     {
      double sorted[];
      ArrayResize(sorted, valid_samples);
      for(int i = 0; i < valid_samples; i++)
         sorted[i] = samples[i];

      staged.MedianSpread = AFS_HF_ComputeMedian(sorted, valid_samples);
      staged.MaxSpread    = AFS_HF_ComputeMax(samples, valid_samples);

      double atr_anchor = rec.AtrM15;
      if(atr_anchor <= 0.0)
         atr_anchor = rec.BaselineMove;

      if(rec.Point > 0.0 && atr_anchor > 0.0 && staged.MedianSpread > 0.0)
         staged.SpreadAtrRatio = (staged.MedianSpread * rec.Point) / atr_anchor;
     }

   int need_samples = MathMax(1, MathMin(sample_count_target, 2));
   int need_updates = MathMax(1, MathMin(min_update_count, 2));

   bool no_baseline     = (rec.HistoryUpdateCount <= 0 || rec.BaselineMove <= 0.0);
   bool quote_usable    = (rec.QuotePresent && rec.Bid > 0.0 && rec.Ask > 0.0 && rec.Ask >= rec.Bid);
   bool active_tick     = (rec.TickAgeSec >= 0 && rec.TickAgeSec <= MathMax(60, max_tick_age));
   bool session_closed  = AFS_HF_IsSessionClosedHint(rec, active_tick);
   bool thin_data       = (valid_samples < need_samples || rec.SurfaceUpdateCount < need_updates);
   bool weak_freshness  = (rec.TickAgeSec > max_tick_age && rec.TickAgeSec <= (max_tick_age * 2));
   bool stale_feed      = (rec.TickAgeSec > (max_tick_age * 2) && rec.TickAgeSec <= (max_tick_age * 3));
   bool dead_feed       = (rec.TickAgeSec > (max_tick_age * 3));
   bool severe_spread   = (staged.SpreadAtrRatio > (max_spread_atr * 1.50) && staged.SpreadAtrRatio > 0.0);
   bool elevated_spread = (staged.SpreadAtrRatio > max_spread_atr && staged.SpreadAtrRatio > 0.0);
   string truth_state   = AFS_HF_DeriveTruthState(rec, quote_usable, no_baseline, session_closed, thin_data, max_tick_age);

   staged.FrictionTruthState  = truth_state;
   staged.FrictionMarketLive  = (truth_state == "ACTIVE_MARKET" || truth_state == "QUIET_ALIVE" || truth_state == "THIN_BUILDING");
   staged.FrictionSessionOpen = (!session_closed);
   staged.FrictionQuoteUsable = quote_usable;

   if(no_baseline)
      flags = AFS_HF_AddFlag(flags, "NO_BASELINE");
   if(!quote_usable)
      flags = AFS_HF_AddFlag(flags, "NO_QUOTE");
   if(session_closed)
      flags = AFS_HF_AddFlag(flags, "OFF_SESSION_OR_CLOSED");
   if(stale_feed || truth_state == "STALE_FEED")
      flags = AFS_HF_AddFlag(flags, "STALE_FEED_RISK");
   if(dead_feed || truth_state == "DEAD_FEED")
      flags = AFS_HF_AddFlag(flags, "DEAD_MARKET_RISK");
   if(truth_state == "QUIET_ALIVE")
      flags = AFS_HF_AddFlag(flags, "QUIET_NOT_DEAD");
   if(truth_state == "THIN_BUILDING")
      flags = AFS_HF_AddFlag(flags, "THIN_BUILDING");
   if(valid_samples < need_samples)
      flags = AFS_HF_AddFlag(flags, "THIN_SAMPLES");
   if(rec.SurfaceUpdateCount < need_updates)
      flags = AFS_HF_AddFlag(flags, "LOW_UPDATE_COUNT");
   if(rec.TickAgeSec < 0)
      flags = AFS_HF_AddFlag(flags, "TICK_AGE_UNKNOWN");
   else if(weak_freshness)
      flags = AFS_HF_AddFlag(flags, "WEAK_FRESHNESS");
   if(elevated_spread)
     {
      if(severe_spread)
         flags = AFS_HF_AddFlag(flags, "SPREAD_ATR_FAIL");
      else
         flags = AFS_HF_AddFlag(flags, "SPREAD_ATR_HIGH");
     }

   bool hard_no_quote   = (truth_state == "NO_QUOTE" && !quote_usable &&
                           rec.TickAgeSec >= 0 && rec.TickAgeSec > max_tick_age);
   bool strong_negative = (truth_state == "CLOSED_SESSION" || truth_state == "DEAD_FEED" || hard_no_quote);
   bool thin_building   = (truth_state == "THIN_BUILDING" || no_baseline);
   bool strong_positive = ((truth_state == "ACTIVE_MARKET" || truth_state == "QUIET_ALIVE") &&
                           quote_usable && !no_baseline && !thin_data && !elevated_spread);
   bool soft_positive   = ((truth_state == "ACTIVE_MARKET" || truth_state == "QUIET_ALIVE" || truth_state == "THIN_BUILDING") &&
                           quote_usable && !severe_spread);
   bool can_trade_now   = ((truth_state == "ACTIVE_MARKET" || truth_state == "QUIET_ALIVE" || truth_state == "THIN_BUILDING") &&
                           quote_usable && !no_baseline && !severe_spread &&
                           staged.FreshnessScore >= 20.0);

   AFS_HF_UpdateHydrationState(staged,
                               rec,
                               now,
                               truth_state,
                               can_trade_now,
                               strong_positive,
                               soft_positive,
                               thin_building,
                               strong_negative);

   if(strong_negative)
      staged.FrictionStatus = "FAIL";
   else if(severe_spread && staged.FrictionBadPasses >= 2 && !thin_building)
      staged.FrictionStatus = "FAIL";
   else if(can_trade_now && (staged.FrictionHydrationScore >= 45 || staged.FrictionGoodPasses >= 1))
      staged.FrictionStatus = "PASS";
   else
      staged.FrictionStatus = "WEAK";

   bool holdable_state = ((truth_state == "THIN_BUILDING" || truth_state == "QUIET_ALIVE" || truth_state == "STALE_FEED") &&
                          !strong_negative && !severe_spread);
   int hold_window_sec = MathMax(300, max_tick_age * 6);

   if(rec.FrictionStatus == "PASS" &&
      staged.FrictionStatus != "PASS" &&
      holdable_state &&
      rec.LastTradableEvidenceAt > 0 &&
      (now - rec.LastTradableEvidenceAt) <= hold_window_sec)
     {
      staged.FrictionStatus    = "PASS";
      staged.FrictionHoldPass  = true;
      staged.FrictionWeakReason = "";
      flags = AFS_HF_AddFlag(flags, "PASS_HOLD");
     }

   if(rec.FrictionStatus == "PASS" &&
      staged.FrictionStatus == "FAIL" &&
      !strong_negative &&
      rec.FrictionBadPasses < 1)
     {
      staged.FrictionStatus = "WEAK";
      flags = AFS_HF_AddFlag(flags, "PASS_SOFT_DROP");
     }

   string primary_reason = AFS_HF_PrimaryReason(truth_state,
                                                severe_spread,
                                                elevated_spread,
                                                thin_data,
                                                weak_freshness,
                                                no_baseline);

   if(staged.FrictionStatus == "FAIL")
      staged.FrictionFailReason = primary_reason;
   else if(staged.FrictionStatus == "WEAK")
      staged.FrictionWeakReason = primary_reason;

   staged.FrictionHydrationStage = AFS_HF_HydrationStage(staged.FrictionHydrationScore, staged.FrictionHoldPass);

   if(StringLen(flags) == 0)
      flags = "OK";

   staged.FrictionFlags        = flags;
   staged.LastFrictionUpdateAt = now;
   staged.FrictionUpdateCount  = rec.FrictionUpdateCount + 1;

   rec = staged;

   detail = rec.FrictionStatus + "|" + rec.FrictionFlags +
            "|Truth=" + rec.FrictionTruthState +
            "|Hydration=" + IntegerToString(rec.FrictionHydrationScore) +
            "|Ratio=" + DoubleToString(rec.SpreadAtrRatio, 6);

   return true;
  }

#endif
