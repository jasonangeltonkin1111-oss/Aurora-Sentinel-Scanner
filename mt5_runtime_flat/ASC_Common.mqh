#ifndef __ASC_COMMON_MQH__
#define __ASC_COMMON_MQH__

#define ASC_PRODUCT_NAME "Aurora Sentinel Scanner"
#define ASC_WRAPPER_VERSION "1.122"
#define ASC_SCHEMA_FAMILY "ASC Foundation"
#define ASC_ACTIVE_CAPABILITY "Market State Detection"
#define ASC_NEXT_CAPABILITY "Open Symbol Snapshot"
#define ASC_RUNTIME_POSTURE "Foundation / Layer 1 Truth"
#define ASC_EXPLORER_SUBSYSTEM_VERSION "0.442"
#define ASC_DEBUG_PREP_SUMMARY_THRESHOLD_MS 25
#define ASC_DEBUG_RENDER_THRESHOLD_MS 16
#define ASC_DEBUG_PAGE_SWITCH_THRESHOLD_MS 32
#define ASC_DEBUG_DOMINANT_DELTA_MS 8
#define ASC_DEBUG_BACKLOG_ELEVATED_MULTIPLIER 2
#define ASC_DEBUG_BACKLOG_SEVERE_MULTIPLIER 4

enum ASC_RuntimeMode
  {
   ASC_RUNTIME_BOOT=0,
   ASC_RUNTIME_RECOVERING=1,
   ASC_RUNTIME_WARMUP=2,
   ASC_RUNTIME_STEADY=3,
   ASC_RUNTIME_DEGRADED=4
  };

enum ASC_MarketStatus
  {
   ASC_MARKET_UNKNOWN=0,
   ASC_MARKET_OPEN=1,
   ASC_MARKET_CLOSED=2,
   ASC_MARKET_UNCERTAIN=3
  };

enum ASC_LogVerbosity
  {
   ASC_LOG_ERRORS_ONLY=0,
   ASC_LOG_NORMAL=1,
   ASC_LOG_DEBUG=2
  };

enum ASC_ExplorerBucketDisplayMode
  {
   ASC_BUCKET_DISPLAY_TOP_3=0,
   ASC_BUCKET_DISPLAY_TOP_5=1,
   ASC_BUCKET_DISPLAY_ALL=2
  };

enum ASC_ExplorerMarketFilter
  {
   ASC_EXPLORER_FILTER_ALL_SYMBOLS=0,
   ASC_EXPLORER_FILTER_OPEN_ONLY=1
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

struct ASC_RuntimeSettings
  {
   bool              explorer_enabled;
   int               explorer_refresh_seconds;
   int               explorer_scroll_step_rows;
   int               explorer_density_mode;
   bool              explorer_show_breadcrumbs;
   int               heartbeat_seconds;
   int               universe_sync_seconds;
   int               symbol_budget_per_heartbeat;
   int               runtime_save_seconds;
   int               scheduler_save_seconds;
   int               summary_save_seconds;
   int               warmup_minimum_universe_percent;
   int               fresh_tick_seconds;
   int               open_recheck_seconds;
   int               uncertain_burst_limit;
   int               uncertain_fast_recheck_seconds;
   int               uncertain_slow_recheck_seconds;
   int               closed_near_open_seconds;
   int               closed_near_open_recheck_seconds;
   int               closed_soon_window_seconds;
   int               closed_soon_recheck_seconds;
   int               closed_idle_recheck_seconds;
   int               unknown_recheck_seconds;
   bool              write_dossiers_when_due;
   bool              repair_missing_dossiers_on_boot;
   bool              include_reserved_capability_placeholders;
   ASC_LogVerbosity  log_verbosity;
   bool              log_scheduler_decisions;
   bool              log_recovery_events;
   bool              log_dossier_repairs;
   bool              open_symbol_snapshot_reserved;
   bool              candidate_filtering_reserved;
   bool              shortlist_selection_reserved;
   bool              deep_selective_analysis_reserved;
   int               reserved_atr_refresh_seconds;
   bool              snapshot_controls_reserved;
   bool              timeframe_history_reserved;
   bool              deep_analysis_controls_reserved;
   bool              selection_controls_reserved;
   int               reserved_m1_bars;
   int               reserved_m5_bars;
   int               reserved_m15_bars;
   int               reserved_h1_bars;
   int               reserved_h4_bars;
   int               reserved_d1_bars;
   int               reserved_selected_symbol_limit;
  };

struct ASC_PreparedStateDiagnostics
  {
   long   bucket_prep_total_ms;
   long   classification_loop_ms;
   long   bucket_sort_ms;
   long   prepared_symbol_reorder_ms;
   long   final_promotion_ms;
   long   heartbeat_dispatch_ms;
   long   hud_render_ms;
   long   page_switch_action_to_render_ms;
   int    last_prepared_batch_id;
   int    promoted_batch_count;
   int    pending_batch_count;
   int    warmup_assessed_count;
   int    warmup_total_count;
   int    readiness_percent;
   string bounded_work_pressure_summary;
   string active_hydration_priority_set;
  };

struct ASC_RuntimeDiagnosticsState
  {
   long     last_bucket_prep_total_ms;
   long     last_classification_loop_ms;
   long     last_bucket_sort_ms;
   long     last_prepared_symbol_reorder_ms;
   long     last_final_promotion_ms;
   long     last_heartbeat_dispatch_ms;
   long     last_hud_render_ms;
   long     last_page_switch_action_to_render_ms;
   int      warmup_progress_percent;
   string   bounded_work_pressure_summary;
   int      last_promoted_prepared_batch_id;
   string   active_hydration_priority_set;
   datetime last_hud_render_at;
  };

struct ASC_RuntimeState
  {
   string          schema_version;
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
   bool            runtime_dirty;
   bool            scheduler_dirty;
   bool            summary_dirty;
   int             symbol_count;
   int             processed_this_heartbeat;
   int             scheduler_cursor;
   int             heartbeats_since_boot;
   int             total_symbols_discovered;
   int             initial_symbols_assessed;
   int             primary_bucket_symbols_assessed;
   int             primary_bucket_symbol_count;
   bool            compressed_primary_buckets_ready;
   bool            warmup_minimum_met;
   int             warmup_progress_percent;
   bool            background_hydration_active;
   int             readiness_percent;
   int                         prepared_last_batch_id;
   int                         prepared_promoted_batch_count;
   int                         prepared_pending_batch_count;
   string                      prepared_bounded_work_summary;
   ASC_RuntimeDiagnosticsState diagnostics;
  };

struct ASC_SymbolState
  {
   bool              is_due_now;
   bool              publication_ok;
   string            next_check_reason;
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

string ASC_Trim(const string value)
  {
   int start=0;
   int finish=(int)StringLen(value)-1;
   while(start<=finish)
     {
      ushort ch=(ushort)StringGetCharacter(value,start);
      if(ch!=' ' && ch!='\t' && ch!='\r' && ch!='\n')
         break;
      start++;
     }
   while(finish>=start)
     {
      ushort ch=(ushort)StringGetCharacter(value,finish);
      if(ch!=' ' && ch!='\t' && ch!='\r' && ch!='\n')
         break;
      finish--;
     }
   if(finish<start)
      return("");
   return(StringSubstr(value,start,finish-start+1));
  }

string ASC_ToLower(const string value)
  {
   string out=value;
   StringToLower(out);
   return(out);
  }

string ASC_ToUpperFirst(const string value)
  {
   if(value=="")
      return("");
   string first=StringSubstr(value,0,1);
   StringToUpper(first);
   if(StringLen(value)==1)
      return(first);
   return(first + StringSubstr(value,1));
  }

string ASC_RuntimeModeText(const ASC_RuntimeMode mode)
  {
   switch(mode)
     {
      case ASC_RUNTIME_BOOT:       return("Boot");
      case ASC_RUNTIME_RECOVERING: return("Recovering");
      case ASC_RUNTIME_WARMUP:     return("Warmup");
      case ASC_RUNTIME_STEADY:     return("Steady");
      case ASC_RUNTIME_DEGRADED:   return("Degraded");
     }
   return("Unknown");
  }

ASC_RuntimeMode ASC_RuntimeModeFromText(const string text)
  {
   string value=ASC_ToLower(ASC_Trim(text));
   if(value=="boot")
      return(ASC_RUNTIME_BOOT);
   if(value=="recovering")
      return(ASC_RUNTIME_RECOVERING);
   if(value=="warmup")
      return(ASC_RUNTIME_WARMUP);
   if(value=="steady")
      return(ASC_RUNTIME_STEADY);
   if(value=="degraded")
      return(ASC_RUNTIME_DEGRADED);
   return(ASC_RUNTIME_BOOT);
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

ASC_MarketStatus ASC_MarketStatusFromText(const string text)
  {
   string value=ASC_ToLower(ASC_Trim(text));
   if(value=="open")
      return(ASC_MARKET_OPEN);
   if(value=="closed")
      return(ASC_MARKET_CLOSED);
   if(value=="uncertain")
      return(ASC_MARKET_UNCERTAIN);
   return(ASC_MARKET_UNKNOWN);
  }

string ASC_LogVerbosityText(const ASC_LogVerbosity value)
  {
   switch(value)
     {
      case ASC_LOG_ERRORS_ONLY: return("Errors Only");
      case ASC_LOG_DEBUG:       return("Debug");
     }
   return("Normal");
  }

string ASC_CompressSeparators(const string value)
  {
   string out="";
   bool last_space=false;
   for(int i=0;i<(int)StringLen(value);i++)
     {
      ushort ch=(ushort)StringGetCharacter(value,i);
      bool sep=(ch==' ' || ch=='\t' || ch=='_' || ch=='-' || ch=='/' || ch=='\\' || ch=='|');
      if(sep)
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
   string lower=ASC_ToLower(word);
   return(ASC_ToUpperFirst(lower));
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



int ASC_PercentClamp(const int value)
  {
   if(value<0)
      return(0);
   if(value>100)
      return(100);
   return(value);
  }

int ASC_PercentOfCountCeil(const int count,const int percent)
  {
   if(count<=0)
      return(0);
   int safe_percent=ASC_PercentClamp(percent);
   if(safe_percent<=0)
      return(1);
   return((count*safe_percent + 99)/100);
  }

bool ASC_IsAlphaNumChar(const ushort ch)
  {
   return((ch>='0' && ch<='9') || (ch>='A' && ch<='Z') || (ch>='a' && ch<='z'));
  }

string ASC_StripKnownSymbolAffixes(const string raw)
  {
   string work=ASC_Trim(raw);
   if(work=="")
      return("");

   string lower=ASC_ToLower(work);
   if(StringLen(lower)>=3 && StringSubstr(lower,StringLen(lower)-3)==".oq")
      work=StringSubstr(work,0,StringLen(work)-3);
   else if(StringLen(lower)>=5 && StringSubstr(lower,StringLen(lower)-5)==".xhkg")
      work=StringSubstr(work,0,StringLen(work)-5);
   else if(StringLen(lower)>=3 && StringSubstr(lower,StringLen(lower)-3)==".nx")
      work=StringSubstr(work,0,StringLen(work)-3);
   else if(StringLen(lower)>=2)
     {
      string tail2=StringSubstr(lower,StringLen(lower)-2);
      if(tail2==".m" || tail2==".c" || tail2==".o")
         work=StringSubstr(work,0,StringLen(work)-2);
     }

   lower=ASC_ToLower(work);
   if(StringLen(lower)>=4 && StringSubstr(lower,StringLen(lower)-4)=="cash")
      work=StringSubstr(work,0,StringLen(work)-4);
   else if(StringLen(lower)>=6 && StringSubstr(lower,StringLen(lower)-6)=="cash-1")
      work=StringSubstr(work,0,StringLen(work)-6);

   while(StringLen(work)>0)
     {
      ushort ch=(ushort)StringGetCharacter(work,StringLen(work)-1);
      if(ch=='-' || ch=='_' || ch=='.')
         work=StringSubstr(work,0,StringLen(work)-1);
      else
         break;
     }
   return(work);
  }

string ASC_NormalizeSymbolForMatch(const string raw)
  {
   string work=ASC_StripKnownSymbolAffixes(raw);
   StringToUpper(work);
   string out="";
   for(int i=0;i<(int)StringLen(work);i++)
     {
      ushort ch=(ushort)StringGetCharacter(work,i);
      if(ASC_IsAlphaNumChar(ch))
         out+=ShortToString((short)ch);
     }
   return(out);
  }

bool ASC_SymbolsMatchCanonical(const string left,const string right)
  {
   string left_norm=ASC_NormalizeSymbolForMatch(left);
   string right_norm=ASC_NormalizeSymbolForMatch(right);
   if(left_norm=="" || right_norm=="")
      return(false);
   return(left_norm==right_norm);
  }

string ASC_SafeFilePart(const string value)
  {
   string out="";
   for(int i=0;i<(int)StringLen(value);i++)
     {
      ushort ch=(ushort)StringGetCharacter(value,i);
      bool ok=((ch>='0' && ch<='9') || (ch>='A' && ch<='Z') || (ch>='a' && ch<='z'));
      if(ok)
         out+=ShortToString((short)ch);
      else if(ch==' ' || ch=='-' || ch=='_' || ch=='.')
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

bool ASC_TryParseDateTime(const string text,datetime &value)
  {
   value=0;
   string trimmed=ASC_Trim(text);
   if(trimmed=="" || trimmed=="Not Yet Available" || trimmed=="Pending")
      return(false);
   value=StringToTime(trimmed);
   return(value>0);
  }

string ASC_BoolText(const bool value)
  {
   return(value ? "Yes" : "No");
  }

bool ASC_BoolFromText(const string text)
  {
   string value=ASC_ToLower(ASC_Trim(text));
   return(value=="yes" || value=="true" || value=="1");
  }

int ASC_IntegerFromText(const string text)
  {
   return((int)StringToInteger(ASC_Trim(text)));
  }

string ASC_ExplorerDensityText(const int value)
  {
   if(value<=0)
      return("Compact");
   if(value>=2)
      return("Detailed");
   return("Normal");
  }

string ASC_WrapperHeaderText(void)
  {
   return(ASC_PRODUCT_NAME + " | Wrapper " + ASC_WRAPPER_VERSION + " | Schema " + ASC_SCHEMA_FAMILY + " | Active " + ASC_ACTIVE_CAPABILITY + " | Next " + ASC_NEXT_CAPABILITY + " | Explorer " + ASC_EXPLORER_SUBSYSTEM_VERSION);
  }

string ASC_UpdateBumpLawText(void)
  {
   return("Every meaningful edit must bump version. Use a patch bump for non-breaking fixes, a minor bump for meaningful subsystem expansion, and 2.000+ only for major architecture revision.");
  }

string ASC_YesNoPending(const bool condition,const string pending_text)
  {
   return(condition ? "Yes" : pending_text);
  }

#endif
