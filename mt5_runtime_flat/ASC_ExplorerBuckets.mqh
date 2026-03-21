#ifndef __ASC_EXPLORER_BUCKETS_MQH__
#define __ASC_EXPLORER_BUCKETS_MQH__

#include "ASC_Common.mqh"
#include "ASC_Classification.mqh"

enum ASC_PreparedBucketProgressState
  {
   ASC_PREPARED_BUCKET_NOT_STARTED=0,
   ASC_PREPARED_BUCKET_PREPARING=1,
   ASC_PREPARED_BUCKET_READY=2,
   ASC_PREPARED_BUCKET_BACKGROUND_ENRICH_PENDING=3
  };

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
   int source_symbol_count;
   int open_resolved_percent_tenths;
   int unresolved_source_percent_tenths;
   int share_total_resolved_percent_tenths;
   int prepared_symbol_offset;
   ASC_PreparedBucketProgressState progress_state;
   string progress_label;
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
   string            secondary_group_id;
   string            secondary_group_name;
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
   int                          working_batch_id;
   int                          last_good_batch_id;
   int                          batch_generation;
   ASC_PreparedStateDiagnostics diagnostics;
   ASC_BucketViewModel          buckets[];
   ASC_BucketPreparedSymbol     symbols[];
   int                          batch_ready[];
   int                          batch_pending[];
   int                          batch_reused[];
   int                          batch_progress_states[];
   int                          bucket_progress_states[];
  };

#define ASC_PREPARED_BATCH_COUNT 3
#define ASC_PREPARED_BATCH_PRIORITY_SET 1
#define ASC_PREPARED_BATCH_STOCK_MAIN 2
#define ASC_PREPARED_BATCH_STOCK_METADATA 3


string ASC_PreparedBucketProgressStateText(const ASC_PreparedBucketProgressState state)
  {
   switch(state)
     {
      case ASC_PREPARED_BUCKET_PREPARING: return("Preparing");
      case ASC_PREPARED_BUCKET_READY: return("Ready");
      case ASC_PREPARED_BUCKET_BACKGROUND_ENRICH_PENDING: return("Background enrich pending");
      default: return("Not started");
     }
  }

int ASC_Layer1MainBucketSlot(const string bucket_id)
  {
   string value=ASC_ToLower(ASC_Trim(bucket_id));
   if(value=="fx")
      return(0);
   if(value=="indices")
      return(1);
   if(value=="metals")
      return(2);
   if(value=="energy")
      return(3);
   if(value=="crypto")
      return(4);
   if(value=="stocks")
      return(5);
   return(-1);
  }

string ASC_Layer1MainBucketIdBySlot(const int slot)
  {
   if(slot==0) return("fx");
   if(slot==1) return("indices");
   if(slot==2) return("metals");
   if(slot==3) return("energy");
   if(slot==4) return("crypto");
   if(slot==5) return("stocks");
   return("");
  }

string ASC_Layer1MainBucketNameBySlot(const int slot)
  {
   if(slot==0) return("FX");
   if(slot==1) return("Indices");
   if(slot==2) return("Metals");
   if(slot==3) return("Energy");
   if(slot==4) return("Crypto");
   if(slot==5) return("Stocks");
   return("Unknown");
  }

ASC_PreparedBucketProgressState ASC_PreparedBucketProgressForSlot(const int slot,const int &ready_batches[])
  {
   bool batch1_ready=(ArraySize(ready_batches)>=1 && ready_batches[0]!=0);
   bool batch2_ready=(ArraySize(ready_batches)>=2 && ready_batches[1]!=0);
   bool batch3_ready=(ArraySize(ready_batches)>=3 && ready_batches[2]!=0);
   if(slot>=0 && slot<=4)
      return(batch1_ready ? ASC_PREPARED_BUCKET_READY : ASC_PREPARED_BUCKET_NOT_STARTED);
   if(slot==5)
     {
      if(batch2_ready && !batch3_ready)
         return(ASC_PREPARED_BUCKET_BACKGROUND_ENRICH_PENDING);
      if(batch3_ready)
         return(ASC_PREPARED_BUCKET_READY);
      if(batch1_ready)
         return(ASC_PREPARED_BUCKET_PREPARING);
      return(ASC_PREPARED_BUCKET_NOT_STARTED);
     }
   return(ASC_PREPARED_BUCKET_NOT_STARTED);
  }

void ASC_PreparedSeedMainBuckets(ASC_PreparedBucketState &prepared)
  {
   ArrayResize(prepared.buckets,6);
   for(int i=0;i<6;i++)
     {
      prepared.buckets[i].bucket_id=ASC_Layer1MainBucketIdBySlot(i);
      prepared.buckets[i].name=ASC_Layer1MainBucketNameBySlot(i);
      prepared.buckets[i].family="Layer 1 Main Bucket";
      prepared.buckets[i].posture="Compressed Layer 1";
      prepared.buckets[i].note=(i==5
                                ? "Compressed Layer 1 stock bucket. Regional grouping promotes before finer stock metadata enrichment."
                                : "Compressed Layer 1 bucket from richer ASC classification truth.");
      prepared.buckets[i].resolved_symbol_count=0;
      prepared.buckets[i].open_symbol_count=0;
      prepared.buckets[i].unresolved_symbol_count=0;
      prepared.buckets[i].source_symbol_count=0;
      prepared.buckets[i].open_resolved_percent_tenths=0;
      prepared.buckets[i].unresolved_source_percent_tenths=0;
      prepared.buckets[i].share_total_resolved_percent_tenths=0;
      prepared.buckets[i].prepared_symbol_offset=-1;
      prepared.buckets[i].progress_state=ASC_PreparedBucketProgressForSlot(i,prepared.batch_ready);
      if(i==5 && ArraySize(prepared.batch_progress_states)>=ASC_PREPARED_BATCH_COUNT)
        {
         if(prepared.batch_progress_states[ASC_PREPARED_BATCH_STOCK_MAIN-1]==ASC_PREPARED_BUCKET_PREPARING)
            prepared.buckets[i].progress_state=ASC_PREPARED_BUCKET_PREPARING;
         else if(prepared.batch_progress_states[ASC_PREPARED_BATCH_STOCK_MAIN-1]==ASC_PREPARED_BUCKET_READY
                 && prepared.batch_progress_states[ASC_PREPARED_BATCH_STOCK_METADATA-1]!=ASC_PREPARED_BUCKET_READY)
            prepared.buckets[i].progress_state=ASC_PREPARED_BUCKET_BACKGROUND_ENRICH_PENDING;
        }
      prepared.buckets[i].progress_label=ASC_PreparedBucketProgressStateText(prepared.buckets[i].progress_state);
      ArrayResize(prepared.buckets[i].symbol_refs,0);
      ArrayResize(prepared.buckets[i].symbol_notes,0);
     }
  }

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
      int key_slot=ASC_Layer1MainBucketSlot(key.bucket_id);
      int j=i-1;
      while(j>=0)
        {
         int left_slot=ASC_Layer1MainBucketSlot(views[j].bucket_id);
         bool keep_order=false;
         if(left_slot>=0 && key_slot>=0)
            keep_order=(left_slot<=key_slot);
         else
           {
            string left=views[j].family + "|" + views[j].name;
            string right=key.family + "|" + key.name;
            keep_order=(StringCompare(left,right,true)<=0);
           }
         if(keep_order)
            break;
         views[j+1]=views[j];
         j--;
        }
      views[j+1]=key;
     }
  }

string ASC_CL_StockSecondaryGroupId(const ASC_SymbolClassification &classification)
  {
   string asset_class=ASC_Trim(classification.asset_class);
   StringToUpper(asset_class);
   if(asset_class!="STOCK")
      return("");

   string primary_upper=ASC_Trim(classification.primary_bucket);
   StringToUpper(primary_upper);
   string theme_upper=ASC_Trim(classification.theme_bucket);
   StringToUpper(theme_upper);
   string canonical_upper=ASC_Trim(classification.canonical_symbol);
   StringToUpper(canonical_upper);

   if(StringFind(primary_upper,"HK_")==0 || StringFind(primary_upper,"HONG_KONG")>=0
      || theme_upper=="HK" || theme_upper=="HONG_KONG"
      || StringFind(canonical_upper,".HK")>0)
      return("hk_stocks");
   if(StringFind(primary_upper,"EU_")==0 || StringFind(primary_upper,"EUR_")==0
      || theme_upper=="EU" || theme_upper=="EUROPE"
      || StringFind(canonical_upper,".DE")>0 || StringFind(canonical_upper,".PA")>0)
      return("eu_stocks");
   if(StringFind(primary_upper,"US_")==0 || theme_upper=="US" || theme_upper=="UNITED_STATES"
      || StringFind(canonical_upper,".US")>0)
      return("us_stocks");
   return("global_stocks");
  }

string ASC_CL_StockSecondaryGroupName(const ASC_SymbolClassification &classification)
  {
   string group_id=ASC_CL_StockSecondaryGroupId(classification);
   if(group_id=="us_stocks")
      return("US Stocks");
   if(group_id=="eu_stocks")
      return("EU Stocks");
   if(group_id=="hk_stocks")
      return("HK Stocks");
   if(group_id=="global_stocks")
      return("Global Stocks");
   return("");
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
      string secondary_group=ASC_CL_StockSecondaryGroupName(classification);
      if(secondary_group!="")
         note+=" Secondary group " + secondary_group + ".";
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

int ASC_PreparedNowMs(void)
  {
   return((int)GetTickCount());
  }

void ASC_CopyBucketViews(const ASC_BucketViewModel &source[],ASC_BucketViewModel &target[])
  {
   int total=ArraySize(source);
   ArrayResize(target,total);
   for(int i=0;i<total;i++)
     {
      target[i].bucket_id=source[i].bucket_id;
      target[i].name=source[i].name;
      target[i].family=source[i].family;
      target[i].posture=source[i].posture;
      target[i].note=source[i].note;
      target[i].resolved_symbol_count=source[i].resolved_symbol_count;
      target[i].open_symbol_count=source[i].open_symbol_count;
      target[i].unresolved_symbol_count=source[i].unresolved_symbol_count;
      target[i].source_symbol_count=source[i].source_symbol_count;
      target[i].open_resolved_percent_tenths=source[i].open_resolved_percent_tenths;
      target[i].unresolved_source_percent_tenths=source[i].unresolved_source_percent_tenths;
      target[i].share_total_resolved_percent_tenths=source[i].share_total_resolved_percent_tenths;
      target[i].prepared_symbol_offset=source[i].prepared_symbol_offset;
      target[i].progress_state=source[i].progress_state;
      target[i].progress_label=source[i].progress_label;
      ArrayResize(target[i].symbol_refs,ArraySize(source[i].symbol_refs));
      for(int j=0;j<ArraySize(source[i].symbol_refs);j++)
         target[i].symbol_refs[j]=source[i].symbol_refs[j];
      ArrayResize(target[i].symbol_notes,ArraySize(source[i].symbol_notes));
      for(int j=0;j<ArraySize(source[i].symbol_notes);j++)
         target[i].symbol_notes[j]=source[i].symbol_notes[j];
     }
  }

void ASC_CopyPreparedSymbols(const ASC_BucketPreparedSymbol &source[],ASC_BucketPreparedSymbol &target[])
  {
   int total=ArraySize(source);
   ArrayResize(target,total);
   for(int i=0;i<total;i++)
      target[i]=source[i];
  }

void ASC_PreparedStateDiagnosticsReset(ASC_PreparedStateDiagnostics &diagnostics)
  {
   diagnostics.bucket_prep_total_ms=0;
   diagnostics.classification_loop_ms=0;
   diagnostics.bucket_sort_ms=0;
   diagnostics.prepared_symbol_reorder_ms=0;
   diagnostics.final_promotion_ms=0;
   diagnostics.heartbeat_dispatch_ms=0;
   diagnostics.hud_render_ms=0;
   diagnostics.page_switch_action_to_render_ms=0;
   diagnostics.last_prepared_batch_id=0;
   diagnostics.promoted_batch_count=0;
   diagnostics.pending_batch_count=ASC_PREPARED_BATCH_COUNT;
   diagnostics.warmup_assessed_count=0;
   diagnostics.warmup_total_count=0;
   diagnostics.readiness_percent=0;
   diagnostics.bounded_work_pressure_summary="Not sampled.";
   diagnostics.active_hydration_priority_set="next=" + ASC_PreparedBatchName(ASC_PREPARED_BATCH_PRIORITY_SET);
  }

string ASC_PreparedBatchName(const int batch_id)
  {
   if(batch_id==ASC_PREPARED_BATCH_PRIORITY_SET)
      return("Priority 1: FX, Indices, Metals, Energy, Crypto");
   if(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN)
      return("Priority 2: Stocks and regional stock groups");
   if(batch_id==ASC_PREPARED_BATCH_STOCK_METADATA)
      return("Priority 3: finer stock detail metadata");
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
   prepared.working_batch_id=0;
   prepared.last_good_batch_id=0;
   prepared.batch_generation=0;
   ASC_PreparedStateDiagnosticsReset(prepared.diagnostics);
   ArrayResize(prepared.buckets,0);
   ArrayResize(prepared.symbols,0);
   ArrayResize(prepared.batch_ready,ASC_PREPARED_BATCH_COUNT);
   ArrayResize(prepared.batch_pending,ASC_PREPARED_BATCH_COUNT);
   ArrayResize(prepared.batch_reused,ASC_PREPARED_BATCH_COUNT);
   ArrayResize(prepared.batch_progress_states,ASC_PREPARED_BATCH_COUNT);
   ArrayResize(prepared.bucket_progress_states,6);
   for(int i=0;i<ASC_PREPARED_BATCH_COUNT;i++)
     {
      prepared.batch_ready[i]=0;
      prepared.batch_pending[i]=0;
      prepared.batch_reused[i]=0;
      prepared.batch_progress_states[i]=ASC_PREPARED_BUCKET_NOT_STARTED;
     }
   for(int i=0;i<6;i++)
      prepared.bucket_progress_states[i]=ASC_PREPARED_BUCKET_NOT_STARTED;
   ASC_PreparedSeedMainBuckets(prepared);
  }

void ASC_CopyPreparedBucketState(const ASC_PreparedBucketState &source,ASC_PreparedBucketState &target)
  {
   target.ready=source.ready;
   target.server_key=source.server_key;
   target.prepared_at=source.prepared_at;
   target.source_symbol_count=source.source_symbol_count;
   target.unresolved_count=source.unresolved_count;
   target.total_resolved_symbols=source.total_resolved_symbols;
   target.active_batch_id=source.active_batch_id;
   target.working_batch_id=source.working_batch_id;
   target.last_good_batch_id=source.last_good_batch_id;
   target.batch_generation=source.batch_generation;
   target.diagnostics=source.diagnostics;
   ASC_CopyBucketViews(source.buckets,target.buckets);
   ASC_CopyPreparedSymbols(source.symbols,target.symbols);
   target.batch_ready=source.batch_ready;
   target.batch_pending=source.batch_pending;
   target.batch_reused=source.batch_reused;
   target.batch_progress_states=source.batch_progress_states;
   target.bucket_progress_states=source.bucket_progress_states;
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

int ASC_PreparedNextPendingBatchId(const ASC_PreparedBucketState &prepared)
  {
   if(ArraySize(prepared.batch_ready)<ASC_PREPARED_BATCH_COUNT)
      return(ASC_PREPARED_BATCH_PRIORITY_SET);
   for(int i=0;i<ASC_PREPARED_BATCH_COUNT;i++)
     {
      if(prepared.batch_ready[i]==0)
         return(i+1);
     }
   return(0);
  }

void ASC_PreparedRefreshBatchProgressStates(ASC_PreparedBucketState &prepared)
  {
   if(ArraySize(prepared.batch_progress_states)!=ASC_PREPARED_BATCH_COUNT)
      ArrayResize(prepared.batch_progress_states,ASC_PREPARED_BATCH_COUNT);
   int next_batch=ASC_PreparedNextPendingBatchId(prepared);
   for(int i=0;i<ASC_PREPARED_BATCH_COUNT;i++)
     {
      int batch_id=i+1;
      if(prepared.batch_ready[i]!=0)
         prepared.batch_progress_states[i]=ASC_PREPARED_BUCKET_READY;
      else if(prepared.batch_pending[i]!=0 || prepared.working_batch_id==batch_id)
         prepared.batch_progress_states[i]=ASC_PREPARED_BUCKET_PREPARING;
      else if(batch_id<next_batch)
         prepared.batch_progress_states[i]=ASC_PREPARED_BUCKET_BACKGROUND_ENRICH_PENDING;
      else
         prepared.batch_progress_states[i]=ASC_PREPARED_BUCKET_NOT_STARTED;
     }
  }


int ASC_PercentTenths(const int numerator,const int denominator)
  {
   if(denominator<=0 || numerator<=0)
      return(0);
   long scaled=((long)numerator*1000 + (denominator/2))/denominator;
   if(scaled<0)
      scaled=0;
   if(scaled>1000)
      scaled=1000;
   return((int)scaled);
  }

void ASC_PreparedRefreshBucketPercentages(ASC_PreparedBucketState &prepared)
  {
   for(int i=0;i<ArraySize(prepared.buckets);i++)
     {
      prepared.buckets[i].source_symbol_count=prepared.buckets[i].resolved_symbol_count+prepared.buckets[i].unresolved_symbol_count;
      prepared.buckets[i].open_resolved_percent_tenths=ASC_PercentTenths(prepared.buckets[i].open_symbol_count,prepared.buckets[i].resolved_symbol_count);
      prepared.buckets[i].unresolved_source_percent_tenths=ASC_PercentTenths(prepared.buckets[i].unresolved_symbol_count,prepared.buckets[i].source_symbol_count);
      prepared.buckets[i].share_total_resolved_percent_tenths=ASC_PercentTenths(prepared.buckets[i].resolved_symbol_count,prepared.total_resolved_symbols);
     }
  }

void ASC_PreparedRefreshDiagnostics(ASC_PreparedBucketState &prepared,const int warmup_assessed,const int warmup_total,const int readiness_percent,const int due_now,const int budget)
  {
   prepared.diagnostics.last_prepared_batch_id=(prepared.active_batch_id>0 ? prepared.active_batch_id : prepared.last_good_batch_id);
   prepared.diagnostics.promoted_batch_count=ASC_PreparedPromotedBatchCount(prepared);
   prepared.diagnostics.pending_batch_count=ASC_PREPARED_BATCH_COUNT-prepared.diagnostics.promoted_batch_count;
   prepared.diagnostics.warmup_assessed_count=warmup_assessed;
   prepared.diagnostics.warmup_total_count=warmup_total;
   prepared.diagnostics.readiness_percent=ASC_PercentClamp(readiness_percent);
   prepared.diagnostics.bounded_work_pressure_summary="due=" + IntegerToString(due_now)
      + " | budget=" + IntegerToString(budget)
      + " | backlog=" + IntegerToString((due_now>budget) ? (due_now-budget) : 0);
   int next_batch=ASC_PreparedNextPendingBatchId(prepared);
   string active_batch=((next_batch>0 && prepared.active_batch_id>0) ? ASC_PreparedBatchName(prepared.active_batch_id) : "Idle");
   string next_label=(next_batch>0 ? ASC_PreparedBatchName(next_batch) : "Hydration complete");
   prepared.diagnostics.active_hydration_priority_set="active=" + active_batch
      + " | next=" + next_label
      + " | promoted=" + IntegerToString(prepared.diagnostics.promoted_batch_count)
      + "/" + IntegerToString(ASC_PREPARED_BATCH_COUNT);
  }

void ASC_PreparedRefreshBucketProgressStates(ASC_PreparedBucketState &prepared)
  {
   for(int i=0;i<ArraySize(prepared.buckets);i++)
     {
      prepared.buckets[i].progress_state=ASC_PreparedBucketProgressForSlot(i,prepared.batch_ready);
      prepared.buckets[i].progress_label=ASC_PreparedBucketProgressStateText(prepared.buckets[i].progress_state);
      if(i<ArraySize(prepared.bucket_progress_states))
         prepared.bucket_progress_states[i]=(int)prepared.buckets[i].progress_state;
     }
  }

void ASC_PreparedRebuildBucketsFromSymbols(ASC_PreparedBucketState &prepared)
  {
   ASC_PreparedSeedMainBuckets(prepared);
   for(int i=0;i<ArraySize(prepared.symbols);i++)
     {
      ASC_BucketPreparedSymbol symbol=prepared.symbols[i];
      int bucket_index=ASC_Layer1MainBucketSlot(symbol.bucket_id);
      if(bucket_index<0 || bucket_index>=ArraySize(prepared.buckets))
         continue;
      int slot=ArraySize(prepared.buckets[bucket_index].symbol_refs);
      ArrayResize(prepared.buckets[bucket_index].symbol_refs,slot+1);
      ArrayResize(prepared.buckets[bucket_index].symbol_notes,slot+1);
      prepared.buckets[bucket_index].symbol_refs[slot]=symbol.live_symbol;
      prepared.buckets[bucket_index].symbol_notes[slot]=symbol.note;
      prepared.buckets[bucket_index].resolved_symbol_count++;
      if(symbol.open_now)
         prepared.buckets[bucket_index].open_symbol_count++;
     }
   ASC_PreparedRefreshBucketProgressStates(prepared);
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
   ASC_CopyPreparedSymbols(ordered,prepared.symbols);
   prepared.total_resolved_symbols=ArraySize(prepared.symbols);
   ASC_PreparedRefreshBucketPercentages(prepared);
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
   ASC_CopyPreparedSymbols(kept,prepared.symbols);
   prepared.total_resolved_symbols=ArraySize(prepared.symbols);
  }

void ASC_PreparedAppendSymbol(ASC_PreparedBucketState &prepared,const ASC_BucketPreparedSymbol &symbol)
  {
   int slot=ArraySize(prepared.symbols);
   ArrayResize(prepared.symbols,slot+1);
   prepared.symbols[slot]=symbol;
   prepared.total_resolved_symbols=ArraySize(prepared.symbols);
   ASC_PreparedRefreshBucketPercentages(prepared);
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
         working.symbols[i].secondary_group_id=ASC_CL_StockSecondaryGroupId(classification);
         working.symbols[i].secondary_group_name=ASC_CL_StockSecondaryGroupName(classification);
         working.symbols[i].match_kind=classification.match_kind;
         working.symbols[i].review_status=classification.review_status;
         working.symbols[i].note="Canonical " + classification.canonical_symbol
                              + " | Primary " + classification.primary_bucket
                              + " | Group " + (working.symbols[i].secondary_group_name=="" ? "N/A" : working.symbols[i].secondary_group_name)
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

      string prepared_bucket_id=ASC_CL_MainBucketId(classification);

      ASC_BucketPreparedSymbol prepared_symbol;
      prepared_symbol.live_symbol=states[i].symbol;
      prepared_symbol.canonical_symbol=classification.canonical_symbol;
      prepared_symbol.bucket_id=prepared_bucket_id;
      prepared_symbol.bucket_name=ASC_CL_MainBucketName(classification);
      prepared_symbol.asset_class=classification.asset_class;
      prepared_symbol.primary_bucket=classification.primary_bucket;
      prepared_symbol.sector=(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN ? "" : classification.sector);
      prepared_symbol.industry=(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN ? "" : classification.industry);
      prepared_symbol.theme_bucket=classification.theme_bucket;
      prepared_symbol.subtype=(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN ? "" : classification.subtype);
      prepared_symbol.secondary_group_id=ASC_CL_StockSecondaryGroupId(classification);
      prepared_symbol.secondary_group_name=ASC_CL_StockSecondaryGroupName(classification);
      prepared_symbol.match_kind=classification.match_kind;
      prepared_symbol.review_status=classification.review_status;
      prepared_symbol.note="Canonical " + classification.canonical_symbol
                         + " | Primary " + classification.primary_bucket
                         + " | Group " + (prepared_symbol.secondary_group_name=="" ? "N/A" : prepared_symbol.secondary_group_name)
                         + " | Theme " + (classification.theme_bucket=="" ? "N/A" : classification.theme_bucket)
                         + " | Review " + classification.review_status;
      prepared_symbol.market_status=states[i].market_status;
      prepared_symbol.open_now=(states[i].market_status==ASC_MARKET_OPEN);
      prepared_symbol.symbol_state_index=i;
      ASC_PreparedAppendSymbol(working,prepared_symbol);
     }
  }

bool ASC_PreparedValidateBatchCompleteness(const ASC_PreparedBucketState &working,const int batch_id)
  {
   if(batch_id<=0 || batch_id>ASC_PREPARED_BATCH_COUNT)
      return(false);
   if(ArraySize(working.batch_ready)<ASC_PREPARED_BATCH_COUNT)
      return(false);
   if(working.batch_ready[batch_id-1]==0)
      return(false);
   for(int i=0;i<ArraySize(working.symbols);i++)
     {
      if(!ASC_PreparedSymbolInBatch(working.symbols[i],batch_id))
         continue;
      if(ASC_Trim(working.symbols[i].live_symbol)=="" || ASC_Trim(working.symbols[i].bucket_id)=="")
         return(false);
      if(batch_id==ASC_PREPARED_BATCH_STOCK_METADATA)
        {
         if(ASC_Trim(working.symbols[i].canonical_symbol)=="")
            return(false);
        }
     }
   return(true);
  }

void ASC_PrepareBucketState(const string server_key,ASC_SymbolState &states[],const int count,const int batch_id,const int warmup_assessed,const int warmup_total,const int readiness_percent,const int due_now,const int budget,const ASC_PreparedBucketState &promoted,const ASC_PreparedBucketState &last_good,ASC_PreparedBucketState &working)
  {
   int prep_started=ASC_PreparedNowMs();
   if(promoted.ready && promoted.server_key==server_key)
      ASC_CopyPreparedBucketState(promoted,working);
   else if(last_good.ready && last_good.server_key==server_key)
      ASC_CopyPreparedBucketState(last_good,working);
   else
      ASC_PreparedBucketStateReset(working);

   working.server_key=server_key;
   working.prepared_at=TimeCurrent();
   working.source_symbol_count=count;
   working.active_batch_id=0;
   working.working_batch_id=batch_id;
   working.last_good_batch_id=(last_good.ready ? last_good.active_batch_id : 0);
   working.unresolved_count=0;
   if(ArraySize(working.batch_ready)!=ASC_PREPARED_BATCH_COUNT)
     {
      ArrayResize(working.batch_ready,ASC_PREPARED_BATCH_COUNT);
      ArrayResize(working.batch_pending,ASC_PREPARED_BATCH_COUNT);
      ArrayResize(working.batch_reused,ASC_PREPARED_BATCH_COUNT);
      ArrayResize(working.batch_progress_states,ASC_PREPARED_BATCH_COUNT);
      for(int i=0;i<ASC_PREPARED_BATCH_COUNT;i++)
        {
         working.batch_ready[i]=0;
         working.batch_pending[i]=0;
         working.batch_reused[i]=0;
         working.batch_progress_states[i]=ASC_PREPARED_BUCKET_NOT_STARTED;
        }
     }
   for(int i=0;i<ASC_PREPARED_BATCH_COUNT;i++)
     {
      working.batch_pending[i]=(i==(batch_id-1) ? 1 : 0);
      working.batch_reused[i]=(i==(batch_id-1) ? 0 : (working.batch_ready[i]!=0 ? 1 : 0));
     }

   ASC_PreparedRefreshBatchProgressStates(working);

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

   working.batch_ready[batch_id-1]=1;
   working.batch_pending[batch_id-1]=0;
   ASC_PreparedRefreshBatchProgressStates(working);
   ASC_PreparedRefreshBucketProgressStates(working);
   working.ready=(ASC_PreparedPromotedBatchCount(working)>0);
   ASC_PreparedRefreshDiagnostics(working,warmup_assessed,warmup_total,readiness_percent,due_now,budget);
   working.diagnostics.bucket_prep_total_ms=ASC_PreparedNowMs()-prep_started;
   working.prepared_at=TimeCurrent();
   working.diagnostics.last_prepared_batch_id=batch_id;
   working.diagnostics.promoted_batch_count=ASC_PreparedPromotedBatchCount(working);
   working.diagnostics.pending_batch_count=ASC_PREPARED_BATCH_COUNT-working.diagnostics.promoted_batch_count;
   working.diagnostics.final_promotion_ms=0;
  }

void ASC_PromotePreparedBucketState(const ASC_PreparedBucketState &completed,const int batch_id,ASC_PreparedBucketState &last_good,ASC_PreparedBucketState &promoted)
  {
   if(!ASC_PreparedValidateBatchCompleteness(completed,batch_id))
      return;

   ASC_PreparedBucketState base;
   if(promoted.ready && promoted.server_key==completed.server_key)
      ASC_CopyPreparedBucketState(promoted,base);
   else if(last_good.ready && last_good.server_key==completed.server_key)
      ASC_CopyPreparedBucketState(last_good,base);
   else
      ASC_PreparedBucketStateReset(base);

   ASC_CopyPreparedBucketState(base,last_good);
   ASC_CopyPreparedBucketState(base,promoted);

   promoted.server_key=completed.server_key;
   promoted.prepared_at=completed.prepared_at;
   promoted.source_symbol_count=completed.source_symbol_count;
   promoted.unresolved_count=completed.unresolved_count;
   promoted.active_batch_id=batch_id;
   promoted.working_batch_id=0;
   promoted.last_good_batch_id=last_good.active_batch_id;
   promoted.batch_generation=last_good.batch_generation+1;
   promoted.diagnostics=completed.diagnostics;

   ASC_PreparedRemoveBatchSymbols(promoted,batch_id);
   for(int i=0;i<ArraySize(completed.symbols);i++)
     {
      if(!ASC_PreparedSymbolInBatch(completed.symbols[i],batch_id))
         continue;
      ASC_PreparedAppendSymbol(promoted,completed.symbols[i]);
     }

   if(ArraySize(promoted.batch_ready)!=ASC_PREPARED_BATCH_COUNT)
     {
      ArrayResize(promoted.batch_ready,ASC_PREPARED_BATCH_COUNT);
      ArrayResize(promoted.batch_pending,ASC_PREPARED_BATCH_COUNT);
      ArrayResize(promoted.batch_reused,ASC_PREPARED_BATCH_COUNT);
      ArrayResize(promoted.batch_progress_states,ASC_PREPARED_BATCH_COUNT);
     }
   for(int i=0;i<ASC_PREPARED_BATCH_COUNT;i++)
     {
      promoted.batch_pending[i]=0;
      promoted.batch_reused[i]=(i==(batch_id-1) ? 0 : (last_good.batch_ready[i]!=0 ? 1 : 0));
      if(i==(batch_id-1))
         promoted.batch_ready[i]=1;
      else if(ArraySize(last_good.batch_ready)==ASC_PREPARED_BATCH_COUNT)
         promoted.batch_ready[i]=last_good.batch_ready[i];
     }

   ASC_PreparedRebuildBucketsFromSymbols(promoted);
   ASC_PreparedPhaseBucketSort(promoted);
   ASC_PreparedPhaseSymbolReorder(promoted);
   ASC_PreparedRefreshBatchProgressStates(promoted);
   ASC_PreparedRefreshBucketProgressStates(promoted);
   promoted.ready=(ASC_PreparedPromotedBatchCount(promoted)>0);
   promoted.diagnostics.last_prepared_batch_id=batch_id;
   promoted.diagnostics.promoted_batch_count=ASC_PreparedPromotedBatchCount(promoted);
   promoted.diagnostics.pending_batch_count=ASC_PREPARED_BATCH_COUNT-promoted.diagnostics.promoted_batch_count;
  }

bool ASC_PreparedBatchMatches(const ASC_PreparedBucketState &left,const ASC_PreparedBucketState &right,const int batch_id)
  {
   if(batch_id<=0 || batch_id>ASC_PREPARED_BATCH_COUNT)
      return(false);

   int left_count=0;
   int right_count=0;
   for(int i=0;i<ArraySize(left.symbols);i++)
     {
      if(!ASC_PreparedSymbolInBatch(left.symbols[i],batch_id))
         continue;
      left_count++;
     }
   for(int i=0;i<ArraySize(right.symbols);i++)
     {
      if(!ASC_PreparedSymbolInBatch(right.symbols[i],batch_id))
         continue;
      right_count++;
     }
   if(left_count!=right_count)
      return(false);

   int left_seen=0;
   for(int i=0;i<ArraySize(left.symbols);i++)
     {
      if(!ASC_PreparedSymbolInBatch(left.symbols[i],batch_id))
         continue;
      bool found=false;
      for(int j=0;j<ArraySize(right.symbols);j++)
        {
         if(!ASC_PreparedSymbolInBatch(right.symbols[j],batch_id))
            continue;
         if(left.symbols[i].live_symbol!=right.symbols[j].live_symbol)
            continue;
         if(left.symbols[i].bucket_id!=right.symbols[j].bucket_id)
            continue;
         if(left.symbols[i].open_now!=right.symbols[j].open_now)
            continue;
         if(left.symbols[i].canonical_symbol!=right.symbols[j].canonical_symbol)
            continue;
         found=true;
         break;
        }
      if(!found)
         return(false);
      left_seen++;
     }
   return(left_seen==left_count);
  }

int ASC_PreparedVisibleOpenBucketTotal(const ASC_PreparedBucketState &prepared)
  {
   int visible=0;
   for(int i=0;i<ArraySize(prepared.buckets);i++)
     {
      if(prepared.buckets[i].open_symbol_count>0)
         visible++;
     }
   return(visible);
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
      return(bucket.progress_state!=ASC_PREPARED_BUCKET_NOT_STARTED || bucket.resolved_symbol_count>0);
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
