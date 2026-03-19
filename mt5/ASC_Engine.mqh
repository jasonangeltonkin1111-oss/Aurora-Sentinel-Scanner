#ifndef ASC_ENGINE_MQH
#define ASC_ENGINE_MQH

#include "ASC_Common.mqh"
#include "ASC_Storage.mqh"
#include "ASC_Diagnostics.mqh"
#include "ASC_UI.mqh"

// ============================================================================
// ASC Engine Shell
// Timer-driven runtime shell only. This layer exposes a kernel that can run
// before any market/domain logic exists.
// ============================================================================

struct ASC_DueServiceSlot
  {
   string             name;
   bool               enabled;
   bool               due;
   ASC_ServiceClass   service_class;
   ASC_ServiceOutcome last_outcome;
   datetime           last_run_at;
  };

struct ASC_RuntimeMemory
  {
   ASC_RuntimeMode        mode;
   ASC_RuntimeMode        previous_mode;
   ASC_ContinuityOrigin   continuity_origin;
   ASC_HydrationState     hydration_state;
   ASC_PublicationState   publication_state;
   bool                   paused_requested;
   bool                   degraded_requested;
   bool                   recovery_hold_requested;
   bool                   restore_required;
   bool                   storage_hook_ready;
   bool                   diagnostics_hook_ready;
   bool                   ui_hook_ready;
   bool                   cycle_in_progress;
   bool                   cycle_reentry_blocked;
   ulong                  cycle_counter;
   int                    consecutive_reentry_skips;
   datetime               last_cycle_started_at;
   datetime               last_cycle_finished_at;
   datetime               last_cycle_snapshot_at;
   datetime               last_restore_at;
   datetime               last_safe_publish_at;
   datetime               last_summary_eligible_at;
   uint                   last_deinit_reason;
   ASC_DueServiceSlot     due_services[4];
   ASC_RuntimeSnapshot    prepared_snapshot;
   ASC_RuntimeRestoreOutcome last_restore_outcome;
   ASC_RuntimeStateLoadResult runtime_state_load;
   ASC_JournalEntryMetadata last_commit_meta;
   ASC_ReasonSet          last_reason;
  };

class ASC_Engine
  {
private:
   ASC_RuntimeMemory       m_runtime;
   ASC_RuntimeConfig       m_config;
   ASC_DiagnosticsLogger   m_logger;
   ASC_UIRuntimeHUD        m_ui;

private:
   void ConfigureRuntimeConfig(const int timer_seconds)
     {
      m_config.ScannerEnabled             = true;
      m_config.TimerSeconds               = timer_seconds;
      m_config.MaxWorkItemsPerCycle       = 1;
      m_config.MaxRestoreItemsPerCycle    = 1;
      m_config.MaxPublishCommitsPerCycle  = 1;
      m_config.WarmupTargetMinutes        = 5;
      m_config.Layer1CoverageTargetMinutes = 0;
      m_config.SnapshotCoverageTargetMinutes = 0;
      m_config.SurfaceCoverageTargetMinutes = 0;
      m_config.DeepCoverageTargetMinutes  = 0;
      m_config.AllowDegradedPublication   = false;
      m_config.PauseRequested             = false;
      m_config.UseCommonFiles             = true;
      m_config.SchemaVersion              = "phase1";
      m_config.BuildId                    = "phase1-shell";
     }

   void ConfigureDueServices()
     {
      m_runtime.due_services[0].name          = "kernel-safety";
      m_runtime.due_services[0].enabled       = true;
      m_runtime.due_services[0].due           = true;
      m_runtime.due_services[0].service_class = ASC_SERVICE_BOOTSTRAP;
      m_runtime.due_services[0].last_outcome  = ASC_OUTCOME_SKIPPED;
      m_runtime.due_services[0].last_run_at   = 0;

      m_runtime.due_services[1].name          = "restore";
      m_runtime.due_services[1].enabled       = true;
      m_runtime.due_services[1].due           = true;
      m_runtime.due_services[1].service_class = ASC_SERVICE_CONTINUITY;
      m_runtime.due_services[1].last_outcome  = ASC_OUTCOME_SKIPPED;
      m_runtime.due_services[1].last_run_at   = 0;

      m_runtime.due_services[2].name          = "runtime-state-commit";
      m_runtime.due_services[2].enabled       = true;
      m_runtime.due_services[2].due           = true;
      m_runtime.due_services[2].service_class = ASC_SERVICE_PUBLISH_CRITICAL;
      m_runtime.due_services[2].last_outcome  = ASC_OUTCOME_SKIPPED;
      m_runtime.due_services[2].last_run_at   = 0;

      m_runtime.due_services[3].name          = "operator-request-queue";
      m_runtime.due_services[3].enabled       = true;
      m_runtime.due_services[3].due           = true;
      m_runtime.due_services[3].service_class = ASC_SERVICE_OPERATOR_REQUEST;
      m_runtime.due_services[3].last_outcome  = ASC_OUTCOME_SKIPPED;
      m_runtime.due_services[3].last_run_at   = 0;
     }

   void ResetRuntimeMemory()
     {
      ZeroMemory(m_runtime);
      m_runtime.mode                    = ASC_RUNTIME_BOOT;
      m_runtime.previous_mode           = ASC_RUNTIME_BOOT;
      m_runtime.continuity_origin       = ASC_CONTINUITY_FRESH;
      m_runtime.hydration_state         = ASC_HYDRATION_EMPTY;
      m_runtime.publication_state       = ASC_PUBLICATION_BLOCKED;
      m_runtime.restore_required        = true;
      ConfigureDueServices();
      PrepareRuntimeSnapshot();
     }

   int DueServiceIndexByName(const string service_name) const
     {
      for(int i = 0; i < ArraySize(m_runtime.due_services); ++i)
        {
         if(m_runtime.due_services[i].name == service_name)
            return(i);
        }
      return(-1);
     }

   void MarkDue(const string service_name,const bool due)
     {
      const int index = DueServiceIndexByName(service_name);
      if(index >= 0)
         m_runtime.due_services[index].due = due;
     }

   void Emit(const ASC_LogEvent &event_record)
     {
      if(m_runtime.diagnostics_hook_ready)
         m_logger.Emit(event_record);
     }

   void EmitModeTransition(const ASC_RuntimeMode previous_mode,const ASC_RuntimeMode next_mode,const string cause)
     {
      if(previous_mode == next_mode)
         return;

      ASC_ReasonSet reason;
      ZeroMemory(reason);
      reason.ReasonCode = cause;
      Emit(ASC_DiagnosticsModeTransitionEvent(previous_mode,next_mode,(long)m_runtime.cycle_counter,cause,reason));
     }

   void SetMode(const ASC_RuntimeMode next_mode,const string cause)
     {
      if(m_runtime.mode == next_mode)
         return;

      const ASC_RuntimeMode previous_mode = m_runtime.mode;
      m_runtime.previous_mode = m_runtime.mode;
      m_runtime.mode          = next_mode;
      EmitModeTransition(previous_mode,next_mode,cause);
     }

   void EvaluateMode()
     {
      if(m_runtime.paused_requested)
        {
         SetMode(ASC_RUNTIME_PAUSED,"pause-requested");
         return;
        }

      if(m_runtime.recovery_hold_requested)
        {
         SetMode(ASC_RUNTIME_RECOVERY_HOLD,"recovery-hold-requested");
         return;
        }

      if(m_runtime.degraded_requested)
        {
         SetMode(ASC_RUNTIME_DEGRADED,"degraded-requested");
         return;
        }

      if(m_runtime.restore_required)
        {
         SetMode(ASC_RUNTIME_RESTORE,"restore-required");
         return;
        }

      if(m_runtime.hydration_state == ASC_HYDRATION_EMPTY ||
         m_runtime.hydration_state == ASC_HYDRATION_RESTORE_PENDING ||
         m_runtime.hydration_state == ASC_HYDRATION_MINIMUM_PENDING)
        {
         SetMode(ASC_RUNTIME_WARMUP,"hydration-incomplete");
         return;
        }

      SetMode(ASC_RUNTIME_STEADY_STATE,"runtime-ready");
     }

   void HandleShellBehaviorForMode()
     {
      if(m_runtime.mode == ASC_RUNTIME_PAUSED)
        {
         m_runtime.publication_state = ASC_PUBLICATION_WITHHELD;
         return;
        }

      if(m_runtime.mode == ASC_RUNTIME_DEGRADED)
        {
         m_runtime.publication_state = ASC_PUBLICATION_DEGRADED;
         m_runtime.continuity_origin = ASC_CONTINUITY_DEGRADED;
         return;
        }

      if(m_runtime.mode == ASC_RUNTIME_RECOVERY_HOLD)
        {
         m_runtime.publication_state = ASC_PUBLICATION_WITHHELD;
         m_runtime.continuity_origin = ASC_CONTINUITY_RECOVERY_HOLD;
         return;
        }

      if(m_runtime.mode == ASC_RUNTIME_RESTORE || m_runtime.mode == ASC_RUNTIME_WARMUP)
        {
         m_runtime.publication_state = ASC_PUBLICATION_PENDING_SAFE;
         return;
        }

      m_runtime.publication_state = ASC_PUBLICATION_READY;
     }

   ASC_RuntimeSnapshot BuildPreparedSnapshot() const
     {
      ASC_RuntimeSnapshot snapshot;
      ZeroMemory(snapshot);
      snapshot.Mode                         = m_runtime.mode;
      snapshot.ContinuityOrigin             = m_runtime.continuity_origin;
      snapshot.HydrationState               = m_runtime.hydration_state;
      snapshot.RuntimePublicationState      = m_runtime.publication_state;
      snapshot.CycleCounters.CycleSequence  = (long)m_runtime.cycle_counter;
      snapshot.CycleCounters.CompletedCycles = (m_runtime.last_cycle_finished_at > 0 ? (long)m_runtime.cycle_counter : (long)(m_runtime.cycle_counter > 0 ? m_runtime.cycle_counter - 1 : 0));
      snapshot.CycleCounters.SkippedReentryCycles = (long)m_runtime.consecutive_reentry_skips;
      snapshot.CycleCounters.ConsecutiveReentrySkips = (long)m_runtime.consecutive_reentry_skips;
      snapshot.CycleCounters.LastCycleStartedAt = m_runtime.last_cycle_started_at;
      snapshot.CycleCounters.LastCycleFinishedAt = m_runtime.last_cycle_finished_at;
      snapshot.CycleCounters.LastHeartbeatAt = TimeCurrent();
      snapshot.ServerTime                   = TimeCurrent();
      snapshot.LocalTime                    = TimeLocal();
      snapshot.LastRestoreAt                = m_runtime.last_restore_at;
      snapshot.LastSafePublishAt            = m_runtime.last_safe_publish_at;
      snapshot.LastSummaryEligibleAt        = m_runtime.last_summary_eligible_at;
      snapshot.WarmupComplete               = (m_runtime.hydration_state == ASC_HYDRATION_MINIMUM_READY || m_runtime.hydration_state == ASC_HYDRATION_PARTIAL || m_runtime.hydration_state == ASC_HYDRATION_CURRENT || m_runtime.hydration_state == ASC_HYDRATION_FROZEN);
      snapshot.DegradedActive               = (m_runtime.mode == ASC_RUNTIME_DEGRADED);
      snapshot.RecoveryBlocked              = (m_runtime.mode == ASC_RUNTIME_RECOVERY_HOLD);
      snapshot.PublishHeadline              = "phase1 shell | mode=" + ASC_RuntimeModeText(snapshot.Mode) + " | hydration=" + ASC_HydrationStateText(snapshot.HydrationState);
      snapshot.Reason                       = m_runtime.last_reason;
      return(snapshot);
     }

   void PrepareRuntimeSnapshot()
     {
      m_runtime.prepared_snapshot = BuildPreparedSnapshot();
      m_runtime.last_cycle_snapshot_at = TimeCurrent();
     }

   void RefreshUI()
     {
      if(m_runtime.ui_hook_ready)
         m_ui.Refresh(m_runtime.prepared_snapshot);
     }

   ASC_ServiceOutcome InspectJournals()
     {
      ASC_ReasonSet reason;
      ZeroMemory(reason);
      int journal_count = 0;
      int corrupt_count = 0;
      string filter = ASC_RuntimeJournalFolder(m_config) + "/*.journal";
      string found_name = "";
      long handle = FileFindFirst(filter,found_name,m_config.UseCommonFiles);
      if(handle != INVALID_HANDLE)
        {
         do
           {
            journal_count++;
            ASC_RuntimeStateLoadResult journal_result = InspectWriteJournal(m_config,ASC_RuntimeJournalFolder(m_config) + "/" + found_name);
            if(journal_result.Condition == ASC_RUNTIME_STATE_CORRUPT)
              {
               corrupt_count++;
               reason = journal_result.Reason;
              }
           }
         while(FileFindNext(handle,found_name));
         FileFindClose(handle);
        }
      else
        {
         reason.ReasonCode = "JOURNAL_EMPTY";
         reason.ReasonDetail = "no runtime-state journal files were present";
         reason.ReasonContext = ASC_RuntimeJournalFolder(m_config);
        }

      const ASC_ServiceOutcome outcome = (corrupt_count > 0 ? ASC_OUTCOME_INVALID_DATA : ASC_OUTCOME_SUCCESS);
      Emit(ASC_DiagnosticsJournalInspectionEvent(outcome,(long)m_runtime.cycle_counter,ASC_RuntimeJournalFolder(m_config),journal_count,corrupt_count,reason));
      return(outcome);
     }

   ASC_ServiceOutcome RunRestoreFlow()
     {
      ZeroMemory(m_runtime.last_restore_outcome);
      m_runtime.last_restore_outcome.Outcome = ASC_OUTCOME_FAILED;
      m_runtime.last_restore_outcome.RecommendedMode = ASC_RUNTIME_WARMUP;
      m_runtime.last_restore_outcome.ContinuityOrigin = ASC_CONTINUITY_REBUILT_CLEAN;
      m_runtime.last_restore_outcome.JournalsInspected = false;
      m_runtime.last_restore_outcome.RuntimeStateLoaded = false;

      InspectJournals();
      m_runtime.last_restore_outcome.JournalsInspected = true;

      ZeroMemory(m_runtime.runtime_state_load);
      if(ASC_RestoreRuntimeStateCompatibility(m_config,m_runtime.runtime_state_load))
        {
         m_runtime.last_restore_outcome.Outcome = ASC_OUTCOME_SUCCESS;
         m_runtime.last_restore_outcome.RuntimeStateLoaded = true;
         m_runtime.last_restore_outcome.ContinuityOrigin = m_runtime.runtime_state_load.Payload.Snapshot.ContinuityOrigin;
         m_runtime.continuity_origin = m_runtime.runtime_state_load.Payload.Snapshot.ContinuityOrigin;
         m_runtime.hydration_state = m_runtime.runtime_state_load.Payload.Snapshot.HydrationState;
         m_runtime.publication_state = m_runtime.runtime_state_load.Payload.Snapshot.RuntimePublicationState;
         m_runtime.last_restore_at = TimeCurrent();
         m_runtime.restore_required = false;
        }
      else if(m_runtime.runtime_state_load.Condition == ASC_RUNTIME_STATE_MISSING)
        {
         m_runtime.last_restore_outcome.Outcome = ASC_OUTCOME_SKIPPED;
         m_runtime.last_restore_outcome.ContinuityOrigin = ASC_CONTINUITY_REBUILT_CLEAN;
         m_runtime.continuity_origin = ASC_CONTINUITY_REBUILT_CLEAN;
         m_runtime.hydration_state = ASC_HYDRATION_EMPTY;
         m_runtime.restore_required = false;
         m_runtime.last_reason = m_runtime.runtime_state_load.Reason;
        }
      else
        {
         m_runtime.last_restore_outcome.Outcome = ASC_OUTCOME_INVALID_DATA;
         m_runtime.last_restore_outcome.CompatibilityHold = true;
         m_runtime.last_restore_outcome.ContinuityOrigin = ASC_CONTINUITY_RECOVERY_HOLD;
         m_runtime.continuity_origin = ASC_CONTINUITY_RECOVERY_HOLD;
         m_runtime.hydration_state = ASC_HYDRATION_FROZEN;
         m_runtime.restore_required = false;
         m_runtime.recovery_hold_requested = true;
         m_runtime.last_reason = m_runtime.runtime_state_load.Reason;
        }

      m_runtime.last_restore_outcome.Reason = m_runtime.runtime_state_load.Reason;
      Emit(ASC_DiagnosticsRestoreEvent(m_runtime.last_restore_outcome.Outcome,
                                       m_runtime.mode,
                                       m_runtime.previous_mode,
                                       (long)m_runtime.cycle_counter,
                                       m_runtime.continuity_origin,
                                       m_runtime.hydration_state,
                                       m_runtime.last_restore_outcome.JournalsInspected,
                                       m_runtime.last_restore_outcome.RuntimeStateLoaded,
                                       m_runtime.last_restore_outcome.Reason));
      return(m_runtime.last_restore_outcome.Outcome);
     }

   ASC_ServiceOutcome CommitRuntimeState()
     {
      ASC_ReasonSet reason;
      ZeroMemory(reason);
      ZeroMemory(m_runtime.last_commit_meta);
      m_runtime.last_commit_meta.CycleSequence = (long)m_runtime.cycle_counter;

      if(m_config.MaxPublishCommitsPerCycle <= 0)
        {
         reason.ReasonCode = "COMMIT_DISABLED";
         reason.ReasonDetail = "runtime-state commit budget was zero";
         reason.ReasonContext = "MaxPublishCommitsPerCycle";
         Emit(ASC_DiagnosticsRuntimeStateCommitEvent(ASC_OUTCOME_BUDGET_EXCEEDED,m_runtime.mode,m_runtime.previous_mode,(long)m_runtime.cycle_counter,ASC_RuntimeStateFinalPath(m_config),"",reason));
         return(ASC_OUTCOME_BUDGET_EXCEEDED);
        }

      PrepareRuntimeSnapshot();
      if(!ASC_CommitRuntimeStateClassA(m_config,m_runtime.prepared_snapshot,m_runtime.last_commit_meta,reason))
        {
         m_runtime.last_reason = reason;
         Emit(ASC_DiagnosticsRuntimeStateCommitEvent(ASC_OUTCOME_FAILED,m_runtime.mode,m_runtime.previous_mode,(long)m_runtime.cycle_counter,ASC_RuntimeStateFinalPath(m_config),m_runtime.last_commit_meta.TargetName,reason));
         return(ASC_OUTCOME_FAILED);
        }

      m_runtime.last_safe_publish_at = TimeCurrent();
      m_runtime.last_reason = m_runtime.last_commit_meta.Reason;
      Emit(ASC_DiagnosticsRuntimeStateCommitEvent(ASC_OUTCOME_SUCCESS,m_runtime.mode,m_runtime.previous_mode,(long)m_runtime.cycle_counter,ASC_RuntimeStateFinalPath(m_config),m_runtime.last_commit_meta.TargetName,m_runtime.last_commit_meta.Reason));
      return(ASC_OUTCOME_SUCCESS);
     }

   ASC_ServiceOutcome DispatchService(const int index)
     {
      ASC_ReasonSet reason;
      ZeroMemory(reason);
      if(index < 0 || index >= ArraySize(m_runtime.due_services))
        {
         reason.ReasonCode = "SERVICE_INDEX_INVALID";
         reason.ReasonDetail = "due service index was outside bounds";
         reason.ReasonContext = "DispatchService";
         return(ASC_OUTCOME_INVALID_DATA);
        }

      ASC_DueServiceSlot &slot = m_runtime.due_services[index];
      const bool was_due = slot.due;
      ASC_ServiceOutcome outcome = ASC_OUTCOME_SKIPPED;

      if(!slot.enabled)
         outcome = ASC_OUTCOME_SKIPPED;
      else if(!slot.due)
         outcome = ASC_OUTCOME_DEFERRED;
      else if(slot.name == "restore")
         outcome = RunRestoreFlow();
      else if(slot.name == "runtime-state-commit")
         outcome = CommitRuntimeState();
      else
         outcome = ASC_OUTCOME_SKIPPED;

      slot.last_outcome = outcome;
      slot.last_run_at  = TimeCurrent();
      if(slot.due)
         slot.due = false;

      Emit(ASC_DiagnosticsDueServiceDispatchEvent(slot.name,slot.service_class,outcome,m_runtime.mode,m_runtime.previous_mode,(long)m_runtime.cycle_counter,was_due,slot.enabled,reason));
      return(outcome);
     }

   void DispatchDueServices()
     {
      for(int i = 0; i < ArraySize(m_runtime.due_services); ++i)
         DispatchService(i);
     }

public:
                     ASC_Engine()
                     {
                        m_logger.Configure("runtime","phase1");
                        ConfigureRuntimeConfig(1);
                        ResetRuntimeMemory();
                     }

   void              BindStorageHook(const bool ready)      { m_runtime.storage_hook_ready = ready; }
   void              BindDiagnosticsHook(const bool ready)  { m_runtime.diagnostics_hook_ready = ready; }
   void              BindUIHook(const bool ready)           { m_runtime.ui_hook_ready = ready; }
   void              RequestPause(const bool enabled)       { m_runtime.paused_requested = enabled; }
   void              RequestDegraded(const bool enabled)    { m_runtime.degraded_requested = enabled; }
   void              RequestRecoveryHold(const bool enabled){ m_runtime.recovery_hold_requested = enabled; }

   int               Init(const int timer_seconds)
     {
      if(timer_seconds <= 0)
         return(INIT_PARAMETERS_INCORRECT);

      ConfigureRuntimeConfig(timer_seconds);
      ResetRuntimeMemory();
      BindStorageHook(true);
      BindDiagnosticsHook(true);
      BindUIHook(true);
      m_ui.Configure("Aurora Sentinel Phase 1");
      Emit(ASC_DiagnosticsStartupEvent("runtime",m_config.BuildId,timer_seconds,m_runtime.storage_hook_ready,m_runtime.diagnostics_hook_ready,m_runtime.ui_hook_ready));

      EventSetTimer(timer_seconds);
      Timer();
      return(INIT_SUCCEEDED);
     }

   void              Deinit(const int reason)
     {
      EventKillTimer();
      m_runtime.last_deinit_reason = (uint)reason;
      m_runtime.cycle_in_progress  = false;
      if(m_runtime.ui_hook_ready)
         m_ui.Clear();
     }

   void              Tick()
     {
      // Timer-driven kernel only. Heavy runtime work intentionally excluded.
     }

   void              Timer()
     {
      if(m_runtime.cycle_in_progress)
        {
         m_runtime.cycle_reentry_blocked = true;
         m_runtime.consecutive_reentry_skips++;
         ASC_ReasonSet reason;
         ZeroMemory(reason);
         reason.ReasonCode = "CYCLE_REENTRY_BLOCKED";
         reason.ReasonDetail = "timer cycle was skipped because a prior cycle was still running";
         reason.ReasonContext = "Timer";
         Emit(ASC_DiagnosticsReentrySkipEvent((long)m_runtime.cycle_counter,m_runtime.mode,m_runtime.consecutive_reentry_skips,reason));
         return;
        }

      m_runtime.cycle_in_progress      = true;
      m_runtime.cycle_reentry_blocked  = false;
      m_runtime.consecutive_reentry_skips = 0;
      m_runtime.cycle_counter++;
      m_runtime.last_cycle_started_at  = TimeCurrent();
      MarkDue("restore",m_runtime.restore_required);
      MarkDue("runtime-state-commit",true);

      EvaluateMode();
      HandleShellBehaviorForMode();
      DispatchDueServices();
      EvaluateMode();
      HandleShellBehaviorForMode();
      PrepareRuntimeSnapshot();
      RefreshUI();

      m_runtime.last_cycle_finished_at = TimeCurrent();
      m_runtime.cycle_in_progress      = false;
     }

   const ASC_RuntimeMemory &Runtime() const
     {
      return(m_runtime);
     }

   const ASC_RuntimeConfig &Config() const
     {
      return(m_config);
     }

   const ASC_RuntimeSnapshot &PreparedSnapshot() const
     {
      return(m_runtime.prepared_snapshot);
     }
  };

#endif
