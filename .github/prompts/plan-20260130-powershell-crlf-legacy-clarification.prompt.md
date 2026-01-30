# PLAN: Clarify PowerShell CRLF Requirement for Legacy 5.1 Compatibility

**Date:** January 30, 2026  
**Status:** Approved  
**Scope:** Governance clarification (non-breaking)  
**Severity:** Medium (documentation clarity for mandatory standard)

---

## Problem Statement

STANDARDS_POWERSHELL.md mandates CRLF for all PowerShell files but does not explicitly document **why**. This creates confusion, especially in cross-platform contexts where PowerShell 7+ accepts LF. The real constraint is **legacy Windows PowerShell 5.1**, particularly for **Group Policy startup/shutdown scripts** and **DSC** scenarios.

**Gap:** The rule is correct but under-specified. It needs explicit rationale and scope so agents do not misdiagnose LF as the root cause or incorrectly propose removing CRLF.

---

## Analysis & Assessment

### Current State

- STANDARDS_POWERSHELL.md says CRLF is mandatory for all PowerShell files.
- The rationale mentions Windows execution and orchestration (DSC, GPO, WinRM), but does not clearly tie the mandate to **PowerShell 5.1 legacy requirements**.
- This leads to contradictions with cross-platform idempotency discussions and agent debugging guidance.

### Constraints

- The environment still includes **PowerShell 5.1 legacy requirements**.
- Backward compatibility for Windows GPO/DSC is **non-negotiable**.

### Proposed Resolution

Clarify the CRLF rule by adding explicit rationale that:

- **PowerShell 5.1** (Windows PowerShell) is sensitive to line endings in legacy execution contexts.
- **Group Policy** and **DSC** are the primary drivers for CRLF enforcement.
- **PowerShell 7+** accepts LF/CRLF, but CRLF remains mandatory to preserve 5.1 compatibility.

### Trade-offs

- **Pro:** Eliminates ambiguity; prevents agents from treating CRLF as optional.
- **Con:** Reinforces Windows-specific requirement even though Core 7+ is tolerant.

### Risk Assessment

- **Low risk:** Clarification only; does not change behavior.
- **No user-facing impact:** Standard remains intact; explanation improves compliance.

---

## Plan

### STAGE 1: Update STANDARDS_POWERSHELL.md — Add Explicit Legacy Rationale

**Objective:** Make the CRLF mandate unambiguous and tied to PowerShell 5.1 legacy requirements

**Deliverables:**
- [ ] Add rationale subsection under "File Encoding and Line Endings" explaining:
  - PowerShell 5.1 legacy compatibility requirement
  - Group Policy and DSC execution contexts
  - PowerShell 7+ accepts both, but CRLF is mandatory due to legacy requirements
- [ ] Ensure wording is precise and avoids implying CRLF is optional

**Checkpoint:** STANDARDS_POWERSHELL.md updated and reviewed

### STAGE 2: Update ADR (If Required)

**Objective:** Record the decision in an ADR for audit trail

**Deliverables:**
- [ ] Create a new ADR documenting CRLF mandate rationale for legacy 5.1
- [ ] OR update existing ADR-0005 if it already covers this rule (confirm scope)

**Checkpoint:** ADR created/updated with rationale

---

## Consent Gate

**Change Type:** Non-breaking governance clarification

**User Approval Requested:**
1. Confirm the rationale: CRLF is mandatory primarily for PowerShell 5.1 legacy compatibility (GPO/DSC).
2. Approve adding explicit rationale language to STANDARDS_POWERSHELL.md.

**Approved:** [x] Eden Nelson on January 30, 2026

---

## References

- [STANDARDS_POWERSHELL.md](../../STANDARDS_POWERSHELL.md) (CRLF mandate)
- [SPEC_PROTOCOL.md](../../SPEC_PROTOCOL.md) (plan requirement for governance changes)
- [ADR-0005](../../.github/adr/0005-powershell-windows-compatibility.md) (related Windows compatibility guidance)
