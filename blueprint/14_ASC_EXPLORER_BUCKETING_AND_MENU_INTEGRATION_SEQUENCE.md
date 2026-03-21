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

### Existing canon file: `07_ASC_MT5_STRUCTURE_MAP.md`
Read together with:
- `11_ASC_SYMBOL_IDENTITY_AND_BUCKETING.md`
- `12_ASC_EXPLORER_HUD_AND_NAVIGATION.md`

Interpretation:
- identity and bucketing should eventually become a clear semantic domain rather than disappearing into `Common`
- the explorer should eventually become a real presentation subsystem with layout, widgets, state, theme, and actions separated cleanly
- the presentation domain must remain a consumer of prepared truth rather than a hidden scanner engine

### Existing canon file: `10_ASC_MENU_AND_TESTABILITY.md`
Read together with:
- `13_ASC_MENU_AND_OPERATOR_SURFACE_EXPANSION.md`
- `12_ASC_EXPLORER_HUD_AND_NAVIGATION.md`

Interpretation:
- the original file remains the foundation-stage menu and staged testing contract
- the menu expansion defines the future group growth path so the menu can mature without naming churn or retrofit pain
- the explorer HUD document clarifies which interactions belong in the live explorer rather than in the EA properties menu

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

### Wave C
Activate bucket-aware explorer views once identity and bucketing records are available.

### Wave D
Later activate bucket-preserving shortlist views, then combined cross-bucket summary views, while preserving the distinction between them.

### Wave E
Only after Aurora integration is mature, activate the later signal surface and semi-automatic path.

## Non-negotiable boundaries

- explorer is not a scanner engine
- menu is not a navigation substitute
- focused symbol compute is runtime-owned, not HUD-owned
- combined cross-bucket summary does not replace bucket-preserving shortlist truth
- open-trade exclusion applies to the later combined lane, not to bucket truth itself

## Final rule

Until the older canon files are rewritten in place, this file is the official bridge that binds the recent expansion pack back into the existing ASC blueprint canon.

Implementation work should follow this bridge rather than improvising its own interpretation.

## Version discipline bridge

Version bumps are mandatory for meaningful wrapper, explorer, menu, and dossier-contract edits.
Implementation work that changes these operator-facing surfaces must update the wrapper/header version and keep the blueprint wording aligned in the same pass.
