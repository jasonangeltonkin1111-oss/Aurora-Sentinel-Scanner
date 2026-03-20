#ifndef __ASC_EXPLORER_HUD_MQH__
#define __ASC_EXPLORER_HUD_MQH__

#include "ASC_Common.mqh"
#include "ASC_ExplorerBuckets.mqh"
#include "ASC_Logging.mqh"

#define ASC_HUD_PREFIX "ASC_EXPLORER::"

enum ASC_ExplorerView
  {
   ASC_EXPLORER_VIEW_OVERVIEW=0,
   ASC_EXPLORER_VIEW_BUCKETS=1,
   ASC_EXPLORER_VIEW_SYMBOL_DETAIL=2
  };

struct ASC_ExplorerTheme
  {
   int margin;
   int padding;
   int row_height;
   int button_height;
   int title_height;
   int rail_width;
   int panel_gap;
   color background;
   color panel;
   color panel_alt;
   color accent;
   color warning;
   color text;
   color muted;
   color button_text;
  };

struct ASC_ExplorerNavState
  {
   ASC_ExplorerView current_view;
   ASC_ExplorerView history_views[12];
   int history_count;
   int bucket_scroll;
   int selected_bucket_index;
   int selected_symbol_index;
   int symbol_scroll;
   bool dirty;
   datetime last_render_at;
  };

struct ASC_ExplorerContext
  {
   long chart_id;
   string prefix;
   ASC_ExplorerTheme theme;
   ASC_ExplorerNavState nav;
   bool initialized;
  };

void ASC_ExplorerThemeDefaults(ASC_ExplorerTheme &theme)
  {
   theme.margin=10;
   theme.padding=8;
   theme.row_height=18;
   theme.button_height=24;
   theme.title_height=28;
   theme.rail_width=94;
   theme.panel_gap=8;
   theme.background=C'19,24,34';
   theme.panel=C'29,36,49';
   theme.panel_alt=C'38,45,60';
   theme.accent=C'82,168,255';
   theme.warning=C'230,185,90';
   theme.text=clrWhite;
   theme.muted=C'188,198,210';
   theme.button_text=clrWhite;
  }

string ASC_ExplorerObjectName(const ASC_ExplorerContext &ctx,const string suffix)
  {
   return(ctx.prefix + suffix);
  }

void ASC_ExplorerDeleteOwnedObjects(const ASC_ExplorerContext &ctx)
  {
   int total=ObjectsTotal(ctx.chart_id,0,-1);
   for(int i=total-1;i>=0;i--)
     {
      string name=ObjectName(ctx.chart_id,i,0,-1);
      if(StringFind(name,ctx.prefix)==0)
         ObjectDelete(ctx.chart_id,name);
     }
  }

bool ASC_ExplorerButton(const ASC_ExplorerContext &ctx,const string id,const string text,const int x,const int y,const int w,const int h,const color bg)
  {
   string name=ASC_ExplorerObjectName(ctx,id);
   ObjectDelete(ctx.chart_id,name);
   if(!ObjectCreate(ctx.chart_id,name,OBJ_BUTTON,0,0,0))
      return(false);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_YSIZE,h);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_COLOR,ctx.theme.button_text);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_BORDER_COLOR,ctx.theme.accent);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_SELECTABLE,false);
   ObjectSetString(ctx.chart_id,name,OBJPROP_TEXT,text);
   return(true);
  }

bool ASC_ExplorerLabel(const ASC_ExplorerContext &ctx,const string id,const string text,const int x,const int y,const color text_color,const int font_size=9)
  {
   string name=ASC_ExplorerObjectName(ctx,id);
   ObjectDelete(ctx.chart_id,name);
   if(!ObjectCreate(ctx.chart_id,name,OBJ_LABEL,0,0,0))
      return(false);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_COLOR,text_color);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_SELECTABLE,false);
   ObjectSetString(ctx.chart_id,name,OBJPROP_TEXT,text);
   return(true);
  }

bool ASC_ExplorerRect(const ASC_ExplorerContext &ctx,const string id,const int x,const int y,const int w,const int h,const color fill,const color border)
  {
   string name=ASC_ExplorerObjectName(ctx,id);
   ObjectDelete(ctx.chart_id,name);
   if(!ObjectCreate(ctx.chart_id,name,OBJ_RECTANGLE_LABEL,0,0,0))
      return(false);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_YSIZE,h);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_BGCOLOR,fill);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_BORDER_COLOR,border);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_COLOR,border);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_BACK,false);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_SELECTABLE,false);
   return(true);
  }

int ASC_ExplorerVisibleRows(const ASC_ExplorerContext &ctx,const int content_height)
  {
   int rows=(content_height-ctx.theme.padding)/(ctx.theme.row_height+2);
   if(rows<1)
      rows=1;
   return(rows);
  }

void ASC_ExplorerPushHistory(ASC_ExplorerContext &ctx,const ASC_ExplorerView view)
  {
   if(ctx.nav.history_count>=ArraySize(ctx.nav.history_views))
     {
      for(int i=1;i<ctx.nav.history_count;i++)
         ctx.nav.history_views[i-1]=ctx.nav.history_views[i];
      ctx.nav.history_count--;
     }
   ctx.nav.history_views[ctx.nav.history_count]=view;
   ctx.nav.history_count++;
  }

void ASC_ExplorerOpenView(ASC_ExplorerContext &ctx,const ASC_ExplorerView view)
  {
   if(ctx.nav.current_view!=view)
      ASC_ExplorerPushHistory(ctx,ctx.nav.current_view);
   ctx.nav.current_view=view;
   ctx.nav.dirty=true;
  }

void ASC_ExplorerGoHome(ASC_ExplorerContext &ctx)
  {
   ctx.nav.current_view=ASC_EXPLORER_VIEW_OVERVIEW;
   ctx.nav.history_count=0;
   ctx.nav.dirty=true;
  }

void ASC_ExplorerGoBack(ASC_ExplorerContext &ctx)
  {
   if(ctx.nav.history_count<=0)
     {
      ASC_ExplorerGoHome(ctx);
      return;
     }
   ctx.nav.history_count--;
   ctx.nav.current_view=ctx.nav.history_views[ctx.nav.history_count];
   ctx.nav.dirty=true;
  }

string ASC_ExplorerBucketStatusText(void)
  {
   return("Placeholder only until Symbol Identity and Bucketing becomes active.");
  }

int ASC_ExplorerFindSymbolIndex(ASC_SymbolState &states[],const int count,const string symbol)
  {
   for(int i=0;i<count;i++)
      if(states[i].symbol==symbol)
         return(i);
   return(-1);
  }

string ASC_ExplorerSafeSymbol(const ASC_ExplorerContext &ctx,ASC_SymbolState &states[],const int count)
  {
   if(count<=0)
      return("");
   if(ctx.nav.selected_symbol_index<0 || ctx.nav.selected_symbol_index>=count)
      return(states[0].symbol);
   return(states[ctx.nav.selected_symbol_index].symbol);
  }

void ASC_ExplorerRenderOverview(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count,const int x,const int y,const int w,const int h)
  {
   ASC_ExplorerRect(ctx,"overview.panel",x,y,w,h,ctx.theme.panel,ctx.theme.accent);
   ASC_ExplorerLabel(ctx,"overview.title","Explorer Overview",x+ctx.theme.padding,y+6,ctx.theme.text,11);

   int row_y=y+ctx.theme.title_height;
   int open_count=0,closed_count=0,uncertain_count=0,unknown_count=0,due_count=0,dirty_count=0;
   for(int i=0;i<count;i++)
     {
      if(states[i].dirty) dirty_count++;
      if(states[i].next_check_at<=runtime.last_heartbeat_at || states[i].dirty) due_count++;
      switch(states[i].market_status)
        {
         case ASC_MARKET_OPEN: open_count++; break;
         case ASC_MARKET_CLOSED: closed_count++; break;
         case ASC_MARKET_UNCERTAIN: uncertain_count++; break;
         default: unknown_count++; break;
        }
     }

   string lines[];
   ArrayResize(lines,13);
   lines[0]=ASC_WrapperHeaderText();
   lines[1]="Server: " + runtime.server_clean + " | Server Time: " + ASC_DateTimeText(TimeTradeServer());
   lines[2]="Runtime State: " + ASC_RuntimeModeText(runtime.mode) + " | Posture: " + ASC_RUNTIME_POSTURE;
   lines[3]="Current Capability: Market State Detection = Working";
   lines[4]="Later Capabilities: Symbol Identity and Bucketing, Open Symbol Snapshot, Candidate Filtering, Shortlist Selection, Deep Selective Analysis = Reserved";
   lines[5]="Universe: " + IntegerToString(count) + " | Open: " + IntegerToString(open_count) + " | Closed: " + IntegerToString(closed_count) + " | Uncertain: " + IntegerToString(uncertain_count) + " | Unknown: " + IntegerToString(unknown_count);
   lines[6]="Heartbeat: " + IntegerToString(runtime.heartbeats_since_boot) + " | Processed Last Beat: " + IntegerToString(runtime.processed_this_heartbeat) + " | Budget: " + IntegerToString(settings.symbol_budget_per_heartbeat);
   lines[7]="Scheduler: cursor " + IntegerToString(runtime.scheduler_cursor) + " | Due now: " + IntegerToString(due_count) + " | Pending writes: " + IntegerToString(dirty_count);
   lines[8]="Backlog: " + (runtime.degraded ? "Bounded work cap active" : "Within current budget") + " | Refresh: " + IntegerToString(settings.explorer_refresh_seconds) + "s";
   lines[9]="Last Activity: heartbeat " + ASC_DateTimeText(runtime.last_heartbeat_at) + " | universe sync " + ASC_DateTimeText(runtime.last_universe_sync_at);
   lines[10]="Last Write: runtime " + ASC_DateTimeText(runtime.last_runtime_save_at) + " | scheduler " + ASC_DateTimeText(runtime.last_scheduler_save_at) + " | summary " + ASC_DateTimeText(runtime.last_summary_save_at);
   lines[11]="Recovery: " + (runtime.recovery_used ? "Restored continuity was used" : "Fresh start on this server") + " | Explorer: shell active";
   lines[12]="Attention: " + (runtime.degraded ? "Some symbols remain queued for the next heartbeat." : "No active bounded-work warning.");

   for(int i=0;i<ArraySize(lines);i++)
      ASC_ExplorerLabel(ctx,"overview.line." + IntegerToString(i),lines[i],x+ctx.theme.padding,row_y + i*(ctx.theme.row_height+2),(i==12 && runtime.degraded ? ctx.theme.warning : ctx.theme.muted));
  }

void ASC_ExplorerRenderBuckets(ASC_ExplorerContext &ctx,const int x,const int y,const int w,const int h)
  {
   ASC_BucketPlaceholder buckets[];
   int total=ASC_GetBucketPlaceholders(buckets);
   int visible=ASC_ExplorerVisibleRows(ctx,h-ctx.theme.title_height-ctx.theme.button_height-ctx.theme.padding*2);
   int max_scroll=(total>visible ? total-visible : 0);
   if(ctx.nav.bucket_scroll<0) ctx.nav.bucket_scroll=0;
   if(ctx.nav.bucket_scroll>max_scroll) ctx.nav.bucket_scroll=max_scroll;

   ASC_ExplorerRect(ctx,"buckets.panel",x,y,w,h,ctx.theme.panel,ctx.theme.accent);
   ASC_ExplorerLabel(ctx,"buckets.title","Bucket View",x+ctx.theme.padding,y+6,ctx.theme.text,11);
   ASC_ExplorerLabel(ctx,"buckets.subtitle",ASC_ExplorerBucketStatusText(),x+ctx.theme.padding,y+ctx.theme.title_height,ctx.theme.muted);

   int list_y=y+ctx.theme.title_height+ctx.theme.row_height+6;
   int row_w=w-(ctx.theme.padding*2)-76;
   int button_x=x+w-ctx.theme.padding-70;
   for(int i=0;i<visible && (ctx.nav.bucket_scroll+i)<total;i++)
     {
      int idx=ctx.nav.bucket_scroll+i;
      int row_y=list_y+i*(ctx.theme.row_height+4);
      color fill=(idx==ctx.nav.selected_bucket_index ? ctx.theme.panel_alt : ctx.theme.background);
      ASC_ExplorerRect(ctx,"buckets.row." + IntegerToString(idx),x+ctx.theme.padding,row_y,row_w,ctx.theme.row_height+6,fill,ctx.theme.panel_alt);
      ASC_ExplorerLabel(ctx,"buckets.name." + IntegerToString(idx),buckets[idx].name + " — " + buckets[idx].family,x+ctx.theme.padding+6,row_y+4,ctx.theme.text);
      ASC_ExplorerButton(ctx,"action.bucket." + IntegerToString(idx),"Open",button_x,row_y,70,ctx.theme.button_height,ctx.theme.accent);
     }

   ASC_ExplorerButton(ctx,"action.scroll_up","Up",x+w-ctx.theme.padding-70,y+h-ctx.theme.button_height*2-6,70,ctx.theme.button_height,ctx.theme.panel_alt);
   ASC_ExplorerButton(ctx,"action.scroll_down","Down",x+w-ctx.theme.padding-70,y+h-ctx.theme.button_height-2,70,ctx.theme.button_height,ctx.theme.panel_alt);
  }

bool ASC_ExplorerReadDouble(const string symbol,const ENUM_SYMBOL_INFO_DOUBLE property,double &value)
  {
   value=0.0;
   return(SymbolInfoDouble(symbol,property,value));
  }

int ASC_ExplorerSymbolDigits(const string symbol)
  {
   long digits=0;
   if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digits))
      return(5);
   return((int)digits);
  }

void ASC_ExplorerRenderSymbolDetail(ASC_ExplorerContext &ctx,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count,const int x,const int y,const int w,const int h)
  {
   ASC_ExplorerRect(ctx,"symbol.panel",x,y,w,h,ctx.theme.panel,ctx.theme.accent);
   ASC_ExplorerLabel(ctx,"symbol.title","Symbol Detail",x+ctx.theme.padding,y+6,ctx.theme.text,11);

   if(count<=0)
     {
      ASC_ExplorerLabel(ctx,"symbol.empty","No symbol state is available yet.",x+ctx.theme.padding,y+ctx.theme.title_height,ctx.theme.warning);
      return;
     }

   if(ctx.nav.selected_symbol_index<0 || ctx.nav.selected_symbol_index>=count)
      ctx.nav.selected_symbol_index=0;

   ASC_SymbolState state=states[ctx.nav.selected_symbol_index];
   int digits=ASC_ExplorerSymbolDigits(state.symbol);
   MqlTick tick={};
   bool have_tick=SymbolInfoTick(state.symbol,tick);
   double bid=0.0,ask=0.0,day_high=0.0,day_low=0.0,point=0.0;
   long spread_points=0;
   ASC_ExplorerReadDouble(state.symbol,SYMBOL_BID,bid);
   ASC_ExplorerReadDouble(state.symbol,SYMBOL_ASK,ask);
   ASC_ExplorerReadDouble(state.symbol,SYMBOL_BIDHIGH,day_high);
   ASC_ExplorerReadDouble(state.symbol,SYMBOL_BIDLOW,day_low);
   ASC_ExplorerReadDouble(state.symbol,SYMBOL_POINT,point);
   SymbolInfoInteger(state.symbol,SYMBOL_SPREAD,spread_points);

   string lines[];
   ArrayResize(lines,15);
   lines[0]="Symbol: " + state.symbol + " | Server: " + runtime.server_clean;
   lines[1]="Market Status: " + ASC_MarketStatusText(state.market_status) + " | Session State: " + (state.within_trade_session ? "Inside broker trade session" : (state.has_trade_sessions ? "Outside broker trade session" : "Session data unavailable"));
   lines[2]="Status Note: " + state.status_note;
   lines[3]="Tick Presence: " + ASC_BoolText(state.has_tick) + " | Tick Age: " + (state.tick_age_seconds>=0 ? IntegerToString((int)state.tick_age_seconds) + "s" : "Not Yet Available");
   lines[4]="Next Check: " + ASC_DateTimeText(state.next_check_at) + " | Reason: " + state.next_check_reason;
   lines[5]="Runtime Health: last heartbeat " + ASC_DateTimeText(runtime.last_heartbeat_at) + " | mode " + ASC_RuntimeModeText(runtime.mode);
   lines[6]="Scheduler State: last checked " + ASC_DateTimeText(state.last_checked_at) + " | burst count " + IntegerToString(state.uncertain_burst_count);
   lines[7]="Publication: " + (state.publication_ok ? "Dossier promoted" : "Pending promotion or retry") + " | Last write " + ASC_DateTimeText(state.last_dossier_write_at);
   double spread_value=(ask>=bid ? (ask-bid) : 0.0);
   string spread_text=(spread_points>0 ? IntegerToString((int)spread_points) + " points" : (point>0.0 ? DoubleToString(spread_value/point,1) + " points" : DoubleToString(spread_value,digits)));
   lines[8]="Bid: " + DoubleToString(bid,digits) + " | Ask: " + DoubleToString(ask,digits) + " | Spread: " + spread_text;
   lines[9]="Day High: " + DoubleToString(day_high,digits) + " | Day Low: " + DoubleToString(day_low,digits);
   lines[10]="Market Watch Update: " + (have_tick ? ASC_DateTimeText((datetime)tick.time) : "Not Yet Available");
   lines[11]="Bucket Surface: Reserved placeholder pending Symbol Identity and Bucketing activation.";
   lines[12]="Open Symbol Snapshot: Reserved placeholder only.";
   lines[13]="Combined Opportunity Summary: Reserved placeholder only.";
   lines[14]="Future Signal Surface: Reserved placeholder only.";

   int content_h=h-ctx.theme.title_height-ctx.theme.padding;
   int visible=ASC_ExplorerVisibleRows(ctx,content_h);
   int max_scroll=(ArraySize(lines)>visible ? ArraySize(lines)-visible : 0);
   if(ctx.nav.symbol_scroll<0) ctx.nav.symbol_scroll=0;
   if(ctx.nav.symbol_scroll>max_scroll) ctx.nav.symbol_scroll=max_scroll;
   for(int i=0;i<visible && (ctx.nav.symbol_scroll+i)<ArraySize(lines);i++)
     {
      int idx=ctx.nav.symbol_scroll+i;
      ASC_ExplorerLabel(ctx,"symbol.line." + IntegerToString(idx),lines[idx],x+ctx.theme.padding,y+ctx.theme.title_height+i*(ctx.theme.row_height+2),(idx>=11 ? ctx.theme.warning : ctx.theme.muted));
     }

   ASC_ExplorerButton(ctx,"action.symbol_up","Up",x+w-ctx.theme.padding-70,y+h-ctx.theme.button_height*2-6,70,ctx.theme.button_height,ctx.theme.panel_alt);
   ASC_ExplorerButton(ctx,"action.symbol_down","Down",x+w-ctx.theme.padding-70,y+h-ctx.theme.button_height-2,70,ctx.theme.button_height,ctx.theme.panel_alt);
  }

string ASC_ExplorerBreadcrumbText(const ASC_ExplorerContext &ctx)
  {
   switch(ctx.nav.current_view)
     {
      case ASC_EXPLORER_VIEW_BUCKETS: return("Home / Buckets");
      case ASC_EXPLORER_VIEW_SYMBOL_DETAIL: return("Home / Symbol Detail");
      default: return("Home / Overview");
     }
  }

void ASC_ExplorerRenderChrome(ASC_ExplorerContext &ctx,const ASC_RuntimeState &runtime,const ASC_RuntimeSettings &settings,const int chart_w,const int chart_h)
  {
   ASC_ExplorerRect(ctx,"root",ctx.theme.margin,ctx.theme.margin,chart_w-(ctx.theme.margin*2),chart_h-(ctx.theme.margin*2),ctx.theme.background,ctx.theme.accent);
   ASC_ExplorerLabel(ctx,"header.main",ASC_PRODUCT_NAME + " — Explorer",ctx.theme.margin+ctx.theme.padding,ctx.theme.margin+4,ctx.theme.text,12);
   ASC_ExplorerLabel(ctx,"header.sub","Wrapper " + ASC_WRAPPER_VERSION + " | Active capability: " + ASC_ACTIVE_CAPABILITY + " | Next: " + ASC_NEXT_CAPABILITY,ctx.theme.margin+ctx.theme.padding,ctx.theme.margin+20,ctx.theme.muted);

   int button_y=ctx.theme.margin+46;
   int button_x=ctx.theme.margin+ctx.theme.padding;
   ASC_ExplorerButton(ctx,"action.home","Home",button_x,button_y,68,ctx.theme.button_height,ctx.theme.accent);
   ASC_ExplorerButton(ctx,"action.back","Back",button_x+74,button_y,68,ctx.theme.button_height,ctx.theme.panel_alt);
   ASC_ExplorerButton(ctx,"action.overview","Overview",button_x+148,button_y,84,ctx.theme.button_height,ctx.theme.panel_alt);
   ASC_ExplorerButton(ctx,"action.buckets","Buckets",button_x+238,button_y,78,ctx.theme.button_height,ctx.theme.panel_alt);
   ASC_ExplorerButton(ctx,"action.symbol_detail","Symbol",button_x+322,button_y,72,ctx.theme.button_height,ctx.theme.panel_alt);

   if(settings.explorer_show_breadcrumbs)
      ASC_ExplorerLabel(ctx,"header.breadcrumb",ASC_ExplorerBreadcrumbText(ctx),button_x,button_y+ctx.theme.button_height+6,ctx.theme.muted);

   if(runtime.degraded)
      ASC_ExplorerLabel(ctx,"header.warn","Attention: bounded work remains active; some symbols are queued for the next heartbeat.",button_x+404,button_y+4,ctx.theme.warning);
  }

void ASC_ExplorerRender(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count)
  {
   if(!settings.explorer_enabled)
      return;

   int chart_w=(int)ChartGetInteger(ctx.chart_id,CHART_WIDTH_IN_PIXELS,0);
   int chart_h=(int)ChartGetInteger(ctx.chart_id,CHART_HEIGHT_IN_PIXELS,0);
   if(chart_w<640 || chart_h<400)
      return;

   ASC_ExplorerDeleteOwnedObjects(ctx);
   ASC_ExplorerRenderChrome(ctx,runtime,settings,chart_w,chart_h);

   int x=ctx.theme.margin+ctx.theme.padding;
   int y=ctx.theme.margin+ (settings.explorer_show_breadcrumbs ? 106 : 80);
   int w=chart_w-(ctx.theme.margin*2)-(ctx.theme.padding*2);
   int h=chart_h-y-ctx.theme.margin;

   switch(ctx.nav.current_view)
     {
      case ASC_EXPLORER_VIEW_BUCKETS:
         ASC_ExplorerRenderBuckets(ctx,x,y,w,h);
         break;
      case ASC_EXPLORER_VIEW_SYMBOL_DETAIL:
         ASC_ExplorerRenderSymbolDetail(ctx,runtime,states,count,x,y,w,h);
         break;
      default:
         ASC_ExplorerRenderOverview(ctx,settings,runtime,states,count,x,y,w,h);
         break;
     }

   ChartRedraw(ctx.chart_id);
   ctx.nav.last_render_at=TimeCurrent();
   ctx.nav.dirty=false;
  }

void ASC_ExplorerInit(ASC_ExplorerContext &ctx,const long chart_id)
  {
   ctx.chart_id=chart_id;
   ctx.prefix=ASC_HUD_PREFIX;
   ASC_ExplorerThemeDefaults(ctx.theme);
   ctx.nav.current_view=ASC_EXPLORER_VIEW_OVERVIEW;
   ctx.nav.history_count=0;
   ctx.nav.bucket_scroll=0;
   ctx.nav.selected_bucket_index=0;
   ctx.nav.selected_symbol_index=0;
   ctx.nav.symbol_scroll=0;
   ctx.nav.dirty=true;
   ctx.nav.last_render_at=0;
   ctx.initialized=true;
  }

void ASC_ExplorerShutdown(ASC_ExplorerContext &ctx)
  {
   if(!ctx.initialized)
      return;
   ASC_ExplorerDeleteOwnedObjects(ctx);
   ctx.initialized=false;
  }

void ASC_ExplorerMaybeRender(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count,const bool force=false)
  {
   if(!ctx.initialized || !settings.explorer_enabled)
      return;
   datetime now=TimeCurrent();
   if(!force && !ctx.nav.dirty && ctx.nav.last_render_at>0 && (now-ctx.nav.last_render_at)<settings.explorer_refresh_seconds)
      return;
   ASC_ExplorerRender(ctx,settings,runtime,states,count);
  }

void ASC_ExplorerHandleAction(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const string object_name,ASC_SymbolState &states[],const int count,ASC_Logger &logger)
  {
   string action=object_name;
   StringReplace(action,ctx.prefix,"");
   if(action=="action.home")
      ASC_ExplorerGoHome(ctx);
   else if(action=="action.back")
      ASC_ExplorerGoBack(ctx);
   else if(action=="action.overview")
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_OVERVIEW);
   else if(action=="action.buckets")
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_BUCKETS);
   else if(action=="action.symbol_detail")
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_SYMBOL_DETAIL);
   else if(action=="action.scroll_up")
     {
      ctx.nav.bucket_scroll-=settings.explorer_scroll_step_rows;
      ctx.nav.dirty=true;
     }
   else if(action=="action.scroll_down")
     {
      ctx.nav.bucket_scroll+=settings.explorer_scroll_step_rows;
      ctx.nav.dirty=true;
     }
   else if(action=="action.symbol_up")
     {
      ctx.nav.symbol_scroll-=settings.explorer_scroll_step_rows;
      ctx.nav.dirty=true;
     }
   else if(action=="action.symbol_down")
     {
      ctx.nav.symbol_scroll+=settings.explorer_scroll_step_rows;
      ctx.nav.dirty=true;
     }
   else if(StringFind(action,"action.bucket.")==0)
     {
      ctx.nav.selected_bucket_index=(int)StringToInteger(StringSubstr(action,StringLen("action.bucket.")));
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_SYMBOL_DETAIL);
      if(count>0)
         ctx.nav.selected_symbol_index=(ctx.nav.selected_bucket_index<count ? ctx.nav.selected_bucket_index : count-1);
      else
         ctx.nav.selected_symbol_index=0;
      ctx.nav.symbol_scroll=0;
     }
   else
      return;

   logger.Debug("Explorer","action " + action + " dispatched");
  }

#endif
