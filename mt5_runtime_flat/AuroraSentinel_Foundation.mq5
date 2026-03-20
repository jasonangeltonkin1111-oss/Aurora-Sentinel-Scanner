#property strict

#include "ASC_F1_Common.mqh"
#include "ASC_F1_ServerPaths.mqh"
#include "ASC_F1_Logging.mqh"
#include "ASC_F1_FileIO.mqh"
#include "ASC_F1_MarketState.mqh"
#include "ASC_F1_Persistence.mqh"
#include "ASC_F1_Dossiers.mqh"

ASC_F1_ServerPaths g_paths;
ASC_F1_RuntimeState g_runtime;
ASC_F1_Logger g_logger;
ASC_F1_SymbolState g_symbols[];
int g_symbol_count=0;

void ASC_F1_SyncUniverse(void)
  {
   int total=SymbolsTotal(false);
   ArrayResize(g_symbols,total);
   g_symbol_count=total;
   for(int i=0;i<total;i++)
     {
      string symbol=SymbolName(i,false);
      g_symbols[i].symbol=symbol;
      g_symbols[i].dossier_file=ASC_F1_DossierFileName(symbol);
      g_symbols[i].dirty=true;
     }
   g_runtime.symbol_count=total;
   g_runtime.last_universe_sync_at=TimeCurrent();
   g_logger.Info("Universe","synced " + IntegerToString(total) + " symbols");
  }

void ASC_F1_RunHeartbeat(void)
  {
   datetime now=TimeCurrent();
   g_runtime.last_heartbeat_at=now;
   g_runtime.processed_this_heartbeat=0;

   if(g_symbol_count==0 || (now-g_runtime.last_universe_sync_at)>=300)
      ASC_F1_SyncUniverse();

   for(int i=0;i<g_symbol_count;i++)
     {
      if(g_symbols[i].next_check_at>now && !g_symbols[i].dirty)
         continue;
      ASC_F1_AssessSymbol(g_symbols[i].symbol,g_symbols[i]);
      ASC_F1_WriteDossier(g_paths,g_runtime,g_symbols[i],g_logger);
      g_runtime.processed_this_heartbeat++;
      if(g_runtime.processed_this_heartbeat>=25)
         break;
     }

   g_runtime.mode=ASC_F1_RUNTIME_STEADY;
   g_runtime.last_runtime_save_at=now;
   g_runtime.last_scheduler_save_at=now;
   g_runtime.last_summary_save_at=now;
   ASC_F1_SaveRuntimeState(g_paths,g_runtime,g_logger);
   ASC_F1_SaveSchedulerState(g_paths,g_symbols,g_symbol_count,g_logger);
   ASC_F1_SaveSummary(g_paths,g_runtime,g_symbols,g_symbol_count,g_logger);
  }

int OnInit()
  {
   if(!ASC_F1_ResolveServerPaths(g_paths))
      return(INIT_FAILED);

   g_logger.Configure(g_paths.log_file);
   g_runtime.server_raw=g_paths.server_raw;
   g_runtime.server_clean=g_paths.server_clean;
   g_runtime.mode=ASC_F1_RUNTIME_RECOVERING;
   g_runtime.boot_at=TimeCurrent();
   g_runtime.recovery_used=FileIsExist(g_paths.runtime_state_file,FILE_COMMON) || FileIsExist(g_paths.scheduler_state_file,FILE_COMMON);
   g_runtime.degraded=false;
   g_runtime.last_universe_sync_at=0;
   g_runtime.last_runtime_save_at=0;
   g_runtime.last_scheduler_save_at=0;
   g_runtime.last_summary_save_at=0;
   g_logger.Info("Init","foundation starting on server " + g_paths.server_clean);

   ASC_F1_SyncUniverse();
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
   g_runtime.last_heartbeat_at=TimeCurrent();
   ASC_F1_SaveRuntimeState(g_paths,g_runtime,g_logger);
   ASC_F1_SaveSchedulerState(g_paths,g_symbols,g_symbol_count,g_logger);
   ASC_F1_SaveSummary(g_paths,g_runtime,g_symbols,g_symbol_count,g_logger);
   g_logger.Info("Deinit","foundation stopping with reason " + IntegerToString(reason));
  }

void OnTick()
  {
  }

void OnTimer()
  {
   ASC_F1_RunHeartbeat();
  }
