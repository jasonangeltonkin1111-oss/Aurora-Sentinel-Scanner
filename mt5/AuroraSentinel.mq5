#property strict
#property version "1.003"

// ==================================================
// AURORA SENTINEL SCANNER VERSION BLOCK
// Always update this block when this EA changes.
// ==================================================
#define ASC_VERSION            "1.003"
#define ASC_VERSION_DATE_UTC   "2026-03-19"
#define ASC_VERSION_SCOPE      "Operator UI control module"

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
#include "ASC_UI.mqh"

int OnInit()
  {
   ASC_RuntimeConfig runtime_config;
   ZeroMemory(runtime_config);
   runtime_config.ScannerEnabled = true;
   runtime_config.TimerSeconds = 60;
   runtime_config.MaxSymbolsPerInitPass = 200;
   runtime_config.MaxSymbolsPerTimerPass = 50;
   runtime_config.DiscoveryRefreshMinutes = 15;
   runtime_config.StaleFeedSeconds = 300;
   runtime_config.NoQuoteSeconds = 600;
   runtime_config.UseCommonFiles = true;
   runtime_config.IncludeCustomSymbols = true;
   runtime_config.IncludeDisabledTradeSymbols = false;
   runtime_config.PreserveFullUniverseSnapshot = true;
   runtime_config.PendingHydrationAllowed = true;
   runtime_config.EnableBucketFiltering = false;
   runtime_config.EnabledPrimaryBuckets = "ALL";
   runtime_config.UnknownBucketPolicy = "KEEP_VISIBLE";
   runtime_config.UnresolvedClassificationPolicy = "KEEP_PENDING";
   runtime_config.ContinuousMarketBias = "NEUTRAL";
   runtime_config.SessionWindowTrustMode = "BALANCED";
   runtime_config.UseSessionReferenceEvidence = true;
   runtime_config.RecheckOpenSeconds = 60;
   runtime_config.RecheckClosedSeconds = 300;
   runtime_config.RecheckUnknownSeconds = 180;
   runtime_config.StrictSpecValidation = true;
   runtime_config.PreservePartialTruth = true;
   runtime_config.RejectBrokerZeroEconomics = true;
   runtime_config.SuspiciousTickValueHandling = "WARN";
   runtime_config.SuspiciousTickSizeHandling = "WARN";
   runtime_config.AllowPublishWhenSpecsPartial = true;
   runtime_config.RequireStrongEconomicsForPublish = false;
   runtime_config.EnableHistoryIntake = true;
   runtime_config.BarsPerTimeframe = 300;
   runtime_config.MinimumBarsRequired = 120;
   runtime_config.HistoryLoadMode = "ON_DEMAND";
   runtime_config.PublishHistorySection = true;
   runtime_config.RequireHistoryBeforeSurface = false;
   runtime_config.EnableATR = true;
   runtime_config.ATRPeriod = 14;
   runtime_config.ATRTimeframe = PERIOD_H1;
   runtime_config.ATRThresholdProfile = "BALANCED";
   runtime_config.EnableEMA = false;
   runtime_config.EMAFastPeriod = 20;
   runtime_config.EMASlowPeriod = 50;
   runtime_config.EMATimeframe = PERIOD_H1;
   runtime_config.EnableRSI = false;
   runtime_config.RSIPeriod = 14;
   runtime_config.RSITimeframe = PERIOD_H1;
   runtime_config.RSIThresholdProfile = "50_70";
   runtime_config.PrimaryScanTimeframe = PERIOD_M15;
   runtime_config.ConfirmationTimeframe = PERIOD_H1;
   runtime_config.ContextTimeframe = PERIOD_H4;
   runtime_config.EnabledTimeframeSet = "M15,H1,H4";
   runtime_config.EnableSurfaceLayer = true;
   runtime_config.MinimumSurfaceInputs = 2;
   runtime_config.SurfaceScoreThreshold = 40.0;
   runtime_config.RequireConditionsBeforeSurface = true;
   runtime_config.PublishSummary = true;
   runtime_config.PublishSymbolFiles = true;
   runtime_config.PublishMirror = true;
   runtime_config.PublishPendingRecords = true;
   runtime_config.HideUnresolvedClassification = false;
   runtime_config.HideWeakSpecs = false;
   runtime_config.IncludeSuspiciousTruthWithWarning = true;
   runtime_config.SummaryMode = "COMPACT";
   runtime_config.MaxItemsPerBucket = 5;
   runtime_config.CleanStaleSymbolFiles = true;
   runtime_config.CleanStaleSummary = true;
   runtime_config.CleanLegacyBadRoots = true;
   runtime_config.HUDEnabled = true;
   runtime_config.MenuEnabled = true;
   runtime_config.CompactMode = true;
   runtime_config.PanelCorner = ASC_UI_TOP_LEFT;
   runtime_config.PanelXOffset = 12;
   runtime_config.PanelYOffset = 18;
   runtime_config.FontSize = 9;
   runtime_config.RowSpacing = 18;
   runtime_config.ShowReasons = true;
   runtime_config.ShowCounts = true;
   runtime_config.ExpertMode = false;

   ASC_LogVersionBlock();
   EventSetTimer(runtime_config.TimerSeconds);
   if(!ASC_Engine_RunInit(runtime_config))
      return(INIT_FAILED);
   ASC_UI::Init(runtime_config);
   return(INIT_SUCCEEDED);
  }

void OnTimer()
  {
   ASC_Engine_RunTimer();
   ASC_UI::OnTimer();
  }

void OnTick()
  {
  }

void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   ASC_UI::OnChartEvent(id,lparam,dparam,sparam);
  }

void OnDeinit(const int reason)
  {
   ASC_UI::Shutdown();
   ASC_Engine_Shutdown();
   EventKillTimer();
  }
