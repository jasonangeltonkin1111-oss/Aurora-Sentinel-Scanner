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
   color panel_soft_fill;
   color section_fill;
   color accent;
   color accent_alt;
   color good;
   color warning;
   color danger;
   color reserved;
   color text;
   color muted;
   color dim;
   color border;
   color rail_fill;
   color selected_fill;
   color selected_soft_fill;
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
   int history_bucket_page[24];
   int history_bucket_symbol_page[24];
   int history_market_filter[24];
   int history_count;
   int bucket_scroll;
   int bucket_detail_scroll;
   int symbol_scroll;
   int stat_scroll;
   int bucket_mode_scroll;
   int bucket_page;
   int bucket_symbol_page;
   int selected_bucket_index;
   int selected_symbol_index;
   ASC_ExplorerBucketDisplayMode bucket_display_mode;
   ASC_ExplorerMarketFilter market_filter;
   ASC_ExplorerStatView selected_stat_view;
   string selected_seed_symbol;
   bool dirty;
   datetime last_render_at;
   long last_render_duration_ms;
   long last_page_switch_action_to_render_ms;
   long pending_page_switch_started_ms;
   bool pending_page_switch_timing;
   string pending_page_switch_action;
  };

struct ASC_ExplorerContext
  {
   long chart_id;
   string prefix;
   ASC_ExplorerTheme theme;
   ASC_ExplorerNavState nav;
   bool initialized;
   string frame_objects[];
   string previous_frame_objects[];
  };

void ASC_ExplorerThemeDefaults(ASC_ExplorerTheme &theme,const int density_mode)
  {
   theme.margin=10;
   theme.gap=(density_mode<=0 ? 6 : 8);
   theme.padding=(density_mode<=0 ? 7 : (density_mode>=2 ? 10 : 8));
   theme.header_height=(density_mode>=2 ? 118 : 108);
   theme.nav_height=(density_mode>=2 ? 34 : 30);
   theme.status_height=(density_mode>=2 ? 32 : 28);
   theme.rail_width=(density_mode>=2 ? 154 : 146);
   theme.row_height=(density_mode<=0 ? 16 : (density_mode>=2 ? 20 : 18));
   theme.title_height=(density_mode>=2 ? 30 : 26);
   theme.button_height=(density_mode>=2 ? 26 : 24);
   theme.background=C'7,12,20';
   theme.header_fill=C'14,22,35';
   theme.panel_fill=C'18,27,40';
   theme.panel_alt_fill=C'26,39,58';
   theme.panel_soft_fill=C'12,19,31';
   theme.section_fill=C'10,17,28';
   theme.accent=C'76,173,255';
   theme.accent_alt=C'97,143,224';
   theme.good=C'88,204,144';
   theme.warning=C'224,181,90';
   theme.danger=C'232,112,98';
   theme.reserved=C'104,112,136';
   theme.text=clrWhite;
   theme.muted=C'196,204,219';
   theme.dim=C'146,155,174';
   theme.border=C'56,73,98';
   theme.rail_fill=C'13,20,31';
   theme.selected_fill=C'35,60,88';
   theme.selected_soft_fill=C'24,47,70';
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

bool ASC_ExplorerObjectTracked(const string &objects[],const string name)
  {
   for(int i=0;i<ArraySize(objects);i++)
     {
      if(objects[i]==name)
         return(true);
     }
   return(false);
  }

void ASC_ExplorerBeginFrame(ASC_ExplorerContext &ctx)
  {
   int total=ArraySize(ctx.frame_objects);
   ArrayResize(ctx.previous_frame_objects,total);
   for(int i=0;i<total;i++)
      ctx.previous_frame_objects[i]=ctx.frame_objects[i];
   ArrayResize(ctx.frame_objects,0);
  }

void ASC_ExplorerTouchObject(ASC_ExplorerContext &ctx,const string name)
  {
   if(ASC_ExplorerObjectTracked(ctx.frame_objects,name))
      return;
   int slot=ArraySize(ctx.frame_objects);
   ArrayResize(ctx.frame_objects,slot+1);
   ctx.frame_objects[slot]=name;
  }

void ASC_ExplorerEndFrame(ASC_ExplorerContext &ctx)
  {
   for(int i=0;i<ArraySize(ctx.previous_frame_objects);i++)
     {
      if(!ASC_ExplorerObjectTracked(ctx.frame_objects,ctx.previous_frame_objects[i]))
         ObjectDelete(ctx.chart_id,ctx.previous_frame_objects[i]);
     }
   ArrayResize(ctx.previous_frame_objects,0);
  }

bool ASC_ExplorerEnsureObject(ASC_ExplorerContext &ctx,const string name,const ENUM_OBJECT object_type)
  {
   if(ObjectFind(ctx.chart_id,name)>=0)
     {
      ENUM_OBJECT existing=(ENUM_OBJECT)ObjectGetInteger(ctx.chart_id,name,OBJPROP_TYPE);
      if(existing==object_type)
        {
         ASC_ExplorerTouchObject(ctx,name);
         return(true);
        }
      ObjectDelete(ctx.chart_id,name);
     }
   if(!ObjectCreate(ctx.chart_id,name,object_type,0,0,0))
      return(false);
   ASC_ExplorerTouchObject(ctx,name);
   return(true);
  }

bool ASC_ExplorerRect(ASC_ExplorerContext &ctx,const string id,const int x,const int y,const int w,const int h,const color fill,const color border)
  {
   string name=ASC_ExplorerObjectName(ctx,id);
   if(!ASC_ExplorerEnsureObject(ctx,name,OBJ_RECTANGLE_LABEL))
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

bool ASC_ExplorerLabel(ASC_ExplorerContext &ctx,const string id,const string text,const int x,const int y,const color text_color,const int font_size=9)
  {
   string name=ASC_ExplorerObjectName(ctx,id);
   if(!ASC_ExplorerEnsureObject(ctx,name,OBJ_LABEL))
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

bool ASC_ExplorerButton(ASC_ExplorerContext &ctx,const string id,const string text,const int x,const int y,const int w,const int h,const color fill,const bool selected=false)
  {
   string name=ASC_ExplorerObjectName(ctx,id);
   if(!ASC_ExplorerEnsureObject(ctx,name,OBJ_BUTTON))
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

int ASC_ExplorerApproxChars(const int pixel_width,const int font_size)
  {
   int divisor=(font_size>=11 ? 8 : 7);
   int chars=(pixel_width/divisor);
   if(chars<4)
      chars=4;
   return(chars);
  }

string ASC_ExplorerFitText(const string value,const int pixel_width,const int font_size=9)
  {
   string clean=value;
   StringReplace(clean,"\r"," ");
   StringReplace(clean,"\n"," ");
   int limit=ASC_ExplorerApproxChars(pixel_width,font_size);
   int length=(int)StringLen(clean);
   if(length<=limit)
      return(clean);
   if(limit<=3)
      return("...");
   return(StringSubstr(clean,0,limit-3) + "...");
  }

string ASC_ExplorerMarketFilterText(const ASC_ExplorerMarketFilter filter)
  {
   return(filter==ASC_EXPLORER_FILTER_OPEN_ONLY ? "Open Only" : "All Symbols");
  }

color ASC_ExplorerStatusAccent(const ASC_ExplorerContext &ctx,const ASC_MarketStatus status,const bool resolved)
  {
   if(!resolved)
      return(ctx.theme.reserved);
   if(status==ASC_MARKET_OPEN)
      return(ctx.theme.good);
   if(status==ASC_MARKET_CLOSED)
      return(ctx.theme.warning);
   if(status==ASC_MARKET_UNCERTAIN)
      return(ctx.theme.danger);
   return(ctx.theme.reserved);
  }

void ASC_ExplorerPanelTitle(ASC_ExplorerContext &ctx,const string id,const string title,const int x,const int y,const int w,const color stripe)
  {
   ASC_ExplorerRect(ctx,id + ".title",x,y,w,ctx.theme.title_height,ctx.theme.section_fill,ctx.theme.border);
   ASC_ExplorerRect(ctx,id + ".title.stripe",x,y,5,ctx.theme.title_height,stripe,stripe);
   ASC_ExplorerLabel(ctx,id + ".title.text",ASC_ExplorerFitText(title,w-ctx.theme.padding-16,10),x+ctx.theme.padding+4,y+6,ctx.theme.text,10);
  }

void ASC_ExplorerInfoRow(ASC_ExplorerContext &ctx,const string id,const string label,const string value,const int x,const int y,const int w,const color accent)
  {
   int row_h=ctx.theme.row_height+6;
   int label_w=w/3;
   if(label_w<84)
      label_w=84;
   if(label_w>w-90)
      label_w=w-90;
   ASC_ExplorerRect(ctx,id + ".row",x,y,w,row_h,ctx.theme.panel_fill,ctx.theme.border);
   ASC_ExplorerRect(ctx,id + ".bar",x,y,4,row_h,accent,accent);
   ASC_ExplorerLabel(ctx,id + ".label",ASC_ExplorerFitText(label,label_w-12),x+ctx.theme.padding+2,y+4,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,id + ".value",ASC_ExplorerFitText(value,w-label_w-ctx.theme.padding-18),x+label_w,y+4,ctx.theme.text);
  }

int ASC_ExplorerVisibleRows(const ASC_ExplorerContext &ctx,const int available_height,const int row_pitch)
  {
   int pitch=(row_pitch>0 ? row_pitch : (ctx.theme.row_height+ctx.theme.gap));
   int rows=(available_height/pitch);
   if(rows<1)
      rows=1;
   return(rows);
  }

int ASC_ExplorerPageCount(const int total_items,const int rows_per_page)
  {
   if(total_items<=0)
      return(1);
   int rows=(rows_per_page>0 ? rows_per_page : 1);
   int pages=total_items/rows;
   if((total_items%rows)!=0)
      pages++;
   if(pages<1)
      pages=1;
   return(pages);
  }

void ASC_ExplorerClampPage(int &page_index,const int total_items,const int rows_per_page)
  {
   int total_pages=ASC_ExplorerPageCount(total_items,rows_per_page);
   if(page_index<0)
      page_index=0;
   if(page_index>=total_pages)
      page_index=total_pages-1;
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
         ctx.nav.history_bucket_page[i-1]=ctx.nav.history_bucket_page[i];
         ctx.nav.history_bucket_symbol_page[i-1]=ctx.nav.history_bucket_symbol_page[i];
         ctx.nav.history_market_filter[i-1]=ctx.nav.history_market_filter[i];
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
   ctx.nav.history_bucket_page[slot]=ctx.nav.bucket_page;
   ctx.nav.history_bucket_symbol_page[slot]=ctx.nav.bucket_symbol_page;
   ctx.nav.history_market_filter[slot]=(int)ctx.nav.market_filter;
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
   ctx.nav.bucket_page=0;
   ctx.nav.bucket_symbol_page=0;
   ctx.nav.market_filter=ASC_EXPLORER_FILTER_ALL_SYMBOLS;
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
   ctx.nav.bucket_page=ctx.nav.history_bucket_page[slot];
   ctx.nav.bucket_symbol_page=ctx.nav.history_bucket_symbol_page[slot];
   ctx.nav.market_filter=(ASC_ExplorerMarketFilter)ctx.nav.history_market_filter[slot];
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

string ASC_ExplorerSelectedBucketName(ASC_ExplorerContext &ctx,const ASC_PreparedBucketState &prepared)
  {
   ASC_BucketViewModel filtered[];
   int source_indices[];
   int total=ASC_PreparedFilteredBuckets(prepared,ctx.nav.market_filter,filtered,source_indices);
   if(total<=0)
      return("Bucket Detail");
   if(ctx.nav.selected_bucket_index<0 || ctx.nav.selected_bucket_index>=total)
      ctx.nav.selected_bucket_index=0;
   return(filtered[ctx.nav.selected_bucket_index].name);
  }

string ASC_ExplorerSelectedSymbolName(ASC_ExplorerContext &ctx,ASC_SymbolState &states[],const int count)
  {
   if(ctx.nav.selected_symbol_index>=0 && ctx.nav.selected_symbol_index<count)
      return(states[ctx.nav.selected_symbol_index].symbol);
   if(ctx.nav.selected_seed_symbol!="")
      return(ctx.nav.selected_seed_symbol);
   return("Symbol Detail");
  }

string ASC_ExplorerBreadcrumbText(ASC_ExplorerContext &ctx,const ASC_PreparedBucketState &prepared,ASC_SymbolState &states[],const int count)
  {
   string path="Home / Overview";
   if(ctx.nav.current_view==ASC_EXPLORER_VIEW_BUCKETS)
      path="Home / Buckets";
   else if(ctx.nav.current_view==ASC_EXPLORER_VIEW_BUCKET_DETAIL)
      path="Home / Buckets / " + ASC_ExplorerSelectedBucketName(ctx,prepared);
   else if(ctx.nav.current_view==ASC_EXPLORER_VIEW_SYMBOL_DETAIL)
      path="Home / Buckets / " + ASC_ExplorerSelectedBucketName(ctx,prepared) + " / " + ASC_ExplorerSelectedSymbolName(ctx,states,count);
   else if(ctx.nav.current_view==ASC_EXPLORER_VIEW_STAT_DETAIL)
      path="Home / Buckets / " + ASC_ExplorerSelectedBucketName(ctx,prepared) + " / " + ASC_ExplorerSelectedSymbolName(ctx,states,count) + " / " + ASC_ExplorerStatText(ctx.nav.selected_stat_view);
   return(path);
  }

void ASC_ExplorerSummaryCard(ASC_ExplorerContext &ctx,const string id,const string title,const string line1,const string line2,const string line3,const int x,const int y,const int w,const int h,const color accent)
  {
   ASC_ExplorerRect(ctx,id + ".card",x,y,w,h,ctx.theme.panel_fill,ctx.theme.border);
   ASC_ExplorerRect(ctx,id + ".bar",x,y,6,h,accent,accent);
   ASC_ExplorerLabel(ctx,id + ".title",ASC_ExplorerFitText(title,w-24,10),x+14,y+6,ctx.theme.text,10);
   ASC_ExplorerLabel(ctx,id + ".line1",ASC_ExplorerFitText(line1,w-24),x+14,y+24,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,id + ".line2",ASC_ExplorerFitText(line2,w-24),x+14,y+24+ctx.theme.row_height,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,id + ".line3",ASC_ExplorerFitText(line3,w-24),x+14,y+24+(ctx.theme.row_height*2),ctx.theme.muted);
  }

void ASC_ExplorerRenderOverview(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count,const int x,const int y,const int w,const int h)
  {
   int gap=ctx.theme.gap;
   int card_w=(w-gap)/2;
   int card_h=(h-(gap*2))/3;
   int open_count=0,closed_count=0,uncertain_count=0,unknown_count=0,due_count=0;
   ASC_ExplorerCounts(states,count,open_count,closed_count,uncertain_count,unknown_count,due_count);

   ASC_ExplorerSummaryCard(ctx,"overview.identity","System Identity",ASC_PRODUCT_NAME,"Wrapper " + ASC_WRAPPER_VERSION + " | Explorer " + ASC_EXPLORER_SUBSYSTEM_VERSION,"Market Filter " + ASC_ExplorerMarketFilterText(ctx.nav.market_filter),x,y,card_w,card_h,ctx.theme.accent);
   ASC_ExplorerSummaryCard(ctx,"overview.runtime","Runtime","Mode " + ASC_RuntimeModeText(runtime.mode),"Warmup " + IntegerToString(runtime.warmup_progress_percent) + "% | Beat " + IntegerToString(runtime.heartbeats_since_boot),"Server " + runtime.server_clean,x+card_w+gap,y,card_w,card_h,(runtime.degraded ? ctx.theme.warning : (runtime.mode==ASC_RUNTIME_WARMUP ? ctx.theme.warning : ctx.theme.good)));
   ASC_ExplorerSummaryCard(ctx,"overview.universe","Universe","Tracked symbols " + IntegerToString(count),"Open " + IntegerToString(open_count) + " | Closed " + IntegerToString(closed_count),"Uncertain " + IntegerToString(uncertain_count) + " | Unknown " + IntegerToString(unknown_count),x,y+card_h+gap,card_w,card_h,ctx.theme.accent_alt);
   ASC_ExplorerSummaryCard(ctx,"overview.scheduler","Scheduler","Cursor " + IntegerToString(runtime.scheduler_cursor),"Due now " + IntegerToString(due_count),"Budget per beat " + IntegerToString(settings.symbol_budget_per_heartbeat),x+card_w+gap,y+card_h+gap,card_w,card_h,ctx.theme.accent);
   ASC_ExplorerSummaryCard(ctx,"overview.health","Health and Attention","Recovery " + (runtime.recovery_used ? "Used" : "Fresh Start"),"Degraded " + ASC_BoolText(runtime.degraded) + " | Warmup Min " + ASC_BoolText(runtime.warmup_minimum_met),"Last heartbeat " + ASC_DateTimeText(runtime.last_heartbeat_at),x,y+(card_h+gap)*2,card_w,card_h,(runtime.degraded ? ctx.theme.warning : ctx.theme.good));
   ASC_ExplorerSummaryCard(ctx,"overview.capability","Layer 1 Readiness","Initial assessed " + IntegerToString(runtime.initial_symbols_assessed) + "/" + IntegerToString(runtime.symbol_count),"Primary buckets " + IntegerToString(runtime.primary_bucket_symbols_assessed) + "/" + IntegerToString(runtime.primary_bucket_symbol_count),"Background hydration " + ASC_BoolText(runtime.background_hydration_active),x+card_w+gap,y+(card_h+gap)*2,card_w,card_h,(runtime.background_hydration_active ? ctx.theme.accent : ctx.theme.reserved));
  }

void ASC_ExplorerRenderPageButtons(ASC_ExplorerContext &ctx,const string id_prefix,const int page_index,const int page_count,const int x,const int y,const int max_width)
  {
   if(page_count<=1)
      return;
   int button_w=60;
   int gap=ctx.theme.gap;
   int fit=(button_w+gap>0 ? ((max_width+gap)/(button_w+gap)) : 1);
   if(fit<1)
      fit=1;
   int start=0;
   if(page_count>fit)
     {
      start=page_index-(fit/2);
      if(start<0)
         start=0;
      if(start+fit>page_count)
         start=page_count-fit;
     }
   int end=start+fit;
   if(end>page_count)
      end=page_count;
   for(int i=start;i<end;i++)
     {
      int bx=x+((i-start)*(button_w+gap));
      ASC_ExplorerButton(ctx,id_prefix + "." + IntegerToString(i),"Page " + IntegerToString(i+1),bx,y,button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill,(i==page_index));
     }
  }

void ASC_ExplorerRenderBucketList(ASC_ExplorerContext &ctx,const ASC_PreparedBucketState &prepared,const int x,const int y,const int w,const int h)
  {
   ASC_BucketViewModel filtered[];
   int source_indices[];
   int total=ASC_PreparedFilteredBuckets(prepared,ctx.nav.market_filter,filtered,source_indices);

   int row_h=(ctx.theme.row_height*3)+18;
   int intro_h=ctx.theme.row_height+12;
   int footer_h=ctx.theme.button_height+ctx.theme.gap+4;
   int available=(h-ctx.theme.title_height-intro_h-footer_h-(ctx.theme.gap*3));
   int rows_per_page=ASC_ExplorerVisibleRows(ctx,available,row_h+ctx.theme.gap);
   int total_pages=ASC_ExplorerPageCount(total,rows_per_page);
   ASC_ExplorerClampPage(ctx.nav.bucket_page,total,rows_per_page);

   ASC_ExplorerPanelTitle(ctx,"buckets.panel","Bucket List",x,y,w,ctx.theme.accent);
   ASC_ExplorerRect(ctx,"buckets.intro",x,y+ctx.theme.title_height,w,intro_h,ctx.theme.panel_soft_fill,ctx.theme.border);
   string filter_note=(ctx.nav.market_filter==ASC_EXPLORER_FILTER_OPEN_ONLY ? "Open Only shows only compressed Layer 1 buckets with at least one classified symbol that is currently OPEN." : "All Symbols progressively reveals compressed Layer 1 buckets from promoted prepared truth; unopened batches remain honestly marked until hydration reaches them.");
   if(prepared.unresolved_count>0)
      filter_note+=" Unresolved live symbols: " + IntegerToString(prepared.unresolved_count) + ".";
   ASC_ExplorerLabel(ctx,"buckets.note",ASC_ExplorerFitText(filter_note,w-ctx.theme.padding-8),x+ctx.theme.padding,y+ctx.theme.title_height+6,ctx.theme.muted);

   int start=ctx.nav.bucket_page*rows_per_page;
   int end=start+rows_per_page;
   if(end>total)
      end=total;
   int row_y=y+ctx.theme.title_height+intro_h+ctx.theme.gap;
   for(int i=start;i<end;i++)
     {
      int visual=i-start;
      int card_y=row_y+(visual*(row_h+ctx.theme.gap));
      int live_visible=ASC_PreparedVisibleBucketCount(filtered[i],ctx.nav.market_filter);
      bool selected=(i==ctx.nav.selected_bucket_index);
      color fill=(selected ? ctx.theme.selected_soft_fill : ctx.theme.panel_fill);
      color accent=(live_visible>0 ? ctx.theme.good : ctx.theme.warning);
      ASC_ExplorerRect(ctx,"buckets.card." + IntegerToString(i),x,card_y,w,row_h,fill,ctx.theme.border);
      ASC_ExplorerRect(ctx,"buckets.card.bar." + IntegerToString(i),x,card_y,6,row_h,accent,accent);
      ASC_ExplorerLabel(ctx,"buckets.name." + IntegerToString(i),ASC_ExplorerFitText(filtered[i].name,w-160,10),x+14,card_y+6,ctx.theme.text,10);
      ASC_ExplorerLabel(ctx,"buckets.meta." + IntegerToString(i),ASC_ExplorerFitText(filtered[i].family + " | " + filtered[i].posture + " | ID " + filtered[i].bucket_id,w-160),x+14,card_y+24,ctx.theme.muted);
      string truth_line="State " + filtered[i].progress_label + " | Classified live " + IntegerToString(filtered[i].resolved_symbol_count) + " | Open " + IntegerToString(filtered[i].open_symbol_count);
      if(ctx.nav.market_filter==ASC_EXPLORER_FILTER_OPEN_ONLY)
         truth_line="State " + filtered[i].progress_label + " | Open classified visible " + IntegerToString(live_visible);
      ASC_ExplorerLabel(ctx,"buckets.truth." + IntegerToString(i),ASC_ExplorerFitText(truth_line,w-160),x+14,card_y+24+ctx.theme.row_height,accent);
      ASC_ExplorerButton(ctx,"action.bucket." + IntegerToString(i),"Open",x+w-82,card_y+((row_h-ctx.theme.button_height)/2),70,ctx.theme.button_height,ctx.theme.accent,selected);
     }

   if(total<=0)
      ASC_ExplorerLabel(ctx,"buckets.empty","No buckets satisfy the current operator filter yet.",x+ctx.theme.padding,row_y+6,ctx.theme.warning);

   int footer_y=y+h-footer_h;
   if(total_pages>1)
     {
      ASC_ExplorerLabel(ctx,"buckets.page.summary","Page " + IntegerToString(ctx.nav.bucket_page+1) + " of " + IntegerToString(total_pages),x+ctx.theme.padding,footer_y+4,ctx.theme.muted);
      ASC_ExplorerRenderPageButtons(ctx,"action.bucket_page",ctx.nav.bucket_page,total_pages,x+120,footer_y,w-130);
     }
  }

void ASC_ExplorerRenderBucketDetail(ASC_ExplorerContext &ctx,const ASC_PreparedBucketState &prepared,const int x,const int y,const int w,const int h)
  {
   ASC_BucketViewModel filtered[];
   int source_indices[];
   int total=ASC_PreparedFilteredBuckets(prepared,ctx.nav.market_filter,filtered,source_indices);
   if(total<=0)
     {
      ASC_ExplorerRect(ctx,"bucket.detail.empty",x,y,w,h,ctx.theme.panel_fill,ctx.theme.border);
      ASC_ExplorerLabel(ctx,"bucket.detail.empty.title","Bucket Detail",x+ctx.theme.padding,y+8,ctx.theme.text,11);
      ASC_ExplorerLabel(ctx,"bucket.detail.empty.note","No bucket currently matches the operator filter.",x+ctx.theme.padding,y+32,ctx.theme.warning);
      return;
     }
   if(ctx.nav.selected_bucket_index<0 || ctx.nav.selected_bucket_index>=total)
      ctx.nav.selected_bucket_index=0;

   ASC_BucketViewModel bucket=filtered[ctx.nav.selected_bucket_index];
   ASC_BucketPreparedSymbol resolved[];
   ASC_PreparedBucketSymbols(prepared,bucket,resolved);

   ASC_BucketPreparedSymbol visible_symbols[];
   ArrayResize(visible_symbols,0);
   for(int i=0;i<ArraySize(resolved);i++)
     {
      bool include=(ctx.nav.market_filter==ASC_EXPLORER_FILTER_ALL_SYMBOLS);
      if(ctx.nav.market_filter==ASC_EXPLORER_FILTER_OPEN_ONLY)
         include=(resolved[i].open_now);
      if(include)
        {
         int slot=ArraySize(visible_symbols);
         ArrayResize(visible_symbols,slot+1);
         visible_symbols[slot]=resolved[i];
        }
     }

   int total_visible_symbols=ArraySize(visible_symbols);
   int mode_limit=total_visible_symbols;
   if(ctx.nav.bucket_display_mode!=ASC_BUCKET_DISPLAY_ALL)
     {
      mode_limit=ASC_BucketDisplayLimit(bucket,ctx.nav.bucket_display_mode);
      if(mode_limit>total_visible_symbols)
         mode_limit=total_visible_symbols;
     }
   int capped_total=mode_limit;

   int wide_summary_min=760;
   int summary_w=(w>=wide_summary_min ? (w*30)/100 : 0);
   if(summary_w>280)
      summary_w=280;
   if(summary_w>0 && summary_w<210)
      summary_w=210;
   int symbol_w=w;
   bool show_side_summary=false;
   if(summary_w>0)
     {
      int candidate_symbol_w=w-summary_w-ctx.theme.gap;
      if(candidate_symbol_w>=320)
        {
         symbol_w=candidate_symbol_w;
         show_side_summary=true;
        }
      else
         summary_w=0;
     }

   int header_h=94;
   int controls_h=42;
   int strip_h=(show_side_summary ? ctx.theme.row_height+12 : (ctx.theme.row_height*2)+16);
   int footer_h=ctx.theme.button_height+ctx.theme.gap+4;
   int row_h=(ctx.theme.row_height*3)+18;
   int available_symbol_h=h-header_h-controls_h-strip_h-footer_h-(ctx.theme.gap*4);
   if(available_symbol_h<row_h)
      available_symbol_h=row_h;
   int rows_per_page=ASC_ExplorerVisibleRows(ctx,available_symbol_h,row_h+ctx.theme.gap);
   int symbol_pages=ASC_ExplorerPageCount(capped_total,rows_per_page);
   ASC_ExplorerClampPage(ctx.nav.bucket_symbol_page,capped_total,rows_per_page);
   int lane_start=ctx.nav.bucket_symbol_page*rows_per_page;
   int lane_end=lane_start+rows_per_page;
   if(lane_end>capped_total)
      lane_end=capped_total;

   int resolved_open_count=ASC_PreparedVisibleBucketCount(bucket,ASC_EXPLORER_FILTER_OPEN_ONLY);
   color bucket_accent=(resolved_open_count>0 ? ctx.theme.good : ctx.theme.accent);

   ASC_ExplorerRect(ctx,"bucket.detail.header",x,y,w,header_h,ctx.theme.panel_fill,ctx.theme.border);
   ASC_ExplorerRect(ctx,"bucket.detail.header.bar",x,y,6,header_h,bucket_accent,bucket_accent);
   ASC_ExplorerLabel(ctx,"bucket.detail.title",ASC_ExplorerFitText(bucket.name,w-24,11),x+14,y+8,ctx.theme.text,11);
   ASC_ExplorerLabel(ctx,"bucket.detail.family",ASC_ExplorerFitText("Compressed Layer 1 Bucket | " + bucket.family + " | " + bucket.posture + " | Bucket ID " + bucket.bucket_id,w-24),x+14,y+28,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,"bucket.detail.note",ASC_ExplorerFitText(bucket.note,w-24),x+14,y+46,ctx.theme.dim);
   ASC_ExplorerLabel(ctx,"bucket.detail.progress",ASC_ExplorerFitText("Prepared state " + bucket.progress_label + " | Promoted batches " + IntegerToString(prepared.diagnostics.promoted_batch_count) + "/" + IntegerToString(ASC_PREPARED_BATCH_COUNT),w-24),x+14,y+46+ctx.theme.row_height,ctx.theme.good);

   int controls_y=y+header_h+ctx.theme.gap;
   ASC_ExplorerRect(ctx,"bucket.detail.controls",x,controls_y,w,controls_h,ctx.theme.section_fill,ctx.theme.border);
   int mode_x=x+ctx.theme.padding;
   ASC_ExplorerButton(ctx,"action.bucket_mode.top3","Top 3",mode_x,controls_y+8,62,ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.bucket_display_mode==ASC_BUCKET_DISPLAY_TOP_3));
   mode_x+=68;
   ASC_ExplorerButton(ctx,"action.bucket_mode.top5","Top 5",mode_x,controls_y+8,62,ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.bucket_display_mode==ASC_BUCKET_DISPLAY_TOP_5));
   mode_x+=68;
   ASC_ExplorerButton(ctx,"action.bucket_mode.all","All",mode_x,controls_y+8,54,ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.bucket_display_mode==ASC_BUCKET_DISPLAY_ALL));
   mode_x+=62;
   string page_mode_text="Visible Classified Symbols " + IntegerToString(capped_total) + " | Page " + IntegerToString(ctx.nav.bucket_symbol_page+1) + " of " + IntegerToString(symbol_pages);
   ASC_ExplorerLabel(ctx,"bucket.detail.page",ASC_ExplorerFitText(page_mode_text,220),x+w-224,controls_y+7,(symbol_pages>1 ? ctx.theme.good : ctx.theme.dim));
   ASC_ExplorerLabel(ctx,"bucket.detail.visibility",ASC_ExplorerFitText("Mode " + ASC_BucketDisplayModeText(ctx.nav.bucket_display_mode) + " | Physical rows " + IntegerToString(rows_per_page),220),x+w-224,controls_y+22,ctx.theme.muted);

   int strip_y=controls_y+controls_h+ctx.theme.gap;
   ASC_ExplorerRect(ctx,"bucket.detail.meta",x,strip_y,w,strip_h,ctx.theme.panel_soft_fill,ctx.theme.border);
   string membership_truth="Membership comes only from promoted prepared truth for compressed Layer 1 buckets on this server.";
   if(ctx.nav.market_filter==ASC_EXPLORER_FILTER_OPEN_ONLY)
      membership_truth="Membership comes only from promoted prepared truth for compressed Layer 1 buckets on this server and currently OPEN.";
   string left_meta="Bucket Members " + IntegerToString(bucket.resolved_symbol_count) + " | Open " + IntegerToString(bucket.open_symbol_count) + " | Visible Classified Symbols " + IntegerToString(capped_total);
   string right_meta="Showing " + IntegerToString(lane_start+1) + "-" + IntegerToString((capped_total>0 ? lane_end : 0)) + " of " + IntegerToString(capped_total) + " | " + membership_truth;
   if(capped_total<=0)
      right_meta=membership_truth;
   if(show_side_summary)
     {
      ASC_ExplorerLabel(ctx,"bucket.detail.meta.left",ASC_ExplorerFitText(left_meta,w-24),x+ctx.theme.padding,strip_y+6,ctx.theme.muted);
      ASC_ExplorerLabel(ctx,"bucket.detail.meta.right",ASC_ExplorerFitText(membership_truth,w-24),x+ctx.theme.padding+250,strip_y+6,ctx.theme.dim);
     }
   else
     {
      ASC_ExplorerLabel(ctx,"bucket.detail.meta.left",ASC_ExplorerFitText(left_meta,w-24),x+ctx.theme.padding,strip_y+6,ctx.theme.muted);
      ASC_ExplorerLabel(ctx,"bucket.detail.meta.right",ASC_ExplorerFitText(right_meta,w-24),x+ctx.theme.padding,strip_y+6+ctx.theme.row_height,ctx.theme.dim);
     }

   int lane_y=strip_y+strip_h+ctx.theme.gap;
   int lane_h=h-(lane_y-y)-footer_h;
   if(lane_h<row_h+ctx.theme.title_height+ctx.theme.gap)
      lane_h=row_h+ctx.theme.title_height+ctx.theme.gap;
   ASC_ExplorerPanelTitle(ctx,"bucket.detail.lane","Bucket Members",x,lane_y,symbol_w,ctx.theme.accent);
   int list_y=lane_y+ctx.theme.title_height+ctx.theme.gap;
   for(int i=lane_start;i<lane_end;i++)
     {
      int visual=i-lane_start;
      int card_y=list_y+(visual*(row_h+ctx.theme.gap));
      color accent=ASC_ExplorerStatusAccent(ctx,visible_symbols[i].market_status,true);
      color fill=ctx.theme.panel_fill;
      ASC_ExplorerRect(ctx,"bucket.detail.seed." + IntegerToString(i),x,card_y,symbol_w,row_h,fill,ctx.theme.border);
      ASC_ExplorerRect(ctx,"bucket.detail.seed.bar." + IntegerToString(i),x,card_y,6,row_h,accent,accent);
      ASC_ExplorerLabel(ctx,"bucket.detail.seed.sym." + IntegerToString(i),ASC_ExplorerFitText(visible_symbols[i].live_symbol,symbol_w-160,10),x+14,card_y+6,ctx.theme.text,10);
      string state_text="Prepared live symbol | State " + ASC_MarketStatusText(visible_symbols[i].market_status)
                       + " | Primary " + visible_symbols[i].primary_bucket;
      string detail_text="Theme " + (visible_symbols[i].theme_bucket=="" ? "N/A" : visible_symbols[i].theme_bucket)
                        + " | Sector " + (visible_symbols[i].sector=="" ? "N/A" : visible_symbols[i].sector)
                        + " | Industry " + (visible_symbols[i].industry=="" ? "N/A" : visible_symbols[i].industry);
      ASC_ExplorerLabel(ctx,"bucket.detail.seed.state." + IntegerToString(i),ASC_ExplorerFitText(state_text,symbol_w-160),x+14,card_y+24,ctx.theme.muted);
      ASC_ExplorerLabel(ctx,"bucket.detail.seed.note." + IntegerToString(i),ASC_ExplorerFitText(detail_text,symbol_w-160),x+14,card_y+24+ctx.theme.row_height,ctx.theme.good);
      ASC_ExplorerButton(ctx,"action.seed_symbol." + IntegerToString(i),"Inspect",x+symbol_w-82,card_y+((row_h-ctx.theme.button_height)/2),70,ctx.theme.button_height,ctx.theme.accent,false);
     }
   if(capped_total<=0)
     {
      string empty_text=(ctx.nav.market_filter==ASC_EXPLORER_FILTER_OPEN_ONLY ? "No open classified symbols are available for this bucket right now." : "No classified broker symbols are currently visible for this bucket on this server.");
      if(ctx.nav.market_filter==ASC_EXPLORER_FILTER_ALL_SYMBOLS && bucket.progress_state!=ASC_PREPARED_BUCKET_READY)
         empty_text="Bucket members will appear here after promoted hydration advances. Current state: " + bucket.progress_label + ".";
      ASC_ExplorerLabel(ctx,"bucket.detail.emptylane",ASC_ExplorerFitText(empty_text,symbol_w-24),x+ctx.theme.padding,list_y+6,ctx.theme.warning);
     }

   if(show_side_summary)
     {
      int summary_x=x+symbol_w+ctx.theme.gap;
      ASC_ExplorerPanelTitle(ctx,"bucket.detail.summary","Bucket Summary",summary_x,lane_y,summary_w,ctx.theme.accent_alt);
      int summary_y=lane_y+ctx.theme.title_height+ctx.theme.gap;
      string stock_grouping_hint="Regional stock grouping promotes before finer stock metadata, but remains inside the Stocks lane rather than creating first-class bucket pages.";
      if(bucket.bucket_id!="stocks")
         stock_grouping_hint="Second-level grouping remains available from preserved primary/sector/theme/subtype metadata.";
      ASC_ExplorerInfoRow(ctx,"bucket.detail.summary.family","Bucket Family",bucket.family,summary_x,summary_y,summary_w,ctx.theme.accent_alt);
      ASC_ExplorerInfoRow(ctx,"bucket.detail.summary.members","Bucket Members",IntegerToString(bucket.resolved_symbol_count),summary_x,summary_y+30,summary_w,ctx.theme.accent_alt);
      ASC_ExplorerInfoRow(ctx,"bucket.detail.summary.visible","Visible Classified",IntegerToString(capped_total) + " shown in mode | " + IntegerToString(total_visible_symbols) + " filter-visible",summary_x,summary_y+60,summary_w,bucket_accent);
      ASC_ExplorerInfoRow(ctx,"bucket.detail.summary.truth","Membership Truth",membership_truth,summary_x,summary_y+90,summary_w,ctx.theme.warning);
      ASC_ExplorerInfoRow(ctx,"bucket.detail.summary.stockhint","Layer 2 Grouping",stock_grouping_hint,summary_x,summary_y+120,summary_w,ctx.theme.good);
      ASC_ExplorerInfoRow(ctx,"bucket.detail.summary.posture","Bucket Posture",bucket.posture,summary_x,summary_y+150,summary_w,ctx.theme.reserved);
     }

   int footer_y=y+h-footer_h;
   if(symbol_pages>1)
     {
      ASC_ExplorerLabel(ctx,"bucket.detail.page.summary","Page " + IntegerToString(ctx.nav.bucket_symbol_page+1) + " of " + IntegerToString(symbol_pages),x+ctx.theme.padding,footer_y+4,ctx.theme.muted);
      ASC_ExplorerRenderPageButtons(ctx,"action.bucket_symbol_page",ctx.nav.bucket_symbol_page,symbol_pages,x+120,footer_y,w-130);
     }
  }

void ASC_ExplorerSectionPanel(ASC_ExplorerContext &ctx,const string id,const string title,const string l1,const string l2,const string l3,const int x,const int y,const int w,const int h,const bool selected,const color accent)
  {
   color stripe=(accent==C'0,0,0' ? ctx.theme.accent : accent);
   ASC_ExplorerRect(ctx,id + ".panel",x,y,w,h,(selected ? ctx.theme.selected_fill : ctx.theme.panel_fill),ctx.theme.border);
   ASC_ExplorerRect(ctx,id + ".stripe",x,y,6,h,stripe,stripe);
   ASC_ExplorerLabel(ctx,id + ".title",ASC_ExplorerFitText(title,w-24,10),x+14,y+6,ctx.theme.text,10);
   ASC_ExplorerLabel(ctx,id + ".l1",ASC_ExplorerFitText(l1,w-24),x+14,y+24,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,id + ".l2",ASC_ExplorerFitText(l2,w-24),x+14,y+24+ctx.theme.row_height,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,id + ".l3",ASC_ExplorerFitText(l3,w-24),x+14,y+24+(ctx.theme.row_height*2),ctx.theme.muted);
  }

void ASC_ExplorerRenderSymbolDetail(ASC_ExplorerContext &ctx,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count,const int x,const int y,const int w,const int h)
  {
   if(count<=0 || ctx.nav.selected_symbol_index<0 || ctx.nav.selected_symbol_index>=count)
     {
      ASC_ExplorerRect(ctx,"symbol.seed.panel",x,y,w,h,ctx.theme.panel_fill,ctx.theme.border);
      ASC_ExplorerLabel(ctx,"symbol.seed.title","Symbol Detail",x+ctx.theme.padding,y+8,ctx.theme.text,11);
      ASC_ExplorerLabel(ctx,"symbol.seed.text",ASC_ExplorerFitText("Live symbol detail is not available for the selected bucket reference yet.",w-24),x+ctx.theme.padding,y+32,ctx.theme.warning);
      ASC_ExplorerInfoRow(ctx,"symbol.seed.row1","Identity",(ctx.nav.selected_seed_symbol=="" ? "Reference pending" : ctx.nav.selected_seed_symbol),x+ctx.theme.padding,y+62,w-(ctx.theme.padding*2),ctx.theme.reserved);
      ASC_ExplorerInfoRow(ctx,"symbol.seed.row2","Layer 1 Truth","Live Market State Detection appears only when the selected reference resolves to a tracked symbol.",x+ctx.theme.padding,y+92,w-(ctx.theme.padding*2),ctx.theme.warning);
      ASC_ExplorerInfoRow(ctx,"symbol.seed.row3","Publication","This shell keeps publication structure visible without fabricating broker truth.",x+ctx.theme.padding,y+122,w-(ctx.theme.padding*2),ctx.theme.accent_alt);
      ASC_ExplorerInfoRow(ctx,"symbol.seed.row4","Future Surface","Aurora and advanced trade detail remain reserved insertion points.",x+ctx.theme.padding,y+152,w-(ctx.theme.padding*2),ctx.theme.reserved);
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

   ASC_ExplorerSectionPanel(ctx,"symbol.identity","Identity","Symbol " + state.symbol,"Server " + runtime.server_clean,"Aurora insertion remains reserved",x,base_y,section_w,section_h,(ctx.nav.selected_stat_view==ASC_EXPLORER_STAT_IDENTITY),ctx.theme.accent);
   ASC_ExplorerSectionPanel(ctx,"symbol.market","Market State","State " + ASC_MarketStatusText(state.market_status),"Session " + (state.within_trade_session ? "Inside broker session" : (state.has_trade_sessions ? "Outside broker session" : "Session data unavailable")),"Next Check " + ASC_DateTimeText(state.next_check_at),x+section_w+gap,base_y,section_w,section_h,(ctx.nav.selected_stat_view==ASC_EXPLORER_STAT_MARKET_STATE),ASC_ExplorerStatusAccent(ctx,state.market_status,true));
   ASC_ExplorerSectionPanel(ctx,"symbol.quote","Tick and Quote","Bid " + DoubleToString(bid,digits),"Ask " + DoubleToString(ask,digits),"Spread " + spread_text,x,base_y+section_h+gap,section_w,section_h,(ctx.nav.selected_stat_view==ASC_EXPLORER_STAT_TICK_QUOTE),ctx.theme.accent_alt);
   ASC_ExplorerSectionPanel(ctx,"symbol.runtime","Runtime and Publication","Heartbeat " + ASC_DateTimeText(runtime.last_heartbeat_at),"Last Write " + ASC_DateTimeText(state.last_dossier_write_at),"Publication " + (state.publication_ok ? "Promoted" : "Pending"),x+section_w+gap,base_y+section_h+gap,section_w,section_h,(ctx.nav.selected_stat_view==ASC_EXPLORER_STAT_RUNTIME_PUBLICATION),ctx.theme.good);
   ASC_ExplorerSectionPanel(ctx,"symbol.future","Future Surface","Open Symbol Snapshot: reserved","Advanced trade detail: reserved","Aurora scan action: reserved",x,base_y+(section_h+gap)*2,w,section_h,(ctx.nav.selected_stat_view==ASC_EXPLORER_STAT_FUTURE_SURFACES),ctx.theme.reserved);

   ASC_ExplorerButton(ctx,"action.stat.identity","Identity",x+section_w-84,base_y+section_h-30,74,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   ASC_ExplorerButton(ctx,"action.stat.market","State",x+w-84,base_y+section_h-30,74,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   ASC_ExplorerButton(ctx,"action.stat.quote","Quote",x+section_w-84,base_y+section_h+gap+section_h-30,74,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   ASC_ExplorerButton(ctx,"action.stat.runtime","Runtime",x+w-84,base_y+section_h+gap+section_h-30,74,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   ASC_ExplorerButton(ctx,"action.stat.future","Future",x+w-84,base_y+(section_h+gap)*2+section_h-30,74,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   ASC_ExplorerLabel(ctx,"symbol.tick.meta",ASC_ExplorerFitText("Day High " + DoubleToString(day_high,digits) + " | Day Low " + DoubleToString(day_low,digits) + " | Market Watch Update " + (have_tick ? ASC_DateTimeText((datetime)tick.time) : "Not Yet Available"),w-24),x+ctx.theme.padding,base_y+(section_h+gap)*2+section_h-18,ctx.theme.muted);
  }

void ASC_ExplorerRenderStatDetail(ASC_ExplorerContext &ctx,const ASC_RuntimeState &runtime,ASC_SymbolState &states[],const int count,const int x,const int y,const int w,const int h)
  {
   ASC_ExplorerRect(ctx,"stat.panel",x,y,w,h,ctx.theme.panel_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"stat.title","Stat Detail",x+ctx.theme.padding,y+8,ctx.theme.text,11);
   ASC_ExplorerLabel(ctx,"stat.subtitle",ASC_ExplorerFitText(ASC_ExplorerStatText(ctx.nav.selected_stat_view),w-24),x+ctx.theme.padding,y+28,ctx.theme.muted);
   int info_top=y+58;
   int visible=ASC_ExplorerVisibleRows(ctx,h-92,30);
   if(visible>4)
      visible=4;
   int max_scroll=(4>visible ? 4-visible : 0);
   if(ctx.nav.stat_scroll<0)
      ctx.nav.stat_scroll=0;
   if(ctx.nav.stat_scroll>max_scroll)
      ctx.nav.stat_scroll=max_scroll;

   if(count<=0 || ctx.nav.selected_symbol_index<0 || ctx.nav.selected_symbol_index>=count)
     {
      ASC_ExplorerLabel(ctx,"stat.empty",ASC_ExplorerFitText("Live stat detail is not available for the selected reference symbol yet.",w-24),x+ctx.theme.padding,y+48,ctx.theme.warning);
      ASC_ExplorerInfoRow(ctx,"stat.seed.row1","Reference Symbol",(ctx.nav.selected_seed_symbol=="" ? "Reference pending" : ctx.nav.selected_seed_symbol),x+ctx.theme.padding,y+78,w-(ctx.theme.padding*2),ctx.theme.reserved);
      ASC_ExplorerInfoRow(ctx,"stat.seed.row2","Current Scope","Stat Detail shell is active; deeper resolution remains reserved.",x+ctx.theme.padding,y+108,w-(ctx.theme.padding*2),ctx.theme.warning);
      return;
     }

   ASC_SymbolState state=states[ctx.nav.selected_symbol_index];
   string line1="";
   string line2="";
   string line3="";
   string line4="";
   string label1="State";
   string label2="Session";
   string label3="Next Check";
   string label4="Reason";

   switch(ctx.nav.selected_stat_view)
     {
      case ASC_EXPLORER_STAT_IDENTITY:
         label1="Symbol";
         label2="Server";
         label3="Membership Truth";
         label4="Future Path";
         line1=state.symbol;
         line2=runtime.server_clean;
         line3="Classification-driven bucket identity is active for resolved broker symbols.";
         line4="Unresolved broker symbols stay outside bucket membership until safely classified.";
         break;
      case ASC_EXPLORER_STAT_MARKET_STATE:
         label1="State";
         label2="Session";
         label3="Next Check";
         label4="Reason";
         line1=ASC_MarketStatusText(state.market_status);
         line2=(state.within_trade_session ? "Inside broker trade session" : (state.has_trade_sessions ? "Outside broker trade session" : "Session data unavailable"));
         line3=ASC_DateTimeText(state.next_check_at);
         line4=state.next_check_reason;
         break;
      case ASC_EXPLORER_STAT_TICK_QUOTE:
         label1="Tick Present";
         label2="Tick Age";
         label3="Scope";
         label4="Guardrail";
         line1=ASC_BoolText(state.has_tick);
         line2=(state.tick_age_seconds>=0 ? IntegerToString((int)state.tick_age_seconds) + " seconds" : "Not Yet Available");
         line3="Market Watch detail remains safe and lightweight in Layer 1.";
         line4="No heavy history pulls are performed from the explorer.";
         break;
      case ASC_EXPLORER_STAT_RUNTIME_PUBLICATION:
         label1="Runtime";
         label2="Publication";
         label3="Last Write";
         label4="Last Heartbeat";
         line1=ASC_RuntimeModeText(runtime.mode);
         line2=(state.publication_ok ? "Current dossier write promoted" : "Awaiting a successful dossier promotion");
         line3=ASC_DateTimeText(state.last_dossier_write_at);
         line4=ASC_DateTimeText(runtime.last_heartbeat_at);
         break;
      default:
         label1="Snapshot";
         label2="Filtering";
         label3="Shortlist";
         label4="Aurora";
         line1="Open Symbol Snapshot remains placeholder-only.";
         line2="Candidate Filtering and Shortlist Selection are not active.";
         line3="Deep Selective and Combined Opportunity lanes remain reserved.";
         line4="Aurora downstream surface remains reserved.";
         break;
     }

   string labels[4];
   string values[4];
   labels[0]=label1; labels[1]=label2; labels[2]=label3; labels[3]=label4;
   values[0]=line1; values[1]=line2; values[2]=line3; values[3]=line4;
   for(int row=0;row<visible && (ctx.nav.stat_scroll+row)<4;row++)
     {
      int idx=ctx.nav.stat_scroll+row;
      ASC_ExplorerInfoRow(ctx,"stat.line" + IntegerToString(idx),labels[idx],values[idx],x+ctx.theme.padding,info_top+(row*30),w-(ctx.theme.padding*2),ctx.theme.accent_alt);
     }
  }

string ASC_ExplorerWarmupBannerText(const ASC_RuntimeState &runtime)
  {
   string progress=IntegerToString(runtime.warmup_progress_percent) + "%";
   string primary_scope=IntegerToString(runtime.primary_bucket_symbols_assessed) + "/" + IntegerToString(runtime.primary_bucket_symbol_count);
   if(runtime.mode==ASC_RUNTIME_WARMUP || !runtime.warmup_minimum_met)
      return("Warmup active: assessed " + IntegerToString(runtime.initial_symbols_assessed) + "/" + IntegerToString(runtime.symbol_count)
             + " discovered symbols | primary buckets " + primary_scope + " | readiness " + progress + ".");
   if(runtime.background_hydration_active)
      return("Layer 1 minimum met: steady mode active while background hydration continues for "
             + IntegerToString(runtime.symbol_count-runtime.initial_symbols_assessed) + " lower-priority symbols | readiness " + progress + ".");
   return("Layer 1 readiness complete: all discovered symbols assessed at least once | readiness " + progress + ".");
  }

string ASC_ExplorerWarmupModeText(const ASC_RuntimeState &runtime)
  {
   if(runtime.mode==ASC_RUNTIME_WARMUP || !runtime.warmup_minimum_met)
      return("Warmup active/full mode");
   if(runtime.background_hydration_active)
      return("Warmup minimum met; steady mode with background completion");
   return("Warmup complete; full Layer 1 steady mode");
  }

string ASC_ExplorerPrimaryBucketLoadingText(const ASC_RuntimeState &runtime)
  {
   return("Primary buckets loading first: " + IntegerToString(runtime.primary_bucket_symbols_assessed)
          + "/" + IntegerToString(runtime.primary_bucket_symbol_count) + " assessed.");
  }

string ASC_ExplorerBackgroundCompletionText(const ASC_RuntimeState &runtime)
  {
   if(runtime.background_hydration_active)
      return("Background completion continues for lower-priority symbols after Layer 1 readiness.");
   return("Background completion is caught up right now.");
  }

string ASC_ExplorerTimingMsText(const long value)
  {
   if(value<=0)
      return("Pending");
   return(IntegerToString((int)value) + " ms");
  }

void ASC_ExplorerMarkPageSwitchTiming(ASC_ExplorerContext &ctx,const string action_name)
  {
   ctx.nav.pending_page_switch_started_ms=GetTickCount();
   ctx.nav.pending_page_switch_timing=true;
   ctx.nav.pending_page_switch_action=action_name;
  }

void ASC_ExplorerMaybeStartPageSwitchTiming(ASC_ExplorerContext &ctx,const string action_name,const ASC_ExplorerView before_view,const int before_bucket,const int before_symbol,const ASC_ExplorerStatView before_stat)
  {
   if(ctx.nav.current_view!=before_view
      || ctx.nav.selected_bucket_index!=before_bucket
      || ctx.nav.selected_symbol_index!=before_symbol
      || ctx.nav.selected_stat_view!=before_stat)
      ASC_ExplorerMarkPageSwitchTiming(ctx,action_name);
  }

void ASC_ExplorerRenderHeader(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,const ASC_PreparedBucketState &prepared,const int chart_w)
  {
   int x=ctx.theme.margin;
   int y=ctx.theme.margin;
   int w=chart_w-(ctx.theme.margin*2);
   ASC_ExplorerRect(ctx,"header.strip",x,y,w,ctx.theme.header_height,ctx.theme.header_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"header.main",ASC_PRODUCT_NAME + " — Explorer Console",x+ctx.theme.padding,y+6,ctx.theme.text,12);
   ASC_ExplorerLabel(ctx,"header.sub",ASC_ExplorerFitText("Wrapper " + ASC_WRAPPER_VERSION + " | Explorer " + ASC_EXPLORER_SUBSYSTEM_VERSION + " | Active " + ASC_ACTIVE_CAPABILITY + " | Next " + ASC_NEXT_CAPABILITY,w-320),x+ctx.theme.padding,y+24,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,"header.time",ASC_ExplorerFitText("Server " + runtime.server_clean + " | Time " + ASC_DateTimeText(TimeTradeServer()) + " | Density " + ASC_ExplorerDensityText(settings.explorer_density_mode),300),x+w-310,y+16,ctx.theme.dim);
   color warmup_color=(runtime.mode==ASC_RUNTIME_WARMUP || !runtime.warmup_minimum_met ? ctx.theme.warning : (runtime.background_hydration_active ? ctx.theme.accent : ctx.theme.good));
   int panel_x=x+ctx.theme.padding;
   int panel_y=y+42;
   int panel_w=w-(ctx.theme.padding*2);
   int panel_h=ctx.theme.header_height-50;
   ASC_ExplorerRect(ctx,"header.status.panel",panel_x,panel_y,panel_w,panel_h,ctx.theme.panel_soft_fill,ctx.theme.border);
   ASC_ExplorerRect(ctx,"header.status.bar",panel_x,panel_y,5,panel_h,warmup_color,warmup_color);
   ASC_ExplorerLabel(ctx,"header.warmup.mode",ASC_ExplorerFitText(ASC_ExplorerWarmupModeText(runtime),panel_w-18),panel_x+12,panel_y+6,warmup_color,10);
   ASC_ExplorerLabel(ctx,"header.warmup.primary",ASC_ExplorerFitText(ASC_ExplorerPrimaryBucketLoadingText(runtime),panel_w-18),panel_x+12,panel_y+22,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,"header.warmup.background",ASC_ExplorerFitText(ASC_ExplorerBackgroundCompletionText(runtime),panel_w-18),panel_x+12,panel_y+38,ctx.theme.muted);
   ASC_ExplorerLabel(ctx,"header.warmup.pressure",ASC_ExplorerFitText("Bounded-work pressure: " + prepared.diagnostics.bounded_work_pressure_summary,panel_w-18),panel_x+12,panel_y+54,(!runtime.degraded ? ctx.theme.dim : ctx.theme.warning));
   string page_switch_label=(ctx.nav.pending_page_switch_action!="" ? ctx.nav.pending_page_switch_action : "none");
   string timing_line="Last prep " + ASC_ExplorerTimingMsText(prepared.diagnostics.bucket_prep_total_ms)
      + " | HUD render " + ASC_ExplorerTimingMsText(ctx.nav.last_render_duration_ms)
      + " | Page switch " + ASC_ExplorerTimingMsText(ctx.nav.last_page_switch_action_to_render_ms)
      + " (" + page_switch_label + ")";
   ASC_ExplorerLabel(ctx,"header.warmup.timing",ASC_ExplorerFitText(timing_line,panel_w-18),panel_x+12,panel_y+70,ctx.theme.dim);
  }

void ASC_ExplorerRenderNavStrip(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,const ASC_PreparedBucketState &prepared,ASC_SymbolState &states[],const int count,const int chart_w)
  {
   int y=ctx.theme.margin+ctx.theme.header_height+ctx.theme.gap;
   ASC_ExplorerRect(ctx,"nav.strip",ctx.theme.margin,y,chart_w-(ctx.theme.margin*2),ctx.theme.nav_height,ctx.theme.panel_alt_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"nav.current","Current View: " + ASC_ExplorerViewText(ctx.nav.current_view),ctx.theme.margin+ctx.theme.padding,y+7,ctx.theme.text);
   if(settings.explorer_show_breadcrumbs)
      ASC_ExplorerLabel(ctx,"nav.breadcrumb",ASC_ExplorerFitText(ASC_ExplorerBreadcrumbText(ctx,prepared,states,count),chart_w-260),ctx.theme.margin+170,y+7,ctx.theme.muted);
  }

void ASC_ExplorerRenderControlRail(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,ASC_SymbolState &states[],const int count,const int x,const int y,const int w,const int h)
  {
   ASC_ExplorerRect(ctx,"rail.panel",x,y,w,h,ctx.theme.rail_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"rail.title","Global Rail",x+ctx.theme.padding,y+8,ctx.theme.text,10);
   int button_y=y+26;
   int button_gap=(ctx.theme.gap>4 ? ctx.theme.gap-1 : ctx.theme.gap);
   int button_w=w-(ctx.theme.padding*2);
   ASC_ExplorerButton(ctx,"action.home","Home",x+ctx.theme.padding,button_y,button_w,ctx.theme.button_height,ctx.theme.accent,(ctx.nav.current_view==ASC_EXPLORER_VIEW_OVERVIEW));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.back","Back",x+ctx.theme.padding,button_y,button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.overview","Overview",x+ctx.theme.padding,button_y,button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.current_view==ASC_EXPLORER_VIEW_OVERVIEW));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.buckets","Buckets",x+ctx.theme.padding,button_y,button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.current_view==ASC_EXPLORER_VIEW_BUCKETS || ctx.nav.current_view==ASC_EXPLORER_VIEW_BUCKET_DETAIL));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.symbol_detail","Symbol",x+ctx.theme.padding,button_y,button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.current_view==ASC_EXPLORER_VIEW_SYMBOL_DETAIL));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.stat_detail","Stat Detail",x+ctx.theme.padding,button_y,button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill,(ctx.nav.current_view==ASC_EXPLORER_VIEW_STAT_DETAIL));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.density","Density",x+ctx.theme.padding,button_y,button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   button_y+=ctx.theme.button_height+(button_gap*2);
   bool filter_surface=(ctx.nav.current_view==ASC_EXPLORER_VIEW_BUCKETS || ctx.nav.current_view==ASC_EXPLORER_VIEW_BUCKET_DETAIL);
   ASC_ExplorerButton(ctx,"action.market_filter.all","All Symbols",x+ctx.theme.padding,button_y,button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill,(filter_surface && ctx.nav.market_filter==ASC_EXPLORER_FILTER_ALL_SYMBOLS));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.market_filter.open","Open Only",x+ctx.theme.padding,button_y,button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill,(filter_surface && ctx.nav.market_filter==ASC_EXPLORER_FILTER_OPEN_ONLY));
   button_y+=ctx.theme.button_height+button_gap;
   ASC_ExplorerButton(ctx,"action.refresh","Refresh",x+ctx.theme.padding,button_y,button_w,ctx.theme.button_height,ctx.theme.panel_alt_fill);
   button_y+=ctx.theme.button_height+(button_gap*2);
   ASC_ExplorerRect(ctx,"rail.state.box",x+ctx.theme.padding,button_y,button_w,70,ctx.theme.panel_soft_fill,ctx.theme.border);
   ASC_ExplorerLabel(ctx,"rail.state","Focus",x+ctx.theme.padding+8,button_y+6,ctx.theme.text,10);
   ASC_ExplorerLabel(ctx,"rail.view",ASC_ExplorerFitText(ASC_ExplorerViewText(ctx.nav.current_view),button_w-16),x+ctx.theme.padding+8,button_y+24,ctx.theme.accent);
   ASC_ExplorerLabel(ctx,"rail.filter","Filter " + ASC_ExplorerMarketFilterText(ctx.nav.market_filter),x+ctx.theme.padding+8,button_y+40,(ctx.nav.market_filter==ASC_EXPLORER_FILTER_OPEN_ONLY ? ctx.theme.good : ctx.theme.dim));
   ASC_ExplorerLabel(ctx,"rail.density","Density " + ASC_ExplorerDensityText(settings.explorer_density_mode),x+ctx.theme.padding+8,button_y+56,ctx.theme.dim);
  }

void ASC_ExplorerRenderStatusStrip(ASC_ExplorerContext &ctx,const ASC_RuntimeState &runtime,const int x,const int y,const int w,const int chart_w,const int chart_h)
  {
   string base_text=(runtime.degraded ? "Attention: bounded work remains active; some symbols are queued for the next heartbeat." : "Runtime is within the current bounded-work budget.");
   string readiness_text="Warmup " + IntegerToString(runtime.warmup_progress_percent) + "% | Initial " + IntegerToString(runtime.initial_symbols_assessed) + "/" + IntegerToString(runtime.symbol_count) + " | Primary " + IntegerToString(runtime.primary_bucket_symbols_assessed) + "/" + IntegerToString(runtime.primary_bucket_symbol_count);
   string status_text=base_text + " | " + readiness_text + " | Server " + runtime.server_clean + " | " + IntegerToString(chart_w) + "x" + IntegerToString(chart_h);
   ASC_ExplorerRect(ctx,"status.strip",x,y,w,ctx.theme.status_height,ctx.theme.panel_alt_fill,ctx.theme.border);
   ASC_ExplorerRect(ctx,"status.bar",x,y,5,ctx.theme.status_height,(runtime.degraded ? ctx.theme.warning : ctx.theme.good),(runtime.degraded ? ctx.theme.warning : ctx.theme.good));
   ASC_ExplorerLabel(ctx,"status.text",ASC_ExplorerFitText(status_text,w-24),x+ctx.theme.padding+4,y+7,(runtime.degraded ? ctx.theme.warning : ctx.theme.muted));
  }

void ASC_ExplorerRender(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,const ASC_PreparedBucketState &prepared,ASC_SymbolState &states[],const int count,ASC_Logger &logger)
  {
   long render_started_ms=GetTickCount();
   if(!settings.explorer_enabled)
     {
      logger.Info("Explorer","render skipped because explorer is disabled");
      return;
     }

   int chart_w=(int)ChartGetInteger(ctx.chart_id,CHART_WIDTH_IN_PIXELS,0);
   int chart_h=(int)ChartGetInteger(ctx.chart_id,CHART_HEIGHT_IN_PIXELS,0);
   if(chart_w<480 || chart_h<300)
     {
      logger.Warn("Explorer","render aborted because chart is too small: " + IntegerToString(chart_w) + "x" + IntegerToString(chart_h));
      return;
     }

   ASC_ExplorerThemeDefaults(ctx.theme,settings.explorer_density_mode);
   ASC_ExplorerBeginFrame(ctx);
   int root_w=chart_w-(ctx.theme.margin*2);
   int root_h=chart_h-(ctx.theme.margin*2);
   if(root_w<440 || root_h<260)
     {
      logger.Warn("Explorer","fallback render activated for root size " + IntegerToString(root_w) + "x" + IntegerToString(root_h));
      ASC_ExplorerRect(ctx,"root.compact",ctx.theme.margin,ctx.theme.margin,root_w,root_h,ctx.theme.background,ctx.theme.border);
      ASC_ExplorerLabel(ctx,"compact.title","ASC Explorer HUD",ctx.theme.margin+12,ctx.theme.margin+12,ctx.theme.text,11);
      ASC_ExplorerLabel(ctx,"compact.server",ASC_ExplorerFitText("Server " + runtime.server_clean + " | View " + ASC_ExplorerViewText(ctx.nav.current_view),root_w-24),ctx.theme.margin+12,ctx.theme.margin+32,ctx.theme.muted);
      ASC_ExplorerLabel(ctx,"compact.state",ASC_ExplorerFitText("Filter " + ASC_ExplorerMarketFilterText(ctx.nav.market_filter) + " | Mode " + ASC_BucketDisplayModeText(ctx.nav.bucket_display_mode),root_w-24),ctx.theme.margin+12,ctx.theme.margin+50,(ctx.nav.market_filter==ASC_EXPLORER_FILTER_OPEN_ONLY ? ctx.theme.good : ctx.theme.dim));
      ASC_ExplorerLabel(ctx,"compact.status",ASC_ExplorerFitText((runtime.degraded ? "Degraded runtime" : ASC_RuntimeModeText(runtime.mode)) + " | Warmup " + IntegerToString(runtime.warmup_progress_percent) + "% | Chart " + IntegerToString(chart_w) + "x" + IntegerToString(chart_h),root_w-24),ctx.theme.margin+12,ctx.theme.margin+68,(runtime.degraded ? ctx.theme.warning : (runtime.mode==ASC_RUNTIME_WARMUP ? ctx.theme.warning : ctx.theme.good)));
      ASC_ExplorerEndFrame(ctx);
      ChartRedraw(ctx.chart_id);
      ctx.nav.last_render_duration_ms=GetTickCount()-render_started_ms;
      if(ctx.nav.pending_page_switch_timing)
        {
         ctx.nav.last_page_switch_action_to_render_ms=GetTickCount()-ctx.nav.pending_page_switch_started_ms;
         ctx.nav.pending_page_switch_timing=false;
        }
      ctx.nav.last_render_at=TimeCurrent();
      ctx.nav.dirty=false;
      return;
     }
   logger.Debug("Explorer","render entry server=" + runtime.server_clean + ", view=" + ASC_ExplorerViewText(ctx.nav.current_view) + ", filter=" + ASC_ExplorerMarketFilterText(ctx.nav.market_filter) + ", mode=" + ASC_BucketDisplayModeText(ctx.nav.bucket_display_mode) + ", chart=" + IntegerToString(chart_w) + "x" + IntegerToString(chart_h));
   ASC_ExplorerRect(ctx,"root",ctx.theme.margin,ctx.theme.margin,root_w,root_h,ctx.theme.background,ctx.theme.border);
   ASC_ExplorerRenderHeader(ctx,settings,runtime,prepared,chart_w);
   ASC_ExplorerRenderNavStrip(ctx,settings,runtime,prepared,states,count,chart_w);

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
         ASC_ExplorerRenderBucketList(ctx,prepared,main_x,main_y,content_w,main_h);
         break;
      case ASC_EXPLORER_VIEW_BUCKET_DETAIL:
         ASC_ExplorerRenderBucketDetail(ctx,prepared,main_x,main_y,content_w,main_h);
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

   ASC_ExplorerRenderStatusStrip(ctx,runtime,main_x,main_y+main_h+ctx.theme.gap,chart_w-(ctx.theme.margin*2)-(ctx.theme.padding*2),chart_w,chart_h);
   ASC_ExplorerEndFrame(ctx);
   ChartRedraw(ctx.chart_id);
   ctx.nav.last_render_duration_ms=GetTickCount()-render_started_ms;
   if(ctx.nav.pending_page_switch_timing)
     {
      ctx.nav.last_page_switch_action_to_render_ms=GetTickCount()-ctx.nav.pending_page_switch_started_ms;
      ctx.nav.pending_page_switch_timing=false;
     }
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
   ctx.nav.bucket_page=0;
   ctx.nav.bucket_symbol_page=0;
   ctx.nav.selected_bucket_index=0;
   ctx.nav.selected_symbol_index=-1;
   ctx.nav.bucket_display_mode=ASC_BUCKET_DISPLAY_TOP_3;
   ctx.nav.market_filter=ASC_EXPLORER_FILTER_ALL_SYMBOLS;
   ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_NONE;
   ctx.nav.selected_seed_symbol="";
   ctx.nav.dirty=true;
   ctx.nav.last_render_at=0;
   ctx.nav.last_render_duration_ms=0;
   ctx.nav.last_page_switch_action_to_render_ms=0;
   ctx.nav.pending_page_switch_started_ms=0;
   ctx.nav.pending_page_switch_timing=false;
   ctx.nav.pending_page_switch_action="";
   ArrayResize(ctx.frame_objects,0);
   ArrayResize(ctx.previous_frame_objects,0);
   ctx.initialized=true;
  }

void ASC_ExplorerShutdown(ASC_ExplorerContext &ctx)
  {
   if(!ctx.initialized)
      return;
   ASC_ExplorerDeleteOwnedObjects(ctx);
   ArrayResize(ctx.frame_objects,0);
   ArrayResize(ctx.previous_frame_objects,0);
   ctx.initialized=false;
  }

void ASC_ExplorerMaybeRender(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,const ASC_PreparedBucketState &prepared,ASC_SymbolState &states[],const int count,const bool force,ASC_Logger &logger)
  {
   if(!ctx.initialized || !settings.explorer_enabled)
     {
      if(settings.explorer_enabled)
         logger.Warn("Explorer","maybe-render called before init");
      return;
     }
   datetime now=TimeCurrent();
   if(!force && !ctx.nav.dirty && ctx.nav.last_render_at>0 && (now-ctx.nav.last_render_at)<settings.explorer_refresh_seconds)
      return;
   ASC_ExplorerRender(ctx,settings,runtime,prepared,states,count,logger);
  }

void ASC_ExplorerAdjustScroll(ASC_ExplorerContext &ctx,const ASC_RuntimeSettings &settings,const int direction)
  {
   int step=(settings.explorer_scroll_step_rows>0 ? settings.explorer_scroll_step_rows : 1);
   switch(ctx.nav.current_view)
     {
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

void ASC_ExplorerHandleAction(ASC_ExplorerContext &ctx,ASC_RuntimeSettings &settings,const ASC_RuntimeState &runtime,const ASC_PreparedBucketState &prepared,const string object_name,ASC_SymbolState &states[],const int count,ASC_Logger &logger)
  {
   string action=object_name;
   StringReplace(action,ctx.prefix,"");
   ASC_ExplorerView before_view=ctx.nav.current_view;
   int before_bucket=ctx.nav.selected_bucket_index;
   int before_symbol=ctx.nav.selected_symbol_index;
   ASC_ExplorerStatView before_stat=ctx.nav.selected_stat_view;

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
      ctx.nav.bucket_symbol_page=0;
      ctx.nav.dirty=true;
     }
   else if(action=="action.bucket_mode.top5")
     {
      ctx.nav.bucket_display_mode=ASC_BUCKET_DISPLAY_TOP_5;
      ctx.nav.bucket_symbol_page=0;
      ctx.nav.dirty=true;
     }
   else if(action=="action.bucket_mode.all")
     {
      ctx.nav.bucket_display_mode=ASC_BUCKET_DISPLAY_ALL;
      ctx.nav.bucket_symbol_page=0;
      ctx.nav.dirty=true;
     }
   else if(action=="action.market_filter.all")
     {
      ctx.nav.market_filter=ASC_EXPLORER_FILTER_ALL_SYMBOLS;
      ctx.nav.bucket_page=0;
      ctx.nav.bucket_symbol_page=0;
      ctx.nav.dirty=true;
     }
   else if(action=="action.market_filter.open")
     {
      ctx.nav.market_filter=ASC_EXPLORER_FILTER_OPEN_ONLY;
      ctx.nav.bucket_page=0;
      ctx.nav.bucket_symbol_page=0;
      ctx.nav.dirty=true;
     }
   else if(StringFind(action,"action.bucket_page.")==0)
     {
      ctx.nav.bucket_page=(int)StringToInteger(StringSubstr(action,StringLen("action.bucket_page.")));
      ctx.nav.dirty=true;
     }
   else if(StringFind(action,"action.bucket_symbol_page.")==0)
     {
      ctx.nav.bucket_symbol_page=(int)StringToInteger(StringSubstr(action,StringLen("action.bucket_symbol_page.")));
      ctx.nav.dirty=true;
     }
   else if(StringFind(action,"action.bucket.")==0)
     {
      ctx.nav.selected_bucket_index=(int)StringToInteger(StringSubstr(action,StringLen("action.bucket.")));
      ctx.nav.bucket_symbol_page=0;
      ctx.nav.selected_seed_symbol="";
      ctx.nav.selected_symbol_index=-1;
      ctx.nav.selected_stat_view=ASC_EXPLORER_STAT_NONE;
      ASC_ExplorerOpenView(ctx,ASC_EXPLORER_VIEW_BUCKET_DETAIL);
     }
   else if(StringFind(action,"action.seed_symbol.")==0)
     {
      int seed_index=(int)StringToInteger(StringSubstr(action,StringLen("action.seed_symbol.")));
      ASC_BucketViewModel filtered[];
      int source_indices[];
      int bucket_total=ASC_PreparedFilteredBuckets(prepared,ctx.nav.market_filter,filtered,source_indices);
      if(ctx.nav.selected_bucket_index<0 || ctx.nav.selected_bucket_index>=bucket_total)
         return;
      ASC_BucketPreparedSymbol resolved[];
      ASC_PreparedBucketSymbols(prepared,filtered[ctx.nav.selected_bucket_index],resolved);
      ASC_BucketPreparedSymbol visible_symbols[];
      ArrayResize(visible_symbols,0);
      for(int i=0;i<ArraySize(resolved);i++)
        {
         bool include=(ctx.nav.market_filter==ASC_EXPLORER_FILTER_ALL_SYMBOLS);
         if(ctx.nav.market_filter==ASC_EXPLORER_FILTER_OPEN_ONLY)
            include=resolved[i].open_now;
         if(include)
           {
            int slot=ArraySize(visible_symbols);
            ArrayResize(visible_symbols,slot+1);
            visible_symbols[slot]=resolved[i];
           }
        }
      int display_count=ArraySize(visible_symbols);
      if(ctx.nav.bucket_display_mode!=ASC_BUCKET_DISPLAY_ALL)
        {
         int limit=ASC_BucketDisplayLimit(filtered[ctx.nav.selected_bucket_index],ctx.nav.bucket_display_mode);
         if(display_count>limit)
            display_count=limit;
        }
      if(seed_index<0 || seed_index>=display_count)
         return;
      ctx.nav.selected_symbol_index=visible_symbols[seed_index].symbol_state_index;
      ctx.nav.selected_seed_symbol=visible_symbols[seed_index].live_symbol;
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

   ASC_ExplorerMaybeStartPageSwitchTiming(ctx,action,before_view,before_bucket,before_symbol,before_stat);
   logger.Debug("Explorer","action " + action + " dispatched");
  }

#endif
