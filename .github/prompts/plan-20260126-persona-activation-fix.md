# PLAN: Persona Activation & Mode Switching Governance

**Date:** 2026-01-26
**Status:** Proposed
**Scope:** Governance improvement; non-breaking
**Issue:** Persona loading ambiguity when agent must switch from Scribe to Architect mode

---

## Problem Statement

When reviewing scribe-plan files, an agent loaded both PERSONA.md (The Pragmatic Architect) and PERSONA_SCRIBE.md (The Scribe) simultaneously. This created role ambiguity:

- Scribe persona has "Prime Directives": NO CODE, NO SOLUTIONING, LISTEN ONLY
- Architect persona has opposite mandate: ANALYZE, CLASSIFY, SOLVE

The agent could not correctly apply SPEC_PROTOCOL §2.4 (Scribe-Plan Ingestion & Architect Analysis) because both persona constraints were active, creating contradictory behavioral expectations.

**Root Cause:** No explicit mechanism exists in the governance framework to:

1. Activate/deactivate personas based on context
2. Prevent simultaneous loading of mutually exclusive personas
3. Signal when role-switching is required

---

## Analysis & Assessment

### Context

- PERSONA.md defines The Pragmatic Architect (primary analyst role)
- PERSONA_SCRIBE.md defines The Scribe (intake/listening role)
- SPEC_PROTOCOL §2.4 requires Architect to reclassify scribe-plan files
- PROJECT_CONTEXT.md describes dynamic chain-loading but lacks persona-specific rules

### Current State

- Both personas are portable, reusable documents
- No mutual exclusion mechanism
- No explicit activation conditions
- Workspace loading via .cursorrules loads both personas without distinction

### Risk Assessment

Severity: Medium (Operational)

- Agent cannot execute Architect role when reviewing scribe-plans (violates SPEC_PROTOCOL §2.4)
- Scribe constraints bleed into Architect context (e.g., agent refuses to propose solutions when analyzing problems)
- Leads to confusing agent behavior and incomplete analysis
- Does not break existing code but prevents governance workflow execution

### Alternatives Considered

#### Alternative 1: Remove PERSONA_SCRIBE.md

Scribe role becomes unavailable. Rejected: Scribe is needed for intake interviews.

#### Alternative 2: Keep both always loaded; rely on user signal

User must say "Switch to Architect mode." Rejected: Implicit, requires user discipline, error-prone.

#### Alternative 3: Merge personas into one

Single adaptive persona. Rejected: Violates separation of concerns; makes PERSONA.md bloated.

#### Alternative 4: Add explicit activation rules

Document in SPEC_PROTOCOL when each persona applies. **Selected:** Minimal change, clear rules, preserves modularity.

---

## Decision

Add **Persona Activation & Mode Switching** guidelines to SPEC_PROTOCOL.md (new §2.5) and .cursorrules. Establish that:

### Mutual Exclusivity

- Only one persona is active in a session
- Default: Architect (PERSONA.md)
- Scribe is triggered explicitly via `/scribe` or an explicit intake request
- Session stickiness: If `/scribe` is invoked, the session stays Scribe until explicitly exited; if not invoked, the session remains Architect

### Activation Conditions

- Architect mode (default): analyzing scribe-plans, reviewing plans, designing solutions, creating plan-*.md specs
- Scribe mode (explicit trigger): `/scribe`, "Switch to Scribe mode", or "Let's do an intake interview"; only active during intake loop, then reverts to Architect after "That's it"

### Implementation Rule

- SPEC_PROTOCOL.md will state: "When reviewing scribe-plan files per §2.4, activate Architect persona only. Scribe Prime Directives do not apply."
- .cursorrules will clarify that dynamic chain-loading applies to standards files (STANDARDS_*.md), not persona files, and define explicit persona activation.
- Add a context verification command to .cursorrules to report currently loaded governance files (PERSONA/PERSONA_SCRIBE, SPEC_PROTOCOL, STANDARDS_*), plus a manual fallback to load .cursorrules if the workspace skips it.

---

## Plan (Stages & Checkpoints)

### Stage 1: Clarify Persona Activation in SPEC_PROTOCOL.md

**Objective:** Add explicit persona activation rules to the Scribe-Plan section.

**Deliverables:**

- [ ] Add §2.5 "Persona Activation & Mode Switching" to SPEC_PROTOCOL.md
- [ ] Document Architect vs. Scribe mutual exclusion
- [ ] Link to PERSONA.md and PERSONA_SCRIBE.md with explicit conditions
- [ ] Include example: "When reviewing scribe-plans, activate Architect, NOT Scribe"

**Checkpoint:** Section 2.5 exists, is clear, and specifies the rule.

### Stage 2: Update .cursorrules (Context & Activation)

**Objective:** Clarify that dynamic chain-loading applies to STANDARDS files, NOT persona files, and document persona activation in .cursorrules.

**Deliverables:**

- [ ] Update .cursorrules to state: "Persona files (PERSONA.md, PERSONA_SCRIBE.md) are mutually exclusive and controlled via explicit user commands (default Architect, `/scribe` for Scribe), NOT dynamic chaining."
- [ ] Distinguish standards chain-loading from persona activation in .cursorrules.
- [ ] Add the context verification command (see Stage 4) into .cursorrules.

**Checkpoint:** .cursorrules contains persona activation rules and the verification command.

### Stage 3: Create ADR-0003

**Objective:** Document the decision with rationale and consequences.

**Deliverables:**

- [ ] Create .github/adr/0003-persona-mode-activation-rules.md
- [ ] Status: Accepted
- [ ] Include problem, decision, consequences, and compliance references

**Checkpoint:** ADR-0003 exists and is accepted.

### Stage 4: Add Context Verification Command and Manual .cursorrules Fallback

**Objective:** Ensure agents can confirm loaded governance files and manually load .cursorrules when the workspace does not auto-load it.

**Deliverables:**

- [ ] Add a "Context Verification" command to .cursorrules that outputs the currently loaded governance files (PERSONA/PERSONA_SCRIBE, SPEC_PROTOCOL, STANDARDS_*).
- [ ] Document a manual fallback: if .cursorrules is not auto-loaded when opening the workspace, instruct the agent to explicitly load it (and then re-run context verification).
- [ ] Include guidance in SPEC_PROTOCOL.md §2.5 linking to the verification command for persona activation checks.

**Checkpoint:** Context verification command works; manual .cursorrules load procedure is documented.

---

## Consent Gate

**Type:** Governance improvement (non-breaking; clarifies existing system)

**User Impact:** None (users already use `/scribe` command; this formalizes rules)

**Approval Requested:** Does the plan to add explicit persona activation rules to SPEC_PROTOCOL.md and clarify PROJECT_CONTEXT.md meet your intent?

---

## Success Criteria

- [ ] Architect role can now correctly analyze scribe-plan files without Scribe constraints interfering
- [ ] Documentation clearly states when each persona applies
- [ ] No ambiguity about which persona is active during a given context
- [ ] If agent loads both personas simultaneously, the active one is clear from the work context

---

## References

- SPEC_PROTOCOL.md § 2.4 (Scribe-Plan Ingestion & Architect Analysis)
- PERSONA.md (The Pragmatic Architect)
- PERSONA_SCRIBE.md (The Scribe)
- PROJECT_CONTEXT.md § 2 (Dynamic Chain-Load Architecture)
- ADR-0002 (Scribe-Plan Ingestion governance)
