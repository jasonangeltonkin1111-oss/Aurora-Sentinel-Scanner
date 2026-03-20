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
      if(part_count<7)
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
      body+=states[i].symbol + "|" + ASC_MarketStatusText(states[i].market_status) + "|" + ASC_DateTimeText(states[i].next_check_at) + "|" + ASC_DateTimeText(states[i].last_tick_seen_at) + "|" + ASC_DateTimeText(states[i].last_checked_at) + "|" + IntegerToString(states[i].uncertain_burst_count) + "|" + states[i].status_note + "\r\n";
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
   for(int i=0;i<count;i++)
     {
      switch(states[i].market_status)
        {
         case ASC_MARKET_OPEN: open_count++; break;
         case ASC_MARKET_CLOSED: closed_count++; break;
         case ASC_MARKET_UNCERTAIN: uncertain_count++; break;
         default: unknown_count++; break;
        }
     }

   string body="Summary Top 5 per Basket\r\n\r\n";
   body+="Schema Version: ASC Foundation v1\r\n";
   body+="Generated At: " + ASC_DateTimeText(saved_at) + "\r\n";
   body+="Server: " + runtime.server_clean + "\r\n";
   body+="Runtime Mode: " + ASC_RuntimeModeText(runtime.mode) + "\r\n";
   body+="Degraded: " + ASC_BoolText(runtime.degraded) + "\r\n";
   body+="Last Heartbeat: " + ASC_DateTimeText(runtime.last_heartbeat_at) + "\r\n";
   body+="Universe Size: " + IntegerToString(count) + "\r\n";
   body+="Open: " + IntegerToString(open_count) + "\r\n";
   body+="Closed: " + IntegerToString(closed_count) + "\r\n";
   body+="Uncertain: " + IntegerToString(uncertain_count) + "\r\n";
   body+="Unknown: " + IntegerToString(unknown_count) + "\r\n\r\n";
   body+="Ranking and basket selection are Reserved for a later build pass.\r\n";
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
