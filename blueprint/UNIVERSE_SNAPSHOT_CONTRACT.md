# UNIVERSE SNAPSHOT CONTRACT

## Status
Active blueprint law.

This file defines the allowed scope and format intent of the Layer 1.2 broker-universe snapshot.

---

## Purpose
Capture a broad broker-truth inventory of all discoverable symbols at EA startup.

This snapshot exists to preserve:
- universe membership
- broker-provided identity/spec truth
- classification truth if available
- session metadata

It is not the rolling dossier system.

---

## Scope
Applies to all discoverable broker symbols, regardless of promotion state.

---

## Allowed Content
The universe snapshot may include:
- raw broker symbol identity
- description/path/exchange metadata if available
- classification fields if resolved
- broker-provided sector/industry/class metadata if available
- contract/spec fields
- margin/calc/trade/filling modes
- volume limits
- session metadata
- snapshot timestamps
- explicit missing/unknown markers

---

## Forbidden Content
The universe snapshot must not become a hidden dossier.

Forbidden:
- Layer 2 ranking calculations
- promotion scores
- deep history persistence
- rolling dossier windows
- activation-only intelligence fields
- Layer 3 continuation metadata

---

## Write Rule
Universe snapshot writes may be simpler than active dossier atomic writes, but they must still preserve truthful structure and must not silently wipe valid prior truth without reason.

---

## Relationship to Activation
A symbol may exist in the universe snapshot and still remain:
- DEFERRED
- INACTIVE
- never promoted

Snapshot presence does not imply active dossier rights.

---

## Completion Standard
Layer 1.2 is only correct when ASC can capture the full broker universe truthfully without accidentally becoming a stealth Layer 2 or Layer 3 system.
