#ifndef ASC_UI_MQH
#define ASC_UI_MQH

#include "ASC_Common.mqh"
#include "ASC_Engine.mqh"

#define ASC_UI_PREFIX "ASC_UI_"
#define ASC_UI_CHART_ID 0

namespace ASC_UI
{
   enum SectionId
     {
      SECTION_RUNTIME = 0,
      SECTION_UNIVERSE,
      SECTION_BUCKETS,
      SECTION_MARKET,
      SECTION_CONDITIONS,
      SECTION_HISTORY,
      SECTION_INDICATORS,
      SECTION_SURFACE,
      SECTION_PUBLICATION,
      SECTION_UI,
      SECTION_ACTIONS,
      SECTION_TOTAL
     };

   static bool g_section_open[SECTION_TOTAL];
   static ASC_RuntimeConfig g_config;
   static ASC_RuntimeSnapshot g_snapshot;

   string Obj(const string suffix) { return(ASC_UI_PREFIX + suffix); }
   string TimeText(const datetime value) { return(value <= 0 ? "pending" : TimeToString(value,TIME_DATE|TIME_SECONDS)); }
   string BoolText(const bool value) { return(value ? "ON" : "OFF"); }
   string CornerText(const ASC_UICorner value)
     {
      switch(value)
        {
         case ASC_UI_TOP_RIGHT: return("TOP_RIGHT");
         case ASC_UI_BOTTOM_LEFT: return("BOTTOM_LEFT");
         case ASC_UI_BOTTOM_RIGHT: return("BOTTOM_RIGHT");
         default: return("TOP_LEFT");
        }
     }
   int CornerAnchor(const ASC_UICorner value)
     {
      switch(value)
        {
         case ASC_UI_TOP_RIGHT: return(CORNER_RIGHT_UPPER);
         case ASC_UI_BOTTOM_LEFT: return(CORNER_LEFT_LOWER);
         case ASC_UI_BOTTOM_RIGHT: return(CORNER_RIGHT_LOWER);
         default: return(CORNER_LEFT_UPPER);
        }
     }
   string TfText(const ENUM_TIMEFRAMES tf) { return(EnumToString(tf)); }

   void EnsureLabel(const string name,const int x,const int y,const string text,const color clr,const int size,const bool back=false)
     {
      if(ObjectFind(ASC_UI_CHART_ID,name) < 0)
        {
         ObjectCreate(ASC_UI_CHART_ID,name,OBJ_LABEL,0,0,0);
         ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_SELECTABLE,false);
         ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_HIDDEN,true);
        }
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_CORNER,CornerAnchor(g_config.PanelCorner));
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_FONTSIZE,size);
      ObjectSetString(ASC_UI_CHART_ID,name,OBJPROP_TEXT,text);
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_BACK,back);
     }

   void EnsureButton(const string name,const int x,const int y,const int w,const string text)
     {
      if(ObjectFind(ASC_UI_CHART_ID,name) < 0)
        {
         ObjectCreate(ASC_UI_CHART_ID,name,OBJ_BUTTON,0,0,0);
         ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_HIDDEN,true);
        }
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_CORNER,CornerAnchor(g_config.PanelCorner));
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_XSIZE,w);
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_YSIZE,g_config.FontSize + 10);
      ObjectSetInteger(ASC_UI_CHART_ID,name,OBJPROP_FONTSIZE,g_config.FontSize);
      ObjectSetString(ASC_UI_CHART_ID,name,OBJPROP_TEXT,text);
     }

   void Clear()
     {
      const int total = ObjectsTotal(ASC_UI_CHART_ID,0,-1);
      for(int index = total - 1; index >= 0; --index)
        {
         const string name = ObjectName(ASC_UI_CHART_ID,index,0,-1);
         if(StringFind(name,ASC_UI_PREFIX) == 0)
            ObjectDelete(ASC_UI_CHART_ID,name);
        }
     }

   void DrawHUD()
     {
      if(!g_config.HUDEnabled)
         return;
      int y = g_config.PanelYOffset;
      const int x = g_config.PanelXOffset;
      const int step = g_config.RowSpacing;
      EnsureLabel(Obj("HUD_TITLE"),x,y,"Aurora Sentinel Control",clrWhite,g_config.FontSize + 1); y += step;
      EnsureLabel(Obj("HUD_SYSTEM"),x,y,"SYSTEM | Scanner=" + BoolText(g_snapshot.ScannerEnabled) + " | Broker=" + g_snapshot.BrokerName + " | " + g_snapshot.PhaseText,clrAqua,g_config.FontSize); y += step;
      EnsureLabel(Obj("HUD_SYSTEM2"),x,y,"Last scan=" + TimeText(g_snapshot.LastScanTime) + " | Next run=" + TimeText(g_snapshot.NextRunTime),clrSilver,g_config.FontSize); y += step;
      EnsureLabel(Obj("HUD_COVERAGE"),x,y,"COVERAGE | Universe=" + IntegerToString(g_snapshot.UniverseCount) + " | Hydrated=" + IntegerToString(g_snapshot.HydratedCount) + " | Pending=" + IntegerToString(g_snapshot.PendingCount) + " | Published=" + IntegerToString(g_snapshot.PublishedCount),clrLime,g_config.FontSize); y += step;
      EnsureLabel(Obj("HUD_TRUTH"),x,y,"TRUTH | Open=" + IntegerToString(g_snapshot.OpenTradableCount) + " | Stale=" + IntegerToString(g_snapshot.StaleFeedCount) + " | No quote=" + IntegerToString(g_snapshot.NoQuoteCount) + " | Closed=" + IntegerToString(g_snapshot.ClosedSessionCount) + " | Unknown=" + IntegerToString(g_snapshot.UnknownCount),clrOrange,g_config.FontSize); y += step;
      EnsureLabel(Obj("HUD_TRUTH2"),x,y,"TRUTH | Specs=" + g_snapshot.SpecSummary + " | Publication=" + g_snapshot.PublicationText,clrOrange,g_config.FontSize); y += step;
      EnsureLabel(Obj("HUD_SETTINGS"),x,y,"ACTIVE SETTINGS | Init=" + IntegerToString(g_config.MaxSymbolsPerInitPass) + " | Timer=" + IntegerToString(g_config.MaxSymbolsPerTimerPass) + " | Buckets=" + g_config.EnabledPrimaryBuckets,clrYellow,g_config.FontSize); y += step;
      EnsureLabel(Obj("HUD_SETTINGS2"),x,y,"ACTIVE SETTINGS | TFs=" + TfText(g_config.PrimaryScanTimeframe) + "/" + TfText(g_config.ConfirmationTimeframe) + "/" + TfText(g_config.ContextTimeframe) + " | ATR=" + BoolText(g_config.EnableATR) + "(" + IntegerToString(g_config.ATRPeriod) + ") | Summary=" + BoolText(g_config.PublishSummary),clrYellow,g_config.FontSize); y += step;
   }

   void AddSettingButton(const string key,int &y,const string label,const string value)
     {
      EnsureButton(Obj(key),g_config.PanelXOffset,y,340,label + ": " + value);
      y += g_config.RowSpacing + 4;
     }

   void DrawSection(const SectionId id,int &y,const string title)
     {
      string toggle = g_section_open[id] ? "[-] " : "[+] ";
      EnsureButton(Obj("SECTION_" + IntegerToString((int)id)),g_config.PanelXOffset,y,340,toggle + title);
      y += g_config.RowSpacing + 6;
     }

   void DrawMenu()
     {
      if(!g_config.MenuEnabled)
         return;
      int y = g_config.PanelYOffset + 180;
      DrawSection(SECTION_RUNTIME,y,"Runtime");
      if(g_section_open[SECTION_RUNTIME])
        {
         AddSettingButton("scanner_enabled",y,"Scanner enabled",BoolText(g_config.ScannerEnabled));
         AddSettingButton("timer_seconds",y,"Timer seconds",IntegerToString(g_config.TimerSeconds));
         AddSettingButton("init_budget",y,"Max init pass",IntegerToString(g_config.MaxSymbolsPerInitPass));
         AddSettingButton("timer_budget",y,"Max timer pass",IntegerToString(g_config.MaxSymbolsPerTimerPass));
        }
      DrawSection(SECTION_UNIVERSE,y,"Universe");
      if(g_section_open[SECTION_UNIVERSE])
        {
         AddSettingButton("custom_symbols",y,"Include custom symbols",BoolText(g_config.IncludeCustomSymbols));
         AddSettingButton("disabled_symbols",y,"Include disabled trade symbols",BoolText(g_config.IncludeDisabledTradeSymbols));
         AddSettingButton("preserve_snapshot",y,"Preserve full snapshot",BoolText(g_config.PreserveFullUniverseSnapshot));
         AddSettingButton("discovery_refresh",y,"Discovery refresh minutes",IntegerToString(g_config.DiscoveryRefreshMinutes));
        }
      DrawSection(SECTION_BUCKETS,y,"Buckets");
      if(g_section_open[SECTION_BUCKETS])
        {
         AddSettingButton("bucket_filter",y,"Enable bucket filtering",BoolText(g_config.EnableBucketFiltering));
         AddSettingButton("bucket_set",y,"Enabled buckets",g_config.EnabledPrimaryBuckets);
         AddSettingButton("unknown_bucket",y,"Unknown bucket policy",g_config.UnknownBucketPolicy);
         AddSettingButton("unresolved_policy",y,"Unresolved classification",g_config.UnresolvedClassificationPolicy);
        }
      DrawSection(SECTION_MARKET,y,"Market Truth");
      if(g_section_open[SECTION_MARKET])
        {
         AddSettingButton("market_bias",y,"Continuous market bias",g_config.ContinuousMarketBias);
         AddSettingButton("stale_feed",y,"Stale feed seconds",IntegerToString(g_config.StaleFeedSeconds));
         AddSettingButton("no_quote",y,"No quote seconds",IntegerToString(g_config.NoQuoteSeconds));
         AddSettingButton("session_mode",y,"Session trust mode",g_config.SessionWindowTrustMode);
        }
      DrawSection(SECTION_CONDITIONS,y,"Conditions");
      if(g_section_open[SECTION_CONDITIONS])
        {
         AddSettingButton("strict_specs",y,"Strict spec validation",BoolText(g_config.StrictSpecValidation));
         AddSettingButton("partial_truth",y,"Preserve partial truth",BoolText(g_config.PreservePartialTruth));
         AddSettingButton("publish_partial_specs",y,"Allow publish on partial specs",BoolText(g_config.AllowPublishWhenSpecsPartial));
         AddSettingButton("require_economics",y,"Require strong economics",BoolText(g_config.RequireStrongEconomicsForPublish));
        }
      DrawSection(SECTION_HISTORY,y,"History");
      if(g_section_open[SECTION_HISTORY])
        {
         AddSettingButton("history_enable",y,"History intake",BoolText(g_config.EnableHistoryIntake));
         AddSettingButton("bars_per_tf",y,"Bars per timeframe",IntegerToString(g_config.BarsPerTimeframe));
         AddSettingButton("min_bars",y,"Minimum bars",IntegerToString(g_config.MinimumBarsRequired));
         AddSettingButton("history_required",y,"Require history before surface",BoolText(g_config.RequireHistoryBeforeSurface));
        }
      DrawSection(SECTION_INDICATORS,y,"Indicators");
      if(g_section_open[SECTION_INDICATORS])
        {
         AddSettingButton("atr_enable",y,"ATR enabled",BoolText(g_config.EnableATR));
         AddSettingButton("atr_period",y,"ATR period",IntegerToString(g_config.ATRPeriod));
         AddSettingButton("ema_enable",y,"EMA enabled",BoolText(g_config.EnableEMA));
         AddSettingButton("rsi_enable",y,"RSI enabled",BoolText(g_config.EnableRSI));
         AddSettingButton("tf_primary",y,"Primary timeframe",TfText(g_config.PrimaryScanTimeframe));
         AddSettingButton("tf_confirm",y,"Confirmation timeframe",TfText(g_config.ConfirmationTimeframe));
         AddSettingButton("tf_context",y,"Context timeframe",TfText(g_config.ContextTimeframe));
        }
      DrawSection(SECTION_SURFACE,y,"Surface");
      if(g_section_open[SECTION_SURFACE])
        {
         AddSettingButton("surface_enable",y,"Surface enabled",BoolText(g_config.EnableSurfaceLayer));
         AddSettingButton("surface_inputs",y,"Minimum surface inputs",IntegerToString(g_config.MinimumSurfaceInputs));
         AddSettingButton("surface_threshold",y,"Surface score threshold",DoubleToString(g_config.SurfaceScoreThreshold,1));
         AddSettingButton("surface_requires_conditions",y,"Require conditions before surface",BoolText(g_config.RequireConditionsBeforeSurface));
        }
      DrawSection(SECTION_PUBLICATION,y,"Publication");
      if(g_section_open[SECTION_PUBLICATION])
        {
         AddSettingButton("publish_summary",y,"Publish summary",BoolText(g_config.PublishSummary));
         AddSettingButton("publish_symbols",y,"Publish symbol files",BoolText(g_config.PublishSymbolFiles));
         AddSettingButton("publish_mirror",y,"Publish mirror",BoolText(g_config.PublishMirror));
         AddSettingButton("publish_pending",y,"Publish pending records",BoolText(g_config.PublishPendingRecords));
         AddSettingButton("clean_symbol_files",y,"Clean stale symbol files",BoolText(g_config.CleanStaleSymbolFiles));
        }
      DrawSection(SECTION_UI,y,"UI");
      if(g_section_open[SECTION_UI])
        {
         AddSettingButton("hud_enable",y,"HUD enabled",BoolText(g_config.HUDEnabled));
         AddSettingButton("menu_enable",y,"Menu enabled",BoolText(g_config.MenuEnabled));
         AddSettingButton("compact_mode",y,"Compact mode",BoolText(g_config.CompactMode));
         AddSettingButton("panel_corner",y,"Panel corner",CornerText(g_config.PanelCorner));
         AddSettingButton("font_size",y,"Font size",IntegerToString(g_config.FontSize));
         AddSettingButton("row_spacing",y,"Row spacing",IntegerToString(g_config.RowSpacing));
         AddSettingButton("show_reasons",y,"Show reasons",BoolText(g_config.ShowReasons));
         AddSettingButton("expert_mode",y,"Expert mode",BoolText(g_config.ExpertMode));
        }
      DrawSection(SECTION_ACTIONS,y,"Actions");
      if(g_section_open[SECTION_ACTIONS])
        {
         AddSettingButton("action_refresh",y,"Refresh now","Run");
         AddSettingButton("action_republish",y,"Republish now","Run");
         AddSettingButton("action_reload_universe",y,"Reload broker universe","Run");
         AddSettingButton("action_rebuild_snapshot",y,"Rebuild snapshot","Run");
         AddSettingButton("action_clean_stale",y,"Clean stale outputs","Run");
         AddSettingButton("action_reset_ui",y,"Reset UI position","Run");
         AddSettingButton("action_toggle_compact",y,"Toggle compact/full","Run");
         AddSettingButton("action_toggle_menu",y,"Toggle menu visibility","Run");
        }
     }

   void Sync()
     {
      ASC_Engine_GetRuntimeConfig(g_config);
      ASC_Engine_GetRuntimeSnapshot(g_snapshot);
     }

   void Render()
     {
      Sync();
      Clear();
      DrawHUD();
      DrawMenu();
      ChartRedraw();
     }

   void Apply()
     {
      g_config.TimerSeconds = MathMax(5,g_config.TimerSeconds);
      g_config.MaxSymbolsPerInitPass = MathMax(1,g_config.MaxSymbolsPerInitPass);
      g_config.MaxSymbolsPerTimerPass = MathMax(1,g_config.MaxSymbolsPerTimerPass);
      g_config.StaleFeedSeconds = MathMax(5,g_config.StaleFeedSeconds);
      g_config.FontSize = MathMax(8,g_config.FontSize);
      g_config.RowSpacing = MathMax(14,g_config.RowSpacing);
      ASC_Engine_UpdateRuntimeConfig(g_config);
      EventSetTimer(g_config.TimerSeconds);
      Render();
     }

   ENUM_TIMEFRAMES NextTf(const ENUM_TIMEFRAMES current)
     {
      ENUM_TIMEFRAMES values[4] = { PERIOD_M5, PERIOD_M15, PERIOD_H1, PERIOD_H4 };
      for(int i = 0; i < 4; ++i)
         if(values[i] == current)
            return(values[(i + 1) % 4]);
      return(PERIOD_M15);
     }

   void ToggleSection(const int id) { if(id >= 0 && id < SECTION_TOTAL) g_section_open[id] = !g_section_open[id]; }

   void HandleAction(const string key)
     {
      if(key == "scanner_enabled") g_config.ScannerEnabled = !g_config.ScannerEnabled;
      else if(key == "timer_seconds") g_config.TimerSeconds = (g_config.TimerSeconds >= 120 ? 15 : g_config.TimerSeconds + 15);
      else if(key == "init_budget") g_config.MaxSymbolsPerInitPass = (g_config.MaxSymbolsPerInitPass >= 500 ? 50 : g_config.MaxSymbolsPerInitPass + 50);
      else if(key == "timer_budget") g_config.MaxSymbolsPerTimerPass = (g_config.MaxSymbolsPerTimerPass >= 250 ? 25 : g_config.MaxSymbolsPerTimerPass + 25);
      else if(key == "custom_symbols") g_config.IncludeCustomSymbols = !g_config.IncludeCustomSymbols;
      else if(key == "disabled_symbols") g_config.IncludeDisabledTradeSymbols = !g_config.IncludeDisabledTradeSymbols;
      else if(key == "preserve_snapshot") g_config.PreserveFullUniverseSnapshot = !g_config.PreserveFullUniverseSnapshot;
      else if(key == "discovery_refresh") g_config.DiscoveryRefreshMinutes = (g_config.DiscoveryRefreshMinutes >= 120 ? 5 : g_config.DiscoveryRefreshMinutes + 5);
      else if(key == "bucket_filter") g_config.EnableBucketFiltering = !g_config.EnableBucketFiltering;
      else if(key == "bucket_set") g_config.EnabledPrimaryBuckets = (g_config.EnabledPrimaryBuckets == "ALL" ? "FX_MAJOR,FX_CROSS,US_EQUITY_TECHNOLOGY" : "ALL");
      else if(key == "unknown_bucket") g_config.UnknownBucketPolicy = (g_config.UnknownBucketPolicy == "KEEP_VISIBLE" ? "HIDE" : "KEEP_VISIBLE");
      else if(key == "unresolved_policy") g_config.UnresolvedClassificationPolicy = (g_config.UnresolvedClassificationPolicy == "KEEP_PENDING" ? "EXCLUDE" : "KEEP_PENDING");
      else if(key == "market_bias") g_config.ContinuousMarketBias = (g_config.ContinuousMarketBias == "NEUTRAL" ? "CONTINUOUS" : "NEUTRAL");
      else if(key == "stale_feed") g_config.StaleFeedSeconds = (g_config.StaleFeedSeconds >= 900 ? 60 : g_config.StaleFeedSeconds + 60);
      else if(key == "no_quote") g_config.NoQuoteSeconds = (g_config.NoQuoteSeconds >= 900 ? 60 : g_config.NoQuoteSeconds + 60);
      else if(key == "session_mode") g_config.SessionWindowTrustMode = (g_config.SessionWindowTrustMode == "BALANCED" ? "STRICT" : "BALANCED");
      else if(key == "strict_specs") g_config.StrictSpecValidation = !g_config.StrictSpecValidation;
      else if(key == "partial_truth") g_config.PreservePartialTruth = !g_config.PreservePartialTruth;
      else if(key == "publish_partial_specs") g_config.AllowPublishWhenSpecsPartial = !g_config.AllowPublishWhenSpecsPartial;
      else if(key == "require_economics") g_config.RequireStrongEconomicsForPublish = !g_config.RequireStrongEconomicsForPublish;
      else if(key == "history_enable") g_config.EnableHistoryIntake = !g_config.EnableHistoryIntake;
      else if(key == "bars_per_tf") g_config.BarsPerTimeframe = (g_config.BarsPerTimeframe >= 1000 ? 200 : g_config.BarsPerTimeframe + 100);
      else if(key == "min_bars") g_config.MinimumBarsRequired = (g_config.MinimumBarsRequired >= 500 ? 100 : g_config.MinimumBarsRequired + 50);
      else if(key == "history_required") g_config.RequireHistoryBeforeSurface = !g_config.RequireHistoryBeforeSurface;
      else if(key == "atr_enable") g_config.EnableATR = !g_config.EnableATR;
      else if(key == "atr_period") g_config.ATRPeriod = (g_config.ATRPeriod >= 28 ? 7 : g_config.ATRPeriod + 7);
      else if(key == "ema_enable") g_config.EnableEMA = !g_config.EnableEMA;
      else if(key == "rsi_enable") g_config.EnableRSI = !g_config.EnableRSI;
      else if(key == "tf_primary") g_config.PrimaryScanTimeframe = NextTf(g_config.PrimaryScanTimeframe);
      else if(key == "tf_confirm") g_config.ConfirmationTimeframe = NextTf(g_config.ConfirmationTimeframe);
      else if(key == "tf_context") g_config.ContextTimeframe = NextTf(g_config.ContextTimeframe);
      else if(key == "surface_enable") g_config.EnableSurfaceLayer = !g_config.EnableSurfaceLayer;
      else if(key == "surface_inputs") g_config.MinimumSurfaceInputs = (g_config.MinimumSurfaceInputs >= 5 ? 1 : g_config.MinimumSurfaceInputs + 1);
      else if(key == "surface_threshold") g_config.SurfaceScoreThreshold = (g_config.SurfaceScoreThreshold >= 80.0 ? 20.0 : g_config.SurfaceScoreThreshold + 10.0);
      else if(key == "surface_requires_conditions") g_config.RequireConditionsBeforeSurface = !g_config.RequireConditionsBeforeSurface;
      else if(key == "publish_summary") g_config.PublishSummary = !g_config.PublishSummary;
      else if(key == "publish_symbols") g_config.PublishSymbolFiles = !g_config.PublishSymbolFiles;
      else if(key == "publish_mirror") g_config.PublishMirror = !g_config.PublishMirror;
      else if(key == "publish_pending") g_config.PublishPendingRecords = !g_config.PublishPendingRecords;
      else if(key == "clean_symbol_files") g_config.CleanStaleSymbolFiles = !g_config.CleanStaleSymbolFiles;
      else if(key == "hud_enable") g_config.HUDEnabled = !g_config.HUDEnabled;
      else if(key == "menu_enable") g_config.MenuEnabled = !g_config.MenuEnabled;
      else if(key == "compact_mode") g_config.CompactMode = !g_config.CompactMode;
      else if(key == "panel_corner") g_config.PanelCorner = (ASC_UICorner)(((int)g_config.PanelCorner + 1) % 4);
      else if(key == "font_size") g_config.FontSize = (g_config.FontSize >= 16 ? 9 : g_config.FontSize + 1);
      else if(key == "row_spacing") g_config.RowSpacing = (g_config.RowSpacing >= 28 ? 16 : g_config.RowSpacing + 2);
      else if(key == "show_reasons") g_config.ShowReasons = !g_config.ShowReasons;
      else if(key == "expert_mode") g_config.ExpertMode = !g_config.ExpertMode;
      else if(key == "action_refresh") { ASC_Engine_RequestImmediateRefresh(); ASC_Engine_RunTimer(); }
      else if(key == "action_republish") { ASC_Engine_RequestRepublish(); ASC_Engine_RunTimer(); }
      else if(key == "action_reload_universe") { ASC_Engine_RequestReloadUniverse(); ASC_Engine_RunTimer(); }
      else if(key == "action_rebuild_snapshot") { ASC_Engine_RequestRebuildSnapshot(); ASC_Engine_RunTimer(); }
      else if(key == "action_clean_stale") { ASC_Engine_RequestCleanStaleOutputs(); ASC_Engine_RunTimer(); }
      else if(key == "action_reset_ui") { g_config.PanelCorner = ASC_UI_TOP_LEFT; g_config.PanelXOffset = 12; g_config.PanelYOffset = 18; }
      else if(key == "action_toggle_compact") g_config.CompactMode = !g_config.CompactMode;
      else if(key == "action_toggle_menu") g_config.MenuEnabled = !g_config.MenuEnabled;
      Apply();
     }

   void Init(const ASC_RuntimeConfig &defaults)
     {
      g_config = defaults;
      for(int i = 0; i < SECTION_TOTAL; ++i)
         g_section_open[i] = (i == SECTION_RUNTIME || i == SECTION_PUBLICATION || i == SECTION_ACTIONS || i == SECTION_UI);
      ASC_Engine_UpdateRuntimeConfig(g_config);
      EventSetTimer(g_config.TimerSeconds);
      Render();
     }

   void Shutdown() { Clear(); }

   void OnTimer() { Render(); }

   void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
     {
      if(id != CHARTEVENT_OBJECT_CLICK)
         return;
      if(StringFind(sparam,Obj("SECTION_")) == 0)
        {
         ToggleSection((int)StringToInteger(StringSubstr(sparam,StringLen(Obj("SECTION_")))));
         Render();
         return;
        }
      if(StringFind(sparam,ASC_UI_PREFIX) != 0)
         return;
      HandleAction(StringSubstr(sparam,StringLen(ASC_UI_PREFIX)));
     }
}

#endif
