# LAYER MODEL

Aurora Sentinel operates as a 3-layer rolling intelligence system.

## Layer 1 — Universe Heartbeat
Purpose:
- maintain cheap awareness of the full broker symbol universe

Allowed concerns:
- market open state
- live tick presence
- tick age
- next recheck scheduling

Not allowed:
- deep calculations
- ranking logic
- writer formatting

## Layer 2 — Active Surface
Purpose:
- maintain current competition state for active and tradable symbols

Allowed concerns:
- light quote state
- light spec state
- light surface calculations for summary candidates
- ranking inputs

Not allowed:
- heavy dossier calculations
- trader-facing deep output generation

## Layer 3 — Deep Shortlist
Purpose:
- maintain richer symbol intelligence only for current bucket leaders

Allowed concerns:
- deeper history loading
- richer calculations
- symbol detail snapshot preparation

Not allowed:
- full-universe deep scanning
