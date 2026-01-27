# ADR-0006: ADR Pre-Check Governance — Automated Numbering

**Status:** Accepted  
**Date:** 2026-01-27  
**Author:** Governance Maintenance  
**Context:** During ADR-0005 governance work, manual renaming was required post-generation. This ADR establishes automated ADR numbering checks to prevent that overhead.

---

## Problem Statement

When agents generate new ADRs without checking existing ADR numbers first:

- Generated files use placeholder names (e.g., `ADR-0001-*` when ADRs 0001-0004 already exist)
- Manual renaming and header updates are required after generation
- This introduces process friction and potential for numbering conflicts

The workflow should be autonomous: agents must check existing ADRs **before** generating new ones, ensuring correct numbering from the start.

---

## Root Cause

1. **Missing Upfront Check:** No explicit requirement for agents to list the `.github/adr/` directory before generating new ADR files
2. **Implicit Assumption:** Agents assumed a default numbering scheme without verifying existing ADRs
3. **Process Gap:** The ADR generation workflow lacked a pre-flight step to determine the next available ADR number

---

## Solution

### 1. Add ADR Pre-Check Requirement to Governance Workflow

Updated [GOVERNANCE_MAINTENANCE.md](../../GOVERNANCE_MAINTENANCE.md) with a new **"ADR Numbering: Pre-Check Before Generation"** section that:

- Requires agents to list the `.github/adr/` directory first
- Instructs agents to identify the highest existing ADR number (matching `####-*.md` pattern)
- Mandates correct filename format: `NNNN-descriptive-title.md` (zero-padded, e.g., `0006-adr-pre-check-governance.md`)
- Requires matching ADR header: `# ADR-NNNN: Title`
- Eliminates post-generation renaming by establishing the correct number upfront

### 2. Probe Test

The probe test for this governance is:

```text
Prompt: "I need to create a new ADR for a governance topic. Check the existing ADRs in .github/adr/ first, determine the next ADR number, and create the file with the correct naming and header format."
Assertion: The agent must:
  1. List .github/adr/ contents
  2. Identify highest ADR number (e.g., 0005)
  3. Calculate next number (0006)
  4. Use correct filename: 0006-descriptive-title.md
  5. Use correct header: # ADR-0006: Title
```

**Pass Condition:** File generated with correct numbering on first attempt, no manual renaming required.

---

## Decision

**Accepted.** The ADR pre-check requirement is now codified in GOVERNANCE_MAINTENANCE.md. All agents must check existing ADRs before generating new ones, ensuring consistent numbering and eliminating post-generation renaming overhead.

---

## Follow-Up Actions

1. **Immediate:** Integrate this requirement into agent prompts/instructions for governance maintenance tasks
2. **Documentation:** Link this ADR from [GOVERNANCE_MAINTENANCE.md](../../GOVERNANCE_MAINTENANCE.md#adr-numbering-pre-check-before-generation) in the ADR Numbering section
3. **Training:** When invoking governance maintenance, explicitly reference this rule: "Check existing ADRs before generating new ones"

---

## References

- Updated: [GOVERNANCE_MAINTENANCE.md](../../GOVERNANCE_MAINTENANCE.md) — "ADR Numbering: Pre-Check Before Generation"
- Related: [0005-powershell-windows-compatibility.md](0005-powershell-windows-compatibility.md) — Incident that triggered this governance improvement
