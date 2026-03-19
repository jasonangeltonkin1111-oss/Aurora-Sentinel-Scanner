# CHANGELOG

## 2026-03-19 - v1.004
- aligned the product release to snapshot schema `V5` for universe persistence
- finalized legacy restore/archive classification recovery tightening in storage handling
- confirmed outward-facing release metadata matches the current persistence/schema story

## v2 Reset
- locked clean root layout: `blueprint/`, `office/`, `mt5/`, `archives/`
- separated office/dev from MT5 production
- preserved broker-level rolling persistence model
- preserved top-5-per-bucket summary rule
- elevated archived classification map into blueprint contract importance
