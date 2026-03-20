#property strict

#include "ASC_Common.mqh"
#include "ASC_ServerPaths.mqh"
#include "ASC_Logging.mqh"
#include "ASC_FileIO.mqh"
#include "ASC_MarketState.mqh"
#include "ASC_Persistence.mqh"
#include "ASC_Dossiers.mqh"

#define ASC_HEARTBEAT_SECONDS 1
#define ASC_UNIVERSE_SYNC_SECONDS 300
#define ASC_RUNTIME_SAVE_SECONDS 30
#define ASC_SCHEDULER_SAVE_SECONDS 15
#define ASC_SUMMARY_SAVE_SECONDS 60
#define ASC_HEARTBEAT_SYMBOL_BUDGET 25

ASC_ServerPaths g_paths;
ASC_RuntimeState g_runtime;
ASC_Logger g_logger;
ASC_SymbolState g_symbols[];
int g_symbol_count=0;
bool g_heartbeat_running=false;

void ASC_ResetRuntimeState(void)
  {
   g_runtime.schema_version="ASC Foundation v1";
   g_runtime.server_raw="";
   g_runtime.server_clean="";
   g_runtime.mode=ASC_RUNTIME_BOOT;
   g_runtime.boot_at=0;
   g_runtime.last_heartbeat_at=0;
   g_runtime.last_universe_sync_at=0;
   g_runtime.last_runtime_save_at=0;
   g_runtime.last_scheduler_save_at=0;
   g_runtime.last_summary_save_at=0;
   g_runtime.recovery_used=false;
   g_runtime.degraded=false;
   g_runtime.runtime_dirty=true;
   g_runtime.scheduler_dirty=true;
   g_runtime.summary_dirty=true;
   g_runtime.symbol_count=0;
   g_runtime.processed_this_heartbeat=0;
   g_runtime.scheduler_cursor=0;
   g_runtime.heartbeats_since_boot=0;
  }

void ASC_ResetSymbolState(ASC_SymbolState &state,const string symbol)
  {
   state.symbol=symbol;
   state.dossier_file=ASC_DossierFileName(symbol);
   state.has_tick=false;
   state.has_trade_sessions=false;
   state.within_trade_session=false;
   state.market_status=ASC_MARKET_UNKNOWN;
   state.last_tick_seen_at=0;
   state.tick_age_seconds=-1;
   state.next_check_at=TimeCurrent();
   state.next_session_open_at=0;
   state.last_checked_at=0;
   state.last_dossier_write_at=0;
   state.uncertain_burst_count=0;
   state.status_note="Pending initial assessment";
   state.dirty=true;
  }

void ASC_ApplyRestoredRuntimeDefaults(void)
  {
   if(g_runtime.schema_version=="")
      g_runtime.schema_version="ASC Foundation v1";
   g_runtime.server_raw=g_paths.server_raw;
   g_runtime.server_clean=g_paths.server_clean;
   g_runtime.runtime_dirty=true;
   g_runtime.scheduler_dirty=true;
   g_runtime.summary_dirty=true;
  }

bool ASC_IsDossierPresent(const ASC_SymbolState &state)
  {
   string dossier_path=ASC_JoinPath(g_paths.universe_folder,state.dossier_file);
   return(FileIsExist(dossier_path,FILE_COMMON));
  }

void ASC_SyncUniverse(void)
  {
   int total=SymbolsTotal(false);
   ArrayResize(g_symbols,total);
   g_symbol_count=total;

   for(int i=0;i<total;i++)
     {
      string symbol=SymbolName(i,false);
      if(g_symbols[i].symbol!=symbol)
         ASC_ResetSymbolState(g_symbols[i],symbol);
      else
        {
         g_symbols[i].symbol=symbol;
         g_symbols[i].dossier_file=ASC_DossierFileName(symbol);
         if(g_symbols[i].next_check_at<=0)
            g_symbols[i].next_check_at=TimeCurrent();
        }
      if(!ASC_IsDossierPresent(g_symbols[i]))
         g_symbols[i].dirty=true;
     }

   g_runtime.symbol_count=total;
   g_runtime.last_universe_sync_at=TimeCurrent();
   g_runtime.runtime_dirty=true;
   g_runtime.scheduler_dirty=true;
   g_runtime.summary_dirty=true;
   g_logger.Info("Universe","synced " + IntegerToString(total) + " symbols");
  }

void ASC_RestoreContinuity(void)
  {
   bool runtime_restored=ASC_LoadRuntimeState(g_paths,g_runtime,g_logger);
   ASC_ApplyRestoredRuntimeDefaults();
   g_runtime.recovery_used=runtime_restored || FileIsExist(g_paths.scheduler_state_file,FILE_COMMON) || FileIsExist(g_paths.scheduler_state_file + ".last-good",FILE_COMMON);
   ASC_SyncUniverse();
   if(ASC_LoadSchedulerState(g_paths,g_symbols,g_symbol_count,g_logger))
      g_runtime.scheduler_dirty=true;
   g_logger.Info("Recovery",(g_runtime.recovery_used ? "continuity available" : "no prior continuity found"));
  }

bool ASC_ShouldSaveRuntime(const datetime now)
  {
   return(g_runtime.runtime_dirty || g_runtime.last_runtime_save_at<=0 || (now-g_runtime.last_runtime_save_at)>=ASC_RUNTIME_SAVE_SECONDS);
  }

bool ASC_ShouldSaveScheduler(const datetime now)
  {
   return(g_runtime.scheduler_dirty || g_runtime.last_scheduler_save_at<=0 || (now-g_runtime.last_scheduler_save_at)>=ASC_SCHEDULER_SAVE_SECONDS);
  }

bool ASC_ShouldSaveSummary(const datetime now)
  {
   return(g_runtime.summary_dirty || g_runtime.last_summary_save_at<=0 || (now-g_runtime.last_summary_save_at)>=ASC_SUMMARY_SAVE_SECONDS);
  }

int ASC_CountMissingDossiers(void)
  {
   int missing=0;
   for(int i=0;i<g_symbol_count;i++)
     {
      if(!ASC_IsDossierPresent(g_symbols[i]))
         missing++;
     }
   return(missing);
  }

void ASC_UpdateRuntimeMode(const int missing_dossiers)
  {
   if(g_runtime.degraded)
     {
      g_runtime.mode=ASC_RUNTIME_DEGRADED;
      return;
     }

   if(missing_dossiers>0)
      g_runtime.mode=ASC_RUNTIME_WARMUP;
   else
      g_runtime.mode=ASC_RUNTIME_STEADY;
  }

void ASC_RunHeartbeat(void)
  {
   if(g_heartbeat_running)
     {
      g_logger.Warn("Heartbeat","skipped re-entry while prior heartbeat was still running");
      return;
     }
   g_heartbeat_running=true;

   datetime now=TimeTradeServer();
   if(now<=0)
      now=TimeCurrent();

   g_runtime.last_heartbeat_at=now;
   g_runtime.processed_this_heartbeat=0;
   g_runtime.heartbeats_since_boot++;

   if(g_symbol_count==0 || (now-g_runtime.last_universe_sync_at)>=ASC_UNIVERSE_SYNC_SECONDS)
      ASC_SyncUniverse();

   int start=(g_symbol_count>0 ? (g_runtime.scheduler_cursor % g_symbol_count) : 0);
   for(int offset=0; offset<g_symbol_count && g_runtime.processed_this_heartbeat<ASC_HEARTBEAT_SYMBOL_BUDGET; offset++)
     {
      int index=(start + offset) % g_symbol_count;
      if(g_symbols[index].next_check_at>now && !g_symbols[index].dirty)
         continue;

      ASC_AssessSymbol(g_symbols[index].symbol,g_symbols[index]);
      if(ASC_WriteDossier(g_paths,g_runtime,g_symbols[index],g_logger))
        {
         g_runtime.processed_this_heartbeat++;
         g_runtime.scheduler_cursor=index+1;
         g_runtime.scheduler_dirty=true;
         g_runtime.summary_dirty=true;
        }
     }

   g_runtime.degraded=(g_runtime.processed_this_heartbeat>=ASC_HEARTBEAT_SYMBOL_BUDGET && g_symbol_count>ASC_HEARTBEAT_SYMBOL_BUDGET);
   ASC_UpdateRuntimeMode(ASC_CountMissingDossiers());
   g_runtime.runtime_dirty=true;

   if(g_runtime.degraded)
      g_logger.Warn("Heartbeat","bounded work cap reached; remaining symbols will roll forward next heartbeat");

   if(ASC_ShouldSaveRuntime(now))
     {
      g_runtime.last_runtime_save_at=now;
      ASC_SaveRuntimeState(g_paths,g_runtime,g_logger);
     }

   if(ASC_ShouldSaveScheduler(now))
     {
      g_runtime.last_scheduler_save_at=now;
      if(ASC_SaveSchedulerState(g_paths,g_symbols,g_symbol_count,g_logger))
         g_runtime.scheduler_dirty=false;
     }

   if(ASC_ShouldSaveSummary(now))
     {
      g_runtime.last_summary_save_at=now;
      ASC_SaveSummary(g_paths,g_runtime,g_symbols,g_symbol_count,g_logger);
     }

   g_heartbeat_running=false;
  }

int OnInit()
  {
   ASC_ResetRuntimeState();
   if(!ASC_ResolveServerPaths(g_paths))
      return(INIT_FAILED);

   g_logger.Configure(g_paths.log_file);
   g_runtime.boot_at=TimeCurrent();
   g_runtime.mode=ASC_RUNTIME_RECOVERING;
   g_logger.Info("Init","foundation starting on server " + g_paths.server_clean);

   ASC_RestoreContinuity();
   EventSetTimer(ASC_HEARTBEAT_SECONDS);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
   g_runtime.last_heartbeat_at=TimeCurrent();
   g_runtime.last_runtime_save_at=g_runtime.last_heartbeat_at;
   g_runtime.last_scheduler_save_at=g_runtime.last_heartbeat_at;
   g_runtime.last_summary_save_at=g_runtime.last_heartbeat_at;
   g_runtime.runtime_dirty=true;
   g_runtime.scheduler_dirty=true;
   g_runtime.summary_dirty=true;
   ASC_SaveRuntimeState(g_paths,g_runtime,g_logger);
   ASC_SaveSchedulerState(g_paths,g_symbols,g_symbol_count,g_logger);
   ASC_SaveSummary(g_paths,g_runtime,g_symbols,g_symbol_count,g_logger);
   g_logger.Info("Deinit","foundation stopping with reason " + IntegerToString(reason));
  }

void OnTick()
  {
  }

void OnTimer()
  {
   ASC_RunHeartbeat();
  }
