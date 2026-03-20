#property strict

#include "ASC_Common.mqh"
#include "ASC_ServerPaths.mqh"
#include "ASC_Logging.mqh"
#include "ASC_FileIO.mqh"
#include "ASC_MarketState.mqh"
#include "ASC_Persistence.mqh"
#include "ASC_Dossiers.mqh"

input group "Runtime"
input int InpHeartbeatSeconds=1;                       // Heartbeat Interval Seconds
input int InpUniverseSyncSeconds=300;                 // Universe Sync Interval Seconds
input int InpSymbolBudgetPerHeartbeat=25;             // Symbol Budget Per Heartbeat

input group "Scheduler"
input int InpFreshTickSeconds=90;                     // Fresh Tick Threshold Seconds
input int InpUncertainBurstLimit=6;                   // Uncertain Burst Limit
input int InpUncertainFastRecheckSeconds=5;           // Uncertain Fast Recheck Seconds
input int InpUncertainSlowRecheckSeconds=30;          // Uncertain Slow Recheck Seconds
input int InpClosedNearOpenWindowSeconds=60;          // Near Open Window Seconds
input int InpClosedNearOpenRecheckSeconds=5;          // Near Open Recheck Seconds
input int InpClosedSoonWindowSeconds=900;             // Closed Soon Window Seconds
input int InpClosedSoonRecheckSeconds=60;             // Closed Soon Recheck Seconds
input int InpClosedIdleRecheckSeconds=300;            // Closed Idle Recheck Seconds
input int InpUnknownRecheckSeconds=120;               // Unknown State Recheck Seconds

input group "Recovery & Persistence"
input int InpRuntimeSaveSeconds=30;                   // Runtime Save Interval Seconds
input int InpSchedulerSaveSeconds=15;                 // Scheduler Save Interval Seconds
input int InpSummarySaveSeconds=60;                   // Summary Save Interval Seconds
input bool InpRepairMissingDossiersOnBoot=true;       // Repair Missing Dossiers On Boot

input group "Logging"
input int InpLogVerbosity=1;                          // Log Verbosity: 0 Errors, 1 Normal, 2 Debug
input bool InpLogSchedulerDecisions=true;             // Log Scheduler Decisions
input bool InpLogRecoveryEvents=true;                 // Log Recovery Events
input bool InpLogDossierRepairs=true;                 // Log Dossier Repairs

input group "Symbol Dossiers"
input bool InpWriteDossiersWhenDue=true;              // Write Dossiers When Due
input bool InpIncludePendingLayerPlaceholders=true;   // Include Pending Layer Placeholders

input group "Snapshot Controls (Pending)"
input bool InpReserveLayer2SnapshotControls=true;     // Reserved: Layer 2 Snapshot Controls
input bool InpReserveSnapshotControls=true;           // Reserved: Snapshot Controls Active Later

input group "Timeframe History (Pending)"
input bool InpReserveTimeframeHistoryControls=true;   // Reserved: Timeframe History Active Later
input int InpReservedM1Bars=500;                      // Reserved: M1 Bars
input int InpReservedM5Bars=500;                      // Reserved: M5 Bars
input int InpReservedM15Bars=500;                     // Reserved: M15 Bars
input int InpReservedH1Bars=500;                      // Reserved: H1 Bars
input int InpReservedH4Bars=300;                      // Reserved: H4 Bars
input int InpReservedD1Bars=300;                      // Reserved: D1 Bars

input group "Deep Analysis (Pending)"
input bool InpReserveLayer5Controls=true;             // Reserved: Deep Analysis Controls
input bool InpReserveDeepAnalysisControls=true;       // Reserved: Deep Analysis Active Later

input group "Future Selection / Ranking (Pending)"
input bool InpReserveLayer3FilterControls=true;       // Reserved: Layer 3 Filter Controls
input bool InpReserveLayer4SelectionControls=true;    // Reserved: Layer 4 Selection Controls
input bool InpReserveSelectionControls=true;          // Reserved: Selection Controls Active Later
input int InpReservedSelectedSymbolLimit=25;          // Reserved: Selected Symbol Limit

ASC_ServerPaths g_paths;
ASC_RuntimeSettings g_settings;
ASC_RuntimeState g_runtime;
ASC_Logger g_logger;
ASC_SymbolState g_symbols[];
int g_symbol_count=0;
bool g_heartbeat_running=false;

ASC_LogVerbosity ASC_InputVerbosity(const int value)
  {
   if(value<=0)
      return(ASC_LOG_ERRORS_ONLY);
   if(value>=2)
      return(ASC_LOG_DEBUG);
   return(ASC_LOG_NORMAL);
  }

void ASC_LoadSettingsFromInputs(void)
  {
   g_settings.heartbeat_seconds=(InpHeartbeatSeconds>0 ? InpHeartbeatSeconds : 1);
   g_settings.universe_sync_seconds=(InpUniverseSyncSeconds>0 ? InpUniverseSyncSeconds : 300);
   g_settings.symbol_budget_per_heartbeat=(InpSymbolBudgetPerHeartbeat>0 ? InpSymbolBudgetPerHeartbeat : 1);
   g_settings.runtime_save_seconds=(InpRuntimeSaveSeconds>0 ? InpRuntimeSaveSeconds : 30);
   g_settings.scheduler_save_seconds=(InpSchedulerSaveSeconds>0 ? InpSchedulerSaveSeconds : 15);
   g_settings.summary_save_seconds=(InpSummarySaveSeconds>0 ? InpSummarySaveSeconds : 60);
   g_settings.fresh_tick_seconds=(InpFreshTickSeconds>0 ? InpFreshTickSeconds : 90);
   g_settings.uncertain_burst_limit=(InpUncertainBurstLimit>=0 ? InpUncertainBurstLimit : 0);
   g_settings.uncertain_fast_recheck_seconds=(InpUncertainFastRecheckSeconds>0 ? InpUncertainFastRecheckSeconds : 5);
   g_settings.uncertain_slow_recheck_seconds=(InpUncertainSlowRecheckSeconds>0 ? InpUncertainSlowRecheckSeconds : 30);
   g_settings.closed_near_open_seconds=(InpClosedNearOpenWindowSeconds>0 ? InpClosedNearOpenWindowSeconds : 60);
   g_settings.closed_near_open_recheck_seconds=(InpClosedNearOpenRecheckSeconds>0 ? InpClosedNearOpenRecheckSeconds : 5);
   g_settings.closed_soon_window_seconds=(InpClosedSoonWindowSeconds>0 ? InpClosedSoonWindowSeconds : 900);
   g_settings.closed_soon_recheck_seconds=(InpClosedSoonRecheckSeconds>0 ? InpClosedSoonRecheckSeconds : 60);
   g_settings.closed_idle_recheck_seconds=(InpClosedIdleRecheckSeconds>0 ? InpClosedIdleRecheckSeconds : 300);
   g_settings.unknown_recheck_seconds=(InpUnknownRecheckSeconds>0 ? InpUnknownRecheckSeconds : 120);
   g_settings.write_dossiers_when_due=InpWriteDossiersWhenDue;
   g_settings.repair_missing_dossiers_on_boot=InpRepairMissingDossiersOnBoot;
   g_settings.include_pending_layer_placeholders=InpIncludePendingLayerPlaceholders;
   g_settings.log_verbosity=ASC_InputVerbosity(InpLogVerbosity);
   g_settings.log_scheduler_decisions=InpLogSchedulerDecisions;
   g_settings.log_recovery_events=InpLogRecoveryEvents;
   g_settings.log_dossier_repairs=InpLogDossierRepairs;
   g_settings.layer2_snapshot_reserved=InpReserveLayer2SnapshotControls;
   g_settings.layer3_filter_reserved=InpReserveLayer3FilterControls;
   g_settings.layer4_selection_reserved=InpReserveLayer4SelectionControls;
   g_settings.layer5_deep_analysis_reserved=InpReserveLayer5Controls;
   g_settings.snapshot_controls_reserved=InpReserveSnapshotControls;
   g_settings.timeframe_history_reserved=InpReserveTimeframeHistoryControls;
   g_settings.deep_analysis_controls_reserved=InpReserveDeepAnalysisControls;
   g_settings.selection_controls_reserved=InpReserveSelectionControls;
   g_settings.reserved_m1_bars=(InpReservedM1Bars>0 ? InpReservedM1Bars : 1);
   g_settings.reserved_m5_bars=(InpReservedM5Bars>0 ? InpReservedM5Bars : 1);
   g_settings.reserved_m15_bars=(InpReservedM15Bars>0 ? InpReservedM15Bars : 1);
   g_settings.reserved_h1_bars=(InpReservedH1Bars>0 ? InpReservedH1Bars : 1);
   g_settings.reserved_h4_bars=(InpReservedH4Bars>0 ? InpReservedH4Bars : 1);
   g_settings.reserved_d1_bars=(InpReservedD1Bars>0 ? InpReservedD1Bars : 1);
   g_settings.reserved_selected_symbol_limit=(InpReservedSelectedSymbolLimit>0 ? InpReservedSelectedSymbolLimit : 1);
  }

void ASC_LogSettingsSummary(void)
  {
   g_logger.Info("Settings","heartbeat=" + IntegerToString(g_settings.heartbeat_seconds) + "s, budget=" + IntegerToString(g_settings.symbol_budget_per_heartbeat) + ", runtime save=" + IntegerToString(g_settings.runtime_save_seconds) + "s, verbosity=" + ASC_LogVerbosityText(g_settings.log_verbosity));
   g_logger.Debug("Settings","future layers reserved: snapshot=" + ASC_BoolText(g_settings.layer2_snapshot_reserved) + ", filter=" + ASC_BoolText(g_settings.layer3_filter_reserved) + ", selection=" + ASC_BoolText(g_settings.layer4_selection_reserved) + ", deep=" + ASC_BoolText(g_settings.layer5_deep_analysis_reserved));
  }

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
      if(g_settings.repair_missing_dossiers_on_boot && !ASC_IsDossierPresent(g_symbols[i]))
        {
         g_symbols[i].dirty=true;
         if(g_settings.log_dossier_repairs)
            g_logger.Info("DossierRepair","queued missing dossier repair for " + symbol);
        }
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
   if(g_settings.log_recovery_events)
      g_logger.Info("Recovery",(g_runtime.recovery_used ? "continuity available" : "no prior continuity found"));
  }

bool ASC_ShouldSaveRuntime(const datetime now)
  {
   return(g_runtime.runtime_dirty || g_runtime.last_runtime_save_at<=0 || (now-g_runtime.last_runtime_save_at)>=g_settings.runtime_save_seconds);
  }

bool ASC_ShouldSaveScheduler(const datetime now)
  {
   return(g_runtime.scheduler_dirty || g_runtime.last_scheduler_save_at<=0 || (now-g_runtime.last_scheduler_save_at)>=g_settings.scheduler_save_seconds);
  }

bool ASC_ShouldSaveSummary(const datetime now)
  {
   return(g_runtime.summary_dirty || g_runtime.last_summary_save_at<=0 || (now-g_runtime.last_summary_save_at)>=g_settings.summary_save_seconds);
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

void ASC_LogSchedulerDecision(const ASC_SymbolState &state)
  {
   if(!g_settings.log_scheduler_decisions)
      return;
   g_logger.Debug("Scheduler","symbol=" + state.symbol + ", status=" + ASC_MarketStatusText(state.market_status) + ", next due=" + ASC_DateTimeText(state.next_check_at));
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

   if(g_symbol_count==0 || (now-g_runtime.last_universe_sync_at)>=g_settings.universe_sync_seconds)
      ASC_SyncUniverse();

   int start=(g_symbol_count>0 ? (g_runtime.scheduler_cursor % g_symbol_count) : 0);
   for(int offset=0; offset<g_symbol_count && g_runtime.processed_this_heartbeat<g_settings.symbol_budget_per_heartbeat; offset++)
     {
      int index=(start + offset) % g_symbol_count;
      if(g_symbols[index].next_check_at>now && !g_symbols[index].dirty)
         continue;

      ASC_AssessSymbol(g_symbols[index].symbol,g_symbols[index],g_settings);
      ASC_LogSchedulerDecision(g_symbols[index]);
      if(g_settings.write_dossiers_when_due && ASC_WriteDossier(g_paths,g_runtime,g_symbols[index],g_logger))
        {
         g_runtime.processed_this_heartbeat++;
         g_runtime.scheduler_cursor=index+1;
         g_runtime.scheduler_dirty=true;
         g_runtime.summary_dirty=true;
        }
     }

   g_runtime.degraded=(g_runtime.processed_this_heartbeat>=g_settings.symbol_budget_per_heartbeat && g_symbol_count>g_settings.symbol_budget_per_heartbeat);
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
   ASC_LoadSettingsFromInputs();
   if(!ASC_ResolveServerPaths(g_paths))
      return(INIT_FAILED);

   g_logger.Configure(g_paths.log_file,g_settings.log_verbosity);
   g_runtime.boot_at=TimeCurrent();
   g_runtime.mode=ASC_RUNTIME_RECOVERING;
   g_logger.Info("Init","foundation starting on server " + g_paths.server_clean);
   ASC_LogSettingsSummary();

   ASC_RestoreContinuity();
   EventSetTimer(g_settings.heartbeat_seconds);
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
