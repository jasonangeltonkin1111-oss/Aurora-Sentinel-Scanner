# SHA Ledger

## Purpose

This file is the active checkpoint ledger for meaningful repo-state snapshots.
It is intentionally compact and focuses on active control, blueprint, layout-plan, and runtime surfaces rather than re-listing the full archive on every pass.

## Current checkpoint

- checkpoint date: 2026-03-20
- checkpoint scope: Layer 1 finalization + menu/input + dossier placeholder surfaces
- hash type: SHA-256
- note: this ledger does not hash itself to avoid self-reference churn
- rule: refresh this file when a pass materially changes active control or scanner-foundation truth

## Entries

```text
3c4ad6ec1b628e7e35c9673610aa3ee92377ed510c88c4096343fbfa90046f7f  office/README.md
a1a0fcf8200512cec5eee0e91bc68c5bc08f4816b4faf7c600b8a9d9814c8d1b  office/OFFICE_CANON.md
bfb00e2e91b78e0b9fda55434730edf037e9aac80ff8eb8d44489a8df7d380d3  office/TASK_BOARD.md
bb86dbf878c954a3781ae3a1458d6494a472f490aa58c0a00e855fec8ba053ba  office/DECISIONS.md
ffdac93d23107fa5e3b09da2bd1bb8ec7f9bcacb0789d6db16dc83b114a1b335  office/WORK_LOG.md
99401b8397d3bf47b1db1b4f79248baa7f8d6c89c328d5637cc35d78c62c51fc  blueprint/01_ASC_SYSTEM_OVERVIEW.md
38a0d81faabb490acb37b2b90cc56f98c9caabdfcc4ea5cd37b012979740987e  blueprint/README.md
23db2c93838ef196e1fec0b6bf5634538eb736f9b4ee7529f663bd8e5d368390  blueprint/09_ASC_AURORA_BRIDGE_REQUIREMENTS.md
de9b0b18456d417d744c9a1de3c16235a7fe9a023f209593d7ee66aaf5fd64a0  blueprint/10_ASC_MENU_AND_TESTABILITY.md
52240ec97aba7e7fc195e8f391c9cb5807c9a926962d98fb16b171d6f31be61c  asc-mt5-scanner-blueprint/20_ASC_DOSSIER_SURFACE_POLICY.md
c3cd1fe9b687bad416e9c721465188b62e8f7520eaef03f1afee3caf7a06d72e  mt5_layout_plan/Include/ASC/README.md
ff5338a86716a44cd698339724d2ccb2ca1c4ce8447a16fd0454f9e95aada69c  mt5_runtime_flat/AuroraSentinel_Foundation.mq5
cf730063a2f71af1b50dccef501da81c2e81c6a881eaafff3891ceaad63aee0a  mt5_runtime_flat/ASC_Common.mqh
1dccd5420b2bdc20770d51159fbc0b4655c0ceb023bf93d3be8f257ee3461c18  mt5_runtime_flat/ASC_Dossiers.mqh
b4da19ee706c1cd23e7ed7e3b1c5e0d2e1f8417ac4a838b67e4d343ddc02a0e2  mt5_runtime_flat/ASC_MarketState.mqh
```
