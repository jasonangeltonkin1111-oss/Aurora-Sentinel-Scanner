//+------------------------------------------------------------------+
//|                 ISS_Full_Test_Dump.mq5                           |
//|      One-shot dump: symbol truth + account + structure + corr    |
//+------------------------------------------------------------------+
#property strict

input int    HISTORY_DAYS          = 30;
input double PROFIT_TEST_POINTS    = 10.0;
input int    CORR_SYMBOLS_MAX      = 30;
input int    CORR_RET_BARS         = 100;

input int    STRUCT_ATR_PERIOD     = 14;
input int    STRUCT_STD20          = 20;
input int    STRUCT_STD50          = 50;
input ENUM_TIMEFRAMES STRUCT_TF    = PERIOD_H1;

//--------------------------------------------------
string g_server;
string g_base;
//--------------------------------------------------

//---------------- JSON helpers --------------------
string JsonEscape(const string s)
{
   string out=s;
   StringReplace(out,"\\","\\\\");
   StringReplace(out,"\"","\\\"");
   StringReplace(out,"\r","\\r");
   StringReplace(out,"\n","\\n");
   StringReplace(out,"\t","\\t");
   return out;
}
string NowStr() { return TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS); }

int SymDigits(const string sym)
{
   long d=0;
   if(SymbolInfoInteger(sym, SYMBOL_DIGITS, d))
      return (int)d;
   return 5;
}

bool EnsureFolders()
{
   g_server = AccountInfoString(ACCOUNT_SERVER);
   StringReplace(g_server," ","_");
   g_base = "ISS/" + g_server + "/TEST/";
   FolderCreate("ISS");
   FolderCreate("ISS/" + g_server);
   return FolderCreate(g_base);
}

bool IsSymbolUsable(const string sym)
{
   if(sym=="") return false;
   if(!SymbolSelect(sym,true)) return false;

   double bid=SymbolInfoDouble(sym,SYMBOL_BID);
   double ask=SymbolInfoDouble(sym,SYMBOL_ASK);
   if(bid<=0 || ask<=0 || ask<=bid) return false;

   return true;
}

//----- Indicator value readers (MT5 correct way) -----
bool GetATR(const string sym, ENUM_TIMEFRAMES tf, int period, double &outValue)
{
   int h = iATR(sym, tf, period);
   if(h==INVALID_HANDLE) return false;

   double buf[];
   ArraySetAsSeries(buf,true);
   int copied = CopyBuffer(h, 0, 0, 1, buf);
   IndicatorRelease(h);

   if(copied<1) return false;
   outValue = buf[0];
   return true;
}

bool GetStdDev(const string sym, ENUM_TIMEFRAMES tf, int period, double &outValue)
{
   int h = iStdDev(sym, tf, period, 0, MODE_SMA, PRICE_CLOSE);
   if(h==INVALID_HANDLE) return false;

   double buf[];
   ArraySetAsSeries(buf,true);
   int copied = CopyBuffer(h, 0, 0, 1, buf);
   IndicatorRelease(h);

   if(copied<1) return false;
   outValue = buf[0];
   return true;
}

//----- Value per point + margin per 1 lot (account currency) -----
bool CalcValuePerPoint_1Lot(const string sym, double &valuePerPoint)
{
   double bid   = SymbolInfoDouble(sym,SYMBOL_BID);
   double point = SymbolInfoDouble(sym,SYMBOL_POINT);
   if(bid<=0 || point<=0) return false;

   double toPrice = bid + point*PROFIT_TEST_POINTS;

   double profit=0;
   if(!OrderCalcProfit(ORDER_TYPE_BUY, sym, 1.0, bid, toPrice, profit))
      return false;

   valuePerPoint = profit / PROFIT_TEST_POINTS;
   return true;
}

bool CalcMargin_1Lot(const string sym, double &margin1Lot)
{
   double bid = SymbolInfoDouble(sym,SYMBOL_BID);
   if(bid<=0) return false;

   double margin=0;
   if(!OrderCalcMargin(ORDER_TYPE_BUY, sym, 1.0, bid, margin))
      return false;

   margin1Lot = margin;
   return true;
}

//==================================================
// EXPORT 01: SYMBOL TRUTH
//==================================================
void ExportSymbolTruth()
{
   string fn = g_base + "01_symbol_truth.json";
   int f = FileOpen(fn, FILE_WRITE|FILE_TXT);
   if(f==INVALID_HANDLE){ Print("File open failed: ",fn); return; }

   FileWriteString(f,"{\n");
   FileWriteString(f,"  \"server\":\""+JsonEscape(g_server)+"\",\n");
   FileWriteString(f,"  \"generated_at\":\""+JsonEscape(NowStr())+"\",\n");
   FileWriteString(f,"  \"account_currency\":\""+JsonEscape(AccountInfoString(ACCOUNT_CURRENCY))+"\",\n");
   FileWriteString(f,"  \"symbols\":[\n");

   int total = SymbolsTotal(true);
   bool first=true;

   for(int i=0;i<total;i++)
   {
      string sym = SymbolName(i,true);
      if(!IsSymbolUsable(sym)) continue;

      double contract_size = SymbolInfoDouble(sym,SYMBOL_TRADE_CONTRACT_SIZE);
      double tick_size     = SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_SIZE);
      double tick_value    = SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE);
      double min_lot       = SymbolInfoDouble(sym,SYMBOL_VOLUME_MIN);
      double max_lot       = SymbolInfoDouble(sym,SYMBOL_VOLUME_MAX);
      double lot_step      = SymbolInfoDouble(sym,SYMBOL_VOLUME_STEP);

      long digits=0;     SymbolInfoInteger(sym,SYMBOL_DIGITS,digits);
      long trade_mode=0; SymbolInfoInteger(sym,SYMBOL_TRADE_MODE,trade_mode);

      string base_ccy   = SymbolInfoString(sym,SYMBOL_CURRENCY_BASE);
      string profit_ccy = SymbolInfoString(sym,SYMBOL_CURRENCY_PROFIT);
      string margin_ccy = SymbolInfoString(sym,SYMBOL_CURRENCY_MARGIN);

      double vpp=0, m1=0;
      bool okV = CalcValuePerPoint_1Lot(sym,vpp);
      bool okM = CalcMargin_1Lot(sym,m1);

      if(!first) FileWriteString(f,",\n");
      first=false;

      FileWriteString(f,"    {\n");
      FileWriteString(f,"      \"symbol\":\""+JsonEscape(sym)+"\",\n");
      FileWriteString(f,"      \"contract_size\":"+DoubleToString(contract_size,2)+",\n");
      FileWriteString(f,"      \"tick_size\":"+DoubleToString(tick_size,10)+",\n");
      FileWriteString(f,"      \"tick_value\":"+DoubleToString(tick_value,6)+",\n");
      FileWriteString(f,"      \"digits\":"+IntegerToString((int)digits)+",\n");
      FileWriteString(f,"      \"min_lot\":"+DoubleToString(min_lot,2)+",\n");
      FileWriteString(f,"      \"max_lot\":"+DoubleToString(max_lot,2)+",\n");
      FileWriteString(f,"      \"lot_step\":"+DoubleToString(lot_step,2)+",\n");
      FileWriteString(f,"      \"trade_mode\":"+IntegerToString((int)trade_mode)+",\n");
      FileWriteString(f,"      \"base_currency\":\""+JsonEscape(base_ccy)+"\",\n");
      FileWriteString(f,"      \"profit_currency\":\""+JsonEscape(profit_ccy)+"\",\n");
      FileWriteString(f,"      \"margin_currency\":\""+JsonEscape(margin_ccy)+"\",\n");
      FileWriteString(f,"      \"value_per_point_per_1lot\":"+(okV?DoubleToString(vpp,6):"0")+",\n");
      FileWriteString(f,"      \"margin_required_per_1lot\":"+(okM?DoubleToString(m1,2):"0")+"\n");
      FileWriteString(f,"    }");
   }

   FileWriteString(f,"\n  ]\n}\n");
   FileClose(f);
   Print("Exported: ",fn);
}

//==================================================
// EXPORT 02: ACCOUNT SNAPSHOT
//==================================================
void ExportAccountSnapshot()
{
   string fn = g_base + "02_account_snapshot.json";
   int f = FileOpen(fn, FILE_WRITE|FILE_TXT);
   if(f==INVALID_HANDLE){ Print("File open failed: ",fn); return; }

   FileWriteString(f,"{\n");
   FileWriteString(f,"  \"server\":\""+JsonEscape(g_server)+"\",\n");
   FileWriteString(f,"  \"generated_at\":\""+JsonEscape(NowStr())+"\",\n");
   FileWriteString(f,"  \"login\":"+IntegerToString((int)AccountInfoInteger(ACCOUNT_LOGIN))+",\n");
   FileWriteString(f,"  \"currency\":\""+JsonEscape(AccountInfoString(ACCOUNT_CURRENCY))+"\",\n");
   FileWriteString(f,"  \"leverage\":"+IntegerToString((int)AccountInfoInteger(ACCOUNT_LEVERAGE))+",\n");
   FileWriteString(f,"  \"balance\":"+DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2)+",\n");
   FileWriteString(f,"  \"equity\":"+DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2)+",\n");
   FileWriteString(f,"  \"margin_used\":"+DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN),2)+",\n");
   FileWriteString(f,"  \"margin_free\":"+DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_FREE),2)+",\n");
   FileWriteString(f,"  \"margin_level\":"+DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL),2)+"\n");
   FileWriteString(f,"}\n");

   FileClose(f);
   Print("Exported: ",fn);
}

//==================================================
// EXPORT 03: OPEN POSITIONS (commission removed)
//==================================================
void ExportOpenPositions()
{
   string fn = g_base + "03_open_positions.json";
   int f = FileOpen(fn, FILE_WRITE|FILE_TXT);
   if(f==INVALID_HANDLE){ Print("File open failed: ",fn); return; }

   FileWriteString(f,"{\n");
   FileWriteString(f,"  \"server\":\""+JsonEscape(g_server)+"\",\n");
   FileWriteString(f,"  \"generated_at\":\""+JsonEscape(NowStr())+"\",\n");
   FileWriteString(f,"  \"positions\":[\n");

   bool first=true;
   for(int i=0;i<PositionsTotal();i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;

      if(!first) FileWriteString(f,",\n");
      first=false;

      string sym = PositionGetString(POSITION_SYMBOL);
      long type  = (long)PositionGetInteger(POSITION_TYPE);
      int d = SymDigits(sym);

      FileWriteString(f,"    {\n");
      FileWriteString(f,"      \"ticket\":"+IntegerToString((int)ticket)+",\n");
      FileWriteString(f,"      \"symbol\":\""+JsonEscape(sym)+"\",\n");
      FileWriteString(f,"      \"type\":"+IntegerToString((int)type)+",\n");
      FileWriteString(f,"      \"volume\":"+DoubleToString(PositionGetDouble(POSITION_VOLUME),2)+",\n");
      FileWriteString(f,"      \"open_price\":"+DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),d)+",\n");
      FileWriteString(f,"      \"sl\":"+DoubleToString(PositionGetDouble(POSITION_SL),d)+",\n");
      FileWriteString(f,"      \"tp\":"+DoubleToString(PositionGetDouble(POSITION_TP),d)+",\n");
      FileWriteString(f,"      \"profit\":"+DoubleToString(PositionGetDouble(POSITION_PROFIT),2)+",\n");
      FileWriteString(f,"      \"swap\":"+DoubleToString(PositionGetDouble(POSITION_SWAP),2)+"\n");
      FileWriteString(f,"    }");
   }

   FileWriteString(f,"\n  ]\n}\n");
   FileClose(f);
   Print("Exported: ",fn);
}

//==================================================
// EXPORT 04: TRADE HISTORY (last N days)
//==================================================
void ExportTradeHistory()
{
   string fn = g_base + "04_trade_history_30d.json";
   int f = FileOpen(fn, FILE_WRITE|FILE_TXT);
   if(f==INVALID_HANDLE){ Print("File open failed: ",fn); return; }

   datetime to   = TimeCurrent();
   datetime from = to - (datetime)HISTORY_DAYS*86400;
   HistorySelect(from,to);

   FileWriteString(f,"{\n");
   FileWriteString(f,"  \"server\":\""+JsonEscape(g_server)+"\",\n");
   FileWriteString(f,"  \"generated_at\":\""+JsonEscape(NowStr())+"\",\n");
   FileWriteString(f,"  \"from\":\""+JsonEscape(TimeToString(from,TIME_DATE|TIME_SECONDS))+"\",\n");
   FileWriteString(f,"  \"to\":\""+JsonEscape(TimeToString(to,TIME_DATE|TIME_SECONDS))+"\",\n");
   FileWriteString(f,"  \"deals\":[\n");

   bool first=true;
   int total = HistoryDealsTotal();
   for(int i=0;i<total;i++)
   {
      ulong deal = HistoryDealGetTicket(i);
      if(deal==0) continue;

      if(!first) FileWriteString(f,",\n");
      first=false;

      string sym = HistoryDealGetString(deal,DEAL_SYMBOL);
      long   type= (long)HistoryDealGetInteger(deal,DEAL_TYPE);
      int d = SymDigits(sym);

      FileWriteString(f,"    {\n");
      FileWriteString(f,"      \"deal\":"+IntegerToString((int)deal)+",\n");
      FileWriteString(f,"      \"symbol\":\""+JsonEscape(sym)+"\",\n");
      FileWriteString(f,"      \"type\":"+IntegerToString((int)type)+",\n");
      FileWriteString(f,"      \"time\":\""+JsonEscape(TimeToString((datetime)HistoryDealGetInteger(deal,DEAL_TIME),TIME_DATE|TIME_SECONDS))+"\",\n");
      FileWriteString(f,"      \"volume\":"+DoubleToString(HistoryDealGetDouble(deal,DEAL_VOLUME),2)+",\n");
      FileWriteString(f,"      \"price\":"+DoubleToString(HistoryDealGetDouble(deal,DEAL_PRICE),d)+",\n");
      FileWriteString(f,"      \"profit\":"+DoubleToString(HistoryDealGetDouble(deal,DEAL_PROFIT),2)+",\n");
      FileWriteString(f,"      \"commission\":"+DoubleToString(HistoryDealGetDouble(deal,DEAL_COMMISSION),2)+",\n");
      FileWriteString(f,"      \"swap\":"+DoubleToString(HistoryDealGetDouble(deal,DEAL_SWAP),2)+"\n");
      FileWriteString(f,"    }");
   }

   FileWriteString(f,"\n  ]\n}\n");
   FileClose(f);
   Print("Exported: ",fn);
}

//==================================================
// EXPORT 05: MARKET STRUCTURE
//==================================================
void ExportMarketStructure()
{
   string fn = g_base + "05_market_structure.json";
   int f = FileOpen(fn, FILE_WRITE|FILE_TXT);
   if(f==INVALID_HANDLE){ Print("File open failed: ",fn); return; }

   FileWriteString(f,"{\n");
   FileWriteString(f,"  \"server\":\""+JsonEscape(g_server)+"\",\n");
   FileWriteString(f,"  \"generated_at\":\""+JsonEscape(NowStr())+"\",\n");
   FileWriteString(f,"  \"timeframe\":\""+IntegerToString((int)STRUCT_TF)+"\",\n");
   FileWriteString(f,"  \"symbols\":[\n");

   int total = SymbolsTotal(true);
   bool first=true;

   for(int i=0;i<total;i++)
   {
      string sym = SymbolName(i,true);
      if(!IsSymbolUsable(sym)) continue;

      double atr=0, sd20=0, sd50=0;
      bool okATR  = GetATR(sym,STRUCT_TF,STRUCT_ATR_PERIOD,atr);
      bool okSD20 = GetStdDev(sym,STRUCT_TF,STRUCT_STD20,sd20);
      bool okSD50 = GetStdDev(sym,STRUCT_TF,STRUCT_STD50,sd50);

      long spread_points=0;
      SymbolInfoInteger(sym,SYMBOL_SPREAD,spread_points);

      int d = SymDigits(sym);

      if(!first) FileWriteString(f,",\n");
      first=false;

      FileWriteString(f,"    {\n");
      FileWriteString(f,"      \"symbol\":\""+JsonEscape(sym)+"\",\n");
      FileWriteString(f,"      \"bid\":"+DoubleToString(SymbolInfoDouble(sym,SYMBOL_BID),d)+",\n");
      FileWriteString(f,"      \"ask\":"+DoubleToString(SymbolInfoDouble(sym,SYMBOL_ASK),d)+",\n");
      FileWriteString(f,"      \"spread_points\":"+IntegerToString((int)spread_points)+",\n");
      FileWriteString(f,"      \"atr\":"+(okATR?DoubleToString(atr,6):"0")+",\n");
      FileWriteString(f,"      \"std20\":"+(okSD20?DoubleToString(sd20,6):"0")+",\n");
      FileWriteString(f,"      \"std50\":"+(okSD50?DoubleToString(sd50,6):"0")+"\n");
      FileWriteString(f,"    }");
   }

   FileWriteString(f,"\n  ]\n}\n");
   FileClose(f);
   Print("Exported: ",fn);
}

//==================================================
// CORRELATION (flat array approach)
//==================================================
bool GetReturns(const string sym, ENUM_TIMEFRAMES tf, int retBars, double &rets[])
{
   double closes[];
   ArraySetAsSeries(closes,true);

   int need = retBars+1;
   int got = CopyClose(sym, tf, 0, need, closes);
   if(got < need) return false;

   ArrayResize(rets, retBars);
   ArraySetAsSeries(rets,true);

   for(int i=0;i<retBars;i++)
   {
      double c0 = closes[i];
      double c1 = closes[i+1];
      if(c0<=0 || c1<=0) rets[i]=0;
      else rets[i] = MathLog(c0/c1);
   }
   return true;
}

double CorrFlat(const double &flat[], int idxA, int idxB, int bars)
{
   // idxA, idxB are symbol indices; each has 'bars' values packed
   int offA = idxA*bars;
   int offB = idxB*bars;

   double meanA=0, meanB=0;
   for(int i=0;i<bars;i++){ meanA += flat[offA+i]; meanB += flat[offB+i]; }
   meanA/=bars; meanB/=bars;

   double num=0, denA=0, denB=0;
   for(int i=0;i<bars;i++)
   {
      double da = flat[offA+i]-meanA;
      double db = flat[offB+i]-meanB;
      num += da*db;
      denA += da*da;
      denB += db*db;
   }
   if(denA<=0 || denB<=0) return 0.0;
   return num / MathSqrt(denA*denB);
}

void ExportCorrelation()
{
   string fn = g_base + "06_correlation_top30.json";
   int f = FileOpen(fn, FILE_WRITE|FILE_TXT);
   if(f==INVALID_HANDLE){ Print("File open failed: ",fn); return; }

   // build symbol list with enough history
   string syms[];
   ArrayResize(syms,0);

   int total = SymbolsTotal(true);
   for(int i=0;i<total && ArraySize(syms)<CORR_SYMBOLS_MAX;i++)
   {
      string s = SymbolName(i,true);
      if(!IsSymbolUsable(s)) continue;

      double tmp[];
      if(!GetReturns(s, PERIOD_H1, CORR_RET_BARS, tmp)) continue;

      int n = ArraySize(syms);
      ArrayResize(syms,n+1);
      syms[n]=s;
   }

   int N = ArraySize(syms);

   // pack returns into flat array size N*bars
   double flat[];
   ArrayResize(flat, N*CORR_RET_BARS);

   for(int i=0;i<N;i++)
   {
      double r[];
      if(!GetReturns(syms[i], PERIOD_H1, CORR_RET_BARS, r))
      {
         // fill zeros if fails unexpectedly
         for(int k=0;k<CORR_RET_BARS;k++) flat[i*CORR_RET_BARS+k]=0;
         continue;
      }
      for(int k=0;k<CORR_RET_BARS;k++) flat[i*CORR_RET_BARS+k]=r[k];
   }

   // write JSON
   FileWriteString(f,"{\n");
   FileWriteString(f,"  \"server\":\""+JsonEscape(g_server)+"\",\n");
   FileWriteString(f,"  \"generated_at\":\""+JsonEscape(NowStr())+"\",\n");
   FileWriteString(f,"  \"bars\":"+IntegerToString(CORR_RET_BARS)+",\n");
   FileWriteString(f,"  \"symbols\":[");
   for(int i=0;i<N;i++){ FileWriteString(f,"\""+JsonEscape(syms[i])+"\""); if(i<N-1) FileWriteString(f,","); }
   FileWriteString(f,"],\n");
   FileWriteString(f,"  \"matrix\":[\n");

   for(int i=0;i<N;i++)
   {
      FileWriteString(f,"    [");
      for(int j=0;j<N;j++)
      {
         double c = CorrFlat(flat, i, j, CORR_RET_BARS);
         FileWriteString(f, DoubleToString(c,3));
         if(j<N-1) FileWriteString(f,",");
      }
      FileWriteString(f,"]");
      if(i<N-1) FileWriteString(f,",\n");
   }

   FileWriteString(f,"\n  ]\n}\n");
   FileClose(f);
   Print("Exported: ",fn);
}

//==================================================
// MAIN
//==================================================
int OnInit()
{
   if(!EnsureFolders())
   {
      Print("Failed creating folders.");
      return(INIT_FAILED);
   }

   ExportSymbolTruth();
   ExportAccountSnapshot();
   ExportOpenPositions();
   ExportTradeHistory();
   ExportMarketStructure();
   ExportCorrelation();

   Print("ISS FULL TEST DUMP COMPLETE.");
   return(INIT_SUCCEEDED);
}

void OnTick(){}
//+------------------------------------------------------------------+