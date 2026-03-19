#ifndef ASC_CONDITIONS_MQH
#define ASC_CONDITIONS_MQH

#include "ASC_Common.mqh"

namespace ASC_Conditions_Internal
{
   bool IsFiniteNumber(const double value)
   {
      return MathIsValidNumber(value);
   }

   bool IsFinitePositive(const double value)
   {
      return (value > 0.0 && IsFiniteNumber(value));
   }

   double AbsRatioGap(const double a,const double b)
   {
      if(a <= 0.0 || b <= 0.0)
         return 0.0;

      const double hi = MathMax(a,b);
      if(hi <= 0.0)
         return 0.0;

      return MathAbs(a - b) / hi;
   }

   void AppendFlag(string &flags,const string flag)
   {
      if(StringLen(flag) == 0)
         return;
      if(StringLen(flags) > 0)
         flags += "|";
      flags += flag;
   }

   double DeriveTickValue(const ASC_ConditionsTruth &truth,bool &derived_readable)
   {
      derived_readable = false;

      if(truth.TickValueProfitReadable && truth.TickValueLossReadable &&
         IsFinitePositive(truth.TickValueProfit) && IsFinitePositive(truth.TickValueLoss))
        {
         derived_readable = true;
         return (truth.TickValueProfit + truth.TickValueLoss) * 0.5;
        }

      if(truth.TickValueProfitReadable && IsFinitePositive(truth.TickValueProfit))
        {
         derived_readable = true;
         return truth.TickValueProfit;
        }

      if(truth.TickValueLossReadable && IsFinitePositive(truth.TickValueLoss))
        {
         derived_readable = true;
         return truth.TickValueLoss;
        }

      return -1.0;
   }

   bool TryValidateTickValue(const string symbol,const ASC_SymbolRecord &record,double &validated_tick_value)
   {
      validated_tick_value = -1.0;

      if(!record.MarketTruth.TradeAllowed ||
         !record.ConditionsTruth.TickSizeReadable || !IsFinitePositive(record.ConditionsTruth.TickSize) ||
         !record.ConditionsTruth.VolumeMinReadable || !IsFinitePositive(record.ConditionsTruth.VolumeMin))
         return false;

      MqlTick tick;
      if(!SymbolInfoTick(symbol,tick))
         return false;

      double profit = 0.0;
      const double volume = record.ConditionsTruth.VolumeMin;

      if(tick.ask > 0.0)
        {
         ResetLastError();
         if(OrderCalcProfit(ORDER_TYPE_BUY,symbol,volume,tick.ask,tick.ask + record.ConditionsTruth.TickSize,profit))
           {
            validated_tick_value = MathAbs(profit) / volume;
            if(IsFinitePositive(validated_tick_value))
               return true;
           }
        }

      if(tick.bid > 0.0)
        {
         ResetLastError();
         if(OrderCalcProfit(ORDER_TYPE_SELL,symbol,volume,tick.bid,tick.bid - record.ConditionsTruth.TickSize,profit))
           {
            validated_tick_value = MathAbs(profit) / volume;
            if(IsFinitePositive(validated_tick_value))
               return true;
           }
        }

      validated_tick_value = -1.0;
      return false;
   }

   int CoverageRank(const ASC_ConditionsTruth &truth)
   {
      int rank = 0;
      if(truth.TruthCoverageStatus == "PARTIAL")
         rank = 1;
      else if(truth.TruthCoverageStatus == "FULL")
         rank = 2;

      if(truth.TickValueRawReadable)
         rank += 1;
      if(truth.TickValueDerivedReadable)
         rank += 1;
      if(truth.TickValueValidatedReadable)
         rank += 2;
      if(truth.EconomicsAuthoritative)
         rank += 2;
      if(truth.CommissionMetadataReadable)
         rank += 1;

      return rank;
   }

   bool IsGoodIntegrityStatus(const string status)
   {
      return (status == "SPEC_OK" || status == "SPEC_SUSPICIOUS" || status == "SPEC_PRESERVED_PRIOR");
   }

   bool ShouldPreservePrior(const ASC_ConditionsTruth &prior,const ASC_ConditionsTruth &candidate,const bool candidate_authoritative)
   {
      if(!IsGoodIntegrityStatus(prior.SpecIntegrityStatus))
         return false;

      if(candidate_authoritative)
         return false;

      const int prior_rank = CoverageRank(prior);
      const int candidate_rank = CoverageRank(candidate);
      if(candidate_rank >= prior_rank)
         return false;

      const int rank_gap = prior_rank - candidate_rank;
      if(rank_gap > 3)
         return false;

      if(prior.TickValueValidatedReadable && !candidate.TickValueValidatedReadable)
         return true;

      if((prior.EconomicsTrust == "VALIDATED" || prior.EconomicsTrust == "DERIVED_OK") &&
         candidate.EconomicsTrust != prior.EconomicsTrust)
         return true;

      return (candidate.TruthCoverageStatus == "PARTIAL" || candidate.TruthCoverageStatus == "UNREAD");
   }

   void AppendReason(string &reason, const string message)
   {
      if(StringLen(message) == 0)
         return;

      if(StringLen(reason) > 0)
         reason += "; ";

      reason += message;
   }

   void PopulateCommissionMetadata(const string symbol,ASC_ConditionsTruth &truth)
   {
      truth.CommissionMetadataReadable = true;
      truth.CommissionMetadataSource = "TERMINAL";
      truth.CommissionMetadata = "symbol commission metadata unavailable via SymbolInfo*";

      long custom_symbol = 0;
      ResetLastError();
      if(SymbolInfoInteger(symbol,SYMBOL_CUSTOM,custom_symbol))
        {
         if(custom_symbol != 0)
            truth.CommissionMetadata = "custom symbol; commission may be embedded in synthetic pricing";
         return;
        }

      truth.CommissionMetadataSource = "TERMINAL_PARTIAL";
    }

   void ResetConditionsTruth(ASC_ConditionsTruth &truth)
   {
      truth.SpecsReadable = false;
      truth.SpecsReason = "specs not loaded";
      truth.SpecIntegrityStatus = "UNREAD";
      truth.EconomicsTrust = "UNREAD";
      truth.NormalizationStatus = "NORMALIZATION_UNKNOWN";
      truth.TruthCoverageStatus = "UNREAD";

      truth.DigitsReadable = false;
      truth.Digits = -1;
      truth.SpreadPointsReadable = false;
      truth.SpreadPoints = -1;
      truth.SpreadFloatReadable = false;
      truth.SpreadFloat = false;
      truth.StopsLevelReadable = false;
      truth.StopsLevel = -1;
      truth.FreezeLevelReadable = false;
      truth.FreezeLevel = -1;

      truth.PointReadable = false;
      truth.Point = -1.0;
      truth.TickSizeReadable = false;
      truth.TickSize = -1.0;
      truth.TickValueReadable = false;
      truth.TickValue = -1.0;
      truth.TickValueRawReadable = false;
      truth.TickValueRaw = -1.0;
      truth.TickValueDerivedReadable = false;
      truth.TickValueDerived = -1.0;
      truth.TickValueValidatedReadable = false;
      truth.TickValueValidated = -1.0;
      truth.TickValueProfitReadable = false;
      truth.TickValueProfit = -1.0;
      truth.TickValueLossReadable = false;
      truth.TickValueLoss = -1.0;
      truth.CommissionMetadataReadable = false;
      truth.CommissionMetadataSource = "UNREAD";
      truth.CommissionMetadata = "";
      truth.EconomicsMismatchFlags = "";
      truth.EconomicsAuthoritative = false;
      truth.EconomicsPreservedFromPrior = false;
      truth.ContractSizeReadable = false;
      truth.ContractSize = -1.0;

      truth.VolumeMinReadable = false;
      truth.VolumeMin = -1.0;
      truth.VolumeMaxReadable = false;
      truth.VolumeMax = -1.0;
      truth.VolumeStepReadable = false;
      truth.VolumeStep = -1.0;
      truth.VolumeLimitReadable = false;
      truth.VolumeLimit = -1.0;

      truth.MarginCurrencyReadable = false;
      truth.MarginCurrency = "";
      truth.ProfitCurrencyReadable = false;
      truth.ProfitCurrency = "";
      truth.BaseCurrencyReadable = false;
      truth.BaseCurrency = "";

      truth.CalcModeReadable = false;
      truth.CalcMode = -1;
      truth.ChartModeReadable = false;
      truth.ChartMode = -1;
      truth.TradeModeReadable = false;
      truth.TradeMode = -1;
      truth.ExecutionModeReadable = false;
      truth.ExecutionMode = -1;
      truth.GtcModeReadable = false;
      truth.GtcMode = -1;
      truth.FillingModeReadable = false;
      truth.FillingMode = -1;
      truth.ExpirationModeReadable = false;
      truth.ExpirationMode = -1;
      truth.OrderModeReadable = false;
      truth.OrderMode = -1;

      truth.SwapModeReadable = false;
      truth.SwapMode = -1;
      truth.SwapLongReadable = false;
      truth.SwapLong = 0.0;
      truth.SwapShortReadable = false;
      truth.SwapShort = 0.0;
      truth.SwapSundayReadable = false;
      truth.SwapSunday = -1.0;
      truth.SwapMondayReadable = false;
      truth.SwapMonday = -1.0;
      truth.SwapTuesdayReadable = false;
      truth.SwapTuesday = -1.0;
      truth.SwapWednesdayReadable = false;
      truth.SwapWednesday = -1.0;
      truth.SwapThursdayReadable = false;
      truth.SwapThursday = -1.0;
      truth.SwapFridayReadable = false;
      truth.SwapFriday = -1.0;
      truth.SwapSaturdayReadable = false;
      truth.SwapSaturday = -1.0;

      truth.MarginInitialReadable = false;
      truth.MarginInitial = -1.0;
      truth.MarginMaintenanceReadable = false;
      truth.MarginMaintenance = -1.0;
      truth.MarginHedgedReadable = false;
      truth.MarginHedged = -1.0;
      truth.MarginRateBuyReadable = false;
      truth.MarginRateBuyInitial = -1.0;
      truth.MarginRateBuyMaintenance = -1.0;
      truth.MarginRateSellReadable = false;
      truth.MarginRateSellInitial = -1.0;
      truth.MarginRateSellMaintenance = -1.0;
   }

   bool ReadIntegerSpec(const string symbol,
                        const ENUM_SYMBOL_INFO_INTEGER property,
                        long &value,
                        const string field_name,
                        string &reason)
   {
      ResetLastError();
      if(SymbolInfoInteger(symbol, property, value))
         return true;

      AppendReason(reason, field_name + " unreadable");
      return false;
   }

   bool ReadDoubleSpec(const string symbol,
                       const ENUM_SYMBOL_INFO_DOUBLE property,
                       double &value,
                       const string field_name,
                       string &reason)
   {
      ResetLastError();
      if(SymbolInfoDouble(symbol, property, value))
         return true;

      AppendReason(reason, field_name + " unreadable");
      return false;
   }

   bool ReadStringSpec(const string symbol,
                       const ENUM_SYMBOL_INFO_STRING property,
                       string &value,
                       const string field_name,
                       string &reason)
   {
      ResetLastError();
      if(SymbolInfoString(symbol, property, value))
         return true;

      AppendReason(reason, field_name + " unreadable");
      return false;
   }

   void ApplyIntegerSpec(const bool readable,
                         const long value,
                         int &target)
   {
      if(readable)
         target = (int)value;
   }

   void ApplyBooleanSpec(const bool readable,
                         const long value,
                         bool &target)
   {
      if(readable)
         target = (value != 0);
   }

   void ApplyDoubleSpec(const bool readable,
                        const double value,
                        double &target)
   {
      if(readable)
         target = value;
   }

   void ApplyStringSpec(const bool readable,
                        const string value,
                        string &target)
   {
      if(readable)
         target = value;
   }

   void AppendInvalidDoubleReason(string &reason,
                                  const string field_name,
                                  const double value)
   {
      if(!IsFiniteNumber(value))
      {
         AppendReason(reason, field_name + " non-finite");
         return;
      }

      if(value == 0.0)
      {
         AppendReason(reason, field_name + " broker-zero");
         return;
      }

      if(value < 0.0)
      {
         AppendReason(reason, field_name + " negative");
         return;
      }

      AppendReason(reason, field_name + " invalid");
   }

   bool IsMeaningfulText(const string value)
   {
      string trimmed = value;
      StringTrimLeft(trimmed);
      StringTrimRight(trimmed);
      return (StringLen(trimmed) > 0);
   }

   void AppendSpecWeakness(string &reason,
                           const bool valid,
                           const string field_name)
   {
      if(!valid)
         AppendReason(reason, field_name + " suspect");
   }

   bool TryReadMarginRate(const string symbol,
                          const ENUM_ORDER_TYPE order_type,
                          double &initial_rate,
                          double &maintenance_rate,
                          string &reason,
                          const string field_name)
   {
      ResetLastError();
      if(SymbolInfoMarginRate(symbol, order_type, initial_rate, maintenance_rate))
         return true;

      AppendReason(reason, field_name + " unreadable");
      initial_rate = -1.0;
      maintenance_rate = -1.0;
      return false;
   }

   string ResolveNormalizationStatus(const ASC_SymbolRecord &record)
   {
      if(!record.Identity.ClassificationResolved)
         return "NORMALIZATION_UNRESOLVED";

      if(StringFind(record.Identity.ClassificationReason, "alias=", 0) >= 0)
         return "NORMALIZATION_PARTIAL";

      if(StringFind(record.Identity.ClassificationReason, "fallback", 0) >= 0)
         return "NORMALIZATION_PARTIAL";

      return "NORMALIZATION_OK";
   }
}

bool ASC_Conditions_Load(const string symbol, ASC_SymbolRecord &record)
{
   const ASC_ConditionsTruth prior_truth = record.ConditionsTruth;
   ASC_Conditions_Internal::ResetConditionsTruth(record.ConditionsTruth);

   string reason = "";
   string mismatch_flags = "";
   bool all_readable = true;
   bool all_valid = true;
   bool any_readable = false;
   bool broker_missing = false;
   bool broker_unreadable = false;
   bool contradictory = false;

   if(StringLen(symbol) == 0)
   {
      record.ConditionsTruth.SpecsReason = "symbol is empty";
      record.ConditionsTruth.SpecIntegrityStatus = "SPEC_UNREADABLE";
      record.ConditionsTruth.EconomicsTrust = "UNREADABLE";
      return false;
   }

   long digits = 0;
   long spread_points = 0;
   long spread_float = 0;
   long stops_level = 0;
   long freeze_level = 0;
   long calc_mode = 0;
   long chart_mode = 0;
   long trade_mode = 0;
   long execution_mode = 0;
   long gtc_mode = 0;
   long filling_mode = 0;
   long expiration_mode = 0;
   long order_mode = 0;
   long swap_mode = 0;

   double point = 0.0;
   double tick_size = 0.0;
   double tick_value = 0.0;
   double tick_value_profit = 0.0;
   double tick_value_loss = 0.0;
   double contract_size = 0.0;
   double volume_min = 0.0;
   double volume_max = 0.0;
   double volume_step = 0.0;
   double volume_limit = 0.0;
   double swap_long = 0.0;
   double swap_short = 0.0;
   double swap_sunday = 0.0;
   double swap_monday = 0.0;
   double swap_tuesday = 0.0;
   double swap_wednesday = 0.0;
   double swap_thursday = 0.0;
   double swap_friday = 0.0;
   double swap_saturday = 0.0;
   double margin_initial = 0.0;
   double margin_maintenance = 0.0;
   double margin_hedged = 0.0;
   double buy_margin_initial = 0.0;
   double buy_margin_maintenance = 0.0;
   double sell_margin_initial = 0.0;
   double sell_margin_maintenance = 0.0;

   string margin_currency = "";
   string profit_currency = "";
   string base_currency = "";

   const bool digits_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_DIGITS, digits, "digits", reason);
   const bool spread_points_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_SPREAD, spread_points, "spread_points", reason);
   const bool spread_float_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_SPREAD_FLOAT, spread_float, "spread_float", reason);
   const bool stops_level_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_TRADE_STOPS_LEVEL, stops_level, "stops_level", reason);
   const bool freeze_level_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_TRADE_FREEZE_LEVEL, freeze_level, "freeze_level", reason);
   const bool point_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_POINT, point, "point", reason);
   const bool tick_size_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_TICK_SIZE, tick_size, "tick_size", reason);
   const bool tick_value_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_TICK_VALUE, tick_value, "tick_value", reason);
   const bool tick_value_profit_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_TICK_VALUE_PROFIT, tick_value_profit, "tick_value_profit", reason);
   const bool tick_value_loss_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_TICK_VALUE_LOSS, tick_value_loss, "tick_value_loss", reason);
   const bool contract_size_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_CONTRACT_SIZE, contract_size, "contract_size", reason);
   const bool volume_min_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_VOLUME_MIN, volume_min, "volume_min", reason);
   const bool volume_max_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_VOLUME_MAX, volume_max, "volume_max", reason);
   const bool volume_step_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_VOLUME_STEP, volume_step, "volume_step", reason);
   const bool volume_limit_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_VOLUME_LIMIT, volume_limit, "volume_limit", reason);
   const bool margin_currency_readable = ASC_Conditions_Internal::ReadStringSpec(symbol, SYMBOL_CURRENCY_MARGIN, margin_currency, "margin_currency", reason);
   const bool profit_currency_readable = ASC_Conditions_Internal::ReadStringSpec(symbol, SYMBOL_CURRENCY_PROFIT, profit_currency, "profit_currency", reason);
   const bool base_currency_readable = ASC_Conditions_Internal::ReadStringSpec(symbol, SYMBOL_CURRENCY_BASE, base_currency, "base_currency", reason);
   const bool calc_mode_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_TRADE_CALC_MODE, calc_mode, "calc_mode", reason);
   const bool chart_mode_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_CHART_MODE, chart_mode, "chart_mode", reason);
   const bool trade_mode_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_TRADE_MODE, trade_mode, "trade_mode", reason);
   const bool execution_mode_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_TRADE_EXEMODE, execution_mode, "execution_mode", reason);
   const bool gtc_mode_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_ORDER_GTC_MODE, gtc_mode, "gtc_mode", reason);
   const bool filling_mode_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_FILLING_MODE, filling_mode, "filling_mode", reason);
   const bool expiration_mode_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_EXPIRATION_MODE, expiration_mode, "expiration_mode", reason);
   const bool order_mode_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_ORDER_MODE, order_mode, "order_mode", reason);
   const bool swap_mode_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_SWAP_MODE, swap_mode, "swap_mode", reason);
   const bool swap_long_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_SWAP_LONG, swap_long, "swap_long", reason);
   const bool swap_short_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_SWAP_SHORT, swap_short, "swap_short", reason);
   const bool swap_sunday_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_SWAP_SUNDAY, swap_sunday, "swap_sunday", reason);
   const bool swap_monday_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_SWAP_MONDAY, swap_monday, "swap_monday", reason);
   const bool swap_tuesday_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_SWAP_TUESDAY, swap_tuesday, "swap_tuesday", reason);
   const bool swap_wednesday_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_SWAP_WEDNESDAY, swap_wednesday, "swap_wednesday", reason);
   const bool swap_thursday_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_SWAP_THURSDAY, swap_thursday, "swap_thursday", reason);
   const bool swap_friday_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_SWAP_FRIDAY, swap_friday, "swap_friday", reason);
   const bool swap_saturday_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_SWAP_SATURDAY, swap_saturday, "swap_saturday", reason);
   const bool margin_initial_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_MARGIN_INITIAL, margin_initial, "margin_initial", reason);
   const bool margin_maintenance_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_MARGIN_MAINTENANCE, margin_maintenance, "margin_maintenance", reason);
   const bool margin_hedged_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_MARGIN_HEDGED, margin_hedged, "margin_hedged", reason);
   const bool buy_margin_rate_readable = ASC_Conditions_Internal::TryReadMarginRate(symbol, ORDER_TYPE_BUY, buy_margin_initial, buy_margin_maintenance, reason, "margin_rate_buy");
   const bool sell_margin_rate_readable = ASC_Conditions_Internal::TryReadMarginRate(symbol, ORDER_TYPE_SELL, sell_margin_initial, sell_margin_maintenance, reason, "margin_rate_sell");

   all_readable = digits_readable &&
                  spread_points_readable &&
                  spread_float_readable &&
                  stops_level_readable &&
                  point_readable &&
                  tick_size_readable &&
                  tick_value_readable &&
                  contract_size_readable &&
                  volume_min_readable &&
                  volume_max_readable &&
                  volume_step_readable &&
                  margin_currency_readable &&
                  profit_currency_readable &&
                  calc_mode_readable &&
                  chart_mode_readable &&
                  trade_mode_readable &&
                  execution_mode_readable &&
                  gtc_mode_readable &&
                  filling_mode_readable &&
                  expiration_mode_readable &&
                  order_mode_readable &&
                  swap_mode_readable &&
                  swap_long_readable &&
                  swap_short_readable &&
                  buy_margin_rate_readable &&
                  sell_margin_rate_readable;

   any_readable = digits_readable || spread_points_readable || spread_float_readable || stops_level_readable || freeze_level_readable ||
                  point_readable || tick_size_readable || tick_value_readable || tick_value_profit_readable || tick_value_loss_readable ||
                  contract_size_readable || volume_min_readable || volume_max_readable || volume_step_readable || volume_limit_readable ||
                  margin_currency_readable || profit_currency_readable || base_currency_readable || calc_mode_readable || chart_mode_readable ||
                  trade_mode_readable || execution_mode_readable || gtc_mode_readable || filling_mode_readable || expiration_mode_readable ||
                  order_mode_readable || swap_mode_readable || swap_long_readable || swap_short_readable || swap_sunday_readable ||
                  swap_monday_readable || swap_tuesday_readable || swap_wednesday_readable || swap_thursday_readable || swap_friday_readable ||
                  swap_saturday_readable || margin_initial_readable || margin_maintenance_readable || margin_hedged_readable ||
                  buy_margin_rate_readable || sell_margin_rate_readable;

   record.ConditionsTruth.DigitsReadable = digits_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(digits_readable, digits, record.ConditionsTruth.Digits);
   record.ConditionsTruth.SpreadPointsReadable = spread_points_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(spread_points_readable, spread_points, record.ConditionsTruth.SpreadPoints);
   record.ConditionsTruth.SpreadFloatReadable = spread_float_readable;
   ASC_Conditions_Internal::ApplyBooleanSpec(spread_float_readable, spread_float, record.ConditionsTruth.SpreadFloat);
   record.ConditionsTruth.StopsLevelReadable = stops_level_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(stops_level_readable, stops_level, record.ConditionsTruth.StopsLevel);
   record.ConditionsTruth.FreezeLevelReadable = freeze_level_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(freeze_level_readable, freeze_level, record.ConditionsTruth.FreezeLevel);

   record.ConditionsTruth.PointReadable = point_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(point_readable, point, record.ConditionsTruth.Point);
   record.ConditionsTruth.TickSizeReadable = tick_size_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(tick_size_readable, tick_size, record.ConditionsTruth.TickSize);
   record.ConditionsTruth.TickValueReadable = tick_value_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(tick_value_readable, tick_value, record.ConditionsTruth.TickValue);
   record.ConditionsTruth.TickValueRawReadable = tick_value_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(tick_value_readable, tick_value, record.ConditionsTruth.TickValueRaw);
   record.ConditionsTruth.TickValueProfitReadable = tick_value_profit_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(tick_value_profit_readable, tick_value_profit, record.ConditionsTruth.TickValueProfit);
   record.ConditionsTruth.TickValueLossReadable = tick_value_loss_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(tick_value_loss_readable, tick_value_loss, record.ConditionsTruth.TickValueLoss);
   record.ConditionsTruth.ContractSizeReadable = contract_size_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(contract_size_readable, contract_size, record.ConditionsTruth.ContractSize);

   bool derived_tick_value_readable = false;
   const double derived_tick_value = ASC_Conditions_Internal::DeriveTickValue(record.ConditionsTruth, derived_tick_value_readable);
   record.ConditionsTruth.TickValueDerivedReadable = derived_tick_value_readable;
   if(derived_tick_value_readable)
      record.ConditionsTruth.TickValueDerived = derived_tick_value;

   record.ConditionsTruth.VolumeMinReadable = volume_min_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(volume_min_readable, volume_min, record.ConditionsTruth.VolumeMin);
   record.ConditionsTruth.VolumeMaxReadable = volume_max_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(volume_max_readable, volume_max, record.ConditionsTruth.VolumeMax);
   record.ConditionsTruth.VolumeStepReadable = volume_step_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(volume_step_readable, volume_step, record.ConditionsTruth.VolumeStep);
   record.ConditionsTruth.VolumeLimitReadable = volume_limit_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(volume_limit_readable, volume_limit, record.ConditionsTruth.VolumeLimit);

   double validated_tick_value = -1.0;
   const bool validated_tick_value_readable = ASC_Conditions_Internal::TryValidateTickValue(symbol, record, validated_tick_value);
   record.ConditionsTruth.TickValueValidatedReadable = validated_tick_value_readable;
   if(validated_tick_value_readable)
      record.ConditionsTruth.TickValueValidated = validated_tick_value;
   record.ConditionsTruth.EconomicsAuthoritative = validated_tick_value_readable;
   ASC_Conditions_Internal::PopulateCommissionMetadata(symbol,record.ConditionsTruth);

   record.ConditionsTruth.MarginCurrencyReadable = margin_currency_readable;
   ASC_Conditions_Internal::ApplyStringSpec(margin_currency_readable, margin_currency, record.ConditionsTruth.MarginCurrency);
   record.ConditionsTruth.ProfitCurrencyReadable = profit_currency_readable;
   ASC_Conditions_Internal::ApplyStringSpec(profit_currency_readable, profit_currency, record.ConditionsTruth.ProfitCurrency);
   record.ConditionsTruth.BaseCurrencyReadable = base_currency_readable;
   ASC_Conditions_Internal::ApplyStringSpec(base_currency_readable, base_currency, record.ConditionsTruth.BaseCurrency);

   record.ConditionsTruth.CalcModeReadable = calc_mode_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(calc_mode_readable, calc_mode, record.ConditionsTruth.CalcMode);
   record.ConditionsTruth.ChartModeReadable = chart_mode_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(chart_mode_readable, chart_mode, record.ConditionsTruth.ChartMode);
   record.ConditionsTruth.TradeModeReadable = trade_mode_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(trade_mode_readable, trade_mode, record.ConditionsTruth.TradeMode);
   record.ConditionsTruth.ExecutionModeReadable = execution_mode_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(execution_mode_readable, execution_mode, record.ConditionsTruth.ExecutionMode);
   record.ConditionsTruth.GtcModeReadable = gtc_mode_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(gtc_mode_readable, gtc_mode, record.ConditionsTruth.GtcMode);
   record.ConditionsTruth.FillingModeReadable = filling_mode_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(filling_mode_readable, filling_mode, record.ConditionsTruth.FillingMode);
   record.ConditionsTruth.ExpirationModeReadable = expiration_mode_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(expiration_mode_readable, expiration_mode, record.ConditionsTruth.ExpirationMode);
   record.ConditionsTruth.OrderModeReadable = order_mode_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(order_mode_readable, order_mode, record.ConditionsTruth.OrderMode);

   record.ConditionsTruth.SwapModeReadable = swap_mode_readable;
   ASC_Conditions_Internal::ApplyIntegerSpec(swap_mode_readable, swap_mode, record.ConditionsTruth.SwapMode);
   record.ConditionsTruth.SwapLongReadable = swap_long_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(swap_long_readable, swap_long, record.ConditionsTruth.SwapLong);
   record.ConditionsTruth.SwapShortReadable = swap_short_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(swap_short_readable, swap_short, record.ConditionsTruth.SwapShort);
   record.ConditionsTruth.SwapSundayReadable = swap_sunday_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(swap_sunday_readable, swap_sunday, record.ConditionsTruth.SwapSunday);
   record.ConditionsTruth.SwapMondayReadable = swap_monday_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(swap_monday_readable, swap_monday, record.ConditionsTruth.SwapMonday);
   record.ConditionsTruth.SwapTuesdayReadable = swap_tuesday_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(swap_tuesday_readable, swap_tuesday, record.ConditionsTruth.SwapTuesday);
   record.ConditionsTruth.SwapWednesdayReadable = swap_wednesday_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(swap_wednesday_readable, swap_wednesday, record.ConditionsTruth.SwapWednesday);
   record.ConditionsTruth.SwapThursdayReadable = swap_thursday_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(swap_thursday_readable, swap_thursday, record.ConditionsTruth.SwapThursday);
   record.ConditionsTruth.SwapFridayReadable = swap_friday_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(swap_friday_readable, swap_friday, record.ConditionsTruth.SwapFriday);
   record.ConditionsTruth.SwapSaturdayReadable = swap_saturday_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(swap_saturday_readable, swap_saturday, record.ConditionsTruth.SwapSaturday);

   record.ConditionsTruth.MarginInitialReadable = margin_initial_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(margin_initial_readable, margin_initial, record.ConditionsTruth.MarginInitial);
   record.ConditionsTruth.MarginMaintenanceReadable = margin_maintenance_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(margin_maintenance_readable, margin_maintenance, record.ConditionsTruth.MarginMaintenance);
   record.ConditionsTruth.MarginHedgedReadable = margin_hedged_readable;
   ASC_Conditions_Internal::ApplyDoubleSpec(margin_hedged_readable, margin_hedged, record.ConditionsTruth.MarginHedged);
   record.ConditionsTruth.MarginRateBuyReadable = buy_margin_rate_readable;
   if(buy_margin_rate_readable)
     {
      record.ConditionsTruth.MarginRateBuyInitial = buy_margin_initial;
      record.ConditionsTruth.MarginRateBuyMaintenance = buy_margin_maintenance;
     }
   record.ConditionsTruth.MarginRateSellReadable = sell_margin_rate_readable;
   if(sell_margin_rate_readable)
     {
      record.ConditionsTruth.MarginRateSellInitial = sell_margin_initial;
      record.ConditionsTruth.MarginRateSellMaintenance = sell_margin_maintenance;
     }

   if(digits_readable && record.ConditionsTruth.Digits < 0)
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendReason(reason, "digits invalid");
     }
   if(spread_points_readable && record.ConditionsTruth.SpreadPoints < 0)
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendReason(reason, "spread_points invalid");
     }
   if(stops_level_readable && record.ConditionsTruth.StopsLevel < 0)
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendReason(reason, "stops_level invalid");
     }
   if(point_readable && !ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.Point))
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendInvalidDoubleReason(reason, "point", record.ConditionsTruth.Point);
     }
   if(tick_size_readable && !ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickSize))
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendInvalidDoubleReason(reason, "tick_size", record.ConditionsTruth.TickSize);
     }
   if(contract_size_readable && !ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.ContractSize))
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendInvalidDoubleReason(reason, "contract_size", record.ConditionsTruth.ContractSize);
     }
   if(volume_min_readable && !ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.VolumeMin))
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendInvalidDoubleReason(reason, "volume_min", record.ConditionsTruth.VolumeMin);
     }
   if(volume_max_readable && !ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.VolumeMax))
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendInvalidDoubleReason(reason, "volume_max", record.ConditionsTruth.VolumeMax);
     }
   if(volume_step_readable && !ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.VolumeStep))
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendInvalidDoubleReason(reason, "volume_step", record.ConditionsTruth.VolumeStep);
     }
   if(volume_min_readable && volume_max_readable && record.ConditionsTruth.VolumeMax < record.ConditionsTruth.VolumeMin)
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendReason(reason, "volume_max below volume_min");
     }

   if(margin_currency_readable && !ASC_Conditions_Internal::IsMeaningfulText(record.ConditionsTruth.MarginCurrency))
      ASC_Conditions_Internal::AppendReason(reason, "margin_currency blank");
   if(profit_currency_readable && !ASC_Conditions_Internal::IsMeaningfulText(record.ConditionsTruth.ProfitCurrency))
      ASC_Conditions_Internal::AppendReason(reason, "profit_currency blank");

   const bool point_valid = (point_readable && ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.Point));
   const bool tick_size_valid = (tick_size_readable && ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickSize));
   const bool tick_value_raw_valid = (record.ConditionsTruth.TickValueRawReadable && ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickValueRaw));
   const bool tick_value_derived_valid = (record.ConditionsTruth.TickValueDerivedReadable && ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickValueDerived));
   const bool tick_value_validated_valid = (record.ConditionsTruth.TickValueValidatedReadable && ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickValueValidated));
   if(point_valid && tick_size_valid && record.ConditionsTruth.TickSize < record.ConditionsTruth.Point)
     {
      all_valid = false;
      contradictory = true;
      ASC_Conditions_Internal::AppendFlag(mismatch_flags, "TICK_SIZE_BELOW_POINT");
      ASC_Conditions_Internal::AppendReason(reason, "tick_size below point");
     }

   if(tick_size_valid && contract_size_readable && ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.ContractSize) && tick_value_raw_valid)
     {
      const double implied_tick_value = record.ConditionsTruth.ContractSize * record.ConditionsTruth.TickSize;
      if(ASC_Conditions_Internal::IsFinitePositive(implied_tick_value))
        {
         const double implied_gap = ASC_Conditions_Internal::AbsRatioGap(record.ConditionsTruth.TickValueRaw, implied_tick_value);
         if(implied_gap > 0.50)
           {
            contradictory = true;
            ASC_Conditions_Internal::AppendFlag(mismatch_flags, "TICK_VALUE_CONTRACT_MISMATCH");
            ASC_Conditions_Internal::AppendReason(reason, "tick_value raw vs contract/tick_size mismatch");
           }
        }
     }

   if(!tick_value_raw_valid && !tick_value_derived_valid && !tick_value_validated_valid)
     {
      broker_missing = true;
      ASC_Conditions_Internal::AppendFlag(mismatch_flags, "TICK_VALUE_MISSING");
      ASC_Conditions_Internal::AppendFlag(mismatch_flags, "NO_ECONOMIC_TRUTH");
      ASC_Conditions_Internal::AppendReason(reason, "tick_value broker-missing");
     }
   else if(!tick_value_raw_valid && (tick_value_derived_valid || tick_value_validated_valid))
     {
      ASC_Conditions_Internal::AppendFlag(mismatch_flags, "TICK_VALUE_RAW_UNREADABLE");
      ASC_Conditions_Internal::AppendReason(reason, "tick_value raw unreadable; using alternate evidence");
     }

   if(tick_value_profit_readable && tick_value_loss_readable &&
      ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickValueProfit) &&
      ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickValueLoss))
     {
      const double profit_loss_gap = ASC_Conditions_Internal::AbsRatioGap(record.ConditionsTruth.TickValueProfit, record.ConditionsTruth.TickValueLoss);
      if(profit_loss_gap > 0.50)
        {
         contradictory = true;
         ASC_Conditions_Internal::AppendFlag(mismatch_flags, "TICK_VALUE_PROFIT_LOSS_MISMATCH");
         ASC_Conditions_Internal::AppendFlag(mismatch_flags, "DERIVED_SIDE_ASYMMETRY");
         ASC_Conditions_Internal::AppendReason(reason, "tick_value_profit vs tick_value_loss mismatch");
        }
     }

   if(tick_value_raw_valid && tick_value_derived_valid)
     {
      const double raw_vs_derived_gap = ASC_Conditions_Internal::AbsRatioGap(record.ConditionsTruth.TickValueRaw, record.ConditionsTruth.TickValueDerived);
      if(raw_vs_derived_gap > 0.50)
        {
         contradictory = true;
         ASC_Conditions_Internal::AppendFlag(mismatch_flags, "TICK_VALUE_RAW_DERIVED_MISMATCH");
         ASC_Conditions_Internal::AppendReason(reason, "tick_value raw vs derived mismatch");
        }
     }

   if(tick_value_validated_valid && tick_value_raw_valid)
     {
      const double raw_vs_validated_gap = ASC_Conditions_Internal::AbsRatioGap(record.ConditionsTruth.TickValueRaw, record.ConditionsTruth.TickValueValidated);
      if(raw_vs_validated_gap > 0.50)
        {
         contradictory = true;
         ASC_Conditions_Internal::AppendFlag(mismatch_flags, "TICK_VALUE_RAW_VALIDATED_MISMATCH");
         ASC_Conditions_Internal::AppendReason(reason, "tick_value raw vs validated mismatch");
        }
     }

   if(tick_value_validated_valid && tick_value_derived_valid)
     {
      const double derived_vs_validated_gap = ASC_Conditions_Internal::AbsRatioGap(record.ConditionsTruth.TickValueDerived, record.ConditionsTruth.TickValueValidated);
      if(derived_vs_validated_gap > 0.50)
        {
         contradictory = true;
         ASC_Conditions_Internal::AppendFlag(mismatch_flags, "TICK_VALUE_DERIVED_VALIDATED_MISMATCH");
         ASC_Conditions_Internal::AppendReason(reason, "tick_value derived vs validated mismatch");
        }
     }
   else if(!tick_value_validated_valid)
     {
      ASC_Conditions_Internal::AppendFlag(mismatch_flags, "VALIDATION_THIN");
      ASC_Conditions_Internal::AppendReason(reason, "tick_value validation thin");
     }

   if(tick_value_validated_valid)
      ASC_Conditions_Internal::AppendFlag(mismatch_flags, "VALIDATED_TICK_VALUE");

   if(record.ConditionsTruth.CommissionMetadataReadable && StringLen(record.ConditionsTruth.CommissionMetadata) > 0)
      ASC_Conditions_Internal::AppendFlag(mismatch_flags, "COMMISSION_METADATA_PRESENT");

   record.ConditionsTruth.EconomicsMismatchFlags = mismatch_flags;
   record.ConditionsTruth.SpecsReadable = false;
   record.ConditionsTruth.NormalizationStatus = ASC_Conditions_Internal::ResolveNormalizationStatus(record);

   if(!all_readable && !any_readable)
      broker_unreadable = true;

   if(!all_readable)
      record.ConditionsTruth.TruthCoverageStatus = (any_readable ? "PARTIAL" : "UNREAD");
   else
      record.ConditionsTruth.TruthCoverageStatus = "FULL";

   if(!any_readable)
      record.ConditionsTruth.SpecIntegrityStatus = "SPEC_UNREADABLE";
   else if(!all_valid)
      record.ConditionsTruth.SpecIntegrityStatus = "SPEC_BROKEN";
   else if(contradictory)
      record.ConditionsTruth.SpecIntegrityStatus = "SPEC_CONTRADICTORY";
   else if(broker_missing)
      record.ConditionsTruth.SpecIntegrityStatus = "SPEC_BROKER_MISSING";
   else if(all_readable)
      record.ConditionsTruth.SpecIntegrityStatus = "SPEC_OK";
   else
      record.ConditionsTruth.SpecIntegrityStatus = "SPEC_SUSPICIOUS";

   if(record.ConditionsTruth.SpecIntegrityStatus == "SPEC_OK")
      record.ConditionsTruth.EconomicsTrust = (record.ConditionsTruth.EconomicsAuthoritative ? "VALIDATED" : "DERIVED_OK");
   else if(record.ConditionsTruth.SpecIntegrityStatus == "SPEC_SUSPICIOUS")
      record.ConditionsTruth.EconomicsTrust = (tick_value_validated_valid ? "VALIDATED_THIN" : "SUSPICIOUS");
   else if(record.ConditionsTruth.SpecIntegrityStatus == "SPEC_BROKER_MISSING")
      record.ConditionsTruth.EconomicsTrust = "BROKER_MISSING";
   else if(record.ConditionsTruth.SpecIntegrityStatus == "SPEC_UNREADABLE")
      record.ConditionsTruth.EconomicsTrust = "UNREADABLE";
   else if(record.ConditionsTruth.SpecIntegrityStatus == "SPEC_CONTRADICTORY")
      record.ConditionsTruth.EconomicsTrust = "CONTRADICTORY";
   else
      record.ConditionsTruth.EconomicsTrust = "BROKEN";

   const bool candidate_authoritative = record.ConditionsTruth.EconomicsAuthoritative;
   if(ASC_Conditions_Internal::ShouldPreservePrior(prior_truth, record.ConditionsTruth, candidate_authoritative))
     {
      record.ConditionsTruth = prior_truth;
      record.ConditionsTruth.SpecIntegrityStatus = "SPEC_PRESERVED_PRIOR";
      record.ConditionsTruth.EconomicsTrust = "CARRIED_FORWARD";
      record.ConditionsTruth.EconomicsPreservedFromPrior = true;
      ASC_Conditions_Internal::AppendFlag(record.ConditionsTruth.EconomicsMismatchFlags, "CARRY_FORWARD");
      record.ConditionsTruth.SpecsReadable = true;
      record.ConditionsTruth.SpecsReason = "preserved prior authoritative economics; incoming pass thinner";
      return true;
     }

   if(record.ConditionsTruth.SpecIntegrityStatus == "SPEC_OK" || record.ConditionsTruth.SpecIntegrityStatus == "SPEC_SUSPICIOUS")
      record.ConditionsTruth.SpecsReadable = true;

   if(record.ConditionsTruth.SpecsReadable)
      record.ConditionsTruth.SpecsReason = (record.ConditionsTruth.EconomicsAuthoritative ? "ok; validated economics" : "ok; derived economics") + (record.ConditionsTruth.CommissionMetadataReadable ? "; commission metadata noted" : "");
   else if(broker_unreadable)
      record.ConditionsTruth.SpecsReason = "broker-unreadable specs";
   else if(record.ConditionsTruth.SpecIntegrityStatus == "SPEC_BROKER_MISSING")
      record.ConditionsTruth.SpecsReason = "broker-missing economics; " + reason;
   else if(record.ConditionsTruth.SpecIntegrityStatus == "SPEC_CONTRADICTORY")
      record.ConditionsTruth.SpecsReason = "contradictory economics; flags=" + (StringLen(mismatch_flags) > 0 ? mismatch_flags : "NONE") + "; " + reason;
   else if(StringLen(reason) > 0)
      record.ConditionsTruth.SpecsReason = ((record.ConditionsTruth.TruthCoverageStatus == "PARTIAL") ? "partial truth; " : "") + reason;
   else
      record.ConditionsTruth.SpecsReason = "specs incomplete";

   return record.ConditionsTruth.SpecsReadable;
}

#endif
