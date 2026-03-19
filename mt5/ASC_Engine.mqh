#ifndef ASC_ENGINE_MQH
#define ASC_ENGINE_MQH

#include "ASC_Common.mqh"

// ============================================================================
// ASC Engine Shell
// Timer-driven runtime shell only. This layer exposes a kernel that can run
// before any market/domain logic exists.
// ============================================================================

struct ASC_DueServiceSlot
  {
   string            name;
   bool              enabled;
   bool              due;
   ASC_ServiceClass  service_class;
   ASC_ServiceOutcome last_outcome;
   datetime          last_run_at;
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
   datetime               last_cycle_started_at;
   datetime               last_cycle_finished_at;
   datetime               last_cycle_snapshot_at;
   uint                   last_deinit_reason;
   ASC_DueServiceSlot     due_services[4];
  };

class ASC_Engine
  {
private:
   ASC_RuntimeMemory m_runtime;

private:
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
      m_runtime.mode                  = ASC_RUNTIME_BOOT;
      m_runtime.previous_mode         = ASC_RUNTIME_BOOT;
      m_runtime.continuity_origin     = ASC_CONTINUITY_FRESH;
      m_runtime.hydration_state       = ASC_HYDRATION_EMPTY;
      m_runtime.publication_state     = ASC_PUBLICATION_BLOCKED;
      m_runtime.paused_requested      = false;
      m_runtime.degraded_requested    = false;
      m_runtime.recovery_hold_requested = false;
      m_runtime.restore_required      = true;
      m_runtime.storage_hook_ready    = false;
      m_runtime.diagnostics_hook_ready = false;
      m_runtime.ui_hook_ready         = false;
      m_runtime.cycle_in_progress     = false;
      m_runtime.cycle_reentry_blocked = false;
      m_runtime.cycle_counter         = 0;
      m_runtime.last_cycle_started_at = 0;
      m_runtime.last_cycle_finished_at = 0;
      m_runtime.last_cycle_snapshot_at = 0;
      m_runtime.last_deinit_reason    = 0;
      ConfigureDueServices();
     }

   void SetMode(const ASC_RuntimeMode next_mode)
     {
      if(m_runtime.mode == next_mode)
         return;

      m_runtime.previous_mode = m_runtime.mode;
      m_runtime.mode          = next_mode;
     }

   void EvaluateMode()
     {
      // mode evaluation
      if(m_runtime.paused_requested)
        {
         SetMode(ASC_RUNTIME_PAUSED);
         return;
        }

      if(m_runtime.recovery_hold_requested)
        {
         SetMode(ASC_RUNTIME_RECOVERY_HOLD);
         return;
        }

      if(m_runtime.degraded_requested)
        {
         SetMode(ASC_RUNTIME_DEGRADED);
         return;
        }

      if(m_runtime.restore_required)
        {
         SetMode(ASC_RUNTIME_RESTORE);
         return;
        }

      if(m_runtime.hydration_state == ASC_HYDRATION_EMPTY ||
         m_runtime.hydration_state == ASC_HYDRATION_RESTORE_PENDING ||
         m_runtime.hydration_state == ASC_HYDRATION_MINIMUM_PENDING)
        {
         SetMode(ASC_RUNTIME_WARMUP);
         return;
        }

      SetMode(ASC_RUNTIME_STEADY_STATE);
     }

   ASC_ServiceOutcome DispatchServicePlaceholder(const int index)
     {
      if(index < 0 || index >= ArraySize(m_runtime.due_services))
         return(ASC_OUTCOME_INVALID_DATA);

      if(!m_runtime.due_services[index].enabled)
         return(ASC_OUTCOME_SKIPPED);

      if(!m_runtime.due_services[index].due)
         return(ASC_OUTCOME_DEFERRED);

      if(m_runtime.due_services[index].name == "restore")
        {
         if(m_runtime.mode == ASC_RUNTIME_RESTORE)
           {
            m_runtime.hydration_state   = ASC_HYDRATION_RESTORE_PENDING;
            m_runtime.continuity_origin = ASC_CONTINUITY_RESTORED_LAST_GOOD;
            m_runtime.restore_required  = false;
            m_runtime.due_services[index].last_outcome = ASC_OUTCOME_SKIPPED;
           }
         else
            m_runtime.due_services[index].last_outcome = ASC_OUTCOME_DEFERRED;
        }
      else if(m_runtime.due_services[index].name == "kernel-safety")
        {
         m_runtime.due_services[index].last_outcome = ASC_OUTCOME_SKIPPED;
        }
      else if(m_runtime.due_services[index].name == "runtime-state-commit")
        {
         m_runtime.due_services[index].last_outcome = ASC_OUTCOME_SKIPPED;
        }
      else if(m_runtime.due_services[index].name == "operator-request-queue")
        {
         m_runtime.due_services[index].last_outcome = ASC_OUTCOME_SKIPPED;
        }
      else
        {
         m_runtime.due_services[index].last_outcome = ASC_OUTCOME_SKIPPED;
        }

      m_runtime.due_services[index].last_run_at = TimeCurrent();
      m_runtime.due_services[index].due         = false;
      return(m_runtime.due_services[index].last_outcome);
     }

   void DispatchDueServices()
     {
      // due-service dispatch
      for(int i = 0; i < ArraySize(m_runtime.due_services); ++i)
         DispatchServicePlaceholder(i);
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
         return;
        }

      if(m_runtime.mode == ASC_RUNTIME_RECOVERY_HOLD)
        {
         m_runtime.publication_state = ASC_PUBLICATION_WITHHELD;
         m_runtime.continuity_origin = ASC_CONTINUITY_RECOVERY_HOLD;
         return;
        }

      if(m_runtime.mode == ASC_RUNTIME_RESTORE)
        {
         m_runtime.publication_state = ASC_PUBLICATION_PENDING_SAFE;
         return;
        }

      if(m_runtime.mode == ASC_RUNTIME_WARMUP)
        {
         m_runtime.publication_state = ASC_PUBLICATION_PENDING_SAFE;
         return;
        }

      m_runtime.publication_state = ASC_PUBLICATION_READY;
     }

   void RefreshCycleSnapshot()
     {
      // cycle end snapshot refresh
      m_runtime.last_cycle_snapshot_at = TimeCurrent();
     }

public:
                     ASC_Engine()
                     {
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
      ResetRuntimeMemory();
      SetMode(ASC_RUNTIME_BOOT);

      if(timer_seconds <= 0)
         return(INIT_PARAMETERS_INCORRECT);

      EventSetTimer(timer_seconds);
      return(INIT_SUCCEEDED);
     }

   void              Deinit(const int reason)
     {
      EventKillTimer();
      m_runtime.last_deinit_reason = (uint)reason;
      m_runtime.cycle_in_progress  = false;
     }

   void              Tick()
     {
      // Timer-driven kernel only. Heavy runtime work intentionally excluded.
     }

   void              Timer()
     {
      if(m_runtime.cycle_in_progress)
        {
         // cycle skip on re-entry
         m_runtime.cycle_reentry_blocked = true;
         return;
        }

      m_runtime.cycle_in_progress     = true;
      m_runtime.cycle_reentry_blocked = false;
      m_runtime.cycle_counter++;
      m_runtime.last_cycle_started_at = TimeCurrent();

      // cycle start
      EvaluateMode();
      HandleShellBehaviorForMode();
      DispatchDueServices();
      EvaluateMode();
      HandleShellBehaviorForMode();
      RefreshCycleSnapshot();

      m_runtime.last_cycle_finished_at = TimeCurrent();
      m_runtime.cycle_in_progress      = false;
     }

   const ASC_RuntimeMemory &Runtime() const
     {
      return(m_runtime);
     }
  };

#endif
