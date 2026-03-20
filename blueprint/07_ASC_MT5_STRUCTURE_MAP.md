# ASC MT5 Structure Map

## Purpose

This document maps the intended future MT5 product layout for the clean ASC rebuild.
This is a structure blueprint, not a finished implementation.

## Root intent

The new active MT5 folder should be separate from archived product code.
Archive code remains in `archives/` for reference.
The new `mt5/` root is the future build surface.

## Intended layout

```text
mt5/
  README.md
  AuroraSentinel.mq5
  Include/
    ASC/
      README.md
      Common/
      Discovery/
        MarketWatch/
        Specs/
      Runtime/
      Layers/
      Publication/
      Presentation/
```

## Domain meaning

### Common
Shared types, enums, status records, time helpers, and small reusable utilities.

### Discovery
Raw retrieval and storage modules.
This includes `MarketWatch` and `Specs`.

### Runtime
Kernel heartbeat, due scheduler, restore flow, mode control, fairness, and bounded dispatch.

### Layers
Layer-owned processing logic.
This includes the explicit ordered capability stack from Market State Detection through Deep Selective Analysis.

### Publication
Symbol file building, temp writes, safe promotion, summary building, and write-state handling.

### Presentation
HUD, menu, and readable output mapping.
This domain renders prepared state only.

## Layout law

Physical folder structure should reflect meaning.
Product behavior must not be named after build steps.

## Presentation law

Anything inside `Presentation` must use human-readable labels.
It must not leak raw internal mechanic names into the HUD or menu.

## Discovery law

Anything inside `Discovery` must retrieve and store truth.
It must not perform ranking or deep-analysis logic.

## Runtime law

Anything inside `Runtime` may schedule and dispatch.
It should not own human-facing output wording.

## Layer law

Anything inside `Layers` should stay meaning-owned.
A layer may use shared utilities, but its logic should not be swallowed by one giant common blob.
