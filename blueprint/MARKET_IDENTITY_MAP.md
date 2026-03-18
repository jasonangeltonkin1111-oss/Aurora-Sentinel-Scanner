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
- bucket assignment
- sector assignment
- industry/theme assignment where defined
- alias and suffix handling

## Rules
- broker symbols may vary, canonical meaning must not drift
- bucket membership is authoritative and centralized
- workers do not create ad hoc sector logic outside the Market module
- the archived map is reference, the blueprint is contract, the MT5 Market module is production implementation
