# ASC Blueprint

This folder is the clean working blueprint canon for the new ASC build.

It exists to describe the EA correctly before product code is rebuilt.
It is not legacy archive recovery, office workflow theater, or UI copy.

## Folder purpose

This blueprint canon defines:
- what ASC is
- what ASC is not
- how runtime ownership is divided
- how discovery, state, filtering, selection, deep analysis, publication, and presentation stay separate
- how naming must stay correct between internal mechanics and human-facing output
- how the future MT5 folder should be arranged

## Canon rules

1. Meaning-based names win over build-step names.
2. Internal mechanics, storage fields, and human-facing labels must remain separate.
3. The EA, HUD, and menu must never expose raw mechanic names such as `daily_change`.
4. The EA, HUD, and menu must never expose build chatter such as `Step 5`, `Layer 2`, `packet`, `wave`, or raw enum names.
5. Blueprint files may describe architecture layers and internal mechanics, but product-facing surfaces may not.
6. This folder is the active design canon for the new build. Older material remains in `archives/` for reference only.
7. Every meaningful wrapper or explorer edit must bump version according to the current version law; version changes are part of the product contract, not optional polish.

## File order

- `00_ASC_LANGUAGE_AND_BOUNDARY_RULES.md`
- `01_ASC_SYSTEM_OVERVIEW.md`
- `02_ASC_RUNTIME_AND_SCHEDULER.md`
- `03_ASC_DISCOVERY_AND_STATE_MODULES.md`
- `04_ASC_FIVE_LAYER_MODEL.md`
- `05_ASC_FIELD_CADENCE_AND_REFRESH_POLICY.md`
- `06_ASC_SYMBOL_FILES_AND_PUBLICATION.md`
- `07_ASC_MT5_STRUCTURE_MAP.md`
- `08_ASC_FOUNDATION_PASS_ONE.md`
- `09_ASC_AURORA_BRIDGE_REQUIREMENTS.md`
- `10_ASC_MENU_AND_TESTABILITY.md`
