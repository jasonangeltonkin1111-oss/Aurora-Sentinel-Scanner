# ASC Symbol Identity and Bucketing

## Purpose

This file defines the ASC symbol identity and bucketing surface.

It exists to separate:
- market-state truth
from
- symbol identity truth
from
- future filtering and shortlist logic

Market State Detection answers:
- is this symbol open, closed, uncertain, or unknown?
- when should it be checked again?

Symbol Identity and Bucketing answers:
- what is this symbol really?
- how should broker-specific aliases normalize?
- what canonical identity should survive across brokers?
- what asset class, bucket, sector, industry, and theme should later capabilities consume?

This capability must remain distinct from strategy logic and must not be folded into Market State Detection.

## Why this capability exists now

ASC already needs a stable future surface for:
- bucket-aware explorer views
- later bucket-preserving shortlist logic
- later cross-bucket combined shortlist logic
- operator-readable symbol drilldown
- Aurora downstream interpretation
- canonical trade-state matching later

The legacy AFS classification system already demonstrates the required record shape and normalization law.
The legacy source includes fields such as:
- `ServerKey`
- `RawSymbol`
- `CanonicalSymbol`
- `DisplayName`
- `AssetClass`
- `PrimaryBucket`
- `Sector`
- `Industry`
- `ThemeBucket`
- `SubType`
- `AliasKind`
- `Confidence`
- `ReviewStatus`
- `Notes`

and helper logic for:
- suffix stripping
- punctuation removal
- server-aware matching
- broker alias normalization
- canonical symbol lookup

That legacy source is evidence, not active authority. ASC must preserve the contract quality without inheriting the legacy file shape blindly. fileciteturn28file0

## Capability status

Current status:
- blueprint-active
- runtime-reserved
- not yet implemented in active ASC runtime

This capability should become active before or alongside later shortlist and explorer expansion work.

## Capability ownership

### Owns
- raw symbol normalization
- broker suffix stripping rules
- punctuation normalization rules
- broker alias resolution
- server-aware classification matching
- canonical symbol assignment
- display-name assignment
- asset-class assignment
- primary-bucket assignment
- sector assignment
- industry assignment
- theme-bucket assignment
- subtype assignment
- alias-kind assignment
- confidence and review-status metadata
- notes and manual-review carryforward

### Does not own
- market-state classification
- next-check scheduling
- dossier write timing
- due-based heartbeat rules
- candidate filtering decisions
- shortlist ranking decisions
- deep selective analysis
- execution decisions
- trade placement

## Classification record contract

The clean ASC record should preserve at least:

- `Raw Symbol`
- `Normalized Symbol`
- `Canonical Symbol`
- `Display Name`
- `Asset Class`
- `Primary Bucket`
- `Sector`
- `Industry`
- `Theme Bucket`
- `Sub Type`
- `Alias Kind`
- `Confidence`
- `Review Status`
- `Notes`

Optional future additions may include:
- `Server Scope`
- `Exchange Region`
- `Lifecycle Class`
- `Instrument Family`
- `Canonical Group Key`

## Resolution status model

A symbol identity result should remain honest.

Suggested statuses:
- `RESOLVED`
- `PARTIAL`
- `ALIAS_MATCH`
- `SERVER_MATCH`
- `UNRESOLVED`
- `NEEDS_REVIEW`

The system must not pretend all mappings are equally trustworthy.
Confidence and review status must survive into later publication and UI surfaces.

## Identity law

Canonical identity must survive broker variation.

Examples of variation classes:
- broker suffixes such as `.nx`, `.m`, `.c`, `.pro`
- punctuation variants such as `.`, `_`, `-`
- exchange aliases such as `AAPL.OQ` versus `AAPL.US`
- server-specific raw symbol variants
- regional listing variants such as `0388.HK` versus `388.xhkg`

The classification surface must preserve both:
- the raw broker truth
- the canonical normalized truth

## Bucketing law

Bucket assignment must be stable enough for later capabilities.

It should support:
- bucket list exploration
- bucket-preserving shortlist logic
- cross-bucket diversity logic later
- later de-duplication and correlation control

Primary bucket is the main grouping surface.
Sector, industry, theme, and subtype remain secondary but should be preserved for future drilldown and Aurora context.

## Data-source law

Preferred future source order:
1. explicit active ASC classification source
2. server-aware override entries
3. trusted alias normalization rules
4. unresolved manual-review state

The system must not rely forever on one giant embedded legacy blob.
The future runtime should support:
- a seed catalog
- override layers
- review workflow later if needed

## Explorer/UI implications

The explorer HUD should consume this capability for:
- bucket list generation
- bucket summary cards
- symbol identity cards
- canonical symbol display
- sector / industry / theme drilldown
- future combined-summary grouping

The HUD must not itself perform heavy classification logic.
It should consume already prepared identity records.

## Publication implications

Future dossiers should be able to expose a reserved or active identity section containing:
- raw symbol
- canonical symbol
- display name
- asset class
- primary bucket
- sector
- industry
- theme bucket
- subtype
- confidence
- review status

This should be machine-parseable and human-readable.

## Future build shape

Recommended future code ownership:

```text
Include/ASC/
  Identity/
    ASC_IdentityTypes.mqh
    ASC_IdentityNormalize.mqh
    ASC_IdentityLookup.mqh
    ASC_IdentityCatalog.mqh
    ASC_IdentityOverrides.mqh
```

The exact code split may evolve, but identity and bucketing should not disappear into `Common` or into Market State Detection.

## Final rule

Symbol Identity and Bucketing is the canonical ASC answer to:
- what symbol is this?
- what canonical instrument does it map to?
- what bucket and taxonomy should later capabilities consume?

It must stay separate from market-state logic and separate from strategy logic.

## Dynamic bucket view-model bridge

Until live identity is active, the explorer may still consume a placeholder taxonomy.
That taxonomy must now flow through a dynamic bucket view-model rather than fixed bucket slots.

The bucket render contract should carry at least:
- bucket id
- bucket name
- family
- posture
- note
- resolved symbol count
- dynamic symbol references
- current display mode

Placeholder symbol references must remain honest:
- canonical references are allowed
- broker tradability must not be implied
- live membership must not be implied before real identity resolution exists

The HUD should be able to consume any bucket count and any per-bucket symbol count without structural rewrite.
