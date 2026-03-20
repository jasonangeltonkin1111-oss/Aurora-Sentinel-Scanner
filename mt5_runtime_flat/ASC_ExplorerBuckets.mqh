#ifndef __ASC_EXPLORER_BUCKETS_MQH__
#define __ASC_EXPLORER_BUCKETS_MQH__

#include "ASC_Common.mqh"

struct ASC_BucketPlaceholder
  {
   string name;
   string family;
   string note;
  };

int ASC_GetBucketPlaceholders(ASC_BucketPlaceholder &buckets[])
  {
   ArrayResize(buckets,15);

   buckets[0].name="FX Major";
   buckets[0].family="FX";
   buckets[0].note="Seeded from legacy classification vocabulary for major currency pairs.";

   buckets[1].name="FX Cross";
   buckets[1].family="FX";
   buckets[1].note="Reserved for cross-currency bucket activation.";

   buckets[2].name="FX Exotic";
   buckets[2].family="FX";
   buckets[2].note="Reserved for regional and exotic currency coverage.";

   buckets[3].name="Index US";
   buckets[3].family="Index";
   buckets[3].note="Reserved for US cash index instruments.";

   buckets[4].name="Index Europe";
   buckets[4].family="Index";
   buckets[4].note="Reserved for European index instruments.";

   buckets[5].name="Index Asia";
   buckets[5].family="Index";
   buckets[5].note="Reserved for Asian index instruments.";

   buckets[6].name="Metals Precious";
   buckets[6].family="Metals";
   buckets[6].note="Reserved for precious-metal instruments.";

   buckets[7].name="Metals Base";
   buckets[7].family="Metals";
   buckets[7].note="Reserved for base-metal instruments.";

   buckets[8].name="Energy";
   buckets[8].family="Commodities";
   buckets[8].note="Reserved for energy-linked instruments.";

   buckets[9].name="Crypto Large Cap";
   buckets[9].family="Crypto";
   buckets[9].note="Reserved for large-cap crypto coverage.";

   buckets[10].name="Crypto Alt L1";
   buckets[10].family="Crypto";
   buckets[10].note="Reserved for alternative layer-1 crypto instruments.";

   buckets[11].name="Crypto DeFi";
   buckets[11].family="Crypto";
   buckets[11].note="Reserved for DeFi-linked instruments.";

   buckets[12].name="Crypto Payments";
   buckets[12].family="Crypto";
   buckets[12].note="Reserved for payment-network crypto instruments.";

   buckets[13].name="US Equity Technology";
   buckets[13].family="Stocks";
   buckets[13].note="Reserved for US technology equities once identity is active.";

   buckets[14].name="US Equity Financial";
   buckets[14].family="Stocks";
   buckets[14].note="Reserved for US financial equities once identity is active.";

   return(ArraySize(buckets));
  }

#endif
