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

   void AppendReason(string &reason, const string message)
   {
      if(StringLen(message) == 0)
         return;

      if(StringLen(reason) > 0)
         reason += "; ";

      reason += message;
   }

   void ResetConditionsTruth(ASC_ConditionsTruth &truth)
   {
      truth.SpecsReadable = false;
      truth.SpecsReason  = "specs not loaded";
      truth.Digits       = -1;
      truth.SpreadPoints = -1;
      truth.SpreadFloat  = false;
      truth.Point        = -1.0;
      truth.TickSize     = -1.0;
      truth.TickValue    = -1.0;
      truth.ContractSize = -1.0;
      truth.VolumeMin    = -1.0;
      truth.VolumeMax    = -1.0;
      truth.VolumeStep   = -1.0;
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

   void AppendSpecWeakness(string &reason,
                           const bool valid,
                           const string field_name)
   {
      if(!valid)
         AppendReason(reason, field_name + " suspect");
   }
}

bool ASC_Conditions_Load(const string symbol, ASC_SymbolRecord &record)
{
   ASC_Conditions_Internal::ResetConditionsTruth(record.ConditionsTruth);

   string reason = "";
   bool all_readable = true;
   bool all_valid = true;
   bool key_economics_strong = true;
   bool any_readable = false;
   bool partial_truth = false;

   if(StringLen(symbol) == 0)
   {
      record.ConditionsTruth.SpecsReason = "symbol is empty";
      return false;
   }

   long digits = 0;
   long spread_points = 0;
   long spread_float = 0;
   double point = 0.0;
   double tick_size = 0.0;
   double tick_value = 0.0;
   double contract_size = 0.0;
   double volume_min = 0.0;
   double volume_max = 0.0;
   double volume_step = 0.0;

   const bool digits_readable =
      ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_DIGITS, digits, "digits", reason);
   const bool spread_points_readable =
      ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_SPREAD, spread_points, "spread_points", reason);
   const bool spread_float_readable =
      ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_SPREAD_FLOAT, spread_float, "spread_float", reason);
   const bool point_readable =
      ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_POINT, point, "point", reason);
   const bool tick_size_readable =
      ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_TICK_SIZE, tick_size, "tick_size", reason);
   const bool tick_value_readable =
      ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_TICK_VALUE, tick_value, "tick_value", reason);
   const bool contract_size_readable =
      ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_CONTRACT_SIZE, contract_size, "contract_size", reason);
   const bool volume_min_readable =
      ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_VOLUME_MIN, volume_min, "volume_min", reason);
   const bool volume_max_readable =
      ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_VOLUME_MAX, volume_max, "volume_max", reason);
   const bool volume_step_readable =
      ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_VOLUME_STEP, volume_step, "volume_step", reason);

   all_readable = digits_readable &&
                  spread_points_readable &&
                  spread_float_readable &&
                  point_readable &&
                  tick_size_readable &&
                  tick_value_readable &&
                  contract_size_readable &&
                  volume_min_readable &&
                  volume_max_readable &&
                  volume_step_readable;

   any_readable = digits_readable ||
                  spread_points_readable ||
                  spread_float_readable ||
                  point_readable ||
                  tick_size_readable ||
                  tick_value_readable ||
                  contract_size_readable ||
                  volume_min_readable ||
                  volume_max_readable ||
                  volume_step_readable;

   partial_truth = (any_readable && !all_readable);

   ASC_Conditions_Internal::ApplyIntegerSpec(digits_readable, digits, record.ConditionsTruth.Digits);
   ASC_Conditions_Internal::ApplyIntegerSpec(spread_points_readable, spread_points, record.ConditionsTruth.SpreadPoints);
   ASC_Conditions_Internal::ApplyBooleanSpec(spread_float_readable, spread_float, record.ConditionsTruth.SpreadFloat);
   ASC_Conditions_Internal::ApplyDoubleSpec(point_readable, point, record.ConditionsTruth.Point);
   ASC_Conditions_Internal::ApplyDoubleSpec(tick_size_readable, tick_size, record.ConditionsTruth.TickSize);
   ASC_Conditions_Internal::ApplyDoubleSpec(tick_value_readable, tick_value, record.ConditionsTruth.TickValue);
   ASC_Conditions_Internal::ApplyDoubleSpec(contract_size_readable, contract_size, record.ConditionsTruth.ContractSize);
   ASC_Conditions_Internal::ApplyDoubleSpec(volume_min_readable, volume_min, record.ConditionsTruth.VolumeMin);
   ASC_Conditions_Internal::ApplyDoubleSpec(volume_max_readable, volume_max, record.ConditionsTruth.VolumeMax);
   ASC_Conditions_Internal::ApplyDoubleSpec(volume_step_readable, volume_step, record.ConditionsTruth.VolumeStep);

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

   if(point_readable && !ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.Point))
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendInvalidDoubleReason(reason, "point", record.ConditionsTruth.Point);
     }

   if(tick_size_readable && !ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickSize))
     {
      all_valid = false;
      key_economics_strong = false;
      ASC_Conditions_Internal::AppendInvalidDoubleReason(reason, "tick_size", record.ConditionsTruth.TickSize);
     }

   if(tick_value_readable && !ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickValue))
     {
      all_valid = false;
      key_economics_strong = false;
      ASC_Conditions_Internal::AppendInvalidDoubleReason(reason, "tick_value", record.ConditionsTruth.TickValue);
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

   if(volume_min_readable &&
      volume_max_readable &&
      record.ConditionsTruth.VolumeMax < record.ConditionsTruth.VolumeMin)
     {
      all_valid = false;
      ASC_Conditions_Internal::AppendReason(reason, "volume_max below volume_min");
     }

   const bool point_valid = (point_readable && ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.Point));
   const bool tick_size_valid = (tick_size_readable && ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickSize));
   const bool tick_value_valid = (tick_value_readable && ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.TickValue));
   const bool contract_size_valid = (contract_size_readable && ASC_Conditions_Internal::IsFinitePositive(record.ConditionsTruth.ContractSize));

   if(!tick_size_readable || !tick_value_readable || !tick_size_valid || !tick_value_valid)
      key_economics_strong = false;

   if(point_valid && tick_size_valid && record.ConditionsTruth.TickSize < record.ConditionsTruth.Point)
     {
      all_valid = false;
      key_economics_strong = false;
      ASC_Conditions_Internal::AppendReason(reason, "tick_size below point");
     }

   if(point_valid && tick_size_valid && tick_value_valid && contract_size_valid)
     {
      const double implied_tick_value = record.ConditionsTruth.ContractSize * record.ConditionsTruth.TickSize;
      if(ASC_Conditions_Internal::IsFinitePositive(implied_tick_value))
        {
         const double ratio = MathAbs(record.ConditionsTruth.TickValue - implied_tick_value) /
                              MathMax(record.ConditionsTruth.TickValue, implied_tick_value);
         if(ratio > 0.50)
           {
            key_economics_strong = false;
            ASC_Conditions_Internal::AppendReason(reason, "tick_value mismatch vs contract/tick_size");
           }
        }
     }

   if(!all_readable)
     {
      ASC_Conditions_Internal::AppendSpecWeakness(reason, tick_size_valid, "tick_size");
      ASC_Conditions_Internal::AppendSpecWeakness(reason, tick_value_valid, "tick_value");
     }

   record.ConditionsTruth.SpecsReadable = (all_readable && all_valid && key_economics_strong);

   if(record.ConditionsTruth.SpecsReadable)
      record.ConditionsTruth.SpecsReason = "ok";
   else if(!any_readable)
      record.ConditionsTruth.SpecsReason = "specs unreadable";
   else if(StringLen(reason) > 0)
     {
      if(partial_truth)
         record.ConditionsTruth.SpecsReason = "partial truth; " + reason;
      else
         record.ConditionsTruth.SpecsReason = reason;
     }
   else if(!key_economics_strong)
      record.ConditionsTruth.SpecsReason = "key economics suspect";
   else
      record.ConditionsTruth.SpecsReason = "specs incomplete";

   return record.ConditionsTruth.SpecsReadable;
}

#endif
