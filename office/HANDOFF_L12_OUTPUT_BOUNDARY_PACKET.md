# LAYER 1.2 OUTPUT BOUNDARY HANDOFF PACKET

## PURPOSE
This office note locks the current Layer 1.2 output boundary so future workers do not accidentally turn universe snapshot work into trader-facing dossier publication.

Layer 1.2 remains a bounded universe-snapshot stage.
It is allowed to preserve broad broker-observed truth, mirror that truth for inspection, and expose review/debug surfaces that explain known vs pending state.
It is not allowed to impersonate true Layer 2 shortlist output or Layer 3 trader-facing dossier output.

---

## ALLOWED LAYER 1.2 SURFACES
Layer 1.2 may write only the following surface classes:

1. **Snapshot surfaces**
   - bounded universe snapshot files
   - continuity-preserving storage used to keep broad symbol state across runs
   - broker-scoped or run-scoped state that reflects broad universe truth without pretending shortlist or trader readiness

2. **Mirror surfaces**
   - truth mirrors for broad universe inspection
   - export/mirror views that restate snapshot truth for operators, Clerk, or Debug
   - broker summary or symbol-path mirrors that remain broad, explicit, and non-dossier-like

3. **Review / debug surfaces**
   - internal review files
   - debug aids
   - operator-facing diagnostics that explain unresolved, pending, partial, or degraded state without converting that state into publishable trader claims

Allowed surfaces must remain descriptive, not promotional.
They may expose broad truth and explicit incompleteness, but they must not act like finalized trader outputs.

---

## FORBIDDEN LAYER 1.2 SURFACES
Layer 1.2 must not write or imply any of the following:

- trader-facing dossier files
- ACTIVE-symbol rolling dossier outputs
- shortlist/promotion files that imply Layer 2 ranking or activation rights already exist
- polished symbol reports that present partial truth as publication-ready trader truth
- any surface that collapses pending, unresolved, legacy-restored, or placeholder state into a false publishable file

If a file reads like a decision-ready symbol dossier rather than a broad snapshot or mirror, it is outside Layer 1.2 scope.

---

## STATE RULES

### 1. Placeholder
A placeholder state means the surface would be carrying fake, synthetic, guessed, or structurally empty values that merely occupy output shape.

Rules:
- placeholder state is never publishable
- placeholder state may only appear as an explicit internal failure/pending marker on review/debug surfaces
- placeholder values must not be formatted as if they are recovered broker truth
- snapshot or mirror surfaces must prefer explicit missing/pending markers over fake zero/default replacements

### 2. Legacy-restored
A legacy-restored state means data continuity was recovered from prior storage, but the current run has not yet rehydrated that field from fresh runtime truth.

Rules:
- legacy-restored data may remain inside continuity-preserving snapshot ownership
- legacy-restored data may appear only when clearly labeled as restored/pending rehydration
- legacy-restored data is not trader-publishable until current-run rehydration confirms it
- a legacy-restored field must not be upgraded to fresh truth merely because it exists in storage

### 3. Unresolved
An unresolved state means identity, classification, or other required truth remains unknown because the current run has no safe fresh resolution.

Rules:
- unresolved must stay explicit
- unresolved identity must not be guessed, normalized by wishful substitution, or hidden behind generic names
- unresolved state may be mirrored for inspection and review
- unresolved state is not publishable until fresh truth resolves the required identity/path/classification dependency

### 4. Publishable
Publishable means the surface is safe to present as true current output for its intended layer.

Rules:
- Layer 1.2 publishable means only publishable **as a snapshot/mirror/review artifact**, not as a trader-facing dossier
- publishable requires no placeholder fabrication
- publishable requires no unlabeled legacy-restored dependency standing in for fresh truth
- publishable requires no unresolved critical identity dependency
- partial truth may still be valuable internally, but it is not publishable if the surface presentation would overstate completeness

---

## DO NOT PUBLISH IF
Do not publish a Layer 1.2 surface as finalized output if any of the following are true:

- [ ] the surface is still in placeholder state
- [ ] the surface is legacy-restored and has not been rehydrated by fresh runtime truth
- [ ] the symbol or broker identity is unresolved and no fresh truth exists yet
- [ ] the surface contains only partial truth and that truth is not yet safe to present as publishable

When any checklist item is true, keep the artifact in snapshot/mirror/review status only, with explicit pending labeling.

---

## FUTURE HANDOFF TO TRUE LAYER 2 OUTPUT
The handoff point to true Layer 2 output begins only when ASC has real shortlist truth rather than broad universe truth alone.

That future handoff requires at minimum:
- verified Layer 2 shortlist fields, not just Layer 1 or Layer 1.2 broad state
- resolved identity/path truth safe enough for shortlist publication naming
- explicit separation between broad-universe mirrors and shortlist/trader-facing files
- a worker packet that opens true Layer 2 output on purpose instead of letting it leak out through Layer 1.2 storage/output convenience

Until that handoff is explicitly opened by HQ, Layer 1.2 output remains snapshot/mirror/review-debug only.

---

## BOUNDARY SUMMARY
- Layer 1.2 owns broad universe snapshot continuity.
- Layer 1.2 may mirror truth and expose review/debug visibility.
- Layer 1.2 must not become a stealth shortlist or dossier publisher.
- True trader-facing publication belongs to later verified layers, beginning with an explicitly opened Layer 2 output packet and then Layer 3 ACTIVE dossier continuation.
