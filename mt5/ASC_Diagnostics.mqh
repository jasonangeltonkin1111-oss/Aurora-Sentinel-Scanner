#ifndef ASC_DIAGNOSTICS_MQH
#define ASC_DIAGNOSTICS_MQH

#include "ASC_Common.mqh"

#define ASC_DIAGNOSTICS_SCHEMA_VERSION "ASC_DIAGNOSTICS_V1"
#define ASC_DIAGNOSTICS_MAX_MESSAGE_CHARS 1900
#define ASC_DIAGNOSTICS_MAX_DETAIL_CHARS  240
#define ASC_DIAGNOSTICS_MAX_CONTEXT_CHARS 120
#define ASC_DIAGNOSTICS_MAX_VALUE_CHARS   96
#define ASC_DIAGNOSTICS_MAX_PAIRS         8
#define ASC_DIAGNOSTICS_LINE_PREFIX       "ASC|"

// ============================================================================
// ASC Diagnostics Phase 1 Shell
// Runtime/event diagnostics only. This layer intentionally excludes symbol,
// ranking, publication, and HUD-specific formatting concerns.
// ============================================================================

enum ASC_LogSeverity
  {
   ASC_LOG_DEBUG = 0,
   ASC_LOG_INFO,
   ASC_LOG_WARN,
   ASC_LOG_ERROR
  };

enum ASC_LogEventClass
  {
   ASC_LOG_EVENT_STARTUP = 0,
   ASC_LOG_EVENT_RESTORE,
   ASC_LOG_EVENT_MODE_TRANSITION,
   ASC_LOG_EVENT_REENTRY_SKIP,
   ASC_LOG_EVENT_DUE_SERVICE_DISPATCH,
   ASC_LOG_EVENT_JOURNAL_INSPECTION,
   ASC_LOG_EVENT_RUNTIME_STATE_COMMIT,
   ASC_LOG_EVENT_DEGRADED_TRANSITION,
   ASC_LOG_EVENT_PAUSED_TRANSITION,
   ASC_LOG_EVENT_RECOVERY_HOLD_TRANSITION
  };

string ASC_LogSeverityText(const ASC_LogSeverity severity)
  {
   switch(severity)
     {
      case ASC_LOG_INFO:  return("INFO");
      case ASC_LOG_WARN:  return("WARN");
      case ASC_LOG_ERROR: return("ERROR");
      default:            return("DEBUG");
     }
  }

string ASC_LogEventClassText(const ASC_LogEventClass event_class)
  {
   switch(event_class)
     {
      case ASC_LOG_EVENT_RESTORE:                return("RESTORE");
      case ASC_LOG_EVENT_MODE_TRANSITION:        return("MODE_TRANSITION");
      case ASC_LOG_EVENT_REENTRY_SKIP:           return("REENTRY_SKIP");
      case ASC_LOG_EVENT_DUE_SERVICE_DISPATCH:   return("DUE_SERVICE_DISPATCH");
      case ASC_LOG_EVENT_JOURNAL_INSPECTION:     return("JOURNAL_INSPECTION");
      case ASC_LOG_EVENT_RUNTIME_STATE_COMMIT:   return("RUNTIME_STATE_COMMIT");
      case ASC_LOG_EVENT_DEGRADED_TRANSITION:    return("DEGRADED_TRANSITION");
      case ASC_LOG_EVENT_PAUSED_TRANSITION:      return("PAUSED_TRANSITION");
      case ASC_LOG_EVENT_RECOVERY_HOLD_TRANSITION:return("RECOVERY_HOLD_TRANSITION");
      default:                                   return("STARTUP");
     }
  }

struct ASC_LogReason
  {
   string Code;
   string Detail;
   string Context;
  };

struct ASC_LogField
  {
   string Key;
   string Value;
  };

struct ASC_LogEvent
  {
   string             SchemaVersion;
   datetime           EventTime;
   ASC_LogSeverity    Severity;
   ASC_LogEventClass  EventClass;
   string             EventName;
   string             Component;
   string             Action;
   string             Outcome;
   long               CycleSequence;
   ASC_RuntimeMode    RuntimeMode;
   ASC_RuntimeMode    PreviousMode;
   ASC_ServiceClass   ServiceClass;
   string             ServiceKey;
   string             SubjectKind;
   string             SubjectKey;
   bool               Success;
   bool               Skipped;
   bool               Failure;
   ASC_LogReason      Reason;
   int                FieldCount;
   ASC_LogField       Fields[ASC_DIAGNOSTICS_MAX_PAIRS];
  };

string ASC_DiagnosticsClip(const string value,const int limit)
  {
   if(limit <= 0)
      return("");

   if(StringLen(value) <= limit)
      return(value);

   if(limit <= 3)
      return(StringSubstr(value,0,limit));

   return(StringSubstr(value,0,limit - 3) + "...");
  }

string ASC_DiagnosticsSanitize(const string value,const int limit)
  {
   string normalized = value;
   StringReplace(normalized,"\r"," ");
   StringReplace(normalized,"\n"," ");
   StringReplace(normalized,"|","/");
   StringReplace(normalized,"=",":");
   while(StringFind(normalized,"  ") >= 0)
      StringReplace(normalized,"  "," ");
   return(ASC_DiagnosticsClip(normalized,limit));
  }

string ASC_DiagnosticsBoolText(const bool value)
  {
   return(value ? "true" : "false");
  }

string ASC_DiagnosticsDateTimeText(const datetime value)
  {
   if(value <= 0)
      return("0");
   return(TimeToString(value,TIME_DATE | TIME_SECONDS));
  }

string ASC_DiagnosticsLongText(const long value)
  {
   return(LongToString(value));
  }

string ASC_DiagnosticsModePair(const ASC_RuntimeMode before_mode,const ASC_RuntimeMode after_mode)
  {
   return(ASC_RuntimeModeText(before_mode) + "->" + ASC_RuntimeModeText(after_mode));
  }

void ASC_DiagnosticsAssignReason(ASC_LogReason &reason,const string code,const string detail,const string context)
  {
   reason.Code    = ASC_DiagnosticsSanitize(code,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   reason.Detail  = ASC_DiagnosticsSanitize(detail,ASC_DIAGNOSTICS_MAX_DETAIL_CHARS);
   reason.Context = ASC_DiagnosticsSanitize(context,ASC_DIAGNOSTICS_MAX_CONTEXT_CHARS);
  }

void ASC_DiagnosticsAssignReasonFromSet(ASC_LogReason &reason,const ASC_ReasonSet &source)
  {
   ASC_DiagnosticsAssignReason(reason,source.ReasonCode,source.ReasonDetail,source.ReasonContext);
  }

ASC_LogSeverity ASC_DiagnosticsSeverityFromOutcome(const ASC_ServiceOutcome outcome)
  {
   switch(outcome)
     {
      case ASC_OUTCOME_SUCCESS:         return(ASC_LOG_INFO);
      case ASC_OUTCOME_SKIPPED:
      case ASC_OUTCOME_DEFERRED:
      case ASC_OUTCOME_NOT_READY:       return(ASC_LOG_WARN);
      case ASC_OUTCOME_INVALID_DATA:
      case ASC_OUTCOME_FAILED:
      case ASC_OUTCOME_BUDGET_EXCEEDED: return(ASC_LOG_ERROR);
      default:                          return(ASC_LOG_DEBUG);
     }
  }

string ASC_DiagnosticsOutcomeText(const ASC_ServiceOutcome outcome)
  {
   return(ASC_ServiceOutcomeText(outcome));
  }

void ASC_DiagnosticsResetEvent(ASC_LogEvent &event_record)
  {
   event_record.SchemaVersion = ASC_DIAGNOSTICS_SCHEMA_VERSION;
   event_record.EventTime     = TimeCurrent();
   event_record.Severity      = ASC_LOG_INFO;
   event_record.EventClass    = ASC_LOG_EVENT_STARTUP;
   event_record.EventName     = "startup";
   event_record.Component     = "runtime";
   event_record.Action        = "observe";
   event_record.Outcome       = "UNKNOWN";
   event_record.CycleSequence = 0;
   event_record.RuntimeMode   = ASC_RUNTIME_BOOT;
   event_record.PreviousMode  = ASC_RUNTIME_BOOT;
   event_record.ServiceClass  = ASC_SERVICE_BOOTSTRAP;
   event_record.ServiceKey    = "";
   event_record.SubjectKind   = "runtime";
   event_record.SubjectKey    = "phase1";
   event_record.Success       = false;
   event_record.Skipped       = false;
   event_record.Failure       = false;
   event_record.FieldCount    = 0;
   ASC_DiagnosticsAssignReason(event_record.Reason,"","","");

   for(int i = 0; i < ASC_DIAGNOSTICS_MAX_PAIRS; ++i)
     {
      event_record.Fields[i].Key   = "";
      event_record.Fields[i].Value = "";
     }
  }

void ASC_DiagnosticsSetOutcome(ASC_LogEvent &event_record,const string outcome,const bool success,const bool skipped,const bool failure)
  {
   event_record.Outcome = ASC_DiagnosticsSanitize(outcome,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   event_record.Success = success;
   event_record.Skipped = skipped;
   event_record.Failure = failure;
  }

bool ASC_DiagnosticsAddField(ASC_LogEvent &event_record,const string key,const string value)
  {
   if(event_record.FieldCount >= ASC_DIAGNOSTICS_MAX_PAIRS)
      return(false);

   event_record.Fields[event_record.FieldCount].Key   = ASC_DiagnosticsSanitize(key,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   event_record.Fields[event_record.FieldCount].Value = ASC_DiagnosticsSanitize(value,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   event_record.FieldCount++;
   return(true);
  }

string ASC_DiagnosticsFormatFieldBag(const ASC_LogEvent &event_record)
  {
   string output = "";
   for(int i = 0; i < event_record.FieldCount; ++i)
     {
      if(event_record.Fields[i].Key == "")
         continue;

      if(output != "")
         output += ";";
      output += event_record.Fields[i].Key + ":" + event_record.Fields[i].Value;
     }
   return(output);
  }

string ASC_DiagnosticsFormatEvent(const ASC_LogEvent &event_record)
  {
   string message = ASC_DIAGNOSTICS_LINE_PREFIX;
   message += "schema=" + ASC_DiagnosticsSanitize(event_record.SchemaVersion,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   message += "|ts=" + ASC_DiagnosticsDateTimeText(event_record.EventTime);
   message += "|sev=" + ASC_LogSeverityText(event_record.Severity);
   message += "|class=" + ASC_LogEventClassText(event_record.EventClass);
   message += "|event=" + ASC_DiagnosticsSanitize(event_record.EventName,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   message += "|component=" + ASC_DiagnosticsSanitize(event_record.Component,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   message += "|action=" + ASC_DiagnosticsSanitize(event_record.Action,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   message += "|outcome=" + ASC_DiagnosticsSanitize(event_record.Outcome,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   message += "|cycle=" + ASC_DiagnosticsLongText(event_record.CycleSequence);
   message += "|mode=" + ASC_RuntimeModeText(event_record.RuntimeMode);
   message += "|prev_mode=" + ASC_RuntimeModeText(event_record.PreviousMode);
   message += "|service_class=" + ASC_ServiceClassText(event_record.ServiceClass);
   message += "|service_key=" + ASC_DiagnosticsSanitize(event_record.ServiceKey,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   message += "|subject_kind=" + ASC_DiagnosticsSanitize(event_record.SubjectKind,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   message += "|subject_key=" + ASC_DiagnosticsSanitize(event_record.SubjectKey,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   message += "|success=" + ASC_DiagnosticsBoolText(event_record.Success);
   message += "|skipped=" + ASC_DiagnosticsBoolText(event_record.Skipped);
   message += "|failure=" + ASC_DiagnosticsBoolText(event_record.Failure);
   message += "|reason_code=" + ASC_DiagnosticsSanitize(event_record.Reason.Code,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   message += "|reason_detail=" + ASC_DiagnosticsSanitize(event_record.Reason.Detail,ASC_DIAGNOSTICS_MAX_DETAIL_CHARS);
   message += "|reason_context=" + ASC_DiagnosticsSanitize(event_record.Reason.Context,ASC_DIAGNOSTICS_MAX_CONTEXT_CHARS);
   message += "|fields=" + ASC_DiagnosticsFormatFieldBag(event_record);
   return(ASC_DiagnosticsClip(message,ASC_DIAGNOSTICS_MAX_MESSAGE_CHARS));
  }

void ASC_DiagnosticsWriteBounded(const string message)
  {
   int length = StringLen(message);

   if(length <= 0)
     {
      Print(ASC_DIAGNOSTICS_LINE_PREFIX + "empty=true");
      return;
     }

   for(int offset = 0; offset < length; offset += ASC_DIAGNOSTICS_MAX_MESSAGE_CHARS)
     {
      string chunk = StringSubstr(message,offset,ASC_DIAGNOSTICS_MAX_MESSAGE_CHARS);
      if(offset > 0)
         chunk = ASC_DIAGNOSTICS_LINE_PREFIX + "cont=true|" + chunk;
      Print(ASC_DiagnosticsClip(chunk,ASC_DIAGNOSTICS_MAX_MESSAGE_CHARS));
     }
  }

void ASC_DiagnosticsWriteEvent(const ASC_LogEvent &event_record)
  {
   ASC_DiagnosticsWriteBounded(ASC_DiagnosticsFormatEvent(event_record));
  }

class ASC_DiagnosticsLogger
  {
private:
   string m_component;
   string m_subject_key;

public:
                     ASC_DiagnosticsLogger(void)
                     {
                        m_component  = "runtime";
                        m_subject_key = "phase1";
                     }

   void              Configure(const string component,const string subject_key)
     {
      m_component   = ASC_DiagnosticsSanitize(component,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
      m_subject_key = ASC_DiagnosticsSanitize(subject_key,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
     }

   void              Emit(const ASC_LogEvent &event_record) const
     {
      ASC_DiagnosticsWriteEvent(event_record);
     }

   void              Write(const ASC_LogEventClass event_class,
                           const ASC_LogSeverity severity,
                           const string event_name,
                           const string action,
                           const string outcome,
                           const ASC_RuntimeMode runtime_mode,
                           const ASC_RuntimeMode previous_mode,
                           const ASC_ServiceClass service_class,
                           const string service_key,
                           const long cycle_sequence,
                           const ASC_LogReason &reason,
                           const bool success,
                           const bool skipped,
                           const bool failure) const
     {
      ASC_LogEvent event_record;
      ASC_DiagnosticsResetEvent(event_record);
      event_record.EventClass    = event_class;
      event_record.Severity      = severity;
      event_record.EventName     = ASC_DiagnosticsSanitize(event_name,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
      event_record.Component     = m_component;
      event_record.Action        = ASC_DiagnosticsSanitize(action,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
      event_record.CycleSequence = cycle_sequence;
      event_record.RuntimeMode   = runtime_mode;
      event_record.PreviousMode  = previous_mode;
      event_record.ServiceClass  = service_class;
      event_record.ServiceKey    = ASC_DiagnosticsSanitize(service_key,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
      event_record.SubjectKind   = "runtime";
      event_record.SubjectKey    = m_subject_key;
      event_record.Reason        = reason;
      ASC_DiagnosticsSetOutcome(event_record,outcome,success,skipped,failure);
      Emit(event_record);
     }
  };

ASC_LogEvent ASC_DiagnosticsStartupEvent(const string component,
                                         const string build_id,
                                         const int timer_seconds,
                                         const bool storage_ready,
                                         const bool diagnostics_ready,
                                         const bool ui_ready)
  {
   ASC_LogEvent event_record;
   ASC_DiagnosticsResetEvent(event_record);
   event_record.EventClass  = ASC_LOG_EVENT_STARTUP;
   event_record.Severity    = ASC_LOG_INFO;
   event_record.EventName   = "startup";
   event_record.Component   = ASC_DiagnosticsSanitize(component,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   event_record.Action      = "initialize";
   ASC_DiagnosticsSetOutcome(event_record,"STARTED",true,false,false);
   ASC_DiagnosticsAddField(event_record,"build_id",build_id);
   ASC_DiagnosticsAddField(event_record,"timer_seconds",IntegerToString(timer_seconds));
   ASC_DiagnosticsAddField(event_record,"storage_hook",ASC_DiagnosticsBoolText(storage_ready));
   ASC_DiagnosticsAddField(event_record,"diag_hook",ASC_DiagnosticsBoolText(diagnostics_ready));
   ASC_DiagnosticsAddField(event_record,"ui_hook",ASC_DiagnosticsBoolText(ui_ready));
   return(event_record);
  }

ASC_LogEvent ASC_DiagnosticsRestoreEvent(const ASC_ServiceOutcome outcome,
                                         const ASC_RuntimeMode runtime_mode,
                                         const ASC_RuntimeMode previous_mode,
                                         const long cycle_sequence,
                                         const ASC_ContinuityOrigin continuity_origin,
                                         const ASC_HydrationState hydration_state,
                                         const bool journals_inspected,
                                         const bool runtime_state_loaded,
                                         const ASC_ReasonSet &reason)
  {
   ASC_LogEvent event_record;
   ASC_DiagnosticsResetEvent(event_record);
   event_record.EventClass    = ASC_LOG_EVENT_RESTORE;
   event_record.Severity      = ASC_DiagnosticsSeverityFromOutcome(outcome);
   event_record.EventName     = "restore";
   event_record.Action        = "restore-runtime";
   event_record.CycleSequence = cycle_sequence;
   event_record.RuntimeMode   = runtime_mode;
   event_record.PreviousMode  = previous_mode;
   event_record.ServiceClass  = ASC_SERVICE_CONTINUITY;
   event_record.ServiceKey    = "restore";
   ASC_DiagnosticsSetOutcome(event_record,ASC_DiagnosticsOutcomeText(outcome),outcome == ASC_OUTCOME_SUCCESS,outcome == ASC_OUTCOME_SKIPPED || outcome == ASC_OUTCOME_DEFERRED,outcome == ASC_OUTCOME_FAILED || outcome == ASC_OUTCOME_INVALID_DATA || outcome == ASC_OUTCOME_BUDGET_EXCEEDED);
   ASC_DiagnosticsAssignReasonFromSet(event_record.Reason,reason);
   ASC_DiagnosticsAddField(event_record,"continuity_origin",ASC_ContinuityOriginText(continuity_origin));
   ASC_DiagnosticsAddField(event_record,"hydration_state",ASC_HydrationStateText(hydration_state));
   ASC_DiagnosticsAddField(event_record,"journals_inspected",ASC_DiagnosticsBoolText(journals_inspected));
   ASC_DiagnosticsAddField(event_record,"runtime_state_loaded",ASC_DiagnosticsBoolText(runtime_state_loaded));
   return(event_record);
  }

ASC_LogEvent ASC_DiagnosticsModeTransitionEvent(const ASC_RuntimeMode previous_mode,
                                                const ASC_RuntimeMode next_mode,
                                                const long cycle_sequence,
                                                const string cause,
                                                const ASC_ReasonSet &reason)
  {
   ASC_LogEvent event_record;
   ASC_DiagnosticsResetEvent(event_record);
   event_record.EventClass    = ASC_LOG_EVENT_MODE_TRANSITION;
   event_record.Severity      = ASC_LOG_INFO;
   event_record.EventName     = "runtime-mode-transition";
   event_record.Action        = "set-mode";
   event_record.CycleSequence = cycle_sequence;
   event_record.RuntimeMode   = next_mode;
   event_record.PreviousMode  = previous_mode;
   ASC_DiagnosticsSetOutcome(event_record,"APPLIED",true,false,false);
   ASC_DiagnosticsAssignReasonFromSet(event_record.Reason,reason);
   ASC_DiagnosticsAddField(event_record,"transition",ASC_DiagnosticsModePair(previous_mode,next_mode));
   ASC_DiagnosticsAddField(event_record,"cause",cause);
   return(event_record);
  }

ASC_LogEvent ASC_DiagnosticsReentrySkipEvent(const long cycle_sequence,
                                             const ASC_RuntimeMode runtime_mode,
                                             const int consecutive_skips,
                                             const ASC_ReasonSet &reason)
  {
   ASC_LogEvent event_record;
   ASC_DiagnosticsResetEvent(event_record);
   event_record.EventClass    = ASC_LOG_EVENT_REENTRY_SKIP;
   event_record.Severity      = ASC_LOG_WARN;
   event_record.EventName     = "reentry-skip";
   event_record.Action        = "skip-cycle";
   event_record.CycleSequence = cycle_sequence;
   event_record.RuntimeMode   = runtime_mode;
   event_record.PreviousMode  = runtime_mode;
   ASC_DiagnosticsSetOutcome(event_record,"SKIPPED",false,true,false);
   ASC_DiagnosticsAssignReasonFromSet(event_record.Reason,reason);
   ASC_DiagnosticsAddField(event_record,"consecutive_skips",IntegerToString(consecutive_skips));
   return(event_record);
  }

ASC_LogEvent ASC_DiagnosticsDueServiceDispatchEvent(const string service_key,
                                                    const ASC_ServiceClass service_class,
                                                    const ASC_ServiceOutcome outcome,
                                                    const ASC_RuntimeMode runtime_mode,
                                                    const ASC_RuntimeMode previous_mode,
                                                    const long cycle_sequence,
                                                    const bool due,
                                                    const bool enabled,
                                                    const ASC_ReasonSet &reason)
  {
   ASC_LogEvent event_record;
   ASC_DiagnosticsResetEvent(event_record);
   event_record.EventClass    = ASC_LOG_EVENT_DUE_SERVICE_DISPATCH;
   event_record.Severity      = ASC_DiagnosticsSeverityFromOutcome(outcome);
   event_record.EventName     = "due-service-dispatch";
   event_record.Action        = "dispatch-service";
   event_record.CycleSequence = cycle_sequence;
   event_record.RuntimeMode   = runtime_mode;
   event_record.PreviousMode  = previous_mode;
   event_record.ServiceClass  = service_class;
   event_record.ServiceKey    = service_key;
   ASC_DiagnosticsSetOutcome(event_record,ASC_DiagnosticsOutcomeText(outcome),outcome == ASC_OUTCOME_SUCCESS,outcome == ASC_OUTCOME_SKIPPED || outcome == ASC_OUTCOME_DEFERRED || outcome == ASC_OUTCOME_NOT_READY,outcome == ASC_OUTCOME_INVALID_DATA || outcome == ASC_OUTCOME_FAILED || outcome == ASC_OUTCOME_BUDGET_EXCEEDED);
   ASC_DiagnosticsAssignReasonFromSet(event_record.Reason,reason);
   ASC_DiagnosticsAddField(event_record,"due",ASC_DiagnosticsBoolText(due));
   ASC_DiagnosticsAddField(event_record,"enabled",ASC_DiagnosticsBoolText(enabled));
   return(event_record);
  }

ASC_LogEvent ASC_DiagnosticsJournalInspectionEvent(const ASC_ServiceOutcome outcome,
                                                   const long cycle_sequence,
                                                   const string journal_target,
                                                   const int journal_count,
                                                   const int corrupt_count,
                                                   const ASC_ReasonSet &reason)
  {
   ASC_LogEvent event_record;
   ASC_DiagnosticsResetEvent(event_record);
   event_record.EventClass    = ASC_LOG_EVENT_JOURNAL_INSPECTION;
   event_record.Severity      = ASC_DiagnosticsSeverityFromOutcome(outcome);
   event_record.EventName     = "journal-inspection";
   event_record.Action        = "inspect-journal";
   event_record.CycleSequence = cycle_sequence;
   event_record.RuntimeMode   = ASC_RUNTIME_RESTORE;
   event_record.PreviousMode  = ASC_RUNTIME_BOOT;
   event_record.ServiceClass  = ASC_SERVICE_CONTINUITY;
   event_record.ServiceKey    = "journal";
   event_record.SubjectKind   = "journal";
   event_record.SubjectKey    = ASC_DiagnosticsSanitize(journal_target,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   ASC_DiagnosticsSetOutcome(event_record,ASC_DiagnosticsOutcomeText(outcome),outcome == ASC_OUTCOME_SUCCESS,outcome == ASC_OUTCOME_SKIPPED || outcome == ASC_OUTCOME_DEFERRED,outcome == ASC_OUTCOME_INVALID_DATA || outcome == ASC_OUTCOME_FAILED || outcome == ASC_OUTCOME_BUDGET_EXCEEDED);
   ASC_DiagnosticsAssignReasonFromSet(event_record.Reason,reason);
   ASC_DiagnosticsAddField(event_record,"journal_count",IntegerToString(journal_count));
   ASC_DiagnosticsAddField(event_record,"corrupt_count",IntegerToString(corrupt_count));
   return(event_record);
  }

ASC_LogEvent ASC_DiagnosticsRuntimeStateCommitEvent(const ASC_ServiceOutcome outcome,
                                                    const ASC_RuntimeMode runtime_mode,
                                                    const ASC_RuntimeMode previous_mode,
                                                    const long cycle_sequence,
                                                    const string commit_target,
                                                    const string commit_token,
                                                    const ASC_ReasonSet &reason)
  {
   ASC_LogEvent event_record;
   ASC_DiagnosticsResetEvent(event_record);
   event_record.EventClass    = ASC_LOG_EVENT_RUNTIME_STATE_COMMIT;
   event_record.Severity      = ASC_DiagnosticsSeverityFromOutcome(outcome);
   event_record.EventName     = "runtime-state-commit";
   event_record.Action        = "commit-runtime-state";
   event_record.CycleSequence = cycle_sequence;
   event_record.RuntimeMode   = runtime_mode;
   event_record.PreviousMode  = previous_mode;
   event_record.ServiceClass  = ASC_SERVICE_PUBLISH_CRITICAL;
   event_record.ServiceKey    = "runtime-state-commit";
   event_record.SubjectKind   = "runtime-state";
   event_record.SubjectKey    = ASC_DiagnosticsSanitize(commit_target,ASC_DIAGNOSTICS_MAX_VALUE_CHARS);
   ASC_DiagnosticsSetOutcome(event_record,ASC_DiagnosticsOutcomeText(outcome),outcome == ASC_OUTCOME_SUCCESS,outcome == ASC_OUTCOME_SKIPPED || outcome == ASC_OUTCOME_DEFERRED,outcome == ASC_OUTCOME_INVALID_DATA || outcome == ASC_OUTCOME_FAILED || outcome == ASC_OUTCOME_BUDGET_EXCEEDED);
   ASC_DiagnosticsAssignReasonFromSet(event_record.Reason,reason);
   ASC_DiagnosticsAddField(event_record,"commit_token",commit_token);
   return(event_record);
  }

ASC_LogEvent ASC_DiagnosticsStateTransitionEvent(const ASC_LogEventClass event_class,
                                                 const ASC_RuntimeMode runtime_mode,
                                                 const ASC_RuntimeMode previous_mode,
                                                 const long cycle_sequence,
                                                 const bool enabled,
                                                 const string transition_cause,
                                                 const ASC_ReasonSet &reason)
  {
   ASC_LogEvent event_record;
   ASC_DiagnosticsResetEvent(event_record);
   event_record.EventClass    = event_class;
   event_record.Severity      = enabled ? ASC_LOG_WARN : ASC_LOG_INFO;
   event_record.EventName     = ASC_LogEventClassText(event_class);
   event_record.Action        = "toggle-runtime-state";
   event_record.CycleSequence = cycle_sequence;
   event_record.RuntimeMode   = runtime_mode;
   event_record.PreviousMode  = previous_mode;
   ASC_DiagnosticsSetOutcome(event_record,enabled ? "ENTERED" : "EXITED",!enabled,false,false);
   ASC_DiagnosticsAssignReasonFromSet(event_record.Reason,reason);
   ASC_DiagnosticsAddField(event_record,"enabled",ASC_DiagnosticsBoolText(enabled));
   ASC_DiagnosticsAddField(event_record,"cause",transition_cause);
   return(event_record);
  }

#endif // ASC_DIAGNOSTICS_MQH
