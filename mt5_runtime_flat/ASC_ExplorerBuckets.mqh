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

   ASC_BucketDefine(buckets[0],"fx-major","FX Major","FX","Canonical Reference Set","Canonical major-FX references aligned to symbols that recur across the multi-server sample. Live membership still requires safe broker-symbol resolution.");
   ASC_BucketAppendSeedRef(buckets[0],"EURUSD","Canonical major FX reference; sample evidence shows plain broker symbols across multiple servers.");
   ASC_BucketAppendSeedRef(buckets[0],"GBPUSD","Canonical major FX reference; sample evidence shows plain broker symbols across multiple servers.");
   ASC_BucketAppendSeedRef(buckets[0],"USDJPY","Canonical major FX reference; sample evidence shows plain broker symbols across multiple servers.");
   ASC_BucketAppendSeedRef(buckets[0],"USDCHF","Canonical major FX reference; sample evidence shows plain broker symbols across multiple servers.");
   ASC_BucketAppendSeedRef(buckets[0],"USDCAD","Canonical major FX reference; sample evidence shows plain broker symbols across multiple servers.");
   ASC_BucketAppendSeedRef(buckets[0],"AUDUSD","Canonical major FX reference; sample evidence shows plain broker symbols across multiple servers.");
   ASC_BucketAppendSeedRef(buckets[0],"NZDUSD","Canonical major FX reference; sample evidence shows plain broker symbols across multiple servers.");

   ASC_BucketDefine(buckets[1],"fx-cross","FX Cross","FX","Canonical Reference Set","Cross-currency FX references kept broker-neutral while remaining close to the observed sample universe.");
   ASC_BucketAppendSeedRef(buckets[1],"EURGBP","Canonical cross FX reference only.");
   ASC_BucketAppendSeedRef(buckets[1],"EURJPY","Canonical cross FX reference only.");
   ASC_BucketAppendSeedRef(buckets[1],"GBPJPY","Canonical cross FX reference only.");
   ASC_BucketAppendSeedRef(buckets[1],"AUDJPY","Canonical cross FX reference only.");
   ASC_BucketAppendSeedRef(buckets[1],"AUDNZD","Canonical cross FX reference only.");
   ASC_BucketAppendSeedRef(buckets[1],"CADJPY","Canonical cross FX reference only.");
   ASC_BucketAppendSeedRef(buckets[1],"CHFJPY","Canonical cross FX reference only.");

   ASC_BucketDefine(buckets[2],"fx-regional","FX Regional and Exotic","FX","Canonical Reference Set","Regional and exotic FX references taken from instruments already evidenced in the multi-server sample.");
   ASC_BucketAppendSeedRef(buckets[2],"USDMXN","Canonical regional FX reference only.");
   ASC_BucketAppendSeedRef(buckets[2],"USDZAR","Canonical regional FX reference only.");
   ASC_BucketAppendSeedRef(buckets[2],"USDCNH","Canonical regional FX reference only.");
   ASC_BucketAppendSeedRef(buckets[2],"USDHKD","Canonical regional FX reference only.");
   ASC_BucketAppendSeedRef(buckets[2],"USDNOK","Canonical regional FX reference only.");
   ASC_BucketAppendSeedRef(buckets[2],"USDSEK","Canonical regional FX reference only.");

   ASC_BucketDefine(buckets[3],"index-us","Index US","Index","Canonical Reference Set","US index references normalized away from broker suffix variants such as .m, .c, and cash-1 when safely evidenced.");
   ASC_BucketAppendSeedRef(buckets[3],"US30","Canonical US equity-index reference only.");
   ASC_BucketAppendSeedRef(buckets[3],"US500","Canonical US equity-index reference only.");
   ASC_BucketAppendSeedRef(buckets[3],"US100","Canonical US equity-index reference only.");
   ASC_BucketAppendSeedRef(buckets[3],"US2000","Canonical US small-cap index reference only.");

   ASC_BucketDefine(buckets[4],"index-europe","Index Europe","Index","Canonical Reference Set","European index references trimmed to common broker-neutral canon while allowing safe resolution from evidenced cash and suffix variants.");
   ASC_BucketAppendSeedRef(buckets[4],"GER40","Canonical European index reference only.");
   ASC_BucketAppendSeedRef(buckets[4],"UK100","Canonical European index reference only.");
   ASC_BucketAppendSeedRef(buckets[4],"EU50","Canonical European index reference only.");
   ASC_BucketAppendSeedRef(buckets[4],"FRA40","Canonical European index reference only.");
   ASC_BucketAppendSeedRef(buckets[4],"SPA35","Canonical European index reference only.");

   ASC_BucketDefine(buckets[5],"index-asia","Index Asia","Index","Canonical Reference Set","Asia-Pacific index references limited to instruments already seen in the sample universe.");
   ASC_BucketAppendSeedRef(buckets[5],"JPN225","Canonical Asia-Pacific index reference only.");
   ASC_BucketAppendSeedRef(buckets[5],"HK50","Canonical Asia-Pacific index reference only.");
   ASC_BucketAppendSeedRef(buckets[5],"AUS200","Canonical Asia-Pacific index reference only.");

   ASC_BucketDefine(buckets[6],"metals-precious","Metals Precious","Metals","Canonical Reference Set","Precious-metals references kept canonical while preserving unresolved states for non-matching broker variants.");
   ASC_BucketAppendSeedRef(buckets[6],"XAUUSD","Canonical precious-metals reference only.");
   ASC_BucketAppendSeedRef(buckets[6],"XAGUSD","Canonical precious-metals reference only.");
   ASC_BucketAppendSeedRef(buckets[6],"XPTUSD","Canonical precious-metals reference only.");
   ASC_BucketAppendSeedRef(buckets[6],"XPDUSD","Canonical precious-metals reference only.");

   ASC_BucketDefine(buckets[7],"energy","Energy","Commodities","Canonical Reference Set","Energy references support safe matching from evidenced .o and cash broker variants without widening into speculative aliases.");
   ASC_BucketAppendSeedRef(buckets[7],"BRENT","Canonical Brent reference only.");
   ASC_BucketAppendSeedRef(buckets[7],"WTI","Canonical WTI reference only.");
   ASC_BucketAppendSeedRef(buckets[7],"NATGAS","Canonical natural-gas reference only.");

   ASC_BucketDefine(buckets[8],"crypto-core","Crypto Core","Crypto","Canonical Reference Set","Core crypto references aligned to repeated broker symbols and safe .nx/.m normalization patterns evidenced in the sample.");
   ASC_BucketAppendSeedRef(buckets[8],"BTCUSD","Canonical crypto reference only.");
   ASC_BucketAppendSeedRef(buckets[8],"ETHUSD","Canonical crypto reference only.");
   ASC_BucketAppendSeedRef(buckets[8],"BNBUSD","Canonical crypto reference only.");
   ASC_BucketAppendSeedRef(buckets[8],"SOLUSD","Canonical crypto reference only.");
   ASC_BucketAppendSeedRef(buckets[8],"ADAUSD","Canonical crypto reference only.");

   ASC_BucketDefine(buckets[9],"crypto-network-themes","Crypto Network Themes","Crypto","Canonical Reference Set","Secondary crypto references chosen from the actual sample universe so families stay even without pretending live identity is active.");
   ASC_BucketAppendSeedRef(buckets[9],"XRPUSD","Canonical crypto reference only.");
   ASC_BucketAppendSeedRef(buckets[9],"LTCUSD","Canonical crypto reference only.");
   ASC_BucketAppendSeedRef(buckets[9],"UNIUSD","Canonical crypto reference only.");
   ASC_BucketAppendSeedRef(buckets[9],"LINKUSD","Canonical crypto reference only.");
   ASC_BucketAppendSeedRef(buckets[9],"ALGOUSD","Canonical crypto reference only.");

   ASC_BucketDefine(buckets[10],"equity-us-tech","US Equity Technology","Stocks","Canonical Reference Set","US technology equity references stay canonical while allowing safe resolution from evidenced .OQ quote-suffix variants.");
   ASC_BucketAppendSeedRef(buckets[10],"AAPL","Canonical US equity reference only.");
   ASC_BucketAppendSeedRef(buckets[10],"MSFT","Canonical US equity reference only.");
   ASC_BucketAppendSeedRef(buckets[10],"NVDA","Canonical US equity reference only.");
   ASC_BucketAppendSeedRef(buckets[10],"META","Canonical US equity reference only.");
   ASC_BucketAppendSeedRef(buckets[10],"GOOG","Canonical US equity reference only.");
   ASC_BucketAppendSeedRef(buckets[10],"AMZN","Canonical US equity reference only.");
   ASC_BucketAppendSeedRef(buckets[10],"TSLA","Canonical US equity reference only.");

   ASC_BucketDefine(buckets[11],"equity-us-financial","US Equity Financial","Stocks","Canonical Reference Set","US financial references expanded so the family stays comparable to other primary families without implying live classification activation.");
   ASC_BucketAppendSeedRef(buckets[11],"JPM","Canonical US financial equity reference only.");
   ASC_BucketAppendSeedRef(buckets[11],"BAC","Canonical US financial equity reference only.");
   ASC_BucketAppendSeedRef(buckets[11],"GS","Canonical US financial equity reference only.");
   ASC_BucketAppendSeedRef(buckets[11],"MS","Canonical US financial equity reference only.");
   ASC_BucketAppendSeedRef(buckets[11],"BK","Canonical US financial equity reference only.");
   ASC_BucketAppendSeedRef(buckets[11],"USB","Canonical US financial equity reference only.");
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
