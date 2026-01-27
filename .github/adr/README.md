# Architecture Decision Records (ADRs)

This directory contains all Architecture Decision Records for the AgentGov repository.

## Purpose

ADRs document important architectural and governance decisions made during the project, capturing:
- The problem and context
- Decision rationale
- Consequences and trade-offs
- Implementation status

## Structure

**Naming Convention:** `NNNN-<verb>-<area>.md`

**Status Values:**
- `Proposed` — Decision under consideration
- `Accepted` — Decision approved and implemented
- `Rejected` — Decision considered and declined
- `Deprecated` — Former decision no longer applies
- `WONTFIX` — Known issue with no planned action
- `Testing` — Governance decision in test/validation phase (intermediate status)

**Sequential Numbering:** ADRs are numbered starting at 0001; each new ADR increments the counter.

## Governance ADRs & Multi-Session Workflow

Governance maintenance decisions follow a four-session workflow where a single ADR is updated across phases:

| Phase | Session | ADR Status | Output |
| --- | --- | --- | --- |
| Suspect Identification | 1 | `Proposed` | ADR with suspected problematic rules list |
| Test Planning | 2 | `Proposed` | ADR with probe test design |
| Execution & Results | 3 | `Proposed` | ADR with baseline vs. post-change behavior |
| Validation & Integration | 4 | `Accepted` or `Rejected` | ADR finalized; governance rules updated (if accepted) |

See [GOVERNANCE_MAINTENANCE.md](../../GOVERNANCE_MAINTENANCE.md) for detailed workflow.

## Example ADR

See [ADR_TEMPLATE.md](../../ADR_TEMPLATE.md) for the standard template.

## Querying ADRs

To understand the rationale behind a decision:
```bash
grep -r "Context" .github/adr/*.md
git log --oneline .github/adr/
```

To view decisions in a specific area:
```bash
ls .github/adr/*governance* .github/adr/*standards*
```

## Adding a New ADR

1. Determine the next sequential number (e.g., if 0003 exists, use 0004)
2. Create file: `NNNN-<verb>-<area>.md` (e.g., `0004-adopt-logging-strategy.md`)
3. Fill in the template (see [ADR_TEMPLATE.md](../../ADR_TEMPLATE.md))
4. Set status to `Proposed`
5. Commit with message: `docs(adr): Add ADR-NNNN-<title>`
6. Update status to `Accepted` (or `Rejected`/`Deprecated`) once decision is finalized
7. Commit with message: `docs(adr): Accept ADR-NNNN`

## See Also

- [GOVERNANCE_MAINTENANCE.md](../../GOVERNANCE_MAINTENANCE.md) — Multi-session governance workflow
- [SPEC_PROTOCOL.md](../../SPEC_PROTOCOL.md) — Artifact types and workflow (including scribe definitions)
- [ADR_TEMPLATE.md](../../ADR_TEMPLATE.md) — Standard ADR template
