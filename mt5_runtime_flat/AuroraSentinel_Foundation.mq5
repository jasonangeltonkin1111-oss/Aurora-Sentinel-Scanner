#property strict

// Aurora Sentinel Scanner
// Wrapper Version: 1.030
// Schema Family: ASC Foundation
// Active Capability: Market State Detection
// Next Planned Capability: Open Symbol Snapshot
// Runtime Posture: Foundation / Layer 1 Truth
// Explorer Subsystem Version: 0.310
// Update Bump Law:
// - Every meaningful edit must bump version
// - Patch bump for non-breaking fixes and polish
// - Minor bump for meaningful subsystem expansion
// - Major bump to 2.000+ for architecture revision

#include "ASC_Common.mqh"
#include "ASC_ServerPaths.mqh"
#include "ASC_Logging.mqh"
#include "ASC_FileIO.mqh"
#include "ASC_MarketState.mqh"
#include "ASC_Persistence.mqh"
#include "ASC_Dossiers.mqh"
#include "ASC_ExplorerHUD.mqh"

input group "Runtime"
input int InpHeartbeatSeconds=1;                        // Heartbeat Interval Seconds
input int InpUniverseSyncSeconds=300;                  // Universe Sync Interval Seconds
input int InpSymbolBudgetPerHeartbeat=25;              // Symbol Budget Per Heartbeat

input group "Scheduler"
input int InpBacklogAttentionThreshold=10;             // Backlog Attention Threshold Symbols

input group "Market State Detection"
input int InpFreshTickSeconds=90;                      // Fresh Tick Threshold Seconds
input int InpOpenRecheckSeconds=10;                    // Open Market Recheck Seconds
input int InpUncertainBurstLimit=6;                    // Uncertain Burst Limit
input int InpUncertainFastRecheckSeconds=5;            // Uncertain Fast Recheck Seconds
input int InpUncertainSlowRecheckSeconds=30;           // Uncertain Slow Recheck Seconds
input int InpClosedNearOpenWindowSeconds=60;           // Near Open Window Seconds
input int InpClosedNearOpenRecheckSeconds=5;           // Near Open Recheck Seconds
input int InpClosedSoonWindowSeconds=900;              // Closed Soon Window Seconds
input int InpClosedSoonRecheckSeconds=60;              // Closed Soon Recheck Seconds
input int InpClosedIdleRecheckSeconds=300;             // Closed Idle Recheck Seconds
input int InpUnknownRecheckSeconds=120;                // Unknown State Recheck Seconds

input group "Recovery & Persistence"
input int InpRuntimeSaveSeconds=30;                    // Runtime Save Interval Seconds
input int InpSchedulerSaveSeconds=15;                  // Scheduler Save Interval Seconds
input int InpSummarySaveSeconds=60;                    // Summary Save Interval Seconds
input bool InpRepairMissingDossiersOnBoot=true;        // Repair Missing Dossiers On Boot

input group "Logging & Attention"
input int InpLogVerbosity=1;                           // Log Verbosity: 0 Errors, 1 Normal, 2 Debug
input bool InpLogSchedulerDecisions=false;             // Log Scheduler Decisions
input bool InpLogRecoveryEvents=true;                  // Log Recovery Events
input bool InpLogDossierRepairs=true;                  // Log Dossier Repairs

input group "Dossiers & Publication"
input bool InpWriteDossiersWhenDue=true;               // Write Dossiers When Due
input bool InpIncludeReservedCapabilityPlaceholders=true; // Include Reserved Capability Placeholders

input group "Explorer HUD"
input bool InpExplorerEnabled=true;                    // Explorer HUD Enabled
input int InpExplorerRefreshSeconds=1;                 // Explorer Refresh Seconds
input int InpExplorerScrollStepRows=1;                 // Explorer Scroll Step Rows
input int InpExplorerDensityMode=1;                    // Explorer Density: 0 Compact, 1 Normal, 2 Detailed
input bool InpExplorerShowBreadcrumbs=true;            // Explorer Show Path

input group "Symbol Identity and Bucketing (Reserved)"
input bool InpReserveIdentityAndBucketingControls=true; // Reserved: Symbol Identity and Bucketing Controls

input group "Open Symbol Snapshot (Reserved)"
input bool InpReserveOpenSymbolSnapshotControls=true;  // Reserved: Open Symbol Snapshot Controls
input int InpReservedSnapshotM1Bars=500;              // Reserved: Snapshot M1 Bars
input int InpReservedSnapshotM5Bars=500;              // Reserved: Snapshot M5 Bars
input int InpReservedSnapshotM15Bars=500;             // Reserved: Snapshot M15 Bars

input group "Candidate Filtering (Reserved)"
input bool InpReserveCandidateFilteringControls=true;  // Reserved: Candidate Filtering Controls

input group "Shortlist Selection (Reserved)"
input bool InpReserveShortlistSelectionControls=true;  // Reserved: Shortlist Selection Controls
input int InpReservedSelectedSymbolLimit=25;           // Reserved: Selected Symbol Limit

input group "Deep Selective Analysis (Reserved)"
input bool InpReserveDeepSelectiveAnalysisControls=true; // Reserved: Deep Selective Analysis Controls
input int InpReservedAtrRefreshSeconds=60;             // Reserved: ATR Refresh Seconds
input int InpReservedDeepH1Bars=500;                   // Reserved: Deep H1 Bars
input int InpReservedDeepH4Bars=300;                   // Reserved: Deep H4 Bars
input int InpReservedDeepD1Bars=300;                   // Reserved: Deep D1 Bars

input group "Combined Opportunity Summary (Reserved)"
input bool InpReserveCombinedSummaryControls=true;     // Reserved: Combined Opportunity Summary Controls

input group "Future Signal Surface (Reserved)"
input bool InpReserveFutureSignalSurfaceControls=true; // Reserved: Future Signal Surface Controls

ASC_ServerPaths g_paths;
ASC_RuntimeSettings g_settings;
ASC_RuntimeState g_runtime;
ASC_Logger g_logger;
ASC_SymbolState g_symbols[];
ASC_ExplorerContext g_explorer;
int g_symbol_count=0;
bool g_heartbeat_running=false;
bool g_last_degraded_state=false;
int g_backlog_attention_threshold=10;

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
   g_settings.explorer_enabled=InpExplorerEnabled;
   g_settings.explorer_refresh_seconds=(InpExplorerRefreshSeconds>0 ? InpExplorerRefreshSeconds : 1);
   g_settings.explorer_scroll_step_rows=(InpExplorerScrollStepRows>0 ? InpExplorerScrollStepRows : 1);
   g_settings.explorer_density_mode=(InpExplorerDensityMode<0 ? 0 : (InpExplorerDensityMode>2 ? 2 : InpExplorerDensityMode));
   g_settings.explorer_show_breadcrumbs=InpExplorerShowBreadcrumbs;
   g_settings.heartbeat_seconds=(InpHeartbeatSeconds>0 ? InpHeartbeatSeconds : 1);
   g_settings.universe_sync_seconds=(InpUniverseSyncSeconds>0 ? InpUniverseSyncSeconds : 300);
   g_settings.symbol_budget_per_heartbeat=(InpSymbolBudgetPerHeartbeat>0 ? InpSymbolBudgetPerHeartbeat : 1);
   g_settings.runtime_save_seconds=(InpRuntimeSaveSeconds>0 ? InpRuntimeSaveSeconds : 30);
   g_settings.scheduler_save_seconds=(InpSchedulerSaveSeconds>0 ? InpSchedulerSaveSeconds : 15);
   g_settings.summary_save_seconds=(InpSummarySaveSeconds>0 ? InpSummarySaveSeconds : 60);
   g_settings.fresh_tick_seconds=(InpFreshTickSeconds>0 ? InpFreshTickSeconds : 90);
   g_settings.open_recheck_seconds=(InpOpenRecheckSeconds>0 ? InpOpenRecheckSeconds : 10);
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
   g_settings.include_reserved_capability_placeholders=InpIncludeReservedCapabilityPlaceholders;
   g_settings.log_verbosity=ASC_InputVerbosity(InpLogVerbosity);
   g_settings.log_scheduler_decisions=InpLogSchedulerDecisions;
   g_settings.log_recovery_events=InpLogRecoveryEvents;
   g_settings.log_dossier_repairs=InpLogDossierRepairs;
   g_settings.open_symbol_snapshot_reserved=InpReserveOpenSymbolSnapshotControls;
   g_settings.candidate_filtering_reserved=InpReserveCandidateFilteringControls;
   g_settings.shortlist_selection_reserved=InpReserveShortlistSelectionControls;
   g_settings.deep_selective_analysis_reserved=InpReserveDeepSelectiveAnalysisControls;
   g_settings.reserved_atr_refresh_seconds=(InpReservedAtrRefreshSeconds>0 ? InpReservedAtrRefreshSeconds : 1);
   g_settings.snapshot_controls_reserved=InpReserveOpenSymbolSnapshotControls;
   g_settings.timeframe_history_reserved=true;
   g_settings.deep_analysis_controls_reserved=InpReserveDeepSelectiveAnalysisControls;
   g_settings.selection_controls_reserved=InpReserveShortlistSelectionControls;
   g_settings.reserved_m1_bars=(InpReservedSnapshotM1Bars>0 ? InpReservedSnapshotM1Bars : 1);
   g_settings.reserved_m5_bars=(InpReservedSnapshotM5Bars>0 ? InpReservedSnapshotM5Bars : 1);
   g_settings.reserved_m15_bars=(InpReservedSnapshotM15Bars>0 ? InpReservedSnapshotM15Bars : 1);
   g_settings.reserved_h1_bars=(InpReservedDeepH1Bars>0 ? InpReservedDeepH1Bars : 1);
   g_settings.reserved_h4_bars=(InpReservedDeepH4Bars>0 ? InpReservedDeepH4Bars : 1);
   g_settings.reserved_d1_bars=(InpReservedDeepD1Bars>0 ? InpReservedDeepD1Bars : 1);
   g_settings.reserved_selected_symbol_limit=(InpReservedSelectedSymbolLimit>0 ? InpReservedSelectedSymbolLimit : 1);
   g_backlog_attention_threshold=(InpBacklogAttentionThreshold>0 ? InpBacklogAttentionThreshold : 1);
  }

void ASC_LogSettingsSummary(void)
  {
   g_logger.Info("Settings",ASC_WrapperHeaderText());
   g_logger.Info("Settings","heartbeat=" + IntegerToString(g_settings.heartbeat_seconds) + "s, budget=" + IntegerToString(g_settings.symbol_budget_per_heartbeat) + ", open recheck=" + IntegerToString(g_settings.open_recheck_seconds) + "s, runtime save=" + IntegerToString(g_settings.runtime_save_seconds) + "s, explorer=" + ASC_BoolText(g_settings.explorer_enabled) + " (" + ASC_ExplorerDensityText(g_settings.explorer_density_mode) + ")");
   g_logger.Debug("Settings","reserved surfaces: identity=" + ASC_BoolText(InpReserveIdentityAndBucketingControls) + ", snapshot=" + ASC_BoolText(g_settings.open_symbol_snapshot_reserved) + " with timeframe placeholders, filter=" + ASC_BoolText(g_settings.candidate_filtering_reserved) + ", shortlist=" + ASC_BoolText(g_settings.shortlist_selection_reserved) + ", deep=" + ASC_BoolText(g_settings.deep_selective_analysis_reserved) + " with timeframe placeholders, combined=" + ASC_BoolText(InpReserveCombinedSummaryControls) + ", signal=" + ASC_BoolText(InpReserveFutureSignalSurfaceControls));
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
   g_last_degraded_state=false;
  }

void ASC_ResetSymbolState(ASC_SymbolState &state,const string symbol)
  {
   state.is_due_now=true;
   state.publication_ok=false;
   state.next_check_reason="Initial assessment pending";
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
   int missing_repairs=0;
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

      g_symbols[i].publication_ok=ASC_IsDossierPresent(g_symbols[i]);
      if(g_settings.repair_missing_dossiers_on_boot && !g_symbols[i].publication_ok)
        {
         g_symbols[i].dirty=true;
         missing_repairs++;
         if(g_settings.log_dossier_repairs && g_settings.log_verbosity>=ASC_LOG_DEBUG)
            g_logger.Debug("DossierRepair","queued missing dossier repair for " + symbol);
        }
     }

   if(g_runtime.scheduler_cursor>=g_symbol_count)
      g_runtime.scheduler_cursor=0;
   g_runtime.symbol_count=total;
   g_runtime.last_universe_sync_at=TimeCurrent();
   g_runtime.runtime_dirty=true;
   g_runtime.scheduler_dirty=true;
   g_runtime.summary_dirty=true;
   g_logger.Info("Universe","synced " + IntegerToString(total) + " symbols");
   if(g_settings.repair_missing_dossiers_on_boot && missing_repairs>0)
      g_logger.Info("DossierRepair","queued " + IntegerToString(missing_repairs) + " missing dossier repairs");
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

int ASC_CountDueSymbols(const datetime now)
  {
   int due_count=0;
   for(int i=0;i<g_symbol_count;i++)
     {
      g_symbols[i].is_due_now=(g_symbols[i].next_check_at<=now || g_symbols[i].dirty);
      if(g_symbols[i].is_due_now)
         due_count++;
     }
   return(due_count);
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
   g_logger.Debug("Scheduler","symbol=" + state.symbol + ", status=" + ASC_MarketStatusText(state.market_status) + ", next due=" + ASC_DateTimeText(state.next_check_at) + ", reason=" + state.next_check_reason);
  }

bool ASC_ProcessMarketStateSymbol(const int index)
  {
   ASC_AssessSymbol(g_symbols[index].symbol,g_symbols[index],g_settings);
   ASC_LogSchedulerDecision(g_symbols[index]);
   if(!g_settings.write_dossiers_when_due)
     {
      g_symbols[index].publication_ok=ASC_IsDossierPresent(g_symbols[index]);
      g_symbols[index].dirty=false;
      return(true);
     }
   return(ASC_WriteDossier(g_paths,g_runtime,g_symbols[index],g_logger));
  }

void ASC_OpenSymbolSnapshotPlaceholder(void) { }
void ASC_CandidateFilteringPlaceholder(void) { }
void ASC_ShortlistSelectionPlaceholder(void) { }
void ASC_DeepSelectiveAnalysisPlaceholder(void) { }

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

   int touched_this_heartbeat=0;
   int promoted_this_heartbeat=0;
   int failed_promotions_this_heartbeat=0;
   int initial_due=ASC_CountDueSymbols(now);
   int start=(g_symbol_count>0 ? (g_runtime.scheduler_cursor % g_symbol_count) : 0);

   for(int offset=0; offset<g_symbol_count && touched_this_heartbeat<g_settings.symbol_budget_per_heartbeat; offset++)
     {
      int index=(start + offset) % g_symbol_count;
      if(!g_symbols[index].is_due_now)
         continue;

      touched_this_heartbeat++;
      bool success=ASC_ProcessMarketStateSymbol(index);
      g_runtime.scheduler_cursor=(g_symbol_count>0 ? ((index+1)%g_symbol_count) : 0);
      g_runtime.scheduler_dirty=true;
      g_runtime.summary_dirty=true;

      if(success)
         promoted_this_heartbeat++;
      else
         failed_promotions_this_heartbeat++;
     }

   if(touched_this_heartbeat==0 && g_symbol_count>0)
      g_runtime.scheduler_cursor=(start+1)%g_symbol_count;

   g_runtime.processed_this_heartbeat=touched_this_heartbeat;
   int remaining_due=ASC_CountDueSymbols(now);
   g_runtime.degraded=(remaining_due>0 && touched_this_heartbeat>=g_settings.symbol_budget_per_heartbeat);
   ASC_UpdateRuntimeMode(ASC_CountMissingDossiers());
   g_runtime.runtime_dirty=true;

   g_logger.Info("Heartbeat","processed " + IntegerToString(touched_this_heartbeat) + " due symbols from " + IntegerToString(initial_due) + "; promoted " + IntegerToString(promoted_this_heartbeat) + " dossiers; failed " + IntegerToString(failed_promotions_this_heartbeat) + "; backlog " + IntegerToString(remaining_due));
   if(g_runtime.degraded && !g_last_degraded_state)
      g_logger.Warn("Heartbeat","bounded work cap reached; " + IntegerToString(remaining_due) + " due symbols remain queued for the next heartbeat");
   else if(!g_runtime.degraded && g_last_degraded_state)
      g_logger.Info("Heartbeat","bounded work backlog has cleared");
   else if(remaining_due>=g_backlog_attention_threshold && g_settings.log_verbosity>=ASC_LOG_DEBUG)
      g_logger.Debug("Heartbeat","backlog remains visible at " + IntegerToString(remaining_due) + " due symbols");
   g_last_degraded_state=g_runtime.degraded;

   bool attempted_save=false;
   bool runtime_saved=true;
   bool scheduler_saved=true;
   bool summary_saved=true;

   if(ASC_ShouldSaveRuntime(now))
     {
      attempted_save=true;
      runtime_saved=ASC_SaveRuntimeState(g_paths,g_runtime,g_logger);
      if(!runtime_saved)
         g_logger.Error("RuntimeState","runtime save failed");
     }

   if(ASC_ShouldSaveScheduler(now))
     {
      attempted_save=true;
      scheduler_saved=ASC_SaveSchedulerState(g_paths,g_symbols,g_symbol_count,g_logger);
      if(scheduler_saved)
        {
         g_runtime.last_scheduler_save_at=now;
         g_runtime.scheduler_dirty=false;
        }
      else
         g_logger.Error("SchedulerState","scheduler save failed");
     }

   if(ASC_ShouldSaveSummary(now))
     {
      attempted_save=true;
      summary_saved=ASC_SaveSummary(g_paths,g_runtime,g_symbols,g_symbol_count,g_logger);
      if(!summary_saved)
         g_logger.Error("Summary","summary save failed");
     }

   if(attempted_save || !runtime_saved || !scheduler_saved || !summary_saved)
      g_logger.Info("Persistence","runtime save " + (runtime_saved ? "succeeded" : "failed") + "; scheduler save " + (scheduler_saved ? "succeeded" : "failed") + "; summary save " + (summary_saved ? "succeeded" : "failed"));

   ASC_ExplorerMaybeRender(g_explorer,g_settings,g_runtime,g_symbols,g_symbol_count,true);
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
   ASC_ExplorerInit(g_explorer,ChartID());
   ASC_ExplorerMaybeRender(g_explorer,g_settings,g_runtime,g_symbols,g_symbol_count,true);
   EventSetTimer(g_settings.heartbeat_seconds);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
   g_runtime.last_heartbeat_at=TimeCurrent();
   g_runtime.runtime_dirty=true;
   g_runtime.scheduler_dirty=true;
   g_runtime.summary_dirty=true;
   ASC_SaveRuntimeState(g_paths,g_runtime,g_logger);
   ASC_SaveSchedulerState(g_paths,g_symbols,g_symbol_count,g_logger);
   ASC_SaveSummary(g_paths,g_runtime,g_symbols,g_symbol_count,g_logger);
   ASC_ExplorerShutdown(g_explorer);
   g_logger.Info("Deinit","foundation stopping with reason " + IntegerToString(reason));
  }

void OnTick() { }

void OnTimer()
  {
   ASC_RunHeartbeat();
  }

void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      g_explorer.nav.dirty=true;
      ASC_ExplorerMaybeRender(g_explorer,g_settings,g_runtime,g_symbols,g_symbol_count,true);
      return;
     }

   if(id!=CHARTEVENT_OBJECT_CLICK)
      return;
   if(StringFind(sparam,ASC_HUD_PREFIX)!=0)
      return;

   ASC_ExplorerHandleAction(g_explorer,g_settings,sparam,g_symbols,g_symbol_count,g_logger);
   ASC_ExplorerMaybeRender(g_explorer,g_settings,g_runtime,g_symbols,g_symbol_count,true);
  }
