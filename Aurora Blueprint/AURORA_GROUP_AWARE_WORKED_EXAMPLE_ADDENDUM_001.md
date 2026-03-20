# AURORA GROUP-AWARE WORKED EXAMPLE ADDENDUM 001

## PURPOSE

This file corrects the worked-example posture on the Aurora side.

A worked example may still use one symbol instance.
But it must not behave like that symbol is the whole family universe.

This addendum exists so Aurora packets and worked examples stay:
- group-aware
- bucket-aware
- regime-aware

rather than drifting into one-symbol rule sheets.

---

# 1. ROOT LAW

A worked example uses one symbol as an instance.
It does not define a family only for that symbol.

Every worked example should now explicitly say:
- what asset class the symbol belongs to
- what bucket the symbol belongs to
- what group or subtype the symbol belongs to if useful
- what broader family tree is being demonstrated
- what other related symbols could express the same lane under similar regime conditions

---

# 2. REQUIRED ADDITIONAL FIELDS FOR FUTURE EXAMPLES

Worked examples should now add these fields:
- `asset_class`
- `primary_bucket`
- `group_type_or_subtype` if useful
- `family_tree_scope`
- `related_symbols_or_related_classes`
- `what_is_family_logic_vs_symbol_constraint`

---

# 3. WHY THIS MATTERS

Without these fields, a worked example can accidentally become:
- one-symbol doctrine
- pair-specific tunnel vision
- false overfitting to one instrument

Aurora should instead show:
- one symbol is being used as the demonstration case
- but the family tree belongs to a broader bucket / regime logic

---

# 4. CURRENT JUDGMENT

Aurora worked examples should now remain symbol-instanced but not symbol-bound.

That keeps the system aligned with the broader group / bucket / regime routing law.
