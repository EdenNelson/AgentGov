# ADR-0003: Persona Activation & Context Verification

## Status

Accepted

## Date

2026-01-26

## Context

An agent reviewing scribe-plan files loaded both PERSONA.md (Architect) and PERSONA_SCRIBE.md (Scribe), causing role ambiguity. The agent lacked SPEC_PROTOCOL and standards in context (likely because .cursorrules was not loaded), leading to “braindead” behavior despite claiming Architect mode. Persona activation was implicit; no explicit mutual exclusion or context verification existed.

## Decision

1. Add SPEC_PROTOCOL §2.5 to define persona activation and mutual exclusivity:
   - Default: Architect; Scribe only when `/scribe` is invoked or intake explicitly requested.
   - Session stickiness: `/scribe` keeps the session Scribe until explicitly exited; otherwise it remains Architect.
   - When reviewing scribe-plan files (SPEC_PROTOCOL §2.4), use Architect only; Scribe Prime Directives do not apply.
   - Personas are not chain-loaded; activation is explicit.
2. Update .cursorrules:
   - Document explicit persona activation and mutual exclusivity.
   - Add a context verification command (`/context`) to report loaded governance files (PERSONA/PERSONA_SCRIBE, SPEC_PROTOCOL, STANDARDS_*).
   - Add manual fallback: if .cursorrules is not auto-loaded, explicitly load it, then rerun `/context`.

## Consequences

### Positive

- Eliminates role ambiguity; Architect analysis of scribe-plans is unblocked.
- Fast detection of missing governance context via `/context`.
- Manual recovery path when workspace skips .cursorrules.

### Negative

- Slight overhead to run `/context` when in doubt.
- Requires discipline to exit Scribe mode explicitly when done.

### Risks

- If users forget to exit `/scribe`, they stay in Scribe (no code/analysis).
- If `.cursorrules` is still skipped and not loaded manually, context remains incomplete; mitigated by the fallback instruction.

## Compliance

- SPEC_PROTOCOL.md updated with §2.5 (persona activation, Architect-only for scribe-plan review).
- .cursorrules updated with activation rules, `/context`, and manual fallback.
- Aligns with STANDARDS_CORE priorities (correctness, clarity) by ensuring correct persona and full governance context before action.

## Alternatives Considered

- Keep implicit activation and rely on user to say “Switch to Architect” — rejected (error-prone, no audit).
- Merge personas into one adaptive persona — rejected (loss of separation of concerns).
- Remove Scribe persona — rejected (intake role needed).

## Approval

- **Status:** Accepted
- **Approved by:** Eden Nelson (Principal Architect)
- **Date:** 2026-01-26
- **Rationale:** Ensures explicit persona activation, context verification, and recovery when .cursorrules is skipped.
