#property strict

#include "ASC_Common.mqh"
#include "ASC_Market.mqh"
#include "ASC_Engine.mqh"

ASC_RuntimeConfig g_asc_runtime_config;

int OnInit()
  {
   EventSetTimer(60);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
  }

void OnTick()
  {
  }

void OnTimer()
  {
   ASC_Engine_RunOnce(g_asc_runtime_config);
  }
