# Plan: Automatic Governance Hard Gate Detection

**Date:** 2026-01-30  
**Status:** Awaiting Approval  
**Topic:** Automatic file-based detection for governance modifications to enforce SPEC_PROTOCOL hard gate

---

## Problem Statement

The hard gate in SPEC_PROTOCOL (§ 2.1–2.3) requires explicit planning before any governance modification. However, enforcement is currently **command-dependent** — agents must remember to run `/gov` or recognize they're modifying governance files and invoke the hard gate manually.

**Failure Mode:** Agent modifies governance files without a persisted plan (as happened in today's ADR-0014 creation), violating the hard gate principle.

**Impact:** 
- Governance changes become implicit and unauditable
- Framework credibility weakens (can't enforce its own rules)
- Consumer projects that inherit this framework get the same weakness
- SPEC_PROTOCOL becomes advisory, not binding

---

## Analysis & Assessment

### Current State

- SPEC_PROTOCOL § 3.3 lists exemptions (typos, comments, small refactors)
- Governance files are **not** in the exemptions list, implying hard gate applies
- But enforcement is passive: relies on agent memory + manual command invocation
- Result: Fragile, human-dependent, not portable

### Root Cause

The instruction architecture doesn't have **early detection** — the hard gate fires only when user explicitly invokes it or when agent remembers to check. It's a "pull" system, not a "push" system.

### Why Option 1 (Automatic Detection) is Best

1. **Self-Enforcing:** AgentGov demonstrates its own governance by automatically enforcing it
2. **Portable:** Consumer projects inherit automatic protection without changes
3. **No Cognitive Burden:** Agent doesn't have to remember; file path triggers the check
4. **Aligned with SPEC_PROTOCOL § 1.2:** "Make state explicit, durable, and queryable" → automatic enforcement is the natural corollary
5. **Token-Efficient:** Single conditional in base instructions, no verbose reminders

### Assessment

- **Risk:** Low. The check is conditional (only fires on governance files) and non-destructive (blocks modification, asks for plan)
- **Scope:** Changes only `.github/copilot-instructions.md` and creates one ADR
- **Breaking Change:** No. Existing workflows still work; this just prevents bad paths earlier
- **Migration:** No impact on consumer projects; they inherit the safer behavior automatically

---

## Decision

**Implement automatic file-path detection in `.github/copilot-instructions.md` that triggers the hard gate whenever any governance file is modified, regardless of perceived simplicity.**

Governance files affected:
- PERSONA.md, PERSONA_SCRIBE.md
- STANDARDS_*.md
- SPEC_PROTOCOL.md, CONSENT_CHECKLIST.md, GOVERNANCE_MAINTENANCE.md, MIGRATION_TEMPLATE.md, ADR_TEMPLATE.md
- .github/adr/*.md
- .github/copilot-instructions.md

---

## Implementation Stages

### Stage 1: Create ADR-0015

**Objective:** Document the decision to implement automatic hard gate detection

**Deliverables:**
- File: `.github/adr/0015-automatic-governance-hardgate-detection.md`
- Sections: Context, Decision, Consequences, Compliance, Rationale
- Status: Accepted
- Links to this plan and SPEC_PROTOCOL

**Checkpoint:** ADR passes Markdown lint; references are correct

### Stage 2: Update `.github/copilot-instructions.md`

**Objective:** Add automatic detection logic to base instructions

**Locations:**
1. Add new section in "Automatic Governance Hard Gate" after "Governance Immutability Rule"
2. Reference in "Default Mode" → initial context loading
3. Update "/gov" command description to note that detection is automatic

**Deliverables:**
- Conditional check before any governance file modification
- Clear message directing agent to create plan
- Links to SPEC_PROTOCOL § 2.1–2.3

**Checkpoint:** Instructions still pass Markdown lint; detection logic is clear and non-ambiguous

### Stage 3: Validation

**Objective:** Verify the mechanism works as intended

**Test:**
- Read modified `.github/copilot-instructions.md` 
- Confirm governance file list is complete and correct
- Verify message directs to correct plan location

**Checkpoint:** No syntax errors; governance file list matches PROJECT_CONTEXT.md "Sync these files"

---

## Consent Gate

**Breaking Change:** No  
**User-Facing Impact:** No  
**Approval Required:** Explicit approval from Eden Nelson

**Approval Statement:**
- [x] I approve the implementation of automatic governance hard gate detection as described in this plan
- **Date:** 2026-01-30
- **Approved by:** Eden Nelson

---

## References

- SPEC_PROTOCOL.md § 1.2 (Explicit State Reification), § 2.1–2.3 (Hard Gate)
- PROJECT_CONTEXT.md (Governance file list, portability principle)
- `.github/copilot-instructions.md` (Target file for modification)
- Today's incident: ADR-0014 created without persisted plan, revealing the gap

---

## Notes

This plan implements the structural enforcement that makes governance portable and self-healing. Once approved, future governance modifications will automatically trigger the hard gate, eliminating the "forgot to run `/gov`" failure mode.

---

## Implementation Log

**Stage 1: Create ADR-0015** ✅
- File: `.github/adr/0015-automatic-governance-hardgate-detection.md`
- Status: Accepted
- Lint validation: PASS
- Checkpoint: Complete

**Stage 2: Update `.github/copilot-instructions.md`** ✅
- Location: New section "Automatic Governance Hard Gate Detection" inserted after "Governance Immutability Rule"
- Content: File list, Thinking Phase, Coding Phase, No Exemptions section
- Governance file list verified against PROJECT_CONTEXT.md: MATCH
- Lint validation: PASS
- Checkpoint: Complete

**Stage 3: Validation** ✅
- Syntax errors: None
- Governance file list completeness: Complete (all files from PROJECT_CONTEXT.md included)
- References to SPEC_PROTOCOL sections: Verified (§ 2.1–2.3)
- Integration with existing instructions: No conflicts
- Checkpoint: Complete

**Implementation Status:** COMPLETE
**All Checkpoints Passed:** YES
**Approval Timestamp:** 2026-01-30 (recorded above)

