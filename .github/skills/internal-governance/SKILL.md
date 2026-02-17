---
name: internal-governance
description: AgentGov-only governance maintenance and consent checklists. Do not distribute to consumer projects.
---

This skill mirrors CONSENT_CHECKLIST.md and GOVERNANCE_MAINTENANCE.md. Keep this content in sync with the canonical files.

## Consent Checklist (Breaking/Major Changes)

Use this checklist before implementing any change that may alter end-user usage or backward compatibility.

### Pre-Change Analysis (Required Before Approval)

Before requesting approval, the agent must create a persisted plan. See [SPEC_PROTOCOL.md](SPEC_PROTOCOL.md).

- [ ] **Plan created and persisted:**
  - [ ] Plan exists in `.github/prompts/plan-<YYYYMMDD>-<topic>.prompt.md`
  - [ ] Plan includes Problem Statement, Analysis & Assessment, Stages with Checkpoints
  - [ ] Plan includes Consent Gate section with explicit approval request

- [ ] **Plan contains:**
  - [ ] Change summary: What will change and why
  - [ ] Affected surfaces: CLI/API/config/files/env vars/output formats
  - [ ] Compatibility impact: Breaking vs. behavioral change; who is affected
  - [ ] Risks: Technical and user-impact risks
  - [ ] Alternatives considered: Safer or incremental paths
  - [ ] Rollback strategy: How to revert safely if needed
  - [ ] Migration plan: High-level steps users must take

### Approval Gate

**Question for user:** After reviewing the written plan, do you approve this breaking/major change?

- [ ] **Explicit approval received in this session**
  - [ ] User confirms: "Yes, proceed with this plan"
  - [ ] Sign-off recorded in plan: `Approved by USERNAME on DATE`

### Implementation Phase (After Approval)

- [ ] **Implementation follows plan:**
  - [ ] Agent has read the approved plan completely
  - [ ] Agent understands rationale (Analysis & Assessment)
  - [ ] Agent verifies stages and checkpoints
  - [ ] Agent knows dependencies and constraints
  - [ ] Git commits reference the plan artifact

- [ ] **Post-change validation:**
  - [ ] All plan checkpoints verified
  - [ ] Behavior and docs align with approved plan
  - [ ] No deviations from approved scope without re-approval
  - [ ] Migration documentation updated for users

### References

- [SPEC_PROTOCOL.md](SPEC_PROTOCOL.md): Complete guidance on the Spec Protocol workflow and plan structure
- [STANDARDS_ORCHESTRATION.md](STANDARDS_ORCHESTRATION.md): Orchestration rules and non-ephemeral planning requirements
- [MIGRATION_TEMPLATE.md](MIGRATION_TEMPLATE.md): Template for documenting user-facing changes

## GOVERNANCE MAINTENANCE & PRUNING PROTOCOL

## 🛑 CRITICAL PRE-FLIGHT CHECK (RULE #0)

**BEFORE starting ANY governance maintenance workflow, verify repository context:**

**Repository Check:**

- **IF** the current repository is **NOT** "AgentGov":
  - **IMMEDIATELY REFUSE** and respond: "I cannot run governance maintenance in consumer projects. These are read-only governance imports from AgentGov. All governance changes must be made in the AgentGov repository."
  - **Do not proceed.** Do not ask for confirmation. Do not negotiate.

- **IF** the current repository **IS** "AgentGov":
  - Proceed with governance maintenance workflow below.

**How to Detect:**

- Check `.git/config` for repository name in the `url =` entry
- Check workspace files (e.g., `AgentGov.code-workspace`)
- Ask the user: "What repository are you working in?" if ambiguous

---

## 0. Invocation & Multi-Session Workflow

### Starting Governance Maintenance Mode

To begin a governance maintenance cycle, invoke with:

```text
Please start governance maintenance mode: scan all governance rules and produce an ADR-0001 format suspect list.
```

This triggers **Session 1** of a four-session workflow documented in `.github/adr/README.md`.

### ADR Numbering: Pre-Check Before Generation

Before Creating an ADR, Check Existing ADRs First:

Before generating any new ADR file:

1. **List the `.github/adr/` directory** to identify all existing ADRs (files matching `####-*.md` pattern, where `####` is a zero-padded number).
2. **Determine the next ADR number** by finding the highest existing ADR number and incrementing by 1.
3. **Use the correct filename format:** `NNNN-descriptive-title.md` (e.g., `0005-powershell-windows-compatibility.md`).
4. **Update the ADR header** to match: `# ADR-NNNN: Title`.

This prevents the manual renaming work after generation and ensures consistent numbering from the start.

**Expected Output:** An ADR in `.github/adr/` with status `Proposed` containing a suspect list of problematic rules.

### Multi-Session Handoff

Each session reads the ADR from the previous session and appends its findings:

| Session | Input | Process | Output | ADR Update |
| --- | --- | --- | --- | --- |
| 1 | Governance files | Scan rules | Suspect list | Create ADR, status `Proposed` |
| 2 | ADR #NNNN | Design probe test | Test plan | Add `Test Plan` section |
| 3 | ADR #NNNN + probe | Execute test & refactor | Baseline + post-change results | Add `Execution Notes` section |
| 4 | ADR #NNNN + results | Validate & integrate | Final decision + governance update | Update status to `Accepted` or `Rejected` |

See `.github/adr/README.md` for full details.

---

## 1. Principle: "Chesterton's Fence"

Do not remove a rule until you understand why it was put there. Do not remove a rule until you can prove the system maintains the behavior without it.

## 2. The Pruning Workflow (Test-Driven)

### Step 1: Isolation

Identify the specific rule candidates for removal (e.g., "Section 4.2 is too verbose").

### Step 2: The "Probe" (Unit Test)

Construct a prompt specifically designed to **trigger the rule**.

- **Context:** Clear the chat. Load the current Standards.
- **Input:** A request that strictly violates the target rule.
- **Assertion:** The Agent must catch the violation.

### Step 3: The Refactor

- **Dedup:** Remove if covered by a parent standard.
- **Compress:** Rewrite to lower token count.
- **Delete:** Remove entirely (if suspecting obsolescence).

### Step 4: Regression Check

- Clear the chat.
- Load the **Modified** Standards.
- Re-run the **Probe**.
- **Pass:** Agent still catches the violation. -> **Commit.**
- **Fail:** Agent allows the violation. -> **Revert.**

## 3. Maintenance Log (Example)

| Date | Target Rule | Probe Prompt | Result | Action |
| :--- | :--- | :--- | :--- |
