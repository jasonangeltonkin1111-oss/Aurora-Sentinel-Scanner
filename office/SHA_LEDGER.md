# SHA Ledger

## Purpose

This file is the active checkpoint ledger for meaningful repo-state snapshots.
It is intentionally compact and focuses on active control, blueprint, and runtime surfaces rather than re-listing the full archive on every pass.

## Current checkpoint

- checkpoint date: 2026-03-20
- checkpoint scope: active office + touched blueprint + touched runtime surfaces
- hash type: SHA-256
- note: this ledger does not hash itself to avoid self-reference churn
- rule: refresh this file when a pass materially changes active control or scanner-foundation truth

## Entries

```text
3c4ad6ec1b628e7e35c9673610aa3ee92377ed510c88c4096343fbfa90046f7f  office/README.md
a1a0fcf8200512cec5eee0e91bc68c5bc08f4816b4faf7c600b8a9d9814c8d1b  office/OFFICE_CANON.md
b299218a572186701c0b22c03fe2bbe50f552ecae3588e74dc31ea80e495495b  office/TASK_BOARD.md
0825e30bd10e96c90452f4d62b86668972fbe87d8547897c6f58f63b93d16fdf  office/DECISIONS.md
68e751433208ac584c3e96d151112c6cfc64bb72798cb30d1bf59cb1e64da28b  office/WORK_LOG.md
da129e65a29b418111254e7e8a14a54ac59b6aee1e61482b650682bdba2ae9a9  blueprint/README.md
333f1ff617f9d5d740d0c8886e0302e2380193de29c554bfbc13a22e2fa9af57  blueprint/02_ASC_RUNTIME_AND_SCHEDULER.md
4dc4de5c5c55c21f9a539f6e92712f6b6d4e8b0b7cd06d4afa53e4131518e611  blueprint/06_ASC_SYMBOL_FILES_AND_PUBLICATION.md
9f5ecceaebd7868a5fb521849d9b314680d469b640f6577fbfea7411697b9b4f  blueprint/09_ASC_AURORA_BRIDGE_REQUIREMENTS.md
894467eef7cf1812fd58aabaa8e292d6e2e3101d464ca18b2ebfa04f5acbeacc  asc-mt5-scanner-blueprint/03_ASC_RUNTIME_KERNEL_AND_EVENT_MODEL.md
3823da3294ecb32254438d115015729227f5feaf34bccfbe45f60a50a0892e37  asc-mt5-scanner-blueprint/09_ASC_SYMBOL_DOSSIER_CONTRACT.md
175b33141fca872adc344d690db552aa9c007b0730e3d6d0c5429a9adcce55b8  asc-mt5-scanner-blueprint/10_ASC_SUMMARY_AND_PUBLICATION_CONTRACT.md
c28ca1e0b667758700f940abb8999e62bf64db5fed9752d5571bdaf57cbbb8c9  asc-mt5-scanner-blueprint/22_ASC_AURORA_BRIDGE_CONTRACT.md
afef1971ba3767f4ff4f16255fca8e2b3c54719cdcc40d93a1861062a943fde5  mt5_runtime_flat/AuroraSentinel_Foundation.mq5
f2a209af2d3e00ff2f45329df5e8e2300498be2290d90b504d39ae445234cf06  mt5_runtime_flat/ASC_Persistence.mqh
```
