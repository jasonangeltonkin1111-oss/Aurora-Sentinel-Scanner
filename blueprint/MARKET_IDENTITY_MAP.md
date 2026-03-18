# MARKET IDENTITY MAP

## Purpose
This file translates the preserved classification map in `archives/` into blueprint contract form.

## Authority
The historical source asset is the archived classification map. Production identity logic must preserve its meaning while being cleaned into product-ready code.

## Market Identity Responsibilities
The Market module owns:
- raw broker symbol recognition
- canonical symbol mapping
- asset class assignment
- `PrimaryBucket` assignment
- sector assignment
- industry/theme assignment where defined
- alias and suffix handling

## Rules
- broker symbols may vary, canonical meaning must not drift
- `PrimaryBucket` membership is authoritative and centralized
- unresolved classification must remain explicit; downstream layers may not silently coerce it into a resolved bucket
- if classification is unresolved or only partially resolved, Market must preserve that state explicitly and downstream consumers must treat `PrimaryBucket = UNKNOWN` as visibility-only, not as invented resolution
- workers do not create ad hoc sector logic outside the Market module
- the archived map is reference, the blueprint is contract, the MT5 Market module is production implementation
