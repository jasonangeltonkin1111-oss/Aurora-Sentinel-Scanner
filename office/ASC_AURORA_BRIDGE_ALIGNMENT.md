# ASC Aurora Bridge Alignment

## Purpose

This file keeps the ASC-side bridge aware of the Aurora-side joint evolution protocol without rewriting or overriding it.

ASC-side reference file:
- `office/ASC_AURORA_COEVOLUTION_PROTOCOL.md`

Aurora-side reference file:
- `Aurora Blueprint/ASC_AURORA_JOINT_EVOLUTION_PROTOCOL.md`

Both files now describe the same project reality:
- ASC and Aurora evolve hand in hand
- they do not merge into one system
- they do not drift in isolation
- every meaningful update should check bridge impact

## Alignment rule

When working on ASC, remain aware of the Aurora-side protocol.
When working on Aurora, remain aware of the ASC-side protocol.

Neither side needs to edit the other side's file by default.
Each side should keep its own bridge/control surfaces consistent with the shared project rule.

## Shared joint-check result classes

To stay aligned with the Aurora-side protocol, ASC-side future checks should use the same result classes whenever possible:
- `NO_BRIDGE_CHANGE_NEEDED`
- `ASC_NEEDS_UPDATE`
- `AURORA_NEEDS_UPDATE`
- `BOTH_NEED_UPDATE`

## Practical rule

For future meaningful ASC-side updates:
1. check the Aurora-side protocol and current Aurora progress
2. classify bridge impact using the shared result classes
3. update ASC-owned bridge/control files if needed
4. leave Aurora-owned files untouched unless explicitly working on Aurora

## Final note

This alignment note is intentionally small.
Its purpose is awareness and consistency, not a second layer of bridge doctrine.
