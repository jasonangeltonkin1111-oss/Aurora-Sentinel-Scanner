# AURORA WRAPPER CONSOLIDATION PLAN V1

## PURPOSE

This file records the first serious wrapper architecture review and consolidation plan after the standalone hardening wave.

Its job is to protect the wrapper from winning on knowledge density while losing on package discipline.

This file is intentionally stored under `Aurora Blueprint/office/` rather than under `Aurora Wrapper/` because:
- the wrapper itself is already near its hard file ceiling
- consolidation planning is a control/architecture task, not default wrapper hot-path doctrine
- the wrapper should not spend one of its remaining file slots on a planning artifact that future maintenance can read from Blueprint control

---

## CURRENT JUDGMENT

The wrapper is now much stronger as a standalone compiled canon.

It now carries materially stronger knowledge for:
- control posture
- bridge behavior
- execution-side operation
- family routing
- pattern routing
- packet/review/example discipline

This is a real gain.

But that gain created the next risk:
- wrapper knowledge growth is now close to outrunning wrapper package discipline

So the next correct job is no longer “add more wrapper doctrine files.”
The next correct job is:
- stabilize the package shape
- decide what remains separate
- decide what should merge
- decide what final file-count target is realistic

---

## CURRENT WRAPPER FILE COUNT

### Current count
The wrapper now stands at **19 files**.

### Why this matters
- the hard ceiling is 20 files
- the preferred package target was 12 files
- the preferred operating range was 10–14 files

So the wrapper is:
- still under the ceiling
- but now too close to the ceiling to keep growing casually
- and above the preferred long-run range

This means a consolidation phase is now mandatory.

---

## CURRENT WRAPPER PACKAGE SHAPE

### Core original package
1. `AURORA_WRAPPER_KERNEL.md`
2. `AURORA_WRAPPER_SETTINGS.md`
3. `AURORA_WRAPPER_FILE_MAP.md`
4. `AURORA_WRAPPER_CONTROL_PACK.md`
5. `AURORA_WRAPPER_EXECUTION_PACK.md`
6. `AURORA_WRAPPER_FAMILY_VAULT.md`
7. `AURORA_WRAPPER_PATTERN_VAULT.md`
8. `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md`
9. `AURORA_WRAPPER_BRIDGE_PACK.md`
10. `AURORA_WRAPPER_MAINTENANCE_GUIDE.md`

### Standalone / architecture wave additions
11. `AURORA_WRAPPER_STANDALONE_REQUIREMENTS_V1.md`
12. `AURORA_WRAPPER_PACKAGE_ARCHITECTURE_V1.md`
13. `AURORA_WRAPPER_STANDALONE_AUDIT_V1.md`
14. `AURORA_WRAPPER_FAMILY_ROUTING_MANUAL_V1.md`
15. `AURORA_WRAPPER_PATTERN_ROUTING_MANUAL_V1.md`
16. `AURORA_WRAPPER_EXECUTION_OPERATING_MANUAL_V1.md`
17. `AURORA_WRAPPER_CONTROL_OPERATING_MANUAL_V1.md`
18. `AURORA_WRAPPER_BRIDGE_OPERATING_MANUAL_V1.md`
19. `AURORA_WRAPPER_PACKET_REVIEW_OPERATING_MANUAL_V1.md`

---

## PACKAGE QUALITY JUDGMENT

## What is genuinely better now
The wrapper now holds much more of the Blueprint's usable intelligence.
It is no longer merely:
- a routing shell
- a compact doctrine summary
- a light wrapper for the source files

It is increasingly:
- a standalone compiled operating canon
- a much more self-sufficient GPT-facing package

That is a real success.

## What is now vulnerable
The wrapper now risks becoming:
- too file-rich for its own design law
- too split across parallel base-pack plus operating-manual structures
- harder to refresh cleanly if each doctrine lane has both a vault/pack and a separate manual forever

So the next risk is not doctrinal thinness.
The next risk is structural over-segmentation.

---

## CONSOLIDATION PRINCIPLE

The wrapper should not stay permanently in its current 19-file shape.

The correct long-run move is:
- preserve the knowledge gains
- merge the densification layers back into their owning packs or vaults
- keep only the wrapper files whose separation clearly improves routing and refresh safety

This means the recent operating manuals are best treated as:
- hardening scaffolds
- consolidation sources
- doctrine expansion inputs

not necessarily as permanent end-state files.

---

## RECOMMENDED FINAL TARGET

### Recommended final wrapper count
**13 files**

### Acceptable final range
**12–14 files**

### Why 13 is the best current target
- enough room to keep the wrapper standalone-capable
- enough room to keep maintenance and architecture law explicit
- still clearly below the hard ceiling
- still compact enough for GPT upload/use
- enough space to preserve one example/review support file without overloading hot-path doctrine

---

## RECOMMENDED FINAL PACKAGE SHAPE

### Router / metadata
1. `AURORA_WRAPPER_KERNEL.md`
2. `AURORA_WRAPPER_SETTINGS.md`
3. `AURORA_WRAPPER_FILE_MAP.md`

### Core doctrine hot path
4. `AURORA_WRAPPER_CONTROL_PACK.md`
5. `AURORA_WRAPPER_EXECUTION_PACK.md`
6. `AURORA_WRAPPER_FAMILY_VAULT.md`
7. `AURORA_WRAPPER_PATTERN_VAULT.md`
8. `AURORA_WRAPPER_BRIDGE_PACK.md`

### Support hot path
9. `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md`

### Maintenance / package governance
10. `AURORA_WRAPPER_MAINTENANCE_GUIDE.md`
11. `AURORA_WRAPPER_STANDALONE_REQUIREMENTS_V1.md`
12. `AURORA_WRAPPER_PACKAGE_ARCHITECTURE_V1.md`
13. optional `AURORA_WRAPPER_STANDALONE_AUDIT_V1.md` only if retained as a recurring audit surface

This is the preferred final architecture.

---

## MERGE RECOMMENDATIONS

## Merge set A — control lane
### Target
Merge key useful content from:
- `AURORA_WRAPPER_CONTROL_OPERATING_MANUAL_V1.md`
into:
- `AURORA_WRAPPER_CONTROL_PACK.md`

### Keep after merge
- keep `CONTROL_PACK`
- remove `CONTROL_OPERATING_MANUAL_V1` after lossless merge

### Why
The control operating manual carries valuable anti-overclaiming and build-phase discipline, but it does not justify permanent separation once the control pack is expanded cleanly.

---

## Merge set B — execution lane
### Target
Merge key useful content from:
- `AURORA_WRAPPER_EXECUTION_OPERATING_MANUAL_V1.md`
into:
- `AURORA_WRAPPER_EXECUTION_PACK.md`

### Keep after merge
- keep `EXECUTION_PACK`
- remove `EXECUTION_OPERATING_MANUAL_V1` after lossless merge

### Why
Execution is a central gravity file.
It should become richer, but still remain one owning pack rather than a permanent split between pack and manual unless it truly becomes unmanageable.

---

## Merge set C — family lane
### Target
Merge key useful content from:
- `AURORA_WRAPPER_FAMILY_ROUTING_MANUAL_V1.md`
into:
- `AURORA_WRAPPER_FAMILY_VAULT.md`

### Keep after merge
- keep `FAMILY_VAULT`
- remove `FAMILY_ROUTING_MANUAL_V1` after lossless merge

### Why
The routing manual added real intelligence, but in end-state form that knowledge belongs inside the family vault itself.

---

## Merge set D — pattern lane
### Target
Merge key useful content from:
- `AURORA_WRAPPER_PATTERN_ROUTING_MANUAL_V1.md`
into:
- `AURORA_WRAPPER_PATTERN_VAULT.md`

### Keep after merge
- keep `PATTERN_VAULT`
- remove `PATTERN_ROUTING_MANUAL_V1` after lossless merge

### Why
Same logic as the family lane.
The knowledge should survive, but the extra file likely should not.

---

## Merge set E — bridge lane
### Target
Merge key useful content from:
- `AURORA_WRAPPER_BRIDGE_OPERATING_MANUAL_V1.md`
into:
- `AURORA_WRAPPER_BRIDGE_PACK.md`

### Keep after merge
- keep `BRIDGE_PACK`
- remove `BRIDGE_OPERATING_MANUAL_V1` after lossless merge

### Why
Bridge doctrine is critical, but it should stay compactly owned by one bridge pack in end-state wrapper form.

---

## Merge set F — packet/review lane
### Target
Merge key useful content from:
- `AURORA_WRAPPER_PACKET_REVIEW_OPERATING_MANUAL_V1.md`
into:
- `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md`

### Keep after merge
- keep `PACKET_EXAMPLE_VAULT`
- remove `PACKET_REVIEW_OPERATING_MANUAL_V1` after lossless merge

### Why
Packet/example/review doctrine belongs together more naturally than as a permanent split.

---

## POSSIBLY TEMPORARY FILES

The following files should be treated as likely transitional rather than permanent:
- `AURORA_WRAPPER_STANDALONE_AUDIT_V1.md`
- `AURORA_WRAPPER_CONTROL_OPERATING_MANUAL_V1.md`
- `AURORA_WRAPPER_EXECUTION_OPERATING_MANUAL_V1.md`
- `AURORA_WRAPPER_FAMILY_ROUTING_MANUAL_V1.md`
- `AURORA_WRAPPER_PATTERN_ROUTING_MANUAL_V1.md`
- `AURORA_WRAPPER_BRIDGE_OPERATING_MANUAL_V1.md`
- `AURORA_WRAPPER_PACKET_REVIEW_OPERATING_MANUAL_V1.md`

They were useful to deepen the wrapper quickly and safely.
But they should not automatically be treated as permanent end-state wrapper structure.

---

## CURRENT BEST NEXT ORDER

### Step 1
Do not add more wrapper files right now.

### Step 2
Run a merge-and-enrich pass pack by pack:
- control
- execution
- family
- pattern
- bridge
- packet/review

### Step 3
After each merge, remove the transitional companion file only when the merge is clearly lossless.

### Step 4
Refresh settings/file-map/maintenance guidance so the final wrapper shape stays truthful.

### Step 5
Refresh SHA/control continuity once the wrapper shape stabilizes.

---

## CURRENT DECISION

Wrapper growth has succeeded in increasing standalone knowledge.
Now the correct architecture move is consolidation.

The wrapper should aim for a final shape of approximately **13 files**, not remain permanently at 19 files.

That means:
- no more casual additions
- knowledge gains must now be folded into owning packs
- package shape must become simpler again while keeping the new doctrinal richness

This should now govern the next wrapper phase.
