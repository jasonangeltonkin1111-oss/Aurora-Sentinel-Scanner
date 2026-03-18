//+------------------------------------------------------------------+
//|      AURORA_StructureEA_Phase1_Test.mq5                          |
//|      Phase-1: Raw geometry + core indicators + rich JSON dumps   |
//|      Testing-scale defaults (you can scale via EA inputs)        |
//+------------------------------------------------------------------+
#property strict

//============================= INPUTS ==============================
input bool   TestMode                = true;
input int    TestRefreshMinutes      = 5;

input string SymbolsCSV              = "EURUSD";   // comma-separated
input int    MaxSymbols              = 3;          // cap in test mode (safety)

input string TimeframesCSV           = "H1";       // e.g. "M15,H1,H4,D1"
input int    BarsToLoad              = 300;        // context bars loaded
input int    BarsToExport            = 100;        // last N bars exported
input int    SwingLookback           = 2;          // fractal lookback

input bool   RecalcEvenIfNoNewBar    = false;      // for testing only

input bool   ExportRates             = true;
input bool   ExportIndicators        = true;
input bool   ExportSwings            = true;
input bool   ExportStructure         = true;
input bool   ExportMarketState       = true;

input bool   EnableCycleAlerts       = true;
input bool   EnablePopupAlert        = true;
input bool   EnableSoundAlert        = true;

input string OutputRootFolder        = "AURORA_PHASE1_TEST"; // under MQL5/Files/

//============================= GLOBALS =============================
ulong g_cycle_id = 0;

// Parsed symbols/timeframes
string g_syms[];
int    g_tfs[];         // store ENUM_TIMEFRAMES as int
string g_tf_names[];

// Indicator handles per symbol-tf (flat arrays)
struct STCtx
{
   string   sym;
   int      tf;
   string   tf_name;

   // handles
   int hEMA20, hEMA50, hEMA200;
   int hATR14, hATR50;
   int hRSI14;
   int hStd20;
   int hBB;

   datetime last_closed_bar_time; // time of bar[1]
};
STCtx g_ctx[];

//============================= HELPERS =============================
string JsonEscape(string s)
{
   StringReplace(s,"\\","\\\\");
   StringReplace(s,"\"","\\\"");
   StringReplace(s,"\r","\\r");
   StringReplace(s,"\n","\\n");
   StringReplace(s,"\t","\\t");
   return s;
}

string BoolStr(const bool v)
{
   if(v)
      return "true";
   else
      return "false";
}

string TFName(const int tf)
{
   switch((ENUM_TIMEFRAMES)tf)
   {
      case PERIOD_M1:  return "M1";
      case PERIOD_M5:  return "M5";
      case PERIOD_M15: return "M15";
      case PERIOD_M30: return "M30";
      case PERIOD_H1:  return "H1";
      case PERIOD_H4:  return "H4";
      case PERIOD_D1:  return "D1";
      case PERIOD_W1:  return "W1";
      default: return IntegerToString(tf);
   }
}

int TFFromName(string s)
{
   StringTrimLeft(s);
   StringTrimRight(s);
   s = StringToUpper(s);
   if(s=="M1")  return (int)PERIOD_M1;
   if(s=="M5")  return (int)PERIOD_M5;
   if(s=="M15") return (int)PERIOD_M15;
   if(s=="M30") return (int)PERIOD_M30;
   if(s=="H1")  return (int)PERIOD_H1;
   if(s=="H4")  return (int)PERIOD_H4;
   if(s=="D1")  return (int)PERIOD_D1;
   if(s=="W1")  return (int)PERIOD_W1;
   return (int)PERIOD_H1;
}

bool EnsureFolder(const string rel)
{
   // rel is relative under MQL5/Files/
   // Create nested folders step by step
   string parts[];
   int n = StringSplit(rel,'/',parts);
   if(n<=0) return false;

   string path="";
   for(int i=0;i<n;i++)
   {
      if(parts[i]=="") continue;
      if(path=="") path = parts[i];
      else path += "/" + parts[i];
      FolderCreate(path);
   }
   return true;
}

string DateFolder()
{
   MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
   string y = IntegerToString(dt.year);
   string m = IntegerToString(dt.mon); if(dt.mon<10) m="0"+m;
   string d = IntegerToString(dt.day); if(dt.day<10) d="0"+d;
   return y+"-"+m+"-"+d;
}

bool AtomicWriteBegin(const string final_rel, int &fh, string &tmp_rel)
{
   tmp_rel = final_rel + ".tmp";
   FileDelete(tmp_rel);
   fh = FileOpen(tmp_rel, FILE_WRITE|FILE_TXT);
   return (fh != INVALID_HANDLE);
}

bool AtomicWriteEnd(const string final_rel, const int fh, const string tmp_rel)
{
   FileFlush(fh);
   FileClose(fh);
   FileDelete(final_rel);
   // Move tmp -> final
   if(!FileMove(tmp_rel, 0, final_rel, 0))
   {
      // If move fails, keep tmp for debugging
      return false;
   }
   return true;
}

//============================= PARSE INPUTS =========================
void ParseSymbols()
{
   ArrayResize(g_syms,0);

   string parts[];
   int n = StringSplit(SymbolsCSV, ',', parts);
   for(int i=0;i<n;i++)
   {
      string s = parts[i];
      StringTrimLeft(s);
      StringTrimRight(s);
      if(s=="") continue;
      if(!SymbolSelect(s,true)) continue;

      int k = ArraySize(g_syms);
      ArrayResize(g_syms,k+1);
      g_syms[k]=s;

      if(TestMode && (k+1)>=MaxSymbols) break;
   }

   // fallback to chart symbol
   if(ArraySize(g_syms)==0)
   {
      string s = _Symbol;
      SymbolSelect(s,true);
      ArrayResize(g_syms,1);
      g_syms[0]=s;
   }
}

void ParseTFs()
{
   ArrayResize(g_tfs,0);
   ArrayResize(g_tf_names,0);

   string parts[];
   int n = StringSplit(TimeframesCSV, ',', parts);
   for(int i=0;i<n;i++)
   {
      string t = parts[i];
      StringTrimLeft(t);
      StringTrimRight(t);
      if(t=="") continue;

      int tf = TFFromName(t);

      int k = ArraySize(g_tfs);
      ArrayResize(g_tfs,k+1);
      ArrayResize(g_tf_names,k+1);
      g_tfs[k]=tf;
      g_tf_names[k]=TFName(tf);
   }

   if(ArraySize(g_tfs)==0)
   {
      ArrayResize(g_tfs,1);
      ArrayResize(g_tf_names,1);
      g_tfs[0]=(int)PERIOD_H1;
      g_tf_names[0]="H1";
   }
}

//============================= HANDLES ==============================
bool CreateHandlesFor(STCtx &c)
{
   c.hEMA20  = iMA(c.sym, (ENUM_TIMEFRAMES)c.tf, 20, 0, MODE_EMA, PRICE_CLOSE);
   c.hEMA50  = iMA(c.sym, (ENUM_TIMEFRAMES)c.tf, 50, 0, MODE_EMA, PRICE_CLOSE);
   c.hEMA200 = iMA(c.sym, (ENUM_TIMEFRAMES)c.tf, 200,0, MODE_EMA, PRICE_CLOSE);

   c.hATR14  = iATR(c.sym, (ENUM_TIMEFRAMES)c.tf, 14);
   c.hATR50  = iATR(c.sym, (ENUM_TIMEFRAMES)c.tf, 50);

   c.hRSI14  = iRSI(c.sym, (ENUM_TIMEFRAMES)c.tf, 14, PRICE_CLOSE);
   c.hStd20  = iStdDev(c.sym, (ENUM_TIMEFRAMES)c.tf, 20, 0, MODE_SMA, PRICE_CLOSE);

   c.hBB     = iBands(c.sym, (ENUM_TIMEFRAMES)c.tf, 20, 0, 2.0, PRICE_CLOSE);

   if(c.hEMA20==INVALID_HANDLE || c.hEMA50==INVALID_HANDLE || c.hEMA200==INVALID_HANDLE ||
      c.hATR14==INVALID_HANDLE || c.hATR50==INVALID_HANDLE ||
      c.hRSI14==INVALID_HANDLE || c.hStd20==INVALID_HANDLE ||
      c.hBB==INVALID_HANDLE)
      return false;

   c.last_closed_bar_time = 0;
   return true;
}

void ReleaseHandlesFor(const STCtx &c)
{
   if(c.hEMA20!=INVALID_HANDLE)  IndicatorRelease(c.hEMA20);
   if(c.hEMA50!=INVALID_HANDLE)  IndicatorRelease(c.hEMA50);
   if(c.hEMA200!=INVALID_HANDLE) IndicatorRelease(c.hEMA200);
   if(c.hATR14!=INVALID_HANDLE)  IndicatorRelease(c.hATR14);
   if(c.hATR50!=INVALID_HANDLE)  IndicatorRelease(c.hATR50);
   if(c.hRSI14!=INVALID_HANDLE)  IndicatorRelease(c.hRSI14);
   if(c.hStd20!=INVALID_HANDLE)  IndicatorRelease(c.hStd20);
   if(c.hBB!=INVALID_HANDLE)     IndicatorRelease(c.hBB);
}

//============================= SWINGS ==============================
bool IsSwingHigh(const double &high[], const int i, const int lookback)
{
   for(int j=1;j<=lookback;j++)
      if(high[i] <= high[i-j] || high[i] <= high[i+j]) return false;
   return true;
}

bool IsSwingLow(const double &low[], const int i, const int lookback)
{
   for(int j=1;j<=lookback;j++)
      if(low[i] >= low[i-j] || low[i] >= low[i+j]) return false;
   return true;
}

bool FindLastTwoSwingPoints(const double &high[], const double &low[], const int bars,
                           const int lookback, const bool wantHigh,
                           int &idx1, double &px1, int &idx2, double &px2)
{
   idx1=-1; idx2=-1; px1=0; px2=0;
   int found=0;

   for(int i=lookback; i<bars-lookback; i++) // series: i small = recent
   {
      bool ok = wantHigh ? IsSwingHigh(high,i,lookback) : IsSwingLow(low,i,lookback);
      if(!ok) continue;

      if(found==0){ idx1=i; px1= wantHigh?high[i]:low[i]; found++; continue; }
      if(found==1){ idx2=i; px2= wantHigh?high[i]:low[i]; found++; break; }
   }
   return (found==2);
}

//============================= JSON EXPORTS =========================
string BaseDayDir()
{
   return OutputRootFolder + "/" + DateFolder();
}

string ComponentDir(const string tf_name)
{
   return BaseDayDir() + "/components/" + tf_name;
}

string MarketStateDir(const string tf_name)
{
   return BaseDayDir() + "/market_state/" + tf_name;
}

void ExportRunMeta(const ulong cycle_id, const double duration_ms, const int symCount, const int tfCount)
{
   string dir = BaseDayDir();
   EnsureFolder(dir);

   string fn = dir + "/run_meta.json";
   int f; string tmp;
   if(!AtomicWriteBegin(fn,f,tmp)) return;

   FileWriteString(f,"{\n");
   FileWriteString(f,"  \"cycle_id\":"+IntegerToString((int)cycle_id)+",\n");
   FileWriteString(f,"  \"generated_at\":\""+JsonEscape(TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS))+"\",\n");
   FileWriteString(f,"  \"duration_ms\":"+DoubleToString(duration_ms,2)+",\n");
   FileWriteString(f,"  \"symbols_count\":"+IntegerToString(symCount)+",\n");
   FileWriteString(f,"  \"timeframes_count\":"+IntegerToString(tfCount)+",\n");
   FileWriteString(f,"  \"bars_loaded\":"+IntegerToString(BarsToLoad)+",\n");
   FileWriteString(f,"  \"bars_exported\":"+IntegerToString(BarsToExport)+",\n");
   string tm = BoolStr(TestMode);
   FileWriteString(f,"  \"test_mode\":"+tm+"\n");
   FileWriteString(f,"}\n");

   AtomicWriteEnd(fn,f,tmp);
}

//============================= CORE PER SYMBOL/TF ===================
bool RunOne(const STCtx &c)
{
   // New closed bar time = bar[1]
   datetime t1 = iTime(c.sym, (ENUM_TIMEFRAMES)c.tf, 1);
   if(t1<=0) return false;

   // If no new closed bar and not forcing recalculation, skip
   if(!RecalcEvenIfNoNewBar && t1 == c.last_closed_bar_time)
      return false;

   // We need rates
   MqlRates rates[];
   ArraySetAsSeries(rates,true);

   int got = CopyRates(c.sym, (ENUM_TIMEFRAMES)c.tf, 0, BarsToLoad, rates);
   if(got < BarsToLoad) return false;

   // Extract arrays
   double open[], high[], low[], close[];
   long   v_tick[];
   long   v_real[];
   datetime t[];

   ArrayResize(open,got);
   ArrayResize(high,got);
   ArrayResize(low,got);
   ArrayResize(close,got);
   ArrayResize(v_tick,got);
   ArrayResize(v_real,got);
   ArrayResize(t,got);

   ArraySetAsSeries(open,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(v_tick,true);
   ArraySetAsSeries(v_real,true);
   ArraySetAsSeries(t,true);

   for(int i=0;i<got;i++)
   {
      open[i]=rates[i].open;
      high[i]=rates[i].high;
      low[i]=rates[i].low;
      close[i]=rates[i].close;
      v_tick[i]=rates[i].tick_volume;
      v_real[i]=rates[i].real_volume;
      t[i]=rates[i].time;
   }

   // Indicator buffers
   double ema20[], ema50[], ema200[], atr14[], atr50[], rsi14[], std20[];
   double bb_up[], bb_mid[], bb_low[];

   ArraySetAsSeries(ema20,true); ArraySetAsSeries(ema50,true); ArraySetAsSeries(ema200,true);
   ArraySetAsSeries(atr14,true); ArraySetAsSeries(atr50,true); ArraySetAsSeries(rsi14,true);
   ArraySetAsSeries(std20,true);
   ArraySetAsSeries(bb_up,true); ArraySetAsSeries(bb_mid,true); ArraySetAsSeries(bb_low,true);

   ArrayResize(ema20,got); ArrayResize(ema50,got); ArrayResize(ema200,got);
   ArrayResize(atr14,got); ArrayResize(atr50,got); ArrayResize(rsi14,got);
   ArrayResize(std20,got);
   ArrayResize(bb_up,got); ArrayResize(bb_mid,got); ArrayResize(bb_low,got);

   if(CopyBuffer(c.hEMA20, 0, 0, got, ema20) < got) return false;
   if(CopyBuffer(c.hEMA50, 0, 0, got, ema50) < got) return false;
   if(CopyBuffer(c.hEMA200,0, 0, got, ema200) < got) return false;

   if(CopyBuffer(c.hATR14, 0, 0, got, atr14) < got) return false;
   if(CopyBuffer(c.hATR50, 0, 0, got, atr50) < got) return false;

   if(CopyBuffer(c.hRSI14, 0, 0, got, rsi14) < got) return false;
   if(CopyBuffer(c.hStd20, 0, 0, got, std20) < got) return false;

   // iBands buffers: 0=upper,1=base,2=lower
   if(CopyBuffer(c.hBB, 0, 0, got, bb_up) < got) return false;
   if(CopyBuffer(c.hBB, 1, 0, got, bb_mid) < got) return false;
   if(CopyBuffer(c.hBB, 2, 0, got, bb_low) < got) return false;

   // Swings (flags for exported window)
   int expN = MathMin(BarsToExport, got-2);
   if(expN<10) expN = MathMin(got, 10);

   bool isSwingH[], isSwingL[];
   ArrayResize(isSwingH, expN);
   ArrayResize(isSwingL, expN);

   for(int i=0;i<expN;i++){ isSwingH[i]=false; isSwingL[i]=false; }

   // For per-bar flags we test swings only where window allows
   for(int i=SwingLookback; i<got-SwingLookback; i++)
   {
      if(i<expN)
      {
         if(IsSwingHigh(high,i,SwingLookback)) isSwingH[i]=true;
         if(IsSwingLow(low,i,SwingLookback))  isSwingL[i]=true;
      }
   }

   // Last two swing highs/lows for structure
   int sh1, sh2, sl1, sl2;
   double ph1, ph2, pl1, pl2;
   bool okH = FindLastTwoSwingPoints(high,low,got,SwingLookback,true, sh1,ph1, sh2,ph2);
   bool okL = FindLastTwoSwingPoints(high,low,got,SwingLookback,false,sl1,pl1, sl2,pl2);

   string trend="range";
   if(okH && okL)
   {
      if(ph1>ph2 && pl1>pl2) trend="bull";
      else if(ph1<ph2 && pl1<pl2) trend="bear";
      else trend="range";
   }

   // BOS/CHOCH using last CLOSED candle (index 1)
   double last_close = close[1];
   datetime last_close_time = t[1];

   bool bos_up=false, bos_down=false, choch_up=false, choch_down=false;
   double broken_level=0;

   if(okH && last_close > ph1){ bos_up=true; broken_level=ph1; }
   if(okL && last_close < pl1){ bos_down=true; broken_level=pl1; }

   if(trend=="bull" && bos_down){ choch_down=true; }
   if(trend=="bear" && bos_up){ choch_up=true; }

   // Anchors (Phase-1 deterministic)
   int origin_bar_index = 1; // last closed bar
   datetime origin_time = last_close_time;
   double structure_break_price = broken_level;

   // Invalidation geometry
   double point = SymbolInfoDouble(c.sym, SYMBOL_POINT);
   double invalid_px=0; string invalid_type="UNDEFINED";
   if(trend=="bull" && okL){ invalid_px=pl1; invalid_type="swing_low"; }
   else if(trend=="bear" && okH){ invalid_px=ph1; invalid_type="swing_high"; }
   else
   {
      // fallback
      if(okL){ invalid_px=pl1; invalid_type="swing_low"; }
      else if(okH){ invalid_px=ph1; invalid_type="swing_high"; }
   }

   // Objective geometry (simple measured move)
   double obj_px=0; string obj_type="UNDEFINED";
   if(okH && okL)
   {
      double leg = MathAbs(ph1 - pl1);
      if(trend=="bull"){ obj_px = ph1 + leg; obj_type="measured_move_1x"; }
      else if(trend=="bear"){ obj_px = pl1 - leg; obj_type="measured_move_1x"; }
      else { obj_px = last_close + (leg*0.5); obj_type="measured_move_0_5x"; }
   }

   // Distances + RR
   double dist_inv_pts = (point>0 && invalid_px>0) ? MathAbs(last_close - invalid_px)/point : 0;
   double dist_obj_pts = (point>0 && obj_px>0) ? MathAbs(obj_px - last_close)/point : 0;
   double rr = (dist_inv_pts>0 ? dist_obj_pts/dist_inv_pts : 0);

   // Regime age bars proxy: bars since last swing in direction (Phase-1 simple)
   int regime_age_bars = 0;
   if(trend=="bull" && okL) regime_age_bars = sl1 - 1;
   else if(trend=="bear" && okH) regime_age_bars = sh1 - 1;
   if(regime_age_bars < 0) regime_age_bars = 0;

   // Compression duration: consecutive bars where ATR14/ATR50 < 0.8 (closed bars)
   int compression_bars = 0;
   for(int i=1;i<MathMin(got, 200); i++)
   {
      if(atr50[i] <= 0) break;
      double ratio = atr14[i]/atr50[i];
      if(ratio < 0.8) compression_bars++;
      else break;
   }

   // Current quotes
   double bid = SymbolInfoDouble(c.sym, SYMBOL_BID);
   double ask = SymbolInfoDouble(c.sym, SYMBOL_ASK);
   long spread_points = 0;
   if(point>0 && bid>0 && ask>0) spread_points = (long)((ask-bid)/point);

   //================== WRITE OUTPUTS ===================
   string compDir = ComponentDir(c.tf_name);
   string mktDir  = MarketStateDir(c.tf_name);
   EnsureFolder(compDir);
   EnsureFolder(mktDir);

   // 1) rates component
   if(ExportRates)
   {
      string fn = compDir + "/" + c.sym + "_rates.json";
      int f; string tmp;
      if(AtomicWriteBegin(fn,f,tmp))
      {
         FileWriteString(f,"{\n");
         FileWriteString(f,"  \"cycle_id\":"+IntegerToString((int)g_cycle_id)+",\n");
         FileWriteString(f,"  \"symbol\":\""+JsonEscape(c.sym)+"\",\n");
         FileWriteString(f,"  \"timeframe\":\""+c.tf_name+"\",\n");
         FileWriteString(f,"  \"bars_exported\":"+IntegerToString(expN)+",\n");
         FileWriteString(f,"  \"bars\":[\n");
         for(int i=expN-1;i>=0;i--) // oldest -> newest for readability
         {
            string ts = TimeToString(t[i], TIME_DATE|TIME_SECONDS);
            FileWriteString(f,
               "    {\"t\":\""+JsonEscape(ts)+"\",\"o\":"+DoubleToString(open[i],6)+
               ",\"h\":"+DoubleToString(high[i],6)+",\"l\":"+DoubleToString(low[i],6)+
               ",\"c\":"+DoubleToString(close[i],6)+",\"v_tick\":"+IntegerToString((int)v_tick[i])+
               ",\"v_real\":"+IntegerToString((int)v_real[i])+"}"
            );
            if(i>0) FileWriteString(f,",\n"); else FileWriteString(f,"\n");
         }
         FileWriteString(f,"  ]\n}\n");
         AtomicWriteEnd(fn,f,tmp);
      }
   }

   // 2) indicators component
   if(ExportIndicators)
   {
      string fn = compDir + "/" + c.sym + "_indicators.json";
      int f; string tmp;
      if(AtomicWriteBegin(fn,f,tmp))
      {
         FileWriteString(f,"{\n");
         FileWriteString(f,"  \"cycle_id\":"+IntegerToString((int)g_cycle_id)+",\n");
         FileWriteString(f,"  \"symbol\":\""+JsonEscape(c.sym)+"\",\n");
         FileWriteString(f,"  \"timeframe\":\""+c.tf_name+"\",\n");
         FileWriteString(f,"  \"bars_exported\":"+IntegerToString(expN)+",\n");
         FileWriteString(f,"  \"current\":{\n");
         FileWriteString(f,"    \"ema20\":"+DoubleToString(ema20[1],6)+",\"ema50\":"+DoubleToString(ema50[1],6)+",\"ema200\":"+DoubleToString(ema200[1],6)+",\n");
         FileWriteString(f,"    \"atr14\":"+DoubleToString(atr14[1],6)+",\"atr50\":"+DoubleToString(atr50[1],6)+",\"rsi14\":"+DoubleToString(rsi14[1],2)+",\n");
         FileWriteString(f,"    \"std20\":"+DoubleToString(std20[1],6)+",\n");
         FileWriteString(f,"    \"bb_up\":"+DoubleToString(bb_up[1],6)+",\"bb_mid\":"+DoubleToString(bb_mid[1],6)+",\"bb_low\":"+DoubleToString(bb_low[1],6)+",\n");
         FileWriteString(f,"    \"bb_width\":"+DoubleToString((bb_up[1]-bb_low[1]),6)+",\n");
         FileWriteString(f,"    \"atr_ratio_14_50\":"+(atr50[1]>0?DoubleToString(atr14[1]/atr50[1],6):"0")+"\n");
         FileWriteString(f,"  },\n");
         FileWriteString(f,"  \"bars\":[\n");
         for(int i=expN-1;i>=0;i--)
         {
            FileWriteString(f,
               "    {\"ema20\":"+DoubleToString(ema20[i],6)+",\"ema50\":"+DoubleToString(ema50[i],6)+",\"ema200\":"+DoubleToString(ema200[i],6)+
               ",\"atr14\":"+DoubleToString(atr14[i],6)+",\"atr50\":"+DoubleToString(atr50[i],6)+",\"rsi14\":"+DoubleToString(rsi14[i],2)+
               ",\"std20\":"+DoubleToString(std20[i],6)+",\"bb_up\":"+DoubleToString(bb_up[i],6)+",\"bb_mid\":"+DoubleToString(bb_mid[i],6)+",\"bb_low\":"+DoubleToString(bb_low[i],6)+
               ",\"bb_width\":"+DoubleToString((bb_up[i]-bb_low[i]),6)+"}"
            );
            if(i>0) FileWriteString(f,",\n"); else FileWriteString(f,"\n");
         }
         FileWriteString(f,"  ]\n}\n");
         AtomicWriteEnd(fn,f,tmp);
      }
   }

   // 3) swings component
   if(ExportSwings)
   {
      string fn = compDir + "/" + c.sym + "_swings.json";
      int f; string tmp;
      if(AtomicWriteBegin(fn,f,tmp))
      {
         FileWriteString(f,"{\n");
         FileWriteString(f,"  \"cycle_id\":"+IntegerToString((int)g_cycle_id)+",\n");
         FileWriteString(f,"  \"symbol\":\""+JsonEscape(c.sym)+"\",\n");
         FileWriteString(f,"  \"timeframe\":\""+c.tf_name+"\",\n");
         FileWriteString(f,"  \"swing_lookback\":"+IntegerToString(SwingLookback)+",\n");
         FileWriteString(f,"  \"last_two_swing_highs\":{\n");
         FileWriteString(f,"    \"idx1\":"+IntegerToString(sh1)+",\"px1\":"+DoubleToString(ph1,6)+",\"idx2\":"+IntegerToString(sh2)+",\"px2\":"+DoubleToString(ph2,6)+"\n");
         FileWriteString(f,"  },\n");
         FileWriteString(f,"  \"last_two_swing_lows\":{\n");
         FileWriteString(f,"    \"idx1\":"+IntegerToString(sl1)+",\"px1\":"+DoubleToString(pl1,6)+",\"idx2\":"+IntegerToString(sl2)+",\"px2\":"+DoubleToString(pl2,6)+"\n");
         FileWriteString(f,"  },\n");
         FileWriteString(f,"  \"bar_flags\":[\n");
         for(int i=expN-1;i>=0;i--)
         {
            string ts = TimeToString(t[i], TIME_DATE|TIME_SECONDS);
            FileWriteString(f,
               "    {\"t\":\""+JsonEscape(ts)+"\",\"is_swing_high\":"+BoolStr(isSwingH[i])+",\"is_swing_low\":"+BoolStr(isSwingL[i])+"}"
            );
            if(i>0) FileWriteString(f,",\n"); else FileWriteString(f,"\n");
         }
         FileWriteString(f,"  ]\n}\n");
         AtomicWriteEnd(fn,f,tmp);
      }
   }

   // 4) structure component
   if(ExportStructure)
   {
      string fn = compDir + "/" + c.sym + "_structure.json";
      int f; string tmp;
      if(AtomicWriteBegin(fn,f,tmp))
      {
         FileWriteString(f,"{\n");
         FileWriteString(f,"  \"cycle_id\":"+IntegerToString((int)g_cycle_id)+",\n");
         FileWriteString(f,"  \"symbol\":\""+JsonEscape(c.sym)+"\",\n");
         FileWriteString(f,"  \"timeframe\":\""+c.tf_name+"\",\n");
         FileWriteString(f,"  \"quotes\":{\"bid\":"+DoubleToString(bid,6)+",\"ask\":"+DoubleToString(ask,6)+",\"spread_points\":"+IntegerToString((int)spread_points)+"},\n");
         FileWriteString(f,"  \"structure_state\":{\n");
         FileWriteString(f,"    \"trend\":\""+trend+"\",\n");
         FileWriteString(f,"    \"bos_up\":"+BoolStr(bos_up)+",\"bos_down\":"+BoolStr(bos_down)+",\n");
         FileWriteString(f,"    \"choch_up\":"+BoolStr(choch_up)+",\"choch_down\":"+BoolStr(choch_down)+",\n");
         FileWriteString(f,"    \"broken_level\":"+DoubleToString(broken_level,6)+",\n");
         FileWriteString(f,"    \"last_close\":"+DoubleToString(last_close,6)+",\n");
         FileWriteString(f,"    \"last_close_time\":\""+JsonEscape(TimeToString(last_close_time,TIME_DATE|TIME_SECONDS))+"\"\n");
         FileWriteString(f,"  },\n");
         FileWriteString(f,"  \"anchors\":{\n");
         FileWriteString(f,"    \"structure_origin_bar_index\":"+IntegerToString(origin_bar_index)+",\n");
         FileWriteString(f,"    \"structure_origin_time\":\""+JsonEscape(TimeToString(origin_time,TIME_DATE|TIME_SECONDS))+"\",\n");
         FileWriteString(f,"    \"structure_break_price\":"+DoubleToString(structure_break_price,6)+"\n");
         FileWriteString(f,"  },\n");
         FileWriteString(f,"  \"invalidation_geometry\":{\n");
         FileWriteString(f,"    \"type\":\""+invalid_type+"\",\n");
         FileWriteString(f,"    \"price\":"+DoubleToString(invalid_px,6)+",\n");
         FileWriteString(f,"    \"distance_points\":"+DoubleToString(dist_inv_pts,1)+"\n");
         FileWriteString(f,"  },\n");
         FileWriteString(f,"  \"objective_geometry\":{\n");
         FileWriteString(f,"    \"type\":\""+obj_type+"\",\n");
         FileWriteString(f,"    \"price\":"+DoubleToString(obj_px,6)+",\n");
         FileWriteString(f,"    \"distance_points\":"+DoubleToString(dist_obj_pts,1)+"\n");
         FileWriteString(f,"  },\n");
         FileWriteString(f,"  \"modeled_rr\":"+DoubleToString(rr,2)+",\n");
         FileWriteString(f,"  \"regime_age_bars\":"+IntegerToString(regime_age_bars)+",\n");
         FileWriteString(f,"  \"compression_duration_bars\":"+IntegerToString(compression_bars)+"\n");
         FileWriteString(f,"}\n");
         AtomicWriteEnd(fn,f,tmp);
      }
   }

   // 5) combined market_state (Phase-1 chart replacement file)
   if(ExportMarketState)
   {
      string fn = mktDir + "/" + c.sym + ".json";
      int f; string tmp;
      if(AtomicWriteBegin(fn,f,tmp))
      {
         FileWriteString(f,"{\n");
         FileWriteString(f,"  \"schema_version\":\"phase1_test_v1\",\n");
         FileWriteString(f,"  \"cycle_id\":"+IntegerToString((int)g_cycle_id)+",\n");
         FileWriteString(f,"  \"generated_at\":\""+JsonEscape(TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS))+"\",\n");
         FileWriteString(f,"  \"symbol\":\""+JsonEscape(c.sym)+"\",\n");
         FileWriteString(f,"  \"timeframe\":\""+c.tf_name+"\",\n");
         FileWriteString(f,"  \"bars_loaded\":"+IntegerToString(BarsToLoad)+",\n");
         FileWriteString(f,"  \"bars_exported\":"+IntegerToString(expN)+",\n");
         FileWriteString(f,"  \"quotes\":{\"bid\":"+DoubleToString(bid,6)+",\"ask\":"+DoubleToString(ask,6)+",\"spread_points\":"+IntegerToString((int)spread_points)+"},\n");

         // state summary
         FileWriteString(f,"  \"state_summary\":{\n");
         FileWriteString(f,"    \"trend\":\""+trend+"\",\n");
         FileWriteString(f,"    \"bos_up\":"+BoolStr(bos_up)+",\"bos_down\":"+BoolStr(bos_down)+",\n");
         FileWriteString(f,"    \"choch_up\":"+BoolStr(choch_up)+",\"choch_down\":"+BoolStr(choch_down)+",\n");
         FileWriteString(f,"    \"invalidation_price\":"+DoubleToString(invalid_px,6)+",\n");
         FileWriteString(f,"    \"objective_price\":"+DoubleToString(obj_px,6)+",\n");
         FileWriteString(f,"    \"distance_to_invalidation_points\":"+DoubleToString(dist_inv_pts,1)+",\n");
         FileWriteString(f,"    \"distance_to_objective_points\":"+DoubleToString(dist_obj_pts,1)+",\n");
         FileWriteString(f,"    \"modeled_rr\":"+DoubleToString(rr,2)+",\n");
         FileWriteString(f,"    \"regime_age_bars\":"+IntegerToString(regime_age_bars)+",\n");
         FileWriteString(f,"    \"compression_duration_bars\":"+IntegerToString(compression_bars)+",\n");
         FileWriteString(f,"    \"atr14\":"+DoubleToString(atr14[1],6)+",\"atr50\":"+DoubleToString(atr50[1],6)+",\"rsi14\":"+DoubleToString(rsi14[1],2)+",\n");
         FileWriteString(f,"    \"ema20\":"+DoubleToString(ema20[1],6)+",\"ema50\":"+DoubleToString(ema50[1],6)+",\"ema200\":"+DoubleToString(ema200[1],6)+",\n");
         FileWriteString(f,"    \"bb_width\":"+DoubleToString((bb_up[1]-bb_low[1]),6)+",\n");
         FileWriteString(f,"    \"std20\":"+DoubleToString(std20[1],6)+"\n");
         FileWriteString(f,"  },\n");

         // bars
         FileWriteString(f,"  \"bars\":[\n");
         for(int i=expN-1;i>=0;i--)
         {
            string ts = TimeToString(t[i], TIME_DATE|TIME_SECONDS);

            double range_pts = (point>0? (high[i]-low[i])/point : 0);
            double body_pts  = (point>0? MathAbs(close[i]-open[i])/point : 0);
            double upper_wick_pts = (point>0? (high[i]-MathMax(open[i],close[i]))/point : 0);
            double lower_wick_pts = (point>0? (MathMin(open[i],close[i])-low[i])/point : 0);

            FileWriteString(f,
               "    {\"t\":\""+JsonEscape(ts)+"\",\"o\":"+DoubleToString(open[i],6)+",\"h\":"+DoubleToString(high[i],6)+",\"l\":"+DoubleToString(low[i],6)+",\"c\":"+DoubleToString(close[i],6)+
               ",\"v_tick\":"+IntegerToString((int)v_tick[i])+",\"v_real\":"+IntegerToString((int)v_real[i])+
               ",\"ema20\":"+DoubleToString(ema20[i],6)+",\"ema50\":"+DoubleToString(ema50[i],6)+",\"ema200\":"+DoubleToString(ema200[i],6)+
               ",\"atr14\":"+DoubleToString(atr14[i],6)+",\"atr50\":"+DoubleToString(atr50[i],6)+",\"rsi14\":"+DoubleToString(rsi14[i],2)+
               ",\"bb_up\":"+DoubleToString(bb_up[i],6)+",\"bb_mid\":"+DoubleToString(bb_mid[i],6)+",\"bb_low\":"+DoubleToString(bb_low[i],6)+
               ",\"std20\":"+DoubleToString(std20[i],6)+
               ",\"range_points\":"+DoubleToString(range_pts,1)+",\"body_points\":"+DoubleToString(body_pts,1)+
               ",\"upper_wick_points\":"+DoubleToString(upper_wick_pts,1)+",\"lower_wick_points\":"+DoubleToString(lower_wick_pts,1)+
               ",\"is_swing_high\":"+BoolStr(isSwingH[i])+",\"is_swing_low\":"+BoolStr(isSwingL[i])+
               "}"
            );
            if(i>0) FileWriteString(f,",\n"); else FileWriteString(f,"\n");
         }
         FileWriteString(f,"  ]\n}\n");

         AtomicWriteEnd(fn,f,tmp);
      }
   }

   return true;
}

//============================= EA EVENTS ============================
int OnInit()
{
   ParseSymbols();
   ParseTFs();

   // Build ctx list
   int symN = ArraySize(g_syms);
   int tfN  = ArraySize(g_tfs);
   ArrayResize(g_ctx, symN*tfN);

   int k=0;
   for(int i=0;i<symN;i++)
   {
      for(int j=0;j<tfN;j++)
      {
         g_ctx[k].sym = g_syms[i];
         g_ctx[k].tf  = g_tfs[j];
         g_ctx[k].tf_name = TFName(g_tfs[j]);

         if(!CreateHandlesFor(g_ctx[k]))
         {
            Print("Failed to create handles for ", g_ctx[k].sym, " ", g_ctx[k].tf_name);
            return INIT_FAILED;
         }
         k++;
      }
   }

   int timer_sec = (TestRefreshMinutes>0 ? TestRefreshMinutes*60 : 300);
   EventSetTimer(timer_sec);

   Print("AURORA_StructureEA_Phase1_Test initialized. Symbols=", symN, " TFs=", tfN);
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   for(int i=0;i<ArraySize(g_ctx);i++)
      ReleaseHandlesFor(g_ctx[i]);
}

void OnTimer()
{
   g_cycle_id++;

   ulong start_us = GetMicrosecondCount();

   if(EnableCycleAlerts)
   {
      Print("[AURORA] Cycle ", (int)g_cycle_id, " START");
      if(EnablePopupAlert) Alert("AURORA Cycle ", (int)g_cycle_id, " START");
   }
   if(EnableSoundAlert) PlaySound("alert.wav");

   int ran = 0;
   for(int i=0;i<ArraySize(g_ctx);i++)
   {
      // update last closed time AFTER successful run
      datetime prev = g_ctx[i].last_closed_bar_time;

      bool did = RunOne(g_ctx[i]);
      if(did)
      {
         // set last closed bar time to current bar[1]
         datetime t1 = iTime(g_ctx[i].sym, (ENUM_TIMEFRAMES)g_ctx[i].tf, 1);
         if(t1>0) g_ctx[i].last_closed_bar_time = t1;
         else g_ctx[i].last_closed_bar_time = prev;
         ran++;
      }
   }

   ulong end_us = GetMicrosecondCount();
   double duration_ms = (end_us - start_us) / 1000.0;

   ExportRunMeta(g_cycle_id, duration_ms, ArraySize(g_syms), ArraySize(g_tfs));

   if(EnableCycleAlerts)
   {
      Print("[AURORA] Cycle ", (int)g_cycle_id, " END | Ran=", ran, " | Duration: ", DoubleToString(duration_ms,2), " ms");
      if(EnablePopupAlert) Alert("AURORA Cycle ", (int)g_cycle_id, " END | Ran=", ran, " | ", DoubleToString(duration_ms,2), " ms");
   }
   if(EnableSoundAlert) PlaySound("ok.wav");
}

void OnTick(){}
//+------------------------------------------------------------------+