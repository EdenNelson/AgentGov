# ADR-0013: Migrate .cursorrules to .github/copilot-instructions.md

## Status

Accepted

## Date

2026-01-28

## Context

A recent VS Code update broke auto-loading of `.cursorrules` files, preventing the governance framework from being automatically ingested by GitHub Copilot at session start. This is a critical failure: without governance auto-load, agents operate without persona, standards, or protocol context, leading to inconsistent behavior and governance violations.

VS Code now requires governance instructions to be placed in `.github/copilot-instructions.md` instead of `.cursorrules` for automatic context loading in GitHub Copilot sessions.

**Impact:** Without this migration:
- Agents start sessions without PERSONA.md, SPEC_PROTOCOL.md, or STANDARDS_* context
- No `/context`, `/scribe`, or `/gov` command awareness
- Rule #0 (Governance Immutability) does not load, allowing accidental governance edits in consumer projects
- Manual workarounds required for every session

**Urgency:** Emergency governance change required to restore auto-loading functionality.

## Decision

**Migrate all governance orchestration from `.cursorrules` to `.github/copilot-instructions.md`:**

1. **Delete `.cursorrules`** (file no longer exists; already moved by user)
2. **Use `.github/copilot-instructions.md` as canonical governance entrypoint** for VS Code/GitHub Copilot
3. **Update all references** across governance files, ADRs, and documentation:
   - PERSONA.md (Rule #0 governance file list)
   - PROJECT_CONTEXT.md (canonical file reference and link)
   - SPEC_PROTOCOL.md (context verification references)
   - STANDARDS_CORE.md (canonical governance list)
   - All ADRs referencing `.cursorrules` (ADR-0001, 0003, 0004, 0011)
   - .github/copilot-instructions.md itself (self-references)

4. **Preserve all governance content** from `.cursorrules` in `.github/copilot-instructions.md`:
   - Rule #0 (Governance Immutability)
   - Mode detection & context loading
   - Persona activation rules (Architect/Scribe)
   - Commands: `/context`, `/scribe`, `/gov`
   - Dynamic chain-load architecture
   - Default mode context ingestion
   - Embedded PERSONA.md content (Pragmatic Architect, Institutional Memory, Scribe intake loop)

## Consequences

### Positive

- **Restores auto-loading:** Governance context loads automatically in GitHub Copilot sessions without manual intervention
- **VS Code compliance:** Aligns with current VS Code/GitHub Copilot extension requirements
- **Zero governance loss:** All rules, commands, and context preserved in new location
- **Maintains portability:** .github/copilot-instructions.md is distributable to consumer projects like .cursorrules was
- **Consistent behavior:** Agents load persona, standards, and protocols at session start as designed

### Negative

- **File rename complexity:** All governance references required updates (26 references across 9 files)
- **Consumer project sync lag:** Consumer projects using `.cursorrules` won't get updates until they migrate
- **Path change:** Longer path (`.github/copilot-instructions.md` vs `.cursorrules`) in references and links

### Risks

- **Stale consumer projects:** Consumer projects still using `.cursorrules` will experience governance auto-load failure until they update
- **Documentation drift:** External references (e.g., README files, external docs) may still mention `.cursorrules`

## Compliance

- **Standards:** Complies with STANDARDS_CORE (governance maintainability, portability)
- **Governance:** Emergency change allowed under SPEC_PROTOCOL for critical infrastructure failures
- **Portability:** Maintains framework distribution model (PROJECT_CONTEXT.md) by keeping governance in a distributable file

## Files Updated

1. `.github/copilot-instructions.md` — Updated self-references (3 locations)
2. `PERSONA.md` — Updated Rule #0 governance file list
3. `PROJECT_CONTEXT.md` — Updated canonical file reference and link (2 locations)
4. `SPEC_PROTOCOL.md` — Updated context verification references (2 locations)
5. `STANDARDS_CORE.md` — Updated canonical governance list
6. `.github/adr/0001-establish-governance-adr-workflow.md` — Updated scan and constraint references (2 locations)
7. `.github/adr/0003-persona-mode-activation-rules.md` — Updated all references (6 locations)
8. `.github/adr/0004-project-context-governance-boundaries.md` — Updated all references (8 locations)
9. `.github/adr/0011-governance-immutability-rule-consumer-projects.md` — Updated all references (3 locations)

**Total:** 9 files updated, 26 references migrated

## Related ADRs

- ADR-0003: Persona Activation & Context Verification (defines `/context` command and manual fallback)
- ADR-0004: Project Context Governance Boundaries (defines governance file location strategy)
- ADR-0011: Governance Immutability Rule (defines Rule #0 protection for consumer projects)

## Approval

- **Status:** Accepted
- **Approved by:** Eden Nelson (Principal Architect)
- **Date:** 2026-01-28
- **Rationale:** Critical infrastructure migration required to restore governance auto-loading after VS Code update. Emergency change justified by complete loss of governance context loading functionality.
