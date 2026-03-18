#ifndef __ISSX_UI_TEST_MQH__
#define __ISSX_UI_TEST_MQH__

#include <ISSX/issx_core.mqh>
#include <ISSX/issx_runtime.mqh>
#include <ISSX/issx_persistence.mqh>
#include <ISSX/issx_market_engine.mqh>
#include <ISSX/issx_history_engine.mqh>
#include <ISSX/issx_selection_engine.mqh>
#include <ISSX/issx_correlation_engine.mqh>
#include <ISSX/issx_contracts.mqh>

// ============================================================================
// ISSX UI TEST v1.7.2
// Kernel HUD / structured traces / weak-link reporting / event-driven debug
// snapshots / aggregated debug summary / trace rate limiting.
//
// DESIGN RULES
// - debug must expose weak links early
// - debug must never become the bottleneck
// - HUD renders only from precomputed counters and stage state summaries
// - public debug is a projection, never authoritative truth
// - stage-local snapshots remain stage-specific and event-driven
// - shared semantic enums remain core-owned
// - unknown / unavailable metrics must remain explicit and must not silently
//   masquerade as healthy, safe, or empty-good state
// ============================================================================

#define ISSX_UI_TEST_MODULE_VERSION            "1.7.2"
#define ISSX_TRACE_DEFAULT_COOLDOWN_MS         15000
#define ISSX_TRACE_MAX_RECENT_KEYS             256
#define ISSX_DEBUG_MAX_WARNINGS                32
#define ISSX_DEBUG_MAX_TRACE_LINES             128
#define ISSX_HUD_MAX_ROWS                      8
#define ISSX_DEBUG_UNKNOWN_COUNT               (-1)
#define ISSX_DEBUG_UNKNOWN_LONG                (-1)
#define ISSX_DEBUG_UNKNOWN_DOUBLE              (-1.0)

enum ISSX_DebugSnapshotReason
  {
   issx_snapshot_reason_none = 0,
   issx_snapshot_reason_boot_restore,
   issx_snapshot_reason_publish_attempt,
   issx_snapshot_reason_acceptance_result,
   issx_snapshot_reason_dependency_block,
   issx_snapshot_reason_fallback_event,
   issx_snapshot_reason_queue_starvation,
   issx_snapshot_reason_rewrite_storm,
   issx_snapshot_reason_weak_link_change,
   issx_snapshot_reason_manual
  };

struct ISSX_TraceLine
  {
   ISSX_TraceSeverity severity;
   ISSX_StageId       stage_id;
   string             code;
   string             message;
   string             detail;
   long               mono_ms;
   int                minute_id;
   long               sequence_no;
   bool               rate_limited;

   void Reset()
     {
      severity=issx_trace_sampled_info;
      stage_id=issx_stage_unknown;
      code="";
      message="";
      detail="";
      mono_ms=0;
      minute_id=0;
      sequence_no=0;
      rate_limited=false;
     }
  };

struct ISSX_WeakLinkWeights
  {
   int error_weight;
   int degrade_weight;
   int dependency_weight;
   int fallback_weight;

   void Reset()
     {
      error_weight=0;
      degrade_weight=0;
      dependency_weight=0;
      fallback_weight=0;
     }
  };

struct ISSX_StageLadderRow
  {
   ISSX_StageId stage_id;
   string       publishability_state;
   long         stage_last_publish_age;
   double       stage_backlog_score;
   double       stage_starvation_score;
   string       dependency_block_reason;
   string       phase_id;
   int          phase_resume_count;
   string       weak_link_code;
   long         accepted_sequence_no;
   long         last_attempted_age;
   long         last_successful_service_age;
   int          fallback_depth;
   bool         minimum_ready_flag;
   bool         publish_due_flag;
   string       source_mode;

   void Reset()
     {
      stage_id=issx_stage_unknown;
      publishability_state="unknown";
      stage_last_publish_age=ISSX_DEBUG_UNKNOWN_LONG;
      stage_backlog_score=ISSX_DEBUG_UNKNOWN_DOUBLE;
      stage_starvation_score=ISSX_DEBUG_UNKNOWN_DOUBLE;
      dependency_block_reason="na";
      phase_id="na";
      phase_resume_count=0;
      weak_link_code="na";
      accepted_sequence_no=0;
      last_attempted_age=ISSX_DEBUG_UNKNOWN_LONG;
      last_successful_service_age=ISSX_DEBUG_UNKNOWN_LONG;
      fallback_depth=0;
      minimum_ready_flag=false;
      publish_due_flag=false;
      source_mode="na";
     }
  };

struct ISSX_HudWarning
  {
   ISSX_HudWarningSeverity severity;
   string                  code;
   string                  text;

   void Reset()
     {
      severity=issx_hud_warning_none;
      code="";
      text="";
     }
  };

struct ISSX_DebugAggregate
  {
   string              firm_id;
   string              engine_name;
   string              engine_version;
   string              weakest_stage;
   string              weakest_stage_reason;
   int                 weak_link_severity;
   bool                kernel_degraded_cycle_flag;
   long                timer_gap_ms_now;
   double              timer_gap_ms_mean;
   long                timer_gap_ms_p95;
   long                scheduler_late_by_ms;
   int                 missed_schedule_windows_estimate;
   double              clock_divergence_sec;
   bool                quote_clock_idle_flag;
   bool                clock_anomaly_flag;
   int                 kernel_minute_id;
   long                scheduler_cycle_no;
   long                queue_starvation_max_ms;
   long                queue_oldest_item_age_ms;
   int                 never_serviced_count;
   int                 overdue_service_count;
   int                 newly_active_symbols_waiting_count;
   int                 sector_cold_backlog_count;
   int                 frontier_refresh_lag_for_new_movers;
   int                 never_ranked_but_now_observable_count;
   string              largest_backlog_owner;
   string              oldest_unserved_queue_family;
   ISSX_StageLadderRow stage_rows[];
   ISSX_HudWarning     warnings[];
   ISSX_TraceLine      traces[];

   void Reset()
     {
      firm_id="";
      engine_name=ISSX_ENGINE_NAME;
      engine_version=ISSX_UI_TEST_MODULE_VERSION;
      weakest_stage="na";
      weakest_stage_reason="na";
      weak_link_severity=0;
      kernel_degraded_cycle_flag=false;
      timer_gap_ms_now=ISSX_DEBUG_UNKNOWN_LONG;
      timer_gap_ms_mean=ISSX_DEBUG_UNKNOWN_DOUBLE;
      timer_gap_ms_p95=ISSX_DEBUG_UNKNOWN_LONG;
      scheduler_late_by_ms=ISSX_DEBUG_UNKNOWN_LONG;
      missed_schedule_windows_estimate=ISSX_DEBUG_UNKNOWN_COUNT;
      clock_divergence_sec=ISSX_DEBUG_UNKNOWN_DOUBLE;
      quote_clock_idle_flag=false;
      clock_anomaly_flag=false;
      kernel_minute_id=0;
      scheduler_cycle_no=0;
      queue_starvation_max_ms=ISSX_DEBUG_UNKNOWN_LONG;
      queue_oldest_item_age_ms=ISSX_DEBUG_UNKNOWN_LONG;
      never_serviced_count=ISSX_DEBUG_UNKNOWN_COUNT;
      overdue_service_count=ISSX_DEBUG_UNKNOWN_COUNT;
      newly_active_symbols_waiting_count=ISSX_DEBUG_UNKNOWN_COUNT;
      sector_cold_backlog_count=ISSX_DEBUG_UNKNOWN_COUNT;
      frontier_refresh_lag_for_new_movers=ISSX_DEBUG_UNKNOWN_COUNT;
      never_ranked_but_now_observable_count=ISSX_DEBUG_UNKNOWN_COUNT;
      largest_backlog_owner="na";
      oldest_unserved_queue_family="na";
      ArrayResize(stage_rows,0);
      ArrayResize(warnings,0);
      ArrayResize(traces,0);
     }
  };

struct ISSX_TraceCooldownEntry
  {
   string key;
   long   last_emit_mono_ms;
   int    emit_count;

   void Reset()
     {
      key="";
      last_emit_mono_ms=0;
      emit_count=0;
     }
  };

class ISSX_UI_Text
  {
public:
   static string TraceSeverityToString(const int v)
     {
      switch(v)
        {
         case issx_trace_error:         return "error";
         case issx_trace_warn:          return "warn";
         case issx_trace_state_change:  return "state_change";
         case issx_trace_sampled_info:  return "sampled_info";
         default:                       return "unknown";
        }
     }

   static string PublishabilityToString(const int v)
     {
      switch(v)
        {
         case issx_publishability_publishable: return "publishable";
         case issx_publishability_degraded:    return "degraded";
         case issx_publishability_blocked:     return "blocked";
         case issx_publishability_unknown:
         default:                              return "unknown";
        }
     }

   static string StageIdToShortString(const ISSX_StageId stage_id)
     {
      switch(stage_id)
        {
         case issx_stage_ea1: return "ea1";
         case issx_stage_ea2: return "ea2";
         case issx_stage_ea3: return "ea3";
         case issx_stage_ea4: return "ea4";
         case issx_stage_ea5: return "ea5";
         case issx_stage_kernel:
         default:             return "na";
        }
     }

   static string BoolToWord(const bool v,const string yes_word="yes",const string no_word="no")
     {
      return (v ? yes_word : no_word);
     }

   static string LongToStringSafe(const long v,const string na_word="na")
     {
      return (v<0 ? na_word : LongToString(v));
     }

   static string DoubleToStringSafe(const double v,const int digits=2,const string na_word="na")
     {
      return (v<0.0 ? na_word : DoubleToString(v,digits));
     }

   static string NonEmptyOrNA(const string v,const string na_word="na")
     {
      return (ISSX_Util::IsEmpty(v) ? na_word : v);
     }
  };

class ISSX_UI_TraceLimiter
  {
private:
   ISSX_TraceCooldownEntry m_entries[];

   int FindKey(const string key) const
     {
      const int n=ArraySize(m_entries);
      for(int i=0;i<n;i++)
        {
         if(m_entries[i].key==key)
            return i;
        }
      return -1;
     }

   void PruneIfNeeded()
     {
      int n=ArraySize(m_entries);
      if(n<ISSX_TRACE_MAX_RECENT_KEYS)
         return;

      int remove_count=(n-ISSX_TRACE_MAX_RECENT_KEYS)+1;
      if(remove_count<1)
         remove_count=1;
      if(remove_count>n)
         remove_count=n;

      for(int i=0;i<remove_count;i++)
        {
         n=ArraySize(m_entries);
         for(int j=1;j<n;j++)
            m_entries[j-1]=m_entries[j];
         ArrayResize(m_entries,n-1);
        }
     }

public:
   void Reset()
     {
      ArrayResize(m_entries,0);
     }

   bool Allow(const string key,const long mono_ms,const long cooldown_ms)
     {
      if(cooldown_ms<=0)
         return true;

      const int idx=FindKey(key);
      if(idx<0)
        {
         ISSX_TraceCooldownEntry e;
         e.Reset();
         e.key=key;
         e.last_emit_mono_ms=mono_ms;
         e.emit_count=1;
         const int n=ArraySize(m_entries);
         ArrayResize(m_entries,n+1);
         m_entries[n]=e;
         PruneIfNeeded();
         return true;
        }

      long delta=mono_ms-m_entries[idx].last_emit_mono_ms;
      if(delta<0)
         delta=0;

      if(delta<cooldown_ms)
        {
         m_entries[idx].emit_count++;
         return false;
        }

      m_entries[idx].last_emit_mono_ms=mono_ms;
      m_entries[idx].emit_count++;
      return true;
     }
  };

class ISSX_UI_Test
  {
private:
   ISSX_UI_TraceLimiter m_trace_limiter;

   static long ValueOrUnknownLong(const long v)
     {
      return (v<0 ? ISSX_DEBUG_UNKNOWN_LONG : v);
     }

   static int ValueOrUnknownInt(const int v)
     {
      return (v<0 ? ISSX_DEBUG_UNKNOWN_COUNT : v);
     }

   static double ValueOrUnknownDouble(const double v)
     {
      return (v<0.0 ? ISSX_DEBUG_UNKNOWN_DOUBLE : v);
     }

   static string ValueOrNA(const string v)
     {
      return ISSX_UI_Text::NonEmptyOrNA(v,"na");
     }

   static string StagePublishabilityWord(const int v)
     {
      switch(v)
        {
         case issx_stage_publishability_ready:         return "ready";
         case issx_stage_publishability_degraded:      return "degraded";
         case issx_stage_publishability_blocked:       return "blocked";
         case issx_stage_publishability_unknown:
         default:                                      return "unknown";
        }
     }

   static string WeakLinkCodeOrNA(const string v)
     {
      return ISSX_UI_Text::NonEmptyOrNA(v,"na");
     }

   static string DependencyReasonOrNA(const string v)
     {
      return ISSX_UI_Text::NonEmptyOrNA(v,"na");
     }

   static void PushWarning(ISSX_HudWarning &arr[],const ISSX_HudWarningSeverity severity,const string code,const string text)
     {
      const int n=ArraySize(arr);
      if(n>=ISSX_DEBUG_MAX_WARNINGS)
         return;
      ArrayResize(arr,n+1);
      arr[n].Reset();
      arr[n].severity=severity;
      arr[n].code=code;
      arr[n].text=text;
     }

   static void PushTrace(ISSX_TraceLine &arr[],const ISSX_TraceSeverity severity,const ISSX_StageId stage_id,
                         const string code,const string message,const string detail,
                         const long mono_ms,const int minute_id,const long sequence_no,
                         const bool rate_limited=false)
     {
      const int n=ArraySize(arr);
      if(n>=ISSX_DEBUG_MAX_TRACE_LINES)
         return;
      ArrayResize(arr,n+1);
      arr[n].Reset();
      arr[n].severity=severity;
      arr[n].stage_id=stage_id;
      arr[n].code=code;
      arr[n].message=message;
      arr[n].detail=detail;
      arr[n].mono_ms=mono_ms;
      arr[n].minute_id=minute_id;
      arr[n].sequence_no=sequence_no;
      arr[n].rate_limited=rate_limited;
     }

   static void AddStageWarningFromRow(ISSX_HudWarning &warnings[],const ISSX_StageLadderRow &row)
     {
      if(row.stage_id==issx_stage_unknown)
         return;

      const string stage_name=ISSX_UI_Text::StageIdToShortString(row.stage_id);

      if(row.publishability_state=="blocked")
         PushWarning(warnings,issx_hud_warning_error,stage_name+"_blocked",
                     stage_name+" publish blocked: "+row.dependency_block_reason);
      else if(row.publishability_state=="degraded")
         PushWarning(warnings,issx_hud_warning_warn,stage_name+"_degraded",
                     stage_name+" degraded: "+row.weak_link_code);

      if(row.stage_starvation_score>=0.0 && row.stage_starvation_score>=70.0)
         PushWarning(warnings,issx_hud_warning_warn,stage_name+"_starved",
                     stage_name+" starvation score elevated");

      if(row.fallback_depth>0)
         PushWarning(warnings,issx_hud_warning_warn,stage_name+"_fallback",
                     stage_name+" fallback depth "+IntegerToString(row.fallback_depth));
     }

   static string SnapshotReasonToString(const ISSX_DebugSnapshotReason reason)
     {
      switch(reason)
        {
         case issx_snapshot_reason_boot_restore:      return "boot_restore";
         case issx_snapshot_reason_publish_attempt:   return "publish_attempt";
         case issx_snapshot_reason_acceptance_result: return "acceptance_result";
         case issx_snapshot_reason_dependency_block:  return "dependency_block";
         case issx_snapshot_reason_fallback_event:    return "fallback_event";
         case issx_snapshot_reason_queue_starvation:  return "queue_starvation";
         case issx_snapshot_reason_rewrite_storm:     return "rewrite_storm";
         case issx_snapshot_reason_weak_link_change:  return "weak_link_change";
         case issx_snapshot_reason_manual:            return "manual";
         case issx_snapshot_reason_none:
         default:                                     return "none";
        }
     }

   static string BuildStageRowJson(const ISSX_StageLadderRow &row)
     {
      string j="{";
      j+=ISSX_JsonWriter::NameString("stage_id",ISSX_UI_Text::StageIdToShortString(row.stage_id))+",";
      j+=ISSX_JsonWriter::NameString("publishability_state",row.publishability_state)+",";
      j+=ISSX_JsonWriter::NameLong("stage_last_publish_age",row.stage_last_publish_age)+",";
      j+=ISSX_JsonWriter::NameDouble("stage_backlog_score",row.stage_backlog_score,2)+",";
      j+=ISSX_JsonWriter::NameDouble("stage_starvation_score",row.stage_starvation_score,2)+",";
      j+=ISSX_JsonWriter::NameString("dependency_block_reason",row.dependency_block_reason)+",";
      j+=ISSX_JsonWriter::NameString("phase_id",row.phase_id)+",";
      j+=ISSX_JsonWriter::NameInt("phase_resume_count",row.phase_resume_count)+",";
      j+=ISSX_JsonWriter::NameString("weak_link_code",row.weak_link_code)+",";
      j+=ISSX_JsonWriter::NameLong("accepted_sequence_no",row.accepted_sequence_no)+",";
      j+=ISSX_JsonWriter::NameLong("last_attempted_age",row.last_attempted_age)+",";
      j+=ISSX_JsonWriter::NameLong("last_successful_service_age",row.last_successful_service_age)+",";
      j+=ISSX_JsonWriter::NameInt("fallback_depth",row.fallback_depth)+",";
      j+=ISSX_JsonWriter::NameBool("minimum_ready_flag",row.minimum_ready_flag)+",";
      j+=ISSX_JsonWriter::NameBool("publish_due_flag",row.publish_due_flag)+",";
      j+=ISSX_JsonWriter::NameString("source_mode",row.source_mode);
      j+="}";
      return j;
     }

   static string BuildWarningJson(const ISSX_HudWarning &w)
     {
      string j="{";
      j+=ISSX_JsonWriter::NameString("severity",ISSX_HudWarningSeverityToString(w.severity))+",";
      j+=ISSX_JsonWriter::NameString("code",w.code)+",";
      j+=ISSX_JsonWriter::NameString("text",w.text);
      j+="}";
      return j;
     }

   static string BuildTraceJson(const ISSX_TraceLine &t)
     {
      string j="{";
      j+=ISSX_JsonWriter::NameString("severity",ISSX_UI_Text::TraceSeverityToString((int)t.severity))+",";
      j+=ISSX_JsonWriter::NameString("stage_id",ISSX_UI_Text::StageIdToShortString(t.stage_id))+",";
      j+=ISSX_JsonWriter::NameString("code",t.code)+",";
      j+=ISSX_JsonWriter::NameString("message",t.message)+",";
      j+=ISSX_JsonWriter::NameString("detail",t.detail)+",";
      j+=ISSX_JsonWriter::NameLong("mono_ms",t.mono_ms)+",";
      j+=ISSX_JsonWriter::NameInt("minute_id",t.minute_id)+",";
      j+=ISSX_JsonWriter::NameLong("sequence_no",t.sequence_no)+",";
      j+=ISSX_JsonWriter::NameBool("rate_limited",t.rate_limited);
      j+="}";
      return j;
     }

   static string BuildAggregateJson(const ISSX_DebugAggregate &agg)
     {
      string j="{";
      j+=ISSX_JsonWriter::NameString("engine_name",agg.engine_name)+",";
      j+=ISSX_JsonWriter::NameString("engine_version",agg.engine_version)+",";
      j+=ISSX_JsonWriter::NameString("firm_id",agg.firm_id)+",";
      j+=ISSX_JsonWriter::NameString("weakest_stage",agg.weakest_stage)+",";
      j+=ISSX_JsonWriter::NameString("weakest_stage_reason",agg.weakest_stage_reason)+",";
      j+=ISSX_JsonWriter::NameInt("weak_link_severity",agg.weak_link_severity)+",";
      j+=ISSX_JsonWriter::NameBool("kernel_degraded_cycle_flag",agg.kernel_degraded_cycle_flag)+",";
      j+=ISSX_JsonWriter::NameLong("timer_gap_ms_now",agg.timer_gap_ms_now)+",";
      j+=ISSX_JsonWriter::NameDouble("timer_gap_ms_mean",agg.timer_gap_ms_mean,2)+",";
      j+=ISSX_JsonWriter::NameLong("timer_gap_ms_p95",agg.timer_gap_ms_p95)+",";
      j+=ISSX_JsonWriter::NameLong("scheduler_late_by_ms",agg.scheduler_late_by_ms)+",";
      j+=ISSX_JsonWriter::NameInt("missed_schedule_windows_estimate",agg.missed_schedule_windows_estimate)+",";
      j+=ISSX_JsonWriter::NameDouble("clock_divergence_sec",agg.clock_divergence_sec,2)+",";
      j+=ISSX_JsonWriter::NameBool("quote_clock_idle_flag",agg.quote_clock_idle_flag)+",";
      j+=ISSX_JsonWriter::NameBool("clock_anomaly_flag",agg.clock_anomaly_flag)+",";
      j+=ISSX_JsonWriter::NameInt("kernel_minute_id",agg.kernel_minute_id)+",";
      j+=ISSX_JsonWriter::NameLong("scheduler_cycle_no",agg.scheduler_cycle_no)+",";
      j+=ISSX_JsonWriter::NameLong("queue_starvation_max_ms",agg.queue_starvation_max_ms)+",";
      j+=ISSX_JsonWriter::NameLong("queue_oldest_item_age_ms",agg.queue_oldest_item_age_ms)+",";
      j+=ISSX_JsonWriter::NameInt("never_serviced_count",agg.never_serviced_count)+",";
      j+=ISSX_JsonWriter::NameInt("overdue_service_count",agg.overdue_service_count)+",";
      j+=ISSX_JsonWriter::NameInt("newly_active_symbols_waiting_count",agg.newly_active_symbols_waiting_count)+",";
      j+=ISSX_JsonWriter::NameInt("sector_cold_backlog_count",agg.sector_cold_backlog_count)+",";
      j+=ISSX_JsonWriter::NameInt("frontier_refresh_lag_for_new_movers",agg.frontier_refresh_lag_for_new_movers)+",";
      j+=ISSX_JsonWriter::NameInt("never_ranked_but_now_observable_count",agg.never_ranked_but_now_observable_count)+",";
      j+=ISSX_JsonWriter::NameString("largest_backlog_owner",agg.largest_backlog_owner)+",";
      j+=ISSX_JsonWriter::NameString("oldest_unserved_queue_family",agg.oldest_unserved_queue_family)+",";

      j+="\"stage_ladder\":[";
      const int stage_n=ArraySize(agg.stage_rows);
      for(int i=0;i<stage_n;i++)
        {
         if(i>0)
            j+=",";
         j+=BuildStageRowJson(agg.stage_rows[i]);
        }
      j+="],";

      j+="\"warnings\":[";
      const int warn_n=ArraySize(agg.warnings);
      for(int i=0;i<warn_n;i++)
        {
         if(i>0)
            j+=",";
         j+=BuildWarningJson(agg.warnings[i]);
        }
      j+="],";

      j+="\"traces\":[";
      const int trace_n=ArraySize(agg.traces);
      for(int i=0;i<trace_n;i++)
        {
         if(i>0)
            j+=",";
         j+=BuildTraceJson(agg.traces[i]);
        }
      j+="]";

      j+="}";
      return j;
     }

   static long NowMonoMs()
     {
      return (long)GetTickCount64();
     }

   static long AgeMsFrom(const long then_ms,const long now_ms)
     {
      if(then_ms<=0 || now_ms<=0)
         return ISSX_DEBUG_UNKNOWN_LONG;
      long d=now_ms-then_ms;
      if(d<0)
         d=0;
      return d;
     }

   static long AgeSecFromTime(const datetime t,const datetime now_time)
     {
      if(t<=0 || now_time<=0)
         return ISSX_DEBUG_UNKNOWN_LONG;
      long d=(long)(now_time-t);
      if(d<0)
         d=0;
      return d;
     }

   static int ClampWeakSeverity(const int v)
     {
      if(v<0)
         return 0;
      if(v>100)
         return 100;
      return v;
     }

   static int ComputeSeverityFromWeights(const ISSX_WeakLinkWeights &w)
     {
      int s=w.error_weight+w.degrade_weight+w.dependency_weight+w.fallback_weight;
      return ClampWeakSeverity(s);
     }

   static ISSX_WeakLinkWeights DeriveWeightsForRow(const ISSX_StageLadderRow &row)
     {
      ISSX_WeakLinkWeights w;
      w.Reset();

      if(row.publishability_state=="blocked")
         w.error_weight+=50;
      else if(row.publishability_state=="degraded")
         w.degrade_weight+=25;

      if(row.stage_starvation_score>=0.0)
        {
         if(row.stage_starvation_score>=90.0)
            w.dependency_weight+=25;
         else if(row.stage_starvation_score>=70.0)
            w.dependency_weight+=15;
        }

      if(row.fallback_depth>0)
         w.fallback_weight+=(10*MathMin(row.fallback_depth,3));

      if(row.dependency_block_reason!="na")
         w.dependency_weight+=10;

      return w;
     }

   static int FindWeakestStageIndex(const ISSX_StageLadderRow &rows[])
     {
      const int n=ArraySize(rows);
      if(n<=0)
         return -1;

      int best_idx=-1;
      int best_score=-1;
      for(int i=0;i<n;i++)
        {
         ISSX_WeakLinkWeights w=DeriveWeightsForRow(rows[i]);
         const int s=ComputeSeverityFromWeights(w);
         if(s>best_score)
           {
            best_score=s;
            best_idx=i;
           }
        }
      return best_idx;
     }

   static ISSX_StageLadderRow BuildStageRow(const ISSX_StageId stage_id,
                                            const ISSX_StageRuntime &rt,
                                            const long now_mono_ms)
     {
      ISSX_StageLadderRow row;
      row.Reset();
      row.stage_id=stage_id;
      row.publishability_state=StagePublishabilityWord((int)rt.publishability_state);
      row.stage_last_publish_age=AgeMsFrom(rt.last_publish_mono_ms,now_mono_ms);
      row.stage_backlog_score=ValueOrUnknownDouble(rt.backlog_score);
      row.stage_starvation_score=ValueOrUnknownDouble(rt.starvation_score);
      row.dependency_block_reason=DependencyReasonOrNA(rt.dependency_block_reason);
      row.phase_id=ValueOrNA(rt.phase_id);
      row.phase_resume_count=MathMax(0,rt.phase_resume_count);
      row.weak_link_code=WeakLinkCodeOrNA(rt.weak_link_code);
      row.accepted_sequence_no=MathMax((long)0,rt.accepted_sequence_no);
      row.last_attempted_age=AgeMsFrom(rt.last_attempt_mono_ms,now_mono_ms);
      row.last_successful_service_age=AgeMsFrom(rt.last_success_mono_ms,now_mono_ms);
      row.fallback_depth=MathMax(0,rt.fallback_depth);
      row.minimum_ready_flag=rt.minimum_ready_flag;
      row.publish_due_flag=rt.publish_due_flag;
      row.source_mode=ValueOrNA(rt.source_mode);
      return row;
     }

   static void BuildStageRows(const ISSX_RuntimeState &runtime_state,ISSX_StageLadderRow &rows[])
     {
      ArrayResize(rows,0);
      const long now_mono_ms=NowMonoMs();

      const int n=ArraySize(runtime_state.stages);
      for(int i=0;i<n;i++)
        {
         const ISSX_StageRuntime rt=runtime_state.stages[i];
         const ISSX_StageId sid=rt.stage_id;
         const int dst=ArraySize(rows);
         ArrayResize(rows,dst+1);
         rows[dst]=BuildStageRow(sid,rt,now_mono_ms);
        }
     }

   static void BuildDefaultWarnings(const ISSX_DebugAggregate &agg,ISSX_HudWarning &warnings[])
     {
      ArrayResize(warnings,0);

      if(agg.kernel_degraded_cycle_flag)
         PushWarning(warnings,issx_hud_warning_warn,"kernel_degraded","kernel cycle degraded");

      if(agg.clock_anomaly_flag)
         PushWarning(warnings,issx_hud_warning_warn,"clock_anomaly","clock anomaly detected");

      if(agg.scheduler_late_by_ms>=0 && agg.scheduler_late_by_ms>5000)
         PushWarning(warnings,issx_hud_warning_warn,"scheduler_late","scheduler late beyond 5s");

      const int n=ArraySize(agg.stage_rows);
      for(int i=0;i<n;i++)
         AddStageWarningFromRow(warnings,agg.stage_rows[i]);
     }

   static void BuildDefaultTraces(const ISSX_DebugAggregate &agg,ISSX_TraceLine &traces[])
     {
      ArrayResize(traces,0);

      PushTrace(traces,issx_trace_state_change,issx_stage_kernel,"hud_refresh",
                "debug aggregate refreshed","",NowMonoMs(),agg.kernel_minute_id,agg.scheduler_cycle_no,false);

      if(agg.kernel_degraded_cycle_flag)
         PushTrace(traces,issx_trace_warn,issx_stage_kernel,"kernel_degraded",
                   "kernel running degraded cycle","",NowMonoMs(),agg.kernel_minute_id,agg.scheduler_cycle_no,false);

      const int n=ArraySize(agg.stage_rows);
      for(int i=0;i<n;i++)
        {
         const ISSX_StageLadderRow row=agg.stage_rows[i];
         if(row.publishability_state=="blocked")
            PushTrace(traces,issx_trace_error,row.stage_id,"dependency_block",
                      "stage blocked",row.dependency_block_reason,NowMonoMs(),agg.kernel_minute_id,row.accepted_sequence_no,false);
         else if(row.publishability_state=="degraded")
            PushTrace(traces,issx_trace_warn,row.stage_id,"stage_degraded",
                      "stage degraded",row.weak_link_code,NowMonoMs(),agg.kernel_minute_id,row.accepted_sequence_no,false);
        }
     }

   static void DetermineWeakestStage(ISSX_DebugAggregate &agg)
     {
      const int idx=FindWeakestStageIndex(agg.stage_rows);
      if(idx<0)
        {
         agg.weakest_stage="na";
         agg.weakest_stage_reason="na";
         agg.weak_link_severity=0;
         return;
        }

      const ISSX_StageLadderRow row=agg.stage_rows[idx];
      agg.weakest_stage=ISSX_UI_Text::StageIdToShortString(row.stage_id);
      if(row.publishability_state=="blocked")
         agg.weakest_stage_reason=ValueOrNA(row.dependency_block_reason);
      else if(row.publishability_state=="degraded")
         agg.weakest_stage_reason=ValueOrNA(row.weak_link_code);
      else
         agg.weakest_stage_reason="backlog";
      agg.weak_link_severity=ComputeSeverityFromWeights(DeriveWeightsForRow(row));
     }

   static string BuildHudIdentityRow(const ISSX_DebugAggregate &agg)
     {
      return "Identity | "+agg.engine_name+" v"+agg.engine_version+" | firm="+ISSX_UI_Text::NonEmptyOrNA(agg.firm_id,"na");
     }

   static string BuildHudRuntimeRow(const ISSX_DebugAggregate &agg)
     {
      string s="Runtime | minute="+IntegerToString(agg.kernel_minute_id);
      s+=" cycle="+LongToString(agg.scheduler_cycle_no);
      s+=" late_ms="+ISSX_UI_Text::LongToStringSafe(agg.scheduler_late_by_ms);
      s+=" gap_ms="+ISSX_UI_Text::LongToStringSafe(agg.timer_gap_ms_now);
      s+=" degraded="+ISSX_UI_Text::BoolToWord(agg.kernel_degraded_cycle_flag);
      return s;
     }

   static string BuildHudStageRow(const ISSX_StageLadderRow &row)
     {
      string s=ISSX_UI_Text::StageIdToShortString(row.stage_id);
      s+=" | pub="+row.publishability_state;
      s+=" last_pub_ms="+ISSX_UI_Text::LongToStringSafe(row.stage_last_publish_age);
      s+=" backlog="+ISSX_UI_Text::DoubleToStringSafe(row.stage_backlog_score,1);
      s+=" starve="+ISSX_UI_Text::DoubleToStringSafe(row.stage_starvation_score,1);
      s+=" dep="+ValueOrNA(row.dependency_block_reason);
      s+=" phase="+ValueOrNA(row.phase_id);
      s+=" weak="+ValueOrNA(row.weak_link_code);
      s+=" fb="+IntegerToString(row.fallback_depth);
      return s;
     }

   static string BuildHudWeakLinksRow(const ISSX_DebugAggregate &agg)
     {
      string s="WeakLinks | weakest="+ISSX_UI_Text::NonEmptyOrNA(agg.weakest_stage,"na");
      s+=" reason="+ISSX_UI_Text::NonEmptyOrNA(agg.weakest_stage_reason,"na");
      s+=" severity="+IntegerToString(agg.weak_link_severity);
      return s;
     }

   static string BuildHudQueuesRow(const ISSX_DebugAggregate &agg)
     {
      string s="Queues | oldest_family="+ISSX_UI_Text::NonEmptyOrNA(agg.oldest_unserved_queue_family,"na");
      s+=" backlog_owner="+ISSX_UI_Text::NonEmptyOrNA(agg.largest_backlog_owner,"na");
      s+=" oldest_age_ms="+ISSX_UI_Text::LongToStringSafe(agg.queue_oldest_item_age_ms);
      s+=" starvation_max_ms="+ISSX_UI_Text::LongToStringSafe(agg.queue_starvation_max_ms);
      return s;
     }

   static string BuildHudWarningsRow(const ISSX_HudWarning &warnings[])
     {
      string s="Warnings | ";
      const int n=ArraySize(warnings);
      if(n<=0)
         return s+"none";
      const int max_show=MathMin(n,3);
      for(int i=0;i<max_show;i++)
        {
         if(i>0)
            s+=" ; ";
         s+=warnings[i].code;
        }
      return s;
     }

public:
   ISSX_UI_Test()
     {
      m_trace_limiter.Reset();
     }

   void Reset()
     {
      m_trace_limiter.Reset();
     }

   bool AllowTrace(const string code,const long mono_ms,const long cooldown_ms=ISSX_TRACE_DEFAULT_COOLDOWN_MS)
     {
      return m_trace_limiter.Allow(code,mono_ms,cooldown_ms);
     }

   ISSX_DebugAggregate BuildAggregate(const string firm_id,const ISSX_RuntimeState &runtime_state)
     {
      ISSX_DebugAggregate agg;
      agg.Reset();
      agg.firm_id=firm_id;

      agg.kernel_degraded_cycle_flag=runtime_state.kernel_degraded_cycle_flag;
      agg.kernel_minute_id=runtime_state.kernel_minute_id;
      agg.scheduler_cycle_no=runtime_state.scheduler_cycle_no;
      agg.timer_gap_ms_now=ValueOrUnknownLong(runtime_state.timer_gap_ms_now);
      agg.timer_gap_ms_mean=ValueOrUnknownDouble(runtime_state.timer_gap_ms_mean);
      agg.timer_gap_ms_p95=ValueOrUnknownLong(runtime_state.timer_gap_ms_p95);
      agg.scheduler_late_by_ms=ValueOrUnknownLong(runtime_state.scheduler_late_by_ms);
      agg.missed_schedule_windows_estimate=ValueOrUnknownInt(runtime_state.missed_schedule_windows_estimate);
      agg.clock_divergence_sec=ValueOrUnknownDouble(runtime_state.clock_divergence_sec);
      agg.quote_clock_idle_flag=runtime_state.quote_clock_idle_flag;
      agg.clock_anomaly_flag=runtime_state.clock_anomaly_flag;
      agg.queue_starvation_max_ms=ValueOrUnknownLong(runtime_state.queue_starvation_max_ms);
      agg.queue_oldest_item_age_ms=ValueOrUnknownLong(runtime_state.queue_oldest_item_age_ms);
      agg.never_serviced_count=ValueOrUnknownInt(runtime_state.never_serviced_count);
      agg.overdue_service_count=ValueOrUnknownInt(runtime_state.overdue_service_count);
      agg.newly_active_symbols_waiting_count=ValueOrUnknownInt(runtime_state.newly_active_symbols_waiting_count);
      agg.sector_cold_backlog_count=ValueOrUnknownInt(runtime_state.sector_cold_backlog_count);
      agg.frontier_refresh_lag_for_new_movers=ValueOrUnknownInt(runtime_state.frontier_refresh_lag_for_new_movers);
      agg.never_ranked_but_now_observable_count=ValueOrUnknownInt(runtime_state.never_ranked_but_now_observable_count);
      agg.largest_backlog_owner=ValueOrNA(runtime_state.largest_backlog_owner);
      agg.oldest_unserved_queue_family=ValueOrNA(runtime_state.oldest_unserved_queue_family);

      BuildStageRows(runtime_state,agg.stage_rows);
      DetermineWeakestStage(agg);
      BuildDefaultWarnings(agg,agg.warnings);
      BuildDefaultTraces(agg,agg.traces);

      return agg;
     }

   string BuildDebugJson(const ISSX_DebugAggregate &agg) const
     {
      return BuildAggregateJson(agg);
     }

   string BuildHudText(const ISSX_DebugAggregate &agg) const
     {
      string lines[];
      ArrayResize(lines,0);

      const int n0=ArraySize(lines);
      ArrayResize(lines,n0+1);
      lines[n0]=BuildHudIdentityRow(agg);

      const int n1=ArraySize(lines);
      ArrayResize(lines,n1+1);
      lines[n1]=BuildHudRuntimeRow(agg);

      const int stage_n=ArraySize(agg.stage_rows);
      for(int i=0;i<stage_n && i<5;i++)
        {
         const int n=ArraySize(lines);
         ArrayResize(lines,n+1);
         lines[n]=BuildHudStageRow(agg.stage_rows[i]);
        }

      const int n2=ArraySize(lines);
      ArrayResize(lines,n2+1);
      lines[n2]=BuildHudQueuesRow(agg);

      const int n3=ArraySize(lines);
      ArrayResize(lines,n3+1);
      lines[n3]=BuildHudWeakLinksRow(agg);

      const int n4=ArraySize(lines);
      ArrayResize(lines,n4+1);
      lines[n4]=BuildHudWarningsRow(agg.warnings);

      string out="";
      const int total=ArraySize(lines);
      for(int i=0;i<total;i++)
        {
         if(i>0)
            out+="\n";
         out+=lines[i];
        }
      return out;
     }

   bool ProjectDebugJson(const string firm_id,const ISSX_DebugAggregate &agg) const
     {
      const string path=ISSX_PersistencePath::DebugRootFile(firm_id);
      return ISSX_FileIO::WriteAllTextUtf8(path,BuildDebugJson(agg));
     }

   bool ProjectHudText(const string firm_id,const ISSX_DebugAggregate &agg) const
     {
      const string path=ISSX_PersistencePath::HudTextFile(firm_id);
      return ISSX_FileIO::WriteAllTextUtf8(path,BuildHudText(agg));
     }

   bool EmitTraceLine(const string firm_id,const ISSX_TraceLine &line) const
     {
      string path=ISSX_PersistencePath::DebugFolder(firm_id)+"issx_trace.log";
      string existing="";
      ISSX_FileIO::ReadAllTextUtf8(path,existing);

      string row=TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS);
      row+=" | sev="+ISSX_UI_Text::TraceSeverityToString((int)line.severity);
      row+=" | stage="+ISSX_UI_Text::StageIdToShortString(line.stage_id);
      row+=" | code="+line.code;
      row+=" | msg="+line.message;
      if(!ISSX_Util::IsEmpty(line.detail))
         row+=" | detail="+line.detail;
      row+=" | minute="+IntegerToString(line.minute_id);
      row+=" | seq="+LongToString(line.sequence_no);

      if(!ISSX_Util::IsEmpty(existing))
         existing+="\n";
      existing+=row;
      return ISSX_FileIO::WriteAllTextUtf8(path,existing);
     }

   bool EmitStructuredTrace(const string firm_id,const ISSX_TraceSeverity severity,const ISSX_StageId stage_id,
                            const string code,const string message,const string detail="",
                            const long sequence_no=0,const long cooldown_ms=ISSX_TRACE_DEFAULT_COOLDOWN_MS)
     {
      const long mono_ms=NowMonoMs();
      const bool allowed=AllowTrace(code+"|"+ISSX_UI_Text::StageIdToShortString(stage_id),mono_ms,cooldown_ms);

      ISSX_TraceLine line;
      line.Reset();
      line.severity=severity;
      line.stage_id=stage_id;
      line.code=code;
      line.message=message;
      line.detail=detail;
      line.mono_ms=mono_ms;
      line.minute_id=0;
      line.sequence_no=sequence_no;
      line.rate_limited=!allowed;

      if(!allowed)
         return true;

      return EmitTraceLine(firm_id,line);
     }

   static string BuildStageSnapshotEA1(const ISSX_EA1_State &ea1)
     {
      string j="{";
      j+=ISSX_JsonWriter::NameString("stage_id","ea1")+",";
      j+=ISSX_JsonWriter::NameString("publishability_state",StagePublishabilityWord((int)ea1.runtime.publishability_state))+",";
      j+=ISSX_JsonWriter::NameBool("stage_minimum_ready_flag",ea1.runtime.minimum_ready_flag)+",";
      j+=ISSX_JsonWriter::NameString("dependency_block_reason",ValueOrNA(ea1.runtime.dependency_block_reason))+",";
      j+=ISSX_JsonWriter::NameLong("accepted_sequence_no",ea1.runtime.accepted_sequence_no)+",";
      j+=ISSX_JsonWriter::NameInt("changed_symbol_count",ea1.changed_symbol_count)+",";
      j+=ISSX_JsonWriter::NameString("broker_universe_fingerprint",ValueOrNA(ea1.broker_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameString("eligible_universe_fingerprint",ValueOrNA(ea1.eligible_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameString("active_universe_fingerprint",ValueOrNA(ea1.active_universe_fingerprint));
      j+="}";
      return j;
     }

   static string BuildStageSnapshotEA2(const ISSX_EA2_State &ea2)
     {
      string j="{";
      j+=ISSX_JsonWriter::NameString("stage_id","ea2")+",";
      j+=ISSX_JsonWriter::NameString("publishability_state",StagePublishabilityWord((int)ea2.runtime.publishability_state))+",";
      j+=ISSX_JsonWriter::NameBool("stage_minimum_ready_flag",ea2.runtime.minimum_ready_flag)+",";
      j+=ISSX_JsonWriter::NameString("dependency_block_reason",ValueOrNA(ea2.runtime.dependency_block_reason))+",";
      j+=ISSX_JsonWriter::NameLong("accepted_sequence_no",ea2.runtime.accepted_sequence_no)+",";
      j+=ISSX_JsonWriter::NameInt("changed_symbol_count",ea2.changed_symbol_count)+",";
      j+=ISSX_JsonWriter::NameInt("changed_timeframe_count",ea2.changed_timeframe_count)+",";
      j+=ISSX_JsonWriter::NameString("active_universe_fingerprint",ValueOrNA(ea2.active_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameDouble("history_deep_completion_pct",ea2.history_deep_completion_pct,2);
      j+="}";
      return j;
     }

   static string BuildStageSnapshotEA3(const ISSX_EA3_State &ea3)
     {
      string j="{";
      j+=ISSX_JsonWriter::NameString("stage_id","ea3")+",";
      j+=ISSX_JsonWriter::NameString("publishability_state",StagePublishabilityWord((int)ea3.runtime.publishability_state))+",";
      j+=ISSX_JsonWriter::NameBool("stage_minimum_ready_flag",ea3.runtime.minimum_ready_flag)+",";
      j+=ISSX_JsonWriter::NameString("dependency_block_reason",ValueOrNA(ea3.runtime.dependency_block_reason))+",";
      j+=ISSX_JsonWriter::NameLong("accepted_sequence_no",ea3.runtime.accepted_sequence_no)+",";
      j+=ISSX_JsonWriter::NameInt("changed_symbol_count",ea3.changed_symbol_count)+",";
      j+=ISSX_JsonWriter::NameInt("changed_frontier_count",ea3.changed_frontier_count)+",";
      j+=ISSX_JsonWriter::NameString("rankable_universe_fingerprint",ValueOrNA(ea3.rankable_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameString("frontier_universe_fingerprint",ValueOrNA(ea3.frontier_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameDouble("coverage_rankable_recent_pct",ea3.coverage_rankable_recent_pct,2)+",";
      j+=ISSX_JsonWriter::NameDouble("coverage_frontier_recent_pct",ea3.coverage_frontier_recent_pct,2);
      j+="}";
      return j;
     }

   static string BuildStageSnapshotEA4(const ISSX_EA4_State &ea4)
     {
      string j="{";
      j+=ISSX_JsonWriter::NameString("stage_id","ea4")+",";
      j+=ISSX_JsonWriter::NameString("publishability_state",StagePublishabilityWord((int)ea4.runtime.publishability_state))+",";
      j+=ISSX_JsonWriter::NameBool("stage_minimum_ready_flag",ea4.runtime.minimum_ready_flag)+",";
      j+=ISSX_JsonWriter::NameString("dependency_block_reason",ValueOrNA(ea4.runtime.dependency_block_reason))+",";
      j+=ISSX_JsonWriter::NameLong("accepted_sequence_no",ea4.runtime.accepted_sequence_no)+",";
      j+=ISSX_JsonWriter::NameInt("changed_symbol_count",ea4.changed_symbol_count)+",";
      j+=ISSX_JsonWriter::NameInt("changed_frontier_count",ea4.changed_frontier_count)+",";
      j+=ISSX_JsonWriter::NameString("frontier_universe_fingerprint",ValueOrNA(ea4.frontier_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameDouble("percent_frontier_revalidated_recent",ea4.percent_frontier_revalidated_recent,2);
      j+="}";
      return j;
     }

   static string BuildStageSnapshotEA5(const ISSX_EA5_State &ea5)
     {
      string j="{";
      j+=ISSX_JsonWriter::NameString("stage_id","ea5")+",";
      j+=ISSX_JsonWriter::NameString("publishability_state",StagePublishabilityWord((int)ea5.runtime.publishability_state))+",";
      j+=ISSX_JsonWriter::NameBool("stage_minimum_ready_flag",ea5.runtime.minimum_ready_flag)+",";
      j+=ISSX_JsonWriter::NameString("dependency_block_reason",ValueOrNA(ea5.runtime.dependency_block_reason))+",";
      j+=ISSX_JsonWriter::NameLong("accepted_sequence_no",ea5.runtime.accepted_sequence_no)+",";
      j+=ISSX_JsonWriter::NameInt("changed_symbol_count",ea5.changed_symbol_count)+",";
      j+=ISSX_JsonWriter::NameString("publishable_universe_fingerprint",ValueOrNA(ea5.publishable_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameLong("last_export_age_sec",ea5.last_export_age_sec)+",";
      j+=ISSX_JsonWriter::NameString("export_health_state",ValueOrNA(ea5.export_health_state));
      j+="}";
      return j;
     }

   static bool ProjectStageSnapshot(const string firm_id,const ISSX_StageId stage_id,const string json)
     {
      const string file_name=ISSX_UI_Text::StageIdToShortString(stage_id)+"_debug_snapshot.json";
      const string path=ISSX_PersistencePath::DebugFolder(firm_id)+file_name;
      return ISSX_FileIO::WriteAllTextUtf8(path,json);
     }

   static string BuildUniverseSnapshotJson(const ISSX_EA1_State &ea1,const ISSX_EA2_State &ea2,const ISSX_EA3_State &ea3,
                                          const ISSX_EA4_State &ea4,const ISSX_EA5_State &ea5)
     {
      string j="{";
      j+=ISSX_JsonWriter::NameString("engine_name",ISSX_ENGINE_NAME)+",";
      j+=ISSX_JsonWriter::NameString("engine_version",ISSX_UI_TEST_MODULE_VERSION)+",";
      j+=ISSX_JsonWriter::NameString("broker_universe_fingerprint",ValueOrNA(ea1.broker_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameString("eligible_universe_fingerprint",ValueOrNA(ea1.eligible_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameString("active_universe_fingerprint",ValueOrNA(ea2.active_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameString("rankable_universe_fingerprint",ValueOrNA(ea3.rankable_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameString("frontier_universe_fingerprint",ValueOrNA(ea4.frontier_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameString("publishable_universe_fingerprint",ValueOrNA(ea5.publishable_universe_fingerprint))+",";
      j+=ISSX_JsonWriter::NameInt("ea1_changed_symbol_count",ea1.changed_symbol_count)+",";
      j+=ISSX_JsonWriter::NameInt("ea2_changed_symbol_count",ea2.changed_symbol_count)+",";
      j+=ISSX_JsonWriter::NameInt("ea3_changed_symbol_count",ea3.changed_symbol_count)+",";
      j+=ISSX_JsonWriter::NameInt("ea4_changed_symbol_count",ea4.changed_symbol_count)+",";
      j+=ISSX_JsonWriter::NameInt("ea5_changed_symbol_count",ea5.changed_symbol_count);
      j+="}";
      return j;
     }

   static bool ProjectUniverseSnapshot(const string firm_id,const ISSX_EA1_State &ea1,const ISSX_EA2_State &ea2,const ISSX_EA3_State &ea3,
                                       const ISSX_EA4_State &ea4,const ISSX_EA5_State &ea5)
     {
      const string path=ISSX_PersistencePath::UniverseSnapshotFile(firm_id);
      return ISSX_FileIO::WriteAllTextUtf8(path,BuildUniverseSnapshotJson(ea1,ea2,ea3,ea4,ea5));
     }

   static bool ProjectAllStageSnapshots(const string firm_id,
                                        const ISSX_EA1_State &ea1,
                                        const ISSX_EA2_State &ea2,
                                        const ISSX_EA3_State &ea3,
                                        const ISSX_EA4_State &ea4,
                                        const ISSX_EA5_State &ea5)
     {
      bool ok=true;
      ok=(ProjectStageSnapshot(firm_id,issx_stage_ea1,BuildStageSnapshotEA1(ea1)) && ok);
      ok=(ProjectStageSnapshot(firm_id,issx_stage_ea2,BuildStageSnapshotEA2(ea2)) && ok);
      ok=(ProjectStageSnapshot(firm_id,issx_stage_ea3,BuildStageSnapshotEA3(ea3)) && ok);
      ok=(ProjectStageSnapshot(firm_id,issx_stage_ea4,BuildStageSnapshotEA4(ea4)) && ok);
      ok=(ProjectStageSnapshot(firm_id,issx_stage_ea5,BuildStageSnapshotEA5(ea5)) && ok);
      return ok;
     }
  };

#endif // __ISSX_UI_TEST_MQH__