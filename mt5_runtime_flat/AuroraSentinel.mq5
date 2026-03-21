#property strict

// Aurora Sentinel Scanner
// Wrapper Version: 1.121
// Schema Family: ASC Foundation
// Active Capability: Market State Detection
// Next Planned Capability: Open Symbol Snapshot
// Runtime Posture: Foundation / Layer 1 Truth
// Explorer Subsystem Version: 0.442
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
input int InpWarmupMinimumUniversePercent=35;          // Warmup Minimum Universe Percent
input int InpWarmupMinimumAssessedSharePercent=35;     // Warmup Minimum Assessed Share Percent
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
ASC_PreparedBucketState g_prepared_buckets;
ASC_PreparedBucketState g_prepared_working_buckets;
ASC_PreparedBucketState g_prepared_last_good_buckets;
int g_prepared_next_batch_id=ASC_PREPARED_BATCH_PRIORITY_SET;
int g_symbol_count=0;
bool g_heartbeat_running=false;
bool g_last_degraded_state=false;
int g_backlog_attention_threshold=10;
int g_last_logged_warmup_progress=-1;
string g_last_logged_bounded_work_summary="";
string g_last_logged_hydration_priority_set="";
int g_last_logged_prepared_batch_id=-1;
bool g_last_logged_warmup_minimum_met=false;
bool g_last_logged_primary_buckets_ready=false;
bool g_last_logged_background_hydration_active=false;

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
   g_settings.warmup_minimum_universe_percent=ASC_PercentClamp((InpWarmupMinimumAssessedSharePercent>0 ? InpWarmupMinimumAssessedSharePercent : InpWarmupMinimumUniversePercent));
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
   g_logger.Info("Settings","heartbeat=" + IntegerToString(g_settings.heartbeat_seconds) + "s, budget=" + IntegerToString(g_settings.symbol_budget_per_heartbeat) + ", open recheck=" + IntegerToString(g_settings.open_recheck_seconds) + "s, runtime save=" + IntegerToString(g_settings.runtime_save_seconds) + "s, warmup min=" + IntegerToString(g_settings.warmup_minimum_universe_percent) + "%, explorer=" + ASC_BoolText(g_settings.explorer_enabled) + " (" + ASC_ExplorerDensityText(g_settings.explorer_density_mode) + ")");
   g_logger.Debug("Settings","reserved surfaces: identity=" + ASC_BoolText(InpReserveIdentityAndBucketingControls) + ", snapshot=" + ASC_BoolText(g_settings.open_symbol_snapshot_reserved) + " with timeframe placeholders, filter=" + ASC_BoolText(g_settings.candidate_filtering_reserved) + ", shortlist=" + ASC_BoolText(g_settings.shortlist_selection_reserved) + ", deep=" + ASC_BoolText(g_settings.deep_selective_analysis_reserved) + " with timeframe placeholders, combined=" + ASC_BoolText(InpReserveCombinedSummaryControls) + ", signal=" + ASC_BoolText(InpReserveFutureSignalSurfaceControls));
  }


int ASC_HydrationNextBatchId(const ASC_PreparedBucketState &prepared)
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

string ASC_HydrationPrioritySetText(const int batch_id)
  {
   if(batch_id==ASC_PREPARED_BATCH_PRIORITY_SET)
      return("Priority 1: FX, Indices, Metals, Energy, Crypto");
   if(batch_id==ASC_PREPARED_BATCH_STOCK_MAIN)
      return("Priority 2: Stocks and regional stock groups");
   if(batch_id==ASC_PREPARED_BATCH_STOCK_METADATA)
      return("Priority 3: finer stock detail metadata");
   return("Hydration complete");
  }

bool ASC_HydrationShouldAdvance(const ASC_PreparedBucketState &prepared,const int next_batch)
  {
   if(g_symbol_count<=0 || next_batch<=0)
      return(false);
   if(next_batch==ASC_PREPARED_BATCH_PRIORITY_SET)
      return(true);
   if(!g_runtime.warmup_minimum_met)
      return(false);
   return(true);
  }

string ASC_DebugBacklogSeverityText(const int due_now,const int budget)
  {
   if(due_now<=0)
      return("clear");
   int safe_budget=(budget>0 ? budget : 1);
   if(due_now>=(safe_budget*ASC_DEBUG_BACKLOG_SEVERE_MULTIPLIER))
      return("severe");
   if(due_now>=(safe_budget*ASC_DEBUG_BACKLOG_ELEVATED_MULTIPLIER))
      return("elevated");
   if(due_now>safe_budget)
      return("watch");
   return("within-budget");
  }

void ASC_DebugLogWarmupTransition(void)
  {
   bool minimum_changed=(g_last_logged_warmup_minimum_met!=g_runtime.warmup_minimum_met);
   bool primary_changed=(g_last_logged_primary_buckets_ready!=g_runtime.compressed_primary_buckets_ready);
   bool background_changed=(g_last_logged_background_hydration_active!=g_runtime.background_hydration_active);
   if(!minimum_changed && !primary_changed && !background_changed)
      return;

   int minimum_assessed=ASC_PercentOfCountCeil(g_symbol_count,g_settings.warmup_minimum_universe_percent);
   string reason="minimum_assessed=" + IntegerToString(minimum_assessed)
      + ", assessed=" + IntegerToString(g_runtime.initial_symbols_assessed) + "/" + IntegerToString(g_runtime.total_symbols_discovered)
      + ", primary=" + IntegerToString(g_runtime.primary_bucket_symbols_assessed) + "/" + IntegerToString(g_runtime.primary_bucket_symbol_count)
      + ", primary_batches_ready=" + ASC_BoolText(g_runtime.compressed_primary_buckets_ready)
      + ", warmup_minimum_met=" + ASC_BoolText(g_runtime.warmup_minimum_met)
      + ", background_hydration=" + ASC_BoolText(g_runtime.background_hydration_active)
      + ", readiness=" + IntegerToString(g_runtime.readiness_percent) + "%";
   g_logger.Debug("Diagnostics","warmup-state transition | mode=" + ASC_RuntimeModeText(g_runtime.mode) + " | " + reason);
   g_last_logged_warmup_minimum_met=g_runtime.warmup_minimum_met;
   g_last_logged_primary_buckets_ready=g_runtime.compressed_primary_buckets_ready;
   g_last_logged_background_hydration_active=g_runtime.background_hydration_active;
  }

void ASC_LogPreparedDiagnosticsSummary(const string reason)
  {
   bool warmup_changed=(g_last_logged_warmup_progress!=g_runtime.warmup_progress_percent);
   bool pressure_changed=ASC_LogMaterialStringChange(g_last_logged_bounded_work_summary,g_prepared_buckets.diagnostics.bounded_work_pressure_summary);
   bool priority_changed=ASC_LogMaterialStringChange(g_last_logged_hydration_priority_set,g_prepared_buckets.diagnostics.active_hydration_priority_set);
   bool batch_changed=(g_last_logged_prepared_batch_id!=g_prepared_buckets.diagnostics.last_prepared_batch_id);
   bool threshold_hit=(g_prepared_buckets.diagnostics.bucket_prep_total_ms>=ASC_DEBUG_PREP_SUMMARY_THRESHOLD_MS
                       || g_prepared_buckets.diagnostics.classification_loop_ms>=15
                       || g_prepared_buckets.diagnostics.bucket_sort_ms>=10
                       || g_prepared_buckets.diagnostics.prepared_symbol_reorder_ms>=10
                       || g_prepared_buckets.diagnostics.final_promotion_ms>=5);
   if(warmup_changed || pressure_changed || priority_changed || batch_changed || threshold_hit)
     {
      string message="reason=" + reason
         + " | prep=" + IntegerToString((int)g_prepared_buckets.diagnostics.bucket_prep_total_ms) + "ms"
         + " | classify=" + IntegerToString((int)g_prepared_buckets.diagnostics.classification_loop_ms) + "ms"
         + " | sort=" + IntegerToString((int)g_prepared_buckets.diagnostics.bucket_sort_ms) + "ms"
         + " | reorder=" + IntegerToString((int)g_prepared_buckets.diagnostics.prepared_symbol_reorder_ms) + "ms"
         + " | promote=" + IntegerToString((int)g_prepared_buckets.diagnostics.final_promotion_ms) + "ms"
         + " | warmup=" + IntegerToString(g_runtime.warmup_progress_percent) + "%"
         + " (" + ASC_LogChangedText(warmup_changed) + ")"
         + " | pressure=" + g_prepared_buckets.diagnostics.bounded_work_pressure_summary
         + " (" + ASC_LogChangedText(pressure_changed) + ")"
         + " | batch=" + IntegerToString(g_prepared_buckets.diagnostics.last_prepared_batch_id)
         + " (" + ASC_LogChangedText(batch_changed) + ")"
         + " | hydration=" + g_prepared_buckets.diagnostics.active_hydration_priority_set
         + " (" + ASC_LogChangedText(priority_changed) + ")"
         + " | dominant=" + (g_prepared_buckets.diagnostics.bucket_prep_total_ms>g_prepared_buckets.diagnostics.hud_render_ms+ASC_DEBUG_DOMINANT_DELTA_MS ? "prep" : (g_prepared_buckets.diagnostics.hud_render_ms>g_prepared_buckets.diagnostics.bucket_prep_total_ms+ASC_DEBUG_DOMINANT_DELTA_MS ? "hud" : "mixed"));
      g_logger.Debug("Diagnostics",message);
     }
   g_last_logged_warmup_progress=g_runtime.warmup_progress_percent;
   g_last_logged_bounded_work_summary=g_prepared_buckets.diagnostics.bounded_work_pressure_summary;
   g_last_logged_hydration_priority_set=g_prepared_buckets.diagnostics.active_hydration_priority_set;
   g_last_logged_prepared_batch_id=g_prepared_buckets.diagnostics.last_prepared_batch_id;
  }

void ASC_LogHeartbeatDiagnosticsSummary(const int initial_due,const int remaining_due)
  {
   bool pressure_changed=ASC_LogMaterialStringChange(g_last_logged_bounded_work_summary,g_runtime.diagnostics.bounded_work_pressure_summary);
   bool warmup_changed=(g_last_logged_warmup_progress!=g_runtime.diagnostics.warmup_progress_percent);
   bool threshold_hit=(g_runtime.diagnostics.last_heartbeat_dispatch_ms>=g_settings.heartbeat_seconds*1000
                       || remaining_due>=g_backlog_attention_threshold);
   if(pressure_changed || warmup_changed || threshold_hit)
     {
      string severity=ASC_DebugBacklogSeverityText(remaining_due,g_settings.symbol_budget_per_heartbeat);
      string message="dispatch=" + IntegerToString((int)g_runtime.diagnostics.last_heartbeat_dispatch_ms) + "ms"
         + " | due=" + IntegerToString(initial_due)
         + " -> " + IntegerToString(remaining_due)
         + " | severity=" + severity
         + " | warmup=" + IntegerToString(g_runtime.diagnostics.warmup_progress_percent) + "%"
         + " (" + ASC_LogChangedText(warmup_changed) + ")"
         + " | pressure=" + g_runtime.diagnostics.bounded_work_pressure_summary
         + " (" + ASC_LogChangedText(pressure_changed) + ")";
      g_logger.Debug("Diagnostics","bounded-work backlog severity bucket | " + message);
     }
   g_last_logged_warmup_progress=g_runtime.diagnostics.warmup_progress_percent;
   g_last_logged_bounded_work_summary=g_runtime.diagnostics.bounded_work_pressure_summary;
  }

void ASC_RunPreparedHydrationController(const string reason)
  {
   int batch_id=ASC_HydrationNextBatchId(g_prepared_buckets);
   if(!ASC_HydrationShouldAdvance(g_prepared_buckets,batch_id))
      return;

   int due_now=ASC_CountDueSymbols(TimeCurrent());
   long prep_started_ms=GetTickCount();
   ASC_PrepareBucketState(g_runtime.server_clean,
                          g_symbols,
                          g_symbol_count,
                          batch_id,
                          g_runtime.initial_symbols_assessed,
                          g_runtime.symbol_count,
                          g_runtime.warmup_progress_percent,
                          due_now,
                          g_settings.symbol_budget_per_heartbeat,
                          g_prepared_buckets,
                          g_prepared_last_good_buckets,
                          g_prepared_working_buckets);
   if(!ASC_PreparedValidateBatchCompleteness(g_prepared_working_buckets,batch_id))
     {
      g_prepared_working_buckets.diagnostics.bucket_prep_total_ms=GetTickCount()-prep_started_ms;
      g_logger.Warn("Hydration","reason=" + reason + ", batch validation failed for " + ASC_PreparedBatchName(batch_id) + "; active prepared truth kept on last-good state");
      ASC_LogPreparedDiagnosticsSummary(reason + ":validation-failed");
      return;
     }

   long promotion_started_ms=GetTickCount();
   int previous_generation=g_prepared_buckets.batch_generation;
   int previous_last_good_batch=g_prepared_buckets.last_good_batch_id;
   bool unchanged_batch=(ASC_PreparedBatchMatches(g_prepared_working_buckets,g_prepared_buckets,batch_id)
                         || ASC_PreparedBatchMatches(g_prepared_working_buckets,g_prepared_last_good_buckets,batch_id));
   ASC_PromotePreparedBucketState(g_prepared_working_buckets,batch_id,g_prepared_last_good_buckets,g_prepared_buckets);
   g_prepared_buckets.diagnostics.final_promotion_ms=GetTickCount()-promotion_started_ms;
   if(unchanged_batch)
      g_logger.Debug("Diagnostics","unchanged batch rewritten | reason=" + reason + " | batch=" + ASC_PreparedBatchName(batch_id) + " | generation=" + IntegerToString(previous_generation) + "->" + IntegerToString(g_prepared_buckets.batch_generation));
   if(previous_last_good_batch!=g_prepared_buckets.last_good_batch_id)
      g_logger.Debug("Diagnostics","batch promotion preserved last-good truth | reason=" + reason + " | promoted=" + ASC_PreparedBatchName(batch_id) + " | last_good_batch=" + IntegerToString(previous_last_good_batch) + "->" + IntegerToString(g_prepared_buckets.last_good_batch_id));
   g_prepared_buckets.diagnostics.bucket_prep_total_ms=GetTickCount()-prep_started_ms;
   ASC_SyncPreparedRuntimeMetadata();
   g_prepared_next_batch_id=ASC_HydrationNextBatchId(g_prepared_buckets);
   g_runtime.summary_dirty=true;
   g_runtime.runtime_dirty=true;
   g_logger.Debug("Hydration","reason=" + reason + ", promoted batch=" + ASC_PreparedBatchName(batch_id) + " | planner=" + ASC_HydrationPrioritySetText(g_prepared_next_batch_id));
   ASC_LogPreparedDiagnosticsSummary(reason);
   ASC_DebugLogWarmupTransition();
  }

void ASC_SyncPreparedRuntimeMetadata(void)
  {
   g_runtime.prepared_last_batch_id=g_prepared_buckets.diagnostics.last_prepared_batch_id;
   g_runtime.prepared_promoted_batch_count=g_prepared_buckets.diagnostics.promoted_batch_count;
   g_runtime.prepared_pending_batch_count=g_prepared_buckets.diagnostics.pending_batch_count;
   g_runtime.prepared_bounded_work_summary=g_prepared_buckets.diagnostics.bounded_work_pressure_summary;
   g_runtime.diagnostics.last_bucket_prep_total_ms=g_prepared_buckets.diagnostics.bucket_prep_total_ms;
   g_runtime.diagnostics.last_classification_loop_ms=g_prepared_buckets.diagnostics.classification_loop_ms;
   g_runtime.diagnostics.last_bucket_sort_ms=g_prepared_buckets.diagnostics.bucket_sort_ms;
   g_runtime.diagnostics.last_prepared_symbol_reorder_ms=g_prepared_buckets.diagnostics.prepared_symbol_reorder_ms;
   g_runtime.diagnostics.last_final_promotion_ms=g_prepared_buckets.diagnostics.final_promotion_ms;
   g_runtime.diagnostics.last_hud_render_ms=g_prepared_buckets.diagnostics.hud_render_ms;
   g_runtime.diagnostics.last_page_switch_action_to_render_ms=g_prepared_buckets.diagnostics.page_switch_action_to_render_ms;
   g_runtime.diagnostics.warmup_progress_percent=g_prepared_buckets.diagnostics.readiness_percent;
   g_runtime.diagnostics.bounded_work_pressure_summary=g_prepared_buckets.diagnostics.bounded_work_pressure_summary;
   g_runtime.diagnostics.last_promoted_prepared_batch_id=g_prepared_buckets.diagnostics.last_prepared_batch_id;
   g_runtime.diagnostics.active_hydration_priority_set=g_prepared_buckets.diagnostics.active_hydration_priority_set;
   g_runtime.diagnostics.last_hud_render_at=g_explorer.nav.last_render_at;
  }

void ASC_RefreshPreparedBucketState(void)
  {
   ASC_RunPreparedHydrationController("runtime");
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
   g_runtime.total_symbols_discovered=0;
   g_runtime.initial_symbols_assessed=0;
   g_runtime.primary_bucket_symbols_assessed=0;
   g_runtime.primary_bucket_symbol_count=0;
   g_runtime.compressed_primary_buckets_ready=false;
   g_runtime.warmup_minimum_met=false;
   g_runtime.warmup_progress_percent=0;
   g_runtime.background_hydration_active=false;
   g_runtime.readiness_percent=0;
   g_runtime.prepared_last_batch_id=0;
   g_runtime.prepared_promoted_batch_count=0;
   g_runtime.prepared_pending_batch_count=ASC_PREPARED_BATCH_COUNT;
   g_runtime.prepared_bounded_work_summary="Not sampled.";
   g_runtime.diagnostics.last_bucket_prep_total_ms=0;
   g_runtime.diagnostics.last_classification_loop_ms=0;
   g_runtime.diagnostics.last_bucket_sort_ms=0;
   g_runtime.diagnostics.last_prepared_symbol_reorder_ms=0;
   g_runtime.diagnostics.last_final_promotion_ms=0;
   g_runtime.diagnostics.last_heartbeat_dispatch_ms=0;
   g_runtime.diagnostics.last_hud_render_ms=0;
   g_runtime.diagnostics.last_page_switch_action_to_render_ms=0;
   g_runtime.diagnostics.warmup_progress_percent=0;
   g_runtime.diagnostics.bounded_work_pressure_summary="Not sampled.";
   g_runtime.diagnostics.last_promoted_prepared_batch_id=0;
   g_runtime.diagnostics.active_hydration_priority_set="next=" + ASC_PreparedBatchName(ASC_PREPARED_BATCH_PRIORITY_SET);
   g_runtime.diagnostics.last_hud_render_at=0;
   ASC_PreparedBucketStateReset(g_prepared_buckets);
   ASC_PreparedBucketStateReset(g_prepared_working_buckets);
   ASC_PreparedBucketStateReset(g_prepared_last_good_buckets);
   g_prepared_next_batch_id=ASC_PREPARED_BATCH_PRIORITY_SET;
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
   ASC_RefreshPreparedBucketState();
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
   ASC_RefreshPreparedBucketState();
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

bool ASC_IsPrioritySet1Bucket(const string primary_bucket)
  {
   string bucket=ASC_ToUpper(ASC_Trim(primary_bucket));
   return(bucket=="FX_MAJOR"
          || bucket=="INDEX_US"
          || bucket=="INDEX_EUROPE"
          || bucket=="METALS_PRECIOUS"
          || bucket=="ENERGY"
          || bucket=="CRYPTO_LARGE_CAP");
  }

void ASC_UpdateLayer1Readiness(void)
  {
   int assessed=0;
   int primary_assessed=0;
   int primary_total=0;

   for(int i=0;i<g_symbol_count;i++)
     {
      bool initial_assessed=(g_symbols[i].last_checked_at>0);
      if(initial_assessed)
         assessed++;

      ASC_SymbolClassification classification;
      if(!ASC_CL_ClassifySymbol(g_runtime.server_clean,g_symbols[i].symbol,classification))
         continue;
      if(!ASC_IsPrioritySet1Bucket(classification.primary_bucket))
         continue;

      primary_total++;
      if(initial_assessed)
         primary_assessed++;
     }

   bool primary_buckets_ready=(ArraySize(g_prepared_buckets.batch_ready)>=ASC_PREPARED_BATCH_COUNT
                               && g_prepared_buckets.batch_ready[ASC_PREPARED_BATCH_PRIORITY_SET-1]!=0);
   g_runtime.total_symbols_discovered=g_symbol_count;
   g_runtime.initial_symbols_assessed=assessed;
   g_runtime.primary_bucket_symbols_assessed=primary_assessed;
   g_runtime.primary_bucket_symbol_count=primary_total;
   g_runtime.compressed_primary_buckets_ready=primary_buckets_ready;

   int minimum_assessed=ASC_PercentOfCountCeil(g_symbol_count,g_settings.warmup_minimum_universe_percent);
   bool assessed_share_minimum_met=(g_symbol_count<=0 || assessed>=minimum_assessed);
   bool primary_bucket_assessment_met=(primary_total<=0 || primary_assessed>=primary_total);
   g_runtime.warmup_minimum_met=(assessed_share_minimum_met && primary_bucket_assessment_met && primary_buckets_ready);

   int assessed_share_progress=(g_symbol_count>0 ? (assessed*100)/g_symbol_count : 100);
   int assessed_threshold_progress=(minimum_assessed>0 ? (assessed*100)/minimum_assessed : 100);
   if(assessed_threshold_progress>100)
      assessed_threshold_progress=100;
   int primary_assessment_progress=(primary_total>0 ? (primary_assessed*100)/primary_total : 100);
   int primary_bucket_progress=(primary_buckets_ready ? 100 : 0);
   int progress=assessed_threshold_progress;
   if(primary_assessment_progress<progress)
      progress=primary_assessment_progress;
   if(primary_bucket_progress<progress)
      progress=primary_bucket_progress;
   if(g_runtime.warmup_minimum_met && assessed_share_progress>progress)
      progress=assessed_share_progress;
   g_runtime.readiness_percent=ASC_PercentClamp(progress);
   g_runtime.warmup_progress_percent=g_runtime.readiness_percent;
   int next_prepared_batch=ASC_HydrationNextBatchId(g_prepared_buckets);
   g_runtime.background_hydration_active=(g_runtime.warmup_minimum_met
                                          && (assessed<g_symbol_count || next_prepared_batch==ASC_PREPARED_BATCH_STOCK_MAIN || next_prepared_batch==ASC_PREPARED_BATCH_STOCK_METADATA));
   g_runtime.diagnostics.warmup_progress_percent=g_runtime.warmup_progress_percent;
  }

void ASC_UpdateRuntimeMode(void)
  {
   if(g_runtime.degraded)
     {
      g_runtime.mode=ASC_RUNTIME_DEGRADED;
      return;
     }

   bool layer1_ready=(g_runtime.compressed_primary_buckets_ready && g_runtime.warmup_minimum_met);
   if(!layer1_ready)
      g_runtime.mode=ASC_RUNTIME_WARMUP;
   else
      g_runtime.mode=ASC_RUNTIME_STEADY;
   ASC_DebugLogWarmupTransition();
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
   long heartbeat_started_ms=GetTickCount();
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
   g_runtime.diagnostics.bounded_work_pressure_summary="due=" + IntegerToString(remaining_due)
      + " | budget=" + IntegerToString(g_settings.symbol_budget_per_heartbeat)
      + " | backlog=" + IntegerToString((remaining_due>g_settings.symbol_budget_per_heartbeat) ? (remaining_due-g_settings.symbol_budget_per_heartbeat) : 0);
   ASC_UpdateLayer1Readiness();
   ASC_UpdateRuntimeMode();
   ASC_RefreshPreparedBucketState();
   g_runtime.diagnostics.last_heartbeat_dispatch_ms=GetTickCount()-heartbeat_started_ms;
   g_prepared_buckets.diagnostics.heartbeat_dispatch_ms=g_runtime.diagnostics.last_heartbeat_dispatch_ms;
   g_runtime.runtime_dirty=true;

   g_logger.Info("Heartbeat","processed " + IntegerToString(touched_this_heartbeat) + " due symbols from " + IntegerToString(initial_due) + "; promoted " + IntegerToString(promoted_this_heartbeat) + " dossiers; failed " + IntegerToString(failed_promotions_this_heartbeat) + "; backlog " + IntegerToString(remaining_due));
   if(g_runtime.degraded && !g_last_degraded_state)
      g_logger.Warn("Heartbeat","bounded work cap reached; " + IntegerToString(remaining_due) + " due symbols remain queued for the next heartbeat");
   else if(!g_runtime.degraded && g_last_degraded_state)
      g_logger.Info("Heartbeat","bounded work backlog has cleared");
   else if(remaining_due>=g_backlog_attention_threshold && g_settings.log_verbosity>=ASC_LOG_DEBUG)
      g_logger.Debug("Heartbeat","backlog remains visible at " + IntegerToString(remaining_due) + " due symbols");
   g_last_degraded_state=g_runtime.degraded;
   ASC_LogHeartbeatDiagnosticsSummary(initial_due,remaining_due);

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

   ASC_ExplorerMaybeRender(g_explorer,g_settings,g_runtime,g_prepared_buckets,g_symbols,g_symbol_count,true,g_logger);
   ASC_SyncPreparedRuntimeMetadata();
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
   g_runtime.mode=ASC_RUNTIME_WARMUP;
   g_runtime.runtime_dirty=true;
   ASC_ExplorerInit(g_explorer,ChartID());
   g_logger.Info("Explorer","init chart=" + IntegerToString((int)ChartID()) + ", server=" + g_runtime.server_clean);
   ASC_ExplorerMaybeRender(g_explorer,g_settings,g_runtime,g_prepared_buckets,g_symbols,g_symbol_count,true,g_logger);
   ASC_SyncPreparedRuntimeMetadata();
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
   g_logger.Info("Explorer","shutdown server=" + g_runtime.server_clean);
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
      ASC_ExplorerMaybeRender(g_explorer,g_settings,g_runtime,g_prepared_buckets,g_symbols,g_symbol_count,true,g_logger);
      ASC_SyncPreparedRuntimeMetadata();
      return;
     }

   if(id!=CHARTEVENT_OBJECT_CLICK)
      return;
   if(StringFind(sparam,ASC_HUD_PREFIX)!=0)
      return;

   ASC_ExplorerHandleAction(g_explorer,g_settings,g_runtime,g_prepared_buckets,sparam,g_symbols,g_symbol_count,g_logger);
   ASC_ExplorerMaybeRender(g_explorer,g_settings,g_runtime,g_prepared_buckets,g_symbols,g_symbol_count,true,g_logger);
   ASC_SyncPreparedRuntimeMetadata();
  }
