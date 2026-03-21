# ASC Menu and Operator Surface Expansion

## Purpose

This file expands the ASC menu and operator-surface design beyond the current foundation-stage settings plan.

It exists to make sure:
- the EA properties menu remains readable and stable
- the explorer HUD and the menu do not drift apart
- reserved future controls already have a safe home
- operator interaction remains human-readable
- future expansion does not force painful retrofits

This file is blueprint-only.
It does not authorize hidden runtime behavior beyond what the active capabilities already own.

## Menu versus explorer law

The EA menu and the explorer HUD are different surfaces.

### Menu owns
- configuration
- stable grouped settings
- runtime behavior flags
- reserved future controls
- startup-time and persisted configuration surfaces

### Explorer owns
- live navigation
- visibility
- interactive browsing
- click-driven drilldown
- live market-watch detail
- current system state display

Do not overload the menu with explorer behavior.
Do not overload the explorer with configuration editing that belongs in the EA properties menu.
Every meaningful menu or explorer surface edit must bump version.

## Product-facing wording law

The menu and the explorer must avoid dev-language.

They must not expose:
- phase
- step
- layer
- packet
- worker terms
- raw enum names
- file-ownership jargon

Prefer capability and operator wording such as:
- `Market State Detection`
- `Symbol Identity and Bucketing`
- `Open Symbol Snapshot`
- `Bucket View`
- `Symbol Detail`
- `Signal Surface`

## Menu design goals

The improved menu must be:
- grouped by ownership
- stable across future versions
- readable under MT5 property-dialog constraints
- explicit about active versus reserved capability surfaces
- suitable for later explorer integration
- careful not to create too many noisy toggles too early

## Canonical menu groups

### Runtime
Owns:
- heartbeat interval
- universe sync interval
- bounded symbol budget
- explorer refresh cadence if needed later

### Scheduler
Owns:
- fairness budget
- due pacing
- degraded thresholds
- backlog visibility thresholds later if needed

### Market State Detection
Owns:
- fresh tick threshold
- uncertain burst limits
- open-market recheck windows
- closed-market pacing windows
- unknown-state pacing

### Recovery and Persistence
Owns:
- runtime save cadence
- scheduler save cadence
- summary save cadence
- dossier repair on boot
- later explorer state restore if implemented

### Logging and Attention
Owns:
- verbosity
- scheduler decision logging
- recovery logging
- dossier repair logging
- attention-summary thresholds later

### Dossiers and Publication
Owns:
- due-based dossier writing toggle
- publication metadata stability
- later identity/publication expansion toggles if they remain cheap and honest

### Explorer HUD (Reserved now, active later)
Reserved for:
- explorer mode default
- explorer density default
- breadcrumb visibility
- overview card density
- scroll-step size
- current-work panel visibility

### Symbol Identity and Bucketing (Reserved)
Reserved for:
- classification source choice later
- server-aware override usage later
- unresolved-match handling later
- confidence/reporting visibility later

### Open Symbol Snapshot (Reserved)
Reserved for:
- snapshot cadence
- snapshot write policy
- snapshot section visibility

### Candidate Filtering (Reserved)
Reserved for:
- later cheap-filter thresholds
- bucket-preserving eligibility controls

### Shortlist Selection (Reserved)
Reserved for:
- shortlist size policy
- top-5-per-bucket publication policy
- anti-churn controls later

### Deep Selective Analysis (Reserved)
Reserved for:
- timeframe history retention
- ATR refresh cadence
- focused symbol high-refresh policy later

### Combined Opportunity Summary (Reserved)
Reserved for:
- later combined cross-bucket shortlist size
- open-trade exclusion policy
- low-correlation combined-view policy

### Future Signal Surface (Reserved)
Reserved for:
- Aurora-driven signal display policy later
- action-bar visibility later
- confirmation model later

## Reserved-control honesty rule

If a capability is not active yet:
- keep the group visible in blueprint planning
- mark controls as Reserved or Pending
- do not imply active behavior exists already
- keep final names stable where possible
- compress inner controls where possible so reserved groups feel intentional rather than cluttered

## Operator-surface alignment law

The menu groups and the explorer views should align conceptually.

Examples:
- menu group `Market State Detection` aligns with explorer stat groups such as `Session State`, `Tick Activity`, and `Market State`
- menu group `Symbol Identity and Bucketing` aligns with explorer pages such as `Buckets`, `Canonical Identity`, and `Bucket Summary`
- menu group `Combined Opportunity Summary` aligns with a later explorer page of the same name

This prevents future naming drift.

## Explorer quick-action law

Some live interaction belongs in the explorer, not the menu.

Examples of explorer-only quick actions:
- Home
- Back
- Open Buckets
- Open Symbol Detail
- All Symbols / Open Only filter ownership in the right rail for the active Layer 1 bucket surface
- View Density toggle
- Refresh display

For Layer 1 bucket surfaces, the right rail must own `All Symbols` and `Open Only`. That explorer-owned filter must stay global across compressed bucket-list visibility, bucket-detail symbol visibility, and zero-open bucket suppression in `Open Only` mode.

The menu should not be used as the substitute for click navigation.

## State visibility law

Where possible, the operator surface should show:
- current mode
- current density
- current selected path
- last update age
- warning summary
- active versus reserved capability progress

This should remain explorer-visible, not buried only in the menu.

## Focused-symbol expansion in operator surfaces

The operator surface must prepare for a future distinction between:
- ordinary shortlisted symbols
- focused symbols receiving elevated refresh cadence

The menu may later need reserved controls for:
- focus promotion timeout
- focused refresh cadence
- maximum concurrent focused symbols

The explorer may later show:
- `Focused`
- `High Refresh`
- `Watch Mode`

These should remain blueprint-reserved for now.

## Combined summary lane in operator surfaces

The operator surface must preserve a later distinction between:
- bucket-preserving shortlist view
- combined cross-bucket summary view

The later combined view should have a dedicated explorer page and should not replace the bucket view.

Potential later menu controls:
- combined shortlist count
- open-trade exclusion enable/disable
- correlation diversity threshold later

## Live data surface law

The explorer symbol-detail page may safely expose selected live market-watch data.
The menu should not attempt to configure individual live fields one by one.

The operator should navigate to live detail, not micromanage dozens of per-field UI toggles.

## Attention and warning surface law

The menu may later expose simple high-level attention thresholds.
The explorer should remain the live warning board.

Example explorer warnings:
- stale quote count
- waiting-for-session count
- pending-history count
- degraded runtime warning
- last write stall warning

## Recommended wrapper header fields

The wrapper surface should preserve future support for:
- wrapper version
- active capability
- next capability
- schema family
- server
- runtime state
- explorer mode
- last refresh age

This should appear in the explorer header rather than being buried only in logs.

## Staged implementation order

### Stage M1
Expand blueprint and naming alignment
- menu group expansion in canon
- operator/explorer alignment law
- reserved future groups named cleanly

### Stage M2
Runtime settings shell for explorer-safe defaults
- density mode default
- explorer visibility defaults
- reserved future groups present but inactive

### Stage M3
Explorer-home alignment
- overview page labels match menu language
- bucket and symbol pages align to the same vocabulary

### Stage M4
Later focused-symbol and combined-summary menu hooks
- still reserved until downstream capabilities exist

## Final rule

The menu should remain the clean configuration contract.
The explorer should remain the live interactive truth surface.

Both must use the same operator language.
Neither should drift into dev-language or noisy clutter.