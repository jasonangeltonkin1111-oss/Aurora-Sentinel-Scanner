# SUMMARY SCHEMA

## Summary Goal
A fast trader-facing decision sheet with enough surface intelligence to choose symbols without chart-hopping.

## Locked Bucket Model
Summary grouping uses `PrimaryBucket` from Market classification.

Implications:
- summary does not invent a replacement bucket system downstream
- ranking and activation must align with the same `PrimaryBucket` truth
- unresolved or policy-handled symbols must remain explicit rather than guessed

Condition-style buckets such as low-spread, high-volatility, or trend-style buckets are not part of the first milestone summary contract.

## Section Rule
Summary is organized by `PrimaryBucket`.
Each bucket shows top 5 symbols only.
If a bucket has fewer than 5 valid symbols, it shows the valid count only.

## Ranking Rule
Symbols are ranked inside their `PrimaryBucket` by a balanced scanner score.
The balanced score exists only to answer:
- which symbols are most worth opening next
- which symbols most deserve ACTIVE promotion attention

It is not a trading signal.
It is not an entry engine.
It is not a directional model.

## Minimum Per-Symbol Fields
- symbol
- display name
- status
- spread now
- ATR M15
- ATR H1
- freshness
- session
- balanced score
- compact note flags

## Must Not Show
- fake medians
- fake max values
- placeholder zeros pretending to be valid
- raw OHLC blocks
- strategy language
- buy or sell language

## Rendering Rule
Summary must remain compact enough to skim quickly.
A trader should be able to open the file, compare symbols inside a bucket, and choose what to inspect next in under one minute.
