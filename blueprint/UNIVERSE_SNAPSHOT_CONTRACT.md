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

## Required Minimum Record Shape
Every universe snapshot record must preserve, when truth is available:
- raw broker symbol identity
- normalized/canonical symbol identity if resolved by Market
- description/path/exchange metadata if available
- broker-provided sector/industry/class metadata if available
- classification fields if resolved
- contract/spec fields needed for downstream conditions truth
- margin/calc/trade/filling/order mode fields where readable
- volume min/max/step/limit fields where readable
- session metadata or explicit session-availability markers
- record snapshot timestamp
- explicit unknown/missing markers for unreadable fields

The snapshot may preserve both broker raw fields and translated Market identity fields together.
It must not overwrite broker raw identity just because canonical identity exists.

---

## Allowed Content
The universe snapshot may include:
- raw broker symbol identity
- canonical identity fields if resolved
- description/path/exchange metadata if available
- classification fields if resolved
- broker-provided sector/industry/class metadata if available
- contract/spec fields
- margin/calc/trade/filling/order modes
- volume limits
- session metadata
- snapshot timestamps
- explicit missing/unknown markers
- read-status markers where useful for truthful recovery

---

## Optional vs Required Interpretation
- If a field is broker-provided and readable, preserve it truthfully.
- If a field is not available from the broker, mark it explicit missing/unknown.
- Do not invent normalized replacements for missing broker truth.
- Do not drop a symbol from the snapshot only because some spec/session fields are unavailable.

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
- shortlist-only file routing decisions
- hidden carry-forward of deep dossier ownership state

---

## Write Rule
Universe snapshot writes may be simpler than active dossier atomic writes, but they must still preserve truthful structure and must not silently wipe valid prior truth without reason.

Minimum write behavior:
- preserve prior valid structure unless replacement is verified
- avoid destructive reset during routine refresh
- keep unreadable fields explicit instead of dropping them silently
- do not rewrite the snapshot as if missing became valid by assumption

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
