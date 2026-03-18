# MT5 Product

This folder contains the production MT5 codebase for Aurora Sentinel Scanner.

## Product Rules
- no dev/task wording in product code
- all `.mq5` and `.mqh` live in one flat EA folder
- no nested module folders in the terminal deployment layout
- output writes to MT5 Common Files
- broker-level persistence is reused across reloads
