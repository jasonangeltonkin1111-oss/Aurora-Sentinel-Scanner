# ARCHIVE IMMUTABILITY

## Status
The entire `archives/` folder is permanently immutable as a source layer.

## Core Law
Archive source content is preserved reference material.
It is not active implementation.
It must not be rewritten, normalized, cleaned, renamed, moved, reformatted, or deleted.

## Allowed Actions
- add new `.md` files for navigation, indexing, mapping, or explanation
- reference archive material from `blueprint/` or `office/`
- compare archive material against active blueprint or MT5 implementation

## Forbidden Actions
- deleting any file or folder under `archives/`
- renaming any archive file or folder
- moving archive files or folders
- changing non-markdown archive files
- reformatting archive source files
- editing archive code, books, text dumps, PDFs, EPUBs, MOBIs, or extracted assets

## Enforcement
- build workers must treat `archives/` as read-only
- Clerk must not modify archive source content
- Debug must flag any archive mutation as a critical violation
- only additive markdown navigation files are permitted inside `archives/`

## Interpretation Rule
Archives preserve provenance.
Blueprint translates meaning.
MT5 implements product logic.
The direction of authority must not reverse.
