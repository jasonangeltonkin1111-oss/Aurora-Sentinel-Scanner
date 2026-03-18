# PERSISTENCE CONTRACT

## Core Rule
Aurora Sentinel is stateful per broker. On startup it must read existing broker-level state first, then refresh only what is missing, invalid, or stale.

## Broker Scope
Persistence is broker-level, not account-level. Multiple accounts on the same terminal and same broker must reuse the same broker output set.

## Startup Behavior
1. identify broker by account company
2. read existing broker summary and symbol data from Common Files
3. parse existing state into memory
4. detect missing, invalid, or stale fields
5. refresh gaps only
6. rebuild outputs truthfully

## Must Not
- rebuild everything blindly on every reload
- treat account switching as a new broker
- trust missing or malformed files without validation
- invent fake fallback values

## Storage Target
`Common\Files\AuroraSentinelCore\`

## Broker Output Pattern
- `<Broker>.Summary.txt`
- `<Broker>.Symbols/<Symbol>.txt`

## Write Safety
All broker-facing writes must be atomic or equivalent safe replacement writes.
