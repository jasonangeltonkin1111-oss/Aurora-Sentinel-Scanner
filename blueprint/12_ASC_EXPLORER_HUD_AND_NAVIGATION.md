# ASC Explorer HUD and Navigation

## Purpose

This file defines the ASC explorer HUD subsystem.

This is not a cosmetic overlay.
It is the future interactive operator and trader-facing explorer surface for ASC.

The HUD must become:
- readable
- interactive
- stateful
- click-safe
- layout-safe
- expandable
- cheap enough to run in MT5 without harming scanner continuity

It must also remain faithful to one non-negotiable law:

> runtime computes truth
> explorer surfaces truth

The HUD must not become a hidden second scanner engine.

## Product identity law

The explorer HUD is part of the ASC domain surface.
It should own the chart presentation region used by ASC and replace noisy legacy chart clutter with structured explorer panels.

Operator-facing wording must remain human-readable.
The explorer must not display build-step or dev jargon on the main surfaces.

## Versioning and wrapper header law

The EA wrapper and the explorer subsystem must use explicit version discipline.

Initial wrapper version:
- `1.001`

Current explorer scaffold milestone after HUD v2 shell expansion:
- `1.020` wrapper
- `0.300` explorer subsystem

Suggested version law:
- patch bump: `1.001 -> 1.002` for non-breaking polish and fixes
- minor capability bump: `1.001 -> 1.020` for meaningful explorer or capability expansion
- major architecture bump: `1.x -> 2.000` only for major structural redesign

The EA wrapper header should eventually preserve:
- product name
- wrapper version
- schema family
- active capability
- next planned capability
- explorer subsystem version
- update discipline notes

This should be part of the future code header standard, but the design law belongs here now.
Every meaningful wrapper or explorer edit must bump version.

## Core split

The explorer should preserve two distinct interaction tracks.

### Operator / Dev track
Purpose:
- runtime health visibility
- market-state visibility
- bucket progress visibility
- pending reason visibility
- publication state visibility
- current work visibility
- system warnings and recovery truth

### Trader track
Purpose:
- bucket browsing
- symbol browsing
- symbol detail
- later signal surface
- later trade action surface

The two tracks may share the same explorer engine, but they must not be blended into one noisy screen.

## Explorer law

The explorer is not a single flat HUD.
It is a stateful navigation system with:
- pages
- panels
- selection state
- scroll state
- breadcrumb state
- back stack
- view modes
- safe widget rendering

## Required view hierarchy

### View 0 — Overview
Shows the current system state at a glance.

Should include:
- product identity
- wrapper version
- server and server time
- runtime state
- current capability progress
- bucket totals
- target symbols
- pending reason summary
- last activity
- warnings / attention summary

### View 1 — Bucket List
Shows all active or known buckets as selectable cards or buttons.

Should include per bucket:
- bucket name
- symbol count
- active count
- open / closed / uncertain rollup
- completion state
- dominant pending reason
- last update when available

### View 2 — Bucket Detail
Triggered by clicking a bucket.

Should show:
- bucket summary header
- top symbols in that bucket
- readiness status
- visible-window scrolling when the list exceeds the screen
- safe pagination or row-based scroll controls

### View 3 — Symbol Detail
Triggered by clicking a symbol.

Should show:
- identity card
- bucket and canonical info
- current market-state fields
- current market-watch fields
- tick and session state
- publication state
- completion and pending reason state
- reserved signal surface

### View 4 — Stat Detail
Triggered by clicking a stat block inside a symbol page.

Examples:
- Session State
- Tick Activity
- Identity
- Publication
- Completion
- Market Watch
- Future Signal Surface

Should show deeper subfields without collapsing the rest of the explorer model.

## Breadcrumb law

The explorer must keep the current path obvious.

Example path:
- `Home / Buckets / HK Equity Financial / 0388.HK / Session State`

Breadcrumbs improve deep navigation clarity and reduce operator confusion.

## Back-stack law

Back navigation must restore:
- prior view
- prior selected bucket
- prior selected symbol
- prior selected stat
- prior scroll position

Without a real back stack, the explorer will feel fragile and frustrating.

## Button law

Buttons must always work.
That means:
- no overlapping click zones
- no tiny hit targets
- no hidden buttons under content
- no click handlers scattered across the codebase
- no heavy recomputation directly on click
- no dependence on unstable redraw timing

Recommended button groups:
- `Home`
- `Back`
- `Buckets`
- `Overview`
- `Scroll Up`
- `Scroll Down`
- `Page Up`
- `Page Down`
- `Compact`
- `Normal`
- `Detailed`
- `Refresh`

Reserved later:
- `Signal`
- `Trade`
- `Stage`
- `Approve`

## Central action dispatch law

All button actions should route through one action-dispatch surface.
Widgets should not own scanner logic.
The explorer should instead map:
- button id
- action kind
- payload
- target view

and then dispatch safely through one controller.

## Layout law

The explorer must use a deterministic layout engine.
It must not rely on guessed coordinates scattered around the file.

Required primitives:
- chart width and height awareness
- outer margin
- panel padding
- section gap
- title height
- row height
- control rail width
- content column widths
- visible-window calculation

### Required layout guarantees
- no clipped titles
- no overlapping blocks
- no truncated labels without a declared rule
- no content touching borders
- no buttons mixed into content rows without fixed placement

## Responsive fitting law

The explorer must intelligently determine how much content fits on screen.

For any list view, it should derive:
- available content height
- visible row count
- whether scrolling is needed
- current scroll offset
- maximum scroll offset

If content does not fit:
- show only the visible slice
- keep explicit scroll controls
- never render rows into hidden or overlapping space

## Scroll law

Initial scrolling should be deterministic and safe.
Do not begin with free drag scrolling.

Allowed first implementation:
- row-based scroll
- page-based scroll
- explicit up/down buttons

The explorer must know per list:
- total items
- visible items
- first visible index
- last visible index

## Widget catalog

The explorer should be built from reusable widgets.

Suggested widget types:
- header strip
- breadcrumb strip
- panel title
- key-value row
- status pill
- progress bar
- bucket card
- symbol card
- action button
- scroll button
- warning strip
- empty-state card

These widgets should remain presentation-only.

## Theme law

Theme and styling must remain separated from logic.
The future explorer should have a theme surface for:
- colors
- text sizes
- padding constants
- border rules
- selected state styling
- warning state styling
- accent state styling

This allows the explorer to look polished without hardcoding style values everywhere.

## Live-data law

Some symbol-detail fields may update live when it is safe and cheap.

### Good live candidates
- Bid
- Ask
- Spread
- High
- Low
- Open
- tick age
- market-watch update time
- session-in/out state
- market-state classification

### Semi-live or heartbeat-fed fields
- pending-reason counts
- bucket totals
- completion percentages
- last write event
- publication state
- current warning summary

### Not allowed for live HUD recompute
- heavy history pulls
- full broker spec rescans every render
- filesystem crawling
- bucket rebuilds in HUD code
- classification recomputation in HUD code

## Empty-state law

Every view must have a safe empty-state surface.
If no data is available, the explorer should say why.

Examples:
- `No active buckets yet`
- `No symbol selected`
- `Market Watch data pending`
- `Signal surface reserved`

Do not show blank broken panels.

## Chart object ownership law

The explorer should own only its own chart objects.
It must use a strict object prefix and never destroy unrelated chart objects casually.

This prevents chart cleanup from becoming destructive.

## Reserved future signal surface

The symbol detail view must preserve a reserved future signal section.
This is only a structural reservation right now.
No trade logic should be implemented from this file.

Future signal panel may later show:
- trade idea status
- entry
- stop
- target
- risk
- confidence
- rationale summary
- action readiness

Future action bar may later show:
- place trade
- stage order
- send to review
- copy levels

This path is reserved for Aurora integration and later semi-automatic workflow.
It must not be faked early.

## Focused symbol expansion law

The explorer may later request deeper attention for a selected symbol.
That does not mean the HUD computes that symbol itself.

Instead, the runtime may elevate a selected shortlisted symbol into a focused analysis surface where:
- higher refresh cadence becomes allowed
- richer tick maintenance becomes allowed
- ATR and timeframe refresh become allowed
- deeper layer-owned fields become allowed

This elevation must remain bounded and runtime-owned.
The HUD is only the navigation and visibility surface for it.

## Combined summary law

The explorer must later support more than one shortlist lane.

### Lane A — bucket-preserving shortlist
This remains the familiar top-5-per-bucket surface.

### Lane B — combined cross-bucket shortlist
Later, after correlation and de-duplication work, the explorer may show a separate combined cross-bucket summary such as top 10 combined.

This second lane must not replace the bucket-preserving lane.
It is a separate downstream page.

## Open-trade exclusion law

The later combined cross-bucket lane may exclude symbols that are already present in currently open positions.

That rule should not erase bucket-truth surfaces.
It only applies to the later combined lane where duplication and opportunity-slot replacement matter.

## Explorer data adapter law

The explorer should not reach directly into raw runtime internals everywhere.
It should consume adapted structures such as:
- global HUD state
- bucket summary rows
- symbol summary rows
- stat-detail cards
- warning and pending summaries

That adapter layer is the safety boundary between runtime truth and explorer rendering.

## Recommended future code shape

```text
Include/ASC/Presentation/
  ASC_ExplorerHUD.mqh
  ASC_ExplorerLayout.mqh
  ASC_ExplorerWidgets.mqh
  ASC_ExplorerState.mqh
  ASC_ExplorerDataAdapters.mqh
  ASC_ExplorerActions.mqh
  ASC_ExplorerTheme.mqh
```

The exact split may evolve, but one giant HUD file should be avoided if the explorer becomes truly interactive.

## Staged implementation plan

### Stage E1
Explorer shell and layout engine
- wrapper header strip
- overview page
- safe buttons
- breadcrumb and back/home support
- visible-window calculation

### Stage E2
Bucket list view
- bucket cards
- scrolling
- stable click routing

### Stage E3
Bucket detail view
- top symbols in bucket
- symbol cards
- safe navigation

### Stage E4
Symbol detail view
- market-state details
- market-watch live panel
- publication summary
- completion summary

### Stage E5
Stat drilldown view
- per-stat deep detail
- breadcrumb/back restore

### Stage E6
Reserved signal surface and later combined-summary page
- still non-executing until Aurora integration is ready

## Final rule

Do not chase UI sophistication before explorer truth, layout safety, and click reliability.

First make it:
- truthful
- readable
- non-overlapping
- scroll-safe
- button-safe
- runtime-safe

Then make it richer over time.

## HUD v2 scaffold direction

The scaffold should now favor a stronger console hierarchy with:
- top identity/header strip
- navigation strip
- main content body with grouped cards and section panels
- right-side control rail
- bottom status strip

This remains presentation-only and must not activate future compute capabilities prematurely.
