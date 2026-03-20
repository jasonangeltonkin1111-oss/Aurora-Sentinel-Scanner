#ifndef __ASC_F1_PERSISTENCE_MQH__
#define __ASC_F1_PERSISTENCE_MQH__

#include "ASC_F1_Common.mqh"
#include "ASC_F1_FileIO.mqh"

bool ASC_F1_SaveRuntimeState(const ASC_F1_ServerPaths &paths,const ASC_F1_RuntimeState &state,ASC_F1_Logger &logger)
  {
   string body="";
   body+="Server Raw=" + state.server_raw + "\r\n";
   body+="Server Clean=" + state.server_clean + "\r\n";
   body+="Runtime Mode=" + ASC_F1_RuntimeModeText(state.mode) + "\r\n";
   body+="Boot At=" + ASC_F1_DateTimeText(state.boot_at) + "\r\n";
   body+="Last Heartbeat=" + ASC_F1_DateTimeText(state.last_heartbeat_at) + "\r\n";
   body+="Last Universe Sync=" + ASC_F1_DateTimeText(state.last_universe_sync_at) + "\r\n";
   body+="Last Runtime Save=" + ASC_F1_DateTimeText(state.last_runtime_save_at) + "\r\n";
   body+="Last Scheduler Save=" + ASC_F1_DateTimeText(state.last_scheduler_save_at) + "\r\n";
   body+="Last Summary Save=" + ASC_F1_DateTimeText(state.last_summary_save_at) + "\r\n";
   body+="Recovery Used=" + ASC_F1_BoolText(state.recovery_used) + "\r\n";
   body+="Degraded=" + ASC_F1_BoolText(state.degraded) + "\r\n";
   body+="Symbol Count=" + IntegerToString(state.symbol_count) + "\r\n";
   body+="Processed This Heartbeat=" + IntegerToString(state.processed_this_heartbeat) + "\r\n";
   bool ok=ASC_F1_AtomicWrite(paths.runtime_state_file,body,logger);
   if(ok)
      logger.Info("RuntimeState","saved runtime state");
   return(ok);
  }

bool ASC_F1_SaveSchedulerState(const ASC_F1_ServerPaths &paths,ASC_F1_SymbolState &states[],const int count,ASC_F1_Logger &logger)
  {
   string body="Scheduler State\r\n\r\n";
   for(int i=0;i<count;i++)
     {
      body+=states[i].symbol + "|" + ASC_F1_MarketStatusText(states[i].market_status) + "|" + ASC_F1_DateTimeText(states[i].next_check_at) + "|" + ASC_F1_DateTimeText(states[i].last_tick_seen_at) + "|" + states[i].status_note + "\r\n";
     }
   bool ok=ASC_F1_AtomicWrite(paths.scheduler_state_file,body,logger);
   if(ok)
      logger.Info("SchedulerState","saved scheduler state");
   return(ok);
  }

bool ASC_F1_SaveSummary(const ASC_F1_ServerPaths &paths,ASC_F1_RuntimeState &runtime,ASC_F1_SymbolState &states[],const int count,ASC_F1_Logger &logger)
  {
   int open_count=0;
   int closed_count=0;
   int uncertain_count=0;
   int unknown_count=0;
   for(int i=0;i<count;i++)
     {
      switch(states[i].market_status)
        {
         case ASC_F1_MARKET_OPEN: open_count++; break;
         case ASC_F1_MARKET_CLOSED: closed_count++; break;
         case ASC_F1_MARKET_UNCERTAIN: uncertain_count++; break;
         default: unknown_count++; break;
        }
     }

   string body="Summary Top 5 per Basket\r\n\r\n";
   body+="Server: " + runtime.server_clean + "\r\n";
   body+="Last Heartbeat: " + ASC_F1_DateTimeText(runtime.last_heartbeat_at) + "\r\n";
   body+="Universe Size: " + IntegerToString(count) + "\r\n";
   body+="Open: " + IntegerToString(open_count) + "\r\n";
   body+="Closed: " + IntegerToString(closed_count) + "\r\n";
   body+="Uncertain: " + IntegerToString(uncertain_count) + "\r\n";
   body+="Unknown: " + IntegerToString(unknown_count) + "\r\n\r\n";
   body+="Ranking and basket selection are Reserved for a later build pass.\r\n";
   bool ok=ASC_F1_AtomicWrite(paths.summary_file,body,logger);
   if(ok)
      logger.Info("Summary","saved summary scaffold");
   return(ok);
  }

#endif
