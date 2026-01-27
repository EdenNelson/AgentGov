# ADR-0002: Scribe-Plan Ingestion & Architect Analysis Governance

## Status

Accepted

## Date

2026-01-26

## Context

The AgentGov system involves two complementary roles:

1. **Scribe:** Captures user intent and perceived problems from interviews/sessions
2. **Architect:** Analyzes the actual codebase and determines root causes

Previously, there was no explicit protocol for how Scribe artifacts flow into Architect analysis. This created ambiguity about:

- Whether the Scribe's problem classification (count, grouping, scope) should dictate the actual implementation
- How to handle cases where the Scribe perceives N problems but the Architect discovers M different root causes
- Whether reframing/regrouping decisions should be documented or implicit
- How to maintain an audit trail linking final plans back to Scribe intake

**Tension:** Scribes are effective at capturing user voice but may misdiagnose root causes. Architects are effective at technical analysis but need clear requirements. We need a process that respects Scribe input while preserving Architect authority over problem classification.

## Decision

Integrate a formal **Scribe-Plan Ingestion & Architect Analysis** process into SPEC_PROTOCOL.md (§2.4). The process establishes:

1. **Clear authority boundaries:**
   - Scribe authority: Accurate intent capture
   - Architect authority: Problem classification and root cause determination

2. **Phase 1 (Intake & Classification):**
   - Architect reads all scribe-plan files
   - Architect analyzes codebase for actual root causes
   - Architect reclassifies: combine, split, or reframe as needed
   - Architect documents the mapping with rationale

3. **Phase 2 (Delivery):**
   - One standard plan file (plan-*.md) reflects Architect's classification
   - Plan includes mapping, root cause analysis, and sequencing
   - Plan is linked in SPEC_PROTOCOL workflow

4. **Documentation requirement:**
   - Every regrouping/split/reframe decision is documented
   - Audit trail is preserved: Scribe input → Architect classification → final plan

## Consequences

**Positive:**

- Clear separation of concerns: Scribes capture, Architects decide
- Audit trail preserves all decision steps
- Reduces scope creep from undisciplined problem bundling
- Enables technical judgment to override perceived problem structure
- Allows Architect to identify dependencies that Scribe may not see

**Negative:**

- Adds a structured step between Scribe intake and implementation
- Requires Architect to document mapping (slight overhead)
- May slow down rapid prototyping if not carefully sequenced
- Scribe must accept that their grouping may be revised

**Risks:**

- If mapping is incomplete, Scribe may feel unheard
- Requires discipline; easy to skip mapping documentation
- New process requires training and cultural adoption

## Compliance

- **Standards:** Aligns with STANDARDS_CORE (Correctness > Speed; Clarity in decision-making)
- **Governance:** Integrates cleanly into SPEC_PROTOCOL.md existing Scribe artifact workflow (§1.5)
- **Authority:** Reinforces Architect's technical judgment as final arbiter
- **Auditability:** Provides durable, queryable decision trail

## Implementation

- **Change:** Added §2.4 "Scribe-Plan Ingestion & Architect Analysis" to SPEC_PROTOCOL.md
- **Location:** [SPEC_PROTOCOL.md](../../SPEC_PROTOCOL.md#24-scribe-plan-ingestion--architect-analysis)
- **Change:** Added §2.4 "Scribe-Plan Ingestion & Architect Analysis" to SPEC_PROTOCOL.md
- **Location:** [SPEC_PROTOCOL.md](../../SPEC_PROTOCOL.md#24-scribe-plan-ingestion--architect-analysis)
- **References:**
  - SPEC_PROTOCOL.md § 1.5 (Scribe Artifacts definition)
  - STANDARDS_CORE.md § 1.1 (Core Values: Correctness > Speed)
  - ADR_TEMPLATE.md (existing governance structure)

## Alternatives Considered

### Alternative 1: No formal process

Architect reclassifies informally; mapping is implicit.
**Rejected:** No audit trail; decisions become tribal knowledge.

### Alternative 2: Scribe-determined grouping is binding

Architect must respect Scribe's problem count and grouping.
**Rejected:** Violates Architect authority; prevents technical optimization.

### Alternative 3: Architect can regroup silently without documentation

Faster execution; less overhead.
**Rejected:** Erases audit trail; Scribe has no visibility into decisions.

## Approval

- **Status:** Accepted
- **Approved by:** Eden Nelson (Principal Architect)
- **Date:** 2026-01-26
- **Rationale:** Governance process preserves both Scribe input integrity and Architect technical authority while maintaining auditability.
