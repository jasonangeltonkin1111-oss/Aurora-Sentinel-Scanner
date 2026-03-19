#property strict
#property version   "0.2.1"

// ==================================================
// AURORA SENTINEL SCANNER VERSION BLOCK
// Always update this block when this EA changes.
// ==================================================
#define ASC_VERSION            "0.2.1"
#define ASC_VERSION_DATE_UTC   "2026-03-18"
#define ASC_VERSION_SCOPE      "Layer 1 / Layer 1.2 truth rebuild follow-up"

void ASC_LogVersionBlock()
  {
   Print("Aurora Sentinel Scanner");
   Print("Version: ", ASC_VERSION);
   Print("VersionDateUTC: ", ASC_VERSION_DATE_UTC);
   Print("VersionScope: ", ASC_VERSION_SCOPE);
  }

#include "ASC_Common.mqh"
#include "ASC_Market.mqh"
#include "ASC_Conditions.mqh"
#include "ASC_Surface.mqh"
#include "ASC_Storage.mqh"
#include "ASC_Output.mqh"
#include "ASC_Engine.mqh"

int OnInit()
  {
   ASC_RuntimeConfig runtime_config;
   runtime_config.TimerSeconds = 60;
   runtime_config.MaxSymbolsPerInitPass = 200;
   runtime_config.MaxSymbolsPerTimerPass = 50;
   runtime_config.StaleFeedSeconds = 300;
   runtime_config.UseCommonFiles = true;

   ASC_LogVersionBlock();

   EventSetTimer(runtime_config.TimerSeconds);

   if(!ASC_Engine_RunInit(runtime_config))
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
