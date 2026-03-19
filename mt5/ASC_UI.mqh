#ifndef ASC_UI_MQH
#define ASC_UI_MQH

#include "ASC_Common.mqh"

#define ASC_UI_MAX_DUE_SERVICE_PLACEHOLDERS 8

// ============================================================================
// ASC UI Shell
// Operator-facing HUD shell only.
//
// Guardrails:
// - UI reads prepared state only.
// - UI must not compute heavy truth.
// - UI must not scan files.
// - UI must not mutate runtime state except through future explicit
//   operator-request enqueue hooks.
// - Display strings must stay operator-facing and must not leak internal
//   worker/dev-wave terminology.
// ============================================================================

struct ASC_UIRuntimeView
  {
   ASC_RuntimeSnapshot       Snapshot;
   ASC_RuntimeRestoreOutcome RestoreOutcome;
   datetime                  LastCycleTime;
   datetime                  NextTimerDue;
   long                      ReentryCount;
   bool                      RestoreOutcomeReady;
   int                       ActiveDueServiceCount;
   string                    ActiveDueServicePlaceholders[ASC_UI_MAX_DUE_SERVICE_PLACEHOLDERS];
  };

string ASC_UIBoolText(const bool value)
  {
   return(value ? "YES" : "NO");
  }

string ASC_UIDateTimeText(const datetime value)
  {
   if(value <= 0)
      return("PENDING");

   return(TimeToString(value,TIME_DATE | TIME_SECONDS));
  }

string ASC_UIRestoreOutcomeText(const ASC_RuntimeRestoreOutcome &outcome,const bool ready)
  {
   if(!ready)
      return("PENDING");

   string summary = ASC_ServiceOutcomeText(outcome.Outcome);

   if(outcome.CompatibilityHold)
      summary += " / COMPATIBILITY_HOLD";

   if(outcome.RuntimeStateLoaded)
      summary += " / RUNTIME_STATE_LOADED";
   else if(outcome.JournalsInspected)
      summary += " / JOURNALS_ONLY";
   else
      summary += " / NOT_INSPECTED";

   return(summary);
  }

string ASC_UIFlagSummary(const ASC_UIRuntimeView &view)
  {
   string flags = "";

   if(view.Snapshot.DegradedActive)
      flags = "DEGRADED";

   if(view.Snapshot.Mode == ASC_RUNTIME_PAUSED)
     {
      if(flags != "")
         flags += " | ";
      flags += "PAUSED";
     }

   if(view.Snapshot.RecoveryBlocked || view.Snapshot.Mode == ASC_RUNTIME_RECOVERY_HOLD)
     {
      if(flags != "")
         flags += " | ";
      flags += "RECOVERY_HOLD";
     }

   if(flags == "")
      return("NORMAL");

   return(flags);
  }

string ASC_UIDueServicesText(const ASC_UIRuntimeView &view)
  {
   if(view.ActiveDueServiceCount <= 0)
      return("NONE");

   string services = "";
   const int count = MathMin(view.ActiveDueServiceCount,ASC_UI_MAX_DUE_SERVICE_PLACEHOLDERS);
   for(int i = 0; i < count; ++i)
     {
      if(view.ActiveDueServicePlaceholders[i] == "")
         continue;

      if(services != "")
         services += " | ";

      services += view.ActiveDueServicePlaceholders[i];
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
   hud += "Re-entry Count: " + LongToString(view.ReentryCount) + "\n";
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
                     ASC_OperatorHUD()
                     {
                        m_has_view = false;
                     }

   void              SetView(const ASC_UIRuntimeView &view)
     {
      // Prepared state arrives from runtime shell/services. No derivation here.
      m_view     = view;
      m_has_view = true;
     }

   bool              HasView() const
     {
      return(m_has_view);
     }

   string            RenderText() const
     {
      if(!m_has_view)
         return("ASC Operator HUD\nState: PENDING");

      return(ASC_UIRenderOperatorHUD(m_view));
     }

   void              DrawToChart() const
     {
      Comment(RenderText());
     }

   void              Clear() const
     {
      Comment("");
     }

   // Future operator actions must flow through explicit enqueue hooks.
   // This shell intentionally exposes no runtime mutation methods.
  };

#endif // ASC_UI_MQH
