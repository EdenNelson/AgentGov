# ADR-0010: Formalize Session Isolation Principle & Create Worker Invocation Command

## Status

Proposed

## Date

2026-01-27

## Context

### Problem 1: Missing Session Isolation Principle Documentation

The governance maintenance workflow (GOVERNANCE_MAINTENANCE.md) describes four sequential sessions (1-4) but **does not explicitly state the core principle that governs workflow execution**:

**Each chat session performs ONE phase of work on ONE ADR, then stops.**

This principle is implied by the four-session design but not articulated as a formal rule. Current documentation gaps:

- **GOVERNANCE_MAINTENANCE.md:** Describes 4 sessions/phases but doesn't explicitly state "one ADR, one phase per session"
- **ADR_TEMPLATE.md:** Has phase markers but doesn't specify the session isolation rule
- **ADR README.md:** Lists the four-phase workflow but lacks the enforcement principle

**Consequence:** Without explicit documentation, there is risk of:

- Attempting multiple phases in a single session (scope creep)
- Working on multiple ADRs simultaneously (context degradation)
- Continuing past phase boundaries (losing clean handoff artifacts)

The session isolation principle is what makes the workflow manageable and prevents the "overwhelming batch" problem that originally motivated the ADR governance approach.

### Problem 2: No Operational Invocation Mechanism for Worker Sessions

Currently, there is no documented way to **invoke a worker for Session 2, 3, or 4** of the governance workflow. 

**Current State:**

- Session 1 (suspect identification) can be triggered with: "Please start governance maintenance mode..."
- Sessions 2-4 lack a documented invocation mechanism
- Manual handoff artifacts (ADR file numbers) are passed between sessions but no standardized command exists

**Need:** A `/command` or agent instruction that allows a user to invoke a worker for any session (2-4) of the governance workflow, passing the ADR identifier as a parameter.

**Example Intent:**

```bash
/governance-session 2 ADR-0005
```

This would invoke a worker to:

1. Load ADR-0005
2. Confirm it has Phase 1 outputs (suspect rule + rationale)
3. Begin Phase 2 (Test Planning)
4. Exit at phase boundary

---

## Decision

### Decision 1: Formalize Session Isolation Principle

Add an explicit rule to the governance workflow documentation:

> **Session Isolation Principle:** One Session = One Phase = One ADR
>
> - Each chat session performs exactly ONE phase of work on exactly ONE ADR.
> - After completing the assigned phase, the session ends. Handoff artifacts (ADR with updated section) are prepared for the next session.
> - This principle prevents scope creep, maintains clean context boundaries, enables clear phase review, and allows sequential validation.

**Rationale:**

- Prevents "overwhelming batch" problems by enforcing clear boundaries
- Ensures each phase output is complete and reviewable before proceeding
- Maintains traceability: each ADR section shows which session produced it (date + phase marker)
- Allows for review, feedback, or rework between phases without losing progress

**Location:**

- Add to GOVERNANCE_MAINTENANCE.md (Section 0, before session table)
- Reference in ADR README.md (Governance ADRs section)
- Reference in ADR_TEMPLATE.md (Phase markers section)

---

### Decision 2: Define Worker Invocation Command

Create a standardized command to invoke Session 2-4 workers:

#### Command Format

```bash
/governance-session <PHASE> <ADR-NUMBER>
```

**Parameters:**

- `<PHASE>`: Phase number (2, 3, or 4)
- `<ADR-NUMBER>`: ADR identifier (e.g., ADR-0005)

**Examples:**

```bash
/governance-session 2 ADR-0005
/governance-session 3 ADR-0005
/governance-session 4 ADR-0005
```

#### Worker Behavior

The invoked worker will:

1. **Load & Validate ADR**
   - Fetch the specified ADR from `.github/adr/`
   - Confirm it exists and status is `Proposed` or `Testing`
   - Confirm the prerequisite phase has outputs (e.g., Phase 2 requires "Target Rule" section)

2. **Initialize Phase Context**
   - Load the ADR content into context
   - Load any governance files referenced in the ADR
   - Confirm the phase target rule (or test plan, or results)

3. **Execute Phase Work**
   - **Phase 2 (Test Planning):** Design probe test; update ADR with "Test Plan" section
   - **Phase 3 (Execution):** Run probe; record baseline and post-change results; update ADR with "Execution Notes"
   - **Phase 4 (Validation):** Validate results; make final decision; update ADR status to `Accepted` or `Rejected`

4. **Enforce Session Boundary**
   - Upon phase completion, confirm output is in ADR
   - Do NOT continue to next phase
   - Provide summary: "Phase X complete. ADR-NNNN ready for Phase Y+1."
   - Exit session

#### Documentation Location

- Create `.github/prompts/GOVERNANCE_SESSION_INVOCATION.md` with:
  - Command syntax
  - Worker responsibilities per phase
  - Session boundary enforcement rules
  - Handoff artifact specification
- Reference from ADR README.md
- Reference from GOVERNANCE_MAINTENANCE.md (Section 0)

#### Automation Note

> **Interim Solution:** This command-based invocation is a manual/assisted approach until full automation is available. Future work may integrate with GitHub Actions or CI/CD to auto-invoke workers at phase boundaries or on-demand via PR comments. For now, the command provides explicit control and clear handoff points.

---

## Consequences

### Positive

1. **Clear Principle:** Session isolation is now a documented, enforceable rule (not implicit)
2. **Operational Clarity:** Users know exactly when a session should end and what to pass to the next session
3. **Predictable Workflow:** Each phase output is atomic and reviewable; no risk of scope creep into multiple phases
4. **Parallel Independence:** Multiple ADRs can progress independently; Session 2 of ADR-0005 can run while Session 4 of ADR-0004 is in progress
5. **Traceability:** Each ADR section is date-stamped with phase ownership; audit trail is clear
6. **Worker Accountability:** Workers have explicit phase boundaries; success = "phase complete and persisted in ADR"

### Negative / Trade-offs

1. **Manual Handoff:** Each phase transition requires explicit invocation (not automatic)
   - *Mitigated by:* Clear command syntax; minimal overhead; allows for review between phases
2. **Session Fragmentation:** Work is split across 4 separate sessions instead of one long session
   - *Mitigated by:* Cleaner context, fewer parallel concerns, better review hygiene
3. **Documentation Update Required:** Multiple files need updates (GOVERNANCE_MAINTENANCE.md, ADR templates, new command doc)
   - *Mitigated by:* One-time cost; significant clarity gain

### Risks

1. **Worker Misunderstanding of Session Boundary:** If the "exit at phase boundary" rule is unclear, a worker may continue past the assigned phase
   - *Mitigation:* Explicit instruction in command documentation; phase checklist in invocation prompt
2. **Missing ADR During Handoff:** If user loses track of ADR number between sessions
   - *Mitigation:* Session 1 output includes ADR number prominently; worker confirms ADR fetch before starting Phase 2

---

## Compliance

- **Standards:** Aligns with STANDARDS_CORE principle of "clear, enforced boundaries"
- **Governance:** Formalizes the governance maintenance workflow (GOVERNANCE_MAINTENANCE.md); clarifies the multi-session ADR process (ADR README.md)
- **Artifact Type:** This decision produces documentation artifacts (new governance command doc) and process rules (session isolation principle)

---

## Implementation Checklist

### Phase 2 (Test Planning)

**Target:** Design probe tests that validate the session isolation principle and command invocation behavior.

- [ ] Probe 1: Verify session boundary enforcement (worker stops at phase end, doesn't continue)
- [ ] Probe 2: Verify ADR validation (worker confirms prerequisite outputs before starting phase)
- [ ] Probe 3: Verify handoff artifact (worker updates correct ADR section and persists change)

---

## See Also

- [GOVERNANCE_MAINTENANCE.md](../../GOVERNANCE_MAINTENANCE.md) — Governance workflow context
- [ADR README.md](README.md) — ADR structure and multi-session process
- [ADR_TEMPLATE.md](../../ADR_TEMPLATE.md) — ADR phase markers
- [SPEC_PROTOCOL.md](../../SPEC_PROTOCOL.md) — Artifact types and workflow definitions
