//+--------------------------------------------------------------------------------------+
//|                                                             Aegis_Forge_Scanner.mq5  |
//|  Aegis Forge Scanner - Phase 5 completion hardening / downstream permission layer  |
//+--------------------------------------------------------------------------------------+
#property strict
#property version   "1.561"
#property description "AFS Phase 5 publication hardening + downstream execution permission"

//====================================================================
// AFS LIVE SYSTEM SAFETY MAP
//====================================================================
// PROTECTED CORE (do not casually touch):
// - startup order / OnInit / heartbeat sequencing
// - Step 8 / 9 / 10 runtime semantics
// - warm-state load/save contracts
// - raw AFS_UniverseSymbol field meaning
//
// PREFERRED SAFE EDIT ZONES:
// - prepared/effective analytics
// - dossier/summary formatting
// - guarded fallbacks with source labels
//
// MAIN RULE FOR FUTURE CHATS:
// If a change touches protected zones, the version and artifact link
// must change, and the change should be wrapper/shadow/guarded rather
// than direct semantic replacement.
//====================================================================

//--------------------------------------------------------------------
// Wrapper identity
//--------------------------------------------------------------------
#define AFS_EA_NAME        "Aegis Forge Scanner"
#define AFS_VERSION_TEXT   "1.561"
#define AFS_OBJ_PREFIX     "AFSUI_"
#define AFS_DISPLAY_PHASE_TAG "Phase 5 completion hardening + next bounded phase step"
#define AFS_DISPLAY_STEP_TAG  "Finalize publication hardening + downstream execution permission"
#define AFS_DISPLAY_PHASE_STEP_CONTEXT "Active publication freshness/completeness hardened | downstream-only rejection/execution-permission active | Step 8/9/10 truth unchanged"
#define AFS_DISPLAY_DEFERRED_FEATURES_HEADER "Downstream-only execution permission is active; scanner-core truth, ranking, and correlation remain unchanged."

#include "AFS_CoreTypes.mqh"
#include "AFS_OutputDebug.mqh"
#include "AFS_Classification.mqh"
#include "AFS_MarketCore.mqh"
#include "AFS_HistoryFriction.mqh"
#include "AFS_Selection.mqh"
#include "AFS_TraderIntel.mqh"
#include "AFS_TraderDossierEngine.mqh"

//--------------------------------------------------------------------
// Theme
//--------------------------------------------------------------------
input group "0. HUD Colors"

// Background
input color AFS_CLR_BG         = C'9,12,18';

// Panels
input color AFS_CLR_PANEL      = C'18,24,33';
input color AFS_CLR_PANEL_ALT  = C'23,31,42';

// Header
input color AFS_CLR_HEADER     = C'24,32,44';
input color AFS_CLR_HEADER_ALT = C'28,39,54';

// Text
input color AFS_CLR_TEXT       = C'235,241,248';
input color AFS_CLR_TEXT_DIM   = C'149,163,179';

// Accent
input color AFS_CLR_ACCENT     = C'74,199,188';

// Status
input color AFS_CLR_OK         = C'88,214,141';
input color AFS_CLR_WARN       = C'242,179,74';
input color AFS_CLR_FAIL       = C'230,108,118';

// Borders
input color AFS_CLR_BORDER     = C'47,61,79';

// Buttons
input color AFS_CLR_BTN        = C'24,32,44';
input color AFS_CLR_BTN_ACTIVE = C'34,60,74';
input color AFS_CLR_BTN_WARN   = C'82,61,31';
input color AFS_CLR_BTN_TEXT   = C'235,241,248';

//--------------------------------------------------------------------
// General
//--------------------------------------------------------------------
input group "1. General"
input bool                     EnableEA                     = true;
input int                      TimerSeconds                 = 1;
input bool                     SnapshotMode                 = false;
input string                   BuildLabel                   = "AFS_P1_S12_TRADER_DATA_v1";
input bool                     EnableJournalLogs            = true;

//--------------------------------------------------------------------
// Mode
//--------------------------------------------------------------------
input group "2. Mode"
input AFS_EffectiveMode        EffectiveModeSelector        = MODE_DEV;
input bool                     AllowTraderModeOnlyIfPhase1Complete = true;
input string                   CurrentPhaseTag              = "Phase 1";
input string                   CurrentStepTag               = "Step 12";
input bool                     Phase1Complete               = false;

//--------------------------------------------------------------------
// Scope
//--------------------------------------------------------------------
input group "3. Scope"
input string                   AssetClassFilter             = "ALL";
input string                   PrimaryBucketFilter          = "ALL";
input string                   SectorFilter                 = "ALL";
input string                   SymbolFilter                 = "ALL";
input string                   CustomSymbolList             = "";
input int                      MaxSymbolsToShow             = 25;
input bool                     IncludeUnclassifiedForReview = true;
input bool                     ScanSelectedScopeOnly        = false;

//--------------------------------------------------------------------
// Pipeline
//--------------------------------------------------------------------
input group "4. Pipeline"
input AFS_PipelineTarget       PipelineTarget               = PIPELINE_FULL;

//--------------------------------------------------------------------
// Scheduling
//--------------------------------------------------------------------
input group "5. Scheduling"
input int                      SurfaceBatchSize             = 50;
input int                      DeepBatchSize                = 10;
input AFS_RotationMode         RotationMode                 = ROTATION_STAGED;
input AFS_SurfaceUpdatePolicy  SurfaceUpdatePolicy          = SURFACE_ROUND_ROBIN;
input AFS_DeepUpdatePolicy     DeepUpdatePolicy             = DEEP_PRIORITY_REFRESH;
input bool                     AllowAdaptiveTiming          = true;
input int                      MinCyclePauseMs              = 250;
input int                      MaxCyclePauseMs              = 1500;
input AFS_PromoteThresholdProfile PromoteThresholdProfile   = PROMOTE_BALANCED;
input bool                     RefreshTopSetPriority        = true;

//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
input group "6. Output"
input AFS_OutputProfile        OutputProfile                = OUTPUT_SELECTED_SCOPE;
input bool                     UseCommonFilesRoot           = true;
input string                   OutputRootFolderName         = "AFS";
input bool                     WriteStep2SummaryFile        = true;
input bool                     ExportUniverseBrokerView     = true;
input bool                     ExportUniverseRawData        = true;
input bool                     UniverseUseMarketWatchOnly   = false;
input bool                     EnableTraderPackageOutput    = true;
input bool                     EnableTraderIntelExport      = false;
input string                   TraderIntelSchemaVersion     = "AFS_P1_S12_TRADER_DATA_v1";
input int                      TraderIntelMaxSymbols        = 50;
input bool                     TraderIntelIncludeM1         = true;
input bool                     TraderIntelIncludeM5         = true;
input bool                     TraderIntelIncludeM15        = true;
input bool                     TraderIntelIncludeH1         = true;

//--------------------------------------------------------------------
// HUD
//--------------------------------------------------------------------
input group "7. HUD"
input bool                     ShowHUD                      = true;
input AFS_HUDProfile           HUDProfile                   = HUD_NORMAL;
input bool                     ShowCorrelationPreview       = false;
input ENUM_BASE_CORNER         HudCorner                    = CORNER_LEFT_UPPER;
input int                      HudX                         = 14;
input int                      HudY                         = 14;
input bool                     OwnChartDomain               = true;
input bool                     ClearAllChartObjectsOnInit   = true;
input bool                     AutoFitPanel                 = true;
input bool                     AllowHudButtons              = true;
input bool                     ShowControlRail              = false;
input int                      PanelWidthPx                 = 1380;
input int                      PanelHeightPx                = 710;
input int                      ControlRailWidthPx           = 170;

//--------------------------------------------------------------------
// Debug
//--------------------------------------------------------------------
input group "8. Debug"
input bool                     DebugVerbose                 = false;
input bool                     DebugShowTimings             = true;
input bool                     DebugShowRejectReasons       = true;
input bool                     DebugShowWeakReasons         = true;
input bool                     DebugShowCalculationSource   = true;
input bool                     DebugShowTrustGrades         = true;
input bool                     DebugShowRotationState       = false;
input bool                     DebugShowBatchState          = false;
input bool                     DebugShowPublicationTrace     = false;

//--------------------------------------------------------------------
// Testing
//--------------------------------------------------------------------
input group "9. Testing"
input AFS_TestTarget           TestTarget                   = TEST_NONE;

//--------------------------------------------------------------------
// Thresholds
//--------------------------------------------------------------------
input group "10. Thresholds"
input int                      MinBarsM15                   = 200;
input int                      MinBarsH1                    = 200;
input double                   MaxSpreadAtr                 = 0.25;
input int                      MinUpdateCount               = 3;
input int                      MaxTickAge                   = 120;
input double                   BucketQualityFloor           = 50.0;
input string                   RankingWeights               = "Move=25;Cost=20;Live=20;Trust=20;Fresh=15";
input int                      FinalCorrelationSetMax       = 50;
input int                      FrictionSampleCount          = 10;
input int                      FrictionSampleWindowSec      = 30;
input double                   SurfacePromotionThreshold    = 40.0;
input double                   RefreshPriorityWeight        = 1.25;

input group "11. Analytics / History Tuning"
input int                      AnalyticsMinBarsM1            = 120;
input int                      AnalyticsMinBarsM5            = 120;
input int                      AnalyticsMinBarsM15           = 200;
input int                      AnalyticsMinBarsH1            = 200;
input int                      AnalyticsMinBarsH4            = 120;
input int                      AnalyticsMinBarsD1            = 120;
input int                      AnalyticsMinBarsW1            = 52;
input int                      AnalyticsAtrPeriod            = 14;
input bool                     AnalyticsIncludeHeavyHTF      = true;

input group "12. Tactical / Dossier Tuning"
input int                      TacticalLightCadenceSeconds   = 10;
input int                      TacticalHeavyCadenceSeconds   = 300;
input int                      TacticalWindowM1Bars          = 6;
input int                      TacticalWindowM5Bars          = 6;
input int                      TacticalWindowM15Bars         = 4;
input int                      DossierOHLCBarsM1            = 20;
input int                      DossierOHLCBarsM5            = 20;
input int                      DossierOHLCBarsM15           = 20;
input int                      DossierOHLCBarsH1            = 20;
input int                      DossierOHLCBarsH4            = 20;
input int                      DossierOHLCBarsD1            = 20;
input int                      DossierOHLCBarsW1            = 20;

input group "13. HUD / Display Tuning"
input bool                     HudNormalShowModules         = true;
input bool                     HudNormalShowScheduling      = false;
input bool                     HudNormalShowScope           = false;
input bool                     HudNormalShowNotes           = true;
input bool                     HudCompactShowNotes          = true;

//--------------------------------------------------------------------
// Globals
//--------------------------------------------------------------------
AFS_RuntimeState g_state;
int      g_chartWidthPx              = 0;
int      g_chartHeightPx             = 0;
bool     g_hudCreated                = false;
bool     g_hudLayoutDirty            = true;
bool     g_surfaceArtifactsDirty     = false;
int      g_specCursor                = 0;
int      g_historyCursor             = 0;
int      g_frictionCursor            = 0;
string   g_lastLayoutSignature       = "";
datetime g_lastSelectionRunAt        = 0;
datetime g_lastCorrelationRunAt      = 0;
datetime g_lastDebugSurfaceAt        = 0;
datetime g_lastStep2SummaryWriteAt   = 0;
datetime g_lastUniverseSummaryWriteAt = 0;
datetime g_lastFinalWriteAt          = 0;
string   g_lastFinalOutputSignature  = "";
string   g_lastTraderSummaryFingerprint = "";
datetime g_lastTraderSummaryWriteAt = 0;
string   g_traderDossierStateSymbols[];
string   g_traderDossierStateSignatures[];
datetime g_traderDossierStateWriteAt[];
int      g_traderDossierWriteCursor = 0;
string   g_tacticalSymbols[];
bool     g_tacticalActive[];
datetime g_tacticalLastLightAt[];
datetime g_tacticalLastHeavyAt[];
datetime g_tacticalNextLightAt[];
datetime g_tacticalNextHeavyAt[];
string   g_tacticalLightSignatures[];
string   g_tacticalHeavySignatures[];

//+------------------------------------------------------------------+
//| Helpers                                                          |
//+------------------------------------------------------------------+
void AFS_Log(const string msg)
  {
   if(EnableJournalLogs)
      Print("[AFS] ", msg);

   if(g_state.PathState.Ready)
      AFS_OD_LogInfo(g_state.PathState, msg);
  }

void AFS_LogWarn(const string msg)
  {
   if(EnableJournalLogs)
      Print("[AFS][WARN] ", msg);

   if(g_state.PathState.Ready)
      AFS_OD_LogWarn(g_state.PathState, msg);
  }

void AFS_LogError(const string msg)
  {
   if(EnableJournalLogs)
      Print("[AFS][ERROR] ", msg);

   if(g_state.PathState.Ready)
      AFS_OD_LogError(g_state.PathState, msg);
  }

void AFS_Debug(const string msg)
  {
   if(!DebugVerbose)
      return;

   if(EnableJournalLogs)
      Print("[AFS][DEBUG] ", msg);

   if(g_state.PathState.Ready)
      AFS_OD_LogDebug(g_state.PathState, msg);
  }

void AFS_DebugSurface(const string msg)
  {
   if(!(DebugVerbose || DebugShowRotationState || DebugShowBatchState))
      return;

   datetime now = TimeCurrent();
   int cooldown = MathMax(5, TimerSeconds * 6);
   bool allow = (DebugVerbose || (g_lastDebugSurfaceAt <= 0 || (now - g_lastDebugSurfaceAt) >= cooldown));
   if(!allow)
      return;

   g_lastDebugSurfaceAt = now;

   if(EnableJournalLogs)
      Print("[AFS][SURFACE] ", msg);

   if(g_state.PathState.Ready)
      AFS_OD_LogDebug(g_state.PathState, "[SURFACE] " + msg);
  }


bool AFS_PublicationTraceEnabled()
  {
   return (DebugVerbose || DebugShowPublicationTrace);
  }

string AFS_BoolText(const bool value)
  {
   if(value)
      return "true";
   return "false";
  }

string AFS_JoinLinesForTrace(string &lines[],const int line_count)
  {
   string out = "";
   for(int i = 0; i < line_count; i++)
     {
      if(i > 0)
         out += "\r\n";
      out += lines[i];
     }
   return out;
  }

string AFS_HashTextFingerprint(const string text)
  {
   ulong hash = 1469598103934665603;
   int len = StringLen(text);
   for(int i = 0; i < len; i++)
     {
      ushort c = (ushort)StringGetCharacter(text, i);
      hash ^= (ulong)c;
      hash *= 1099511628211;
     }
   long signed_hash = (long)(hash & 0x7FFFFFFFFFFFFFFF);
   return IntegerToString((int)(signed_hash & 0x7FFFFFFF)) + "_" + IntegerToString((int)((signed_hash >> 31) & 0x7FFFFFFF));
  }

string AFS_HashLinesFingerprint(string &lines[],const int line_count)
  {
   return AFS_HashTextFingerprint(AFS_JoinLinesForTrace(lines, line_count));
  }

string AFS_TraderTickState(const AFS_UniverseSymbol &rec)
  {
   if(!rec.QuotePresent || rec.TickAgeSec < 0 || rec.QuoteState == "NO_QUOTE")
      return "DEAD";
   if(rec.TickAgeSec <= 5)
      return "FRESH";
   if(rec.TickAgeSec <= 30)
      return "AGING";
   if(rec.TickAgeSec <= MaxTickAge)
      return "STALE";
   return "DEAD";
  }

string AFS_TraderFreshnessBand(const AFS_UniverseSymbol &rec)
  {
   if(rec.FreshnessScore >= 80.0)
      return "HIGH";
   if(rec.FreshnessScore >= 55.0)
      return "MEDIUM";
   if(rec.FreshnessScore >= 30.0)
      return "LOW";
   return "STALE";
  }

string AFS_TraderSpreadBand(const AFS_UniverseSymbol &rec)
  {
   if(!rec.QuotePresent || rec.SpreadSnapshot <= 0.0)
      return "UNUSABLE";
   if(rec.SpreadAtrRatio <= 0.08)
      return "TIGHT";
   if(rec.SpreadAtrRatio <= 0.20)
      return "NORMAL";
   if(rec.SpreadAtrRatio <= 0.35)
      return "WIDE";
   return "UNUSABLE";
  }

string AFS_TraderExecutionBand(const AFS_UniverseSymbol &rec)
  {
   double q = (rec.LivelinessScore * 0.50) + (rec.FreshnessScore * 0.50);
   if(q >= 70.0)
      return "GOOD";
   if(q >= 45.0)
      return "DEGRADED";
   return "UNUSABLE";
  }

string AFS_TraderMovementBand(const AFS_UniverseSymbol &rec)
  {
   if(rec.MovementCapacityScore >= 70.0)
      return "HIGH";
   if(rec.MovementCapacityScore >= 40.0)
      return "NORMAL";
   return "LOW";
  }

int AFS_TraderDossierStateIndex(const string symbol)
  {
   for(int i = 0; i < ArraySize(g_traderDossierStateSymbols); i++)
     {
      if(g_traderDossierStateSymbols[i] == symbol)
         return i;
     }
   return -1;
  }

void AFS_TraderDossierStateSet(const string symbol,const string signature,const datetime write_at)
  {
   int idx = AFS_TraderDossierStateIndex(symbol);
   if(idx < 0)
     {
      idx = ArraySize(g_traderDossierStateSymbols);
      ArrayResize(g_traderDossierStateSymbols, idx + 1);
      ArrayResize(g_traderDossierStateSignatures, idx + 1);
      ArrayResize(g_traderDossierStateWriteAt, idx + 1);
      g_traderDossierStateSymbols[idx] = symbol;
     }
   g_traderDossierStateSignatures[idx] = signature;
   g_traderDossierStateWriteAt[idx] = write_at;
  }

int AFS_ActivePublicationFreshnessWindowSec()
  {
   int light = AFS_TacticalLightCadenceSec();
   if(light < 30)
      light = 30;
   if(light > 120)
      light = 120;
   return light;
  }

bool AFS_ActivePublicationWriteIsStale(const datetime last_write_at,const datetime now)
  {
   if(last_write_at <= 0 || now <= 0)
      return true;
   return ((now - last_write_at) >= AFS_ActivePublicationFreshnessWindowSec());
  }

void AFS_ActivePublicationFreshnessStats(const int &ordered[],
                                         const datetime now,
                                         int &stale_count,
                                         int &max_write_age_sec)
  {
   stale_count = 0;
   max_write_age_sec = 0;
   for(int i = 0; i < ArraySize(ordered); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[ordered[i]];
      int state_idx = AFS_TraderDossierStateIndex(rec.Symbol);
      datetime last_write_at = (state_idx >= 0 ? g_traderDossierStateWriteAt[state_idx] : 0);
      int age = 0;
      if(last_write_at > 0 && now > last_write_at)
         age = (int)(now - last_write_at);
      else
         age = AFS_ActivePublicationFreshnessWindowSec();
      if(age > max_write_age_sec)
         max_write_age_sec = age;
      if(AFS_ActivePublicationWriteIsStale(last_write_at, now))
         stale_count++;
     }
  }

string AFS_TraderDossierMaterialSignature(const AFS_UniverseSymbol &rec,const int rank_within_bucket)
  {
   string no_trade_flag = AFS_BoolText(rec.FrictionStatus == "FAIL");
   string no_trade_reason = AFS_FinalOutputReasonText(rec);
   string key = rec.Symbol +
                "|" + AFS_OutputSafeText(rec.CanonicalSymbol, rec.Symbol) +
                "|" + AFS_OutputSafeText(rec.AssetClass, "-") +
                "|" + AFS_OutputSafeText(rec.PrimaryBucket, "UNBUCKETED") +
                "|" + AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "-")) +
                "|" + AFS_OutputSafeText(rec.FrictionStatus, "-") +
                "|" + AFS_FinalOutputRoleText(rec) +
                "|R" + IntegerToString(rank_within_bucket) +
                "|NTF=" + no_trade_flag +
                "|NTR=" + no_trade_reason +
                "|CORR=" + AFS_OutputSafeText(rec.CorrClosestSymbol, "-") +
                "|CF=" + AFS_OutputSafeText(rec.CorrContextFlag, "CORR_PENDING") +
                "|MS=" + AFS_OutputSafeText(rec.PromotionState, "-") +
                "|SS=" + AFS_OutputSafeText(rec.HistoryStatus, "-") +
                "|SB=" + AFS_TraderSpreadBand(rec) +
                "|TB=" + AFS_TraderTickState(rec) +
                "|FB=" + AFS_TraderFreshnessBand(rec) +
                "|EB=" + AFS_TraderExecutionBand(rec) +
                "|MB=" + AFS_TraderMovementBand(rec);
   return AFS_HashTextFingerprint(key);
  }

int AFS_TraderMaxDossierWritesPerCycle()
  {
   return 3;
  }

int AFS_TacticalCacheIndex(const string symbol)
  {
   for(int i = 0; i < ArraySize(g_tacticalSymbols); i++)
     {
      if(g_tacticalSymbols[i] == symbol)
         return i;
     }
   return -1;
  }

void AFS_TacticalCacheSyncActiveSet(const int &ordered[],const datetime now)
  {
   string next_symbols[];
   bool next_active[];
   datetime next_last_light[];
   datetime next_last_heavy[];
   datetime next_next_light[];
   datetime next_next_heavy[];
   string next_light_sig[];
   string next_heavy_sig[];

   int n = ArraySize(ordered);
   ArrayResize(next_symbols, n);
   ArrayResize(next_active, n);
   ArrayResize(next_last_light, n);
   ArrayResize(next_last_heavy, n);
   ArrayResize(next_next_light, n);
   ArrayResize(next_next_heavy, n);
   ArrayResize(next_light_sig, n);
   ArrayResize(next_heavy_sig, n);

   for(int i = 0; i < n; i++)
     {
      int universe_idx = ordered[i];
      if(universe_idx < 0 || universe_idx >= ArraySize(g_state.Universe))
         continue;

      string symbol = g_state.Universe[universe_idx].Symbol;
      int old_idx = AFS_TacticalCacheIndex(symbol);

      next_symbols[i]      = symbol;
      next_active[i]       = true;
      next_last_light[i]   = (old_idx >= 0 ? g_tacticalLastLightAt[old_idx]     : 0);
      next_last_heavy[i]   = (old_idx >= 0 ? g_tacticalLastHeavyAt[old_idx]     : 0);
      next_next_light[i]   = (old_idx >= 0 ? g_tacticalNextLightAt[old_idx]     : now);
      next_next_heavy[i]   = (old_idx >= 0 ? g_tacticalNextHeavyAt[old_idx]     : now);
      next_light_sig[i]    = (old_idx >= 0 ? g_tacticalLightSignatures[old_idx] : "");
      next_heavy_sig[i]    = (old_idx >= 0 ? g_tacticalHeavySignatures[old_idx] : "");

      if(next_next_light[i] <= 0)
         next_next_light[i] = now;
      if(next_next_heavy[i] <= 0)
         next_next_heavy[i] = now;
     }

   ArrayResize(g_tacticalSymbols, n);
   ArrayResize(g_tacticalActive, n);
   ArrayResize(g_tacticalLastLightAt, n);
   ArrayResize(g_tacticalLastHeavyAt, n);
   ArrayResize(g_tacticalNextLightAt, n);
   ArrayResize(g_tacticalNextHeavyAt, n);
   ArrayResize(g_tacticalLightSignatures, n);
   ArrayResize(g_tacticalHeavySignatures, n);

   ArrayCopy(g_tacticalSymbols,         next_symbols,      0, 0, WHOLE_ARRAY);
   ArrayCopy(g_tacticalActive,          next_active,       0, 0, WHOLE_ARRAY);
   ArrayCopy(g_tacticalLastLightAt,     next_last_light,   0, 0, WHOLE_ARRAY);
   ArrayCopy(g_tacticalLastHeavyAt,     next_last_heavy,   0, 0, WHOLE_ARRAY);
   ArrayCopy(g_tacticalNextLightAt,     next_next_light,   0, 0, WHOLE_ARRAY);
   ArrayCopy(g_tacticalNextHeavyAt,     next_next_heavy,   0, 0, WHOLE_ARRAY);
   ArrayCopy(g_tacticalLightSignatures, next_light_sig,    0, 0, WHOLE_ARRAY);
   ArrayCopy(g_tacticalHeavySignatures, next_heavy_sig,    0, 0, WHOLE_ARRAY);
  }

string AFS_TraderDossierLightSignature(const AFS_UniverseSymbol &rec,const int rank_within_bucket)
  {
   return AFS_TraderDossierMaterialSignature(rec, rank_within_bucket);
  }

string AFS_TraderDossierHeavySignature(const AFS_UniverseSymbol &rec)
  {
   string key = rec.Symbol +
                "|H=" + AFS_OutputSafeText(rec.HistoryStatus, "-") +
                "|HF=" + AFS_OutputSafeText(rec.HistoryFlags, "-") +
                "|A15=" + AFS_FormatScore2(rec.AtrM15) +
                "|A60=" + AFS_FormatScore2(rec.AtrH1) +
                "|BM=" + AFS_FormatScore2(rec.BaselineMove) +
                "|MC=" + AFS_FormatScore2(rec.MovementCapacityScore) +
                "|EC=" + AFS_OutputSafeText(rec.EconomicsTrust, "UNSCANNED") +
                "|SI=" + AFS_OutputSafeText(rec.SpecIntegrityStatus, "UNSCANNED");
   return AFS_HashTextFingerprint(key);
  }

int AFS_TacticalLightCadenceSec()
  {
   return MathMax(1, TacticalLightCadenceSeconds);
  }

int AFS_TacticalHeavyCadenceSec()
  {
   return MathMax(10, TacticalHeavyCadenceSeconds);
  }

void AFS_TracePublication(const string stage,
                          const string target,
                          const string action,
                          const bool   ok,
                          const string detail="")
  {
   if(!AFS_PublicationTraceEnabled())
      return;

   string safe_target = target;
   if(StringLen(safe_target) == 0)
      safe_target = "-";

   string msg = "[PUB] " + stage +
                " | target=" + safe_target +
                " | action=" + action +
                " | ok=" + AFS_BoolText(ok);

   if(StringLen(detail) > 0)
      msg += " | " + detail;

   if(EnableJournalLogs)
      Print("[AFS][DEBUG] ", msg);

   if(g_state.PathState.Ready)
      AFS_OD_LogDebug(g_state.PathState, msg);
  }

void AFS_SetInfo(const string msg)
  {
   g_state.LastInfo = msg;
  }

void AFS_SetInfoAndLog(const string msg)
  {
   g_state.LastInfo = msg;
   AFS_Log(msg);
  }

void AFS_InitModuleState(AFS_ModuleState &module_ref,const string name,const AFS_ModuleStateCode state,const string detail)
  {
   module_ref.Name   = name;
   module_ref.State  = state;
   module_ref.Detail = detail;
  }

void AFS_InitMemoryShell()
  {
   g_state.MemoryShell.Ready                 = true;
   g_state.MemoryShell.CreatedAt             = TimeCurrent();
   g_state.MemoryShell.LastTouchedAt         = TimeCurrent();
   g_state.MemoryShell.LastSurfaceAt         = 0;
   g_state.MemoryShell.LastFullSurfaceAt     = 0;
   g_state.MemoryShell.LastSurfaceResetAt    = TimeCurrent();

   g_state.MemoryShell.BrokerSymbolCount     = 0;
   g_state.MemoryShell.LoadedUniverseCount   = 0;
   g_state.MemoryShell.EligibleSymbolCount   = 0;
   g_state.MemoryShell.UniverseCount         = 0;
   g_state.MemoryShell.ClassifiedSymbolCount = 0;
   g_state.MemoryShell.UnresolvedSymbolCount = 0;
   g_state.MemoryShell.SurfaceCount          = 0;
   g_state.MemoryShell.SurfaceLoadedCount    = 0;
   g_state.MemoryShell.DeepCount             = 0;
   g_state.MemoryShell.FinalistCount         = 0;

   g_state.MemoryShell.ExchangeCoverageCount       = 0;
   g_state.MemoryShell.ISINCoverageCount           = 0;
   g_state.MemoryShell.BrokerSectorCoverageCount   = 0;
   g_state.MemoryShell.BrokerIndustryCoverageCount = 0;
   g_state.MemoryShell.BrokerClassCoverageCount    = 0;

   g_state.MemoryShell.SurfaceCursor         = 0;
   g_state.MemoryShell.SurfaceLastBatchCount = 0;
   g_state.MemoryShell.SurfacePassCount      = 0;
   g_state.MemoryShell.SurfaceFreshCount     = 0;
   g_state.MemoryShell.SurfaceStaleCount     = 0;
   g_state.MemoryShell.SurfaceNoQuoteCount   = 0;
   g_state.MemoryShell.SurfacePromotedCount  = 0;
   g_state.MemoryShell.SurfaceFirstSeenCount = 0;

   g_state.MemoryShell.SpecCount             = 0;
   g_state.MemoryShell.SpecPassCount         = 0;
   g_state.MemoryShell.SpecWeakCount         = 0;
   g_state.MemoryShell.SpecFailCount         = 0;
   g_state.MemoryShell.SpecCursor            = 0;

   g_state.MemoryShell.HistoryCount          = 0;
   g_state.MemoryShell.HistoryPassCount      = 0;
   g_state.MemoryShell.HistoryWeakCount      = 0;
   g_state.MemoryShell.HistoryFailCount      = 0;
   g_state.MemoryShell.HistoryCursor         = 0;

   g_state.MemoryShell.FrictionCount         = 0;
   g_state.MemoryShell.FrictionPassCount     = 0;
   g_state.MemoryShell.FrictionWeakCount     = 0;
   g_state.MemoryShell.FrictionFailCount     = 0;
   g_state.MemoryShell.FrictionCursor        = 0;

   g_state.MemoryShell.LastSurfaceResetReason = "INIT_MEMORY_SHELL";

   g_specCursor     = 0;
   g_historyCursor  = 0;
   g_frictionCursor = 0;

   AFS_ResetUniverse();
  }
  string AFS_SafeServerName()
  {
   return AFS_OD_SanitizePathPart(AccountInfoString(ACCOUNT_SERVER));
  }

string AFS_ObjName(const string suffix)
  {
   return AFS_OBJ_PREFIX + suffix;
  }

bool AFS_ObjectSetIntegerIfChanged(const string name,const ENUM_OBJECT_PROPERTY_INTEGER prop,const long value)
  {
   if(ObjectGetInteger(0, name, prop) == value)
      return true;
   return ObjectSetInteger(0, name, prop, value);
  }

bool AFS_ObjectSetStringIfChanged(const string name,const ENUM_OBJECT_PROPERTY_STRING prop,const string value)
  {
   if(ObjectGetString(0, name, prop) == value)
      return true;
   return ObjectSetString(0, name, prop, value);
  }

bool AFS_IsTraderModeUnlocked()
  {
   if(!AllowTraderModeOnlyIfPhase1Complete)
      return true;
   if(Phase1Complete)
      return true;
   return (AFS_GetStepNumber() >= 11.0);
  }

int AFS_HudRefreshCooldownSeconds()
  {
   return MathMax(2, TimerSeconds);
  }

int AFS_SelectionCooldownSeconds()
  {
   return 1800;
  }

int AFS_CorrelationCooldownSeconds()
  {
   return 1800;
  }

int AFS_Step2SummaryCooldownSeconds()
  {
   return MathMax(5, TimerSeconds * 5);
  }

int AFS_FinalOutputHeartbeatSeconds()
  {
   return MathMax(15, TimerSeconds * 15);
  }

void AFS_ResetLateStageCadence()
  {
   g_lastSelectionRunAt       = 0;
   g_lastCorrelationRunAt     = 0;
   g_lastStep2SummaryWriteAt  = 0;
   g_lastFinalWriteAt         = 0;
   g_lastFinalOutputSignature = "";
   g_lastUniverseSummaryWriteAt = 0;
   g_lastTraderSummaryFingerprint = "";
   g_lastTraderSummaryWriteAt = 0;
   ArrayResize(g_traderDossierStateSymbols, 0);
   ArrayResize(g_traderDossierStateSignatures, 0);
   ArrayResize(g_traderDossierStateWriteAt, 0);
   g_traderDossierWriteCursor = 0;
   ArrayResize(g_tacticalSymbols, 0);
   ArrayResize(g_tacticalActive, 0);
   ArrayResize(g_tacticalLastLightAt, 0);
   ArrayResize(g_tacticalLastHeavyAt, 0);
   ArrayResize(g_tacticalNextLightAt, 0);
   ArrayResize(g_tacticalNextHeavyAt, 0);
   ArrayResize(g_tacticalLightSignatures, 0);
   ArrayResize(g_tacticalHeavySignatures, 0);
   g_state.TraderIntel.LastWriteAt = 0;
   g_state.TraderIntel.ForceRefresh = true;
  }

string AFS_ClipText(const string txt,const int max_chars)
  {
   if(max_chars <= 0)
      return "";
   if(StringLen(txt) <= max_chars)
      return txt;
   if(max_chars <= 3)
      return StringSubstr(txt,0,max_chars);

   return StringSubstr(txt,0,max_chars - 3) + "...";
  }

string AFS_ToUpperTrim(const string value)
  {
   string s = value;
   StringTrimLeft(s);
   StringTrimRight(s);
   StringToUpper(s);
   return s;
  }
  
bool AFS_IsAllOrEmpty(const string value)
  {
   string s = AFS_ToUpperTrim(value);
   return (StringLen(s) == 0 || s == "ALL");
  }

bool AFS_StringContainsNoCase(const string haystack,const string needle)
  {
   string h = haystack;
   string n = needle;

   StringToUpper(h);
   StringToUpper(n);

   return (StringFind(h, n) >= 0);
  }

bool AFS_MatchesWildcardSimple(const string value,const string filter)
  {
   string f = AFS_ToUpperTrim(filter);
   string v = value;
   StringToUpper(v);

   if(StringLen(f) == 0 || f == "ALL")
      return true;

   if(StringFind(f, "*") < 0)
      return (StringFind(v, f) >= 0);

   string parts[];
   int count = StringSplit(f, '*', parts);

   if(count <= 0)
      return true;

   int search_from = 0;

   for(int i = 0; i < count; i++)
     {
      string p = parts[i];
      if(StringLen(p) == 0)
         continue;

      int pos = StringFind(v, p, search_from);
      if(pos < 0)
         return false;

      search_from = pos + StringLen(p);
     }

   return true;
  }

bool AFS_ListContainsValue(const string csv_list,const string value)
  {
   string raw = csv_list;
   if(StringLen(raw) == 0)
      return false;

   string parts[];
   int count = StringSplit(raw, ',', parts);
   string target = AFS_ToUpperTrim(value);

   for(int i = 0; i < count; i++)
     {
      string p = AFS_ToUpperTrim(parts[i]);
      if(StringLen(p) == 0)
         continue;
      if(target == p)
         return true;
     }

   return false;
  }

string AFS_BoolCsv(const bool v)
  {
   return v ? "true" : "false";
  }

string AFS_DoubleCsv(const double v,const int digits=8)
  {
   return DoubleToString(v, digits);
  }

string AFS_LongCsv(const long v)
  {
   return IntegerToString((int)v);
  }

string AFS_OD_CsvEscape(const string value)
  {
   string s = value;
   StringReplace(s, "\"", "\"\"");
   return "\"" + s + "\"";
  }

bool AFS_OD_WriteCsvLines(const string file_name,
                          const bool use_common_files,
                          const string header,
                          string &lines[],
                          const int line_count,
                          string &err)
  {
   err = "";

   int flags = FILE_WRITE | FILE_TXT | FILE_ANSI;
   if(use_common_files)
      flags |= FILE_COMMON;

   int h = FileOpen(file_name, flags);
   if(h == INVALID_HANDLE)
     {
      err = "Failed to write CSV: " + file_name + " (error " + IntegerToString(GetLastError()) + ")";
      return false;
     }

   FileWriteString(h, header + "\r\n");

   for(int i = 0; i < line_count; i++)
      FileWriteString(h, lines[i] + "\r\n");

   FileClose(h);
   return true;
  }
  
string AFS_EnumTextClean(string value)
  {
   int pos = StringFind(value, "::");
   if(pos >= 0)
      value = StringSubstr(value, pos + 2);

   StringReplace(value, "SECTOR_", "");
   StringReplace(value, "INDUSTRY_", "");
   StringReplace(value, "_", " ");
   return value;
  }

string AFS_GetSectorText(const string symbol)
  {
   long raw = 0;
   if(!SymbolInfoInteger(symbol, SYMBOL_SECTOR, raw))
      return "";

   return AFS_EnumTextClean(EnumToString((ENUM_SYMBOL_SECTOR)raw));
  }

string AFS_GetIndustryText(const string symbol)
  {
   long raw = 0;
   if(!SymbolInfoInteger(symbol, SYMBOL_INDUSTRY, raw))
      return "";

   return AFS_EnumTextClean(EnumToString((ENUM_SYMBOL_INDUSTRY)raw));
  }

string AFS_GetBrokerClassText(const AFS_UniverseSymbol &rec)
  {
   string broker_class = rec.Sector;

   if(StringLen(rec.Industry) > 0)
     {
      if(StringLen(broker_class) > 0)
         broker_class += " / ";
      broker_class += rec.Industry;
     }

   if(StringLen(broker_class) == 0 && StringLen(rec.Path) > 0)
      broker_class = rec.Path;

   if(StringLen(broker_class) == 0)
      broker_class = "UNSPECIFIED";

   return broker_class;
  }

string AFS_SessionWindowsToText(const string symbol,const bool trade_sessions)
  {
   string out = "";

   for(int day = SUNDAY; day <= SATURDAY; day++)
     {
      for(uint idx = 0; idx < 10; idx++)
        {
         datetime from_time = 0;
         datetime to_time   = 0;
         bool ok = (trade_sessions
                    ? SymbolInfoSessionTrade(symbol, (ENUM_DAY_OF_WEEK)day, idx, from_time, to_time)
                    : SymbolInfoSessionQuote(symbol, (ENUM_DAY_OF_WEEK)day, idx, from_time, to_time));

         if(!ok)
            break;

         string piece = EnumToString((ENUM_DAY_OF_WEEK)day) + " " +
                        TimeToString(from_time, TIME_MINUTES) + "-" +
                        TimeToString(to_time, TIME_MINUTES);

         if(StringLen(out) > 0)
            out += " | ";
         out += piece;
        }
     }

   return out;
  }

bool AFS_IsUniverseSymbolTradable(const AFS_UniverseSymbol &rec)
  {
   if(!rec.Exists)
      return false;
   if(rec.Custom)
      return false;
   if(rec.TradeMode <= SYMBOL_TRADE_MODE_DISABLED)
      return false;
   return true;
  }

bool AFS_RecordMatchesScope(const AFS_UniverseSymbol &rec)
  {
   if(!AFS_IsAllOrEmpty(SymbolFilter))
     {
      if(!(AFS_MatchesWildcardSimple(rec.Symbol, SymbolFilter) ||
           AFS_MatchesWildcardSimple(rec.CanonicalSymbol, SymbolFilter) ||
           AFS_StringContainsNoCase(rec.DisplayName, SymbolFilter) ||
           AFS_StringContainsNoCase(rec.Description, SymbolFilter) ||
           AFS_StringContainsNoCase(rec.Path, SymbolFilter)))
         return false;
     }

   if(StringLen(CustomSymbolList) > 0 && !AFS_ListContainsValue(CustomSymbolList, rec.Symbol))
      return false;

   if(!AFS_IsAllOrEmpty(SectorFilter))
     {
      if(!(AFS_StringContainsNoCase(rec.Sector, SectorFilter) ||
           AFS_StringContainsNoCase(rec.Industry, SectorFilter) ||
           AFS_StringContainsNoCase(rec.ThemeBucket, SectorFilter) ||
           AFS_StringContainsNoCase(rec.BrokerClass, SectorFilter) ||
           AFS_StringContainsNoCase(rec.Path, SectorFilter)))
         return false;
     }

   if(!AFS_IsAllOrEmpty(AssetClassFilter))
     {
      if(!(AFS_StringContainsNoCase(rec.AssetClass, AssetClassFilter) ||
           AFS_StringContainsNoCase(rec.Path, AssetClassFilter) ||
           AFS_StringContainsNoCase(rec.Description, AssetClassFilter) ||
           AFS_StringContainsNoCase(rec.BrokerClass, AssetClassFilter)))
         return false;
     }

   if(!AFS_IsAllOrEmpty(PrimaryBucketFilter))
     {
      if(!(AFS_StringContainsNoCase(rec.PrimaryBucket, PrimaryBucketFilter) ||
           AFS_StringContainsNoCase(rec.Path, PrimaryBucketFilter) ||
           AFS_StringContainsNoCase(rec.Description, PrimaryBucketFilter)))
         return false;
     }

   return true;
  }

void AFS_RefreshScopeInclusion()
  {
   for(int i = 0; i < ArraySize(g_state.Universe); i++)
      g_state.Universe[i].ScopeIncluded = AFS_RecordMatchesScope(g_state.Universe[i]);
  }


bool AFS_IsMeaningfulBrokerText(const string value)
  {
   string s = value;
   StringTrimLeft(s);
   StringTrimRight(s);
   StringToUpper(s);

   return (StringLen(s) > 0 &&
           s != "UNDEFINED" &&
           s != "UNDEFINED / UNDEFINED" &&
           s != "N/A" &&
           s != "NONE");
  }

void AFS_RecalculateStep4Diagnostics()
  {
   g_state.MemoryShell.ExchangeCoverageCount       = 0;
   g_state.MemoryShell.ISINCoverageCount           = 0;
   g_state.MemoryShell.BrokerSectorCoverageCount   = 0;
   g_state.MemoryShell.BrokerIndustryCoverageCount = 0;
   g_state.MemoryShell.BrokerClassCoverageCount    = 0;

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      AFS_UniverseSymbol rec = g_state.Universe[i];

      if(AFS_IsMeaningfulBrokerText(rec.Exchange))
         g_state.MemoryShell.ExchangeCoverageCount++;

      if(AFS_IsMeaningfulBrokerText(rec.ISIN))
         g_state.MemoryShell.ISINCoverageCount++;

      if(AFS_IsMeaningfulBrokerText(rec.BrokerSector))
         g_state.MemoryShell.BrokerSectorCoverageCount++;

      if(AFS_IsMeaningfulBrokerText(rec.BrokerIndustry))
         g_state.MemoryShell.BrokerIndustryCoverageCount++;

      if(AFS_IsMeaningfulBrokerText(rec.BrokerClass))
         g_state.MemoryShell.BrokerClassCoverageCount++;
     }
  }


void AFS_CaptureUniverseSymbol(const string symbol,AFS_UniverseSymbol &rec)
  {
   ZeroMemory(rec);

   rec.Symbol         = symbol;
   rec.Path           = SymbolInfoString(symbol, SYMBOL_PATH);
   rec.Description    = SymbolInfoString(symbol, SYMBOL_DESCRIPTION);
   rec.ISIN           = SymbolInfoString(symbol, SYMBOL_ISIN);
   rec.Exchange       = SymbolInfoString(symbol, SYMBOL_EXCHANGE);
   rec.CurrencyBase   = SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
   rec.CurrencyProfit = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
   rec.CurrencyMargin = SymbolInfoString(symbol, SYMBOL_CURRENCY_MARGIN);

   rec.BrokerSector   = AFS_GetSectorText(symbol);
   rec.BrokerIndustry = AFS_GetIndustryText(symbol);
   rec.Sector         = rec.BrokerSector;
   rec.Industry       = rec.BrokerIndustry;
   rec.NormalizedSymbol = AFS_CL_NormalizeSymbol(symbol);
   rec.NormalizedAlias  = "";

   rec.Exists         = (bool)SymbolInfoInteger(symbol, SYMBOL_EXIST);
   rec.Selected       = (bool)SymbolInfoInteger(symbol, SYMBOL_SELECT);
   rec.Visible        = (bool)SymbolInfoInteger(symbol, SYMBOL_VISIBLE);
   rec.Custom         = (bool)SymbolInfoInteger(symbol, SYMBOL_CUSTOM);
   rec.SpreadFloat    = (bool)SymbolInfoInteger(symbol, SYMBOL_SPREAD_FLOAT);

   rec.Digits         = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
   rec.Spread         = (int)SymbolInfoInteger(symbol, SYMBOL_SPREAD);
   rec.StopsLevel     = (int)SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);
   rec.FreezeLevel    = (int)SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);
   rec.TradeMode      = (int)SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE);
   rec.CalcMode       = (int)SymbolInfoInteger(symbol, SYMBOL_TRADE_CALC_MODE);
   rec.ExecMode       = (int)SymbolInfoInteger(symbol, SYMBOL_TRADE_EXEMODE);
   rec.FillingMode    = (int)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);
   rec.ExpirationMode = (int)SymbolInfoInteger(symbol, SYMBOL_EXPIRATION_MODE);
   rec.OrderMode      = (int)SymbolInfoInteger(symbol, SYMBOL_ORDER_MODE);
   rec.SwapMode       = (int)SymbolInfoInteger(symbol, SYMBOL_SWAP_MODE);

   rec.Point          = SymbolInfoDouble(symbol, SYMBOL_POINT);
   rec.TickSize       = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
   rec.TickValue      = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
   rec.TickValueProfit= SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE_PROFIT);
   rec.TickValueLoss  = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE_LOSS);
   rec.ContractSize   = SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);
   rec.VolumeMin      = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
   rec.VolumeMax      = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
   rec.VolumeStep     = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
   rec.VolumeLimit    = SymbolInfoDouble(symbol, SYMBOL_VOLUME_LIMIT);
   rec.SwapLong       = SymbolInfoDouble(symbol, SYMBOL_SWAP_LONG);
   rec.SwapShort      = SymbolInfoDouble(symbol, SYMBOL_SWAP_SHORT);

   rec.MarginInitial     = 0.0;
   rec.MarginMaintenance = 0.0;
   rec.MarginLong        = 0.0;
   rec.MarginShort       = 0.0;
   SymbolInfoMarginRate(symbol, ORDER_TYPE_BUY,  rec.MarginInitial, rec.MarginMaintenance);
   SymbolInfoMarginRate(symbol, ORDER_TYPE_SELL, rec.MarginLong,    rec.MarginShort);

   rec.SessionQuotes   = AFS_SessionWindowsToText(symbol, false);
   rec.SessionTrades   = AFS_SessionWindowsToText(symbol, true);
   AFS_MC_ResetSurfaceState(rec);
   rec.BrokerClass     = AFS_GetBrokerClassText(rec);
   string class_detail = "";
   if(AFS_CL_ClassifySymbol(g_state.PathState.ServerKey, rec, class_detail))
     {
      g_state.MemoryShell.ClassifiedSymbolCount++;
     }
   else
     {
      g_state.MemoryShell.UnresolvedSymbolCount++;
      if(StringLen(rec.ClassificationNotes) == 0)
         rec.ClassificationNotes = class_detail;
     }

   rec.TradeAllowed    = AFS_IsUniverseSymbolTradable(rec);
   rec.ScopeIncluded   = AFS_RecordMatchesScope(rec);
  }

bool AFS_WriteUniverseBrokerView()
  {
   if(!ExportUniverseBrokerView || !g_state.PathState.Ready)
      return true;

   string exported_at = AFS_ExportedAtText();
   string source_text = AFS_UniverseSourceText();

   string lines[];
   int line_count = 0;

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      AFS_UniverseSymbol rec = g_state.Universe[i];

      ArrayResize(lines, line_count + 1);
      lines[line_count] =
         AFS_OD_CsvEscape(g_state.PathState.ServerKey) + "," +
         AFS_OD_CsvEscape(BuildLabel) + "," +
         AFS_OD_CsvEscape(CurrentPhaseTag) + "," +
         AFS_OD_CsvEscape(CurrentStepTag) + "," +
         AFS_OD_CsvEscape(exported_at) + "," +
         AFS_OD_CsvEscape(source_text) + "," +
         AFS_OD_CsvEscape(AFS_ModeToText(g_state.RequestedMode)) + "," +
         AFS_OD_CsvEscape(g_state.EffectiveModeText) + "," +
         AFS_OD_CsvEscape(AFS_RunStartedText()) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(g_state.MemoryShell.LastSurfaceResetAt)) + "," +
         AFS_OD_CsvEscape(g_state.MemoryShell.LastSurfaceResetReason) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(g_state.MemoryShell.LastFullSurfaceAt)) + "," +
         AFS_OD_CsvEscape(AFS_RotationModeToText(RotationMode)) + "," +
         AFS_OD_CsvEscape(AFS_SurfaceUpdatePolicyToText(SurfaceUpdatePolicy)) + "," +
         AFS_OD_CsvEscape(AFS_FormatSurfaceBatchState()) + "," +
         IntegerToString(g_state.MemoryShell.SurfacePassCount) + "," +
         IntegerToString(g_state.MemoryShell.SurfaceCursor) + "," +
         IntegerToString(g_state.MemoryShell.SurfaceLastBatchCount) + "," +
         IntegerToString(g_state.MemoryShell.SurfaceLoadedCount) + "," +
         IntegerToString(g_state.MemoryShell.LoadedUniverseCount) + "," +
         IntegerToString(g_state.MemoryShell.SurfaceCount) + "," +
         IntegerToString(g_state.MemoryShell.UniverseCount) + "," +
         AFS_OD_CsvEscape(rec.Symbol) + "," +
         AFS_OD_CsvEscape(rec.NormalizedSymbol) + "," +
         AFS_OD_CsvEscape(rec.NormalizedAlias) + "," +
         AFS_OD_CsvEscape(rec.CanonicalSymbol) + "," +
         AFS_OD_CsvEscape(rec.DisplayName) + "," +
         AFS_OD_CsvEscape(rec.AssetClass) + "," +
         AFS_OD_CsvEscape(rec.PrimaryBucket) + "," +
         AFS_OD_CsvEscape(rec.ThemeBucket) + "," +
         AFS_OD_CsvEscape(rec.SubType) + "," +
         AFS_OD_CsvEscape(rec.BrokerClass) + "," +
         AFS_OD_CsvEscape(rec.BrokerSector) + "," +
         AFS_OD_CsvEscape(rec.BrokerIndustry) + "," +
         AFS_OD_CsvEscape(rec.Sector) + "," +
         AFS_OD_CsvEscape(rec.Industry) + "," +
         AFS_OD_CsvEscape(rec.Path) + "," +
         AFS_OD_CsvEscape(rec.Description) + "," +
         AFS_BoolCsv(rec.SurfaceSeen) + "," +
         AFS_BoolCsv(rec.QuotePresent) + "," +
         AFS_BoolCsv(rec.PromotionCandidate) + "," +
         AFS_OD_CsvEscape(rec.PromotionState) + "," +
         AFS_OD_CsvEscape(rec.PromotionReason) + "," +
         AFS_OD_CsvEscape(rec.QuoteState) + "," +
         AFS_OD_CsvEscape(rec.SessionState) + "," +
         IntegerToString(rec.TickAgeSec) + "," +
         IntegerToString(rec.SurfaceUpdateCount) + "," +
         AFS_DoubleCsv(rec.Bid) + "," +
         AFS_DoubleCsv(rec.Ask) + "," +
         AFS_DoubleCsv(rec.SpreadSnapshot) + "," +
         AFS_DoubleCsv(rec.DailyChangePercent) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(rec.LastTickTime)) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(rec.LastSurfaceUpdateAt)) + "," +
         IntegerToString(rec.SpecUpdateCount) + "," +
         AFS_OD_CsvEscape(rec.SpecIntegrityStatus) + "," +
         AFS_OD_CsvEscape(rec.EconomicsTrust) + "," +
         AFS_DoubleCsv(rec.TickValueRaw) + "," +
         AFS_DoubleCsv(rec.TickValueDerived) + "," +
         AFS_DoubleCsv(rec.TickValueValidated) + "," +
         AFS_DoubleCsv(rec.MarginHedged) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(rec.LastSpecUpdateAt)) + "," +
         AFS_OD_CsvEscape(rec.EconomicsFlags) + "," +
         IntegerToString(rec.HistoryUpdateCount) + "," +
         AFS_OD_CsvEscape(rec.HistoryStatus) + "," +
         AFS_DoubleCsv(rec.AtrM15) + "," +
         AFS_DoubleCsv(rec.AtrH1) + "," +
         AFS_DoubleCsv(rec.BaselineMove) + "," +
         AFS_DoubleCsv(rec.MovementCapacityScore) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(rec.LastHistoryUpdateAt)) + "," +
         AFS_OD_CsvEscape(rec.HistoryFlags) + "," +
         IntegerToString(rec.FrictionUpdateCount) + "," +
         AFS_OD_CsvEscape(rec.FrictionStatus) + "," +
         AFS_DoubleCsv(rec.MedianSpread) + "," +
         AFS_DoubleCsv(rec.MaxSpread) + "," +
         AFS_DoubleCsv(rec.SpreadAtrRatio) + "," +
         AFS_DoubleCsv(rec.LivelinessScore) + "," +
         AFS_DoubleCsv(rec.FreshnessScore) + "," +
         IntegerToString(rec.FrictionSampleCountUsed) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(rec.LastFrictionUpdateAt)) + "," +
         AFS_OD_CsvEscape(rec.FrictionFlags) + "," +
         AFS_OD_CsvEscape(rec.SurfaceFlags);

      line_count++;
     }

   string err = "";
   string prior_export_text = "";
   bool had_prior_export = false;
g_state.UniverseBrokerViewFile = g_state.PathState.DevFolder + "\\universe_broker_view.csv";
   had_prior_export = AFS_ReadAllTextFile(g_state.UniverseBrokerViewFile, g_state.PathState.UseCommonFiles, prior_export_text);
   string next_export_text = AFS_JoinLinesForTrace(lines, line_count);
   bool export_changed = (!had_prior_export || prior_export_text != next_export_text);

   if(!AFS_OD_WriteCsvLines(
         g_state.UniverseBrokerViewFile,
         g_state.PathState.UseCommonFiles,
         "ServerKey,BuildLabel,PhaseTag,StepTag,ExportedAt,UniverseSource,RequestedMode,EffectiveMode,RunStartedAt,LastSurfaceResetAt,LastSurfaceResetReason,LastFullSurfaceAt,RotationMode,SurfaceUpdatePolicy,BatchRange,SurfacePassCount,SurfaceCursor,SurfaceLastBatchCount,SurfaceLoadedCount,LoadedUniverseCount,SurfaceScopeCount,ActiveScopeCount,Symbol,NormalizedSymbol,NormalizedAlias,CanonicalSymbol,DisplayName,AssetClass,PrimaryBucket,ThemeBucket,SubType,BrokerClass,BrokerSector,BrokerIndustry,AFSSector,AFSIndustry,Path,Description,SurfaceSeen,QuotePresent,PromotionCandidate,PromotionState,PromotionReason,QuoteState,SessionState,TickAgeSec,SurfaceUpdateCount,Bid,Ask,SpreadSnapshot,DailyChangePercent,LastTickTimeText,LastSurfaceUpdateAt,SpecUpdateCount,SpecIntegrityStatus,EconomicsTrust,TickValueRaw,TickValueDerived,TickValueValidated,MarginHedged,LastSpecUpdateAt,EconomicsFlags,HistoryUpdateCount,HistoryStatus,AtrM15,AtrH1,BaselineMove,MovementCapacityScore,LastHistoryUpdateAt,HistoryFlags,FrictionUpdateCount,FrictionStatus,MedianSpread,MaxSpread,SpreadAtrRatio,LivelinessScore,FreshnessScore,FrictionSampleCountUsed,LastFrictionUpdateAt,FrictionFlags,SurfaceFlags",
         lines,
         line_count,
         err))
     {
      AFS_TracePublication("UNIVERSE_BROKER_VIEW",
                           g_state.UniverseBrokerViewFile,
                           "write",
                           false,
                           "prior_exists=" + AFS_BoolText(had_prior_export) +
                           " | changed=" + AFS_BoolText(export_changed) +
                           " | detail=" + AFS_OutputSafeText(err, "-"));
      g_state.LastWarning = err;
      AFS_LogWarn(err);
      return false;
     }

   AFS_TracePublication("UNIVERSE_BROKER_VIEW",
                        g_state.UniverseBrokerViewFile,
                        "write",
                        true,
                        "prior_exists=" + AFS_BoolText(had_prior_export) +
                        " | changed=" + AFS_BoolText(export_changed) +
                        " | rows=" + IntegerToString(line_count));
   return true;
  }

bool AFS_WriteUniverseRawExport()
  {
   if(!ExportUniverseRawData || !g_state.PathState.Ready)
      return true;

   string exported_at = AFS_ExportedAtText();
   string source_text = AFS_UniverseSourceText();

   string lines[];
   int line_count = 0;

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      AFS_UniverseSymbol rec = g_state.Universe[i];

      ArrayResize(lines, line_count + 1);
      lines[line_count] =
         AFS_OD_CsvEscape(g_state.PathState.ServerKey) + "," +
         AFS_OD_CsvEscape(BuildLabel) + "," +
         AFS_OD_CsvEscape(CurrentPhaseTag) + "," +
         AFS_OD_CsvEscape(CurrentStepTag) + "," +
         AFS_OD_CsvEscape(exported_at) + "," +
         AFS_OD_CsvEscape(source_text) + "," +
         AFS_OD_CsvEscape(AFS_ModeToText(g_state.RequestedMode)) + "," +
         AFS_OD_CsvEscape(g_state.EffectiveModeText) + "," +
         AFS_OD_CsvEscape(AFS_RunStartedText()) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(g_state.MemoryShell.LastSurfaceResetAt)) + "," +
         AFS_OD_CsvEscape(g_state.MemoryShell.LastSurfaceResetReason) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(g_state.MemoryShell.LastFullSurfaceAt)) + "," +
         AFS_OD_CsvEscape(AFS_RotationModeToText(RotationMode)) + "," +
         AFS_OD_CsvEscape(AFS_SurfaceUpdatePolicyToText(SurfaceUpdatePolicy)) + "," +
         AFS_OD_CsvEscape(AFS_FormatSurfaceBatchState()) + "," +
         IntegerToString(g_state.MemoryShell.SurfacePassCount) + "," +
         IntegerToString(g_state.MemoryShell.SurfaceCursor) + "," +
         IntegerToString(g_state.MemoryShell.SurfaceLastBatchCount) + "," +
         IntegerToString(g_state.MemoryShell.SurfaceLoadedCount) + "," +
         IntegerToString(g_state.MemoryShell.LoadedUniverseCount) + "," +
         IntegerToString(g_state.MemoryShell.SurfaceCount) + "," +
         IntegerToString(g_state.MemoryShell.UniverseCount) + "," +
         AFS_OD_CsvEscape(rec.Symbol) + "," +
         AFS_OD_CsvEscape(rec.NormalizedSymbol) + "," +
         AFS_OD_CsvEscape(rec.NormalizedAlias) + "," +
         AFS_OD_CsvEscape(rec.CanonicalSymbol) + "," +
         AFS_OD_CsvEscape(rec.DisplayName) + "," +
         AFS_OD_CsvEscape(rec.AssetClass) + "," +
         AFS_OD_CsvEscape(rec.PrimaryBucket) + "," +
         AFS_OD_CsvEscape(rec.ThemeBucket) + "," +
         AFS_OD_CsvEscape(rec.SubType) + "," +
         AFS_OD_CsvEscape(rec.AliasKind) + "," +
         AFS_OD_CsvEscape(rec.ClassificationStatus) + "," +
         AFS_OD_CsvEscape(rec.ClassificationConfidence) + "," +
         AFS_OD_CsvEscape(rec.ClassificationReviewStatus) + "," +
         AFS_OD_CsvEscape(rec.ClassificationNotes) + "," +
         AFS_OD_CsvEscape(rec.Path) + "," +
         AFS_OD_CsvEscape(rec.Description) + "," +
         AFS_OD_CsvEscape(rec.ISIN) + "," +
         AFS_OD_CsvEscape(rec.Exchange) + "," +
         AFS_OD_CsvEscape(rec.BrokerSector) + "," +
         AFS_OD_CsvEscape(rec.BrokerIndustry) + "," +
         AFS_OD_CsvEscape(rec.Sector) + "," +
         AFS_OD_CsvEscape(rec.Industry) + "," +
         AFS_OD_CsvEscape(rec.BrokerClass) + "," +
         AFS_OD_CsvEscape(rec.CurrencyBase) + "," +
         AFS_OD_CsvEscape(rec.CurrencyProfit) + "," +
         AFS_OD_CsvEscape(rec.CurrencyMargin) + "," +
         IntegerToString(rec.Digits) + "," +
         IntegerToString(rec.Spread) + "," +
         IntegerToString(rec.StopsLevel) + "," +
         IntegerToString(rec.FreezeLevel) + "," +
         IntegerToString(rec.TradeMode) + "," +
         IntegerToString(rec.CalcMode) + "," +
         IntegerToString(rec.ExecMode) + "," +
         IntegerToString(rec.FillingMode) + "," +
         IntegerToString(rec.ExpirationMode) + "," +
         IntegerToString(rec.OrderMode) + "," +
         IntegerToString(rec.SwapMode) + "," +
         AFS_DoubleCsv(rec.Point) + "," +
         AFS_DoubleCsv(rec.TickSize) + "," +
         AFS_DoubleCsv(rec.TickValue) + "," +
         AFS_DoubleCsv(rec.TickValueProfit) + "," +
         AFS_DoubleCsv(rec.TickValueLoss) + "," +
         AFS_DoubleCsv(rec.ContractSize) + "," +
         AFS_DoubleCsv(rec.VolumeMin) + "," +
         AFS_DoubleCsv(rec.VolumeMax) + "," +
         AFS_DoubleCsv(rec.VolumeStep) + "," +
         AFS_DoubleCsv(rec.VolumeLimit) + "," +
         AFS_DoubleCsv(rec.SwapLong) + "," +
         AFS_DoubleCsv(rec.SwapShort) + "," +
         AFS_DoubleCsv(rec.MarginInitial) + "," +
         AFS_DoubleCsv(rec.MarginMaintenance) + "," +
         AFS_DoubleCsv(rec.MarginLong) + "," +
         AFS_DoubleCsv(rec.MarginShort) + "," +
         AFS_DoubleCsv(rec.TickValueRaw) + "," +
         AFS_DoubleCsv(rec.TickValueDerived) + "," +
         AFS_DoubleCsv(rec.TickValueValidated) + "," +
         AFS_DoubleCsv(rec.MarginHedged) + "," +
         AFS_DoubleCsv(rec.CommissionValue) + "," +
         AFS_OD_CsvEscape(rec.CommissionMode) + "," +
         AFS_OD_CsvEscape(rec.CommissionCurrency) + "," +
         AFS_OD_CsvEscape(rec.CommissionStatus) + "," +
         AFS_OD_CsvEscape(rec.SpecIntegrityStatus) + "," +
         AFS_OD_CsvEscape(rec.EconomicsTrust) + "," +
         AFS_OD_CsvEscape(rec.NormalizationStatus) + "," +
         AFS_OD_CsvEscape(rec.PracticalityStatus) + "," +
         AFS_OD_CsvEscape(rec.EconomicsFlags) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(rec.LastSpecUpdateAt)) + "," +
         IntegerToString(rec.SpecUpdateCount) + "," +
         AFS_BoolCsv(rec.Exists) + "," +
         AFS_BoolCsv(rec.Selected) + "," +
         AFS_BoolCsv(rec.Visible) + "," +
         AFS_BoolCsv(rec.Custom) + "," +
         AFS_BoolCsv(rec.SpreadFloat) + "," +
         AFS_BoolCsv(rec.TradeAllowed) + "," +
         AFS_BoolCsv(rec.ScopeIncluded) + "," +
         AFS_BoolCsv(rec.ClassificationResolved) + "," +
         AFS_BoolCsv(rec.SurfaceSeen) + "," +
         AFS_BoolCsv(rec.QuotePresent) + "," +
         AFS_BoolCsv(rec.PromotionCandidate) + "," +
         AFS_LongCsv((long)rec.LastTickTime) + "," +
         AFS_LongCsv((long)rec.LastSurfaceUpdateAt) + "," +
         IntegerToString(rec.TickAgeSec) + "," +
         IntegerToString(rec.SurfaceUpdateCount) + "," +
         AFS_DoubleCsv(rec.Bid) + "," +
         AFS_DoubleCsv(rec.Ask) + "," +
         AFS_DoubleCsv(rec.SpreadSnapshot) + "," +
         AFS_DoubleCsv(rec.SessionHigh) + "," +
         AFS_DoubleCsv(rec.SessionLow) + "," +
         AFS_DoubleCsv(rec.SessionOpen) + "," +
         AFS_DoubleCsv(rec.SessionClose) + "," +
         AFS_DoubleCsv(rec.BidHigh) + "," +
         AFS_DoubleCsv(rec.BidLow) + "," +
         AFS_DoubleCsv(rec.AskHigh) + "," +
         AFS_DoubleCsv(rec.AskLow) + "," +
         AFS_DoubleCsv(rec.DailyChangePercent) + "," +
         AFS_OD_CsvEscape(rec.QuoteState) + "," +
         AFS_OD_CsvEscape(rec.SessionState) + "," +
         AFS_OD_CsvEscape(rec.SurfaceFlags) + "," +
         AFS_OD_CsvEscape(rec.PromotionState) + "," +
         AFS_OD_CsvEscape(rec.PromotionReason) + "," +
         IntegerToString(rec.HistoryUpdateCount) + "," +
         IntegerToString(rec.BarsM15) + "," +
         IntegerToString(rec.BarsH1) + "," +
         AFS_DoubleCsv(rec.AtrM15) + "," +
         AFS_DoubleCsv(rec.AtrH1) + "," +
         AFS_DoubleCsv(rec.BaselineMove) + "," +
         AFS_DoubleCsv(rec.MovementCapacityScore) + "," +
         AFS_OD_CsvEscape(rec.HistoryStatus) + "," +
         AFS_OD_CsvEscape(rec.HistoryFlags) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(rec.LastHistoryUpdateAt)) + "," +
         IntegerToString(rec.FrictionUpdateCount) + "," +
         IntegerToString(rec.FrictionSampleCountUsed) + "," +
         AFS_DoubleCsv(rec.MedianSpread) + "," +
         AFS_DoubleCsv(rec.MaxSpread) + "," +
         AFS_DoubleCsv(rec.SpreadAtrRatio) + "," +
         AFS_DoubleCsv(rec.LivelinessScore) + "," +
         AFS_DoubleCsv(rec.FreshnessScore) + "," +
         AFS_OD_CsvEscape(rec.FrictionStatus) + "," +
         AFS_OD_CsvEscape(rec.FrictionFlags) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(rec.LastFrictionUpdateAt)) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(rec.LastTickTime)) + "," +
         AFS_OD_CsvEscape(AFS_FormatTime(rec.LastSurfaceUpdateAt)) + "," +
         AFS_OD_CsvEscape(rec.SessionQuotes) + "," +
         AFS_OD_CsvEscape(rec.SessionTrades) + "," +
         AFS_OD_CsvEscape(rec.FrictionTruthState) + "," +
         AFS_OD_CsvEscape(rec.FrictionFailReason) + "," +
         AFS_OD_CsvEscape(rec.FrictionWeakReason) + "," +
         AFS_OD_CsvEscape(rec.FrictionHydrationStage) + "," +
         AFS_BoolCsv(rec.FrictionHoldPass) + "," +
         AFS_BoolCsv(rec.FrictionMarketLive) + "," +
         AFS_BoolCsv(rec.FrictionSessionOpen) + "," +
         AFS_BoolCsv(rec.FrictionQuoteUsable) + "," +
         IntegerToString(rec.FrictionHydrationScore) + "," +
         IntegerToString(rec.FrictionGoodPasses) + "," +
         IntegerToString(rec.FrictionBadPasses) + "," +
         AFS_LongCsv((long)rec.LastTradableEvidenceAt) + "," +
         AFS_LongCsv((long)rec.LastAliveEvidenceAt) + "," +
         DoubleToString(rec.CostEfficiencyScore, 4) + "," +
         DoubleToString(rec.TrustScore, 4) + "," +
         DoubleToString(rec.TotalScore, 4) + "," +
         IntegerToString(rec.BucketRank) + "," +
         AFS_BoolCsv(rec.FinalistSelected) + "," +
         AFS_LongCsv((long)rec.LastRankingUpdateAt);

      line_count++;
     }

   string err = "";
   string prior_export_text = "";
   bool had_prior_export = false;
g_state.UniverseRawFile = g_state.PathState.DevFolder + "\\universe_raw_export.csv";
   had_prior_export = AFS_ReadAllTextFile(g_state.UniverseRawFile, g_state.PathState.UseCommonFiles, prior_export_text);
   string next_export_text = AFS_JoinLinesForTrace(lines, line_count);
   bool export_changed = (!had_prior_export || prior_export_text != next_export_text);

   if(!AFS_OD_WriteCsvLines(
         g_state.UniverseRawFile,
         g_state.PathState.UseCommonFiles,
         "ServerKey,BuildLabel,PhaseTag,StepTag,ExportedAt,UniverseSource,RequestedMode,EffectiveMode,RunStartedAt,LastSurfaceResetAt,LastSurfaceResetReason,LastFullSurfaceAt,RotationMode,SurfaceUpdatePolicy,BatchRange,SurfacePassCount,SurfaceCursor,SurfaceLastBatchCount,SurfaceLoadedCount,LoadedUniverseCount,SurfaceScopeCount,ActiveScopeCount,Symbol,NormalizedSymbol,NormalizedAlias,CanonicalSymbol,DisplayName,AssetClass,PrimaryBucket,ThemeBucket,SubType,AliasKind,ClassificationStatus,ClassificationConfidence,ClassificationReviewStatus,ClassificationNotes,Path,Description,ISIN,Exchange,BrokerSector,BrokerIndustry,AFSSector,AFSIndustry,BrokerClass,CurrencyBase,CurrencyProfit,CurrencyMargin,Digits,Spread,StopsLevel,FreezeLevel,TradeMode,CalcMode,ExecMode,FillingMode,ExpirationMode,OrderMode,SwapMode,Point,TickSize,TickValue,TickValueProfit,TickValueLoss,ContractSize,VolumeMin,VolumeMax,VolumeStep,VolumeLimit,SwapLong,SwapShort,MarginInitial,MarginMaintenance,MarginLong,MarginShort,TickValueRaw,TickValueDerived,TickValueValidated,MarginHedged,CommissionValue,CommissionMode,CommissionCurrency,CommissionStatus,SpecIntegrityStatus,EconomicsTrust,NormalizationStatus,PracticalityStatus,EconomicsFlags,LastSpecUpdateAt,SpecUpdateCount,Exists,Selected,Visible,Custom,SpreadFloat,TradeAllowed,ScopeIncluded,ClassificationResolved,SurfaceSeen,QuotePresent,PromotionCandidate,LastTickTime,LastSurfaceUpdateAt,TickAgeSec,SurfaceUpdateCount,Bid,Ask,SpreadSnapshot,SessionHigh,SessionLow,SessionOpen,SessionClose,BidHigh,BidLow,AskHigh,AskLow,DailyChangePercent,QuoteState,SessionState,SurfaceFlags,PromotionState,PromotionReason,HistoryUpdateCount,BarsM15,BarsH1,AtrM15,AtrH1,BaselineMove,MovementCapacityScore,HistoryStatus,HistoryFlags,LastHistoryUpdateAt,FrictionUpdateCount,FrictionSampleCountUsed,MedianSpread,MaxSpread,SpreadAtrRatio,LivelinessScore,FreshnessScore,FrictionStatus,FrictionFlags,LastFrictionUpdateAt,LastTickTimeText,LastSurfaceUpdateTimeText,SessionQuotes,SessionTrades,FrictionTruthState,FrictionFailReason,FrictionWeakReason,FrictionHydrationStage,FrictionHoldPass,FrictionMarketLive,FrictionSessionOpen,FrictionQuoteUsable,FrictionHydrationScore,FrictionGoodPasses,FrictionBadPasses,LastTradableEvidenceAt,LastAliveEvidenceAt,CostEfficiencyScore,TrustScore,TotalScore,BucketRank,FinalistSelected,LastRankingUpdateAt",
         lines,
         line_count,
         err))
     {
      AFS_TracePublication("UNIVERSE_RAW_EXPORT",
                           g_state.UniverseRawFile,
                           "write",
                           false,
                           "prior_exists=" + AFS_BoolText(had_prior_export) +
                           " | changed=" + AFS_BoolText(export_changed) +
                           " | detail=" + AFS_OutputSafeText(err, "-"));
      g_state.LastWarning = err;
      AFS_LogWarn(err);
      return false;
     }

   AFS_TracePublication("UNIVERSE_RAW_EXPORT",
                        g_state.UniverseRawFile,
                        "write",
                        true,
                        "prior_exists=" + AFS_BoolText(had_prior_export) +
                        " | changed=" + AFS_BoolText(export_changed) +
                        " | rows=" + IntegerToString(line_count));
   return true;
  }

bool AFS_WriteClassificationReviewExport()
  {
   if(!g_state.PathState.Ready)
      return true;

   string lines[];
   int line_count = 0;

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      AFS_UniverseSymbol rec = g_state.Universe[i];
      if(rec.ClassificationResolved)
         continue;

      ArrayResize(lines, line_count + 1);
      lines[line_count] =
         AFS_OD_CsvEscape(g_state.PathState.ServerKey) + "," +
         AFS_OD_CsvEscape(BuildLabel) + "," +
         AFS_OD_CsvEscape(CurrentPhaseTag) + "," +
         AFS_OD_CsvEscape(CurrentStepTag) + "," +
         AFS_OD_CsvEscape(AFS_ExportedAtText()) + "," +
         AFS_OD_CsvEscape(rec.Symbol) + "," +
         AFS_OD_CsvEscape(rec.NormalizedSymbol) + "," +
         AFS_OD_CsvEscape(rec.NormalizedAlias) + "," +
         AFS_OD_CsvEscape(rec.CanonicalSymbol) + "," +
         AFS_OD_CsvEscape(rec.DisplayName) + "," +
         AFS_OD_CsvEscape(rec.AliasKind) + "," +
         AFS_OD_CsvEscape(rec.BrokerSector) + "," +
         AFS_OD_CsvEscape(rec.BrokerIndustry) + "," +
         AFS_OD_CsvEscape(rec.Description) + "," +
         AFS_OD_CsvEscape(rec.Path) + "," +
         AFS_OD_CsvEscape(rec.AssetClass) + "," +
         AFS_OD_CsvEscape(rec.PrimaryBucket) + "," +
         AFS_OD_CsvEscape(rec.ClassificationStatus) + "," +
         AFS_OD_CsvEscape(rec.ClassificationConfidence) + "," +
         AFS_OD_CsvEscape(rec.ClassificationReviewStatus) + "," +
         AFS_OD_CsvEscape(rec.ClassificationNotes);
      line_count++;
     }

   string err = "";
   string prior_export_text = "";
   bool had_prior_export = false;
   g_state.ClassificationReviewFile = g_state.PathState.DevFolder + "\\classification_review.csv";
   had_prior_export = AFS_ReadAllTextFile(g_state.ClassificationReviewFile, g_state.PathState.UseCommonFiles, prior_export_text);
   string next_export_text = AFS_JoinLinesForTrace(lines, line_count);
   bool export_changed = (!had_prior_export || prior_export_text != next_export_text);

   if(!AFS_OD_WriteCsvLines(g_state.ClassificationReviewFile,
                            g_state.PathState.UseCommonFiles,
                            "ServerKey,BuildLabel,PhaseTag,StepTag,ExportedAt,Symbol,NormalizedSymbol,NormalizedAlias,CanonicalSymbol,DisplayName,AliasKind,BrokerSector,BrokerIndustry,Description,Path,AssetClass,PrimaryBucket,ClassificationStatus,ClassificationConfidence,ClassificationReviewStatus,ClassificationNotes",
                            lines,
                            line_count,
                            err))
     {
      AFS_TracePublication("CLASSIFICATION_REVIEW",
                           g_state.ClassificationReviewFile,
                           "write",
                           false,
                           "prior_exists=" + AFS_BoolText(had_prior_export) +
                           " | changed=" + AFS_BoolText(export_changed) +
                           " | detail=" + AFS_OutputSafeText(err, "-"));
      g_state.LastWarning = err;
      AFS_LogWarn(err);
      return false;
     }

   AFS_TracePublication("CLASSIFICATION_REVIEW",
                        g_state.ClassificationReviewFile,
                        "write",
                        true,
                        "prior_exists=" + AFS_BoolText(had_prior_export) +
                        " | changed=" + AFS_BoolText(export_changed) +
                        " | rows=" + IntegerToString(line_count));
   return true;
  }

bool AFS_RunStep3UniverseLoader()
  {
   AFS_UniverseSymbol previous_universe[];
   AFS_CopyUniverseArray(previous_universe, g_state.Universe);

   datetime previous_surface_at      = g_state.MemoryShell.LastSurfaceAt;
   datetime previous_full_surface_at = g_state.MemoryShell.LastFullSurfaceAt;
   int previous_surface_passes       = g_state.MemoryShell.SurfacePassCount;

   AFS_ResetUniverse();
   g_surfaceArtifactsDirty = true;
   g_state.MemoryShell.LastSurfaceResetAt = TimeCurrent();
   g_state.MemoryShell.LastSurfaceResetReason = "UNIVERSE_RELOAD";

   int total = SymbolsTotal(UniverseUseMarketWatchOnly);
   g_state.MemoryShell.BrokerSymbolCount = total;

   if(total <= 0)
     {
      g_state.MarketCore.State  = MODULE_WARN;
      g_state.MarketCore.Detail = "No terminal symbols found";
      g_state.LastWarning       = "Step 3 found no symbols in terminal universe.";
      AFS_LogWarn(g_state.LastWarning);
      return false;
     }

   AFS_Log("Universe loader starting. Source=" + AFS_UniverseSourceText() +
           ", SymbolsDetected=" + IntegerToString(total));

   for(int i = 0; i < total; i++)
     {
      string symbol = SymbolName(i, UniverseUseMarketWatchOnly);
      if(StringLen(symbol) == 0)
         continue;

      AFS_UniverseSymbol rec;
      AFS_CaptureUniverseSymbol(symbol, rec);

      int prev_idx = AFS_FindUniverseRecordIndex(previous_universe, symbol);
      if(prev_idx >= 0)
         AFS_CopyCarryForwardRuntime(rec, previous_universe[prev_idx]);

      if(rec.TradeAllowed)
         g_state.MemoryShell.EligibleSymbolCount++;

      ArrayResize(g_state.Universe, ArraySize(g_state.Universe) + 1);
      g_state.Universe[ArraySize(g_state.Universe) - 1] = rec;
     }

   g_state.MemoryShell.LoadedUniverseCount = ArraySize(g_state.Universe);
   AFS_RefreshScopeInclusion();

   int active_count = 0;
   if(ScanSelectedScopeOnly)
     {
      for(int i = 0; i < ArraySize(g_state.Universe); i++)
         if(g_state.Universe[i].TradeAllowed && g_state.Universe[i].ScopeIncluded)
            active_count++;
     }
   else
     {
      for(int i = 0; i < ArraySize(g_state.Universe); i++)
         if(g_state.Universe[i].TradeAllowed)
            active_count++;
     }

   g_state.MemoryShell.UniverseCount = active_count;
   g_state.MemoryShell.LastSurfaceAt = previous_surface_at;
   g_state.MemoryShell.LastFullSurfaceAt = previous_full_surface_at;
   g_state.MemoryShell.SurfacePassCount = previous_surface_passes;
   AFS_RecalculateSurfaceDiagnostics();
   AFS_RecalculateSpecDiagnostics();
   AFS_RecalculateHistoryDiagnostics();
   AFS_RecalculateFrictionDiagnostics();
   AFS_RecalculateStep4Diagnostics();

   if(!AFS_WriteUniverseBrokerView())
      return false;

   if(!AFS_WriteUniverseRawExport())
      return false;

   if(!AFS_WriteClassificationReviewExport())
      return false;

   g_surfaceArtifactsDirty = false;

   int excluded_count = g_state.MemoryShell.BrokerSymbolCount - g_state.MemoryShell.EligibleSymbolCount;

   g_state.MarketCore.State  = MODULE_OK;
   g_state.MarketCore.Detail = "Universe loaded";

   AFS_Log("Universe loaded. Eligible=" + IntegerToString(g_state.MemoryShell.EligibleSymbolCount) +
           ", Excluded=" + IntegerToString(excluded_count) +
           ", ActiveScope=" + IntegerToString(g_state.MemoryShell.UniverseCount) +
           ", Classified=" + IntegerToString(g_state.MemoryShell.ClassifiedSymbolCount) +
           ", Unresolved=" + IntegerToString(g_state.MemoryShell.UnresolvedSymbolCount) +
           ", ExchangeCoverage=" + IntegerToString(g_state.MemoryShell.ExchangeCoverageCount) +
           ", ISINCoverage=" + IntegerToString(g_state.MemoryShell.ISINCoverageCount) +
           ", BrokerSectorCoverage=" + IntegerToString(g_state.MemoryShell.BrokerSectorCoverageCount) +
           ", BrokerIndustryCoverage=" + IntegerToString(g_state.MemoryShell.BrokerIndustryCoverageCount));

   if(StringLen(g_state.UniverseBrokerViewFile) > 0)
      AFS_Log("Universe broker view exported: " + g_state.UniverseBrokerViewFile);
   if(StringLen(g_state.UniverseRawFile) > 0)
      AFS_Log("Universe raw export written: " + g_state.UniverseRawFile);

   return true;
  }



string AFS_TraderDossierFileName(const AFS_UniverseSymbol &rec)
  {
   string leaf = AFS_OD_SanitizePathPart(rec.Symbol);
   if(StringLen(leaf) == 0)
      leaf = "UNKNOWN_SYMBOL";
   return leaf + AFS_CANONICAL_DOSSIER_FILE_EXTENSION;
  }

string AFS_TraderDossierFilePath(const AFS_UniverseSymbol &rec)
  {
   return g_state.PathState.TraderFolder + "\\" + AFS_TraderDossierFileName(rec);
  }

bool AFS_TraderOutputNeedsCarryForward(const AFS_UniverseSymbol &rec)
  {
   bool quote_hollow = (!rec.QuotePresent || rec.QuoteState == "NO_QUOTE" || rec.TickAgeSec < 0);
   bool spread_hollow = (rec.SpreadSnapshot <= 0.0 || rec.MedianSpread <= 0.0 || rec.MaxSpread <= 0.0);
   bool history_hollow = (rec.HistoryUpdateCount <= 0 || rec.BarsM15 <= 0 || rec.BarsH1 <= 0 || rec.AtrM15 <= 0.0 || rec.AtrH1 <= 0.0 || rec.BaselineMove <= 0.0);
   bool friction_hollow = (rec.FrictionUpdateCount <= 0 || rec.FrictionSampleCountUsed <= 0);
   return ((history_hollow && (quote_hollow || friction_hollow)) || (quote_hollow && spread_hollow));
  }


string AFS_GetTraderPublicationSelectionPolicy()
  {
   // Mirrors live Step 9 finalist selection without changing it here.
   // Publication lifecycle must stay downstream-only of finalist truth.
   return "STEP9_SECTOR_RANK_TRUTH__OPTION_B_PASS_FIRST_FILL_WITH_WEAK_TO_5";
  }

string AFS_GetTraderPublicationInactivePolicy()
  {
   // Inactive trader dossiers are currently retained snapshots because the
   // live EA does not delete or rewrite non-active dossier files.
   return "RETAIN_ON_DISK_UNCHANGED";
  }

string AFS_GetTraderPublicationReentryPolicy()
  {
   // Stable symbol file naming makes re-entry resume the same dossier path.
   return "REUSE_STABLE_SYMBOL_DOSSIER_FILE";
  }

string AFS_GetTraderPublicationScope()
  {
   return "ACTIVE_TOP5_PER_SECTOR_FROM_EXISTING_RANK_TRUTH";
  }

int AFS_TraderPublicationBucketLimit()
  {
   return 5;
  }

int AFS_FindTextIndex(const string &arr[],const string value)
  {
   for(int i = 0; i < ArraySize(arr); i++)
     {
      if(arr[i] == value)
         return i;
     }
   return -1;
  }

bool AFS_TraderPublicationEligible(const AFS_UniverseSymbol &rec,string &reason)
  {
   reason = "";

   if(rec.QuoteState == "NO_QUOTE")
     {
      reason = "QuoteState=NO_QUOTE";
      return false;
     }

   if(rec.FrictionTruthState == "NO_QUOTE")
     {
      reason = "FrictionTruthState=NO_QUOTE";
      return false;
     }

   string no_trade_reason = AFS_FinalOutputReasonText(rec);
   if(no_trade_reason == "DEAD_FEED")
     {
      reason = "NoTradeReason=DEAD_FEED";
      return false;
     }

   // Final tradability status is surfaced downstream via FrictionStatus /
   // FinalTradabilityStatus and must not be rewritten here.
   if(rec.FrictionStatus == "FAIL")
     {
      reason = "FinalTradabilityStatus=FAIL";
      return false;
     }

   if(rec.Bid <= 0.0)
     {
      reason = "Bid<=0";
      return false;
     }

   if(rec.Ask <= 0.0)
     {
      reason = "Ask<=0";
      return false;
     }

   if(!rec.QuotePresent)
     {
      reason = "QuotePresent=false";
      return false;
     }

   return true;
  }

bool AFS_SanitizeTraderPublishedIndexes(int &ordered[],string &detail)
  {
   detail = "";

   int total = ArraySize(g_state.Universe);
   if(total <= 0)
     {
      ArrayResize(ordered, 0);
      detail = "empty_universe";
      return false;
     }

   bool seen[];
   ArrayResize(seen, total);
   for(int i = 0; i < total; i++)
      seen[i] = false;

   string buckets[];
   int bucket_counts[];
   ArrayResize(buckets, 0);
   ArrayResize(bucket_counts, 0);

   int write_pos = 0;
   int dropped_invalid = 0;
   int dropped_duplicate = 0;
   int dropped_not_finalist = 0;
   int dropped_publication_ineligible = 0;
   int dropped_bucket_overflow = 0;
   string dropped_publication_detail = "";

   for(int i = 0; i < ArraySize(ordered); i++)
     {
      int idx = ordered[i];
      if(idx < 0 || idx >= total)
        {
         dropped_invalid++;
         continue;
        }

      if(seen[idx])
        {
         dropped_duplicate++;
         continue;
        }

      const AFS_UniverseSymbol rec = g_state.Universe[idx];
      if(!rec.FinalistSelected)
        {
         dropped_not_finalist++;
         continue;
        }

      string publication_block_reason = "";
      if(!AFS_TraderPublicationEligible(rec, publication_block_reason))
        {
         dropped_publication_ineligible++;
         if(StringLen(dropped_publication_detail) == 0)
            dropped_publication_detail = rec.Symbol + ":" + publication_block_reason;
         continue;
        }

      string bucket = AFS_OutputSafeText(rec.PrimaryBucket, "UNBUCKETED");
      int bucket_pos = AFS_FindTextIndex(buckets, bucket);
      if(bucket_pos < 0)
        {
         int n = ArraySize(buckets);
         ArrayResize(buckets, n + 1);
         ArrayResize(bucket_counts, n + 1);
         buckets[n] = bucket;
         bucket_counts[n] = 0;
         bucket_pos = n;
        }

      if(bucket_counts[bucket_pos] >= AFS_TraderPublicationBucketLimit())
        {
         dropped_bucket_overflow++;
         continue;
        }

      seen[idx] = true;
      bucket_counts[bucket_pos]++;
      ordered[write_pos] = idx;
      write_pos++;
     }

   if(write_pos != ArraySize(ordered))
      ArrayResize(ordered, write_pos);

   detail = "invalid=" + IntegerToString(dropped_invalid) +
            "|duplicate=" + IntegerToString(dropped_duplicate) +
            "|not_finalist=" + IntegerToString(dropped_not_finalist) +
            "|publication_ineligible=" + IntegerToString(dropped_publication_ineligible) +
            "|bucket_overflow=" + IntegerToString(dropped_bucket_overflow);
   if(StringLen(dropped_publication_detail) > 0)
      detail += "|publication_block_example=" + dropped_publication_detail;

   return (dropped_invalid > 0 ||
           dropped_duplicate > 0 ||
           dropped_not_finalist > 0 ||
           dropped_publication_ineligible > 0 ||
           dropped_bucket_overflow > 0);
  }

int AFS_TraderTopNextSymbolLimit()
  {
   return 12;
  }

string AFS_TraderSummaryHealthText(const int active_count,const int selected_count)
  {
   if(!g_state.PathState.Ready)
      return "ROUTE_NOT_READY";
   if(active_count <= 0 && selected_count > 0)
      return "ACTIVE_PUBLICATION_EMPTY";
   if(active_count <= 0)
      return "NO_ACTIVE_DOSSIERS";
   return "ACTIVE_SUMMARY_READY";
  }

bool AFS_TraderIsSupportTextFile(const string file_name)
  {
   if(file_name == AFS_CANONICAL_TRADER_SUMMARY_FILE_NAME)
      return true;
   if(file_name == "UNIVERSE_SUMMARY.txt")
      return true;
   return false;
  }

int AFS_TraderRetainedInactiveDossierCount(const int &ordered[])
  {
   if(!g_state.PathState.Ready)
      return -1;

   string match = g_state.PathState.TraderFolder + "\\*" + AFS_CANONICAL_DOSSIER_FILE_EXTENSION;
   string file_name = "";
   int common_flag = (g_state.PathState.UseCommonFiles ? FILE_COMMON : 0);

   ResetLastError();
   long h = FileFindFirst(match, file_name, common_flag);
   if(h == INVALID_HANDLE)
      return -1;

   int total_dossiers = 0;
   bool done = false;
   while(!done)
     {
      if(StringLen(file_name) > 0 && !AFS_TraderIsSupportTextFile(file_name))
         total_dossiers++;

      ResetLastError();
      if(!FileFindNext(h, file_name))
         done = true;
     }

   FileFindClose(h);

   int inactive = total_dossiers - ArraySize(ordered);
   if(inactive < 0)
      inactive = 0;
   return inactive;
  }

int AFS_TraderActiveRankWithinSector(const int &ordered[],const int ordered_pos)
  {
   if(ordered_pos < 0 || ordered_pos >= ArraySize(ordered))
      return 0;

   string sector = AFS_OutputSafeText(g_state.Universe[ordered[ordered_pos]].Sector,
                                      AFS_OutputSafeText(g_state.Universe[ordered[ordered_pos]].BrokerSector, "UNSECTORED"));
   int rank = 0;
   for(int i = 0; i <= ordered_pos && i < ArraySize(ordered); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[ordered[i]];
      if(AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "UNSECTORED")) != sector)
         continue;
      rank++;
     }
   return rank;
  }

int AFS_TraderActiveRankWithinBucket(const int &ordered[],const int ordered_pos)
  {
   if(ordered_pos < 0 || ordered_pos >= ArraySize(ordered))
      return 0;

   int base_idx = ordered[ordered_pos];
   if(base_idx < 0 || base_idx >= ArraySize(g_state.Universe))
      return 0;

   string bucket = AFS_OutputSafeText(g_state.Universe[base_idx].PrimaryBucket, "UNBUCKETED");
   int rank = 0;

   for(int i = 0; i <= ordered_pos && i < ArraySize(ordered); i++)
     {
      int idx = ordered[i];
      if(idx < 0 || idx >= ArraySize(g_state.Universe))
         continue;

      const AFS_UniverseSymbol rec = g_state.Universe[idx];
      if(AFS_OutputSafeText(rec.PrimaryBucket, "UNBUCKETED") != bucket)
         continue;

      rank++;
     }

   return rank;
  }
  
bool AFS_TraderPublicationRankBetter(const AFS_UniverseSymbol &a,const AFS_UniverseSymbol &b)
  {
   if(a.BucketRank > 0 && b.BucketRank > 0)
     {
      if(a.BucketRank < b.BucketRank)
         return true;
      if(a.BucketRank > b.BucketRank)
         return false;
     }

   if(a.TotalScore > b.TotalScore)
      return true;
   if(a.TotalScore < b.TotalScore)
      return false;

   return (StringCompare(a.Symbol, b.Symbol) < 0);
  }

double AFS_TraderExecutionQualityScore(const AFS_UniverseSymbol &rec)
  {
   // Downstream-only quality proxy for summary routing readability.
   // Truth-integrity guard: zero samples or unusable quotes must not score strong/high.
   if(!rec.QuotePresent || rec.Bid <= 0.0 || rec.Ask <= 0.0 || rec.Ask < rec.Bid)
      return 0.0;
   if(!rec.FrictionQuoteUsable)
      return 0.0;
   if(rec.FrictionSampleCountUsed <= 0)
      return 0.0;
   if(rec.FrictionStatus == "FAIL")
      return 0.0;

   double live = rec.LivelinessScore;
   if(live < 0.0)
      live = 0.0;
   if(live > 100.0)
      live = 100.0;

   double fresh = rec.FreshnessScore;
   if(fresh < 0.0)
      fresh = 0.0;
   if(fresh > 100.0)
      fresh = 100.0;

   double spread_penalty = 100.0;
   if(rec.SpreadAtrRatio > 0.0)
      spread_penalty = MathMin(100.0, rec.SpreadAtrRatio * 100.0);

   double score = (live * 0.40) + (fresh * 0.40) + ((100.0 - spread_penalty) * 0.20);
   if(score < 0.0)
      score = 0.0;
   if(score > 100.0)
      score = 100.0;
   return score;
  }

double AFS_TraderReferencePrice(const AFS_UniverseSymbol &rec)
  {
   if(rec.Bid > 0.0 && rec.Ask > 0.0)
      return (rec.Bid + rec.Ask) * 0.5;
   if(rec.SessionClose > 0.0)
      return rec.SessionClose;
   if(rec.SessionOpen > 0.0)
      return rec.SessionOpen;
   return 0.0;
  }

double AFS_TraderDistancePoints(const double from_price,const double to_price,const double point_size)
  {
   if(from_price <= 0.0 || to_price <= 0.0 || point_size <= 0.0)
      return 0.0;
   return MathAbs(to_price - from_price) / point_size;
  }

string AFS_TraderMarketStateContext(const double session_range,const double atr_ref)
  {
   if(session_range <= 0.0 || atr_ref <= 0.0)
      return "PENDING_RANGE_CONTEXT";

   double ratio = session_range / atr_ref;
   if(ratio <= 0.60)
      return "COMPRESSION";
   if(ratio >= 1.60)
      return "EXPANSION";
   return "BALANCED_CHOP";
  }

bool AFS_TraderFileNameInSet(const string &names[],const string target)
  {
   for(int i = 0; i < ArraySize(names); i++)
     {
      if(names[i] == target)
         return true;
     }
   return false;
  }

void AFS_TraderCollectActiveDossierFileNames(const int &ordered[],string &active_files[])
  {
   ArrayResize(active_files, 0);
   for(int i = 0; i < ArraySize(ordered); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[ordered[i]];
      int n = ArraySize(active_files);
      ArrayResize(active_files, n + 1);
      active_files[n] = AFS_TraderDossierFileName(rec);
     }
  }

void AFS_TraderMarkInactiveLifecycleSnapshots(const int &ordered[],const datetime now)
  {
   if(!g_state.PathState.Ready)
      return;

   string active_files[];
   AFS_TraderCollectActiveDossierFileNames(ordered, active_files);

   string match = g_state.PathState.TraderFolder + "\\*" + AFS_CANONICAL_DOSSIER_FILE_EXTENSION;
   string file_name = "";
   int common_flag = (g_state.PathState.UseCommonFiles ? FILE_COMMON : 0);

   ResetLastError();
   long h = FileFindFirst(match, file_name, common_flag);
   if(h == INVALID_HANDLE)
      return;

   bool done = false;
   string lifecycle_now = AFS_FormatTime(now);

   while(!done)
     {
      if(StringLen(file_name) > 0 && !AFS_TraderIsSupportTextFile(file_name) && !AFS_TraderFileNameInSet(active_files, file_name))
        {
         string file_path = g_state.PathState.TraderFolder + "\\" + file_name;
         string prior_text = "";
         if(AFS_ReadAllTextFile(file_path, g_state.PathState.UseCommonFiles, prior_text) && StringLen(prior_text) > 0)
           {
            string prior_lines[];
            StringReplace(prior_text, "\r", "");
            ushort nl = 10;
            int line_count = StringSplit(prior_text, nl, prior_lines);
            if(line_count > 0)
              {
               bool found = false;
               AFS_TraderUpsertKeyLine(prior_lines, line_count, "Build: ", "Build: " + BuildLabel + " | Version: v" + AFS_VERSION_TEXT, "", "", found);
               AFS_TraderUpsertKeyLine(prior_lines, line_count, "Phase: ", "Phase: " + AFS_GetDisplayPhaseTag() + " | Step: " + AFS_GetDisplayStepTag(), "", "", found);
               AFS_TraderUpsertKeyLine(prior_lines, line_count, "PhaseStepContext: ", "PhaseStepContext: " + AFS_GetDisplayPhaseStepContext(), "", "", found);
               AFS_TraderUpsertKeyLine(prior_lines, line_count, "UpdatedAt: ", "UpdatedAt: " + lifecycle_now, "", "", found);
               AFS_TraderUpsertKeyLine(prior_lines, line_count, "DossierStatus: ", "DossierStatus: INACTIVE_LAST_SNAPSHOT", "", "", found);
               AFS_TraderUpsertKeyLine(prior_lines, line_count, "ActiveInCurrentSummary: ", "ActiveInCurrentSummary: false", "", "", found);
               AFS_TraderUpsertKeyLine(prior_lines, line_count, "ActivePublicationGroup: ", "ActivePublicationGroup: INACTIVE_RETAINED_SNAPSHOT", "", "", found);
               AFS_TraderUpsertKeyLine(prior_lines, line_count, "PublicationState: ", "PublicationState: INACTIVE_RETAINED", "", "", found);
               AFS_TraderUpsertKeyLine(prior_lines, line_count, "InactivePolicy: ", "InactivePolicy: " + AFS_GetTraderPublicationInactivePolicy(), "", "", found);

               string inactive_text = AFS_JoinLinesForTrace(prior_lines, line_count);
               if(inactive_text != prior_text)
                 {
                  string err = "";
                  bool changed = false;
                  bool ok = AFS_WritePlainTextFileIfChanged(file_path,
                                                            g_state.PathState.UseCommonFiles,
                                                            prior_lines,
                                                            line_count,
                                                            prior_text,
                                                            true,
                                                            changed,
                                                            err);
                  AFS_TracePublication("TRADER_DOSSIER",
                                       file_path,
                                       "inactive_lifecycle_patch",
                                       ok,
                                       "active_set_size=" + IntegerToString(ArraySize(ordered)) +
                                       " | changed=" + AFS_BoolText(changed));
                  if(!ok && StringLen(err) > 0)
                     AFS_LogWarn("Inactive dossier lifecycle patch warning: " + err);
                 }
              }
           }
        }

      ResetLastError();
      if(!FileFindNext(h, file_name))
         done = true;
     }

   FileFindClose(h);
  }


bool AFS_TraderDossierHasImmediateKnownData(const AFS_UniverseSymbol &rec)
  {
   if(StringLen(rec.CanonicalSymbol) > 0 || StringLen(rec.DisplayName) > 0)
      return true;
   if(StringLen(rec.AssetClass) > 0 || StringLen(rec.PrimaryBucket) > 0)
      return true;
   if(rec.ClassificationResolved || StringLen(rec.ClassificationStatus) > 0)
      return true;
   if(StringLen(rec.BrokerClass) > 0 || StringLen(rec.BrokerSector) > 0 || StringLen(rec.BrokerIndustry) > 0)
      return true;
   if(rec.Point > 0.0 || rec.TickSize > 0.0 || rec.ContractSize > 0.0)
      return true;
   if(rec.VolumeMin > 0.0 || rec.VolumeStep > 0.0 || rec.VolumeMax > 0.0)
      return true;
   if(rec.BucketRank > 0 || rec.FinalistSelected || rec.LastRankingUpdateAt > 0 || rec.TotalScore > 0.0)
      return true;
   return false;
  }

string AFS_TraderDossierPendingReasons(const AFS_UniverseSymbol &rec)
  {
   string reasons = "";

   bool history_pending = (rec.HistoryUpdateCount <= 0 ||
                           rec.BarsM15 <= 0 ||
                           rec.BarsH1 <= 0 ||
                           rec.AtrM15 <= 0.0 ||
                           rec.AtrH1 <= 0.0 ||
                           rec.BaselineMove <= 0.0);
   bool quote_pending = (!rec.QuotePresent ||
                         rec.TickAgeSec < 0 ||
                         rec.QuoteState == "UNSCANNED" ||
                         rec.QuoteState == "NO_QUOTE");
   bool live_spread_pending = (rec.SpreadSnapshot <= 0.0);
   bool correlation_pending = (rec.CorrContextFlag == "CORR_PENDING" || StringLen(rec.CorrClosestSymbol) == 0);
   bool spec_validation_pending = (rec.SpecUpdateCount <= 0 || rec.TickValueValidated <= 0.0);

   if(history_pending)
      reasons = "PENDING_HISTORY";

   if(quote_pending)
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "PENDING_QUOTE";
     }

   if(live_spread_pending)
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "PENDING_LIVE_SPREAD";
     }

   if(correlation_pending)
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "PENDING_CORRELATION";
     }

   if(spec_validation_pending)
     {
      if(StringLen(reasons) > 0) reasons += ",";
      reasons += "PENDING_SPEC_VALIDATION";
     }

   if(StringLen(reasons) == 0)
      reasons = "NONE";

   return reasons;
  }

string AFS_TraderDossierCompletionState(const AFS_UniverseSymbol &rec)
  {
   bool have_static = AFS_TraderDossierHasImmediateKnownData(rec);
   bool history_ready = (rec.HistoryUpdateCount > 0 &&
                         rec.BarsM15 > 0 &&
                         rec.BarsH1 > 0 &&
                         rec.AtrM15 > 0.0 &&
                         rec.AtrH1 > 0.0 &&
                         rec.BaselineMove > 0.0);
   bool live_ready = (rec.QuotePresent &&
                      rec.TickAgeSec >= 0 &&
                      rec.QuoteState != "UNSCANNED" &&
                      rec.QuoteState != "NO_QUOTE" &&
                      rec.SpreadSnapshot > 0.0);
   bool corr_ready = (rec.CorrContextFlag != "CORR_PENDING" && StringLen(rec.CorrClosestSymbol) > 0);

   if(corr_ready && live_ready && history_ready)
      return "COMPLETE";
   if(live_ready && history_ready)
      return "LIVE_READY";
   if(history_ready)
      return "HISTORY_READY";
   if(rec.BucketRank > 0 || rec.FinalistSelected || rec.LastRankingUpdateAt > 0)
      return "SCANNER_READY";
   if(have_static)
      return "STATIC_READY";
   return "CREATED";
  }

string AFS_GetTraderDossierCarryForwardMode(const AFS_UniverseSymbol &rec)
  {
   // Step 3 Z-revision safety note:
   // keep startup/runtime flow untouched and keep prior-snapshot fallback available,
   // but do not let hollow live/history fields suppress already-known static/spec/
   // selection truth that is already in memory at dossier write time.
   if(AFS_TraderOutputNeedsCarryForward(rec) && !AFS_TraderDossierHasImmediateKnownData(rec))
      return "PRIOR_ACTIVE_SNAPSHOT_IF_PRESENT";
   return "FRESH_REWRITE";
  }

bool AFS_TraderLineHasPrefix(const string line,const string prefix_a,const string prefix_b="")
  {
   if(StringLen(prefix_a) > 0 && StringFind(line, prefix_a) == 0)
      return true;
   if(StringLen(prefix_b) > 0 && StringFind(line, prefix_b) == 0)
      return true;
   return false;
  }

void AFS_TraderUpsertKeyLine(string &lines[],
                             int &line_count,
                             const string key_colon,
                             const string replacement_colon,
                             const string key_equals,
                             const string replacement_equals,
                             bool &found)
  {
   for(int i = 0; i < line_count; i++)
     {
      if(AFS_TraderLineHasPrefix(lines[i], key_colon, key_equals))
        {
         lines[i] = (StringFind(lines[i], key_equals) == 0 && StringLen(key_equals) > 0 ? replacement_equals : replacement_colon);
         found = true;
         return;
        }
     }

   int n = ArraySize(lines);
   ArrayResize(lines, n + 1);
   lines[n] = replacement_colon;
   line_count = n + 1;
   found = true;
  }

void AFS_TraderRefreshActiveLifecycleLines(string &lines[],
                                           int &line_count,
                                           const AFS_UniverseSymbol &rec,
                                           const string lifecycle_now,
                                           const string completion_state,
                                           const string pending_reasons)
  {
   bool found = false;
   AFS_TraderUpsertKeyLine(lines, line_count, "Build: ", "Build: " + BuildLabel + " | Version: v" + AFS_VERSION_TEXT, "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "Phase: ", "Phase: " + AFS_GetDisplayPhaseTag() + " | Step: " + AFS_GetDisplayStepTag(), "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "PhaseStepContext: ", "PhaseStepContext: " + AFS_GetDisplayPhaseStepContext(), "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "UpdatedAt: ", "UpdatedAt: " + lifecycle_now, "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "DossierFile: ", "DossierFile: " + AFS_TraderDossierFileName(rec), "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "DossierStatus: ", "DossierStatus: ACTIVE", "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "ActiveInCurrentSummary: ", "ActiveInCurrentSummary: true", "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "ActivePublicationGroup: ", "ActivePublicationGroup: SECTOR:" + AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "UNSECTORED")), "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "LastActiveSummaryAt: ", "LastActiveSummaryAt: " + lifecycle_now, "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "LastDossierWriteAt: ", "LastDossierWriteAt: " + lifecycle_now, "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "CompletionState: ", "CompletionState: " + completion_state, "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "PendingReasons: ", "PendingReasons: " + pending_reasons, "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "PublicationState: ", "PublicationState: ACTIVE", "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "PublicationScope: ", "PublicationScope: " + AFS_GetTraderPublicationScope(), "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "SelectionPolicy: ", "SelectionPolicy: " + AFS_GetTraderPublicationSelectionPolicy(), "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "InactivePolicy: ", "InactivePolicy: " + AFS_GetTraderPublicationInactivePolicy(), "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "ReentryPolicy: ", "ReentryPolicy: " + AFS_GetTraderPublicationReentryPolicy(), "", "", found);
   AFS_TraderUpsertKeyLine(lines, line_count, "CarryForwardMode: ", "CarryForwardMode: " + AFS_GetTraderDossierCarryForwardMode(rec), "", "", found);
  }

void AFS_CollectTraderPublishedIndexes(int &ordered[])
  {
   // Dependency note:
   // This ordered active set must remain a pure downstream view of the
   // existing finalist truth. Do not re-gate, re-score, or widen publication here.
   // Option B scope: publish PASS first within each sector, then fill remaining
   // slots with existing-ranked WEAK/BACKUP finalists until the sector reaches 5.
   ArrayResize(ordered, 0);
   string sectors[];
   ArrayResize(sectors, 0);

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!rec.FinalistSelected)
         continue;

      string sector = AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "UNSECTORED"));
      if(!AFS_FinalOutputBucketExists(sectors, sector))
        {
         int n = ArraySize(sectors);
         ArrayResize(sectors, n + 1);
         sectors[n] = sector;
        }
     }

   for(int b = 0; b < ArraySize(sectors); b++)
     {
      string sector = sectors[b];
      bool used[];
      ArrayResize(used, ArraySize(g_state.Universe));
      for(int u = 0; u < ArraySize(used); u++)
         used[u] = false;

      int published = 0;
      const int sector_limit = AFS_TraderPublicationBucketLimit();

      while(published < sector_limit)
        {
         int best_idx = -1;
         for(int i = 0; i < ArraySize(g_state.Universe); i++)
           {
            const AFS_UniverseSymbol rec = g_state.Universe[i];
            if(!rec.FinalistSelected || used[i])
               continue;
            if(AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "UNSECTORED")) != sector)
               continue;
            if(rec.FrictionStatus != "PASS")
               continue;

            if(best_idx < 0 || AFS_TraderPublicationRankBetter(rec, g_state.Universe[best_idx]))
               best_idx = i;
           }

         if(best_idx < 0)
            break;

         used[best_idx] = true;
         int n = ArraySize(ordered);
         ArrayResize(ordered, n + 1);
         ordered[n] = best_idx;
         published++;
        }

      while(published < sector_limit)
        {
         int best_idx = -1;
         for(int i = 0; i < ArraySize(g_state.Universe); i++)
           {
            const AFS_UniverseSymbol rec = g_state.Universe[i];
            if(!rec.FinalistSelected || used[i])
               continue;
            if(AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "UNSECTORED")) != sector)
               continue;
            if(rec.FrictionStatus == "PASS")
               continue;

            if(best_idx < 0 || AFS_TraderPublicationRankBetter(rec, g_state.Universe[best_idx]))
               best_idx = i;
           }

         if(best_idx < 0)
            break;

         used[best_idx] = true;
         int n = ArraySize(ordered);
         ArrayResize(ordered, n + 1);
         ordered[n] = best_idx;
         published++;
        }
     }
  }

string AFS_FormatRecentOHLCSeries(const string symbol,const ENUM_TIMEFRAMES tf,const int bars)
  {
   int want = bars;
   if(want < 1)
      want = 1;
   if(want > 5)
      want = 5;

   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   int copied = CopyRates(symbol, tf, 0, want, rates);
   if(copied <= 0)
      return "PENDING_NOT_AVAILABLE_IN_RUNTIME_RECORD";

   string out = "";
   for(int i = copied - 1; i >= 0; i--)
     {
      if(StringLen(out) > 0)
         out += " | ";
      out += "{" + TimeToString(rates[i].time, TIME_DATE|TIME_MINUTES) +
             ",O=" + AFS_FormatScore2(rates[i].open) +
             ",H=" + AFS_FormatScore2(rates[i].high) +
             ",L=" + AFS_FormatScore2(rates[i].low) +
             ",C=" + AFS_FormatScore2(rates[i].close) + "}";
     }

   return out;
  }

bool AFS_WriteTraderSymbolDossier(const AFS_UniverseSymbol &rec,const datetime now,const bool include_heavy,const bool force_write_if_unchanged,string &err)
  {
   string publication_block_reason = "";
   if(!AFS_TraderPublicationEligible(rec, publication_block_reason))
     {
      err = "blocked_active_refresh:" + rec.Symbol + ":" + publication_block_reason;
      AFS_TracePublication("TRADER_DOSSIER",
                           AFS_TraderDossierFilePath(rec),
                           "skip_publication_ineligible",
                           true,
                           "symbol=" + rec.Symbol + " | reason=" + publication_block_reason);
      return true;
     }

   return AFS_TD_WriteDossier(g_state, rec, now, include_heavy, force_write_if_unchanged, err);
  }


//==================================================================
// CORE-STABILITY NOTE: active summary builder
// Summary should read prepared/effective truth only. Keep this function
// formatter-oriented and do not extend it into a heavy rescan engine.
//==================================================================
void AFS_BuildTraderActiveSummaryLines(const int &ordered[],
                                     const datetime now,
                                     const int active_refreshed_this_pass,
                                     const int stale_active_count,
                                     const int max_active_write_age_sec,
                                     string &lines[],
                                     int &c)
  {
   int pass_count = 0;
   int weak_count = 0;
   int blocked_count = 0;
   int retained_inactive_count = AFS_TraderRetainedInactiveDossierCount(ordered);
   string sectors[];
   ArrayResize(sectors, 0);

   for(int i = 0; i < ArraySize(ordered); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[ordered[i]];
      if(rec.FrictionStatus == "PASS")
         pass_count++;
      else if(rec.FrictionStatus == "WEAK")
         weak_count++;
      else
         blocked_count++;

      string sector = AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "UNSECTORED"));
      if(!AFS_FinalOutputBucketExists(sectors, sector))
        {
         int n = ArraySize(sectors);
         ArrayResize(sectors, n + 1);
         sectors[n] = sector;
        }
     }

   string summary_file = g_state.PathState.TraderFolder + "\\" + AFS_CANONICAL_TRADER_SUMMARY_FILE_NAME;
   int top_next_limit = AFS_TraderTopNextSymbolLimit();
   if(top_next_limit > ArraySize(ordered))
      top_next_limit = ArraySize(ordered);

   AFS_FinalOutputAddLine(lines, c, "Aegis Forge Scanner - Trader Active Summary");
   AFS_FinalOutputAddLine(lines, c, "");
   AFS_FinalOutputAddLine(lines, c, "[HEADER_PACKAGE_STATUS]");
   AFS_FinalOutputAddLine(lines, c, "SystemName: Aegis Forge Scanner");
   AFS_FinalOutputAddLine(lines, c, "ServerName: " + g_state.ServerName);
   AFS_FinalOutputAddLine(lines, c, "ServerKey: " + g_state.PathState.ServerKey);
   AFS_FinalOutputAddLine(lines, c, "Build: " + BuildLabel + " | Version: v" + AFS_VERSION_TEXT);
   AFS_FinalOutputAddLine(lines, c, "Phase: " + AFS_GetDisplayPhaseTag());
   AFS_FinalOutputAddLine(lines, c, "Step: " + AFS_GetDisplayStepTag());
   AFS_FinalOutputAddLine(lines, c, "PhaseStepContext: " + AFS_GetDisplayPhaseStepContext());
   AFS_FinalOutputAddLine(lines, c, "UpdatedAt: " + AFS_FormatTime(now));
   AFS_FinalOutputAddLine(lines, c, "SummaryFile: " + summary_file);
   AFS_FinalOutputAddLine(lines, c, "ActiveDossierCount: " + IntegerToString(ArraySize(ordered)));
   if(retained_inactive_count >= 0)
      AFS_FinalOutputAddLine(lines, c, "RetainedInactiveDossierCount: " + IntegerToString(retained_inactive_count));
   AFS_FinalOutputAddLine(lines, c, "SelectedSymbolCount: " + IntegerToString(g_state.MemoryShell.FinalistCount));
   AFS_FinalOutputAddLine(lines, c, "PASS: " + IntegerToString(pass_count));
   AFS_FinalOutputAddLine(lines, c, "WEAK: " + IntegerToString(weak_count));
   AFS_FinalOutputAddLine(lines, c, "FailBlockedNoTrade: " + IntegerToString(blocked_count));
   AFS_FinalOutputAddLine(lines, c, "Top5PerSectorRuleActive: true");
   AFS_FinalOutputAddLine(lines, c, "ActiveRefreshWindowSec: " + IntegerToString(AFS_ActivePublicationFreshnessWindowSec()));
   AFS_FinalOutputAddLine(lines, c, "ActiveRefreshedThisPass: " + IntegerToString(active_refreshed_this_pass));
   AFS_FinalOutputAddLine(lines, c, "StaleActiveCount: " + IntegerToString(stale_active_count));
   AFS_FinalOutputAddLine(lines, c, "MaxActiveWriteAgeSec: " + IntegerToString(max_active_write_age_sec));
   AFS_FinalOutputAddLine(lines, c, "PackageHealth: " + AFS_TraderSummaryHealthText(ArraySize(ordered), g_state.MemoryShell.FinalistCount));
   AFS_FinalOutputAddLine(lines, c, "Notes: Dossiers written before SUMMARY.txt | inactive dossier files retained unchanged on disk");
   AFS_FinalOutputAddLine(lines, c, "PreservationLayer: " + AFS_DISPLAY_DEFERRED_FEATURES_HEADER);
   AFS_FinalOutputAddLine(lines, c, AFS_GetDeferredFeaturePreservationLine());
   AFS_FinalOutputAddLine(lines, c, "");
   AFS_FinalOutputAddLine(lines, c, "[TOP_NEXT_SYMBOLS]");
   for(int i = 0; i < top_next_limit; i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[ordered[i]];
      AFS_TraderAnalytics analytics;
      AFS_TA_Build(rec, false, analytics);
      string row = "{InspectPriority:" + IntegerToString(i + 1) +
                   ", Symbol:\"" + rec.Symbol +
                   "\", Canonical:\"" + AFS_OutputSafeText(rec.CanonicalSymbol, rec.Symbol) +
                   "\", Asset:\"" + AFS_OutputSafeText(rec.AssetClass, "-") +
                   "\", Bucket:\"" + AFS_OutputSafeText(rec.PrimaryBucket, "UNBUCKETED") +
                   "\", Sector:\"" + AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "-")) +
                   "\", Status:\"" + AFS_OutputSafeText(rec.FrictionStatus, "-") +
                   "\", Role:\"" + AFS_FinalOutputRoleText(rec) +
                   "\", Score:" + AFS_FormatScore2(rec.TotalScore) +
                   ", ExecutionQualityScore:" + AFS_FormatScore2(analytics.ExecutionQualityScore) +
                   ", TradeEligibility:\"" + AFS_OutputSafeText(analytics.TradeEligibility, "PENDING") +
                   "\", ExecutionPermission:\"" + AFS_OutputSafeText(analytics.ExecutionPermission, "PENDING") +
                   "\", EligibilityReasons:\"" + AFS_OutputSafeText(analytics.EligibilityReasons, "NONE") +
                   "\", MarketState:\"" + AFS_OutputSafeText(rec.PromotionState, "-") +
                   "\", StructureState:\"" + AFS_OutputSafeText(rec.HistoryStatus, "-") +
                   "\", FreshnessScore:" + AFS_FormatScore2(rec.FreshnessScore) +
                   ", TickAge:" + IntegerToString(rec.TickAgeSec) +
                   ", QuoteState:\"" + AFS_OutputSafeText(rec.QuoteState, "-") +
                   "\", SessionState:\"" + AFS_OutputSafeText(rec.SessionState, "-") +
                   "\", SpreadNow:" + AFS_FormatScore2(rec.SpreadSnapshot) +
                   "\", AtrM15:\"" + AFS_FinalOutputMetricOrState(analytics.EffectiveAtrM15, analytics.HasEffectiveAtrM15, analytics.AtrM15Source, 2) +
                   "\", AtrM15Source:\"" + AFS_OutputSafeText(analytics.AtrM15Source, "UNAVAILABLE_TRUE") +
                   "\", AtrH1:\"" + AFS_FinalOutputMetricOrState(analytics.EffectiveAtrH1, analytics.HasEffectiveAtrH1, analytics.AtrH1Source, 2) +
                   "\", AtrH1Source:\"" + AFS_OutputSafeText(analytics.AtrH1Source, "UNAVAILABLE_TRUE") +
                   ", DailyChangePercent:" + AFS_FormatScore2(rec.DailyChangePercent) +
                   ", CorrClosestSymbol:\"" + AFS_OutputSafeText(rec.CorrClosestSymbol, "-") +
                   "\", CorrFlag:\"" + AFS_OutputSafeText(rec.CorrContextFlag, "CORR_PENDING") +
                   "\", EconomicsConfidence:\"" + AFS_OutputSafeText(rec.EconomicsTrust, "UNSCANNED") +
                   "\", NoTradeFlag:\"" + AFS_BoolText(rec.FrictionStatus == "FAIL") +
                   "\", NoTradeReason:\"" + AFS_FinalOutputReasonText(rec) +
                   "\", DossierFile:\"" + AFS_TraderDossierFileName(rec) +
                   "\"}";
      AFS_FinalOutputAddLine(lines, c, row);
     }

   AFS_FinalOutputAddLine(lines, c, "");
   AFS_FinalOutputAddLine(lines, c, "[TOP_5_PER_SECTOR]");
   for(int b = 0; b < ArraySize(sectors); b++)
     {
      string sector = sectors[b];
      for(int i = 0; i < ArraySize(ordered); i++)
        {
         const AFS_UniverseSymbol rec = g_state.Universe[ordered[i]];
         if(AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "UNSECTORED")) != sector)
            continue;

         string row = "{Sector:\"" + sector +
                      "\", RankWithinSector:" + IntegerToString(AFS_TraderActiveRankWithinSector(ordered, i)) +
                      ", Symbol:\"" + rec.Symbol +
                      "\", Bucket:\"" + AFS_OutputSafeText(rec.PrimaryBucket, "UNBUCKETED") +
                      "\", Status:\"" + AFS_OutputSafeText(rec.FrictionStatus, "-") +
                      "\", Role:\"" + AFS_FinalOutputRoleText(rec) +
                      "\", Score:" + AFS_FormatScore2(rec.TotalScore) +
                      ", DossierFile:\"" + AFS_TraderDossierFileName(rec) +
                      "\"}";
         AFS_FinalOutputAddLine(lines, c, row);
        }
     }

   AFS_FinalOutputAddLine(lines, c, "");
   AFS_FinalOutputAddLine(lines, c, "[CORRELATION_CLUSTERS]");
   bool cluster_used[];
   ArrayResize(cluster_used, ArraySize(ordered));
   for(int z = 0; z < ArraySize(cluster_used); z++)
      cluster_used[z] = false;

   for(int i = 0; i < ArraySize(ordered); i++)
     {
      if(cluster_used[i])
         continue;

      const AFS_UniverseSymbol rec = g_state.Universe[ordered[i]];
      if(StringLen(rec.CorrClosestSymbol) <= 0 && rec.CorrContextFlag == "CORR_PENDING")
         continue;

      int mate_pos = -1;
      for(int j = 0; j < ArraySize(ordered); j++)
        {
         if(i == j)
            continue;
         if(g_state.Universe[ordered[j]].Symbol == rec.CorrClosestSymbol)
           {
            mate_pos = j;
            break;
           }
        }

      cluster_used[i] = true;
      string cluster_leader = rec.Symbol;
      string linked = rec.Symbol;
      string best_rep = rec.Symbol;

      if(mate_pos >= 0)
        {
         cluster_used[mate_pos] = true;
         const AFS_UniverseSymbol mate = g_state.Universe[ordered[mate_pos]];
         linked = rec.Symbol + "," + mate.Symbol;
         if(AFS_TraderPublicationRankBetter(mate, rec))
           {
            cluster_leader = mate.Symbol;
            best_rep = mate.Symbol;
           }
        }

      string cluster_name = cluster_leader + "_CLUSTER";
      if(mate_pos >= 0)
         cluster_name = cluster_leader + "__" + g_state.Universe[ordered[mate_pos]].Symbol;

      AFS_FinalOutputAddLine(lines, c,
                             "{ClusterName:\"" + cluster_name +
                             "\", ClusterLeader:\"" + cluster_leader +
                             "\", LinkedSymbols:\"" + linked +
                             "\", CorrType:\"" + AFS_OutputSafeText(rec.CorrContextFlag, "FINALIST_NEAREST_PEER") +
                             "\", BestRepresentative:\"" + best_rep +
                             "\", AvoidStackingNote:\"Prefer one representative when correlation flag is elevated\"}");
     }

   AFS_FinalOutputAddLine(lines, c, "");
   AFS_FinalOutputAddLine(lines, c, "[DO_NOT_PRIORITIZE_CAUTION]");
   int caution_count = 0;
   for(int i = 0; i < ArraySize(ordered); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[ordered[i]];
      AFS_TraderAnalytics analytics;
      AFS_TA_Build(rec, false, analytics);
      string degraded = AFS_FinalOutputDegradedText(rec);
      bool caution = (rec.FrictionStatus != "PASS" || StringLen(degraded) > 0 || rec.QuoteState == "NO_QUOTE");
      if(!caution)
         continue;

      caution_count++;
      if(caution_count > 15)
         break;

      AFS_FinalOutputAddLine(lines, c,
                             "{Symbol:\"" + rec.Symbol +
                             "\", Bucket:\"" + AFS_OutputSafeText(rec.PrimaryBucket, "UNBUCKETED") +
                             "\", Sector:\"" + AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "-")) +
                             "\", ProblemType:\"" + AFS_FinalOutputReasonText(rec) +
                             "\", NoTradeFlag:\"" + AFS_BoolText(rec.FrictionStatus == "FAIL") +
                             "\", NoTradeReason:\"" + AFS_FinalOutputReasonText(rec) +
                             "\", DegradedFlags:\"" + degraded +
                             "\", QuoteState:\"" + AFS_OutputSafeText(rec.QuoteState, "-") +
                             "\", FreshnessScore:" + AFS_FormatScore2(rec.FreshnessScore) +
                             ", EconomicsConfidence:\"" + AFS_OutputSafeText(rec.EconomicsTrust, "UNSCANNED") +
                             "\", TradeEligibility:\"" + AFS_OutputSafeText(analytics.TradeEligibility, "PENDING") +
                             "\", ExecutionPermission:\"" + AFS_OutputSafeText(analytics.ExecutionPermission, "PENDING") +
                             "\", DossierFile:\"" + AFS_TraderDossierFileName(rec) +
                             "\"}");
     }

   AFS_FinalOutputAddLine(lines, c, "");
   AFS_FinalOutputAddLine(lines, c, "[DOSSIER_FILE_INDEX]");
   for(int i = 0; i < ArraySize(ordered); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[ordered[i]];
      AFS_FinalOutputAddLine(lines, c,
                             "{Symbol:\"" + rec.Symbol +
                             "\", DossierFile:\"" + AFS_TraderDossierFileName(rec) +
                             "\", Bucket:\"" + AFS_OutputSafeText(rec.PrimaryBucket, "UNBUCKETED") +
                             "\", Sector:\"" + AFS_OutputSafeText(rec.Sector, AFS_OutputSafeText(rec.BrokerSector, "-")) +
                             "\", Status:\"" + AFS_OutputSafeText(rec.FrictionStatus, "-") +
                             "\"}");
     }
  }


void AFS_BuildTraderUniverseSummaryLines(const int &ordered[],
                                         const datetime now,
                                         string &lines[],
                                         int &c)
  {
   int pass_count = 0;
   int weak_count = 0;
   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      if(!g_state.Universe[i].FinalistSelected)
         continue;
      if(g_state.Universe[i].FrictionStatus == "PASS") pass_count++;
      else if(g_state.Universe[i].FrictionStatus == "WEAK") weak_count++;
     }

   string summary_file = g_state.PathState.TraderFolder + "\\UNIVERSE_SUMMARY.txt";

   AFS_FinalOutputAddLine(lines, c, "Aegis Forge Scanner - Universe Summary");
   AFS_FinalOutputAddLine(lines, c, "SystemName: Aegis Forge Scanner");
   AFS_FinalOutputAddLine(lines, c, "ServerName: " + g_state.ServerName);
   AFS_FinalOutputAddLine(lines, c, "ServerKey: " + g_state.PathState.ServerKey);
   AFS_FinalOutputAddLine(lines, c, "Build: " + BuildLabel + " | Version: v" + AFS_VERSION_TEXT);
   AFS_FinalOutputAddLine(lines, c, "Phase: " + AFS_GetDisplayPhaseTag() + " | Step: " + AFS_GetDisplayStepTag());
   AFS_FinalOutputAddLine(lines, c, "PhaseStepContext: " + AFS_GetDisplayPhaseStepContext());
   AFS_FinalOutputAddLine(lines, c, "UpdatedAt: " + AFS_FormatTime(now));
   AFS_FinalOutputAddLine(lines, c, "SummaryFile: " + summary_file);
   AFS_FinalOutputAddLine(lines, c, "FinalOutputFile: " + g_state.PathState.FinalOutputFile);
   AFS_FinalOutputAddLine(lines, c, "PublicationScope: UNIVERSE_OVERVIEW_WITH_ACTIVE_SET_REFERENCE");
   AFS_FinalOutputAddLine(lines, c, "PreservationLayer: " + AFS_DISPLAY_DEFERRED_FEATURES_HEADER);
   AFS_FinalOutputAddLine(lines, c, "SelectedSymbolCount: " + IntegerToString(g_state.MemoryShell.FinalistCount));
   AFS_FinalOutputAddLine(lines, c, "ActivePublicationCount: " + IntegerToString(ArraySize(ordered)));
   AFS_FinalOutputAddLine(lines, c, "BrokerSymbolCount: " + IntegerToString(g_state.MemoryShell.BrokerSymbolCount));
   AFS_FinalOutputAddLine(lines, c, "LoadedUniverseCount: " + IntegerToString(g_state.MemoryShell.LoadedUniverseCount));
   AFS_FinalOutputAddLine(lines, c, "EligibleSymbolCount: " + IntegerToString(g_state.MemoryShell.EligibleSymbolCount));
   AFS_FinalOutputAddLine(lines, c, "UniverseCount: " + IntegerToString(g_state.MemoryShell.UniverseCount));
   AFS_FinalOutputAddLine(lines, c, "PASS: " + IntegerToString(pass_count));
   AFS_FinalOutputAddLine(lines, c, "WEAK: " + IntegerToString(weak_count));
   AFS_FinalOutputAddLine(lines, c, "SurfaceBatchRange: " + AFS_FormatSurfaceBatchState());
   AFS_FinalOutputAddLine(lines, c, "RotationMode: " + AFS_RotationModeToText(RotationMode));
   AFS_FinalOutputAddLine(lines, c, "SurfaceState: " + AFS_SurfaceHealthSummary());
   AFS_FinalOutputAddLine(lines, c, "Freshness: " + AFS_SurfaceFreshnessText());
  }

bool AFS_WriteTraderSummaryAndDossiers()
  {
   // Downstream-only publication patch:
   // preserve active dossier-first / summary-last ordering and keep FINAL_OUTPUT
   // continuity untouched, but build trader/SUMMARY.txt directly from the active set.
   if(!g_state.PathState.Ready)
      return true;

   datetime now = g_state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   int ordered[];
   AFS_CollectTraderPublishedIndexes(ordered);

   string sanitize_detail = "";
   bool sanitized = AFS_SanitizeTraderPublishedIndexes(ordered, sanitize_detail);
   if(sanitized)
      AFS_LogWarn("Trader publication set sanitized: " + sanitize_detail);

   AFS_TacticalCacheSyncActiveSet(ordered, now);

   bool ok = true;
   int writes_done = 0;
   int writes_deferred = 0;
   int writes_skipped = 0;
   int stale_active_before = 0;
   int stale_active_after = 0;
   int max_active_write_age_sec = 0;

   int active_total = ArraySize(ordered);
   if(g_traderDossierWriteCursor < 0 || g_traderDossierWriteCursor >= active_total)
      g_traderDossierWriteCursor = 0;

   AFS_ActivePublicationFreshnessStats(ordered, now, stale_active_before, max_active_write_age_sec);

   for(int i = 0; i < active_total; i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[ordered[i]];
      int rank_within_bucket = AFS_TraderActiveRankWithinBucket(ordered, i);
      string next_sig = AFS_TraderDossierMaterialSignature(rec, rank_within_bucket);
      string next_light_sig = AFS_TraderDossierLightSignature(rec, rank_within_bucket);
      string next_heavy_sig = AFS_TraderDossierHeavySignature(rec);
      int tactical_idx = AFS_TacticalCacheIndex(rec.Symbol);

      int state_idx = AFS_TraderDossierStateIndex(rec.Symbol);
      string prior_sig = (state_idx >= 0 ? g_traderDossierStateSignatures[state_idx] : "");
      datetime prior_write_at = (state_idx >= 0 ? g_traderDossierStateWriteAt[state_idx] : 0);
      bool stale_due = AFS_ActivePublicationWriteIsStale(prior_write_at, now);
      bool material_changed = (StringLen(prior_sig) == 0 || prior_sig != next_sig);

      bool light_due = true;
      bool heavy_due = true;
      if(tactical_idx >= 0)
        {
         light_due = (StringLen(g_tacticalLightSignatures[tactical_idx]) == 0 ||
                      g_tacticalLightSignatures[tactical_idx] != next_light_sig ||
                      g_tacticalNextLightAt[tactical_idx] <= 0 ||
                      now >= g_tacticalNextLightAt[tactical_idx]);
         heavy_due = (StringLen(g_tacticalHeavySignatures[tactical_idx]) == 0 ||
                      g_tacticalHeavySignatures[tactical_idx] != next_heavy_sig ||
                      g_tacticalNextHeavyAt[tactical_idx] <= 0 ||
                      now >= g_tacticalNextHeavyAt[tactical_idx]);
        }
      bool include_heavy = heavy_due;

      if(!material_changed && !stale_due && !light_due && !heavy_due)
        {
         writes_skipped++;
         AFS_TracePublication("TRADER_DOSSIER",
                              AFS_TraderDossierFilePath(rec),
                              "skip_material_unchanged",
                              true,
                              "symbol=" + rec.Symbol +
                              " | sig=" + next_sig +
                              " | active_fresh=true" +
                              " | tactical=idle");
         continue;
        }

      string dossier_err = "";
      if(!AFS_WriteTraderSymbolDossier(rec, now, include_heavy, stale_due, dossier_err))
        {
         ok = false;
         if(StringLen(dossier_err) > 0)
            AFS_LogWarn("Trader dossier write warning: " + dossier_err);
        }
      else
        {
         writes_done++;
         AFS_TraderDossierStateSet(rec.Symbol, next_sig, now);
         if(tactical_idx >= 0)
           {
            g_tacticalLastLightAt[tactical_idx] = now;
            g_tacticalNextLightAt[tactical_idx] = now + AFS_TacticalLightCadenceSec();
            g_tacticalLightSignatures[tactical_idx] = next_light_sig;
            if(include_heavy)
              {
               g_tacticalLastHeavyAt[tactical_idx] = now;
               g_tacticalNextHeavyAt[tactical_idx] = now + AFS_TacticalHeavyCadenceSec();
               g_tacticalHeavySignatures[tactical_idx] = next_heavy_sig;
              }
           }
        }
     }

   g_traderDossierWriteCursor = 0;
   AFS_ActivePublicationFreshnessStats(ordered, now, stale_active_after, max_active_write_age_sec);

   string summary_file = g_state.PathState.TraderFolder + "\\" + AFS_CANONICAL_TRADER_SUMMARY_FILE_NAME;
   string prior_summary_text = "";
   bool had_prior_summary = AFS_ReadAllTextFile(summary_file, g_state.PathState.UseCommonFiles, prior_summary_text);

   string summary_lines[];
   int summary_count = 0;
   AFS_BuildTraderActiveSummaryLines(ordered, now, writes_done, stale_active_after, max_active_write_age_sec, summary_lines, summary_count);

    string next_summary_text = AFS_JoinLinesForTrace(summary_lines, summary_count);
    bool summary_changed = (!had_prior_summary || prior_summary_text != next_summary_text);
   string next_summary_fingerprint = AFS_HashLinesFingerprint(summary_lines, summary_count);
   bool summary_stale_due = AFS_ActivePublicationWriteIsStale(g_lastTraderSummaryWriteAt, now);

    string sum_err = "";
    bool sum_ok = (summary_stale_due && !summary_changed
                ? AFS_WritePlainTextFile(summary_file,
                                         g_state.PathState.UseCommonFiles,
                                         summary_lines,
                                         summary_count,
                                         sum_err)
                : AFS_WritePlainTextFileIfChanged(summary_file,
                                                  g_state.PathState.UseCommonFiles,
                                                  summary_lines,
                                                  summary_count,
                                                  prior_summary_text,
                                                  had_prior_summary,
                                                  summary_changed,
                                                  sum_err));
   AFS_TracePublication("TRADER_SUMMARY",
                        summary_file,
                        (summary_changed ? "write" : (summary_stale_due ? "refresh_due_no_content_delta" : "skip_unchanged")),
                        sum_ok,
                        "changed=" + AFS_BoolText(summary_changed) +
                         " | forced_refresh=" + AFS_BoolText(summary_stale_due && !summary_changed) +
                        " | fp=" + next_summary_fingerprint +
                        " | active_dossiers=" + IntegerToString(ArraySize(ordered)) +
                        " | finalists=" + IntegerToString(g_state.MemoryShell.FinalistCount) +
                        " | writes_done=" + IntegerToString(writes_done) +
                        " | writes_skipped=" + IntegerToString(writes_skipped) +
                        " | writes_deferred=" + IntegerToString(writes_deferred) +
                        " | stale_active_before=" + IntegerToString(stale_active_before) +
                        " | stale_active_after=" + IntegerToString(stale_active_after) +
                        " | max_active_write_age_sec=" + IntegerToString(max_active_write_age_sec));
   if(sum_ok)
     {
      g_lastTraderSummaryFingerprint = next_summary_fingerprint;
      g_lastTraderSummaryWriteAt = now;
     }
   if(!sum_ok)
     {
      ok = false;
      if(StringLen(sum_err) > 0)
         AFS_LogWarn("Trader summary write warning: " + sum_err);
     }

   bool universe_due = (g_lastUniverseSummaryWriteAt <= 0 || (now - g_lastUniverseSummaryWriteAt) >= 1800);
   if(universe_due)
     {
      string universe_summary_file = g_state.PathState.TraderFolder + "\\UNIVERSE_SUMMARY.txt";
      string prior_universe_text = "";
      bool had_prior_universe = AFS_ReadAllTextFile(universe_summary_file, g_state.PathState.UseCommonFiles, prior_universe_text);

      string universe_lines[];
      int universe_count = 0;
      AFS_BuildTraderUniverseSummaryLines(ordered, now, universe_lines, universe_count);

      bool universe_changed = false;

      string uni_err = "";
      bool uni_ok = AFS_WritePlainTextFileIfChanged(universe_summary_file,
                                                    g_state.PathState.UseCommonFiles,
                                                    universe_lines,
                                                    universe_count,
                                                    prior_universe_text,
                                                    had_prior_universe,
                                                    universe_changed,
                                                    uni_err);
      AFS_TracePublication("TRADER_UNIVERSE_SUMMARY",
                           universe_summary_file,
                           (universe_changed ? "write" : "skip_unchanged"),
                           uni_ok,
                           "cadence=1800s | changed=" + AFS_BoolText(universe_changed) +
                           " | active_dossiers=" + IntegerToString(ArraySize(ordered)) +
                           " | finalists=" + IntegerToString(g_state.MemoryShell.FinalistCount));
      if(uni_ok)
         g_lastUniverseSummaryWriteAt = now;
      else
        {
         ok = false;
         if(StringLen(uni_err) > 0)
            AFS_LogWarn("Trader universe summary write warning: " + uni_err);
        }
     }
   else if(AFS_PublicationTraceEnabled())
     {
      int next_due = (int)(1800 - (now - g_lastUniverseSummaryWriteAt));
      if(next_due < 0)
         next_due = 0;
      AFS_TracePublication("TRADER_UNIVERSE_SUMMARY",
                           g_state.PathState.TraderFolder + "\\UNIVERSE_SUMMARY.txt",
                           "skip_cadence",
                           true,
                           "cadence=1800s | next_due_in_sec=" + IntegerToString(next_due));
     }

   return ok;
  }

void AFS_WriteArtifactsForCurrentStep()
  {
   // Publication order is intentionally preserved for runtime safety.
   // Legacy outputs stay live here until dependency-safe retirement is proven.
   AFS_WriteStep2Artifacts();

   if(!g_state.PathState.Ready)
      return;

   bool write_ok = true;

   if(AFS_GetStepNumber() >= 11.0)
     {
      bool final_ok = AFS_WriteFinalOperatorOutput();
      if(!final_ok)
         write_ok = false;

      if(EnableTraderPackageOutput)
        {
         bool trader_ok = AFS_WriteTraderSummaryAndDossiers();
         if(!trader_ok)
            write_ok = false;
        }
      else
         AFS_TracePublication("TRADER_PACKAGE",
                              g_state.PathState.TraderFolder + "\\" + AFS_CANONICAL_TRADER_SUMMARY_FILE_NAME,
                              "disabled",
                              true,
                              "EnableTraderPackageOutput=false");

      if(EnableTraderIntelExport)
        {
         string ti_err = "";
         bool ti_ok = AFS_TI_RunExport(g_state,
                                       EnableTraderIntelExport,
                                       TraderIntelSchemaVersion,
                                       TraderIntelMaxSymbols,
                                       TraderIntelIncludeM1,
                                       TraderIntelIncludeM5,
                                       TraderIntelIncludeM15,
                                       TraderIntelIncludeH1,
                                       CurrentPhaseTag,
                                       CurrentStepTag,
                                       ti_err);
         AFS_TracePublication("TRADER_DATA",
                              g_state.PathState.TraderDataFile,
                              "write",
                              ti_ok,
                              "enabled=" + AFS_BoolText(EnableTraderIntelExport) +
                              " | detail=" + AFS_OutputSafeText(ti_err, "-"));
         if(StringLen(ti_err) > 0)
            AFS_LogWarn("TraderData export warning: " + ti_err);
         if(!ti_ok)
            write_ok = false;
        }
      else
         AFS_TracePublication("TRADER_DATA",
                              g_state.PathState.TraderDataFile,
                              "disabled",
                              true,
                              "EnableTraderIntelExport=false");
     }

   if(!g_surfaceArtifactsDirty)
     {
      AFS_TracePublication("SURFACE_EXPORTS",
                           g_state.PathState.DevFolder,
                           "skip",
                           true,
                           "g_surfaceArtifactsDirty=false");
      return;
     }

   if(AFS_GetStepNumber() >= 3.0)
     {
      bool broker_ok = AFS_WriteUniverseBrokerView();
      if(!broker_ok)
         write_ok = false;

      bool raw_ok = AFS_WriteUniverseRawExport();
      if(!raw_ok)
         write_ok = false;

      bool class_ok = AFS_WriteClassificationReviewExport();
      if(!class_ok)
         write_ok = false;
     }

   if(write_ok)
      g_surfaceArtifactsDirty = false;
  }

string AFS_FormatTime(const datetime t)
  {
   if(t <= 0)
      return "n/a";
   return TimeToString(t, TIME_DATE|TIME_SECONDS);
  }

string AFS_FormatScore2(const double value)
  {
   return DoubleToString(value, 2);
  }

string AFS_FinalOutputMetricOrState(const double value,const bool has_value,const string source,const int digits=2)
  {
   if(has_value && value > 0.0)
      return DoubleToString(value, digits);
   if(StringLen(source) > 0)
      return source;
   return "UNAVAILABLE_TRUE";
  }

string AFS_FormatCorrValue(const double value)
  {
   return DoubleToString(value, 2);
  }

void AFS_FinalOutputAddLine(string &lines[],int &line_count,const string text)
  {
   ArrayResize(lines, line_count + 1);
   lines[line_count] = text;
   line_count++;
  }

bool AFS_FinalOutputBucketExists(string &buckets[],const string bucket)
  {
   for(int i = 0; i < ArraySize(buckets); i++)
      if(buckets[i] == bucket)
         return true;
   return false;
  }

string AFS_BuildStableTextSignature(string &lines[],const int line_count)
  {
   string sig = "";
   for(int i = 0; i < line_count; i++)
     {
      if(StringFind(lines[i], "Updated: ") == 0)
         continue;
      sig += lines[i] + "\n";
     }
   return sig;
  }

bool AFS_FinalOutputBetter(const AFS_UniverseSymbol &a,const AFS_UniverseSymbol &b)
  {
   if(a.BucketRank < b.BucketRank)
      return true;
   if(a.BucketRank > b.BucketRank)
      return false;

   if(a.FrictionStatus == "PASS" && b.FrictionStatus != "PASS")
      return true;
   if(a.FrictionStatus != "PASS" && b.FrictionStatus == "PASS")
      return false;

   if(a.TotalScore > b.TotalScore)
      return true;
   if(a.TotalScore < b.TotalScore)
      return false;

   return (StringCompare(a.Symbol, b.Symbol) < 0);
  }

string AFS_FinalOutputWeakText(const AFS_UniverseSymbol &rec)
  {
   if(rec.FrictionStatus != "WEAK")
      return "";

   if(StringLen(rec.FrictionWeakReason) > 0)
      return " | WeakReason=" + rec.FrictionWeakReason;

   return " | WeakReason=WEAK_RUNTIME";
  }

string AFS_OutputSafeText(const string value,const string fallback="-")
  {
   if(StringLen(value) > 0)
      return value;
   return fallback;
  }

string AFS_FinalOutputRoleText(const AFS_UniverseSymbol &rec)
  {
   if(rec.FrictionStatus == "PASS")
      return "PRIMARY";
   if(rec.FrictionStatus == "WEAK")
      return "BACKUP";
   return "CONTEXT";
  }

string AFS_FinalOutputReasonText(const AFS_UniverseSymbol &rec)
  {
   if(rec.FrictionStatus == "WEAK")
      return AFS_OutputSafeText(rec.FrictionWeakReason, "WEAK_RUNTIME");
   if(rec.FrictionStatus == "FAIL")
      return AFS_OutputSafeText(rec.FrictionFailReason, "FAIL_RUNTIME");
   return "-";
  }

string AFS_FinalOutputDegradedText(const AFS_UniverseSymbol &rec)
  {
   string out = "";

   if(rec.HistoryUpdateCount <= 0 || rec.BarsM15 <= 0 || rec.BarsH1 <= 0)
      out += "HISTORY_PENDING";
   else if(rec.HistoryStatus == "WEAK")
      out += "HISTORY_THIN";

   if(rec.FrictionUpdateCount <= 0)
     {
      if(StringLen(out) > 0) out += ",";
      out += "FRICTION_PENDING";
     }
   else if(rec.FrictionStatus == "WEAK")
     {
      if(StringLen(out) > 0) out += ",";
      out += "TRADABILITY_WEAK";
     }

   if(rec.TickAgeSec > MaxTickAge)
     {
      if(StringLen(out) > 0) out += ",";
      out += "QUOTE_STALE";
     }

   if(rec.CorrContextFlag == "CORR_PENDING")
     {
      if(StringLen(out) > 0) out += ",";
      out += "CORR_PENDING";
     }

   if(StringLen(out) == 0)
      out = "NONE";

   return out;
  }

string AFS_FinalOutputIdentityText(const AFS_UniverseSymbol &rec)
  {
   string txt = rec.Symbol;

   if(StringLen(rec.DisplayName) > 0 && rec.DisplayName != rec.Symbol)
      txt += " | Name=" + rec.DisplayName;

   if(StringLen(rec.CanonicalSymbol) > 0 && rec.CanonicalSymbol != rec.Symbol)
      txt += " | Canonical=" + rec.CanonicalSymbol;

   if(StringLen(rec.AssetClass) > 0)
      txt += " | Asset=" + rec.AssetClass;

   return txt;
  }

string AFS_NormalizeTextLine(const string line)
  {
   string out = line;
   while(StringLen(out) > 0)
     {
      int ch = StringGetCharacter(out, StringLen(out) - 1);
      if(ch == '\r' || ch == '\n')
         out = StringSubstr(out, 0, StringLen(out) - 1);
      else
         break;
     }
   return out;
  }

bool AFS_ReadAllTextFile(const string rel_file,
                         const bool use_common_files,
                         string &text)
  {
   text = "";

   int flags = FILE_READ | FILE_BIN;
   if(use_common_files)
      flags |= FILE_COMMON;

   ResetLastError();
   int h = FileOpen(rel_file, flags);
   if(h == INVALID_HANDLE)
      return false;

   int size = (int)FileSize(h);
   uchar data[];
   ArrayResize(data, size);
   if(size > 0)
      FileReadArray(h, data, 0, size);
   FileClose(h);

   text = CharArrayToString(data, 0, size);
   return true;
  }

string AFS_BuildAtomicTempFilePath(const string rel_file)
  {
   string dir  = AFS_TI_FileDirName(rel_file);
   string base = AFS_TI_FileBaseName(rel_file);
   string temp = ".__afs_tmp_" + IntegerToString((int)GetTickCount()) + "_" + base;
   if(StringLen(dir) > 0)
      return dir + "\\" + temp;
   return temp;
  }

bool AFS_WritePlainTextFile(const string rel_file,
                            const bool use_common_files,
                            string &lines[],
                            const int line_count,
                            string &err)
  {
   err = "";

   int flags = FILE_WRITE | FILE_TXT | FILE_ANSI;
   if(use_common_files)
      flags |= FILE_COMMON;

   string temp_file = AFS_BuildAtomicTempFilePath(rel_file);

   ResetLastError();
   int h = FileOpen(temp_file, flags);
   if(h == INVALID_HANDLE)
     {
      err = "Failed to write temp text file: " + temp_file +
            " (error " + IntegerToString(GetLastError()) + ")";
      if(g_state.PathState.Ready)
         AFS_OD_LogWriteFailure(g_state.PathState, err);
      return false;
     }

   for(int i = 0; i < line_count; i++)
     {
      ResetLastError();
      FileWriteString(h, lines[i] + "\r\n");
      if(GetLastError() != 0)
        {
         int write_err = GetLastError();
         FileClose(h);
         FileDelete(temp_file, use_common_files ? FILE_COMMON : 0);
         err = "Failed while writing temp text file: " + temp_file +
               " (error " + IntegerToString(write_err) + ")";
         if(g_state.PathState.Ready)
            AFS_OD_LogWriteFailure(g_state.PathState, err);
         return false;
        }
     }

   FileFlush(h);
   FileClose(h);

   ResetLastError();
   int common_flag = (use_common_files ? FILE_COMMON : 0);
   int move_flags  = FILE_REWRITE | common_flag;
   if(!FileMove(temp_file, common_flag, rel_file, move_flags))
     {
      int move_err = GetLastError();
      FileDelete(temp_file, common_flag);
      err = "Failed to promote temp text file: " + temp_file +
            " -> " + rel_file +
            " (error " + IntegerToString(move_err) + ")";
      if(g_state.PathState.Ready)
         AFS_OD_LogWriteFailure(g_state.PathState, err);
      return false;
     }

   return true;
  }

bool AFS_WritePlainTextFileIfChanged(const string rel_file,
                                     const bool use_common_files,
                                     string &lines[],
                                     const int line_count,
                                     const string prior_text_hint,
                                     const bool has_prior_hint,
                                     bool &changed,
                                     string &err)
  {
   string next_text = AFS_JoinLinesForTrace(lines, line_count);
   string prior_text = prior_text_hint;
   bool has_prior = has_prior_hint;

   if(!has_prior)
      has_prior = AFS_ReadAllTextFile(rel_file, use_common_files, prior_text);

   changed = (!has_prior || prior_text != next_text);
   if(!changed)
      return true;

   return AFS_WritePlainTextFile(rel_file, use_common_files, lines, line_count, err);
  }


bool AFS_CopyFileAtomic(const string source_file,
                        const string target_file,
                        const bool use_common_files,
                        string &err)
  {
   err = "";

   int common_flag = (use_common_files ? FILE_COMMON : 0);

   ResetLastError();
   int src = FileOpen(source_file, FILE_READ | FILE_BIN | common_flag);
   if(src == INVALID_HANDLE)
     {
      err = "Failed to open source file for copy: " + source_file +
            " (error " + IntegerToString(GetLastError()) + ")";
      if(g_state.PathState.Ready)
         AFS_OD_LogWriteFailure(g_state.PathState, err);
      return false;
     }

   int size = (int)FileSize(src);
   uchar data[];
   ArrayResize(data, size);
   if(size > 0)
      FileReadArray(src, data, 0, size);
   FileClose(src);

   string temp_file = AFS_BuildAtomicTempFilePath(target_file);

   ResetLastError();
   int dst = FileOpen(temp_file, FILE_WRITE | FILE_BIN | common_flag);
   if(dst == INVALID_HANDLE)
     {
      err = "Failed to open temp target file for copy: " + temp_file +
            " (error " + IntegerToString(GetLastError()) + ")";
      if(g_state.PathState.Ready)
         AFS_OD_LogWriteFailure(g_state.PathState, err);
      return false;
     }

   if(size > 0)
     {
      ResetLastError();
      FileWriteArray(dst, data, 0, size);
      if(GetLastError() != 0)
        {
         int write_err = GetLastError();
         FileClose(dst);
         FileDelete(temp_file, common_flag);
         err = "Failed while writing temp copy file: " + temp_file +
               " (error " + IntegerToString(write_err) + ")";
         if(g_state.PathState.Ready)
            AFS_OD_LogWriteFailure(g_state.PathState, err);
         return false;
        }
     }

   FileFlush(dst);
   FileClose(dst);

   ResetLastError();
   int move_flags = FILE_REWRITE | common_flag;
   if(!FileMove(temp_file, common_flag, target_file, move_flags))
     {
      int move_err = GetLastError();
      FileDelete(temp_file, common_flag);
      err = "Failed to promote temp copy file: " + temp_file +
            " -> " + target_file +
            " (error " + IntegerToString(move_err) + ")";
      if(g_state.PathState.Ready)
         AFS_OD_LogWriteFailure(g_state.PathState, err);
      return false;
     }

   return true;
  }

string AFS_FinalOutputExtractHeaderSymbol(const string header)
  {
   string line = AFS_NormalizeTextLine(header);
   if(StringLen(line) < 3 || StringGetCharacter(line, 0) != '#')
      return "";

   int start = -1;
   for(int i = 0; i < StringLen(line); i++)
     {
      if(StringGetCharacter(line, i) == ' ')
        {
         start = i + 1;
         break;
        }
     }
   if(start < 0 || start >= StringLen(line))
      return "";

   int end = StringLen(line);
   for(int i = start; i < StringLen(line); i++)
     {
      if(i + 1 < StringLen(line) &&
         StringGetCharacter(line, i) == ' ' &&
         StringGetCharacter(line, i + 1) == '|')
        {
         end = i;
         break;
        }
     }

   return StringSubstr(line, start, end - start);
  }

bool AFS_FinalOutputNeedsCarryForward(const AFS_UniverseSymbol &rec)
  {
   bool quote_hollow =
      (!rec.QuotePresent ||
       rec.QuoteState == "NO_QUOTE" ||
       rec.TickAgeSec < 0);

   bool spread_hollow =
      (rec.SpreadSnapshot <= 0.0 ||
       rec.MedianSpread <= 0.0 ||
       rec.MaxSpread <= 0.0);

   bool history_hollow =
      (rec.HistoryUpdateCount <= 0 ||
       rec.BarsM15 <= 0 ||
       rec.BarsH1 <= 0 ||
       rec.AtrM15 <= 0.0 ||
       rec.AtrH1 <= 0.0 ||
       rec.BaselineMove <= 0.0);

   bool friction_hollow =
      (rec.FrictionUpdateCount <= 0 ||
       rec.FrictionSampleCountUsed <= 0);

   return ((history_hollow && (quote_hollow || friction_hollow)) ||
           (quote_hollow && spread_hollow));
  }

bool AFS_FinalOutputFindPriorEvidenceLines(const string prior_text,
                                           const string symbol,
                                           string &line2,
                                           string &line3)
  {
   line2 = "";
   line3 = "";

   if(StringLen(prior_text) <= 0 || StringLen(symbol) <= 0)
      return false;

   string raw_lines[];
   int raw_count = StringSplit(prior_text, '\n', raw_lines);
   if(raw_count <= 0)
      return false;

   for(int i = 0; i + 2 < raw_count; i++)
     {
      string current = AFS_NormalizeTextLine(raw_lines[i]);
      if(StringLen(current) == 0 || StringGetCharacter(current, 0) != '#')
         continue;

      if(AFS_FinalOutputExtractHeaderSymbol(current) != symbol)
         continue;

      string candidate2 = AFS_NormalizeTextLine(raw_lines[i + 1]);
      string candidate3 = AFS_NormalizeTextLine(raw_lines[i + 2]);

      if(StringFind(candidate2, "  Cost/Move:") != 0)
         return false;
      if(StringFind(candidate3, "  Activity:") != 0)
         return false;

      line2 = candidate2;
      line3 = candidate3;
      return true;
     }

   return false;
  }

bool AFS_WriteFinalOperatorOutput()
  {
   if(!g_state.PathState.Ready)
      return true;

   string final_file = g_state.PathState.FinalOutputFile;
   string prior_text = "";
   bool had_prior_file = AFS_ReadAllTextFile(final_file, g_state.PathState.UseCommonFiles, prior_text);

   string lines[];
   int line_count = 0;
   int pass_count = 0;
   int weak_count = 0;

   string buckets[];
   ArrayResize(buckets, 0);

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!rec.FinalistSelected)
         continue;

      if(rec.FrictionStatus == "PASS")
         pass_count++;
      else if(rec.FrictionStatus == "WEAK")
         weak_count++;

      string bucket = rec.PrimaryBucket;
      if(StringLen(bucket) == 0)
         bucket = "UNBUCKETED";

      if(!AFS_FinalOutputBucketExists(buckets, bucket))
        {
         int pos = ArraySize(buckets);
         ArrayResize(buckets, pos + 1);
         buckets[pos] = bucket;
        }
     }

   AFS_FinalOutputAddLine(lines, line_count, "Aegis Forge Scanner - Final Output");
   AFS_FinalOutputAddLine(lines, line_count, "Server: " + g_state.ServerName);
   AFS_FinalOutputAddLine(lines, line_count, "ServerKey: " + g_state.PathState.ServerKey);
   AFS_FinalOutputAddLine(lines, line_count, "Phase: " + AFS_GetDisplayPhaseTag() + " | Step: " + AFS_GetDisplayStepTag());
   AFS_FinalOutputAddLine(lines, line_count, "Build: " + BuildLabel + " | Version: v" + AFS_VERSION_TEXT);
   AFS_FinalOutputAddLine(lines, line_count, "Updated: " + AFS_FormatTime(g_state.ServerTime));
   AFS_FinalOutputAddLine(lines, line_count, "FinalOutputFile: " + final_file);
   AFS_FinalOutputAddLine(lines, line_count, "Finalists: " + IntegerToString(g_state.MemoryShell.FinalistCount) +
                                            " | PASS=" + IntegerToString(pass_count) +
                                            " | WEAK=" + IntegerToString(weak_count));
   AFS_FinalOutputAddLine(lines, line_count, "");

   if(g_state.MemoryShell.FinalistCount <= 0)
     {
      AFS_FinalOutputAddLine(lines, line_count, "No finalists available.");
      AFS_FinalOutputAddLine(lines, line_count, "Scanner remains honest: no downstream re-gate was applied.");
     }
   else
     {
      for(int b = 0; b < ArraySize(buckets); b++)
        {
         string bucket = buckets[b];
         AFS_FinalOutputAddLine(lines, line_count, "[" + bucket + "]");

         int emitted = 0;
         bool used[];
         ArrayResize(used, ArraySize(g_state.Universe));
         for(int u = 0; u < ArraySize(used); u++)
            used[u] = false;

         while(emitted < 5)
           {
            int best_idx = -1;

            for(int i = 0; i < ArraySize(g_state.Universe); i++)
              {
               AFS_UniverseSymbol rec = g_state.Universe[i];
               if(!rec.FinalistSelected)
                  continue;
               if(used[i])
                  continue;
               if(rec.PrimaryBucket != bucket)
                  continue;

               if(best_idx < 0 || AFS_FinalOutputBetter(rec, g_state.Universe[best_idx]))
                  best_idx = i;
              }

            if(best_idx < 0)
               break;

            used[best_idx] = true;
            emitted++;

            AFS_UniverseSymbol rec = g_state.Universe[best_idx];
            string corr_symbol = AFS_OutputSafeText(rec.CorrClosestSymbol, "-");
            string reason_text = AFS_FinalOutputReasonText(rec);
            string degraded    = AFS_FinalOutputDegradedText(rec);

            string header = "#" + IntegerToString(rec.BucketRank) + " " + AFS_FinalOutputIdentityText(rec) +
                            " | Status=" + rec.FrictionStatus +
                            " | Role=" + AFS_FinalOutputRoleText(rec) +
                            " | Score=" + AFS_FormatScore2(rec.TotalScore);
            string line2 = "  Cost/Move: SpreadNow=" + AFS_FormatScore2(rec.SpreadSnapshot) +
                           " | Median=" + AFS_FormatScore2(rec.MedianSpread) +
                           " | Max=" + AFS_FormatScore2(rec.MaxSpread) +
                           " | SprATR=" + AFS_FormatScore2(rec.SpreadAtrRatio) +
                           " | ATRM15=" + AFS_FormatScore2(rec.AtrM15) +
                           " | ATRH1=" + AFS_FormatScore2(rec.AtrH1) +
                           " | BaseMove=" + AFS_FormatScore2(rec.BaselineMove);
            string line3 = "  Activity: Live=" + AFS_FormatScore2(rec.LivelinessScore) +
                           " | Fresh=" + AFS_FormatScore2(rec.FreshnessScore) +
                           " | TickAge=" + IntegerToString(rec.TickAgeSec) +
                           " | FrictionUpdates=" + IntegerToString(rec.FrictionUpdateCount) +
                           " | Quote=" + AFS_OutputSafeText(rec.QuoteState, "-") +
                           " | Session=" + AFS_OutputSafeText(rec.SessionState, "-");
            string line4 = "  Context: Corr=" + AFS_FormatCorrValue(rec.CorrMax) +
                           " vs " + corr_symbol +
                           " | CorrFlag=" + AFS_OutputSafeText(rec.CorrContextFlag, "CORR_PENDING") +
                           " | Reason=" + reason_text +
                           " | Degraded=" + degraded;

            if(AFS_FinalOutputNeedsCarryForward(rec))
              {
               string prior_line2 = "";
               string prior_line3 = "";
               if(AFS_FinalOutputFindPriorEvidenceLines(prior_text, rec.Symbol, prior_line2, prior_line3))
                 {
                  line2 = prior_line2;
                  line3 = prior_line3;
                 }
              }

            AFS_FinalOutputAddLine(lines, line_count, header);
            AFS_FinalOutputAddLine(lines, line_count, line2);
            AFS_FinalOutputAddLine(lines, line_count, line3);
            AFS_FinalOutputAddLine(lines, line_count, line4);
            AFS_FinalOutputAddLine(lines, line_count, "");
           }
        }
     }

   datetime now = g_state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   string next_text = AFS_JoinLinesForTrace(lines, line_count);
   bool changed = (!had_prior_file || prior_text != next_text);

   string stable_sig = AFS_BuildStableTextSignature(lines, line_count);
   if(g_lastFinalOutputSignature == stable_sig &&
      g_lastFinalWriteAt > 0 &&
      (now - g_lastFinalWriteAt) < AFS_FinalOutputHeartbeatSeconds())
     {
      AFS_TracePublication("FINAL_OUTPUT",
                           final_file,
                           "skip_heartbeat",
                           true,
                           "prior_exists=" + AFS_BoolText(had_prior_file) +
                           " | changed=" + AFS_BoolText(changed));
      return true;
     }

   string err = "";
   if(!AFS_WritePlainTextFile(final_file,
                              g_state.PathState.UseCommonFiles,
                              lines,
                              line_count,
                              err))
     {
      AFS_TracePublication("FINAL_OUTPUT",
                           final_file,
                           "write",
                           false,
                           "prior_exists=" + AFS_BoolText(had_prior_file) +
                           " | changed=" + AFS_BoolText(changed) +
                           " | detail=" + AFS_OutputSafeText(err, "-"));
      g_state.LastWarning = err;
      AFS_LogWarn(err);
      return false;
     }

   AFS_TracePublication("FINAL_OUTPUT",
                        final_file,
                        "write",
                        true,
                        "prior_exists=" + AFS_BoolText(had_prior_file) +
                        " | changed=" + AFS_BoolText(changed) +
                        " | finalists=" + IntegerToString(g_state.MemoryShell.FinalistCount));
   g_lastFinalOutputSignature = stable_sig;
   g_lastFinalWriteAt         = now;
   return true;
  }

bool AFS_RecordInActiveScope(const AFS_UniverseSymbol &rec)
  {
   if(!rec.TradeAllowed)
      return false;
   if(ScanSelectedScopeOnly)
      return rec.ScopeIncluded;
   return true;
  }

string AFS_SurfaceCoverageText()
  {
   return IntegerToString(g_state.MemoryShell.SurfaceCount) + "/" +
          IntegerToString(g_state.MemoryShell.UniverseCount);
  }

string AFS_SurfaceLoadedCoverageText()
  {
   return IntegerToString(g_state.MemoryShell.SurfaceLoadedCount) + "/" +
          IntegerToString(g_state.MemoryShell.LoadedUniverseCount);
  }

string AFS_RunStartedText()
  {
   return AFS_FormatTime(g_state.MemoryShell.CreatedAt);
  }

string AFS_GetStepActiveCsvFile()
  {
   if(AFS_GetStepNumber() >= 12.0)
      return "top5_by_bucket.csv";
   if(AFS_GetStepNumber() >= 3.0)
      return "universe_broker_view.csv";
   return "scanner_state.csv";
  }

void AFS_SyncActiveCsvRoute()
  {
   if(!g_state.PathState.Ready)
      return;
   g_state.PathState.ActiveCsvFile = g_state.PathState.ActiveModeFolder + "\\" + AFS_GetStepActiveCsvFile();
  }

string AFS_SurfaceHealthSummary()
  {
   return "Scope " + AFS_SurfaceCoverageText() +
          " | F " + IntegerToString(g_state.MemoryShell.SurfaceFreshCount) +
          " S " + IntegerToString(g_state.MemoryShell.SurfaceStaleCount) +
          " NQ " + IntegerToString(g_state.MemoryShell.SurfaceNoQuoteCount);
  }

string AFS_SurfaceFreshnessText()
  {
   if(g_state.MemoryShell.LastSurfaceAt <= 0)
      return "No surface updates";
   return "Last " + AFS_FormatTime(g_state.MemoryShell.LastSurfaceAt) +
          " | Full " + AFS_FormatTime(g_state.MemoryShell.LastFullSurfaceAt) +
          " | Passes " + IntegerToString(g_state.MemoryShell.SurfacePassCount) +
          " | Batch " + AFS_FormatSurfaceBatchState();
  }

void AFS_RecalculateSurfaceDiagnostics()
  {
   int surfaced_scope   = 0;
   int surfaced_loaded  = 0;
   int fresh            = 0;
   int stale            = 0;
   int no_quote         = 0;
   int promoted         = 0;
   int first_seen       = 0;

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[i];

      if(rec.SurfaceSeen)
         surfaced_loaded++;

      if(!AFS_RecordInActiveScope(rec))
         continue;

      if(rec.SurfaceSeen)
         surfaced_scope++;

      if(rec.QuotePresent)
        {
         if(rec.TickAgeSec >= 0 && rec.TickAgeSec <= 60)
            fresh++;
         else if(rec.TickAgeSec > 60)
            stale++;
        }
      else if(rec.SurfaceSeen)
        {
         no_quote++;
        }

      if(rec.PromotionCandidate)
         promoted++;
      if(rec.SurfaceSeen && rec.SurfaceUpdateCount <= 1)
         first_seen++;
     }

   g_state.MemoryShell.SurfaceCount          = surfaced_scope;
   g_state.MemoryShell.SurfaceLoadedCount    = surfaced_loaded;
   g_state.MemoryShell.SurfaceFreshCount     = fresh;
   g_state.MemoryShell.SurfaceStaleCount     = stale;
   g_state.MemoryShell.SurfaceNoQuoteCount   = no_quote;
   g_state.MemoryShell.SurfacePromotedCount  = promoted;
   g_state.MemoryShell.SurfaceFirstSeenCount = first_seen;
  }

void AFS_ResetStep5Runtime(const string reason)
  {
   for(int i = 0; i < ArraySize(g_state.Universe); i++)
      AFS_MC_ResetSurfaceState(g_state.Universe[i]);

   g_state.MemoryShell.LastSurfaceAt          = 0;
   g_state.MemoryShell.LastFullSurfaceAt      = 0;
   g_state.MemoryShell.LastSurfaceResetAt     = TimeCurrent();
   g_state.MemoryShell.SurfaceCursor          = 0;
   g_state.MemoryShell.SurfaceLastBatchCount  = 0;
   g_state.MemoryShell.SurfacePassCount       = 0;
   g_state.MemoryShell.SurfaceCount           = 0;
   g_state.MemoryShell.SurfaceFreshCount      = 0;
   g_state.MemoryShell.SurfaceStaleCount      = 0;
   g_state.MemoryShell.SurfaceNoQuoteCount    = 0;
   g_state.MemoryShell.SurfacePromotedCount   = 0;
   g_state.MemoryShell.SurfaceFirstSeenCount  = 0;
   g_state.MemoryShell.LastSurfaceResetReason = reason;
   g_surfaceArtifactsDirty = true;
  }


double AFS_GetStepNumber()
  {
   string s = CurrentStepTag;

   if(StringFind(s, "1.2") >= 0) return 1.2;
   if(StringFind(s, "14")  >= 0) return 14.0;
   if(StringFind(s, "13")  >= 0) return 13.0;
   if(StringFind(s, "12")  >= 0) return 12.0;
   if(StringFind(s, "11")  >= 0) return 11.0;
   if(StringFind(s, "10")  >= 0) return 10.0;
   if(StringFind(s, "9")   >= 0) return 9.0;
   if(StringFind(s, "8")   >= 0) return 8.0;
   if(StringFind(s, "7")   >= 0) return 7.0;
   if(StringFind(s, "6")   >= 0) return 6.0;
   if(StringFind(s, "5")   >= 0) return 5.0;
   if(StringFind(s, "4")   >= 0) return 4.0;
   if(StringFind(s, "3")   >= 0) return 3.0;
   if(StringFind(s, "2")   >= 0) return 2.0;
   if(StringFind(s, "1")   >= 0) return 1.0;

   return 0.0;
  }

void AFS_GetChartSize(int &w,int &h)
  {
   w = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   h = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);

   if(w < 200)
      w = PanelWidthPx;
   if(h < 200)
      h = PanelHeightPx;
  }

void AFS_UpdateChartSizeCache()
  {
   AFS_GetChartSize(g_chartWidthPx, g_chartHeightPx);
  }

void AFS_DeleteOwnedObjects()
  {
   int total = ObjectsTotal(0);
   for(int i = total - 1; i >= 0; i--)
     {
      string name = ObjectName(0, i);
      if(StringFind(name, AFS_OBJ_PREFIX) == 0)
         ObjectDelete(0, name);
     }
  }

void AFS_ClearChartObjects()
  {
   ObjectsDeleteAll(0, -1, -1);
  }

void AFS_PrepareScannerChart(const bool clear_objects=false)
  {
   if(!OwnChartDomain)
      return;

   ChartSetInteger(0, CHART_SHOW_GRID, false);
   ChartSetInteger(0, CHART_SHOW_OHLC, false);
   ChartSetInteger(0, CHART_SHOW_BID_LINE, false);
   ChartSetInteger(0, CHART_SHOW_ASK_LINE, false);
   ChartSetInteger(0, CHART_SHOW_LAST_LINE, false);
   ChartSetInteger(0, CHART_SHOW_VOLUMES, false);
   ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, false);
   ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, false);
   ChartSetInteger(0, CHART_AUTOSCROLL, false);
   ChartSetInteger(0, CHART_SHIFT, false);
   ChartSetInteger(0, CHART_SCALEFIX, true);

   ChartSetInteger(0, CHART_COLOR_BACKGROUND, AFS_CLR_BG);
   ChartSetInteger(0, CHART_COLOR_FOREGROUND, AFS_CLR_BG);
   ChartSetInteger(0, CHART_COLOR_GRID, AFS_CLR_BG);
   ChartSetInteger(0, CHART_COLOR_CHART_UP, AFS_CLR_BG);
   ChartSetInteger(0, CHART_COLOR_CHART_DOWN, AFS_CLR_BG);
   ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, AFS_CLR_BG);
   ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, AFS_CLR_BG);
   ChartSetInteger(0, CHART_COLOR_BID, AFS_CLR_BG);
   ChartSetInteger(0, CHART_COLOR_ASK, AFS_CLR_BG);
   ChartSetInteger(0, CHART_MODE, CHART_LINE);

   // --- FIX: do not suppress full chart domain visibility during HUD life ---
   ChartSetInteger(0, CHART_SHOW, true);

   // --- FIX: only allow destructive chart clearing during true init path ---
   if(clear_objects && ClearAllChartObjectsOnInit)
      AFS_ClearChartObjects();
  }

color AFS_StateColor(const AFS_ModuleStateCode state)
  {
   switch(state)
     {
      case MODULE_OK:      return AFS_CLR_OK;
      case MODULE_WARN:    return AFS_CLR_WARN;
      case MODULE_FAIL:    return AFS_CLR_FAIL;
      case MODULE_READY:   return AFS_CLR_ACCENT;
      case MODULE_RUNNING: return AFS_CLR_ACCENT;
      case MODULE_IDLE:    return AFS_CLR_TEXT_DIM;
     }
   return AFS_CLR_TEXT;
  }

color AFS_StatusColorFromMessage(const string txt,const bool is_error)
  {
   if(StringLen(txt) == 0)
      return AFS_CLR_TEXT_DIM;
   return is_error ? AFS_CLR_FAIL : AFS_CLR_WARN;
  }

bool AFS_CreateRectLabel(const string name,const int x,const int y,const int w,const int h,const color bg,const color border)
  {
   if(ObjectFind(0, name) < 0)
     {
      if(!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
         return false;
     }

   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_CORNER, HudCorner);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_XDISTANCE, x);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_YDISTANCE, y);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_XSIZE, w);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_YSIZE, h);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_BGCOLOR, bg);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_BORDER_COLOR, border);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_COLOR, border);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_SELECTABLE, false);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_SELECTED, false);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_HIDDEN, true);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_BACK, false);
   return true;
  }

bool AFS_CreateLabel(const string name,const int x,const int y,const string text,const int size,const color clr,const string font="Consolas")
  {
   if(ObjectFind(0, name) < 0)
     {
      if(!ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0))
         return false;
     }

   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_CORNER, HudCorner);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_XDISTANCE, x);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_YDISTANCE, y);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_FONTSIZE, size);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_COLOR, clr);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_SELECTABLE, false);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_SELECTED, false);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_HIDDEN, true);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_BACK, false);
   AFS_ObjectSetStringIfChanged(name, OBJPROP_FONT, font);
   AFS_ObjectSetStringIfChanged(name, OBJPROP_TEXT, text);
   return true;
  }

int AFS_FontTitle()
  {
   if(g_state.ActiveHUDProfile == HUD_COMPACT)
      return 10;
   return 10;
  }

bool AFS_CreateButton(const string name,const int x,const int y,const int w,const int h,const string text,const color bg,const color border,const color txt)
  {
   bool created_now = false;

   if(ObjectFind(0, name) < 0)
     {
      if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0))
         return false;
      created_now = true;
     }

   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_CORNER, HudCorner);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_XDISTANCE, x);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_YDISTANCE, y);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_XSIZE, w);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_YSIZE, h);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_BGCOLOR, bg);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_BORDER_COLOR, border);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_COLOR, txt);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_HIDDEN, true);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_BACK, false);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_SELECTABLE, true);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_SELECTED, false);
   AFS_ObjectSetIntegerIfChanged(name, OBJPROP_ZORDER, 100);
   AFS_ObjectSetStringIfChanged(name, OBJPROP_FONT, "Consolas");
   AFS_ObjectSetStringIfChanged(name, OBJPROP_TEXT, text);

   if(created_now)
      ObjectSetInteger(0, name, OBJPROP_STATE, false);

   return true;
  }
  
int AFS_FontLabel()
  {
   return 9;
  }

int AFS_FontValue()
  {
   return 9;
  }

int AFS_FontBadge()
  {
   return 8;
  }

int AFS_FontHeaderTitle()
  {
   return 16;
  }

int AFS_FontHeaderSub()
  {
   return 9;
  }
  
int AFS_RowStep()
  {
   return 19;
  }

int AFS_SectionBodyStart()
  {
   return 38;
  }

int AFS_SectionTopPad()
  {
   return 12;
  }

int AFS_SectionBottomPad()
  {
   return 14;
  }

int AFS_SectionHeight(const int row_count)
  {
   return AFS_SectionBodyStart() + (row_count * AFS_RowStep()) + AFS_SectionBottomPad();
  }

int AFS_NotesRowCount()
  {
   return 3;
  }

int AFS_NotesHeight()
  {
   return AFS_SectionHeight(AFS_NotesRowCount());
  }

int AFS_DebugFooterHeight()
  {
   return 26;
  }

int AFS_BlockGap()
  {
   return 14;
  }

int AFS_ModuleRowStep()
  {
   return 22;
  }

int AFS_KeyWidthMain()
  {
   return 160;
  }

int AFS_KeyWidthWide()
  {
   return 180;
  }

int AFS_KeyWidthSched()
  {
   return 170;
  }

int AFS_RailButtonHeight()
  {
   return 34;
  }

int AFS_RailButtonStep()
  {
   return 42;
  }

string AFS_OnOffText(const bool v)
  {
   return v ? "yes" : "no";
  }

string AFS_GetRouteLeaf()
  {
   if(g_state.EffectiveMode == MODE_TRADER)
      return "trader";
   return "dev";
  }

string AFS_GetSummaryLeaf()
  {
   return "scanner_summary.txt";
  }

string AFS_GetUniverseStateText()
  {
   if(AFS_GetStepNumber() < 3.0)
      return "Pending";
   return (g_state.MemoryShell.UniverseCount > 0
           ? "Loaded (" + IntegerToString(g_state.MemoryShell.UniverseCount) + ")"
           : "Loaded (0)");
  }

string AFS_GetSurfaceStateText()
  {
   if(AFS_GetStepNumber() < 5.0)
      return "Pending";
   if(g_state.MemoryShell.SurfaceCount > 0 || g_state.MemoryShell.SurfaceLoadedCount > 0)
      return AFS_SurfaceHealthSummary() + " | Loaded " + AFS_SurfaceLoadedCoverageText();
   if(g_state.MemoryShell.UniverseCount > 0)
      return "Armed";
   return "Idle";
  }

string AFS_GetSelectionStateText()
  {
   if(AFS_GetStepNumber() < 9.0)
      return "Pending";
   if(g_state.MemoryShell.FinalistCount > 0)
      return "Active (" + IntegerToString(g_state.MemoryShell.FinalistCount) + ")";
   if(g_state.MemoryShell.FrictionPassCount > 0 || g_state.MemoryShell.FrictionWeakCount > 0)
      return "Armed";
   return "Idle";
  }

void AFS_DrawSectionTitle(const string id,const int x,const int y,const string txt)
  {
   AFS_CreateLabel(AFS_ObjName(id+"_TITLE"), x+2, y+2, txt, AFS_FontTitle(), AFS_CLR_ACCENT);
  }

void AFS_DrawKeyValueRow(const string id,
                         const int x,
                         const int y,
                         const int key_w,
                         const string key,
                         const string value,
                         const color value_clr,
                         const int value_max_chars=80)
  {
   int pad = 6;

   int key_x   = x + pad;
   int value_x = x + key_w + 24;

   AFS_CreateLabel(AFS_ObjName(id+"_K"),
                   key_x,
                   y + 2,
                   key,
                   AFS_FontLabel(),
                   AFS_CLR_TEXT_DIM);

   string clipped = AFS_ClipText(value, value_max_chars);

   AFS_CreateLabel(AFS_ObjName(id+"_V1"),
                   value_x,
                   y + 2,
                   clipped,
                   AFS_FontValue(),
                   value_clr);

   string stale_v2 = AFS_ObjName(id+"_V2");
   if(ObjectFind(0, stale_v2) >= 0)
      ObjectDelete(0, stale_v2);
  }

int AFS_FindWrapSplitPos(const string value,const int preferred_chars,const int min_window=14)
  {
   int len = StringLen(value);
   if(len <= preferred_chars)
      return len;

   int start = preferred_chars;
   int floor = preferred_chars - min_window;
   if(floor < 8)
      floor = 8;

   for(int i = start; i >= floor; i--)
     {
      string ch = StringSubstr(value, i, 1);
      if(ch == " " || ch == "|" || ch == "," || ch == ";" || ch == "/" || ch == "-")
         return i + 1;
     }

   return preferred_chars;
  }

void AFS_DrawWrappedKeyValueRow(const string id,
                                const int x,
                                const int y,
                                const int key_w,
                                const string key,
                                const string value,
                                const color value_clr,
                                const int first_line_chars=42,
                                const int second_line_chars=56)
  {
   int pad = 6;

   int key_x   = x + pad;
   int value_x = x + key_w + 24;

   AFS_CreateLabel(AFS_ObjName(id+"_K"),
                   key_x,
                   y + 2,
                   key,
                   AFS_FontLabel(),
                   AFS_CLR_TEXT_DIM);

   string line1 = value;
   string line2 = "";

   if(StringLen(value) > first_line_chars)
     {
      int split = AFS_FindWrapSplitPos(value, first_line_chars);
      line1 = StringSubstr(value, 0, split);
      line2 = StringSubstr(value, split);
      StringTrimLeft(line1);
      StringTrimRight(line1);
      StringTrimLeft(line2);
      StringTrimRight(line2);
      line2 = AFS_ClipText(line2, second_line_chars);
     }

   line1 = AFS_ClipText(line1, first_line_chars);

   AFS_CreateLabel(AFS_ObjName(id+"_V1"),
                   value_x,
                   y + 2,
                   line1,
                   AFS_FontValue(),
                   value_clr);

   string v2 = AFS_ObjName(id+"_V2");
   if(StringLen(line2) > 0)
     {
      AFS_CreateLabel(v2,
                      value_x,
                      y + 18,
                      line2,
                      AFS_FontLabel(),
                      value_clr);
     }
   else if(ObjectFind(0, v2) >= 0)
      ObjectDelete(0, v2);
  }

string AFS_PrettyModuleName(const string name)
  {
   if(name == "Classification")
      return "Classification";
   if(name == "MarketCore")
      return "Market Core";
   if(name == "HistoryFriction")
      return "History";
   if(name == "Selection")
      return "Selection";
   if(name == "OutputDebug")
      return "Output / Debug";
   return name;
  }

void AFS_DrawModuleRow(const string id,const int x,const int y,const AFS_ModuleState &m,const int detail_chars)
  {
   string label = AFS_PrettyModuleName(m.Name);
   AFS_CreateLabel(AFS_ObjName(id+"_NAME"),   x, y, AFS_ClipText(label, 18), AFS_FontValue(), AFS_CLR_TEXT);
   AFS_CreateLabel(AFS_ObjName(id+"_STATE"),  x + 128, y, AFS_ModuleStateToText(m.State), AFS_FontValue(), AFS_StateColor(m.State));
   AFS_CreateLabel(AFS_ObjName(id+"_DETAIL"), x + 208, y, AFS_ClipText(m.Detail, detail_chars), AFS_FontLabel(), AFS_CLR_TEXT_DIM);
  }

void AFS_DrawBadge(const string id,const int x,const int y,const int w,const int h,const string txt,const color bg,const color border,const color txt_clr)
  {
   AFS_CreateRectLabel(AFS_ObjName(id+"_BG"), x, y, w, h, bg, border);
   AFS_CreateLabel(AFS_ObjName(id+"_TX"), x + 8, y + 4, txt, AFS_FontBadge(), txt_clr);
  }

string AFS_GetLayoutSignature()
  {
   return
      IntegerToString((int)g_state.EffectiveMode) + "|" +
      IntegerToString((int)g_state.ActiveHUDProfile) + "|" +
      AFS_BoolText(g_state.ViewShowNotes) + "|" +
      AFS_BoolText(g_state.ViewShowModules) + "|" +
      AFS_BoolText(g_state.ViewShowScheduling) + "|" +
      AFS_BoolText(g_state.ViewShowScope) + "|" +
      AFS_BoolText(g_state.ViewShowDebugFooter) + "|" +
      AFS_BoolText(g_state.ViewShowControlRail) + "|" +
      AFS_BoolText(ShowHUD) + "|" +
      AFS_BoolText(Phase1Complete);
  }

void AFS_ResetUniverse()
  {
   ArrayResize(g_state.Universe, 0);

   g_state.UniverseRawFile          = "";
   g_state.UniverseBrokerViewFile   = "";
   g_state.ClassificationReviewFile = "";

   g_state.MemoryShell.BrokerSymbolCount           = 0;
   g_state.MemoryShell.LoadedUniverseCount         = 0;
   g_state.MemoryShell.EligibleSymbolCount         = 0;
   g_state.MemoryShell.UniverseCount               = 0;
   g_state.MemoryShell.ClassifiedSymbolCount       = 0;
   g_state.MemoryShell.UnresolvedSymbolCount       = 0;
   g_state.MemoryShell.ExchangeCoverageCount       = 0;
   g_state.MemoryShell.ISINCoverageCount           = 0;
   g_state.MemoryShell.BrokerSectorCoverageCount   = 0;
   g_state.MemoryShell.BrokerIndustryCoverageCount = 0;
   g_state.MemoryShell.BrokerClassCoverageCount    = 0;

   g_state.MemoryShell.SurfaceCount          = 0;
   g_state.MemoryShell.SurfaceLoadedCount    = 0;
   g_state.MemoryShell.SurfaceFreshCount     = 0;
   g_state.MemoryShell.SurfaceStaleCount     = 0;
   g_state.MemoryShell.SurfaceNoQuoteCount   = 0;
   g_state.MemoryShell.SurfacePromotedCount  = 0;
   g_state.MemoryShell.SurfaceFirstSeenCount = 0;

   g_state.MemoryShell.SpecCount      = 0;
   g_state.MemoryShell.SpecPassCount  = 0;
   g_state.MemoryShell.SpecWeakCount  = 0;
   g_state.MemoryShell.SpecFailCount  = 0;
   g_state.MemoryShell.SpecCursor     = 0;

   g_state.MemoryShell.HistoryCount     = 0;
   g_state.MemoryShell.HistoryPassCount = 0;
   g_state.MemoryShell.HistoryWeakCount = 0;
   g_state.MemoryShell.HistoryFailCount = 0;
   g_state.MemoryShell.HistoryCursor    = 0;

   g_specCursor    = 0;
   g_historyCursor = 0;
  }

int AFS_FindUniverseRecordIndex(const AFS_UniverseSymbol &records[],const string symbol)
  {
   for(int i = 0; i < ArraySize(records); i++)
      if(records[i].Symbol == symbol)
         return i;
   return -1;
  }

void AFS_CopyUniverseArray(AFS_UniverseSymbol &dst[],const AFS_UniverseSymbol &src[])
  {
   int count = ArraySize(src);
   ArrayResize(dst, count);

   for(int i = 0; i < count; i++)
      dst[i] = src[i];
  }
  
void AFS_CopyCarryForwardRuntime(AFS_UniverseSymbol &dst,const AFS_UniverseSymbol &src)
  {
   dst.SurfaceSeen           = src.SurfaceSeen;
   dst.QuotePresent          = src.QuotePresent;
   dst.PromotionCandidate    = src.PromotionCandidate;
   dst.LastTickTime          = src.LastTickTime;
   dst.LastSurfaceUpdateAt   = src.LastSurfaceUpdateAt;
   dst.LastSpecUpdateAt      = src.LastSpecUpdateAt;
   dst.LastHistoryUpdateAt   = src.LastHistoryUpdateAt;
   dst.LastFrictionUpdateAt  = src.LastFrictionUpdateAt;
   dst.TickAgeSec            = src.TickAgeSec;
   dst.SpecUpdateCount       = src.SpecUpdateCount;
   dst.SurfaceUpdateCount    = src.SurfaceUpdateCount;
   dst.HistoryUpdateCount    = src.HistoryUpdateCount;
   dst.FrictionUpdateCount   = src.FrictionUpdateCount;
   dst.FrictionSampleCountUsed = src.FrictionSampleCountUsed;
   dst.BarsM15               = src.BarsM15;
   dst.BarsH1                = src.BarsH1;

   dst.Bid                   = src.Bid;
   dst.Ask                   = src.Ask;
   dst.SpreadSnapshot        = src.SpreadSnapshot;
   dst.SessionHigh           = src.SessionHigh;
   dst.SessionLow            = src.SessionLow;
   dst.SessionOpen           = src.SessionOpen;
   dst.SessionClose          = src.SessionClose;
   dst.BidHigh               = src.BidHigh;
   dst.BidLow                = src.BidLow;
   dst.AskHigh               = src.AskHigh;
   dst.AskLow                = src.AskLow;
   dst.DailyChangePercent    = src.DailyChangePercent;

   dst.TickValueRaw          = src.TickValueRaw;
   dst.TickValueDerived      = src.TickValueDerived;
   dst.TickValueValidated    = src.TickValueValidated;
   dst.MarginHedged          = src.MarginHedged;
   dst.CommissionValue       = src.CommissionValue;
   dst.AtrM15                = src.AtrM15;
   dst.AtrH1                 = src.AtrH1;
   dst.BaselineMove          = src.BaselineMove;
   dst.MovementCapacityScore = src.MovementCapacityScore;
   dst.MedianSpread          = src.MedianSpread;
   dst.MaxSpread             = src.MaxSpread;
   dst.SpreadAtrRatio        = src.SpreadAtrRatio;
   dst.LivelinessScore       = src.LivelinessScore;
   dst.FreshnessScore        = src.FreshnessScore;
   dst.SpreadSampleWritePos  = src.SpreadSampleWritePos;
   dst.SpreadSampleCount     = src.SpreadSampleCount;
   ArrayCopy(dst.SpreadSampleRing, src.SpreadSampleRing);
   ArrayCopy(dst.SpreadSampleTimeRing, src.SpreadSampleTimeRing);

   dst.CommissionMode        = src.CommissionMode;
   dst.CommissionCurrency    = src.CommissionCurrency;
   dst.CommissionStatus      = src.CommissionStatus;
   dst.SpecIntegrityStatus   = src.SpecIntegrityStatus;
   dst.EconomicsTrust        = src.EconomicsTrust;
   dst.NormalizationStatus   = src.NormalizationStatus;
   dst.PracticalityStatus    = src.PracticalityStatus;
   dst.EconomicsFlags        = src.EconomicsFlags;

   dst.QuoteState            = src.QuoteState;
   dst.SessionState          = src.SessionState;
   dst.SurfaceFlags          = src.SurfaceFlags;
   dst.PromotionState        = src.PromotionState;
   dst.PromotionReason       = src.PromotionReason;
   dst.HistoryStatus         = src.HistoryStatus;
   dst.HistoryFlags          = src.HistoryFlags;
   dst.FrictionStatus        = src.FrictionStatus;
   dst.FrictionFlags         = src.FrictionFlags;
   dst.FrictionTruthState    = src.FrictionTruthState;
   dst.FrictionFailReason    = src.FrictionFailReason;
   dst.FrictionWeakReason    = src.FrictionWeakReason;
   dst.FrictionHydrationStage= src.FrictionHydrationStage;
   dst.FrictionHoldPass      = src.FrictionHoldPass;
   dst.FrictionMarketLive    = src.FrictionMarketLive;
   dst.FrictionSessionOpen   = src.FrictionSessionOpen;
   dst.FrictionQuoteUsable   = src.FrictionQuoteUsable;
   dst.FrictionHydrationScore= src.FrictionHydrationScore;
   dst.FrictionGoodPasses    = src.FrictionGoodPasses;
   dst.FrictionBadPasses     = src.FrictionBadPasses;
   dst.LastTradableEvidenceAt= src.LastTradableEvidenceAt;
   dst.LastAliveEvidenceAt   = src.LastAliveEvidenceAt;
   dst.CostEfficiencyScore   = src.CostEfficiencyScore;
   dst.TrustScore            = src.TrustScore;
   dst.TotalScore            = src.TotalScore;
   dst.BucketRank            = src.BucketRank;
   dst.FinalistSelected      = src.FinalistSelected;
   dst.LastRankingUpdateAt   = src.LastRankingUpdateAt;
  }


string AFS_GetStep8WarmStateFile()
  {
   if(!g_state.PathState.Ready)
      return "";
   return g_state.PathState.DevFolder + "\\warm_state\\step8_warm_state.csv";
  }

bool AFS_SaveStep8WarmState()
  {
   if(AFS_GetStepNumber() < 8.0 || !g_state.PathState.Ready)
      return true;

   string rel_file = AFS_GetStep8WarmStateFile();
   if(StringLen(rel_file) == 0)
      return false;

   int flags = FILE_WRITE | FILE_CSV | FILE_ANSI;
   if(g_state.PathState.UseCommonFiles)
      flags |= FILE_COMMON;

   ResetLastError();
   int h = FileOpen(rel_file, flags, ',');
   if(h == INVALID_HANDLE)
     {
      string err = "Step8 warm-state save failed: " + rel_file +
                   " | LastError=" + IntegerToString(GetLastError());
      g_state.LastWarning = err;
      AFS_LogWarn(err);
      return false;
     }

   FileWrite(h,
             "Symbol","SavedAt","FrictionStatus","FrictionTruthState",
             "FrictionHydrationScore","FrictionGoodPasses","FrictionBadPasses",
             "LastTradableEvidenceAt","LastAliveEvidenceAt",
             "FrictionSampleCountUsed","MedianSpread","MaxSpread","SpreadAtrRatio",
             "LivelinessScore","FreshnessScore","FrictionHoldPass",
             "FrictionWeakReason","FrictionFailReason","FrictionHydrationStage");

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[i];
      if(rec.FrictionUpdateCount <= 0 && rec.FrictionHydrationScore <= 0)
         continue;

      FileWrite(h,
                rec.Symbol,
                IntegerToString((int)TimeCurrent()),
                rec.FrictionStatus,
                rec.FrictionTruthState,
                IntegerToString(rec.FrictionHydrationScore),
                IntegerToString(rec.FrictionGoodPasses),
                IntegerToString(rec.FrictionBadPasses),
                IntegerToString((int)rec.LastTradableEvidenceAt),
                IntegerToString((int)rec.LastAliveEvidenceAt),
                IntegerToString(rec.FrictionSampleCountUsed),
                DoubleToString(rec.MedianSpread, 8),
                DoubleToString(rec.MaxSpread, 8),
                DoubleToString(rec.SpreadAtrRatio, 8),
                DoubleToString(rec.LivelinessScore, 4),
                DoubleToString(rec.FreshnessScore, 4),
                (rec.FrictionHoldPass ? "1" : "0"),
                rec.FrictionWeakReason,
                rec.FrictionFailReason,
                rec.FrictionHydrationStage);
     }

   FileClose(h);
   return true;
  }

bool AFS_LoadStep8WarmState()
  {
   if(AFS_GetStepNumber() < 8.0 || !g_state.PathState.Ready)
      return true;

   string rel_file = AFS_GetStep8WarmStateFile();
   if(StringLen(rel_file) == 0)
      return true;

   int flags = FILE_READ | FILE_CSV | FILE_ANSI;
   if(g_state.PathState.UseCommonFiles)
      flags |= FILE_COMMON;

   ResetLastError();
   int h = FileOpen(rel_file, flags, ',');
   if(h == INVALID_HANDLE)
      return true;

   if(!FileIsEnding(h))
     {
      for(int skip = 0; skip < 19 && !FileIsEnding(h); skip++)
         FileReadString(h);
     }

   datetime now = g_state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   int loaded = 0;
   int warm_max_age = 43200;
   int pass_hold_age = MathMax(900, MaxTickAge * 6);

   while(!FileIsEnding(h))
     {
      string symbol = FileReadString(h);
      if(FileIsEnding(h) && StringLen(symbol) == 0)
         break;

      string saved_at_text         = FileReadString(h);
      string status_text           = FileReadString(h);
      string truth_text            = FileReadString(h);
      string hydration_text        = FileReadString(h);
      string good_text             = FileReadString(h);
      string bad_text              = FileReadString(h);
      string last_good_text        = FileReadString(h);
      string last_alive_text       = FileReadString(h);
      string sample_text           = FileReadString(h);
      string median_text           = FileReadString(h);
      string max_text              = FileReadString(h);
      string ratio_text            = FileReadString(h);
      string lively_text           = FileReadString(h);
      string fresh_text            = FileReadString(h);
      string hold_text             = FileReadString(h);
      string weak_reason_text      = FileReadString(h);
      string fail_reason_text      = FileReadString(h);
      string stage_text            = FileReadString(h);

      int idx = AFS_FindUniverseRecordIndex(g_state.Universe, symbol);
      if(idx < 0)
         continue;

      datetime saved_at = (datetime)StringToInteger(saved_at_text);
      if(saved_at <= 0)
         continue;

      int age = (int)MathMax(0, (long)(now - saved_at));
      if(age > warm_max_age)
         continue;

      g_state.Universe[idx].FrictionStatus          = status_text;
      g_state.Universe[idx].FrictionTruthState      = truth_text;
      g_state.Universe[idx].FrictionHydrationScore  = (int)StringToInteger(hydration_text);
      g_state.Universe[idx].FrictionGoodPasses      = (int)StringToInteger(good_text);
      g_state.Universe[idx].FrictionBadPasses       = (int)StringToInteger(bad_text);
      g_state.Universe[idx].LastTradableEvidenceAt  = (datetime)StringToInteger(last_good_text);
      g_state.Universe[idx].LastAliveEvidenceAt     = (datetime)StringToInteger(last_alive_text);
      g_state.Universe[idx].FrictionSampleCountUsed = (int)StringToInteger(sample_text);
      g_state.Universe[idx].MedianSpread            = StringToDouble(median_text);
      g_state.Universe[idx].MaxSpread               = StringToDouble(max_text);
      g_state.Universe[idx].SpreadAtrRatio          = StringToDouble(ratio_text);
      g_state.Universe[idx].LivelinessScore         = StringToDouble(lively_text);
      g_state.Universe[idx].FreshnessScore          = StringToDouble(fresh_text);
      g_state.Universe[idx].FrictionHoldPass        = (StringToInteger(hold_text) != 0);
      g_state.Universe[idx].FrictionWeakReason      = weak_reason_text;
      g_state.Universe[idx].FrictionFailReason      = fail_reason_text;
      g_state.Universe[idx].FrictionHydrationStage  = stage_text;
      g_state.Universe[idx].FrictionMarketLive      = (truth_text == "ACTIVE_MARKET" || truth_text == "QUIET_ALIVE" || truth_text == "THIN_BUILDING");
      g_state.Universe[idx].FrictionSessionOpen     = (g_state.Universe[idx].SessionState != "SESSION_REF_NO_QUOTE");
      g_state.Universe[idx].FrictionQuoteUsable     = (g_state.Universe[idx].QuotePresent && g_state.Universe[idx].Bid > 0.0 && g_state.Universe[idx].Ask > 0.0 && g_state.Universe[idx].Ask >= g_state.Universe[idx].Bid);
      g_state.Universe[idx].LastFrictionUpdateAt    = saved_at;
      if(g_state.Universe[idx].FrictionUpdateCount <= 0)
         g_state.Universe[idx].FrictionUpdateCount = 1;

      if(g_state.Universe[idx].FrictionStatus == "PASS" && age > pass_hold_age)
        {
         g_state.Universe[idx].FrictionStatus         = "WEAK";
         g_state.Universe[idx].FrictionHoldPass       = true;
         g_state.Universe[idx].FrictionHydrationStage = "HELD";
         if(StringLen(g_state.Universe[idx].FrictionWeakReason) == 0)
            g_state.Universe[idx].FrictionWeakReason = "WARM_RECHECK";
        }

      loaded++;
     }

   FileClose(h);

   if(loaded > 0)
     {
      AFS_RecalculateFrictionDiagnostics();
      g_surfaceArtifactsDirty = true;
      AFS_Log("Phase 1 Step 8 warm state restored: " + IntegerToString(loaded));
     }

   return true;
  }


void AFS_RefreshOutputRoute()
  {
   if(!g_state.PathState.Ready)
      return;

   string previous_route = g_state.PathState.ActiveModeFolder;
   string err = "";

   if(!AFS_OD_SetActiveRoute(g_state.PathState, g_state.EffectiveMode, err))
     {
      g_state.LastWarning = err;
      AFS_LogWarn(err);
      return;
     }

   if(previous_route != g_state.PathState.ActiveModeFolder)
      AFS_Log("Active route set to " + (g_state.EffectiveMode == MODE_TRADER ? "trader" : "dev"));
  }

void AFS_WriteStep2Artifacts()
  {
   if(!WriteStep2SummaryFile || !g_state.PathState.Ready)
      return;

   datetime now = g_state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   if(g_lastStep2SummaryWriteAt > 0 && (now - g_lastStep2SummaryWriteAt) < AFS_Step2SummaryCooldownSeconds())
      return;

   AFS_SyncActiveCsvRoute();

   string err = "";
   if(!AFS_OD_WriteStep2Summary(g_state.PathState,
                                g_state.MemoryShell,
                                g_state.RequestedMode,
                                g_state.EffectiveMode,
                                CurrentPhaseTag,
                                CurrentStepTag,
                                BuildLabel,
                                TimerSeconds,
                                SurfaceBatchSize,
                                AFS_RotationModeToText(RotationMode),
                                AFS_SurfaceUpdatePolicyToText(SurfaceUpdatePolicy),
                                AFS_FormatSurfaceBatchState(),
                                err))
     {
      g_state.LastWarning = err;
      AFS_LogWarn(err);
      return;
     }

   g_lastStep2SummaryWriteAt = now;
   AFS_Debug("Summary updated: " + g_state.PathState.ActiveSummaryFile);
  }

void AFS_ResolveEffectiveMode()
  {
   g_state.ModeForcedToDev = false;
   g_state.LastWarning     = "";

   if(g_state.RequestedMode == MODE_TRADER && !AFS_IsTraderModeUnlocked())
     {
      g_state.EffectiveMode   = MODE_DEV;
      g_state.ModeForcedToDev = true;
      g_state.LastWarning     = "Trader Mode requested before Phase 1 core runtime readiness. Forced to MODE_DEV.";
     }
   else
     {
      g_state.EffectiveMode = g_state.RequestedMode;
     }

   g_state.EffectiveModeText = AFS_ModeToText(g_state.EffectiveMode);
  }

void AFS_ResetStep6Runtime(const string reason)
  {
   for(int i = 0; i < ArraySize(g_state.Universe); i++)
      AFS_MC_ResetSpecState(g_state.Universe[i]);

   g_state.MemoryShell.SpecCount      = 0;
   g_state.MemoryShell.SpecPassCount  = 0;
   g_state.MemoryShell.SpecWeakCount  = 0;
   g_state.MemoryShell.SpecFailCount  = 0;
   g_state.MemoryShell.SpecCursor     = 0;
   g_specCursor                       = 0;
   g_surfaceArtifactsDirty            = true;

   if(StringLen(reason) > 0)
      g_state.LastInfo = "Spec runtime reset: " + reason;
  }

void AFS_ResetStep7Runtime(const string reason)
  {
   for(int i = 0; i < ArraySize(g_state.Universe); i++)
      AFS_HF_ResetHistoryState(g_state.Universe[i]);

   g_state.MemoryShell.HistoryCount     = 0;
   g_state.MemoryShell.HistoryPassCount = 0;
   g_state.MemoryShell.HistoryWeakCount = 0;
   g_state.MemoryShell.HistoryFailCount = 0;
   g_state.MemoryShell.HistoryCursor    = 0;
   g_historyCursor                      = 0;
   g_surfaceArtifactsDirty              = true;

   if(StringLen(reason) > 0)
      g_state.LastInfo = "History runtime reset: " + reason;
  }

void AFS_ResetStep8Runtime(const string reason)
  {
   for(int i = 0; i < ArraySize(g_state.Universe); i++)
      AFS_HF_ResetFrictionState(g_state.Universe[i]);

   g_state.MemoryShell.FrictionCount     = 0;
   g_state.MemoryShell.FrictionPassCount = 0;
   g_state.MemoryShell.FrictionWeakCount = 0;
   g_state.MemoryShell.FrictionFailCount = 0;
   g_state.MemoryShell.FrictionCursor    = 0;
   g_frictionCursor                      = 0;
   g_surfaceArtifactsDirty               = true;

   if(StringLen(reason) > 0)
      g_state.LastInfo = "Friction runtime reset: " + reason;
  }

bool AFS_IsHistoryCandidate(const AFS_UniverseSymbol &rec)
  {
   if(AFS_GetStepNumber() < 7.0)
      return false;
   if(!AFS_RecordInActiveScope(rec))
      return false;
   if(!rec.ClassificationResolved)
      return false;
   if(!rec.TradeAllowed)
      return false;
   if(rec.EconomicsTrust == "FAIL")
      return false;
   if(rec.PromotionCandidate)
      return true;
   if(rec.HistoryUpdateCount <= 0)
      return true;
   if(rec.HistoryStatus == "WEAK" || rec.HistoryStatus == "FAIL" || rec.BaselineMove <= 0.0)
      return true;
   return false;
  }

bool AFS_ShouldRefreshHistoryRecord(const AFS_UniverseSymbol &rec,const datetime now)
  {
   if(rec.LastHistoryUpdateAt <= 0)
      return true;

   int cooldown = MathMax(60, TimerSeconds * 40);
   if(rec.PromotionCandidate)
      cooldown = MathMax(20, TimerSeconds * 15);
   if(rec.HistoryStatus == "WEAK" || rec.HistoryStatus == "FAIL" || rec.BaselineMove <= 0.0)
      cooldown = MathMax(15, TimerSeconds * 8);

   return ((now - rec.LastHistoryUpdateAt) >= cooldown);
  }

void AFS_RecalculateHistoryDiagnostics()
  {
   int touched = 0;
   int pass_ct = 0;
   int weak_ct = 0;
   int fail_ct = 0;

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!AFS_RecordInActiveScope(rec))
         continue;
      if(rec.HistoryUpdateCount <= 0)
         continue;

      touched++;

      if(rec.HistoryStatus == "PASS")
         pass_ct++;
      else if(rec.HistoryStatus == "WEAK")
         weak_ct++;
      else if(rec.HistoryStatus == "FAIL")
         fail_ct++;
     }

   g_state.MemoryShell.HistoryCount     = touched;
   g_state.MemoryShell.HistoryPassCount = pass_ct;
   g_state.MemoryShell.HistoryWeakCount = weak_ct;
   g_state.MemoryShell.HistoryFailCount = fail_ct;
  }

string AFS_GetHistoryStateText()
  {
   if(AFS_GetStepNumber() < 7.0)
      return "Pending";

   return IntegerToString(g_state.MemoryShell.HistoryCount) + "/" +
          IntegerToString(g_state.MemoryShell.UniverseCount) +
          " | P " + IntegerToString(g_state.MemoryShell.HistoryPassCount) +
          " W " + IntegerToString(g_state.MemoryShell.HistoryWeakCount) +
          " F " + IntegerToString(g_state.MemoryShell.HistoryFailCount);
  }

int AFS_DeepScanInspectionBudget(const int total,const int batch)
  {
   if(total <= 0)
      return 0;

   if(batch < 1)
      return MathMin(total, 1);

   if(!AllowAdaptiveTiming)
      return total;

   int factor = 4;
   if(TimerSeconds <= 1)
      factor = 2;
   else if(TimerSeconds <= 2)
      factor = 3;

   if(total >= 800)
      factor = MathMax(2, factor - 1);
   if(total >= 2000)
      factor = 1;

   int budget = batch * factor;
   if(budget < batch)
      budget = batch;
   if(budget > total)
      budget = total;

   int force_full_every = MathMax(8, 120 / MathMax(1, TimerSeconds));
   if((g_state.TimerCount % force_full_every) == 0)
      budget = total;

   return budget;
  }

void AFS_RunHistoryScanCycle()
  {
   if(AFS_GetStepNumber() < 7.0)
      return;

   int total = ArraySize(g_state.Universe);
   if(total <= 0)
      return;

   int batch = DeepBatchSize;
   if(batch < 1)
      batch = 1;
   if(batch > total)
      batch = total;

   int cursor = g_historyCursor;
   if(cursor < 0 || cursor >= total)
      cursor = 0;

   int processed = 0;
   int inspected = 0;
   int inspect_budget = AFS_DeepScanInspectionBudget(total, batch);
   datetime now = g_state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   for(int n = 0; n < inspect_budget && processed < batch; n++)
     {
      if(cursor >= total)
         cursor = 0;

      inspected++;

      if(AFS_IsHistoryCandidate(g_state.Universe[cursor]) &&
         AFS_ShouldRefreshHistoryRecord(g_state.Universe[cursor], now))
        {
         string detail = "";
         AFS_HF_RefreshHistoryRecord(g_state.Universe[cursor],
                                     now,
                                     MinBarsM15,
                                     MinBarsH1,
                                     detail);
         processed++;
        }

      cursor++;
     }

   if(cursor >= total)
      cursor = 0;

   g_historyCursor = cursor;
   g_state.MemoryShell.HistoryCursor = cursor;

   if(processed > 0)
     {
      AFS_RecalculateHistoryDiagnostics();
      g_surfaceArtifactsDirty = true;
      g_state.HistoryFriction.State  = MODULE_OK;
      g_state.HistoryFriction.Detail = "History " + AFS_GetHistoryStateText();
      AFS_DebugSurface("History cycle | Batch=" + IntegerToString(processed) +
                       " | Inspected=" + IntegerToString(inspected) +
                       " / " + IntegerToString(inspect_budget) +
                       " | Cursor=" + IntegerToString(g_historyCursor) +
                       " | History=" + AFS_GetHistoryStateText());
     }
  }
  
bool AFS_IsFrictionCandidate(const AFS_UniverseSymbol &rec)
  {
   if(AFS_GetStepNumber() < 8.0)
      return false;
   if(!AFS_RecordInActiveScope(rec))
      return false;
   if(!rec.ClassificationResolved)
      return false;
   if(!rec.TradeAllowed)
      return false;
   if(rec.EconomicsTrust == "FAIL")
      return false;
   if(rec.HistoryUpdateCount <= 0)
      return false;
   if(rec.PromotionCandidate)
      return true;
   if(rec.FrictionUpdateCount <= 0)
      return true;
   if(rec.FrictionStatus == "WEAK" || rec.FrictionStatus == "FAIL")
      return true;
   if(rec.FreshnessScore < 40.0)
      return true;
   return false;
  }

bool AFS_ShouldRefreshFrictionRecord(const AFS_UniverseSymbol &rec,const datetime now)
  {
   if(rec.LastFrictionUpdateAt <= 0)
      return true;

   int cooldown = MathMax(30, TimerSeconds * 20);
   if(rec.PromotionCandidate)
      cooldown = MathMax(12, TimerSeconds * 8);
   if(rec.FrictionStatus == "WEAK" || rec.FrictionStatus == "FAIL")
      cooldown = MathMax(10, TimerSeconds * 6);
   if(rec.FreshnessScore < 40.0)
      cooldown = MathMax(10, TimerSeconds * 5);

   return ((now - rec.LastFrictionUpdateAt) >= cooldown);
  }

void AFS_RecalculateFrictionDiagnostics()
  {
   int touched = 0;
   int pass_ct = 0;
   int weak_ct = 0;
   int fail_ct = 0;

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!AFS_RecordInActiveScope(rec))
         continue;
      if(rec.FrictionUpdateCount <= 0)
         continue;

      touched++;

      if(rec.FrictionStatus == "PASS")
         pass_ct++;
      else if(rec.FrictionStatus == "WEAK")
         weak_ct++;
      else if(rec.FrictionStatus == "FAIL")
         fail_ct++;
     }

   g_state.MemoryShell.FrictionCount     = touched;
   g_state.MemoryShell.FrictionPassCount = pass_ct;
   g_state.MemoryShell.FrictionWeakCount = weak_ct;
   g_state.MemoryShell.FrictionFailCount = fail_ct;
  }

string AFS_GetFrictionStateText()
  {
   if(AFS_GetStepNumber() < 8.0)
      return "Pending";

   return IntegerToString(g_state.MemoryShell.FrictionCount) + "/" +
          IntegerToString(g_state.MemoryShell.UniverseCount) +
          " | P " + IntegerToString(g_state.MemoryShell.FrictionPassCount) +
          " W " + IntegerToString(g_state.MemoryShell.FrictionWeakCount) +
          " F " + IntegerToString(g_state.MemoryShell.FrictionFailCount);
  }

void AFS_RunFrictionScanCycle()
  {
   if(AFS_GetStepNumber() < 8.0)
      return;

   int total = ArraySize(g_state.Universe);
   if(total <= 0)
      return;

   int batch = DeepBatchSize;
   if(batch < 1)
      batch = 1;
   if(batch > total)
      batch = total;

   int cursor = g_frictionCursor;
   if(cursor < 0 || cursor >= total)
      cursor = 0;

   int processed = 0;
   int inspected = 0;
   int inspect_budget = AFS_DeepScanInspectionBudget(total, batch);
   datetime now = g_state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   for(int n = 0; n < inspect_budget && processed < batch; n++)
     {
      if(cursor >= total)
         cursor = 0;

      inspected++;

      if(AFS_IsFrictionCandidate(g_state.Universe[cursor]) &&
         AFS_ShouldRefreshFrictionRecord(g_state.Universe[cursor], now))
        {
         string detail = "";
         AFS_HF_RefreshFrictionRecord(g_state.Universe[cursor],
                                      now,
                                      FrictionSampleWindowSec,
                                      FrictionSampleCount,
                                      MinUpdateCount,
                                      MaxTickAge,
                                      MaxSpreadAtr,
                                      detail);
         processed++;
        }

      cursor++;
     }

   if(cursor >= total)
      cursor = 0;

   g_frictionCursor = cursor;
   g_state.MemoryShell.FrictionCursor = cursor;

   if(processed > 0)
     {
      AFS_RecalculateFrictionDiagnostics();
      g_surfaceArtifactsDirty = true;
      g_state.HistoryFriction.State  = MODULE_OK;
      g_state.HistoryFriction.Detail = "History " + AFS_GetHistoryStateText() +
                                       " | Friction " + AFS_GetFrictionStateText();
      AFS_DebugSurface("Friction cycle | Batch=" + IntegerToString(processed) +
                       " | Inspected=" + IntegerToString(inspected) +
                       " / " + IntegerToString(inspect_budget) +
                       " | Cursor=" + IntegerToString(g_frictionCursor) +
                       " | Friction=" + AFS_GetFrictionStateText());
     }
  }

void AFS_RunSelectionCycle()
  {
   if(AFS_GetStepNumber() < 9.0)
      return;

   int total = ArraySize(g_state.Universe);
   if(total <= 0)
      return;

   datetime now = g_state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   if(g_lastSelectionRunAt > 0 && (now - g_lastSelectionRunAt) < AFS_SelectionCooldownSeconds())
      return;

   int finalist_count = 0;
   string detail = "";
   AFS_Selection_Rebuild(g_state.Universe,
                         total,
                         ScanSelectedScopeOnly,
                         now,
                         finalist_count,
                         detail);

   g_lastSelectionRunAt = now;
   g_state.MemoryShell.FinalistCount = finalist_count;
   g_state.Selection.State  = (finalist_count > 0 ? MODULE_OK : MODULE_WARN);
   g_state.Selection.Detail = detail;
  }

void AFS_RunCorrelationCycle()
  {
   if(AFS_GetStepNumber() < 10.0)
      return;

   int total = ArraySize(g_state.Universe);
   if(total <= 0)
      return;

   datetime now = g_state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   if(g_lastCorrelationRunAt > 0 && (now - g_lastCorrelationRunAt) < AFS_CorrelationCooldownSeconds())
      return;

   string detail = "";
   AFS_Correlation_Rebuild(g_state.Universe, total, FinalCorrelationSetMax, detail);

   g_lastCorrelationRunAt = now;

   if(StringLen(g_state.Selection.Detail) > 0)
      g_state.Selection.Detail += " | " + detail;
   else
      g_state.Selection.Detail = detail;

   if(g_state.MemoryShell.FinalistCount > 0)
      g_state.Selection.State = MODULE_OK;
  }

bool AFS_IsSpecCandidate(const AFS_UniverseSymbol &rec)
  {
   if(!AFS_RecordInActiveScope(rec))
      return false;
   if(!rec.ClassificationResolved)
      return false;
   if(!rec.TradeAllowed)
      return false;
   if(rec.PromotionCandidate)
      return true;
   if(rec.SpecUpdateCount <= 0)
      return true;
   return false;
  }

bool AFS_ShouldRefreshSpecRecord(const AFS_UniverseSymbol &rec,const datetime now)
  {
   if(rec.LastSpecUpdateAt <= 0)
      return true;

   int cooldown = MathMax(30, TimerSeconds * 20);
   if(rec.PromotionCandidate)
      cooldown = MathMax(15, TimerSeconds * 10);
   if(rec.EconomicsTrust == "WEAK" || rec.EconomicsTrust == "FAIL" || rec.SpecIntegrityStatus == "SPEC_BROKEN")
      cooldown = MathMax(12, TimerSeconds * 6);

   return ((now - rec.LastSpecUpdateAt) >= cooldown);
  }

void AFS_RecalculateSpecDiagnostics()
  {
   int touched = 0;
   int pass_ct = 0;
   int weak_ct = 0;
   int fail_ct = 0;

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!AFS_RecordInActiveScope(rec))
         continue;
      if(rec.SpecUpdateCount <= 0)
         continue;

      touched++;

      if(rec.EconomicsTrust == "PASS")
         pass_ct++;
      else if(rec.EconomicsTrust == "WEAK")
         weak_ct++;
      else if(rec.EconomicsTrust == "FAIL")
         fail_ct++;
     }

   g_state.MemoryShell.SpecCount     = touched;
   g_state.MemoryShell.SpecPassCount = pass_ct;
   g_state.MemoryShell.SpecWeakCount = weak_ct;
   g_state.MemoryShell.SpecFailCount = fail_ct;
  }

string AFS_GetSpecStateText()
  {
   return IntegerToString(g_state.MemoryShell.SpecCount) + "/" +
          IntegerToString(g_state.MemoryShell.UniverseCount) +
          " | P " + IntegerToString(g_state.MemoryShell.SpecPassCount) +
          " W " + IntegerToString(g_state.MemoryShell.SpecWeakCount) +
          " F " + IntegerToString(g_state.MemoryShell.SpecFailCount);
  }

void AFS_RunSpecScanCycle()
  {
   if(AFS_GetStepNumber() < 6.0)
      return;

   int total = ArraySize(g_state.Universe);
   if(total <= 0)
      return;

   int batch = DeepBatchSize;
   if(batch < 1)
      batch = 1;
   if(batch > total)
      batch = total;

   int cursor = g_specCursor;
   if(cursor < 0 || cursor >= total)
      cursor = 0;

   int processed = 0;
   int inspected = 0;
   int inspect_budget = AFS_DeepScanInspectionBudget(total, batch);
   datetime now = g_state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   for(int n = 0; n < inspect_budget && processed < batch; n++)
     {
      if(cursor >= total)
         cursor = 0;

      inspected++;

      if(AFS_IsSpecCandidate(g_state.Universe[cursor]) &&
         AFS_ShouldRefreshSpecRecord(g_state.Universe[cursor], now))
        {
         string detail = "";
         AFS_MC_RefreshSpecRecord(g_state.Universe[cursor], now, detail);
         processed++;
        }

      cursor++;
     }

   if(cursor >= total)
      cursor = 0;

   g_specCursor = cursor;
   g_state.MemoryShell.SpecCursor = cursor;

   if(processed > 0)
     {
      AFS_RecalculateSpecDiagnostics();
      g_surfaceArtifactsDirty = true;
      g_state.MarketCore.State  = MODULE_OK;
      g_state.MarketCore.Detail = "Surface " + AFS_SurfaceCoverageText() +
                                  " | Spec " + AFS_GetSpecStateText();
      AFS_DebugSurface("Spec cycle | Batch=" + IntegerToString(processed) +
                       " | Inspected=" + IntegerToString(inspected) +
                       " / " + IntegerToString(inspect_budget) +
                       " | Cursor=" + IntegerToString(g_specCursor) +
                       " | Spec=" + AFS_GetSpecStateText());
     }
  }

void AFS_SetupStepShell()
  {
   AFS_InitModuleState(g_state.Classification,  "Classification",  MODULE_IDLE,  "Awaiting Step 4");
   AFS_InitModuleState(g_state.MarketCore,      "MarketCore",      MODULE_READY, "Surface/spec sanity pending");
   AFS_InitModuleState(g_state.HistoryFriction, "HistoryFriction", MODULE_READY, "History/friction cadence pending");
   AFS_InitModuleState(g_state.Selection,       "Selection",       MODULE_IDLE,  "Awaiting Steps 9-13");
   AFS_InitModuleState(g_state.OutputDebug,     "OutputDebug",     MODULE_READY, "Preparing route");
  }

void AFS_ApplyStep2ModuleStates()
  {
   if(g_state.PathState.Ready && g_state.MemoryShell.Ready)
     {
      g_state.OutputDebug.State  = MODULE_OK;
      g_state.OutputDebug.Detail = "Server route ready";
     }
   else
     {
      g_state.OutputDebug.State  = MODULE_WARN;
      g_state.OutputDebug.Detail = "Output shell not ready";
     }

   if(AFS_GetStepNumber() >= 4.0)
     {
      if(g_state.ClassificationMapReady)
        {
         g_state.Classification.State  = MODULE_OK;
         g_state.Classification.Detail = "Embedded map ready";
        }
      else
        {
         g_state.Classification.State  = MODULE_WARN;
         g_state.Classification.Detail = "Embedded map missing";
        }
     }

   if(AFS_GetStepNumber() >= 3.0)
     {
      g_state.MarketCore.State  = MODULE_READY;
      g_state.MarketCore.Detail = (AFS_GetStepNumber() >= 5.0 ? "Surface rotation armed" : "Universe loader armed");
     }

   if(AFS_GetStepNumber() >= 7.0)
     {
      g_state.HistoryFriction.State  = MODULE_READY;
      g_state.HistoryFriction.Detail = (AFS_GetStepNumber() >= 8.0 ? "History/friction cadence armed" : "History/ATR cadence armed");
     }
   else
     {
      g_state.HistoryFriction.State  = MODULE_IDLE;
      g_state.HistoryFriction.Detail = "Awaiting Step 7";
     }
  }

void AFS_InitViewState()
  {
   g_state.ActiveHUDProfile           = HUDProfile;
   g_state.ViewShowNotes              = (HUDProfile == HUD_COMPACT ? HudCompactShowNotes : HudNormalShowNotes);
   g_state.ViewShowModules            = (HUDProfile == HUD_COMPACT ? false : HudNormalShowModules);
   g_state.ViewShowScheduling         = (HUDProfile == HUD_COMPACT ? false : HudNormalShowScheduling);
   g_state.ViewShowScope              = (HUDProfile == HUD_COMPACT ? false : HudNormalShowScope);
   g_state.ViewShowCorrelationPreview = ShowCorrelationPreview;
   g_state.ViewShowDebugFooter        = (HUDProfile == HUD_DEBUG);
   g_state.ViewShowControlRail        = ShowControlRail;
   g_state.TimerPaused                = false;
  }

bool AFS_ValidateInputs()
  {
   g_state.LastError = "";

   if(TimerSeconds < 1)
     {
      g_state.LastError = "TimerSeconds must be >= 1";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(SurfaceBatchSize < 1)
     {
      g_state.LastError = "SurfaceBatchSize must be >= 1";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(DeepBatchSize < 1)
     {
      g_state.LastError = "DeepBatchSize must be >= 1";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(MaxSymbolsToShow < 1)
     {
      g_state.LastError = "MaxSymbolsToShow must be >= 1";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(MinCyclePauseMs < 0)
     {
      g_state.LastError = "MinCyclePauseMs must be >= 0";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(MaxCyclePauseMs < MinCyclePauseMs)
     {
      g_state.LastError = "MaxCyclePauseMs must be >= MinCyclePauseMs";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(MinBarsM15 < 1)
     {
      g_state.LastError = "MinBarsM15 must be >= 1";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(MinBarsH1 < 1)
     {
      g_state.LastError = "MinBarsH1 must be >= 1";
      AFS_LogError(g_state.LastError);
      return false;
     }


if(AnalyticsMinBarsM1 < 1 || AnalyticsMinBarsM5 < 1 || AnalyticsMinBarsM15 < 1 ||
   AnalyticsMinBarsH1 < 1 || AnalyticsMinBarsH4 < 1 || AnalyticsMinBarsD1 < 1 || AnalyticsMinBarsW1 < 1)
  {
   g_state.LastError = "Analytics min bars inputs must be >= 1";
   AFS_LogError(g_state.LastError);
   return false;
  }

if(AnalyticsAtrPeriod < 2)
  {
   g_state.LastError = "AnalyticsAtrPeriod must be >= 2";
   AFS_LogError(g_state.LastError);
   return false;
  }

if(TacticalLightCadenceSeconds < 1 || TacticalHeavyCadenceSeconds < 10)
  {
   g_state.LastError = "Tactical cadence inputs out of range";
   AFS_LogError(g_state.LastError);
   return false;
  }

if(TacticalWindowM1Bars < 2 || TacticalWindowM5Bars < 2 || TacticalWindowM15Bars < 2)
  {
   g_state.LastError = "Tactical window inputs must be >= 2";
   AFS_LogError(g_state.LastError);
   return false;
  }

if(DossierOHLCBarsM1 < 1 || DossierOHLCBarsM5 < 1 || DossierOHLCBarsM15 < 1 ||
   DossierOHLCBarsH1 < 1 || DossierOHLCBarsH4 < 1 || DossierOHLCBarsD1 < 1 || DossierOHLCBarsW1 < 1)
  {
   g_state.LastError = "Dossier OHLC bars inputs must be >= 1";
   AFS_LogError(g_state.LastError);
   return false;
  }

   if(FrictionSampleCount < 1)
     {
      g_state.LastError = "FrictionSampleCount must be >= 1";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(FrictionSampleWindowSec < 1)
     {
      g_state.LastError = "FrictionSampleWindowSec must be >= 1";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(FinalCorrelationSetMax < 1)
     {
      g_state.LastError = "FinalCorrelationSetMax must be >= 1";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(PanelWidthPx < 760)
     {
      g_state.LastError = "PanelWidthPx must be >= 760";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(PanelHeightPx < 460)
     {
      g_state.LastError = "PanelHeightPx must be >= 460";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(ControlRailWidthPx < 120)
     {
      g_state.LastError = "ControlRailWidthPx must be >= 120";
      AFS_LogError(g_state.LastError);
      return false;
     }

   if(StringLen(OutputRootFolderName) == 0)
     {
      g_state.LastError = "OutputRootFolderName must not be empty";
      AFS_LogError(g_state.LastError);
      return false;
     }

   return true;
  }

string AFS_GetStageBadgeText()
  {
   double step_n = AFS_GetStepNumber();

   if(step_n <= 1.2) return "UI Control Shell";
   if(step_n < 3.0)  return "Output / Memory";
   if(step_n < 5.0)  return "Universe Loader";
   if(step_n < 9.0)  return "Scan Context";
   if(step_n < 14.0) return "Selection Build";
   return "Trader Ready";
  }

string AFS_GetDisplayPhaseTag()
  {
   // Display-only identity. Do not route runtime gating through this helper.
   return AFS_DISPLAY_PHASE_TAG;
  }

string AFS_GetDisplayStepTag()
  {
   // Display-only identity for the current bounded same-step revision.
   // CurrentStepTag remains operationally coupled to runtime gating elsewhere.
   return AFS_DISPLAY_STEP_TAG;
  }

string AFS_GetDisplayPhaseStepContext()
  {
   return AFS_DISPLAY_PHASE_STEP_CONTEXT;
  }

string AFS_GetDeferredFeaturePreservationLine()
  {
   return "DeferredFeatureRegistry: DownstreamExecutionPermission=ACTIVE_DOWNSTREAM_ONLY | HardRejectionLayer=ACTIVE_DOWNSTREAM_ONLY | CorrelationClusterFilter=PRESERVED_INACTIVE | ATR_Efficiency=ANALYTICS_ONLY | SpreadToVolatility=ANALYTICS_ONLY | CandidateOverlay=DEFERRED | SessionQualityExpansion=DEFERRED | MaxTradePerAssetClass=DEFERRED | PositionRiskModel=DEFERRED | FinalTradePipeline=DEFERRED | OrderBookDepth=DEFERRED | ExecutionQualityMetrics=DEFERRED | RegimeDetectionExpansion=DEFERRED | StatisticalProfile=DEFERRED | TradeFeasibilityExpansion=DEFERRED | MacroContext=DEFERRED | DataQualityConfidenceExpansion=PRESERVED_DOWNSTREAM_ONLY";
  }


string AFS_GetStageDisplayName(const int step_number)
  {
   switch(step_number)
     {
      case 5:  return "Surface";
      case 6:  return "Economics / Spec";
      case 7:  return "History / ATR";
      case 8:  return "Phase 1 Step 8 Tradability / Friction";
      case 9:  return "Selection";
      case 10: return "Finalist Correlation";
      case 11: return "Trader Package";
      case 12: return "Trader Intel";
     }
   return "Step " + IntegerToString(step_number);
  }

int AFS_CountCorrelatedFinalists()
  {
   int count = 0;
   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!rec.FinalistSelected)
         continue;
      if(StringLen(rec.CorrClosestSymbol) <= 0)
         continue;
      if(rec.CorrContextFlag == "CORR_PENDING")
         continue;
      count++;
     }
   return count;
  }

int AFS_CountPublishedTraderDossiers()
  {
   int ordered[];
   AFS_CollectTraderPublishedIndexes(ordered);
   return ArraySize(ordered);
  }

int AFS_CountLiveFinalists()
  {
   int count = 0;
   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!rec.FinalistSelected)
         continue;
      if(!rec.QuotePresent || rec.Bid <= 0.0 || rec.Ask <= 0.0)
         continue;
      count++;
     }
   return count;
  }

int AFS_CountTickTrustedFinalists()
  {
   int count = 0;
   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      const AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!rec.FinalistSelected)
         continue;

      double trusted_tick_value = 0.0;
      string provenance = "";
      string trust_state = "";
      bool estimated = false;
      if(AFS_TA_SelectTrustedTickValue(rec, trusted_tick_value, provenance, trust_state, estimated))
         count++;
     }
   return count;
  }

string AFS_HUD_PipelineMaturityBand(const int correlated_count)
  {
   int ready_hits = 0;
   if(g_state.MemoryShell.SurfaceLoadedCount > 0) ready_hits++;
   if(g_state.MemoryShell.SpecCount > 0) ready_hits++;
   if(g_state.MemoryShell.HistoryCount > 0) ready_hits++;
   if(g_state.MemoryShell.FrictionCount > 0) ready_hits++;
   if(g_state.MemoryShell.FinalistCount > 0) ready_hits++;
   if(correlated_count > 0) ready_hits++;

   if(ready_hits >= 5)
      return "READY";
   if(ready_hits >= 3)
      return "PARTIAL";
   return "WARMING";
  }

string AFS_HUD_ShortlistBand(const int pass_count,const int weak_count,const int finalist_count)
  {
   if(finalist_count <= 0 || pass_count <= 0)
      return "UNSTABLE";
   if(weak_count > pass_count)
      return "STABILIZING";
   return "STABLE";
  }

string AFS_HUD_CorrelationBand(const int correlated_count,const int finalist_count)
  {
   if(finalist_count <= 0)
      return "PENDING";
   if(correlated_count >= finalist_count)
      return "READY";
   if(correlated_count > 0)
      return "PARTIAL";
   return "PENDING";
  }

string AFS_HUD_DossierFreshnessBand()
  {
   if(g_state.TraderIntel.LastWriteAt <= 0)
      return "STALE";

   int age = (int)(g_state.LastTimerAt - g_state.TraderIntel.LastWriteAt);
   if(age <= 20)
      return "FRESH";
   if(age <= 120)
      return "AGING";
   return "STALE";
  }

string AFS_HUD_ScannerConfidenceBand(const int pass_count,const int weak_count)
  {
   if(pass_count > 0 && weak_count <= pass_count)
      return "HIGH";
   if(pass_count > 0 || weak_count > 0)
      return "BUILDING";
   return "LOW";
  }

string AFS_HUD_TacticalBand(const int live_finalists,const int finalist_count)
  {
   if(finalist_count <= 0)
      return "PENDING";
   if(live_finalists >= finalist_count)
      return "LIGHT_READY";
   if(live_finalists > 0)
      return "MEDIUM_PENDING";
   return "HEAVY_DEFERRED";
  }

string AFS_HUD_ActivePublicationBand(const int dossier_count,const int finalist_count,const int live_finalists)
  {
   if(finalist_count <= 0)
      return "WEAK";
   if(dossier_count >= finalist_count && live_finalists >= finalist_count)
      return "GOOD";
   if(dossier_count > 0 || live_finalists > 0)
      return "MIXED";
   return "WEAK";
  }

string AFS_HUD_DataIntegrityBand(const int trusted_tick_finalists,const int finalist_count)
  {
   if(finalist_count <= 0)
      return "FRAGILE";
   if(trusted_tick_finalists >= finalist_count)
      return "VALIDATED";
   if(trusted_tick_finalists > 0)
      return "MIXED";
   return "FRAGILE";
  }

string AFS_HUD_ExecutionBand(const int live_finalists,const int finalist_count,const int pass_count)
  {
   if(finalist_count <= 0 || live_finalists <= 0)
      return "CAUTION";
   if(pass_count > 0 && live_finalists >= finalist_count)
      return "READY";
   return "BUILDING";
  }

color AFS_HUD_BandColor(const string band)
  {
   if(band == "READY" || band == "STABLE" || band == "FRESH" || band == "HIGH" || band == "GOOD" || band == "VALIDATED" || band == "LIGHT_READY")
      return AFS_CLR_OK;
   if(StringFind(band, "PARTIAL") >= 0 || StringFind(band, "AGING") >= 0 || StringFind(band, "BUILDING") >= 0 || StringFind(band, "MIXED") >= 0 || StringFind(band, "STABILIZING") >= 0 || StringFind(band, "MEDIUM_PENDING") >= 0)
      return AFS_CLR_ACCENT;
   return AFS_CLR_WARN;
  }


string AFS_GetTraderPackageHudText(const int dossier_count)
  {
   if(!g_state.PathState.Ready)
      return "Output shell pending";

   if(AFS_GetStepNumber() < 11.0)
      return "Trader package publish gate not active";

   if(StringLen(g_state.PathState.TraderFolder) <= 0)
      return "Trader package route pending";

   return "SUMMARY.txt route ready | Dossiers " + IntegerToString(dossier_count);
  }

string AFS_GetStepGuidance()
  {
   double step_n = AFS_GetStepNumber();

   if(step_n < 2.1)
      return "Step 2 active: output route and runtime memory shell are live.";
   if(step_n < 3.1)
      return "Step 3 active: broker universe loaded and exports ready for classification prep.";
   if(step_n < 4.1)
      return "Step 4 active: embedded symbol normalization and classification are live.";
   if(step_n < 5.1)
      return AFS_GetStageDisplayName(5) + " active: scan rotation is live and promotion remains placeholder-only.";
   if(step_n < 6.1)
      return AFS_GetStageDisplayName(6) + " active: economics sanity and spec validation are live.";
   if(step_n < 7.1)
      return AFS_GetStageDisplayName(7) + " active: coverage and ATR baseline cadence are live.";
   if(step_n < 8.1)
      return AFS_GetStageDisplayName(8) + " active: tradability truth refresh remains upstream of selection and is not modified by downstream execution-permission display logic.";
   if(step_n < 9.1)
      return AFS_GetStageDisplayName(9) + " pending: shortlist builds only after Phase 1 Step 8 tradability truth is ready.";
   if(step_n < 10.1)
      return AFS_GetStageDisplayName(10) + " pending: finalists correlate only after selection rebuild.";
   if(step_n < 11.1)
      return AFS_GetStageDisplayName(11) + " pending: trader publication stays downstream-only.";
   if(step_n < 12.1)
      return AFS_GetStageDisplayName(12) + " pending: export layer remains downstream of scanner truth.";

   return "Phase-aware HUD is active with synchronized publication-hardening / execution-permission labeling while Phase 1 Step 8 core truth remains protected.";
  }

string AFS_GetTraderReadinessText()
  {
   if(!AFS_IsTraderModeUnlocked())
      return "Trader Mode is blocked until protected Phase 1 core runtime readiness is reached.";

   if(!Phase1Complete && AFS_GetStepNumber() >= 11.0)
      return "Trader Mode unlocked from protected Phase 1 core runtime readiness. Final shortlist panels remain live while downstream execution permission remains display-only." ;

   return "Trader Mode is allowed. Final shortlist panels will populate as scanner modules provide real data.";
  }

string AFS_GetRuntimeStateLine()
  {
   if(!EnableEA)
      return "EA disabled by input";
   if(g_state.TimerPaused)
      return "Timer paused by HUD control";
   if(SnapshotMode)
      return "SnapshotMode input active";

   if(AFS_GetStepNumber() >= 8.0)
      return "Surface active | Scope " + AFS_SurfaceCoverageText() +
             " | Batch " + AFS_FormatSurfaceBatchState() +
             " | Rot " + AFS_RotationModeToText(RotationMode) +
             " / " + AFS_SurfaceUpdatePolicyToText(SurfaceUpdatePolicy) +
             " | Fresh " + IntegerToString(g_state.MemoryShell.SurfaceFreshCount) +
             " | Hist " + IntegerToString(g_state.MemoryShell.HistoryPassCount) + "/" +
             IntegerToString(g_state.MemoryShell.HistoryCount) +
             " | Fric " + IntegerToString(g_state.MemoryShell.FrictionPassCount) + "/" +
             IntegerToString(g_state.MemoryShell.FrictionCount);

   if(AFS_GetStepNumber() >= 7.0)
      return "Surface active | Scope " + AFS_SurfaceCoverageText() +
             " | Batch " + AFS_FormatSurfaceBatchState() +
             " | Rot " + AFS_RotationModeToText(RotationMode) +
             " / " + AFS_SurfaceUpdatePolicyToText(SurfaceUpdatePolicy) +
             " | Fresh " + IntegerToString(g_state.MemoryShell.SurfaceFreshCount) +
             " | Hist " + IntegerToString(g_state.MemoryShell.HistoryPassCount) + "/" +
             IntegerToString(g_state.MemoryShell.HistoryCount);

   if(AFS_GetStepNumber() >= 5.0 && g_state.MemoryShell.SurfaceLastBatchCount > 0)
      return "Surface active | Scope " + AFS_SurfaceCoverageText() +
             " | Batch " + AFS_FormatSurfaceBatchState() +
             " | Rot " + AFS_RotationModeToText(RotationMode) +
             " / " + AFS_SurfaceUpdatePolicyToText(SurfaceUpdatePolicy) +
             " | Fresh " + IntegerToString(g_state.MemoryShell.SurfaceFreshCount) +
             " | NoQuote " + IntegerToString(g_state.MemoryShell.SurfaceNoQuoteCount);

   return "Timer heartbeat active";
  }

string AFS_GetStorageModeText()
  {
   return g_state.PathState.UseCommonFiles ? "COMMON FILES" : "LOCAL FILES";
  }

string AFS_UniverseSourceText()
  {
   return UniverseUseMarketWatchOnly ? "MarketWatch" : "Terminal";
  }

string AFS_ExportedAtText()
  {
   return TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS);
  }
  
void AFS_DrawRailButton(const string key,const int x,const int y,const int w,const string text,const bool active=false,const bool warn=false)
  {
   color bg = AFS_CLR_PANEL;
   if(active)
      bg = AFS_CLR_BTN_ACTIVE;
   else if(warn)
      bg = AFS_CLR_BTN_WARN;

   AFS_CreateButton(AFS_ObjName("BTN_"+key), x, y, w, AFS_RailButtonHeight(), text, bg, AFS_CLR_BORDER, AFS_CLR_BTN_TEXT);
  }

void AFS_DrawControlRail(const int x,const int y,const int w,const int h)
  {
   if(!AllowHudButtons || !g_state.ViewShowControlRail)
      return;

   AFS_CreateRectLabel(AFS_ObjName("RAIL_BG"), x, y, w, h, AFS_CLR_PANEL_ALT, AFS_CLR_BORDER);
   AFS_DrawSectionTitle("RAIL", x + 12, y + 12, "CONTROL RAIL");

   int cy = y + 40;
   int bw = w - 24;
   int bs = AFS_RailButtonStep();
   int group_gap = 16;

   string trader_text = (!AFS_IsTraderModeUnlocked() ? "TRADER MODE (LOCKED)" : "TRADER MODE");

   AFS_CreateLabel(AFS_ObjName("RAIL_G1"), x + 12, cy, "MODE", AFS_FontLabel(), AFS_CLR_TEXT_DIM);
   cy += 22;
   AFS_DrawRailButton("MODE_DEV",    x + 12, cy, bw, "DEV MODE",    (g_state.RequestedMode == MODE_DEV)); cy += bs;
   AFS_DrawRailButton("MODE_TRADER", x + 12, cy, bw, trader_text,   (g_state.RequestedMode == MODE_TRADER), !AFS_IsTraderModeUnlocked()); cy += (bs + group_gap);

   AFS_CreateLabel(AFS_ObjName("RAIL_G2"), x + 12, cy, "VIEW", AFS_FontLabel(), AFS_CLR_TEXT_DIM);
   cy += 22;
   AFS_DrawRailButton("HUD_COMPACT", x + 12, cy, bw, "COMPACT", (g_state.ActiveHUDProfile == HUD_COMPACT)); cy += bs;
   AFS_DrawRailButton("HUD_NORMAL",  x + 12, cy, bw, "NORMAL",  (g_state.ActiveHUDProfile == HUD_NORMAL));  cy += bs;
   AFS_DrawRailButton("HUD_DEBUG",   x + 12, cy, bw, "DEBUG",   (g_state.ActiveHUDProfile == HUD_DEBUG));   cy += (bs + group_gap);

   AFS_CreateLabel(AFS_ObjName("RAIL_G3"), x + 12, cy, "ACTIONS", AFS_FontLabel(), AFS_CLR_TEXT_DIM);
   cy += 22;
   AFS_DrawRailButton("TOGGLE_NOTES", x + 12, cy, bw, g_state.ViewShowNotes ? "ATTENTION ON" : "ATTENTION OFF", g_state.ViewShowNotes); cy += bs;
   AFS_DrawRailButton("PAUSE",        x + 12, cy, bw, g_state.TimerPaused ? "RESUME TIMER" : "PAUSE TIMER", g_state.TimerPaused); cy += bs;
   AFS_DrawRailButton("REFRESH",      x + 12, cy, bw, "REFRESH HUD", false);
  }

void AFS_DrawHeader(const int x,const int y,const int w,const int h)
  {
   color head_bg = (g_state.EffectiveMode == MODE_TRADER ? AFS_CLR_HEADER_ALT : AFS_CLR_HEADER);

   AFS_CreateRectLabel(AFS_ObjName("HEADER"), x, y, w, h, head_bg, head_bg);
   AFS_CreateRectLabel(AFS_ObjName("HEADER_LINE"), x, y + h, w, 1, AFS_CLR_BORDER, AFS_CLR_BORDER);

   AFS_CreateLabel(AFS_ObjName("TITLE"), x + 16, y + 10, "AEGIS FORGE SCANNER", AFS_FontHeaderTitle(), AFS_CLR_TEXT);
   AFS_CreateLabel(AFS_ObjName("SUB"),   x + 18, y + 36, "Market intelligence scanner console", AFS_FontHeaderSub(), AFS_CLR_TEXT_DIM);

   string source_badge = AFS_UniverseSourceText() + " source";
   string mode_badge   = g_state.EffectiveModeText + (g_state.ModeForcedToDev ? " (forced)" : "");

   AFS_DrawBadge("HEADER_SOURCE", x + 324, y + 12, 188, 22, source_badge, AFS_CLR_PANEL_ALT, AFS_CLR_BORDER, AFS_CLR_ACCENT);
   AFS_DrawBadge("HEADER_MODE",   x + 324, y + 40, 188, 22, mode_badge,
                 g_state.ModeForcedToDev ? AFS_CLR_BTN_WARN : AFS_CLR_PANEL,
                 AFS_CLR_BORDER,
                 g_state.ModeForcedToDev ? AFS_CLR_WARN : AFS_CLR_TEXT);

   int right_x = x + w - 360;
   AFS_CreateLabel(AFS_ObjName("HDR_R1"), right_x, y + 11, "Server: " + AFS_ClipText(g_state.ServerName, 34), AFS_FontValue(), AFS_CLR_TEXT);
   AFS_CreateLabel(AFS_ObjName("HDR_R2"), right_x, y + 29, "Server Time: " + AFS_FormatTime(g_state.ServerTime), AFS_FontValue(), AFS_CLR_TEXT);
   AFS_CreateLabel(AFS_ObjName("HDR_R3"), right_x, y + 47, "Phase / Step: " + AFS_GetDisplayPhaseTag() + " / " + AFS_GetDisplayStepTag(), AFS_FontValue(), AFS_CLR_TEXT_DIM);
  }

void AFS_DrawNotesBlock(const int x,const int y,const int w,const int h)
  {
   AFS_CreateRectLabel(AFS_ObjName("NOTES_BG"), x, y, w, h, AFS_CLR_PANEL, AFS_CLR_BORDER);

   AFS_DrawSectionTitle("NOTES", x + 12, y + 12, "ATTENTION");

   string note1 = (StringLen(g_state.LastWarning) > 0
                   ? "Warning: " + g_state.LastWarning
                   : "Warning: Surface stale=" + IntegerToString(g_state.MemoryShell.SurfaceStaleCount) +
                     ", no-quote=" + IntegerToString(g_state.MemoryShell.SurfaceNoQuoteCount));
   string note2 = (StringLen(g_state.LastError) > 0
                   ? "Error: " + g_state.LastError
                   : "Error: none");
   string note3 = (StringLen(g_state.LastInfo) > 0
                   ? "Info: " + g_state.LastInfo
                   : "Info: " + AFS_SurfaceFreshnessText());

   int ry = y + AFS_SectionBodyStart();

   AFS_CreateLabel(AFS_ObjName("NOTE1"), x + 14, ry, AFS_ClipText(note1, 120), AFS_FontValue(),
                   (StringLen(g_state.LastWarning) > 0 ? AFS_CLR_WARN : AFS_CLR_TEXT_DIM));
   ry += AFS_RowStep();

   AFS_CreateLabel(AFS_ObjName("NOTE2"), x + 14, ry, AFS_ClipText(note2, 120), AFS_FontValue(),
                   (StringLen(g_state.LastError) > 0 ? AFS_CLR_FAIL : AFS_CLR_TEXT_DIM));
   ry += AFS_RowStep();

   AFS_CreateLabel(AFS_ObjName("NOTE3"), x + 14, ry, AFS_ClipText(note3, 120), AFS_FontValue(), AFS_CLR_TEXT_DIM);
  }

void AFS_DrawDebugFooter(const int x,const int y,const int w,const int h)
{
   AFS_CreateRectLabel(AFS_ObjName("DBG_BG"), x, y, w, h, AFS_CLR_PANEL_ALT, AFS_CLR_BORDER);

   string dbg = "DEBUG | Timings=" + AFS_BoolText(DebugShowTimings)
              + " Reject=" + AFS_BoolText(DebugShowRejectReasons)
              + " Weak=" + AFS_BoolText(DebugShowWeakReasons)
              + " CalcSrc=" + AFS_BoolText(DebugShowCalculationSource)
              + " Trust=" + AFS_BoolText(DebugShowTrustGrades)
              + " Rotation=" + AFS_BoolText(DebugShowRotationState)
              + " Batch=" + AFS_BoolText(DebugShowBatchState)
              + " | Surface=" + IntegerToString(g_state.MemoryShell.SurfaceCount)
              + "/" + IntegerToString(ArraySize(g_state.Universe))
              + " Fresh=" + IntegerToString(g_state.MemoryShell.SurfaceFreshCount)
              + " Stale=" + IntegerToString(g_state.MemoryShell.SurfaceStaleCount)
              + " NoQuote=" + IntegerToString(g_state.MemoryShell.SurfaceNoQuoteCount)
              + " Promoted=" + IntegerToString(g_state.MemoryShell.SurfacePromotedCount)
              + " Cursor=" + IntegerToString(g_state.MemoryShell.SurfaceCursor)
              + " Pass=" + IntegerToString(g_state.MemoryShell.SurfacePassCount);

   AFS_CreateLabel(AFS_ObjName("DBG_TX"), x + 10, y + 6, AFS_ClipText(dbg, 150), AFS_FontLabel(), AFS_CLR_WARN);
}

void AFS_DrawDevHUD(const int x,const int y,const int w,const int h,const int rail_w)
  {
   int gap         = AFS_BlockGap();
   int header_h    = 84;
   int content_y   = y + header_h + 10;

   int main_w      = w - ((rail_w > 0) ? (rail_w + gap) : 0);
   int col_w       = (main_w - gap) / 2;
   col_w          -= 10;

   int row1_h      = AFS_SectionHeight(6) + 22;
   int row2_h      = AFS_SectionHeight(9) + 42;
   int notes_h     = (g_state.ViewShowNotes ? AFS_NotesHeight() : 0);

   int left_x      = x;
   int right_x     = x + col_w + gap;
   int row2_y      = content_y + row1_h + gap;

   string scope_text = (ScanSelectedScopeOnly ? "Selected scope only" : "Full tradable universe");

   string filters = "";
   if(!AFS_IsAllOrEmpty(AssetClassFilter))
      filters += "Asset=" + AssetClassFilter + " ";
   if(!AFS_IsAllOrEmpty(PrimaryBucketFilter))
      filters += "Bucket=" + PrimaryBucketFilter + " ";
   if(!AFS_IsAllOrEmpty(SectorFilter))
      filters += "Sector=" + SectorFilter + " ";
   if(!AFS_IsAllOrEmpty(SymbolFilter))
      filters += "Symbol=" + SymbolFilter + " ";
   if(StringLen(AFS_ToUpperTrim(CustomSymbolList)) > 0)
      filters += "CustomList ";
   if(StringLen(filters) == 0)
      filters = "No active filters";

   int excluded = g_state.MemoryShell.BrokerSymbolCount - g_state.MemoryShell.EligibleSymbolCount;

   AFS_DrawHeader(x, y, w, header_h);

   AFS_CreateRectLabel(AFS_ObjName("DEV_SCOPE_BG"),  left_x,  content_y, col_w, row1_h, AFS_CLR_PANEL, AFS_CLR_BORDER);
   AFS_CreateRectLabel(AFS_ObjName("DEV_HEALTH_BG"), right_x, content_y, col_w, row1_h, AFS_CLR_PANEL, AFS_CLR_BORDER);

   AFS_DrawSectionTitle("DEV_SCOPE", left_x + 12, content_y + 12, "SESSION / SCOPE");
   int ry = content_y + AFS_SectionBodyStart();
   AFS_DrawKeyValueRow("SC1", left_x + 14, ry, 128, "Mode",    g_state.EffectiveModeText, g_state.ModeForcedToDev ? AFS_CLR_WARN : AFS_CLR_OK, 28); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("SC2", left_x + 14, ry, 128, "HUD",     AFS_HUDProfileToText(g_state.ActiveHUDProfile), AFS_CLR_TEXT, 22); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("SC3", left_x + 14, ry, 128, "Source",  AFS_UniverseSourceText(), AFS_CLR_ACCENT, 22); ry += AFS_RowStep();
   AFS_DrawWrappedKeyValueRow("SC4", left_x + 14, ry, 128, "Scope",   scope_text, AFS_CLR_TEXT, 38, 58); ry += (AFS_RowStep() + 16);
   AFS_DrawWrappedKeyValueRow("SC5", left_x + 14, ry, 128, "Filters", filters, AFS_CLR_TEXT_DIM, 40, 62);

   AFS_DrawSectionTitle("DEV_HEALTH", right_x + 12, content_y + 12, "RUNTIME / HEALTH");
   ry = content_y + AFS_SectionBodyStart();
   AFS_DrawKeyValueRow("RH1", right_x + 14, ry, 132, "Server Time",  AFS_FormatTime(g_state.ServerTime), AFS_CLR_TEXT, 28); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("RH2", right_x + 14, ry, 132, "Timer",        g_state.TimerPaused ? "Paused" : "Running", g_state.TimerPaused ? AFS_CLR_WARN : AFS_CLR_OK, 18); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("RH3", right_x + 14, ry, 132, "Heartbeat",    IntegerToString(g_state.TimerCount), AFS_CLR_TEXT, 14); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("RH4", right_x + 14, ry, 132, "Last Refresh", AFS_FormatTime(g_state.LastTimerAt), AFS_CLR_TEXT_DIM, 28); ry += AFS_RowStep();
   AFS_DrawWrappedKeyValueRow("RH5", right_x + 14, ry, 132, "Status", AFS_GetRuntimeStateLine(), g_state.TimerPaused ? AFS_CLR_WARN : AFS_CLR_TEXT_DIM, 44, 66);

   AFS_CreateRectLabel(AFS_ObjName("DEV_UNI_BG"), left_x,  row2_y, col_w, row2_h, AFS_CLR_PANEL_ALT, AFS_CLR_BORDER);
   AFS_CreateRectLabel(AFS_ObjName("DEV_OUT_BG"), right_x, row2_y, col_w, row2_h, AFS_CLR_PANEL_ALT, AFS_CLR_BORDER);

   AFS_DrawSectionTitle("DEV_UNI", left_x + 12, row2_y + 12, "UNIVERSE SNAPSHOT");
   ry = row2_y + AFS_SectionBodyStart();
   AFS_DrawKeyValueRow("US1", left_x + 14, ry, 136, "Broker Total", IntegerToString(g_state.MemoryShell.BrokerSymbolCount), AFS_CLR_TEXT, 14); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("US2", left_x + 14, ry, 136, "Eligible",     IntegerToString(g_state.MemoryShell.EligibleSymbolCount), AFS_CLR_OK, 14); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("US3", left_x + 14, ry, 136, "Active Scope", IntegerToString(g_state.MemoryShell.UniverseCount), AFS_CLR_ACCENT, 14); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("US4", left_x + 14, ry, 136, "Excluded",     IntegerToString(excluded), excluded > 0 ? AFS_CLR_WARN : AFS_CLR_TEXT_DIM, 14); ry += AFS_RowStep();
   AFS_DrawWrappedKeyValueRow("US5", left_x + 14, ry, 136, "Surface", AFS_GetSurfaceStateText(), AFS_CLR_TEXT, 42, 64); ry += (AFS_RowStep() + 16);
   AFS_DrawWrappedKeyValueRow("US6", left_x + 14, ry, 136, "Economics / Spec", AFS_GetSpecStateText(), AFS_CLR_TEXT_DIM, 42, 62); ry += (AFS_RowStep() + 16);
   AFS_DrawWrappedKeyValueRow("US7", left_x + 14, ry, 136, "History / ATR", AFS_GetHistoryStateText(), AFS_CLR_TEXT_DIM, 42, 62); ry += (AFS_RowStep() + 16);
   AFS_DrawWrappedKeyValueRow("US8", left_x + 14, ry, 136, "Tradability / Friction", AFS_GetFrictionStateText(), AFS_CLR_TEXT_DIM, 42, 62);

   AFS_DrawSectionTitle("DEV_OUT", right_x + 12, row2_y + 12, "OUTPUT / ROUTE");
   ry = row2_y + AFS_SectionBodyStart();
   AFS_DrawKeyValueRow("OR1", right_x + 14, ry, 132, "Storage",   AFS_GetStorageModeText(), AFS_CLR_TEXT, 22); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("OR2", right_x + 14, ry, 132, "Server Key", g_state.PathState.ServerKey, AFS_CLR_TEXT, 28); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("OR3", right_x + 14, ry, 132, "Route",     AFS_GetRouteLeaf(), AFS_CLR_ACCENT, 28); ry += AFS_RowStep();
   AFS_DrawWrappedKeyValueRow("OR4", right_x + 14, ry, 132, "Rotation",  AFS_FormatSurfaceBatchState(), AFS_CLR_OK, 40, 62); ry += (AFS_RowStep() + 16);
   AFS_DrawWrappedKeyValueRow("OR5", right_x + 14, ry, 132, "Freshness", AFS_SurfaceFreshnessText(), AFS_CLR_TEXT_DIM, 44, 66); ry += (AFS_RowStep() + 16);
   AFS_DrawWrappedKeyValueRow("OR6", right_x + 14, ry, 132, "Economics / Spec",    AFS_GetSpecStateText(), AFS_CLR_TEXT_DIM, 40, 62); ry += (AFS_RowStep() + 16);
   AFS_DrawWrappedKeyValueRow("OR7", right_x + 14, ry, 132, "History / ATR",    AFS_GetHistoryStateText(), AFS_CLR_TEXT_DIM, 40, 62); ry += (AFS_RowStep() + 16);
   AFS_DrawWrappedKeyValueRow("OR8", right_x + 14, ry, 132, "Tradability / Friction",    AFS_GetFrictionStateText(), AFS_CLR_TEXT_DIM, 40, 62);

   int next_y = row2_y + row2_h + gap;

   if(g_state.ViewShowNotes)
     {
      AFS_DrawNotesBlock(x, next_y, main_w, notes_h);
      next_y += notes_h + gap;
     }

   if(rail_w > 0)
      AFS_DrawControlRail(x + main_w + gap, content_y, rail_w, h - header_h - 10);
  }


int AFS_FindBestFinalistIndexByBucket(const string bucket,bool &used[])
  {
   int best_idx = -1;

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      if(used[i])
         continue;

      AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!rec.FinalistSelected)
         continue;
      if(rec.PrimaryBucket != bucket)
         continue;

      if(best_idx < 0 || AFS_FinalOutputBetter(rec, g_state.Universe[best_idx]))
         best_idx = i;
     }

   return best_idx;
  }


string AFS_GetFinalOutputLeaf()
  {
   string full = g_state.PathState.FinalOutputFile;
   int p = StringFind(full, "\\", 0);
   int last = -1;
   while(p >= 0)
     {
      last = p;
      p = StringFind(full, "\\", p + 1);
     }

   if(last >= 0 && last + 1 < StringLen(full))
      return StringSubstr(full, last + 1);

   return full;
  }

string AFS_BuildTraderEntryLine1(const AFS_UniverseSymbol &rec)
  {
   return "#" + IntegerToString(rec.BucketRank) + " " + rec.Symbol + " " +
          rec.FrictionStatus + " " + AFS_FormatScore2(rec.TotalScore);
  }

string AFS_BuildTraderEntryLine2(const AFS_UniverseSymbol &rec)
  {
   string tail = "";
   if(rec.FrictionStatus == "WEAK")
      tail = AFS_OutputSafeText(rec.FrictionWeakReason, "Backup finalist");
   else if(g_state.ViewShowCorrelationPreview)
      tail = AFS_OutputSafeText(rec.CorrContextFlag, "Primary finalist");
   else
      tail = "Primary finalist";

   return AFS_OutputSafeText(rec.PrimaryBucket, "UNBUCKETED") + " | " + tail;
  }

void AFS_DrawTraderBucketColumn(const string id,
                                const int x,
                                const int y,
                                const int w,
                                const int h,
                                const string bucket,
                                bool &used[])
  {
   AFS_CreateRectLabel(AFS_ObjName(id+"_BG"), x, y, w, h, AFS_CLR_PANEL_ALT, AFS_CLR_BORDER);
   AFS_DrawSectionTitle(id, x + 10, y + 10, bucket);

   int ry = y + 34;
   for(int slot = 0; slot < 2; slot++)
     {
      int idx = AFS_FindBestFinalistIndexByBucket(bucket, used);
      string head = "No finalist";
      string tail = "No selected symbol";
      color  clr  = AFS_CLR_TEXT_DIM;

      if(idx >= 0)
        {
         used[idx] = true;
         AFS_UniverseSymbol rec = g_state.Universe[idx];
         head = AFS_BuildTraderEntryLine1(rec);
         tail = AFS_BuildTraderEntryLine2(rec);
         clr  = (rec.FrictionStatus == "PASS" ? AFS_CLR_OK : (rec.FrictionStatus == "WEAK" ? AFS_CLR_WARN : AFS_CLR_TEXT));
        }

      AFS_CreateLabel(AFS_ObjName(id+"_H"+IntegerToString(slot)), x + 10, ry, AFS_ClipText(head, 26), AFS_FontValue(), clr);
      AFS_CreateLabel(AFS_ObjName(id+"_T"+IntegerToString(slot)), x + 10, ry + 18, AFS_ClipText(tail, 28), AFS_FontLabel(), AFS_CLR_TEXT_DIM);
      ry += 46;
     }
  }

void AFS_DrawTraderNotesBlock(const int x,const int y,const int w,const int h)
  {
   AFS_CreateRectLabel(AFS_ObjName("TR_NOTES_BG"), x, y, w, h, AFS_CLR_PANEL, AFS_CLR_BORDER);
   AFS_DrawSectionTitle("TR_NOTES", x + 12, y + 12, "TRADER ATTENTION");

   int pass_count = AFS_CountFinalistsByStatus("PASS");
   int weak_count = AFS_CountFinalistsByStatus("WEAK");
   int fail_count = AFS_CountFinalistsByStatus("FAIL");

   string note1 = "Shortlist live | Finalists " + IntegerToString(g_state.MemoryShell.FinalistCount) +
                  " | PASS " + IntegerToString(pass_count) +
                  " | WEAK " + IntegerToString(weak_count);
   string note2 = "Output ready: " + (StringLen(g_state.PathState.FinalOutputFile) > 0 ? AFS_GetFinalOutputLeaf() : "pending");
   string note3 = (weak_count > 0
                   ? "PASS stays primary. WEAK remains visible as backup shortlist."
                   : "PASS finalists currently hold the visible shortlist.");
   string note4 = (fail_count > 0
                   ? "FAIL remains counted in scanner totals; shortlist keeps operator focus on selected names."
                   : "Surface focus remains on selected names and aggregate scanner state.");

   int ry = y + AFS_SectionBodyStart();
   AFS_CreateLabel(AFS_ObjName("TR_NOTE1"), x + 14, ry, AFS_ClipText(note1, 128), AFS_FontValue(), AFS_CLR_TEXT); ry += AFS_RowStep();
   AFS_CreateLabel(AFS_ObjName("TR_NOTE2"), x + 14, ry, AFS_ClipText(note2, 128), AFS_FontValue(), AFS_CLR_ACCENT); ry += AFS_RowStep();
   AFS_CreateLabel(AFS_ObjName("TR_NOTE3"), x + 14, ry, AFS_ClipText(note3, 128), AFS_FontValue(), AFS_CLR_TEXT_DIM); ry += AFS_RowStep();
   AFS_CreateLabel(AFS_ObjName("TR_NOTE4"), x + 14, ry, AFS_ClipText(note4, 128), AFS_FontValue(), fail_count > 0 ? AFS_CLR_WARN : AFS_CLR_TEXT_DIM);
  }

string AFS_BuildTraderLeadText(const string bucket,bool &used[])
  {
   int idx = AFS_FindBestFinalistIndexByBucket(bucket, used);
   if(idx < 0)
      return "-";

   used[idx] = true;
   AFS_UniverseSymbol rec = g_state.Universe[idx];

   string txt = bucket + ": #" + IntegerToString(rec.BucketRank) + " " + rec.Symbol +
                " " + rec.FrictionStatus +
                " " + AFS_FormatScore2(rec.TotalScore);

   if(g_state.ViewShowCorrelationPreview)
      txt += " | " + AFS_OutputSafeText(rec.CorrContextFlag, "CORR_PENDING");

   return txt;
  }

int AFS_FindFirstWeakFinalistIndex()
  {
   int best_idx = -1;

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!rec.FinalistSelected || rec.FrictionStatus != "WEAK")
         continue;

      if(best_idx < 0 || AFS_FinalOutputBetter(rec, g_state.Universe[best_idx]))
         best_idx = i;
     }

   return best_idx;
  }

string AFS_BuildTraderWeakBackupText()
  {
   int idx = AFS_FindFirstWeakFinalistIndex();
   if(idx < 0)
      return "No WEAK backup finalists";

   AFS_UniverseSymbol rec = g_state.Universe[idx];
   return rec.Symbol + " | " + AFS_OutputSafeText(rec.FrictionWeakReason, "WEAK_RUNTIME") +
          " | Score " + AFS_FormatScore2(rec.TotalScore);
  }

bool AFS_TraderBucketExists(string &buckets[],const string bucket)
  {
   for(int i = 0; i < ArraySize(buckets); i++)
      if(buckets[i] == bucket)
         return true;
   return false;
  }

void AFS_CollectTraderBuckets(string &buckets[])
  {
   ArrayResize(buckets, 0);

   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      AFS_UniverseSymbol rec = g_state.Universe[i];
      if(!rec.FinalistSelected)
         continue;

      string bucket = rec.PrimaryBucket;
      if(StringLen(bucket) == 0)
         bucket = "UNBUCKETED";

      if(!AFS_TraderBucketExists(buckets, bucket))
        {
         int pos = ArraySize(buckets);
         ArrayResize(buckets, pos + 1);
         buckets[pos] = bucket;
        }
     }
  }

int AFS_CountFinalistsByStatus(const string status)
  {
   int count = 0;
   for(int i = 0; i < ArraySize(g_state.Universe); i++)
     {
      if(!g_state.Universe[i].FinalistSelected)
         continue;
      if(g_state.Universe[i].FrictionStatus == status)
         count++;
     }
   return count;
  }




void AFS_DrawTraderHUD(const int x,const int y,const int w,const int h,const int rail_w)
  {
   int gap         = 12;
   int header_h    = 84;
   int main_w      = w - ((rail_w > 0) ? (rail_w + gap) : 0);
   int content_y   = y + header_h + 12;
   int top_h       = 108;
   int symbols_h   = 138;
   int agg_h       = 102;
   int notes_h     = (g_state.ViewShowNotes ? 112 : 0);

   AFS_DrawHeader(x, y, w, header_h);

   int pass_count            = AFS_CountFinalistsByStatus("PASS");
   int weak_count            = AFS_CountFinalistsByStatus("WEAK");
   int fail_count            = AFS_CountFinalistsByStatus("FAIL");
   int dossier_count         = AFS_CountPublishedTraderDossiers();
   int correlated_count      = AFS_CountCorrelatedFinalists();
   int live_finalists        = AFS_CountLiveFinalists();
   int trusted_tick_finalists = AFS_CountTickTrustedFinalists();

   string pipeline_band      = AFS_HUD_PipelineMaturityBand(correlated_count);
   string shortlist_band     = AFS_HUD_ShortlistBand(pass_count, weak_count, g_state.MemoryShell.FinalistCount);
   string correlation_band   = AFS_HUD_CorrelationBand(correlated_count, g_state.MemoryShell.FinalistCount);
   string dossier_band       = AFS_HUD_DossierFreshnessBand();
   string scanner_band       = AFS_HUD_ScannerConfidenceBand(pass_count, weak_count);
   string tactical_band      = AFS_HUD_TacticalBand(live_finalists, g_state.MemoryShell.FinalistCount);
   string publication_band   = AFS_HUD_ActivePublicationBand(dossier_count, g_state.MemoryShell.FinalistCount, live_finalists);
   string integrity_band     = AFS_HUD_DataIntegrityBand(trusted_tick_finalists, g_state.MemoryShell.FinalistCount);
   string execution_band     = AFS_HUD_ExecutionBand(live_finalists, g_state.MemoryShell.FinalistCount, pass_count);

   AFS_CreateRectLabel(AFS_ObjName("TR_TOP_BG"), x, content_y, main_w, top_h, AFS_CLR_PANEL, AFS_CLR_BORDER);
   AFS_DrawSectionTitle("TR_TOP", x + 12, content_y + 12, "TRADER SUMMARY");

   int ry = content_y + 34;
   AFS_DrawKeyValueRow("TR1", x + 14, ry, 126, "Mode", g_state.EffectiveModeText, AFS_CLR_OK, 24); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TR2", x + 14, ry, 126, "Server", g_state.ServerName, AFS_CLR_TEXT, 28); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TR3", x + 14, ry, 126, "Phase / Step", AFS_GetDisplayPhaseTag() + " / " + AFS_GetDisplayStepTag(), AFS_CLR_ACCENT, 24);
   AFS_DrawKeyValueRow("TR4", x + 390, content_y + 34, 126, "Universe", "Broker " + IntegerToString(g_state.MemoryShell.BrokerSymbolCount) + " | Eligible " + IntegerToString(g_state.MemoryShell.EligibleSymbolCount) + " | Scope " + IntegerToString(g_state.MemoryShell.UniverseCount), AFS_CLR_TEXT, 54);
   AFS_DrawKeyValueRow("TR5", x + 390, content_y + 53, 126, "Scanner", "Finalists " + IntegerToString(g_state.MemoryShell.FinalistCount) + " | PASS " + IntegerToString(pass_count) + " | WEAK " + IntegerToString(weak_count) + " | FAIL " + IntegerToString(fail_count), AFS_CLR_TEXT_DIM, 58);
   AFS_DrawKeyValueRow("TR6", x + 390, content_y + 72, 126, "Package", AFS_GetTraderPackageHudText(dossier_count), AFS_CLR_OK, 56);

   int symbol_y = content_y + top_h + gap;
   int mid_col_gap = 12;
   int mid_col_w   = (main_w - mid_col_gap) / 2;

   AFS_CreateRectLabel(AFS_ObjName("TR_COUNTS_BG"), x, symbol_y, mid_col_w, symbols_h, AFS_CLR_PANEL, AFS_CLR_BORDER);
   AFS_CreateRectLabel(AFS_ObjName("TR_PIPE_BG"), x + mid_col_w + mid_col_gap, symbol_y, mid_col_w, symbols_h, AFS_CLR_PANEL, AFS_CLR_BORDER);

   AFS_DrawSectionTitle("TR_COUNTS", x + 12, symbol_y + 12, "TRUST / READINESS");
   ry = symbol_y + 34;
   AFS_DrawKeyValueRow("TC1", x + 14, ry, 132, "Pipeline", pipeline_band, AFS_HUD_BandColor(pipeline_band), 12); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TC2", x + 14, ry, 132, "Shortlist", shortlist_band, AFS_HUD_BandColor(shortlist_band), 12); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TC3", x + 14, ry, 132, "Correlation", correlation_band, AFS_HUD_BandColor(correlation_band), 12); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TC4", x + 14, ry, 132, "Dossier", dossier_band, AFS_HUD_BandColor(dossier_band), 12); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TC5", x + 14, ry, 132, "Integrity", integrity_band, AFS_HUD_BandColor(integrity_band), 12); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TC6", x + 14, ry, 132, "Execution", execution_band, AFS_HUD_BandColor(execution_band), 12);

   int px = x + mid_col_w + mid_col_gap;
   AFS_DrawSectionTitle("TR_PIPE", px + 12, symbol_y + 12, "ACTIVE HEALTH");
   ry = symbol_y + 34;
   AFS_DrawKeyValueRow("TP1", px + 14, ry, 148, "Tactical", tactical_band, AFS_HUD_BandColor(tactical_band), 34); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TP2", px + 14, ry, 148, "Publication", publication_band, AFS_HUD_BandColor(publication_band), 34); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TP3", px + 14, ry, 148, "Scanner", scanner_band, AFS_HUD_BandColor(scanner_band), 34); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TP4", px + 14, ry, 148, "Live Finalists", IntegerToString(live_finalists) + "/" + IntegerToString(g_state.MemoryShell.FinalistCount), AFS_CLR_TEXT_DIM, 34); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TP5", px + 14, ry, 148, "Trusted Tick", IntegerToString(trusted_tick_finalists) + "/" + IntegerToString(g_state.MemoryShell.FinalistCount), AFS_CLR_TEXT_DIM, 34); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TP6", px + 14, ry, 148, "Dossiers", IntegerToString(dossier_count) + " published", dossier_count > 0 ? AFS_CLR_OK : AFS_CLR_TEXT_DIM, 34);

   int agg_y = symbol_y + symbols_h + gap;
   int agg_col_gap = 12;
   int agg_col_w   = (main_w - agg_col_gap) / 2;

   AFS_CreateRectLabel(AFS_ObjName("TR_AGG_LEFT_BG"), x, agg_y, agg_col_w, agg_h, AFS_CLR_PANEL_ALT, AFS_CLR_BORDER);
   AFS_CreateRectLabel(AFS_ObjName("TR_AGG_RIGHT_BG"), x + agg_col_w + agg_col_gap, agg_y, agg_col_w, agg_h, AFS_CLR_PANEL_ALT, AFS_CLR_BORDER);

   AFS_DrawSectionTitle("TR_AGG_L", x + 12, agg_y + 12, "SCANNER COUNTS");
   ry = agg_y + 34;
   AFS_DrawKeyValueRow("TRA1", x + 14, ry, 124, "Broker Total", IntegerToString(g_state.MemoryShell.BrokerSymbolCount), AFS_CLR_TEXT, 14); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TRA2", x + 14, ry, 124, "Eligible", IntegerToString(g_state.MemoryShell.EligibleSymbolCount), AFS_CLR_OK, 14); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TRA3", x + 14, ry, 124, "Active Scope", IntegerToString(g_state.MemoryShell.UniverseCount), AFS_CLR_ACCENT, 14); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TRA4", x + 14, ry, 124, "Surfaced", IntegerToString(g_state.MemoryShell.SurfaceCount) + " | Loaded " + IntegerToString(g_state.MemoryShell.SurfaceLoadedCount), AFS_CLR_TEXT_DIM, 28);

   int rx = x + agg_col_w + agg_col_gap;
   AFS_DrawSectionTitle("TR_AGG_R", rx + 12, agg_y + 12, "OPERATOR STATE");
   ry = agg_y + 34;
   AFS_DrawKeyValueRow("TRB1", rx + 14, ry, 124, "Chart", g_state.SymbolName + " / " + EnumToString(g_state.ChartTf), AFS_CLR_TEXT, 24); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TRB2", rx + 14, ry, 124, "Selection", "PASS " + IntegerToString(pass_count) + " | WEAK " + IntegerToString(weak_count) + " | Finalists " + IntegerToString(g_state.MemoryShell.FinalistCount), AFS_CLR_ACCENT, 44); ry += AFS_RowStep();
   AFS_DrawKeyValueRow("TRB3", rx + 14, ry, 124, "Correlation", IntegerToString(correlated_count) + "/" + IntegerToString(g_state.MemoryShell.FinalistCount) + " annotated", correlated_count > 0 ? AFS_CLR_OK : AFS_CLR_TEXT_DIM, 24); ry += AFS_RowStep();
   AFS_DrawWrappedKeyValueRow("TRB4", rx + 14, ry, 124, "State", AFS_GetRuntimeStateLine(), g_state.TimerPaused ? AFS_CLR_WARN : AFS_CLR_OK, 40, 58);

   if(g_state.ViewShowNotes)
     {
      int notes_y = agg_y + agg_h + gap;
      AFS_DrawTraderNotesBlock(x, notes_y, main_w, notes_h);
     }

   if(rail_w > 0)
      AFS_DrawControlRail(x + main_w + gap, content_y, rail_w, h - header_h - 12);
  }

void AFS_ApplyHUDProfileDefaults(const AFS_HUDProfile profile)
  {
   g_state.ActiveHUDProfile = profile;

   switch(profile)
     {
      case HUD_COMPACT:
         g_state.ViewShowModules     = false;
         g_state.ViewShowScheduling  = false;
         g_state.ViewShowScope       = false;
         g_state.ViewShowNotes       = HudCompactShowNotes;
         g_state.ViewShowDebugFooter = false;
         break;

      case HUD_NORMAL:
         g_state.ViewShowModules     = HudNormalShowModules;
         g_state.ViewShowScheduling  = HudNormalShowScheduling;
         g_state.ViewShowScope       = HudNormalShowScope;
         g_state.ViewShowNotes       = HudNormalShowNotes;
         g_state.ViewShowDebugFooter = false;
         break;

      case HUD_DEBUG:
         g_state.ViewShowModules     = true;
         g_state.ViewShowScheduling  = true;
         g_state.ViewShowScope       = true;
         g_state.ViewShowNotes       = true;
         g_state.ViewShowDebugFooter = true;
         break;
     }
  }

void AFS_DrawScannerPanel(const bool force=false)
  {
   if(!ShowHUD)
     {
      AFS_DeleteOwnedObjects();
      g_hudCreated = false;
      g_hudLayoutDirty = true;
      g_lastLayoutSignature = "";
      return;
     }

   datetime now = TimeCurrent();
   if(!force && g_hudCreated && !g_hudLayoutDirty && (now - g_state.LastHudAt) < AFS_HudRefreshCooldownSeconds())
      return;

   AFS_UpdateChartSizeCache();

   int x = HudX;
   int y = HudY;

   int w = PanelWidthPx;
   int h = PanelHeightPx;

   if(AutoFitPanel)
     {
      w = MathMin(PanelWidthPx,  g_chartWidthPx  - (HudX * 2));
      h = MathMin(PanelHeightPx, g_chartHeightPx - (HudY * 2));
     }

   if(AllowHudButtons && g_state.ViewShowControlRail)
     {
      int min_w = 940;
      if(w < min_w)
         w = MathMin(g_chartWidthPx - (HudX * 2), min_w);
     }

   if(w < 820) w = 820;
   if(h < 500) h = 500;

   int rail_w = 0;
   if(AllowHudButtons && g_state.ViewShowControlRail)
      rail_w = ControlRailWidthPx;

   string layout_sig = AFS_GetLayoutSignature();

   if(!g_hudCreated || g_hudLayoutDirty || layout_sig != g_lastLayoutSignature)
     {
      if(OwnChartDomain)
         AFS_PrepareScannerChart(false);

      AFS_DeleteOwnedObjects();
      g_hudCreated = false;
      g_hudLayoutDirty = false;
      g_lastLayoutSignature = layout_sig;
     }

   AFS_CreateRectLabel(AFS_ObjName("ROOT"), x, y, w, h, AFS_CLR_BG, AFS_CLR_BG);

   if(g_state.EffectiveMode == MODE_TRADER)
      AFS_DrawTraderHUD(x, y, w, h, rail_w);
   else
      AFS_DrawDevHUD(x, y, w, h, rail_w);

   g_hudCreated = true;
   g_state.LastHudAt = now;
   ChartRedraw();
  }


bool AFS_ShouldRunSurfaceScan()
  {
   if(AFS_GetStepNumber() < 5.0)
      return false;

   switch(PipelineTarget)
     {
      case PIPELINE_CLASSIFICATION:
         return false;
      default:
         return true;
     }
  }

string AFS_FormatSurfaceBatchState()
  {
   int total = ArraySize(g_state.Universe);
   if(total <= 0)
      return "No universe";

   int processed = g_state.MemoryShell.SurfaceLastBatchCount;
   int end_index = g_state.MemoryShell.SurfaceCursor - 1;
   if(end_index < 0)
      end_index = total - 1;

   int start_index = end_index - processed + 1;
   while(start_index < 0)
      start_index += total;

   if(processed <= 0)
      start_index = end_index;

   return IntegerToString(start_index) + "-" + IntegerToString(end_index) +
          " / " + IntegerToString(total) +
          " | Pass " + IntegerToString(g_state.MemoryShell.SurfacePassCount);
  }

void AFS_RunSurfaceScanCycle()
  {
   if(!AFS_ShouldRunSurfaceScan())
      return;

   int total = ArraySize(g_state.Universe);
   if(total <= 0)
     {
      g_state.MemoryShell.SurfaceLastBatchCount = 0;
      g_state.MarketCore.State  = MODULE_WARN;
      g_state.MarketCore.Detail = "Surface scan has no universe";
      return;
     }

   int batch = SurfaceBatchSize;
   if(batch < 1)
      batch = 1;
   if(batch > total)
      batch = total;

   int start_cursor = g_state.MemoryShell.SurfaceCursor;
   if(start_cursor < 0 || start_cursor >= total)
      start_cursor = 0;

   int processed = 0;
   int cursor    = start_cursor;
   int completed = 0;
   datetime now  = g_state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   for(int n = 0; n < batch; n++)
     {
      if(cursor >= total)
        {
         cursor = 0;
         completed++;
        }

      string detail = "";
      AFS_MC_RefreshSurfaceRecord(g_state.Universe[cursor], now, detail);

      processed++;
      cursor++;
     }

   if(cursor >= total)
     {
      cursor = 0;
      completed++;
     }

   g_state.MemoryShell.SurfaceCursor         = cursor;
   g_state.MemoryShell.SurfaceLastBatchCount = processed;
   g_state.MemoryShell.LastSurfaceAt         = now;
   if(completed > 0)
     {
      g_state.MemoryShell.SurfacePassCount  += completed;
      g_state.MemoryShell.LastFullSurfaceAt  = now;
     }

   AFS_RecalculateSurfaceDiagnostics();
   g_surfaceArtifactsDirty          = true;
   g_state.MarketCore.State         = MODULE_OK;
   g_state.MarketCore.Detail        = "Surface batch " + AFS_FormatSurfaceBatchState() +
                                      " | Scope=" + AFS_SurfaceCoverageText() +
                                      " | Fresh=" + IntegerToString(g_state.MemoryShell.SurfaceFreshCount) +
                                      " | NoQuote=" + IntegerToString(g_state.MemoryShell.SurfaceNoQuoteCount);

   AFS_DebugSurface("Surface cycle | Batch=" + IntegerToString(processed) +
                    " | Cursor=" + IntegerToString(g_state.MemoryShell.SurfaceCursor) +
                    " | FullPasses=" + IntegerToString(g_state.MemoryShell.SurfacePassCount) +
                    " | ScopeCovered=" + AFS_SurfaceCoverageText() +
                    " | LoadedCovered=" + AFS_SurfaceLoadedCoverageText() +
                    " | Fresh=" + IntegerToString(g_state.MemoryShell.SurfaceFreshCount) +
                    " | Stale=" + IntegerToString(g_state.MemoryShell.SurfaceStaleCount) +
                    " | NoQuote=" + IntegerToString(g_state.MemoryShell.SurfaceNoQuoteCount) +
                    " | Promoted=" + IntegerToString(g_state.MemoryShell.SurfacePromotedCount));
  }


void AFS_RunStep2Heartbeat()
  {
   g_state.LastTimerAt = TimeCurrent();

   datetime srv = TimeTradeServer();
   if(srv <= 0)
      srv = TimeCurrent();

   g_state.ServerTime = srv;
   g_state.SymbolName = _Symbol;
   g_state.ChartTf    = (ENUM_TIMEFRAMES)_Period;
   g_state.MemoryShell.LastTouchedAt = TimeCurrent();

   if(g_state.TimerPaused)
     {
      AFS_SetInfo("Timer paused from control rail.");
      AFS_DrawScannerPanel(false);
      return;
     }

   g_state.TimerCount++;

   AFS_RunSurfaceScanCycle();
   AFS_RunSpecScanCycle();
   AFS_RunHistoryScanCycle();
   AFS_RunFrictionScanCycle();
   AFS_RunSelectionCycle();
   AFS_RunCorrelationCycle();
   AFS_WriteArtifactsForCurrentStep();

   AFS_SetInfo(AFS_GetRuntimeStateLine());
   AFS_DrawScannerPanel(false);

   if(SnapshotMode)
     {
      EventKillTimer();
      g_state.TimerPaused = true;
      AFS_SetInfo("SnapshotMode stopped timer after first heartbeat.");
      AFS_DrawScannerPanel(true);
     }
  }

void AFS_HandleHudButton(const string obj_name)
  {
   string key = obj_name;
   StringReplace(key, AFS_OBJ_PREFIX + "BTN_", "");

   if(key == "MODE_DEV")
     {
      g_state.RequestedMode = MODE_DEV;
      AFS_ResolveEffectiveMode();
      AFS_RefreshOutputRoute();
      AFS_ResetLateStageCadence();
      AFS_WriteArtifactsForCurrentStep();
      AFS_SetInfoAndLog("Requested Dev Mode from HUD.");
     }
   else if(key == "MODE_TRADER")
     {
      g_state.RequestedMode = MODE_TRADER;
      AFS_ResolveEffectiveMode();
      AFS_RefreshOutputRoute();
      AFS_ResetLateStageCadence();
      AFS_WriteArtifactsForCurrentStep();

      if(g_state.ModeForcedToDev)
         AFS_SetInfoAndLog("Trader Mode request blocked by blueprint. Remaining in Dev Mode.");
      else
         AFS_SetInfoAndLog("Requested Trader Mode from HUD.");
     }
   else if(key == "HUD_COMPACT")
     {
      AFS_ApplyHUDProfileDefaults(HUD_COMPACT);
      AFS_SetInfoAndLog("HUD profile switched to Compact.");
     }
   else if(key == "HUD_NORMAL")
     {
      AFS_ApplyHUDProfileDefaults(HUD_NORMAL);
      AFS_SetInfoAndLog("HUD profile switched to Normal.");
     }
   else if(key == "HUD_DEBUG")
     {
      AFS_ApplyHUDProfileDefaults(HUD_DEBUG);
      AFS_SetInfoAndLog("HUD profile switched to Debug.");
     }
   else if(key == "TOGGLE_NOTES")
     {
      g_state.ViewShowNotes = !g_state.ViewShowNotes;
      AFS_SetInfoAndLog("Notes visibility toggled.");
     }
   else if(key == "TOGGLE_MODS")
     {
      g_state.ViewShowModules = !g_state.ViewShowModules;
      AFS_SetInfoAndLog("Module visibility toggled.");
     }
   else if(key == "TOGGLE_SCHED")
     {
      g_state.ViewShowScheduling = !g_state.ViewShowScheduling;
      AFS_SetInfoAndLog("Scheduling visibility toggled.");
     }
   else if(key == "TOGGLE_SCOPE")
     {
      g_state.ViewShowScope = !g_state.ViewShowScope;
      AFS_SetInfoAndLog("Output/memory visibility toggled.");
     }
   else if(key == "TOGGLE_CORR")
     {
      g_state.ViewShowCorrelationPreview = !g_state.ViewShowCorrelationPreview;
      AFS_SetInfoAndLog("Correlation preview visibility toggled.");
     }
   else if(key == "PAUSE")
     {
      g_state.TimerPaused = !g_state.TimerPaused;
      AFS_SetInfoAndLog(g_state.TimerPaused ? "Timer paused from HUD." : "Timer resumed from HUD.");
     }
   else if(key == "REFRESH")
     {
      datetime srv = TimeTradeServer();
      if(srv <= 0)
         srv = TimeCurrent();
      g_state.ServerTime = srv;

      if(AFS_GetStepNumber() >= 3.0)
         AFS_RunStep3UniverseLoader();

      if(AFS_GetStepNumber() >= 5.0)
        {
         AFS_RunSurfaceScanCycle();

         if(AFS_GetStepNumber() >= 6.0)
            AFS_RunSpecScanCycle();

         if(AFS_GetStepNumber() >= 7.0)
            AFS_RunHistoryScanCycle();
         if(AFS_GetStepNumber() >= 8.0)
            AFS_RunFrictionScanCycle();
        }

      AFS_ResetLateStageCadence();

      if(AFS_GetStepNumber() >= 9.0)
         AFS_RunSelectionCycle();
      if(AFS_GetStepNumber() >= 10.0)
         AFS_RunCorrelationCycle();

      g_surfaceArtifactsDirty = true;
      AFS_WriteArtifactsForCurrentStep();
      AFS_SetInfoAndLog("HUD refresh completed without destructive runtime reset.");
     }

   g_hudLayoutDirty = true;
   AFS_DrawScannerPanel(true);
  }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ZeroMemory(g_state);

   g_state.InitCount      = 1;
   g_state.ChartId        = ChartID();
   g_state.SymbolName     = _Symbol;
   g_state.ChartTf        = (ENUM_TIMEFRAMES)_Period;
   g_state.ServerName     = AFS_SafeServerName();
   g_state.ServerTime     = TimeTradeServer();
   if(g_state.ServerTime <= 0)
      g_state.ServerTime = TimeCurrent();

   g_state.BuildStamp     = BuildLabel;
   g_state.Enabled        = EnableEA;
   g_state.LastWarning    = "";
   g_state.LastError      = "";
   g_state.LastInfo       = "";
   g_state.RequestedMode  = EffectiveModeSelector;

   g_hudCreated           = false;
   g_hudLayoutDirty       = true;
   g_surfaceArtifactsDirty= false;
   g_lastLayoutSignature  = "";

   AFS_SetupStepShell();
   AFS_InitViewState();
   AFS_ResolveEffectiveMode();

   if(!AFS_ValidateInputs())
      return INIT_FAILED;

   string path_err = "";
   if(!AFS_OD_BuildOutputShell(OutputRootFolderName,
                               g_state.ServerName,
                               UseCommonFilesRoot,
                               g_state.PathState,
                               path_err))
     {
      g_state.LastError = path_err;
      AFS_LogError(g_state.LastError);
      return INIT_FAILED;
     }

   AFS_InitMemoryShell();
   AFS_Log("Memory shell initialized.");

   string class_err = "";
   if(!AFS_CL_LoadEmbedded(g_state, class_err))
     {
      g_state.LastError = class_err;
      AFS_LogError(g_state.LastError);
      return INIT_FAILED;
     }

   AFS_Log("Embedded classification map loaded.");
   AFS_RefreshOutputRoute();
   AFS_ApplyStep2ModuleStates();

   if(AFS_GetStepNumber() >= 3.0)
      AFS_RunStep3UniverseLoader();

   if(AFS_GetStepNumber() >= 5.0)
     {
      AFS_ResetStep5Runtime("INIT_STEP5_RUNTIME");
      if(AFS_GetStepNumber() >= 6.0)
         AFS_ResetStep6Runtime("INIT_STEP6_RUNTIME");
      if(AFS_GetStepNumber() >= 8.0)
         AFS_ResetStep8Runtime("INIT_STEP8_RUNTIME");
      AFS_RunSurfaceScanCycle();
      if(AFS_GetStepNumber() >= 6.0)
         AFS_RunSpecScanCycle();
      if(AFS_GetStepNumber() >= 8.0)
         AFS_LoadStep8WarmState();
     }

   if(AFS_GetStepNumber() >= 9.0)
      AFS_RunSelectionCycle();
   if(AFS_GetStepNumber() >= 10.0)
      AFS_RunCorrelationCycle();

   AFS_WriteArtifactsForCurrentStep();

   // --- FIX: only init path may do chart-domain destructive clear ---
   AFS_PrepareScannerChart(true);
   AFS_UpdateChartSizeCache();
   AFS_DeleteOwnedObjects();

   if(!EnableEA)
     {
      g_state.Initialized = true;
      g_state.LastWarning = "EnableEA=false. Wrapper loaded but scanner is idle.";
      AFS_DrawScannerPanel(true);
      AFS_Log("Initialized in idle state because EnableEA=false");
      return INIT_SUCCEEDED;
     }

   EventSetTimer(MathMax(1, TimerSeconds));
   g_state.Initialized = true;

   AFS_Log("Initialized successfully. Mode=" + g_state.EffectiveModeText +
           ", Phase=" + CurrentPhaseTag +
           ", Step=" + CurrentStepTag +
           ", Server=" + g_state.ServerName +
           ", Build=" + BuildLabel +
           ", Version=" + AFS_VERSION_TEXT);

   AFS_Log("Output shell ready. Root=" + g_state.PathState.RootFolder +
           ", ServerFolder=" + g_state.PathState.ServerFolder +
           
           ", Storage=" + (g_state.PathState.UseCommonFiles ? "COMMON" : "LOCAL"));

   if(g_state.ModeForcedToDev)
      AFS_LogWarn(g_state.LastWarning);

   AFS_SetInfoAndLog("Phase 5 publication hardening and downstream execution permission are active while protected core runtime stages remain unchanged.");
   if(DebugVerbose)
      AFS_OD_LogDebug(g_state.PathState, "Phase 5 debug bootstrap: final output route preserved, active-publication freshness hardened, and downstream execution-permission labels armed without touching protected core stages.");
   if(DebugVerbose)
      AFS_Debug("Phase 5 debug bootstrap: verbose diagnostics enabled for downstream-only publication-hardening and execution-permission visibility.");

   AFS_DrawScannerPanel(true);
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(AFS_GetStepNumber() >= 8.0)
      AFS_SaveStep8WarmState();

   EventKillTimer();
   AFS_DeleteOwnedObjects();
   ChartRedraw();
   g_hudCreated = false;
   g_hudLayoutDirty = true;
   g_surfaceArtifactsDirty = false;
   g_lastLayoutSignature = "";
   AFS_ResetLateStageCadence();

   string why = "UNKNOWN";
   switch(reason)
     {
      case REASON_PROGRAM:     why = "PROGRAM";     break;
      case REASON_REMOVE:      why = "REMOVE";      break;
      case REASON_RECOMPILE:   why = "RECOMPILE";   break;
      case REASON_CHARTCHANGE: why = "CHARTCHANGE"; break;
      case REASON_CHARTCLOSE:  why = "CHARTCLOSE";  break;
      case REASON_PARAMETERS:  why = "PARAMETERS";  break;
      case REASON_ACCOUNT:     why = "ACCOUNT";     break;
      case REASON_TEMPLATE:    why = "TEMPLATE";    break;
      case REASON_INITFAILED:  why = "INITFAILED";  break;
      case REASON_CLOSE:       why = "CLOSE";       break;
     }

   AFS_Log("Deinitialized. Reason=" + why);
  }

//+------------------------------------------------------------------+
//| Timer event                                                      |
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(!g_state.Initialized)
      return;

   if(!EnableEA)
     {
      datetime srv = TimeTradeServer();
      if(srv <= 0)
         srv = TimeCurrent();
      g_state.ServerTime = srv;
      g_state.MemoryShell.LastTouchedAt = TimeCurrent();
      AFS_DrawScannerPanel(false);
      return;
     }

   AFS_RunStep2Heartbeat();
  }

//+------------------------------------------------------------------+
//| Tick event                                                       |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Step 3 intentionally remains timer-driven only.
   // No scan work on tick yet.
  }

//+------------------------------------------------------------------+
//| Chart event                                                      |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id == CHARTEVENT_CHART_CHANGE)
     {
      g_hudLayoutDirty = true;
      AFS_DrawScannerPanel(true);
      return;
     }

   if(id == CHARTEVENT_OBJECT_CLICK)
     {
      if(StringFind(sparam, AFS_ObjName("BTN_")) == 0)
         AFS_HandleHudButton(sparam);
     }
  }
//+------------------------------------------------------------------+