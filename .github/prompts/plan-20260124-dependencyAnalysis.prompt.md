# PLAN: Governance File Dependency Analysis & Remediation

**Date:** 2026-01-24
**Author:** GitHub Copilot
**Status:** ANALYSIS COMPLETE - AWAITING REVIEW
**Scope:** Identify hard file references that break chain-load model; design remediation strategy

---

## EXECUTIVE SUMMARY

Analysis of all governance files reveals **8 critical hard references** that force premature file loading, breaking the dynamic chain-load architecture. Key issues: (1) .github/instructions/spec-protocol.instructions.md references 4 other files, forcing them to load; (2) Circular dependencies between Consent Checklist (.github/skills/internal-governance/SKILL.md) and .github/instructions/spec-protocol.instructions.md; (3) Orphaned files with no clear activation trigger. Remediation requires converting hard references to conditional chain metadata and defining DO NOT LOAD UNTIL conditions for all standards files.

---

## FINDINGS

### Cross-File Reference Analysis

#### .github/instructions/spec-protocol.instructions.md

**Hard References:**
- References: .github/instructions/orchestration.instructions.md, .github/instructions/general-coding.instructions.md, Consent Checklist (.github/skills/internal-governance/SKILL.md), Migration Template (.github/skills/templates/SKILL.md)
- Impact: **BREAKS chain-load model** — Forces these 4 files to load when .github/instructions/spec-protocol.instructions.md loads
- Current Behavior: Reader encounters references; agent must ingest referenced files to understand context
- Chain-Load Conflict: .github/instructions/spec-protocol.instructions.md is TIER 0 (always load), but shouldn't force TIER 2 files (governance phase-specific)
- Status: [WARNING] **CRITICAL** — Needs remediation

**Remediation Approach:**
- Convert hard references (`See Consent Checklist`) to chain metadata (`CHAINS TO: Consent Checklist when breaking change detected`)
- Replace static link with: "For breaking changes, Consent Checklist chains automatically when breaking change is detected"

---

#### .github/instructions/orchestration.instructions.md

**Hard References:**
- References: .github/instructions/general-coding.instructions.md (acceptable), Consent Checklist (.github/skills/internal-governance/SKILL.md) (problematic)
- Impact: **BREAKS chain-load model** — Forces the Consent Checklist to load prematurely
- Current Behavior: "See Consent Checklist for a ready-to-use prompt" forces file load
- Chain-Load Conflict: .github/instructions/orchestration.instructions.md is TIER 2 (governance phase), but shouldn't force the Consent Checklist to pre-load
- Status: [WARNING] **HIGH** — Needs remediation

**Remediation Approach:**
- Convert to: "When breaking change is proposed, Consent Checklist chains automatically"
- Define DO NOT LOAD UNTIL: `breaking_change_detected`

---

#### Consent Checklist (.github/skills/internal-governance/SKILL.md)

**Hard References:**
- References: Migration Template (.github/skills/templates/SKILL.md), .github/instructions/spec-protocol.instructions.md
- Impact: **BREAKS chain-load model** — Circular dependency risk
- Current Behavior: Consent Checklist is only referenced by other files; no independent entry point
- Chain-Load Conflict: File cannot be loaded without triggering .github/instructions/spec-protocol.instructions.md again (circular load)
- Orphaned Status: No work phase triggers this file directly
- Status: [WARNING] **CRITICAL** — Needs remediation + explicit trigger definition

**Remediation Approach:**
- Define DO NOT LOAD UNTIL: `breaking_change_proposed`
- Replace hard reference to .github/instructions/spec-protocol.instructions.md with: "Assumes spec-protocol context; triggers after hard gate approval"
- Add metadata: `CHAINS TO: Migration Template (when user confirms breaking change implementation)`

---

#### .github/instructions/general-coding.instructions.md

**Hard References:**
- References: None detected
- Impact: [COMPLETE] **CLEAN** — Can be first loaded without forcing other files
- Chain-Load Status: Ready for chain-load model as-is
- Status: [COMPLETE] No action needed

---

#### .github/instructions/bash.instructions.md

**Hard References:**
- References: .github/instructions/general-coding.instructions.md
- Impact: [WARNING] **EXPECTED** — Language-specific files should chain to core standards
- Chain-Load Status: Acceptable; expected parent-child relationship
- Status: [COMPLETE] Acceptable; may need metadata for clarity: `CHAINS FROM: .github/instructions/general-coding.instructions.md (when bash detected)`

---

#### .github/instructions/powershell.instructions.md

**Hard References:**
- References: .github/instructions/general-coding.instructions.md
- Impact: [WARNING] **EXPECTED** — Language-specific files should chain to core standards
- Chain-Load Status: Acceptable; expected parent-child relationship
- Status: [COMPLETE] Acceptable; may need metadata for clarity: `CHAINS FROM: .github/instructions/general-coding.instructions.md (when powershell detected)`

---

#### Migration Template (.github/skills/templates/SKILL.md)

**Hard References:**
- References: .github/instructions/spec-protocol.instructions.md
- Impact: [WARNING] **CREATES CIRCULAR DEPENDENCY** — References spec-protocol instructions, which references the Migration Template
- Current Behavior: Template file with hard reference to parent governance
- Chain-Load Conflict: Circular load risk; unclear activation trigger
- Orphaned Status: No work phase directly triggers this template
- Status: [WARNING] **MEDIUM** — Needs remediation + trigger definition

**Remediation Approach:**
- Convert hard reference to: "Used when implementing breaking changes per spec-protocol hard gate"
- Define DO NOT LOAD UNTIL: `breaking_change_implementation_phase`
- Add metadata: `CHAINS FROM: Consent Checklist (when user approves breaking change)`

---

#### PROJECT_CONTEXT.md

**Hard References:**
- References: None (foundational)
- Impact: [COMPLETE] **CLEAN** — Foundational file with no outbound references
- Chain-Load Status: Ready for chain-load model as-is
- Status: [COMPLETE] No action needed

---

#### .github/agents/architect.agent.md

**Hard References:**
- References: None (foundational)
- Impact: [COMPLETE] **CLEAN** — Foundational file with no outbound references
- Chain-Load Status: Ready for chain-load model as-is
- Status: [COMPLETE] No action needed

---

## Orphaned Files Analysis

### Consent Checklist (.github/skills/internal-governance/SKILL.md)

**Status:** Orphaned — No clear entry point

**Current Situation:**
- Referenced BY: .github/instructions/spec-protocol.instructions.md, .github/instructions/orchestration.instructions.md, Migration Template (.github/skills/templates/SKILL.md)
- Referenced FROM: Nothing (no file initiates load of the Consent Checklist)
- Activation Trigger: Undefined — File only loads if reader encounters references to it

**Chain-Load Problem:** In lazy-load model, this file never loads unless explicitly requested or inbound reference is processed.

**Solution:** Define explicit DO NOT LOAD UNTIL condition:
- `DO NOT LOAD UNTIL: breaking_change_proposed`
- Metadata entry point: "When user proposes breaking/major change, Consent Checklist chains automatically"

---

### Migration Template (.github/skills/templates/SKILL.md)

**Status:** Orphaned — Template file with undefined activation

**Current Situation:**
- Referenced BY: Consent Checklist (hard reference)
- Referenced FROM: Nothing (no file initiates load of the Migration Template)
- Activation Trigger: Undefined — Template only loads if the Consent Checklist is loaded
- Purpose: Guidance document for implementing breaking changes

**Chain-Load Problem:** File is a template/guide, not an active governance rule. Unclear if it should load automatically or only on-demand.

**Solution:** Define explicit DO NOT LOAD UNTIL condition:
- `DO NOT LOAD UNTIL: breaking_change_implementation_phase`
- Metadata: "Chains from Consent Checklist when user approves breaking change"
- Purpose: Guidance template, loads when user implements approved breaking change

---

## Summary of Issues

| Issue | Files Affected | Severity | Action Required |
| --- | --- | --- | --- |
| Static hard references (forced load) | .github/instructions/spec-protocol.instructions.md, .github/instructions/orchestration.instructions.md, Consent Checklist, Migration Template | HIGH | Convert all to conditional chain metadata |
| Circular dependencies | Consent Checklist ↔ spec-protocol instructions, Migration Template ↔ spec-protocol instructions | MEDIUM | Restructure references; eliminate circular paths |
| Orphaned entry points | Consent Checklist, Migration Template | MEDIUM | Define explicit DO NOT LOAD UNTIL conditions for both |
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
See Consent Checklist for approval gate details.
```

**New Pattern (Chain-load friendly):**
```markdown
When breaking change is proposed, Consent Checklist chains automatically.
(LOAD METADATA: DO NOT LOAD UNTIL: breaking_change_proposed)
```

### Phase 3: Resolve Circular Dependencies

**Current State:**
```
.github/instructions/spec-protocol.instructions.md → references Consent Checklist
Consent Checklist → references spec-protocol instructions (circular)
```

**Resolved State:**
```
.github/instructions/spec-protocol.instructions.md (TIER 0):
   └─ Explains hard gate; chains to Consent Checklist when breaking change detected

Consent Checklist (TIER 2):
   └─ Assumes spec-protocol instructions context (already loaded); no reference back
```

Remove back-reference from Consent Checklist to spec-protocol instructions; assume it's already loaded by chain.

### Phase 4: Define Orphan Activation Triggers

**Consent Checklist:**
- DO NOT LOAD UNTIL: `breaking_change_proposed`
- Chains from: .github/instructions/orchestration.instructions.md (when governance phase begins)

**Migration Template:**
- DO NOT LOAD UNTIL: `breaking_change_implementation_approved`
- Chains from: Consent Checklist (after user approval)

---

## Implementation Order

1. **Add LOAD METADATA to TIER 0 files** (.github/agents/architect.agent.md, PROJECT_CONTEXT.md, .github/instructions/spec-protocol.instructions.md, .github/instructions/general-coding.instructions.md)
   - Declare `TIER: 0`, `DO NOT LOAD UNTIL: N/A`
   - Update .github/instructions/spec-protocol.instructions.md: Declare chains to governance files (don't hard-reference)

2. **Add LOAD METADATA to TIER 1 files** (.github/instructions/bash.instructions.md, .github/instructions/powershell.instructions.md)
   - Declare `TIER: 1`, `DO NOT LOAD UNTIL: [language detected]`
   - Declare `CHAINS FROM: .github/instructions/general-coding.instructions.md`

3. **Add LOAD METADATA to TIER 2 files** (.github/instructions/orchestration.instructions.md, Consent Checklist, Migration Template)
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
