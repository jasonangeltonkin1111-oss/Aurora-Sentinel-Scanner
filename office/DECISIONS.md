# Decisions

## Locked decisions

- the active office root is `office/`
- the office layer must stay small
- the active MT5 build surface is `mt5_runtime_flat/`
- MT5 runtime deployment remains flat for fast file navigation
- server identity only; no account contamination in storage
- storage root is `AuroraSentinel/<Clean Server Name>/`
- exactly two server subfolders: `Symbol Universe` and `Dev`
- dossiers must use human-readable functional names
- internal mechanic names must not leak into dossier, HUD, or menu wording
- startup restores and repairs; it must not blindly wipe and rebuild
- atomic temp-to-final persistence is mandatory
- foundation scope stays limited to runtime, scheduler, persistence, dossiers, logging, and market-state truth
- ranking, basket selection, strategy logic, trade logic, and account logic remain blocked

## Archive-derived control decisions

Preserve:
- task board
- decision log
- master/work log
- SHA ledger
- stage-gated control

Reject as active office shape:
- handoff sprawl
- HQ state sprawl
- wave packet clutter
- one tiny file per minor control change
