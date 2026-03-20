#ifndef __ASC_F1_MARKET_STATE_MQH__
#define __ASC_F1_MARKET_STATE_MQH__

#include "ASC_F1_Common.mqh"

bool ASC_F1_IsWithinTradeSession(const string symbol,const datetime now,datetime &next_open_at,bool &has_sessions)
  {
   has_sessions=false;
   next_open_at=0;

   MqlDateTime dt;
   TimeToStruct(now,dt);
   int now_seconds=dt.hour*3600 + dt.min*60 + dt.sec;
   ENUM_DAY_OF_WEEK today=(ENUM_DAY_OF_WEEK)dt.day_of_week;

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
            if(now_seconds>=from_value && now_seconds<to_value)
               return(true);
            if(now_seconds<from_value)
              {
               next_open_at=now + (from_value - now_seconds);
               return(false);
              }
           }
         else if(next_open_at<=0)
           {
            int remain_today=86400-now_seconds;
            next_open_at=now + remain_today + (day_offset-1)*86400 + from_value;
            return(false);
           }
        }
     }

   return(false);
  }

void ASC_F1_AssessSymbol(const string symbol,ASC_F1_SymbolState &state)
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
   bool within_session=ASC_F1_IsWithinTradeSession(symbol,now,next_open_at,has_sessions);
   state.has_trade_sessions=has_sessions;
   state.within_trade_session=within_session;
   state.next_session_open_at=next_open_at;

   if(state.has_tick && state.tick_age_seconds>=0 && state.tick_age_seconds<=90)
     {
      state.market_status=ASC_F1_MARKET_OPEN;
      state.status_note="Fresh tick observed";
      state.next_check_at=now+10;
      state.uncertain_burst_count=0;
     }
   else if(within_session)
     {
      state.market_status=ASC_F1_MARKET_UNCERTAIN;
      state.status_note="Inside trade session without fresh tick";
      if(state.uncertain_burst_count<12)
        {
         state.next_check_at=now+5;
         state.uncertain_burst_count++;
        }
      else
        {
         state.next_check_at=now+30;
        }
     }
   else if(has_sessions)
     {
      state.market_status=ASC_F1_MARKET_CLOSED;
      state.status_note="Outside trade session";
      if(next_open_at>0 && (next_open_at-now)<=60)
         state.next_check_at=now+1;
      else if(next_open_at>0)
         state.next_check_at=(next_open_at>now ? next_open_at : now+300);
      else
         state.next_check_at=now+300;
      state.uncertain_burst_count=0;
     }
   else
     {
      state.market_status=ASC_F1_MARKET_UNKNOWN;
      state.status_note="No trade session information available";
      state.next_check_at=now+60;
     }

   state.dirty=true;
  }

#endif
