# ADR-0019: User Identity Attribution in Governance Artifacts

## Status

Accepted

## Date

2026-02-18

## Context

Governance artifacts (plans, ADRs, consent checklists) define approval gates and signature blocks but do not enforce **consistent identity attribution**. This creates audit trail ambiguity:

- Plans may be signed off with "Nelson," "Eden," or undefined
- ADRs list "Deciders: ?" without clear canonical identity
- Consumer projects inherit decisions without knowing exactly who approved them
- Different governance files use inconsistent formats for user identity

**Framework Impact:** SPEC_PROTOCOL §1.2 (Explicit State Reification) requires decisions to be "explicit, durable, and queryable." An approval signature that lacks clear identity violates this principle — the audit trail cannot definitively answer "Who decided this?"

**Evidence:** Review of governance files on 2026-02-18 revealed:
- `.github/copilot-instructions.md` (Rule #0) uses generic "USER" placeholders
- `orchestration.instructions.md` (§1.2) lacks concrete identity example
- `internal-governance/SKILL.md` shows `Approved by USERNAME on DATE` (template, not enforced)
- `templates.instructions.md` (ADR template) has no Deciders example
- However, ADR-0018 demonstrates correct format: `Deciders: Eden Nelson`

---

## Decision

**Enforce canonical user identity attribution across all governance artifacts.**

All approval signatures and decision records must use: **Eden Nelson**

### Canonical Identity Format

| Artifact Type | Format | Example |
|---|---|---|
| Plan approval signature | `Approved by Eden Nelson on YYYY-MM-DD` | `Approved by Eden Nelson on 2026-02-18` |
| ADR Deciders field | `Deciders: Eden Nelson` | (see ADR header) |
| Consent Checklist sign-off | `Approved by: Eden Nelson` | (in internal governance workflow) |
| Governance rule approval | `Approved by Eden Nelson on YYYY-MM-DD` | (in copilot-instructions.md or related) |

### Why This Identity

- **GitHub Owner:** Repository is owned by `EdenNelson` (GitHub username)
- **Workspace User:** Local user is `nelson` (macOS)
- **Canonical Form:** `Eden Nelson` (human-readable, full name, legal form)
- **Precedent:** ADR-0018 already uses this format for Deciders field

---

## Consequences

### Positive

- **Audit Trail Clarity:** Consumer projects and future maintainers know exactly who approved each decision
- **Queryable History:** `git log --grep="approved by Eden Nelson"` can now find all approval decisions
- **Consistency:** Identity format is uniform across all governance files; no ambiguity
- **Spec Protocol Compliance:** Satisfies SPEC_PROTOCOL §1.2 (explicit state reification)
- **Portability:** Consumer projects inherit clear decision authority from AgentGov

### Negative

- Requires updating multiple governance files
- Future approvals must use canonical form (adds minor discipline requirement)

### Risks

- **None identified.** This is a clarification, not a behavioral change.

---

## Implementation

### Files Modified

1. `.github/copilot-instructions.md` — Add identity attribution rule after Rule #0
2. `orchestration.instructions.md` — Concrete example in §1.2 (Approval Flow)
3. `internal-governance/SKILL.md` — Update Consent Checklist with canonical format
4. `templates.instructions.md` — Add Deciders example to ADR template
5. `spec-protocol.instructions.md` — Add canonical identity requirement to §2.3 (Approval)

### Changes Summary

**New Rule (.github/copilot-instructions.md):**
```markdown
## User Identity Attribution (Required in Governance Artifacts)

All approval signatures must use the canonical form: **Eden Nelson**

Scope:
- Plan approval signatures: `Approved by Eden Nelson on YYYY-MM-DD`
- ADR Deciders field: `Deciders: Eden Nelson`
- Consent Checklist sign-offs: `Approved by: Eden Nelson`

Why: Audit trail clarity and Spec Protocol compliance (explicit state reification).
```

**Orchestration.instructions.md §1.2 (Existing text updated):**
- Replace: `User confirms: "Yes, proceed with this plan"`
- With example: `Approved by Eden Nelson on 2026-02-18`

**Internal-governance/SKILL.md (Consent Checklist):**
- Replace: `Sign-off recorded in plan: Approved by USERNAME on DATE`
- With: `Sign-off recorded in plan: Approved by Eden Nelson on DATE`

**Templates.instructions.md (ADR Template):**
- Add example to Deciders field: `Deciders: Eden Nelson`

**Spec-protocol.instructions.md §2.3:**
- Add canonical identity requirement to approval section

---

## Compliance

- **Standards:** [COMPLETE] Aligns with SPEC_PROTOCOL §1.2 (explicit state reification)
- **Governance:** [COMPLETE] Improves audit trail clarity (internal governance consistency)
- **User Impact:** [COMPLETE] None (applies prospectively; existing approvals grandfathered)
- **Portability:** [COMPLETE] Consumer projects inherit clear decision authority

---

## Related

- **Plan:** `.github/prompts/plan-20260218-user-identity-attribution-governance.prompt.md` (approved by Eden Nelson on 2026-02-18)
- **SPEC_PROTOCOL.instructions.md:** §1.2 (Explicit State Reification), §2.3 (Approval)
- **ADR-0018:** PowerShell CRLF (demonstrates correct Deciders format)
- **Governance Review (2026-02-18):** Identified identity attribution gap

