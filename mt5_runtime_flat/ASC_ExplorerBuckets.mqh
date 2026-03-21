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
   int prepared_symbol_offset;
   string symbol_refs[];
   string symbol_notes[];
  };

struct ASC_BucketPreparedSymbol
  {
   string            live_symbol;
   string            canonical_symbol;
   string            note;
   ASC_MarketStatus  market_status;
   bool              open_now;
   int               symbol_state_index;
  };

struct ASC_PreparedBucketState
  {
   bool                     ready;
   string                   server_key;
   datetime                 prepared_at;
   int                      source_symbol_count;
   int                      unresolved_count;
   int                      total_resolved_symbols;
   ASC_BucketViewModel      buckets[];
   ASC_BucketPreparedSymbol symbols[];
  };

int ASC_BucketDisplayLimit(const ASC_BucketViewModel &bucket,const ASC_ExplorerBucketDisplayMode display_mode)
  {
   if(display_mode==ASC_BUCKET_DISPLAY_TOP_3)
      return((bucket.resolved_symbol_count<3) ? bucket.resolved_symbol_count : 3);
   if(display_mode==ASC_BUCKET_DISPLAY_TOP_5)
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

void ASC_PreparedBucketStateReset(ASC_PreparedBucketState &prepared)
  {
   prepared.ready=false;
   prepared.server_key="";
   prepared.prepared_at=0;
   prepared.source_symbol_count=0;
   prepared.unresolved_count=0;
   prepared.total_resolved_symbols=0;
   ArrayResize(prepared.buckets,0);
   ArrayResize(prepared.symbols,0);
  }

int ASC_FindOrAddBucket(ASC_BucketViewModel &views[],const ASC_SymbolClassification &classification)
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
   views[slot].prepared_symbol_offset=-1;
   ArrayResize(views[slot].symbol_refs,0);
   ArrayResize(views[slot].symbol_notes,0);
   return(slot);
  }

void ASC_PrepareBucketState(const string server_key,ASC_SymbolState &states[],const int count,ASC_PreparedBucketState &prepared)
  {
   ASC_PreparedBucketStateReset(prepared);
   prepared.server_key=server_key;
   prepared.prepared_at=TimeCurrent();
   prepared.source_symbol_count=count;

   for(int i=0;i<count;i++)
     {
      ASC_SymbolClassification classification;
      if(!ASC_CL_ClassifySymbol(server_key,states[i].symbol,classification))
        {
         prepared.unresolved_count++;
         continue;
        }

      int bucket_index=ASC_FindOrAddBucket(prepared.buckets,classification);
      int bucket_slot=ArraySize(prepared.buckets[bucket_index].symbol_refs);
      ArrayResize(prepared.buckets[bucket_index].symbol_refs,bucket_slot+1);
      ArrayResize(prepared.buckets[bucket_index].symbol_notes,bucket_slot+1);
      prepared.buckets[bucket_index].symbol_refs[bucket_slot]=states[i].symbol;
      prepared.buckets[bucket_index].symbol_notes[bucket_slot]="Canonical " + classification.canonical_symbol
                                                      + " | Match " + classification.match_kind
                                                      + " | Review " + classification.review_status;
      prepared.buckets[bucket_index].resolved_symbol_count++;
      if(states[i].market_status==ASC_MARKET_OPEN)
         prepared.buckets[bucket_index].open_symbol_count++;

      int prepared_slot=ArraySize(prepared.symbols);
      ArrayResize(prepared.symbols,prepared_slot+1);
      prepared.symbols[prepared_slot].live_symbol=states[i].symbol;
      prepared.symbols[prepared_slot].canonical_symbol=classification.canonical_symbol;
      prepared.symbols[prepared_slot].note=prepared.buckets[bucket_index].symbol_notes[bucket_slot];
      prepared.symbols[prepared_slot].market_status=states[i].market_status;
      prepared.symbols[prepared_slot].open_now=(states[i].market_status==ASC_MARKET_OPEN);
      prepared.symbols[prepared_slot].symbol_state_index=i;
     }

   prepared.total_resolved_symbols=ArraySize(prepared.symbols);
   for(int i=0;i<ArraySize(prepared.buckets);i++)
      ASC_BucketSortSymbols(prepared.buckets[i].symbol_refs,prepared.buckets[i].symbol_notes);
   ASC_BucketSortViews(prepared.buckets);

   int offset=0;
   for(int i=0;i<ArraySize(prepared.buckets);i++)
     {
      prepared.buckets[i].prepared_symbol_offset=offset;
      for(int j=0;j<ArraySize(prepared.buckets[i].symbol_refs);j++)
        {
         string symbol_ref=prepared.buckets[i].symbol_refs[j];
         for(int k=offset;k<ArraySize(prepared.symbols);k++)
           {
            if(prepared.symbols[k].live_symbol==symbol_ref)
              {
               if(k!=offset+j)
                 {
                  ASC_BucketPreparedSymbol temp=prepared.symbols[offset+j];
                  prepared.symbols[offset+j]=prepared.symbols[k];
                  prepared.symbols[k]=temp;
                 }
               break;
              }
           }
        }
      offset+=prepared.buckets[i].resolved_symbol_count;
     }

   prepared.ready=true;
  }

int ASC_PreparedVisibleBucketCount(const ASC_BucketViewModel &bucket,const ASC_ExplorerMarketFilter filter)
  {
   if(filter==ASC_EXPLORER_FILTER_ALL_SYMBOLS)
      return(bucket.resolved_symbol_count);
   return(bucket.open_symbol_count);
  }

bool ASC_PreparedBucketVisible(const ASC_BucketViewModel &bucket,const ASC_ExplorerMarketFilter filter)
  {
   if(filter==ASC_EXPLORER_FILTER_ALL_SYMBOLS)
      return(bucket.resolved_symbol_count>0);
   return(bucket.open_symbol_count>0);
  }

int ASC_PreparedFilteredBuckets(const ASC_PreparedBucketState &prepared,const ASC_ExplorerMarketFilter filter,ASC_BucketViewModel &filtered[],int &source_indices[])
  {
   ArrayResize(filtered,0);
   ArrayResize(source_indices,0);
   for(int i=0;i<ArraySize(prepared.buckets);i++)
     {
      if(!ASC_PreparedBucketVisible(prepared.buckets[i],filter))
         continue;
      int slot=ArraySize(filtered);
      ArrayResize(filtered,slot+1);
      ArrayResize(source_indices,slot+1);
      filtered[slot]=prepared.buckets[i];
      source_indices[slot]=i;
     }
   return(ArraySize(filtered));
  }

int ASC_PreparedBucketSymbols(const ASC_PreparedBucketState &prepared,const ASC_BucketViewModel &bucket,ASC_BucketPreparedSymbol &resolved[])
  {
   ArrayResize(resolved,0);
   if(!prepared.ready || bucket.prepared_symbol_offset<0 || bucket.resolved_symbol_count<=0)
      return(0);
   ArrayResize(resolved,bucket.resolved_symbol_count);
   for(int i=0;i<bucket.resolved_symbol_count;i++)
      resolved[i]=prepared.symbols[bucket.prepared_symbol_offset+i];
   return(ArraySize(resolved));
  }

#endif
