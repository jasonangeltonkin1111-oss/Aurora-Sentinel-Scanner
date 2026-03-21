#ifndef __ASC_PERSISTENCE_MQH__
#define __ASC_PERSISTENCE_MQH__

#include "ASC_Common.mqh"
#include "ASC_FileIO.mqh"

bool ASC_ParseKeyValueLine(const string line,string &key,string &value)
  {
   int pivot=StringFind(line,"=");
   if(pivot<0)
      return(false);
   key=ASC_Trim(StringSubstr(line,0,pivot));
   value=ASC_Trim(StringSubstr(line,pivot+1));
   return(key!="");
  }

bool ASC_ReadContinuityWithFallback(const string primary_path,string &body,ASC_Logger &logger)
  {
   if(ASC_ReadTextFile(primary_path,body) && body!="")
      return(true);

   string backup_path=primary_path + ".last-good";
   if(ASC_ReadTextFile(backup_path,body) && body!="")
     {
      logger.Warn("Persistence","restored from last-good backup for " + primary_path);
      return(true);
     }

   body="";
   return(false);
  }

void ASC_AssignRuntimeField(ASC_RuntimeState &state,const string key,const string value)
  {
   if(key=="Schema Version") state.schema_version=value;
   else if(key=="Server Raw") state.server_raw=value;
   else if(key=="Server Clean") state.server_clean=value;
   else if(key=="Runtime Mode") state.mode=ASC_RuntimeModeFromText(value);
   else if(key=="Boot At") ASC_TryParseDateTime(value,state.boot_at);
   else if(key=="Last Heartbeat") ASC_TryParseDateTime(value,state.last_heartbeat_at);
   else if(key=="Last Universe Sync") ASC_TryParseDateTime(value,state.last_universe_sync_at);
   else if(key=="Last Runtime Save") ASC_TryParseDateTime(value,state.last_runtime_save_at);
   else if(key=="Last Scheduler Save") ASC_TryParseDateTime(value,state.last_scheduler_save_at);
   else if(key=="Last Summary Save") ASC_TryParseDateTime(value,state.last_summary_save_at);
   else if(key=="Recovery Used") state.recovery_used=ASC_BoolFromText(value);
   else if(key=="Degraded") state.degraded=ASC_BoolFromText(value);
   else if(key=="Symbol Count") state.symbol_count=ASC_IntegerFromText(value);
   else if(key=="Processed This Heartbeat") state.processed_this_heartbeat=ASC_IntegerFromText(value);
   else if(key=="Scheduler Cursor") state.scheduler_cursor=ASC_IntegerFromText(value);
   else if(key=="Heartbeats Since Boot") state.heartbeats_since_boot=ASC_IntegerFromText(value);
   else if(key=="Total Symbols Discovered") state.total_symbols_discovered=ASC_IntegerFromText(value);
   else if(key=="Initial Symbols Assessed") state.initial_symbols_assessed=ASC_IntegerFromText(value);
   else if(key=="Primary Bucket Symbols Assessed") state.primary_bucket_symbols_assessed=ASC_IntegerFromText(value);
   else if(key=="Primary Bucket Symbol Count") state.primary_bucket_symbol_count=ASC_IntegerFromText(value);
   else if(key=="Compressed Primary Buckets Ready") state.compressed_primary_buckets_ready=ASC_BoolFromText(value);
   else if(key=="Warmup Minimum Met") state.warmup_minimum_met=ASC_BoolFromText(value);
   else if(key=="Warmup Progress Percent") state.warmup_progress_percent=ASC_IntegerFromText(value);
   else if(key=="Background Hydration Active") state.background_hydration_active=ASC_BoolFromText(value);
   else if(key=="Readiness Percent") state.readiness_percent=ASC_IntegerFromText(value);
   else if(key=="Prepared Last Batch Id") state.prepared_last_batch_id=ASC_IntegerFromText(value);
   else if(key=="Prepared Promoted Batch Count") state.prepared_promoted_batch_count=ASC_IntegerFromText(value);
   else if(key=="Prepared Pending Batch Count") state.prepared_pending_batch_count=ASC_IntegerFromText(value);
   else if(key=="Prepared Bounded Work Summary") state.prepared_bounded_work_summary=value;
   else if(key=="Diagnostics Bucket Prep Ms") state.diagnostics.last_bucket_prep_total_ms=ASC_IntegerFromText(value);
   else if(key=="Diagnostics Classification Loop Ms") state.diagnostics.last_classification_loop_ms=ASC_IntegerFromText(value);
   else if(key=="Diagnostics Bucket Sort Ms") state.diagnostics.last_bucket_sort_ms=ASC_IntegerFromText(value);
   else if(key=="Diagnostics Prepared Symbol Reorder Ms") state.diagnostics.last_prepared_symbol_reorder_ms=ASC_IntegerFromText(value);
   else if(key=="Diagnostics Final Promotion Ms") state.diagnostics.last_final_promotion_ms=ASC_IntegerFromText(value);
   else if(key=="Diagnostics Heartbeat Dispatch Ms") state.diagnostics.last_heartbeat_dispatch_ms=ASC_IntegerFromText(value);
   else if(key=="Diagnostics HUD Render Ms") state.diagnostics.last_hud_render_ms=ASC_IntegerFromText(value);
   else if(key=="Diagnostics Page Switch Render Ms") state.diagnostics.last_page_switch_action_to_render_ms=ASC_IntegerFromText(value);
   else if(key=="Diagnostics Warmup Progress Percent") state.diagnostics.warmup_progress_percent=ASC_IntegerFromText(value);
   else if(key=="Diagnostics Bounded Work Summary") state.diagnostics.bounded_work_pressure_summary=value;
   else if(key=="Diagnostics Last Promoted Batch Id") state.diagnostics.last_promoted_prepared_batch_id=ASC_IntegerFromText(value);
   else if(key=="Diagnostics Active Hydration Priority Set") state.diagnostics.active_hydration_priority_set=value;
   else if(key=="Diagnostics Last HUD Render At") ASC_TryParseDateTime(value,state.diagnostics.last_hud_render_at);
  }

bool ASC_LoadRuntimeState(const ASC_ServerPaths &paths,ASC_RuntimeState &state,ASC_Logger &logger)
  {
   string body="";
   if(!ASC_ReadContinuityWithFallback(paths.runtime_state_file,body,logger))
      return(false);

   string lines[];
   int count=StringSplit(body,'\n',lines);
   for(int i=0;i<count;i++)
     {
      string key="";
      string value="";
      if(ASC_ParseKeyValueLine(lines[i],key,value))
         ASC_AssignRuntimeField(state,key,value);
     }

   if(state.schema_version=="")
     {
      logger.Warn("RuntimeState","runtime continuity missing schema version; ignoring restore");
      return(false);
     }

   state.runtime_dirty=false;
   logger.Info("RuntimeState","restored runtime continuity");
   return(true);
  }

bool ASC_LoadSchedulerState(const ASC_ServerPaths &paths,ASC_SymbolState &states[],const int count,ASC_Logger &logger)
  {
   string body="";
   if(!ASC_ReadContinuityWithFallback(paths.scheduler_state_file,body,logger))
      return(false);

   string lines[];
   int line_count=StringSplit(body,'\n',lines);
   int restored=0;
   for(int i=0;i<line_count;i++)
     {
      string line=ASC_Trim(lines[i]);
      if(line=="" || StringFind(line,"|")<0 || StringFind(line,"=")>=0)
         continue;

      string parts[];
      int part_count=StringSplit(line,'|',parts);
      if(part_count<8)
         continue;

      string symbol=ASC_Trim(parts[0]);
      for(int s=0;s<count;s++)
        {
         if(states[s].symbol!=symbol)
            continue;
         states[s].market_status=ASC_MarketStatusFromText(parts[1]);
         ASC_TryParseDateTime(parts[2],states[s].next_check_at);
         ASC_TryParseDateTime(parts[3],states[s].last_tick_seen_at);
         ASC_TryParseDateTime(parts[4],states[s].last_checked_at);
         states[s].uncertain_burst_count=ASC_IntegerFromText(parts[5]);
         states[s].status_note=parts[6];
         states[s].next_check_reason=parts[7];
         states[s].publication_ok=FileIsExist(ASC_JoinPath(paths.universe_folder,states[s].dossier_file),FILE_COMMON);
         states[s].dirty=true;
         restored++;
         break;
        }
     }

   logger.Info("SchedulerState","restored scheduler continuity for " + IntegerToString(restored) + " symbols");
   return(restored>0);
  }

bool ASC_SaveRuntimeState(const ASC_ServerPaths &paths,ASC_RuntimeState &state,ASC_Logger &logger)
  {
   datetime saved_at=TimeCurrent();
   string now_text=ASC_DateTimeText(saved_at);
   string body="";
   body+="Schema Version=ASC Foundation v1\r\n";
   body+="Format Family=Runtime Continuity\r\n";
   body+="Product=" + ASC_PRODUCT_NAME + "\r\n";
   body+="Wrapper Version=" + ASC_WRAPPER_VERSION + "\r\n";
   body+="Active Capability=" + ASC_ACTIVE_CAPABILITY + "\r\n";
   body+="Next Planned Capability=" + ASC_NEXT_CAPABILITY + "\r\n";
   body+="Generated At=" + now_text + "\r\n";
   body+="Server Raw=" + state.server_raw + "\r\n";
   body+="Server Clean=" + state.server_clean + "\r\n";
   body+="Runtime Mode=" + ASC_RuntimeModeText(state.mode) + "\r\n";
   body+="Boot At=" + ASC_DateTimeText(state.boot_at) + "\r\n";
   body+="Last Heartbeat=" + ASC_DateTimeText(state.last_heartbeat_at) + "\r\n";
   body+="Last Universe Sync=" + ASC_DateTimeText(state.last_universe_sync_at) + "\r\n";
   body+="Last Runtime Save=" + now_text + "\r\n";
   body+="Last Scheduler Save=" + ASC_DateTimeText(state.last_scheduler_save_at) + "\r\n";
   body+="Last Summary Save=" + ASC_DateTimeText(state.last_summary_save_at) + "\r\n";
   body+="Recovery Used=" + ASC_BoolText(state.recovery_used) + "\r\n";
   body+="Degraded=" + ASC_BoolText(state.degraded) + "\r\n";
   body+="Symbol Count=" + IntegerToString(state.symbol_count) + "\r\n";
   body+="Processed This Heartbeat=" + IntegerToString(state.processed_this_heartbeat) + "\r\n";
   body+="Scheduler Cursor=" + IntegerToString(state.scheduler_cursor) + "\r\n";
   body+="Heartbeats Since Boot=" + IntegerToString(state.heartbeats_since_boot) + "\r\n";
   body+="Total Symbols Discovered=" + IntegerToString(state.total_symbols_discovered) + "\r\n";
   body+="Initial Symbols Assessed=" + IntegerToString(state.initial_symbols_assessed) + "\r\n";
   body+="Primary Bucket Symbols Assessed=" + IntegerToString(state.primary_bucket_symbols_assessed) + "\r\n";
   body+="Primary Bucket Symbol Count=" + IntegerToString(state.primary_bucket_symbol_count) + "\r\n";
   body+="Compressed Primary Buckets Ready=" + ASC_BoolText(state.compressed_primary_buckets_ready) + "\r\n";
   body+="Warmup Minimum Met=" + ASC_BoolText(state.warmup_minimum_met) + "\r\n";
   body+="Warmup Progress Percent=" + IntegerToString(state.warmup_progress_percent) + "\r\n";
   body+="Background Hydration Active=" + ASC_BoolText(state.background_hydration_active) + "\r\n";
   body+="Readiness Percent=" + IntegerToString(state.readiness_percent) + "\r\n";
   body+="Prepared Last Batch Id=" + IntegerToString(state.prepared_last_batch_id) + "\r\n";
   body+="Prepared Promoted Batch Count=" + IntegerToString(state.prepared_promoted_batch_count) + "\r\n";
   body+="Prepared Pending Batch Count=" + IntegerToString(state.prepared_pending_batch_count) + "\r\n";
   body+="Prepared Bounded Work Summary=" + state.prepared_bounded_work_summary + "\r\n";
   body+="Diagnostics Bucket Prep Ms=" + IntegerToString((int)state.diagnostics.last_bucket_prep_total_ms) + "\r\n";
   body+="Diagnostics Classification Loop Ms=" + IntegerToString((int)state.diagnostics.last_classification_loop_ms) + "\r\n";
   body+="Diagnostics Bucket Sort Ms=" + IntegerToString((int)state.diagnostics.last_bucket_sort_ms) + "\r\n";
   body+="Diagnostics Prepared Symbol Reorder Ms=" + IntegerToString((int)state.diagnostics.last_prepared_symbol_reorder_ms) + "\r\n";
   body+="Diagnostics Final Promotion Ms=" + IntegerToString((int)state.diagnostics.last_final_promotion_ms) + "\r\n";
   body+="Diagnostics Heartbeat Dispatch Ms=" + IntegerToString((int)state.diagnostics.last_heartbeat_dispatch_ms) + "\r\n";
   body+="Diagnostics HUD Render Ms=" + IntegerToString((int)state.diagnostics.last_hud_render_ms) + "\r\n";
   body+="Diagnostics Page Switch Render Ms=" + IntegerToString((int)state.diagnostics.last_page_switch_action_to_render_ms) + "\r\n";
   body+="Diagnostics Warmup Progress Percent=" + IntegerToString(state.diagnostics.warmup_progress_percent) + "\r\n";
   body+="Diagnostics Bounded Work Summary=" + state.diagnostics.bounded_work_pressure_summary + "\r\n";
   body+="Diagnostics Last Promoted Batch Id=" + IntegerToString(state.diagnostics.last_promoted_prepared_batch_id) + "\r\n";
   body+="Diagnostics Active Hydration Priority Set=" + state.diagnostics.active_hydration_priority_set + "\r\n";
   body+="Diagnostics Last HUD Render At=" + ASC_DateTimeText(state.diagnostics.last_hud_render_at) + "\r\n";
   bool ok=ASC_AtomicWrite(paths.runtime_state_file,body,logger);
   if(ok)
     {
      state.last_runtime_save_at=saved_at;
      state.runtime_dirty=false;
      logger.Info("RuntimeState","saved runtime state");
     }
   return(ok);
  }

bool ASC_SaveSchedulerState(const ASC_ServerPaths &paths,ASC_SymbolState &states[],const int count,ASC_Logger &logger)
  {
   string body="Schema Version=ASC Foundation v1\r\n";
   body+="Format Family=Scheduler Continuity\r\n";
   body+="Generated At=" + ASC_DateTimeText(TimeCurrent()) + "\r\n\r\n";
   for(int i=0;i<count;i++)
     {
      body+=states[i].symbol + "|" + ASC_MarketStatusText(states[i].market_status) + "|" + ASC_DateTimeText(states[i].next_check_at) + "|" + ASC_DateTimeText(states[i].last_tick_seen_at) + "|" + ASC_DateTimeText(states[i].last_checked_at) + "|" + IntegerToString(states[i].uncertain_burst_count) + "|" + states[i].status_note + "|" + states[i].next_check_reason + "\r\n";
     }
   bool ok=ASC_AtomicWrite(paths.scheduler_state_file,body,logger);
   if(ok)
      logger.Info("SchedulerState","saved scheduler state");
   return(ok);
  }

bool ASC_SaveSummary(const ASC_ServerPaths &paths,ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count,ASC_Logger &logger)
  {
   datetime saved_at=TimeCurrent();
   int open_count=0;
   int closed_count=0;
   int uncertain_count=0;
   int unknown_count=0;
   int due_count=0;
   for(int i=0;i<count;i++)
     {
      if(states[i].dirty || states[i].next_check_at<=runtime.last_heartbeat_at)
         due_count++;
      switch(states[i].market_status)
        {
         case ASC_MARKET_OPEN: open_count++; break;
         case ASC_MARKET_CLOSED: closed_count++; break;
         case ASC_MARKET_UNCERTAIN: uncertain_count++; break;
         default: unknown_count++; break;
        }
     }

   string body="Summary Top 5 per Basket\r\n\r\n";
   body+="Product: " + ASC_PRODUCT_NAME + "\r\n";
   body+="Wrapper Version: " + ASC_WRAPPER_VERSION + "\r\n";
   body+="Schema Version: ASC Foundation v1\r\n";
   body+="Generated At: " + ASC_DateTimeText(saved_at) + "\r\n";
   body+="Server: " + runtime.server_clean + "\r\n";
   body+="Runtime Mode: " + ASC_RuntimeModeText(runtime.mode) + "\r\n";
   body+="Degraded: " + ASC_BoolText(runtime.degraded) + "\r\n";
   body+="Last Heartbeat: " + ASC_DateTimeText(runtime.last_heartbeat_at) + "\r\n";
   body+="Universe Size: " + IntegerToString(count) + "\r\n";
   body+="Due Now: " + IntegerToString(due_count) + "\r\n";
   body+="Open: " + IntegerToString(open_count) + "\r\n";
   body+="Closed: " + IntegerToString(closed_count) + "\r\n";
   body+="Uncertain: " + IntegerToString(uncertain_count) + "\r\n";
   body+="Unknown: " + IntegerToString(unknown_count) + "\r\n\r\n";
   body+="Market State Detection is working. Symbol Identity and Bucketing, selection, summary ranking, and signal surfaces remain Reserved.\r\n";
   bool ok=ASC_AtomicWrite(paths.summary_file,body,logger);
   if(ok)
     {
      runtime.last_summary_save_at=saved_at;
      runtime.summary_dirty=false;
      logger.Info("Summary","saved summary scaffold");
     }
   return(ok);
  }

#endif
