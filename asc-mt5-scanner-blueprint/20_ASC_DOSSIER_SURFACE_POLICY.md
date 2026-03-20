# ASC Dossier Surface Policy

## Purpose

This file resolves a tension in the current dossier doctrine:

- dossiers are canonical recoverable symbol truth
- dossiers are also meant to be readable by a human operator

Without a policy, the system drifts into an awkward hybrid where dossier section names become too dev-heavy for humans while still not being cleanly internal-only.

## Final dossier identity

The canonical ASC dossier is:
- internally authoritative
- operator-readable
- publication-safe
- machine-stable enough for restoration and searchability

It is not a raw debug dump.
It is not a pure machine-only artifact.

## Consequence

Because the dossier is operator-readable, visible section headers inside the primary dossier should avoid heavy dev-language when possible.

## Section naming policy

### Internal architecture concepts may still exist in code and persistence models
Examples:
- Market State Detection
- Open Symbol Snapshot
- publication state
- write state
- dirty domains

### Dossier-visible section headers should favor functional language
Prefer:
- `Symbol Identity`
- `Runtime State`
- `Scheduler State`
- `Market Status`
- `Snapshot State`
- `Filter State`
- `Selection State`
- `Deep Analysis`
- `Publication State`
- `Write State`
- `Error State`

Avoid in the visible dossier body when not necessary:
- `LAYER_1_OPEN_CLOSED_STATE`
- `LAYER_4_TOP_LIST_SELECTION`
- raw enum names
- packet/phase/wave/worker wording

## Searchability rule

Searchability still matters.
The solution is not to make the human-facing dossier ugly.

Recommended approach:
- keep stable internal keys and DTO/domain names in code
- use readable visible section headers in dossier output
- if necessary, include machine-stable hidden/internal mapping in writer logic or state schema rather than as ugly human-visible headers

## Example mapping

Internal concept:
- `LAYER_1_OPEN_CLOSED_STATE`

Visible dossier section:
- `Market Status`

Internal concept:
- `LAYER_2_OPEN_SYMBOL_SNAPSHOT`

Visible dossier section:
- `Snapshot State`

Internal concept:
- `LAYER_4_TOP_LIST_SELECTION`

Visible dossier section:
- `Selection State`

## Top-of-file rule

The top of the dossier should remain compact, readable, and human-first.
This is where a trader/operator should understand the symbol quickly without reading internal architecture language.

## Lower-section rule

Lower sections may be denser and more structured, but they should still remain readable and not feel like raw blueprint leakage.

## Final stance

The primary dossier is a human-readable canonical symbol document.
Therefore:
- code may use architecture ownership names
- internal schema may use stable internal identifiers
- visible dossier sections should prefer functional readable names

That is the final policy.

## Layer-progress placeholder rule

Because the active system is Market State Detection only, the dossier should still show the later reserved capabilities as Reserved rather than omitting them.

That preserves structural completeness for operators and future Aurora-side consumers without pretending later logic already exists.
