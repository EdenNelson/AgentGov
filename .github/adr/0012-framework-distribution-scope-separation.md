# ADR-0012: Framework Distribution & Scope Separation

## Status

Accepted

## Date

2026-01-27

## Context

AgentGov serves a dual purpose: it is both a behavioral framework for AI agents AND a meta-governance process for managing AgentGov itself. The distinction was unclear, leading to confusion about which files should be distributed to consumer projects.

**The tension:**

- Consumer projects need the behavioral framework (personas, standards, planning discipline) to ensure agents operate consistently across all projects.
- Consumer projects do NOT need AgentGov's internal meta-governance processes (approval gates, framework maintenance, change documentation templates).
- Without a clear declaration of intent, maintainers cannot reliably decide what to sync and what to keep private.

## Decision

We have declared AgentGov's dual purpose explicitly in PROJECT_CONTEXT.md:

1. **Behavioral Framework (Distributed):** Reusable patterns for AI agent behavior — personas, standards, planning protocols, ADR patterns — designed to scale across projects.

2. **Meta-Governance (Internal Only):** Processes for managing AgentGov itself — consent workflows, migration procedures, governance maintenance — not applicable to consumer projects.

**Files to distribute to consumer projects:**

- PERSONA.md, PERSONA_SCRIBE.md
- SPEC_PROTOCOL.md
- STANDARDS_CORE.md, STANDARDS_BASH.md, STANDARDS_POWERSHELL.md, STANDARDS_ORCHESTRATION.md
- ADR_TEMPLATE.md

**Files to keep in AgentGov only:**

- CONSENT_CHECKLIST.md
- MIGRATION_TEMPLATE.md
- GOVERNANCE_MAINTENANCE.md

**Principle:** The behavioral framework ensures agents operate consistently; the meta-governance ensures AgentGov evolves responsibly.

## Consequences

**Positive:**

- Clear decision rules for what syncs to consumer projects
- Reduced cognitive load — developers know which files apply to their project
- Consumer projects inherit consistent agent behavior standards
- AgentGov's internal processes remain focused and not conflated with framework

**Negative:**

- Requires documentation discipline to maintain the distinction as AgentGov evolves
- New files created in AgentGov must be explicitly classified as framework or meta-governance

**Risks:**

- Maintainers might inconsistently apply the principle without documented guidance
- New governance innovations in AgentGov might be mistakenly kept private when they should be distributed

## Compliance

- **Standards:** This decision aligns with STANDARDS_ORCHESTRATION.md (clarity in governance processes).
- **Governance:** This clarifies which governance files apply to which projects, addressing PROJECT_CONTEXT.md's portability principle.

## Implementation Notes

- PROJECT_CONTEXT.md updated with explicit "Framework Distribution & Scope" section.
- Future ADRs and governance changes must be tagged as either "Framework" or "Meta-Governance."
- Consumer project sync tools should reference this ADR as the authoritative source for file inclusion/exclusion.
