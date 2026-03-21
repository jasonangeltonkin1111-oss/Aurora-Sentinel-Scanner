#ifndef __ASC_EXPLORER_BUCKETS_MQH__
#define __ASC_EXPLORER_BUCKETS_MQH__

#include "ASC_Common.mqh"

struct ASC_BucketPlaceholder
  {
   string name;
   string family;
   string posture;
   string note;
  };

int ASC_GetBucketPlaceholders(ASC_BucketPlaceholder &buckets[])
  {
   ArrayResize(buckets,15);

   buckets[0].name="FX Major";
   buckets[0].family="FX";
   buckets[0].posture="Reserved Seed";
   buckets[0].note="Seeded from legacy classification vocabulary for major currency pairs.";

   buckets[1].name="FX Cross";
   buckets[1].family="FX";
   buckets[1].posture="Reserved Seed";
   buckets[1].note="Reserved for cross-currency bucket activation.";

   buckets[2].name="FX Exotic";
   buckets[2].family="FX";
   buckets[2].posture="Reserved Seed";
   buckets[2].note="Reserved for regional and exotic currency coverage.";

   buckets[3].name="Index US";
   buckets[3].family="Index";
   buckets[3].posture="Reserved Seed";
   buckets[3].note="Reserved for US cash index instruments.";

   buckets[4].name="Index Europe";
   buckets[4].family="Index";
   buckets[4].posture="Reserved Seed";
   buckets[4].note="Reserved for European index instruments.";

   buckets[5].name="Index Asia";
   buckets[5].family="Index";
   buckets[5].posture="Reserved Seed";
   buckets[5].note="Reserved for Asian index instruments.";

   buckets[6].name="Metals Precious";
   buckets[6].family="Metals";
   buckets[6].posture="Reserved Seed";
   buckets[6].note="Reserved for precious-metal instruments.";

   buckets[7].name="Metals Base";
   buckets[7].family="Metals";
   buckets[7].posture="Reserved Seed";
   buckets[7].note="Reserved for base-metal instruments.";

   buckets[8].name="Energy";
   buckets[8].family="Commodities";
   buckets[8].posture="Reserved Seed";
   buckets[8].note="Reserved for energy-linked instruments.";

   buckets[9].name="Crypto Large Cap";
   buckets[9].family="Crypto";
   buckets[9].posture="Reserved Seed";
   buckets[9].note="Reserved for large-cap crypto coverage.";

   buckets[10].name="Crypto Alt L1";
   buckets[10].family="Crypto";
   buckets[10].posture="Reserved Seed";
   buckets[10].note="Reserved for alternative layer-1 crypto instruments.";

   buckets[11].name="Crypto DeFi";
   buckets[11].family="Crypto";
   buckets[11].posture="Reserved Seed";
   buckets[11].note="Reserved for DeFi-linked instruments.";

   buckets[12].name="Crypto Payments";
   buckets[12].family="Crypto";
   buckets[12].posture="Reserved Seed";
   buckets[12].note="Reserved for payment-network crypto instruments.";

   buckets[13].name="US Equity Technology";
   buckets[13].family="Stocks";
   buckets[13].posture="Reserved Seed";
   buckets[13].note="Reserved for US technology equities once identity is active.";

   buckets[14].name="US Equity Financial";
   buckets[14].family="Stocks";
   buckets[14].posture="Reserved Seed";
   buckets[14].note="Reserved for US financial equities once identity is active.";

   return(ArraySize(buckets));
  }

int ASC_GetBucketSeedSymbolCount(const int bucket_index)
  {
   switch(bucket_index)
     {
      case 0: return(3);
      case 1: return(3);
      case 2: return(3);
      case 3: return(3);
      case 4: return(3);
      case 5: return(3);
      case 6: return(3);
      case 7: return(3);
      case 8: return(3);
      case 9: return(3);
      case 10: return(3);
      case 11: return(3);
      case 12: return(3);
      case 13: return(3);
      case 14: return(3);
     }
   return(0);
  }

string ASC_GetBucketSeedSymbol(const int bucket_index,const int row)
  {
   switch(bucket_index)
     {
      case 0:
         if(row==0) return("EURUSD");
         if(row==1) return("GBPUSD");
         if(row==2) return("USDJPY");
         break;
      case 1:
         if(row==0) return("EURGBP");
         if(row==1) return("AUDCAD");
         if(row==2) return("NZDJPY");
         break;
      case 2:
         if(row==0) return("USDMXN");
         if(row==1) return("USDZAR");
         if(row==2) return("EURTRY");
         break;
      case 3:
         if(row==0) return("US30");
         if(row==1) return("US500");
         if(row==2) return("NAS100");
         break;
      case 4:
         if(row==0) return("GER40");
         if(row==1) return("UK100");
         if(row==2) return("EU50");
         break;
      case 5:
         if(row==0) return("JPN225");
         if(row==1) return("HK50");
         if(row==2) return("AUS200");
         break;
      case 6:
         if(row==0) return("XAUUSD");
         if(row==1) return("XAGUSD");
         if(row==2) return("XPTUSD");
         break;
      case 7:
         if(row==0) return("COPPER");
         if(row==1) return("ALUMINIUM");
         if(row==2) return("ZINC");
         break;
      case 8:
         if(row==0) return("BRENT");
         if(row==1) return("XTIUSD");
         if(row==2) return("NGAS");
         break;
      case 9:
         if(row==0) return("BTCUSD");
         if(row==1) return("ETHUSD");
         if(row==2) return("BNBUSD");
         break;
      case 10:
         if(row==0) return("SOLUSD");
         if(row==1) return("ADAUSD");
         if(row==2) return("DOTUSD");
         break;
      case 11:
         if(row==0) return("UNIUSD");
         if(row==1) return("AVEUSD");
         if(row==2) return("LNKUSD");
         break;
      case 12:
         if(row==0) return("XRPUSD");
         if(row==1) return("LTCUSD");
         if(row==2) return("XLMUSD");
         break;
      case 13:
         if(row==0) return("AAPL.US");
         if(row==1) return("AMZN.US");
         if(row==2) return("META.US");
         break;
      case 14:
         if(row==0) return("JPM.US");
         if(row==1) return("BAC.US");
         if(row==2) return("GS.US");
         break;
     }
   return("Seed Pending");
  }

string ASC_GetBucketSeedNote(const int bucket_index)
  {
   ASC_BucketPlaceholder buckets[];
   int total=ASC_GetBucketPlaceholders(buckets);
   if(bucket_index<0 || bucket_index>=total)
      return("Reserved bucket detail is not available yet.");
   return(buckets[bucket_index].note);
  }

#endif
