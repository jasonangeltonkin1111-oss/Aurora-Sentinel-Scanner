# ARCHITECTURE RULES

## Hard Rules
1. Aurora Sentinel runs as one Expert Advisor in normal operation.
2. The 3-layer runtime model must remain intact.
3. Writers never compute analytics or invent fallback values.
4. No module invents its own market identity outside the Market module.
5. No module invents its own economics outside the Conditions module.
6. No module writes trader-facing files except Output via Storage.
7. No hidden renaming of fields across layers or modules.
8. No fake zero values for missing data.
9. No giant catch-all module.
10. No cross-module redesign without blueprint updates.
11. MT5 product code and files must contain no dev/task/phase/worker wording.
12. MT5 terminal deployment uses one flat EA folder, not nested module folders.
13. Symbol detail files must preserve the exact major section names:
   - `[BROKER_SPEC]`
   - `[OHLC_HISTORY]`
   - `[CALCULATIONS]`
14. `archives/` is reference-only and must not be silently treated as active product implementation.

## Forbidden Patterns
- scan -> writer -> calculate
- summary files that exceed top 5 per bucket
- symbol detail files with extra major sections
- direct raw-object access by writers
- duplicated business logic across module families
- account-specific logic leaking into broker-level outputs
- overloading Layer 1 with surface or deep calculations
- nested MT5 deployment folders used as module boundaries

## Design Priorities
1. truthfulness
2. structural simplicity
3. broker correctness
4. layer separation
5. safe scaling
6. reliable outputs
7. extensibility
