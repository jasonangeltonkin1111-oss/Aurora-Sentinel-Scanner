# SUMMARY SCHEMA

## Summary Goal
A fast trader-facing decision sheet with enough surface intelligence to choose symbols without chart-hopping.

## Section Rule
Summary is organized by bucket. Each bucket shows top 5 symbols only.

## Minimum Per-Symbol Fields
- symbol
- display name
- status
- spread now
- BPS
- ATR M15
- ATR H1
- friction
- freshness
- session
- correlation context
- compact note flags

## Must Not Show
- fake medians
- fake max values
- placeholder zeros pretending to be valid
- raw OHLC blocks

## Rendering Rule
Summary should remain compact enough to skim quickly, but rich enough to compare movement, cost, and surface quality between symbols.
