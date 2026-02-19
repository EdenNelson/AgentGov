# PLAN: Conditional CRLF for PowerShell 5.1 + Idempotency by Default

**Date:** January 30, 2026  
**Status:** Approved  
**Scope:** Governance change (behavioral clarification)  
**Severity:** High (changes default line-ending policy)

---

## Problem Statement

Current guidance mandates CRLF for all PowerShell files. This conflicts with the desired default behavior of **idempotency and cross-platform consistency**. You clarified intent:

- **Idempotency by default** (cross-platform scripts should not introduce encoding side effects)
- **CRLF only when explicitly required** (PowerShell 5.1 compatibility is conditional and should be opt-in)

The standard must reflect conditional CRLF usage rather than a blanket mandate.

---

## Analysis & Assessment

### Current State

- .github/instructions/powershell.instructions.md mandates CRLF universally.
- Legacy PowerShell 5.1 exists, but CRLF is only required in specific contexts (GPO/DSC or explicitly stated requirements).

### Constraints

- Legacy PowerShell 5.1 support must be preserved **when required**.
- Default behavior should preserve idempotency and cross-platform stability.

### Proposed Resolution

Adopt a **conditional CRLF policy**:

1. **Default:** Use LF for cross-platform idempotency.
2. **Conditional CRLF:** Use CRLF **only when explicitly required**, such as:
   - Group Policy startup/shutdown scripts
   - DSC configurations
   - Explicit requirement stated by user or project context
3. Require explicit labeling in scripts or instructions when CRLF is required.

---

## Plan

### STAGE 1: Update .github/instructions/powershell.instructions.md (Policy Shift)

**Objective:** Make idempotency the default and CRLF conditional

**Deliverables:**
- [ ] Replace universal CRLF mandate with conditional policy:
  - Default LF for cross-platform idempotency
  - CRLF only when explicitly required (GPO/DSC/5.1 requirement)
- [ ] Add clear triggers for CRLF usage
- [ ] Add explicit note: PowerShell 7+ accepts LF/CRLF; 5.1 may require CRLF in specific contexts

**Checkpoint:** .github/instructions/powershell.instructions.md updated and reviewed

### STAGE 2: Update ADRs

**Objective:** Record the policy change and its rationale

**Deliverables:**
- [ ] Update ADR-0018 to reflect conditional CRLF policy (or create a new ADR if preferred)
- [ ] Note that the default is idempotent LF and CRLF is conditional

**Checkpoint:** ADR updated/created

### STAGE 3: Add a Decision Marker Convention

**Objective:** Make CRLF opt-in explicit in scripts

**Deliverables:**
- [ ] Add guidance for a script header marker, e.g.:
  - `# REQUIRES-CRLF: PowerShell 5.1 (GPO/DSC)`
- [ ] Document how agents should interpret this marker

**Checkpoint:** Marker convention documented

---

## Consent Gate

**Change Type:** Breaking governance change (default line-ending policy shifts to LF)

**User Approval Requested:**
1. Approve switching the default to LF for idempotency.
2. Confirm CRLF is **conditional only** when explicitly required (GPO/DSC/5.1 requirement).
3. Approve the script marker convention for CRLF opt-in.

**Approved:** [x] Eden Nelson on January 30, 2026

---

## References

- [.github/instructions/powershell.instructions.md](../../.github/instructions/powershell.instructions.md)
- [.github/instructions/general-coding.instructions.md](../../.github/instructions/general-coding.instructions.md) (idempotency principle)
- [ADR-0018](../../.github/adr/0018-powershell-crlf-legacy-compatibility.md)
- [.github/instructions/spec-protocol.instructions.md](../../.github/instructions/spec-protocol.instructions.md)
