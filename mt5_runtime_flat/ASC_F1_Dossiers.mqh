#ifndef __ASC_F1_DOSSIERS_MQH__
#define __ASC_F1_DOSSIERS_MQH__

#include "ASC_F1_Common.mqh"
#include "ASC_F1_FileIO.mqh"

string ASC_F1_BuildDossierText(const ASC_F1_ServerPaths &paths,const ASC_F1_RuntimeState &runtime,const ASC_F1_SymbolState &state)
  {
   string body="";
   body+="Aurora Sentinel Symbol Dossier\r\n";
   body+="========================================\r\n\r\n";
   body+="Symbol Identity\r\n";
   body+="----------------------------------------\r\n";
   body+="Symbol: " + state.symbol + "\r\n";
   body+="Server: " + paths.server_clean + "\r\n";
   body+="Dossier File: " + state.dossier_file + "\r\n\r\n";

   body+="Market Status\r\n";
   body+="----------------------------------------\r\n";
   body+="Current Status: " + ASC_F1_MarketStatusText(state.market_status) + "\r\n";
   body+="Status Note: " + (state.status_note=="" ? "Pending" : state.status_note) + "\r\n";
   body+="Last Tick Seen: " + ASC_F1_DateTimeText(state.last_tick_seen_at) + "\r\n";
   body+="Next Check: " + ASC_F1_DateTimeText(state.next_check_at) + "\r\n\r\n";

   body+="Session State\r\n";
   body+="----------------------------------------\r\n";
   body+="Trade Sessions Available: " + ASC_F1_BoolText(state.has_trade_sessions) + "\r\n";
   body+="Within Trade Session: " + ASC_F1_BoolText(state.within_trade_session) + "\r\n";
   body+="Next Session Open: " + ASC_F1_DateTimeText(state.next_session_open_at) + "\r\n\r\n";

   body+="Runtime Health\r\n";
   body+="----------------------------------------\r\n";
   body+="Runtime Mode: " + ASC_F1_RuntimeModeText(runtime.mode) + "\r\n";
   body+="Heartbeat: " + ASC_F1_DateTimeText(runtime.last_heartbeat_at) + "\r\n";
   body+="Universe Sync: " + ASC_F1_DateTimeText(runtime.last_universe_sync_at) + "\r\n";
   body+="Recovery Used: " + ASC_F1_BoolText(runtime.recovery_used) + "\r\n\r\n";

   body+="Heartbeat State\r\n";
   body+="----------------------------------------\r\n";
   body+="Last Checked: " + ASC_F1_DateTimeText(state.last_checked_at) + "\r\n";
   body+="Scheduler Due: " + ASC_F1_DateTimeText(state.next_check_at) + "\r\n\r\n";

   body+="Tick Activity\r\n";
   body+="----------------------------------------\r\n";
   body+="Tick Present: " + ASC_F1_BoolText(state.has_tick) + "\r\n";
   body+="Tick Age Seconds: " + (state.tick_age_seconds>=0 ? IntegerToString((int)state.tick_age_seconds) : "Not Yet Available") + "\r\n\r\n";

   body+="Price History\r\n";
   body+="----------------------------------------\r\n";
   body+="Reserved for future OHLC and timeframe sections.\r\n\r\n";

   body+="Scheduler State\r\n";
   body+="----------------------------------------\r\n";
   body+="Current Status: " + ASC_F1_MarketStatusText(state.market_status) + "\r\n";
   body+="Next Due: " + ASC_F1_DateTimeText(state.next_check_at) + "\r\n";
   body+="Burst Count: " + IntegerToString(state.uncertain_burst_count) + "\r\n\r\n";

   body+="Future Sections\r\n";
   body+="----------------------------------------\r\n";
   body+="Selection Status: Reserved\r\n";
   body+="Deep Analysis: Reserved\r\n";
   body+="Basket Summary: Reserved\r\n";

   return(body);
  }

bool ASC_F1_WriteDossier(const ASC_F1_ServerPaths &paths,const ASC_F1_RuntimeState &runtime,ASC_F1_SymbolState &state,ASC_F1_Logger &logger)
  {
   string final_path=ASC_F1_JoinPath(paths.universe_folder,state.dossier_file);
   string text=ASC_F1_BuildDossierText(paths,runtime,state);
   bool ok=ASC_F1_AtomicWrite(final_path,text,logger);
   if(ok)
     {
      state.last_dossier_write_at=TimeCurrent();
      state.dirty=false;
      logger.Info("Dossier","wrote dossier for " + state.symbol);
     }
   return(ok);
  }

#endif
