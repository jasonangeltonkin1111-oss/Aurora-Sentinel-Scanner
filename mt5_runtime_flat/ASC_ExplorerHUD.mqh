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
   ASC_EXPLORER_VIEW_BUCKET_DETAIL=2,
   ASC_EXPLORER_VIEW_SYMBOL_DETAIL=3,
   ASC_EXPLORER_VIEW_STAT_DETAIL=4
  };

enum ASC_ExplorerStatView
  {
   ASC_EXPLORER_STAT_NONE=0,
   ASC_EXPLORER_STAT_IDENTITY=1,
   ASC_EXPLORER_STAT_MARKET_STATE=2,
   ASC_EXPLORER_STAT_TICK_QUOTE=3,
   ASC_EXPLORER_STAT_RUNTIME_PUBLICATION=4,
   ASC_EXPLORER_STAT_FUTURE_SURFACES=5
  };

struct ASC_ExplorerTheme
  {
   int margin;
   int gap;
   int padding;
   int header_height;
   int nav_height;
   int status_height;
   int rail_width;
   int row_height;
   int title_height;
   int button_height;
   color background;
   color header_fill;
   color panel_fill;
   color panel_alt_fill;
   color section_fill;
   color accent;
   color accent_alt;
   color warning;
   color reserved;
   color text;
   color muted;
   color border;
   color rail_fill;
   color selected_fill;
  };

struct ASC_ExplorerNavState
  {
   ASC_ExplorerView current_view;
   ASC_ExplorerView history_views[24];
   int history_bucket[24];
   int history_symbol[24];
   int history_stat[24];
   string history_bucket_mode[24];
   string history_seed_symbol[24];
   int history_bucket_scroll[24];
   int history_detail_scroll[24];
   int history_symbol_scroll[24];
   int history_stat_scroll[24];
   int history_bucket_mode_scroll[24];
   int history_count;
   int bucket_scroll;
   int bucket_detail_scroll;
   int symbol_scroll;
   int stat_scroll;
   int bucket_mode_scroll;
   int selected_bucket_index;
   int selected_symbol_index;
   ASC_ExplorerBucketDisplayMode bucket_display_mode;
   ASC_ExplorerStatView selected_stat_view;
   string selected_seed_symbol;
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

void ASC_ExplorerThemeDefaults(ASC_ExplorerTheme &theme,const int density_mode)
  {
   theme.margin=10;
   theme.gap=8;
   theme.padding=(density_mode<=0 ? 7 : (density_mode>=2 ? 10 : 8));
   theme.header_height=(density_mode>=2 ? 58 : 52);
   theme.nav_height=(density_mode>=2 ? 34 : 30);
   theme.status_height=(density_mode>=2 ? 30 : 26);
   theme.rail_width=(density_mode>=2 ? 128 : 116);
   theme.row_height=(density_mode<=0 ? 16 : (density_mode>=2 ? 20 : 18));
   theme.title_height=(density_mode>=2 ? 30 : 26);
   theme.button_height=(density_mode>=2 ? 26 : 24);
   theme.background=C'14,19,27';
   theme.header_fill=C'23,31,43';
   theme.panel_fill=C'26,35,48';
   theme.panel_alt_fill=C'34,44,60';
   theme.section_fill=C'18,26,37';
   theme.accent=C'78,163,255';
   theme.accent_alt=C'89,214,176';
   theme.warning=C'236,191,92';
   theme.reserved=C'123,132,153';
   theme.text=clrWhite;
   theme.muted=C'194,202,216';
   theme.border=C'60,75,98';
   theme.rail_fill=C'20,27,38';
   theme.selected_fill=C'43,60,82';
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

bool ASC_ExplorerButton(const ASC_ExplorerContext &ctx,const string id,const string text,const int x,const int y,const int w,const int h,const color fill,const bool selected=false)
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
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_BGCOLOR,(selected ? ctx.theme.selected_fill : fill));
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_COLOR,ctx.theme.text);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_BORDER_COLOR,(selected ? ctx.theme.accent : ctx.theme.border));
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(ctx.chart_id,name,OBJPROP_SELECTABLE,false);
   ObjectSetString(ctx.chart_id,name,OBJPROP_TEXT,text);
   return(true);
  }

void ASC_ExplorerPanelTitle(const ASC_ExplorerContext &ctx,const string id,const string title,const int x,const int y,const int w)
  {
   ASC_ExplorerRect(ctx,id + ".title",x,y,w,ctx.theme.title_height,ctx.theme.section_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,id + ".title.text",title,x+ctx.theme.padding,y+6,ctx.theme.text,10);
  }

void ASC_ExplorerInfoRow(const ASC_ExplorerContext &ctx,const string id,const string label,const string value,const int x,const int y,const int w)
  {
   ASC_ExplorerRect(ctx,id + ".row",x,y,w,ctx.theme.row_height+4,ctx.theme.panel_fill,ctx.theme.panel_fill);
   ASC_ExplorerLabel(ctx,id + ".label",label,x+ctx.theme.padding,y+3,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,id + ".value",value,x+(w/2),y+3,ctx.theme.text);
  }

int ASC_ExplorerVisibleRows(const ASC_ExplorerContext &ctx,const int available_height)
  {
   int rows=(available_height)/(ctx.theme.row_height+ctx.theme.gap);
   if(rows<1)
      rows=1;
   return(rows);
  }

void ASC_ExplorerPushHistory(ASC_ExplorerContext &ctx)
  {
   if(ctx.nav.history_count>=ArraySize(ctx.nav.history_views))
     {
      for(int i=1;i<ctx.nav.history_count;i++)
        {
         ctx.nav.history_views[i-1]=ctx.nav.history_views[i];
         ctx.nav.history_bucket[i-1]=ctx.nav.history_bucket[i];
         ctx.nav.history_symbol[i-1]=ctx.nav.history_symbol[i];
         ctx.nav.history_stat[i-1]=ctx.nav.history_stat[i];
         ctx.nav.history_bucket_mode[i-1]=ctx.nav.history_bucket_mode[i];
         ctx.nav.history_seed_symbol[i-1]=ctx.nav.history_seed_symbol[i];
         ctx.nav.history_bucket_scroll[i-1]=ctx.nav.history_bucket_scroll[i];
         ctx.nav.history_detail_scroll[i-1]=ctx.nav.history_detail_scroll[i];
         ctx.nav.history_symbol_scroll[i-1]=ctx.nav.history_symbol_scroll[i];
         ctx.nav.history_stat_scroll[i-1]=ctx.nav.history_stat_scroll[i];
         ctx.nav.history_bucket_mode_scroll[i-1]=ctx.nav.history_bucket_mode_scroll[i];
        }
      ctx.nav.history_count--;
     }

   int slot=ctx.nav.history_count;
   ctx.nav.history_views[slot]=ctx.nav.current_view;
   ctx.nav.history_bucket[slot]=ctx.nav.selected_bucket_index;
   ctx.nav.history_symbol[slot]=ctx.nav.selected_symbol_index;
   ctx.nav.history_stat[slot]=(int)ctx.nav.selected_stat_view;
   ctx.nav.history_bucket_mode[slot]=IntegerToString((int)ctx.nav.bucket_display_mode);
   ctx.nav.history_seed_symbol[slot]=ctx.nav.selected_seed_symbol;
   ctx.nav.history_bucket_scroll[slot]=ctx.nav.bucket_scroll;
   ctx.nav.history_detail_scroll[slot]=ctx.nav.bucket_detail_scroll;
   ctx.nav.history_symbol_scroll[slot]=ctx.nav.symbol_scroll;
   ctx.nav.history_stat_scroll[slot]=ctx.nav.stat_scroll;
   ctx.nav.history_bucket_mode_scroll[slot]=ctx.nav.bucket_mode_scroll;
   ctx.nav.history_count++;
  }

void ASC_ExplorerOpenView(ASC_ExplorerContext &ctx,const ASC_ExplorerView view)
  {
   if(ctx.nav.current_view!=view)
      ASC_ExplorerPushHistory(ctx);
   ctx.nav.current_view=view;
   ctx.nav.dirty=true;
  }

void ASC_ExplorerGoHome(ASC_ExplorerContext &ctx)
  {
   ctx.nav.current_view=ASC_EXPLORER_VIEW_OVERVIEW;
   ctx.nav.history_count=0;
   ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_NONE;
   ctx.nav.selected_seed_symbol="";
   ctx.nav.selected_symbol_index=-1;
   ctx.nav.bucket_display_mode=ASC_BUCKET_DISPLAY_TOP_3;
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
   int slot=ctx.nav.history_count;
   ctx.nav.current_view=ctx.nav.history_views[slot];
   ctx.nav.selected_bucket_index=ctx.nav.history_bucket[slot];
   ctx.nav.selected_symbol_index=ctx.nav.history_symbol[slot];
   ctx.nav.selected_stat_view=(ASC_ExplorerStatView)ctx.nav.history_stat[slot];
   ctx.nav.bucket_display_mode=(ASC_ExplorerBucketDisplayMode)StringToInteger(ctx.nav.history_bucket_mode[slot]);
   ctx.nav.selected_seed_symbol=ctx.nav.history_seed_symbol[slot];
   ctx.nav.bucket_scroll=ctx.nav.history_bucket_scroll[slot];
   ctx.nav.bucket_detail_scroll=ctx.nav.history_detail_scroll[slot];
   ctx.nav.symbol_scroll=ctx.nav.history_symbol_scroll[slot];
   ctx.nav.stat_scroll=ctx.nav.history_stat_scroll[slot];
   ctx.nav.bucket_mode_scroll=ctx.nav.history_bucket_mode_scroll[slot];
   ctx.nav.dirty=true;
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

string ASC_ExplorerViewText(const ASC_ExplorerView view)
  {
   switch(view)
     {
      case ASC_EXPLORER_VIEW_BUCKETS: return("Bucket List");
      case ASC_EXPLORER_VIEW_BUCKET_DETAIL: return("Bucket Detail");
      case ASC_EXPLORER_VIEW_SYMBOL_DETAIL: return("Symbol Detail");
      case ASC_EXPLORER_VIEW_STAT_DETAIL: return("Stat Detail");
      default: return("Overview");
     }
  }

string ASC_ExplorerStatText(const ASC_ExplorerStatView view)
  {
   switch(view)
     {
      case ASC_EXPLORER_STAT_IDENTITY: return("Identity");
      case ASC_EXPLORER_STAT_MARKET_STATE: return("Market State");
      case ASC_EXPLORER_STAT_TICK_QUOTE: return("Tick and Quote");
      case ASC_EXPLORER_STAT_RUNTIME_PUBLICATION: return("Runtime and Publication");
      case ASC_EXPLORER_STAT_FUTURE_SURFACES: return("Future Surfaces");
     }
   return("Overview");
  }

string ASC_ExplorerSelectedBucketName(ASC_ExplorerContext &ctx)
  {
   ASC_BucketViewModel buckets[];
   int total=ASC_GetBucketViewModels(buckets,ctx.nav.bucket_display_mode);
   if(ctx.nav.selected_bucket_index<0 || ctx.nav.selected_bucket_index>=total)
      return("Bucket Detail");
   return(buckets[ctx.nav.selected_bucket_index].name);
  }

string ASC_ExplorerSelectedSymbolName(ASC_ExplorerContext &ctx,ASC_SymbolState &states[],const int count)
  {
   if(ctx.nav.selected_symbol_index>=0 && ctx.nav.selected_symbol_index<count)
      return(states[ctx.nav.selected_symbol_index].symbol);
   if(ctx.nav.selected_seed_symbol!="")
      return(ctx.nav.selected_seed_symbol);
   return("Symbol Detail");
  }

string ASC_ExplorerBreadcrumbText(ASC_ExplorerContext &ctx,ASC_SymbolState &states[],const int count)
  {
   string path="Home / Overview";
   if(ctx.nav.current_view==ASC_EXPLORER_VIEW_BUCKETS)
      path="Home / Buckets";
   else if(ctx.nav.current_view==ASC_EXPLORER_VIEW_BUCKET_DETAIL)
      path="Home / Buckets / " + ASC_ExplorerSelectedBucketName(ctx);
   else if(ctx.nav.current_view==ASC_EXPLORER_VIEW_SYMBOL_DETAIL)
      path="Home / Buckets / " + ASC_ExplorerSelectedBucketName(ctx) + " / " + ASC_ExplorerSelectedSymbolName(ctx,states,count);
   else if(ctx.nav.current_view==ASC_EXPLORER_VIEW_STAT_DETAIL)
      path="Home / Buckets / " + ASC_ExplorerSelectedBucketName(ctx) + " / " + ASC_ExplorerSelectedSymbolName(ctx,states,count) + " / " + ASC_ExplorerStatText(ctx.nav.selected_stat_view);
   return(path);
  }

void ASC_ExplorerCounts(ASC_SymbolState &states[],const int count,int &open_count,int &closed_count,int &uncertain_count,int &unknown_count,int &due_count)
  {
   open_count=0;
   closed_count=0;
   uncertain_count=0;
   unknown_count=0;
   due_count=0;
   for(int i=0;i<count;i++)
     {
      if(states[i].dirty || states[i].is_due_now)
         due_count++;
      switch(states[i].market_status)
        {
         case ASC_MARKET_OPEN: open_count++; break;
         case ASC_MARKET_CLOSED: closed_count++; break;
         case ASC_MARKET_UNCERTAIN: uncertain_count++; break;
         default: unknown_count++; break;
        }
     }
  }

void ASC_ExplorerSummaryCard(const ASC_ExplorerContext &ctx,const string id,const string title,const string line1,const string line2,const string line3,const int x,const int y,const int w,const int h,const color accent)
  {
   ASC_ExplorerRect(ctx,id + ".card",x,y,w,h,ctx.theme.panel_fill,ctx.theme.border);
   ASC_ExplorerRect(ctx,id + ".bar",x,y,6,h,accent,accent);
   ASC_ExplorerLabel(ctx,id + ".title",title,x+14,y+6,ctx.theme.text,10);
   ASC_ExplorerLabel(ctx,id + ".line1",line1,x+14,y+24,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,id + ".line2",line2,x+14,y+24+ctx.theme.row_height,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,id + ".line3",line3,x+14,y+24+(ctx.theme.row_height*2),ctx.theme.muted);
  }

void ASC_ExplorerRenderOverview(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count,const int x,const int y,const int w,const int h)
  {
   int gap=ctx.theme.gap;
   int card_w=(w-gap)/2;
   int card_h=(h-(gap*2))/3;
   int open_count=0,closed_count=0,uncertain_count=0,unknown_count=0,due_count=0;
   ASC_ExplorerCounts(states,count,open_count,closed_count,uncertain_count,unknown_count,due_count);

   ASC_ExplorerSummaryCard(ctx,"overview.identity","System Identity",ASC_PRODUCT_NAME,"Wrapper " + ASC_WRAPPER_VERSION + " | Explorer " + ASC_EXPLORER_SUBSYSTEM_VERSION,"Density " + ASC_ExplorerDensityText(settings.explorer_density_mode),x,y,card_w,card_h,ctx.theme.accent);
   ASC_ExplorerSummaryCard(ctx,"overview.runtime","Runtime","Mode " + ASC_RuntimeModeText(runtime.mode),"Heartbeat " + IntegerToString(runtime.heartbeats_since_boot),"Server " + runtime.server_clean,x+card_w+gap,y,card_w,card_h,ctx.theme.accent_alt);
   ASC_ExplorerSummaryCard(ctx,"overview.universe","Universe","Tracked symbols " + IntegerToString(count),"Open " + IntegerToString(open_count) + " | Closed " + IntegerToString(closed_count),"Uncertain " + IntegerToString(uncertain_count) + " | Unknown " + IntegerToString(unknown_count),x,y+card_h+gap,card_w,card_h,ctx.theme.accent);
   ASC_ExplorerSummaryCard(ctx,"overview.scheduler","Scheduler","Cursor " + IntegerToString(runtime.scheduler_cursor),"Due now " + IntegerToString(due_count),"Budget per beat " + IntegerToString(settings.symbol_budget_per_heartbeat),x+card_w+gap,y+card_h+gap,card_w,card_h,ctx.theme.accent_alt);
   ASC_ExplorerSummaryCard(ctx,"overview.health","Health and Attention","Recovery " + (runtime.recovery_used ? "Used" : "Fresh Start"),"Degraded " + ASC_BoolText(runtime.degraded),"Last heartbeat " + ASC_DateTimeText(runtime.last_heartbeat_at),x,y+(card_h+gap)*2,card_w,card_h,(runtime.degraded ? ctx.theme.warning : ctx.theme.accent));
   ASC_ExplorerSummaryCard(ctx,"overview.capability","Capability Progress","Market State Detection: Working","Later capability surfaces: Reserved","Explorer HUD v2 scaffold active",x+card_w+gap,y+(card_h+gap)*2,card_w,card_h,ctx.theme.reserved);
  }

void ASC_ExplorerRenderBucketList(ASC_ExplorerContext &ctx,const int x,const int y,const int w,const int h)
  {
   ASC_BucketViewModel buckets[];
   int total=ASC_GetBucketViewModels(buckets,ctx.nav.bucket_display_mode);
   int row_h=58;
   int visible=ASC_ExplorerVisibleRows(ctx,h-ctx.theme.title_height-ctx.theme.gap);
   int max_scroll=(total>visible ? total-visible : 0);
   if(ctx.nav.bucket_scroll<0) ctx.nav.bucket_scroll=0;
   if(ctx.nav.bucket_scroll>max_scroll) ctx.nav.bucket_scroll=max_scroll;

   ASC_ExplorerPanelTitle(ctx,"buckets.panel","Bucket List",x,y,w);
   ASC_ExplorerLabel(ctx,"buckets.note","Bucket cards now consume a dynamic view-model. Placeholder taxonomy remains honest until Symbol Identity and Bucketing activates.",x+ctx.theme.padding,y+ctx.theme.title_height+4,ctx.theme.muted);

   int start_y=y+ctx.theme.title_height+ctx.theme.row_height+ctx.theme.gap;
   for(int i=0;i<visible && (ctx.nav.bucket_scroll+i)<total;i++)
     {
      int idx=ctx.nav.bucket_scroll+i;
      int row_y=start_y+i*(row_h+ctx.theme.gap);
      color fill=(idx==ctx.nav.selected_bucket_index ? ctx.theme.selected_fill : ctx.theme.panel_fill);
      string count_text=IntegerToString(buckets[idx].resolved_symbol_count) + " refs | Mode " + ASC_BucketDisplayModeText(buckets[idx].display_mode);
      ASC_ExplorerRect(ctx,"buckets.row." + IntegerToString(idx),x,row_y,w,row_h,fill,ctx.theme.border);
      ASC_ExplorerLabel(ctx,"buckets.name." + IntegerToString(idx),buckets[idx].name,x+ctx.theme.padding,row_y+6,ctx.theme.text,10);
      ASC_ExplorerLabel(ctx,"buckets.family." + IntegerToString(idx),buckets[idx].family + " | " + buckets[idx].posture,x+ctx.theme.padding,row_y+24,ctx.theme.muted);
      ASC_ExplorerLabel(ctx,"buckets.count." + IntegerToString(idx),count_text,x+ctx.theme.padding,row_y+24+ctx.theme.row_height,ctx.theme.accent_alt);
      ASC_ExplorerButton(ctx,"action.bucket." + IntegerToString(idx),"Open",x+w-82,row_y+16,70,ctx.theme.button_height,ctx.theme.accent,false);
     }
  }

void ASC_ExplorerRenderBucketDetail(ASC_ExplorerContext &ctx,const int x,const int y,const int w,const int h)
  {
   ASC_BucketViewModel buckets[];
   int total=ASC_GetBucketViewModels(buckets,ctx.nav.bucket_display_mode);
   if(total<=0)
     {
      ASC_ExplorerRect(ctx,"bucket.detail.empty",x,y,w,h,ctx.theme.panel_fill,ctx.theme.border);
      ASC_ExplorerLabel(ctx,"bucket.detail.empty.title","Bucket Detail",x+ctx.theme.padding,y+8,ctx.theme.text,11);
      ASC_ExplorerLabel(ctx,"bucket.detail.empty.note","No bucket definitions are available yet.",x+ctx.theme.padding,y+32,ctx.theme.warning);
      return;
     }
   if(ctx.nav.selected_bucket_index<0 || ctx.nav.selected_bucket_index>=total)
      ctx.nav.selected_bucket_index=0;

   ASC_BucketViewModel bucket=buckets[ctx.nav.selected_bucket_index];
   int header_h=86;
   int toggle_h=42;
   int summary_h=138;
   int future_h=108;
   int symbol_area_y=y+header_h+ctx.theme.gap;
   int toggle_y=symbol_area_y;
   int lane_y=toggle_y+toggle_h+ctx.theme.gap;
   int summary_y=h+y-summary_h-future_h-ctx.theme.gap;
   int future_y=h+y-future_h;
   int lane_h=summary_y-lane_y-ctx.theme.gap;

   ASC_ExplorerRect(ctx,"bucket.detail.header",x,y,w,header_h,ctx.theme.panel_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"bucket.detail.title",bucket.name,x+ctx.theme.padding,y+8,ctx.theme.text,11);
   ASC_ExplorerLabel(ctx,"bucket.detail.family",bucket.family + " | " + bucket.posture + " | ID " + bucket.bucket_id,x+ctx.theme.padding,y+28,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,"bucket.detail.note",bucket.note,x+ctx.theme.padding,y+46,ctx.theme.reserved);
   ASC_ExplorerLabel(ctx,"bucket.detail.honesty","Bucket Detail is dynamic-ready only. Market State Detection remains the only active capability.",x+ctx.theme.padding,y+64,ctx.theme.warning);

   ASC_ExplorerRect(ctx,"bucket.detail.mode.strip",x,toggle_y,w,toggle_h,ctx.theme.section_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"bucket.detail.mode.label","Display Mode",x+ctx.theme.padding,toggle_y+12,ctx.theme.text,10);
   int mode_button_w=74;
   int mode_gap=ctx.theme.gap;
   int mode_x=x+120;
   ASC_ExplorerButton(ctx,"action.bucket_mode.top3","Top 3",mode_x,toggle_y+8,mode_button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.bucket_display_mode==ASC_BUCKET_DISPLAY_TOP_3));
   ASC_ExplorerButton(ctx,"action.bucket_mode.top5","Top 5",mode_x+mode_button_w+mode_gap,toggle_y+8,mode_button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.bucket_display_mode==ASC_BUCKET_DISPLAY_TOP_5));
   ASC_ExplorerButton(ctx,"action.bucket_mode.all","All",mode_x+((mode_button_w+mode_gap)*2),toggle_y+8,mode_button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.bucket_display_mode==ASC_BUCKET_DISPLAY_ALL));
   ASC_ExplorerLabel(ctx,"bucket.detail.mode.state","Visible now: " + IntegerToString(ASC_BucketDisplayLimit(bucket)) + " of " + IntegerToString(bucket.resolved_symbol_count) + " refs",x+w-220,toggle_y+12,ctx.theme.muted);

   ASC_ExplorerPanelTitle(ctx,"bucket.detail.symbols","Symbol Lane",x,lane_y,w);
   int visible=ASC_ExplorerVisibleRows(ctx,lane_h-ctx.theme.title_height-ctx.theme.gap);
   int display_count=ASC_BucketDisplayLimit(bucket);
   int lane_scrollable_count=(ctx.nav.bucket_display_mode==ASC_BUCKET_DISPLAY_ALL ? display_count : 0);
   int max_scroll=(lane_scrollable_count>visible ? lane_scrollable_count-visible : 0);
   if(ctx.nav.bucket_mode_scroll<0) ctx.nav.bucket_mode_scroll=0;
   if(ctx.nav.bucket_mode_scroll>max_scroll) ctx.nav.bucket_mode_scroll=max_scroll;
   if(ctx.nav.bucket_display_mode!=ASC_BUCKET_DISPLAY_ALL)
      ctx.nav.bucket_mode_scroll=0;
   int list_y=lane_y+ctx.theme.title_height+ctx.theme.gap;
   for(int i=0;i<visible && (ctx.nav.bucket_mode_scroll+i)<display_count;i++)
     {
      int row=ctx.nav.bucket_mode_scroll+i;
      int row_y=list_y+i*(46+ctx.theme.gap);
      ASC_ExplorerRect(ctx,"bucket.detail.seed." + IntegerToString(row),x,row_y,w,46,ctx.theme.panel_alt_fill,ctx.theme.border);
      ASC_ExplorerLabel(ctx,"bucket.detail.seed.sym." + IntegerToString(row),bucket.symbol_refs[row],x+ctx.theme.padding,row_y+8,ctx.theme.text,10);
      ASC_ExplorerLabel(ctx,"bucket.detail.seed.note." + IntegerToString(row),bucket.symbol_notes[row],x+ctx.theme.padding,row_y+24,ctx.theme.muted);
      ASC_ExplorerButton(ctx,"action.seed_symbol." + IntegerToString(row),"Inspect",x+w-82,row_y+11,70,ctx.theme.button_height,ctx.theme.accent,false);
     }

   ASC_ExplorerPanelTitle(ctx,"bucket.detail.summary","Bucket Summary",x,summary_y,w);
   ASC_ExplorerInfoRow(ctx,"bucket.detail.summary1","Family",bucket.family, x,summary_y+ctx.theme.title_height+ctx.theme.gap,w);
   ASC_ExplorerInfoRow(ctx,"bucket.detail.summary2","Resolved References",IntegerToString(bucket.resolved_symbol_count),x,summary_y+ctx.theme.title_height+ctx.theme.gap+26,w);
   ASC_ExplorerInfoRow(ctx,"bucket.detail.summary3","Visible Window",IntegerToString(display_count) + " in " + ASC_BucketDisplayModeText(ctx.nav.bucket_display_mode),x,summary_y+ctx.theme.title_height+ctx.theme.gap+52,w);
   ASC_ExplorerInfoRow(ctx,"bucket.detail.summary4","Membership Truth","Canonical references only until live identity resolution is active",x,summary_y+ctx.theme.title_height+ctx.theme.gap+78,w);
   ASC_ExplorerInfoRow(ctx,"bucket.detail.summary5","Scroll State",(ctx.nav.bucket_display_mode==ASC_BUCKET_DISPLAY_ALL ? ("All-mode scroll row " + IntegerToString(ctx.nav.bucket_mode_scroll)) : "Top modes pin the lane without scroll"),x,summary_y+ctx.theme.title_height+ctx.theme.gap+104,w);

   ASC_ExplorerPanelTitle(ctx,"bucket.detail.future","Reserved Future Layer Strip",x,future_y,w);
   ASC_ExplorerInfoRow(ctx,"bucket.detail.future1","Open Symbol Snapshot","Reserved insertion point only",x,future_y+ctx.theme.title_height+ctx.theme.gap,w);
   ASC_ExplorerInfoRow(ctx,"bucket.detail.future2","Candidate Filtering / Shortlist","Reserved insertion point only",x,future_y+ctx.theme.title_height+ctx.theme.gap+26,w);
   ASC_ExplorerInfoRow(ctx,"bucket.detail.future3","Deep / Combined / Aurora","Reserved insertion point only",x,future_y+ctx.theme.title_height+ctx.theme.gap+52,w);
  }

void ASC_ExplorerSectionPanel(const ASC_ExplorerContext &ctx,const string id,const string title,const string l1,const string l2,const string l3,const int x,const int y,const int w,const int h,const bool selected,const color accent)
  {
   color stripe=(accent==C'0,0,0' ? ctx.theme.accent : accent);
   ASC_ExplorerRect(ctx,id + ".panel",x,y,w,h,(selected ? ctx.theme.selected_fill : ctx.theme.panel_fill),ctx.theme.border);
   ASC_ExplorerRect(ctx,id + ".stripe",x,y,6,h,stripe,stripe);
   ASC_ExplorerLabel(ctx,id + ".title",title,x+14,y+6,ctx.theme.text,10);
   ASC_ExplorerLabel(ctx,id + ".l1",l1,x+14,y+24,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,id + ".l2",l2,x+14,y+24+ctx.theme.row_height,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,id + ".l3",l3,x+14,y+24+(ctx.theme.row_height*2),ctx.theme.muted);
  }

void ASC_ExplorerRenderSymbolDetail(ASC_ExplorerContext &ctx,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count,const int x,const int y,const int w,const int h)
  {
   if(count<=0 || ctx.nav.selected_symbol_index<0 || ctx.nav.selected_symbol_index>=count)
     {
      ASC_ExplorerRect(ctx,"symbol.seed.panel",x,y,w,h,ctx.theme.panel_fill,ctx.theme.border);
      ASC_ExplorerLabel(ctx,"symbol.seed.title","Symbol Detail",x+ctx.theme.padding,y+8,ctx.theme.text,11);
      ASC_ExplorerLabel(ctx,"symbol.seed.text","Live symbol detail is not available for the selected bucket seed yet.",x+ctx.theme.padding,y+32,ctx.theme.warning);
      ASC_ExplorerInfoRow(ctx,"symbol.seed.row1","Identity",(ctx.nav.selected_seed_symbol=="" ? "Seed Pending" : ctx.nav.selected_seed_symbol),x+ctx.theme.padding,y+62,w-(ctx.theme.padding*2));
      ASC_ExplorerInfoRow(ctx,"symbol.seed.row2","Market State","Live Layer 1 state appears here only when the selected seed resolves to a tracked symbol",x+ctx.theme.padding,y+88,w-(ctx.theme.padding*2));
      ASC_ExplorerInfoRow(ctx,"symbol.seed.row3","Runtime and Publication","This shell keeps the publication and dossier lane visible without fabricating data",x+ctx.theme.padding,y+114,w-(ctx.theme.padding*2));
      ASC_ExplorerInfoRow(ctx,"symbol.seed.row4","Future Surfaces","Once Symbol Identity and Bucketing is active, this route will resolve without fallback",x+ctx.theme.padding,y+140,w-(ctx.theme.padding*2));
      return;
     }

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
   double spread_value=(ask>=bid ? (ask-bid) : 0.0);
   string spread_text=(spread_points>0 ? IntegerToString((int)spread_points) + " points" : (point>0.0 ? DoubleToString(spread_value/point,1) + " points" : DoubleToString(spread_value,digits)));

   int gap=ctx.theme.gap;
   int section_w=(w-gap)/2;
   int section_h=(h-(gap*2))/3;
   if(ctx.nav.symbol_scroll<0)
      ctx.nav.symbol_scroll=0;
   if(ctx.nav.symbol_scroll>1)
      ctx.nav.symbol_scroll=1;
   int base_y=y-(ctx.nav.symbol_scroll*(section_h/2));

   ASC_ExplorerSectionPanel(ctx,"symbol.identity","Identity","Symbol " + state.symbol,"Server " + runtime.server_clean,"Bucket detail shell active",x,base_y,section_w,section_h,(ctx.nav.selected_stat_view==ASC_EXPLORER_STAT_IDENTITY),ctx.theme.accent);
   ASC_ExplorerSectionPanel(ctx,"symbol.market","Market State",ASC_MarketStatusText(state.market_status),state.status_note,"Next check " + ASC_DateTimeText(state.next_check_at),x+section_w+gap,base_y,section_w,section_h,(ctx.nav.selected_stat_view==ASC_EXPLORER_STAT_MARKET_STATE),ctx.theme.accent_alt);
   ASC_ExplorerSectionPanel(ctx,"symbol.quote","Tick and Quote","Bid " + DoubleToString(bid,digits),"Ask " + DoubleToString(ask,digits),"Spread " + spread_text,x,base_y+section_h+gap,section_w,section_h,(ctx.nav.selected_stat_view==ASC_EXPLORER_STAT_TICK_QUOTE),ctx.theme.accent);
   ASC_ExplorerSectionPanel(ctx,"symbol.runtime","Runtime and Publication","Heartbeat " + ASC_DateTimeText(runtime.last_heartbeat_at),"Last write " + ASC_DateTimeText(state.last_dossier_write_at),"Publication " + (state.publication_ok ? "Promoted" : "Pending"),x+section_w+gap,base_y+section_h+gap,section_w,section_h,(ctx.nav.selected_stat_view==ASC_EXPLORER_STAT_RUNTIME_PUBLICATION),ctx.theme.accent_alt);
   ASC_ExplorerSectionPanel(ctx,"symbol.future","Future Surfaces","Identity and bucketing reserved","Snapshot / shortlist / deep reserved","Signal surface reserved",x,base_y+(section_h+gap)*2,w,section_h,(ctx.nav.selected_stat_view==ASC_EXPLORER_STAT_FUTURE_SURFACES),ctx.theme.reserved);

   ASC_ExplorerButton(ctx,"action.stat.identity","Identity",x+section_w-84,base_y+section_h-30,74,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   ASC_ExplorerButton(ctx,"action.stat.market","State",x+w-84,base_y+section_h-30,74,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   ASC_ExplorerButton(ctx,"action.stat.quote","Quote",x+section_w-84,base_y+section_h+gap+section_h-30,74,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   ASC_ExplorerButton(ctx,"action.stat.runtime","Runtime",x+w-84,base_y+section_h+gap+section_h-30,74,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   ASC_ExplorerButton(ctx,"action.stat.future","Future",x+w-84,base_y+(section_h+gap)*2+section_h-30,74,ctx.theme.button_height,ctx.theme.panel_alt_fill);

   ASC_ExplorerLabel(ctx,"symbol.tick.meta","Day High " + DoubleToString(day_high,digits) + " | Day Low " + DoubleToString(day_low,digits) + " | Market Watch Update " + (have_tick ? ASC_DateTimeText((datetime)tick.time) : "Not Yet Available"),x+ctx.theme.padding,base_y+(section_h+gap)*2+section_h-18,ctx.theme.muted);
  }

void ASC_ExplorerRenderStatDetail(ASC_ExplorerContext &ctx,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count,const int x,const int y,const int w,const int h)
  {
   ASC_ExplorerRect(ctx,"stat.panel",x,y,w,h,ctx.theme.panel_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"stat.title","Stat Detail",x+ctx.theme.padding,y+8,ctx.theme.text,11);
   ASC_ExplorerLabel(ctx,"stat.subtitle",ASC_ExplorerStatText(ctx.nav.selected_stat_view),x+ctx.theme.padding,y+28,ctx.theme.muted);
   int info_top=y+58;
   int visible=ASC_ExplorerVisibleRows(ctx,h-92);
   if(visible>4)
      visible=4;
   int max_scroll=(4>visible ? 4-visible : 0);
   if(ctx.nav.stat_scroll<0)
      ctx.nav.stat_scroll=0;
   if(ctx.nav.stat_scroll>max_scroll)
      ctx.nav.stat_scroll=max_scroll;

   if(count<=0 || ctx.nav.selected_symbol_index<0 || ctx.nav.selected_symbol_index>=count)
     {
      ASC_ExplorerLabel(ctx,"stat.empty","Live stat detail is not available for the selected seed symbol yet.",x+ctx.theme.padding,y+48,ctx.theme.warning);
      ASC_ExplorerInfoRow(ctx,"stat.seed.row1","Seed Symbol",(ctx.nav.selected_seed_symbol=="" ? "Seed Pending" : ctx.nav.selected_seed_symbol),x+ctx.theme.padding,y+78,w-(ctx.theme.padding*2));
      ASC_ExplorerInfoRow(ctx,"stat.seed.row2","Current Scope","Stat Detail shell is active; deeper resolution remains reserved",x+ctx.theme.padding,y+104,w-(ctx.theme.padding*2));
      return;
     }

   ASC_SymbolState state=states[ctx.nav.selected_symbol_index];
   string line1="";
   string line2="";
   string line3="";
   string line4="";

   switch(ctx.nav.selected_stat_view)
     {
      case ASC_EXPLORER_STAT_IDENTITY:
         line1="Symbol " + state.symbol;
         line2="Server " + runtime.server_clean;
         line3="Bucket identity remains reserved until Symbol Identity and Bucketing activates.";
         line4="This shell preserves the later insertion point without faking classification.";
         break;
      case ASC_EXPLORER_STAT_MARKET_STATE:
         line1="Market Status " + ASC_MarketStatusText(state.market_status);
         line2="Session State " + (state.within_trade_session ? "Inside broker trade session" : (state.has_trade_sessions ? "Outside broker trade session" : "Session data unavailable"));
         line3="Next Check " + ASC_DateTimeText(state.next_check_at);
         line4="Reason " + state.next_check_reason;
         break;
      case ASC_EXPLORER_STAT_TICK_QUOTE:
         line1="Tick Present " + ASC_BoolText(state.has_tick);
         line2="Tick Age " + (state.tick_age_seconds>=0 ? IntegerToString((int)state.tick_age_seconds) + " seconds" : "Not Yet Available");
         line3="Market Watch detail remains safe and lightweight in Layer 1.";
         line4="No heavy history pulls are performed from the explorer.";
         break;
      case ASC_EXPLORER_STAT_RUNTIME_PUBLICATION:
         line1="Runtime Mode " + ASC_RuntimeModeText(runtime.mode);
         line2="Last Heartbeat " + ASC_DateTimeText(runtime.last_heartbeat_at);
         line3="Publication " + (state.publication_ok ? "Current dossier write promoted" : "Awaiting a successful dossier promotion");
         line4="Last Dossier Write " + ASC_DateTimeText(state.last_dossier_write_at);
         break;
      default:
         line1="Future capability surfaces remain placeholder-only.";
         line2="Open Symbol Snapshot, Candidate Filtering, Shortlist Selection, and Deep Selective Analysis are not active here.";
         line3="Combined Opportunity Summary and Future Signal Surface remain reserved.";
         line4="This page exists now to keep the explorer path complete and future-safe.";
         break;
     }

   for(int row=0;row<visible && (ctx.nav.stat_scroll+row)<4;row++)
     {
      int idx=ctx.nav.stat_scroll+row;
      string detail_value="";
      if(idx==0)
         detail_value=line1;
      else if(idx==1)
         detail_value=line2;
      else if(idx==2)
         detail_value=line3;
      else
         detail_value=line4;
      ASC_ExplorerInfoRow(ctx,"stat.line" + IntegerToString(idx),"Detail",detail_value,x+ctx.theme.padding,info_top+(row*26),w-(ctx.theme.padding*2));
     }
  }

void ASC_ExplorerRenderHeader(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,const int chart_w)
  {
   ASC_ExplorerRect(ctx,"header.strip",ctx.theme.margin,ctx.theme.margin,chart_w-(ctx.theme.margin*2),ctx.theme.header_height,ctx.theme.header_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"header.main",ASC_PRODUCT_NAME + " — Explorer Console",ctx.theme.margin+ctx.theme.padding,ctx.theme.margin+6,ctx.theme.text,12);
   ASC_ExplorerLabel(ctx,"header.sub","Wrapper " + ASC_WRAPPER_VERSION + " | Explorer " + ASC_EXPLORER_SUBSYSTEM_VERSION + " | Active " + ASC_ACTIVE_CAPABILITY + " | Next " + ASC_NEXT_CAPABILITY,ctx.theme.margin+ctx.theme.padding,ctx.theme.margin+24,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,"header.time","Server " + runtime.server_clean + " | Time " + ASC_DateTimeText(TimeTradeServer()) + " | Density " + ASC_ExplorerDensityText(settings.explorer_density_mode),chart_w-360,ctx.theme.margin+16,ctx.theme.muted);
  }

void ASC_ExplorerRenderNavStrip(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,ASC_SymbolState &states[],const int count,const int chart_w)
  {
   int y=ctx.theme.margin+ctx.theme.header_height+ctx.theme.gap;
   ASC_ExplorerRect(ctx,"nav.strip",ctx.theme.margin,y,chart_w-(ctx.theme.margin*2),ctx.theme.nav_height,ctx.theme.panel_alt_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"nav.current","Current View: " + ASC_ExplorerViewText(ctx.nav.current_view),ctx.theme.margin+ctx.theme.padding,y+7,ctx.theme.text);
   if(settings.explorer_show_breadcrumbs)
      ASC_ExplorerLabel(ctx,"nav.breadcrumb",ASC_ExplorerBreadcrumbText(ctx,states,count),ctx.theme.margin+170,y+7,ctx.theme.muted);
  }

void ASC_ExplorerRenderControlRail(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,ASC_SymbolState &states[],const int count,const int x,const int y,const int w,const int h)
  {
   ASC_ExplorerRect(ctx,"rail.panel",x,y,w,h,ctx.theme.rail_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"rail.title","Control Rail",x+ctx.theme.padding,y+8,ctx.theme.text,10);
   int button_y=y+28;
   int button_gap=ctx.theme.gap;
   ASC_ExplorerButton(ctx,"action.home","Home",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.accent,(ctx.nav.current_view==ASC_EXPLORER_VIEW_OVERVIEW));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.back","Back",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.panel_alt_fill);
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.overview","Overview",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.current_view==ASC_EXPLORER_VIEW_OVERVIEW));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.buckets","Buckets",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.current_view==ASC_EXPLORER_VIEW_BUCKETS));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.bucket_detail","Bucket Detail",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.current_view==ASC_EXPLORER_VIEW_BUCKET_DETAIL));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.symbol_detail","Symbol",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.current_view==ASC_EXPLORER_VIEW_SYMBOL_DETAIL));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.stat_detail","Stat Detail",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.current_view==ASC_EXPLORER_VIEW_STAT_DETAIL));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.density","Density",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.panel_alt_fill);
   button_y+=ctx.theme.button_height+(button_gap*2);
   ASC_ExplorerButton(ctx,"action.scroll_up","Scroll Up",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.panel_alt_fill);
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.scroll_down","Scroll Down",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.panel_alt_fill);
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.refresh","Refresh",x+ctx.theme.padding,button_y,w-(ctx.theme.padding*2),ctx.theme.button_height,ctx.theme.panel_alt_fill);
   button_y+=ctx.theme.button_height+(button_gap*2);
   ASC_ExplorerLabel(ctx,"rail.state","Path",x+ctx.theme.padding,button_y,ctx.theme.text,10);
   ASC_ExplorerLabel(ctx,"rail.state.value",ASC_ExplorerBreadcrumbText(ctx,states,count),x+ctx.theme.padding,button_y+18,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,"rail.density","Density " + ASC_ExplorerDensityText(settings.explorer_density_mode),x+ctx.theme.padding,button_y+42,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,"rail.bucketmode","Bucket Mode " + ASC_BucketDisplayModeText(ctx.nav.bucket_display_mode),x+ctx.theme.padding,button_y+60,ctx.theme.muted);
  }

void ASC_ExplorerRenderStatusStrip(ASC_ExplorerContext &ctx,const ASC_RuntimeState &runtime,const int x,const int y,const int w)
  {
   string status_text=(runtime.degraded ? "Attention: bounded work remains active; some symbols are queued for the next heartbeat." : "Runtime is within the current bounded-work budget.");
   ASC_ExplorerRect(ctx,"status.strip",x,y,w,ctx.theme.status_height,ctx.theme.panel_alt_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"status.text",status_text,x+ctx.theme.padding,y+7,(runtime.degraded ? ctx.theme.warning : ctx.theme.muted));
  }

void ASC_ExplorerRender(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count)
  {
   if(!settings.explorer_enabled)
      return;

   int chart_w=(int)ChartGetInteger(ctx.chart_id,CHART_WIDTH_IN_PIXELS,0);
   int chart_h=(int)ChartGetInteger(ctx.chart_id,CHART_HEIGHT_IN_PIXELS,0);
   if(chart_w<760 || chart_h<520)
      return;

   ASC_ExplorerThemeDefaults(ctx.theme,settings.explorer_density_mode);
   ASC_ExplorerDeleteOwnedObjects(ctx);
   ASC_ExplorerRect(ctx,"root",ctx.theme.margin,ctx.theme.margin,chart_w-(ctx.theme.margin*2),chart_h-(ctx.theme.margin*2),ctx.theme.background,ctx.theme.border);
   ASC_ExplorerRenderHeader(ctx,settings,runtime,chart_w);
   ASC_ExplorerRenderNavStrip(ctx,settings,states,count,chart_w);

   int main_x=ctx.theme.margin+ctx.theme.padding;
   int main_y=ctx.theme.margin+ctx.theme.header_height+ctx.theme.nav_height+(ctx.theme.gap*2);
   int main_h=chart_h-main_y-ctx.theme.status_height-ctx.theme.margin-(ctx.theme.gap*2);
   int rail_x=chart_w-ctx.theme.margin-ctx.theme.rail_width;
   int rail_y=main_y;
   int rail_h=main_h;
   int content_w=rail_x-main_x-ctx.theme.gap;

   ASC_ExplorerRenderControlRail(ctx,settings,states,count,rail_x,rail_y,ctx.theme.rail_width,rail_h);

   switch(ctx.nav.current_view)
     {
      case ASC_EXPLORER_VIEW_BUCKETS:
         ASC_ExplorerRenderBucketList(ctx,main_x,main_y,content_w,main_h);
         break;
      case ASC_EXPLORER_VIEW_BUCKET_DETAIL:
         ASC_ExplorerRenderBucketDetail(ctx,main_x,main_y,content_w,main_h);
         break;
      case ASC_EXPLORER_VIEW_SYMBOL_DETAIL:
         ASC_ExplorerRenderSymbolDetail(ctx,runtime,states,count,main_x,main_y,content_w,main_h);
         break;
      case ASC_EXPLORER_VIEW_STAT_DETAIL:
         ASC_ExplorerRenderStatDetail(ctx,runtime,states,count,main_x,main_y,content_w,main_h);
         break;
      default:
         ASC_ExplorerRenderOverview(ctx,settings,runtime,states,count,main_x,main_y,content_w,main_h);
         break;
     }

   ASC_ExplorerRenderStatusStrip(ctx,runtime,main_x,main_y+main_h+ctx.theme.gap,chart_w-(ctx.theme.margin*2)-(ctx.theme.padding*2));
   ChartRedraw(ctx.chart_id);
   ctx.nav.last_render_at=TimeCurrent();
   ctx.nav.dirty=false;
  }

void ASC_ExplorerInit(ASC_ExplorerContext &ctx,const long chart_id)
  {
   ctx.chart_id=chart_id;
   ctx.prefix=ASC_HUD_PREFIX;
   ASC_ExplorerThemeDefaults(ctx.theme,1);
   ctx.nav.current_view=ASC_EXPLORER_VIEW_OVERVIEW;
   ctx.nav.history_count=0;
   ctx.nav.bucket_scroll=0;
   ctx.nav.bucket_detail_scroll=0;
   ctx.nav.symbol_scroll=0;
   ctx.nav.stat_scroll=0;
   ctx.nav.bucket_mode_scroll=0;
   ctx.nav.selected_bucket_index=0;
   ctx.nav.selected_symbol_index=-1;
   ctx.nav.bucket_display_mode=ASC_BUCKET_DISPLAY_TOP_3;
   ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_NONE;
   ctx.nav.selected_seed_symbol="";
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

void ASC_ExplorerAdjustScroll(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const int direction)
  {
   int step=(settings.explorer_scroll_step_rows>0 ? settings.explorer_scroll_step_rows : 1);
   switch(ctx.nav.current_view)
     {
      case ASC_EXPLORER_VIEW_BUCKETS:
         ctx.nav.bucket_scroll+=direction*step;
         break;
      case ASC_EXPLORER_VIEW_BUCKET_DETAIL:
         if(ctx.nav.bucket_display_mode==ASC_BUCKET_DISPLAY_ALL)
            ctx.nav.bucket_mode_scroll+=direction*step;
         else
            ctx.nav.bucket_detail_scroll+=direction*step;
         break;
      case ASC_EXPLORER_VIEW_SYMBOL_DETAIL:
         ctx.nav.symbol_scroll+=direction*step;
         break;
      case ASC_EXPLORER_VIEW_STAT_DETAIL:
         ctx.nav.stat_scroll+=direction*step;
         break;
      default:
         break;
     }
   ctx.nav.dirty=true;
  }

void ASC_ExplorerHandleAction(ASC_ExplorerContext &ctx,ASC_RuntimeSettings &settings,const string object_name,ASC_SymbolState &states[],const int count,ASC_Logger &logger)
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
   else if(action=="action.bucket_detail")
     {
      ctx.nav.selected_seed_symbol="";
      ctx.nav.selected_symbol_index=-1;
      ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_NONE;
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_BUCKET_DETAIL);
     }
   else if(action=="action.symbol_detail")
     {
      if(ctx.nav.selected_symbol_index>=0 || ctx.nav.selected_seed_symbol!="")
         ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_SYMBOL_DETAIL);
      else
         ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_BUCKET_DETAIL);
     }
   else if(action=="action.stat_detail")
     {
      if(ctx.nav.selected_stat_view!=ASC_EXPLORER_STAT_NONE)
         ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_STAT_DETAIL);
      else if(ctx.nav.selected_symbol_index>=0 || ctx.nav.selected_seed_symbol!="")
         ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_SYMBOL_DETAIL);
      else
         ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_BUCKET_DETAIL);
     }
   else if(action=="action.scroll_up")
      ASC_ExplorerAdjustScroll(ctx,settings,-1);
   else if(action=="action.scroll_down")
      ASC_ExplorerAdjustScroll(ctx,settings,1);
   else if(action=="action.refresh")
      ctx.nav.dirty=true;
   else if(action=="action.density")
     {
      settings.explorer_density_mode=(settings.explorer_density_mode>=2 ? 0 : settings.explorer_density_mode+1);
      ctx.nav.dirty=true;
     }
   else if(action=="action.bucket_mode.top3")
     {
      ctx.nav.bucket_display_mode=ASC_BUCKET_DISPLAY_TOP_3;
      ctx.nav.bucket_mode_scroll=0;
      ctx.nav.bucket_detail_scroll=0;
      ctx.nav.dirty=true;
     }
   else if(action=="action.bucket_mode.top5")
     {
      ctx.nav.bucket_display_mode=ASC_BUCKET_DISPLAY_TOP_5;
      ctx.nav.bucket_mode_scroll=0;
      ctx.nav.bucket_detail_scroll=0;
      ctx.nav.dirty=true;
     }
   else if(action=="action.bucket_mode.all")
     {
      ctx.nav.bucket_display_mode=ASC_BUCKET_DISPLAY_ALL;
      ctx.nav.bucket_mode_scroll=0;
      ctx.nav.bucket_detail_scroll=0;
      ctx.nav.dirty=true;
     }
   else if(StringFind(action,"action.bucket.")==0)
     {
      ctx.nav.selected_bucket_index=(int)StringToInteger(StringSubstr(action,StringLen("action.bucket.")));
      ctx.nav.bucket_detail_scroll=0;
      ctx.nav.bucket_mode_scroll=0;
      ctx.nav.selected_seed_symbol="";
      ctx.nav.selected_symbol_index=-1;
      ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_NONE;
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_BUCKET_DETAIL);
     }
   else if(StringFind(action,"action.seed_symbol.")==0)
     {
      int seed_index=(int)StringToInteger(StringSubstr(action,StringLen("action.seed_symbol.")));
      ASC_BucketViewModel bucket_views[];
      int bucket_total=ASC_GetBucketViewModels(bucket_views,ctx.nav.bucket_display_mode);
      if(ctx.nav.selected_bucket_index<0 || ctx.nav.selected_bucket_index>=bucket_total)
         return;
      int display_count=ASC_BucketDisplayLimit(bucket_views[ctx.nav.selected_bucket_index]);
      if(seed_index<0 || seed_index>=display_count)
         return;
      string desired=bucket_views[ctx.nav.selected_bucket_index].symbol_refs[seed_index];
      int match=-1;
      for(int i=0;i<count;i++)
        {
         if(states[i].symbol==desired)
           {
            match=i;
            break;
           }
        }
      ctx.nav.selected_symbol_index=match;
      ctx.nav.selected_seed_symbol=desired;
      ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_IDENTITY;
      ctx.nav.symbol_scroll=0;
      ctx.nav.stat_scroll=0;
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_SYMBOL_DETAIL);
     }
   else if(action=="action.stat.identity")
     {
      ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_IDENTITY;
      ctx.nav.stat_scroll=0;
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_STAT_DETAIL);
     }
   else if(action=="action.stat.market")
     {
      ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_MARKET_STATE;
      ctx.nav.stat_scroll=0;
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_STAT_DETAIL);
     }
   else if(action=="action.stat.quote")
     {
      ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_TICK_QUOTE;
      ctx.nav.stat_scroll=0;
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_STAT_DETAIL);
     }
   else if(action=="action.stat.runtime")
     {
      ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_RUNTIME_PUBLICATION;
      ctx.nav.stat_scroll=0;
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_STAT_DETAIL);
     }
   else if(action=="action.stat.future")
     {
      ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_FUTURE_SURFACES;
      ctx.nav.stat_scroll=0;
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_STAT_DETAIL);
     }
   else
      return;

   logger.Debug("Explorer","action " + action + " dispatched");
  }

#endif
