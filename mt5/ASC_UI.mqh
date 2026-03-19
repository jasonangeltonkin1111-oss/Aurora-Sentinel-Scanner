#ifndef ASC_UI_MQH
#define ASC_UI_MQH

#include "ASC_Common.mqh"

string ASC_UIDateTimeText(const datetime value)
  {
   return(value <= 0 ? "pending" : TimeToString(value,TIME_DATE | TIME_SECONDS));
  }

string ASC_UIBoolText(const bool value)
  {
   return(value ? "true" : "false");
  }

class ASC_UIRuntimeHUD
  {
private:
   string m_title;

public:
                     ASC_UIRuntimeHUD(void)
                     {
                      m_title = "Aurora Sentinel Phase 1";
                     }

   void              Configure(const string title)
     {
      m_title = title;
     }

   void              Refresh(const ASC_RuntimeSnapshot &snapshot) const
     {
      string hud = m_title;
      hud += "\nmode=" + ASC_RuntimeModeText(snapshot.Mode);
      hud += " | continuity=" + ASC_ContinuityOriginText(snapshot.ContinuityOrigin);
      hud += " | hydration=" + ASC_HydrationStateText(snapshot.HydrationState);
      hud += " | publication=" + ASC_PublicationStateText(snapshot.RuntimePublicationState);
      hud += "\ncycle=" + LongToString(snapshot.CycleCounters.CycleSequence);
      hud += " | completed=" + LongToString(snapshot.CycleCounters.CompletedCycles);
      hud += " | reentry_skips=" + LongToString(snapshot.CycleCounters.ConsecutiveReentrySkips);
      hud += "\nstarted=" + ASC_UIDateTimeText(snapshot.CycleCounters.LastCycleStartedAt);
      hud += " | finished=" + ASC_UIDateTimeText(snapshot.CycleCounters.LastCycleFinishedAt);
      hud += " | heartbeat=" + ASC_UIDateTimeText(snapshot.CycleCounters.LastHeartbeatAt);
      hud += "\nrestore_at=" + ASC_UIDateTimeText(snapshot.LastRestoreAt);
      hud += " | safe_commit_at=" + ASC_UIDateTimeText(snapshot.LastSafePublishAt);
      hud += "\nwarmup_complete=" + ASC_UIBoolText(snapshot.WarmupComplete);
      hud += " | degraded=" + ASC_UIBoolText(snapshot.DegradedActive);
      hud += " | recovery_blocked=" + ASC_UIBoolText(snapshot.RecoveryBlocked);
      hud += "\nheadline=" + snapshot.PublishHeadline;
      Comment(hud);
     }

   void              Clear(void) const
     {
      Comment("");
     }
  };

#endif // ASC_UI_MQH
