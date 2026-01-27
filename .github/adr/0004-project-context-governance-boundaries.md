# ADR-0004: Project Context Governance Boundaries

## Status

Accepted

## Date

2026-01-26

## Context

PROJECT_CONTEXT.md contained governance content (dynamic chain-load architecture, working-mode `/gov` guidance). Because PROJECT_CONTEXT is project-specific and non-portable, embedding governance there risks divergence and loss of canonical rules when the file differs per project. Governance must live in canonical files (.cursorrules, STANDARDS_*, SPEC_PROTOCOL, CONSENT_CHECKLIST, ADRs).

## Decision

1. Move dynamic chain-load architecture guidance into .cursorrules (concise, minimal, still the trigger surface).
2. Move `/gov` working-mode guidance into .cursorrules (commands) and rely on existing governance files for consent/flow.
3. Add a rule to STANDARDS_CORE.md: PROJECT_CONTEXT.md must not contain governance rules; it may only provide project-specific context and links to canonical governance files.
4. Trim PROJECT_CONTEXT.md to purpose/portability plus references to canonical governance files.

## Consequences

### Positive

- Governance lives in canonical, portable files; PROJECT_CONTEXT stays project-specific and light.
- .cursorrules remains the minimal, powerful trigger surface for chain-load and commands.
- Clear boundary reduces risk of conflicting local governance.

### Negative

- Slightly more reliance on .cursorrules for chain-load description and `/gov` command.

### Risks

- If .cursorrules is not loaded, chain-load guidance is missed; mitigated by existing manual load guidance and `/context` check.

## Compliance

- .cursorrules updated with chain-load summary and `/gov` command.
- STANDARDS_CORE.md updated with file-boundary rule forbidding governance in PROJECT_CONTEXT.md.
- PROJECT_CONTEXT.md cleaned to references only.

## Alternatives Considered

- Leave governance in PROJECT_CONTEXT.md — rejected (non-portable, conflicts with canonical governance).
- Move chain-load guidance into SPEC_PROTOCOL instead — rejected; .cursorrules is the activation entrypoint and should remain minimal but include chain-load description.

## Approval

- **Status:** Accepted
- **Approved by:** Eden Nelson (Principal Architect)
- **Date:** 2026-01-26
- **Rationale:** Preserves portability and keeps governance in canonical, portable files while keeping .cursorrules minimal and authoritative for activation.
