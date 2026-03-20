#ifndef __ASC_MARKET_STATE_MQH__
#define __ASC_MARKET_STATE_MQH__

#include "ASC_Common.mqh"

bool ASC_IsWithinTradeSession(const string symbol,const datetime now,datetime &next_open_at,bool &has_sessions)
  {
   has_sessions=false;
   next_open_at=0;

   MqlDateTime dt;
   TimeToStruct(now,dt);
   int now_seconds=dt.hour*3600 + dt.min*60 + dt.sec;

   for(int day_offset=0; day_offset<7; day_offset++)
     {
      ENUM_DAY_OF_WEEK day=(ENUM_DAY_OF_WEEK)((dt.day_of_week + day_offset) % 7);
      datetime from_sec=0;
      datetime to_sec=0;
      for(uint session_index=0; SymbolInfoSessionTrade(symbol,day,session_index,from_sec,to_sec); session_index++)
        {
         has_sessions=true;
         int from_value=(int)from_sec;
         int to_value=(int)to_sec;

         if(day_offset==0)
           {
            if(to_value<from_value)
              {
               if(now_seconds>=from_value || now_seconds<to_value)
                  return(true);
              }
            else if(now_seconds>=from_value && now_seconds<to_value)
               return(true);

            if(now_seconds<from_value && (next_open_at<=0 || now + (from_value-now_seconds) < next_open_at))
               next_open_at=now + (from_value-now_seconds);
           }
         else if(next_open_at<=0)
           {
            int remain_today=86400-now_seconds;
            next_open_at=now + remain_today + (day_offset-1)*86400 + from_value;
           }
        }
      if(day_offset==0 && next_open_at>0)
         return(false);
     }

   return(false);
  }

void ASC_AssessSymbol(const string symbol,ASC_SymbolState &state,const ASC_RuntimeSettings &settings)
  {
   datetime now=TimeTradeServer();
   if(now<=0)
      now=TimeCurrent();

   state.symbol=symbol;
   state.last_checked_at=now;
   state.status_note="";

   MqlTick tick={};
   state.has_tick=SymbolInfoTick(symbol,tick);
   state.last_tick_seen_at=(state.has_tick ? (datetime)tick.time : 0);
   state.tick_age_seconds=(state.last_tick_seen_at>0 ? (long)(now-state.last_tick_seen_at) : -1);

   datetime next_open_at=0;
   bool has_sessions=false;
   bool within_session=ASC_IsWithinTradeSession(symbol,now,next_open_at,has_sessions);
   state.has_trade_sessions=has_sessions;
   state.within_trade_session=within_session;
   state.next_session_open_at=next_open_at;

   bool fresh_tick=(state.has_tick && state.tick_age_seconds>=0 && state.tick_age_seconds<=settings.fresh_tick_seconds);

   if(state.has_trade_sessions)
     {
      if(state.within_trade_session)
        {
         if(fresh_tick)
           {
            state.market_status=ASC_MARKET_OPEN;
            state.status_note="Fresh tick inside broker trade session";
            state.next_check_at=now+settings.open_recheck_seconds;
            state.next_check_reason="Open market refresh cadence";
            state.uncertain_burst_count=0;
           }
         else
           {
            state.market_status=ASC_MARKET_UNCERTAIN;
            state.status_note="Inside broker trade session without a fresh tick";
            if(state.uncertain_burst_count<settings.uncertain_burst_limit)
              {
               state.next_check_at=now+settings.uncertain_fast_recheck_seconds;
               state.next_check_reason="Uncertain fast follow-up inside trade session";
               state.uncertain_burst_count++;
              }
            else
              {
               state.next_check_at=now+settings.uncertain_slow_recheck_seconds;
               state.next_check_reason="Uncertain slow follow-up after burst limit";
              }
           }
        }
      else
        {
         state.market_status=ASC_MARKET_CLOSED;
         state.status_note=(fresh_tick ? "Outside broker trade session; recent tick preserved but market treated as closed" : "Outside broker trade session");
         if(next_open_at>0 && (next_open_at-now)<=settings.closed_near_open_seconds)
           {
            state.next_check_at=now+settings.closed_near_open_recheck_seconds;
            state.next_check_reason="Near broker session open";
           }
         else if(next_open_at>0 && (next_open_at-now)<=settings.closed_soon_window_seconds)
           {
            state.next_check_at=now+settings.closed_soon_recheck_seconds;
            state.next_check_reason="Broker session opens soon";
           }
         else
           {
            state.next_check_at=now+settings.closed_idle_recheck_seconds;
            state.next_check_reason="Closed-session maintenance cadence";
           }
         state.uncertain_burst_count=0;
        }
     }
   else if(fresh_tick)
     {
      state.market_status=ASC_MARKET_OPEN;
      state.status_note="Fresh tick observed while broker session data is unavailable";
      state.next_check_at=now+settings.open_recheck_seconds;
      state.next_check_reason="Open cadence using live tick evidence";
      state.uncertain_burst_count=0;
     }
   else
     {
      state.market_status=ASC_MARKET_UNKNOWN;
      state.status_note="Trade session information is not available and no fresh tick confirms activity";
      state.next_check_at=now+settings.unknown_recheck_seconds;
      state.next_check_reason="Unknown-state safety recheck";
      state.uncertain_burst_count=0;
     }

   state.is_due_now=(state.next_check_at<=now);
   state.publication_ok=(state.last_dossier_write_at>0);
   state.dirty=true;
  }

#endif
