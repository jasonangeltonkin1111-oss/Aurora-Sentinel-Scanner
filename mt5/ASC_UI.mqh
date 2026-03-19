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

   if(services == "")
      return("NONE");

   return(services);
  }

string ASC_UIRenderOperatorHUD(const ASC_UIRuntimeView &view)
  {
   // Rendering is intentionally string-only so redraw remains lightweight.
   string hud = "ASC Operator HUD\n";
   hud += "Mode: " + ASC_RuntimeModeText(view.Snapshot.Mode) + "\n";
   hud += "Last Cycle: " + ASC_UIDateTimeText(view.LastCycleTime) + "\n";
   hud += "Next Timer Due: " + ASC_UIDateTimeText(view.NextTimerDue) + "\n";
   hud += "Re-entry Count: " + IntegerToString(view.ReentryCount) + "\n";
   hud += "Due Services: " + ASC_UIDueServicesText(view) + "\n";
   hud += "Restore Outcome: " + ASC_UIRestoreOutcomeText(view.RestoreOutcome,view.RestoreOutcomeReady) + "\n";
   hud += "Runtime State: " + ASC_UIFlagSummary(view) + "\n";
   hud += "Continuity: " + ASC_ContinuityOriginText(view.Snapshot.ContinuityOrigin) + "\n";
   hud += "Hydration: " + ASC_HydrationStateText(view.Snapshot.HydrationState) + "\n";
   hud += "Publication: " + ASC_PublicationStateText(view.Snapshot.RuntimePublicationState);
   return(hud);
  }

class ASC_OperatorHUD
  {
private:
   ASC_UIRuntimeView m_view;
   bool              m_has_view;

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
