#ifndef ASC_CONDITIONS_MQH
#define ASC_CONDITIONS_MQH

#include "ASC_Common.mqh"

namespace ASC_Conditions_Internal
{
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
}

bool ASC_Conditions_Load(const string symbol, ASC_SymbolRecord &record)
{
   ASC_Conditions_Internal::ResetConditionsTruth(record.ConditionsTruth);

   string reason = "";
   bool all_readable = true;

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

   all_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_DIGITS, digits, "digits", reason) && all_readable;
   all_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_SPREAD, spread_points, "spread_points", reason) && all_readable;
   all_readable = ASC_Conditions_Internal::ReadIntegerSpec(symbol, SYMBOL_SPREAD_FLOAT, spread_float, "spread_float", reason) && all_readable;
   all_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_POINT, point, "point", reason) && all_readable;
   all_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_TICK_SIZE, tick_size, "tick_size", reason) && all_readable;
   all_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_TICK_VALUE, tick_value, "tick_value", reason) && all_readable;
   all_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_TRADE_CONTRACT_SIZE, contract_size, "contract_size", reason) && all_readable;
   all_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_VOLUME_MIN, volume_min, "volume_min", reason) && all_readable;
   all_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_VOLUME_MAX, volume_max, "volume_max", reason) && all_readable;
   all_readable = ASC_Conditions_Internal::ReadDoubleSpec(symbol, SYMBOL_VOLUME_STEP, volume_step, "volume_step", reason) && all_readable;

   if(all_readable)
   {
      record.ConditionsTruth.Digits       = (int)digits;
      record.ConditionsTruth.SpreadPoints = (int)spread_points;
      record.ConditionsTruth.SpreadFloat  = (spread_float != 0);
      record.ConditionsTruth.Point        = point;
      record.ConditionsTruth.TickSize     = tick_size;
      record.ConditionsTruth.TickValue    = tick_value;
      record.ConditionsTruth.ContractSize = contract_size;
      record.ConditionsTruth.VolumeMin    = volume_min;
      record.ConditionsTruth.VolumeMax    = volume_max;
      record.ConditionsTruth.VolumeStep   = volume_step;

      if(record.ConditionsTruth.Digits < 0)
         ASC_Conditions_Internal::AppendReason(reason, "digits invalid");

      if(record.ConditionsTruth.SpreadPoints < 0)
         ASC_Conditions_Internal::AppendReason(reason, "spread_points invalid");

      if(record.ConditionsTruth.Point <= 0.0)
         ASC_Conditions_Internal::AppendReason(reason, "point invalid");

      if(record.ConditionsTruth.TickSize <= 0.0)
         ASC_Conditions_Internal::AppendReason(reason, "tick_size invalid");

      if(record.ConditionsTruth.TickValue <= 0.0)
         ASC_Conditions_Internal::AppendReason(reason, "tick_value invalid");

      if(record.ConditionsTruth.ContractSize <= 0.0)
         ASC_Conditions_Internal::AppendReason(reason, "contract_size invalid");

      if(record.ConditionsTruth.VolumeMin <= 0.0)
         ASC_Conditions_Internal::AppendReason(reason, "volume_min invalid");

      if(record.ConditionsTruth.VolumeMax <= 0.0)
         ASC_Conditions_Internal::AppendReason(reason, "volume_max invalid");

      if(record.ConditionsTruth.VolumeStep <= 0.0)
         ASC_Conditions_Internal::AppendReason(reason, "volume_step invalid");

      if(record.ConditionsTruth.VolumeMax < record.ConditionsTruth.VolumeMin)
         ASC_Conditions_Internal::AppendReason(reason, "volume_max below volume_min");
   }

   record.ConditionsTruth.SpecsReadable = (StringLen(reason) == 0);
   record.ConditionsTruth.SpecsReason = record.ConditionsTruth.SpecsReadable ? "ok" : reason;

   return record.ConditionsTruth.SpecsReadable;
}

#endif
