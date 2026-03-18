# MT5 Product

This folder contains the production MT5 codebase for Aurora Sentinel Scanner.

## Product Rules
- no dev/task wording in product code
- all `.mq5` and `.mqh` live under the EA tree
- output writes to MT5 Common Files
- broker-level persistence is reused across reloads
