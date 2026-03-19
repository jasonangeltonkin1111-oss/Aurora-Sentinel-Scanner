#property strict
#property version   "1.000"
#property description "Aurora Sentinel shell-only timer runtime"

// ==================================================
// AURORA SENTINEL SHELL VERSION BLOCK
// Keep property and runtime-reported version metadata aligned.
// ==================================================
#define ASC_VERSION            "1.000"
#define ASC_VERSION_DATE_UTC   "2026-03-19"
#define ASC_VERSION_SCOPE      "Shell-only timer runtime"

void ASC_LogVersionBlock()
  {
   Print("Aurora Sentinel");
   Print("Version: ", ASC_VERSION);
   Print("VersionDateUTC: ", ASC_VERSION_DATE_UTC);
   Print("VersionScope: ", ASC_VERSION_SCOPE);
  }

#include "ASC_Engine.mqh"

input int InpKernelTimerSeconds = 1;

ASC_Engine g_engine;

int OnInit()
  {
   ASC_LogVersionBlock();
   return(g_engine.Init(InpKernelTimerSeconds));
  }

void OnDeinit(const int reason)
  {
   g_engine.Deinit(reason);
  }

void OnTick()
  {
   // Heavy runtime path intentionally disabled on ticks.
  }

void OnTimer()
  {
   g_engine.Timer();
  }
