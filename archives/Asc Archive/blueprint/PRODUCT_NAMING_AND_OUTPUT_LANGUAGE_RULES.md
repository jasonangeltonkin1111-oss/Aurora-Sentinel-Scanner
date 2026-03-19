# PRODUCT NAMING AND OUTPUT LANGUAGE RULES

## Status
Active blueprint law.

This file defines the language boundary between development-facing language and product-facing language.

---

## Core Principle
Development language may exist in:
- office documents
- blueprint planning
- internal review notes
- worker task packets
- comments intended only for development workflow

Development language must not leak into:
- EA runtime surfaces
- trader-facing output
- persistent product files
- summary output
- symbol dossier output
- user-facing MT5 labels

ASC product surfaces must speak in domain meaning, not project workflow language.

---

## Forbidden Product-Facing Terms
The following classes of terms are forbidden in EA/product-facing naming and output unless the text is explicitly an internal developer-only comment that cannot reach runtime or persisted product artifacts:

- Task
- Step
- Phase
- Module
- Worker
- Clerk
- Debug
- Pipeline
- Test Target
- Build Order
- Dev Mode
- Trader Mode labels copied literally from legacy systems
- Raw Debug
- Module Summary
- Selected Scope
- Final Only
- Anomalies Only

This applies to:
- persistent output files
- dossier headings
- summary headings
- state labels seen by the trader/operator in live product use
- MT5-visible display strings
- product-facing struct/enum names where they would leak into output semantics

---

## Required Product-Facing Naming Style
Product-facing names must describe what the thing is about.
Use market/state/intelligence language.

Examples of acceptable naming direction:
- `MarketSessionStatus`
- `NextRecheckTime`
- `SurfaceEligibility`
- `UniverseSnapshot`
- `PromotionStatus`
- `ActiveSymbolState`
- `DossierIntegrity`
- `PrimaryBucket`
- `SpreadState`
- `HistoryCoverage`

Examples of forbidden naming direction:
- `Task1Check`
- `Step2Surface`
- `Phase3Deep`
- `DebugOutput`
- `PipelineStage`
- `WorkerStatus`

---

## Output Surface Rule
`SUMMARY.txt`, symbol files, universe snapshots, and any future trader-facing files must read like product intelligence artifacts, not like internal build artifacts.

Do not make outputs sound like:
- a build pipeline
- a coding project
- a test harness
- a dev console

---

## Legacy Translation Rule
Legacy source files may contain useful internal names and development labels.
Those may inform understanding, but must be translated into product-appropriate naming before entering active ASC runtime/output surfaces.

---

## Office vs Product Boundary
Office language is allowed to say:
- Task 001
- Stage 3
- Phase 2
- Worker handoff
- Debug review

Product language must instead say what the system truth means.

---

## Completion Standard
A feature is not naming-complete until:
- product-facing terms describe market meaning
- no dev-workflow phrasing leaks into runtime/output surfaces
- legacy debug/profile language has been translated or kept internal only
