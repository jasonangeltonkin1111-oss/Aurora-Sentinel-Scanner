#ifndef __ASC_EXPLORER_BUCKETS_MQH__
#define __ASC_EXPLORER_BUCKETS_MQH__

#include "ASC_Common.mqh"

struct ASC_BucketSeedReference
  {
   string symbol_ref;
   string note;
  };

struct ASC_BucketDefinition
  {
   string bucket_id;
   string name;
   string family;
   string posture;
   string note;
   ASC_BucketSeedReference symbol_refs[];
  };

struct ASC_BucketViewModel
  {
   string bucket_id;
   string name;
   string family;
   string posture;
   string note;
   int resolved_symbol_count;
   string symbol_refs[];
   string symbol_notes[];
   ASC_ExplorerBucketDisplayMode display_mode;
  };

void ASC_BucketSetSeedRef(ASC_BucketSeedReference &ref,const string symbol_ref,const string note)
  {
   ref.symbol_ref=symbol_ref;
   ref.note=note;
  }

void ASC_BucketDefine(ASC_BucketDefinition &bucket,const string bucket_id,const string name,const string family,const string posture,const string note)
  {
   bucket.bucket_id=bucket_id;
   bucket.name=name;
   bucket.family=family;
   bucket.posture=posture;
   bucket.note=note;
   ArrayResize(bucket.symbol_refs,0);
  }

void ASC_BucketAppendSeedRef(ASC_BucketDefinition &bucket,const string symbol_ref,const string note)
  {
   int slot=ArraySize(bucket.symbol_refs);
   ArrayResize(bucket.symbol_refs,slot+1);
   ASC_BucketSetSeedRef(bucket.symbol_refs[slot],symbol_ref,note);
  }

void ASC_BucketPlaceholderCatalog(ASC_BucketDefinition &buckets[])
  {
   ArrayResize(buckets,12);

   ASC_BucketDefine(buckets[0],"fx-major","FX Major","FX","Reference Taxonomy","Canonical major-FX bucket placeholder until Symbol Identity and Bucketing can resolve live broker membership.");
   ASC_BucketAppendSeedRef(buckets[0],"EURUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[0],"GBPUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[0],"USDJPY","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[0],"AUDUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[0],"USDCHF","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[1],"fx-cross","FX Cross","FX","Reference Taxonomy","Cross-currency placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[1],"EURGBP","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[1],"AUDNZD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[1],"CADJPY","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[1],"CHFJPY","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[2],"fx-regional","FX Regional and Exotic","FX","Reference Taxonomy","Regional and exotic FX placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[2],"USDMXN","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[2],"USDZAR","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[2],"EURTRY","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[3],"index-us","Index US","Index","Reference Taxonomy","US index placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[3],"US30","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[3],"US500","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[3],"NAS100","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[4],"index-europe","Index Europe","Index","Reference Taxonomy","European index placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[4],"GER40","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[4],"UK100","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[4],"EU50","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[5],"index-asia","Index Asia","Index","Reference Taxonomy","Asian index placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[5],"JPN225","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[5],"HK50","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[5],"AUS200","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[6],"metals-precious","Metals Precious","Metals","Reference Taxonomy","Precious-metals placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[6],"XAUUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[6],"XAGUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[6],"XPTUSD","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[7],"energy","Energy","Commodities","Reference Taxonomy","Energy placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[7],"BRENT","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[7],"WTI","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[7],"NATGAS","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[8],"crypto-core","Crypto Core","Crypto","Reference Taxonomy","Core crypto placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[8],"BTCUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[8],"ETHUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[8],"BNBUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[8],"SOLUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[8],"ADAUSD","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[9],"crypto-network-themes","Crypto Network Themes","Crypto","Reference Taxonomy","Crypto thematic placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[9],"XRPUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[9],"LTCUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[9],"UNIUSD","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[9],"LINKUSD","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[10],"equity-us-tech","US Equity Technology","Stocks","Reference Taxonomy","US technology equity placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[10],"AAPL","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[10],"MSFT","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[10],"NVDA","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[10],"META","Canonical reference symbol only; not a claim of broker availability.");

   ASC_BucketDefine(buckets[11],"equity-us-financial","US Equity Financial","Stocks","Reference Taxonomy","US financial equity placeholder bucket with canonical references only.");
   ASC_BucketAppendSeedRef(buckets[11],"JPM","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[11],"BAC","Canonical reference symbol only; not a claim of broker availability.");
   ASC_BucketAppendSeedRef(buckets[11],"GS","Canonical reference symbol only; not a claim of broker availability.");
  }

int ASC_GetBucketViewModels(ASC_BucketViewModel &views[],const ASC_ExplorerBucketDisplayMode display_mode)
  {
   ASC_BucketDefinition buckets[];
   ASC_BucketPlaceholderCatalog(buckets);
   int total=ArraySize(buckets);
   ArrayResize(views,total);

   for(int i=0;i<total;i++)
     {
      views[i].bucket_id=buckets[i].bucket_id;
      views[i].name=buckets[i].name;
      views[i].family=buckets[i].family;
      views[i].posture=buckets[i].posture;
      views[i].note=buckets[i].note;
      views[i].resolved_symbol_count=ArraySize(buckets[i].symbol_refs);
      views[i].display_mode=display_mode;
      ArrayResize(views[i].symbol_refs,views[i].resolved_symbol_count);
      ArrayResize(views[i].symbol_notes,views[i].resolved_symbol_count);
      for(int j=0;j<views[i].resolved_symbol_count;j++)
        {
         views[i].symbol_refs[j]=buckets[i].symbol_refs[j].symbol_ref;
         views[i].symbol_notes[j]=buckets[i].symbol_refs[j].note;
        }
     }
   return(total);
  }

int ASC_BucketDisplayLimit(const ASC_BucketViewModel &bucket)
  {
   if(bucket.display_mode==ASC_BUCKET_DISPLAY_TOP_3)
      return((bucket.resolved_symbol_count<3) ? bucket.resolved_symbol_count : 3);
   if(bucket.display_mode==ASC_BUCKET_DISPLAY_TOP_5)
      return((bucket.resolved_symbol_count<5) ? bucket.resolved_symbol_count : 5);
   return(bucket.resolved_symbol_count);
  }

string ASC_BucketDisplayModeText(const ASC_ExplorerBucketDisplayMode mode)
  {
   switch(mode)
     {
      case ASC_BUCKET_DISPLAY_TOP_5: return("Top 5");
      case ASC_BUCKET_DISPLAY_ALL:   return("All");
      default:                       return("Top 3");
     }
  }

#endif
