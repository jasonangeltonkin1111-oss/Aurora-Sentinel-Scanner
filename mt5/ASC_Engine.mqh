#ifndef __ASC_ENGINE_MQH__
#define __ASC_ENGINE_MQH__

#include "ASC_Common.mqh"
#include "ASC_Market.mqh"

bool ASC_Engine_RunOnce(const ASC_RuntimeConfig &config)
  {
   string discovered_symbols[];
   if(!ASC_Market_DiscoverSymbols(discovered_symbols))
      return false;

   for(int i = 0; i < ArraySize(discovered_symbols); i++)
     {
      ASC_SymbolRecord record;
      ASC_Market_BuildIdentityAndTruth(discovered_symbols[i], config, record);
     }

   return true;
  }

#endif
