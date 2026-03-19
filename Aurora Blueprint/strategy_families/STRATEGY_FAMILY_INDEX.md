# STRATEGY FAMILY INDEX

## PURPOSE

This folder is the organized strategy-family layer for Aurora Blueprint.

It exists to make the strategy side of Aurora:
- clear
- modular
- future-wrapper friendly
- future-EA friendly
- easy to recover without rereading scattered doctrine files

This folder should become the main organized family workspace.

It is designed to sit between:
- high-level doctrine (`AURORA_STRATEGY_FAMILY_REGISTRY.md`)
and
- future implementation or wrapper layers

That means this folder is where strategy families become:
- clearly named
- structurally placed
- bounded by habitat
- bounded by anti-confusions
- easier to translate into later family cards, wrappers, and EA logic

---

# 1. FOLDER LOGIC

## Core family files
These are the first direct Aurora families that inherit from current Wave 1 doctrine.

Stored in:
- `Aurora Blueprint/strategy_families/CORE/`

## Conditional family registry
These are real and preserved, but require more context or more doctrine before becoming core.

Stored in:
- `Aurora Blueprint/strategy_families/CONDITIONAL/`

## Preserved non-chart-native family registry
These are academically real families Aurora should not lose, but they are not clean chart-only core families yet.

Stored in:
- `Aurora Blueprint/strategy_families/PRESERVED/`

## Starter build file
This is the practical bridge that explains which family pack should be built first.

Stored in:
- `Aurora Blueprint/strategy_families/AURORA_STARTER_FAMILY_BUILD.md`

---

# 2. CORE FAMILY FILES

## Current first-pack files
- `CORE/Trend_Continuation.md`
- `CORE/Trend_Pullback_Continuation.md`
- `CORE/Breakout_Compression_Release.md`
- `CORE/Failed_Break_Trap_Reversal.md`
- `CORE/Balance_Rotation_Range_Mean_Reversion.md`

These files should be treated as the first build-ready family stack.

---

# 3. CONDITIONAL / PRESERVED FILES

## Conditional families
- `CONDITIONAL/CONDITIONAL_FAMILY_REGISTRY.md`

## Preserved non-chart-native families
- `PRESERVED/PRESERVED_NON_CHART_NATIVE_REGISTRY.md`

These files exist so Aurora does not lose valid strategy families just because they are not yet part of the first build pack.

---

# 4. INPUT HIERARCHY FOR THIS FOLDER

When family files are updated, use this hierarchy:

1. `Aurora Blueprint/AURORA_STRATEGY_FAMILY_REGISTRY.md`
2. consolidated Wave 1 doctrine files
3. Wave 1 integrated / strengthening lineage files if needed
4. source-pass files only for clarification or deferred residue recovery

Do not let older scaffold doctrine control family files when consolidated or registry truth exists.

---

# 5. FUTURE WRAPPER / EA USE

This folder is intentionally shaped so a future GPT wrapper or EA design layer can consume it in a stable way.

Each core family file should eventually provide:
- family name
- canonical idea
- native habitat
- anti-habitat
- structural signatures
- anti-confusions
- future pattern dependencies
- future testing notes

That makes these files suitable for later transformation into:
- family cards
- wrapper prompts
- EA strategy modules
- family-level review templates

---

# 6. CURRENT JUDGMENT

Aurora no longer needs to keep strategy knowledge trapped inside one large registry file.

This folder exists to make the family layer modular, explicit, and future-buildable.
