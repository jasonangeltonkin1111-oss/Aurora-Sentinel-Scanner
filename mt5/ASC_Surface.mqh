#ifndef ASC_SURFACE_MQH
#define ASC_SURFACE_MQH

#include "ASC_Common.mqh"

namespace ASC_Surface_Internal
{
   void AppendReason(string &reason,const string message)
     {
      if(StringLen(message) == 0)
         return;

      if(StringLen(reason) > 0)
         reason += "; ";

      reason += message;
     }

   void ResetSurfaceTruth(ASC_SurfaceTruth &truth)
     {
      truth.ScanState = ASC_SURFACE_NOT_RUN;
      truth.SurfaceEligible = false;
      truth.RankingEligible = false;
      truth.SurfaceReason = "";
      truth.BarsM15 = -1;
      truth.BarsH1 = -1;
      truth.LastBarTimeM15 = 0;
      truth.LastBarTimeH1 = 0;
      truth.QuoteAgeSeconds = -1.0;
      truth.SpreadCostPoints = -1.0;
      truth.SurfaceScore = -1.0;
     }

   bool ReadSeriesState(const string symbol,
                        const ENUM_TIMEFRAMES timeframe,
                        int &bars,
                        datetime &last_bar_time,
                        string &reason)
     {
      ResetLastError();
      bars = iBars(symbol,timeframe);
      if(bars <= 0)
        {
         AppendReason(reason,EnumToString(timeframe) + " history unavailable");
         bars = -1;
         last_bar_time = 0;
         return(false);
        }

      ResetLastError();
      last_bar_time = iTime(symbol,timeframe,0);
      if(last_bar_time <= 0)
        {
         AppendReason(reason,EnumToString(timeframe) + " last bar unavailable");
         return(false);
        }

      return(true);
     }

   double ComputeQuoteAgeSeconds(const datetime last_quote_time)
     {
      if(last_quote_time <= 0)
         return(-1.0);

      return((double)(TimeCurrent() - last_quote_time));
     }

   double ComputeSpreadScore(const ASC_ConditionsTruth &conditions)
     {
      if(!conditions.SpecsReadable || conditions.SpreadPoints < 0)
         return(0.0);

      if(conditions.SpreadPoints <= 5)
         return(40.0);
      if(conditions.SpreadPoints <= 15)
         return(30.0);
      if(conditions.SpreadPoints <= 30)
         return(20.0);
      if(conditions.SpreadPoints <= 50)
         return(10.0);

      return(0.0);
     }

   double ComputeFreshnessScore(const double quote_age_seconds,const int stale_feed_seconds)
     {
      if(quote_age_seconds < 0.0 || stale_feed_seconds <= 0)
         return(0.0);

      if(quote_age_seconds <= 5.0)
         return(30.0);
      if(quote_age_seconds <= 30.0)
         return(20.0);
      if(quote_age_seconds <= stale_feed_seconds)
         return(10.0);

      return(0.0);
     }

   double ComputeHistoryScore(const bool has_m15,const bool has_h1)
     {
      double score = 0.0;
      if(has_m15)
         score += 15.0;
      if(has_h1)
         score += 15.0;
      return(score);
     }
}

bool ASC_Surface_Evaluate(const ASC_RuntimeConfig &config,ASC_SymbolRecord &record)
  {
   ASC_Surface_Internal::ResetSurfaceTruth(record.SurfaceTruth);

   if(!record.MarketTruth.Exists)
     {
      record.SurfaceTruth.ScanState = ASC_SURFACE_SKIPPED;
      record.SurfaceTruth.SurfaceReason = "symbol not present in broker universe";
      ASC_Logger_Log("WARN","SURFACE","ASC_Surface_Evaluate",
                     "skipped symbol=" + record.Identity.RawSymbol + " reason=" + record.SurfaceTruth.SurfaceReason);
      return(false);
     }

   if(!record.MarketTruth.Layer1Eligible)
     {
      record.SurfaceTruth.ScanState = ASC_SURFACE_SKIPPED;
      record.SurfaceTruth.SurfaceReason = record.MarketTruth.IneligibleReason;
      if(StringLen(record.SurfaceTruth.SurfaceReason) == 0)
         record.SurfaceTruth.SurfaceReason = "layer 1 ineligible";
      ASC_Logger_Log("WARN","SURFACE","ASC_Surface_Evaluate",
                     "skipped symbol=" + record.Identity.RawSymbol + " reason=" + record.SurfaceTruth.SurfaceReason);
      return(false);
     }

   record.SurfaceTruth.ScanState = ASC_SURFACE_EVALUATED;
   record.SurfaceTruth.SurfaceEligible = true;
   record.SurfaceTruth.SurfaceReason = "surface scan evaluated";

   string reason = "";
   bool has_m15 = ASC_Surface_Internal::ReadSeriesState(record.Identity.RawSymbol,PERIOD_M15,
                                                        record.SurfaceTruth.BarsM15,
                                                        record.SurfaceTruth.LastBarTimeM15,
                                                        reason);
   bool has_h1 = ASC_Surface_Internal::ReadSeriesState(record.Identity.RawSymbol,PERIOD_H1,
                                                       record.SurfaceTruth.BarsH1,
                                                       record.SurfaceTruth.LastBarTimeH1,
                                                       reason);

   record.SurfaceTruth.QuoteAgeSeconds =
      ASC_Surface_Internal::ComputeQuoteAgeSeconds(record.MarketTruth.LastQuoteTime);

   if(record.ConditionsTruth.SpecsReadable)
      record.SurfaceTruth.SpreadCostPoints = (double)record.ConditionsTruth.SpreadPoints;

   const bool bucket_known = (StringLen(record.Identity.PrimaryBucket) > 0);
   const bool conditions_ok = record.ConditionsTruth.SpecsReadable;
   const bool quote_fresh = (record.SurfaceTruth.QuoteAgeSeconds >= 0.0 &&
                             record.SurfaceTruth.QuoteAgeSeconds <= config.StaleFeedSeconds);

   if(!bucket_known)
      ASC_Surface_Internal::AppendReason(reason,"primary bucket missing");
   if(!conditions_ok)
      ASC_Surface_Internal::AppendReason(reason,record.ConditionsTruth.SpecsReason);
   if(!quote_fresh)
      ASC_Surface_Internal::AppendReason(reason,"quote freshness outside Layer 2 bounds");

   record.SurfaceTruth.RankingEligible = (bucket_known && conditions_ok && quote_fresh && has_m15 && has_h1);

   if(record.SurfaceTruth.RankingEligible)
     {
      record.SurfaceTruth.SurfaceScore =
         ASC_Surface_Internal::ComputeSpreadScore(record.ConditionsTruth) +
         ASC_Surface_Internal::ComputeFreshnessScore(record.SurfaceTruth.QuoteAgeSeconds,config.StaleFeedSeconds) +
         ASC_Surface_Internal::ComputeHistoryScore(has_m15,has_h1);
      record.SurfaceTruth.SurfaceReason = "surface eligible for later ranking";
      ASC_Logger_Log("INFO","SURFACE","ASC_Surface_Evaluate",
                     "evaluated symbol=" + record.Identity.RawSymbol +
                     " ranking_eligible=true score=" + DoubleToString(record.SurfaceTruth.SurfaceScore,2));
      return(true);
     }

   if(StringLen(reason) == 0)
      reason = "surface truth incomplete";

   record.SurfaceTruth.SurfaceReason = reason;
   ASC_Logger_Log("WARN","SURFACE","ASC_Surface_Evaluate",
                  "evaluated symbol=" + record.Identity.RawSymbol +
                  " ranking_eligible=false reason=" + record.SurfaceTruth.SurfaceReason);
   return(false);
  }

#endif
