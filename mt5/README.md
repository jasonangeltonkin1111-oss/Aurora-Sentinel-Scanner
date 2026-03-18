# MT5 Product

This folder contains the production MT5 codebase for Aurora Sentinel Scanner.

## Product Rules
- no dev/task/phase/worker wording in product code
- all `.mq5` and `.mqh` live in one flat EA folder
- no nested module folders in the terminal deployment layout
- output writes to MT5 Common Files
- broker-level persistence is reused across reloads

## Flat Deployment Clarification
The repo may contain the single deployment folder `mt5/AuroraSentinelCore/`.
Inside that folder:
- `.mq5` and `.mqh` files remain flat
- nested folders such as `market/`, `storage/`, or `dev/` are not allowed for terminal deployment

## Output Target
Trader-facing runtime files are written to:

`Common\\Files\\AuroraSentinelCore\\`
