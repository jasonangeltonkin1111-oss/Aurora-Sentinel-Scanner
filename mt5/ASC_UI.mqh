#ifndef ASC_UI_MQH
#define ASC_UI_MQH

#include "ASC_Common.mqh"

class ASC_UIRuntimeHUD
  {
private:
   string m_title;

   string TimeText(const datetime value) const
     {
      return(value <= 0 ? "pending" : TimeToString(value,TIME_DATE | TIME_SECONDS));
     }

   string BoolText(const bool value) const
     {
      return(value ? "true" : "false");
     }

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
      hud += " | started=" + TimeText(snapshot.CycleCounters.LastCycleStartedAt);
      hud += " | finished=" + TimeText(snapshot.CycleCounters.LastCycleFinishedAt);
      hud += "\nrestore_at=" + TimeText(snapshot.LastRestoreAt);
      hud += " | safe_commit_at=" + TimeText(snapshot.LastSafePublishAt);
      hud += "\ndegraded=" + BoolText(snapshot.DegradedActive);
      hud += " | recovery_blocked=" + BoolText(snapshot.RecoveryBlocked);
      hud += "\nheadline=" + snapshot.PublishHeadline;
      Comment(hud);
     }

   void              Clear(void) const
     {
      Comment("");
     }
  };

#endif // ASC_UI_MQH
