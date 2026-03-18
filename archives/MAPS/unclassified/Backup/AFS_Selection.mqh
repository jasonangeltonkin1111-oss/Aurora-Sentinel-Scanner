//+------------------------------------------------------------------+
//|                                                    AFS_Selection |
//|              Aegis Forge Scanner - Phase 1 / Step 9             |
//+------------------------------------------------------------------+
#ifndef __AFS_SELECTION_MQH__
#define __AFS_SELECTION_MQH__

#include "AFS_CoreTypes.mqh"

double AFS_SL_ClampScore(const double value)
  {
   if(!MathIsValidNumber(value))
      return 0.0;
   if(value < 0.0)
      return 0.0;
   if(value > 100.0)
      return 100.0;
   return value;
  }

bool AFS_SL_RecordInSelectionScope(const AFS_UniverseSymbol &rec,const bool selected_scope_only)
  {
   if(!rec.TradeAllowed)
      return false;
   if(!rec.ClassificationResolved)
      return false;
   if(selected_scope_only && !rec.ScopeIncluded)
      return false;
   return true;
  }

bool AFS_SL_IsRankable(const AFS_UniverseSymbol &rec,const bool selected_scope_only)
  {
   if(!AFS_SL_RecordInSelectionScope(rec, selected_scope_only))
      return false;
   if(rec.FrictionStatus == "FAIL")
      return false;

   if(rec.FrictionUpdateCount > 0)
      return true;

   // Preserve carry-forward Step 8 truth so valid PASS/WEAK names do not vanish
   // from Step 9/10/11 merely because the current friction refresh has not yet rebuilt.
   if((rec.FrictionStatus == "PASS" || rec.FrictionStatus == "WEAK") &&
      (rec.LastFrictionUpdateAt > 0 || rec.LastTradableEvidenceAt > 0 || rec.LastAliveEvidenceAt > 0))
      return true;

   return false;
  }

double AFS_SL_ComputeCostEfficiencyScore(const AFS_UniverseSymbol &rec)
  {
   double ratio = rec.SpreadAtrRatio;

   if(ratio <= 0.0 || !MathIsValidNumber(ratio))
     {
      if(rec.FrictionQuoteUsable && rec.FrictionStatus != "FAIL")
         return 60.0;
      return 25.0;
     }

   if(ratio <= 0.03) return 98.0;
   if(ratio <= 0.05) return 92.0;
   if(ratio <= 0.08) return 84.0;
   if(ratio <= 0.12) return 72.0;
   if(ratio <= 0.18) return 58.0;
   if(ratio <= 0.25) return 44.0;
   if(ratio <= 0.40) return 28.0;
   return 12.0;
  }

double AFS_SL_ComputeTrustScore(const AFS_UniverseSymbol &rec)
  {
   double score = 0.0;

   if(rec.EconomicsTrust == "PASS")
      score += 35.0;
   else if(rec.EconomicsTrust == "WEAK")
      score += 22.0;
   else
      score += 8.0;

   if(rec.HistoryStatus == "PASS")
      score += 25.0;
   else if(rec.HistoryStatus == "WEAK")
      score += 14.0;
   else
      score += 4.0;

   if(rec.FrictionStatus == "PASS")
      score += 26.0;
   else if(rec.FrictionStatus == "WEAK")
      score += 14.0;

   if(rec.FrictionHoldPass)
      score += 5.0;
   if(rec.FrictionMarketLive)
      score += 5.0;
   if(rec.FrictionQuoteUsable)
      score += 4.0;

   return AFS_SL_ClampScore(score);
  }

double AFS_SL_ComputeTotalScore(const AFS_UniverseSymbol &rec)
  {
   double movement  = AFS_SL_ClampScore(rec.MovementCapacityScore);
   double cost      = AFS_SL_ClampScore(rec.CostEfficiencyScore);
   double lively    = AFS_SL_ClampScore(rec.LivelinessScore);
   double trust     = AFS_SL_ClampScore(rec.TrustScore);
   double freshness = AFS_SL_ClampScore(rec.FreshnessScore);

   double total = (movement * 0.28) +
                  (cost * 0.22) +
                  (lively * 0.18) +
                  (trust * 0.20) +
                  (freshness * 0.12);

   if(rec.FrictionStatus == "WEAK")
      total *= 0.88;

   return AFS_SL_ClampScore(total);
  }

bool AFS_SL_BetterTieBreak(const AFS_UniverseSymbol &a,const AFS_UniverseSymbol &b)
  {
   if(a.FrictionStatus == "PASS" && b.FrictionStatus != "PASS")
      return true;
   if(a.FrictionStatus != "PASS" && b.FrictionStatus == "PASS")
      return false;

   if(a.TrustScore > b.TrustScore)
      return true;
   if(a.TrustScore < b.TrustScore)
      return false;

   if(a.FreshnessScore > b.FreshnessScore)
      return true;
   if(a.FreshnessScore < b.FreshnessScore)
      return false;

   return (StringCompare(a.Symbol, b.Symbol) < 0);
  }

bool AFS_SL_BetterCorrelationFinalist(const AFS_UniverseSymbol &a,const AFS_UniverseSymbol &b)
  {
   if(a.TotalScore > b.TotalScore)
      return true;
   if(a.TotalScore < b.TotalScore)
      return false;

   if(a.FrictionStatus == "PASS" && b.FrictionStatus != "PASS")
      return true;
   if(a.FrictionStatus != "PASS" && b.FrictionStatus == "PASS")
      return false;

   if(a.BucketRank > 0 && b.BucketRank > 0)
     {
      if(a.BucketRank < b.BucketRank)
         return true;
      if(a.BucketRank > b.BucketRank)
         return false;
     }

   if(a.TrustScore > b.TrustScore)
      return true;
   if(a.TrustScore < b.TrustScore)
      return false;

   if(a.FreshnessScore > b.FreshnessScore)
      return true;
   if(a.FreshnessScore < b.FreshnessScore)
      return false;

   return (StringCompare(a.Symbol, b.Symbol) < 0);
  }

void AFS_SL_ResetSelectionFields(AFS_UniverseSymbol &rec)
  {
   rec.CostEfficiencyScore = 0.0;
   rec.TrustScore          = 0.0;
   rec.TotalScore          = 0.0;
   rec.CorrMax             = 0.0;
   rec.BucketRank          = 0;
   rec.FinalistSelected    = false;
   rec.CorrClosestSymbol   = "";
   rec.CorrContextFlag     = "CORR_PENDING";
  }


void AFS_SL_ResetCorrelationFields(AFS_UniverseSymbol &rec)
  {
   rec.CorrMax           = 0.0;
   rec.CorrClosestSymbol = "";
   rec.CorrContextFlag   = "CORR_PENDING";
  }

double AFS_SL_AbsCorr(const double value)
  {
   return (value >= 0.0 ? value : -value);
  }

bool AFS_SL_LoadCloseReturns(const string symbol,
                             const ENUM_TIMEFRAMES tf,
                             const int close_count,
                             double &returns[])
  {
   ArrayResize(returns, 0);

   if(close_count < 3)
      return false;

   double closes[];
   ArraySetAsSeries(closes, true);

   int copied = CopyClose(symbol, tf, 1, close_count, closes);
   if(copied < 3)
      return false;

   int ret_count = copied - 1;
   ArrayResize(returns, ret_count);

   int out_idx = 0;
   for(int i = copied - 1; i >= 1; i--)
     {
      double prev_close = closes[i];
      double curr_close = closes[i - 1];

      if(!MathIsValidNumber(prev_close) || !MathIsValidNumber(curr_close) || prev_close == 0.0)
         return false;

      returns[out_idx] = (curr_close - prev_close) / prev_close;
      out_idx++;
     }

   return (out_idx >= 2);
  }

bool AFS_SL_ComputePearson(const double &a[],const double &b[],double &corr_out)
  {
   corr_out = 0.0;

   int count = MathMin(ArraySize(a), ArraySize(b));
   if(count < 3)
      return false;

   double mean_a = 0.0;
   double mean_b = 0.0;

   for(int i = 0; i < count; i++)
     {
      mean_a += a[i];
      mean_b += b[i];
     }

   mean_a /= count;
   mean_b /= count;

   double cov = 0.0;
   double var_a = 0.0;
   double var_b = 0.0;

   for(int i = 0; i < count; i++)
     {
      double da = a[i] - mean_a;
      double db = b[i] - mean_b;
      cov   += (da * db);
      var_a += (da * da);
      var_b += (db * db);
     }

   if(var_a <= 0.0 || var_b <= 0.0)
      return false;

   corr_out = cov / MathSqrt(var_a * var_b);

   if(!MathIsValidNumber(corr_out))
      return false;

   if(corr_out > 1.0)
      corr_out = 1.0;
   else if(corr_out < -1.0)
      corr_out = -1.0;

   return true;
  }

string AFS_SL_BuildCorrContextFlag(const double corr_value,const int valid_pair_count)
  {
   if(valid_pair_count <= 0)
      return "CORR_PENDING";

   double abs_corr = AFS_SL_AbsCorr(corr_value);

   if(abs_corr >= 0.90)
      return "CORR_CLUSTERED";
   if(abs_corr >= 0.75)
      return "CORR_LINKED";
   return "CORR_DIVERSE";
  }

bool AFS_SL_ComputePairCorrelation(const string symbol_a,
                                   const string symbol_b,
                                   const ENUM_TIMEFRAMES tf,
                                   const int close_count,
                                   double &corr_out)
  {
   corr_out = 0.0;

   double ret_a[];
   double ret_b[];

   if(!AFS_SL_LoadCloseReturns(symbol_a, tf, close_count, ret_a))
      return false;
   if(!AFS_SL_LoadCloseReturns(symbol_b, tf, close_count, ret_b))
      return false;

   return AFS_SL_ComputePearson(ret_a, ret_b, corr_out);
  }

bool AFS_Correlation_Rebuild(AFS_UniverseSymbol &records[],
                             const int total,
                             const int finalist_set_max,
                             string &detail)
  {
   detail = "Idle";

   if(total <= 0)
      return true;

   int finalists[];
   ArrayResize(finalists, 0);

   for(int i = 0; i < total; i++)
     {
      AFS_SL_ResetCorrelationFields(records[i]);

      if(records[i].FinalistSelected)
        {
         int pos = ArraySize(finalists);
         ArrayResize(finalists, pos + 1);
         finalists[pos] = i;
        }
     }

   int finalist_count = ArraySize(finalists);
   if(finalist_count <= 0)
     {
      detail = "0 finalists";
      return true;
     }

   if(finalist_set_max > 0 && finalist_count > finalist_set_max)
     {
      int limited[];
      bool used[];

      ArrayResize(limited, finalist_set_max);
      ArrayResize(used, finalist_count);

      for(int u = 0; u < finalist_count; u++)
         used[u] = false;

      for(int pick = 0; pick < finalist_set_max; pick++)
        {
         int best_pos = -1;

         for(int k = 0; k < finalist_count; k++)
           {
            if(used[k])
               continue;

            if(best_pos < 0)
              {
               best_pos = k;
               continue;
              }

            if(AFS_SL_BetterCorrelationFinalist(records[finalists[k]],
                                                records[finalists[best_pos]]))
               best_pos = k;
           }

         if(best_pos < 0)
           {
            ArrayResize(limited, pick);
            break;
           }

         used[best_pos] = true;
         limited[pick]  = finalists[best_pos];
        }

      ArrayResize(finalists, ArraySize(limited));
      for(int copy_i = 0; copy_i < ArraySize(limited); copy_i++)
         finalists[copy_i] = limited[copy_i];

      finalist_count = ArraySize(finalists);
     }

   const ENUM_TIMEFRAMES corr_tf = PERIOD_M15;
   const int corr_close_count = 33;
   int annotated_count = 0;

   for(int i = 0; i < finalist_count; i++)
     {
      int rec_i = finalists[i];
      double best_corr = 0.0;
      double best_abs = -1.0;
      string best_symbol = "";
      int valid_pairs = 0;

      for(int j = 0; j < finalist_count; j++)
        {
         if(i == j)
            continue;

         double corr = 0.0;
         if(!AFS_SL_ComputePairCorrelation(records[rec_i].Symbol,
                                           records[finalists[j]].Symbol,
                                           corr_tf,
                                           corr_close_count,
                                           corr))
            continue;

         valid_pairs++;

         double abs_corr = AFS_SL_AbsCorr(corr);
         if(abs_corr > best_abs)
           {
            best_abs = abs_corr;
            best_corr = corr;
            best_symbol = records[finalists[j]].Symbol;
           }
        }

      if(valid_pairs <= 0)
        {
         records[rec_i].CorrContextFlag = "CORR_PENDING";
         continue;
        }

      records[rec_i].CorrMax = best_corr;
      records[rec_i].CorrClosestSymbol = best_symbol;
      records[rec_i].CorrContextFlag = AFS_SL_BuildCorrContextFlag(best_corr, valid_pairs);
      annotated_count++;
     }

   detail = IntegerToString(annotated_count) + "/" + IntegerToString(finalist_count) +
            " correlated | TF=M15 | Win=32";
   return true;
  }

bool AFS_Selection_Rebuild(AFS_UniverseSymbol &records[],
                           const int total,
                           const bool selected_scope_only,
                           const datetime now,
                           int &finalist_count,
                           string &detail)
  {
   finalist_count = 0;
   detail = "Idle";

   if(total <= 0)
      return true;

   for(int i = 0; i < total; i++)
     {
      AFS_SL_ResetSelectionFields(records[i]);

      if(!AFS_SL_RecordInSelectionScope(records[i], selected_scope_only))
         continue;

      records[i].CostEfficiencyScore = AFS_SL_ComputeCostEfficiencyScore(records[i]);
      records[i].TrustScore          = AFS_SL_ComputeTrustScore(records[i]);

      if(AFS_SL_IsRankable(records[i], selected_scope_only))
        {
         records[i].TotalScore = AFS_SL_ComputeTotalScore(records[i]);
         records[i].LastRankingUpdateAt = now;
        }
      else
        {
         records[i].LastRankingUpdateAt = 0;
        }
     }

   int rankable_count = 0;

   for(int i = 0; i < total; i++)
     {
      if(!AFS_SL_IsRankable(records[i], selected_scope_only))
         continue;

      rankable_count++;
      int rank = 1;

      for(int j = 0; j < total; j++)
        {
         if(i == j)
            continue;
         if(!AFS_SL_IsRankable(records[j], selected_scope_only))
            continue;
         if(records[i].PrimaryBucket != records[j].PrimaryBucket)
            continue;

         if(records[j].TotalScore > records[i].TotalScore)
            rank++;
         else if(records[j].TotalScore == records[i].TotalScore && AFS_SL_BetterTieBreak(records[j], records[i]))
            rank++;
        }

      records[i].BucketRank = rank;
      if(rank <= 5)
        {
         records[i].FinalistSelected = true;
         finalist_count++;
        }
     }

   detail = IntegerToString(finalist_count) + " finalists | Rankable " + IntegerToString(rankable_count);
   return true;
  }

#endif
