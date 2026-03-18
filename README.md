# Aurora Sentinel Scanner

Aurora Sentinel Scanner is a broker-aware MT5 market intelligence system.

## Top-Level Structure
- `blueprint/` — constitutional source of truth
- `office/` — master/worker governance and coordination
- `mt5/` — production MT5 codebase
- `archives/` — historical reference and preserved source material

## Core Principles
- one EA
- broker-level output, not account-level output
- rolling persistence: read existing state first, then fill gaps
- writers format only
- top 5 per bucket only in summary output
- no dev/task wording in MT5 product code
- MT5 product deployment is one flat EA folder
