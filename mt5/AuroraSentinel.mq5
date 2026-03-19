#property strict
#property version   "0.1"
#property description "Aurora Sentinel shell-only timer runtime"

#include "ASC_Engine.mqh"

input int InpKernelTimerSeconds = 1;

ASC_Engine g_engine;

int OnInit()
  {
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
