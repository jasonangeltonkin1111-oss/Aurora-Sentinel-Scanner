# ASC Active Implementation Target

## Purpose

This file removes ambiguity about what is active now, what is transitional, and what is future-facing.

Without this, GPT/Codex or a later human operator can mistake multiple parallel structures as equally live and accidentally generate drift.

## Active truth stack

Use this order when implementation choices conflict:

1. active `blueprint/`
2. this `asc-mt5-scanner-blueprint/` pack as deep implementation manual
3. active runtime build surface
4. older archive contracts and lineage systems

## What this pack is

This pack is:
- a deep build manual
- a code-generation bridge
- an archive-resolution layer
- an implementation clarifier

This pack is not:
- a replacement for the root `blueprint/` constitution
- permission to revive broken runtime naming
- permission to treat lineage systems as equal authority

## Active implementation target

### Active runtime build surface now
- `mt5_runtime_flat/`

This remains the practical active build surface for the near term because:
- fast file navigation matters
- flat MT5 runtime editing is currently part of the working method
- implementation hardening is still ongoing

### Long-term source architecture target
- semantic MT5 tree under `mt5/Include/ASC/...`

That tree is the long-term maintainable source architecture target.
It is not yet the active implementation surface.

## Critical distinction

Do not confuse:
- active runtime build surface
- long-term source architecture target
- archive lineage material

These are three different things.

## Current stance

### Active now
- root `blueprint/`
- this pack
- `mt5_runtime_flat/` as the current implementation surface

### Transitional
- migration from flat runtime files toward semantically named modules
- migration away from any phase/dev naming leakage

### Future target
- long-term semantic source tree
- richer capability implementation
- deeper publication and selection systems

## Immediate implementation law

If the current runtime surface violates a naming or architecture law, that surface must be treated as:
- implementation debt
- temporary correction target
- not normalized doctrine

A broken current file name does not become valid just because it exists in the repo.

## Example

Bad reasoning:
- an archived `ASC_F1_Common.mqh` reference exists, therefore `F1` is acceptable active naming

Correct reasoning:
- archived `ASC_F1_Common.mqh` references are lineage evidence only, while the active runtime surface must stay responsibility-named

## Final rule

The active implementation target is:
- clean responsibility-based module naming
- no phase/dev naming in active runtime files
- flat runtime surface for now
- semantic source tree later when the implementation is stable enough to migrate cleanly
