# ADR-0015: Automatic Governance Hard Gate Detection

## Status

Accepted

## Date

2026-01-30

## Context

The hard gate in SPEC_PROTOCOL (§ 2.1–2.3) requires explicit planning before any governance modification. However, enforcement is currently **command-dependent** — agents must remember to run `/gov` or manually recognize they're modifying governance files and invoke the hard gate.

**Failure Mode:** On 2026-01-30, ADR-0014 (ASCII Hyphens for PowerShell) was created without a persisted plan, directly violating the hard gate principle. The agent treated it as a "simple clarification" and bypassed planning entirely.

**Framework Impact:** If AgentGov cannot enforce its own governance rules automatically, its credibility as a portable, self-improving framework is compromised. Consumer projects that inherit this framework would inherit the same weakness.

## Decision

**Implement automatic file-path detection in `.github/copilot-instructions.md` that triggers the hard gate whenever any governance file is modified, without exception or exemption.**

Governance files covered by automatic detection:

- PERSONA.md, PERSONA_SCRIBE.md
- STANDARDS_CORE.md, STANDARDS_BASH.md, STANDARDS_POWERSHELL.md, STANDARDS_ORCHESTRATION.md
- SPEC_PROTOCOL.md, CONSENT_CHECKLIST.md, GOVERNANCE_MAINTENANCE.md, MIGRATION_TEMPLATE.md, ADR_TEMPLATE.md
- .github/adr/*.md
- .github/copilot-instructions.md

**Mechanism:** Before any modification to these files, the agent must check for an existing persisted plan in `.github/prompts/plan-*.md`. If no plan exists, the modification is blocked and the agent is directed to create one (Thinking Phase). If a plan exists but lacks explicit approval, the agent waits. If the plan is approved, the agent proceeds (Coding Phase).

## Consequences

- **Positive:**

  - Framework becomes self-enforcing; hard gate is structural, not advisory
  - Portable to consumer projects — automatic protection inherited without configuration
  - Eliminates "forgot to run `/gov`" failure mode
  - All governance changes become queryable, auditable, and durable (persisted in `.github/prompts/`)
  - Aligns with SPEC_PROTOCOL § 1.2 principle: "Make the state of architectural decisions explicit, durable, and queryable"
  - Demonstrates governance compliance in practice, strengthening framework credibility

- **Negative:**

  - No exceptions for "simple" governance fixes (e.g., typos in standards); all changes require a plan (even trivial ones)
  - Slower workflow for minor corrections (must create a plan, wait for approval, then implement)
  - May feel restrictive for ad-hoc documentation improvements

- **Risks:**

  - Over-enforcement: Trivial typo corrections now require a plan, adding bureaucratic overhead
  - Mitigated by: SPEC_PROTOCOL § 3.3 acknowledges exemptions exist; this ADR moves governance files OUT of exemptions, which is correct but requires discipline

## Compliance

- **Standards:** Aligns with STANDARDS_CORE.md (correctness, rigor, auditability)
- **Governance:** Strengthens SPEC_PROTOCOL § 1.2 (Explicit State Reification) and § 2.1–2.3 (Hard Gate)
- **Enforcement:** Implemented as conditional check in `.github/copilot-instructions.md` Base Instructions, triggering automatically on file modification
- **Portability:** Consumer projects inherit the mechanism without additional configuration

## Related Standards

- SPEC_PROTOCOL.md § 1.2 (Explicit State Reification)
- SPEC_PROTOCOL.md § 2.1–2.3 (Hard Gate Diagram & Workflow)
- PROJECT_CONTEXT.md (Governance framework distribution principle)

## Prior Analysis

- Session session on 2026-01-30 identified that ADR-0014 (PowerShell ASCII Hyphens) was created without a persisted plan
- Root cause analysis showed enforcement is command-dependent, not structural
- Review of SPEC_PROTOCOL revealed automatic detection as the correct solution to align implementation with intent
