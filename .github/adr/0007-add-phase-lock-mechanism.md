# ADR-0007: Add Phase Lock Mechanism to ADR Template

## Status

Accepted

## Date

2026-01-27

## Context

### Problem: No Gating Mechanism for Concurrent Phase Work

ADR-0006 established the **Session Isolation Principle**: Each chat session performs ONE phase of work on ONE ADR, then exits.

However, the current ADR template (`ADR_TEMPLATE.md`) lacks a **gating mechanism to prevent concurrent workers from attempting to work on the same phase simultaneously**.

**Current State:**

- ADR template has phase markers (Phase 1, 2, 3, 4)
- Template has Date fields in some sections
- Template has Status field (Proposed, Accepted, Rejected, etc.)
- **Missing:** Worker assignment, lock status, or ownership indicator per phase

**Risk:**

- Two workers could inadvertently start Phase 2 on the same ADR in parallel sessions
- No clear indication which worker "owns" a phase in progress
- Conflicting updates to ADR sections during concurrent work
- No audit trail of which worker/session modified which phase

**Example Problem Scenario:**

```bash
Session A: /governance-session 2 ADR-0005  ← Worker A starts Phase 2
Session B: /governance-session 2 ADR-0005  ← Worker B also starts Phase 2 (collision!)
           Both workers design probes, both commit changes, merge conflict ensues
```

---

## Decision

### Add Phase Lock Fields to ADR Template

Introduce three new fields to each phase section to track ownership and prevent concurrent work:

1. **Worker Assigned:** Name or identifier of the worker currently assigned to this phase
2. **Started:** Timestamp (ISO 8601 format) when the phase work began
3. **Lock Status:** Explicit lock indicator (`Available` | `In Progress` | `Complete`)

### Updated Template Structure

Each phase section will include a lock block at the start:

```markdown
### Test Plan (Phase 2)

**Phase Lock:**
- **Assigned To:** [Worker name/ID or "Unassigned"]
- **Started:** [YYYY-MM-DD HH:MM UTC or "Not started"]
- **Status:** [Available | In Progress | Complete]

**Target Rule:** [Which rule from Suspect List]
[rest of phase content...]
```

### Worker Lock Protocol

**Before Starting Phase Work:**

1. Fetch the ADR from `.github/adr/`
2. Check the phase's "Lock Status"
3. If Status = `Available` or `Complete`:
   - Update the lock fields:
     - `Assigned To:` [Your worker identifier]
     - `Started:` [Current UTC timestamp]
     - `Status:` `In Progress`
   - Commit immediately with message: `docs(adr): Lock Phase X for ADR-NNNN`
4. If Status = `In Progress`:
   - Check `Assigned To` and `Started` fields
   - **Abort with error:** "Phase 2 of ADR-0005 is locked by [Worker]. Cannot proceed. Waiting for phase to complete or lock to be released."
   - Do NOT attempt to work on this phase

**After Completing Phase Work:**

1. Update the lock status:
   - `Status:` `Complete`
2. Commit ADR with phase content updates
3. Provide handoff message: "Phase X complete. ADR-NNNN ready for Phase Y+1."

### Application to All Phases

The lock mechanism applies to all governance maintenance phases:

| Phase | Section | Lock Field | Prevents |
| --- | --- | --- | --- |
| 1 | Target Rule (Phase 1) | Phase 1 Lock | Concurrent rule identification |
| 2 | Test Plan (Phase 2) | Phase 2 Lock | Concurrent probe design |
| 3 | Execution Notes (Phase 3) | Phase 3 Lock | Concurrent test execution |
| 4 | Validation Results (Phase 4) | Phase 4 Lock | Concurrent validation |

---

## Consequences

### Positive

1. **Prevents Concurrent Collisions:** Only one worker can actively work on a phase at a time
2. **Clear Ownership:** Lock fields show which worker is actively working and when they started
3. **Audit Trail:** Timestamps and worker assignments provide traceability
4. **Git Merge Conflict Prevention:** By locking before starting, we prevent multiple workers from modifying the same section
5. **Worker Error Detection:** Worker can quickly check if a phase is already in progress before spending effort
6. **Graceful Queueing:** If a phase is locked, worker knows to wait rather than attempting to work

### Negative / Trade-offs

1. **Lock Release Risk:** If a worker dies mid-phase or abandons work, the lock remains `In Progress` indefinitely
   - *Mitigation:* Lock fields include `Started` timestamp; a human can override a stale lock after reviewing the timestamp
2. **Manual Override Complexity:** No automatic lock release mechanism
   - *Mitigation:* Simple override rule: if lock is `In Progress` for > 24 hours, human can manually reset to `Available`
3. **Template Verbosity:** Each phase section now has 3 additional fields
   - *Mitigation:* Lock block is minimal (3 lines); clarifies system behavior

### Risks

1. **Worker Ignores Lock:** Worker sees `In Progress` but attempts phase anyway
   - *Mitigation:* Enforce in worker instructions (GOVERNANCE_SESSION_INVOCATION.md); make lock check explicit in worker behavior
2. **Lock Data Corruption:** Manual edits result in invalid lock state (e.g., `Status: InProgress` instead of `In Progress`)
   - *Mitigation:* Template example is clear; linter can validate lock status values

---

## Compliance

- **Standards:** Aligns with STANDARDS_CORE principle of "explicit, enforceable boundaries"
- **Governance:** Enforces the Session Isolation Principle from ADR-0006
- **Artifact Type:** Modifies ADR_TEMPLATE.md; affects all future governance maintenance ADRs

---

## Implementation Checklist

### Phase 1: Template Update

- [ ] Update `ADR_TEMPLATE.md` with phase lock fields for all four phases
- [ ] Provide clear example of lock protocol in template comments
- [ ] Document lock override procedure (for stale locks)

### Phase 2: Worker Documentation Update

- [ ] Update `GOVERNANCE_SESSION_INVOCATION.md` to include lock check and update procedures
- [ ] Add explicit error message for locked phases
- [ ] Document stale lock override process

### Phase 3: Retrofit Existing ADRs

- [ ] Scan all ADRs in `.github/adr/` for governance maintenance records
- [ ] Add lock fields to existing governance ADRs (ADR-0005, etc.)
- [ ] For completed phases, set status to `Complete` and backfill timestamps if available from git history

---

## Implementation Status ✅ COMPLETED

**Date Completed:** 2026-01-27

**Changes Applied:**

1. **ADR_TEMPLATE.md:**
   - Added "Phase Lock" block to Phase 1 (Target Rule)
   - Added "Phase Lock" block to Phase 2 (Test Plan)
   - Added "Phase Lock" block to Phase 3 (Execution Notes)
   - Added "Phase Lock" block to Phase 4 (Validation Results)
   - Each block includes: Assigned To, Started, Status fields

2. **GOVERNANCE_SESSION_INVOCATION.md:**
   - Added "Phase Lock Protocol (All Phases)" section
   - Documents lock check before starting phase work
   - Documents error condition: `In Progress` status prevents concurrent work
   - Documents lock acquisition procedure
   - Documents lock release procedure

3. **Existing ADRs:**
   - ADR-0005, ADR-0006, ADR-0007: Decision ADRs (no phase sections; no retrofit needed)
   - Future governance maintenance ADRs will inherit lock fields from updated template

**Ready for Use:** The phase lock mechanism is now active. All new governance maintenance ADRs (created after this date) will include phase locks by default.

---

## See Also

- [ADR-0006: Formalize Session Isolation Principle & Create Worker Invocation Command](.github/adr/0006-session-isolation-governance-principle.md)
- [GOVERNANCE_SESSION_INVOCATION.md](.github/prompts/GOVERNANCE_SESSION_INVOCATION.md) — Updated with lock protocol
- [ADR_TEMPLATE.md](ADR_TEMPLATE.md) — Updated with phase lock fields
