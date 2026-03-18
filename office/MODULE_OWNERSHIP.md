# MODULE OWNERSHIP

## Interpretation Rule
The ownership names below are logical domains, not required terminal folders.
Ownership does not authorize nested MT5 deployment folders.

## Active Build Workers
### First Slice
- Engine worker -> Runtime Engine domain -> expected product files such as `ASC_Engine.*`
- Market worker -> Market Identity domain -> expected product files such as `ASC_Market.*`
- Conditions worker -> Conditions domain -> expected product files such as `ASC_Conditions.*`
- Storage + Output worker -> Broker Storage and Summary Output domains -> expected product files such as `ASC_Storage.*` and `ASC_Output.*`

### Second Slice
- Surface worker -> Surface domain -> expected product files such as `ASC_Surface.*`
- Ranking worker -> Ranking domain -> expected product files such as `ASC_Ranking.*`

### Later Slice
- Diagnostics worker -> Diagnostics domain -> expected product files such as `ASC_Diagnostics.*`
- UI worker -> UI domain -> expected product files such as `ASC_UI.*`

## Idle-Only Post-Run Workers
- Clerk worker -> logging, ledger updates, repo-state normalization
- Debug worker -> repo-wide integrity inspection and drift detection

## High-Friction Zones
- Common domain
- Engine domain
- Storage domain
