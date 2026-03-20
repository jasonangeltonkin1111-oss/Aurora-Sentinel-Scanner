# ASC AURORA JOINT EVOLUTION PROTOCOL

## PURPOSE

This file makes the bridge between ASC and Aurora explicit.

It exists because the project has now reached the point where:
- ASC cannot evolve as an isolated scanner forever
- Aurora cannot evolve as an isolated doctrine archive forever

From this point forward, ASC and Aurora should grow hand in hand.
They may evolve at different speeds, but they must remain aware of each other’s progress and update pressure.

---

# 1. ROOT LAW

Every meaningful ASC update must ask:
- what does this change imply for Aurora?
- what Aurora file, object, or protocol should be updated because of it?

Every meaningful Aurora update must ask:
- what does this change imply for ASC?
- what ASC field, dossier section, telemetry surface, or runtime contract should be updated because of it?

An update is no longer fully complete if it only improves one side while silently drifting away from the other.

---

# 2. WHAT THIS BRIDGE PREVENTS

This protocol exists to prevent:
- ASC becoming a rich scanner with no doctrine bridge
- Aurora becoming a rich doctrine system with no live truth bridge
- duplicated concepts with mismatched names
- missing telemetry that Aurora keeps needing but ASC never exposes
- doctrine files that assume data surfaces ASC does not publish
- scanner features that Aurora never consumes

---

# 3. JOINT EVOLUTION CHECK RULE

From now on, every meaningful update wave should include a joint evolution check.

That check should answer:

## 3.1 If the update is ASC-first
- what new truth surface was added or changed?
- does Aurora already consume it?
- if not, what Aurora file or object should be updated?
- did any existing Aurora assumption become stale?

## 3.2 If the update is Aurora-first
- what new doctrine surface or object was added?
- does ASC already expose the needed truth fields?
- if not, what ASC file or dossier contract should be updated?
- did any existing ASC surface become insufficient or misnamed?

---

# 4. SHARED BRIDGE QUESTIONS

Every cross-check should review these questions:

1. **Context bridge**
- Does ASC provide the truth Aurora now needs?

2. **Naming bridge**
- Are ASC and Aurora using the same names for the same concepts?

3. **Freshness bridge**
- Can Aurora tell when ASC truth is stale, degraded, or unavailable?

4. **Deployability bridge**
- Does ASC expose the execution / friction truth Aurora’s deployability logic needs?

5. **Geometry bridge**
- Does ASC expose enough session / market-status truth for Aurora’s geometry and timebox logic?

6. **Opportunity bridge**
- Can ASC shortlist and Aurora preserve opportunities without starving the system?

7. **Automation bridge**
- Are Aurora’s machine-safe outputs grounded in ASC fields that are stable enough to automate later?

---

# 5. REQUIRED OUTPUT OF A JOINT CHECK

A joint evolution check should produce at least one of:
- `NO_BRIDGE_CHANGE_NEEDED`
- `ASC_NEEDS_UPDATE`
- `AURORA_NEEDS_UPDATE`
- `BOTH_NEED_UPDATE`

And when change is needed, it should name:
- the affected files
- the affected objects or contracts
- the missing bridge surface

---

# 6. PRACTICAL BUILD ORDER LAW

When possible, use this order:
1. update the primary side
2. run the joint evolution check
3. patch the bridge on the other side
4. log the cross-update in the run file

This keeps the systems synchronized without forcing them to evolve at identical speed.

---

# 7. SHARED OBJECT ALIGNMENT

ASC and Aurora should increasingly align around a shared object chain:
- ASC context truth
- Aurora state / surface / deployability interpretation
- Aurora opportunity and strategy-card outputs
- bounded EA-safe subset later

This does not mean the systems merge.
It means the handoff between them becomes explicit and version-aware.

---

# 8. WHAT COUNTS AS A MEANINGFUL UPDATE

Examples of meaningful ASC updates:
- new dossier fields
- new friction telemetry
- new session truth
- new ranking / shortlist logic
- new runtime degradation states

Examples of meaningful Aurora updates:
- new deployability rules
- new geometry rules
- new object model layers
- new strategy-card fields
- new EA-safe output fields

Small editorial cleanups do not require a full joint evolution check.
Architecture or contract changes do.

---

# 9. BEGINNER OPERATOR LAW

Because this is a massive long-horizon project, the operator should not be forced to remember all bridge dependencies mentally.

Therefore:
- the bridge must live in repo files
- run logs should mention joint-check outcomes
- new files should state what they depend on from the other side

This makes the project easier to carry over time.

---

# 10. CURRENT JUDGMENT

ASC and Aurora are no longer separate growth tracks.

From this point forward:
- they evolve at their own pace
- but every meaningful update must check the bridge
- and when one side advances, the other side should be reviewed and patched accordingly

This is now the official hand-in-hand growth law for the project.
