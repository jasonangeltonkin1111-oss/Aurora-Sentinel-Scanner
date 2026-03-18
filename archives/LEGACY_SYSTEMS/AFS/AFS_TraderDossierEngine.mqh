#ifndef __AFS_TRADER_DOSSIER_ENGINE_MQH__
#define __AFS_TRADER_DOSSIER_ENGINE_MQH__

#include "AFS_TraderAnalyticsEngine.mqh"

//==================================================================
// AFS DOSSIER / WRITER ZONE
//==================================================================
// WRITER-LAYER ONLY.
// Keep this file focused on formatting and publication-readable views.
// Do not add heavy rescans, full-history reconstruction, or Step 8/9/10
// recomputation here. Prefer prepared/effective values and explicit
// source labels over fake 0.00 / fake pending output.
//==================================================================


int AFS_TD_EffectiveDigits(const AFS_UniverseSymbol &rec)
  {
   int digits = rec.Digits;
   if(digits < 0 || digits > 10)
      digits = (int)SymbolInfoInteger(rec.Symbol, SYMBOL_DIGITS);
   if(digits < 0)
      digits = 5;
   if(digits > 10)
      digits = 10;
   return digits;
  }

string AFS_TD_FormatPrice(const AFS_UniverseSymbol &rec,const double value)
  {
   return DoubleToString(value, AFS_TD_EffectiveDigits(rec));
  }

string AFS_TD_FormatPointLike(const AFS_UniverseSymbol &rec,const double value)
  {
   int digits = AFS_TD_EffectiveDigits(rec) + 2;
   if(digits < 4)
      digits = 4;
   if(digits > 10)
      digits = 10;
   return DoubleToString(value, digits);
  }

double AFS_TD_SpreadPriceNow(const AFS_UniverseSymbol &rec)
  {
   if(rec.SpreadSnapshot <= 0.0)
      return 0.0;
   if(rec.Point > 0.0)
      return rec.SpreadSnapshot * rec.Point;
   return rec.SpreadSnapshot;
  }

double AFS_TD_SafeDerivedMoneyFromPriceDistance(const AFS_UniverseSymbol &rec,const double price_distance)
  {
   if(price_distance <= 0.0 || rec.TickSize <= 0.0)
      return 0.0;

   double trusted_tick_value = 0.0;
   string provenance = "";
   string trust_state = "";
   bool estimated = false;
   if(!AFS_TA_SelectTrustedTickValue(rec, trusted_tick_value, provenance, trust_state, estimated))
      return 0.0;

   return (price_distance / rec.TickSize) * trusted_tick_value;
  }

double AFS_TD_SafeDerivedMoneyFromPriceDistanceEstimated(const AFS_UniverseSymbol &rec,const double price_distance)
  {
   if(price_distance <= 0.0 || rec.TickSize <= 0.0)
      return 0.0;

   double trusted_tick_value = 0.0;
   string provenance = "";
   string trust_state = "";
   bool estimated = false;
   if(!AFS_TA_SelectTrustedTickValue(rec, trusted_tick_value, provenance, trust_state, estimated))
      return 0.0;

   return (price_distance / rec.TickSize) * trusted_tick_value;
  }

bool AFS_TD_CalcMarginPerVolume(const AFS_UniverseSymbol &rec,const double volume,const ENUM_ORDER_TYPE order_type,double &margin_value)
  {
   margin_value = 0.0;
   if(volume <= 0.0)
      return false;

   double price = (order_type == ORDER_TYPE_SELL ? rec.Bid : rec.Ask);
   if(price <= 0.0)
      price = AFS_TraderReferencePrice(rec);
   if(price <= 0.0)
      return false;

   ResetLastError();
   if(OrderCalcMargin(order_type, rec.Symbol, volume, price, margin_value) && MathIsValidNumber(margin_value) && margin_value > 0.0)
      return true;
   margin_value = 0.0;
   return false;
  }

string AFS_TD_MoneyMetricText(const double value,const bool estimated,const string pending_or_unavailable)
  {
   if(value > 0.0)
      return (estimated ? "~" : "") + AFS_TD_FormatMoney(value);
   return pending_or_unavailable;
  }

string AFS_TD_TacticalMetricText(const AFS_UniverseSymbol &rec,const bool has_value,const double value)
  {
   if(has_value)
      return AFS_TD_FormatPrice(rec, value);
   return "PENDING_OR_UNAVAILABLE";
  }


string AFS_TD_FormatPercent(const double value)
  {
   return DoubleToString(value, 2) + "%";
  }

string AFS_TD_TrimNumericText(const string value)
  {
   string out = value;
   int dot = StringFind(out, ".");
   if(dot < 0)
      return out;

   while(StringLen(out) > (dot + 1) && StringSubstr(out, StringLen(out) - 1, 1) == "0")
      out = StringSubstr(out, 0, StringLen(out) - 1);

   if(StringLen(out) > 0 && StringSubstr(out, StringLen(out) - 1, 1) == ".")
      out = StringSubstr(out, 0, StringLen(out) - 1);

   return out;
  }

string AFS_TD_FormatAdaptiveValue(const double value,const int min_decimals=2,const int max_decimals=10)
  {
   if(!MathIsValidNumber(value))
      return "NaN";

   int use_min = min_decimals;
   int use_max = max_decimals;
   if(use_min < 0)
      use_min = 0;
   if(use_max < use_min)
      use_max = use_min;
   if(use_max > 10)
      use_max = 10;

   string raw = DoubleToString(value, use_max);
   string trimmed = AFS_TD_TrimNumericText(raw);

   int dot = StringFind(trimmed, ".");
   int decimals = (dot >= 0 ? (StringLen(trimmed) - dot - 1) : 0);
   while(decimals < use_min)
     {
      trimmed += (decimals == 0 ? "." : "") + "0";
      decimals++;
     }

   return trimmed;
  }

string AFS_TD_FormatMoney(const double value)
  {
   return AFS_TD_FormatAdaptiveValue(value, 2, 10);
  }

string AFS_TD_FormatValueState(const bool is_known,const string known_value,const string pending_value,const string unavailable_value)
  {
   if(is_known)
      return known_value;
   if(StringLen(pending_value) > 0)
      return pending_value;
   return unavailable_value;
  }

string AFS_TD_TradeModeText(const int value)
  {
   if(value == 0) return "DISABLED";
   if(value == 1) return "LONG_ONLY";
   if(value == 2) return "SHORT_ONLY";
   if(value == 3) return "CLOSE_ONLY";
   if(value == 4) return "FULL_ACCESS";
   return "UNKNOWN";
  }

string AFS_TD_ExecModeText(const int value)
  {
   if(value == 0) return "REQUEST";
   if(value == 1) return "INSTANT";
   if(value == 2) return "MARKET";
   if(value == 3) return "EXCHANGE";
   return "UNKNOWN";
  }

string AFS_TD_CalcModeText(const int value)
  {
   if(value == 0) return "FOREX";
   if(value == 1) return "FOREX_NO_LEVERAGE";
   if(value == 2) return "FUTURES";
   if(value == 3) return "CFD";
   if(value == 4) return "CFD_INDEX";
   if(value == 5) return "CFD_LEVERAGE";
   if(value == 6) return "EXCHANGE_STOCKS";
   if(value == 7) return "EXCHANGE_FUTURES";
   if(value == 8) return "EXCHANGE_OPTIONS";
   if(value == 9) return "EXCHANGE_OPTIONS_MARGIN";
   if(value == 10) return "BONDS";
   if(value == 11) return "EXCHANGE_BONDS";
   if(value == 12) return "SERV_COLLATERAL";
   return "UNKNOWN";
  }

string AFS_TD_SwapModeText(const int value)
  {
   if(value == 0) return "DISABLED";
   if(value == 1) return "POINTS";
   if(value == 2) return "CURRENCY_SYMBOL";
   if(value == 3) return "CURRENCY_MARGIN";
   if(value == 4) return "CURRENCY_DEPOSIT";
   if(value == 5) return "INTEREST_CURRENT";
   if(value == 6) return "INTEREST_OPEN";
   if(value == 7) return "REOPEN_CURRENT";
   if(value == 8) return "REOPEN_BID";
   return "UNKNOWN";
  }

string AFS_TD_FillingModeText(const int value)
  {
   string text = "";
   if((value & 1) == 1)
      text = "FOK";
   if((value & 2) == 2)
     {
      if(StringLen(text) > 0)
         text += "|";
      text += "IOC";
     }
   if((value & 4) == 4)
     {
      if(StringLen(text) > 0)
         text += "|";
      text += "BOC";
     }
   if(StringLen(text) == 0)
      text = "NONE_OR_UNSPECIFIED";
   return text;
  }

string AFS_TD_SessionStateMeaning(const AFS_UniverseSymbol &rec)
  {
   if(rec.SessionState == "ACTIVE")
      return "SESSION_LIVE";
   if(rec.SessionState == "VERIFY")
      return "SESSION_UNCERTAIN_VERIFY_QUOTES";
   if(rec.SessionState == "CLOSED")
      return "SESSION_CLOSED_OR_NOT_TRADING";
   if(rec.SessionState == "DEAD")
      return "SESSION_DEAD_NO_LIVE_EVIDENCE";
   return "SESSION_STATE_UNSPECIFIED";
  }

string AFS_TD_TickValueValidationLabel(const AFS_UniverseSymbol &rec)
  {
   double trusted_tick_value = 0.0;
   string provenance = "";
   string trust_state = "";
   bool estimated = false;
   if(AFS_TA_SelectTrustedTickValue(rec, trusted_tick_value, provenance, trust_state, estimated))
      return trust_state;
   if(rec.SpecUpdateCount <= 0)
      return "PENDING_SPEC_SCAN";
   if(StringFind(rec.EconomicsFlags, "VALIDATION") >= 0 || StringFind(rec.NormalizationStatus, "PARTIAL") >= 0)
      return "PENDING_VALIDATION";
   return "PENDING_TRUSTED_TICK_VALUE";
  }

string AFS_TD_DerivedMoneyLabel(const double value,const bool can_compute_now,const string ready_label,const string deferred_label,const string unavailable_label)
  {
   if(value > 0.0)
      return ready_label;
   if(can_compute_now)
      return deferred_label;
   return unavailable_label;
  }

string AFS_TD_HistoryCoverageLine(const AFS_UniverseSymbol &rec)
  {
   string m15 = (rec.BarsM15 > 0 ? IntegerToString(rec.BarsM15) + " READY" : "PENDING");
   string h1  = (rec.BarsH1  > 0 ? IntegerToString(rec.BarsH1)  + " READY" : "PENDING");
   return "BarsM15=" + m15 +
          " | BarsH1=" + h1 +
          " | BarsM1=DEFERRED_NOT_TRACKED_IN_RUNTIME" +
          " | BarsM5=DEFERRED_NOT_TRACKED_IN_RUNTIME" +
          " | BarsH4=DEFERRED_NOT_TRACKED_IN_RUNTIME" +
          " | BarsD1=DEFERRED_NOT_TRACKED_IN_RUNTIME" +
          " | BarsW1=DEFERRED_NOT_TRACKED_IN_RUNTIME";
  }

string AFS_TD_SelectionReasonLine(const AFS_UniverseSymbol &rec)
  {
   string activity = "BLOCKED";
   if(rec.FrictionStatus == "PASS")
      activity = "ACTIVE_PASS";
   else if(rec.FrictionStatus == "WEAK")
      activity = "ACTIVE_WEAK";
   string ranking = (rec.FinalistSelected ? "FINALIST_ACTIVE_SET" : (rec.Selected ? "SELECTED_NOT_FINALIST" : "NOT_SELECTED"));
   return "ActivityLabel=" + activity +
          " | RankingState=" + ranking +
          " | BucketRank=" + IntegerToString(rec.BucketRank) +
          " | PromotionState=" + AFS_OutputSafeText(rec.PromotionState, "-") +
          " | PromotionReason=" + AFS_OutputSafeText(rec.PromotionReason, "-");
  }

string AFS_TD_TrustLabelLine(const AFS_UniverseSymbol &rec)
  {
   string trust = "BLOCKED";
   if(rec.FrictionStatus == "PASS" && rec.EconomicsTrust == "PASS" && rec.HistoryStatus == "PASS")
      trust = "TRUSTED_ACTIVE";
   else if(rec.FrictionStatus == "WEAK")
      trust = "WEAK_BUT_PUBLISHED";
   else if(rec.FrictionStatus == "FAIL")
      trust = "BLOCKED_NOT_FOR_ACTIVE_REFRESH";
   return "TrustLabel=" + trust +
          " | HistoryTrust=" + AFS_OutputSafeText(rec.HistoryStatus, "-") +
          " | EconomicsTrust=" + AFS_OutputSafeText(rec.EconomicsTrust, "-") +
          " | CorrelationState=" + AFS_OutputSafeText(rec.CorrContextFlag, "CORR_PENDING");
  }

string AFS_TD_LifecycleExplanation(const AFS_UniverseSymbol &rec,const bool include_heavy)
  {
   string freshness = (rec.QuotePresent ? "LIVE_QUOTE_VISIBLE" : "QUOTE_PENDING_OR_MISSING");
   string heavy_state = (include_heavy ? "HEAVY_CONTEXT_ATTACHED_NOW" : "HTF_HEAVY_CONTEXT_DEFERRED");
   return "LifecycleExplanation=ACTIVE_FILE_REFRESH_ONLY_WHILE_IN_ACTIVE_PUBLICATION_SET | FreshnessView=" + freshness + " | HeavyState=" + heavy_state;
  }

string AFS_TD_FormatOHLCSeries(const AFS_UniverseSymbol &rec,const ENUM_TIMEFRAMES tf,const int bars)
  {
   int want = bars;
   if(want < 1)
      want = 1;
   if(want > 20)
      want = 20;

   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   int copied = CopyRates(rec.Symbol, tf, 0, want, rates);
   if(copied <= 0)
      return "PENDING_NOT_AVAILABLE_IN_RUNTIME_RECORD";

   string out = "";
   for(int i = copied - 1; i >= 0; i--)
     {
      if(StringLen(out) > 0)
         out += " | ";
      out += "{" + TimeToString(rates[i].time, TIME_DATE|TIME_MINUTES) +
             ",O=" + AFS_TD_FormatPrice(rec, rates[i].open) +
             ",H=" + AFS_TD_FormatPrice(rec, rates[i].high) +
             ",L=" + AFS_TD_FormatPrice(rec, rates[i].low) +
             ",C=" + AFS_TD_FormatPrice(rec, rates[i].close) + "}";
     }

   return out;
  }

void AFS_TD_AppendLine(string &text,const string line)
  {
   text += line + "\n";
  }

double AFS_TD_SafeLevel(const string symbol,const ENUM_TIMEFRAMES tf,const int shift,const int mode)
  {
   if(mode == 0)
      return iOpen(symbol, tf, shift);
   if(mode == 1)
      return iHigh(symbol, tf, shift);
   return iLow(symbol, tf, shift);
  }

int AFS_TD_CompletionPercent(const AFS_UniverseSymbol &rec,const string pending_reasons)
  {
   int total = 5;
   int ready = 0;
   if(AFS_TraderDossierHasImmediateKnownData(rec)) ready++;
   if(rec.HistoryUpdateCount > 0 && rec.BarsM15 > 0 && rec.BarsH1 > 0) ready++;
   if(rec.QuotePresent && rec.TickAgeSec >= 0 && rec.SpreadSnapshot > 0.0) ready++;
   if(rec.SpecUpdateCount > 0 && rec.TickValueValidated > 0.0) ready++;
   if(rec.CorrContextFlag != "CORR_PENDING" && StringLen(rec.CorrClosestSymbol) > 0) ready++;
   if(StringFind(pending_reasons, "PENDING_") < 0)
      ready = total;
   return (int)MathRound((100.0 * ready) / total);
  }

string AFS_TD_DossierVersionText()
  {
   return "v" + AFS_VERSION_TEXT;
  }

string AFS_TD_DossierPhaseText()
  {
   return AFS_DISPLAY_PHASE_TAG;
  }

string AFS_TD_DossierStepText()
  {
   return AFS_DISPLAY_STEP_TAG;
  }

string AFS_TD_DossierPhaseStepContext()
  {
   return AFS_GetDisplayPhaseStepContext();
  }

string AFS_TD_DossierDeferredPreservationText()
  {
   return AFS_GetDeferredFeaturePreservationLine();
  }

string AFS_TD_AnalyticsBarsText(const int bars,const bool heavy_requested)
  {
   if(bars > 0)
      return IntegerToString(bars);
   if(heavy_requested)
      return "PENDING_OR_UNAVAILABLE";
   return "DEFERRED_HEAVY_REFRESH";
  }

string AFS_TD_AnalyticsMetricText(const AFS_UniverseSymbol &rec,const bool has_value,const double value)
  {
   if(has_value)
      return AFS_TD_FormatPrice(rec, value);
   return "PENDING_OR_UNAVAILABLE";
  }

string AFS_TD_EffectiveMetricText(const AFS_UniverseSymbol &rec,const bool has_value,const double value,const string source)
  {
   if(has_value && value > 0.0)
      return AFS_TD_FormatPrice(rec, value);
   if(StringLen(source) > 0)
      return source;
   return "UNAVAILABLE_TRUE";
  }

string AFS_TD_RawMetricText(const AFS_UniverseSymbol &rec,const double value,const string unavailable_label="UNAVAILABLE_TRUE")
  {
   if(value > 0.0)
      return AFS_TD_FormatPrice(rec, value);
   return unavailable_label;
  }

string AFS_TD_AnalyticsPercentText(const bool has_value,const double value)
  {
   if(has_value)
      return AFS_TD_FormatPercent(value);
   return "PENDING_OR_UNAVAILABLE";
  }

string AFS_TD_AnalyticsRangePositionText(const double value,const bool heavy_requested)
  {
   if(value >= 0.0)
      return AFS_TD_FormatPercent(value);
   if(heavy_requested)
      return "PENDING_OR_UNAVAILABLE";
   return "DEFERRED_HEAVY_REFRESH";
  }

string AFS_TD_AnalyticsStateText(const string value,const bool heavy_requested)
  {
   if(StringLen(value) > 0 && value != "PENDING")
      return value;
   if(heavy_requested)
      return "PENDING_OR_UNAVAILABLE";
   return "DEFERRED_HEAVY_REFRESH";
  }


//==================================================================
// CORE-STABILITY NOTE: dossier build
// Reads prepared/effective analytics for trader-facing output. Avoid
// turning this writer into a hidden compute engine beyond lightweight
// prepared-view assembly already present in the legacy implementation.
//==================================================================
string AFS_TD_BuildDossierText(const AFS_RuntimeState &state,
                               const AFS_UniverseSymbol &rec,
                               const datetime now,
                               const bool include_heavy,
                               const string completion_state,
                               const string pending_reasons)
  {
   AFS_TraderAnalytics analytics;
   AFS_TA_Build(rec, include_heavy, analytics);

   string pipeline_maturity_state = ((rec.SurfaceUpdateCount > 0 && rec.SpecUpdateCount > 0 && analytics.HistoryState == "READY") ? "READY" :
                                     ((rec.SurfaceUpdateCount > 0 || rec.SpecUpdateCount > 0 || analytics.HistoryState == "PARTIAL") ? "PARTIAL" : "WARMING"));
   string shortlist_stability_state = (rec.FinalistSelected ? (rec.FrictionStatus == "PASS" ? "STABLE" : "STABILIZING") : "UNSTABLE");
   string correlation_readiness_state = (rec.FinalistSelected ? ((StringLen(rec.CorrClosestSymbol) > 0 && rec.CorrContextFlag != "CORR_PENDING") ? "READY" : "PENDING") : "PARTIAL");
   datetime freshest_symbol_update = rec.LastSurfaceUpdateAt;
   if(rec.LastHistoryUpdateAt > freshest_symbol_update)
      freshest_symbol_update = rec.LastHistoryUpdateAt;
   if(rec.LastSpecUpdateAt > freshest_symbol_update)
      freshest_symbol_update = rec.LastSpecUpdateAt;
   string dossier_freshness_state = (freshest_symbol_update > 0 && (now - freshest_symbol_update) <= 20 ? "FRESH" :
                                    (freshest_symbol_update > 0 && (now - freshest_symbol_update) <= 120 ? "AGING" : "STALE"));
   string scanner_confidence_state = ((rec.FrictionStatus == "PASS" && analytics.DataIntegrityScore >= 90.0) ? "HIGH" :
                                     ((rec.FrictionStatus == "WEAK" || analytics.DataIntegrityScore >= 70.0) ? "BUILDING" : "LOW"));
   string tactical_readiness_band = (analytics.TacticalLightState == "READY" && analytics.TacticalMediumState == "READY" ?
                                     (analytics.TacticalHeavyState == "READY" ? "HEAVY_READY" : "HEAVY_DEFERRED") :
                                     (analytics.TacticalLightState == "READY" ? "MEDIUM_PENDING" : "LIGHT_PENDING"));
   string active_publication_health_state = (rec.FinalistSelected && rec.QuotePresent && rec.Bid > 0.0 && rec.Ask > 0.0 ? "GOOD" :
                                            (rec.FinalistSelected ? "MIXED" : "WEAK"));
   string data_integrity_state = (analytics.DataIntegrityScore >= 90.0 ? "VALIDATED" :
                                 (analytics.DataIntegrityScore >= 70.0 ? "MIXED" : "FRAGILE"));
   string execution_readiness_state = (analytics.ExecutionPermission == "ALLOWED" ? "READY" :
                                      (analytics.ExecutionPermission == "HOLD" ? "BUILDING" : "CAUTION"));

   string lifecycle_now = AFS_FormatTime(now);
   double reference_price = AFS_TraderReferencePrice(rec);
   double atr_ref = (analytics.EffectiveAtrM15 > analytics.EffectiveAtrH1 ? analytics.EffectiveAtrM15 : analytics.EffectiveAtrH1);
   if(atr_ref <= 0.0)
      atr_ref = rec.BaselineMove;

   double session_range = (rec.SessionHigh > 0.0 && rec.SessionLow > 0.0 ? MathAbs(rec.SessionHigh - rec.SessionLow) : 0.0);
   double session_range_used = (atr_ref > 0.0 ? (session_range / atr_ref) * 100.0 : 0.0);
   double distance_to_high_pts = AFS_TraderDistancePoints(reference_price, rec.SessionHigh, rec.Point);
   double distance_to_low_pts  = AFS_TraderDistancePoints(reference_price, rec.SessionLow, rec.Point);
   double atr_buffer_tight = (atr_ref > 0.0 ? atr_ref * 0.15 : 0.0);
   double atr_buffer_wide  = (atr_ref > 0.0 ? atr_ref * 0.30 : 0.0);
   bool equal_highs_nearby = (rec.SessionHigh > 0.0 && rec.BidHigh > 0.0 && MathAbs(rec.SessionHigh - rec.BidHigh) <= atr_buffer_tight && atr_buffer_tight > 0.0);
   bool equal_lows_nearby  = (rec.SessionLow > 0.0 && rec.BidLow > 0.0 && MathAbs(rec.SessionLow - rec.BidLow) <= atr_buffer_tight && atr_buffer_tight > 0.0);
   bool liquidity_sweep_up = (rec.AskHigh > 0.0 && rec.SessionHigh > 0.0 && rec.AskHigh > (rec.SessionHigh + atr_buffer_tight));
   bool liquidity_sweep_down = (rec.BidLow > 0.0 && rec.SessionLow > 0.0 && rec.BidLow < (rec.SessionLow - atr_buffer_tight));
   bool false_break_up = (liquidity_sweep_up && rec.SessionClose > 0.0 && rec.SessionClose < rec.SessionHigh);
   bool false_break_down = (liquidity_sweep_down && rec.SessionClose > 0.0 && rec.SessionClose > rec.SessionLow);

   double compression_score = 0.0;
   double expansion_score   = 0.0;
   if(session_range > 0.0 && atr_ref > 0.0)
     {
      double ratio = session_range / atr_ref;
      compression_score = 100.0 * (1.0 - MathMin(1.0, ratio));
      expansion_score   = 100.0 * MathMin(1.0, ratio / 2.0);
     }

   double pdh = AFS_TD_SafeLevel(rec.Symbol, PERIOD_D1, 1, 1);
   double pdl = AFS_TD_SafeLevel(rec.Symbol, PERIOD_D1, 1, 2);
   double pwh = AFS_TD_SafeLevel(rec.Symbol, PERIOD_W1, 1, 1);
   double pwl = AFS_TD_SafeLevel(rec.Symbol, PERIOD_W1, 1, 2);
   double today_open = AFS_TD_SafeLevel(rec.Symbol, PERIOD_D1, 0, 0);
   double week_open  = AFS_TD_SafeLevel(rec.Symbol, PERIOD_W1, 0, 0);

   double tick_value_raw = (rec.TickValueRaw > 0.0 ? rec.TickValueRaw : rec.TickValue);
   double trusted_tick_value = 0.0;
   string trusted_tick_value_provenance = "";
   string trusted_tick_value_state = "";
   bool trusted_tick_value_estimated = false;
   bool has_trusted_tick_value = AFS_TA_SelectTrustedTickValue(rec,
                                                               trusted_tick_value,
                                                               trusted_tick_value_provenance,
                                                               trusted_tick_value_state,
                                                               trusted_tick_value_estimated);

   double spread_price_now = AFS_TD_SpreadPriceNow(rec);
   double spread_money = AFS_TD_SafeDerivedMoneyFromPriceDistance(rec, spread_price_now);
   double stop_money_m15 = AFS_TD_SafeDerivedMoneyFromPriceDistance(rec, rec.AtrM15);
   bool spread_money_estimated = trusted_tick_value_estimated;
   bool stop_money_estimated = trusted_tick_value_estimated;

   if(!has_trusted_tick_value)
     {
      spread_money = 0.0;
      stop_money_m15 = 0.0;
      spread_money_estimated = false;
      stop_money_estimated = false;
     }

   double margin_buy_min_lot = 0.0;
   double margin_sell_min_lot = 0.0;
   bool has_margin_buy_min_lot = AFS_TD_CalcMarginPerVolume(rec, rec.VolumeMin, ORDER_TYPE_BUY, margin_buy_min_lot);
   bool has_margin_sell_min_lot = AFS_TD_CalcMarginPerVolume(rec, rec.VolumeMin, ORDER_TYPE_SELL, margin_sell_min_lot);
   double margin_per_min_lot = 0.0;
   bool has_margin_per_min_lot = false;
   if(has_margin_buy_min_lot && has_margin_sell_min_lot)
     {
      margin_per_min_lot = MathMax(margin_buy_min_lot, margin_sell_min_lot);
      has_margin_per_min_lot = true;
     }
   else if(has_margin_buy_min_lot)
     {
      margin_per_min_lot = margin_buy_min_lot;
      has_margin_per_min_lot = true;
     }
   else if(has_margin_sell_min_lot)
     {
      margin_per_min_lot = margin_sell_min_lot;
      has_margin_per_min_lot = true;
     }

   int completion_percent = AFS_TD_CompletionPercent(rec, pending_reasons);
   string market_state_context = AFS_TraderMarketStateContext(session_range, atr_ref);

   string t = "";
   AFS_TD_AppendLine(t, "Aegis Forge Scanner - Trader Dossier");
   AFS_TD_AppendLine(t, "");
   AFS_TD_AppendLine(t, "[HEADER_IDENTITY]");
   AFS_TD_AppendLine(t, "SystemName: Aegis Forge Scanner");
   AFS_TD_AppendLine(t, "ServerName: " + state.ServerName);
   AFS_TD_AppendLine(t, "ServerKey: " + state.PathState.ServerKey);
   AFS_TD_AppendLine(t, "Build: DOSSIER_PRESENTATION_ONLY | Version: " + AFS_TD_DossierVersionText());
   AFS_TD_AppendLine(t, "Phase: " + AFS_TD_DossierPhaseText() + " | Step: " + AFS_TD_DossierStepText());
   AFS_TD_AppendLine(t, "PhaseStepContext: " + AFS_TD_DossierPhaseStepContext());
   AFS_TD_AppendLine(t, "UpdatedAt: " + lifecycle_now);
   AFS_TD_AppendLine(t, "Symbol: " + rec.Symbol);
   AFS_TD_AppendLine(t, "CanonicalSymbol: " + AFS_OutputSafeText(rec.CanonicalSymbol, rec.Symbol));
   AFS_TD_AppendLine(t, "DisplayName: " + AFS_OutputSafeText(rec.DisplayName, AFS_OutputSafeText(rec.Description, "-")));
   AFS_TD_AppendLine(t, "AssetClass: " + AFS_OutputSafeText(rec.AssetClass, AFS_OutputSafeText(rec.BrokerClass, "-")));
   AFS_TD_AppendLine(t, "PrimaryBucket: " + AFS_OutputSafeText(rec.PrimaryBucket, "UNBUCKETED"));
   AFS_TD_AppendLine(t, "ThemeBucket: " + AFS_OutputSafeText(rec.ThemeBucket, "-"));
   AFS_TD_AppendLine(t, "Sector: " + AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "-")));
   AFS_TD_AppendLine(t, "Industry: " + AFS_OutputSafeText(rec.Industry, AFS_OutputSafeText(rec.BrokerIndustry, "-")));
   AFS_TD_AppendLine(t, "Exchange: " + AFS_OutputSafeText(rec.Exchange, "-"));
   AFS_TD_AppendLine(t, "ISIN: " + AFS_OutputSafeText(rec.ISIN, "-"));
   AFS_TD_AppendLine(t, "CurrencyBase: " + AFS_OutputSafeText(rec.CurrencyBase, "-"));
   AFS_TD_AppendLine(t, "MarginCurrency: " + AFS_OutputSafeText(rec.CurrencyMargin, "-"));
   AFS_TD_AppendLine(t, "ProfitCurrency: " + AFS_OutputSafeText(rec.CurrencyProfit, "-"));
   AFS_TD_AppendLine(t, "Role: " + AFS_FinalOutputRoleText(rec));
   AFS_TD_AppendLine(t, "Status: " + AFS_OutputSafeText(rec.FrictionStatus, "-"));
   AFS_TD_AppendLine(t, "Score: " + AFS_FormatScore2(rec.TotalScore));
   AFS_TD_AppendLine(t, "BucketRank: " + IntegerToString(rec.BucketRank));
   AFS_TD_AppendLine(t, "CorrClosestSymbol: " + AFS_OutputSafeText(rec.CorrClosestSymbol, "-"));
   AFS_TD_AppendLine(t, "CorrFlag: " + AFS_OutputSafeText(rec.CorrContextFlag, "CORR_PENDING"));
   AFS_TD_AppendLine(t, "DossierFile: " + AFS_TraderDossierFileName(rec));
   AFS_TD_AppendLine(t, "NormalizedSymbol: " + AFS_OutputSafeText(rec.NormalizedSymbol, "-") + " | NormalizedAlias: " + AFS_OutputSafeText(rec.NormalizedAlias, "-"));
   AFS_TD_AppendLine(t, "SubType: " + AFS_OutputSafeText(rec.SubType, "-") + " | AliasKind: " + AFS_OutputSafeText(rec.AliasKind, "-"));
   AFS_TD_AppendLine(t, "ClassificationStatus: " + AFS_OutputSafeText(rec.ClassificationStatus, "-") + " | Confidence: " + AFS_OutputSafeText(rec.ClassificationConfidence, "-"));
   AFS_TD_AppendLine(t, "ClassificationReviewStatus: " + AFS_OutputSafeText(rec.ClassificationReviewStatus, "-") + " | Resolved: " + AFS_BoolText(rec.ClassificationResolved));
   AFS_TD_AppendLine(t, "ClassificationNotes: " + AFS_OutputSafeText(rec.ClassificationNotes, "-"));
   AFS_TD_AppendLine(t, "");

   AFS_TD_AppendLine(t, "[LIFECYCLE_STATUS]");
   AFS_TD_AppendLine(t, "DossierStatus: ACTIVE");
   AFS_TD_AppendLine(t, "ActiveInCurrentSummary: true");
   AFS_TD_AppendLine(t, "ActivePublicationGroup: SECTOR:" + AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "UNSECTORED")));
   AFS_TD_AppendLine(t, "LastActiveSummaryAt: " + lifecycle_now);
   AFS_TD_AppendLine(t, "LastDossierWriteAt: " + lifecycle_now);
   AFS_TD_AppendLine(t, "FreshnessThresholdMinutes: 10");
   AFS_TD_AppendLine(t, AFS_TD_LifecycleExplanation(rec, include_heavy));
   AFS_TD_AppendLine(t, "CompletionState: " + completion_state);
   AFS_TD_AppendLine(t, "CompletionPercent: " + IntegerToString(completion_percent));
   AFS_TD_AppendLine(t, "PendingReasons: " + pending_reasons);
   AFS_TD_AppendLine(t, "PublicationState: ACTIVE");
   AFS_TD_AppendLine(t, "PublicationScope: " + AFS_GetTraderPublicationScope());
   AFS_TD_AppendLine(t, "SelectionPolicy: " + AFS_GetTraderPublicationSelectionPolicy());
   AFS_TD_AppendLine(t, "ImmediateKnownDataPolicy: WRITE_STATIC_SPEC_SELECTION_NOW");
   AFS_TD_AppendLine(t, "PendingFieldPolicy: MARK_HISTORY_LIVE_CORRELATION_PENDING");
   AFS_TD_AppendLine(t, "InactivePolicy: " + AFS_GetTraderPublicationInactivePolicy());
   AFS_TD_AppendLine(t, "ReentryPolicy: " + AFS_GetTraderPublicationReentryPolicy());
   AFS_TD_AppendLine(t, "CarryForwardMode: " + AFS_GetTraderDossierCarryForwardMode(rec));
   AFS_TD_AppendLine(t, "TacticalRefreshMode: " + (include_heavy ? "HEAVY" : "LIGHT"));
   AFS_TD_AppendLine(t, "DeferredFeaturePreservation: PRESERVED_INACTIVE_DOWNSTREAM_ONLY");
   AFS_TD_AppendLine(t, AFS_TD_DossierDeferredPreservationText());
   AFS_TD_AppendLine(t, "Selected: " + AFS_BoolText(rec.Selected) + " | ScopeIncluded: " + AFS_BoolText(rec.ScopeIncluded) + " | FinalistSelected: " + AFS_BoolText(rec.FinalistSelected));
   AFS_TD_AppendLine(t, AFS_TD_SelectionReasonLine(rec));
   AFS_TD_AppendLine(t, "PromotionCandidate: " + AFS_BoolText(rec.PromotionCandidate) + " | PromotionReason: " + AFS_OutputSafeText(rec.PromotionReason, "-"));
   AFS_TD_AppendLine(t, "LastRankingUpdateAt: " + AFS_FormatTime(rec.LastRankingUpdateAt));
   AFS_TD_AppendLine(t, "");

   AFS_TD_AppendLine(t, "[TRADABILITY_BLOCK]");
   AFS_TD_AppendLine(t, "FinalTradabilityStatus=" + AFS_OutputSafeText(rec.FrictionStatus, "-") + " | QuoteState=" + AFS_OutputSafeText(rec.QuoteState, "-") + " | SessionState=" + AFS_OutputSafeText(rec.SessionState, "-"));
   AFS_TD_AppendLine(t, "SessionStateMeaning=" + AFS_TD_SessionStateMeaning(rec));
   AFS_TD_AppendLine(t, "TickAge=" + IntegerToString(rec.TickAgeSec) + " | FreshnessScore=" + AFS_FormatScore2(rec.FreshnessScore) + " | UpdateCount=" + IntegerToString(rec.FrictionUpdateCount));
   AFS_TD_AppendLine(t, "LastTickTime=" + AFS_FormatTime(rec.LastTickTime) + " | LastSurfaceUpdateAt=" + AFS_FormatTime(rec.LastSurfaceUpdateAt) + " | SurfaceUpdateCount=" + IntegerToString(rec.SurfaceUpdateCount));
   AFS_TD_AppendLine(t, "Bid=" + AFS_TD_FormatPrice(rec, rec.Bid) + " | Ask=" + AFS_TD_FormatPrice(rec, rec.Ask) + " | SpreadNow=" + (spread_price_now > 0.0 ? AFS_TD_FormatPrice(rec, spread_price_now) : "PENDING_OR_UNAVAILABLE"));
   AFS_TD_AppendLine(t, "SpreadInternalPoints=" + AFS_TD_FormatPointLike(rec, rec.SpreadSnapshot) + " | SpreadDisplayFactor=" + (rec.Point > 0.0 ? AFS_TD_FormatPointLike(rec, rec.Point) : "PENDING_OR_UNAVAILABLE") + " | SpreadNormalizationState=" + (spread_price_now > 0.0 ? "DISPLAY_NORMALIZED_FROM_INTERNAL_POINTS" : "PENDING_OR_UNAVAILABLE"));
   AFS_TD_AppendLine(t, "MedianSpread=" + AFS_TD_FormatPointLike(rec, rec.MedianSpread) + " | MaxSpread=" + AFS_TD_FormatPointLike(rec, rec.MaxSpread) + " | SpreadAtrRatio=" + AFS_FormatScore2(rec.SpreadAtrRatio));
   AFS_TD_AppendLine(t, "TacticalLight=" + AFS_OutputSafeText(analytics.TacticalLightState, "PENDING") +
                      " | SpreadBand=" + AFS_OutputSafeText(analytics.SpreadBand, "PENDING") +
                      " | FreshnessBand=" + AFS_OutputSafeText(analytics.FreshnessBand, "PENDING") +
                      " | ExecutionQualityState=" + AFS_OutputSafeText(analytics.ExecutionQualityState, "PENDING"));
   AFS_TD_AppendLine(t, "RecentSpreadBand=" +
                      "Min=" + AFS_TD_TacticalMetricText(rec, analytics.HasRecentSpreadStats, analytics.RecentSpreadMinPrice) +
                      " | Avg=" + AFS_TD_TacticalMetricText(rec, analytics.HasRecentSpreadStats, analytics.RecentSpreadAvgPrice) +
                      " | Max=" + AFS_TD_TacticalMetricText(rec, analytics.HasRecentSpreadStats, analytics.RecentSpreadMaxPrice));
   AFS_TD_AppendLine(t, "LivelinessScore=" + AFS_FormatScore2(rec.LivelinessScore) + " | NoTradeFlag=" + AFS_BoolText(rec.FrictionStatus == "FAIL") + " | NoTradeReason=" + AFS_FinalOutputReasonText(rec));
   AFS_TD_AppendLine(t, "TradeAllowed=" + AFS_BoolText(rec.TradeAllowed) + " | Exists=" + AFS_BoolText(rec.Exists) + " | Visible=" + AFS_BoolText(rec.Visible) + " | Custom=" + AFS_BoolText(rec.Custom));
   AFS_TD_AppendLine(t, "QuotePresent=" + AFS_BoolText(rec.QuotePresent) + " | SurfaceSeen=" + AFS_BoolText(rec.SurfaceSeen) + " | SpreadFloat=" + AFS_BoolText(rec.SpreadFloat));
   AFS_TD_AppendLine(t, "SessionQuotes=" + AFS_OutputSafeText(rec.SessionQuotes, "-") + " | SessionTrades=" + AFS_OutputSafeText(rec.SessionTrades, "-"));
   AFS_TD_AppendLine(t, "FrictionTruthState=" + AFS_OutputSafeText(rec.FrictionTruthState, "-") + " | FrictionFlags=" + AFS_OutputSafeText(rec.FrictionFlags, "-"));
   AFS_TD_AppendLine(t, "FrictionHydrationStage=" + AFS_OutputSafeText(analytics.DisplayHydrationStage, "-") + " | HydrationScore=" + IntegerToString(analytics.DisplayHydrationScore) + " | SamplesUsed=" + IntegerToString(rec.FrictionSampleCountUsed) + " | RuntimeHydrationStage=" + AFS_OutputSafeText(rec.FrictionHydrationStage, "-"));
   AFS_TD_AppendLine(t, "FrictionHoldPass=" + AFS_BoolText(rec.FrictionHoldPass) + " | MarketLive=" + AFS_BoolText(rec.FrictionMarketLive) + " | SessionOpen=" + AFS_BoolText(rec.FrictionSessionOpen) + " | QuoteUsable=" + AFS_BoolText(rec.FrictionQuoteUsable));
   AFS_TD_AppendLine(t, "GoodPasses=" + IntegerToString(rec.FrictionGoodPasses) + " | BadPasses=" + IntegerToString(rec.FrictionBadPasses) + " | LastFrictionUpdateAt=" + AFS_FormatTime(rec.LastFrictionUpdateAt));
   AFS_TD_AppendLine(t, "");

   AFS_TD_AppendLine(t, "[STRUCTURE_BLOCK]");
   AFS_TD_AppendLine(t, "MarketStructureState=" + AFS_OutputSafeText(rec.HistoryStatus, "-") + " | HistoryFlags=" + AFS_OutputSafeText(rec.HistoryFlags, "-"));
   AFS_TD_AppendLine(t, "LastHistoryUpdateAt=" + AFS_FormatTime(rec.LastHistoryUpdateAt) + " | HistoryUpdateCount=" + IntegerToString(rec.HistoryUpdateCount));
   AFS_TD_AppendLine(t, AFS_TD_HistoryCoverageLine(rec));
   AFS_TD_AppendLine(t, "PDH=" + (pdh > 0.0 ? AFS_TD_FormatPrice(rec, pdh) : "PENDING_NOT_AVAILABLE_IN_RUNTIME_RECORD") + " | PDL=" + (pdl > 0.0 ? AFS_TD_FormatPrice(rec, pdl) : "PENDING_NOT_AVAILABLE_IN_RUNTIME_RECORD"));
   AFS_TD_AppendLine(t, "PWH=" + (pwh > 0.0 ? AFS_TD_FormatPrice(rec, pwh) : "PENDING_NOT_AVAILABLE_IN_RUNTIME_RECORD") + " | PWL=" + (pwl > 0.0 ? AFS_TD_FormatPrice(rec, pwl) : "PENDING_NOT_AVAILABLE_IN_RUNTIME_RECORD"));
   AFS_TD_AppendLine(t, "TodayOpen=" + (today_open > 0.0 ? AFS_TD_FormatPrice(rec, today_open) : "PENDING_NOT_AVAILABLE_IN_RUNTIME_RECORD") + " | WeekOpen=" + (week_open > 0.0 ? AFS_TD_FormatPrice(rec, week_open) : "PENDING_NOT_AVAILABLE_IN_RUNTIME_RECORD"));
   AFS_TD_AppendLine(t, "CurrentSessionHigh=" + AFS_TD_FormatPrice(rec, rec.SessionHigh) + " | CurrentSessionLow=" + AFS_TD_FormatPrice(rec, rec.SessionLow));
   AFS_TD_AppendLine(t, "SessionRangeUsedPercent=" + (atr_ref > 0.0 ? AFS_TD_FormatPercent(session_range_used) : "PENDING_NOT_AVAILABLE_IN_RUNTIME_RECORD"));
   AFS_TD_AppendLine(t, "LastTradableEvidenceAt=" + AFS_FormatTime(rec.LastTradableEvidenceAt) + " | LastAliveEvidenceAt=" + AFS_FormatTime(rec.LastAliveEvidenceAt));
   AFS_TD_AppendLine(t, "AnalyticsHistoryCoverage=" +
                      "M1=" + AFS_TD_AnalyticsBarsText(analytics.BarsM1, true) +
                      " | M5=" + AFS_TD_AnalyticsBarsText(analytics.BarsM5, true) +
                      " | M15=" + AFS_TD_AnalyticsBarsText(analytics.BarsM15, true) +
                      " | H1=" + AFS_TD_AnalyticsBarsText(analytics.BarsH1, true) +
                      " | H4=" + AFS_TD_AnalyticsBarsText(analytics.BarsH4, include_heavy) +
                      " | D1=" + AFS_TD_AnalyticsBarsText(analytics.BarsD1, include_heavy) +
                      " | W1=" + AFS_TD_AnalyticsBarsText(analytics.BarsW1, include_heavy));
   AFS_TD_AppendLine(t, "AnalyticsHistoryState=" + analytics.HistoryState +
                      " | HistoryCompleteness=" + AFS_TD_AnalyticsPercentText(analytics.HasHistoryCompleteness, analytics.HistoryCompleteness) +
                      " | DeferredReasons=" + AFS_OutputSafeText(analytics.DeferredReasons, "-"));
   AFS_TD_AppendLine(t, "HTFCompletion=" +
                      "HTFReadiness=" + AFS_OutputSafeText(analytics.HTFReadiness, "PENDING") +
                      " | HistoryDepthStatus=" + AFS_OutputSafeText(analytics.HistoryDepthStatus, "PENDING") +
                      " | HTFDeferredReason=" + AFS_OutputSafeText(analytics.HTFDeferredReason, "-"));
   AFS_TD_AppendLine(t, "CoverageStates=" +
                      "M1=" + AFS_OutputSafeText(analytics.CoverageStateM1, "PENDING") +
                      " | M5=" + AFS_OutputSafeText(analytics.CoverageStateM5, "PENDING") +
                      " | M15=" + AFS_OutputSafeText(analytics.CoverageStateM15, "PENDING") +
                      " | H1=" + AFS_OutputSafeText(analytics.CoverageStateH1, "PENDING") +
                      " | H4=" + AFS_OutputSafeText(analytics.CoverageStateH4, "PENDING") +
                      " | D1=" + AFS_OutputSafeText(analytics.CoverageStateD1, "PENDING") +
                      " | W1=" + AFS_OutputSafeText(analytics.CoverageStateW1, "PENDING"));
   AFS_TD_AppendLine(t, "TacticalReadiness=" + AFS_OutputSafeText(analytics.TacticalReadiness, "PENDING") +
                      " | TacticalContextStatus=" + AFS_OutputSafeText(analytics.TacticalContextStatus, "PENDING") +
                      " | TacticalHeavyState=" + AFS_OutputSafeText(analytics.TacticalHeavyState, "PENDING"));
   AFS_TD_AppendLine(t, "TacticalDeferredReason=" + AFS_OutputSafeText(analytics.TacticalDeferredReason, "-"));
   AFS_TD_AppendLine(t, "");

   AFS_TD_AppendLine(t, "[VOLATILITY_BLOCK]");
   AFS_TD_AppendLine(t, "AtrM15=" + AFS_TD_EffectiveMetricText(rec, analytics.HasEffectiveAtrM15, analytics.EffectiveAtrM15, analytics.AtrM15Source) + " | AtrH1=" + AFS_TD_EffectiveMetricText(rec, analytics.HasEffectiveAtrH1, analytics.EffectiveAtrH1, analytics.AtrH1Source) + " | BaselineMove=" + AFS_TD_RawMetricText(rec, rec.BaselineMove));
   AFS_TD_AppendLine(t, "AtrSources=" + AFS_OutputSafeText(analytics.AtrM15Source, "UNAVAILABLE") + " | H1Source=" + AFS_OutputSafeText(analytics.AtrH1Source, "UNAVAILABLE"));
   AFS_TD_AppendLine(t, "DailyChangePercent=" + AFS_TD_FormatPercent(rec.DailyChangePercent) + " | MovementCapacityScore=" + AFS_FormatScore2(rec.MovementCapacityScore) + " | SurfaceFlags=" + AFS_OutputSafeText(rec.SurfaceFlags, "-"));
   AFS_TD_AppendLine(t, "AnalyticsAtrStack=" +
                      "M5=" + AFS_TD_AnalyticsMetricText(rec, analytics.HasAtrM5, analytics.AtrM5) +
                      " | M15=" + AFS_TD_AnalyticsMetricText(rec, analytics.HasAtrM15, analytics.AtrM15) +
                      " | H1=" + AFS_TD_AnalyticsMetricText(rec, analytics.HasAtrH1, analytics.AtrH1) +
                      " | H4=" + AFS_TD_AnalyticsMetricText(rec, analytics.HasAtrH4, analytics.AtrH4) +
                      " | D1=" + AFS_TD_AnalyticsMetricText(rec, analytics.HasAtrD1, analytics.AtrD1));
   AFS_TD_AppendLine(t, "AnalyticsExpectedMove=" +
                      "M15=" + AFS_TD_AnalyticsMetricText(rec, analytics.HasExpectedMoveM15, analytics.ExpectedMoveM15) +
                      " | H1=" + AFS_TD_AnalyticsMetricText(rec, analytics.HasExpectedMoveH1, analytics.ExpectedMoveH1) +
                      " | H4=" + AFS_TD_AnalyticsMetricText(rec, analytics.HasExpectedMoveH4, analytics.ExpectedMoveH4) +
                      " | D1=" + AFS_TD_AnalyticsMetricText(rec, analytics.HasExpectedMoveD1, analytics.ExpectedMoveD1) +
                      " | AtrState=" + analytics.AtrState);
   AFS_TD_AppendLine(t, "");

   AFS_TD_AppendLine(t, "[LIQUIDITY_BLOCK]");
   AFS_TD_AppendLine(t, "SessionHigh=" + AFS_TD_FormatPrice(rec, rec.SessionHigh) + " | SessionLow=" + AFS_TD_FormatPrice(rec, rec.SessionLow) + " | SessionOpen=" + AFS_TD_FormatPrice(rec, rec.SessionOpen) + " | SessionClose=" + AFS_TD_FormatPrice(rec, rec.SessionClose));
   AFS_TD_AppendLine(t, "BidHigh=" + AFS_TD_FormatPrice(rec, rec.BidHigh) + " | BidLow=" + AFS_TD_FormatPrice(rec, rec.BidLow) + " | AskHigh=" + AFS_TD_FormatPrice(rec, rec.AskHigh) + " | AskLow=" + AFS_TD_FormatPrice(rec, rec.AskLow));
   AFS_TD_AppendLine(t, "DistanceToSwingHigh=" + AFS_FormatScore2(distance_to_high_pts) + " | DistanceToSwingLow=" + AFS_FormatScore2(distance_to_low_pts) + " | EqualHighsNearby=" + (equal_highs_nearby ? "YES" : "NO") + " | EqualLowsNearby=" + (equal_lows_nearby ? "YES" : "NO"));
   AFS_TD_AppendLine(t, "LiquiditySweepUp=" + (liquidity_sweep_up ? "YES" : "NO") + " | LiquiditySweepDown=" + (liquidity_sweep_down ? "YES" : "NO") + " | FalseBreakUp=" + (false_break_up ? "YES" : "NO") + " | FalseBreakDown=" + (false_break_down ? "YES" : "NO"));
   AFS_TD_AppendLine(t, "BreakoutBuyLevel=" + AFS_TD_FormatPrice(rec, rec.SessionHigh) + " | BreakoutSellLevel=" + AFS_TD_FormatPrice(rec, rec.SessionLow) + " | ATRBufferTight=" + AFS_TD_FormatPrice(rec, atr_buffer_tight) + " | ATRBufferWide=" + AFS_TD_FormatPrice(rec, atr_buffer_wide));
   AFS_TD_AppendLine(t, "CompressionScore=" + AFS_FormatScore2(compression_score) + " | ExpansionScore=" + AFS_FormatScore2(expansion_score) + " | MarketStateContext=" + market_state_context + " | ChopInterpretation=" + (market_state_context == "BALANCED_CHOP" ? "YES" : "NO"));
   AFS_TD_AppendLine(t, "AnalyticsTrendRegime=" +
                      "TrendStrengthM15=" + AFS_TD_AnalyticsPercentText(analytics.HasTrendStrengthM15, analytics.TrendStrengthM15) +
                      " | TrendStrengthH1=" + AFS_TD_AnalyticsPercentText(analytics.HasTrendStrengthH1, analytics.TrendStrengthH1) +
                      " | HTFTrend=" + AFS_TD_AnalyticsStateText(analytics.HTFTrend, include_heavy) +
                      " | VolatilityRegime=" + AFS_TD_AnalyticsStateText(analytics.VolatilityRegime, include_heavy));
   AFS_TD_AppendLine(t, "AnalyticsRangePosition=" +
                      "Daily=" + AFS_TD_AnalyticsRangePositionText(analytics.RangePositionDaily, include_heavy) +
                      " | Weekly=" + AFS_TD_AnalyticsRangePositionText(analytics.RangePositionWeekly, include_heavy) +
                      " | TrendState=" + analytics.TrendState);
   AFS_TD_AppendLine(t, "TacticalMovement=" +
                      "MovementBand=" + AFS_OutputSafeText(analytics.MovementBand, "PENDING") +
                      " | IntradayBias=" + AFS_OutputSafeText(analytics.IntradayBias, "PENDING") +
                      " | TacticalMediumState=" + AFS_OutputSafeText(analytics.TacticalMediumState, "PENDING"));
   AFS_TD_AppendLine(t, "TacticalWindows=" +
                      "RecentMoveM1=" + AFS_TD_TacticalMetricText(rec, analytics.HasRecentMoveM1, analytics.RecentMoveM1) +
                      " | RecentMoveM5=" + AFS_TD_TacticalMetricText(rec, analytics.HasRecentMoveM5, analytics.RecentMoveM5) +
                      " | TacticalM1Summary=" + AFS_OutputSafeText(analytics.TacticalM1Summary, "PENDING") +
                      " | TacticalM5Summary=" + AFS_OutputSafeText(analytics.TacticalM5Summary, "PENDING"));
   AFS_TD_AppendLine(t, "");

   AFS_TD_AppendLine(t, "[RISK_ECONOMICS_BLOCK]");
   AFS_TD_AppendLine(t, "TradeMode=" + IntegerToString(rec.TradeMode) + " (" + AFS_TD_TradeModeText(rec.TradeMode) + ")" + " | Digits=" + IntegerToString(rec.Digits) + " | Point=" + AFS_TD_FormatPointLike(rec, rec.Point));
   AFS_TD_AppendLine(t, "TickSize=" + AFS_TD_FormatPointLike(rec, rec.TickSize) + " | TickValueRaw=" + AFS_TD_FormatMoney(tick_value_raw) + " | TickValueDerived=" + AFS_TD_FormatMoney(rec.TickValueDerived) + " | TickValueValidated=" + AFS_TD_FormatMoney(rec.TickValueValidated));
   AFS_TD_AppendLine(t, "TickValueTrusted=" + (has_trusted_tick_value ? AFS_TD_FormatMoney(trusted_tick_value) : "PENDING_OR_UNAVAILABLE") +
                      " | TickValueSource=" + (has_trusted_tick_value ? trusted_tick_value_provenance : "PENDING_OR_UNAVAILABLE"));
   AFS_TD_AppendLine(t, "TickValueValidationState=" + AFS_TD_TickValueValidationLabel(rec));
   AFS_TD_AppendLine(t, "TickValueProfit=" + AFS_TD_FormatMoney(rec.TickValueProfit) + " | TickValueLoss=" + AFS_TD_FormatMoney(rec.TickValueLoss) + " | TickValue=" + AFS_TD_FormatMoney(rec.TickValue));
   AFS_TD_AppendLine(t, "ContractSize=" + AFS_TD_FormatMoney(rec.ContractSize) + " | VolumeMin=" + AFS_TD_FormatMoney(rec.VolumeMin) + " | VolumeStep=" + AFS_TD_FormatMoney(rec.VolumeStep) + " | VolumeMax=" + AFS_TD_FormatMoney(rec.VolumeMax));
   AFS_TD_AppendLine(t, "VolumeLimit=" + AFS_TD_FormatMoney(rec.VolumeLimit) +
                      " | MarginPerMinLot=" + (has_margin_per_min_lot ? "~" + AFS_TD_FormatMoney(margin_per_min_lot) : "PENDING_OR_UNAVAILABLE") +
                      " | MarginCalcState=" + (has_margin_per_min_lot ? "ORDER_CALC_MARGIN_ACTIVE" : "PENDING_OR_UNAVAILABLE"));
   AFS_TD_AppendLine(t, "MarginBySideMinLot=" +
                      "Buy=" + (has_margin_buy_min_lot ? "~" + AFS_TD_FormatMoney(margin_buy_min_lot) : "PENDING_OR_UNAVAILABLE") +
                      " | Sell=" + (has_margin_sell_min_lot ? "~" + AFS_TD_FormatMoney(margin_sell_min_lot) : "PENDING_OR_UNAVAILABLE"));
   AFS_TD_AppendLine(t, "MarginCurrency=" + AFS_OutputSafeText(rec.CurrencyMargin, "-") + " | ProfitCurrency=" + AFS_OutputSafeText(rec.CurrencyProfit, "-"));
   AFS_TD_AppendLine(t, "MarginInitial=" + AFS_TD_FormatMoney(rec.MarginInitial) + " | MarginMaintenance=" + AFS_TD_FormatMoney(rec.MarginMaintenance) + " | MarginLong=" + AFS_TD_FormatMoney(rec.MarginLong) + " | MarginShort=" + AFS_TD_FormatMoney(rec.MarginShort));
   AFS_TD_AppendLine(t, "MarginHedged=" + AFS_TD_FormatMoney(rec.MarginHedged) + " | CommissionValue=" + AFS_TD_FormatMoney(rec.CommissionValue) + " | CommissionMode=" + AFS_OutputSafeText(rec.CommissionMode, "-") + " | CommissionCurrency=" + AFS_OutputSafeText(rec.CommissionCurrency, "-") + " | CommissionStatus=" + AFS_OutputSafeText(rec.CommissionStatus, "-"));
   AFS_TD_AppendLine(t, "SpreadMoneyPerMinLot=" + AFS_TD_MoneyMetricText(spread_money, spread_money_estimated, "UNAVAILABLE_OR_DEFERRED") + " | StopMoneyPerMinLot_M15ATR=" + AFS_TD_MoneyMetricText(stop_money_m15, stop_money_estimated, "UNAVAILABLE_OR_DEFERRED"));
   AFS_TD_AppendLine(t, "SpreadMoneyValidationState=" +
                      (spread_money > 0.0 ? (trusted_tick_value_state + "_SPREAD_MONEY") :
                       AFS_TD_DerivedMoneyLabel(spread_money, spread_price_now > 0.0, "READY_TRUSTED_TICK_VALUE", "PENDING_TRUSTED_TICK_VALUE", "UNAVAILABLE_NO_TICK_VALUE")));
   AFS_TD_AppendLine(t, "StopMoneyPerMinLotState=" +
                      (stop_money_m15 > 0.0 ? (trusted_tick_value_state + "_ATR_STOP_MONEY") :
                       AFS_TD_DerivedMoneyLabel(stop_money_m15, rec.AtrM15 > 0.0, "READY_TRUSTED_TICK_VALUE", "PENDING_TRUSTED_TICK_VALUE_OR_ATR", "UNAVAILABLE_NO_TICK_VALUE_OR_ATR")));
   AFS_TD_AppendLine(t, "EconomicsConfidence=" + AFS_OutputSafeText(rec.EconomicsTrust, "UNSCANNED") + " | ContractSpecTrust=" + AFS_OutputSafeText(rec.EconomicsTrust, "UNSCANNED") + " | SpecIntegrityStatus=" + AFS_OutputSafeText(rec.SpecIntegrityStatus, "UNSCANNED"));
   AFS_TD_AppendLine(t, "NormalizationStatus=" + AFS_OutputSafeText(rec.NormalizationStatus, "-") + " | PracticalityStatus=" + AFS_OutputSafeText(rec.PracticalityStatus, "-") + " | EconomicsFlags=" + AFS_OutputSafeText(rec.EconomicsFlags, "-"));
   AFS_TD_AppendLine(t, "StopLevel=" + IntegerToString(rec.StopsLevel) + " | FreezeLevel=" + IntegerToString(rec.FreezeLevel) + " | ExecMode=" + IntegerToString(rec.ExecMode) + " (" + AFS_TD_ExecModeText(rec.ExecMode) + ")" + " | FillingMode=" + IntegerToString(rec.FillingMode) + " (" + AFS_TD_FillingModeText(rec.FillingMode) + ")");
   AFS_TD_AppendLine(t, "CalcMode=" + IntegerToString(rec.CalcMode) + " (" + AFS_TD_CalcModeText(rec.CalcMode) + ")" + " | ExpirationMode=" + IntegerToString(rec.ExpirationMode) + " | OrderMode=" + IntegerToString(rec.OrderMode) + " | SwapMode=" + IntegerToString(rec.SwapMode) + " (" + AFS_TD_SwapModeText(rec.SwapMode) + ")");
   AFS_TD_AppendLine(t, "SwapLong=" + AFS_TD_FormatMoney(rec.SwapLong) + " | SwapShort=" + AFS_TD_FormatMoney(rec.SwapShort) + " | LastSpecUpdateAt=" + AFS_FormatTime(rec.LastSpecUpdateAt) + " | SpecUpdateCount=" + IntegerToString(rec.SpecUpdateCount));
   AFS_TD_AppendLine(t, "SpreadInt=" + IntegerToString(rec.Spread) + " | CostEfficiencyScore=" + AFS_FormatScore2(rec.CostEfficiencyScore) + " | TrustScore=" + AFS_FormatScore2(rec.TrustScore));
   AFS_TD_AppendLine(t, "AnalyticsQuality=" +
                      "AtrEfficiency=" + AFS_TD_AnalyticsPercentText(analytics.HasAtrEfficiency, analytics.AtrEfficiency) +
                      " | SpreadToAtr=" + AFS_TD_AnalyticsPercentText(analytics.HasSpreadToAtr, analytics.SpreadToAtr) +
                      " | DataIntegrityScore=" + AFS_TD_AnalyticsPercentText(analytics.HasDataIntegrityScore, analytics.DataIntegrityScore) +
                      " | QualityState=" + analytics.QualityState);
   AFS_TD_AppendLine(t, "");

   AFS_TD_AppendLine(t, "[FINAL_DECISION_BLOCK]");
   AFS_TD_AppendLine(t, "Bias=" + AFS_FinalOutputRoleText(rec));
   AFS_TD_AppendLine(t, AFS_TD_TrustLabelLine(rec));
   AFS_TD_AppendLine(t, "State=" + AFS_OutputSafeText(rec.PromotionState, "-"));
   AFS_TD_AppendLine(t, "Confidence=" + AFS_FormatScore2(rec.TotalScore));
   AFS_TD_AppendLine(t, "Blockers=" + AFS_FinalOutputReasonText(rec));
   AFS_TD_AppendLine(t, "Notes=" + AFS_FinalOutputDegradedText(rec));
   AFS_TD_AppendLine(t, "EntryStyle=DOWNSTREAM_CONTEXT_ONLY");
   AFS_TD_AppendLine(t, "KeyLevels=" + (pdh > 0.0 && pdl > 0.0 ? ("PDH=" + AFS_TD_FormatPrice(rec, pdh) + ",PDL=" + AFS_TD_FormatPrice(rec, pdl)) : "PENDING_NOT_AVAILABLE_IN_RUNTIME_RECORD"));
   AFS_TD_AppendLine(t, "StopModel=ATR_M15_REFERENCE");
   AFS_TD_AppendLine(t, "PositionSizeModel=" + (has_trusted_tick_value ? "MIN_LOT_CONSERVATIVE" : "DEFERRED_PENDING_TRUSTED_TICK_VALUE"));
   AFS_TD_AppendLine(t, "TrustReadiness=" +
                      "Pipeline=" + pipeline_maturity_state +
                      " | Shortlist=" + shortlist_stability_state +
                      " | Correlation=" + correlation_readiness_state +
                      " | DossierFreshness=" + dossier_freshness_state +
                      " | ScannerConfidence=" + scanner_confidence_state +
                      " | Tactical=" + tactical_readiness_band +
                      " | ActivePublication=" + active_publication_health_state +
                      " | DataIntegrity=" + data_integrity_state +
                      " | Execution=" + execution_readiness_state);
   AFS_TD_AppendLine(t, "TradeEligibility=" + AFS_OutputSafeText(analytics.TradeEligibility, "PENDING") +
                      " | ExecutionPermission=" + AFS_OutputSafeText(analytics.ExecutionPermission, "PENDING"));
   AFS_TD_AppendLine(t, "EligibilityReasons=" + AFS_OutputSafeText(analytics.EligibilityReasons, "NONE"));
   AFS_TD_AppendLine(t, "ExecutionQualityScore=" + AFS_FormatScore2(analytics.ExecutionQualityScore) +
                      " | TacticalExecutionState=" + AFS_OutputSafeText(analytics.ExecutionQualityState, "PENDING"));
   AFS_TD_AppendLine(t, "PromotionReason=" + AFS_OutputSafeText(rec.PromotionReason, "-") + " | CorrMax=" + AFS_FormatCorrValue(rec.CorrMax));
   AFS_TD_AppendLine(t, "WeakReason=" + AFS_OutputSafeText(rec.FrictionWeakReason, "-") + " | FailReason=" + AFS_OutputSafeText(rec.FrictionFailReason, "-"));
   AFS_TD_AppendLine(t, "ReasoningGuide=PASS_MEANS_ACTIVE_AND_TRADABLE | WEAK_MEANS_ACTIVE_BUT_CAUTION | FAIL_MEANS_BLOCKED_FROM_ACTIVE_PUBLICATION | Phase1Step8CoreRemainsProtected=true");
   AFS_TD_AppendLine(t, "");

   AFS_TD_AppendLine(t, "[OHLC_BLOCKS]");
   AFS_TD_AppendLine(t, "OHLC_M1_RECENT=" + AFS_TD_FormatOHLCSeries(rec, PERIOD_M1, MathMax(1, DossierOHLCBarsM1)));
   AFS_TD_AppendLine(t, "OHLC_M5=" + AFS_TD_FormatOHLCSeries(rec, PERIOD_M5, MathMax(1, DossierOHLCBarsM5)));
   AFS_TD_AppendLine(t, "OHLC_M15=" + AFS_TD_FormatOHLCSeries(rec, PERIOD_M15, MathMax(1, DossierOHLCBarsM15)));
   AFS_TD_AppendLine(t, "OHLC_H1=" + AFS_TD_FormatOHLCSeries(rec, PERIOD_H1, MathMax(1, DossierOHLCBarsH1)));
   if(include_heavy)
     {
      AFS_TD_AppendLine(t, "OHLC_H4=" + (analytics.BarsH4 > 0 ? AFS_TD_FormatOHLCSeries(rec, PERIOD_H4, MathMax(1, DossierOHLCBarsH4)) : "PENDING_OR_UNAVAILABLE"));
      AFS_TD_AppendLine(t, "OHLC_D1=" + (analytics.BarsD1 > 0 ? AFS_TD_FormatOHLCSeries(rec, PERIOD_D1, MathMax(1, DossierOHLCBarsD1)) : "PENDING_OR_UNAVAILABLE"));
      AFS_TD_AppendLine(t, "OHLC_W1=" + (analytics.BarsW1 > 0 ? AFS_TD_FormatOHLCSeries(rec, PERIOD_W1, MathMax(1, DossierOHLCBarsW1)) : "PENDING_OR_UNAVAILABLE"));
     }
   else
     {
      AFS_TD_AppendLine(t, "OHLC_H4=DEFERRED_HEAVY_REFRESH");
      AFS_TD_AppendLine(t, "OHLC_D1=DEFERRED_HEAVY_REFRESH");
      AFS_TD_AppendLine(t, "OHLC_W1=DEFERRED_HEAVY_REFRESH");
     }

   return t;
  }

bool AFS_TD_WriteDossier(const AFS_RuntimeState &state,
                         const AFS_UniverseSymbol &rec,
                         const datetime now,
                         const bool include_heavy,
                         const bool force_write_if_unchanged,
                         string &err)
  {
   err = "";
   string dossier_file = AFS_TraderDossierFilePath(rec);
   string prior_text = "";
   bool had_prior_file = AFS_ReadAllTextFile(dossier_file, state.PathState.UseCommonFiles, prior_text);

   string pending_reasons = AFS_TraderDossierPendingReasons(rec);
   string completion_state = AFS_TraderDossierCompletionState(rec);
   string lifecycle_now = AFS_FormatTime(now);

   if(AFS_TraderOutputNeedsCarryForward(rec) && !AFS_TraderDossierHasImmediateKnownData(rec))
     {
      if(had_prior_file && StringLen(prior_text) > 0)
        {
         string prior_lines[];
         StringReplace(prior_text, "\r", "");
         ushort nl = 10;
         int prior_count = StringSplit(prior_text, nl, prior_lines);
         if(prior_count > 0)
           {
            AFS_TraderRefreshActiveLifecycleLines(prior_lines, prior_count, rec, lifecycle_now, completion_state, pending_reasons);
            string carry_text = AFS_JoinLinesForTrace(prior_lines, prior_count);
            bool carry_changed = (prior_text != carry_text);
             bool carry_ok = (force_write_if_unchanged && !carry_changed ?
                              AFS_WritePlainTextFile(dossier_file, state.PathState.UseCommonFiles, prior_lines, prior_count, err) :
                              AFS_WritePlainTextFileIfChanged(dossier_file, state.PathState.UseCommonFiles, prior_lines, prior_count, prior_text, had_prior_file, carry_changed, err));
             AFS_TracePublication("TRADER_DOSSIER", dossier_file, (carry_changed ? "carry_forward_rewrite" : (force_write_if_unchanged ? "carry_forward_refresh" : "carry_forward_rewrite")), carry_ok,
                                 "symbol=" + rec.Symbol +
                                 " | prior_exists=" + AFS_BoolText(had_prior_file) +
                                 " | changed=" + AFS_BoolText(carry_changed) +
                                 " | forced_refresh=" + AFS_BoolText(force_write_if_unchanged && !carry_changed) +
                                 " | completion=" + completion_state +
                                 " | pending=" + pending_reasons);
            return carry_ok;
           }
        }
     }

   string text = AFS_TD_BuildDossierText(state, rec, now, include_heavy, completion_state, pending_reasons);
   string lines[];
   StringReplace(text, "\r", "");
   ushort nl = 10;
   int c = StringSplit(text, nl, lines);
   if(c > 0 && StringLen(lines[c - 1]) == 0)
      c--;

    string next_text = AFS_JoinLinesForTrace(lines, c);
    bool changed = (!had_prior_file || prior_text != next_text);
    bool dossier_ok = (force_write_if_unchanged && !changed
                    ? AFS_WritePlainTextFile(dossier_file,
                                             state.PathState.UseCommonFiles,
                                             lines,
                                             c,
                                             err)
                    : AFS_WritePlainTextFileIfChanged(dossier_file,
                                                      state.PathState.UseCommonFiles,
                                                      lines,
                                                      c,
                                                      prior_text,
                                                      had_prior_file,
                                                      changed,
                                                      err));
   AFS_TracePublication("TRADER_DOSSIER",
                        dossier_file,
                         (changed ? "write" : (force_write_if_unchanged ? "refresh_due_no_content_delta" : "write")),
                        dossier_ok,
                        "symbol=" + rec.Symbol +
                        " | prior_exists=" + AFS_BoolText(had_prior_file) +
                        " | changed=" + AFS_BoolText(changed) +
                         " | forced_refresh=" + AFS_BoolText(force_write_if_unchanged && !changed) +
                        " | completion=" + completion_state +
                        " | pending=" + pending_reasons);
   return dossier_ok;
  }

#endif