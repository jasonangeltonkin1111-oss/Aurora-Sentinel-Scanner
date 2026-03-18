//+------------------------------------------------------------------+
//| ISSX_DEV_Structural.mq5                                          |
//| DEV EA #2 (Blueprint-Strict): Structural State Engine (StageA ONLY)|
//|                                                                  |
//| INPUT: reads DEV #1 snapshot:                                    |
//|   MQL5\Files\ISSX_DEV_Friction_<Broker>_<Server>_<Login>\         |
//|     iss_snapshot_latest.json                                     |
//|                                                                  |
//| OUTPUT (DEV folder; rolling + latest; atomic writes):            |
//|   MQL5\Files\ISSX_DEV_Structural_<Broker>_<Server>_<Login>\       |
//|     iss_structural_latest.json                                   |
//|     iss_structural_YYYYMMDD_HHMMSS.json (optional)               |
//|                                                                  |
//| NOTE: NO trading. Deterministic. Per-account isolated.           |
//| This module does NOT compute friction or StageA. It consumes it. |
//+------------------------------------------------------------------+
#property strict
#property version   "12.00"
#property description "ISSX DEV EA #2: Structural Engine (StageA only, reads DEV #1 snapshot)"

//==============================
// ISS-X VERSIONING
//==============================
#define ISS_VERSION    "12.00"
#define SCHEMA_VERSION "12.00"

//==============================
// INPUTS (Blueprint Stage 5 defaults)
//==============================
input int  RecomputeMinutes         = 60;     // structural recompute cadence (testing)
input bool EnableSnapshotStamped    = true;   // write stamped file in addition to latest
input bool EnablePopups             = false;  // popups only AFTER verified disk writes

// Structural params (blueprint)
input ENUM_TIMEFRAMES HTF_TF        = PERIOD_H4;
input ENUM_TIMEFRAMES LTF_TF        = PERIOD_H1;

input int  EMA_Fast                 = 50;
input int  EMA_Slow                 = 200;
input int  ADX_Period               = 14;

input int  RangeLookbackBars        = 48;     // H1
input int  BreakoutLookbackDays     = 30;     // ~30*24 H1 bars
input int  WeeklyLookbackDays       = 5;      // ~5*24 H1 bars
input int  MonthlyLookbackDays      = 20;     // ~20*24 H1 bars

input int  VolPctWindowDays         = 30;     // ~30*24 H1 ATR bars
input int  TrendMaturityBars_H4     = 60;

input int  VolShock_FromPct         = 30;
input int  VolShock_ToPct           = 80;
input int  VolShock_Bars            = 12;

input double BreakoutReady_ThreshATR= 0.50;   // deterministic threshold (explicit)

// Tick / staleness reference (used only for flags; no friction sampling here)
input int  MaxTickAgeSeconds        = 300;

//==============================
// INTERNAL CONSTANTS
//==============================
#define TINY   1e-12

//==============================
// GLOBALS (Paths / Timing)
//==============================
string   g_out_folder    = "";
string   g_in_folder     = "";   // friction folder
datetime g_last_recompute_time = 0;

//==============================
// JSON HELPERS
//==============================
string JsonEscape(string s)
{
   StringReplace(s, "\\", "\\\\");
   StringReplace(s, "\"", "\\\"");
   StringReplace(s, "\r", "\\r");
   StringReplace(s, "\n", "\\n");
   StringReplace(s, "\t", "\\t");
   return s;
}
string B2S(bool v) { return (v ? "true" : "false"); }
string I2S(long v) { return IntegerToString((int)v); }
// 64-bit safe (no LongToString dependency)
string L2S(long v) { return StringFormat("%I64d", v); }
string D2S(double v, int digits) { return DoubleToString(v, digits); }

string Sanitize(string s)
{
   StringReplace(s," ","_");
   StringReplace(s,"/","_");
   StringReplace(s,"\\","_");
   StringReplace(s,":","_");
   StringReplace(s,"*","_");
   StringReplace(s,"?","_");
   StringReplace(s,"\"","_");
   StringReplace(s,"<","_");
   StringReplace(s,">","_");
   StringReplace(s,"|","_");
   return s;
}

string Stamp(datetime t_server)
{
   MqlDateTime st; TimeToStruct(t_server, st);
   return StringFormat("%04d%02d%02d_%02d%02d%02d", st.year, st.mon, st.day, st.hour, st.min, st.sec);
}

bool EnsureFolder(string folder_rel)
{
   ResetLastError();
   if(FolderCreate(folder_rel))
      return true;

   int err = GetLastError();
   if(err == 5019 || err == 0) // already exists
      return true;

   return false;
}

bool BasicJsonLooksValid(const string &content)
{
   int n = StringLen(content);
   if(n < 2) return false;

   int i = 0;
   while(i < n)
   {
      ushort ch = StringGetCharacter(content, i);
      if(ch!=' ' && ch!='\n' && ch!='\r' && ch!='\t') break;
      i++;
   }
   if(i >= n) return false;
   if(StringGetCharacter(content, i) != '{') return false;

   int j = n - 1;
   while(j >= 0)
   {
      ushort ch2 = StringGetCharacter(content, j);
      if(ch2!=' ' && ch2!='\n' && ch2!='\r' && ch2!='\t') break;
      j--;
   }
   if(j < 0) return false;
   if(StringGetCharacter(content, j) != '}') return false;

   return true;
}

bool AtomicWriteText(const string rel_final, const string content, string &err_out)
{
   err_out = "";

   if(!BasicJsonLooksValid(content))
   {
      err_out = "content failed basic JSON sanity (must start '{' and end '}')";
      return false;
   }

   string rel_tmp = rel_final + ".tmp";

   ResetLastError();
   int h = FileOpen(rel_tmp, FILE_WRITE|FILE_TXT);
   if(h == INVALID_HANDLE)
   {
      err_out = "FileOpen(tmp) failed err=" + IntegerToString(GetLastError());
      return false;
   }

   FileWriteString(h, content);
   FileFlush(h);

   ulong sz = FileSize(h);
   FileClose(h);

   if(sz < 2)
   {
      err_out = "tmp file too small (" + IntegerToString((int)sz) + ")";
      if(FileIsExist(rel_tmp)) FileDelete(rel_tmp);
      return false;
   }

   ResetLastError();
   int vr = FileOpen(rel_tmp, FILE_READ|FILE_TXT);
   if(vr == INVALID_HANDLE)
   {
      err_out = "Verify open(tmp) failed err=" + IntegerToString(GetLastError());
      return false;
   }
   FileClose(vr);

   if(FileIsExist(rel_final))
   {
      ResetLastError();
      if(!FileDelete(rel_final))
      {
         err_out = "FileDelete(final) failed err=" + IntegerToString(GetLastError());
         return false;
      }
   }

   ResetLastError();
   if(!FileMove(rel_tmp, 0, rel_final, 0))
   {
      err_out = "FileMove(tmp->final) failed err=" + IntegerToString(GetLastError());
      return false;
   }

   ResetLastError();
   int vf = FileOpen(rel_final, FILE_READ|FILE_TXT);
   if(vf == INVALID_HANDLE)
   {
      err_out = "Verify open(final) failed err=" + IntegerToString(GetLastError());
      return false;
   }
   FileClose(vf);

   return true;
}

//==============================
// TIME HELPERS
//==============================
datetime NowServer(bool &used_fallback)
{
   used_fallback = false;
   datetime t = TimeTradeServer();
   if(t <= 0)
   {
      used_fallback = true;
      t = TimeCurrent();
   }
   return t;
}

//==============================
// FILE READ
//==============================
bool ReadAllText(const string rel_path, string &out, string &err_out)
{
   err_out = "";
   out = "";

   if(!FileIsExist(rel_path))
   {
      err_out = "file not found: " + rel_path;
      return false;
   }

   ResetLastError();
   int h = FileOpen(rel_path, FILE_READ|FILE_TXT);
   if(h == INVALID_HANDLE)
   {
      err_out = "FileOpen(read) failed err=" + IntegerToString(GetLastError());
      return false;
   }

   ulong sz = FileSize(h);
   if(sz == 0)
   {
      FileClose(h);
      err_out = "file empty";
      return false;
   }

   int len = (int)sz;
   out = FileReadString(h, len);
   FileClose(h);

   if(StringLen(out) < 2)
   {
      err_out = "read too short";
      return false;
   }
   return true;
}

//==============================
// MINIMAL JSON PARSING (StageA symbols only)
//==============================
bool IsWs(ushort ch)
{
   return (ch==' '||ch=='\n'||ch=='\r'||ch=='\t');
}

int FindMatchingBracket(const string &s, int openPos, ushort openCh, ushort closeCh)
{
   int n = StringLen(s);
   if(openPos < 0 || openPos >= n) return -1;
   if(StringGetCharacter(s, openPos) != openCh) return -1;

   int depth = 0;
   bool inStr = false;
   bool esc = false;

   for(int i=openPos; i<n; i++)
   {
      ushort ch = StringGetCharacter(s, i);

      if(inStr)
      {
         if(esc) { esc = false; continue; }
         if(ch == '\\') { esc = true; continue; }
         if(ch == '"') { inStr = false; continue; }
         continue;
      }
      else
      {
         if(ch == '"') { inStr = true; continue; }
         if(ch == openCh) depth++;
         else if(ch == closeCh)
         {
            depth--;
            if(depth == 0) return i;
         }
      }
   }
   return -1;
}

bool ReadJsonStringAt(const string &s, int startQuotePos, int &outEndQuotePos, string &outVal)
{
   outVal = "";
   outEndQuotePos = -1;

   int n = StringLen(s);
   if(startQuotePos < 0 || startQuotePos >= n) return false;
   if(StringGetCharacter(s, startQuotePos) != '"') return false;

   bool esc = false;
   for(int i=startQuotePos+1; i<n; i++)
   {
      ushort ch = StringGetCharacter(s, i);

      if(esc)
      {
         if(ch=='"' || ch=='\\' || ch=='/') outVal += CharToString((uchar)ch);
         else if(ch=='n') outVal += "\n";
         else if(ch=='r') outVal += "\r";
         else if(ch=='t') outVal += "\t";
         else outVal += CharToString((uchar)ch);
         esc = false;
         continue;
      }

      if(ch == '\\') { esc = true; continue; }
      if(ch == '"')
      {
         outEndQuotePos = i;
         return true;
      }

      outVal += CharToString((uchar)ch);
   }
   return false;
}

bool ParseIntAfterColon(const string &s, int colonPos, int &outVal)
{
   outVal = 0;
   int n = StringLen(s);
   if(colonPos < 0 || colonPos >= n) return false;

   int i = colonPos + 1;
   while(i < n && IsWs(StringGetCharacter(s,i))) i++;

   bool neg = false;
   if(i < n && StringGetCharacter(s,i) == '-') { neg = true; i++; }

   bool any = false;
   long v = 0;
   while(i < n)
   {
      ushort ch = StringGetCharacter(s,i);
      if(ch < '0' || ch > '9') break;
      any = true;
      v = v*10 + (ch - '0');
      i++;
   }

   if(!any) return false;
   if(neg) v = -v;

   outVal = (int)v;
   return true;
}

bool ExtractStageAList(const string &js, string &src_err, string &out_source_time, int &out_stageA_count,
                       string &syms[], int &ranks[])
{
   src_err = "";
   out_source_time = "";
   out_stageA_count = 0;
   ArrayResize(syms, 0);
   ArrayResize(ranks, 0);

   int pStageA = StringFind(js, "\"stageA\"");
   if(pStageA < 0) { src_err = "stageA key not found"; return false; }

   int pSymbols = StringFind(js, "\"symbols\"", pStageA);
   if(pSymbols < 0) { src_err = "stageA.symbols key not found"; return false; }

   int pArr = StringFind(js, "[", pSymbols);
   if(pArr < 0) { src_err = "stageA.symbols array '[' not found"; return false; }

   int pArrEnd = FindMatchingBracket(js, pArr, '[', ']');
   if(pArrEnd < 0) { src_err = "stageA.symbols array ']' not found"; return false; }

   // best effort: source server_time
   int pTime = StringFind(js, "\"server_time\"");
   if(pTime >= 0)
   {
      int pColon = StringFind(js, ":", pTime);
      int tInt = 0;
      if(pColon >= 0 && ParseIntAfterColon(js, pColon, tInt))
         out_source_time = IntegerToString(tInt);
   }

   int cur = pArr + 1;
   int n = 0;

   while(true)
   {
      int pSymKey = StringFind(js, "\"symbol\"", cur);
      if(pSymKey < 0 || pSymKey > pArrEnd) break;

      int pColon1 = StringFind(js, ":", pSymKey);
      if(pColon1 < 0 || pColon1 > pArrEnd) break;

      int q = pColon1 + 1;
      while(q < pArrEnd && IsWs(StringGetCharacter(js,q))) q++;
      if(q >= pArrEnd || StringGetCharacter(js,q) != '"') { src_err = "symbol value quote not found"; return false; }

      int qEnd = -1;
      string sym = "";
      if(!ReadJsonStringAt(js, q, qEnd, sym) || qEnd < 0) { src_err = "symbol value parse failed"; return false; }

      int pRankKey = StringFind(js, "\"stageA_rank\"", qEnd);
      if(pRankKey < 0 || pRankKey > pArrEnd) { src_err = "stageA_rank not found for " + sym; return false; }

      int pColon2 = StringFind(js, ":", pRankKey);
      int rk = 0;
      if(pColon2 < 0 || !ParseIntAfterColon(js, pColon2, rk)) { src_err = "stageA_rank parse failed for " + sym; return false; }

      ArrayResize(syms, n+1);
      ArrayResize(ranks, n+1);
      syms[n] = sym;
      ranks[n] = rk;
      n++;

      cur = pRankKey + 1;
   }

   out_stageA_count = n;
   return true;
}

//==============================
// STRUCTURAL COMPUTATION
//==============================
string TrendLabel(bool emaUp, double adx)
{
   const double ADX_STRONG = 25.0;
   const double ADX_RANGE  = 20.0;

   if(adx < ADX_RANGE) return "RANGE";
   if(emaUp)
      return (adx >= ADX_STRONG ? "STRONG_UP" : "WEAK_UP");
   else
      return (adx >= ADX_STRONG ? "STRONG_DOWN" : "WEAK_DOWN");
}

bool GetEMA(const string sym, ENUM_TIMEFRAMES tf, int period, int count, double &outArr[])
{
   ArrayResize(outArr, 0);

   int h = iMA(sym, tf, period, 0, MODE_EMA, PRICE_CLOSE);
   if(h == INVALID_HANDLE) return false;

   ArrayResize(outArr, count);
   ArraySetAsSeries(outArr, true);

   int got = CopyBuffer(h, 0, 0, count, outArr);
   IndicatorRelease(h);

   return (got >= count);
}

bool GetADXMain(const string sym, ENUM_TIMEFRAMES tf, int period, int count, double &outArr[])
{
   ArrayResize(outArr, 0);

   int h = iADX(sym, tf, period);
   if(h == INVALID_HANDLE) return false;

   ArrayResize(outArr, count);
   ArraySetAsSeries(outArr, true);

   int got = CopyBuffer(h, 0, 0, count, outArr);
   IndicatorRelease(h);

   return (got >= count);
}

bool GetATRSeries(const string sym, ENUM_TIMEFRAMES tf, int period, int count, double &outArr[])
{
   ArrayResize(outArr, 0);

   int h = iATR(sym, tf, period);
   if(h == INVALID_HANDLE) return false;

   ArrayResize(outArr, count);
   ArraySetAsSeries(outArr, true);

   int got = CopyBuffer(h, 0, 0, count, outArr);
   IndicatorRelease(h);

   return (got >= 1);
}

bool GetRates(const string sym, ENUM_TIMEFRAMES tf, int count, MqlRates &rates[])
{
   ArrayResize(rates, count);
   ArraySetAsSeries(rates, true);

   int got = CopyRates(sym, tf, 0, count, rates);
   if(got < 1) { ArrayResize(rates, 0); return false; }

   ArrayResize(rates, got);
   return true;
}

double PercentileRank(const double &values[], int n, double x)
{
   if(n <= 1) return 0.0;

   double tmp[];
   ArrayResize(tmp, n);
   for(int i=0;i<n;i++) tmp[i] = values[i];

   ArraySort(tmp);

   int lo = 0, hi = n;
   while(lo < hi)
   {
      int mid = (lo + hi) / 2;
      if(tmp[mid] < x) lo = mid + 1;
      else hi = mid;
   }

   double pct = 100.0 * ((double)lo / (double)(n - 1));
   if(pct < 0.0) pct = 0.0;
   if(pct > 100.0) pct = 100.0;
   return pct;
}

void HighLowOverRates(const MqlRates &rates[], int n, double &outHigh, double &outLow)
{
   outHigh = 0.0;
   outLow = 0.0;
   if(n <= 0) return;

   outHigh = rates[0].high;
   outLow  = rates[0].low;

   for(int i=1;i<n;i++)
   {
      if(rates[i].high > outHigh) outHigh = rates[i].high;
      if(rates[i].low  < outLow)  outLow  = rates[i].low;
   }
}

//==============================
// BUILD STRUCTURAL JSON
//==============================
string BuildStructuralJson(const string &input_relpath, bool input_ok, const string &input_err,
                           const string &source_time, string &stageA_syms[], int &stageA_ranks[])
{
   bool used_fallback = false;
   datetime t_server = NowServer(used_fallback);
   datetime t_utc    = TimeGMT();

   int n = ArraySize(stageA_syms);

   string js = "{\n";
   js += "  \"iss_version\":\""+string(ISS_VERSION)+"\",\n";
   js += "  \"schema_version\":\""+string(SCHEMA_VERSION)+"\",\n";
   js += "  \"engine\":\"ISSX_DEV_Structural\",\n";
   js += "  \"server_time\":"+L2S((long)t_server)+",\n";
   js += "  \"utc_time\":"+L2S((long)t_utc)+",\n";
   js += "  \"server_time_fallback_used\":"+string(B2S(used_fallback))+",\n";

   js += "  \"input\":{\n";
   js += "    \"snapshot_relpath\":\""+JsonEscape(input_relpath)+"\",\n";
   js += "    \"read_ok\":"+string(B2S(input_ok))+",\n";
   js += "    \"read_error\":\""+JsonEscape(input_err)+"\",\n";
   js += "    \"source_server_time\":\""+JsonEscape(source_time)+"\"\n";
   js += "  },\n";

   js += "  \"params\":{\n";
   js += "    \"RecomputeMinutes\":"+I2S(RecomputeMinutes)+",\n";
   js += "    \"HTF_TF\":\""+EnumToString(HTF_TF)+"\",\n";
   js += "    \"LTF_TF\":\""+EnumToString(LTF_TF)+"\",\n";
   js += "    \"EMA_Fast\":"+I2S(EMA_Fast)+",\n";
   js += "    \"EMA_Slow\":"+I2S(EMA_Slow)+",\n";
   js += "    \"ADX_Period\":"+I2S(ADX_Period)+",\n";
   js += "    \"RangeLookbackBars\":"+I2S(RangeLookbackBars)+",\n";
   js += "    \"BreakoutLookbackDays\":"+I2S(BreakoutLookbackDays)+",\n";
   js += "    \"WeeklyLookbackDays\":"+I2S(WeeklyLookbackDays)+",\n";
   js += "    \"MonthlyLookbackDays\":"+I2S(MonthlyLookbackDays)+",\n";
   js += "    \"VolPctWindowDays\":"+I2S(VolPctWindowDays)+",\n";
   js += "    \"TrendMaturityBars_H4\":"+I2S(TrendMaturityBars_H4)+",\n";
   js += "    \"VolShock_FromPct\":"+I2S(VolShock_FromPct)+",\n";
   js += "    \"VolShock_ToPct\":"+I2S(VolShock_ToPct)+",\n";
   js += "    \"VolShock_Bars\":"+I2S(VolShock_Bars)+",\n";
   js += "    \"BreakoutReady_ThreshATR\":"+D2S(BreakoutReady_ThreshATR,2)+",\n";
   js += "    \"MaxTickAgeSeconds\":"+I2S(MaxTickAgeSeconds)+"\n";
   js += "  },\n";

   js += "  \"stageA_count\":"+I2S(n)+",\n";
   js += "  \"structural\":[\n";

   for(int i=0;i<n;i++)
   {
      string sym = stageA_syms[i];
      int stage_rank = stageA_ranks[i];

      SymbolSelect(sym, true);

      MqlTick tk;
      bool tick_ok = SymbolInfoTick(sym, tk);
      long tick_age = 2147483647;
      if(tick_ok)
      {
         tick_age = (long)(t_server - tk.time);
         if(tick_age < 0) tick_age = 2147483647;
      }
      bool tick_fresh = (tick_ok && tick_age <= MaxTickAgeSeconds);

      // --- H4 trend ---
      double emaF_h4[], emaS_h4[], adx_h4[];
      bool ok_emaF_h4 = GetEMA(sym, HTF_TF, EMA_Fast, 6, emaF_h4);
      bool ok_emaS_h4 = GetEMA(sym, HTF_TF, EMA_Slow, 1, emaS_h4);
      bool ok_adx_h4  = GetADXMain(sym, HTF_TF, ADX_Period, 6, adx_h4);

      double emaF_h4_0 = (ok_emaF_h4 ? emaF_h4[0] : 0.0);
      double emaF_h4_5 = (ok_emaF_h4 ? emaF_h4[5] : 0.0);
      double emaS_h4_0 = (ok_emaS_h4 ? emaS_h4[0] : 0.0);
      double adx_h4_0  = (ok_adx_h4  ? adx_h4[0]  : 0.0);
      double adx_h4_5  = (ok_adx_h4  ? adx_h4[5]  : 0.0);
      bool h4_ema_up = (ok_emaF_h4 && ok_emaS_h4 && (emaF_h4_0 >= emaS_h4_0));
      string h4_trend = (ok_emaF_h4 && ok_emaS_h4 && ok_adx_h4) ? TrendLabel(h4_ema_up, adx_h4_0) : "UNKNOWN";
      double h4_slope5 = (ok_emaF_h4 ? (emaF_h4_0 - emaF_h4_5) : 0.0);

      // --- H1 trend ---
      double emaF_h1[], emaS_h1[], adx_h1[];
      bool ok_emaF_h1 = GetEMA(sym, LTF_TF, EMA_Fast, 6, emaF_h1);
      bool ok_emaS_h1 = GetEMA(sym, LTF_TF, EMA_Slow, 1, emaS_h1);
      bool ok_adx_h1  = GetADXMain(sym, LTF_TF, ADX_Period, 6, adx_h1);

      double emaF_h1_0 = (ok_emaF_h1 ? emaF_h1[0] : 0.0);
      double emaF_h1_5 = (ok_emaF_h1 ? emaF_h1[5] : 0.0);
      double emaS_h1_0 = (ok_emaS_h1 ? emaS_h1[0] : 0.0);
      double adx_h1_0  = (ok_adx_h1  ? adx_h1[0]  : 0.0);
      double adx_h1_5  = (ok_adx_h1  ? adx_h1[5]  : 0.0);
      bool h1_ema_up = (ok_emaF_h1 && ok_emaS_h1 && (emaF_h1_0 >= emaS_h1_0));
      string h1_trend = (ok_emaF_h1 && ok_emaS_h1 && ok_adx_h1) ? TrendLabel(h1_ema_up, adx_h1_0) : "UNKNOWN";
      double h1_slope5 = (ok_emaF_h1 ? (emaF_h1_0 - emaF_h1_5) : 0.0);

      // Alignment score
      double align = 0.0;
      if(h4_trend == "RANGE") align = 0.5;
      else if((h4_trend == "STRONG_UP" || h4_trend == "WEAK_UP") && (h1_trend == "STRONG_UP" || h1_trend == "WEAK_UP")) align = 1.0;
      else if((h4_trend == "STRONG_DOWN" || h4_trend == "WEAK_DOWN") && (h1_trend == "STRONG_DOWN" || h1_trend == "WEAK_DOWN")) align = 1.0;
      else if(h4_trend == "UNKNOWN" || h1_trend == "UNKNOWN") align = 0.0;
      else align = 0.3;

      // Rates lookbacks (H1)
      int bars_30d = BreakoutLookbackDays * 24;
      int bars_w   = WeeklyLookbackDays * 24;
      int bars_m   = MonthlyLookbackDays * 24;

      if(bars_30d < 1) bars_30d = 1;
      if(bars_w   < 1) bars_w   = 1;
      if(bars_m   < 1) bars_m   = 1;

      MqlRates rates48[], rates30d[], ratesW[], ratesM[];
      bool ok48  = GetRates(sym, LTF_TF, RangeLookbackBars, rates48);
      bool ok30d = GetRates(sym, LTF_TF, bars_30d, rates30d);
      bool okW   = GetRates(sym, LTF_TF, bars_w, ratesW);
      bool okM   = GetRates(sym, LTF_TF, bars_m, ratesM);

      int got48  = (ok48 ? ArraySize(rates48)  : 0);
      int got30d = (ok30d? ArraySize(rates30d) : 0);
      int gotW   = (okW  ? ArraySize(ratesW)   : 0);
      int gotM   = (okM  ? ArraySize(ratesM)   : 0);

      double close0 = 0.0;
      if(ok30d && got30d > 0) close0 = rates30d[0].close;
      else if(ok48 && got48 > 0) close0 = rates48[0].close;

      // ATR percentile (H1)
      int atr_hist_bars = VolPctWindowDays * 24;
      if(atr_hist_bars < 50) atr_hist_bars = 50;

      double atr_h1[];
      bool okATR = GetATRSeries(sym, LTF_TF, 14, atr_hist_bars, atr_h1);
      int atr_n = ArraySize(atr_h1);

      double atr_valid[];
      int vcnt = 0;
      if(okATR && atr_n > 0)
      {
         ArrayResize(atr_valid, atr_n);
         for(int k=0;k<atr_n;k++)
         {
            if(atr_h1[k] > 0.0)
            {
               atr_valid[vcnt] = atr_h1[k];
               vcnt++;
            }
         }
         ArrayResize(atr_valid, vcnt);
      }

      double atr_now = (vcnt > 0 ? atr_valid[0] : 0.0);
      double atr_pct = (vcnt > 1 ? PercentileRank(atr_valid, vcnt, atr_now) : 0.0);

      string comp_state = "UNKNOWN";
      if(vcnt > 1)
      {
         if(atr_pct <= (double)VolShock_FromPct) comp_state = "COMPRESSED";
         else if(atr_pct >= (double)VolShock_ToPct) comp_state = "EXPANDING";
         else comp_state = "NORMAL";
      }

      double r48_hi = 0.0, r48_lo = 0.0;
      if(ok48 && got48 > 0) HighLowOverRates(rates48, got48, r48_hi, r48_lo);
      double range48 = (ok48 ? (r48_hi - r48_lo) : 0.0);

      // Breakout proximity (30d high/low)
      double hh30 = 0.0, ll30 = 0.0;
      if(ok30d && got30d > 0) HighLowOverRates(rates30d, got30d, hh30, ll30);

      double distHighATR = 0.0, distLowATR = 0.0;
      bool breakout_ready_high = false, breakout_ready_low = false;
      if(vcnt > 0 && atr_now > TINY && ok30d && got30d > 0 && close0 > 0.0)
      {
         distHighATR = (hh30 - close0) / atr_now;
         distLowATR  = (close0 - ll30) / atr_now;

         if(distHighATR < 0.0) distHighATR = 0.0;
         if(distLowATR  < 0.0) distLowATR  = 0.0;

         breakout_ready_high = (distHighATR <= BreakoutReady_ThreshATR);
         breakout_ready_low  = (distLowATR  <= BreakoutReady_ThreshATR);
      }

      // Weekly / monthly distances
      double hhW=0.0, llW=0.0, hhM=0.0, llM=0.0;
      if(okW && gotW > 0) HighLowOverRates(ratesW, gotW, hhW, llW);
      if(okM && gotM > 0) HighLowOverRates(ratesM, gotM, hhM, llM);

      double wDistHighATR=0.0, wDistLowATR=0.0, mDistHighATR=0.0, mDistLowATR=0.0;
      if(vcnt > 0 && atr_now > TINY && close0 > 0.0)
      {
         if(okW && gotW > 0)
         {
            wDistHighATR = (hhW - close0)/atr_now; if(wDistHighATR < 0) wDistHighATR = 0;
            wDistLowATR  = (close0 - llW)/atr_now; if(wDistLowATR  < 0) wDistLowATR  = 0;
         }
         if(okM && gotM > 0)
         {
            mDistHighATR = (hhM - close0)/atr_now; if(mDistHighATR < 0) mDistHighATR = 0;
            mDistLowATR  = (close0 - llM)/atr_now; if(mDistLowATR  < 0) mDistLowATR  = 0;
         }
      }

      // Trend maturity (H4)
      int maturity_count = 0;
      bool mature = false;
      if(TrendMaturityBars_H4 > 0)
      {
         double emaF_m[], emaS_m[];
         bool okF = GetEMA(sym, HTF_TF, EMA_Fast, TrendMaturityBars_H4, emaF_m);
         bool okS = GetEMA(sym, HTF_TF, EMA_Slow, TrendMaturityBars_H4, emaS_m);
         if(okF && okS)
         {
            bool up_now = (emaF_m[0] >= emaS_m[0]);
            for(int k=0;k<TrendMaturityBars_H4;k++)
            {
               bool up_k = (emaF_m[k] >= emaS_m[k]);
               if(up_k == up_now) maturity_count++;
               else break;
            }
            mature = (maturity_count >= TrendMaturityBars_H4);
         }
      }

      // Vol shock
      bool vol_shock = false;
      double pct_past = 0.0;
      if(vcnt > (VolShock_Bars+1) && VolShock_Bars > 0)
      {
         double atr_past = atr_valid[VolShock_Bars];
         pct_past = PercentileRank(atr_valid, vcnt, atr_past);
         if(pct_past < (double)VolShock_FromPct && atr_pct > (double)VolShock_ToPct)
            vol_shock = true;
      }

      // Expansion score (0..10)
      double exp = 0.0;
      if(comp_state == "COMPRESSED") exp += 2.0;
      else if(comp_state == "NORMAL") exp += 1.0;

      if(breakout_ready_high || breakout_ready_low) exp += 2.0;

      if(ok_adx_h4 && (adx_h4_0 > adx_h4_5)) exp += 1.0;
      if(ok_adx_h1 && (adx_h1_0 > adx_h1_5)) exp += 1.0;

      if(align >= 0.99) exp += 1.0;
      if(h4_trend == "STRONG_UP" || h4_trend == "STRONG_DOWN") exp += 1.0;
      if(h1_trend == "STRONG_UP" || h1_trend == "STRONG_DOWN") exp += 0.5;

      if(vol_shock) exp += 1.0;

      if(exp < 0.0) exp = 0.0;
      if(exp > 10.0) exp = 10.0;

      // JSON object
      js += "    {\n";
      js += "      \"symbol\":\""+JsonEscape(sym)+"\",\n";
      js += "      \"stageA_rank\":"+I2S(stage_rank)+",\n";
      js += "      \"tick\":{\n";
      js += "        \"available\":"+string(B2S(tick_ok))+",\n";
      js += "        \"age_seconds\":"+L2S(tick_age)+",\n";
      js += "        \"fresh\":"+string(B2S(tick_fresh))+"\n";
      js += "      },\n";

      js += "      \"htf\":{\n";
      js += "        \"tf\":\""+EnumToString(HTF_TF)+"\",\n";
      js += "        \"trend\":\""+h4_trend+"\",\n";
      js += "        \"ema_fast_0\":"+(ok_emaF_h4 ? D2S(emaF_h4_0,8) : "null")+",\n";
      js += "        \"ema_slow_0\":"+(ok_emaS_h4 ? D2S(emaS_h4_0,8) : "null")+",\n";
      js += "        \"ema_fast_slope_5\":"+(ok_emaF_h4 ? D2S(h4_slope5,8) : "null")+",\n";
      js += "        \"adx_0\":"+(ok_adx_h4 ? D2S(adx_h4_0,4) : "null")+",\n";
      js += "        \"adx_5\":"+(ok_adx_h4 ? D2S(adx_h4_5,4) : "null")+"\n";
      js += "      },\n";

      js += "      \"ltf\":{\n";
      js += "        \"tf\":\""+EnumToString(LTF_TF)+"\",\n";
      js += "        \"trend\":\""+h1_trend+"\",\n";
      js += "        \"ema_fast_0\":"+(ok_emaF_h1 ? D2S(emaF_h1_0,8) : "null")+",\n";
      js += "        \"ema_slow_0\":"+(ok_emaS_h1 ? D2S(emaS_h1_0,8) : "null")+",\n";
      js += "        \"ema_fast_slope_5\":"+(ok_emaF_h1 ? D2S(h1_slope5,8) : "null")+",\n";
      js += "        \"adx_0\":"+(ok_adx_h1 ? D2S(adx_h1_0,4) : "null")+",\n";
      js += "        \"adx_5\":"+(ok_adx_h1 ? D2S(adx_h1_5,4) : "null")+"\n";
      js += "      },\n";

      js += "      \"alignment_score\":"+D2S(align,2)+",\n";

      js += "      \"compression\":{\n";
      js += "        \"state\":\""+comp_state+"\",\n";
      js += "        \"atr_now\":"+(vcnt>0 ? D2S(atr_now,8) : "null")+",\n";
      js += "        \"atr_percentile\":"+(vcnt>1 ? D2S(atr_pct,2) : "null")+",\n";
      js += "        \"range_lookback_bars\":"+I2S(RangeLookbackBars)+",\n";
      js += "        \"range_width\":"+(ok48 ? D2S(range48,8) : "null")+"\n";
      js += "      },\n";

      js += "      \"breakout\":{\n";
      js += "        \"lookback_days\":"+I2S(BreakoutLookbackDays)+",\n";
      js += "        \"hh\":"+(ok30d? D2S(hh30,8) : "null")+",\n";
      js += "        \"ll\":"+(ok30d? D2S(ll30,8) : "null")+",\n";
      js += "        \"dist_high_atr\":"+(vcnt>0? D2S(distHighATR,4) : "null")+",\n";
      js += "        \"dist_low_atr\":"+(vcnt>0? D2S(distLowATR,4) : "null")+",\n";
      js += "        \"ready_high\":"+string(B2S(breakout_ready_high))+",\n";
      js += "        \"ready_low\":"+string(B2S(breakout_ready_low))+"\n";
      js += "      },\n";

      js += "      \"context\":{\n";
      js += "        \"weekly_days\":"+I2S(WeeklyLookbackDays)+",\n";
      js += "        \"monthly_days\":"+I2S(MonthlyLookbackDays)+",\n";
      js += "        \"weekly_dist_high_atr\":"+(vcnt>0? D2S(wDistHighATR,4) : "null")+",\n";
      js += "        \"weekly_dist_low_atr\":"+(vcnt>0? D2S(wDistLowATR,4) : "null")+",\n";
      js += "        \"monthly_dist_high_atr\":"+(vcnt>0? D2S(mDistHighATR,4) : "null")+",\n";
      js += "        \"monthly_dist_low_atr\":"+(vcnt>0? D2S(mDistLowATR,4) : "null")+"\n";
      js += "      },\n";

      js += "      \"trend_maturity\":{\n";
      js += "        \"lookback_bars_h4\":"+I2S(TrendMaturityBars_H4)+",\n";
      js += "        \"consecutive_bars\":"+I2S(maturity_count)+",\n";
      js += "        \"mature\":"+string(B2S(mature))+"\n";
      js += "      },\n";

      js += "      \"vol_shock\":{\n";
      js += "        \"flag\":"+string(B2S(vol_shock))+",\n";
      js += "        \"from_pct\":"+I2S(VolShock_FromPct)+",\n";
      js += "        \"to_pct\":"+I2S(VolShock_ToPct)+",\n";
      js += "        \"bars\":"+I2S(VolShock_Bars)+",\n";
      js += "        \"pct_past\":"+(vcnt>1? D2S(pct_past,2) : "null")+"\n";
      js += "      },\n";

      js += "      \"expansion_score\":{\n";
      js += "        \"value\":"+D2S(exp,2)+",\n";
      js += "        \"components\":{\n";
      // *** FIX: NO backslashes inside MQL code comparisons ***
      js += "          \"compression_points\":"+D2S((comp_state=="COMPRESSED"?2.0:(comp_state=="NORMAL"?1.0:0.0)),2)+",\n";
      js += "          \"breakout_points\":"+D2S((breakout_ready_high||breakout_ready_low)?2.0:0.0,2)+",\n";
      js += "          \"adx_rising_h4\":"+string(B2S(ok_adx_h4 && (adx_h4_0>adx_h4_5)))+",\n";
      js += "          \"adx_rising_h1\":"+string(B2S(ok_adx_h1 && (adx_h1_0>adx_h1_5)))+",\n";
      js += "          \"aligned\":"+string(B2S(align>=0.99))+",\n";
      js += "          \"htf_strong\":"+string(B2S(h4_trend=="STRONG_UP" || h4_trend=="STRONG_DOWN"))+",\n";
      js += "          \"ltf_strong\":"+string(B2S(h1_trend=="STRONG_UP" || h1_trend=="STRONG_DOWN"))+",\n";
      js += "          \"vol_shock\":"+string(B2S(vol_shock))+"\n";
      js += "        }\n";
      js += "      },\n";

      js += "      \"data_quality\":{\n";
      js += "        \"rates_h1_48_received\":"+I2S(got48)+",\n";
      js += "        \"rates_h1_30d_received\":"+I2S(got30d)+",\n";
      js += "        \"rates_h1_week_received\":"+I2S(gotW)+",\n";
      js += "        \"rates_h1_month_received\":"+I2S(gotM)+",\n";
      js += "        \"atr_valid_count\":"+I2S(vcnt)+",\n";
      js += "        \"htf_indicators_ok\":"+string(B2S(ok_emaF_h4 && ok_emaS_h4 && ok_adx_h4))+",\n";
      js += "        \"ltf_indicators_ok\":"+string(B2S(ok_emaF_h1 && ok_emaS_h1 && ok_adx_h1))+"\n";
      js += "      }\n";

      js += "    }";
      if(i < n-1) js += ",";
      js += "\n";
   }

   js += "  ]\n";
   js += "}\n";
   return js;
}

//==============================
// CORE CYCLE
//==============================
void BuildFolders()
{
   string broker = Sanitize(AccountInfoString(ACCOUNT_COMPANY));
   string server = Sanitize(AccountInfoString(ACCOUNT_SERVER));
   long login    = AccountInfoInteger(ACCOUNT_LOGIN);

   g_in_folder  = "ISSX_DEV_Friction_" + broker + "_" + server + "_" + (string)login + "\\";
   g_out_folder = "ISSX_DEV_Structural_" + broker + "_" + server + "_" + (string)login + "\\";

   EnsureFolder(g_out_folder);
}

void RecomputeCycle()
{
   string in_rel = g_in_folder + "iss_snapshot_latest.json";

   string txt, err;
   bool read_ok = ReadAllText(in_rel, txt, err);

   string parse_err = "";
   string src_time = "";
   int stageA_count = 0;
   string syms[];
   int ranks[];

   bool parse_ok = false;
   if(read_ok)
      parse_ok = ExtractStageAList(txt, parse_err, src_time, stageA_count, syms, ranks);

   if(!read_ok) parse_err = err;
   if(read_ok && !parse_ok && parse_err=="") parse_err = "parse failed";

   string out_json = BuildStructuralJson(in_rel, (read_ok && parse_ok), parse_err, src_time, syms, ranks);

   string write_err;
   bool used_fallback = false;
   datetime t_server = NowServer(used_fallback);
   string stamp = Stamp(t_server);

   bool ok = AtomicWriteText(g_out_folder+"iss_structural_latest.json", out_json, write_err);
   if(ok && EnableSnapshotStamped)
      ok = AtomicWriteText(g_out_folder+"iss_structural_"+stamp+".json", out_json, write_err);

   if(ok)
   {
      string msg = "ISSX_DEV_Structural: export complete. StageA_in=" + IntegerToString(stageA_count);
      Print(msg);
      if(EnablePopups) Alert(msg);
   }
   else
   {
      string msg = "ISSX_DEV_Structural: EXPORT ERROR: " + write_err;
      Print(msg);
      if(EnablePopups) Alert(msg);
   }
}

//==============================
// INIT / DEINIT / TIMER
//==============================
int OnInit()
{
   BuildFolders();

   EventSetTimer(1);

   g_last_recompute_time = 0;

   Print("ISSX_DEV_Structural: START. InFolder=MQL5\\Files\\", g_in_folder,
         " OutFolder=MQL5\\Files\\", g_out_folder);

   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   Print("ISSX_DEV_Structural: STOP. reason=", reason);
}

void OnTimer()
{
   bool used_fallback = false;
   datetime now = NowServer(used_fallback);

   if(RecomputeMinutes > 0 && (now - g_last_recompute_time) >= (RecomputeMinutes * 60))
   {
      g_last_recompute_time = now;
      RecomputeCycle();
   }
}
//+------------------------------------------------------------------+