# L1.2 IDENTITY CLASSIFICATION RECOVERY HANDOFF

### 1. CHANGED FILES
- `office/HANDOFF_L12_IDENTITY_CLASSIFICATION_RECOVERY.md`
- `office/TASK_BOARD.md`
- `office/HQ_DECISION_LOG.md`

### 2. SCOPE CHECK
- Stayed inside Layer 1.2 identity/classification recovery planning.
- No live MT5 product code was changed in this packet.
- This handoff is archive-to-ASC recovery guidance only; implementation remains future bounded worker work.

### 3. HQ DECISION
- HQ decision: AFS classification lineage is the active identity recovery source for ASC Layer 1.2 classification repair and backfill.

### 4. CURRENT IDENTITY FLAWS IN `mt5/ASC_Market.mqh`
- `ASC_SymbolIdentity` currently preserves `RawSymbol`, `NormalizedSymbol`, `CanonicalSymbol`, `DisplayName`, and bucket/class fields, but it does not preserve alias-kind, confidence, review-status, or notes as first-class identity fields. Those values exist in the parsed classification rows yet are collapsed into the free-form `ClassificationReason` string, so downstream code cannot inspect them structurally.
- `ApplyClassification()` copies only canonical/display/classification bucket outputs into `ASC_SymbolIdentity`. The structured lineage fields `AliasKind`, `Confidence`, `ReviewStatus`, and `Notes` are discarded after reason-string assembly.
- `ResolveClassification()` falls back to `identity.NormalizedSymbol` as the canonical symbol when no match is found. That mixes lookup-normalization with canonical-display identity and can turn broker-cleanup output into implied canonical truth.
- `ClassificationRowMatches()` uses only normalized raw/canonical lookups. Because ASC does not preserve a dedicated normalized-alias lookup field, later recovery/debug work cannot distinguish "matched by raw broker alias" from "matched by canonical lookup".
- The equity second-pass path can resolve a row using broker metadata, but the result still lands in the same compressed identity model; operator-facing lineage about why a symbol matched remains trapped inside text instead of durable fields.
- The current identity contract has no explicit review-state carry-forward law. If classification material is backfilled later, ASC has nowhere stable to preserve manual-review breadcrumbs without reparsing prose.

### 5. AFS FIELDS PRESERVED TOGETHER THAT ASC STILL NEEDS
AFS keeps the following identity-lineage fields together on both classification rows and `AFS_UniverseSymbol`, and ASC still needs that bundle preserved as structured identity truth:
- `RawSymbol`
- canonical symbol (`CanonicalSymbol`)
- alias kind (`AliasKind`)
- confidence (`Confidence` / `ClassificationConfidence`)
- review status (`ReviewStatus` / `ClassificationReviewStatus`)
- notes (`Notes` / `ClassificationNotes`)

Why this matters:
- AFS can tell the difference between the observed broker symbol, the canonical display symbol, and the alias lineage used to connect them.
- AFS keeps reviewability attached to the identity record instead of burying it in a log string.
- Archived exports and trader-intel outputs can round-trip identity decisions because the confidence/review/notes fields survive beside the raw and canonical symbol fields.

### 6. BROKER/SERVER-SPECIFIC COVERAGE GAPS TO BACKFILL
Backfill review should target archived classification material for these gap classes:
- **Server-key row coverage gaps**: broker/server combinations present in archived AFS embedded/exported rows but absent from ASC's generated embedded rows.
- **Alias-form coverage gaps**: broker suffix variants, punctuation variants, `.cash`/`.spot`/micro/mini/raw/pro forms, and other raw-symbol aliases that AFS captured per server but ASC may only normalize away heuristically.
- **Equity venue ambiguity gaps**: NASDAQ/NYSE/XETRA/Euronext/LSE style aliases where archived rows can disambiguate broker symbols that normalization alone cannot separate.
- **Broker-specific display-name gaps**: rows where archived display names contain the strongest practical hint for equity or index mapping, but ASC currently does not preserve the review metadata attached to that name.
- **Manual-review carry-forward gaps**: symbols marked in archives with low confidence, pending review, or explanatory notes that should remain visible during recovery instead of being flattened into a generic unresolved reason.
- **Fallback-only server gaps**: symbols that currently resolve in ASC only by cross-server fallback and therefore need server-specific rows backfilled from archived exports to avoid accidental misclassification.

Suggested archived coverage sources to inspect during backfill:
- embedded AFS classification rows by `ServerKey`
- AFS exported classification snapshots and trader-intel identity outputs
- archived scanner output material for unresolved or partial-review symbols

### 7. PROPOSED FIELD MODEL: RAW VS NORMALIZED LOOKUP VS CANONICAL DISPLAY
Use a three-layer identity model so lookup mechanics do not overwrite lineage truth:

#### A. Raw broker observation
- `RawSymbol`: exact broker symbol observed from MT5.
- `BrokerDisplayName`: direct broker description/display text if needed.
- Purpose: preserve the source token that actually existed on the broker server.

#### B. Normalized lookup layer
- `NormalizedLookupSymbol`: normalization of `RawSymbol` for matching.
- `NormalizedCanonicalLookup`: normalization of canonical symbol for reverse matching/indexing.
- `NormalizedAliasLookup`: normalization of the matched archived raw alias.
- Purpose: matching/index/search only. These fields are not canonical display truth.

#### C. Canonical identity display layer
- `CanonicalSymbol`: the stable canonical symbol chosen by classification lineage.
- `CanonicalDisplayName`: preferred display name from archived classification when available.
- `AliasKind`: explicit alias lineage label.
- `ClassificationConfidence`: structured confidence value.
- `ClassificationReviewStatus`: structured review state.
- `ClassificationNotes`: structured lineage notes.
- Purpose: operator-facing identity truth, persistence truth, and review carry-forward.

#### D. Match provenance layer
- `ClassificationMatchSource`: e.g. `SERVER_ROW`, `SERVER_FALLBACK`, `EQUITY_SECOND_PASS`, `UNRESOLVED`.
- `ClassificationMatchServerKey`: row server key actually used.
- `ClassificationMatchReason`: concise machine-safe reason, separate from operator prose.
- Purpose: explain how recovery happened without conflating provenance with canonical identity.

### 8. RECOMMENDED NEXT-STEP RECOVERY ORDER
1. Extend the ASC identity contract so lineage fields survive structurally rather than only inside `ClassificationReason`.
2. Regenerate or supplement embedded classification content using archived AFS server-key material with explicit server coverage accounting.
3. Add a dedicated normalized-alias lookup field so exact raw-alias matches, canonical matches, and fallback matches can be reported separately.
4. Backfill review-status/notes into persistence and outputs so unresolved/manual-review symbols stay inspectable across restarts.
5. Audit fallback matches by broker/server and promote any repeat fallback cases into explicit server rows.

### 9. SEARCH STRINGS
- `NormalizeSymbol`
- `ApplyClassification`
- `ClassificationEmbeddedRows`
- `AFS_UniverseSymbol`

### 10. ARCHIVE USE NOTE
Exact archive files used for this handoff:
- `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh` — used to confirm the AFS classification row contract, normalization pipeline, and preserved identity lineage fields.
- `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh` — used to confirm that `AFS_UniverseSymbol` keeps raw/canonical/alias/confidence/review/notes fields together on the live shared symbol record.
- `archives/LEGACY_SYSTEMS/AFS/Aegis_Forge_Scanner.mq5` — used to confirm universe capture flow and archived output/export surfaces that preserve identity lineage for recovery/backfill.

### 11. ARCHIVE USE NOTE BLOCK
> ARCHIVE USE NOTE
> - `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
> - `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`
> - `archives/LEGACY_SYSTEMS/AFS/Aegis_Forge_Scanner.mq5`
