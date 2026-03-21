# ASC Explorer, Bucketing, and Menu Integration Sequence

## Purpose

This file is the integration bridge for the recent ASC blueprint expansion pack.

It exists so the new blueprint surfaces can be consumed cleanly without ambiguity by later implementation work, even before the older canon files are fully rewritten in-place.

The expansion pack added:
- `11_ASC_SYMBOL_IDENTITY_AND_BUCKETING.md`
- `12_ASC_EXPLORER_HUD_AND_NAVIGATION.md`
- `13_ASC_MENU_AND_OPERATOR_SURFACE_EXPANSION.md`

This file explains exactly how they bind back into the existing canon.

## Canon binding map

### Existing canon file: `01_ASC_SYSTEM_OVERVIEW.md`
Read together with:
- `11_ASC_SYMBOL_IDENTITY_AND_BUCKETING.md`
- `12_ASC_EXPLORER_HUD_AND_NAVIGATION.md`
- `13_ASC_MENU_AND_OPERATOR_SURFACE_EXPANSION.md`

Interpretation:
- the overview still defines ASC as a scanner and presentation surface
- identity and bucketing now clarify how ASC will answer what a symbol is
- the explorer HUD now clarifies how prepared truth will be navigated and viewed
- the menu expansion now clarifies how operator configuration will remain stable as the system grows
- runtime-owned focus elevation, stale-bound refresh, and atomic rolling persistence are now system laws rather than loose explorer hints

### Existing canon file: `04_ASC_FIVE_LAYER_MODEL.md`
Read together with:
- `11_ASC_SYMBOL_IDENTITY_AND_BUCKETING.md`
- `12_ASC_EXPLORER_HUD_AND_NAVIGATION.md`

Interpretation:
- the five ordered capabilities remain the explicit ordered implementation stack
- Symbol Identity and Bucketing is a parallel future capability surface that supports later filtering, shortlist construction, explorer views, and canonical trade-state matching
- the explorer HUD is not a sixth compute layer and must not be treated as one
- the explorer is a presentation and navigation subsystem that consumes prepared state
- focused-symbol expansion remains runtime-owned and later combined-summary lanes remain separate from the bucket-preserving shortlist
- focus requests are capability-stage-bound and cannot unlock inactive downstream work

### Existing canon file: `07_ASC_MT5_STRUCTURE_MAP.md`
Read together with:
- `11_ASC_SYMBOL_IDENTITY_AND_BUCKETING.md`
- `12_ASC_EXPLORER_HUD_AND_NAVIGATION.md`

Interpretation:
- identity and bucketing should eventually become a clear semantic domain rather than disappearing into `Common`
- the explorer should eventually become a real presentation subsystem with layout, widgets, state, theme, and actions separated cleanly
- the first operator surface should consume a compressed six-bucket Layer 1 adapter (`FX`, `Indices`, `Metals`, `Energy`, `Crypto`, `Stocks`) while richer classification truth stays attached to prepared symbols
- the presentation domain must remain a consumer of prepared truth rather than a hidden scanner engine

### Existing canon file: `10_ASC_MENU_AND_TESTABILITY.md`
Read together with:
- `13_ASC_MENU_AND_OPERATOR_SURFACE_EXPANSION.md`
- `12_ASC_EXPLORER_HUD_AND_NAVIGATION.md`

Interpretation:
- the original file remains the foundation-stage menu and staged testing contract
- the menu expansion defines the future group growth path so the menu can mature without naming churn or retrofit pain
- the explorer HUD document clarifies which interactions belong in the live explorer rather than in the EA properties menu
- testability now explicitly includes focus elevation, snapshot reuse, and no-heavy-compute-in-HUD proofs

## Authority note

When these files are read together, the authority order remains:
1. active blueprint canon
2. active runtime code when verifying what is already implemented
3. legacy archive evidence only as translation support

The legacy AFS classification source remains evidence for field shape and normalization behavior, not active authority.

## Immediate implementation meaning

For upcoming implementation work, the system should now be read as having:
- one active capability: Market State Detection
- one future identity and bucketing surface reserved for activation before deeper shortlist work
- one future explorer HUD subsystem reserved as the interactive presentation surface
- one expanded menu/operator design reserved to prevent future structural breakage
- one general law that all HUD-visible fields must flow through prepared runtime truth, owned cadence, stale boundaries, and adapter snapshots

## Runtime/HUD operating bridge

The system must now be implemented with the following binding rules:
- focus requests travel from explorer to runtime as bounded attention requests, not as compute commands
- runtime decides whether the current capability stage permits elevation for the focused object
- field refresh tier and stale boundary decide whether any actual recomputation occurs
- changed truth persists atomically by owned section or prepared snapshot surface
- explorer redraws reuse prepared snapshots until invalidated
- focus change or exit removes elevated work promptly while preserving honest last-good display state
- runtime-owned Layer 1 readiness must gate warmup versus steady mode using first-pass coverage of the live universe and compressed priority-set-1 buckets, not dossier-missing count alone

These rules apply generally across overview, bucket, symbol, stat, shortlist, deep-analysis, and Aurora-reserved surfaces.

## Future build order implied by this expansion

### Wave A
Thread identity and bucket records into the blueprint and reserved runtime structures
without widening into filtering logic yet.

### Wave B
Build the explorer shell:
- wrapper header
- overview page
- stable button routing
- layout engine
- breadcrumb and back stack
- adapter-fed overview and bucket list snapshots

### Wave C
Activate bucket-aware explorer views once identity and bucketing records are available.
Do so through prepared bucket membership and bucket detail snapshots rather than render-path classification.

### Wave D
Later activate bucket-preserving shortlist views, then combined cross-bucket summary views, while preserving the distinction between them.
These later surfaces must inherit the same stale-bound refresh, focus decay, and adapter laws rather than introducing HUD-side compute shortcuts.

### Wave E
Only after Aurora integration is mature, activate the later signal surface and semi-automatic path.
Aurora-reserved surfaces must still consume prepared runtime truth and bounded refresh rights.

## Non-negotiable boundaries

- explorer is not a scanner engine
- menu is not a navigation substitute
- focused symbol compute is runtime-owned, not HUD-owned
- dynamic bucket membership is runtime-prepared truth, not render-path reconstruction
- compressed Layer 1 main buckets must stay separate from later stock-region drilldown such as US/EU/HK
- combined cross-bucket summary does not replace bucket-preserving shortlist truth
- open-trade exclusion applies to the later combined lane, not to bucket truth itself
- no explorer interaction may justify full-universe recomputation by itself

## Final rule

Until the older canon files are rewritten in place, this file is the official bridge that binds the recent expansion pack back into the existing ASC blueprint canon.

Implementation work should follow this bridge rather than improvising its own interpretation.

## Version discipline bridge

Version bumps are mandatory for meaningful wrapper, explorer, menu, and dossier-contract edits.
Implementation work that changes these operator-facing surfaces must update the wrapper/header version and keep the blueprint wording aligned in the same pass.

## Dynamic bucket architecture bridge

The explorer bucket flow must now be read as dynamic-ready even before live identity activation:
- first-surface main bucket count is fixed at six compressed Layer 1 buckets (`FX`, `Indices`, `Metals`, `Energy`, `Crypto`, `Stocks`)
- per-bucket symbol count is not fixed at 3
- bucket detail mode is part of navigation state
- all-mode scrolling is owned by the symbol lane rather than by one rigid placeholder list
- bucket list and bucket detail must consume prepared bucket snapshots rather than raw identity catalogs
- prepared symbol rows beneath those buckets must retain the richer primary-bucket / sector / industry / theme / subtype truth for later detail surfaces

Placeholder taxonomy remains allowed as a temporary source, but only through an honest view-model layer that does not imply live broker membership.


## Warmup bridge

The explorer and menu surfaces must now assume a two-stage Layer 1 startup model:
- `ASC_RUNTIME_WARMUP` on boot and recovery
- `ASC_RUNTIME_STEADY` once the Layer 1 minimum readiness threshold is met

That threshold should be interpreted as:
- all currently discovered symbols inside compressed priority-set-1 buckets assessed at least once, and
- a configurable minimum portion of the currently discovered live universe assessed at least once

After promotion, lower-priority first-pass work may continue as background hydration.
HUD status and persisted continuity must keep this visible without forcing warmup to remain active forever.
