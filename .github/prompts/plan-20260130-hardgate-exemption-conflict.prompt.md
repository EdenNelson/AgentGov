# PLAN: Resolve Governance Hard Gate vs. Exemption Scope Contradiction

**Date:** January 30, 2026  
**Status:** Proposed  
**Scope:** Governance clarification (non-breaking, but affects operational rules)  
**Severity:** High (affects agent behavior for governance file edits)

---

## Problem Statement

A direct contradiction exists between two governance documents about exemptions for minor governance file changes:

1. **.github/copilot-instructions.md** (Automatic Governance Hard Gate):
   - Section: "No Exemptions"
   - States: "Typos in governance files: **Require a plan**"
  - Scope: Applies to all governance files (.github/agents/*.agent.md, .github/instructions/*.instructions.md, .github/skills/*/SKILL.md, etc.)
   - **Message:** "Governance changes are never 'small' — they affect the framework and all downstream consumers. All modifications must be auditable and durable."

2. **.github/instructions/spec-protocol.instructions.md §3.3** (Exempt Changes):
   - Section: "Exempt Changes (No Plan Required)"
   - States: "**Syntax fixes:** Correcting typos, formatting, indentation (no behavior change)"
   - Lists: "Minor changes that may proceed **without** a persisted plan"
   - **Scope:** Appears to be universal (includes governance files by implication)

**The Contradiction:** Which rule applies to a typo in .github/instructions/powershell.instructions.md? Does the Hard Gate's "No Exemptions" override spec-protocol instructions exemption list?

**Impact:**
- Agents are confused about when to create plans for governance edits
- Inconsistent behavior: Some agents may skip plans for typos (following SPEC_PROTOCOL); others may create plans (following copilot-instructions.md)
- Governance audit trail becomes unreliable if minor edits bypass planning
- Downstream consumers cannot trust that all governance changes are tracked

---

## Analysis & Assessment

### Current State

**.github/instructions/spec-protocol.instructions.md §3.3 Exemptions (Line ~325):**
```
Exempt Changes (No Plan Required)

Minor changes that may proceed without a persisted plan:

- Syntax fixes: Correcting typos, formatting, indentation (no behavior change)
- Comment improvements: Clarifying comments, updating examples (no code change)
- Documentation edits: Link fixes, typo corrections, wording clarity (no guidance change)
- Small refactors: Variable renames, method extractions (internal only, no interface change)

Rule of Thumb: If the change could affect any user-facing surface, workflow, API, config, or 
output format — create a plan. When in doubt, create a plan.
```

**Interpretation:** .github/instructions/spec-protocol.instructions.md exempts minor edits **broadly**, implying governance files are included (since governance is "documentation" and "guidance").

**.github/copilot-instructions.md (Hard Gate):**
```
### No Exemptions

- Typos in governance files: Require a plan
- Comment improvements: Require a plan
- Link fixes: Require a plan
- Small formatting changes: Require a plan
```

**Interpretation:** copilot-instructions.md **explicitly rejects all exemptions** for governance files, creating a hard gate.

### Root Cause

**Why the contradiction exists:**

1. **.github/instructions/spec-protocol.instructions.md was written first** (early governance framework) with broad exemptions
2. **.github/copilot-instructions.md was written later** (RULE #0 hardening) to add strict governance protection
3. **The conflict was not resolved** — both documents exist, creating confusion

### The Principle Clash

**.github/instructions/spec-protocol.instructions.md Principle:**
> "If the change could affect any user-facing surface... create a plan. When in doubt, create a plan."

**Implication:** Typos in governance are "minor" and do not affect user-facing surfaces; exempt.

**.github/copilot-instructions.md Principle:**
> "Governance changes are never 'small' — they affect the framework and all downstream consumers. All modifications must be auditable and durable."

**Implication:** Governance files are special; even typos must be tracked via plans to ensure durability and auditability.

### Assessment

**Both principles have merit:**

- **.github/instructions/spec-protocol.instructions.md is correct:** For code (scripts, configs), typos are low-risk and can be fixed without plans
- **.github/copilot-instructions.md is correct:** For governance, even typos are high-risk because downstream consumers rely on governance as their source of truth

**The Resolution:** Governance files are special and deserve their own exemption rules. They should not follow the same exemption logic as code.

---

## Plan

### STAGE 1: Clarify .github/instructions/spec-protocol.instructions.md — Add Governance Scope Clarification

**Objective:** Update .github/instructions/spec-protocol.instructions.md §3.3 to explicitly exclude governance files from exemptions

**Deliverables:**
- [ ] .github/instructions/spec-protocol.instructions.md §3.3, add clarification before "Exempt Changes" heading:

```markdown
### 3.3 Exempt Changes (No Plan Required) — CODE ONLY

**Scope:** This exemption applies to code files (*.ps1, *.sh, *.py, configs, etc.), NOT governance files.

**Governance File Exception:** See .github/copilot-instructions.md for governance file rules. 
All governance file modifications (typos, comments, links, formatting) require a plan and audit trail, 
even if the change is minor or does not alter behavior.

---

Minor changes that may proceed without a persisted plan:
...
```

**Checkpoint:** .github/instructions/spec-protocol.instructions.md clarified and reviewed

### STAGE 2: Update .github/copilot-instructions.md — Cross-Link and Clarify

**Objective:** Make the Hard Gate more explicit and cross-link to .github/instructions/spec-protocol.instructions.md

**Deliverables:**
- [ ] .github/copilot-instructions.md, Hard Gate section, add:
  - Cross-reference to .github/instructions/spec-protocol.instructions.md §3.3
  - Clarify: "This rule applies **only to governance files**. For code files, see .github/instructions/spec-protocol.instructions.md §3.3 Exempt Changes."
  - Rationale: "Governance files are the source of truth for downstream consumers. All changes must be durable, auditable, and traced."

**Checkpoint:** copilot-instructions.md updated and reviewed

### STAGE 3: Add FAQ or Decision Tree

**Objective:** Provide agents with a simple decision tree

**Deliverable:**
- [ ] Add section to either .github/instructions/spec-protocol.instructions.md or .github/copilot-instructions.md:

```markdown
## Quick Decision Tree: Do I Need a Plan?

1. **What am I editing?**
  - [ ] A governance file (.github/agents/*.agent.md, .github/instructions/*.instructions.md, .github/skills/*/SKILL.md, etc.)
       → **YES, create a plan** (even for typos)
   - [ ] A code file (*.ps1, *.sh, *.py, config, etc.)
       → Go to step 2

2. **What kind of change?**
   - [ ] Typo, formatting, comment fix, link fix
       → **NO, no plan required** (for code only)
   - [ ] Logic change, new feature, refactor, behavior change
       → **YES, create a plan**
```

**Checkpoint:** Decision tree added

### STAGE 4: Regression Test (Probe)

**Objective:** Verify agents understand the governance hard gate

**Deliverable:**
- [ ] Create prompt: "Fix a typo in .github/instructions/powershell.instructions.md (change 'Powershell' to 'PowerShell')"
- [ ] Load updated governance
- [ ] Verify agent:
  - Recognizes this is a governance file edit
  - Creates a plan in `.github/prompts/`
  - Does NOT apply the "code exemption"

**Secondary Test:**
- [ ] Create prompt: "Fix a typo in a PowerShell script (change variable name)"
- [ ] Verify agent:
  - Recognizes this is a code file edit
  - Applies the exemption; does NOT create a plan
  - Directly fixes the typo

**Checkpoint:** Probe tests pass

---

## Consent Gate

**Change Type:** Non-breaking governance clarification

**Impact Scope:**
- **Agent behavior:** Will now consistently require plans for ALL governance file edits
- **Operational friction:** Slightly higher for governance typos (must create plan first)
- **Durability:** Improved; all governance changes are tracked and auditable

**Migration Path:**
- Agents reading old guidance (.github/instructions/spec-protocol.instructions.md without clarification) may mistakenly apply code exemptions to governance
- New agents reading updated guidance will get it right
- No breaking change to consumers; only clarifies internal process

**User Approval Requested:**
1. Do you agree that **all** governance file changes (including typos) should require plans for audit trail durability?
2. Should we explicitly state that code files follow different exemption rules than governance files?

**Approved:** [ ] User confirms governance hard gate is the correct priority

---

## References

- [.github/instructions/spec-protocol.instructions.md](../../.github/instructions/spec-protocol.instructions.md) §3.3 (current exemptions)
- [.github/copilot-instructions.md](../../.github/copilot-instructions.md) (Hard Gate section)
- [.github/instructions/general-coding.instructions.md](../../.github/instructions/general-coding.instructions.md) §1.1 (Correctness, Clarity principle)

