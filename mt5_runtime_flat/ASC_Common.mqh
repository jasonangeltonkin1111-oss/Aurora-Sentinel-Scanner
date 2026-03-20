#ifndef __ASC_COMMON_MQH__
#define __ASC_COMMON_MQH__

enum ASC_RuntimeMode
  {
   ASC_RUNTIME_BOOT=0,
   ASC_RUNTIME_RECOVERING=1,
   ASC_RUNTIME_STEADY=2,
   ASC_RUNTIME_DEGRADED=3
  };

enum ASC_MarketStatus
  {
   ASC_MARKET_UNKNOWN=0,
   ASC_MARKET_OPEN=1,
   ASC_MARKET_CLOSED=2,
   ASC_MARKET_UNCERTAIN=3
  };

struct ASC_ServerPaths
  {
   string server_raw;
   string server_clean;
   string root_folder;
   string server_folder;
   string universe_folder;
   string dev_folder;
   string runtime_state_file;
   string scheduler_state_file;
   string summary_file;
   string log_file;
  };

struct ASC_RuntimeState
  {
   string          server_raw;
   string          server_clean;
   ASC_RuntimeMode mode;
   datetime        boot_at;
   datetime        last_heartbeat_at;
   datetime        last_universe_sync_at;
   datetime        last_runtime_save_at;
   datetime        last_scheduler_save_at;
   datetime        last_summary_save_at;
   bool            recovery_used;
   bool            degraded;
   int             symbol_count;
   int             processed_this_heartbeat;
  };

struct ASC_SymbolState
  {
   string            symbol;
   string            dossier_file;
   bool              has_tick;
   bool              has_trade_sessions;
   bool              within_trade_session;
   ASC_MarketStatus  market_status;
   datetime          last_tick_seen_at;
   long              tick_age_seconds;
   datetime          next_check_at;
   datetime          next_session_open_at;
   datetime          last_checked_at;
   datetime          last_dossier_write_at;
   int               uncertain_burst_count;
   string            status_note;
   bool              dirty;
  };

string ASC_RuntimeModeText(const ASC_RuntimeMode mode)
  {
   switch(mode)
     {
      case ASC_RUNTIME_BOOT:       return("Boot");
      case ASC_RUNTIME_RECOVERING: return("Recovering");
      case ASC_RUNTIME_STEADY:     return("Steady");
      case ASC_RUNTIME_DEGRADED:   return("Degraded");
     }
   return("Unknown");
  }

string ASC_MarketStatusText(const ASC_MarketStatus status)
  {
   switch(status)
     {
      case ASC_MARKET_OPEN:      return("Open");
      case ASC_MARKET_CLOSED:    return("Closed");
      case ASC_MARKET_UNCERTAIN: return("Uncertain");
     }
   return("Unknown");
  }

string ASC_Trim(const string value)
  {
   int start=0;
   int finish=(int)StringLen(value)-1;
   while(start<=finish)
     {
      string ch=StringSubstr(value,start,1);
      if(ch!=" " && ch!="\t" && ch!="\r" && ch!="\n")
         break;
      start++;
     }
   while(finish>=start)
     {
      string ch=StringSubstr(value,finish,1);
      if(ch!=" " && ch!="\t" && ch!="\r" && ch!="\n")
         break;
      finish--;
     }
   if(finish<start)
      return("");
   return(StringSubstr(value,start,finish-start+1));
  }

string ASC_CompressSeparators(const string value)
  {
   string out="";
   bool last_space=false;
   for(int i=0;i<(int)StringLen(value);i++)
     {
      string ch=StringSubstr(value,i,1);
      bool sep=(ch==" " || ch=="\t" || ch=="_" || ch=="-" || ch=="/" || ch=="\\" || ch=="|");
      if(sep)
        {
         if(!last_space)
           {
            out+=" ";
            last_space=true;
           }
        }
      else
        {
         out+=ch;
         last_space=false;
        }
     }
   return(ASC_Trim(out));
  }

string ASC_TitleCaseWord(const string word)
  {
   if(word=="")
      return("");

   string lower=word;
   if(!StringToLower(lower))
      return(word);

   string out=StringSubstr(lower,0,1);
   StringToUpper(out);

   if(StringLen(lower)>1)
      out+=StringSubstr(lower,1);

   return(out);
  }

string ASC_TitleCase(const string value)
  {
   string prepared=ASC_CompressSeparators(value);
   if(prepared=="")
      return("Unknown Server");

   string parts[];
   int count=StringSplit(prepared,' ',parts);
   string out="";
   for(int i=0;i<count;i++)
     {
      string piece=ASC_TitleCaseWord(parts[i]);
      if(piece=="")
         continue;
      if(out!="")
         out+=" ";
      out+=piece;
     }
   return(out=="" ? "Unknown Server" : out);
  }

string ASC_CleanServerName(const string raw)
  {
   return(ASC_TitleCase(raw));
  }

string ASC_SafeFilePart(const string value)
  {
   string out="";
   for(int i=0;i<(int)StringLen(value);i++)
     {
      string ch=StringSubstr(value,i,1);
      bool ok=((ch>="0" && ch<="9") || (ch>="A" && ch<="Z") || (ch>="a" && ch<="z"));
      if(ok)
         out+=ch;
      else if(ch==" " || ch=="-" || ch=="_" || ch==".")
         out+="-";
      else
         out+="_";
     }
   while(StringFind(out,"--")>=0)
      StringReplace(out,"--","-");
   if(out=="")
      out="item";
   return(out);
  }

uint ASC_StringHash(const string value)
  {
   uint hash=2166136261;
   for(int i=0;i<(int)StringLen(value);i++)
     {
      hash^=(uint)StringGetCharacter(value,i);
      hash*=16777619;
     }
   return(hash);
  }

string ASC_Hex8(const uint value)
  {
   return(StringFormat("%08X",value));
  }

string ASC_DossierFileName(const string symbol)
  {
   return(ASC_SafeFilePart(symbol) + " [" + ASC_Hex8(ASC_StringHash(symbol)) + "].txt");
  }

string ASC_JoinPath(const string left,const string right)
  {
   if(left=="")
      return(right);
   if(right=="")
      return(left);
   if(StringSubstr(left,StringLen(left)-1,1)=="\\")
      return(left + right);
   return(left + "\\" + right);
  }

string ASC_DateTimeText(const datetime value)
  {
   if(value<=0)
      return("Not Yet Available");
   return(TimeToString(value,TIME_DATE|TIME_SECONDS));
  }

string ASC_BoolText(const bool value)
  {
   return(value ? "Yes" : "No");
  }

int ASC_SecondsOfDay(const datetime value)
  {
   MqlDateTime dt;
   TimeToStruct(value,dt);
   return(dt.hour*3600 + dt.min*60 + dt.sec);
  }

string ASC_GetServerNowText(void)
  {
   datetime now=TimeTradeServer();
   if(now<=0)
      now=TimeCurrent();
   return(ASC_DateTimeText(now));
  }

#endif
