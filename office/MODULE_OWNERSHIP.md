# MODULE OWNERSHIP

## Interpretation Rule
The ownership names below are logical domains, not required terminal folders.
Ownership does not authorize nested MT5 deployment folders.

## Early Build Ownership
- Engine worker -> Engine domain -> expected product files such as `ASC_Engine.*`
- Market worker -> Market Identity domain -> expected product files such as `ASC_Market.*`
- Conditions worker -> Conditions domain -> expected product files such as `ASC_Conditions.*`
- Storage/Output worker -> Broker Storage and Summary Output domains -> expected product files such as `ASC_Storage.*` and `ASC_Output.*`

## Next Wave
- Surface worker -> Surface domain -> expected product files such as `ASC_Surface.*`
- Ranking worker -> Ranking domain -> expected product files such as `ASC_Ranking.*`

## Later
- Diagnostics worker -> Diagnostics domain -> expected product files such as `ASC_Diagnostics.*`
- UI worker -> UI domain -> expected product files such as `ASC_UI.*`

## High-Friction Zones
- Common domain
- Engine domain
- Storage domain
