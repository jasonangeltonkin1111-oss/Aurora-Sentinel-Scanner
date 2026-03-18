//+------------------------------------------------------------------+
//|                                                AFS_TraderIntel   |
//|              Aegis Forge Scanner - Phase 1 / Step 12            |
//+------------------------------------------------------------------+
#ifndef __AFS_TRADERINTEL_MQH__
#define __AFS_TRADERINTEL_MQH__

#include "AFS_CoreTypes.mqh"

string AFS_TI_JsonEscape(const string value)
  {
   string s = value;
   StringReplace(s, "\\", "\\\\");
   StringReplace(s, "\"", "\\\"");
   StringReplace(s, "\r", "\\r");
   StringReplace(s, "\n", "\\n");
   StringReplace(s, "\t", "\\t");
   return s;
  }

string AFS_TI_JsonString(const string value)
  {
   return "\"" + AFS_TI_JsonEscape(value) + "\"";
  }

string AFS_TI_JsonBool(const bool value)
  {
   return value ? "true" : "false";
  }

string AFS_TI_LongText(const long value)
  {
   return StringFormat("%I64d", value);
  }

string AFS_TI_JsonInt(const long value)
  {
   return AFS_TI_LongText(value);
  }

string AFS_TI_JsonDouble(const double value,const int digits=8)
  {
   if(!MathIsValidNumber(value))
      return "0";
   return DoubleToString(value, digits);
  }

string AFS_TI_JsonNullableDouble(const double value,const int digits=8)
  {
   if(!MathIsValidNumber(value))
      return "null";
   return DoubleToString(value, digits);
  }

string AFS_TI_TimeframeTag(const ENUM_TIMEFRAMES tf)
  {
   switch(tf)
     {
      case PERIOD_M1:  return "M1";
      case PERIOD_M5:  return "M5";
      case PERIOD_M15: return "M15";
      case PERIOD_H1:  return "H1";
     }
   return "TF_UNKNOWN";
  }

int AFS_TI_TargetBars(const ENUM_TIMEFRAMES tf)
  {
   switch(tf)
     {
      case PERIOD_M1:  return 90;
      case PERIOD_M5:  return 72;
      case PERIOD_M15: return 48;
      case PERIOD_H1:  return 36;
     }
   return 0;
  }

int AFS_TI_RefreshAgeSec(const ENUM_TIMEFRAMES tf)
  {
   switch(tf)
     {
      case PERIOD_M1:  return 1800;
      case PERIOD_M5:  return 1800;
      case PERIOD_M15: return 1800;
      case PERIOD_H1:  return 1800;
     }
   return 1800;
  }

long AFS_TI_TimeUnix(const datetime value)
  {
   if(value <= 0)
      return 0;
   return (long)value;
  }

int AFS_TI_AgeSec(const datetime now,const datetime then_value)
  {
   if(now <= 0 || then_value <= 0)
      return -1;
   if(now < then_value)
      return 0;
   return (int)(now - then_value);
  }

string AFS_TI_SafeText(const string value,const string fallback="")
  {
   if(StringLen(value) > 0)
      return value;
   return fallback;
  }

double AFS_TI_NonNegative(const double value)
  {
   if(!MathIsValidNumber(value))
      return 0.0;
   if(value < 0.0)
      return 0.0;
   return value;
  }

void AFS_TI_AddLine(string &lines[],int &count,const string text)
  {
   ArrayResize(lines, count + 1);
   lines[count] = text;
   count++;
  }

void AFS_TI_AddField(string &lines[],int &count,const string indent,const string name,const string json_value,const bool comma=true)
  {
   string line = indent + "\"" + name + "\": " + json_value;
   if(comma)
      line += ",";
   AFS_TI_AddLine(lines, count, line);
  }

ulong AFS_TI_HashRawText(const string value)
  {
   ulong hash = 1469598103934665603;
   int len = StringLen(value);
   for(int i = 0; i < len; i++)
     {
      ulong c = (ulong)StringGetCharacter(value, i);
      hash ^= c;
      hash *= 1099511628211;
     }
   return hash;
  }

string AFS_TI_HashText(const string value)
  {
   ulong hash_value = AFS_TI_HashRawText(value);
   return StringFormat("%I64u", hash_value) + "_" + IntegerToString(StringLen(value));
  }

string AFS_TI_StableSignatureFromLines(string &lines[],const int count)
  {
   string stable = "";
   for(int i = 0; i < count; i++)
     {
      if(StringFind(lines[i], "\"GeneratedAt\":") >= 0)
         continue;
      stable += lines[i];
      stable += "\n";
     }
   return AFS_TI_HashText(stable);
  }

string AFS_TI_StableSignatureFromText(const string text)
  {
   string normalized = text;
   StringReplace(normalized, "\r", "");
   ushort sep = 10;
   string parts[];
   int count = StringSplit(normalized, sep, parts);
   string stable = "";
   for(int i = 0; i < count; i++)
     {
      if(StringFind(parts[i], "\"GeneratedAt\":") >= 0)
         continue;
      stable += parts[i];
      stable += "\n";
     }
   return AFS_TI_HashText(stable);
  }

bool AFS_TI_ReadAllText(const string rel_file,const bool use_common_files,string &text)
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

string AFS_TI_BuildAtomicTempFilePath(const string rel_file)
  {
   string dir  = AFS_TI_FileDirName(rel_file);
   string base = AFS_TI_FileBaseName(rel_file);
   string temp = ".__afs_tmp_" + IntegerToString((int)GetTickCount()) + "_" + base;
   if(StringLen(dir) > 0)
      return dir + "\\" + temp;
   return temp;
  }

bool AFS_TI_WriteTextFile(const string rel_file,const bool use_common_files,string &lines[],const int count,string &err)
  {
   err = "";
   int flags = FILE_WRITE | FILE_TXT | FILE_ANSI;
   if(use_common_files)
      flags |= FILE_COMMON;

   string temp_file = AFS_TI_BuildAtomicTempFilePath(rel_file);

   ResetLastError();
   int h = FileOpen(temp_file, flags);
   if(h == INVALID_HANDLE)
     {
      err = "Failed to write temp trader data file: " + temp_file + " | LastError=" + IntegerToString(GetLastError());
      return false;
     }

   for(int i = 0; i < count; i++)
     {
      ResetLastError();
      FileWriteString(h, lines[i] + "\r\n");
      if(GetLastError() != 0)
        {
         int write_err = GetLastError();
         FileClose(h);
         FileDelete(temp_file, use_common_files ? FILE_COMMON : 0);
         err = "Failed while writing temp trader data file: " + temp_file + " | LastError=" + IntegerToString(write_err);
         return false;
        }
     }

   FileFlush(h);
   FileClose(h);

   int common_flag = (use_common_files ? FILE_COMMON : 0);
   int move_flags  = FILE_REWRITE | common_flag;
   ResetLastError();
   if(!FileMove(temp_file, common_flag, rel_file, move_flags))
     {
      int move_err = GetLastError();
      FileDelete(temp_file, common_flag);
      err = "Failed to promote temp trader data file: " + temp_file + " -> " + rel_file + " | LastError=" + IntegerToString(move_err);
      return false;
     }

   return true;
  }

string AFS_TI_FileBaseName(const string path)
  {
   string p = path;
   StringReplace(p, "/", "\\");
   int pos = -1;
   for(int i = 0; i < StringLen(p); i++)
      if(StringGetCharacter(p, i) == '\\')
         pos = i;
   if(pos >= 0 && pos + 1 < StringLen(p))
      return StringSubstr(p, pos + 1);
   return p;
  }

string AFS_TI_FileDirName(const string path)
  {
   string p = path;
   StringReplace(p, "/", "\\");
   int pos = -1;
   for(int i = 0; i < StringLen(p); i++)
      if(StringGetCharacter(p, i) == '\\')
         pos = i;
   if(pos > 0)
      return StringSubstr(p, 0, pos);
   return "";
  }

string AFS_TI_TimeStampTag(const datetime now)
  {
   string t = TimeToString(now, TIME_DATE|TIME_SECONDS);
   StringReplace(t, ".", "-");
   StringReplace(t, ":", "-");
   StringReplace(t, " ", "_");
   return t;
  }

string AFS_TI_ShortHash(const string value)
  {
   string s = value;
   if(StringLen(s) > 12)
      s = StringSubstr(s, 0, 12);
   StringReplace(s, "_", "");
   return s;
  }

string AFS_TI_BuildArchiveFile(const AFS_OutputPathState &paths,const datetime now,const string payload_sig)
  {
   string dir = paths.TraderDataFolder;
   if(StringLen(dir) == 0)
      dir = paths.RootFolder + "\\Trader-Data";

   string server = paths.ServerKey;
   if(StringLen(server) == 0)
      server = "UNKNOWN_SERVER";

   return dir + "\\" + server + "_TRADER_DATA_" + AFS_TI_TimeStampTag(now) + "_" + AFS_TI_ShortHash(payload_sig) + ".txt";
  }

void AFS_TI_InitTfCache(AFS_TI_TimeframeCache &cache,const ENUM_TIMEFRAMES tf)
  {
   cache.Timeframe     = tf;
   cache.TargetBars    = AFS_TI_TargetBars(tf);
   cache.RefreshAgeSec = AFS_TI_RefreshAgeSec(tf);
   cache.LastRefreshAt = 0;
   cache.LastBarTime   = 0;
   cache.HasData       = false;
   cache.BarCount      = 0;
   cache.Status        = "UNINITIALIZED";
   cache.LastError     = "";
   ArrayResize(cache.Bars, 0);
  }

void AFS_TI_InitSymbolCache(AFS_TI_SymbolCache &cache,const string raw_symbol,const string canonical_symbol)
  {
   cache.RawSymbol             = raw_symbol;
   cache.CanonicalSymbol       = canonical_symbol;
   cache.MaterialSignature     = "";
   cache.LastTouchedAt         = 0;
   cache.LastMaterialChangeAt  = 0;
   cache.Dirty                 = false;

   AFS_TI_InitTfCache(cache.M1, PERIOD_M1);
   AFS_TI_InitTfCache(cache.M5, PERIOD_M5);
   AFS_TI_InitTfCache(cache.M15, PERIOD_M15);
   AFS_TI_InitTfCache(cache.H1, PERIOD_H1);
  }

int AFS_TI_FindSymbolCacheIndex(AFS_TraderIntelState &state,const string raw_symbol)
  {
   for(int i = 0; i < ArraySize(state.Caches); i++)
      if(state.Caches[i].RawSymbol == raw_symbol)
         return i;
   return -1;
  }

int AFS_TI_EnsureSymbolCache(AFS_TraderIntelState &state,const string raw_symbol,const string canonical_symbol)
  {
   int idx = AFS_TI_FindSymbolCacheIndex(state, raw_symbol);
   if(idx >= 0)
      return idx;

   idx = ArraySize(state.Caches);
   ArrayResize(state.Caches, idx + 1);
   AFS_TI_InitSymbolCache(state.Caches[idx], raw_symbol, canonical_symbol);
   state.CacheCount = ArraySize(state.Caches);
   return idx;
  }

bool AFS_TI_TfRefreshDue(const AFS_TI_TimeframeCache &cache,const datetime now,const bool force_refresh)
  {
   if(force_refresh)
      return true;
   if(!cache.HasData)
      return true;
   if(cache.LastRefreshAt <= 0)
      return true;
   if(cache.RefreshAgeSec <= 0)
      return true;
   return ((now - cache.LastRefreshAt) >= cache.RefreshAgeSec);
  }

bool AFS_TI_FinalistBetter(const AFS_UniverseSymbol &a,const AFS_UniverseSymbol &b)
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

bool AFS_TI_BucketExists(string &buckets[],const string bucket)
  {
   for(int i = 0; i < ArraySize(buckets); i++)
      if(buckets[i] == bucket)
         return true;
   return false;
  }

int AFS_TI_BuildOrderedFinalistIndexes(const AFS_UniverseSymbol &universe[],const int total,const int max_symbols,int &ordered[])
  {
   ArrayResize(ordered, 0);
   string buckets[];
   ArrayResize(buckets, 0);

   for(int i = 0; i < total; i++)
     {
      if(!universe[i].FinalistSelected)
         continue;

      string bucket = AFS_TI_SafeText(universe[i].PrimaryBucket, "UNBUCKETED");
      if(!AFS_TI_BucketExists(buckets, bucket))
        {
         int n = ArraySize(buckets);
         ArrayResize(buckets, n + 1);
         buckets[n] = bucket;
        }
     }

   for(int b = 0; b < ArraySize(buckets); b++)
     {
      int temp[];
      ArrayResize(temp, 0);

      for(int i = 0; i < total; i++)
        {
         if(!universe[i].FinalistSelected)
            continue;
         string bucket = AFS_TI_SafeText(universe[i].PrimaryBucket, "UNBUCKETED");
         if(bucket != buckets[b])
            continue;

         int n = ArraySize(temp);
         ArrayResize(temp, n + 1);
         temp[n] = i;
        }

      for(int x = 0; x < ArraySize(temp); x++)
        {
         int best = x;
         for(int y = x + 1; y < ArraySize(temp); y++)
            if(AFS_TI_FinalistBetter(universe[temp[y]], universe[temp[best]]))
               best = y;
         if(best != x)
           {
            int swap = temp[x];
            temp[x] = temp[best];
            temp[best] = swap;
           }
        }

      for(int j = 0; j < ArraySize(temp); j++)
        {
         if(max_symbols > 0 && ArraySize(ordered) >= max_symbols)
            break;

         int n = ArraySize(ordered);
         ArrayResize(ordered, n + 1);
         ordered[n] = temp[j];
        }

      if(max_symbols > 0 && ArraySize(ordered) >= max_symbols)
         break;
     }

   return ArraySize(ordered);
  }

string AFS_TI_BuildShortlistSignature(const AFS_UniverseSymbol &universe[],const int &ordered[])
  {
   string raw = "";
   for(int i = 0; i < ArraySize(ordered); i++)
     {
      AFS_UniverseSymbol rec = universe[ordered[i]];
      raw += rec.Symbol + "|";
      raw += rec.CanonicalSymbol + "|";
      raw += rec.PrimaryBucket + "|";
      raw += IntegerToString(rec.BucketRank) + "|";
      raw += rec.FrictionStatus + "|";
      raw += DoubleToString(rec.TotalScore, 4) + "|";
      raw += DoubleToString(rec.CorrMax, 4) + "|";
      raw += rec.CorrClosestSymbol + "|";
      raw += rec.CorrContextFlag + "\n";
     }
   return AFS_TI_HashText(raw);
  }

bool AFS_TI_LoadRatesToCache(const string symbol,AFS_TI_TimeframeCache &cache,const datetime now,string &err)
  {
   err = "";
   int target = cache.TargetBars;
   if(target <= 0)
     {
      cache.Status = "DISABLED";
      return true;
     }

   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   ResetLastError();
   int copied = CopyRates(symbol, cache.Timeframe, 0, target, rates);
   if(copied <= 0)
     {
      cache.Status = "COPY_FAIL";
      cache.LastError = "CopyRates failed for " + symbol + " " + AFS_TI_TimeframeTag(cache.Timeframe) +
                        " | LastError=" + IntegerToString(GetLastError());
      err = cache.LastError;
      return false;
     }

   ArrayResize(cache.Bars, copied);
   for(int i = 0; i < copied; i++)
     {
      int src = copied - 1 - i;
      cache.Bars[i].TimeUnix   = (long)rates[src].time;
      cache.Bars[i].Open       = rates[src].open;
      cache.Bars[i].High       = rates[src].high;
      cache.Bars[i].Low        = rates[src].low;
      cache.Bars[i].Close      = rates[src].close;
      cache.Bars[i].TickVolume = rates[src].tick_volume;
      cache.Bars[i].Spread     = rates[src].spread;
      cache.Bars[i].RealVolume = rates[src].real_volume;
     }

   cache.BarCount      = copied;
   cache.HasData       = true;
   cache.LastRefreshAt = now;
   cache.LastBarTime   = (datetime)cache.Bars[copied - 1].TimeUnix;
   cache.Status        = (copied >= target ? "OK" : "PARTIAL");
   cache.LastError     = "";
   return true;
  }

bool AFS_TI_RefreshCacheIfDue(const string symbol,AFS_TI_TimeframeCache &cache,const datetime now,const bool force_refresh,string &err)
  {
   if(!AFS_TI_TfRefreshDue(cache, now, force_refresh))
      return true;

   return AFS_TI_LoadRatesToCache(symbol, cache, now, err);
  }

double AFS_TI_M1SpreadPrice(const AFS_UniverseSymbol &rec,const AFS_TI_OhlcBar &bar)
  {
   if(rec.Point > 0.0)
      return ((double)bar.Spread) * rec.Point;
   return (double)bar.Spread;
  }

void AFS_TI_CalcMicroContext(const AFS_UniverseSymbol &rec,
                             const AFS_TI_TimeframeCache &m1,
                             double &current_open,
                             double &current_high,
                             double &current_low,
                             double &current_bid,
                             double &current_ask,
                             double &current_spread,
                             double &mean_spread_20,
                             double &max_spread_20,
                             double &micro_range_20,
                             double &dist_recent_high,
                             double &dist_recent_low)
  {
   current_open      = 0.0;
   current_high      = 0.0;
   current_low       = 0.0;
   current_bid       = rec.Bid;
   current_ask       = rec.Ask;
   current_spread    = rec.SpreadSnapshot;
   mean_spread_20    = 0.0;
   max_spread_20     = 0.0;
   micro_range_20    = 0.0;
   dist_recent_high  = 0.0;
   dist_recent_low   = 0.0;

   if(!m1.HasData || m1.BarCount <= 0)
      return;

   AFS_TI_OhlcBar latest = m1.Bars[m1.BarCount - 1];
   current_open = latest.Open;
   current_high = latest.High;
   current_low  = latest.Low;

   int take = MathMin(20, m1.BarCount);
   double recent_high = latest.High;
   double recent_low  = latest.Low;
   double spread_sum  = 0.0;

   for(int i = m1.BarCount - take; i < m1.BarCount; i++)
     {
      if(m1.Bars[i].High > recent_high)
         recent_high = m1.Bars[i].High;
      if(m1.Bars[i].Low < recent_low)
         recent_low = m1.Bars[i].Low;

      double spread_price = AFS_TI_M1SpreadPrice(rec, m1.Bars[i]);
      spread_sum += spread_price;
      if(spread_price > max_spread_20)
         max_spread_20 = spread_price;
     }

   if(take > 0)
      mean_spread_20 = spread_sum / (double)take;

   micro_range_20   = recent_high - recent_low;
   dist_recent_high = MathAbs(recent_high - current_bid);
   dist_recent_low  = MathAbs(current_bid - recent_low);
  }


bool AFS_TI_CalcATRFromCache(const AFS_TI_TimeframeCache &cache,const int period,double &atr_out)
  {
   atr_out = 0.0;
   if(!cache.HasData || cache.BarCount <= period)
      return false;

   int start = cache.BarCount - period;
   if(start <= 0)
      start = 1;

   double tr_sum = 0.0;
   int used = 0;
   for(int i = start; i < cache.BarCount; i++)
     {
      double prev_close = cache.Bars[i - 1].Close;
      double tr1 = cache.Bars[i].High - cache.Bars[i].Low;
      double tr2 = MathAbs(cache.Bars[i].High - prev_close);
      double tr3 = MathAbs(cache.Bars[i].Low - prev_close);
      double tr = MathMax(tr1, MathMax(tr2, tr3));
      tr_sum += tr;
      used++;
     }

   if(used <= 0)
      return false;

   atr_out = tr_sum / (double)used;
   return (atr_out > 0.0);
  }

bool AFS_TI_CalcATRFromRates(const string symbol,const ENUM_TIMEFRAMES tf,const int period,double &atr_out)
  {
   atr_out = 0.0;
   int need = period + 2;
   MqlRates rates[];
   ArraySetAsSeries(rates, false);
   int copied = CopyRates(symbol, tf, 0, need, rates);
   if(copied <= period)
      return false;

   double tr_sum = 0.0;
   int used = 0;
   int start = copied - period;
   if(start <= 0)
      start = 1;

   for(int i = start; i < copied; i++)
     {
      double prev_close = rates[i - 1].close;
      double tr1 = rates[i].high - rates[i].low;
      double tr2 = MathAbs(rates[i].high - prev_close);
      double tr3 = MathAbs(rates[i].low - prev_close);
      double tr = MathMax(tr1, MathMax(tr2, tr3));
      tr_sum += tr;
      used++;
     }

   if(used <= 0)
      return false;

   atr_out = tr_sum / (double)used;
   return (atr_out > 0.0);
  }

double AFS_TI_MoveFromCache(const AFS_TI_TimeframeCache &cache)
  {
   if(!cache.HasData || cache.BarCount < 2)
      return 0.0;
   return cache.Bars[cache.BarCount - 1].Close - cache.Bars[cache.BarCount - 2].Close;
  }

double AFS_TI_RangeFromRates(const string symbol,const ENUM_TIMEFRAMES tf,const int bars)
  {
   MqlRates rates[];
   ArraySetAsSeries(rates, false);
   int copied = CopyRates(symbol, tf, 0, bars, rates);
   if(copied <= 0)
      return 0.0;

   double hi = rates[0].high;
   double lo = rates[0].low;
   for(int i = 1; i < copied; i++)
     {
      if(rates[i].high > hi) hi = rates[i].high;
      if(rates[i].low < lo)  lo = rates[i].low;
     }
   return (hi - lo);
  }

double AFS_TI_NormalizeLot(const double requested,const AFS_UniverseSymbol &rec)
  {
   if(requested <= 0.0 || rec.VolumeStep <= 0.0 || rec.VolumeMax <= 0.0)
      return 0.0;

   double lot = MathFloor(requested / rec.VolumeStep) * rec.VolumeStep;
   if(lot < rec.VolumeMin)
      return 0.0;
   if(lot > rec.VolumeMax)
      lot = rec.VolumeMax;
   return lot;
  }

double AFS_TI_RiskLotByStop(const double risk_money,const double stop_price,const AFS_UniverseSymbol &rec)
  {
   if(risk_money <= 0.0 || stop_price <= 0.0)
      return 0.0;

   double tv = rec.TickValue;
   if(tv <= 0.0)
      tv = rec.TickValueValidated;
   if(tv <= 0.0)
      tv = rec.TickValueDerived;

   if(tv <= 0.0 || rec.TickSize <= 0.0)
      return 0.0;

   double loss_per_lot = (stop_price / rec.TickSize) * tv;
   if(loss_per_lot <= 0.0)
      return 0.0;

   return AFS_TI_NormalizeLot(risk_money / loss_per_lot, rec);
  }

void AFS_TI_AppendOhlcArray(string &lines[],int &count,const string indent,const string name,const AFS_TI_TimeframeCache &cache,const bool include,const bool comma_after)
  {
   string first_line = indent + "\"" + name + "\": [";
   AFS_TI_AddLine(lines, count, first_line);

   if(include && cache.HasData && cache.BarCount > 0)
     {
      for(int i = 0; i < cache.BarCount; i++)
        {
         string suffix = (i < cache.BarCount - 1 ? "," : "");
         string line = indent + "  {";
         line += "\"time_unix\": " + AFS_TI_JsonInt(cache.Bars[i].TimeUnix);
         line += ", \"open\": " + AFS_TI_JsonDouble(cache.Bars[i].Open, 8);
         line += ", \"high\": " + AFS_TI_JsonDouble(cache.Bars[i].High, 8);
         line += ", \"low\": " + AFS_TI_JsonDouble(cache.Bars[i].Low, 8);
         line += ", \"close\": " + AFS_TI_JsonDouble(cache.Bars[i].Close, 8);
         line += ", \"tick_volume\": " + AFS_TI_JsonInt(cache.Bars[i].TickVolume);
         line += ", \"spread\": " + AFS_TI_JsonInt(cache.Bars[i].Spread);
         line += ", \"real_volume\": " + AFS_TI_JsonInt(cache.Bars[i].RealVolume);
         line += "}" + suffix;
         AFS_TI_AddLine(lines, count, line);
        }
     }

   string end_line = indent + "]";
   if(comma_after)
      end_line += ",";
   AFS_TI_AddLine(lines, count, end_line);
  }

void AFS_TI_AppendSymbolObject(string &lines[],
                               int &count,
                               const AFS_UniverseSymbol &rec,
                               const AFS_TI_SymbolCache &cache,
                               const datetime now,
                               const bool include_m1,
                               const bool include_m5,
                               const bool include_m15,
                               const bool include_h1,
                               const bool comma_after)
  {
   double current_m1_open = 0.0;
   double current_m1_high = 0.0;
   double current_m1_low  = 0.0;
   double current_bid     = rec.Bid;
   double current_ask     = rec.Ask;
   double current_spread  = rec.SpreadSnapshot;
   double mean_spread_20  = 0.0;
   double max_spread_20   = 0.0;
   double micro_range_20  = 0.0;
   double dist_high       = 0.0;
   double dist_low        = 0.0;

   double atr_m1_14 = 0.0;
   double atr_m1_28 = 0.0;
   double atr_m1_60 = 0.0;
   double atr_m5_14 = 0.0;
   double atr_m15_14 = rec.AtrM15;
   double atr_h1_14 = rec.AtrH1;
   double atr_h4_14 = 0.0;
   double atr_d1_14 = 0.0;

   bool atr_m1_14_ok = AFS_TI_CalcATRFromCache(cache.M1, 14, atr_m1_14);
   bool atr_m1_28_ok = AFS_TI_CalcATRFromCache(cache.M1, 28, atr_m1_28);
   bool atr_m1_60_ok = AFS_TI_CalcATRFromCache(cache.M1, 60, atr_m1_60);
   bool atr_m5_14_ok = AFS_TI_CalcATRFromCache(cache.M5, 14, atr_m5_14);
   bool atr_m15_14_ok = (atr_m15_14 > 0.0) || AFS_TI_CalcATRFromCache(cache.M15, 14, atr_m15_14);
   bool atr_h1_14_ok = (atr_h1_14 > 0.0) || AFS_TI_CalcATRFromCache(cache.H1, 14, atr_h1_14);
   bool atr_h4_14_ok = AFS_TI_CalcATRFromRates(rec.Symbol, PERIOD_H4, 14, atr_h4_14);
   bool atr_d1_14_ok = AFS_TI_CalcATRFromRates(rec.Symbol, PERIOD_D1, 14, atr_d1_14);

   double move_m1 = AFS_TI_MoveFromCache(cache.M1);
   double move_m5 = AFS_TI_MoveFromCache(cache.M5);
   double move_m15 = AFS_TI_MoveFromCache(cache.M15);
   double move_h1 = AFS_TI_MoveFromCache(cache.H1);

   double today_range = MathAbs(rec.SessionHigh - rec.SessionLow);
   double adr5 = AFS_TI_RangeFromRates(rec.Symbol, PERIOD_D1, 5);
   double adr20 = AFS_TI_RangeFromRates(rec.Symbol, PERIOD_D1, 20);
   double range_used_percent = 0.0;
   if(adr20 > 0.0)
      range_used_percent = (today_range / adr20) * 100.0;

   double spread_points = (rec.Point > 0.0 ? rec.SpreadSnapshot / rec.Point : 0.0);
   double spread_money = 0.0;
   if(rec.TickSize > 0.0 && rec.TickValue > 0.0)
      spread_money = (rec.SpreadSnapshot / rec.TickSize) * rec.TickValue;

   double spread_to_atr_m1 = (atr_m1_14 > 0.0 ? rec.SpreadSnapshot / atr_m1_14 : 0.0);
   double spread_to_atr_m5 = (atr_m5_14 > 0.0 ? rec.SpreadSnapshot / atr_m5_14 : 0.0);
   double spread_to_atr_m15 = (atr_m15_14 > 0.0 ? rec.SpreadSnapshot / atr_m15_14 : 0.0);
   double spread_to_atr_h1 = (atr_h1_14 > 0.0 ? rec.SpreadSnapshot / atr_h1_14 : 0.0);
   double cost_per_atr = (atr_m1_14 > 0.0 ? spread_money / atr_m1_14 : 0.0);

   bool fresh = (rec.TickAgeSec >= 0 && rec.TickAgeSec <= 30);
   bool live = rec.FrictionMarketLive;

   double account_balance = AccountInfoDouble(ACCOUNT_BALANCE);
   bool balance_ok = MathIsValidNumber(account_balance) && account_balance > 0.0;

   double suggested_stop_m1 = (atr_m1_14 > 0.0 ? atr_m1_14 * 1.5 : 0.0);
   double suggested_stop_m5 = (atr_m5_14 > 0.0 ? atr_m5_14 * 1.5 : 0.0);
   double suggested_stop_m15 = (atr_m15_14 > 0.0 ? atr_m15_14 * 1.5 : 0.0);

   double atr_stop_money = 0.0;
   if(suggested_stop_m1 > 0.0 && rec.TickSize > 0.0 && rec.TickValue > 0.0)
      atr_stop_money = (suggested_stop_m1 / rec.TickSize) * rec.TickValue;

   double lot_025 = 0.0;
   double lot_050 = 0.0;
   double lot_100 = 0.0;
   if(balance_ok)
     {
      lot_025 = AFS_TI_RiskLotByStop(account_balance * 0.0025, suggested_stop_m1, rec);
      lot_050 = AFS_TI_RiskLotByStop(account_balance * 0.0050, suggested_stop_m1, rec);
      lot_100 = AFS_TI_RiskLotByStop(account_balance * 0.0100, suggested_stop_m1, rec);
     }

   AFS_TI_CalcMicroContext(rec,
                           cache.M1,
                           current_m1_open,
                           current_m1_high,
                           current_m1_low,
                           current_bid,
                           current_ask,
                           current_spread,
                           mean_spread_20,
                           max_spread_20,
                           micro_range_20,
                           dist_high,
                           dist_low);

   AFS_TI_AddLine(lines, count, "    {");
   AFS_TI_AddField(lines, count, "      ", "RawSymbol", AFS_TI_JsonString(rec.Symbol));
   AFS_TI_AddField(lines, count, "      ", "CanonicalSymbol", AFS_TI_JsonString(rec.CanonicalSymbol));
   AFS_TI_AddField(lines, count, "      ", "DisplayName", AFS_TI_JsonString(rec.DisplayName));
   AFS_TI_AddField(lines, count, "      ", "AssetClass", AFS_TI_JsonString(rec.AssetClass));
   AFS_TI_AddField(lines, count, "      ", "PrimaryBucket", AFS_TI_JsonString(rec.PrimaryBucket));
   AFS_TI_AddField(lines, count, "      ", "Sector", AFS_TI_JsonString(rec.Sector));
   AFS_TI_AddField(lines, count, "      ", "Industry", AFS_TI_JsonString(rec.Industry));
   AFS_TI_AddField(lines, count, "      ", "ThemeBucket", AFS_TI_JsonString(rec.ThemeBucket));
   AFS_TI_AddField(lines, count, "      ", "SubType", AFS_TI_JsonString(rec.SubType));
   AFS_TI_AddField(lines, count, "      ", "AliasKind", AFS_TI_JsonString(rec.AliasKind));
   AFS_TI_AddField(lines, count, "      ", "ClassificationStatus", AFS_TI_JsonString(rec.ClassificationStatus));
   AFS_TI_AddField(lines, count, "      ", "ClassificationConfidence", AFS_TI_JsonString(rec.ClassificationConfidence));
   AFS_TI_AddField(lines, count, "      ", "ClassificationReviewStatus", AFS_TI_JsonString(rec.ClassificationReviewStatus));
   AFS_TI_AddField(lines, count, "      ", "ClassificationNotes", AFS_TI_JsonString(rec.ClassificationNotes));

   AFS_TI_AddField(lines, count, "      ", "Bid", AFS_TI_JsonDouble(rec.Bid, 8));
   AFS_TI_AddField(lines, count, "      ", "Ask", AFS_TI_JsonDouble(rec.Ask, 8));
   AFS_TI_AddField(lines, count, "      ", "SpreadSnapshot", AFS_TI_JsonDouble(rec.SpreadSnapshot, 8));
   AFS_TI_AddField(lines, count, "      ", "SessionOpen", AFS_TI_JsonDouble(rec.SessionOpen, 8));
   AFS_TI_AddField(lines, count, "      ", "SessionHigh", AFS_TI_JsonDouble(rec.SessionHigh, 8));
   AFS_TI_AddField(lines, count, "      ", "SessionLow", AFS_TI_JsonDouble(rec.SessionLow, 8));
   AFS_TI_AddField(lines, count, "      ", "SessionClose", AFS_TI_JsonDouble(rec.SessionClose, 8));
   AFS_TI_AddField(lines, count, "      ", "BidHigh", AFS_TI_JsonDouble(rec.BidHigh, 8));
   AFS_TI_AddField(lines, count, "      ", "BidLow", AFS_TI_JsonDouble(rec.BidLow, 8));
   AFS_TI_AddField(lines, count, "      ", "AskHigh", AFS_TI_JsonDouble(rec.AskHigh, 8));
   AFS_TI_AddField(lines, count, "      ", "AskLow", AFS_TI_JsonDouble(rec.AskLow, 8));
   AFS_TI_AddField(lines, count, "      ", "LastTickTime", AFS_TI_JsonInt(AFS_TI_TimeUnix(rec.LastTickTime)));
   AFS_TI_AddField(lines, count, "      ", "TickAgeSec", AFS_TI_JsonInt(rec.TickAgeSec));
   AFS_TI_AddField(lines, count, "      ", "DailyChangePercent", AFS_TI_JsonDouble(rec.DailyChangePercent, 6));
   AFS_TI_AddField(lines, count, "      ", "QuotePresent", AFS_TI_JsonBool(rec.QuotePresent));
   AFS_TI_AddField(lines, count, "      ", "QuoteState", AFS_TI_JsonString(rec.QuoteState));
   AFS_TI_AddField(lines, count, "      ", "SessionState", AFS_TI_JsonString(rec.SessionState));
   AFS_TI_AddField(lines, count, "      ", "SurfaceSeen", AFS_TI_JsonBool(rec.SurfaceSeen));
   AFS_TI_AddField(lines, count, "      ", "SurfaceUpdateCount", AFS_TI_JsonInt(rec.SurfaceUpdateCount));
   AFS_TI_AddField(lines, count, "      ", "LastSurfaceUpdateAt", AFS_TI_JsonInt(AFS_TI_TimeUnix(rec.LastSurfaceUpdateAt)));

   AFS_TI_AddField(lines, count, "      ", "Description", AFS_TI_JsonString(rec.Description));
   AFS_TI_AddField(lines, count, "      ", "ISIN", AFS_TI_JsonString(rec.ISIN));
   AFS_TI_AddField(lines, count, "      ", "Exchange", AFS_TI_JsonString(rec.Exchange));
   AFS_TI_AddField(lines, count, "      ", "CurrencyBase", AFS_TI_JsonString(rec.CurrencyBase));
   AFS_TI_AddField(lines, count, "      ", "CurrencyProfit", AFS_TI_JsonString(rec.CurrencyProfit));
   AFS_TI_AddField(lines, count, "      ", "CurrencyMargin", AFS_TI_JsonString(rec.CurrencyMargin));
   AFS_TI_AddField(lines, count, "      ", "BrokerSector", AFS_TI_JsonString(rec.BrokerSector));
   AFS_TI_AddField(lines, count, "      ", "BrokerIndustry", AFS_TI_JsonString(rec.BrokerIndustry));
   AFS_TI_AddField(lines, count, "      ", "BrokerClass", AFS_TI_JsonString(rec.BrokerClass));
   AFS_TI_AddField(lines, count, "      ", "SessionQuotes", AFS_TI_JsonString(rec.SessionQuotes));
   AFS_TI_AddField(lines, count, "      ", "SessionTrades", AFS_TI_JsonString(rec.SessionTrades));
   AFS_TI_AddField(lines, count, "      ", "Digits", AFS_TI_JsonInt(rec.Digits));
   AFS_TI_AddField(lines, count, "      ", "Spread", AFS_TI_JsonInt(rec.Spread));
   AFS_TI_AddField(lines, count, "      ", "StopsLevel", AFS_TI_JsonInt(rec.StopsLevel));
   AFS_TI_AddField(lines, count, "      ", "FreezeLevel", AFS_TI_JsonInt(rec.FreezeLevel));
   AFS_TI_AddField(lines, count, "      ", "TradeMode", AFS_TI_JsonInt(rec.TradeMode));
   AFS_TI_AddField(lines, count, "      ", "CalcMode", AFS_TI_JsonInt(rec.CalcMode));
   AFS_TI_AddField(lines, count, "      ", "ExecMode", AFS_TI_JsonInt(rec.ExecMode));
   AFS_TI_AddField(lines, count, "      ", "FillingMode", AFS_TI_JsonInt(rec.FillingMode));
   AFS_TI_AddField(lines, count, "      ", "ExpirationMode", AFS_TI_JsonInt(rec.ExpirationMode));
   AFS_TI_AddField(lines, count, "      ", "OrderMode", AFS_TI_JsonInt(rec.OrderMode));
   AFS_TI_AddField(lines, count, "      ", "SwapMode", AFS_TI_JsonInt(rec.SwapMode));
   AFS_TI_AddField(lines, count, "      ", "Point", AFS_TI_JsonDouble(rec.Point, 8));
   AFS_TI_AddField(lines, count, "      ", "TickSize", AFS_TI_JsonDouble(rec.TickSize, 8));
   AFS_TI_AddField(lines, count, "      ", "TickValue", AFS_TI_JsonDouble(rec.TickValue, 8));
   AFS_TI_AddField(lines, count, "      ", "TickValueProfit", AFS_TI_JsonDouble(rec.TickValueProfit, 8));
   AFS_TI_AddField(lines, count, "      ", "TickValueLoss", AFS_TI_JsonDouble(rec.TickValueLoss, 8));
   AFS_TI_AddField(lines, count, "      ", "ContractSize", AFS_TI_JsonDouble(rec.ContractSize, 8));
   AFS_TI_AddField(lines, count, "      ", "VolumeMin", AFS_TI_JsonDouble(rec.VolumeMin, 8));
   AFS_TI_AddField(lines, count, "      ", "VolumeStep", AFS_TI_JsonDouble(rec.VolumeStep, 8));
   AFS_TI_AddField(lines, count, "      ", "VolumeMax", AFS_TI_JsonDouble(rec.VolumeMax, 8));
   AFS_TI_AddField(lines, count, "      ", "VolumeLimit", AFS_TI_JsonDouble(rec.VolumeLimit, 8));
   AFS_TI_AddField(lines, count, "      ", "SwapLong", AFS_TI_JsonDouble(rec.SwapLong, 8));
   AFS_TI_AddField(lines, count, "      ", "SwapShort", AFS_TI_JsonDouble(rec.SwapShort, 8));
   AFS_TI_AddField(lines, count, "      ", "MarginInitial", AFS_TI_JsonDouble(rec.MarginInitial, 8));
   AFS_TI_AddField(lines, count, "      ", "MarginMaintenance", AFS_TI_JsonDouble(rec.MarginMaintenance, 8));
   AFS_TI_AddField(lines, count, "      ", "MarginLong", AFS_TI_JsonDouble(rec.MarginLong, 8));
   AFS_TI_AddField(lines, count, "      ", "MarginShort", AFS_TI_JsonDouble(rec.MarginShort, 8));
   AFS_TI_AddField(lines, count, "      ", "MarginHedged", AFS_TI_JsonDouble(rec.MarginHedged, 8));
   AFS_TI_AddField(lines, count, "      ", "SpreadFloat", AFS_TI_JsonBool(rec.SpreadFloat));
   AFS_TI_AddField(lines, count, "      ", "TradeAllowed", AFS_TI_JsonBool(rec.TradeAllowed));
   AFS_TI_AddField(lines, count, "      ", "Selected", AFS_TI_JsonBool(rec.Selected));
   AFS_TI_AddField(lines, count, "      ", "Visible", AFS_TI_JsonBool(rec.Visible));
   AFS_TI_AddField(lines, count, "      ", "Custom", AFS_TI_JsonBool(rec.Custom));

   AFS_TI_AddField(lines, count, "      ", "TickValueRaw", AFS_TI_JsonDouble(rec.TickValueRaw, 8));
   AFS_TI_AddField(lines, count, "      ", "TickValueDerived", AFS_TI_JsonDouble(rec.TickValueDerived, 8));
   AFS_TI_AddField(lines, count, "      ", "TickValueValidated", AFS_TI_JsonDouble(rec.TickValueValidated, 8));
   AFS_TI_AddField(lines, count, "      ", "CommissionValue", AFS_TI_JsonDouble(rec.CommissionValue, 8));
   AFS_TI_AddField(lines, count, "      ", "CommissionMode", AFS_TI_JsonString(rec.CommissionMode));
   AFS_TI_AddField(lines, count, "      ", "CommissionCurrency", AFS_TI_JsonString(rec.CommissionCurrency));
   AFS_TI_AddField(lines, count, "      ", "CommissionStatus", AFS_TI_JsonString(rec.CommissionStatus));
   AFS_TI_AddField(lines, count, "      ", "SpecIntegrityStatus", AFS_TI_JsonString(rec.SpecIntegrityStatus));
   AFS_TI_AddField(lines, count, "      ", "EconomicsTrust", AFS_TI_JsonString(rec.EconomicsTrust));
   AFS_TI_AddField(lines, count, "      ", "NormalizationStatus", AFS_TI_JsonString(rec.NormalizationStatus));
   AFS_TI_AddField(lines, count, "      ", "PracticalityStatus", AFS_TI_JsonString(rec.PracticalityStatus));
   AFS_TI_AddField(lines, count, "      ", "EconomicsFlags", AFS_TI_JsonString(rec.EconomicsFlags));
   AFS_TI_AddField(lines, count, "      ", "LastSpecUpdateAt", AFS_TI_JsonInt(AFS_TI_TimeUnix(rec.LastSpecUpdateAt)));
   AFS_TI_AddField(lines, count, "      ", "SpecUpdateCount", AFS_TI_JsonInt(rec.SpecUpdateCount));

   AFS_TI_AddField(lines, count, "      ", "BarsM15", AFS_TI_JsonInt(rec.BarsM15));
   AFS_TI_AddField(lines, count, "      ", "BarsH1", AFS_TI_JsonInt(rec.BarsH1));
   AFS_TI_AddField(lines, count, "      ", "AtrM15", AFS_TI_JsonDouble(rec.AtrM15, 8));
   AFS_TI_AddField(lines, count, "      ", "AtrH1", AFS_TI_JsonDouble(rec.AtrH1, 8));
   AFS_TI_AddField(lines, count, "      ", "BaselineMove", AFS_TI_JsonDouble(rec.BaselineMove, 8));
   AFS_TI_AddField(lines, count, "      ", "MovementCapacityScore", AFS_TI_JsonDouble(rec.MovementCapacityScore, 6));
   AFS_TI_AddField(lines, count, "      ", "HistoryStatus", AFS_TI_JsonString(rec.HistoryStatus));
   AFS_TI_AddField(lines, count, "      ", "HistoryFlags", AFS_TI_JsonString(rec.HistoryFlags));
   AFS_TI_AddField(lines, count, "      ", "LastHistoryUpdateAt", AFS_TI_JsonInt(AFS_TI_TimeUnix(rec.LastHistoryUpdateAt)));
   AFS_TI_AddField(lines, count, "      ", "HistoryUpdateCount", AFS_TI_JsonInt(rec.HistoryUpdateCount));

   AFS_TI_AddField(lines, count, "      ", "MedianSpread", AFS_TI_JsonDouble(rec.MedianSpread, 8));
   AFS_TI_AddField(lines, count, "      ", "MaxSpread", AFS_TI_JsonDouble(rec.MaxSpread, 8));
   AFS_TI_AddField(lines, count, "      ", "SpreadAtrRatio", AFS_TI_JsonDouble(rec.SpreadAtrRatio, 8));
   AFS_TI_AddField(lines, count, "      ", "LivelinessScore", AFS_TI_JsonDouble(rec.LivelinessScore, 6));
   AFS_TI_AddField(lines, count, "      ", "FreshnessScore", AFS_TI_JsonDouble(rec.FreshnessScore, 6));
   AFS_TI_AddField(lines, count, "      ", "FrictionStatus", AFS_TI_JsonString(rec.FrictionStatus));
   AFS_TI_AddField(lines, count, "      ", "FrictionFlags", AFS_TI_JsonString(rec.FrictionFlags));
   AFS_TI_AddField(lines, count, "      ", "FrictionTruthState", AFS_TI_JsonString(rec.FrictionTruthState));
   AFS_TI_AddField(lines, count, "      ", "FrictionFailReason", AFS_TI_JsonString(rec.FrictionFailReason));
   AFS_TI_AddField(lines, count, "      ", "FrictionWeakReason", AFS_TI_JsonString(rec.FrictionWeakReason));
   AFS_TI_AddField(lines, count, "      ", "FrictionHydrationStage", AFS_TI_JsonString(rec.FrictionHydrationStage));
   AFS_TI_AddField(lines, count, "      ", "FrictionHydrationScore", AFS_TI_JsonInt(rec.FrictionHydrationScore));
   AFS_TI_AddField(lines, count, "      ", "FrictionHoldPass", AFS_TI_JsonBool(rec.FrictionHoldPass));
   AFS_TI_AddField(lines, count, "      ", "FrictionMarketLive", AFS_TI_JsonBool(rec.FrictionMarketLive));
   AFS_TI_AddField(lines, count, "      ", "FrictionSessionOpen", AFS_TI_JsonBool(rec.FrictionSessionOpen));
   AFS_TI_AddField(lines, count, "      ", "FrictionQuoteUsable", AFS_TI_JsonBool(rec.FrictionQuoteUsable));
   AFS_TI_AddField(lines, count, "      ", "FrictionSampleCountUsed", AFS_TI_JsonInt(rec.FrictionSampleCountUsed));
   AFS_TI_AddField(lines, count, "      ", "FrictionGoodPasses", AFS_TI_JsonInt(rec.FrictionGoodPasses));
   AFS_TI_AddField(lines, count, "      ", "FrictionBadPasses", AFS_TI_JsonInt(rec.FrictionBadPasses));
   AFS_TI_AddField(lines, count, "      ", "LastFrictionUpdateAt", AFS_TI_JsonInt(AFS_TI_TimeUnix(rec.LastFrictionUpdateAt)));
   AFS_TI_AddField(lines, count, "      ", "FrictionUpdateCount", AFS_TI_JsonInt(rec.FrictionUpdateCount));
   AFS_TI_AddField(lines, count, "      ", "LastTradableEvidenceAt", AFS_TI_JsonInt(AFS_TI_TimeUnix(rec.LastTradableEvidenceAt)));
   AFS_TI_AddField(lines, count, "      ", "LastAliveEvidenceAt", AFS_TI_JsonInt(AFS_TI_TimeUnix(rec.LastAliveEvidenceAt)));

   AFS_TI_AddField(lines, count, "      ", "CostEfficiencyScore", AFS_TI_JsonDouble(rec.CostEfficiencyScore, 6));
   AFS_TI_AddField(lines, count, "      ", "TrustScore", AFS_TI_JsonDouble(rec.TrustScore, 6));
   AFS_TI_AddField(lines, count, "      ", "TotalScore", AFS_TI_JsonDouble(rec.TotalScore, 6));
   AFS_TI_AddField(lines, count, "      ", "BucketRank", AFS_TI_JsonInt(rec.BucketRank));
   AFS_TI_AddField(lines, count, "      ", "FinalistSelected", AFS_TI_JsonBool(rec.FinalistSelected));
   AFS_TI_AddField(lines, count, "      ", "LastRankingUpdateAt", AFS_TI_JsonInt(AFS_TI_TimeUnix(rec.LastRankingUpdateAt)));

   AFS_TI_AddField(lines, count, "      ", "CorrMax", AFS_TI_JsonDouble(rec.CorrMax, 6));
   AFS_TI_AddField(lines, count, "      ", "CorrClosestSymbol", AFS_TI_JsonString(rec.CorrClosestSymbol));
   AFS_TI_AddField(lines, count, "      ", "CorrContextFlag", AFS_TI_JsonString(rec.CorrContextFlag));

   AFS_TI_AddField(lines, count, "      ", "PromotionCandidate", AFS_TI_JsonBool(rec.PromotionCandidate));
   AFS_TI_AddField(lines, count, "      ", "PromotionState", AFS_TI_JsonString(rec.PromotionState));
   AFS_TI_AddField(lines, count, "      ", "PromotionReason", AFS_TI_JsonString(rec.PromotionReason));
   AFS_TI_AddField(lines, count, "      ", "SurfaceFlags", AFS_TI_JsonString(rec.SurfaceFlags));

   AFS_TI_AddField(lines, count, "      ", "SurfaceAgeSec", AFS_TI_JsonInt(AFS_TI_AgeSec(now, rec.LastSurfaceUpdateAt)));
   AFS_TI_AddField(lines, count, "      ", "SpecAgeSec", AFS_TI_JsonInt(AFS_TI_AgeSec(now, rec.LastSpecUpdateAt)));
   AFS_TI_AddField(lines, count, "      ", "HistoryAgeSec", AFS_TI_JsonInt(AFS_TI_AgeSec(now, rec.LastHistoryUpdateAt)));
   AFS_TI_AddField(lines, count, "      ", "FrictionAgeSec", AFS_TI_JsonInt(AFS_TI_AgeSec(now, rec.LastFrictionUpdateAt)));

   AFS_TI_AppendOhlcArray(lines, count, "      ", "OHLC_M1", cache.M1, include_m1, true);
   AFS_TI_AppendOhlcArray(lines, count, "      ", "OHLC_M5", cache.M5, include_m5, true);
   AFS_TI_AppendOhlcArray(lines, count, "      ", "OHLC_M15", cache.M15, include_m15, true);
   AFS_TI_AppendOhlcArray(lines, count, "      ", "OHLC_H1", cache.H1, include_h1, true);

   AFS_TI_AddField(lines, count, "      ", "CurrentM1Open", AFS_TI_JsonDouble(current_m1_open, 8));
   AFS_TI_AddField(lines, count, "      ", "CurrentM1High", AFS_TI_JsonDouble(current_m1_high, 8));
   AFS_TI_AddField(lines, count, "      ", "CurrentM1Low", AFS_TI_JsonDouble(current_m1_low, 8));
   AFS_TI_AddField(lines, count, "      ", "CurrentBid", AFS_TI_JsonDouble(current_bid, 8));
   AFS_TI_AddField(lines, count, "      ", "CurrentAsk", AFS_TI_JsonDouble(current_ask, 8));
   AFS_TI_AddField(lines, count, "      ", "CurrentSpread", AFS_TI_JsonDouble(current_spread, 8));
   AFS_TI_AddField(lines, count, "      ", "MeanSpreadLast20M1", AFS_TI_JsonDouble(mean_spread_20, 8));
   AFS_TI_AddField(lines, count, "      ", "MaxSpreadLast20M1", AFS_TI_JsonDouble(max_spread_20, 8));
   AFS_TI_AddField(lines, count, "      ", "MicroRangeLast20M1", AFS_TI_JsonDouble(micro_range_20, 8));
   AFS_TI_AddField(lines, count, "      ", "DistanceFromRecentM1High", AFS_TI_JsonDouble(dist_high, 8));

   AFS_TI_AddField(lines, count, "      ", "Status", AFS_TI_JsonString(rec.FrictionStatus));
   AFS_TI_AddField(lines, count, "      ", "Role", AFS_TI_JsonString(rec.PromotionState));
   AFS_TI_AddField(lines, count, "      ", "Score", AFS_TI_JsonDouble(rec.TotalScore, 6));
   AFS_TI_AddField(lines, count, "      ", "Reason", AFS_TI_JsonString(rec.FrictionWeakReason));
   AFS_TI_AddField(lines, count, "      ", "DegradedFlags", AFS_TI_JsonString(rec.FrictionFlags));

   AFS_TI_AddField(lines, count, "      ", "CommissionPerLot", AFS_TI_JsonNullableDouble((rec.CommissionValue > 0.0 ? rec.CommissionValue : MathSqrt(-1.0)), 8));
   AFS_TI_AddField(lines, count, "      ", "SpreadNow", AFS_TI_JsonDouble(rec.SpreadSnapshot, 8));
   AFS_TI_AddField(lines, count, "      ", "SpreadMoney", AFS_TI_JsonDouble(spread_money, 8));
   AFS_TI_AddField(lines, count, "      ", "SpreadPoints", AFS_TI_JsonDouble(spread_points, 4));
   AFS_TI_AddField(lines, count, "      ", "SpreadToATR_M1", AFS_TI_JsonDouble(spread_to_atr_m1, 8));
   AFS_TI_AddField(lines, count, "      ", "SpreadToATR_M5", AFS_TI_JsonDouble(spread_to_atr_m5, 8));
   AFS_TI_AddField(lines, count, "      ", "SpreadToATR_M15", AFS_TI_JsonDouble(spread_to_atr_m15, 8));
   AFS_TI_AddField(lines, count, "      ", "SpreadToATR_H1", AFS_TI_JsonDouble(spread_to_atr_h1, 8));
   AFS_TI_AddField(lines, count, "      ", "CostPerATR", AFS_TI_JsonDouble(cost_per_atr, 8));
   AFS_TI_AddField(lines, count, "      ", "QuoteStatus", AFS_TI_JsonString(rec.QuoteState));
   AFS_TI_AddField(lines, count, "      ", "TickAge", AFS_TI_JsonInt(rec.TickAgeSec));
   AFS_TI_AddField(lines, count, "      ", "Fresh", AFS_TI_JsonBool(fresh));
   AFS_TI_AddField(lines, count, "      ", "Live", AFS_TI_JsonBool(live));

   AFS_TI_AddField(lines, count, "      ", "ATR_M1_14", AFS_TI_JsonNullableDouble((atr_m1_14_ok ? atr_m1_14 : MathSqrt(-1.0)), 8));
   AFS_TI_AddField(lines, count, "      ", "ATR_M1_28", AFS_TI_JsonNullableDouble((atr_m1_28_ok ? atr_m1_28 : MathSqrt(-1.0)), 8));
   AFS_TI_AddField(lines, count, "      ", "ATR_M1_60", AFS_TI_JsonNullableDouble((atr_m1_60_ok ? atr_m1_60 : MathSqrt(-1.0)), 8));
   AFS_TI_AddField(lines, count, "      ", "ATR_M5_14", AFS_TI_JsonNullableDouble((atr_m5_14_ok ? atr_m5_14 : MathSqrt(-1.0)), 8));
   AFS_TI_AddField(lines, count, "      ", "ATR_M15_14", AFS_TI_JsonNullableDouble((atr_m15_14_ok ? atr_m15_14 : MathSqrt(-1.0)), 8));
   AFS_TI_AddField(lines, count, "      ", "ATR_H1_14", AFS_TI_JsonNullableDouble((atr_h1_14_ok ? atr_h1_14 : MathSqrt(-1.0)), 8));
   AFS_TI_AddField(lines, count, "      ", "ATR_H4_14", AFS_TI_JsonNullableDouble((atr_h4_14_ok ? atr_h4_14 : MathSqrt(-1.0)), 8));
   AFS_TI_AddField(lines, count, "      ", "ATR_D1_14", AFS_TI_JsonNullableDouble((atr_d1_14_ok ? atr_d1_14 : MathSqrt(-1.0)), 8));

   AFS_TI_AddField(lines, count, "      ", "MoveM1", AFS_TI_JsonDouble(move_m1, 8));
   AFS_TI_AddField(lines, count, "      ", "MoveM5", AFS_TI_JsonDouble(move_m5, 8));
   AFS_TI_AddField(lines, count, "      ", "MoveM15", AFS_TI_JsonDouble(move_m15, 8));
   AFS_TI_AddField(lines, count, "      ", "MoveH1", AFS_TI_JsonDouble(move_h1, 8));
   AFS_TI_AddField(lines, count, "      ", "TodayRange", AFS_TI_JsonDouble(today_range, 8));
   AFS_TI_AddField(lines, count, "      ", "ADR5", AFS_TI_JsonDouble(adr5, 8));
   AFS_TI_AddField(lines, count, "      ", "ADR20", AFS_TI_JsonDouble(adr20, 8));
   AFS_TI_AddField(lines, count, "      ", "RangeUsedPercent", AFS_TI_JsonDouble(range_used_percent, 4));

   AFS_TI_AddField(lines, count, "      ", "Session", AFS_TI_JsonString(rec.SessionState));
   AFS_TI_AddField(lines, count, "      ", "SessionType", AFS_TI_JsonNullableDouble(MathSqrt(-1.0)));
   AFS_TI_AddField(lines, count, "      ", "MinutesToSessionClose", AFS_TI_JsonNullableDouble(MathSqrt(-1.0)));
   AFS_TI_AddField(lines, count, "      ", "TicksPerMinute", AFS_TI_JsonNullableDouble(MathSqrt(-1.0)));
   AFS_TI_AddField(lines, count, "      ", "SpreadStability", AFS_TI_JsonDouble((rec.MaxSpread > 0.0 ? rec.MedianSpread / rec.MaxSpread : 0.0), 6));

   AFS_TI_AddField(lines, count, "      ", "PipValue", AFS_TI_JsonNullableDouble(((rec.TickValue > 0.0 && rec.TickSize > 0.0 && rec.Point > 0.0) ? rec.TickValue * (rec.Point / rec.TickSize) : MathSqrt(-1.0)), 8));
   AFS_TI_AddField(lines, count, "      ", "SuggestedATRStop_M1", AFS_TI_JsonDouble(suggested_stop_m1, 8));
   AFS_TI_AddField(lines, count, "      ", "SuggestedATRStop_M5", AFS_TI_JsonDouble(suggested_stop_m5, 8));
   AFS_TI_AddField(lines, count, "      ", "SuggestedATRStop_M15", AFS_TI_JsonDouble(suggested_stop_m15, 8));
   AFS_TI_AddField(lines, count, "      ", "ATRStopMoney", AFS_TI_JsonDouble(atr_stop_money, 8));
   AFS_TI_AddField(lines, count, "      ", "AccountBalance", AFS_TI_JsonNullableDouble((balance_ok ? account_balance : MathSqrt(-1.0)), 2));
   AFS_TI_AddField(lines, count, "      ", "LotSize_0_25pctRisk", AFS_TI_JsonNullableDouble((lot_025 > 0.0 ? lot_025 : MathSqrt(-1.0)), 4));
   AFS_TI_AddField(lines, count, "      ", "LotSize_0_50pctRisk", AFS_TI_JsonNullableDouble((lot_050 > 0.0 ? lot_050 : MathSqrt(-1.0)), 4));
   AFS_TI_AddField(lines, count, "      ", "LotSize_1_00pctRisk", AFS_TI_JsonNullableDouble((lot_100 > 0.0 ? lot_100 : MathSqrt(-1.0)), 4));

   AFS_TI_AddField(lines, count, "      ", "Corr", AFS_TI_JsonDouble(rec.CorrMax, 6));
   AFS_TI_AddField(lines, count, "      ", "CorrPeer", AFS_TI_JsonString(rec.CorrClosestSymbol));
   AFS_TI_AddField(lines, count, "      ", "CorrFlag", AFS_TI_JsonString(rec.CorrContextFlag));
   AFS_TI_AddField(lines, count, "      ", "CorrClusterSize", AFS_TI_JsonNullableDouble(MathSqrt(-1.0)));

   AFS_TI_AddField(lines, count, "      ", "DistanceFromRecentM1Low", AFS_TI_JsonDouble(dist_low, 8), false);

   string closer = "    }";
   if(comma_after)
      closer += ",";
   AFS_TI_AddLine(lines, count, closer);
  }

bool AFS_TI_RecordNeedsCarryForward(const AFS_UniverseSymbol &rec)
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

bool AFS_TI_FindJsonObjectBounds(const string text,
                                 const int anchor_pos,
                                 int &obj_start,
                                 int &obj_end)
  {
   obj_start = -1;
   obj_end   = -1;

   bool in_string = false;
   bool escape    = false;
   int depth      = 0;

   for(int i = anchor_pos; i >= 0; i--)
     {
      int ch = StringGetCharacter(text, i);

      if(in_string)
        {
         if(escape)
            escape = false;
         else if(ch == '\\')
            escape = true;
         else if(ch == '"')
            in_string = false;
         continue;
        }

      if(ch == '"')
        {
         in_string = true;
         escape = false;
         continue;
        }

      if(ch == '}')
         depth++;
      else if(ch == '{')
        {
         if(depth == 0)
           {
            obj_start = i;
            break;
           }
         depth--;
        }
     }

   if(obj_start < 0)
      return false;

   in_string = false;
   escape    = false;
   depth     = 0;

   for(int i = obj_start; i < StringLen(text); i++)
     {
      int ch = StringGetCharacter(text, i);

      if(in_string)
        {
         if(escape)
            escape = false;
         else if(ch == '\\')
            escape = true;
         else if(ch == '"')
            in_string = false;
         continue;
        }

      if(ch == '"')
        {
         in_string = true;
         escape = false;
         continue;
        }

      if(ch == '{')
         depth++;
      else if(ch == '}')
        {
         depth--;
         if(depth == 0)
           {
            obj_end = i;
            return true;
           }
        }
     }

   return false;
  }

bool AFS_TI_ExtractSymbolObjectBlock(const string prior_text,
                                     const string raw_symbol,
                                     string &block)
  {
   block = "";
   if(StringLen(prior_text) <= 0 || StringLen(raw_symbol) <= 0)
      return false;

   string token = "\"RawSymbol\": " + AFS_TI_JsonString(raw_symbol);
   int pos = StringFind(prior_text, token, 0);
   if(pos < 0)
      return false;

   int obj_start = -1;
   int obj_end   = -1;
   if(!AFS_TI_FindJsonObjectBounds(prior_text, pos, obj_start, obj_end))
      return false;

   if(obj_end < obj_start)
      return false;

   block = StringSubstr(prior_text, obj_start, obj_end - obj_start + 1);
   return (StringLen(block) > 0);
  }

void AFS_TI_AppendBlockText(string &lines[],
                            int &count,
                            const string block,
                            const bool comma_after)
  {
   if(StringLen(block) <= 0)
      return;

   string parts[];
   int n = StringSplit(block, '\n', parts);
   if(n <= 0)
      return;

   for(int i = 0; i < n; i++)
     {
      string line = parts[i];
      while(StringLen(line) > 0)
        {
         int ch = StringGetCharacter(line, StringLen(line) - 1);
         if(ch == '\r' || ch == '\n')
            line = StringSubstr(line, 0, StringLen(line) - 1);
         else
            break;
        }

      if(i == n - 1)
        {
         while(StringLen(line) > 0 && StringGetCharacter(line, StringLen(line) - 1) == ',')
            line = StringSubstr(line, 0, StringLen(line) - 1);
         if(comma_after)
            line += ",";
        }

      AFS_TI_AddLine(lines, count, line);
     }
  }

void AFS_TI_BuildPayload(string &lines[],
                         int &count,
                         AFS_RuntimeState &state,
                         const int &ordered[],
                         const bool include_m1,
                         const bool include_m5,
                         const bool include_m15,
                         const bool include_h1,
                         const string schema_version,
                         const string phase_tag,
                         const string step_tag,
                         const datetime now,
                         const string prior_text)
  {
   ArrayResize(lines, 0);
   count = 0;

   AFS_TI_AddLine(lines, count, "{");
   AFS_TI_AddField(lines, count, "  ", "SystemName", AFS_TI_JsonString("Aegis Forge Scanner"));
   AFS_TI_AddField(lines, count, "  ", "BuildLabel", AFS_TI_JsonString(state.BuildStamp));
   AFS_TI_AddField(lines, count, "  ", "SchemaVersion", AFS_TI_JsonString(schema_version));
   AFS_TI_AddField(lines, count, "  ", "PayloadType", AFS_TI_JsonString("TRADER_DATA"));
   AFS_TI_AddField(lines, count, "  ", "PayloadFileExtension", AFS_TI_JsonString("txt"));
   AFS_TI_AddField(lines, count, "  ", "ServerName", AFS_TI_JsonString(state.ServerName));
   AFS_TI_AddField(lines, count, "  ", "ServerKey", AFS_TI_JsonString(state.PathState.ServerKey));
   AFS_TI_AddField(lines, count, "  ", "GeneratedAt", AFS_TI_JsonInt(AFS_TI_TimeUnix(now)));
   AFS_TI_AddField(lines, count, "  ", "PhaseTag", AFS_TI_JsonString(phase_tag));
   AFS_TI_AddField(lines, count, "  ", "StepTag", AFS_TI_JsonString(step_tag));
   AFS_TI_AddField(lines, count, "  ", "SymbolCount", AFS_TI_JsonInt(ArraySize(ordered)));
   AFS_TI_AddLine(lines, count, "  \"Symbols\": [");

   for(int i = 0; i < ArraySize(ordered); i++)
     {
      AFS_UniverseSymbol rec = state.Universe[ordered[i]];
      int cache_idx = AFS_TI_FindSymbolCacheIndex(state.TraderIntel, rec.Symbol);
      if(cache_idx < 0)
         continue;

      bool comma_after = (i < ArraySize(ordered) - 1);
      bool used_prior = false;

      if(AFS_TI_RecordNeedsCarryForward(rec))
        {
         string prior_block = "";
         if(AFS_TI_ExtractSymbolObjectBlock(prior_text, rec.Symbol, prior_block))
           {
            AFS_TI_AppendBlockText(lines, count, prior_block, comma_after);
            used_prior = true;
           }
        }

      if(used_prior)
         continue;

      AFS_TI_AppendSymbolObject(lines,
                                count,
                                rec,
                                state.TraderIntel.Caches[cache_idx],
                                now,
                                include_m1,
                                include_m5,
                                include_m15,
                                include_h1,
                                comma_after);
     }

   AFS_TI_AddLine(lines, count, "  ]");
   AFS_TI_AddLine(lines, count, "}");
  }


int AFS_TI_DossierCadenceSec()
  {
   return 1800;
  }

bool AFS_TI_RunExport(AFS_RuntimeState &state,
                      const bool enable_export,
                      const string schema_version,
                      const int max_symbols,
                      const bool include_m1,
                      const bool include_m5,
                      const bool include_m15,
                      const bool include_h1,
                      const string phase_tag,
                      const string step_tag,
                      string &err)
  {
   err = "";
   state.TraderIntel.Enabled = enable_export;
   state.TraderIntel.SchemaVersion = schema_version;

   if(!enable_export)
     {
      err = "TraderData export disabled by input.";
      return true;
     }

   if(!state.PathState.Ready)
     {
      err = "TraderData paths are not ready.";
      return false;
     }

   if(StringLen(state.PathState.TraderDataFolder) == 0)
      state.PathState.TraderDataFolder = state.PathState.RootFolder + "\\Trader-Data";
   if(StringLen(state.PathState.TraderDataFile) == 0)
      state.PathState.TraderDataFile = state.PathState.TraderDataFolder + "\\" + state.PathState.ServerKey + "_TRADER_DATA.txt";

   datetime now = state.ServerTime;
   if(now <= 0)
      now = TimeCurrent();

   int ordered[];
   AFS_TI_BuildOrderedFinalistIndexes(state.Universe, ArraySize(state.Universe), max_symbols, ordered);
   string shortlist_sig = AFS_TI_BuildShortlistSignature(state.Universe, ordered);
   bool shortlist_changed = (shortlist_sig != state.TraderIntel.LastShortlistSignature);

   bool cadence_due = true;
   if(state.TraderIntel.LastWriteAt > 0 && !shortlist_changed && !state.TraderIntel.ForceRefresh)
      cadence_due = ((now - state.TraderIntel.LastWriteAt) >= AFS_TI_DossierCadenceSec());

   if(!cadence_due)
      return true;

   for(int i = 0; i < ArraySize(ordered); i++)
     {
      AFS_UniverseSymbol rec = state.Universe[ordered[i]];
      int cache_idx = AFS_TI_EnsureSymbolCache(state.TraderIntel, rec.Symbol, rec.CanonicalSymbol);
      state.TraderIntel.Caches[cache_idx].LastTouchedAt = now;

      bool force_symbol_refresh = state.TraderIntel.ForceRefresh || shortlist_changed;

      string tf_err = "";
      if(include_m1 && !AFS_TI_RefreshCacheIfDue(rec.Symbol, state.TraderIntel.Caches[cache_idx].M1, now, force_symbol_refresh, tf_err) && StringLen(err) == 0)
         err = tf_err;
      if(include_m5 && !AFS_TI_RefreshCacheIfDue(rec.Symbol, state.TraderIntel.Caches[cache_idx].M5, now, force_symbol_refresh, tf_err) && StringLen(err) == 0)
         err = tf_err;
      if(include_m15 && !AFS_TI_RefreshCacheIfDue(rec.Symbol, state.TraderIntel.Caches[cache_idx].M15, now, force_symbol_refresh, tf_err) && StringLen(err) == 0)
         err = tf_err;
      if(include_h1 && !AFS_TI_RefreshCacheIfDue(rec.Symbol, state.TraderIntel.Caches[cache_idx].H1, now, force_symbol_refresh, tf_err) && StringLen(err) == 0)
         err = tf_err;
     }

   string existing_text = "";
   string existing_sig = "";
   if(AFS_TI_ReadAllText(state.PathState.TraderDataFile, state.PathState.UseCommonFiles, existing_text))
      existing_sig = AFS_TI_StableSignatureFromText(existing_text);

   string lines[];
   int line_count = 0;
   AFS_TI_BuildPayload(lines, line_count, state, ordered, include_m1, include_m5, include_m15, include_h1, schema_version, phase_tag, step_tag, now, existing_text);
   string payload_sig = AFS_TI_StableSignatureFromLines(lines, line_count);

   state.TraderIntel.LastShortlistSignature = shortlist_sig;

   if(existing_sig == payload_sig && payload_sig == state.TraderIntel.LastPayloadSignature && !state.TraderIntel.ForceRefresh)
     {
      state.TraderIntel.LastWriteAt = now;
      return true;
     }

   string write_err = "";
   if(!AFS_TI_WriteTextFile(state.PathState.TraderDataFile, state.PathState.UseCommonFiles, lines, line_count, write_err))
     {
      err = write_err;
      return false;
     }

   state.TraderIntel.LastPayloadSignature = payload_sig;
   state.TraderIntel.LastWriteAt = now;
   state.TraderIntel.ForceRefresh = false;
   return true;
  }

#endif
