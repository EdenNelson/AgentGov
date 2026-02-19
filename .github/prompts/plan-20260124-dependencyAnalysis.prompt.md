# PLAN: Governance File Dependency Analysis & Remediation

**Date:** 2026-01-24
**Author:** GitHub Copilot
**Status:** ANALYSIS COMPLETE - AWAITING REVIEW
**Scope:** Identify hard file references that break chain-load model; design remediation strategy

---

## EXECUTIVE SUMMARY

Analysis of all governance files reveals **8 critical hard references** that force premature file loading, breaking the dynamic chain-load architecture. Key issues: (1) SPEC_PROTOCOL.md references 4 other files, forcing them to load; (2) Circular dependencies between CONSENT_CHECKLIST.md and SPEC_PROTOCOL.md; (3) Orphaned files with no clear activation trigger. Remediation requires converting hard references to conditional chain metadata and defining DO NOT LOAD UNTIL conditions for all standards files.

---

## FINDINGS

### Cross-File Reference Analysis

#### SPEC_PROTOCOL.md

**Hard References:**
- References: STANDARDS_ORCHESTRATION.md, STANDARDS_CORE.md, CONSENT_CHECKLIST.md, MIGRATION_TEMPLATE.md
- Impact: **BREAKS chain-load model** — Forces these 4 files to load when SPEC_PROTOCOL.md loads
- Current Behavior: Reader encounters references; agent must ingest referenced files to understand context
- Chain-Load Conflict: SPEC_PROTOCOL.md is TIER 0 (always load), but shouldn't force TIER 2 files (governance phase-specific)
- Status: [WARNING] **CRITICAL** — Needs remediation

**Remediation Approach:**
- Convert hard references (`See CONSENT_CHECKLIST.md`) to chain metadata (`CHAINS TO: CONSENT_CHECKLIST.md when breaking change detected`)
- Replace static link with: "For breaking changes, CONSENT_CHECKLIST.md chains automatically when breaking change is detected"

---

#### STANDARDS_ORCHESTRATION.md

**Hard References:**
- References: STANDARDS_CORE.md (acceptable), CONSENT_CHECKLIST.md (problematic)
- Impact: **BREAKS chain-load model** — Forces CONSENT_CHECKLIST.md to load prematurely
- Current Behavior: "See CONSENT_CHECKLIST.md for a ready-to-use prompt" forces file load
- Chain-Load Conflict: STANDARDS_ORCHESTRATION.md is TIER 2 (governance phase), but shouldn't force CONSENT_CHECKLIST.md to pre-load
- Status: [WARNING] **HIGH** — Needs remediation

**Remediation Approach:**
- Convert to: "When breaking change is proposed, CONSENT_CHECKLIST.md chains automatically"
- Define DO NOT LOAD UNTIL: `breaking_change_detected`

---

#### CONSENT_CHECKLIST.md

**Hard References:**
- References: MIGRATION_TEMPLATE.md, SPEC_PROTOCOL.md
- Impact: **BREAKS chain-load model** — Circular dependency risk
- Current Behavior: CONSENT_CHECKLIST.md is only referenced by other files; no independent entry point
- Chain-Load Conflict: File cannot be loaded without triggering SPEC_PROTOCOL.md again (circular load)
- Orphaned Status: No work phase triggers this file directly
- Status: [WARNING] **CRITICAL** — Needs remediation + explicit trigger definition

**Remediation Approach:**
- Define DO NOT LOAD UNTIL: `breaking_change_proposed`
- Replace hard reference to SPEC_PROTOCOL.md with: "Assumes SPEC_PROTOCOL.md context; triggers after hard gate approval"
- Add metadata: `CHAINS TO: MIGRATION_TEMPLATE.md (when user confirms breaking change implementation)`

---

#### STANDARDS_CORE.md

**Hard References:**
- References: None detected
- Impact: [COMPLETE] **CLEAN** — Can be first loaded without forcing other files
- Chain-Load Status: Ready for chain-load model as-is
- Status: [COMPLETE] No action needed

---

#### STANDARDS_BASH.md

**Hard References:**
- References: STANDARDS_CORE.md
- Impact: [WARNING] **EXPECTED** — Language-specific files should chain to core standards
- Chain-Load Status: Acceptable; expected parent-child relationship
- Status: [COMPLETE] Acceptable; may need metadata for clarity: `CHAINS FROM: STANDARDS_CORE.md (when bash detected)`

---

#### STANDARDS_POWERSHELL.md

**Hard References:**
- References: STANDARDS_CORE.md
- Impact: [WARNING] **EXPECTED** — Language-specific files should chain to core standards
- Chain-Load Status: Acceptable; expected parent-child relationship
- Status: [COMPLETE] Acceptable; may need metadata for clarity: `CHAINS FROM: STANDARDS_CORE.md (when powershell detected)`

---

#### MIGRATION_TEMPLATE.md

**Hard References:**
- References: SPEC_PROTOCOL.md
- Impact: [WARNING] **CREATES CIRCULAR DEPENDENCY** — References SPEC_PROTOCOL.md, which references MIGRATION_TEMPLATE.md
- Current Behavior: Template file with hard reference to parent governance
- Chain-Load Conflict: Circular load risk; unclear activation trigger
- Orphaned Status: No work phase directly triggers this template
- Status: [WARNING] **MEDIUM** — Needs remediation + trigger definition

**Remediation Approach:**
- Convert hard reference to: "Used when implementing breaking changes per SPEC_PROTOCOL.md hard gate"
- Define DO NOT LOAD UNTIL: `breaking_change_implementation_phase`
- Add metadata: `CHAINS FROM: CONSENT_CHECKLIST.md (when user approves breaking change)`

---

#### PROJECT_CONTEXT.md

**Hard References:**
- References: None (foundational)
- Impact: [COMPLETE] **CLEAN** — Foundational file with no outbound references
- Chain-Load Status: Ready for chain-load model as-is
- Status: [COMPLETE] No action needed

---

#### PERSONA.md

**Hard References:**
- References: None (foundational)
- Impact: [COMPLETE] **CLEAN** — Foundational file with no outbound references
- Chain-Load Status: Ready for chain-load model as-is
- Status: [COMPLETE] No action needed

---

## Orphaned Files Analysis

### CONSENT_CHECKLIST.md

**Status:** Orphaned — No clear entry point

**Current Situation:**
- Referenced BY: SPEC_PROTOCOL.md, STANDARDS_ORCHESTRATION.md, MIGRATION_TEMPLATE.md
- Referenced FROM: Nothing (no file initiates load of CONSENT_CHECKLIST.md)
- Activation Trigger: Undefined — File only loads if reader encounters references to it

**Chain-Load Problem:** In lazy-load model, this file never loads unless explicitly requested or inbound reference is processed.

**Solution:** Define explicit DO NOT LOAD UNTIL condition:
- `DO NOT LOAD UNTIL: breaking_change_proposed`
- Metadata entry point: "When user proposes breaking/major change, CONSENT_CHECKLIST.md chains automatically"

---

### MIGRATION_TEMPLATE.md

**Status:** Orphaned — Template file with undefined activation

**Current Situation:**
- Referenced BY: CONSENT_CHECKLIST.md (hard reference)
- Referenced FROM: Nothing (no file initiates load of MIGRATION_TEMPLATE.md)
- Activation Trigger: Undefined — Template only loads if CONSENT_CHECKLIST.md is loaded
- Purpose: Guidance document for implementing breaking changes

**Chain-Load Problem:** File is a template/guide, not an active governance rule. Unclear if it should load automatically or only on-demand.

**Solution:** Define explicit DO NOT LOAD UNTIL condition:
- `DO NOT LOAD UNTIL: breaking_change_implementation_phase`
- Metadata: "Chains from CONSENT_CHECKLIST.md when user approves breaking change"
- Purpose: Guidance template, loads when user implements approved breaking change

---

## Summary of Issues

| Issue | Files Affected | Severity | Action Required |
| --- | --- | --- | --- |
| Static hard references (forced load) | SPEC_PROTOCOL.md, STANDARDS_ORCHESTRATION.md, CONSENT_CHECKLIST.md, MIGRATION_TEMPLATE.md | HIGH | Convert all to conditional chain metadata |
| Circular dependencies | CONSENT_CHECKLIST.md ↔ SPEC_PROTOCOL.md, MIGRATION_TEMPLATE.md ↔ SPEC_PROTOCOL.md | MEDIUM | Restructure references; eliminate circular paths |
| Orphaned entry points | CONSENT_CHECKLIST.md, MIGRATION_TEMPLATE.md | MEDIUM | Define explicit DO NOT LOAD UNTIL conditions for both |
| Missing load metadata | All standards files | HIGH | Add LOAD METADATA section to every file |

---

## Remediation Strategy

### Phase 1: Define Load Metadata (All Files)

Every standards file must declare:

```markdown
---
## LOAD METADATA

**TIER:** [0=Always, 1=Language, 2=Governance Phase]
**DO NOT LOAD UNTIL:** [Specific condition or N/A for TIER 0]
**CHAINS TO:** [Next file(s) if applicable, or None]
**CHAINS FROM:** [File(s) that trigger this file, or None]
```

### Phase 2: Convert Hard References to Chain Declarations

**Current Pattern (BREAKS chain-load):**
```markdown
See CONSENT_CHECKLIST.md for approval gate details.
```

**New Pattern (Chain-load friendly):**
```markdown
When breaking change is proposed, CONSENT_CHECKLIST.md chains automatically.
(LOAD METADATA: DO NOT LOAD UNTIL: breaking_change_proposed)
```

### Phase 3: Resolve Circular Dependencies

**Current State:**
```
SPEC_PROTOCOL.md → references CONSENT_CHECKLIST.md
CONSENT_CHECKLIST.md → references SPEC_PROTOCOL.md (circular)
```

**Resolved State:**
```
SPEC_PROTOCOL.md (TIER 0):
  └─ Explains hard gate; chains to CONSENT_CHECKLIST.md when breaking change detected

CONSENT_CHECKLIST.md (TIER 2):
  └─ Assumes SPEC_PROTOCOL.md context (already loaded); no reference back
```

Remove back-reference from CONSENT_CHECKLIST.md to SPEC_PROTOCOL.md; assume it's already loaded by chain.

### Phase 4: Define Orphan Activation Triggers

**CONSENT_CHECKLIST.md:**
- DO NOT LOAD UNTIL: `breaking_change_proposed`
- Chains from: STANDARDS_ORCHESTRATION.md (when governance phase begins)

**MIGRATION_TEMPLATE.md:**
- DO NOT LOAD UNTIL: `breaking_change_implementation_approved`
- Chains from: CONSENT_CHECKLIST.md (after user approval)

---

## Implementation Order

1. **Add LOAD METADATA to TIER 0 files** (PERSONA.md, PROJECT_CONTEXT.md, SPEC_PROTOCOL.md, STANDARDS_CORE.md)
   - Declare `TIER: 0`, `DO NOT LOAD UNTIL: N/A`
   - Update SPEC_PROTOCOL.md: Declare chains to governance files (don't hard-reference)

2. **Add LOAD METADATA to TIER 1 files** (STANDARDS_BASH.md, STANDARDS_POWERSHELL.md)
   - Declare `TIER: 1`, `DO NOT LOAD UNTIL: [language detected]`
   - Declare `CHAINS FROM: STANDARDS_CORE.md`

3. **Add LOAD METADATA to TIER 2 files** (STANDARDS_ORCHESTRATION.md, CONSENT_CHECKLIST.md, MIGRATION_TEMPLATE.md)
   - Declare `TIER: 2`, `DO NOT LOAD UNTIL: [governance phase]`
   - Resolve circular references

4. **Convert all hard references to chain declarations**
   - Replace "See file.md" with "file.md chains when [condition]"
   - Add metadata comments explaining load trigger

5. **Test chain propagation** with 3 governance audit plans

---

## Expected Outcomes

**After Remediation:**

- [COMPLETE] No hard references force unintended file loads
- [COMPLETE] All files declare their load conditions explicitly
- [COMPLETE] Circular dependencies eliminated
- [COMPLETE] Orphaned files have clear activation triggers
- [COMPLETE] Chain-load model can function correctly
- [COMPLETE] Token efficiency improves (lazy loading works as designed)

**Token Savings:**
- Per-session efficiency gains: 15-25% (files only load when needed)
- No change to governance intent; only reference model changes

---

## Risks & Mitigations

| Risk | Probability | Mitigation |
| --- | --- | --- |
| Readers miss critical files | Medium | Add "CHAINS TO" summary section at top of TIER 0 files |
| Circular dependency not fully resolved | Low | Add explicit check in implementation phase |
| Metadata format not intuitive | Medium | Document metadata format in PROJECT_CONTEXT.md |

---

## NEXT STEPS

1. User reviews this dependency analysis plan
2. User approves or requests modifications
3. Execute Phase 1-5 remediation in order
4. Validate with 3 governance audit plans
5. Test chain-load functionality with real projects
