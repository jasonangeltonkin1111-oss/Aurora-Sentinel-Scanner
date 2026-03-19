# Blueprint

This folder is the constitutional source of truth for Aurora Sentinel Scanner.

It defines:
- system purpose
- architecture rules
- layer model
- module boundaries
- persistence contract
- output contract

No worker coordination lives here.
No MT5 code lives here.

## Authority Rule
If a file in `README.md`, `INDEX.md`, `office/`, or `mt5/` ever disagrees with a `blueprint/` contract, the relevant `blueprint/` contract wins.
