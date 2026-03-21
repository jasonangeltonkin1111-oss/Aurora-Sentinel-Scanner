#ifndef __ASC_EXPLORER_BUCKETS_MQH__
#define __ASC_EXPLORER_BUCKETS_MQH__

#include "ASC_Common.mqh"
#include "ASC_Classification.mqh"

struct ASC_BucketViewModel
  {
   string bucket_id;
   string name;
   string family;
   string posture;
   string note;
   int resolved_symbol_count;
   int open_symbol_count;
   int unresolved_symbol_count;
   string symbol_refs[];
   string symbol_notes[];
   ASC_ExplorerBucketDisplayMode display_mode;
  };

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

void ASC_BucketSortSymbols(string &symbols[],string &notes[])
  {
   int total=ArraySize(symbols);
   for(int i=1;i<total;i++)
     {
      string key_symbol=symbols[i];
      string key_note=notes[i];
      int j=i-1;
      while(j>=0 && StringCompare(symbols[j],key_symbol,true)>0)
        {
         symbols[j+1]=symbols[j];
         notes[j+1]=notes[j];
         j--;
        }
      symbols[j+1]=key_symbol;
      notes[j+1]=key_note;
     }
  }

void ASC_BucketSortViews(ASC_BucketViewModel &views[])
  {
   int total=ArraySize(views);
   for(int i=1;i<total;i++)
     {
      ASC_BucketViewModel key=views[i];
      int j=i-1;
      while(j>=0)
        {
         string left=views[j].family + "|" + views[j].name;
         string right=key.family + "|" + key.name;
         if(StringCompare(left,right,true)<=0)
            break;
         views[j+1]=views[j];
         j--;
        }
      views[j+1]=key;
     }
  }

int ASC_FindOrAddBucket(ASC_BucketViewModel &views[],const ASC_SymbolClassification &classification,const ASC_ExplorerBucketDisplayMode display_mode)
  {
   string bucket_id=ASC_CL_BucketId(classification.primary_bucket);
   for(int i=0;i<ArraySize(views);i++)
     {
      if(views[i].bucket_id==bucket_id)
         return(i);
     }
   int slot=ArraySize(views);
   ArrayResize(views,slot+1);
   views[slot].bucket_id=bucket_id;
   views[slot].name=ASC_CL_BucketName(classification);
   views[slot].family=ASC_CL_BucketFamily(classification);
   views[slot].posture="Classification Driven";
   views[slot].note=ASC_CL_BucketNote(classification);
   views[slot].resolved_symbol_count=0;
   views[slot].open_symbol_count=0;
   views[slot].unresolved_symbol_count=0;
   views[slot].display_mode=display_mode;
   ArrayResize(views[slot].symbol_refs,0);
   ArrayResize(views[slot].symbol_notes,0);
   return(slot);
  }

int ASC_GetBucketViewModels(const string server_key,ASC_SymbolState &states[],const int count,ASC_BucketViewModel &views[],const ASC_ExplorerBucketDisplayMode display_mode,int &unresolved_count)
  {
   unresolved_count=0;
   ArrayResize(views,0);
   for(int i=0;i<count;i++)
     {
      ASC_SymbolClassification classification;
      if(!ASC_CL_ClassifySymbol(server_key,states[i].symbol,classification))
        {
         unresolved_count++;
         continue;
        }
      int bucket_index=ASC_FindOrAddBucket(views,classification,display_mode);
      int slot=ArraySize(views[bucket_index].symbol_refs);
      ArrayResize(views[bucket_index].symbol_refs,slot+1);
      ArrayResize(views[bucket_index].symbol_notes,slot+1);
      views[bucket_index].symbol_refs[slot]=states[i].symbol;
      views[bucket_index].symbol_notes[slot]="Canonical " + classification.canonical_symbol
                                       + " | Match " + classification.match_kind
                                       + " | Review " + classification.review_status;
      views[bucket_index].resolved_symbol_count++;
      if(states[i].market_status==ASC_MARKET_OPEN)
         views[bucket_index].open_symbol_count++;
     }

   for(int i=0;i<ArraySize(views);i++)
      ASC_BucketSortSymbols(views[i].symbol_refs,views[i].symbol_notes);
   ASC_BucketSortViews(views);
   return(ArraySize(views));
  }

#endif
