# L1.2 SCHEMA MIGRATION PACKET

### 1. PURPOSE
Define the next bounded universe-snapshot schema upgrade so Layer 1.2 persistence can evolve without reopening unrelated product layers or granting false authority during restore.

### 2. BOUNDED SCHEMA LABEL
- The next schema label is `V4`.
- `V4` is the bounded upgrade for Layer 1.2 universe snapshot persistence only.
- `V4` must not be treated as a general product-version banner or as permission to revise unrelated dossier, ranking, activation, diagnostics, or UI payloads.
- Schema/version work remains centralized under HQ and must stay bounded to explicit release-authorized packets.

### 3. REQUIRED V4 SNAPSHOT SHAPE
`V4` records must carry these fields in the schema/header layer or in the first authoritative record envelope before any symbol payload is trusted:
- record snapshot timestamp
- producer version
- schema version/header
- universe fingerprint
- recovery authority markers
- legacy-restore downgrade rules

Recommended bounded header shape:
- `schema_version = "V4"`
- `record_snapshot_timestamp = <canonical UTC snapshot time captured when the file is written>`
- `producer_version = <build/release producer string written by the version owner>`
- `universe_fingerprint = <stable fingerprint derived from the symbol universe shape used to produce the file>`
- `recovery_authority_markers = <bounded flags proving this file came from the current release-approved writer path>`
- `legacy_restore_downgrade_rules = <explicit downgrade/compatibility marker set for older snapshot readers>`

### 4. VERSION-OWNER-TASK-ONLY FIELDS
The following fields are version-owner-task only and must not be invented, rewritten, or inferred by generic restore/migration workers:
- `producer_version`
- `schema_version` / any header banner field that changes the bounded schema label
- `recovery_authority_markers`
- `legacy_restore_downgrade_rules`
- the canonical algorithm and inputs used to compute `universe_fingerprint`

Only the final version-owner release task may bless new values for those fields.
Other workers may preserve or transport them, but they must not escalate authority by minting replacement values.

### 5. PARSE RULES FOR OLDER SNAPSHOTS
#### V3 parse rule
- Accept `V3` payloads as legacy-readable snapshots only.
- Parse them into a non-authoritative legacy restore path.
- Missing `record_snapshot_timestamp`, `producer_version`, `universe_fingerprint`, `recovery_authority_markers`, or `legacy_restore_downgrade_rules` must be treated as absent authority, not as permission to synthesize trusted values.
- A parsed `V3` file may recover observational data fields that are still structurally valid, but it must not claim release-approved recovery authority merely because the payload shape is familiar.

#### V1/V2 parse rule
- Accept `V1` and `V2` only through a stricter downgrade parser.
- Treat `V1`/`V2` as structurally incomplete legacy snapshots with no embedded authority.
- Read only fields that are still explicitly mapped in the live restore contract.
- Unknown, renamed, or silently collapsed fields must degrade to `missing` / `legacy-untrusted` rather than being up-converted into trusted `V4` equivalents.
- `V1`/`V2` inputs must never populate release authority markers, producer identity, or a modern universe fingerprint.

### 6. FALSE-AUTHORITY PREVENTION LAW
When parsing `V3`, `V2`, or `V1`:
- never infer authority from file existence alone
- never equate successful parsing with release approval
- never backfill `producer_version` from runtime build text unless the version-owner task explicitly owns that migration
- never mint `recovery_authority_markers` during restore
- never generate a `universe_fingerprint` from a legacy file and then treat that generated value as proof the legacy file was produced by the current writer
- never rewrite an old payload as `V4` during passive restore without a dedicated upgrade path owned by the final release/version task

### 7. DOWNGRADE / LEGACY-RESTORE RULES
`legacy_restore_downgrade_rules` should explicitly encode bounded behavior such as:
- whether the file may be read as data-only legacy state
- whether restore must strip authority-only fields before hydration
- whether downgrade requires universe mismatch quarantine
- whether legacy records may contribute gap-fill observations without restoring producer-owned authority
- whether the file must remain read-only until a final release-owned upgrader rewrites it

At minimum, older schema restores must support three outcomes:
1. `restore-allowed-data-only`
2. `restore-allowed-with-quarantine`
3. `restore-blocked-await-upgrade`

### 8. IMPLEMENTATION BOUNDARY NOTES
- The schema packet is about persistence contract shape, not a license to expand business logic.
- If `V4` is introduced, all writers/readers must preserve the current law that restore cannot grant false activation, ranking, or ownership authority.
- Future schema labels beyond `V4` require a fresh bounded HQ decision and must not be implied by this packet.
