# PLAN: Add User Identity Attribution Requirement to Governance

**Date:** February 18, 2026  
**Status:** Approved  
**Approved by:** Eden Nelson on February 18, 2026  
**Scope:** Governance enhancement (non-breaking)  
**Impact:** Internal governance consistency, audit clarity

---

## Problem Statement

Governance artifacts (plans, ADRs, consent checklists) define approval gates but do not enforce **consistent identity attribution**. This creates audit trail ambiguity:

- Plans may be signed off with "Nelson," "Eden," or undefined
- ADRs list "Deciders: ?" without clear canonical identity
- Consumer projects inherit decisions without knowing exactly who approved them
- Git blame shows inconsistent usernames across governance files

**Root Cause:** No governance rule defines the canonical identity format for approvals. Agents have the information (GitHub owner: EdenNelson, workspace user: nelson) but no rule requiring consistent use in formal artifacts.

---

## Analysis & Assessment

### Current State
- **Consent Checklist** (internal-governance/SKILL.md) has placeholder: `Sign-off recorded in plan: Approved by USERNAME on DATE`
- **Orchestration.instructions.md §1.2** uses generic "user" language
- **ADR-0018 (PowerShell CRLF)** shows format: `Deciders: Eden Nelson` (good example)
- **Templates.instructions.md (ADR)** has no example for Deciders field
- **spec-protocol.instructions.md** mentions "approved by" but doesn't specify format

### Impact Assessment
- **Scope:** Non-breaking internal change; only affects future approvals and ADR creation
- **Affected Surfaces:** 
  - `.github/prompts/plan-*.md` approval signatures
  - `.github/adr/*.md` Deciders field
  - `.github/copilot-instructions.md` and related instructions
  - Internal-governance/SKILL.md examples
  - templates.instructions.md ADR template
- **User-Facing:** No; this is internal governance housekeeping
- **Risks:** Minimal; clarifies existing intent without changing behavior

### Alternatives Considered
1. **Do nothing:** Accept audit trail ambiguity (rejected; violates SPEC_PROTOCOL audit principle)
2. **Codify multiple accepted formats:** Too flexible; defeats audit clarity purpose (rejected)
3. **Use GitHub username only (EdenNelson):** Mixes GitHub identity with human name; less readable in formal approvals (rejected)
4. **Use full canonical name (Eden Nelson) [CHOSEN]:**
   - Matches GitHub owner (EdenNelson = Eden Nelson)
   - Human-readable in audit trails
   - Consistent with ADR-0018 precedent
   - Clear and unambiguous

---

## Plan: Four Stages

### STAGE 1: Create ADR-0019

**Objective:** Document the decision to require canonical identity attribution

**Deliverables:**
- [ ] ADR-0019 created at `.github/adr/0019-user-identity-attribution-governance.md`
- [ ] Status: `Accepted` (approved with this plan)
- [ ] Includes: Context (identity audit gap), Decision (require "Eden Nelson" format), Consequences (audit clarity, consistency)
- [ ] Compliance section links to SPEC_PROTOCOL §1.2 (explicit state reification)
- [ ] Implementation notes list all files to be updated

**Checkpoint:** ADR-0019 reviewed and ready for commit

---

### STAGE 2: Update Governance Files

**Objective:** Codify identity attribution requirement in operational governance

**Deliverables:**
- [ ] `.github/copilot-instructions.md` — Add new section after Rule #0 with identity attribution rule
- [ ] `orchestration.instructions.md §1.2 (Approval Flow)` — Replace generic "USER" with concrete example: `Approved by Eden Nelson on YYYY-MM-DD`
- [ ] `internal-governance/SKILL.md (Consent Checklist)` — Update placeholder with example: `Approved by: Eden Nelson`
- [ ] `templates.instructions.md (ADR Template)` — Add example to Deciders field: `Deciders: Eden Nelson`
- [ ] `spec-protocol.instructions.md §2.3 (Approval)` — Add canonical identity requirement to approval section

**Checkpoint:** All governance files updated; cross-references verified

---

### STAGE 3: Validate Changes

**Objective:** Verify all governance artifacts are internally consistent

**Deliverables:**
- [ ] Run `validate-skills.sh` to ensure skill mirrors stay synchronized
- [ ] Review `.github/copilot-instructions.md` for completeness
- [ ] Verify all identity attribution examples use "Eden Nelson" consistently
- [ ] No contradictions between files

**Checkpoint:** All validation passes; no linting errors

---

### STAGE 4: Commit & Record

**Objective:** Lock in changes with clear audit trail

**Deliverables:**
- [ ] Commit message: `docs(adr): Add ADR-0019 User Identity Attribution Governance`
- [ ] Second commit: `docs(governance): Enforce canonical identity attribution in approvals`
- [ ] Both commits reference plan: `.github/prompts/plan-20260218-user-identity-attribution-governance.prompt.md`
- [ ] ADR-0019 marked as `Accepted` in final commit

**Checkpoint:** Changes are in git; audit trail is clear

---

## Consent Gate

**Breaking Change?** No

**Major Change?** No (internal governance consistency enhance)

**User Impact?** None (affects how future approvals are recorded, not user-facing behavior)

**Backward Compatibility?** Full (applies prospectively; existing approvals are grandfathered)

**Rollback?** If rejected, simply revert commits; no data loss or breaking changes

**Approval Requested:**

- [ ] Do you approve adding explicit identity attribution requirement to governance?
- [ ] Format: "Eden Nelson" for all approval signatures and ADR Deciders fields?
- [ ] Update all five governance files as outlined in STAGE 2?

---

## Persistence & Recovery

**Plan Location:** `.github/prompts/plan-20260218-user-identity-attribution-governance.prompt.md`

**Checkpoint Markers:**
- STAGE 1 Complete → ADR-0019 exists and is ready to commit
- STAGE 2 Complete → All governance files updated without errors
- STAGE 3 Complete → Validation passes
- STAGE 4 Complete → Commits are in git with clear references

If session crashes, resume from last completed checkpoint.

---

## References

- **SPEC_PROTOCOL.instructions.md** — §1.2 (Explicit State Reification), §2.3 (Approval), §3.3 (Plan Exemptions)
- **orchestration.instructions.md** — §1 (Consent Gate), §1.2 (Approval Flow)
- **ADR-0018** (PowerShell CRLF) — Shows correct Deciders format
- **Governance Review (2026-02-18)** — Identified identity attribution gap

---

**Ready for approval.** Please confirm: Proceed with this plan?
