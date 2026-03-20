# ASC Symbol Dossier Contract

## Purpose

Each symbol owns one canonical evolving dossier.

The dossier is:
- the symbol’s truth container
- the main recoverable publication unit
- created early
- filled gradually
- safe to exist while some sections remain pending

## One-symbol-one-file law

One canonical file per symbol.
It may contain many sections, but it remains one primary document.

## Why dossiers matter

They:
- preserve continuity naturally
- support atomic replacement
- allow partial evolution
- keep whole-universe truth visible
- reduce monolithic-state complexity

## Canonical dossier philosophy

The dossier should have:
- a compact readable top
- machine-stable section ownership
- explicit freshness/validity markers
- reserved sections for future layers
- no fake completeness

## New canonical section model

Recommended section order:

1. `SYMBOL_HEADER`
2. `SYMBOL_IDENTITY`
3. `SYMBOL_RUNTIME_STATE`
4. `SYMBOL_SCHEDULE_STATE`
5. `LAYER_1_OPEN_CLOSED_STATE`
6. `LAYER_2_OPEN_SYMBOL_SNAPSHOT`
7. `LAYER_3_FILTER`
8. `LAYER_4_TOP_LIST_SELECTION`
9. `LAYER_5_DEEP_SELECTIVE_ANALYSIS`
10. `PUBLICATION_STATE`
11. `WRITE_STATE`
12. `ERROR_STATE`

## Human-readable overlay

Architecture section names are stable for internal schema/searchability.
Inside those sections, trader/operator-visible field labels should be readable.

Example:
- good: `Daily Change`
- bad: `daily_change`

## Minimum dossier contents for foundation pass

Even before higher layers exist, every dossier should express:

- symbol identity
- server identity
- current market status
- status note
- tick presence
- tick age
- session availability
- next session open
- next check
- runtime mode
- heartbeat timestamp
- placeholders or reserved sections for later expansion

## Suggested top-of-file shape

```text
Aurora Sentinel Symbol Dossier
========================================

Symbol Identity
----------------------------------------
Symbol: EURUSD
Server: Broker-Server
Dossier File: EURUSD.txt

Market Status
----------------------------------------
Current Status: Open
Status Note: Fresh tick observed
Last Tick Seen: 2026.03.20 12:31:02
Next Check: 2026.03.20 12:31:12
```

## Dossier state classes

A section or field may be:
- present
- pending
- reserved
- unavailable
- unsupported
- stale
- frozen
- invalid

Do not express all of those as `0` or blank.

## Section ownership examples

### `SYMBOL_IDENTITY`
Owner:
- identity discovery / universe service

### `LAYER_1_OPEN_CLOSED_STATE`
Owner:
- market-state layer service

### `LAYER_2_OPEN_SYMBOL_SNAPSHOT`
Owner:
- snapshot publication service

### `LAYER_4_TOP_LIST_SELECTION`
Owner:
- selection/ranking service

### `WRITE_STATE`
Owner:
- publication/write service

## Compatibility note for old archive

Older archive law enforced three major sections:
- `[BROKER_SPEC]`
- `[OHLC_HISTORY]`
- `[CALCULATIONS]`

Recommended modern stance:
- keep the newer evolving dossier as canonical
- optionally emit a legacy-compatible reduced export view later if needed

## Suggested field examples per section

### `SYMBOL_IDENTITY`
- `Raw Symbol`
- `Canonical Symbol`
- `Description`
- `Path`
- `Exchange`
- `Asset Class`
- `Primary Bucket`

### `SYMBOL_RUNTIME_STATE`
- `Lifecycle State`
- `Last Seen In Universe`
- `Warmup State`
- `Frozen Reason`

### `SYMBOL_SCHEDULE_STATE`
- `Next Check`
- `Last Check`
- `Next Snapshot Refresh`
- `Next Filter Refresh`
- `Next Deep Refresh`

### `LAYER_1_OPEN_CLOSED_STATE`
- `Current Status`
- `Status Note`
- `Evidence Confidence`
- `Tick Present`
- `Tick Age Seconds`
- `Within Trade Session`
- `Next Session Open`
- `Reason Code`

### `PUBLICATION_STATE`
- `Last Published`
- `Publication Health`
- `Dirty Domains`
- `Last Good Available`

### `WRITE_STATE`
- `Schema Version`
- `Last Temp Path`
- `Last Promote Result`
- `Last Write Error`

## Codegen warning

Do not let a generated writer directly compute analytics while formatting text.
Writers render prepared state only.

## Bridge continuity note

The dossier is not only an operator artifact.
It is also the most likely future ASC-to-Aurora scanner interface surface.

For that reason the dossier contract should preserve:
- stable section names
- stable timing fields
- explicit uncertainty wording
- explicit recovery or degraded markers when present
- reserved placeholders instead of fake completion
