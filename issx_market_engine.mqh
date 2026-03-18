//+------------------------------------------------------------------+
//|            AURORA_StructureEA_Test_v0.1                         |
//|   Minimal test engine: Structure + EMA + ATR + Swings + BOS    |
//+------------------------------------------------------------------+
#property strict

//========================= INPUTS ==================================
input string TestSymbol              = "EURUSD";
input ENUM_TIMEFRAMES TestTF         = PERIOD_H1;
input int    BarsToLoad              = 300;
input int    BarsToExport            = 100;
input int    SwingLookback           = 2;
input int    TestRefreshMinutes      = 5;
input bool   EnableCycleAlerts       = true;
input bool   EnableSoundAlert        = true;

//========================= GLOBALS =================================
ulong     g_cycle_id = 0;
datetime  g_last_bar_time = 0;

// Indicator handles
int hEMA20, hEMA50, hEMA200, hATR;

//========================= INIT ====================================
int OnInit()
{
   if(!SymbolSelect(TestSymbol,true))
   {
      Print("Failed to select symbol.");
      return INIT_FAILED;
   }

   // Create indicator handles once
   hEMA20  = iMA(TestSymbol, TestTF, 20, 0, MODE_EMA, PRICE_CLOSE);
   hEMA50  = iMA(TestSymbol, TestTF, 50, 0, MODE_EMA, PRICE_CLOSE);
   hEMA200 = iMA(TestSymbol, TestTF, 200,0, MODE_EMA, PRICE_CLOSE);
   hATR    = iATR(TestSymbol, TestTF, 14);

   if(hEMA20==INVALID_HANDLE || hEMA50==INVALID_HANDLE || 
      hEMA200==INVALID_HANDLE || hATR==INVALID_HANDLE)
   {
      Print("Indicator handle creation failed.");
      return INIT_FAILED;
   }

   EventSetTimer(TestRefreshMinutes * 60);

   Print("AURORA_StructureEA_Test_v0.1 Initialized.");
   return INIT_SUCCEEDED;
}

//========================= DEINIT ==================================
void OnDeinit(const int reason)
{
   EventKillTimer();
   IndicatorRelease(hEMA20);
   IndicatorRelease(hEMA50);
   IndicatorRelease(hEMA200);
   IndicatorRelease(hATR);
}

//========================= TIMER ===================================
void OnTimer()
{
   g_cycle_id++;

   ulong start = GetMicrosecondCount();

   if(EnableCycleAlerts)
      Print("[AURORA] Cycle ", g_cycle_id, " START");

   if(EnableSoundAlert)
      PlaySound("alert.wav");

   // Detect new bar
   datetime current_bar_time = iTime(TestSymbol, TestTF, 0);
   if(current_bar_time == g_last_bar_time)
   {
      Print("No new bar. Skipping heavy calculation.");
      return;
   }
   g_last_bar_time = current_bar_time;

   RunStructureEngine();

   ulong end = GetMicrosecondCount();
   double duration_ms = (end - start) / 1000.0;

   if(EnableCycleAlerts)
      Print("[AURORA] Cycle ", g_cycle_id, " END - Duration: ", 
            DoubleToString(duration_ms,2), " ms");

   if(EnableSoundAlert)
      PlaySound("ok.wav");
}

//========================= STRUCTURE ENGINE ========================
void RunStructureEngine()
{
   double close[], high[], low[];
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);

   if(CopyClose(TestSymbol,TestTF,0,BarsToLoad,close) < BarsToLoad) return;
   if(CopyHigh(TestSymbol,TestTF,0,BarsToLoad,high) < BarsToLoad) return;
   if(CopyLow(TestSymbol,TestTF,0,BarsToLoad,low) < BarsToLoad) return;

   // Indicator buffers
   double ema20[], ema50[], ema200[], atr[];
   ArraySetAsSeries(ema20,true);
   ArraySetAsSeries(ema50,true);
   ArraySetAsSeries(ema200,true);
   ArraySetAsSeries(atr,true);

   CopyBuffer(hEMA20,0,0,BarsToLoad,ema20);
   CopyBuffer(hEMA50,0,0,BarsToLoad,ema50);
   CopyBuffer(hEMA200,0,0,BarsToLoad,ema200);
   CopyBuffer(hATR,0,0,BarsToLoad,atr);

   //================ SWING DETECTION ==================
   int swingCount = 0;
   double lastSwingHigh=0, lastSwingLow=0;
   bool bos_up=false, bos_down=false;

   for(int i=SwingLookback; i<BarsToLoad-SwingLookback; i++)
   {
      bool swingHigh=true, swingLow=true;

      for(int j=1; j<=SwingLookback; j++)
      {
         if(high[i] <= high[i-j] || high[i] <= high[i+j])
            swingHigh=false;

         if(low[i] >= low[i-j] || low[i] >= low[i+j])
            swingLow=false;
      }

      if(swingHigh)
      {
         swingCount++;
         if(lastSwingHigh>0 && high[i] > lastSwingHigh)
            bos_up=true;

         lastSwingHigh = high[i];
      }

      if(swingLow)
      {
         swingCount++;
         if(lastSwingLow>0 && low[i] < lastSwingLow)
            bos_down=true;

         lastSwingLow = low[i];
      }
   }

   //================ JSON EXPORT ==================
   string folder = "AURORA_TEST/";
   FolderCreate(folder);

   string filename = folder + TestSymbol + "_H1_test.json";
   int f = FileOpen(filename, FILE_WRITE|FILE_TXT);

   if(f==INVALID_HANDLE)
   {
      Print("File open failed.");
      return;
   }

   FileWriteString(f,"{\n");
   FileWriteString(f,"  \"cycle_id\":"+IntegerToString((int)g_cycle_id)+",\n");
   FileWriteString(f,"  \"symbol\":\""+TestSymbol+"\",\n");
   FileWriteString(f,"  \"timeframe\":\"H1\",\n");
   FileWriteString(f,"  \"bars_loaded\":"+IntegerToString(BarsToLoad)+",\n");
   FileWriteString(f,"  \"ema20_current\":"+DoubleToString(ema20[0],6)+",\n");
   FileWriteString(f,"  \"ema50_current\":"+DoubleToString(ema50[0],6)+",\n");
   FileWriteString(f,"  \"ema200_current\":"+DoubleToString(ema200[0],6)+",\n");
   FileWriteString(f,"  \"atr14_current\":"+DoubleToString(atr[0],6)+",\n");
   FileWriteString(f,"  \"bos_up\":"+(bos_up?"true":"false")+",\n");
   FileWriteString(f,"  \"bos_down\":"+(bos_down?"true":"false")+",\n");
   FileWriteString(f,"  \"swing_count\":"+IntegerToString(swingCount)+"\n");
   FileWriteString(f,"}\n");

   FileClose(f);
   Print("Exported: ", filename);
}

//========================= EMPTY ===================================
void OnTick(){}
//+------------------------------------------------------------------+