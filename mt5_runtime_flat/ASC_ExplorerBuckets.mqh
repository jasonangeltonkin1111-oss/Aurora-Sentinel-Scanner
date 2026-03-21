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
   string            bucket_id;
   string            bucket_name;
   string            asset_class;
   string            primary_bucket;
   string            sector;
   string            industry;
   string            theme_bucket;
   string            subtype;
   string            match_kind;
   string            review_status;
   string            note;
   ASC_MarketStatus  market_status;
   bool              open_now;
   int               symbol_state_index;
  };

struct ASC_PreparedBucketState
  {
   bool                         ready;
   string                       server_key;
   datetime                     prepared_at;
   int                          source_symbol_count;
   int                          unresolved_count;
   int                          total_resolved_symbols;
   int                          active_batch_id;
   int                          batch_generation;
   ASC_PreparedStateDiagnostics diagnostics;
   ASC_BucketViewModel          buckets[];
   ASC_BucketPreparedSymbol     symbols[];
   int                          batch_ready[];
   int                          batch_reused[];
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

string ASC_CL_MainBucketId(const ASC_SymbolClassification &classification)
  {
   string asset_class=classification.asset_class;
   if(asset_class=="FX")
      return("fx");
   if(asset_class=="INDEX")
      return("indices");
   if(asset_class=="METALS")
      return("metals");
   if(asset_class=="ENERGY")
      return("energy");
   if(asset_class=="CRYPTO")
      return("crypto");
   if(asset_class=="STOCK")
      return("stocks");
   return(ASC_CL_BucketId(classification.primary_bucket));
  }

string ASC_CL_MainBucketName(const ASC_SymbolClassification &classification)
  {
   string bucket_id=ASC_CL_MainBucketId(classification);
   if(bucket_id=="fx")
      return("FX");
   if(bucket_id=="indices")
      return("Indices");
   if(bucket_id=="metals")
      return("Metals");
   if(bucket_id=="energy")
      return("Energy");
   if(bucket_id=="crypto")
      return("Crypto");
   if(bucket_id=="stocks")
      return("Stocks");
   return(ASC_CL_BucketName(classification));
  }

string ASC_CL_MainBucketFamily(const ASC_SymbolClassification &classification)
  {
   string bucket_id=ASC_CL_MainBucketId(classification);
   if(bucket_id=="stocks")
      return("Layer 1 Main Bucket");
   if(bucket_id=="indices")
      return("Layer 1 Main Bucket");
   if(bucket_id=="fx" || bucket_id=="metals" || bucket_id=="energy" || bucket_id=="crypto")
      return("Layer 1 Main Bucket");
   return(ASC_CL_BucketFamily(classification));
  }

string ASC_CL_MainBucketNote(const ASC_SymbolClassification &classification)
  {
   string note="Compressed Layer 1 bucket from richer ASC classification truth.";
   if(classification.primary_bucket!="")
      note+=" Primary " + classification.primary_bucket + ".";
   if(classification.asset_class=="STOCK")
     {
      if(classification.theme_bucket!="")
         note+=" Region/Theme seed " + classification.theme_bucket + ".";
      if(classification.sector!="")
         note+=" Sector " + classification.sector + ".";
      return(note);
     }
   if(classification.sector!="")
      note+=" Sector " + classification.sector + ".";
   if(classification.theme_bucket!="")
      note+=" Theme " + classification.theme_bucket + ".";
   return(note);
  }

#define ASC_PREPARED_BATCH_COUNT 3
#define ASC_PREPARED_BATCH_PRIORITY_SET 1
#define ASC_PREPARED_BATCH_STOCK_MAIN 2
#define ASC_PREPARED_BATCH_STOCK_METADATA 3

int ASC_PreparedNowMs(void)
  {
   return((int)GetTickCount());
  }

void ASC_PreparedStateDiagnosticsReset(ASC_PreparedStateDiagnostics &diagnostics)
  {
   diagnostics.bucket_prep_total_ms=0;
   diagnostics.classification_loop_ms=0;
   diagnostics.bucket_sort_ms=0;
   diagnostics.prepared_symbol_reorder_ms=0;
   diagnostics.final_promotion_ms=0;
   diagnostics.last_prepared_batch_id=0;
   diagnostics.promoted_batch_count=0;
   diagnostics.pending_batch_count=ASC_PREPARED_BATCH_COUNT;
   diagnostics.warmup_assessed_count=0;
   diagnostics.warmup_total_count=0;
   diagnostics.readiness_percent=0;
   diagnostics.bounded_work_pressure_summary="Not sampled.";
  }

string ASC_PreparedBatchName(const int batch_id)
  {
   if(batch_id==ASC_PREPARED_BATCH_PRIORITY_SET)
      return("Priority Set Main");
   if(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN)
      return("Stock Main and Regions");
   if(batch_id==ASC_PREPARED_BATCH_STOCK_METADATA)
      return("Stock Taxonomy Metadata");
   return("Unknown Batch");
  }

bool ASC_IsBatch1BucketId(const string bucket_id)
  {
   string value=ASC_ToLower(ASC_Trim(bucket_id));
   return(value=="fx" || value=="indices" || value=="metals" || value=="energy" || value=="crypto");
  }

bool ASC_PreparedClassificationInBatch(const ASC_SymbolClassification &classification,const int batch_id)
  {
   if(batch_id==ASC_PREPARED_BATCH_PRIORITY_SET)
      return(classification.asset_class=="FX"
             || classification.asset_class=="INDEX"
             || classification.asset_class=="METALS"
             || classification.asset_class=="ENERGY"
             || classification.asset_class=="CRYPTO");
   if(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN || batch_id==ASC_PREPARED_BATCH_STOCK_METADATA)
      return(classification.asset_class=="STOCK");
   return(false);
  }

bool ASC_PreparedSymbolInBatch(const ASC_BucketPreparedSymbol &symbol,const int batch_id)
  {
   if(batch_id==ASC_PREPARED_BATCH_PRIORITY_SET)
      return(ASC_IsBatch1BucketId(symbol.bucket_id));
   if(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN || batch_id==ASC_PREPARED_BATCH_STOCK_METADATA)
      return(ASC_ToLower(ASC_Trim(symbol.asset_class))=="stock" || ASC_ToLower(ASC_Trim(symbol.bucket_id))=="stocks");
   return(false);
  }

void ASC_PreparedBucketStateReset(ASC_PreparedBucketState &prepared)
  {
   prepared.ready=false;
   prepared.server_key="";
   prepared.prepared_at=0;
   prepared.source_symbol_count=0;
   prepared.unresolved_count=0;
   prepared.total_resolved_symbols=0;
   prepared.active_batch_id=0;
   prepared.batch_generation=0;
   ASC_PreparedStateDiagnosticsReset(prepared.diagnostics);
   ArrayResize(prepared.buckets,0);
   ArrayResize(prepared.symbols,0);
   ArrayResize(prepared.batch_ready,ASC_PREPARED_BATCH_COUNT);
   ArrayResize(prepared.batch_reused,ASC_PREPARED_BATCH_COUNT);
   for(int i=0;i<ASC_PREPARED_BATCH_COUNT;i++)
     {
      prepared.batch_ready[i]=0;
      prepared.batch_reused[i]=0;
     }
  }

void ASC_CopyPreparedBucketState(const ASC_PreparedBucketState &source,ASC_PreparedBucketState &target)
  {
   target=source;
  }

int ASC_PreparedPromotedBatchCount(const ASC_PreparedBucketState &prepared)
  {
   int ready_count=0;
   for(int i=0;i<ArraySize(prepared.batch_ready);i++)
     {
      if(prepared.batch_ready[i]!=0)
         ready_count++;
     }
   return(ready_count);
  }

void ASC_PreparedRefreshDiagnostics(ASC_PreparedBucketState &prepared,const int warmup_assessed,const int warmup_total,const int readiness_percent,const int due_now,const int budget)
  {
   prepared.diagnostics.last_prepared_batch_id=prepared.active_batch_id;
   prepared.diagnostics.promoted_batch_count=ASC_PreparedPromotedBatchCount(prepared);
   prepared.diagnostics.pending_batch_count=ASC_PREPARED_BATCH_COUNT-prepared.diagnostics.promoted_batch_count;
   prepared.diagnostics.warmup_assessed_count=warmup_assessed;
   prepared.diagnostics.warmup_total_count=warmup_total;
   prepared.diagnostics.readiness_percent=ASC_PercentClamp(readiness_percent);
   prepared.diagnostics.bounded_work_pressure_summary="due=" + IntegerToString(due_now)
      + " | budget=" + IntegerToString(budget)
      + " | backlog=" + IntegerToString((due_now>budget) ? (due_now-budget) : 0);
  }

void ASC_PreparedRebuildBucketsFromSymbols(ASC_PreparedBucketState &prepared)
  {
   ArrayResize(prepared.buckets,0);
   for(int i=0;i<ArraySize(prepared.symbols);i++)
     {
      ASC_BucketPreparedSymbol symbol=prepared.symbols[i];
      int bucket_index=-1;
      for(int b=0;b<ArraySize(prepared.buckets);b++)
        {
         if(prepared.buckets[b].bucket_id==symbol.bucket_id)
           {
            bucket_index=b;
            break;
           }
        }
      if(bucket_index<0)
        {
         bucket_index=ArraySize(prepared.buckets);
         ArrayResize(prepared.buckets,bucket_index+1);
         prepared.buckets[bucket_index].bucket_id=symbol.bucket_id;
         prepared.buckets[bucket_index].name=symbol.bucket_name;
         prepared.buckets[bucket_index].family="Layer 1 Main Bucket";
         prepared.buckets[bucket_index].posture="Compressed Layer 1";
         prepared.buckets[bucket_index].note=(symbol.asset_class=="STOCK"
                                              ? "Compressed Layer 1 stock bucket. Regional grouping is promoted early; finer taxonomy remains metadata-driven."
                                              : "Compressed Layer 1 bucket from richer ASC classification truth.");
         prepared.buckets[bucket_index].resolved_symbol_count=0;
         prepared.buckets[bucket_index].open_symbol_count=0;
         prepared.buckets[bucket_index].unresolved_symbol_count=0;
         prepared.buckets[bucket_index].prepared_symbol_offset=-1;
         ArrayResize(prepared.buckets[bucket_index].symbol_refs,0);
         ArrayResize(prepared.buckets[bucket_index].symbol_notes,0);
        }
      int slot=ArraySize(prepared.buckets[bucket_index].symbol_refs);
      ArrayResize(prepared.buckets[bucket_index].symbol_refs,slot+1);
      ArrayResize(prepared.buckets[bucket_index].symbol_notes,slot+1);
      prepared.buckets[bucket_index].symbol_refs[slot]=symbol.live_symbol;
      prepared.buckets[bucket_index].symbol_notes[slot]=symbol.note;
      prepared.buckets[bucket_index].resolved_symbol_count++;
      if(symbol.open_now)
         prepared.buckets[bucket_index].open_symbol_count++;
     }
  }

void ASC_PreparedPhaseBucketSort(ASC_PreparedBucketState &prepared)
  {
   for(int i=0;i<ArraySize(prepared.buckets);i++)
      ASC_BucketSortSymbols(prepared.buckets[i].symbol_refs,prepared.buckets[i].symbol_notes);
   ASC_BucketSortViews(prepared.buckets);
  }

void ASC_PreparedPhaseSymbolReorder(ASC_PreparedBucketState &prepared)
  {
   ASC_BucketPreparedSymbol ordered[];
   ArrayResize(ordered,0);
   int offset=0;
   for(int i=0;i<ArraySize(prepared.buckets);i++)
     {
      prepared.buckets[i].prepared_symbol_offset=offset;
      for(int j=0;j<ArraySize(prepared.buckets[i].symbol_refs);j++)
        {
         string symbol_ref=prepared.buckets[i].symbol_refs[j];
         for(int k=0;k<ArraySize(prepared.symbols);k++)
           {
            if(prepared.symbols[k].live_symbol!=symbol_ref)
               continue;
            int slot=ArraySize(ordered);
            ArrayResize(ordered,slot+1);
            ordered[slot]=prepared.symbols[k];
            break;
           }
        }
      offset+=prepared.buckets[i].resolved_symbol_count;
     }
   prepared.symbols=ordered;
   prepared.total_resolved_symbols=ArraySize(prepared.symbols);
  }

void ASC_PreparedRemoveBatchSymbols(ASC_PreparedBucketState &prepared,const int batch_id)
  {
   ASC_BucketPreparedSymbol kept[];
   ArrayResize(kept,0);
   for(int i=0;i<ArraySize(prepared.symbols);i++)
     {
      if(ASC_PreparedSymbolInBatch(prepared.symbols[i],batch_id))
         continue;
      int slot=ArraySize(kept);
      ArrayResize(kept,slot+1);
      kept[slot]=prepared.symbols[i];
     }
   prepared.symbols=kept;
   prepared.total_resolved_symbols=ArraySize(prepared.symbols);
  }

void ASC_PreparedAppendSymbol(ASC_PreparedBucketState &prepared,const ASC_BucketPreparedSymbol &symbol)
  {
   int slot=ArraySize(prepared.symbols);
   ArrayResize(prepared.symbols,slot+1);
   prepared.symbols[slot]=symbol;
   prepared.total_resolved_symbols=ArraySize(prepared.symbols);
  }

void ASC_PreparedPhaseClassificationPass(const string server_key,ASC_SymbolState &states[],const int count,const int batch_id,ASC_PreparedBucketState &working)
  {
   if(batch_id==ASC_PREPARED_BATCH_STOCK_METADATA)
     {
      for(int i=0;i<ArraySize(working.symbols);i++)
        {
         if(!ASC_PreparedSymbolInBatch(working.symbols[i],batch_id))
            continue;
         ASC_SymbolClassification classification;
         if(!ASC_CL_ClassifySymbol(server_key,working.symbols[i].live_symbol,classification))
            continue;
         working.symbols[i].canonical_symbol=classification.canonical_symbol;
         working.symbols[i].primary_bucket=classification.primary_bucket;
         working.symbols[i].sector=classification.sector;
         working.symbols[i].industry=classification.industry;
         working.symbols[i].theme_bucket=classification.theme_bucket;
         working.symbols[i].subtype=classification.subtype;
         working.symbols[i].match_kind=classification.match_kind;
         working.symbols[i].review_status=classification.review_status;
         working.symbols[i].note="Canonical " + classification.canonical_symbol
                              + " | Primary " + classification.primary_bucket
                              + " | Theme " + (classification.theme_bucket=="" ? "N/A" : classification.theme_bucket)
                              + " | Sector " + (classification.sector=="" ? "N/A" : classification.sector)
                              + " | Industry " + (classification.industry=="" ? "N/A" : classification.industry)
                              + " | Review " + classification.review_status;
        }
      return;
     }

   ASC_PreparedRemoveBatchSymbols(working,batch_id);
   for(int i=0;i<count;i++)
     {
      ASC_SymbolClassification classification;
      if(!ASC_CL_ClassifySymbol(server_key,states[i].symbol,classification))
        {
         if(batch_id==ASC_PREPARED_BATCH_PRIORITY_SET || batch_id==ASC_PREPARED_BATCH_STOCK_MAIN)
            working.unresolved_count++;
         continue;
        }
      if(!ASC_PreparedClassificationInBatch(classification,batch_id))
         continue;

      ASC_BucketPreparedSymbol prepared_symbol;
      prepared_symbol.live_symbol=states[i].symbol;
      prepared_symbol.canonical_symbol=classification.canonical_symbol;
      prepared_symbol.bucket_id=ASC_CL_MainBucketId(classification);
      prepared_symbol.bucket_name=ASC_CL_MainBucketName(classification);
      prepared_symbol.asset_class=classification.asset_class;
      prepared_symbol.primary_bucket=classification.primary_bucket;
      prepared_symbol.sector=(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN ? "" : classification.sector);
      prepared_symbol.industry=(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN ? "" : classification.industry);
      prepared_symbol.theme_bucket=classification.theme_bucket;
      prepared_symbol.subtype=(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN ? "" : classification.subtype);
      prepared_symbol.match_kind=classification.match_kind;
      prepared_symbol.review_status=classification.review_status;
      prepared_symbol.note="Canonical " + classification.canonical_symbol
                         + " | Primary " + classification.primary_bucket
                         + " | Theme " + (classification.theme_bucket=="" ? "N/A" : classification.theme_bucket)
                         + " | Review " + classification.review_status;
      prepared_symbol.market_status=states[i].market_status;
      prepared_symbol.open_now=(states[i].market_status==ASC_MARKET_OPEN);
      prepared_symbol.symbol_state_index=i;
      ASC_PreparedAppendSymbol(working,prepared_symbol);
     }
  }

void ASC_PrepareBucketState(const string server_key,ASC_SymbolState &states[],const int count,const int batch_id,const int warmup_assessed,const int warmup_total,const int readiness_percent,const int due_now,const int budget,const ASC_PreparedBucketState &last_good,ASC_PreparedBucketState &working)
  {
   int prep_started=ASC_PreparedNowMs();
   if(!last_good.ready || last_good.server_key!=server_key)
      ASC_PreparedBucketStateReset(working);
   else
      ASC_CopyPreparedBucketState(last_good,working);

   working.server_key=server_key;
   working.prepared_at=TimeCurrent();
   working.source_symbol_count=count;
   working.active_batch_id=batch_id;
   working.unresolved_count=0;
   if(ArraySize(working.batch_ready)!=ASC_PREPARED_BATCH_COUNT)
     {
      ArrayResize(working.batch_ready,ASC_PREPARED_BATCH_COUNT);
      ArrayResize(working.batch_reused,ASC_PREPARED_BATCH_COUNT);
      for(int i=0;i<ASC_PREPARED_BATCH_COUNT;i++)
        {
         working.batch_ready[i]=0;
         working.batch_reused[i]=0;
        }
     }
   for(int i=0;i<ASC_PREPARED_BATCH_COUNT;i++)
      working.batch_reused[i]=(i==(batch_id-1) ? 0 : 1);

   int phase_started=ASC_PreparedNowMs();
   ASC_PreparedPhaseClassificationPass(server_key,states,count,batch_id,working);
   working.diagnostics.classification_loop_ms=ASC_PreparedNowMs()-phase_started;

   phase_started=ASC_PreparedNowMs();
   ASC_PreparedRebuildBucketsFromSymbols(working);
   ASC_PreparedPhaseBucketSort(working);
   working.diagnostics.bucket_sort_ms=ASC_PreparedNowMs()-phase_started;

   phase_started=ASC_PreparedNowMs();
   ASC_PreparedPhaseSymbolReorder(working);
   working.diagnostics.prepared_symbol_reorder_ms=ASC_PreparedNowMs()-phase_started;

   phase_started=ASC_PreparedNowMs();
   working.batch_ready[batch_id-1]=1;
   working.batch_generation++;
   working.ready=(ASC_PreparedPromotedBatchCount(working)>0);
   ASC_PreparedRefreshDiagnostics(working,warmup_assessed,warmup_total,readiness_percent,due_now,budget);
   working.diagnostics.bucket_prep_total_ms=ASC_PreparedNowMs()-prep_started;
   working.prepared_at=TimeCurrent();
   working.diagnostics.last_prepared_batch_id=batch_id;
   working.diagnostics.promoted_batch_count=ASC_PreparedPromotedBatchCount(working);
   working.diagnostics.pending_batch_count=ASC_PREPARED_BATCH_COUNT-working.diagnostics.promoted_batch_count;
   int promotion_ms=ASC_PreparedNowMs()-phase_started;
   if(promotion_ms<0)
      promotion_ms=0;
   working.diagnostics.final_promotion_ms=promotion_ms;
   working.diagnostics.bucket_prep_total_ms=ASC_PreparedNowMs()-prep_started;
  }

void ASC_PromotePreparedBucketState(const ASC_PreparedBucketState &completed,ASC_PreparedBucketState &last_good,ASC_PreparedBucketState &promoted)
  {
   last_good=completed;
   promoted=completed;
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
