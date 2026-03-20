# ASC Source Evidence Map

## Purpose

This file maps major conclusions in this pack back to the uploaded archive source locations.

## Active blueprint basis

### `blueprint/00_ASC_LANGUAGE_AND_BOUNDARY_RULES.md`
Used for:
- human-facing naming laws
- mechanic-label separation
- symbol-file-first / summary-later discipline

### `blueprint/01_ASC_SYSTEM_OVERVIEW.md`
Used for:
- runtime spine
- discovery module naming
- five processing layers

### `blueprint/02_ASC_RUNTIME_AND_SCHEDULER.md`
Used for:
- heartbeat model
- due items
- bounded work
- runtime modes
- dispatch priority

### `blueprint/03_ASC_DISCOVERY_AND_STATE_MODULES.md`
Used for:
- collector/store/accessor doctrine
- SymbolSpecs and MarketWatchFeed roles
- completeness/availability classes

### `blueprint/04_ASC_FIVE_LAYER_MODEL.md`
Used for:
- current 5-layer ownership model

### `blueprint/05_ASC_FIELD_CADENCE_AND_REFRESH_POLICY.md`
Used for:
- cadence classes
- write minimization
- in-memory vs publication separation

### `blueprint/06_ASC_SYMBOL_FILES_AND_PUBLICATION.md`
Used for:
- dossier evolution
- section ownership
- atomic publication laws

### `blueprint/07_ASC_MT5_STRUCTURE_MAP.md`
Used for:
- future semantic MT5 source layout

### `blueprint/08_ASC_FOUNDATION_PASS_ONE.md`
Used for:
- current blocked scope
- server-only identity
- storage structure
- foundation dossier language

## Runtime depth canon

### `archives/Asc Archive 2/ASC Blueprint/01_ASC_SYSTEM_BLUEPRINT.md`
Used for:
- overall scanner mission and core laws

### `.../02_ASC_RUNTIME_NERVOUS_SYSTEM.md`
Used for:
- runtime “nervous system”
- debt/budgets/fairness/degradation
- stronger scheduler doctrine

### `.../03_ASC_DATA_PERSISTENCE_AND_PUBLICATION.md`
Used for:
- persistence classes
- publication philosophy
- one-symbol-one-file law

### `.../04_ASC_SURFACE_RANKING_AND_DEEP_ENRICHMENT.md`
Used for:
- deeper market-truth evidence model
- promotion meaning
- deep selective-analysis framing

### `.../05_ASC_BUILD_STAGES_AND_ACCEPTANCE.md`
Used for:
- implementation order
- acceptance thinking

### `.../06_ASC_REFOUNDATION_AUDIT_AND_RUNTIME_CANON.md`
Used for:
- lineage survival from AFS, EA1, ISSX
- contradiction resolution
- refoundation logic

## Older archive contracts

### `archives/Asc Archive/blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`
Used for:
- restore-first persistence
- temp/stage/final promotion doctrine
- gap-fill mentality

### `archives/Asc Archive/blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md`
Used for:
- validity/stale/unknown/incomplete categories
- no fake zero law

### `archives/Asc Archive/blueprint/LAYER_MODEL.md`
Used for:
- older 3-layer ancestry and mapping

### `archives/Asc Archive/blueprint/MODULE_MAP.md`
Used for:
- domain boundaries
- logical module families

### `archives/Asc Archive/blueprint/OUTPUT_CONTRACT.md`
Used for:
- trader-facing output purity concept

### `archives/Asc Archive/blueprint/PERSISTENCE_CONTRACT.md`
Used for:
- restore-first startup contract ancestry

### `archives/Asc Archive/blueprint/RANKING_AND_PROMOTION_CONTRACT.md`
Used for:
- promotion is budget assignment, not trade decision

## Current foundation code

### `mt5_runtime_flat/ASC_F1_Common.mqh`
Used for:
- current enums/types/path/runtime state skeleton

### `mt5_runtime_flat/ASC_F1_ServerPaths.mqh`
Used for:
- current server-root file layout

### `mt5_runtime_flat/ASC_F1_MarketState.mqh`
Used for:
- current Layer 1 implementation shape
- `SymbolInfoTick` + session usage
- next-check scheduling style

### `mt5_runtime_flat/ASC_F1_FileIO.mqh`
Used for:
- current temp/final/last-good style

### `mt5_runtime_flat/ASC_F1_Dossiers.mqh`
Used for:
- current human-readable dossier top shape

### `mt5_runtime_flat/AuroraSentinel_Foundation.mq5`
Used for:
- current `OnInit`/`OnTimer` foundation heartbeat loop

## Legacy lineage

### `archives/LEGACY_SYSTEMS/AFS`
Used for:
- continuity, dossier, and layered-scanner lessons

### `archives/LEGACY_SYSTEMS/ISSX`
Used for:
- service/debt/runtime thinking

### `archives/LEGACY_SYSTEMS/Old EAS`
Used for:
- older timer orchestration patterns and anti-pattern recognition

## Final authority rule

If these sources disagree:
1. active `blueprint/`
2. `Asc Archive 2` runtime depth canon
3. current `mt5_runtime_flat/` as implementation seed
4. older archive contracts as translation guardrails
5. legacy systems as lineage only
