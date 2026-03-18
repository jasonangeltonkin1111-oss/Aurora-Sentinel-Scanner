#property strict

#include "ASC_Common.mqh"
#include "ASC_Engine.mqh"

ASC_RuntimeConfig g_runtime_config;

int OnInit()
  {
   g_runtime_config.TimerSeconds = 60;
   g_runtime_config.MaxSymbolsPerInitPass = 200;
   g_runtime_config.MaxSymbolsPerTimerPass = 50;
   g_runtime_config.StaleFeedSeconds = 300;
   g_runtime_config.UseCommonFiles = true;

   EventSetTimer(g_runtime_config.TimerSeconds);

   if(!ASC_Engine_RunInit(g_runtime_config))
      return(INIT_FAILED);

   return(INIT_SUCCEEDED);
  }

void OnTimer()
  {
   ASC_Engine_RunTimer();
  }

void OnTick()
  {
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
  }
