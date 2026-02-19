# REFACTORING PLAN: Implicit Permission → Explicit State Reification (Spec Protocol)

**Date:** January 24, 2026  
**Scope:** Governance Framework Upgrade  
**Status:** Planning Phase

---

## EXECUTIVE SUMMARY

Upgrade the Agent Orchestration governance model from **"Implicit Permission"** (vague consent, ephemeral decisions) to **"Explicit State Reification"** (written architectural specs, durable checkpoints). This enforces the **Spec Protocol**: architectural decisions must be written and reviewed before code generation begins.

---

## PROBLEM STATEMENT: "CODING WHILE THINKING"

**The Anti-Pattern:** The current governance allows agents to begin code generation while still thinking through architectural decisions. This produces:

- **Reactive Refactoring:** Code is written, then revised when implications become clear (waste, churn)
- **Ephemeral Decisions:** Reasoning exists only in chat; no durable record of *why* decisions were made
- **Lost Context on Crashes:** If a session ends unexpectedly, all planning context disappears; recovery requires re-thinking from scratch
- **No Audit Trail:** Changes cannot be traced back to architectural decisions or rationale
- **Implicit Consent:** Approval gates lack the written specs needed to evaluate trade-offs properly

**The Preventive Mechanism:** The **Spec Protocol** enforces a **hard gate** between thinking and coding:
1. **Analyze & Assess:** Write the change impact, constraints, risks, alternatives
2. **Draft the Plan:** Document stages, checkpoints, expected outputs
3. **Persist the Plan:** Save artifacts in `.github/prompts/` (durable, queryable)
4. **Explicit Approval:** User reviews written spec, approves or requests changes
5. **ONLY THEN:** Proceed to implementation (coding phase)

This ensures **architectural decisions are written and reviewed before code generation begins**.

---

## CORE PRINCIPLES: EXPLICIT STATE REIFICATION & KNOW BEFORE YOU ROLE

### 1. Explicit State Reification

**Definition:** Make the state of architectural decisions explicit, durable, and queryable by persisting them in written artifacts.

**Current Reality (Implicit):**
- Decisions exist only in chat transcripts (ephemeral)
- State is lost if session ends
- Cannot ask "What was decided?" or "Why?" without replaying conversation
- No way to audit or trace decisions

**Target Reality (Explicit):**
- All significant architectural decisions written into `.github/prompts/plan-*.md` artifacts
- State is persisted in the repository (durable)
- Artifacts are queryable: grep, diff, history, blame
- Decision rationale is permanent and auditable
- Sessions can resume with full context from artifacts

**How Spec Protocol Implements Reification:**
- Plan artifacts (`.github/prompts/plan-<YYYYMMDD>-<topic>.prompt.md`) are the "reified state"
- Each plan contains: Analysis, Assessment, Stages, Checkpoints, Expected Outputs
- These artifacts become the source of truth for what was approved and why
- Implementation is traced back to plan via git commit links

### 2. Know Before You Role

**Definition:** Understand the current state, constraints, and approved scope *before* taking action (before you "role" forward or "roll" out changes).

**Pre-Flight Checks:**
- [ ] Read the approved plan artifact
- [ ] Understand the analysis and assessment
- [ ] Verify the stages and checkpoints match expectations
- [ ] Confirm explicit approval was granted in the plan
- [ ] Check dependencies: are other changes needed first?
- [ ] Validate that no blocking issues have emerged since approval

**What "Know Before You Role" Prevents:**
- Starting work without reading the plan (wasted effort)
- Implementing more than approved (scope creep)
- Missing dependencies or hidden constraints
- Proceeding despite changed context (new issue discovered)
- Surprises: "I didn't know we were also doing X"

**Implementation in Spec Protocol:**
- The **Explicit Approval** checkpoint in the plan is the permission gate
- Agent MUST read and verify the plan before coding
- Plan contains all context needed to answer "Do I understand the full scope?"
- Checkpoints in the plan serve as "gates" — verify each before proceeding

---

## CURRENT STATE ANALYSIS

### Current Model: Implicit Permission
- **Consent Checklist (.github/skills/internal-governance/SKILL.md)** provides a checklist (reactive approval gate)
- **.github/instructions/orchestration.instructions.md** defines consent rules but lacks **durable architectural documentation**
- **Migration Template (.github/skills/templates/SKILL.md)** exists for user-facing changes but no **agent-facing plan artifacts**
- **No persisted planning requirement** before significant changes
- Decisions exist only in ephemeral chat; no checkpoint recovery after session crashes

### Governance Gaps
1. **Vague Consent:** Checklist is incomplete without written spec pre-approval
2. **Ephemeral Planning:** Plans created in chat are lost if session crashes
3. **No Reification:** State of architectural decisions is not explicit or queryable
4. **Missing Audit Trail:** No durable record of *why* decisions were made

---

## TARGET STATE: Explicit State Reification (Spec Protocol)

### Core Requirements

**SPEC PROTOCOL:** Before implementing significant changes:
1. **Analyze** the change (context, constraints, risks)
2. **Assess** options (alternatives, trade-offs)
3. **Draft a Plan** with clear stages and checkpoints
4. **Persist the Plan** in `.github/prompts/` as `plan-<YYYYMMDD>-<topic>.prompt.md`
5. **Require Explicit Approval** before proceeding to implementation
6. **Link Plan to Implementation** (traceability)

### Target Governance Files

| File | Current State | Target Change | Rationale |
|------|---------------|----------------|-----------|
| **Consent Checklist (.github/skills/internal-governance/SKILL.md)** | Reactive checklist | Add **Pre-Change Analysis** section | Enforce written spec before approval |
| **.github/instructions/orchestration.instructions.md** | Mentions Spec Protocol (§3) vaguely | **Fully specify** the Spec Protocol workflow | Detailed, actionable instructions |
| **Migration Template (.github/skills/templates/SKILL.md)** | User-facing migrations only | Add **Agent Planning Template** section | Agents must document architectural changes |
| **.github/instructions/general-coding.instructions.md** | General principles only | Add **Spec Protocol Requirement** | Enforce spec-first approach globally |
| **.github/prompts/** | Empty directory | **Establish prompt persistence pattern** | Durable checkpoints for refactoring |
| **NEW: .github/instructions/spec-protocol.instructions.md** | Does not exist | Create detailed reference guide | Central documentation for Spec Protocol |

---

## SUPERSESSION & CONFLICT RESOLUTION

### Old Rules Being Superseded

The current .github/instructions/orchestration.instructions.md contains vague and conflicting guidance that will be **replaced or clarified** by the Spec Protocol:

| Old Rule | Current Weakness | How Spec Protocol Replaces It |
|----------|------------------|------------------------------|
| **§1.1 Consent Gate** (User approval required) | Approval can happen without written specs; implicit consent allowed | **Preserved & Enhanced:** Consent now *requires* written plan artifacts showing Analysis, Assessment, and Plan before user approval gate |
| **§1.2 Required Approval Flow** (Propose → Ask → Implement) | Proposal can be verbal/chat-only; no durable record | **Replaced:** New flow is Plan (persisted) → Approve (written) → Implement; plan is the proposal artifact |
| **§3 ARCHITECTURAL SPECIFICATION (vague)** | Mentioned but not defined; no actionable spec structure | **Replaced:** Merged into new .github/instructions/spec-protocol.instructions.md with full definition and examples |
| **§4.1 Non-Ephemeral Planning (vague)** | Says plans should be persisted but gives no structure, naming convention, or minimum contents | **Replaced:** .github/instructions/spec-protocol.instructions.md provides Plan Prompt Naming Convention, Minimum Contents, and Recovery Procedures |
| **§4.3 Plan Prompt Minimum Contents (vague)** | Lists vague sections ("Analysis and Assessment") without definitions | **Replaced:** New .github/instructions/spec-protocol.instructions.md defines each section with examples and required minimum content |

### Integration Points (No Breaking Changes to User Consent)

1. **User Consent Requirement:** Preserved. Still mandatory for breaking/major changes.
   - **Change:** Approval now *requires* written plan as input (user reads/reviews plan before approving)
   - **Before:** Approval happened after chat discussion (ephemeral)
   - **After:** Approval happens after reviewing persisted plan artifact (explicit)

2. **Timing:** Clarified. Plan must be written and **persisted BEFORE user approval is requested**.
   - **Old ambiguity:** §4.1 says "prior to implementation" — unclear if that's before or after approval
   - **New clarity:** Prior to both approval request AND implementation

3. **Scope:** Clarified. What changes require a plan?
   - **Old:** "Significant change" (refactors, feature additions, interface alterations, structural reorganizations)
   - **New:** Same scope, **plus** exceptions clearly listed (minor edits, typos, comment fixes are exempt)

### Files That Will Be Merged/Replaced

- **.github/instructions/orchestration.instructions.md §3–4** → Merged into .github/instructions/spec-protocol.instructions.md; links updated
- **.github/instructions/orchestration.instructions.md §1** → Kept but enhanced (references Spec Protocol as prerequisite)
- **Consent Checklist (.github/skills/internal-governance/SKILL.md)** → Updated to reference plan artifacts; workflow reordered

### No Removed Permissions

- **User consent gate remains non-bypassable** for breaking/major changes
- **Scope exceptions** (minor edits) remain as-is
- **Rollback strategy requirement** stays in place

---

## REFACTORING PLAN

### STAGE 1: Foundation (Spec Protocol Definition)

**Objective:** Write the authoritative Spec Protocol spec itself. **This spec will enforce the hard gate: architectural decisions must be written and reviewed before code generation begins.**

**Deliverables:**
- [ ] **.github/instructions/spec-protocol.instructions.md** (new file)
  - Definition and purpose of Spec Protocol
  - **Anti-Pattern Addressed:** "Coding While Thinking" — the failure mode of beginning code generation before decisions are finalized
  - Workflow diagram (Analyze → Assess → Plan → Approve → **[HARD GATE]** → Implement)
  - Plan prompt structure and examples
  - Checkpoint requirements
  - Session persistence and recovery patterns
  - Scope exceptions (minor edits, typos, comment fixes)
  - **Emphasis:** Thinking phase must complete with persisted artifacts **before** coding phase begins

**Checkpoint:** .github/instructions/spec-protocol.instructions.md reviewed and approved

---

### STAGE 2: Update Orchestration Standards

**Objective:** Integrate Spec Protocol into .github/instructions/orchestration.instructions.md

**Deliverables:**
- [ ] **.github/instructions/orchestration.instructions.md** (update)
  - Replace vague §3 ("ARCHITECTURAL SPECIFICATION") with full Spec Protocol spec OR cross-reference to .github/instructions/spec-protocol.instructions.md
  - Expand §4 ("NON-EPHEMERAL PLANNING") with:
    - Explicit trigger conditions (breaking changes, refactors, feature additions, structural reorganizations)
    - Plan prompt naming convention with examples
    - Minimum required sections (title, scope, analysis, assessment, plan, consent gate, persistence)
    - Recovery procedures after session crashes
  - Clarify relationships between Consent Gate (§1) and Spec Protocol (§4)

**Checkpoint:** .github/instructions/orchestration.instructions.md updated and reviewed

---

### STAGE 3: Strengthen Consent Checklist

**Objective:** Refactor Consent Checklist (in .github/skills/internal-governance/SKILL.md) to require written analysis *before* approval.

**Deliverables:**
- [ ] **Consent Checklist (.github/skills/internal-governance/SKILL.md)** (update)
  - Add section: **"Pre-Change Analysis (Required Before Approval)"**
    - Concise analysis of impact, risks, alternatives
    - Reference to the durable plan prompt (if created)
  - Reorder checklist: Analysis → Approval → Implementation → Validation
  - Add checkbox: "[ ] Written plan persisted in `.github/prompts/`"
  - Add checkpoint: "[ ] Plan reviewed and approved in session before implementation begins"

**Checkpoint:** Consent Checklist updated and reviewed

---

### STAGE 4: Unified Standards Framework

**Objective:** Ensure all standards reference Spec Protocol; no contradictions.

**Deliverables:**
- [ ] **.github/instructions/general-coding.instructions.md** (update)
  - Add reference to Spec Protocol in §1.1 (Core Values) or new section
  - Link to .github/instructions/orchestration.instructions.md and .github/instructions/spec-protocol.instructions.md
  - Clarify that "Coding while Thinking" is prohibited for significant changes

- [ ] **.github/instructions/bash.instructions.md** (review only; no changes unless needed)
  - Verify no contradictions with Spec Protocol

- [ ] **.github/instructions/powershell.instructions.md** (review only; no changes unless needed)
  - Verify no contradictions with Spec Protocol

- [ ] **PROJECT_CONTEXT.md** (update)
  - Add section: "Governance & Specification Protocol"
  - Link to .github/instructions/spec-protocol.instructions.md and .github/instructions/orchestration.instructions.md
  - Brief summary of Spec Protocol applicability

**Checkpoint:** All standards reviewed for alignment; cross-references verified

---

### STAGE 5: Migration & Documentation

**Objective:** Explain Spec Protocol to users and agents; establish repeatable pattern.

**Deliverables:**
- [ ] **Migration Template (.github/skills/templates/SKILL.md)** (update or extend)
  - Add **Agent Planning Template** section for architectural changes
  - Separate sections: User-Facing Changes vs. Agent Architectural Changes
  - Link to plan prompt example

- [ ] **README or GOVERNANCE_GUIDE.md** (if needed)
  - High-level guide to governance files and their purposes
  - Quick-start: How agents should use Spec Protocol
  - Links to all relevant standards and templates

**Checkpoint:** Migration template and guides reviewed

---

### STAGE 6: Establish Prompt Artifact Pattern

**Objective:** Demonstrate the persistent planning pattern in practice.

**Deliverables:**
- [ ] **Refactoring This Task Using Spec Protocol**
  - Create `plan-20260124-spectProtocolRefactor.prompt.md` (this file)
  - Link the plan to implementation in .github/instructions/orchestration.instructions.md as an example
  - After refactoring is complete, plan artifact serves as audit trail

**Checkpoint:** Plan artifact exists; links trace implementation back to plan

---

## ANALYSIS & ASSESSMENT

### The "Coding While Thinking" Failure Mode

**Definition:** An agent begins code generation before architectural decisions are finalized and written. The agent "thinks through" implications while writing, leading to:

1. **Reactive Refactoring:** Initial code is wrong; must be rewritten after issues appear
2. **Wasted Tokens:** Thinking + rewriting = higher cost and slower execution
3. **Lost Decisions:** Reasoning about trade-offs happens in chat; no permanent record
4. **Unrecoverable Context:** Session crash = complete loss of architectural reasoning
5. **Implicit Consent:** User approves changes without seeing written analysis of risks/trade-offs
6. **No Audit Trail:** Cannot answer "Why was this decision made?" months later

**Example Scenario:**
- Agent starts refactoring .github/instructions/orchestration.instructions.md without a written plan
- Realizes mid-way that Spec Protocol spec should be in a separate file (.github/instructions/spec-protocol.instructions.md)
- Backtracks, deletes work, starts over
- Session crashes; plan is lost; next session starts from scratch
- User approves final changes without knowing rejected alternatives were considered

### Current Pain Points
1. **No Durable Decisions:** Plans created in chat disappear after session ends
2. **Implicit Consent:** Approval happens without written architectural reasoning
3. **Recovery Gaps:** If session crashes, refactoring context is lost
4. **Audit Failure:** No way to trace a change back to its original spec or decision
5. **Thinking-While-Coding:** Architectural decisions are made *during* implementation, not *before*

### Proposed Solutions
1. **Persistent Plans:** All significant changes documented in `.github/prompts/` **before implementation begins**
2. **Explicit Specs:** Written analysis, assessment, and plan required and **reviewed before approval**
3. **Checkpoints:** Plan artifact serves as recovery anchor; can resume with full context
4. **Audit Trail:** Implementation linked to plan; rationale is queryable
5. **Hard Gate:** Coding phase begins **only after** plan is approved and finalized

### Trade-offs
| Option | Pros | Cons |
|--------|------|------|
| **Full Spec Protocol (Proposed)** | Durable, auditable, recoverable; prevents thinking-while-coding | Overhead for minor changes (mitigated by exceptions) |
| **Lightweight Checklist Only** | Fast approval process | No durability; decisions ephemeral; thinking-while-coding persists |
| **Hybrid: Tiered Approval** | Flexibility for scope | More complex governance rules; risk of falling back to thinking-while-coding |

**Recommendation:** Implement full Spec Protocol with clear **scope exceptions** (minor edits, typos, comment fixes) to balance durability, auditability, and efficiency.

---

## EXPECTED OUTPUTS

### Files Created
- `.github/prompts/plan-20260124-spectProtocolRefactor.prompt.md` (this file)
- `.github/instructions/spec-protocol.instructions.md` (new file)
- Possibly: `GOVERNANCE_GUIDE.md` (if needed for clarity)

### Files Modified
- `.github/instructions/orchestration.instructions.md` (expanded Spec Protocol spec; clearer non-ephemeral planning)
- `Consent Checklist (.github/skills/internal-governance/SKILL.md)` (added pre-change analysis requirement; reordered workflow)
- `.github/instructions/general-coding.instructions.md` (reference to Spec Protocol)
- `PROJECT_CONTEXT.md` (governance section)
- `Migration Template (.github/skills/templates/SKILL.md)` (agent planning section added)

### No Breaking Changes
- Existing user consent workflow preserved; enhanced with written specs
- Backward compatible with current Consent Checklist usage
- Scope exceptions allow minor work to proceed without plans

---

## CONSENT GATE

**Question:** This refactoring changes the governance workflow for all future AI-driven changes in this repository. The Spec Protocol requires durable planning artifacts and explicit approval stages.

**Impact:** 
- User-facing: None (external API unchanged)
- Agent-facing: Requires written plan artifacts for significant changes; session recovery improved
- Repository: New `.github/prompts/` patterns establish durable checkpoint precedent

**Risks:**
- Overhead if scope exceptions not clearly defined (mitigated: exceptions listed in .github/instructions/spec-protocol.instructions.md)
- Learning curve for agents following new pattern (mitigated: clear examples and templates)

**Rollback:** If governance changes prove too rigid, exceptions can be expanded or protocol simplified. Existing plan artifacts remain as audit trail.

---

## IMPLEMENTATION CHECKPOINTS

1. ✓ **Plan Complete:** This spec document is written and ready for approval
2. ✓ **Approve:** User confirmed "Proceed with Spec Protocol refactoring"
3. ✓ **Stage 1:** .github/instructions/spec-protocol.instructions.md created with full spec
4. ✓ **Stage 2:** .github/instructions/orchestration.instructions.md updated with Spec Protocol integration
5. ✓ **Stage 3:** Consent Checklist updated with Pre-Change Analysis section
6. ✓ **Stage 4:** .github/instructions/general-coding.instructions.md, PROJECT_CONTEXT.md updated; standards aligned
7. ✓ **Stage 5:** Migration Template extended with Agent Planning section
8. ✓ **Stage 6:** Plan artifact linked to implementation; this plan serves as audit trail

---

## COMPLETION SUMMARY

**All Stages Complete ✓**

The Spec Protocol refactoring has been implemented across all governance files:

- **.github/instructions/spec-protocol.instructions.md** (new): Complete reference guide for explicit state reification
- **.github/instructions/orchestration.instructions.md** (updated): Integrated Spec Protocol with cross-references
- **Consent Checklist (.github/skills/internal-governance/SKILL.md)** (updated): Workflow reordered to require pre-change analysis
- **.github/instructions/general-coding.instructions.md** (updated): Added Spec Protocol requirement to core values
- **PROJECT_CONTEXT.md** (updated): Added governance section with links
- **Migration Template (.github/skills/templates/SKILL.md)** (updated): Added agent planning section
- **.github/instructions/bash.instructions.md** (reviewed): No conflicts identified
- **.github/instructions/powershell.instructions.md** (reviewed): No conflicts identified

**Key Outcomes:**

1. **Hard Gate Established:** No code generation begins before written architectural specs
2. **Explicit State Reification:** All decisions persisted in `.github/prompts/plan-*.md` artifacts
3. **Know Before You Role:** Pre-flight checks required before implementation begins
4. **Durable Audit Trail:** Plans become permanent records in git; decisions are queryable
5. **Session Recovery:** If session crashes, agents can resume from last checkpoint using plan artifacts
6. **No Breaking Changes:** User consent requirement preserved; integrated with Spec Protocol
7. **Clear Exemptions:** Minor edits (typos, syntax, comment fixes) may proceed without plans

**Cross-References Working:**
- .github/instructions/spec-protocol.instructions.md linked from .github/instructions/orchestration.instructions.md, Consent Checklist, PROJECT_CONTEXT.md
- All governance files mention spec-protocol instructions in references sections
- Hard gate workflow is discoverable and actionable

---

## REFERENCES

This plan artifact demonstrates the Spec Protocol in practice:
- **Location:** `.github/prompts/plan-20260124-spectProtocolRefactor.prompt.md`
- **Status:** Approved and implemented
- **Audit Trail:** All commits implementing stages 1-6 reference this plan
- **Recovery:** Agents can read this plan to understand the full refactoring context

---

## REFERENCES

- **Current:** .github/instructions/orchestration.instructions.md §3–4 (vague Spec Protocol mention)
- **Current:** Consent Checklist (reactive approval pattern)
- **Current:** Migration Template (user-facing only)
- **Target:** Integrated Spec Protocol with durable planning artifacts and explicit approval gates
