# ASC Language and Boundary Rules

## Purpose

This document locks the naming boundary between:
- internal engineering language
- stored field language
- human-facing output language

ASC must be mechanically precise inside the runtime and easy to read on the HUD, menu, and published symbol files.

## Core law

One thing may have more than one name depending on where it lives.
That is not drift. That is correct separation.

## The three naming domains

### 1. Internal engineering language
Used inside code, runtime contracts, accessors, enums, dirty flags, and scheduler identifiers.

Examples:
- `daily_change`
- `last_tick_time`
- `LAYER_1_OPEN_CLOSED_STATE`
- `ATR_REFRESH_M5`

This language may be technical, compact, and mechanically useful.

### 2. Stored field language
Used in in-memory records and stable persisted schema keys.

Examples:
- `daily_change`
- `last_tick_time`
- `trade_allowed`
- `volume_min`

This language should remain stable, literal, and easy to map.
It should not drift because of HUD wording changes.

### 3. Human-facing output language
Used in:
- HUD
- menu
- operator panels
- symbol files meant for reading
- summary outputs

Examples:
- `Daily Change`
- `Last Tick Time`
- `Trade Allowed`
- `Minimum Volume`
- `Market Status`

This language must be readable and natural.
It must never look like variable names.

## Product-facing prohibition

The EA, HUD, menu, summary, and symbol files must not expose:
- `daily_change`
- `has_tick`
- `LAYER_3_FILTER`
- `STEP_05`
- `ATR_REFRESH_H1`
- `ASC_OUTCOME_INVALID_DATA`
- `packet`
- `wave`
- `debug mirror`

These are internal mechanics, not product language.

## Architecture term rule

Architecture terms may exist in blueprint documents and code comments where needed.
They may also exist in diagnostic logs when the audience is technical.
They may not become trader-facing labels.

Example:
- architecture term: `LAYER_1_OPEN_CLOSED_STATE`
- human-facing text: `Market Status`

## Meaning-based naming rule

Inside the product, names must describe what something is, not what build step created it.

Correct:
- `Market Watch`
- `Symbol Specifications`
- `Top List Selection`
- `Deep Analysis`
- `Market Status`

Incorrect:
- `Step 1`
- `Step 2`
- `Phase 3`
- `Layer 5` shown in HUD

## Human-facing formatting rule

Human-facing labels should use title case and natural wording.

Examples:
- `Daily Change`
- `Bid High`
- `Ask Low`
- `Open Price`
- `Close Price`
- `Quote Sessions`
- `Trade Sessions`
- `Selection Status`
- `ATR (H1)`

## Writer purity rule

Publication and HUD rendering may format labels.
They may not invent meaning.
They read already prepared state and render it clearly.

## Translation examples

| Internal | Stored | Human-Facing |
|---|---|---|
| `daily_change` | `daily_change` | `Daily Change` |
| `last_tick_time` | `last_tick_time` | `Last Tick Time` |
| `trade_allowed` | `trade_allowed` | `Trade Allowed` |
| `volume_min` | `volume_min` | `Minimum Volume` |
| `LAYER_1_OPEN_CLOSED_STATE` | not shown | `Market Status` |
| `TOP_LIST_SELECTED` | `selected` | `Selection Status` |

## UI and HUD law

The HUD and menu are presentation surfaces only.
They must not look like a debug terminal unless the surface is explicitly a technical operator diagnostic view.
Even technical operator views should prefer readable wording over raw enum noise.

## Canonical result

ASC must remain:
- mechanically strict inside
- schema-stable in storage
- human-readable outside
