#ifndef __ASC_COMMON_MQH__
#define __ASC_COMMON_MQH__

struct ASC_SymbolIdentity
  {
   string RawSymbol;
  };

struct ASC_RuntimeConfig
  {
  };

struct ASC_SymbolRecord
  {
   ASC_SymbolIdentity Identity;

   string             CanonicalSymbol;
   string             AssetClass;
   string             PrimaryBucket;
   string             Sector;
   string             Industry;
   string             Theme;
   bool               ClassificationResolved;
   string             ClassificationReason;

   bool               Exists;
   bool               Selected;
   bool               Visible;
   bool               QuoteWindowOpen;
   bool               TradeWindowOpen;
   bool               TradeAllowed;
   string             SessionTruthStatus;
   bool               Layer1Eligible;
   datetime           LastQuoteTime;
   datetime           NextRecheckTime;
   string             IneligibleReason;
  };

bool ASC_Market_DiscoverSymbols(string &symbols[]);
bool ASC_Market_BuildIdentityAndTruth(const string symbol,const ASC_RuntimeConfig &config,ASC_SymbolRecord &record);
bool ASC_Engine_RunOnce(const ASC_RuntimeConfig &config);

#endif
