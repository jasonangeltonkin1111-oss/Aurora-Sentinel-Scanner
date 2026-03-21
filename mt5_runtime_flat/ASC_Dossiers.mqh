#ifndef __ASC_DOSSIERS_MQH__
#define __ASC_DOSSIERS_MQH__

#include "ASC_Common.mqh"
#include "ASC_FileIO.mqh"

string ASC_BuildDossierText(const ASC_ServerPaths &paths,const ASC_RuntimeState &runtime,const ASC_SymbolState &state)
  {
   string body="";
   body+="Aurora Sentinel Symbol Dossier\r\n";
   body+="========================================\r\n\r\n";
   body+="Publication Metadata\r\n";
   body+="----------------------------------------\r\n";
   body+="Product: " + ASC_PRODUCT_NAME + "\r\n";
   body+="Wrapper Version: " + ASC_WRAPPER_VERSION + "\r\n";
   body+="Explorer Subsystem Version: " + ASC_EXPLORER_SUBSYSTEM_VERSION + "\r\n";
   body+="Schema Family: " + ASC_SCHEMA_FAMILY + "\r\n";
   body+="Schema Version: ASC Foundation v1\r\n";
   body+="Active Capability: " + ASC_ACTIVE_CAPABILITY + "\r\n";
   body+="Next Planned Capability: " + ASC_NEXT_CAPABILITY + "\r\n";
   body+="Runtime Posture: " + ASC_RUNTIME_POSTURE + "\r\n";
   body+="Update Discipline: " + ASC_UpdateBumpLawText() + "\r\n";
   body+="Generated At: " + ASC_DateTimeText(TimeCurrent()) + "\r\n";
   body+="Runtime Mode: " + ASC_RuntimeModeText(runtime.mode) + "\r\n\r\n";

   body+="Symbol Identity\r\n";
   body+="----------------------------------------\r\n";
   body+="Symbol: " + state.symbol + "\r\n";
   body+="Server: " + paths.server_clean + "\r\n";
   body+="Dossier File: " + state.dossier_file + "\r\n\r\n";

   body+="Market Status\r\n";
   body+="----------------------------------------\r\n";
   body+="Current Status: " + ASC_MarketStatusText(state.market_status) + "\r\n";
   body+="Status Note: " + (state.status_note=="" ? "Pending" : state.status_note) + "\r\n";
   body+="Last Tick Seen: " + ASC_DateTimeText(state.last_tick_seen_at) + "\r\n";
   body+="Tick Age Seconds: " + (state.tick_age_seconds>=0 ? IntegerToString((int)state.tick_age_seconds) : "Not Yet Available") + "\r\n";
   body+="Next Check: " + ASC_DateTimeText(state.next_check_at) + "\r\n";
   body+="Next Check Reason: " + state.next_check_reason + "\r\n\r\n";

   body+="Session State\r\n";
   body+="----------------------------------------\r\n";
   body+="Trade Sessions Available: " + ASC_BoolText(state.has_trade_sessions) + "\r\n";
   body+="Within Trade Session: " + ASC_BoolText(state.within_trade_session) + "\r\n";
   body+="Next Session Open: " + ASC_DateTimeText(state.next_session_open_at) + "\r\n\r\n";

   body+="Runtime Health\r\n";
   body+="----------------------------------------\r\n";
   body+="Last Heartbeat: " + ASC_DateTimeText(runtime.last_heartbeat_at) + "\r\n";
   body+="Universe Sync: " + ASC_DateTimeText(runtime.last_universe_sync_at) + "\r\n";
   body+="Recovery Used: " + ASC_BoolText(runtime.recovery_used) + "\r\n";
   body+="Degraded Runtime: " + ASC_BoolText(runtime.degraded) + "\r\n\r\n";

   body+="Scheduler State\r\n";
   body+="----------------------------------------\r\n";
   body+="Last Checked: " + ASC_DateTimeText(state.last_checked_at) + "\r\n";
   body+="Next Due: " + ASC_DateTimeText(state.next_check_at) + "\r\n";
   body+="Next Due Reason: " + state.next_check_reason + "\r\n";
   body+="Uncertain Burst Count: " + IntegerToString(state.uncertain_burst_count) + "\r\n";
   body+="Publication State: " + (state.publication_ok ? "Last write promoted" : "Awaiting a successful dossier promotion") + "\r\n\r\n";

   body+="Capability Progress\r\n";
   body+="----------------------------------------\r\n";
   body+="Market State Detection: Working\r\n";
   body+="Symbol Identity and Bucketing: Reserved\r\n";
   body+="Open Symbol Snapshot: Reserved\r\n";
   body+="Candidate Filtering: Reserved\r\n";
   body+="Shortlist Selection: Reserved\r\n";
   body+="Deep Selective Analysis: Reserved\r\n";
   body+="Combined Opportunity Summary: Reserved\r\n";
   body+="Future Signal Surface: Reserved\r\n\r\n";

   body+="Tick Activity\r\n";
   body+="----------------------------------------\r\n";
   body+="Tick Present: " + ASC_BoolText(state.has_tick) + "\r\n";
   body+="Tick Age Seconds: " + (state.tick_age_seconds>=0 ? IntegerToString((int)state.tick_age_seconds) : "Not Yet Available") + "\r\n\r\n";

   body+="Future Sections\r\n";
   body+="----------------------------------------\r\n";
   body+="Bucket Identity: Reserved\r\n";
   body+="Open Symbol Snapshot: Reserved\r\n";
   body+="Selection Status: Reserved\r\n";
   body+="Deep Analysis: Reserved\r\n";
   body+="Combined Opportunity Summary: Reserved\r\n";
   body+="Future Signal Surface: Reserved\r\n";
   return(body);
  }

bool ASC_WriteDossier(const ASC_ServerPaths &paths,const ASC_RuntimeState &runtime,ASC_SymbolState &state,ASC_Logger &logger)
  {
   string final_path=ASC_JoinPath(paths.universe_folder,state.dossier_file);
   string text=ASC_BuildDossierText(paths,runtime,state);
   bool ok=ASC_AtomicWrite(final_path,text,logger);
   if(ok)
     {
      state.last_dossier_write_at=TimeCurrent();
      state.publication_ok=true;
      state.dirty=false;
      logger.Debug("Dossier","promoted dossier for " + state.symbol + " to " + final_path);
     }
   else
     {
      state.publication_ok=false;
      logger.Error("Dossier","failed to promote dossier for " + state.symbol + " to " + final_path);
     }
   return(ok);
  }

#endif
