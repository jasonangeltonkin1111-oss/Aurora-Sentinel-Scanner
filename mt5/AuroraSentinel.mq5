#property strict
#property version   "0.2.2"

// ==================================================
// AURORA SENTINEL SCANNER VERSION BLOCK
// Always update this block when this EA changes.
// ==================================================
#define ASC_VERSION            "0.2.2"
#define ASC_VERSION_DATE_UTC   "2026-03-19"
#define ASC_VERSION_SCOPE      "MT5 runtime logger and function map"

void ASC_LogVersionBlock()
  {
   Print("Aurora Sentinel Scanner");
   Print("Version: ", ASC_VERSION);
   Print("VersionDateUTC: ", ASC_VERSION_DATE_UTC);
   Print("VersionScope: ", ASC_VERSION_SCOPE);
  }

#include "ASC_Common.mqh"
#include "ASC_Logger.mqh"
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

   ASC_Logger_Start(runtime_config);
   ASC_Logger_Log("INFO","EA","OnInit","starting initialization");
   ASC_LogVersionBlock();

   EventSetTimer(runtime_config.TimerSeconds);
   ASC_Logger_Log("INFO","EA","OnInit","timer armed seconds=" + IntegerToString(runtime_config.TimerSeconds));

   if(!ASC_Engine_RunInit(runtime_config))
     {
      ASC_Logger_Log("ERROR","EA","OnInit","ASC_Engine_RunInit failed");
      return(INIT_FAILED);
     }

   ASC_Logger_Log("INFO","EA","OnInit","initialization complete");
   return(INIT_SUCCEEDED);
  }

void OnTimer()
  {
   ASC_Logger_Log("INFO","EA","OnTimer","timer pass started");
   ASC_Engine_RunTimer();
   ASC_Logger_Log("INFO","EA","OnTimer","timer pass finished");
  }

void OnTick()
  {
  }

void OnDeinit(const int reason)
  {
   ASC_Logger_Log("INFO","EA","OnDeinit","deinitializing reason=" + IntegerToString(reason));
   EventKillTimer();
   ASC_Logger_Stop("EA deinitialized reason=" + IntegerToString(reason));
  }
