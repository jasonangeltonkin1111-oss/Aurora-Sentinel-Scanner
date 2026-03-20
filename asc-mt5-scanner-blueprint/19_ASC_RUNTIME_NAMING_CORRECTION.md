# ASC Runtime Naming Correction

## Purpose

This file records a corrected drift: numeric layer/dev naming leaked into an earlier MT5 runtime seed and had to be removed from active operator and runtime surfaces.

That is not acceptable as a stable runtime naming model.

## Broken naming pattern

Examples of broken active-surface naming:
- `ASC_F1_Dossiers.mqh`

The problem is not that these files exist.
The problem is treating that naming as legitimate doctrine.

## Why it is wrong

`F1` means a foundation/phase marker.
That is dev-history language, not responsibility language.

Active runtime file names must answer:
- what this file owns
- what this file does
- where it fits architecturally

They must not answer:
- which development wave or phase created it

## Correct naming law

Use responsibility-based names only.

Good examples:
- `ASC_Common.mqh`
- `ASC_ServerPaths.mqh`
- `ASC_Logging.mqh`
- `ASC_FileIO.mqh`
- `ASC_MarketState.mqh`
- `ASC_Persistence.mqh`
- `ASC_Dossiers.mqh`
- `AuroraSentinel_Foundation.mq5`

## Rule for future implementation

If a generated file name includes:
- phase number
- packet
- worker
- temp
- wave
- refactor tag
- migration tag
- office jargon

then that name should be treated as invalid for active runtime code unless explicitly justified as a non-runtime helper artifact.

## Distinction

This rule applies to:
- active runtime file names
- active source module names
- user-facing output labels

This rule does not forbid:
- internal schema version fields
- migration metadata inside persistence files
- office-side task naming

## Migration stance

When broken runtime naming exists:
- do not normalize it into doctrine
- do not keep citing it as the desired final shape
- treat it as correction debt
- migrate active includes and references toward clean responsibility-based names

## Why this file exists

The current pack previously referenced the broken `ASC_F1_*` names as if they were the present implementation seed.
That is now corrected by this file.

## Final rule

The active runtime surface must use names based on responsibility, not development phase.