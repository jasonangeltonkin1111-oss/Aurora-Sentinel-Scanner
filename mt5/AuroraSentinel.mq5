#property strict
#property version   "0.1"
#property description "Aurora Sentinel shell-only timer runtime"

#include "ASC_Common.mqh"
#include "ASC_Storage.mqh"
#include "ASC_Diagnostics.mqh"
#include "ASC_UI.mqh"
#include "ASC_Engine.mqh"

input int InpKernelTimerSeconds = 1;
input bool InpPauseShell = false;
input bool InpDegradedShell = false;
input bool InpRecoveryHoldShell = false;

ASC_Engine g_engine;

int OnInit()
  {
   g_engine.RequestPause(InpPauseShell);
   g_engine.RequestDegraded(InpDegradedShell);
   g_engine.RequestRecoveryHold(InpRecoveryHoldShell);
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
