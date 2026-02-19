# PLAN: Project Context Governance Cleanup

**Date:** 2026-01-26
**Status:** Proposed
**Scope:** Documentation/governance refactor (non-breaking)
**Problem:** PROJECT_CONTEXT.md currently contains governance content (dynamic chain-load architecture, working-mode instructions, pre-flight constraints). This file is meant to be project-specific and portable; governance must live in canonical governance files, not project-local context files.

---

## Goals

- Remove governance/policy content from PROJECT_CONTEXT.md
- Relocate content to correct canonical files (.github/copilot-instructions.md and/or .github/instructions/orchestration.instructions.md)
- Add a governance rule in a canonical file (proposed: .github/instructions/general-coding.instructions.md) forbidding governance in PROJECT_CONTEXT.md
- Preserve portability: PROJECT_CONTEXT.md should only describe project purpose and portability notes (no rules)
- Record the decision in ADR-0004

---

## Observations (Governance Content Found)

- Dynamic Chain-Load Architecture: activation metadata, chain propagation, scaling rules (governance behavior) – should live in .github/copilot-instructions.md
- Working Modes `/gov`: pre-flight and constraints for governance work – should live in .github/copilot-instructions.md (commands/behavior) and/or .github/instructions/orchestration.instructions.md
- Coding/Governance references are fine as links but should avoid prescriptive rules inside PROJECT_CONTEXT.md

---

## Plan (Stages & Checkpoints)

### Stage 1: Relocate Chain-Load Guidance to .github/copilot-instructions.md

**Deliverables:**

- Move/merge "Dynamic Chain-Load Architecture" content from PROJECT_CONTEXT.md into .github/copilot-instructions.md (activation metadata, chaining, scaling rules)
- Ensure .github/copilot-instructions.md remains lint-clean

**Checkpoint:** .github/copilot-instructions.md contains the chain-load architecture guidance; PROJECT_CONTEXT.md no longer does.

### Stage 2: Move Working Modes to Canonical Governance

**Deliverables:**

- Move `/gov` working-mode guidance (pre-flight, constraints) from PROJECT_CONTEXT.md into .github/copilot-instructions.md (commands) and/or .github/instructions/orchestration.instructions.md (consent/flow)
- Ensure wording is aligned with existing governance files

**Checkpoint:** PROJECT_CONTEXT.md no longer contains working-mode governance; commands/rules live in canonical files.

### Stage 3: Lock Rule in .github/instructions/general-coding.instructions.md

**Deliverables:**

- Add a rule to .github/instructions/general-coding.instructions.md clarifying file boundaries: PROJECT_CONTEXT.md is project-specific context only; do not place governance/rules there. Canonical governance belongs in .github/agents, .github/instructions, .github/skills/internal-governance, .github/copilot-instructions.md, ADRs.

**Checkpoint:** .github/instructions/general-coding.instructions.md includes the prohibition and points to canonical locations.

### Stage 4: Clean PROJECT_CONTEXT.md

**Deliverables:**

- Trim PROJECT_CONTEXT.md to purpose/portability overview and link list only (non-governance)
- Maintain references to canonical files as links (no rules)
- Ensure lint clean

**Checkpoint:** PROJECT_CONTEXT.md contains only project purpose/portability and pointers to governance files.

### Stage 5: ADR-0004

**Deliverables:**

- Create ADR-0004 documenting the relocation, the prohibition rule, and rationale (portability, separation of concerns)

**Checkpoint:** ADR-0004 accepted.

---

## Success Criteria

- PROJECT_CONTEXT.md is free of governance/policy instructions
- Chain-load and working-mode instructions reside in .github/copilot-instructions.md/.github/instructions/orchestration.instructions.md
- .github/instructions/general-coding.instructions.md codifies the "no governance in PROJECT_CONTEXT" rule
- ADR-0004 records the decision and rationale

---

## Approval Requested

Proceed with the above stages to enforce governance file boundaries and portability?
