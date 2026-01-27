# ADR-0011: Governance Immutability Rule — Prevent Accidental Consumer Project Edits

## Status

Accepted

## Date

2026-01-27

## Context

During recent work, accidental governance updates were made to a consumer project that consumes AgentGov's canonical governance files. These files (PERSONA.md, STANDARDS_*.md, SPEC_PROTOCOL.md, CONSENT_CHECKLIST.md, .cursorrules, etc.) are canonical and should **only** be modified in the AgentGov repository. Consumer projects should treat them as read-only imports.

The risk: Governance drift in consumer projects, loss of consistency, and unintended overrides of canonical rules.

## Decision

Implement **Rule #0 (Governance Immutability Rule)** — a critical guard rule that:

1. **Detects repository context** at the start of every session (checks `.git/config`, workspace files, or asks the user)
2. **Refuses ALL governance file modifications** unless the repository is "AgentGov"
3. **Provides a non-negotiable response** with clear explanation and reference to the canonical location
4. **Allows normal governance work in AgentGov** (subject to existing Spec Protocol and Consent rules)

### Implementation

#### .cursorrules

- Added as the first section (Rule #0)
- Placed before all other governance loading rules
- Includes detection logic, blocked examples, and allowed examples

#### PERSONA.md

- Added as first behavioral guideline
- Ensures the rule loads with the default persona
- Marked with 🛑 for visibility

### Enforcement

The rule is strict and non-negotiable:

- No "ask user for confirmation" fallback
- No bypassing with special commands
- Clear, immediate refusal with explanation

## Consequences

### Positive

- **Prevents accidental governance drift:** Consumer projects cannot be modified to contradict AgentGov canonical rules
- **Single source of truth:** All governance changes must happen in AgentGov and be re-imported
- **Safety:** Reduces risk of unintended rule conflicts across the distributed ecosystem
- **Transparency:** Consumer projects immediately understand why a governance change is refused

### Negative

- **Strictness:** Developers may perceive the rule as inflexible (intentional; safety over convenience)
- **Workflow adjustment:** Developers in consumer projects must now create PRs against AgentGov instead of making local changes

### Risks

- **Detection edge cases:** If repository context detection fails, the rule may not activate (mitigated by asking the user as fallback)
- **Rule versioning:** Consumer projects using older versions of .cursorrules won't have this protection until they update

## Compliance

- **Standards:** Complies with STANDARDS_CORE (governance, maintainability, safety)
- **Governance:** Aligns with SPEC_PROTOCOL (planning required for governance changes) and STANDARDS_ORCHESTRATION (consent gates)
- **Portability:** Maintains portability of governance artifacts to consumer projects

## Related ADRs

- ADR-0001: Establish Governance ADR Workflow
- ADR-0006: ADR Pre-Check Governance (automated numbering)
