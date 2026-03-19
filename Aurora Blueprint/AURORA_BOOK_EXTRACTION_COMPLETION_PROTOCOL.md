# AURORA BOOK EXTRACTION COMPLETION PROTOCOL

## PURPOSE

This file defines how Aurora must track book extraction so the same books do not need to be re-uploaded repeatedly and the project does not drift into partial extraction loops.

This protocol exists because the library is large, chats get bloated, and continuity has to survive across many runs.

The rule is simple:
- extract each uploaded book as deeply as possible in its active wave when it is in scope
- log what was extracted
- log where it landed
- mark what residue remains
- avoid returning to the same book repeatedly unless later global consolidation or cross-wave synthesis genuinely requires it

---

# 1. ROOT LAW

A book is not considered "done" merely because it was mentioned in a source pass.

A book is considered sufficiently complete for the current stage only when all four conditions are met:

1. the book is logged in the extraction ledger
2. its main doctrinal destinations are explicitly named
3. its current extraction depth is classified honestly
4. its deferred residue is explicitly recorded instead of being silently dropped

---

# 2. EXTRACTION STATUS LABELS

Each book must use one of these statuses:

- `NOT_UPLOADED`
- `UPLOADED_NOT_OPENED`
- `OPENED`
- `PARTIALLY_EXTRACTED`
- `STRONGLY_PRESERVED_FOR_CURRENT_WAVE`
- `CURRENT_WAVE_COMPLETE`
- `DEFERRED_RESIDUE_ONLY`
- `REFERENCE_ONLY`

## Meaning

### `PARTIALLY_EXTRACTED`
Useful content has been preserved, but the current wave still has meaningful uncovered extraction value.

### `STRONGLY_PRESERVED_FOR_CURRENT_WAVE`
The book’s main conceptual contribution has been captured into active source-pass and doctrine artifacts strongly enough that the project can move on without needing immediate return.

### `CURRENT_WAVE_COMPLETE`
The book’s active-wave contribution is fully logged, destination coverage is explicit, and only later cross-wave synthesis should revisit it.

### `DEFERRED_RESIDUE_ONLY`
The main current-wave value is already captured. Only clearly deferred material remains for later waves or later consolidation.

---

# 3. REQUIRED LEDGER FIELDS PER BOOK

Every tracked book entry should include:

- book title / filename
- wave or source-set cluster
- source classification (`TRANSLATE`, `REFERENCE ONLY`, `DO NOT USE`)
- current status label
- extraction depth estimate
- main doctrine destinations reached
- deferred residue still remaining
- last artifact(s) touched
- re-upload needed? (`YES` / `NO`)
- current judgment

---

# 4. EXTRACTION DEPTH SCALE

Use this rough depth scale:

- `0` = not opened
- `1` = opened / role identified
- `2` = first source-pass preservation exists
- `3` = doctrine strengthening exists
- `4` = card/pattern/evidence layer impact exists
- `5` = current-wave contribution fully logged and no immediate revisit needed

This is not a claim of total lifetime extraction.
It is a claim of current-wave completion quality.

---

# 5. REUPLOAD RULE

A book should be marked `re-upload needed = NO` once:
- its current-wave conceptual contribution is strongly preserved
- residue is explicitly logged
- the project can move forward without needing the original upload again for the same wave task

A book should only need re-upload later if:
- the earlier upload was incomplete or corrupted
- the repo never actually preserved its main contribution cleanly
- a later cross-wave synthesis truly requires direct source return and no complete extraction residue exists

---

# 6. ONE-PASS EXTRACTION RULE

Within an active wave:
- extract as much of the book’s relevant contribution as possible in one bounded campaign
- preserve both primary contribution and deferred residue
- do not keep bouncing back to the same book for tiny fragments if the main value can be captured now

This does **not** mean every page must be flattened into doctrine immediately.
It means the repo must capture enough of the book’s active-wave value that the project can move on safely.

---

# 7. LATER RETURN RULE

Returning to a book later is allowed only for one of these reasons:
- later wave needs deferred residue that was already logged
- later consolidation needs source verification
- later evidence work needs a specific section not yet translated

Returning later is **not** a reason to skip strong current-wave extraction now.

---

# 8. CURRENT JUDGMENT

Aurora should now track books as extraction assets, not as vague references.

This protocol exists so uploaded books can be processed once, logged honestly, and moved past without repeated re-upload dependence.
