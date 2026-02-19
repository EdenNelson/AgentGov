# Master Plan: Governance Maintenance + ADR Integration Workflow

## Executive Summary

This plan integrates two scribe reports into a unified, multi-session governance improvement workflow where **ADRs serve as the central decision record** for all governance changes. Rather than scattered artifacts, each governance maintenance effort will be captured in a single ADR that tracks all four phases: suspect identification, test planning, execution, and validation.

## Prior Analysis

This master plan builds on two scribe analysis documents (archived in `.github/prompts/archive/`):

- [scribe-plan-20260126-governance-maintenance.md](archive/scribe-plan-20260126-governance-maintenance.md) — Identified gaps in the governance maintenance workflow
- [scribe-plan-20260126-adr-automation.md](archive/scribe-plan-20260126-adr-automation.md) — Identified gaps in ADR automation and integration

These scribes informed the assessment and design of this master plan.

---

## Problem Statement

1. **Governance Maintenance Gap:** No operational entrypoint exists to trigger governance scans or enumerate problematic rules.
2. **ADR Automation Gap:** ADRs are not being produced for governance changes, and no workflow ties them to governance decisions.
3. **Multi-Session Coordination:** Four distinct session phases exist (suspect → test → execute → validate) but lack durable handoff artifacts.
4. **Living Document Void:** No central place tracks the status of in-progress governance changes across sessions.

---

## User Intent

Enable a **documented, artifact-driven governance maintenance workflow** where:

- Session 1 produces a suspect list (ADR in "Proposed" status)
- Session 2 drafts a test plan (ADR updated to "Testing" section)
- Session 3 executes change and records results (ADR updated with "Execution Notes")
- Session 4 validates and finalizes decision (ADR moves to "Accepted" or "Rejected")

**The ADR becomes the single source of truth** for governance change status, rationale, and outcomes.

---

## Standard ADR Location & Naming

**Directory:** `.github/adr/`
**Naming Convention:** `NNNN-<verb>-<governance-area>.md`

Examples:

- `.github/adr/0001-prune-token-wasting-rules.md`
- `.github/adr/0002-consolidate-overlapping-standards.md`
- `.github/adr/0003-clarify-agent-consent-requirements.md`

**Rationale:** Industry standard (joelparkerhenderson/architecture-decision-record). The `.github/` location keeps governance artifacts close to repository metadata; numeric prefixing enables sequential tracking.

---

## Formalization: "Scribe" as Official Artifact Type

As part of this plan, we formalize the "scribe" artifact as an official stage in the SPEC_PROTOCOL workflow.

**Definition:**

A **scribe** is a pre-planning analysis document that captures the thinking phase before a plan is drafted. It answers:
- What is the problem?
- What gap exists?
- What intent is the user trying to fulfill?
- What are the constraints?
- What are the success criteria?

**Naming Convention:** `scribe-<YYYYMMDD>-<topic>.md`

**Location:** `.github/prompts/` (active) or `.github/prompts/archive/` (superseded)

**Workflow Position:**
```
Analysis (Scribe) → Plan (plan-*.md) → Approval → Coding
```

Scribes are typically replaced by a formal plan artifact; they are archived once a plan is approved.

**Update Required:** .github/instructions/spec-protocol.instructions.md section 2.1 should be updated to document the scribe stage before the thinking phase diagram.

---

## Integration: Governance Maintenance + ADR Workflow

### Phase 1: Suspect Identification (Session 1)

**Artifact:** New ADR in `.github/adr/` with status `Proposed`

**Input:** Invoke governance maintenance mode (CLI or agent instruction)

**Process:**

1. Scan all governance files (.github/instructions/*.instructions.md, .github/copilot-instructions.md, governance rules)
2. Enumerate suspected problematic rules with rationales:
   - **Invalid:** Rule refers to non-existent patterns or outdated frameworks
   - **Superseded:** Another rule now covers this; deduplication opportunity
   - **Conflicting:** Two rules contradict each other
   - **Token Waste:** Rule is overly verbose or redundant
3. Create ADR with:
   - **Status:** `Proposed`
   - **Context:** What was scanned, why the scan was triggered
   - **Suspect List:** Table of rules with issue category and brief rationale
   - **Decision:** "Begin governance review cycle for listed suspects"

**Output:** ADR file persisted in `.github/adr/`; filename and number recorded for next session

---

### Phase 2: Test Planning (Session 2)

**Artifact:** Same ADR updated with `Testing` section; status remains `Proposed`

**Input:** ADR number and suspect rule identifier

**Process:**

1. Select one suspect rule from Phase 1 ADR
2. Design "Probe" test per Governance Maintenance (in .github/skills/internal-governance/SKILL.md):
   - Clear chat context
   - Load current Standards
   - Construct prompt that violates the target rule
   - Document assertion: "Agent must catch violation"
3. Add to ADR:
   - **Testing Section:**
     - Target rule and category
     - Probe prompt (full text)
     - Expected agent behavior (assertion)
     - Pass criteria (e.g., "Agent flags violation within 2 turns")
   - **Test Plan Link:** Cross-reference the probe methodology

**Output:** ADR updated; ready for Phase 3 execution

---

### Phase 3: Execution & Results (Session 3)

**Artifact:** Same ADR updated with `Execution Notes` section; status remains `Proposed`

**Input:** ADR number with test plan

**Process:**

1. Execute the Probe test on **current Standards** (baseline)
2. Apply suspected change (compress, dedup, or delete rule)
3. Re-run Probe on **modified Standards** (post-change)
4. Record results:
   - **Baseline Result:** Pass/Fail/Behavior observed
   - **Modified Result:** Pass/Fail/Behavior observed
   - **Regression Status:** "Passed" (change is safe) or "Failed" (change breaks behavior)
   - **Change Details:** Exact modification made (diff snippet)
5. Add to ADR:
   - **Execution Notes Section:**
     - Date and session ID
     - Baseline behavior
     - Change applied (with code/text diff)
     - Post-change behavior
     - Regression verdict

**Output:** ADR updated with execution results; ready for Phase 4

---

### Phase 4: Validation & ADR Finalization (Session 4)

**Artifact:** Same ADR finalized; status changes to `Accepted` or `Rejected`

**Input:** ADR with execution results

**Process:**

1. Review all prior phases (suspect, test, execution results)
2. Validate regression test results:
   - **If Passed:** Rule change is safe; proceed to governance integration
   - **If Failed:** Rule change breaks behavior; revert and mark as `Rejected`
3. If Accepted:
   - Integrate change into governance file (apply the change for real)
   - Update ADR with `Consequences` section:
     - What becomes easier? (e.g., "Standards are 200 tokens shorter")
     - What becomes harder? (e.g., "More agent sessions needed for validation")
     - Risks introduced? (e.g., "Oversight risk if probe wasn't comprehensive")
   - Move ADR status to `Accepted`
   - Commit both ADR and governance change together
4. If Rejected:
   - Document why in ADR (e.g., "Regression test showed rule still needed")
   - Move ADR status to `Rejected`
   - Add optional `Retry Plan` section if rule might be revisited

**Output:** ADR finalized with decision; governance file either updated or unchanged

---

## ADR Template Enhancements

Update ADR Template (in .github/skills/templates/SKILL.md) to support:

1. **Status Values:** Add to the existing list:
   - `Proposed` ← Initial suspect identification
   - `Testing` ← Test plan drafted (optional explicit status, or included in Proposed ADR)
   - `Accepted` ← Governance change integrated
   - `Rejected` ← Change deemed unsafe or invalid
   - `Deprecated` ← Former rule no longer applies (for governance cleanup ADRs)
   - `WONTFIX` ← Known issue; no action planned (for governance edge cases)

2. **New Sections for Governance Maintenance ADRs:**
   - **Suspect List** (Phase 1): Table of identified problematic rules
   - **Test Plan** (Phase 2): Probe design, assertions, pass criteria
   - **Execution Notes** (Phase 3): Baseline, change, post-change behavior
   - **Validation Results** (Phase 4): Regression verdict, integration status

3. **Compliance Section:** Keep existing `Standards` and `Governance` checks

---

## Multi-Session Handoff Pattern

| Phase         | Session | Input             | Output                                      | ADR Status       |
| ------------- | ------- | ----------------- | ------------------------------------------- | ---------------- |
| 1: Suspects   | 1       | Governance files  | ADR with suspect list                       | `Proposed`       |
| 2: Test Plan  | 2       | ADR #NNNN         | ADR with probe & assertions                 | `Proposed`       |
| 3: Execute    | 3       | ADR #NNNN         | ADR with baseline + post-change results     | `Proposed`       |
| 4: Validate   | 4       | ADR #NNNN         | ADR with final verdict + governance change  | `Accepted` or `Rejected` |

**Key:** Each session reads the prior session's ADR updates, never starts over. ADR is the durable state.

---

## Implementation Tasks

1. **Create `.github/adr/` directory** with README explaining:
   - Purpose: Governance decision log
   - Naming convention: `NNNN-<verb>-<area>.md`
   - Status values supported
   - Multi-session workflow

2. **Create `.github/prompts/archive/` directory** for old scribe and plan artifacts

3. **Update .github/instructions/spec-protocol.instructions.md** to formalize scribe artifacts:
   - Add section defining scribe purpose and naming convention
   - Position scribe in workflow diagram (before thinking phase)
   - Note that scribes transition to plans; old scribes are archived

4. **Update ADR Template (in .github/skills/templates/SKILL.md)** to include:
   - Full list of status values (Proposed, Testing, Accepted, Rejected, Deprecated, WONTFIX)
   - Governance-specific sections (Suspect List, Test Plan, Execution Notes, Validation Results)
   - Example ADR for a governance change (e.g., pruning a verbose rule)

5. **Document governance maintenance invocation** in Governance Maintenance (in .github/skills/internal-governance/SKILL.md):
   - How to start governance scan (e.g., agent instruction or CLI command)
   - Expected ADR output
   - How to hand off to next session (by ADR number)

6. **Establish ADR numbering** (start at 0001; auto-increment per new governance decision)

7. **Create governance-maintenance.prompt** in `.github/prompts/` for Session 1:
   - Instruction for agent to scan governance files
   - Produce ADR with suspect list
   - Stop and wait for user approval before proceeding

8. **Archive superseded scribe files:**
   - Move `scribe-plan-20260126-governance-maintenance.md` → `.github/prompts/archive/`
   - Move `scribe-plan-20260126-adr-automation.md` → `.github/prompts/archive/`
   - Update ADR-0001 to reference archived scribe reports in "Prior Analysis" section

---

## Constraints & Safeguards

- **No in-place edits:** Governance files (.github/instructions/*.instructions.md, .github/copilot-instructions.md) remain unchanged until Phase 4 ADR is `Accepted`
- **Protected files:** ADR itself is the only mutable record during Phases 1–3
- **Immutable baseline:** Suspect list and test plan (Phases 1–2) cannot be altered; new concerns become new ADRs
- **Living document exception:** Execution Notes and Validation Results may be amended with timestamps if new information emerges (aligned with industry ADR practice)

---

## Success Criteria

- [ ] ADR directory `.github/adr/` created with sequential numbering scheme
- [ ] ADR template updated with governance-specific sections and status values
- [ ] Multi-session governance workflow documented and tested end-to-end
- [ ] Clear handoff mechanism exists between all four phases (via ADR updates)
- [ ] Governance files remain unchanged until final validation ADR is `Accepted`
- [ ] Every governance change leaves a permanent decision trail (ADR)
- [ ] Workflow can be repeated without manual intervention for multiple concurrent suspects

---

## Next Steps

**Immediate Actions:**
1. User approves this master plan
2. Create `.github/adr/` directory and README
3. Update ADR Template (in .github/skills/templates/SKILL.md) with governance sections
4. Update Governance Maintenance (in .github/skills/internal-governance/SKILL.md) with invocation & handoff guidance
5. Create first governance-maintenance.prompt for Session 1 agent

**First Cycle Test:**
- Run governance scan (Session 1) → produce ADR with suspect list
- Manually verify suspect identification
- Proceed to Session 2 when user signals readiness

