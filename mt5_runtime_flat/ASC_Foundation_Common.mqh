#ifndef __ASC_FOUNDATION_COMMON_MQH__
#define __ASC_FOUNDATION_COMMON_MQH__

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
   bool              available_now;
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
      ushort ch=StringGetCharacter(value,start);
      if(ch!=' ' && ch!='\t' && ch!='\r' && ch!='\n')
         break;
      start++;
     }
   while(finish>=start)
     {
      ushort ch=StringGetCharacter(value,finish);
      if(ch!=' ' && ch!='\t' && ch!='\r' && ch!='\n')
         break;
      finish--;
     }
   if(finish<start)
      return("");
   return(StringSubstr(value,start,finish-start+1));
  }

string ASC_CompressSpaces(const string value)
  {
   string out="";
   bool last_space=false;
   for(int i=0;i<(int)StringLen(value);i++)
     {
      ushort ch=StringGetCharacter(value,i);
      bool is_space=(ch==' ' || ch=='\t' || ch=='_' || ch=='-' || ch=='/' || ch=='\\');
      if(is_space)
        {
         if(!last_space)
           {
            out+=" ";
            last_space=true;
           }
         continue;
        }
      out+=ShortToString((short)ch);
      last_space=false;
     }
   return(ASC_Trim(out));
  }

string ASC_TitleCaseWord(const string word)
  {
   if(word=="")
      return("");
   string lower=StringToLower(word);
   string out="";
   for(int i=0;i<(int)StringLen(lower);i++)
     {
      string ch=StringSubstr(lower,i,1);
      out+=(i==0 ? StringToUpper(ch) : ch);
     }
   return(out);
  }

string ASC_TitleCase(const string value)
  {
   string prepared=ASC_CompressSpaces(value);
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

string ASC_CleanServerName(const string server_raw)
  {
   string cleaned=ASC_TitleCase(server_raw);
   cleaned=StringReplace(cleaned,"Demo","Demo");
   return(cleaned);
  }

string ASC_SafeFilePart(const string value)
  {
   string out="";
   for(int i=0;i<(int)StringLen(value);i++)
     {
      ushort ch=StringGetCharacter(value,i);
      bool ok=((ch>='0' && ch<='9') || (ch>='A' && ch<='Z') || (ch>='a' && ch<='z'));
      if(ok)
        {
         out+=ShortToString((short)ch);
         continue;
        }
      if(ch==' ' || ch=='-' || ch=='_' || ch=='.')
         out+="-";
      else
         out+="_";
     }
   while(StringFind(out,"--")>=0)
      out=StringReplace(out,"--","-");
   out=ASC_Trim(out);
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

string ASC_DossierFileNameForSymbol(const string symbol)
  {
   string safe=ASC_SafeFilePart(symbol);
   return(safe + " [" + ASC_Hex8(ASC_StringHash(symbol)) + "].txt");
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

#endif
