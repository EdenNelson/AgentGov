# PLAN: Persona Activation & Mode Switching Governance

**Date:** 2026-01-26
**Status:** Proposed
**Scope:** Governance improvement; non-breaking
**Issue:** Persona loading ambiguity when agent must switch from Scribe to Architect mode

---

## Problem Statement

When reviewing scribe-plan files, an agent loaded both .github/agents/architect.agent.md (The Pragmatic Architect) and .github/agents/scribe.agent.md (The Scribe) simultaneously. This created role ambiguity:

- Scribe persona has "Prime Directives": NO CODE, NO SOLUTIONING, LISTEN ONLY
- Architect persona has opposite mandate: ANALYZE, CLASSIFY, SOLVE

The agent could not correctly apply .github/instructions/spec-protocol.instructions.md §2.4 (Scribe-Plan Ingestion & Architect Analysis) because both persona constraints were active, creating contradictory behavioral expectations.

**Root Cause:** No explicit mechanism exists in the governance framework to:

1. Activate/deactivate personas based on context
2. Prevent simultaneous loading of mutually exclusive personas
3. Signal when role-switching is required

---

## Analysis & Assessment

### Context

- .github/agents/architect.agent.md defines The Pragmatic Architect (primary analyst role)
- .github/agents/scribe.agent.md defines The Scribe (intake/listening role)
- .github/instructions/spec-protocol.instructions.md §2.4 requires Architect to reclassify scribe-plan files
- .github/copilot-instructions.md describes dynamic chain-loading but lacks persona-specific rules

### Current State

- Both personas are portable, reusable documents
- No mutual exclusion mechanism
- No explicit activation conditions
- Workspace loading via .github/copilot-instructions.md loads both personas without distinction

### Risk Assessment

Severity: Medium (Operational)

- Agent cannot execute Architect role when reviewing scribe-plans (violates SPEC_PROTOCOL §2.4)
- Scribe constraints bleed into Architect context (e.g., agent refuses to propose solutions when analyzing problems)
- Leads to confusing agent behavior and incomplete analysis
- Does not break existing code but prevents governance workflow execution

### Alternatives Considered

#### Alternative 1: Remove .github/agents/scribe.agent.md

Scribe role becomes unavailable. Rejected: Scribe is needed for intake interviews.

#### Alternative 2: Keep both always loaded; rely on user signal

User must say "Switch to Architect mode." Rejected: Implicit, requires user discipline, error-prone.

#### Alternative 3: Merge personas into one

Single adaptive persona. Rejected: Violates separation of concerns; makes .github/agents/architect.agent.md bloated.

#### Alternative 4: Add explicit activation rules

Document in .github/instructions/spec-protocol.instructions.md when each persona applies. **Selected:** Minimal change, clear rules, preserves modularity.

---

## Decision

Add **Persona Activation & Mode Switching** guidelines to .github/instructions/spec-protocol.instructions.md (new §2.5) and .github/copilot-instructions.md. Establish that:

### Mutual Exclusivity

- Only one persona is active in a session
- Default: Architect (.github/agents/architect.agent.md)
- Scribe is triggered explicitly via `/scribe` or an explicit intake request
- Session stickiness: If `/scribe` is invoked, the session stays Scribe until explicitly exited; if not invoked, the session remains Architect

### Activation Conditions

- Architect mode (default): analyzing scribe-plans, reviewing plans, designing solutions, creating plan-*.md specs
- Scribe mode (explicit trigger): `/scribe`, "Switch to Scribe mode", or "Let's do an intake interview"; only active during intake loop, then reverts to Architect after "That's it"

### Implementation Rule

- .github/instructions/spec-protocol.instructions.md will state: "When reviewing scribe-plan files per §2.4, activate Architect persona only. Scribe Prime Directives do not apply."
- .github/copilot-instructions.md will clarify that dynamic chain-loading applies to path-specific instructions (.github/instructions/*.instructions.md), not persona files, and define explicit persona activation.
- Add a context verification command to .github/copilot-instructions.md to report currently loaded governance files (.github/agents/*.agent.md, .github/instructions/*.instructions.md), plus a manual fallback to load .github/copilot-instructions.md if the workspace skips it.

---

## Plan (Stages & Checkpoints)

### Stage 1: Clarify Persona Activation in .github/instructions/spec-protocol.instructions.md

**Objective:** Add explicit persona activation rules to the Scribe-Plan section.

**Deliverables:**

- [ ] Add §2.5 "Persona Activation & Mode Switching" to .github/instructions/spec-protocol.instructions.md
- [ ] Document Architect vs. Scribe mutual exclusion
- [ ] Link to .github/agents/architect.agent.md and .github/agents/scribe.agent.md with explicit conditions
- [ ] Include example: "When reviewing scribe-plans, activate Architect, NOT Scribe"

**Checkpoint:** Section 2.5 exists, is clear, and specifies the rule.

### Stage 2: Update .github/copilot-instructions.md (Context & Activation)

**Objective:** Clarify that dynamic chain-loading applies to instruction files, NOT persona files, and document persona activation in .github/copilot-instructions.md.

**Deliverables:**

- [ ] Update .github/copilot-instructions.md to state: "Persona files (.github/agents/architect.agent.md, .github/agents/scribe.agent.md) are mutually exclusive and controlled via explicit user commands (default Architect, `/scribe` for Scribe), NOT dynamic chaining."
- [ ] Distinguish instruction chain-loading from persona activation in .github/copilot-instructions.md.
- [ ] Add the context verification command (see Stage 4) into .github/copilot-instructions.md.

**Checkpoint:** .github/copilot-instructions.md contains persona activation rules and the verification command.

### Stage 3: Create ADR-0003

**Objective:** Document the decision with rationale and consequences.

**Deliverables:**

- [ ] Create .github/adr/0003-persona-mode-activation-rules.md
- [ ] Status: Accepted
- [ ] Include problem, decision, consequences, and compliance references

**Checkpoint:** ADR-0003 exists and is accepted.

### Stage 4: Add Context Verification Command and Manual .github/copilot-instructions.md Fallback

**Objective:** Ensure agents can confirm loaded governance files and manually load .github/copilot-instructions.md when the workspace does not auto-load it.

**Deliverables:**

- [ ] Add a "Context Verification" command to .github/copilot-instructions.md that outputs the currently loaded governance files (.github/agents/*.agent.md, .github/instructions/*.instructions.md).
- [ ] Document a manual fallback: if .github/copilot-instructions.md is not auto-loaded when opening the workspace, instruct the agent to explicitly load it (and then re-run context verification).
- [ ] Include guidance in .github/instructions/spec-protocol.instructions.md §2.5 linking to the verification command for persona activation checks.

**Checkpoint:** Context verification command works; manual .github/copilot-instructions.md load procedure is documented.

---

## Consent Gate

**Type:** Governance improvement (non-breaking; clarifies existing system)

**User Impact:** None (users already use `/scribe` command; this formalizes rules)

**Approval Requested:** Does the plan to add explicit persona activation rules to .github/instructions/spec-protocol.instructions.md and clarify PROJECT_CONTEXT.md meet your intent?

---

## Success Criteria

- [ ] Architect role can now correctly analyze scribe-plan files without Scribe constraints interfering
- [ ] Documentation clearly states when each persona applies
- [ ] No ambiguity about which persona is active during a given context
- [ ] If agent loads both personas simultaneously, the active one is clear from the work context

---

## References

- .github/instructions/spec-protocol.instructions.md § 2.4 (Scribe-Plan Ingestion & Architect Analysis)
- .github/agents/architect.agent.md (The Pragmatic Architect)
- .github/agents/scribe.agent.md (The Scribe)
- PROJECT_CONTEXT.md § 2 (Dynamic Chain-Load Architecture)
- ADR-0002 (Scribe-Plan Ingestion governance)
